#include <linux/module.h>
#include <linux/sched.h>
#include <linux/pid.h>
#include <linux/kthread.h>
#include <linux/kernel.h>
#include <linux/err.h>
#include <linux/slab.h>
#include <linux/printk.h>
#include <linux/jiffies.h>
#include <linux/kmod.h>
#include <linux/fs.h>
#include <linux/kmod.h>
#include <linux/err.h>

MODULE_LICENSE("GPL");



struct wait_opts {
	enum pid_type		wo_type;
	int			wo_flags;
	struct pid		*wo_pid;

	struct waitid_info	*wo_info;
	int			wo_stat;
	struct rusage		*wo_rusage;

	wait_queue_entry_t		child_wait;
	int			notask_error;
};

extern long do_wait(struct wait_opts *wo);
extern int do_execve( struct filename *filename, const char __user *const __user *__argv, const char __user *const __user *__envp);
extern pid_t kernel_clone(struct kernel_clone_args *args);
extern struct filename * getname_kernel(const char * filename);

int CODE = 0;


int exec_test_program(void *argc){
	struct filename *filename;
	char path[] = "/tmp/test";
	// notice that in test, you need to put the test file in /tep/ folder
	char *argv[] = {path, NULL, NULL};
	char *envp[] = {"HOME=/", "PATH=/sbin:/user/sbin:/bin:/usr/bin", NULL};

	filename = getname_kernel(path);	
	// we need to convert the file path in the user space location to kernel space location
	printk(KERN_INFO "[Program2] Exec start!\n"); // If do_execve returns, there's an error.
	CODE = (call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC) & 0x0000007f);

	//CODE = do_execve(filename, NULL, NULL);
	
	printk("[Program2] do_execve signal: %d", CODE);

	do_exit(CODE);
	return CODE;
}

int wait_test(pid_t upid){
	struct wait_opts wo;
	enum pid_type type = PIDTYPE_PID;
	struct pid *pid = NULL;
	int state_temp;

	pid = find_get_pid(upid);
	if (!pid) {
		printk(KERN_ERR "Invalid PID: %d\n", upid);
		return -ESRCH;  // No such process
	}

	wo.wo_type   = type;
	wo.wo_pid    = pid;
	wo.wo_flags  = WEXITED;
	wo.wo_info   = NULL;
	wo.wo_stat   = state_temp;

	do_wait(&wo);
	state_temp = wo.wo_stat;
	
	put_pid(pid);
	

	return state_temp;
}


char* signal_to_string(int sig) {
    switch(sig) {
        case 1: return "SIGHUP";   // Hangup detected on controlling terminal or death of controlling process
        case 2: return "SIGINT";   // Interrupt from keyboard
        case 3: return "SIGQUIT";  // Quit from keyboard
        case 4: return "SIGILL";   // Illegal Instruction
        case 5: return "SIGTRAP";  // Trace/breakpoint trap
        case 6: return "SIGABRT";  // Abort signal from abort(3)
        case 7: return "SIGBUS";   // Bus error (bad memory access)
        case 8: return "SIGFPE";   // Floating-point exception
        case 9: return "SIGKILL";  // Kill signal
        case 10: return "SIGUSR1"; // User-defined signal 1
        case 11: return "SIGSEGV"; // Invalid memory reference
        case 12: return "SIGUSR2"; // User-defined signal 2
        case 13: return "SIGPIPE"; // Broken pipe: write to pipe with no readers
        case 14: return "SIGALRM"; // Timer signal from alarm(2)
        case 15: return "SIGTERM"; // Termination signal
        default: return "UNKNOWN";
    }
}

//implement fork function
int my_fork(void *argc){
	
	
	//set default sigaction for current process
	// int i;
	// struct k_sigaction *k_action = &current->sighand->action[0];
	pid_t pid;
    struct kernel_clone_args kargs = {
		.exit_signal = SIGCHLD,
		.stack = (unsigned long)&exec_test_program,
		.stack_size = 0,
		.tls = 0,
		.flags = SIGCHLD
    };

	/* fork a process using kernel_clone or kernel_thread */
	// need to pass a kernel_clone args 
	pid = kernel_clone(&kargs);
	
	if (pid < 0) {
	    printk(KERN_ERR "[Program2] Forking child failed: %d\n", pid);
	    return -1;
	}
	else if (pid > 0) {
		int wait_result=0;
		printk(KERN_INFO "[Program2] Parent PID: %d\n", current->pid);
		printk(KERN_INFO "[Program2] This is CHILD PID: %d\n", pid); 
	    printk(KERN_INFO "[Program2] Wait start!\n");
		wait_result = wait_test(pid);
	    printk(KERN_INFO "[Program2] Wait Exit! with excution code %s: %d\n",  signal_to_string(CODE), CODE);


	    if (wait_result < 0) {
	        printk(KERN_ERR "[Program2] Wait failed!\n");
	    } 
	}

	/* execute a test program in child process */
	return 0;
}

static int __init program2_init(void){

	struct task_struct *thread;
    printk(KERN_INFO "[program2] : Module_init\n");

    /* create a kernel thread to run my_fork */
    //thread = kthread_run(my_fork, NULL, "my_fork_thread");
    thread = kthread_run(&my_fork, NULL, "my_fork_thread");
    if (IS_ERR(thread)) {
        printk(KERN_ERR "[program2] : Failed to create kernel thread\n");
        return PTR_ERR(thread);
    }
	return 0;
}

static void __exit program2_exit(void){
	printk("[program2] : Module_exit\n");
}

module_init(program2_init);
module_exit(program2_exit);
