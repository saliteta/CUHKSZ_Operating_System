#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "stat.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "fs.h"
#include "sleeplock.h"
#include "fcntl.h"
#include "file.h"

struct spinlock tickslock;
uint ticks;

extern char trampoline[], uservec[], userret[];

// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void *find_trap_vma(uint64 question_address, struct proc* p){
  for (int i = 0; i < VMASIZE; i++) {
      if ((question_address>=p->vma[i].mapped_starting_address) && 
         (p->vma[i].mapped_starting_address+8*PGSIZE> question_address)) {
          return &p->vma[i]; //corresponding vma found
      }
  }
  return 0;
}



int memory_mapping(struct vma *trap_vma, struct proc *p) {
    struct file *f = trap_vma->mapped_file;
    acquire(&p->lock);
    char *mem = kalloc(); // Allocates one page of physical memory.
    if (mem == 0) {
        release(&p->lock);
        printf("we have out of memory!\n");
        return -1; // Out of memory.
    }
    memset(mem, 0, PGSIZE);
    // Read the content from file into the memory page with the given offset.
    if (f->ip == 0) {
        // The file is not open, handle accordingly
        kfree(mem);
        release(&p->lock);
        printf("File is not open.\n");
        return -3; // Indicate that the file is not open.
    }
    mapfile(f, mem, trap_vma->used_length+trap_vma->offset);
    if (mappages(p->pagetable, trap_vma->mapped_starting_address+trap_vma->used_length, PGSIZE, (uint64)mem, trap_vma->memory_flags) != 0) {
        kfree(mem);
        release(&p->lock);
        printf("we fail to map the page");
        return -3; // Failed to map page.
    }
    trap_vma->used_length += PGSIZE;
    release(&p->lock);
    return 0;
}

struct vma * vma_searching_trap(struct proc *p) {
    for (int i = 0; i < VMASIZE; i++) {
        if (p->vma[i].mapped_file == 0 && p->vma[i].mapped_length == 0) {
            return &p->vma[i]; // Empty VMA slot found.
        }
    }
    return 0; // No empty VMA slot found.
}

int memory_flag_generator_trap(int map_flags, int shared_flags){
  int page_flags = PTE_U|PTE_V;
  if (map_flags&0x1){
    page_flags = page_flags|PTE_R;
  }
  if (map_flags&0x2){
    page_flags = page_flags|PTE_W;
  }
  if (map_flags&0x4){
    page_flags = page_flags|PTE_X;
  }

  return page_flags;
}

int lazy_copy(struct vma *parents_vma, struct proc *child_p){
  acquire(&child_p->lock);
  struct vma *child_vma = vma_searching_trap(child_p);
  child_vma->mapped_file = parents_vma->mapped_file;
  child_vma->memory_flags = parents_vma->memory_flags;
  child_vma->mapped_flags = parents_vma->mapped_flags;
  child_vma->mapped_length = parents_vma->mapped_length;
  child_vma->mapped_starting_address = parents_vma->mapped_starting_address;
  child_vma->max_page_length = parents_vma->max_page_length;
  child_vma->offset = parents_vma->offset;
  child_vma->used_length = 0;
  filedup(child_vma->mapped_file);
  release(&child_p->lock);
  return memory_mapping(child_vma, child_p);
}

void
trapinit(void)
{
  initlock(&tickslock, "time");
}


// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
  w_stvec((uint64)kernelvec);
}

//
// handle an interrupt, exception, or system call from user space.
// called from trampoline.S
//
void
usertrap(void)
{
  int which_dev = 0;

  if((r_sstatus() & SSTATUS_SPP) != 0)
    panic("usertrap: not from user mode");

  // send interrupts and exceptions to kerneltrap(),
  // since we're now in the kernel.
  w_stvec((uint64)kernelvec);

  struct proc *p = myproc();
  
  // save user program counter.
  p->trapframe->epc = r_sepc();
  
  if(r_scause() == 8){
    // system call

    if(killed(p))
      exit(-1);

    // sepc points to the ecall instruction,
    // but we want to return to the next instruction.
    p->trapframe->epc += 4;

    // an interrupt will change sepc, scause, and sstatus,
    // so enable only now that we're done with those registers.
    intr_on();

    syscall();
  } else if((which_dev = devintr()) != 0){
    // ok
  }
  // TODO: page fault handling
  else if(r_scause() == 13 || r_scause() == 15) {
    uint64 va = r_stval(); // we extract the address that cause the problem
    struct proc *p = myproc();
    struct vma *trap_vma = find_trap_vma(va, p);
    if (trap_vma == 0){
      // we need to then find the parents process
      trap_vma = find_trap_vma(va, p->parent);
      lazy_copy(trap_vma, p);
    }
    else{
      if (memory_mapping(trap_vma, p)!=0){
        printf("handeling falied\n");
        exit(-1);
      };
    }
    if (trap_vma==0){
      printf("we don't have that page\n");
      goto err;
    }

    // map the correspoding pages to the next location

  }
  else {
  err:
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    setkilled(p);
  }

  if(killed(p))
    exit(-1);

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2)
    yield();

  usertrapret();
}

//
// return to user space
//
void
usertrapret(void)
{
  struct proc *p = myproc();

  // we're about to switch the destination of traps from
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
  p->trapframe->kernel_trap = (uint64)usertrap;
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()

  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
  x |= SSTATUS_SPIE; // enable interrupts in user mode
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
  ((void (*)(uint64))trampoline_userret)(satp);
}

// interrupts and exceptions from kernel code go here via kernelvec,
// on whatever the current kernel stack is.
void 
kerneltrap()
{
  int which_dev = 0;
  uint64 sepc = r_sepc();
  uint64 sstatus = r_sstatus();
  uint64 scause = r_scause();
  
  if((sstatus & SSTATUS_SPP) == 0)
    panic("kerneltrap: not from supervisor mode");
  if(intr_get() != 0)
    panic("kerneltrap: interrupts enabled");

  if((which_dev = devintr()) == 0){
    printf("scause %p\n", scause);
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    panic("kerneltrap");
  }

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    yield();

  // the yield() may have caused some traps to occur,
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void
clockintr()
{
  acquire(&tickslock);
  ticks++;
  wakeup(&ticks);
  release(&tickslock);
}

// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
     (scause & 0xff) == 9){
    // this is a supervisor external interrupt, via PLIC.

    // irq indicates which device interrupted.
    int irq = plic_claim();

    if(irq == UART0_IRQ){
      uartintr();
    } else if(irq == VIRTIO0_IRQ){
      virtio_disk_intr();
    } else if(irq){
      printf("unexpected interrupt irq=%d\n", irq);
    }

    // the PLIC allows each device to raise at most one
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    // software interrupt from a machine-mode timer interrupt,
    // forwarded by timervec in kernelvec.S.

    if(cpuid() == 0){
      clockintr();
    }
    
    // acknowledge the software interrupt by clearing
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
  }
}

