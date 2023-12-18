
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8a013103          	ld	sp,-1888(sp) # 800088a0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	796050ef          	jal	ra,800057ac <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	d3078793          	addi	a5,a5,-720 # 80021d60 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	8a090913          	addi	s2,s2,-1888 # 800088f0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	152080e7          	jalr	338(ra) # 800061ac <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1f2080e7          	jalr	498(ra) # 80006260 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	bd8080e7          	jalr	-1064(ra) # 80005c62 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	80450513          	addi	a0,a0,-2044 # 800088f0 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	028080e7          	jalr	40(ra) # 8000611c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	c6050513          	addi	a0,a0,-928 # 80021d60 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00008497          	auipc	s1,0x8
    80000126:	7ce48493          	addi	s1,s1,1998 # 800088f0 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	080080e7          	jalr	128(ra) # 800061ac <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00008517          	auipc	a0,0x8
    8000013e:	7b650513          	addi	a0,a0,1974 # 800088f0 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	11c080e7          	jalr	284(ra) # 80006260 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00008517          	auipc	a0,0x8
    8000016a:	78a50513          	addi	a0,a0,1930 # 800088f0 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	0f2080e7          	jalr	242(ra) # 80006260 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	ae4080e7          	jalr	-1308(ra) # 80000e12 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00008717          	auipc	a4,0x8
    8000033a:	58a70713          	addi	a4,a4,1418 # 800088c0 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	ac8080e7          	jalr	-1336(ra) # 80000e12 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	950080e7          	jalr	-1712(ra) # 80005cac <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	76a080e7          	jalr	1898(ra) # 80001ad6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	d8c080e7          	jalr	-628(ra) # 80005100 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fb4080e7          	jalr	-76(ra) # 80001330 <scheduler>
    consoleinit();
    80000384:	00005097          	auipc	ra,0x5
    80000388:	7f0080e7          	jalr	2032(ra) # 80005b74 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	b06080e7          	jalr	-1274(ra) # 80005e92 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	910080e7          	jalr	-1776(ra) # 80005cac <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	900080e7          	jalr	-1792(ra) # 80005cac <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	8f0080e7          	jalr	-1808(ra) # 80005cac <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	326080e7          	jalr	806(ra) # 800006f2 <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	982080e7          	jalr	-1662(ra) # 80000d5e <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	6ca080e7          	jalr	1738(ra) # 80001aae <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	6ea080e7          	jalr	1770(ra) # 80001ad6 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	cf6080e7          	jalr	-778(ra) # 800050ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	d04080e7          	jalr	-764(ra) # 80005100 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	e42080e7          	jalr	-446(ra) # 80002246 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	4e6080e7          	jalr	1254(ra) # 800028f2 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	484080e7          	jalr	1156(ra) # 80003898 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	dec080e7          	jalr	-532(ra) # 80005208 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	cf2080e7          	jalr	-782(ra) # 80001116 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	48f72723          	sw	a5,1166(a4) # 800088c0 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000442:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000446:	00008797          	auipc	a5,0x8
    8000044a:	4827b783          	ld	a5,1154(a5) # 800088c8 <kernel_pagetable>
    8000044e:	83b1                	srli	a5,a5,0xc
    80000450:	577d                	li	a4,-1
    80000452:	177e                	slli	a4,a4,0x3f
    80000454:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000456:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000045a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000045e:	6422                	ld	s0,8(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000464:	7139                	addi	sp,sp,-64
    80000466:	fc06                	sd	ra,56(sp)
    80000468:	f822                	sd	s0,48(sp)
    8000046a:	f426                	sd	s1,40(sp)
    8000046c:	f04a                	sd	s2,32(sp)
    8000046e:	ec4e                	sd	s3,24(sp)
    80000470:	e852                	sd	s4,16(sp)
    80000472:	e456                	sd	s5,8(sp)
    80000474:	e05a                	sd	s6,0(sp)
    80000476:	0080                	addi	s0,sp,64
    80000478:	84aa                	mv	s1,a0
    8000047a:	89ae                	mv	s3,a1
    8000047c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047e:	57fd                	li	a5,-1
    80000480:	83e9                	srli	a5,a5,0x1a
    80000482:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000484:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000486:	04b7f263          	bgeu	a5,a1,800004ca <walk+0x66>
    panic("walk");
    8000048a:	00008517          	auipc	a0,0x8
    8000048e:	bc650513          	addi	a0,a0,-1082 # 80008050 <etext+0x50>
    80000492:	00005097          	auipc	ra,0x5
    80000496:	7d0080e7          	jalr	2000(ra) # 80005c62 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000049a:	060a8663          	beqz	s5,80000506 <walk+0xa2>
    8000049e:	00000097          	auipc	ra,0x0
    800004a2:	c7a080e7          	jalr	-902(ra) # 80000118 <kalloc>
    800004a6:	84aa                	mv	s1,a0
    800004a8:	c529                	beqz	a0,800004f2 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004aa:	6605                	lui	a2,0x1
    800004ac:	4581                	li	a1,0
    800004ae:	00000097          	auipc	ra,0x0
    800004b2:	cca080e7          	jalr	-822(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b6:	00c4d793          	srli	a5,s1,0xc
    800004ba:	07aa                	slli	a5,a5,0xa
    800004bc:	0017e793          	ori	a5,a5,1
    800004c0:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c4:	3a5d                	addiw	s4,s4,-9
    800004c6:	036a0063          	beq	s4,s6,800004e6 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004ca:	0149d933          	srl	s2,s3,s4
    800004ce:	1ff97913          	andi	s2,s2,511
    800004d2:	090e                	slli	s2,s2,0x3
    800004d4:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d6:	00093483          	ld	s1,0(s2)
    800004da:	0014f793          	andi	a5,s1,1
    800004de:	dfd5                	beqz	a5,8000049a <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004e0:	80a9                	srli	s1,s1,0xa
    800004e2:	04b2                	slli	s1,s1,0xc
    800004e4:	b7c5                	j	800004c4 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e6:	00c9d513          	srli	a0,s3,0xc
    800004ea:	1ff57513          	andi	a0,a0,511
    800004ee:	050e                	slli	a0,a0,0x3
    800004f0:	9526                	add	a0,a0,s1
}
    800004f2:	70e2                	ld	ra,56(sp)
    800004f4:	7442                	ld	s0,48(sp)
    800004f6:	74a2                	ld	s1,40(sp)
    800004f8:	7902                	ld	s2,32(sp)
    800004fa:	69e2                	ld	s3,24(sp)
    800004fc:	6a42                	ld	s4,16(sp)
    800004fe:	6aa2                	ld	s5,8(sp)
    80000500:	6b02                	ld	s6,0(sp)
    80000502:	6121                	addi	sp,sp,64
    80000504:	8082                	ret
        return 0;
    80000506:	4501                	li	a0,0
    80000508:	b7ed                	j	800004f2 <walk+0x8e>

000000008000050a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000050a:	57fd                	li	a5,-1
    8000050c:	83e9                	srli	a5,a5,0x1a
    8000050e:	00b7f463          	bgeu	a5,a1,80000516 <walkaddr+0xc>
    return 0;
    80000512:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000514:	8082                	ret
{
    80000516:	1141                	addi	sp,sp,-16
    80000518:	e406                	sd	ra,8(sp)
    8000051a:	e022                	sd	s0,0(sp)
    8000051c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051e:	4601                	li	a2,0
    80000520:	00000097          	auipc	ra,0x0
    80000524:	f44080e7          	jalr	-188(ra) # 80000464 <walk>
  if(pte == 0)
    80000528:	c105                	beqz	a0,80000548 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000052a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000052c:	0117f693          	andi	a3,a5,17
    80000530:	4745                	li	a4,17
    return 0;
    80000532:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000534:	00e68663          	beq	a3,a4,80000540 <walkaddr+0x36>
}
    80000538:	60a2                	ld	ra,8(sp)
    8000053a:	6402                	ld	s0,0(sp)
    8000053c:	0141                	addi	sp,sp,16
    8000053e:	8082                	ret
  pa = PTE2PA(*pte);
    80000540:	00a7d513          	srli	a0,a5,0xa
    80000544:	0532                	slli	a0,a0,0xc
  return pa;
    80000546:	bfcd                	j	80000538 <walkaddr+0x2e>
    return 0;
    80000548:	4501                	li	a0,0
    8000054a:	b7fd                	j	80000538 <walkaddr+0x2e>

000000008000054c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000054c:	715d                	addi	sp,sp,-80
    8000054e:	e486                	sd	ra,72(sp)
    80000550:	e0a2                	sd	s0,64(sp)
    80000552:	fc26                	sd	s1,56(sp)
    80000554:	f84a                	sd	s2,48(sp)
    80000556:	f44e                	sd	s3,40(sp)
    80000558:	f052                	sd	s4,32(sp)
    8000055a:	ec56                	sd	s5,24(sp)
    8000055c:	e85a                	sd	s6,16(sp)
    8000055e:	e45e                	sd	s7,8(sp)
    80000560:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000562:	c205                	beqz	a2,80000582 <mappages+0x36>
    80000564:	8aaa                	mv	s5,a0
    80000566:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000568:	77fd                	lui	a5,0xfffff
    8000056a:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056e:	15fd                	addi	a1,a1,-1
    80000570:	00c589b3          	add	s3,a1,a2
    80000574:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000578:	8952                	mv	s2,s4
    8000057a:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057e:	6b85                	lui	s7,0x1
    80000580:	a015                	j	800005a4 <mappages+0x58>
    panic("mappages: size");
    80000582:	00008517          	auipc	a0,0x8
    80000586:	ad650513          	addi	a0,a0,-1322 # 80008058 <etext+0x58>
    8000058a:	00005097          	auipc	ra,0x5
    8000058e:	6d8080e7          	jalr	1752(ra) # 80005c62 <panic>
      panic("mappages: remap");
    80000592:	00008517          	auipc	a0,0x8
    80000596:	ad650513          	addi	a0,a0,-1322 # 80008068 <etext+0x68>
    8000059a:	00005097          	auipc	ra,0x5
    8000059e:	6c8080e7          	jalr	1736(ra) # 80005c62 <panic>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
  for(;;){
    800005a4:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a8:	4605                	li	a2,1
    800005aa:	85ca                	mv	a1,s2
    800005ac:	8556                	mv	a0,s5
    800005ae:	00000097          	auipc	ra,0x0
    800005b2:	eb6080e7          	jalr	-330(ra) # 80000464 <walk>
    800005b6:	cd19                	beqz	a0,800005d4 <mappages+0x88>
    if(*pte & PTE_V)
    800005b8:	611c                	ld	a5,0(a0)
    800005ba:	8b85                	andi	a5,a5,1
    800005bc:	fbf9                	bnez	a5,80000592 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005be:	80b1                	srli	s1,s1,0xc
    800005c0:	04aa                	slli	s1,s1,0xa
    800005c2:	0164e4b3          	or	s1,s1,s6
    800005c6:	0014e493          	ori	s1,s1,1
    800005ca:	e104                	sd	s1,0(a0)
    if(a == last)
    800005cc:	fd391be3          	bne	s2,s3,800005a2 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005d0:	4501                	li	a0,0
    800005d2:	a011                	j	800005d6 <mappages+0x8a>
      return -1;
    800005d4:	557d                	li	a0,-1
}
    800005d6:	60a6                	ld	ra,72(sp)
    800005d8:	6406                	ld	s0,64(sp)
    800005da:	74e2                	ld	s1,56(sp)
    800005dc:	7942                	ld	s2,48(sp)
    800005de:	79a2                	ld	s3,40(sp)
    800005e0:	7a02                	ld	s4,32(sp)
    800005e2:	6ae2                	ld	s5,24(sp)
    800005e4:	6b42                	ld	s6,16(sp)
    800005e6:	6ba2                	ld	s7,8(sp)
    800005e8:	6161                	addi	sp,sp,80
    800005ea:	8082                	ret

00000000800005ec <kvmmap>:
{
    800005ec:	1141                	addi	sp,sp,-16
    800005ee:	e406                	sd	ra,8(sp)
    800005f0:	e022                	sd	s0,0(sp)
    800005f2:	0800                	addi	s0,sp,16
    800005f4:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f6:	86b2                	mv	a3,a2
    800005f8:	863e                	mv	a2,a5
    800005fa:	00000097          	auipc	ra,0x0
    800005fe:	f52080e7          	jalr	-174(ra) # 8000054c <mappages>
    80000602:	e509                	bnez	a0,8000060c <kvmmap+0x20>
}
    80000604:	60a2                	ld	ra,8(sp)
    80000606:	6402                	ld	s0,0(sp)
    80000608:	0141                	addi	sp,sp,16
    8000060a:	8082                	ret
    panic("kvmmap");
    8000060c:	00008517          	auipc	a0,0x8
    80000610:	a6c50513          	addi	a0,a0,-1428 # 80008078 <etext+0x78>
    80000614:	00005097          	auipc	ra,0x5
    80000618:	64e080e7          	jalr	1614(ra) # 80005c62 <panic>

000000008000061c <kvmmake>:
{
    8000061c:	1101                	addi	sp,sp,-32
    8000061e:	ec06                	sd	ra,24(sp)
    80000620:	e822                	sd	s0,16(sp)
    80000622:	e426                	sd	s1,8(sp)
    80000624:	e04a                	sd	s2,0(sp)
    80000626:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000628:	00000097          	auipc	ra,0x0
    8000062c:	af0080e7          	jalr	-1296(ra) # 80000118 <kalloc>
    80000630:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000632:	6605                	lui	a2,0x1
    80000634:	4581                	li	a1,0
    80000636:	00000097          	auipc	ra,0x0
    8000063a:	b42080e7          	jalr	-1214(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063e:	4719                	li	a4,6
    80000640:	6685                	lui	a3,0x1
    80000642:	10000637          	lui	a2,0x10000
    80000646:	100005b7          	lui	a1,0x10000
    8000064a:	8526                	mv	a0,s1
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	fa0080e7          	jalr	-96(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000654:	4719                	li	a4,6
    80000656:	6685                	lui	a3,0x1
    80000658:	10001637          	lui	a2,0x10001
    8000065c:	100015b7          	lui	a1,0x10001
    80000660:	8526                	mv	a0,s1
    80000662:	00000097          	auipc	ra,0x0
    80000666:	f8a080e7          	jalr	-118(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000066a:	4719                	li	a4,6
    8000066c:	004006b7          	lui	a3,0x400
    80000670:	0c000637          	lui	a2,0xc000
    80000674:	0c0005b7          	lui	a1,0xc000
    80000678:	8526                	mv	a0,s1
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	f72080e7          	jalr	-142(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000682:	00008917          	auipc	s2,0x8
    80000686:	97e90913          	addi	s2,s2,-1666 # 80008000 <etext>
    8000068a:	4729                	li	a4,10
    8000068c:	80008697          	auipc	a3,0x80008
    80000690:	97468693          	addi	a3,a3,-1676 # 8000 <_entry-0x7fff8000>
    80000694:	4605                	li	a2,1
    80000696:	067e                	slli	a2,a2,0x1f
    80000698:	85b2                	mv	a1,a2
    8000069a:	8526                	mv	a0,s1
    8000069c:	00000097          	auipc	ra,0x0
    800006a0:	f50080e7          	jalr	-176(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a4:	4719                	li	a4,6
    800006a6:	46c5                	li	a3,17
    800006a8:	06ee                	slli	a3,a3,0x1b
    800006aa:	412686b3          	sub	a3,a3,s2
    800006ae:	864a                	mv	a2,s2
    800006b0:	85ca                	mv	a1,s2
    800006b2:	8526                	mv	a0,s1
    800006b4:	00000097          	auipc	ra,0x0
    800006b8:	f38080e7          	jalr	-200(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006bc:	4729                	li	a4,10
    800006be:	6685                	lui	a3,0x1
    800006c0:	00007617          	auipc	a2,0x7
    800006c4:	94060613          	addi	a2,a2,-1728 # 80007000 <_trampoline>
    800006c8:	040005b7          	lui	a1,0x4000
    800006cc:	15fd                	addi	a1,a1,-1
    800006ce:	05b2                	slli	a1,a1,0xc
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	f1a080e7          	jalr	-230(ra) # 800005ec <kvmmap>
  proc_mapstacks(kpgtbl);
    800006da:	8526                	mv	a0,s1
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	5ec080e7          	jalr	1516(ra) # 80000cc8 <proc_mapstacks>
}
    800006e4:	8526                	mv	a0,s1
    800006e6:	60e2                	ld	ra,24(sp)
    800006e8:	6442                	ld	s0,16(sp)
    800006ea:	64a2                	ld	s1,8(sp)
    800006ec:	6902                	ld	s2,0(sp)
    800006ee:	6105                	addi	sp,sp,32
    800006f0:	8082                	ret

00000000800006f2 <kvminit>:
{
    800006f2:	1141                	addi	sp,sp,-16
    800006f4:	e406                	sd	ra,8(sp)
    800006f6:	e022                	sd	s0,0(sp)
    800006f8:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f22080e7          	jalr	-222(ra) # 8000061c <kvmmake>
    80000702:	00008797          	auipc	a5,0x8
    80000706:	1ca7b323          	sd	a0,454(a5) # 800088c8 <kernel_pagetable>
}
    8000070a:	60a2                	ld	ra,8(sp)
    8000070c:	6402                	ld	s0,0(sp)
    8000070e:	0141                	addi	sp,sp,16
    80000710:	8082                	ret

0000000080000712 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000712:	715d                	addi	sp,sp,-80
    80000714:	e486                	sd	ra,72(sp)
    80000716:	e0a2                	sd	s0,64(sp)
    80000718:	fc26                	sd	s1,56(sp)
    8000071a:	f84a                	sd	s2,48(sp)
    8000071c:	f44e                	sd	s3,40(sp)
    8000071e:	f052                	sd	s4,32(sp)
    80000720:	ec56                	sd	s5,24(sp)
    80000722:	e85a                	sd	s6,16(sp)
    80000724:	e45e                	sd	s7,8(sp)
    80000726:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000728:	03459793          	slli	a5,a1,0x34
    8000072c:	e795                	bnez	a5,80000758 <uvmunmap+0x46>
    8000072e:	8a2a                	mv	s4,a0
    80000730:	892e                	mv	s2,a1
    80000732:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000734:	0632                	slli	a2,a2,0xc
    80000736:	00b609b3          	add	s3,a2,a1
        // if (do_free == -1)
          continue;
        // else
        //   panic("uvmunmap: not mapped");
      }
    if(PTE_FLAGS(*pte) == PTE_V)
    8000073a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000073c:	6a85                	lui	s5,0x1
    8000073e:	0735e163          	bltu	a1,s3,800007a0 <uvmunmap+0x8e>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000742:	60a6                	ld	ra,72(sp)
    80000744:	6406                	ld	s0,64(sp)
    80000746:	74e2                	ld	s1,56(sp)
    80000748:	7942                	ld	s2,48(sp)
    8000074a:	79a2                	ld	s3,40(sp)
    8000074c:	7a02                	ld	s4,32(sp)
    8000074e:	6ae2                	ld	s5,24(sp)
    80000750:	6b42                	ld	s6,16(sp)
    80000752:	6ba2                	ld	s7,8(sp)
    80000754:	6161                	addi	sp,sp,80
    80000756:	8082                	ret
    panic("uvmunmap: not aligned");
    80000758:	00008517          	auipc	a0,0x8
    8000075c:	92850513          	addi	a0,a0,-1752 # 80008080 <etext+0x80>
    80000760:	00005097          	auipc	ra,0x5
    80000764:	502080e7          	jalr	1282(ra) # 80005c62 <panic>
      panic("uvmunmap: walk");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	93050513          	addi	a0,a0,-1744 # 80008098 <etext+0x98>
    80000770:	00005097          	auipc	ra,0x5
    80000774:	4f2080e7          	jalr	1266(ra) # 80005c62 <panic>
      panic("uvmunmap: not a leaf");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	93050513          	addi	a0,a0,-1744 # 800080a8 <etext+0xa8>
    80000780:	00005097          	auipc	ra,0x5
    80000784:	4e2080e7          	jalr	1250(ra) # 80005c62 <panic>
      uint64 pa = PTE2PA(*pte);
    80000788:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    8000078a:	00c79513          	slli	a0,a5,0xc
    8000078e:	00000097          	auipc	ra,0x0
    80000792:	88e080e7          	jalr	-1906(ra) # 8000001c <kfree>
    *pte = 0;
    80000796:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000079a:	9956                	add	s2,s2,s5
    8000079c:	fb3973e3          	bgeu	s2,s3,80000742 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007a0:	4601                	li	a2,0
    800007a2:	85ca                	mv	a1,s2
    800007a4:	8552                	mv	a0,s4
    800007a6:	00000097          	auipc	ra,0x0
    800007aa:	cbe080e7          	jalr	-834(ra) # 80000464 <walk>
    800007ae:	84aa                	mv	s1,a0
    800007b0:	dd45                	beqz	a0,80000768 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0) {
    800007b2:	611c                	ld	a5,0(a0)
    800007b4:	0017f713          	andi	a4,a5,1
    800007b8:	d36d                	beqz	a4,8000079a <uvmunmap+0x88>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007ba:	3ff7f713          	andi	a4,a5,1023
    800007be:	fb770de3          	beq	a4,s7,80000778 <uvmunmap+0x66>
    if(do_free){
    800007c2:	fc0b0ae3          	beqz	s6,80000796 <uvmunmap+0x84>
    800007c6:	b7c9                	j	80000788 <uvmunmap+0x76>

00000000800007c8 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007c8:	1101                	addi	sp,sp,-32
    800007ca:	ec06                	sd	ra,24(sp)
    800007cc:	e822                	sd	s0,16(sp)
    800007ce:	e426                	sd	s1,8(sp)
    800007d0:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d2:	00000097          	auipc	ra,0x0
    800007d6:	946080e7          	jalr	-1722(ra) # 80000118 <kalloc>
    800007da:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007dc:	c519                	beqz	a0,800007ea <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007de:	6605                	lui	a2,0x1
    800007e0:	4581                	li	a1,0
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	996080e7          	jalr	-1642(ra) # 80000178 <memset>
  return pagetable;
}
    800007ea:	8526                	mv	a0,s1
    800007ec:	60e2                	ld	ra,24(sp)
    800007ee:	6442                	ld	s0,16(sp)
    800007f0:	64a2                	ld	s1,8(sp)
    800007f2:	6105                	addi	sp,sp,32
    800007f4:	8082                	ret

00000000800007f6 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007f6:	7179                	addi	sp,sp,-48
    800007f8:	f406                	sd	ra,40(sp)
    800007fa:	f022                	sd	s0,32(sp)
    800007fc:	ec26                	sd	s1,24(sp)
    800007fe:	e84a                	sd	s2,16(sp)
    80000800:	e44e                	sd	s3,8(sp)
    80000802:	e052                	sd	s4,0(sp)
    80000804:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000806:	6785                	lui	a5,0x1
    80000808:	04f67863          	bgeu	a2,a5,80000858 <uvmfirst+0x62>
    8000080c:	8a2a                	mv	s4,a0
    8000080e:	89ae                	mv	s3,a1
    80000810:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000812:	00000097          	auipc	ra,0x0
    80000816:	906080e7          	jalr	-1786(ra) # 80000118 <kalloc>
    8000081a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000081c:	6605                	lui	a2,0x1
    8000081e:	4581                	li	a1,0
    80000820:	00000097          	auipc	ra,0x0
    80000824:	958080e7          	jalr	-1704(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000828:	4779                	li	a4,30
    8000082a:	86ca                	mv	a3,s2
    8000082c:	6605                	lui	a2,0x1
    8000082e:	4581                	li	a1,0
    80000830:	8552                	mv	a0,s4
    80000832:	00000097          	auipc	ra,0x0
    80000836:	d1a080e7          	jalr	-742(ra) # 8000054c <mappages>
  memmove(mem, src, sz);
    8000083a:	8626                	mv	a2,s1
    8000083c:	85ce                	mv	a1,s3
    8000083e:	854a                	mv	a0,s2
    80000840:	00000097          	auipc	ra,0x0
    80000844:	998080e7          	jalr	-1640(ra) # 800001d8 <memmove>
}
    80000848:	70a2                	ld	ra,40(sp)
    8000084a:	7402                	ld	s0,32(sp)
    8000084c:	64e2                	ld	s1,24(sp)
    8000084e:	6942                	ld	s2,16(sp)
    80000850:	69a2                	ld	s3,8(sp)
    80000852:	6a02                	ld	s4,0(sp)
    80000854:	6145                	addi	sp,sp,48
    80000856:	8082                	ret
    panic("uvmfirst: more than a page");
    80000858:	00008517          	auipc	a0,0x8
    8000085c:	86850513          	addi	a0,a0,-1944 # 800080c0 <etext+0xc0>
    80000860:	00005097          	auipc	ra,0x5
    80000864:	402080e7          	jalr	1026(ra) # 80005c62 <panic>

0000000080000868 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000868:	1101                	addi	sp,sp,-32
    8000086a:	ec06                	sd	ra,24(sp)
    8000086c:	e822                	sd	s0,16(sp)
    8000086e:	e426                	sd	s1,8(sp)
    80000870:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000872:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000874:	00b67d63          	bgeu	a2,a1,8000088e <uvmdealloc+0x26>
    80000878:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000087a:	6785                	lui	a5,0x1
    8000087c:	17fd                	addi	a5,a5,-1
    8000087e:	00f60733          	add	a4,a2,a5
    80000882:	767d                	lui	a2,0xfffff
    80000884:	8f71                	and	a4,a4,a2
    80000886:	97ae                	add	a5,a5,a1
    80000888:	8ff1                	and	a5,a5,a2
    8000088a:	00f76863          	bltu	a4,a5,8000089a <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000088e:	8526                	mv	a0,s1
    80000890:	60e2                	ld	ra,24(sp)
    80000892:	6442                	ld	s0,16(sp)
    80000894:	64a2                	ld	s1,8(sp)
    80000896:	6105                	addi	sp,sp,32
    80000898:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000089a:	8f99                	sub	a5,a5,a4
    8000089c:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000089e:	4685                	li	a3,1
    800008a0:	0007861b          	sext.w	a2,a5
    800008a4:	85ba                	mv	a1,a4
    800008a6:	00000097          	auipc	ra,0x0
    800008aa:	e6c080e7          	jalr	-404(ra) # 80000712 <uvmunmap>
    800008ae:	b7c5                	j	8000088e <uvmdealloc+0x26>

00000000800008b0 <uvmalloc>:
  if(newsz < oldsz)
    800008b0:	0ab66563          	bltu	a2,a1,8000095a <uvmalloc+0xaa>
{
    800008b4:	7139                	addi	sp,sp,-64
    800008b6:	fc06                	sd	ra,56(sp)
    800008b8:	f822                	sd	s0,48(sp)
    800008ba:	f426                	sd	s1,40(sp)
    800008bc:	f04a                	sd	s2,32(sp)
    800008be:	ec4e                	sd	s3,24(sp)
    800008c0:	e852                	sd	s4,16(sp)
    800008c2:	e456                	sd	s5,8(sp)
    800008c4:	e05a                	sd	s6,0(sp)
    800008c6:	0080                	addi	s0,sp,64
    800008c8:	8aaa                	mv	s5,a0
    800008ca:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008cc:	6985                	lui	s3,0x1
    800008ce:	19fd                	addi	s3,s3,-1
    800008d0:	95ce                	add	a1,a1,s3
    800008d2:	79fd                	lui	s3,0xfffff
    800008d4:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008d8:	08c9f363          	bgeu	s3,a2,8000095e <uvmalloc+0xae>
    800008dc:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008de:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008e2:	00000097          	auipc	ra,0x0
    800008e6:	836080e7          	jalr	-1994(ra) # 80000118 <kalloc>
    800008ea:	84aa                	mv	s1,a0
    if(mem == 0){
    800008ec:	c51d                	beqz	a0,8000091a <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008ee:	6605                	lui	a2,0x1
    800008f0:	4581                	li	a1,0
    800008f2:	00000097          	auipc	ra,0x0
    800008f6:	886080e7          	jalr	-1914(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008fa:	875a                	mv	a4,s6
    800008fc:	86a6                	mv	a3,s1
    800008fe:	6605                	lui	a2,0x1
    80000900:	85ca                	mv	a1,s2
    80000902:	8556                	mv	a0,s5
    80000904:	00000097          	auipc	ra,0x0
    80000908:	c48080e7          	jalr	-952(ra) # 8000054c <mappages>
    8000090c:	e90d                	bnez	a0,8000093e <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090e:	6785                	lui	a5,0x1
    80000910:	993e                	add	s2,s2,a5
    80000912:	fd4968e3          	bltu	s2,s4,800008e2 <uvmalloc+0x32>
  return newsz;
    80000916:	8552                	mv	a0,s4
    80000918:	a809                	j	8000092a <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000091a:	864e                	mv	a2,s3
    8000091c:	85ca                	mv	a1,s2
    8000091e:	8556                	mv	a0,s5
    80000920:	00000097          	auipc	ra,0x0
    80000924:	f48080e7          	jalr	-184(ra) # 80000868 <uvmdealloc>
      return 0;
    80000928:	4501                	li	a0,0
}
    8000092a:	70e2                	ld	ra,56(sp)
    8000092c:	7442                	ld	s0,48(sp)
    8000092e:	74a2                	ld	s1,40(sp)
    80000930:	7902                	ld	s2,32(sp)
    80000932:	69e2                	ld	s3,24(sp)
    80000934:	6a42                	ld	s4,16(sp)
    80000936:	6aa2                	ld	s5,8(sp)
    80000938:	6b02                	ld	s6,0(sp)
    8000093a:	6121                	addi	sp,sp,64
    8000093c:	8082                	ret
      kfree(mem);
    8000093e:	8526                	mv	a0,s1
    80000940:	fffff097          	auipc	ra,0xfffff
    80000944:	6dc080e7          	jalr	1756(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000948:	864e                	mv	a2,s3
    8000094a:	85ca                	mv	a1,s2
    8000094c:	8556                	mv	a0,s5
    8000094e:	00000097          	auipc	ra,0x0
    80000952:	f1a080e7          	jalr	-230(ra) # 80000868 <uvmdealloc>
      return 0;
    80000956:	4501                	li	a0,0
    80000958:	bfc9                	j	8000092a <uvmalloc+0x7a>
    return oldsz;
    8000095a:	852e                	mv	a0,a1
}
    8000095c:	8082                	ret
  return newsz;
    8000095e:	8532                	mv	a0,a2
    80000960:	b7e9                	j	8000092a <uvmalloc+0x7a>

0000000080000962 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000962:	7179                	addi	sp,sp,-48
    80000964:	f406                	sd	ra,40(sp)
    80000966:	f022                	sd	s0,32(sp)
    80000968:	ec26                	sd	s1,24(sp)
    8000096a:	e84a                	sd	s2,16(sp)
    8000096c:	e44e                	sd	s3,8(sp)
    8000096e:	e052                	sd	s4,0(sp)
    80000970:	1800                	addi	s0,sp,48
    80000972:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000974:	84aa                	mv	s1,a0
    80000976:	6905                	lui	s2,0x1
    80000978:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000097a:	4985                	li	s3,1
    8000097c:	a821                	j	80000994 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000097e:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000980:	0532                	slli	a0,a0,0xc
    80000982:	00000097          	auipc	ra,0x0
    80000986:	fe0080e7          	jalr	-32(ra) # 80000962 <freewalk>
      pagetable[i] = 0;
    8000098a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000098e:	04a1                	addi	s1,s1,8
    80000990:	03248163          	beq	s1,s2,800009b2 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000994:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000996:	00f57793          	andi	a5,a0,15
    8000099a:	ff3782e3          	beq	a5,s3,8000097e <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000099e:	8905                	andi	a0,a0,1
    800009a0:	d57d                	beqz	a0,8000098e <freewalk+0x2c>
      panic("freewalk: leaf");
    800009a2:	00007517          	auipc	a0,0x7
    800009a6:	73e50513          	addi	a0,a0,1854 # 800080e0 <etext+0xe0>
    800009aa:	00005097          	auipc	ra,0x5
    800009ae:	2b8080e7          	jalr	696(ra) # 80005c62 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b2:	8552                	mv	a0,s4
    800009b4:	fffff097          	auipc	ra,0xfffff
    800009b8:	668080e7          	jalr	1640(ra) # 8000001c <kfree>
}
    800009bc:	70a2                	ld	ra,40(sp)
    800009be:	7402                	ld	s0,32(sp)
    800009c0:	64e2                	ld	s1,24(sp)
    800009c2:	6942                	ld	s2,16(sp)
    800009c4:	69a2                	ld	s3,8(sp)
    800009c6:	6a02                	ld	s4,0(sp)
    800009c8:	6145                	addi	sp,sp,48
    800009ca:	8082                	ret

00000000800009cc <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009cc:	1101                	addi	sp,sp,-32
    800009ce:	ec06                	sd	ra,24(sp)
    800009d0:	e822                	sd	s0,16(sp)
    800009d2:	e426                	sd	s1,8(sp)
    800009d4:	1000                	addi	s0,sp,32
    800009d6:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d8:	e999                	bnez	a1,800009ee <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009da:	8526                	mv	a0,s1
    800009dc:	00000097          	auipc	ra,0x0
    800009e0:	f86080e7          	jalr	-122(ra) # 80000962 <freewalk>
}
    800009e4:	60e2                	ld	ra,24(sp)
    800009e6:	6442                	ld	s0,16(sp)
    800009e8:	64a2                	ld	s1,8(sp)
    800009ea:	6105                	addi	sp,sp,32
    800009ec:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009ee:	6605                	lui	a2,0x1
    800009f0:	167d                	addi	a2,a2,-1
    800009f2:	962e                	add	a2,a2,a1
    800009f4:	4685                	li	a3,1
    800009f6:	8231                	srli	a2,a2,0xc
    800009f8:	4581                	li	a1,0
    800009fa:	00000097          	auipc	ra,0x0
    800009fe:	d18080e7          	jalr	-744(ra) # 80000712 <uvmunmap>
    80000a02:	bfe1                	j	800009da <uvmfree+0xe>

0000000080000a04 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a04:	c269                	beqz	a2,80000ac6 <uvmcopy+0xc2>
{
    80000a06:	715d                	addi	sp,sp,-80
    80000a08:	e486                	sd	ra,72(sp)
    80000a0a:	e0a2                	sd	s0,64(sp)
    80000a0c:	fc26                	sd	s1,56(sp)
    80000a0e:	f84a                	sd	s2,48(sp)
    80000a10:	f44e                	sd	s3,40(sp)
    80000a12:	f052                	sd	s4,32(sp)
    80000a14:	ec56                	sd	s5,24(sp)
    80000a16:	e85a                	sd	s6,16(sp)
    80000a18:	e45e                	sd	s7,8(sp)
    80000a1a:	0880                	addi	s0,sp,80
    80000a1c:	8aaa                	mv	s5,a0
    80000a1e:	8b2e                	mv	s6,a1
    80000a20:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a22:	4481                	li	s1,0
    80000a24:	a829                	j	80000a3e <uvmcopy+0x3a>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000a26:	00007517          	auipc	a0,0x7
    80000a2a:	6ca50513          	addi	a0,a0,1738 # 800080f0 <etext+0xf0>
    80000a2e:	00005097          	auipc	ra,0x5
    80000a32:	234080e7          	jalr	564(ra) # 80005c62 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    80000a36:	6785                	lui	a5,0x1
    80000a38:	94be                	add	s1,s1,a5
    80000a3a:	0944f463          	bgeu	s1,s4,80000ac2 <uvmcopy+0xbe>
    if((pte = walk(old, i, 0)) == 0)
    80000a3e:	4601                	li	a2,0
    80000a40:	85a6                	mv	a1,s1
    80000a42:	8556                	mv	a0,s5
    80000a44:	00000097          	auipc	ra,0x0
    80000a48:	a20080e7          	jalr	-1504(ra) # 80000464 <walk>
    80000a4c:	dd69                	beqz	a0,80000a26 <uvmcopy+0x22>
    if((*pte & PTE_V) == 0) continue;
    80000a4e:	6118                	ld	a4,0(a0)
    80000a50:	00177793          	andi	a5,a4,1
    80000a54:	d3ed                	beqz	a5,80000a36 <uvmcopy+0x32>
      // panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a56:	00a75593          	srli	a1,a4,0xa
    80000a5a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a5e:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    80000a62:	fffff097          	auipc	ra,0xfffff
    80000a66:	6b6080e7          	jalr	1718(ra) # 80000118 <kalloc>
    80000a6a:	89aa                	mv	s3,a0
    80000a6c:	c515                	beqz	a0,80000a98 <uvmcopy+0x94>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a6e:	6605                	lui	a2,0x1
    80000a70:	85de                	mv	a1,s7
    80000a72:	fffff097          	auipc	ra,0xfffff
    80000a76:	766080e7          	jalr	1894(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a7a:	874a                	mv	a4,s2
    80000a7c:	86ce                	mv	a3,s3
    80000a7e:	6605                	lui	a2,0x1
    80000a80:	85a6                	mv	a1,s1
    80000a82:	855a                	mv	a0,s6
    80000a84:	00000097          	auipc	ra,0x0
    80000a88:	ac8080e7          	jalr	-1336(ra) # 8000054c <mappages>
    80000a8c:	d54d                	beqz	a0,80000a36 <uvmcopy+0x32>
      kfree(mem);
    80000a8e:	854e                	mv	a0,s3
    80000a90:	fffff097          	auipc	ra,0xfffff
    80000a94:	58c080e7          	jalr	1420(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a98:	4685                	li	a3,1
    80000a9a:	00c4d613          	srli	a2,s1,0xc
    80000a9e:	4581                	li	a1,0
    80000aa0:	855a                	mv	a0,s6
    80000aa2:	00000097          	auipc	ra,0x0
    80000aa6:	c70080e7          	jalr	-912(ra) # 80000712 <uvmunmap>
  return -1;
    80000aaa:	557d                	li	a0,-1
}
    80000aac:	60a6                	ld	ra,72(sp)
    80000aae:	6406                	ld	s0,64(sp)
    80000ab0:	74e2                	ld	s1,56(sp)
    80000ab2:	7942                	ld	s2,48(sp)
    80000ab4:	79a2                	ld	s3,40(sp)
    80000ab6:	7a02                	ld	s4,32(sp)
    80000ab8:	6ae2                	ld	s5,24(sp)
    80000aba:	6b42                	ld	s6,16(sp)
    80000abc:	6ba2                	ld	s7,8(sp)
    80000abe:	6161                	addi	sp,sp,80
    80000ac0:	8082                	ret
  return 0;
    80000ac2:	4501                	li	a0,0
    80000ac4:	b7e5                	j	80000aac <uvmcopy+0xa8>
    80000ac6:	4501                	li	a0,0
}
    80000ac8:	8082                	ret

0000000080000aca <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000aca:	1141                	addi	sp,sp,-16
    80000acc:	e406                	sd	ra,8(sp)
    80000ace:	e022                	sd	s0,0(sp)
    80000ad0:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ad2:	4601                	li	a2,0
    80000ad4:	00000097          	auipc	ra,0x0
    80000ad8:	990080e7          	jalr	-1648(ra) # 80000464 <walk>
  if(pte == 0)
    80000adc:	c901                	beqz	a0,80000aec <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ade:	611c                	ld	a5,0(a0)
    80000ae0:	9bbd                	andi	a5,a5,-17
    80000ae2:	e11c                	sd	a5,0(a0)
}
    80000ae4:	60a2                	ld	ra,8(sp)
    80000ae6:	6402                	ld	s0,0(sp)
    80000ae8:	0141                	addi	sp,sp,16
    80000aea:	8082                	ret
    panic("uvmclear");
    80000aec:	00007517          	auipc	a0,0x7
    80000af0:	62450513          	addi	a0,a0,1572 # 80008110 <etext+0x110>
    80000af4:	00005097          	auipc	ra,0x5
    80000af8:	16e080e7          	jalr	366(ra) # 80005c62 <panic>

0000000080000afc <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000afc:	c6bd                	beqz	a3,80000b6a <copyout+0x6e>
{
    80000afe:	715d                	addi	sp,sp,-80
    80000b00:	e486                	sd	ra,72(sp)
    80000b02:	e0a2                	sd	s0,64(sp)
    80000b04:	fc26                	sd	s1,56(sp)
    80000b06:	f84a                	sd	s2,48(sp)
    80000b08:	f44e                	sd	s3,40(sp)
    80000b0a:	f052                	sd	s4,32(sp)
    80000b0c:	ec56                	sd	s5,24(sp)
    80000b0e:	e85a                	sd	s6,16(sp)
    80000b10:	e45e                	sd	s7,8(sp)
    80000b12:	e062                	sd	s8,0(sp)
    80000b14:	0880                	addi	s0,sp,80
    80000b16:	8b2a                	mv	s6,a0
    80000b18:	8c2e                	mv	s8,a1
    80000b1a:	8a32                	mv	s4,a2
    80000b1c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b1e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b20:	6a85                	lui	s5,0x1
    80000b22:	a015                	j	80000b46 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b24:	9562                	add	a0,a0,s8
    80000b26:	0004861b          	sext.w	a2,s1
    80000b2a:	85d2                	mv	a1,s4
    80000b2c:	41250533          	sub	a0,a0,s2
    80000b30:	fffff097          	auipc	ra,0xfffff
    80000b34:	6a8080e7          	jalr	1704(ra) # 800001d8 <memmove>

    len -= n;
    80000b38:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b3c:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b3e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b42:	02098263          	beqz	s3,80000b66 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b46:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b4a:	85ca                	mv	a1,s2
    80000b4c:	855a                	mv	a0,s6
    80000b4e:	00000097          	auipc	ra,0x0
    80000b52:	9bc080e7          	jalr	-1604(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000b56:	cd01                	beqz	a0,80000b6e <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b58:	418904b3          	sub	s1,s2,s8
    80000b5c:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b5e:	fc99f3e3          	bgeu	s3,s1,80000b24 <copyout+0x28>
    80000b62:	84ce                	mv	s1,s3
    80000b64:	b7c1                	j	80000b24 <copyout+0x28>
  }
  return 0;
    80000b66:	4501                	li	a0,0
    80000b68:	a021                	j	80000b70 <copyout+0x74>
    80000b6a:	4501                	li	a0,0
}
    80000b6c:	8082                	ret
      return -1;
    80000b6e:	557d                	li	a0,-1
}
    80000b70:	60a6                	ld	ra,72(sp)
    80000b72:	6406                	ld	s0,64(sp)
    80000b74:	74e2                	ld	s1,56(sp)
    80000b76:	7942                	ld	s2,48(sp)
    80000b78:	79a2                	ld	s3,40(sp)
    80000b7a:	7a02                	ld	s4,32(sp)
    80000b7c:	6ae2                	ld	s5,24(sp)
    80000b7e:	6b42                	ld	s6,16(sp)
    80000b80:	6ba2                	ld	s7,8(sp)
    80000b82:	6c02                	ld	s8,0(sp)
    80000b84:	6161                	addi	sp,sp,80
    80000b86:	8082                	ret

0000000080000b88 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b88:	c6bd                	beqz	a3,80000bf6 <copyin+0x6e>
{
    80000b8a:	715d                	addi	sp,sp,-80
    80000b8c:	e486                	sd	ra,72(sp)
    80000b8e:	e0a2                	sd	s0,64(sp)
    80000b90:	fc26                	sd	s1,56(sp)
    80000b92:	f84a                	sd	s2,48(sp)
    80000b94:	f44e                	sd	s3,40(sp)
    80000b96:	f052                	sd	s4,32(sp)
    80000b98:	ec56                	sd	s5,24(sp)
    80000b9a:	e85a                	sd	s6,16(sp)
    80000b9c:	e45e                	sd	s7,8(sp)
    80000b9e:	e062                	sd	s8,0(sp)
    80000ba0:	0880                	addi	s0,sp,80
    80000ba2:	8b2a                	mv	s6,a0
    80000ba4:	8a2e                	mv	s4,a1
    80000ba6:	8c32                	mv	s8,a2
    80000ba8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000baa:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bac:	6a85                	lui	s5,0x1
    80000bae:	a015                	j	80000bd2 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bb0:	9562                	add	a0,a0,s8
    80000bb2:	0004861b          	sext.w	a2,s1
    80000bb6:	412505b3          	sub	a1,a0,s2
    80000bba:	8552                	mv	a0,s4
    80000bbc:	fffff097          	auipc	ra,0xfffff
    80000bc0:	61c080e7          	jalr	1564(ra) # 800001d8 <memmove>

    len -= n;
    80000bc4:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bc8:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bca:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bce:	02098263          	beqz	s3,80000bf2 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000bd2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bd6:	85ca                	mv	a1,s2
    80000bd8:	855a                	mv	a0,s6
    80000bda:	00000097          	auipc	ra,0x0
    80000bde:	930080e7          	jalr	-1744(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000be2:	cd01                	beqz	a0,80000bfa <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000be4:	418904b3          	sub	s1,s2,s8
    80000be8:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bea:	fc99f3e3          	bgeu	s3,s1,80000bb0 <copyin+0x28>
    80000bee:	84ce                	mv	s1,s3
    80000bf0:	b7c1                	j	80000bb0 <copyin+0x28>
  }
  return 0;
    80000bf2:	4501                	li	a0,0
    80000bf4:	a021                	j	80000bfc <copyin+0x74>
    80000bf6:	4501                	li	a0,0
}
    80000bf8:	8082                	ret
      return -1;
    80000bfa:	557d                	li	a0,-1
}
    80000bfc:	60a6                	ld	ra,72(sp)
    80000bfe:	6406                	ld	s0,64(sp)
    80000c00:	74e2                	ld	s1,56(sp)
    80000c02:	7942                	ld	s2,48(sp)
    80000c04:	79a2                	ld	s3,40(sp)
    80000c06:	7a02                	ld	s4,32(sp)
    80000c08:	6ae2                	ld	s5,24(sp)
    80000c0a:	6b42                	ld	s6,16(sp)
    80000c0c:	6ba2                	ld	s7,8(sp)
    80000c0e:	6c02                	ld	s8,0(sp)
    80000c10:	6161                	addi	sp,sp,80
    80000c12:	8082                	ret

0000000080000c14 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c14:	c6c5                	beqz	a3,80000cbc <copyinstr+0xa8>
{
    80000c16:	715d                	addi	sp,sp,-80
    80000c18:	e486                	sd	ra,72(sp)
    80000c1a:	e0a2                	sd	s0,64(sp)
    80000c1c:	fc26                	sd	s1,56(sp)
    80000c1e:	f84a                	sd	s2,48(sp)
    80000c20:	f44e                	sd	s3,40(sp)
    80000c22:	f052                	sd	s4,32(sp)
    80000c24:	ec56                	sd	s5,24(sp)
    80000c26:	e85a                	sd	s6,16(sp)
    80000c28:	e45e                	sd	s7,8(sp)
    80000c2a:	0880                	addi	s0,sp,80
    80000c2c:	8a2a                	mv	s4,a0
    80000c2e:	8b2e                	mv	s6,a1
    80000c30:	8bb2                	mv	s7,a2
    80000c32:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c34:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c36:	6985                	lui	s3,0x1
    80000c38:	a035                	j	80000c64 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c3a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c3e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c40:	0017b793          	seqz	a5,a5
    80000c44:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c48:	60a6                	ld	ra,72(sp)
    80000c4a:	6406                	ld	s0,64(sp)
    80000c4c:	74e2                	ld	s1,56(sp)
    80000c4e:	7942                	ld	s2,48(sp)
    80000c50:	79a2                	ld	s3,40(sp)
    80000c52:	7a02                	ld	s4,32(sp)
    80000c54:	6ae2                	ld	s5,24(sp)
    80000c56:	6b42                	ld	s6,16(sp)
    80000c58:	6ba2                	ld	s7,8(sp)
    80000c5a:	6161                	addi	sp,sp,80
    80000c5c:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c5e:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c62:	c8a9                	beqz	s1,80000cb4 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c64:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c68:	85ca                	mv	a1,s2
    80000c6a:	8552                	mv	a0,s4
    80000c6c:	00000097          	auipc	ra,0x0
    80000c70:	89e080e7          	jalr	-1890(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000c74:	c131                	beqz	a0,80000cb8 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c76:	41790833          	sub	a6,s2,s7
    80000c7a:	984e                	add	a6,a6,s3
    if(n > max)
    80000c7c:	0104f363          	bgeu	s1,a6,80000c82 <copyinstr+0x6e>
    80000c80:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c82:	955e                	add	a0,a0,s7
    80000c84:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c88:	fc080be3          	beqz	a6,80000c5e <copyinstr+0x4a>
    80000c8c:	985a                	add	a6,a6,s6
    80000c8e:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c90:	41650633          	sub	a2,a0,s6
    80000c94:	14fd                	addi	s1,s1,-1
    80000c96:	9b26                	add	s6,s6,s1
    80000c98:	00f60733          	add	a4,a2,a5
    80000c9c:	00074703          	lbu	a4,0(a4)
    80000ca0:	df49                	beqz	a4,80000c3a <copyinstr+0x26>
        *dst = *p;
    80000ca2:	00e78023          	sb	a4,0(a5)
      --max;
    80000ca6:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000caa:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cac:	ff0796e3          	bne	a5,a6,80000c98 <copyinstr+0x84>
      dst++;
    80000cb0:	8b42                	mv	s6,a6
    80000cb2:	b775                	j	80000c5e <copyinstr+0x4a>
    80000cb4:	4781                	li	a5,0
    80000cb6:	b769                	j	80000c40 <copyinstr+0x2c>
      return -1;
    80000cb8:	557d                	li	a0,-1
    80000cba:	b779                	j	80000c48 <copyinstr+0x34>
  int got_null = 0;
    80000cbc:	4781                	li	a5,0
  if(got_null){
    80000cbe:	0017b793          	seqz	a5,a5
    80000cc2:	40f00533          	neg	a0,a5
}
    80000cc6:	8082                	ret

0000000080000cc8 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000cc8:	7139                	addi	sp,sp,-64
    80000cca:	fc06                	sd	ra,56(sp)
    80000ccc:	f822                	sd	s0,48(sp)
    80000cce:	f426                	sd	s1,40(sp)
    80000cd0:	f04a                	sd	s2,32(sp)
    80000cd2:	ec4e                	sd	s3,24(sp)
    80000cd4:	e852                	sd	s4,16(sp)
    80000cd6:	e456                	sd	s5,8(sp)
    80000cd8:	e05a                	sd	s6,0(sp)
    80000cda:	0080                	addi	s0,sp,64
    80000cdc:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cde:	00008497          	auipc	s1,0x8
    80000ce2:	06248493          	addi	s1,s1,98 # 80008d40 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000ce6:	8b26                	mv	s6,s1
    80000ce8:	00007a97          	auipc	s5,0x7
    80000cec:	318a8a93          	addi	s5,s5,792 # 80008000 <etext>
    80000cf0:	04000937          	lui	s2,0x4000
    80000cf4:	197d                	addi	s2,s2,-1
    80000cf6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf8:	0000ea17          	auipc	s4,0xe
    80000cfc:	a48a0a13          	addi	s4,s4,-1464 # 8000e740 <tickslock>
    char *pa = kalloc();
    80000d00:	fffff097          	auipc	ra,0xfffff
    80000d04:	418080e7          	jalr	1048(ra) # 80000118 <kalloc>
    80000d08:	862a                	mv	a2,a0
    if(pa == 0)
    80000d0a:	c131                	beqz	a0,80000d4e <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d0c:	416485b3          	sub	a1,s1,s6
    80000d10:	858d                	srai	a1,a1,0x3
    80000d12:	000ab783          	ld	a5,0(s5)
    80000d16:	02f585b3          	mul	a1,a1,a5
    80000d1a:	2585                	addiw	a1,a1,1
    80000d1c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d20:	4719                	li	a4,6
    80000d22:	6685                	lui	a3,0x1
    80000d24:	40b905b3          	sub	a1,s2,a1
    80000d28:	854e                	mv	a0,s3
    80000d2a:	00000097          	auipc	ra,0x0
    80000d2e:	8c2080e7          	jalr	-1854(ra) # 800005ec <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d32:	16848493          	addi	s1,s1,360
    80000d36:	fd4495e3          	bne	s1,s4,80000d00 <proc_mapstacks+0x38>
  }
}
    80000d3a:	70e2                	ld	ra,56(sp)
    80000d3c:	7442                	ld	s0,48(sp)
    80000d3e:	74a2                	ld	s1,40(sp)
    80000d40:	7902                	ld	s2,32(sp)
    80000d42:	69e2                	ld	s3,24(sp)
    80000d44:	6a42                	ld	s4,16(sp)
    80000d46:	6aa2                	ld	s5,8(sp)
    80000d48:	6b02                	ld	s6,0(sp)
    80000d4a:	6121                	addi	sp,sp,64
    80000d4c:	8082                	ret
      panic("kalloc");
    80000d4e:	00007517          	auipc	a0,0x7
    80000d52:	3d250513          	addi	a0,a0,978 # 80008120 <etext+0x120>
    80000d56:	00005097          	auipc	ra,0x5
    80000d5a:	f0c080e7          	jalr	-244(ra) # 80005c62 <panic>

0000000080000d5e <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d5e:	7139                	addi	sp,sp,-64
    80000d60:	fc06                	sd	ra,56(sp)
    80000d62:	f822                	sd	s0,48(sp)
    80000d64:	f426                	sd	s1,40(sp)
    80000d66:	f04a                	sd	s2,32(sp)
    80000d68:	ec4e                	sd	s3,24(sp)
    80000d6a:	e852                	sd	s4,16(sp)
    80000d6c:	e456                	sd	s5,8(sp)
    80000d6e:	e05a                	sd	s6,0(sp)
    80000d70:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d72:	00007597          	auipc	a1,0x7
    80000d76:	3b658593          	addi	a1,a1,950 # 80008128 <etext+0x128>
    80000d7a:	00008517          	auipc	a0,0x8
    80000d7e:	b9650513          	addi	a0,a0,-1130 # 80008910 <pid_lock>
    80000d82:	00005097          	auipc	ra,0x5
    80000d86:	39a080e7          	jalr	922(ra) # 8000611c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d8a:	00007597          	auipc	a1,0x7
    80000d8e:	3a658593          	addi	a1,a1,934 # 80008130 <etext+0x130>
    80000d92:	00008517          	auipc	a0,0x8
    80000d96:	b9650513          	addi	a0,a0,-1130 # 80008928 <wait_lock>
    80000d9a:	00005097          	auipc	ra,0x5
    80000d9e:	382080e7          	jalr	898(ra) # 8000611c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000da2:	00008497          	auipc	s1,0x8
    80000da6:	f9e48493          	addi	s1,s1,-98 # 80008d40 <proc>
      initlock(&p->lock, "proc");
    80000daa:	00007b17          	auipc	s6,0x7
    80000dae:	396b0b13          	addi	s6,s6,918 # 80008140 <etext+0x140>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000db2:	8aa6                	mv	s5,s1
    80000db4:	00007a17          	auipc	s4,0x7
    80000db8:	24ca0a13          	addi	s4,s4,588 # 80008000 <etext>
    80000dbc:	04000937          	lui	s2,0x4000
    80000dc0:	197d                	addi	s2,s2,-1
    80000dc2:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dc4:	0000e997          	auipc	s3,0xe
    80000dc8:	97c98993          	addi	s3,s3,-1668 # 8000e740 <tickslock>
      initlock(&p->lock, "proc");
    80000dcc:	85da                	mv	a1,s6
    80000dce:	8526                	mv	a0,s1
    80000dd0:	00005097          	auipc	ra,0x5
    80000dd4:	34c080e7          	jalr	844(ra) # 8000611c <initlock>
      p->state = UNUSED;
    80000dd8:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ddc:	415487b3          	sub	a5,s1,s5
    80000de0:	878d                	srai	a5,a5,0x3
    80000de2:	000a3703          	ld	a4,0(s4)
    80000de6:	02e787b3          	mul	a5,a5,a4
    80000dea:	2785                	addiw	a5,a5,1
    80000dec:	00d7979b          	slliw	a5,a5,0xd
    80000df0:	40f907b3          	sub	a5,s2,a5
    80000df4:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df6:	16848493          	addi	s1,s1,360
    80000dfa:	fd3499e3          	bne	s1,s3,80000dcc <procinit+0x6e>
  }
}
    80000dfe:	70e2                	ld	ra,56(sp)
    80000e00:	7442                	ld	s0,48(sp)
    80000e02:	74a2                	ld	s1,40(sp)
    80000e04:	7902                	ld	s2,32(sp)
    80000e06:	69e2                	ld	s3,24(sp)
    80000e08:	6a42                	ld	s4,16(sp)
    80000e0a:	6aa2                	ld	s5,8(sp)
    80000e0c:	6b02                	ld	s6,0(sp)
    80000e0e:	6121                	addi	sp,sp,64
    80000e10:	8082                	ret

0000000080000e12 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e12:	1141                	addi	sp,sp,-16
    80000e14:	e422                	sd	s0,8(sp)
    80000e16:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e18:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e1a:	2501                	sext.w	a0,a0
    80000e1c:	6422                	ld	s0,8(sp)
    80000e1e:	0141                	addi	sp,sp,16
    80000e20:	8082                	ret

0000000080000e22 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e22:	1141                	addi	sp,sp,-16
    80000e24:	e422                	sd	s0,8(sp)
    80000e26:	0800                	addi	s0,sp,16
    80000e28:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e2a:	2781                	sext.w	a5,a5
    80000e2c:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e2e:	00008517          	auipc	a0,0x8
    80000e32:	b1250513          	addi	a0,a0,-1262 # 80008940 <cpus>
    80000e36:	953e                	add	a0,a0,a5
    80000e38:	6422                	ld	s0,8(sp)
    80000e3a:	0141                	addi	sp,sp,16
    80000e3c:	8082                	ret

0000000080000e3e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e3e:	1101                	addi	sp,sp,-32
    80000e40:	ec06                	sd	ra,24(sp)
    80000e42:	e822                	sd	s0,16(sp)
    80000e44:	e426                	sd	s1,8(sp)
    80000e46:	1000                	addi	s0,sp,32
  push_off();
    80000e48:	00005097          	auipc	ra,0x5
    80000e4c:	318080e7          	jalr	792(ra) # 80006160 <push_off>
    80000e50:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e52:	2781                	sext.w	a5,a5
    80000e54:	079e                	slli	a5,a5,0x7
    80000e56:	00008717          	auipc	a4,0x8
    80000e5a:	aba70713          	addi	a4,a4,-1350 # 80008910 <pid_lock>
    80000e5e:	97ba                	add	a5,a5,a4
    80000e60:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e62:	00005097          	auipc	ra,0x5
    80000e66:	39e080e7          	jalr	926(ra) # 80006200 <pop_off>
  return p;
}
    80000e6a:	8526                	mv	a0,s1
    80000e6c:	60e2                	ld	ra,24(sp)
    80000e6e:	6442                	ld	s0,16(sp)
    80000e70:	64a2                	ld	s1,8(sp)
    80000e72:	6105                	addi	sp,sp,32
    80000e74:	8082                	ret

0000000080000e76 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e76:	1141                	addi	sp,sp,-16
    80000e78:	e406                	sd	ra,8(sp)
    80000e7a:	e022                	sd	s0,0(sp)
    80000e7c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e7e:	00000097          	auipc	ra,0x0
    80000e82:	fc0080e7          	jalr	-64(ra) # 80000e3e <myproc>
    80000e86:	00005097          	auipc	ra,0x5
    80000e8a:	3da080e7          	jalr	986(ra) # 80006260 <release>

  if (first) {
    80000e8e:	00008797          	auipc	a5,0x8
    80000e92:	9c27a783          	lw	a5,-1598(a5) # 80008850 <first.1684>
    80000e96:	eb89                	bnez	a5,80000ea8 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e98:	00001097          	auipc	ra,0x1
    80000e9c:	c56080e7          	jalr	-938(ra) # 80001aee <usertrapret>
}
    80000ea0:	60a2                	ld	ra,8(sp)
    80000ea2:	6402                	ld	s0,0(sp)
    80000ea4:	0141                	addi	sp,sp,16
    80000ea6:	8082                	ret
    first = 0;
    80000ea8:	00008797          	auipc	a5,0x8
    80000eac:	9a07a423          	sw	zero,-1624(a5) # 80008850 <first.1684>
    fsinit(ROOTDEV);
    80000eb0:	4505                	li	a0,1
    80000eb2:	00002097          	auipc	ra,0x2
    80000eb6:	9c0080e7          	jalr	-1600(ra) # 80002872 <fsinit>
    80000eba:	bff9                	j	80000e98 <forkret+0x22>

0000000080000ebc <allocpid>:
{
    80000ebc:	1101                	addi	sp,sp,-32
    80000ebe:	ec06                	sd	ra,24(sp)
    80000ec0:	e822                	sd	s0,16(sp)
    80000ec2:	e426                	sd	s1,8(sp)
    80000ec4:	e04a                	sd	s2,0(sp)
    80000ec6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ec8:	00008917          	auipc	s2,0x8
    80000ecc:	a4890913          	addi	s2,s2,-1464 # 80008910 <pid_lock>
    80000ed0:	854a                	mv	a0,s2
    80000ed2:	00005097          	auipc	ra,0x5
    80000ed6:	2da080e7          	jalr	730(ra) # 800061ac <acquire>
  pid = nextpid;
    80000eda:	00008797          	auipc	a5,0x8
    80000ede:	97a78793          	addi	a5,a5,-1670 # 80008854 <nextpid>
    80000ee2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ee4:	0014871b          	addiw	a4,s1,1
    80000ee8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000eea:	854a                	mv	a0,s2
    80000eec:	00005097          	auipc	ra,0x5
    80000ef0:	374080e7          	jalr	884(ra) # 80006260 <release>
}
    80000ef4:	8526                	mv	a0,s1
    80000ef6:	60e2                	ld	ra,24(sp)
    80000ef8:	6442                	ld	s0,16(sp)
    80000efa:	64a2                	ld	s1,8(sp)
    80000efc:	6902                	ld	s2,0(sp)
    80000efe:	6105                	addi	sp,sp,32
    80000f00:	8082                	ret

0000000080000f02 <proc_pagetable>:
{
    80000f02:	1101                	addi	sp,sp,-32
    80000f04:	ec06                	sd	ra,24(sp)
    80000f06:	e822                	sd	s0,16(sp)
    80000f08:	e426                	sd	s1,8(sp)
    80000f0a:	e04a                	sd	s2,0(sp)
    80000f0c:	1000                	addi	s0,sp,32
    80000f0e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f10:	00000097          	auipc	ra,0x0
    80000f14:	8b8080e7          	jalr	-1864(ra) # 800007c8 <uvmcreate>
    80000f18:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f1a:	c121                	beqz	a0,80000f5a <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f1c:	4729                	li	a4,10
    80000f1e:	00006697          	auipc	a3,0x6
    80000f22:	0e268693          	addi	a3,a3,226 # 80007000 <_trampoline>
    80000f26:	6605                	lui	a2,0x1
    80000f28:	040005b7          	lui	a1,0x4000
    80000f2c:	15fd                	addi	a1,a1,-1
    80000f2e:	05b2                	slli	a1,a1,0xc
    80000f30:	fffff097          	auipc	ra,0xfffff
    80000f34:	61c080e7          	jalr	1564(ra) # 8000054c <mappages>
    80000f38:	02054863          	bltz	a0,80000f68 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f3c:	4719                	li	a4,6
    80000f3e:	05893683          	ld	a3,88(s2)
    80000f42:	6605                	lui	a2,0x1
    80000f44:	020005b7          	lui	a1,0x2000
    80000f48:	15fd                	addi	a1,a1,-1
    80000f4a:	05b6                	slli	a1,a1,0xd
    80000f4c:	8526                	mv	a0,s1
    80000f4e:	fffff097          	auipc	ra,0xfffff
    80000f52:	5fe080e7          	jalr	1534(ra) # 8000054c <mappages>
    80000f56:	02054163          	bltz	a0,80000f78 <proc_pagetable+0x76>
}
    80000f5a:	8526                	mv	a0,s1
    80000f5c:	60e2                	ld	ra,24(sp)
    80000f5e:	6442                	ld	s0,16(sp)
    80000f60:	64a2                	ld	s1,8(sp)
    80000f62:	6902                	ld	s2,0(sp)
    80000f64:	6105                	addi	sp,sp,32
    80000f66:	8082                	ret
    uvmfree(pagetable, 0);
    80000f68:	4581                	li	a1,0
    80000f6a:	8526                	mv	a0,s1
    80000f6c:	00000097          	auipc	ra,0x0
    80000f70:	a60080e7          	jalr	-1440(ra) # 800009cc <uvmfree>
    return 0;
    80000f74:	4481                	li	s1,0
    80000f76:	b7d5                	j	80000f5a <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f78:	4681                	li	a3,0
    80000f7a:	4605                	li	a2,1
    80000f7c:	040005b7          	lui	a1,0x4000
    80000f80:	15fd                	addi	a1,a1,-1
    80000f82:	05b2                	slli	a1,a1,0xc
    80000f84:	8526                	mv	a0,s1
    80000f86:	fffff097          	auipc	ra,0xfffff
    80000f8a:	78c080e7          	jalr	1932(ra) # 80000712 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f8e:	4581                	li	a1,0
    80000f90:	8526                	mv	a0,s1
    80000f92:	00000097          	auipc	ra,0x0
    80000f96:	a3a080e7          	jalr	-1478(ra) # 800009cc <uvmfree>
    return 0;
    80000f9a:	4481                	li	s1,0
    80000f9c:	bf7d                	j	80000f5a <proc_pagetable+0x58>

0000000080000f9e <proc_freepagetable>:
{
    80000f9e:	1101                	addi	sp,sp,-32
    80000fa0:	ec06                	sd	ra,24(sp)
    80000fa2:	e822                	sd	s0,16(sp)
    80000fa4:	e426                	sd	s1,8(sp)
    80000fa6:	e04a                	sd	s2,0(sp)
    80000fa8:	1000                	addi	s0,sp,32
    80000faa:	84aa                	mv	s1,a0
    80000fac:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fae:	4681                	li	a3,0
    80000fb0:	4605                	li	a2,1
    80000fb2:	040005b7          	lui	a1,0x4000
    80000fb6:	15fd                	addi	a1,a1,-1
    80000fb8:	05b2                	slli	a1,a1,0xc
    80000fba:	fffff097          	auipc	ra,0xfffff
    80000fbe:	758080e7          	jalr	1880(ra) # 80000712 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fc2:	4681                	li	a3,0
    80000fc4:	4605                	li	a2,1
    80000fc6:	020005b7          	lui	a1,0x2000
    80000fca:	15fd                	addi	a1,a1,-1
    80000fcc:	05b6                	slli	a1,a1,0xd
    80000fce:	8526                	mv	a0,s1
    80000fd0:	fffff097          	auipc	ra,0xfffff
    80000fd4:	742080e7          	jalr	1858(ra) # 80000712 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fd8:	85ca                	mv	a1,s2
    80000fda:	8526                	mv	a0,s1
    80000fdc:	00000097          	auipc	ra,0x0
    80000fe0:	9f0080e7          	jalr	-1552(ra) # 800009cc <uvmfree>
}
    80000fe4:	60e2                	ld	ra,24(sp)
    80000fe6:	6442                	ld	s0,16(sp)
    80000fe8:	64a2                	ld	s1,8(sp)
    80000fea:	6902                	ld	s2,0(sp)
    80000fec:	6105                	addi	sp,sp,32
    80000fee:	8082                	ret

0000000080000ff0 <freeproc>:
{
    80000ff0:	1101                	addi	sp,sp,-32
    80000ff2:	ec06                	sd	ra,24(sp)
    80000ff4:	e822                	sd	s0,16(sp)
    80000ff6:	e426                	sd	s1,8(sp)
    80000ff8:	1000                	addi	s0,sp,32
    80000ffa:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000ffc:	6d28                	ld	a0,88(a0)
    80000ffe:	c509                	beqz	a0,80001008 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001000:	fffff097          	auipc	ra,0xfffff
    80001004:	01c080e7          	jalr	28(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001008:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000100c:	68a8                	ld	a0,80(s1)
    8000100e:	c511                	beqz	a0,8000101a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001010:	64ac                	ld	a1,72(s1)
    80001012:	00000097          	auipc	ra,0x0
    80001016:	f8c080e7          	jalr	-116(ra) # 80000f9e <proc_freepagetable>
  p->pagetable = 0;
    8000101a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000101e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001022:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001026:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000102a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000102e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001032:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001036:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000103a:	0004ac23          	sw	zero,24(s1)
}
    8000103e:	60e2                	ld	ra,24(sp)
    80001040:	6442                	ld	s0,16(sp)
    80001042:	64a2                	ld	s1,8(sp)
    80001044:	6105                	addi	sp,sp,32
    80001046:	8082                	ret

0000000080001048 <allocproc>:
{
    80001048:	1101                	addi	sp,sp,-32
    8000104a:	ec06                	sd	ra,24(sp)
    8000104c:	e822                	sd	s0,16(sp)
    8000104e:	e426                	sd	s1,8(sp)
    80001050:	e04a                	sd	s2,0(sp)
    80001052:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001054:	00008497          	auipc	s1,0x8
    80001058:	cec48493          	addi	s1,s1,-788 # 80008d40 <proc>
    8000105c:	0000d917          	auipc	s2,0xd
    80001060:	6e490913          	addi	s2,s2,1764 # 8000e740 <tickslock>
    acquire(&p->lock);
    80001064:	8526                	mv	a0,s1
    80001066:	00005097          	auipc	ra,0x5
    8000106a:	146080e7          	jalr	326(ra) # 800061ac <acquire>
    if(p->state == UNUSED) {
    8000106e:	4c9c                	lw	a5,24(s1)
    80001070:	cf81                	beqz	a5,80001088 <allocproc+0x40>
      release(&p->lock);
    80001072:	8526                	mv	a0,s1
    80001074:	00005097          	auipc	ra,0x5
    80001078:	1ec080e7          	jalr	492(ra) # 80006260 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000107c:	16848493          	addi	s1,s1,360
    80001080:	ff2492e3          	bne	s1,s2,80001064 <allocproc+0x1c>
  return 0;
    80001084:	4481                	li	s1,0
    80001086:	a889                	j	800010d8 <allocproc+0x90>
  p->pid = allocpid();
    80001088:	00000097          	auipc	ra,0x0
    8000108c:	e34080e7          	jalr	-460(ra) # 80000ebc <allocpid>
    80001090:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001092:	4785                	li	a5,1
    80001094:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001096:	fffff097          	auipc	ra,0xfffff
    8000109a:	082080e7          	jalr	130(ra) # 80000118 <kalloc>
    8000109e:	892a                	mv	s2,a0
    800010a0:	eca8                	sd	a0,88(s1)
    800010a2:	c131                	beqz	a0,800010e6 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010a4:	8526                	mv	a0,s1
    800010a6:	00000097          	auipc	ra,0x0
    800010aa:	e5c080e7          	jalr	-420(ra) # 80000f02 <proc_pagetable>
    800010ae:	892a                	mv	s2,a0
    800010b0:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010b2:	c531                	beqz	a0,800010fe <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010b4:	07000613          	li	a2,112
    800010b8:	4581                	li	a1,0
    800010ba:	06048513          	addi	a0,s1,96
    800010be:	fffff097          	auipc	ra,0xfffff
    800010c2:	0ba080e7          	jalr	186(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010c6:	00000797          	auipc	a5,0x0
    800010ca:	db078793          	addi	a5,a5,-592 # 80000e76 <forkret>
    800010ce:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010d0:	60bc                	ld	a5,64(s1)
    800010d2:	6705                	lui	a4,0x1
    800010d4:	97ba                	add	a5,a5,a4
    800010d6:	f4bc                	sd	a5,104(s1)
}
    800010d8:	8526                	mv	a0,s1
    800010da:	60e2                	ld	ra,24(sp)
    800010dc:	6442                	ld	s0,16(sp)
    800010de:	64a2                	ld	s1,8(sp)
    800010e0:	6902                	ld	s2,0(sp)
    800010e2:	6105                	addi	sp,sp,32
    800010e4:	8082                	ret
    freeproc(p);
    800010e6:	8526                	mv	a0,s1
    800010e8:	00000097          	auipc	ra,0x0
    800010ec:	f08080e7          	jalr	-248(ra) # 80000ff0 <freeproc>
    release(&p->lock);
    800010f0:	8526                	mv	a0,s1
    800010f2:	00005097          	auipc	ra,0x5
    800010f6:	16e080e7          	jalr	366(ra) # 80006260 <release>
    return 0;
    800010fa:	84ca                	mv	s1,s2
    800010fc:	bff1                	j	800010d8 <allocproc+0x90>
    freeproc(p);
    800010fe:	8526                	mv	a0,s1
    80001100:	00000097          	auipc	ra,0x0
    80001104:	ef0080e7          	jalr	-272(ra) # 80000ff0 <freeproc>
    release(&p->lock);
    80001108:	8526                	mv	a0,s1
    8000110a:	00005097          	auipc	ra,0x5
    8000110e:	156080e7          	jalr	342(ra) # 80006260 <release>
    return 0;
    80001112:	84ca                	mv	s1,s2
    80001114:	b7d1                	j	800010d8 <allocproc+0x90>

0000000080001116 <userinit>:
{
    80001116:	1101                	addi	sp,sp,-32
    80001118:	ec06                	sd	ra,24(sp)
    8000111a:	e822                	sd	s0,16(sp)
    8000111c:	e426                	sd	s1,8(sp)
    8000111e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001120:	00000097          	auipc	ra,0x0
    80001124:	f28080e7          	jalr	-216(ra) # 80001048 <allocproc>
    80001128:	84aa                	mv	s1,a0
  initproc = p;
    8000112a:	00007797          	auipc	a5,0x7
    8000112e:	7aa7b323          	sd	a0,1958(a5) # 800088d0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001132:	03400613          	li	a2,52
    80001136:	00007597          	auipc	a1,0x7
    8000113a:	72a58593          	addi	a1,a1,1834 # 80008860 <initcode>
    8000113e:	6928                	ld	a0,80(a0)
    80001140:	fffff097          	auipc	ra,0xfffff
    80001144:	6b6080e7          	jalr	1718(ra) # 800007f6 <uvmfirst>
  p->sz = PGSIZE;
    80001148:	6785                	lui	a5,0x1
    8000114a:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000114c:	6cb8                	ld	a4,88(s1)
    8000114e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001152:	6cb8                	ld	a4,88(s1)
    80001154:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001156:	4641                	li	a2,16
    80001158:	00007597          	auipc	a1,0x7
    8000115c:	ff058593          	addi	a1,a1,-16 # 80008148 <etext+0x148>
    80001160:	15848513          	addi	a0,s1,344
    80001164:	fffff097          	auipc	ra,0xfffff
    80001168:	166080e7          	jalr	358(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    8000116c:	00007517          	auipc	a0,0x7
    80001170:	fec50513          	addi	a0,a0,-20 # 80008158 <etext+0x158>
    80001174:	00002097          	auipc	ra,0x2
    80001178:	120080e7          	jalr	288(ra) # 80003294 <namei>
    8000117c:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001180:	478d                	li	a5,3
    80001182:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001184:	8526                	mv	a0,s1
    80001186:	00005097          	auipc	ra,0x5
    8000118a:	0da080e7          	jalr	218(ra) # 80006260 <release>
}
    8000118e:	60e2                	ld	ra,24(sp)
    80001190:	6442                	ld	s0,16(sp)
    80001192:	64a2                	ld	s1,8(sp)
    80001194:	6105                	addi	sp,sp,32
    80001196:	8082                	ret

0000000080001198 <growproc>:
{
    80001198:	1101                	addi	sp,sp,-32
    8000119a:	ec06                	sd	ra,24(sp)
    8000119c:	e822                	sd	s0,16(sp)
    8000119e:	e426                	sd	s1,8(sp)
    800011a0:	e04a                	sd	s2,0(sp)
    800011a2:	1000                	addi	s0,sp,32
    800011a4:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011a6:	00000097          	auipc	ra,0x0
    800011aa:	c98080e7          	jalr	-872(ra) # 80000e3e <myproc>
    800011ae:	84aa                	mv	s1,a0
  sz = p->sz;
    800011b0:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011b2:	01204c63          	bgtz	s2,800011ca <growproc+0x32>
  } else if(n < 0){
    800011b6:	02094663          	bltz	s2,800011e2 <growproc+0x4a>
  p->sz = sz;
    800011ba:	e4ac                	sd	a1,72(s1)
  return 0;
    800011bc:	4501                	li	a0,0
}
    800011be:	60e2                	ld	ra,24(sp)
    800011c0:	6442                	ld	s0,16(sp)
    800011c2:	64a2                	ld	s1,8(sp)
    800011c4:	6902                	ld	s2,0(sp)
    800011c6:	6105                	addi	sp,sp,32
    800011c8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011ca:	4691                	li	a3,4
    800011cc:	00b90633          	add	a2,s2,a1
    800011d0:	6928                	ld	a0,80(a0)
    800011d2:	fffff097          	auipc	ra,0xfffff
    800011d6:	6de080e7          	jalr	1758(ra) # 800008b0 <uvmalloc>
    800011da:	85aa                	mv	a1,a0
    800011dc:	fd79                	bnez	a0,800011ba <growproc+0x22>
      return -1;
    800011de:	557d                	li	a0,-1
    800011e0:	bff9                	j	800011be <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011e2:	00b90633          	add	a2,s2,a1
    800011e6:	6928                	ld	a0,80(a0)
    800011e8:	fffff097          	auipc	ra,0xfffff
    800011ec:	680080e7          	jalr	1664(ra) # 80000868 <uvmdealloc>
    800011f0:	85aa                	mv	a1,a0
    800011f2:	b7e1                	j	800011ba <growproc+0x22>

00000000800011f4 <fork>:
{
    800011f4:	7179                	addi	sp,sp,-48
    800011f6:	f406                	sd	ra,40(sp)
    800011f8:	f022                	sd	s0,32(sp)
    800011fa:	ec26                	sd	s1,24(sp)
    800011fc:	e84a                	sd	s2,16(sp)
    800011fe:	e44e                	sd	s3,8(sp)
    80001200:	e052                	sd	s4,0(sp)
    80001202:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001204:	00000097          	auipc	ra,0x0
    80001208:	c3a080e7          	jalr	-966(ra) # 80000e3e <myproc>
    8000120c:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000120e:	00000097          	auipc	ra,0x0
    80001212:	e3a080e7          	jalr	-454(ra) # 80001048 <allocproc>
    80001216:	10050b63          	beqz	a0,8000132c <fork+0x138>
    8000121a:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000121c:	04893603          	ld	a2,72(s2)
    80001220:	692c                	ld	a1,80(a0)
    80001222:	05093503          	ld	a0,80(s2)
    80001226:	fffff097          	auipc	ra,0xfffff
    8000122a:	7de080e7          	jalr	2014(ra) # 80000a04 <uvmcopy>
    8000122e:	04054663          	bltz	a0,8000127a <fork+0x86>
  np->sz = p->sz;
    80001232:	04893783          	ld	a5,72(s2)
    80001236:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000123a:	05893683          	ld	a3,88(s2)
    8000123e:	87b6                	mv	a5,a3
    80001240:	0589b703          	ld	a4,88(s3)
    80001244:	12068693          	addi	a3,a3,288
    80001248:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000124c:	6788                	ld	a0,8(a5)
    8000124e:	6b8c                	ld	a1,16(a5)
    80001250:	6f90                	ld	a2,24(a5)
    80001252:	01073023          	sd	a6,0(a4)
    80001256:	e708                	sd	a0,8(a4)
    80001258:	eb0c                	sd	a1,16(a4)
    8000125a:	ef10                	sd	a2,24(a4)
    8000125c:	02078793          	addi	a5,a5,32
    80001260:	02070713          	addi	a4,a4,32
    80001264:	fed792e3          	bne	a5,a3,80001248 <fork+0x54>
  np->trapframe->a0 = 0;
    80001268:	0589b783          	ld	a5,88(s3)
    8000126c:	0607b823          	sd	zero,112(a5)
    80001270:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001274:	15000a13          	li	s4,336
    80001278:	a03d                	j	800012a6 <fork+0xb2>
    freeproc(np);
    8000127a:	854e                	mv	a0,s3
    8000127c:	00000097          	auipc	ra,0x0
    80001280:	d74080e7          	jalr	-652(ra) # 80000ff0 <freeproc>
    release(&np->lock);
    80001284:	854e                	mv	a0,s3
    80001286:	00005097          	auipc	ra,0x5
    8000128a:	fda080e7          	jalr	-38(ra) # 80006260 <release>
    return -1;
    8000128e:	5a7d                	li	s4,-1
    80001290:	a069                	j	8000131a <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001292:	00002097          	auipc	ra,0x2
    80001296:	698080e7          	jalr	1688(ra) # 8000392a <filedup>
    8000129a:	009987b3          	add	a5,s3,s1
    8000129e:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012a0:	04a1                	addi	s1,s1,8
    800012a2:	01448763          	beq	s1,s4,800012b0 <fork+0xbc>
    if(p->ofile[i])
    800012a6:	009907b3          	add	a5,s2,s1
    800012aa:	6388                	ld	a0,0(a5)
    800012ac:	f17d                	bnez	a0,80001292 <fork+0x9e>
    800012ae:	bfcd                	j	800012a0 <fork+0xac>
  np->cwd = idup(p->cwd);
    800012b0:	15093503          	ld	a0,336(s2)
    800012b4:	00001097          	auipc	ra,0x1
    800012b8:	7fc080e7          	jalr	2044(ra) # 80002ab0 <idup>
    800012bc:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012c0:	4641                	li	a2,16
    800012c2:	15890593          	addi	a1,s2,344
    800012c6:	15898513          	addi	a0,s3,344
    800012ca:	fffff097          	auipc	ra,0xfffff
    800012ce:	000080e7          	jalr	ra # 800002ca <safestrcpy>
  pid = np->pid;
    800012d2:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800012d6:	854e                	mv	a0,s3
    800012d8:	00005097          	auipc	ra,0x5
    800012dc:	f88080e7          	jalr	-120(ra) # 80006260 <release>
  acquire(&wait_lock);
    800012e0:	00007497          	auipc	s1,0x7
    800012e4:	64848493          	addi	s1,s1,1608 # 80008928 <wait_lock>
    800012e8:	8526                	mv	a0,s1
    800012ea:	00005097          	auipc	ra,0x5
    800012ee:	ec2080e7          	jalr	-318(ra) # 800061ac <acquire>
  np->parent = p;
    800012f2:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    800012f6:	8526                	mv	a0,s1
    800012f8:	00005097          	auipc	ra,0x5
    800012fc:	f68080e7          	jalr	-152(ra) # 80006260 <release>
  acquire(&np->lock);
    80001300:	854e                	mv	a0,s3
    80001302:	00005097          	auipc	ra,0x5
    80001306:	eaa080e7          	jalr	-342(ra) # 800061ac <acquire>
  np->state = RUNNABLE;
    8000130a:	478d                	li	a5,3
    8000130c:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001310:	854e                	mv	a0,s3
    80001312:	00005097          	auipc	ra,0x5
    80001316:	f4e080e7          	jalr	-178(ra) # 80006260 <release>
}
    8000131a:	8552                	mv	a0,s4
    8000131c:	70a2                	ld	ra,40(sp)
    8000131e:	7402                	ld	s0,32(sp)
    80001320:	64e2                	ld	s1,24(sp)
    80001322:	6942                	ld	s2,16(sp)
    80001324:	69a2                	ld	s3,8(sp)
    80001326:	6a02                	ld	s4,0(sp)
    80001328:	6145                	addi	sp,sp,48
    8000132a:	8082                	ret
    return -1;
    8000132c:	5a7d                	li	s4,-1
    8000132e:	b7f5                	j	8000131a <fork+0x126>

0000000080001330 <scheduler>:
{
    80001330:	7139                	addi	sp,sp,-64
    80001332:	fc06                	sd	ra,56(sp)
    80001334:	f822                	sd	s0,48(sp)
    80001336:	f426                	sd	s1,40(sp)
    80001338:	f04a                	sd	s2,32(sp)
    8000133a:	ec4e                	sd	s3,24(sp)
    8000133c:	e852                	sd	s4,16(sp)
    8000133e:	e456                	sd	s5,8(sp)
    80001340:	e05a                	sd	s6,0(sp)
    80001342:	0080                	addi	s0,sp,64
    80001344:	8792                	mv	a5,tp
  int id = r_tp();
    80001346:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001348:	00779a93          	slli	s5,a5,0x7
    8000134c:	00007717          	auipc	a4,0x7
    80001350:	5c470713          	addi	a4,a4,1476 # 80008910 <pid_lock>
    80001354:	9756                	add	a4,a4,s5
    80001356:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000135a:	00007717          	auipc	a4,0x7
    8000135e:	5ee70713          	addi	a4,a4,1518 # 80008948 <cpus+0x8>
    80001362:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001364:	498d                	li	s3,3
        p->state = RUNNING;
    80001366:	4b11                	li	s6,4
        c->proc = p;
    80001368:	079e                	slli	a5,a5,0x7
    8000136a:	00007a17          	auipc	s4,0x7
    8000136e:	5a6a0a13          	addi	s4,s4,1446 # 80008910 <pid_lock>
    80001372:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001374:	0000d917          	auipc	s2,0xd
    80001378:	3cc90913          	addi	s2,s2,972 # 8000e740 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000137c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001380:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001384:	10079073          	csrw	sstatus,a5
    80001388:	00008497          	auipc	s1,0x8
    8000138c:	9b848493          	addi	s1,s1,-1608 # 80008d40 <proc>
    80001390:	a03d                	j	800013be <scheduler+0x8e>
        p->state = RUNNING;
    80001392:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001396:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000139a:	06048593          	addi	a1,s1,96
    8000139e:	8556                	mv	a0,s5
    800013a0:	00000097          	auipc	ra,0x0
    800013a4:	6a4080e7          	jalr	1700(ra) # 80001a44 <swtch>
        c->proc = 0;
    800013a8:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013ac:	8526                	mv	a0,s1
    800013ae:	00005097          	auipc	ra,0x5
    800013b2:	eb2080e7          	jalr	-334(ra) # 80006260 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013b6:	16848493          	addi	s1,s1,360
    800013ba:	fd2481e3          	beq	s1,s2,8000137c <scheduler+0x4c>
      acquire(&p->lock);
    800013be:	8526                	mv	a0,s1
    800013c0:	00005097          	auipc	ra,0x5
    800013c4:	dec080e7          	jalr	-532(ra) # 800061ac <acquire>
      if(p->state == RUNNABLE) {
    800013c8:	4c9c                	lw	a5,24(s1)
    800013ca:	ff3791e3          	bne	a5,s3,800013ac <scheduler+0x7c>
    800013ce:	b7d1                	j	80001392 <scheduler+0x62>

00000000800013d0 <sched>:
{
    800013d0:	7179                	addi	sp,sp,-48
    800013d2:	f406                	sd	ra,40(sp)
    800013d4:	f022                	sd	s0,32(sp)
    800013d6:	ec26                	sd	s1,24(sp)
    800013d8:	e84a                	sd	s2,16(sp)
    800013da:	e44e                	sd	s3,8(sp)
    800013dc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013de:	00000097          	auipc	ra,0x0
    800013e2:	a60080e7          	jalr	-1440(ra) # 80000e3e <myproc>
    800013e6:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800013e8:	00005097          	auipc	ra,0x5
    800013ec:	d4a080e7          	jalr	-694(ra) # 80006132 <holding>
    800013f0:	c93d                	beqz	a0,80001466 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800013f2:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800013f4:	2781                	sext.w	a5,a5
    800013f6:	079e                	slli	a5,a5,0x7
    800013f8:	00007717          	auipc	a4,0x7
    800013fc:	51870713          	addi	a4,a4,1304 # 80008910 <pid_lock>
    80001400:	97ba                	add	a5,a5,a4
    80001402:	0a87a703          	lw	a4,168(a5)
    80001406:	4785                	li	a5,1
    80001408:	06f71763          	bne	a4,a5,80001476 <sched+0xa6>
  if(p->state == RUNNING)
    8000140c:	4c98                	lw	a4,24(s1)
    8000140e:	4791                	li	a5,4
    80001410:	06f70b63          	beq	a4,a5,80001486 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001414:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001418:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000141a:	efb5                	bnez	a5,80001496 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000141c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000141e:	00007917          	auipc	s2,0x7
    80001422:	4f290913          	addi	s2,s2,1266 # 80008910 <pid_lock>
    80001426:	2781                	sext.w	a5,a5
    80001428:	079e                	slli	a5,a5,0x7
    8000142a:	97ca                	add	a5,a5,s2
    8000142c:	0ac7a983          	lw	s3,172(a5)
    80001430:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001432:	2781                	sext.w	a5,a5
    80001434:	079e                	slli	a5,a5,0x7
    80001436:	00007597          	auipc	a1,0x7
    8000143a:	51258593          	addi	a1,a1,1298 # 80008948 <cpus+0x8>
    8000143e:	95be                	add	a1,a1,a5
    80001440:	06048513          	addi	a0,s1,96
    80001444:	00000097          	auipc	ra,0x0
    80001448:	600080e7          	jalr	1536(ra) # 80001a44 <swtch>
    8000144c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000144e:	2781                	sext.w	a5,a5
    80001450:	079e                	slli	a5,a5,0x7
    80001452:	97ca                	add	a5,a5,s2
    80001454:	0b37a623          	sw	s3,172(a5)
}
    80001458:	70a2                	ld	ra,40(sp)
    8000145a:	7402                	ld	s0,32(sp)
    8000145c:	64e2                	ld	s1,24(sp)
    8000145e:	6942                	ld	s2,16(sp)
    80001460:	69a2                	ld	s3,8(sp)
    80001462:	6145                	addi	sp,sp,48
    80001464:	8082                	ret
    panic("sched p->lock");
    80001466:	00007517          	auipc	a0,0x7
    8000146a:	cfa50513          	addi	a0,a0,-774 # 80008160 <etext+0x160>
    8000146e:	00004097          	auipc	ra,0x4
    80001472:	7f4080e7          	jalr	2036(ra) # 80005c62 <panic>
    panic("sched locks");
    80001476:	00007517          	auipc	a0,0x7
    8000147a:	cfa50513          	addi	a0,a0,-774 # 80008170 <etext+0x170>
    8000147e:	00004097          	auipc	ra,0x4
    80001482:	7e4080e7          	jalr	2020(ra) # 80005c62 <panic>
    panic("sched running");
    80001486:	00007517          	auipc	a0,0x7
    8000148a:	cfa50513          	addi	a0,a0,-774 # 80008180 <etext+0x180>
    8000148e:	00004097          	auipc	ra,0x4
    80001492:	7d4080e7          	jalr	2004(ra) # 80005c62 <panic>
    panic("sched interruptible");
    80001496:	00007517          	auipc	a0,0x7
    8000149a:	cfa50513          	addi	a0,a0,-774 # 80008190 <etext+0x190>
    8000149e:	00004097          	auipc	ra,0x4
    800014a2:	7c4080e7          	jalr	1988(ra) # 80005c62 <panic>

00000000800014a6 <yield>:
{
    800014a6:	1101                	addi	sp,sp,-32
    800014a8:	ec06                	sd	ra,24(sp)
    800014aa:	e822                	sd	s0,16(sp)
    800014ac:	e426                	sd	s1,8(sp)
    800014ae:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014b0:	00000097          	auipc	ra,0x0
    800014b4:	98e080e7          	jalr	-1650(ra) # 80000e3e <myproc>
    800014b8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014ba:	00005097          	auipc	ra,0x5
    800014be:	cf2080e7          	jalr	-782(ra) # 800061ac <acquire>
  p->state = RUNNABLE;
    800014c2:	478d                	li	a5,3
    800014c4:	cc9c                	sw	a5,24(s1)
  sched();
    800014c6:	00000097          	auipc	ra,0x0
    800014ca:	f0a080e7          	jalr	-246(ra) # 800013d0 <sched>
  release(&p->lock);
    800014ce:	8526                	mv	a0,s1
    800014d0:	00005097          	auipc	ra,0x5
    800014d4:	d90080e7          	jalr	-624(ra) # 80006260 <release>
}
    800014d8:	60e2                	ld	ra,24(sp)
    800014da:	6442                	ld	s0,16(sp)
    800014dc:	64a2                	ld	s1,8(sp)
    800014de:	6105                	addi	sp,sp,32
    800014e0:	8082                	ret

00000000800014e2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800014e2:	7179                	addi	sp,sp,-48
    800014e4:	f406                	sd	ra,40(sp)
    800014e6:	f022                	sd	s0,32(sp)
    800014e8:	ec26                	sd	s1,24(sp)
    800014ea:	e84a                	sd	s2,16(sp)
    800014ec:	e44e                	sd	s3,8(sp)
    800014ee:	1800                	addi	s0,sp,48
    800014f0:	89aa                	mv	s3,a0
    800014f2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800014f4:	00000097          	auipc	ra,0x0
    800014f8:	94a080e7          	jalr	-1718(ra) # 80000e3e <myproc>
    800014fc:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800014fe:	00005097          	auipc	ra,0x5
    80001502:	cae080e7          	jalr	-850(ra) # 800061ac <acquire>
  release(lk);
    80001506:	854a                	mv	a0,s2
    80001508:	00005097          	auipc	ra,0x5
    8000150c:	d58080e7          	jalr	-680(ra) # 80006260 <release>

  // Go to sleep.
  p->chan = chan;
    80001510:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001514:	4789                	li	a5,2
    80001516:	cc9c                	sw	a5,24(s1)

  sched();
    80001518:	00000097          	auipc	ra,0x0
    8000151c:	eb8080e7          	jalr	-328(ra) # 800013d0 <sched>

  // Tidy up.
  p->chan = 0;
    80001520:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001524:	8526                	mv	a0,s1
    80001526:	00005097          	auipc	ra,0x5
    8000152a:	d3a080e7          	jalr	-710(ra) # 80006260 <release>
  acquire(lk);
    8000152e:	854a                	mv	a0,s2
    80001530:	00005097          	auipc	ra,0x5
    80001534:	c7c080e7          	jalr	-900(ra) # 800061ac <acquire>
}
    80001538:	70a2                	ld	ra,40(sp)
    8000153a:	7402                	ld	s0,32(sp)
    8000153c:	64e2                	ld	s1,24(sp)
    8000153e:	6942                	ld	s2,16(sp)
    80001540:	69a2                	ld	s3,8(sp)
    80001542:	6145                	addi	sp,sp,48
    80001544:	8082                	ret

0000000080001546 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001546:	7139                	addi	sp,sp,-64
    80001548:	fc06                	sd	ra,56(sp)
    8000154a:	f822                	sd	s0,48(sp)
    8000154c:	f426                	sd	s1,40(sp)
    8000154e:	f04a                	sd	s2,32(sp)
    80001550:	ec4e                	sd	s3,24(sp)
    80001552:	e852                	sd	s4,16(sp)
    80001554:	e456                	sd	s5,8(sp)
    80001556:	0080                	addi	s0,sp,64
    80001558:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000155a:	00007497          	auipc	s1,0x7
    8000155e:	7e648493          	addi	s1,s1,2022 # 80008d40 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001562:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001564:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001566:	0000d917          	auipc	s2,0xd
    8000156a:	1da90913          	addi	s2,s2,474 # 8000e740 <tickslock>
    8000156e:	a821                	j	80001586 <wakeup+0x40>
        p->state = RUNNABLE;
    80001570:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001574:	8526                	mv	a0,s1
    80001576:	00005097          	auipc	ra,0x5
    8000157a:	cea080e7          	jalr	-790(ra) # 80006260 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000157e:	16848493          	addi	s1,s1,360
    80001582:	03248463          	beq	s1,s2,800015aa <wakeup+0x64>
    if(p != myproc()){
    80001586:	00000097          	auipc	ra,0x0
    8000158a:	8b8080e7          	jalr	-1864(ra) # 80000e3e <myproc>
    8000158e:	fea488e3          	beq	s1,a0,8000157e <wakeup+0x38>
      acquire(&p->lock);
    80001592:	8526                	mv	a0,s1
    80001594:	00005097          	auipc	ra,0x5
    80001598:	c18080e7          	jalr	-1000(ra) # 800061ac <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000159c:	4c9c                	lw	a5,24(s1)
    8000159e:	fd379be3          	bne	a5,s3,80001574 <wakeup+0x2e>
    800015a2:	709c                	ld	a5,32(s1)
    800015a4:	fd4798e3          	bne	a5,s4,80001574 <wakeup+0x2e>
    800015a8:	b7e1                	j	80001570 <wakeup+0x2a>
    }
  }
}
    800015aa:	70e2                	ld	ra,56(sp)
    800015ac:	7442                	ld	s0,48(sp)
    800015ae:	74a2                	ld	s1,40(sp)
    800015b0:	7902                	ld	s2,32(sp)
    800015b2:	69e2                	ld	s3,24(sp)
    800015b4:	6a42                	ld	s4,16(sp)
    800015b6:	6aa2                	ld	s5,8(sp)
    800015b8:	6121                	addi	sp,sp,64
    800015ba:	8082                	ret

00000000800015bc <reparent>:
{
    800015bc:	7179                	addi	sp,sp,-48
    800015be:	f406                	sd	ra,40(sp)
    800015c0:	f022                	sd	s0,32(sp)
    800015c2:	ec26                	sd	s1,24(sp)
    800015c4:	e84a                	sd	s2,16(sp)
    800015c6:	e44e                	sd	s3,8(sp)
    800015c8:	e052                	sd	s4,0(sp)
    800015ca:	1800                	addi	s0,sp,48
    800015cc:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015ce:	00007497          	auipc	s1,0x7
    800015d2:	77248493          	addi	s1,s1,1906 # 80008d40 <proc>
      pp->parent = initproc;
    800015d6:	00007a17          	auipc	s4,0x7
    800015da:	2faa0a13          	addi	s4,s4,762 # 800088d0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015de:	0000d997          	auipc	s3,0xd
    800015e2:	16298993          	addi	s3,s3,354 # 8000e740 <tickslock>
    800015e6:	a029                	j	800015f0 <reparent+0x34>
    800015e8:	16848493          	addi	s1,s1,360
    800015ec:	01348d63          	beq	s1,s3,80001606 <reparent+0x4a>
    if(pp->parent == p){
    800015f0:	7c9c                	ld	a5,56(s1)
    800015f2:	ff279be3          	bne	a5,s2,800015e8 <reparent+0x2c>
      pp->parent = initproc;
    800015f6:	000a3503          	ld	a0,0(s4)
    800015fa:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800015fc:	00000097          	auipc	ra,0x0
    80001600:	f4a080e7          	jalr	-182(ra) # 80001546 <wakeup>
    80001604:	b7d5                	j	800015e8 <reparent+0x2c>
}
    80001606:	70a2                	ld	ra,40(sp)
    80001608:	7402                	ld	s0,32(sp)
    8000160a:	64e2                	ld	s1,24(sp)
    8000160c:	6942                	ld	s2,16(sp)
    8000160e:	69a2                	ld	s3,8(sp)
    80001610:	6a02                	ld	s4,0(sp)
    80001612:	6145                	addi	sp,sp,48
    80001614:	8082                	ret

0000000080001616 <exit>:
{
    80001616:	7179                	addi	sp,sp,-48
    80001618:	f406                	sd	ra,40(sp)
    8000161a:	f022                	sd	s0,32(sp)
    8000161c:	ec26                	sd	s1,24(sp)
    8000161e:	e84a                	sd	s2,16(sp)
    80001620:	e44e                	sd	s3,8(sp)
    80001622:	e052                	sd	s4,0(sp)
    80001624:	1800                	addi	s0,sp,48
    80001626:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001628:	00000097          	auipc	ra,0x0
    8000162c:	816080e7          	jalr	-2026(ra) # 80000e3e <myproc>
    80001630:	89aa                	mv	s3,a0
  if(p == initproc)
    80001632:	00007797          	auipc	a5,0x7
    80001636:	29e7b783          	ld	a5,670(a5) # 800088d0 <initproc>
    8000163a:	0d050493          	addi	s1,a0,208
    8000163e:	15050913          	addi	s2,a0,336
    80001642:	02a79363          	bne	a5,a0,80001668 <exit+0x52>
    panic("init exiting");
    80001646:	00007517          	auipc	a0,0x7
    8000164a:	b6250513          	addi	a0,a0,-1182 # 800081a8 <etext+0x1a8>
    8000164e:	00004097          	auipc	ra,0x4
    80001652:	614080e7          	jalr	1556(ra) # 80005c62 <panic>
      fileclose(f);
    80001656:	00002097          	auipc	ra,0x2
    8000165a:	326080e7          	jalr	806(ra) # 8000397c <fileclose>
      p->ofile[fd] = 0;
    8000165e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001662:	04a1                	addi	s1,s1,8
    80001664:	01248563          	beq	s1,s2,8000166e <exit+0x58>
    if(p->ofile[fd]){
    80001668:	6088                	ld	a0,0(s1)
    8000166a:	f575                	bnez	a0,80001656 <exit+0x40>
    8000166c:	bfdd                	j	80001662 <exit+0x4c>
  begin_op();
    8000166e:	00002097          	auipc	ra,0x2
    80001672:	e42080e7          	jalr	-446(ra) # 800034b0 <begin_op>
  iput(p->cwd);
    80001676:	1509b503          	ld	a0,336(s3)
    8000167a:	00001097          	auipc	ra,0x1
    8000167e:	62e080e7          	jalr	1582(ra) # 80002ca8 <iput>
  end_op();
    80001682:	00002097          	auipc	ra,0x2
    80001686:	eae080e7          	jalr	-338(ra) # 80003530 <end_op>
  p->cwd = 0;
    8000168a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000168e:	00007497          	auipc	s1,0x7
    80001692:	29a48493          	addi	s1,s1,666 # 80008928 <wait_lock>
    80001696:	8526                	mv	a0,s1
    80001698:	00005097          	auipc	ra,0x5
    8000169c:	b14080e7          	jalr	-1260(ra) # 800061ac <acquire>
  reparent(p);
    800016a0:	854e                	mv	a0,s3
    800016a2:	00000097          	auipc	ra,0x0
    800016a6:	f1a080e7          	jalr	-230(ra) # 800015bc <reparent>
  wakeup(p->parent);
    800016aa:	0389b503          	ld	a0,56(s3)
    800016ae:	00000097          	auipc	ra,0x0
    800016b2:	e98080e7          	jalr	-360(ra) # 80001546 <wakeup>
  acquire(&p->lock);
    800016b6:	854e                	mv	a0,s3
    800016b8:	00005097          	auipc	ra,0x5
    800016bc:	af4080e7          	jalr	-1292(ra) # 800061ac <acquire>
  p->xstate = status;
    800016c0:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016c4:	4795                	li	a5,5
    800016c6:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016ca:	8526                	mv	a0,s1
    800016cc:	00005097          	auipc	ra,0x5
    800016d0:	b94080e7          	jalr	-1132(ra) # 80006260 <release>
  sched();
    800016d4:	00000097          	auipc	ra,0x0
    800016d8:	cfc080e7          	jalr	-772(ra) # 800013d0 <sched>
  panic("zombie exit");
    800016dc:	00007517          	auipc	a0,0x7
    800016e0:	adc50513          	addi	a0,a0,-1316 # 800081b8 <etext+0x1b8>
    800016e4:	00004097          	auipc	ra,0x4
    800016e8:	57e080e7          	jalr	1406(ra) # 80005c62 <panic>

00000000800016ec <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800016ec:	7179                	addi	sp,sp,-48
    800016ee:	f406                	sd	ra,40(sp)
    800016f0:	f022                	sd	s0,32(sp)
    800016f2:	ec26                	sd	s1,24(sp)
    800016f4:	e84a                	sd	s2,16(sp)
    800016f6:	e44e                	sd	s3,8(sp)
    800016f8:	1800                	addi	s0,sp,48
    800016fa:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800016fc:	00007497          	auipc	s1,0x7
    80001700:	64448493          	addi	s1,s1,1604 # 80008d40 <proc>
    80001704:	0000d997          	auipc	s3,0xd
    80001708:	03c98993          	addi	s3,s3,60 # 8000e740 <tickslock>
    acquire(&p->lock);
    8000170c:	8526                	mv	a0,s1
    8000170e:	00005097          	auipc	ra,0x5
    80001712:	a9e080e7          	jalr	-1378(ra) # 800061ac <acquire>
    if(p->pid == pid){
    80001716:	589c                	lw	a5,48(s1)
    80001718:	01278d63          	beq	a5,s2,80001732 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000171c:	8526                	mv	a0,s1
    8000171e:	00005097          	auipc	ra,0x5
    80001722:	b42080e7          	jalr	-1214(ra) # 80006260 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001726:	16848493          	addi	s1,s1,360
    8000172a:	ff3491e3          	bne	s1,s3,8000170c <kill+0x20>
  }
  return -1;
    8000172e:	557d                	li	a0,-1
    80001730:	a829                	j	8000174a <kill+0x5e>
      p->killed = 1;
    80001732:	4785                	li	a5,1
    80001734:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001736:	4c98                	lw	a4,24(s1)
    80001738:	4789                	li	a5,2
    8000173a:	00f70f63          	beq	a4,a5,80001758 <kill+0x6c>
      release(&p->lock);
    8000173e:	8526                	mv	a0,s1
    80001740:	00005097          	auipc	ra,0x5
    80001744:	b20080e7          	jalr	-1248(ra) # 80006260 <release>
      return 0;
    80001748:	4501                	li	a0,0
}
    8000174a:	70a2                	ld	ra,40(sp)
    8000174c:	7402                	ld	s0,32(sp)
    8000174e:	64e2                	ld	s1,24(sp)
    80001750:	6942                	ld	s2,16(sp)
    80001752:	69a2                	ld	s3,8(sp)
    80001754:	6145                	addi	sp,sp,48
    80001756:	8082                	ret
        p->state = RUNNABLE;
    80001758:	478d                	li	a5,3
    8000175a:	cc9c                	sw	a5,24(s1)
    8000175c:	b7cd                	j	8000173e <kill+0x52>

000000008000175e <setkilled>:

void
setkilled(struct proc *p)
{
    8000175e:	1101                	addi	sp,sp,-32
    80001760:	ec06                	sd	ra,24(sp)
    80001762:	e822                	sd	s0,16(sp)
    80001764:	e426                	sd	s1,8(sp)
    80001766:	1000                	addi	s0,sp,32
    80001768:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000176a:	00005097          	auipc	ra,0x5
    8000176e:	a42080e7          	jalr	-1470(ra) # 800061ac <acquire>
  p->killed = 1;
    80001772:	4785                	li	a5,1
    80001774:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001776:	8526                	mv	a0,s1
    80001778:	00005097          	auipc	ra,0x5
    8000177c:	ae8080e7          	jalr	-1304(ra) # 80006260 <release>
}
    80001780:	60e2                	ld	ra,24(sp)
    80001782:	6442                	ld	s0,16(sp)
    80001784:	64a2                	ld	s1,8(sp)
    80001786:	6105                	addi	sp,sp,32
    80001788:	8082                	ret

000000008000178a <killed>:

int
killed(struct proc *p)
{
    8000178a:	1101                	addi	sp,sp,-32
    8000178c:	ec06                	sd	ra,24(sp)
    8000178e:	e822                	sd	s0,16(sp)
    80001790:	e426                	sd	s1,8(sp)
    80001792:	e04a                	sd	s2,0(sp)
    80001794:	1000                	addi	s0,sp,32
    80001796:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001798:	00005097          	auipc	ra,0x5
    8000179c:	a14080e7          	jalr	-1516(ra) # 800061ac <acquire>
  k = p->killed;
    800017a0:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017a4:	8526                	mv	a0,s1
    800017a6:	00005097          	auipc	ra,0x5
    800017aa:	aba080e7          	jalr	-1350(ra) # 80006260 <release>
  return k;
}
    800017ae:	854a                	mv	a0,s2
    800017b0:	60e2                	ld	ra,24(sp)
    800017b2:	6442                	ld	s0,16(sp)
    800017b4:	64a2                	ld	s1,8(sp)
    800017b6:	6902                	ld	s2,0(sp)
    800017b8:	6105                	addi	sp,sp,32
    800017ba:	8082                	ret

00000000800017bc <wait>:
{
    800017bc:	715d                	addi	sp,sp,-80
    800017be:	e486                	sd	ra,72(sp)
    800017c0:	e0a2                	sd	s0,64(sp)
    800017c2:	fc26                	sd	s1,56(sp)
    800017c4:	f84a                	sd	s2,48(sp)
    800017c6:	f44e                	sd	s3,40(sp)
    800017c8:	f052                	sd	s4,32(sp)
    800017ca:	ec56                	sd	s5,24(sp)
    800017cc:	e85a                	sd	s6,16(sp)
    800017ce:	e45e                	sd	s7,8(sp)
    800017d0:	e062                	sd	s8,0(sp)
    800017d2:	0880                	addi	s0,sp,80
    800017d4:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017d6:	fffff097          	auipc	ra,0xfffff
    800017da:	668080e7          	jalr	1640(ra) # 80000e3e <myproc>
    800017de:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017e0:	00007517          	auipc	a0,0x7
    800017e4:	14850513          	addi	a0,a0,328 # 80008928 <wait_lock>
    800017e8:	00005097          	auipc	ra,0x5
    800017ec:	9c4080e7          	jalr	-1596(ra) # 800061ac <acquire>
    havekids = 0;
    800017f0:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800017f2:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800017f4:	0000d997          	auipc	s3,0xd
    800017f8:	f4c98993          	addi	s3,s3,-180 # 8000e740 <tickslock>
        havekids = 1;
    800017fc:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017fe:	00007c17          	auipc	s8,0x7
    80001802:	12ac0c13          	addi	s8,s8,298 # 80008928 <wait_lock>
    havekids = 0;
    80001806:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001808:	00007497          	auipc	s1,0x7
    8000180c:	53848493          	addi	s1,s1,1336 # 80008d40 <proc>
    80001810:	a0bd                	j	8000187e <wait+0xc2>
          pid = pp->pid;
    80001812:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001816:	000b0e63          	beqz	s6,80001832 <wait+0x76>
    8000181a:	4691                	li	a3,4
    8000181c:	02c48613          	addi	a2,s1,44
    80001820:	85da                	mv	a1,s6
    80001822:	05093503          	ld	a0,80(s2)
    80001826:	fffff097          	auipc	ra,0xfffff
    8000182a:	2d6080e7          	jalr	726(ra) # 80000afc <copyout>
    8000182e:	02054563          	bltz	a0,80001858 <wait+0x9c>
          freeproc(pp);
    80001832:	8526                	mv	a0,s1
    80001834:	fffff097          	auipc	ra,0xfffff
    80001838:	7bc080e7          	jalr	1980(ra) # 80000ff0 <freeproc>
          release(&pp->lock);
    8000183c:	8526                	mv	a0,s1
    8000183e:	00005097          	auipc	ra,0x5
    80001842:	a22080e7          	jalr	-1502(ra) # 80006260 <release>
          release(&wait_lock);
    80001846:	00007517          	auipc	a0,0x7
    8000184a:	0e250513          	addi	a0,a0,226 # 80008928 <wait_lock>
    8000184e:	00005097          	auipc	ra,0x5
    80001852:	a12080e7          	jalr	-1518(ra) # 80006260 <release>
          return pid;
    80001856:	a0b5                	j	800018c2 <wait+0x106>
            release(&pp->lock);
    80001858:	8526                	mv	a0,s1
    8000185a:	00005097          	auipc	ra,0x5
    8000185e:	a06080e7          	jalr	-1530(ra) # 80006260 <release>
            release(&wait_lock);
    80001862:	00007517          	auipc	a0,0x7
    80001866:	0c650513          	addi	a0,a0,198 # 80008928 <wait_lock>
    8000186a:	00005097          	auipc	ra,0x5
    8000186e:	9f6080e7          	jalr	-1546(ra) # 80006260 <release>
            return -1;
    80001872:	59fd                	li	s3,-1
    80001874:	a0b9                	j	800018c2 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001876:	16848493          	addi	s1,s1,360
    8000187a:	03348463          	beq	s1,s3,800018a2 <wait+0xe6>
      if(pp->parent == p){
    8000187e:	7c9c                	ld	a5,56(s1)
    80001880:	ff279be3          	bne	a5,s2,80001876 <wait+0xba>
        acquire(&pp->lock);
    80001884:	8526                	mv	a0,s1
    80001886:	00005097          	auipc	ra,0x5
    8000188a:	926080e7          	jalr	-1754(ra) # 800061ac <acquire>
        if(pp->state == ZOMBIE){
    8000188e:	4c9c                	lw	a5,24(s1)
    80001890:	f94781e3          	beq	a5,s4,80001812 <wait+0x56>
        release(&pp->lock);
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	9ca080e7          	jalr	-1590(ra) # 80006260 <release>
        havekids = 1;
    8000189e:	8756                	mv	a4,s5
    800018a0:	bfd9                	j	80001876 <wait+0xba>
    if(!havekids || killed(p)){
    800018a2:	c719                	beqz	a4,800018b0 <wait+0xf4>
    800018a4:	854a                	mv	a0,s2
    800018a6:	00000097          	auipc	ra,0x0
    800018aa:	ee4080e7          	jalr	-284(ra) # 8000178a <killed>
    800018ae:	c51d                	beqz	a0,800018dc <wait+0x120>
      release(&wait_lock);
    800018b0:	00007517          	auipc	a0,0x7
    800018b4:	07850513          	addi	a0,a0,120 # 80008928 <wait_lock>
    800018b8:	00005097          	auipc	ra,0x5
    800018bc:	9a8080e7          	jalr	-1624(ra) # 80006260 <release>
      return -1;
    800018c0:	59fd                	li	s3,-1
}
    800018c2:	854e                	mv	a0,s3
    800018c4:	60a6                	ld	ra,72(sp)
    800018c6:	6406                	ld	s0,64(sp)
    800018c8:	74e2                	ld	s1,56(sp)
    800018ca:	7942                	ld	s2,48(sp)
    800018cc:	79a2                	ld	s3,40(sp)
    800018ce:	7a02                	ld	s4,32(sp)
    800018d0:	6ae2                	ld	s5,24(sp)
    800018d2:	6b42                	ld	s6,16(sp)
    800018d4:	6ba2                	ld	s7,8(sp)
    800018d6:	6c02                	ld	s8,0(sp)
    800018d8:	6161                	addi	sp,sp,80
    800018da:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018dc:	85e2                	mv	a1,s8
    800018de:	854a                	mv	a0,s2
    800018e0:	00000097          	auipc	ra,0x0
    800018e4:	c02080e7          	jalr	-1022(ra) # 800014e2 <sleep>
    havekids = 0;
    800018e8:	bf39                	j	80001806 <wait+0x4a>

00000000800018ea <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018ea:	7179                	addi	sp,sp,-48
    800018ec:	f406                	sd	ra,40(sp)
    800018ee:	f022                	sd	s0,32(sp)
    800018f0:	ec26                	sd	s1,24(sp)
    800018f2:	e84a                	sd	s2,16(sp)
    800018f4:	e44e                	sd	s3,8(sp)
    800018f6:	e052                	sd	s4,0(sp)
    800018f8:	1800                	addi	s0,sp,48
    800018fa:	84aa                	mv	s1,a0
    800018fc:	892e                	mv	s2,a1
    800018fe:	89b2                	mv	s3,a2
    80001900:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001902:	fffff097          	auipc	ra,0xfffff
    80001906:	53c080e7          	jalr	1340(ra) # 80000e3e <myproc>
  if(user_dst){
    8000190a:	c08d                	beqz	s1,8000192c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000190c:	86d2                	mv	a3,s4
    8000190e:	864e                	mv	a2,s3
    80001910:	85ca                	mv	a1,s2
    80001912:	6928                	ld	a0,80(a0)
    80001914:	fffff097          	auipc	ra,0xfffff
    80001918:	1e8080e7          	jalr	488(ra) # 80000afc <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000191c:	70a2                	ld	ra,40(sp)
    8000191e:	7402                	ld	s0,32(sp)
    80001920:	64e2                	ld	s1,24(sp)
    80001922:	6942                	ld	s2,16(sp)
    80001924:	69a2                	ld	s3,8(sp)
    80001926:	6a02                	ld	s4,0(sp)
    80001928:	6145                	addi	sp,sp,48
    8000192a:	8082                	ret
    memmove((char *)dst, src, len);
    8000192c:	000a061b          	sext.w	a2,s4
    80001930:	85ce                	mv	a1,s3
    80001932:	854a                	mv	a0,s2
    80001934:	fffff097          	auipc	ra,0xfffff
    80001938:	8a4080e7          	jalr	-1884(ra) # 800001d8 <memmove>
    return 0;
    8000193c:	8526                	mv	a0,s1
    8000193e:	bff9                	j	8000191c <either_copyout+0x32>

0000000080001940 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001940:	7179                	addi	sp,sp,-48
    80001942:	f406                	sd	ra,40(sp)
    80001944:	f022                	sd	s0,32(sp)
    80001946:	ec26                	sd	s1,24(sp)
    80001948:	e84a                	sd	s2,16(sp)
    8000194a:	e44e                	sd	s3,8(sp)
    8000194c:	e052                	sd	s4,0(sp)
    8000194e:	1800                	addi	s0,sp,48
    80001950:	892a                	mv	s2,a0
    80001952:	84ae                	mv	s1,a1
    80001954:	89b2                	mv	s3,a2
    80001956:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001958:	fffff097          	auipc	ra,0xfffff
    8000195c:	4e6080e7          	jalr	1254(ra) # 80000e3e <myproc>
  if(user_src){
    80001960:	c08d                	beqz	s1,80001982 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001962:	86d2                	mv	a3,s4
    80001964:	864e                	mv	a2,s3
    80001966:	85ca                	mv	a1,s2
    80001968:	6928                	ld	a0,80(a0)
    8000196a:	fffff097          	auipc	ra,0xfffff
    8000196e:	21e080e7          	jalr	542(ra) # 80000b88 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001972:	70a2                	ld	ra,40(sp)
    80001974:	7402                	ld	s0,32(sp)
    80001976:	64e2                	ld	s1,24(sp)
    80001978:	6942                	ld	s2,16(sp)
    8000197a:	69a2                	ld	s3,8(sp)
    8000197c:	6a02                	ld	s4,0(sp)
    8000197e:	6145                	addi	sp,sp,48
    80001980:	8082                	ret
    memmove(dst, (char*)src, len);
    80001982:	000a061b          	sext.w	a2,s4
    80001986:	85ce                	mv	a1,s3
    80001988:	854a                	mv	a0,s2
    8000198a:	fffff097          	auipc	ra,0xfffff
    8000198e:	84e080e7          	jalr	-1970(ra) # 800001d8 <memmove>
    return 0;
    80001992:	8526                	mv	a0,s1
    80001994:	bff9                	j	80001972 <either_copyin+0x32>

0000000080001996 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001996:	715d                	addi	sp,sp,-80
    80001998:	e486                	sd	ra,72(sp)
    8000199a:	e0a2                	sd	s0,64(sp)
    8000199c:	fc26                	sd	s1,56(sp)
    8000199e:	f84a                	sd	s2,48(sp)
    800019a0:	f44e                	sd	s3,40(sp)
    800019a2:	f052                	sd	s4,32(sp)
    800019a4:	ec56                	sd	s5,24(sp)
    800019a6:	e85a                	sd	s6,16(sp)
    800019a8:	e45e                	sd	s7,8(sp)
    800019aa:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019ac:	00006517          	auipc	a0,0x6
    800019b0:	69c50513          	addi	a0,a0,1692 # 80008048 <etext+0x48>
    800019b4:	00004097          	auipc	ra,0x4
    800019b8:	2f8080e7          	jalr	760(ra) # 80005cac <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019bc:	00007497          	auipc	s1,0x7
    800019c0:	4dc48493          	addi	s1,s1,1244 # 80008e98 <proc+0x158>
    800019c4:	0000d917          	auipc	s2,0xd
    800019c8:	ed490913          	addi	s2,s2,-300 # 8000e898 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019cc:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019ce:	00006997          	auipc	s3,0x6
    800019d2:	7fa98993          	addi	s3,s3,2042 # 800081c8 <etext+0x1c8>
    printf("%d %s %s", p->pid, state, p->name);
    800019d6:	00006a97          	auipc	s5,0x6
    800019da:	7faa8a93          	addi	s5,s5,2042 # 800081d0 <etext+0x1d0>
    printf("\n");
    800019de:	00006a17          	auipc	s4,0x6
    800019e2:	66aa0a13          	addi	s4,s4,1642 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e6:	00007b97          	auipc	s7,0x7
    800019ea:	82ab8b93          	addi	s7,s7,-2006 # 80008210 <states.1728>
    800019ee:	a00d                	j	80001a10 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019f0:	ed86a583          	lw	a1,-296(a3)
    800019f4:	8556                	mv	a0,s5
    800019f6:	00004097          	auipc	ra,0x4
    800019fa:	2b6080e7          	jalr	694(ra) # 80005cac <printf>
    printf("\n");
    800019fe:	8552                	mv	a0,s4
    80001a00:	00004097          	auipc	ra,0x4
    80001a04:	2ac080e7          	jalr	684(ra) # 80005cac <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a08:	16848493          	addi	s1,s1,360
    80001a0c:	03248163          	beq	s1,s2,80001a2e <procdump+0x98>
    if(p->state == UNUSED)
    80001a10:	86a6                	mv	a3,s1
    80001a12:	ec04a783          	lw	a5,-320(s1)
    80001a16:	dbed                	beqz	a5,80001a08 <procdump+0x72>
      state = "???";
    80001a18:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a1a:	fcfb6be3          	bltu	s6,a5,800019f0 <procdump+0x5a>
    80001a1e:	1782                	slli	a5,a5,0x20
    80001a20:	9381                	srli	a5,a5,0x20
    80001a22:	078e                	slli	a5,a5,0x3
    80001a24:	97de                	add	a5,a5,s7
    80001a26:	6390                	ld	a2,0(a5)
    80001a28:	f661                	bnez	a2,800019f0 <procdump+0x5a>
      state = "???";
    80001a2a:	864e                	mv	a2,s3
    80001a2c:	b7d1                	j	800019f0 <procdump+0x5a>
  }
}
    80001a2e:	60a6                	ld	ra,72(sp)
    80001a30:	6406                	ld	s0,64(sp)
    80001a32:	74e2                	ld	s1,56(sp)
    80001a34:	7942                	ld	s2,48(sp)
    80001a36:	79a2                	ld	s3,40(sp)
    80001a38:	7a02                	ld	s4,32(sp)
    80001a3a:	6ae2                	ld	s5,24(sp)
    80001a3c:	6b42                	ld	s6,16(sp)
    80001a3e:	6ba2                	ld	s7,8(sp)
    80001a40:	6161                	addi	sp,sp,80
    80001a42:	8082                	ret

0000000080001a44 <swtch>:
    80001a44:	00153023          	sd	ra,0(a0)
    80001a48:	00253423          	sd	sp,8(a0)
    80001a4c:	e900                	sd	s0,16(a0)
    80001a4e:	ed04                	sd	s1,24(a0)
    80001a50:	03253023          	sd	s2,32(a0)
    80001a54:	03353423          	sd	s3,40(a0)
    80001a58:	03453823          	sd	s4,48(a0)
    80001a5c:	03553c23          	sd	s5,56(a0)
    80001a60:	05653023          	sd	s6,64(a0)
    80001a64:	05753423          	sd	s7,72(a0)
    80001a68:	05853823          	sd	s8,80(a0)
    80001a6c:	05953c23          	sd	s9,88(a0)
    80001a70:	07a53023          	sd	s10,96(a0)
    80001a74:	07b53423          	sd	s11,104(a0)
    80001a78:	0005b083          	ld	ra,0(a1)
    80001a7c:	0085b103          	ld	sp,8(a1)
    80001a80:	6980                	ld	s0,16(a1)
    80001a82:	6d84                	ld	s1,24(a1)
    80001a84:	0205b903          	ld	s2,32(a1)
    80001a88:	0285b983          	ld	s3,40(a1)
    80001a8c:	0305ba03          	ld	s4,48(a1)
    80001a90:	0385ba83          	ld	s5,56(a1)
    80001a94:	0405bb03          	ld	s6,64(a1)
    80001a98:	0485bb83          	ld	s7,72(a1)
    80001a9c:	0505bc03          	ld	s8,80(a1)
    80001aa0:	0585bc83          	ld	s9,88(a1)
    80001aa4:	0605bd03          	ld	s10,96(a1)
    80001aa8:	0685bd83          	ld	s11,104(a1)
    80001aac:	8082                	ret

0000000080001aae <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001aae:	1141                	addi	sp,sp,-16
    80001ab0:	e406                	sd	ra,8(sp)
    80001ab2:	e022                	sd	s0,0(sp)
    80001ab4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ab6:	00006597          	auipc	a1,0x6
    80001aba:	78a58593          	addi	a1,a1,1930 # 80008240 <states.1728+0x30>
    80001abe:	0000d517          	auipc	a0,0xd
    80001ac2:	c8250513          	addi	a0,a0,-894 # 8000e740 <tickslock>
    80001ac6:	00004097          	auipc	ra,0x4
    80001aca:	656080e7          	jalr	1622(ra) # 8000611c <initlock>
}
    80001ace:	60a2                	ld	ra,8(sp)
    80001ad0:	6402                	ld	s0,0(sp)
    80001ad2:	0141                	addi	sp,sp,16
    80001ad4:	8082                	ret

0000000080001ad6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ad6:	1141                	addi	sp,sp,-16
    80001ad8:	e422                	sd	s0,8(sp)
    80001ada:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001adc:	00003797          	auipc	a5,0x3
    80001ae0:	55478793          	addi	a5,a5,1364 # 80005030 <kernelvec>
    80001ae4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ae8:	6422                	ld	s0,8(sp)
    80001aea:	0141                	addi	sp,sp,16
    80001aec:	8082                	ret

0000000080001aee <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001aee:	1141                	addi	sp,sp,-16
    80001af0:	e406                	sd	ra,8(sp)
    80001af2:	e022                	sd	s0,0(sp)
    80001af4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001af6:	fffff097          	auipc	ra,0xfffff
    80001afa:	348080e7          	jalr	840(ra) # 80000e3e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001afe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b02:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b04:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b08:	00005617          	auipc	a2,0x5
    80001b0c:	4f860613          	addi	a2,a2,1272 # 80007000 <_trampoline>
    80001b10:	00005697          	auipc	a3,0x5
    80001b14:	4f068693          	addi	a3,a3,1264 # 80007000 <_trampoline>
    80001b18:	8e91                	sub	a3,a3,a2
    80001b1a:	040007b7          	lui	a5,0x4000
    80001b1e:	17fd                	addi	a5,a5,-1
    80001b20:	07b2                	slli	a5,a5,0xc
    80001b22:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b24:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b28:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b2a:	180026f3          	csrr	a3,satp
    80001b2e:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b30:	6d38                	ld	a4,88(a0)
    80001b32:	6134                	ld	a3,64(a0)
    80001b34:	6585                	lui	a1,0x1
    80001b36:	96ae                	add	a3,a3,a1
    80001b38:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b3a:	6d38                	ld	a4,88(a0)
    80001b3c:	00000697          	auipc	a3,0x0
    80001b40:	13068693          	addi	a3,a3,304 # 80001c6c <usertrap>
    80001b44:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b46:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b48:	8692                	mv	a3,tp
    80001b4a:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b4c:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b50:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b54:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b58:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b5c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b5e:	6f18                	ld	a4,24(a4)
    80001b60:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b64:	6928                	ld	a0,80(a0)
    80001b66:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b68:	00005717          	auipc	a4,0x5
    80001b6c:	53470713          	addi	a4,a4,1332 # 8000709c <userret>
    80001b70:	8f11                	sub	a4,a4,a2
    80001b72:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b74:	577d                	li	a4,-1
    80001b76:	177e                	slli	a4,a4,0x3f
    80001b78:	8d59                	or	a0,a0,a4
    80001b7a:	9782                	jalr	a5
}
    80001b7c:	60a2                	ld	ra,8(sp)
    80001b7e:	6402                	ld	s0,0(sp)
    80001b80:	0141                	addi	sp,sp,16
    80001b82:	8082                	ret

0000000080001b84 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b84:	1101                	addi	sp,sp,-32
    80001b86:	ec06                	sd	ra,24(sp)
    80001b88:	e822                	sd	s0,16(sp)
    80001b8a:	e426                	sd	s1,8(sp)
    80001b8c:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b8e:	0000d497          	auipc	s1,0xd
    80001b92:	bb248493          	addi	s1,s1,-1102 # 8000e740 <tickslock>
    80001b96:	8526                	mv	a0,s1
    80001b98:	00004097          	auipc	ra,0x4
    80001b9c:	614080e7          	jalr	1556(ra) # 800061ac <acquire>
  ticks++;
    80001ba0:	00007517          	auipc	a0,0x7
    80001ba4:	d3850513          	addi	a0,a0,-712 # 800088d8 <ticks>
    80001ba8:	411c                	lw	a5,0(a0)
    80001baa:	2785                	addiw	a5,a5,1
    80001bac:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bae:	00000097          	auipc	ra,0x0
    80001bb2:	998080e7          	jalr	-1640(ra) # 80001546 <wakeup>
  release(&tickslock);
    80001bb6:	8526                	mv	a0,s1
    80001bb8:	00004097          	auipc	ra,0x4
    80001bbc:	6a8080e7          	jalr	1704(ra) # 80006260 <release>
}
    80001bc0:	60e2                	ld	ra,24(sp)
    80001bc2:	6442                	ld	s0,16(sp)
    80001bc4:	64a2                	ld	s1,8(sp)
    80001bc6:	6105                	addi	sp,sp,32
    80001bc8:	8082                	ret

0000000080001bca <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001bca:	1101                	addi	sp,sp,-32
    80001bcc:	ec06                	sd	ra,24(sp)
    80001bce:	e822                	sd	s0,16(sp)
    80001bd0:	e426                	sd	s1,8(sp)
    80001bd2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bd4:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bd8:	00074d63          	bltz	a4,80001bf2 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bdc:	57fd                	li	a5,-1
    80001bde:	17fe                	slli	a5,a5,0x3f
    80001be0:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001be2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001be4:	06f70363          	beq	a4,a5,80001c4a <devintr+0x80>
  }
}
    80001be8:	60e2                	ld	ra,24(sp)
    80001bea:	6442                	ld	s0,16(sp)
    80001bec:	64a2                	ld	s1,8(sp)
    80001bee:	6105                	addi	sp,sp,32
    80001bf0:	8082                	ret
     (scause & 0xff) == 9){
    80001bf2:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001bf6:	46a5                	li	a3,9
    80001bf8:	fed792e3          	bne	a5,a3,80001bdc <devintr+0x12>
    int irq = plic_claim();
    80001bfc:	00003097          	auipc	ra,0x3
    80001c00:	53c080e7          	jalr	1340(ra) # 80005138 <plic_claim>
    80001c04:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c06:	47a9                	li	a5,10
    80001c08:	02f50763          	beq	a0,a5,80001c36 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c0c:	4785                	li	a5,1
    80001c0e:	02f50963          	beq	a0,a5,80001c40 <devintr+0x76>
    return 1;
    80001c12:	4505                	li	a0,1
    } else if(irq){
    80001c14:	d8f1                	beqz	s1,80001be8 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c16:	85a6                	mv	a1,s1
    80001c18:	00006517          	auipc	a0,0x6
    80001c1c:	63050513          	addi	a0,a0,1584 # 80008248 <states.1728+0x38>
    80001c20:	00004097          	auipc	ra,0x4
    80001c24:	08c080e7          	jalr	140(ra) # 80005cac <printf>
      plic_complete(irq);
    80001c28:	8526                	mv	a0,s1
    80001c2a:	00003097          	auipc	ra,0x3
    80001c2e:	532080e7          	jalr	1330(ra) # 8000515c <plic_complete>
    return 1;
    80001c32:	4505                	li	a0,1
    80001c34:	bf55                	j	80001be8 <devintr+0x1e>
      uartintr();
    80001c36:	00004097          	auipc	ra,0x4
    80001c3a:	496080e7          	jalr	1174(ra) # 800060cc <uartintr>
    80001c3e:	b7ed                	j	80001c28 <devintr+0x5e>
      virtio_disk_intr();
    80001c40:	00004097          	auipc	ra,0x4
    80001c44:	a46080e7          	jalr	-1466(ra) # 80005686 <virtio_disk_intr>
    80001c48:	b7c5                	j	80001c28 <devintr+0x5e>
    if(cpuid() == 0){
    80001c4a:	fffff097          	auipc	ra,0xfffff
    80001c4e:	1c8080e7          	jalr	456(ra) # 80000e12 <cpuid>
    80001c52:	c901                	beqz	a0,80001c62 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c54:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c58:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c5a:	14479073          	csrw	sip,a5
    return 2;
    80001c5e:	4509                	li	a0,2
    80001c60:	b761                	j	80001be8 <devintr+0x1e>
      clockintr();
    80001c62:	00000097          	auipc	ra,0x0
    80001c66:	f22080e7          	jalr	-222(ra) # 80001b84 <clockintr>
    80001c6a:	b7ed                	j	80001c54 <devintr+0x8a>

0000000080001c6c <usertrap>:
{
    80001c6c:	1101                	addi	sp,sp,-32
    80001c6e:	ec06                	sd	ra,24(sp)
    80001c70:	e822                	sd	s0,16(sp)
    80001c72:	e426                	sd	s1,8(sp)
    80001c74:	e04a                	sd	s2,0(sp)
    80001c76:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c78:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c7c:	1007f793          	andi	a5,a5,256
    80001c80:	e3d1                	bnez	a5,80001d04 <usertrap+0x98>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c82:	00003797          	auipc	a5,0x3
    80001c86:	3ae78793          	addi	a5,a5,942 # 80005030 <kernelvec>
    80001c8a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c8e:	fffff097          	auipc	ra,0xfffff
    80001c92:	1b0080e7          	jalr	432(ra) # 80000e3e <myproc>
    80001c96:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c98:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c9a:	14102773          	csrr	a4,sepc
    80001c9e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ca0:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001ca4:	47a1                	li	a5,8
    80001ca6:	06f70763          	beq	a4,a5,80001d14 <usertrap+0xa8>
  } else if((which_dev = devintr()) != 0){
    80001caa:	00000097          	auipc	ra,0x0
    80001cae:	f20080e7          	jalr	-224(ra) # 80001bca <devintr>
    80001cb2:	892a                	mv	s2,a0
    80001cb4:	e171                	bnez	a0,80001d78 <usertrap+0x10c>
    80001cb6:	14202773          	csrr	a4,scause
  else if(r_scause() == 13 || r_scause() == 15) {
    80001cba:	47b5                	li	a5,13
    80001cbc:	0af70563          	beq	a4,a5,80001d66 <usertrap+0xfa>
    80001cc0:	14202773          	csrr	a4,scause
    80001cc4:	47bd                	li	a5,15
    80001cc6:	0af70063          	beq	a4,a5,80001d66 <usertrap+0xfa>
    80001cca:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cce:	5890                	lw	a2,48(s1)
    80001cd0:	00006517          	auipc	a0,0x6
    80001cd4:	5e050513          	addi	a0,a0,1504 # 800082b0 <states.1728+0xa0>
    80001cd8:	00004097          	auipc	ra,0x4
    80001cdc:	fd4080e7          	jalr	-44(ra) # 80005cac <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ce0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ce4:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ce8:	00006517          	auipc	a0,0x6
    80001cec:	5f850513          	addi	a0,a0,1528 # 800082e0 <states.1728+0xd0>
    80001cf0:	00004097          	auipc	ra,0x4
    80001cf4:	fbc080e7          	jalr	-68(ra) # 80005cac <printf>
    setkilled(p);
    80001cf8:	8526                	mv	a0,s1
    80001cfa:	00000097          	auipc	ra,0x0
    80001cfe:	a64080e7          	jalr	-1436(ra) # 8000175e <setkilled>
    80001d02:	a825                	j	80001d3a <usertrap+0xce>
    panic("usertrap: not from user mode");
    80001d04:	00006517          	auipc	a0,0x6
    80001d08:	56450513          	addi	a0,a0,1380 # 80008268 <states.1728+0x58>
    80001d0c:	00004097          	auipc	ra,0x4
    80001d10:	f56080e7          	jalr	-170(ra) # 80005c62 <panic>
    if(killed(p))
    80001d14:	00000097          	auipc	ra,0x0
    80001d18:	a76080e7          	jalr	-1418(ra) # 8000178a <killed>
    80001d1c:	ed1d                	bnez	a0,80001d5a <usertrap+0xee>
    p->trapframe->epc += 4;
    80001d1e:	6cb8                	ld	a4,88(s1)
    80001d20:	6f1c                	ld	a5,24(a4)
    80001d22:	0791                	addi	a5,a5,4
    80001d24:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d26:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d2a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d2e:	10079073          	csrw	sstatus,a5
    syscall();
    80001d32:	00000097          	auipc	ra,0x0
    80001d36:	2ba080e7          	jalr	698(ra) # 80001fec <syscall>
  if(killed(p))
    80001d3a:	8526                	mv	a0,s1
    80001d3c:	00000097          	auipc	ra,0x0
    80001d40:	a4e080e7          	jalr	-1458(ra) # 8000178a <killed>
    80001d44:	e129                	bnez	a0,80001d86 <usertrap+0x11a>
  usertrapret();
    80001d46:	00000097          	auipc	ra,0x0
    80001d4a:	da8080e7          	jalr	-600(ra) # 80001aee <usertrapret>
}
    80001d4e:	60e2                	ld	ra,24(sp)
    80001d50:	6442                	ld	s0,16(sp)
    80001d52:	64a2                	ld	s1,8(sp)
    80001d54:	6902                	ld	s2,0(sp)
    80001d56:	6105                	addi	sp,sp,32
    80001d58:	8082                	ret
      exit(-1);
    80001d5a:	557d                	li	a0,-1
    80001d5c:	00000097          	auipc	ra,0x0
    80001d60:	8ba080e7          	jalr	-1862(ra) # 80001616 <exit>
    80001d64:	bf6d                	j	80001d1e <usertrap+0xb2>
    printf("Now, after mmap, we get a page fault\n");
    80001d66:	00006517          	auipc	a0,0x6
    80001d6a:	52250513          	addi	a0,a0,1314 # 80008288 <states.1728+0x78>
    80001d6e:	00004097          	auipc	ra,0x4
    80001d72:	f3e080e7          	jalr	-194(ra) # 80005cac <printf>
    goto err;
    80001d76:	bf91                	j	80001cca <usertrap+0x5e>
  if(killed(p))
    80001d78:	8526                	mv	a0,s1
    80001d7a:	00000097          	auipc	ra,0x0
    80001d7e:	a10080e7          	jalr	-1520(ra) # 8000178a <killed>
    80001d82:	c901                	beqz	a0,80001d92 <usertrap+0x126>
    80001d84:	a011                	j	80001d88 <usertrap+0x11c>
    80001d86:	4901                	li	s2,0
    exit(-1);
    80001d88:	557d                	li	a0,-1
    80001d8a:	00000097          	auipc	ra,0x0
    80001d8e:	88c080e7          	jalr	-1908(ra) # 80001616 <exit>
  if(which_dev == 2)
    80001d92:	4789                	li	a5,2
    80001d94:	faf919e3          	bne	s2,a5,80001d46 <usertrap+0xda>
    yield();
    80001d98:	fffff097          	auipc	ra,0xfffff
    80001d9c:	70e080e7          	jalr	1806(ra) # 800014a6 <yield>
    80001da0:	b75d                	j	80001d46 <usertrap+0xda>

0000000080001da2 <kerneltrap>:
{
    80001da2:	7179                	addi	sp,sp,-48
    80001da4:	f406                	sd	ra,40(sp)
    80001da6:	f022                	sd	s0,32(sp)
    80001da8:	ec26                	sd	s1,24(sp)
    80001daa:	e84a                	sd	s2,16(sp)
    80001dac:	e44e                	sd	s3,8(sp)
    80001dae:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001db0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001db8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dbc:	1004f793          	andi	a5,s1,256
    80001dc0:	cb85                	beqz	a5,80001df0 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dc2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dc6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dc8:	ef85                	bnez	a5,80001e00 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dca:	00000097          	auipc	ra,0x0
    80001dce:	e00080e7          	jalr	-512(ra) # 80001bca <devintr>
    80001dd2:	cd1d                	beqz	a0,80001e10 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dd4:	4789                	li	a5,2
    80001dd6:	06f50a63          	beq	a0,a5,80001e4a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dda:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dde:	10049073          	csrw	sstatus,s1
}
    80001de2:	70a2                	ld	ra,40(sp)
    80001de4:	7402                	ld	s0,32(sp)
    80001de6:	64e2                	ld	s1,24(sp)
    80001de8:	6942                	ld	s2,16(sp)
    80001dea:	69a2                	ld	s3,8(sp)
    80001dec:	6145                	addi	sp,sp,48
    80001dee:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001df0:	00006517          	auipc	a0,0x6
    80001df4:	51050513          	addi	a0,a0,1296 # 80008300 <states.1728+0xf0>
    80001df8:	00004097          	auipc	ra,0x4
    80001dfc:	e6a080e7          	jalr	-406(ra) # 80005c62 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e00:	00006517          	auipc	a0,0x6
    80001e04:	52850513          	addi	a0,a0,1320 # 80008328 <states.1728+0x118>
    80001e08:	00004097          	auipc	ra,0x4
    80001e0c:	e5a080e7          	jalr	-422(ra) # 80005c62 <panic>
    printf("scause %p\n", scause);
    80001e10:	85ce                	mv	a1,s3
    80001e12:	00006517          	auipc	a0,0x6
    80001e16:	53650513          	addi	a0,a0,1334 # 80008348 <states.1728+0x138>
    80001e1a:	00004097          	auipc	ra,0x4
    80001e1e:	e92080e7          	jalr	-366(ra) # 80005cac <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e22:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e26:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e2a:	00006517          	auipc	a0,0x6
    80001e2e:	52e50513          	addi	a0,a0,1326 # 80008358 <states.1728+0x148>
    80001e32:	00004097          	auipc	ra,0x4
    80001e36:	e7a080e7          	jalr	-390(ra) # 80005cac <printf>
    panic("kerneltrap");
    80001e3a:	00006517          	auipc	a0,0x6
    80001e3e:	53650513          	addi	a0,a0,1334 # 80008370 <states.1728+0x160>
    80001e42:	00004097          	auipc	ra,0x4
    80001e46:	e20080e7          	jalr	-480(ra) # 80005c62 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e4a:	fffff097          	auipc	ra,0xfffff
    80001e4e:	ff4080e7          	jalr	-12(ra) # 80000e3e <myproc>
    80001e52:	d541                	beqz	a0,80001dda <kerneltrap+0x38>
    80001e54:	fffff097          	auipc	ra,0xfffff
    80001e58:	fea080e7          	jalr	-22(ra) # 80000e3e <myproc>
    80001e5c:	4d18                	lw	a4,24(a0)
    80001e5e:	4791                	li	a5,4
    80001e60:	f6f71de3          	bne	a4,a5,80001dda <kerneltrap+0x38>
    yield();
    80001e64:	fffff097          	auipc	ra,0xfffff
    80001e68:	642080e7          	jalr	1602(ra) # 800014a6 <yield>
    80001e6c:	b7bd                	j	80001dda <kerneltrap+0x38>

0000000080001e6e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e6e:	1101                	addi	sp,sp,-32
    80001e70:	ec06                	sd	ra,24(sp)
    80001e72:	e822                	sd	s0,16(sp)
    80001e74:	e426                	sd	s1,8(sp)
    80001e76:	1000                	addi	s0,sp,32
    80001e78:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e7a:	fffff097          	auipc	ra,0xfffff
    80001e7e:	fc4080e7          	jalr	-60(ra) # 80000e3e <myproc>
  switch (n) {
    80001e82:	4795                	li	a5,5
    80001e84:	0497e163          	bltu	a5,s1,80001ec6 <argraw+0x58>
    80001e88:	048a                	slli	s1,s1,0x2
    80001e8a:	00006717          	auipc	a4,0x6
    80001e8e:	51e70713          	addi	a4,a4,1310 # 800083a8 <states.1728+0x198>
    80001e92:	94ba                	add	s1,s1,a4
    80001e94:	409c                	lw	a5,0(s1)
    80001e96:	97ba                	add	a5,a5,a4
    80001e98:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e9a:	6d3c                	ld	a5,88(a0)
    80001e9c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e9e:	60e2                	ld	ra,24(sp)
    80001ea0:	6442                	ld	s0,16(sp)
    80001ea2:	64a2                	ld	s1,8(sp)
    80001ea4:	6105                	addi	sp,sp,32
    80001ea6:	8082                	ret
    return p->trapframe->a1;
    80001ea8:	6d3c                	ld	a5,88(a0)
    80001eaa:	7fa8                	ld	a0,120(a5)
    80001eac:	bfcd                	j	80001e9e <argraw+0x30>
    return p->trapframe->a2;
    80001eae:	6d3c                	ld	a5,88(a0)
    80001eb0:	63c8                	ld	a0,128(a5)
    80001eb2:	b7f5                	j	80001e9e <argraw+0x30>
    return p->trapframe->a3;
    80001eb4:	6d3c                	ld	a5,88(a0)
    80001eb6:	67c8                	ld	a0,136(a5)
    80001eb8:	b7dd                	j	80001e9e <argraw+0x30>
    return p->trapframe->a4;
    80001eba:	6d3c                	ld	a5,88(a0)
    80001ebc:	6bc8                	ld	a0,144(a5)
    80001ebe:	b7c5                	j	80001e9e <argraw+0x30>
    return p->trapframe->a5;
    80001ec0:	6d3c                	ld	a5,88(a0)
    80001ec2:	6fc8                	ld	a0,152(a5)
    80001ec4:	bfe9                	j	80001e9e <argraw+0x30>
  panic("argraw");
    80001ec6:	00006517          	auipc	a0,0x6
    80001eca:	4ba50513          	addi	a0,a0,1210 # 80008380 <states.1728+0x170>
    80001ece:	00004097          	auipc	ra,0x4
    80001ed2:	d94080e7          	jalr	-620(ra) # 80005c62 <panic>

0000000080001ed6 <fetchaddr>:
{
    80001ed6:	1101                	addi	sp,sp,-32
    80001ed8:	ec06                	sd	ra,24(sp)
    80001eda:	e822                	sd	s0,16(sp)
    80001edc:	e426                	sd	s1,8(sp)
    80001ede:	e04a                	sd	s2,0(sp)
    80001ee0:	1000                	addi	s0,sp,32
    80001ee2:	84aa                	mv	s1,a0
    80001ee4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ee6:	fffff097          	auipc	ra,0xfffff
    80001eea:	f58080e7          	jalr	-168(ra) # 80000e3e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001eee:	653c                	ld	a5,72(a0)
    80001ef0:	02f4f863          	bgeu	s1,a5,80001f20 <fetchaddr+0x4a>
    80001ef4:	00848713          	addi	a4,s1,8
    80001ef8:	02e7e663          	bltu	a5,a4,80001f24 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001efc:	46a1                	li	a3,8
    80001efe:	8626                	mv	a2,s1
    80001f00:	85ca                	mv	a1,s2
    80001f02:	6928                	ld	a0,80(a0)
    80001f04:	fffff097          	auipc	ra,0xfffff
    80001f08:	c84080e7          	jalr	-892(ra) # 80000b88 <copyin>
    80001f0c:	00a03533          	snez	a0,a0
    80001f10:	40a00533          	neg	a0,a0
}
    80001f14:	60e2                	ld	ra,24(sp)
    80001f16:	6442                	ld	s0,16(sp)
    80001f18:	64a2                	ld	s1,8(sp)
    80001f1a:	6902                	ld	s2,0(sp)
    80001f1c:	6105                	addi	sp,sp,32
    80001f1e:	8082                	ret
    return -1;
    80001f20:	557d                	li	a0,-1
    80001f22:	bfcd                	j	80001f14 <fetchaddr+0x3e>
    80001f24:	557d                	li	a0,-1
    80001f26:	b7fd                	j	80001f14 <fetchaddr+0x3e>

0000000080001f28 <fetchstr>:
{
    80001f28:	7179                	addi	sp,sp,-48
    80001f2a:	f406                	sd	ra,40(sp)
    80001f2c:	f022                	sd	s0,32(sp)
    80001f2e:	ec26                	sd	s1,24(sp)
    80001f30:	e84a                	sd	s2,16(sp)
    80001f32:	e44e                	sd	s3,8(sp)
    80001f34:	1800                	addi	s0,sp,48
    80001f36:	892a                	mv	s2,a0
    80001f38:	84ae                	mv	s1,a1
    80001f3a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f3c:	fffff097          	auipc	ra,0xfffff
    80001f40:	f02080e7          	jalr	-254(ra) # 80000e3e <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f44:	86ce                	mv	a3,s3
    80001f46:	864a                	mv	a2,s2
    80001f48:	85a6                	mv	a1,s1
    80001f4a:	6928                	ld	a0,80(a0)
    80001f4c:	fffff097          	auipc	ra,0xfffff
    80001f50:	cc8080e7          	jalr	-824(ra) # 80000c14 <copyinstr>
    80001f54:	00054e63          	bltz	a0,80001f70 <fetchstr+0x48>
  return strlen(buf);
    80001f58:	8526                	mv	a0,s1
    80001f5a:	ffffe097          	auipc	ra,0xffffe
    80001f5e:	3a2080e7          	jalr	930(ra) # 800002fc <strlen>
}
    80001f62:	70a2                	ld	ra,40(sp)
    80001f64:	7402                	ld	s0,32(sp)
    80001f66:	64e2                	ld	s1,24(sp)
    80001f68:	6942                	ld	s2,16(sp)
    80001f6a:	69a2                	ld	s3,8(sp)
    80001f6c:	6145                	addi	sp,sp,48
    80001f6e:	8082                	ret
    return -1;
    80001f70:	557d                	li	a0,-1
    80001f72:	bfc5                	j	80001f62 <fetchstr+0x3a>

0000000080001f74 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001f74:	1101                	addi	sp,sp,-32
    80001f76:	ec06                	sd	ra,24(sp)
    80001f78:	e822                	sd	s0,16(sp)
    80001f7a:	e426                	sd	s1,8(sp)
    80001f7c:	1000                	addi	s0,sp,32
    80001f7e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f80:	00000097          	auipc	ra,0x0
    80001f84:	eee080e7          	jalr	-274(ra) # 80001e6e <argraw>
    80001f88:	c088                	sw	a0,0(s1)
}
    80001f8a:	60e2                	ld	ra,24(sp)
    80001f8c:	6442                	ld	s0,16(sp)
    80001f8e:	64a2                	ld	s1,8(sp)
    80001f90:	6105                	addi	sp,sp,32
    80001f92:	8082                	ret

0000000080001f94 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001f94:	1101                	addi	sp,sp,-32
    80001f96:	ec06                	sd	ra,24(sp)
    80001f98:	e822                	sd	s0,16(sp)
    80001f9a:	e426                	sd	s1,8(sp)
    80001f9c:	1000                	addi	s0,sp,32
    80001f9e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fa0:	00000097          	auipc	ra,0x0
    80001fa4:	ece080e7          	jalr	-306(ra) # 80001e6e <argraw>
    80001fa8:	e088                	sd	a0,0(s1)
}
    80001faa:	60e2                	ld	ra,24(sp)
    80001fac:	6442                	ld	s0,16(sp)
    80001fae:	64a2                	ld	s1,8(sp)
    80001fb0:	6105                	addi	sp,sp,32
    80001fb2:	8082                	ret

0000000080001fb4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fb4:	7179                	addi	sp,sp,-48
    80001fb6:	f406                	sd	ra,40(sp)
    80001fb8:	f022                	sd	s0,32(sp)
    80001fba:	ec26                	sd	s1,24(sp)
    80001fbc:	e84a                	sd	s2,16(sp)
    80001fbe:	1800                	addi	s0,sp,48
    80001fc0:	84ae                	mv	s1,a1
    80001fc2:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001fc4:	fd840593          	addi	a1,s0,-40
    80001fc8:	00000097          	auipc	ra,0x0
    80001fcc:	fcc080e7          	jalr	-52(ra) # 80001f94 <argaddr>
  return fetchstr(addr, buf, max);
    80001fd0:	864a                	mv	a2,s2
    80001fd2:	85a6                	mv	a1,s1
    80001fd4:	fd843503          	ld	a0,-40(s0)
    80001fd8:	00000097          	auipc	ra,0x0
    80001fdc:	f50080e7          	jalr	-176(ra) # 80001f28 <fetchstr>
}
    80001fe0:	70a2                	ld	ra,40(sp)
    80001fe2:	7402                	ld	s0,32(sp)
    80001fe4:	64e2                	ld	s1,24(sp)
    80001fe6:	6942                	ld	s2,16(sp)
    80001fe8:	6145                	addi	sp,sp,48
    80001fea:	8082                	ret

0000000080001fec <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    80001fec:	1101                	addi	sp,sp,-32
    80001fee:	ec06                	sd	ra,24(sp)
    80001ff0:	e822                	sd	s0,16(sp)
    80001ff2:	e426                	sd	s1,8(sp)
    80001ff4:	e04a                	sd	s2,0(sp)
    80001ff6:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001ff8:	fffff097          	auipc	ra,0xfffff
    80001ffc:	e46080e7          	jalr	-442(ra) # 80000e3e <myproc>
    80002000:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002002:	05853903          	ld	s2,88(a0)
    80002006:	0a893783          	ld	a5,168(s2)
    8000200a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000200e:	37fd                	addiw	a5,a5,-1
    80002010:	4759                	li	a4,22
    80002012:	00f76f63          	bltu	a4,a5,80002030 <syscall+0x44>
    80002016:	00369713          	slli	a4,a3,0x3
    8000201a:	00006797          	auipc	a5,0x6
    8000201e:	3a678793          	addi	a5,a5,934 # 800083c0 <syscalls>
    80002022:	97ba                	add	a5,a5,a4
    80002024:	639c                	ld	a5,0(a5)
    80002026:	c789                	beqz	a5,80002030 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002028:	9782                	jalr	a5
    8000202a:	06a93823          	sd	a0,112(s2)
    8000202e:	a839                	j	8000204c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002030:	15848613          	addi	a2,s1,344
    80002034:	588c                	lw	a1,48(s1)
    80002036:	00006517          	auipc	a0,0x6
    8000203a:	35250513          	addi	a0,a0,850 # 80008388 <states.1728+0x178>
    8000203e:	00004097          	auipc	ra,0x4
    80002042:	c6e080e7          	jalr	-914(ra) # 80005cac <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002046:	6cbc                	ld	a5,88(s1)
    80002048:	577d                	li	a4,-1
    8000204a:	fbb8                	sd	a4,112(a5)
  }
}
    8000204c:	60e2                	ld	ra,24(sp)
    8000204e:	6442                	ld	s0,16(sp)
    80002050:	64a2                	ld	s1,8(sp)
    80002052:	6902                	ld	s2,0(sp)
    80002054:	6105                	addi	sp,sp,32
    80002056:	8082                	ret

0000000080002058 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002058:	1101                	addi	sp,sp,-32
    8000205a:	ec06                	sd	ra,24(sp)
    8000205c:	e822                	sd	s0,16(sp)
    8000205e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002060:	fec40593          	addi	a1,s0,-20
    80002064:	4501                	li	a0,0
    80002066:	00000097          	auipc	ra,0x0
    8000206a:	f0e080e7          	jalr	-242(ra) # 80001f74 <argint>
  exit(n);
    8000206e:	fec42503          	lw	a0,-20(s0)
    80002072:	fffff097          	auipc	ra,0xfffff
    80002076:	5a4080e7          	jalr	1444(ra) # 80001616 <exit>
  return 0;  // not reached
}
    8000207a:	4501                	li	a0,0
    8000207c:	60e2                	ld	ra,24(sp)
    8000207e:	6442                	ld	s0,16(sp)
    80002080:	6105                	addi	sp,sp,32
    80002082:	8082                	ret

0000000080002084 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002084:	1141                	addi	sp,sp,-16
    80002086:	e406                	sd	ra,8(sp)
    80002088:	e022                	sd	s0,0(sp)
    8000208a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000208c:	fffff097          	auipc	ra,0xfffff
    80002090:	db2080e7          	jalr	-590(ra) # 80000e3e <myproc>
}
    80002094:	5908                	lw	a0,48(a0)
    80002096:	60a2                	ld	ra,8(sp)
    80002098:	6402                	ld	s0,0(sp)
    8000209a:	0141                	addi	sp,sp,16
    8000209c:	8082                	ret

000000008000209e <sys_fork>:

uint64
sys_fork(void)
{
    8000209e:	1141                	addi	sp,sp,-16
    800020a0:	e406                	sd	ra,8(sp)
    800020a2:	e022                	sd	s0,0(sp)
    800020a4:	0800                	addi	s0,sp,16
  return fork();
    800020a6:	fffff097          	auipc	ra,0xfffff
    800020aa:	14e080e7          	jalr	334(ra) # 800011f4 <fork>
}
    800020ae:	60a2                	ld	ra,8(sp)
    800020b0:	6402                	ld	s0,0(sp)
    800020b2:	0141                	addi	sp,sp,16
    800020b4:	8082                	ret

00000000800020b6 <sys_wait>:

uint64
sys_wait(void)
{
    800020b6:	1101                	addi	sp,sp,-32
    800020b8:	ec06                	sd	ra,24(sp)
    800020ba:	e822                	sd	s0,16(sp)
    800020bc:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800020be:	fe840593          	addi	a1,s0,-24
    800020c2:	4501                	li	a0,0
    800020c4:	00000097          	auipc	ra,0x0
    800020c8:	ed0080e7          	jalr	-304(ra) # 80001f94 <argaddr>
  return wait(p);
    800020cc:	fe843503          	ld	a0,-24(s0)
    800020d0:	fffff097          	auipc	ra,0xfffff
    800020d4:	6ec080e7          	jalr	1772(ra) # 800017bc <wait>
}
    800020d8:	60e2                	ld	ra,24(sp)
    800020da:	6442                	ld	s0,16(sp)
    800020dc:	6105                	addi	sp,sp,32
    800020de:	8082                	ret

00000000800020e0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020e0:	7179                	addi	sp,sp,-48
    800020e2:	f406                	sd	ra,40(sp)
    800020e4:	f022                	sd	s0,32(sp)
    800020e6:	ec26                	sd	s1,24(sp)
    800020e8:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800020ea:	fdc40593          	addi	a1,s0,-36
    800020ee:	4501                	li	a0,0
    800020f0:	00000097          	auipc	ra,0x0
    800020f4:	e84080e7          	jalr	-380(ra) # 80001f74 <argint>
  addr = myproc()->sz;
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	d46080e7          	jalr	-698(ra) # 80000e3e <myproc>
    80002100:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002102:	fdc42503          	lw	a0,-36(s0)
    80002106:	fffff097          	auipc	ra,0xfffff
    8000210a:	092080e7          	jalr	146(ra) # 80001198 <growproc>
    8000210e:	00054863          	bltz	a0,8000211e <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002112:	8526                	mv	a0,s1
    80002114:	70a2                	ld	ra,40(sp)
    80002116:	7402                	ld	s0,32(sp)
    80002118:	64e2                	ld	s1,24(sp)
    8000211a:	6145                	addi	sp,sp,48
    8000211c:	8082                	ret
    return -1;
    8000211e:	54fd                	li	s1,-1
    80002120:	bfcd                	j	80002112 <sys_sbrk+0x32>

0000000080002122 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002122:	7139                	addi	sp,sp,-64
    80002124:	fc06                	sd	ra,56(sp)
    80002126:	f822                	sd	s0,48(sp)
    80002128:	f426                	sd	s1,40(sp)
    8000212a:	f04a                	sd	s2,32(sp)
    8000212c:	ec4e                	sd	s3,24(sp)
    8000212e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002130:	fcc40593          	addi	a1,s0,-52
    80002134:	4501                	li	a0,0
    80002136:	00000097          	auipc	ra,0x0
    8000213a:	e3e080e7          	jalr	-450(ra) # 80001f74 <argint>
  if(n < 0)
    8000213e:	fcc42783          	lw	a5,-52(s0)
    80002142:	0607cf63          	bltz	a5,800021c0 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002146:	0000c517          	auipc	a0,0xc
    8000214a:	5fa50513          	addi	a0,a0,1530 # 8000e740 <tickslock>
    8000214e:	00004097          	auipc	ra,0x4
    80002152:	05e080e7          	jalr	94(ra) # 800061ac <acquire>
  ticks0 = ticks;
    80002156:	00006917          	auipc	s2,0x6
    8000215a:	78292903          	lw	s2,1922(s2) # 800088d8 <ticks>
  while(ticks - ticks0 < n){
    8000215e:	fcc42783          	lw	a5,-52(s0)
    80002162:	cf9d                	beqz	a5,800021a0 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002164:	0000c997          	auipc	s3,0xc
    80002168:	5dc98993          	addi	s3,s3,1500 # 8000e740 <tickslock>
    8000216c:	00006497          	auipc	s1,0x6
    80002170:	76c48493          	addi	s1,s1,1900 # 800088d8 <ticks>
    if(killed(myproc())){
    80002174:	fffff097          	auipc	ra,0xfffff
    80002178:	cca080e7          	jalr	-822(ra) # 80000e3e <myproc>
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	60e080e7          	jalr	1550(ra) # 8000178a <killed>
    80002184:	e129                	bnez	a0,800021c6 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002186:	85ce                	mv	a1,s3
    80002188:	8526                	mv	a0,s1
    8000218a:	fffff097          	auipc	ra,0xfffff
    8000218e:	358080e7          	jalr	856(ra) # 800014e2 <sleep>
  while(ticks - ticks0 < n){
    80002192:	409c                	lw	a5,0(s1)
    80002194:	412787bb          	subw	a5,a5,s2
    80002198:	fcc42703          	lw	a4,-52(s0)
    8000219c:	fce7ece3          	bltu	a5,a4,80002174 <sys_sleep+0x52>
  }
  release(&tickslock);
    800021a0:	0000c517          	auipc	a0,0xc
    800021a4:	5a050513          	addi	a0,a0,1440 # 8000e740 <tickslock>
    800021a8:	00004097          	auipc	ra,0x4
    800021ac:	0b8080e7          	jalr	184(ra) # 80006260 <release>
  return 0;
    800021b0:	4501                	li	a0,0
}
    800021b2:	70e2                	ld	ra,56(sp)
    800021b4:	7442                	ld	s0,48(sp)
    800021b6:	74a2                	ld	s1,40(sp)
    800021b8:	7902                	ld	s2,32(sp)
    800021ba:	69e2                	ld	s3,24(sp)
    800021bc:	6121                	addi	sp,sp,64
    800021be:	8082                	ret
    n = 0;
    800021c0:	fc042623          	sw	zero,-52(s0)
    800021c4:	b749                	j	80002146 <sys_sleep+0x24>
      release(&tickslock);
    800021c6:	0000c517          	auipc	a0,0xc
    800021ca:	57a50513          	addi	a0,a0,1402 # 8000e740 <tickslock>
    800021ce:	00004097          	auipc	ra,0x4
    800021d2:	092080e7          	jalr	146(ra) # 80006260 <release>
      return -1;
    800021d6:	557d                	li	a0,-1
    800021d8:	bfe9                	j	800021b2 <sys_sleep+0x90>

00000000800021da <sys_kill>:

uint64
sys_kill(void)
{
    800021da:	1101                	addi	sp,sp,-32
    800021dc:	ec06                	sd	ra,24(sp)
    800021de:	e822                	sd	s0,16(sp)
    800021e0:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800021e2:	fec40593          	addi	a1,s0,-20
    800021e6:	4501                	li	a0,0
    800021e8:	00000097          	auipc	ra,0x0
    800021ec:	d8c080e7          	jalr	-628(ra) # 80001f74 <argint>
  return kill(pid);
    800021f0:	fec42503          	lw	a0,-20(s0)
    800021f4:	fffff097          	auipc	ra,0xfffff
    800021f8:	4f8080e7          	jalr	1272(ra) # 800016ec <kill>
}
    800021fc:	60e2                	ld	ra,24(sp)
    800021fe:	6442                	ld	s0,16(sp)
    80002200:	6105                	addi	sp,sp,32
    80002202:	8082                	ret

0000000080002204 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002204:	1101                	addi	sp,sp,-32
    80002206:	ec06                	sd	ra,24(sp)
    80002208:	e822                	sd	s0,16(sp)
    8000220a:	e426                	sd	s1,8(sp)
    8000220c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000220e:	0000c517          	auipc	a0,0xc
    80002212:	53250513          	addi	a0,a0,1330 # 8000e740 <tickslock>
    80002216:	00004097          	auipc	ra,0x4
    8000221a:	f96080e7          	jalr	-106(ra) # 800061ac <acquire>
  xticks = ticks;
    8000221e:	00006497          	auipc	s1,0x6
    80002222:	6ba4a483          	lw	s1,1722(s1) # 800088d8 <ticks>
  release(&tickslock);
    80002226:	0000c517          	auipc	a0,0xc
    8000222a:	51a50513          	addi	a0,a0,1306 # 8000e740 <tickslock>
    8000222e:	00004097          	auipc	ra,0x4
    80002232:	032080e7          	jalr	50(ra) # 80006260 <release>
  return xticks;
}
    80002236:	02049513          	slli	a0,s1,0x20
    8000223a:	9101                	srli	a0,a0,0x20
    8000223c:	60e2                	ld	ra,24(sp)
    8000223e:	6442                	ld	s0,16(sp)
    80002240:	64a2                	ld	s1,8(sp)
    80002242:	6105                	addi	sp,sp,32
    80002244:	8082                	ret

0000000080002246 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002246:	7179                	addi	sp,sp,-48
    80002248:	f406                	sd	ra,40(sp)
    8000224a:	f022                	sd	s0,32(sp)
    8000224c:	ec26                	sd	s1,24(sp)
    8000224e:	e84a                	sd	s2,16(sp)
    80002250:	e44e                	sd	s3,8(sp)
    80002252:	e052                	sd	s4,0(sp)
    80002254:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002256:	00006597          	auipc	a1,0x6
    8000225a:	22a58593          	addi	a1,a1,554 # 80008480 <syscalls+0xc0>
    8000225e:	0000c517          	auipc	a0,0xc
    80002262:	4fa50513          	addi	a0,a0,1274 # 8000e758 <bcache>
    80002266:	00004097          	auipc	ra,0x4
    8000226a:	eb6080e7          	jalr	-330(ra) # 8000611c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000226e:	00014797          	auipc	a5,0x14
    80002272:	4ea78793          	addi	a5,a5,1258 # 80016758 <bcache+0x8000>
    80002276:	00014717          	auipc	a4,0x14
    8000227a:	74a70713          	addi	a4,a4,1866 # 800169c0 <bcache+0x8268>
    8000227e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002282:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002286:	0000c497          	auipc	s1,0xc
    8000228a:	4ea48493          	addi	s1,s1,1258 # 8000e770 <bcache+0x18>
    b->next = bcache.head.next;
    8000228e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002290:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002292:	00006a17          	auipc	s4,0x6
    80002296:	1f6a0a13          	addi	s4,s4,502 # 80008488 <syscalls+0xc8>
    b->next = bcache.head.next;
    8000229a:	2b893783          	ld	a5,696(s2)
    8000229e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800022a0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022a4:	85d2                	mv	a1,s4
    800022a6:	01048513          	addi	a0,s1,16
    800022aa:	00001097          	auipc	ra,0x1
    800022ae:	4c4080e7          	jalr	1220(ra) # 8000376e <initsleeplock>
    bcache.head.next->prev = b;
    800022b2:	2b893783          	ld	a5,696(s2)
    800022b6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022b8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022bc:	45848493          	addi	s1,s1,1112
    800022c0:	fd349de3          	bne	s1,s3,8000229a <binit+0x54>
  }
}
    800022c4:	70a2                	ld	ra,40(sp)
    800022c6:	7402                	ld	s0,32(sp)
    800022c8:	64e2                	ld	s1,24(sp)
    800022ca:	6942                	ld	s2,16(sp)
    800022cc:	69a2                	ld	s3,8(sp)
    800022ce:	6a02                	ld	s4,0(sp)
    800022d0:	6145                	addi	sp,sp,48
    800022d2:	8082                	ret

00000000800022d4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022d4:	7179                	addi	sp,sp,-48
    800022d6:	f406                	sd	ra,40(sp)
    800022d8:	f022                	sd	s0,32(sp)
    800022da:	ec26                	sd	s1,24(sp)
    800022dc:	e84a                	sd	s2,16(sp)
    800022de:	e44e                	sd	s3,8(sp)
    800022e0:	1800                	addi	s0,sp,48
    800022e2:	89aa                	mv	s3,a0
    800022e4:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800022e6:	0000c517          	auipc	a0,0xc
    800022ea:	47250513          	addi	a0,a0,1138 # 8000e758 <bcache>
    800022ee:	00004097          	auipc	ra,0x4
    800022f2:	ebe080e7          	jalr	-322(ra) # 800061ac <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022f6:	00014497          	auipc	s1,0x14
    800022fa:	71a4b483          	ld	s1,1818(s1) # 80016a10 <bcache+0x82b8>
    800022fe:	00014797          	auipc	a5,0x14
    80002302:	6c278793          	addi	a5,a5,1730 # 800169c0 <bcache+0x8268>
    80002306:	02f48f63          	beq	s1,a5,80002344 <bread+0x70>
    8000230a:	873e                	mv	a4,a5
    8000230c:	a021                	j	80002314 <bread+0x40>
    8000230e:	68a4                	ld	s1,80(s1)
    80002310:	02e48a63          	beq	s1,a4,80002344 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002314:	449c                	lw	a5,8(s1)
    80002316:	ff379ce3          	bne	a5,s3,8000230e <bread+0x3a>
    8000231a:	44dc                	lw	a5,12(s1)
    8000231c:	ff2799e3          	bne	a5,s2,8000230e <bread+0x3a>
      b->refcnt++;
    80002320:	40bc                	lw	a5,64(s1)
    80002322:	2785                	addiw	a5,a5,1
    80002324:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002326:	0000c517          	auipc	a0,0xc
    8000232a:	43250513          	addi	a0,a0,1074 # 8000e758 <bcache>
    8000232e:	00004097          	auipc	ra,0x4
    80002332:	f32080e7          	jalr	-206(ra) # 80006260 <release>
      acquiresleep(&b->lock);
    80002336:	01048513          	addi	a0,s1,16
    8000233a:	00001097          	auipc	ra,0x1
    8000233e:	46e080e7          	jalr	1134(ra) # 800037a8 <acquiresleep>
      return b;
    80002342:	a8b9                	j	800023a0 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002344:	00014497          	auipc	s1,0x14
    80002348:	6c44b483          	ld	s1,1732(s1) # 80016a08 <bcache+0x82b0>
    8000234c:	00014797          	auipc	a5,0x14
    80002350:	67478793          	addi	a5,a5,1652 # 800169c0 <bcache+0x8268>
    80002354:	00f48863          	beq	s1,a5,80002364 <bread+0x90>
    80002358:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000235a:	40bc                	lw	a5,64(s1)
    8000235c:	cf81                	beqz	a5,80002374 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000235e:	64a4                	ld	s1,72(s1)
    80002360:	fee49de3          	bne	s1,a4,8000235a <bread+0x86>
  panic("bget: no buffers");
    80002364:	00006517          	auipc	a0,0x6
    80002368:	12c50513          	addi	a0,a0,300 # 80008490 <syscalls+0xd0>
    8000236c:	00004097          	auipc	ra,0x4
    80002370:	8f6080e7          	jalr	-1802(ra) # 80005c62 <panic>
      b->dev = dev;
    80002374:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002378:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000237c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002380:	4785                	li	a5,1
    80002382:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002384:	0000c517          	auipc	a0,0xc
    80002388:	3d450513          	addi	a0,a0,980 # 8000e758 <bcache>
    8000238c:	00004097          	auipc	ra,0x4
    80002390:	ed4080e7          	jalr	-300(ra) # 80006260 <release>
      acquiresleep(&b->lock);
    80002394:	01048513          	addi	a0,s1,16
    80002398:	00001097          	auipc	ra,0x1
    8000239c:	410080e7          	jalr	1040(ra) # 800037a8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800023a0:	409c                	lw	a5,0(s1)
    800023a2:	cb89                	beqz	a5,800023b4 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800023a4:	8526                	mv	a0,s1
    800023a6:	70a2                	ld	ra,40(sp)
    800023a8:	7402                	ld	s0,32(sp)
    800023aa:	64e2                	ld	s1,24(sp)
    800023ac:	6942                	ld	s2,16(sp)
    800023ae:	69a2                	ld	s3,8(sp)
    800023b0:	6145                	addi	sp,sp,48
    800023b2:	8082                	ret
    virtio_disk_rw(b, 0);
    800023b4:	4581                	li	a1,0
    800023b6:	8526                	mv	a0,s1
    800023b8:	00003097          	auipc	ra,0x3
    800023bc:	040080e7          	jalr	64(ra) # 800053f8 <virtio_disk_rw>
    b->valid = 1;
    800023c0:	4785                	li	a5,1
    800023c2:	c09c                	sw	a5,0(s1)
  return b;
    800023c4:	b7c5                	j	800023a4 <bread+0xd0>

00000000800023c6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023c6:	1101                	addi	sp,sp,-32
    800023c8:	ec06                	sd	ra,24(sp)
    800023ca:	e822                	sd	s0,16(sp)
    800023cc:	e426                	sd	s1,8(sp)
    800023ce:	1000                	addi	s0,sp,32
    800023d0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023d2:	0541                	addi	a0,a0,16
    800023d4:	00001097          	auipc	ra,0x1
    800023d8:	46e080e7          	jalr	1134(ra) # 80003842 <holdingsleep>
    800023dc:	cd01                	beqz	a0,800023f4 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023de:	4585                	li	a1,1
    800023e0:	8526                	mv	a0,s1
    800023e2:	00003097          	auipc	ra,0x3
    800023e6:	016080e7          	jalr	22(ra) # 800053f8 <virtio_disk_rw>
}
    800023ea:	60e2                	ld	ra,24(sp)
    800023ec:	6442                	ld	s0,16(sp)
    800023ee:	64a2                	ld	s1,8(sp)
    800023f0:	6105                	addi	sp,sp,32
    800023f2:	8082                	ret
    panic("bwrite");
    800023f4:	00006517          	auipc	a0,0x6
    800023f8:	0b450513          	addi	a0,a0,180 # 800084a8 <syscalls+0xe8>
    800023fc:	00004097          	auipc	ra,0x4
    80002400:	866080e7          	jalr	-1946(ra) # 80005c62 <panic>

0000000080002404 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002404:	1101                	addi	sp,sp,-32
    80002406:	ec06                	sd	ra,24(sp)
    80002408:	e822                	sd	s0,16(sp)
    8000240a:	e426                	sd	s1,8(sp)
    8000240c:	e04a                	sd	s2,0(sp)
    8000240e:	1000                	addi	s0,sp,32
    80002410:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002412:	01050913          	addi	s2,a0,16
    80002416:	854a                	mv	a0,s2
    80002418:	00001097          	auipc	ra,0x1
    8000241c:	42a080e7          	jalr	1066(ra) # 80003842 <holdingsleep>
    80002420:	c92d                	beqz	a0,80002492 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002422:	854a                	mv	a0,s2
    80002424:	00001097          	auipc	ra,0x1
    80002428:	3da080e7          	jalr	986(ra) # 800037fe <releasesleep>

  acquire(&bcache.lock);
    8000242c:	0000c517          	auipc	a0,0xc
    80002430:	32c50513          	addi	a0,a0,812 # 8000e758 <bcache>
    80002434:	00004097          	auipc	ra,0x4
    80002438:	d78080e7          	jalr	-648(ra) # 800061ac <acquire>
  b->refcnt--;
    8000243c:	40bc                	lw	a5,64(s1)
    8000243e:	37fd                	addiw	a5,a5,-1
    80002440:	0007871b          	sext.w	a4,a5
    80002444:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002446:	eb05                	bnez	a4,80002476 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002448:	68bc                	ld	a5,80(s1)
    8000244a:	64b8                	ld	a4,72(s1)
    8000244c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000244e:	64bc                	ld	a5,72(s1)
    80002450:	68b8                	ld	a4,80(s1)
    80002452:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002454:	00014797          	auipc	a5,0x14
    80002458:	30478793          	addi	a5,a5,772 # 80016758 <bcache+0x8000>
    8000245c:	2b87b703          	ld	a4,696(a5)
    80002460:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002462:	00014717          	auipc	a4,0x14
    80002466:	55e70713          	addi	a4,a4,1374 # 800169c0 <bcache+0x8268>
    8000246a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000246c:	2b87b703          	ld	a4,696(a5)
    80002470:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002472:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002476:	0000c517          	auipc	a0,0xc
    8000247a:	2e250513          	addi	a0,a0,738 # 8000e758 <bcache>
    8000247e:	00004097          	auipc	ra,0x4
    80002482:	de2080e7          	jalr	-542(ra) # 80006260 <release>
}
    80002486:	60e2                	ld	ra,24(sp)
    80002488:	6442                	ld	s0,16(sp)
    8000248a:	64a2                	ld	s1,8(sp)
    8000248c:	6902                	ld	s2,0(sp)
    8000248e:	6105                	addi	sp,sp,32
    80002490:	8082                	ret
    panic("brelse");
    80002492:	00006517          	auipc	a0,0x6
    80002496:	01e50513          	addi	a0,a0,30 # 800084b0 <syscalls+0xf0>
    8000249a:	00003097          	auipc	ra,0x3
    8000249e:	7c8080e7          	jalr	1992(ra) # 80005c62 <panic>

00000000800024a2 <bpin>:

void
bpin(struct buf *b) {
    800024a2:	1101                	addi	sp,sp,-32
    800024a4:	ec06                	sd	ra,24(sp)
    800024a6:	e822                	sd	s0,16(sp)
    800024a8:	e426                	sd	s1,8(sp)
    800024aa:	1000                	addi	s0,sp,32
    800024ac:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024ae:	0000c517          	auipc	a0,0xc
    800024b2:	2aa50513          	addi	a0,a0,682 # 8000e758 <bcache>
    800024b6:	00004097          	auipc	ra,0x4
    800024ba:	cf6080e7          	jalr	-778(ra) # 800061ac <acquire>
  b->refcnt++;
    800024be:	40bc                	lw	a5,64(s1)
    800024c0:	2785                	addiw	a5,a5,1
    800024c2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024c4:	0000c517          	auipc	a0,0xc
    800024c8:	29450513          	addi	a0,a0,660 # 8000e758 <bcache>
    800024cc:	00004097          	auipc	ra,0x4
    800024d0:	d94080e7          	jalr	-620(ra) # 80006260 <release>
}
    800024d4:	60e2                	ld	ra,24(sp)
    800024d6:	6442                	ld	s0,16(sp)
    800024d8:	64a2                	ld	s1,8(sp)
    800024da:	6105                	addi	sp,sp,32
    800024dc:	8082                	ret

00000000800024de <bunpin>:

void
bunpin(struct buf *b) {
    800024de:	1101                	addi	sp,sp,-32
    800024e0:	ec06                	sd	ra,24(sp)
    800024e2:	e822                	sd	s0,16(sp)
    800024e4:	e426                	sd	s1,8(sp)
    800024e6:	1000                	addi	s0,sp,32
    800024e8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024ea:	0000c517          	auipc	a0,0xc
    800024ee:	26e50513          	addi	a0,a0,622 # 8000e758 <bcache>
    800024f2:	00004097          	auipc	ra,0x4
    800024f6:	cba080e7          	jalr	-838(ra) # 800061ac <acquire>
  b->refcnt--;
    800024fa:	40bc                	lw	a5,64(s1)
    800024fc:	37fd                	addiw	a5,a5,-1
    800024fe:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002500:	0000c517          	auipc	a0,0xc
    80002504:	25850513          	addi	a0,a0,600 # 8000e758 <bcache>
    80002508:	00004097          	auipc	ra,0x4
    8000250c:	d58080e7          	jalr	-680(ra) # 80006260 <release>
}
    80002510:	60e2                	ld	ra,24(sp)
    80002512:	6442                	ld	s0,16(sp)
    80002514:	64a2                	ld	s1,8(sp)
    80002516:	6105                	addi	sp,sp,32
    80002518:	8082                	ret

000000008000251a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000251a:	1101                	addi	sp,sp,-32
    8000251c:	ec06                	sd	ra,24(sp)
    8000251e:	e822                	sd	s0,16(sp)
    80002520:	e426                	sd	s1,8(sp)
    80002522:	e04a                	sd	s2,0(sp)
    80002524:	1000                	addi	s0,sp,32
    80002526:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002528:	00d5d59b          	srliw	a1,a1,0xd
    8000252c:	00015797          	auipc	a5,0x15
    80002530:	9087a783          	lw	a5,-1784(a5) # 80016e34 <sb+0x1c>
    80002534:	9dbd                	addw	a1,a1,a5
    80002536:	00000097          	auipc	ra,0x0
    8000253a:	d9e080e7          	jalr	-610(ra) # 800022d4 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000253e:	0074f713          	andi	a4,s1,7
    80002542:	4785                	li	a5,1
    80002544:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002548:	14ce                	slli	s1,s1,0x33
    8000254a:	90d9                	srli	s1,s1,0x36
    8000254c:	00950733          	add	a4,a0,s1
    80002550:	05874703          	lbu	a4,88(a4)
    80002554:	00e7f6b3          	and	a3,a5,a4
    80002558:	c69d                	beqz	a3,80002586 <bfree+0x6c>
    8000255a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000255c:	94aa                	add	s1,s1,a0
    8000255e:	fff7c793          	not	a5,a5
    80002562:	8ff9                	and	a5,a5,a4
    80002564:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002568:	00001097          	auipc	ra,0x1
    8000256c:	120080e7          	jalr	288(ra) # 80003688 <log_write>
  brelse(bp);
    80002570:	854a                	mv	a0,s2
    80002572:	00000097          	auipc	ra,0x0
    80002576:	e92080e7          	jalr	-366(ra) # 80002404 <brelse>
}
    8000257a:	60e2                	ld	ra,24(sp)
    8000257c:	6442                	ld	s0,16(sp)
    8000257e:	64a2                	ld	s1,8(sp)
    80002580:	6902                	ld	s2,0(sp)
    80002582:	6105                	addi	sp,sp,32
    80002584:	8082                	ret
    panic("freeing free block");
    80002586:	00006517          	auipc	a0,0x6
    8000258a:	f3250513          	addi	a0,a0,-206 # 800084b8 <syscalls+0xf8>
    8000258e:	00003097          	auipc	ra,0x3
    80002592:	6d4080e7          	jalr	1748(ra) # 80005c62 <panic>

0000000080002596 <balloc>:
{
    80002596:	711d                	addi	sp,sp,-96
    80002598:	ec86                	sd	ra,88(sp)
    8000259a:	e8a2                	sd	s0,80(sp)
    8000259c:	e4a6                	sd	s1,72(sp)
    8000259e:	e0ca                	sd	s2,64(sp)
    800025a0:	fc4e                	sd	s3,56(sp)
    800025a2:	f852                	sd	s4,48(sp)
    800025a4:	f456                	sd	s5,40(sp)
    800025a6:	f05a                	sd	s6,32(sp)
    800025a8:	ec5e                	sd	s7,24(sp)
    800025aa:	e862                	sd	s8,16(sp)
    800025ac:	e466                	sd	s9,8(sp)
    800025ae:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025b0:	00015797          	auipc	a5,0x15
    800025b4:	86c7a783          	lw	a5,-1940(a5) # 80016e1c <sb+0x4>
    800025b8:	10078163          	beqz	a5,800026ba <balloc+0x124>
    800025bc:	8baa                	mv	s7,a0
    800025be:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025c0:	00015b17          	auipc	s6,0x15
    800025c4:	858b0b13          	addi	s6,s6,-1960 # 80016e18 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025c8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025ca:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025cc:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025ce:	6c89                	lui	s9,0x2
    800025d0:	a061                	j	80002658 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025d2:	974a                	add	a4,a4,s2
    800025d4:	8fd5                	or	a5,a5,a3
    800025d6:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800025da:	854a                	mv	a0,s2
    800025dc:	00001097          	auipc	ra,0x1
    800025e0:	0ac080e7          	jalr	172(ra) # 80003688 <log_write>
        brelse(bp);
    800025e4:	854a                	mv	a0,s2
    800025e6:	00000097          	auipc	ra,0x0
    800025ea:	e1e080e7          	jalr	-482(ra) # 80002404 <brelse>
  bp = bread(dev, bno);
    800025ee:	85a6                	mv	a1,s1
    800025f0:	855e                	mv	a0,s7
    800025f2:	00000097          	auipc	ra,0x0
    800025f6:	ce2080e7          	jalr	-798(ra) # 800022d4 <bread>
    800025fa:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800025fc:	40000613          	li	a2,1024
    80002600:	4581                	li	a1,0
    80002602:	05850513          	addi	a0,a0,88
    80002606:	ffffe097          	auipc	ra,0xffffe
    8000260a:	b72080e7          	jalr	-1166(ra) # 80000178 <memset>
  log_write(bp);
    8000260e:	854a                	mv	a0,s2
    80002610:	00001097          	auipc	ra,0x1
    80002614:	078080e7          	jalr	120(ra) # 80003688 <log_write>
  brelse(bp);
    80002618:	854a                	mv	a0,s2
    8000261a:	00000097          	auipc	ra,0x0
    8000261e:	dea080e7          	jalr	-534(ra) # 80002404 <brelse>
}
    80002622:	8526                	mv	a0,s1
    80002624:	60e6                	ld	ra,88(sp)
    80002626:	6446                	ld	s0,80(sp)
    80002628:	64a6                	ld	s1,72(sp)
    8000262a:	6906                	ld	s2,64(sp)
    8000262c:	79e2                	ld	s3,56(sp)
    8000262e:	7a42                	ld	s4,48(sp)
    80002630:	7aa2                	ld	s5,40(sp)
    80002632:	7b02                	ld	s6,32(sp)
    80002634:	6be2                	ld	s7,24(sp)
    80002636:	6c42                	ld	s8,16(sp)
    80002638:	6ca2                	ld	s9,8(sp)
    8000263a:	6125                	addi	sp,sp,96
    8000263c:	8082                	ret
    brelse(bp);
    8000263e:	854a                	mv	a0,s2
    80002640:	00000097          	auipc	ra,0x0
    80002644:	dc4080e7          	jalr	-572(ra) # 80002404 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002648:	015c87bb          	addw	a5,s9,s5
    8000264c:	00078a9b          	sext.w	s5,a5
    80002650:	004b2703          	lw	a4,4(s6)
    80002654:	06eaf363          	bgeu	s5,a4,800026ba <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80002658:	41fad79b          	sraiw	a5,s5,0x1f
    8000265c:	0137d79b          	srliw	a5,a5,0x13
    80002660:	015787bb          	addw	a5,a5,s5
    80002664:	40d7d79b          	sraiw	a5,a5,0xd
    80002668:	01cb2583          	lw	a1,28(s6)
    8000266c:	9dbd                	addw	a1,a1,a5
    8000266e:	855e                	mv	a0,s7
    80002670:	00000097          	auipc	ra,0x0
    80002674:	c64080e7          	jalr	-924(ra) # 800022d4 <bread>
    80002678:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000267a:	004b2503          	lw	a0,4(s6)
    8000267e:	000a849b          	sext.w	s1,s5
    80002682:	8662                	mv	a2,s8
    80002684:	faa4fde3          	bgeu	s1,a0,8000263e <balloc+0xa8>
      m = 1 << (bi % 8);
    80002688:	41f6579b          	sraiw	a5,a2,0x1f
    8000268c:	01d7d69b          	srliw	a3,a5,0x1d
    80002690:	00c6873b          	addw	a4,a3,a2
    80002694:	00777793          	andi	a5,a4,7
    80002698:	9f95                	subw	a5,a5,a3
    8000269a:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000269e:	4037571b          	sraiw	a4,a4,0x3
    800026a2:	00e906b3          	add	a3,s2,a4
    800026a6:	0586c683          	lbu	a3,88(a3)
    800026aa:	00d7f5b3          	and	a1,a5,a3
    800026ae:	d195                	beqz	a1,800025d2 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026b0:	2605                	addiw	a2,a2,1
    800026b2:	2485                	addiw	s1,s1,1
    800026b4:	fd4618e3          	bne	a2,s4,80002684 <balloc+0xee>
    800026b8:	b759                	j	8000263e <balloc+0xa8>
  printf("balloc: out of blocks\n");
    800026ba:	00006517          	auipc	a0,0x6
    800026be:	e1650513          	addi	a0,a0,-490 # 800084d0 <syscalls+0x110>
    800026c2:	00003097          	auipc	ra,0x3
    800026c6:	5ea080e7          	jalr	1514(ra) # 80005cac <printf>
  return 0;
    800026ca:	4481                	li	s1,0
    800026cc:	bf99                	j	80002622 <balloc+0x8c>

00000000800026ce <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800026ce:	7179                	addi	sp,sp,-48
    800026d0:	f406                	sd	ra,40(sp)
    800026d2:	f022                	sd	s0,32(sp)
    800026d4:	ec26                	sd	s1,24(sp)
    800026d6:	e84a                	sd	s2,16(sp)
    800026d8:	e44e                	sd	s3,8(sp)
    800026da:	e052                	sd	s4,0(sp)
    800026dc:	1800                	addi	s0,sp,48
    800026de:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026e0:	47ad                	li	a5,11
    800026e2:	02b7e763          	bltu	a5,a1,80002710 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800026e6:	02059493          	slli	s1,a1,0x20
    800026ea:	9081                	srli	s1,s1,0x20
    800026ec:	048a                	slli	s1,s1,0x2
    800026ee:	94aa                	add	s1,s1,a0
    800026f0:	0504a903          	lw	s2,80(s1)
    800026f4:	06091e63          	bnez	s2,80002770 <bmap+0xa2>
      addr = balloc(ip->dev);
    800026f8:	4108                	lw	a0,0(a0)
    800026fa:	00000097          	auipc	ra,0x0
    800026fe:	e9c080e7          	jalr	-356(ra) # 80002596 <balloc>
    80002702:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002706:	06090563          	beqz	s2,80002770 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    8000270a:	0524a823          	sw	s2,80(s1)
    8000270e:	a08d                	j	80002770 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002710:	ff45849b          	addiw	s1,a1,-12
    80002714:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002718:	0ff00793          	li	a5,255
    8000271c:	08e7e563          	bltu	a5,a4,800027a6 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002720:	08052903          	lw	s2,128(a0)
    80002724:	00091d63          	bnez	s2,8000273e <bmap+0x70>
      addr = balloc(ip->dev);
    80002728:	4108                	lw	a0,0(a0)
    8000272a:	00000097          	auipc	ra,0x0
    8000272e:	e6c080e7          	jalr	-404(ra) # 80002596 <balloc>
    80002732:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002736:	02090d63          	beqz	s2,80002770 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000273a:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000273e:	85ca                	mv	a1,s2
    80002740:	0009a503          	lw	a0,0(s3)
    80002744:	00000097          	auipc	ra,0x0
    80002748:	b90080e7          	jalr	-1136(ra) # 800022d4 <bread>
    8000274c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000274e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002752:	02049593          	slli	a1,s1,0x20
    80002756:	9181                	srli	a1,a1,0x20
    80002758:	058a                	slli	a1,a1,0x2
    8000275a:	00b784b3          	add	s1,a5,a1
    8000275e:	0004a903          	lw	s2,0(s1)
    80002762:	02090063          	beqz	s2,80002782 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002766:	8552                	mv	a0,s4
    80002768:	00000097          	auipc	ra,0x0
    8000276c:	c9c080e7          	jalr	-868(ra) # 80002404 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002770:	854a                	mv	a0,s2
    80002772:	70a2                	ld	ra,40(sp)
    80002774:	7402                	ld	s0,32(sp)
    80002776:	64e2                	ld	s1,24(sp)
    80002778:	6942                	ld	s2,16(sp)
    8000277a:	69a2                	ld	s3,8(sp)
    8000277c:	6a02                	ld	s4,0(sp)
    8000277e:	6145                	addi	sp,sp,48
    80002780:	8082                	ret
      addr = balloc(ip->dev);
    80002782:	0009a503          	lw	a0,0(s3)
    80002786:	00000097          	auipc	ra,0x0
    8000278a:	e10080e7          	jalr	-496(ra) # 80002596 <balloc>
    8000278e:	0005091b          	sext.w	s2,a0
      if(addr){
    80002792:	fc090ae3          	beqz	s2,80002766 <bmap+0x98>
        a[bn] = addr;
    80002796:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000279a:	8552                	mv	a0,s4
    8000279c:	00001097          	auipc	ra,0x1
    800027a0:	eec080e7          	jalr	-276(ra) # 80003688 <log_write>
    800027a4:	b7c9                	j	80002766 <bmap+0x98>
  panic("bmap: out of range");
    800027a6:	00006517          	auipc	a0,0x6
    800027aa:	d4250513          	addi	a0,a0,-702 # 800084e8 <syscalls+0x128>
    800027ae:	00003097          	auipc	ra,0x3
    800027b2:	4b4080e7          	jalr	1204(ra) # 80005c62 <panic>

00000000800027b6 <iget>:
{
    800027b6:	7179                	addi	sp,sp,-48
    800027b8:	f406                	sd	ra,40(sp)
    800027ba:	f022                	sd	s0,32(sp)
    800027bc:	ec26                	sd	s1,24(sp)
    800027be:	e84a                	sd	s2,16(sp)
    800027c0:	e44e                	sd	s3,8(sp)
    800027c2:	e052                	sd	s4,0(sp)
    800027c4:	1800                	addi	s0,sp,48
    800027c6:	89aa                	mv	s3,a0
    800027c8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027ca:	00014517          	auipc	a0,0x14
    800027ce:	66e50513          	addi	a0,a0,1646 # 80016e38 <itable>
    800027d2:	00004097          	auipc	ra,0x4
    800027d6:	9da080e7          	jalr	-1574(ra) # 800061ac <acquire>
  empty = 0;
    800027da:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027dc:	00014497          	auipc	s1,0x14
    800027e0:	67448493          	addi	s1,s1,1652 # 80016e50 <itable+0x18>
    800027e4:	00016697          	auipc	a3,0x16
    800027e8:	0fc68693          	addi	a3,a3,252 # 800188e0 <log>
    800027ec:	a039                	j	800027fa <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027ee:	02090b63          	beqz	s2,80002824 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027f2:	08848493          	addi	s1,s1,136
    800027f6:	02d48a63          	beq	s1,a3,8000282a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027fa:	449c                	lw	a5,8(s1)
    800027fc:	fef059e3          	blez	a5,800027ee <iget+0x38>
    80002800:	4098                	lw	a4,0(s1)
    80002802:	ff3716e3          	bne	a4,s3,800027ee <iget+0x38>
    80002806:	40d8                	lw	a4,4(s1)
    80002808:	ff4713e3          	bne	a4,s4,800027ee <iget+0x38>
      ip->ref++;
    8000280c:	2785                	addiw	a5,a5,1
    8000280e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002810:	00014517          	auipc	a0,0x14
    80002814:	62850513          	addi	a0,a0,1576 # 80016e38 <itable>
    80002818:	00004097          	auipc	ra,0x4
    8000281c:	a48080e7          	jalr	-1464(ra) # 80006260 <release>
      return ip;
    80002820:	8926                	mv	s2,s1
    80002822:	a03d                	j	80002850 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002824:	f7f9                	bnez	a5,800027f2 <iget+0x3c>
    80002826:	8926                	mv	s2,s1
    80002828:	b7e9                	j	800027f2 <iget+0x3c>
  if(empty == 0)
    8000282a:	02090c63          	beqz	s2,80002862 <iget+0xac>
  ip->dev = dev;
    8000282e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002832:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002836:	4785                	li	a5,1
    80002838:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000283c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002840:	00014517          	auipc	a0,0x14
    80002844:	5f850513          	addi	a0,a0,1528 # 80016e38 <itable>
    80002848:	00004097          	auipc	ra,0x4
    8000284c:	a18080e7          	jalr	-1512(ra) # 80006260 <release>
}
    80002850:	854a                	mv	a0,s2
    80002852:	70a2                	ld	ra,40(sp)
    80002854:	7402                	ld	s0,32(sp)
    80002856:	64e2                	ld	s1,24(sp)
    80002858:	6942                	ld	s2,16(sp)
    8000285a:	69a2                	ld	s3,8(sp)
    8000285c:	6a02                	ld	s4,0(sp)
    8000285e:	6145                	addi	sp,sp,48
    80002860:	8082                	ret
    panic("iget: no inodes");
    80002862:	00006517          	auipc	a0,0x6
    80002866:	c9e50513          	addi	a0,a0,-866 # 80008500 <syscalls+0x140>
    8000286a:	00003097          	auipc	ra,0x3
    8000286e:	3f8080e7          	jalr	1016(ra) # 80005c62 <panic>

0000000080002872 <fsinit>:
fsinit(int dev) {
    80002872:	7179                	addi	sp,sp,-48
    80002874:	f406                	sd	ra,40(sp)
    80002876:	f022                	sd	s0,32(sp)
    80002878:	ec26                	sd	s1,24(sp)
    8000287a:	e84a                	sd	s2,16(sp)
    8000287c:	e44e                	sd	s3,8(sp)
    8000287e:	1800                	addi	s0,sp,48
    80002880:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002882:	4585                	li	a1,1
    80002884:	00000097          	auipc	ra,0x0
    80002888:	a50080e7          	jalr	-1456(ra) # 800022d4 <bread>
    8000288c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000288e:	00014997          	auipc	s3,0x14
    80002892:	58a98993          	addi	s3,s3,1418 # 80016e18 <sb>
    80002896:	02000613          	li	a2,32
    8000289a:	05850593          	addi	a1,a0,88
    8000289e:	854e                	mv	a0,s3
    800028a0:	ffffe097          	auipc	ra,0xffffe
    800028a4:	938080e7          	jalr	-1736(ra) # 800001d8 <memmove>
  brelse(bp);
    800028a8:	8526                	mv	a0,s1
    800028aa:	00000097          	auipc	ra,0x0
    800028ae:	b5a080e7          	jalr	-1190(ra) # 80002404 <brelse>
  if(sb.magic != FSMAGIC)
    800028b2:	0009a703          	lw	a4,0(s3)
    800028b6:	102037b7          	lui	a5,0x10203
    800028ba:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028be:	02f71263          	bne	a4,a5,800028e2 <fsinit+0x70>
  initlog(dev, &sb);
    800028c2:	00014597          	auipc	a1,0x14
    800028c6:	55658593          	addi	a1,a1,1366 # 80016e18 <sb>
    800028ca:	854a                	mv	a0,s2
    800028cc:	00001097          	auipc	ra,0x1
    800028d0:	b40080e7          	jalr	-1216(ra) # 8000340c <initlog>
}
    800028d4:	70a2                	ld	ra,40(sp)
    800028d6:	7402                	ld	s0,32(sp)
    800028d8:	64e2                	ld	s1,24(sp)
    800028da:	6942                	ld	s2,16(sp)
    800028dc:	69a2                	ld	s3,8(sp)
    800028de:	6145                	addi	sp,sp,48
    800028e0:	8082                	ret
    panic("invalid file system");
    800028e2:	00006517          	auipc	a0,0x6
    800028e6:	c2e50513          	addi	a0,a0,-978 # 80008510 <syscalls+0x150>
    800028ea:	00003097          	auipc	ra,0x3
    800028ee:	378080e7          	jalr	888(ra) # 80005c62 <panic>

00000000800028f2 <iinit>:
{
    800028f2:	7179                	addi	sp,sp,-48
    800028f4:	f406                	sd	ra,40(sp)
    800028f6:	f022                	sd	s0,32(sp)
    800028f8:	ec26                	sd	s1,24(sp)
    800028fa:	e84a                	sd	s2,16(sp)
    800028fc:	e44e                	sd	s3,8(sp)
    800028fe:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002900:	00006597          	auipc	a1,0x6
    80002904:	c2858593          	addi	a1,a1,-984 # 80008528 <syscalls+0x168>
    80002908:	00014517          	auipc	a0,0x14
    8000290c:	53050513          	addi	a0,a0,1328 # 80016e38 <itable>
    80002910:	00004097          	auipc	ra,0x4
    80002914:	80c080e7          	jalr	-2036(ra) # 8000611c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002918:	00014497          	auipc	s1,0x14
    8000291c:	54848493          	addi	s1,s1,1352 # 80016e60 <itable+0x28>
    80002920:	00016997          	auipc	s3,0x16
    80002924:	fd098993          	addi	s3,s3,-48 # 800188f0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002928:	00006917          	auipc	s2,0x6
    8000292c:	c0890913          	addi	s2,s2,-1016 # 80008530 <syscalls+0x170>
    80002930:	85ca                	mv	a1,s2
    80002932:	8526                	mv	a0,s1
    80002934:	00001097          	auipc	ra,0x1
    80002938:	e3a080e7          	jalr	-454(ra) # 8000376e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000293c:	08848493          	addi	s1,s1,136
    80002940:	ff3498e3          	bne	s1,s3,80002930 <iinit+0x3e>
}
    80002944:	70a2                	ld	ra,40(sp)
    80002946:	7402                	ld	s0,32(sp)
    80002948:	64e2                	ld	s1,24(sp)
    8000294a:	6942                	ld	s2,16(sp)
    8000294c:	69a2                	ld	s3,8(sp)
    8000294e:	6145                	addi	sp,sp,48
    80002950:	8082                	ret

0000000080002952 <ialloc>:
{
    80002952:	715d                	addi	sp,sp,-80
    80002954:	e486                	sd	ra,72(sp)
    80002956:	e0a2                	sd	s0,64(sp)
    80002958:	fc26                	sd	s1,56(sp)
    8000295a:	f84a                	sd	s2,48(sp)
    8000295c:	f44e                	sd	s3,40(sp)
    8000295e:	f052                	sd	s4,32(sp)
    80002960:	ec56                	sd	s5,24(sp)
    80002962:	e85a                	sd	s6,16(sp)
    80002964:	e45e                	sd	s7,8(sp)
    80002966:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002968:	00014717          	auipc	a4,0x14
    8000296c:	4bc72703          	lw	a4,1212(a4) # 80016e24 <sb+0xc>
    80002970:	4785                	li	a5,1
    80002972:	04e7fa63          	bgeu	a5,a4,800029c6 <ialloc+0x74>
    80002976:	8aaa                	mv	s5,a0
    80002978:	8bae                	mv	s7,a1
    8000297a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000297c:	00014a17          	auipc	s4,0x14
    80002980:	49ca0a13          	addi	s4,s4,1180 # 80016e18 <sb>
    80002984:	00048b1b          	sext.w	s6,s1
    80002988:	0044d593          	srli	a1,s1,0x4
    8000298c:	018a2783          	lw	a5,24(s4)
    80002990:	9dbd                	addw	a1,a1,a5
    80002992:	8556                	mv	a0,s5
    80002994:	00000097          	auipc	ra,0x0
    80002998:	940080e7          	jalr	-1728(ra) # 800022d4 <bread>
    8000299c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000299e:	05850993          	addi	s3,a0,88
    800029a2:	00f4f793          	andi	a5,s1,15
    800029a6:	079a                	slli	a5,a5,0x6
    800029a8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029aa:	00099783          	lh	a5,0(s3)
    800029ae:	c3a1                	beqz	a5,800029ee <ialloc+0x9c>
    brelse(bp);
    800029b0:	00000097          	auipc	ra,0x0
    800029b4:	a54080e7          	jalr	-1452(ra) # 80002404 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029b8:	0485                	addi	s1,s1,1
    800029ba:	00ca2703          	lw	a4,12(s4)
    800029be:	0004879b          	sext.w	a5,s1
    800029c2:	fce7e1e3          	bltu	a5,a4,80002984 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    800029c6:	00006517          	auipc	a0,0x6
    800029ca:	b7250513          	addi	a0,a0,-1166 # 80008538 <syscalls+0x178>
    800029ce:	00003097          	auipc	ra,0x3
    800029d2:	2de080e7          	jalr	734(ra) # 80005cac <printf>
  return 0;
    800029d6:	4501                	li	a0,0
}
    800029d8:	60a6                	ld	ra,72(sp)
    800029da:	6406                	ld	s0,64(sp)
    800029dc:	74e2                	ld	s1,56(sp)
    800029de:	7942                	ld	s2,48(sp)
    800029e0:	79a2                	ld	s3,40(sp)
    800029e2:	7a02                	ld	s4,32(sp)
    800029e4:	6ae2                	ld	s5,24(sp)
    800029e6:	6b42                	ld	s6,16(sp)
    800029e8:	6ba2                	ld	s7,8(sp)
    800029ea:	6161                	addi	sp,sp,80
    800029ec:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800029ee:	04000613          	li	a2,64
    800029f2:	4581                	li	a1,0
    800029f4:	854e                	mv	a0,s3
    800029f6:	ffffd097          	auipc	ra,0xffffd
    800029fa:	782080e7          	jalr	1922(ra) # 80000178 <memset>
      dip->type = type;
    800029fe:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a02:	854a                	mv	a0,s2
    80002a04:	00001097          	auipc	ra,0x1
    80002a08:	c84080e7          	jalr	-892(ra) # 80003688 <log_write>
      brelse(bp);
    80002a0c:	854a                	mv	a0,s2
    80002a0e:	00000097          	auipc	ra,0x0
    80002a12:	9f6080e7          	jalr	-1546(ra) # 80002404 <brelse>
      return iget(dev, inum);
    80002a16:	85da                	mv	a1,s6
    80002a18:	8556                	mv	a0,s5
    80002a1a:	00000097          	auipc	ra,0x0
    80002a1e:	d9c080e7          	jalr	-612(ra) # 800027b6 <iget>
    80002a22:	bf5d                	j	800029d8 <ialloc+0x86>

0000000080002a24 <iupdate>:
{
    80002a24:	1101                	addi	sp,sp,-32
    80002a26:	ec06                	sd	ra,24(sp)
    80002a28:	e822                	sd	s0,16(sp)
    80002a2a:	e426                	sd	s1,8(sp)
    80002a2c:	e04a                	sd	s2,0(sp)
    80002a2e:	1000                	addi	s0,sp,32
    80002a30:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a32:	415c                	lw	a5,4(a0)
    80002a34:	0047d79b          	srliw	a5,a5,0x4
    80002a38:	00014597          	auipc	a1,0x14
    80002a3c:	3f85a583          	lw	a1,1016(a1) # 80016e30 <sb+0x18>
    80002a40:	9dbd                	addw	a1,a1,a5
    80002a42:	4108                	lw	a0,0(a0)
    80002a44:	00000097          	auipc	ra,0x0
    80002a48:	890080e7          	jalr	-1904(ra) # 800022d4 <bread>
    80002a4c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a4e:	05850793          	addi	a5,a0,88
    80002a52:	40c8                	lw	a0,4(s1)
    80002a54:	893d                	andi	a0,a0,15
    80002a56:	051a                	slli	a0,a0,0x6
    80002a58:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002a5a:	04449703          	lh	a4,68(s1)
    80002a5e:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002a62:	04649703          	lh	a4,70(s1)
    80002a66:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002a6a:	04849703          	lh	a4,72(s1)
    80002a6e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002a72:	04a49703          	lh	a4,74(s1)
    80002a76:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002a7a:	44f8                	lw	a4,76(s1)
    80002a7c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a7e:	03400613          	li	a2,52
    80002a82:	05048593          	addi	a1,s1,80
    80002a86:	0531                	addi	a0,a0,12
    80002a88:	ffffd097          	auipc	ra,0xffffd
    80002a8c:	750080e7          	jalr	1872(ra) # 800001d8 <memmove>
  log_write(bp);
    80002a90:	854a                	mv	a0,s2
    80002a92:	00001097          	auipc	ra,0x1
    80002a96:	bf6080e7          	jalr	-1034(ra) # 80003688 <log_write>
  brelse(bp);
    80002a9a:	854a                	mv	a0,s2
    80002a9c:	00000097          	auipc	ra,0x0
    80002aa0:	968080e7          	jalr	-1688(ra) # 80002404 <brelse>
}
    80002aa4:	60e2                	ld	ra,24(sp)
    80002aa6:	6442                	ld	s0,16(sp)
    80002aa8:	64a2                	ld	s1,8(sp)
    80002aaa:	6902                	ld	s2,0(sp)
    80002aac:	6105                	addi	sp,sp,32
    80002aae:	8082                	ret

0000000080002ab0 <idup>:
{
    80002ab0:	1101                	addi	sp,sp,-32
    80002ab2:	ec06                	sd	ra,24(sp)
    80002ab4:	e822                	sd	s0,16(sp)
    80002ab6:	e426                	sd	s1,8(sp)
    80002ab8:	1000                	addi	s0,sp,32
    80002aba:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002abc:	00014517          	auipc	a0,0x14
    80002ac0:	37c50513          	addi	a0,a0,892 # 80016e38 <itable>
    80002ac4:	00003097          	auipc	ra,0x3
    80002ac8:	6e8080e7          	jalr	1768(ra) # 800061ac <acquire>
  ip->ref++;
    80002acc:	449c                	lw	a5,8(s1)
    80002ace:	2785                	addiw	a5,a5,1
    80002ad0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ad2:	00014517          	auipc	a0,0x14
    80002ad6:	36650513          	addi	a0,a0,870 # 80016e38 <itable>
    80002ada:	00003097          	auipc	ra,0x3
    80002ade:	786080e7          	jalr	1926(ra) # 80006260 <release>
}
    80002ae2:	8526                	mv	a0,s1
    80002ae4:	60e2                	ld	ra,24(sp)
    80002ae6:	6442                	ld	s0,16(sp)
    80002ae8:	64a2                	ld	s1,8(sp)
    80002aea:	6105                	addi	sp,sp,32
    80002aec:	8082                	ret

0000000080002aee <ilock>:
{
    80002aee:	1101                	addi	sp,sp,-32
    80002af0:	ec06                	sd	ra,24(sp)
    80002af2:	e822                	sd	s0,16(sp)
    80002af4:	e426                	sd	s1,8(sp)
    80002af6:	e04a                	sd	s2,0(sp)
    80002af8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002afa:	c115                	beqz	a0,80002b1e <ilock+0x30>
    80002afc:	84aa                	mv	s1,a0
    80002afe:	451c                	lw	a5,8(a0)
    80002b00:	00f05f63          	blez	a5,80002b1e <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b04:	0541                	addi	a0,a0,16
    80002b06:	00001097          	auipc	ra,0x1
    80002b0a:	ca2080e7          	jalr	-862(ra) # 800037a8 <acquiresleep>
  if(ip->valid == 0){
    80002b0e:	40bc                	lw	a5,64(s1)
    80002b10:	cf99                	beqz	a5,80002b2e <ilock+0x40>
}
    80002b12:	60e2                	ld	ra,24(sp)
    80002b14:	6442                	ld	s0,16(sp)
    80002b16:	64a2                	ld	s1,8(sp)
    80002b18:	6902                	ld	s2,0(sp)
    80002b1a:	6105                	addi	sp,sp,32
    80002b1c:	8082                	ret
    panic("ilock");
    80002b1e:	00006517          	auipc	a0,0x6
    80002b22:	a3250513          	addi	a0,a0,-1486 # 80008550 <syscalls+0x190>
    80002b26:	00003097          	auipc	ra,0x3
    80002b2a:	13c080e7          	jalr	316(ra) # 80005c62 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b2e:	40dc                	lw	a5,4(s1)
    80002b30:	0047d79b          	srliw	a5,a5,0x4
    80002b34:	00014597          	auipc	a1,0x14
    80002b38:	2fc5a583          	lw	a1,764(a1) # 80016e30 <sb+0x18>
    80002b3c:	9dbd                	addw	a1,a1,a5
    80002b3e:	4088                	lw	a0,0(s1)
    80002b40:	fffff097          	auipc	ra,0xfffff
    80002b44:	794080e7          	jalr	1940(ra) # 800022d4 <bread>
    80002b48:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b4a:	05850593          	addi	a1,a0,88
    80002b4e:	40dc                	lw	a5,4(s1)
    80002b50:	8bbd                	andi	a5,a5,15
    80002b52:	079a                	slli	a5,a5,0x6
    80002b54:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b56:	00059783          	lh	a5,0(a1)
    80002b5a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b5e:	00259783          	lh	a5,2(a1)
    80002b62:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b66:	00459783          	lh	a5,4(a1)
    80002b6a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b6e:	00659783          	lh	a5,6(a1)
    80002b72:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b76:	459c                	lw	a5,8(a1)
    80002b78:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b7a:	03400613          	li	a2,52
    80002b7e:	05b1                	addi	a1,a1,12
    80002b80:	05048513          	addi	a0,s1,80
    80002b84:	ffffd097          	auipc	ra,0xffffd
    80002b88:	654080e7          	jalr	1620(ra) # 800001d8 <memmove>
    brelse(bp);
    80002b8c:	854a                	mv	a0,s2
    80002b8e:	00000097          	auipc	ra,0x0
    80002b92:	876080e7          	jalr	-1930(ra) # 80002404 <brelse>
    ip->valid = 1;
    80002b96:	4785                	li	a5,1
    80002b98:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b9a:	04449783          	lh	a5,68(s1)
    80002b9e:	fbb5                	bnez	a5,80002b12 <ilock+0x24>
      panic("ilock: no type");
    80002ba0:	00006517          	auipc	a0,0x6
    80002ba4:	9b850513          	addi	a0,a0,-1608 # 80008558 <syscalls+0x198>
    80002ba8:	00003097          	auipc	ra,0x3
    80002bac:	0ba080e7          	jalr	186(ra) # 80005c62 <panic>

0000000080002bb0 <iunlock>:
{
    80002bb0:	1101                	addi	sp,sp,-32
    80002bb2:	ec06                	sd	ra,24(sp)
    80002bb4:	e822                	sd	s0,16(sp)
    80002bb6:	e426                	sd	s1,8(sp)
    80002bb8:	e04a                	sd	s2,0(sp)
    80002bba:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bbc:	c905                	beqz	a0,80002bec <iunlock+0x3c>
    80002bbe:	84aa                	mv	s1,a0
    80002bc0:	01050913          	addi	s2,a0,16
    80002bc4:	854a                	mv	a0,s2
    80002bc6:	00001097          	auipc	ra,0x1
    80002bca:	c7c080e7          	jalr	-900(ra) # 80003842 <holdingsleep>
    80002bce:	cd19                	beqz	a0,80002bec <iunlock+0x3c>
    80002bd0:	449c                	lw	a5,8(s1)
    80002bd2:	00f05d63          	blez	a5,80002bec <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bd6:	854a                	mv	a0,s2
    80002bd8:	00001097          	auipc	ra,0x1
    80002bdc:	c26080e7          	jalr	-986(ra) # 800037fe <releasesleep>
}
    80002be0:	60e2                	ld	ra,24(sp)
    80002be2:	6442                	ld	s0,16(sp)
    80002be4:	64a2                	ld	s1,8(sp)
    80002be6:	6902                	ld	s2,0(sp)
    80002be8:	6105                	addi	sp,sp,32
    80002bea:	8082                	ret
    panic("iunlock");
    80002bec:	00006517          	auipc	a0,0x6
    80002bf0:	97c50513          	addi	a0,a0,-1668 # 80008568 <syscalls+0x1a8>
    80002bf4:	00003097          	auipc	ra,0x3
    80002bf8:	06e080e7          	jalr	110(ra) # 80005c62 <panic>

0000000080002bfc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002bfc:	7179                	addi	sp,sp,-48
    80002bfe:	f406                	sd	ra,40(sp)
    80002c00:	f022                	sd	s0,32(sp)
    80002c02:	ec26                	sd	s1,24(sp)
    80002c04:	e84a                	sd	s2,16(sp)
    80002c06:	e44e                	sd	s3,8(sp)
    80002c08:	e052                	sd	s4,0(sp)
    80002c0a:	1800                	addi	s0,sp,48
    80002c0c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c0e:	05050493          	addi	s1,a0,80
    80002c12:	08050913          	addi	s2,a0,128
    80002c16:	a021                	j	80002c1e <itrunc+0x22>
    80002c18:	0491                	addi	s1,s1,4
    80002c1a:	01248d63          	beq	s1,s2,80002c34 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c1e:	408c                	lw	a1,0(s1)
    80002c20:	dde5                	beqz	a1,80002c18 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c22:	0009a503          	lw	a0,0(s3)
    80002c26:	00000097          	auipc	ra,0x0
    80002c2a:	8f4080e7          	jalr	-1804(ra) # 8000251a <bfree>
      ip->addrs[i] = 0;
    80002c2e:	0004a023          	sw	zero,0(s1)
    80002c32:	b7dd                	j	80002c18 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c34:	0809a583          	lw	a1,128(s3)
    80002c38:	e185                	bnez	a1,80002c58 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c3a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c3e:	854e                	mv	a0,s3
    80002c40:	00000097          	auipc	ra,0x0
    80002c44:	de4080e7          	jalr	-540(ra) # 80002a24 <iupdate>
}
    80002c48:	70a2                	ld	ra,40(sp)
    80002c4a:	7402                	ld	s0,32(sp)
    80002c4c:	64e2                	ld	s1,24(sp)
    80002c4e:	6942                	ld	s2,16(sp)
    80002c50:	69a2                	ld	s3,8(sp)
    80002c52:	6a02                	ld	s4,0(sp)
    80002c54:	6145                	addi	sp,sp,48
    80002c56:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c58:	0009a503          	lw	a0,0(s3)
    80002c5c:	fffff097          	auipc	ra,0xfffff
    80002c60:	678080e7          	jalr	1656(ra) # 800022d4 <bread>
    80002c64:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c66:	05850493          	addi	s1,a0,88
    80002c6a:	45850913          	addi	s2,a0,1112
    80002c6e:	a811                	j	80002c82 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002c70:	0009a503          	lw	a0,0(s3)
    80002c74:	00000097          	auipc	ra,0x0
    80002c78:	8a6080e7          	jalr	-1882(ra) # 8000251a <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002c7c:	0491                	addi	s1,s1,4
    80002c7e:	01248563          	beq	s1,s2,80002c88 <itrunc+0x8c>
      if(a[j])
    80002c82:	408c                	lw	a1,0(s1)
    80002c84:	dde5                	beqz	a1,80002c7c <itrunc+0x80>
    80002c86:	b7ed                	j	80002c70 <itrunc+0x74>
    brelse(bp);
    80002c88:	8552                	mv	a0,s4
    80002c8a:	fffff097          	auipc	ra,0xfffff
    80002c8e:	77a080e7          	jalr	1914(ra) # 80002404 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c92:	0809a583          	lw	a1,128(s3)
    80002c96:	0009a503          	lw	a0,0(s3)
    80002c9a:	00000097          	auipc	ra,0x0
    80002c9e:	880080e7          	jalr	-1920(ra) # 8000251a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ca2:	0809a023          	sw	zero,128(s3)
    80002ca6:	bf51                	j	80002c3a <itrunc+0x3e>

0000000080002ca8 <iput>:
{
    80002ca8:	1101                	addi	sp,sp,-32
    80002caa:	ec06                	sd	ra,24(sp)
    80002cac:	e822                	sd	s0,16(sp)
    80002cae:	e426                	sd	s1,8(sp)
    80002cb0:	e04a                	sd	s2,0(sp)
    80002cb2:	1000                	addi	s0,sp,32
    80002cb4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cb6:	00014517          	auipc	a0,0x14
    80002cba:	18250513          	addi	a0,a0,386 # 80016e38 <itable>
    80002cbe:	00003097          	auipc	ra,0x3
    80002cc2:	4ee080e7          	jalr	1262(ra) # 800061ac <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cc6:	4498                	lw	a4,8(s1)
    80002cc8:	4785                	li	a5,1
    80002cca:	02f70363          	beq	a4,a5,80002cf0 <iput+0x48>
  ip->ref--;
    80002cce:	449c                	lw	a5,8(s1)
    80002cd0:	37fd                	addiw	a5,a5,-1
    80002cd2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cd4:	00014517          	auipc	a0,0x14
    80002cd8:	16450513          	addi	a0,a0,356 # 80016e38 <itable>
    80002cdc:	00003097          	auipc	ra,0x3
    80002ce0:	584080e7          	jalr	1412(ra) # 80006260 <release>
}
    80002ce4:	60e2                	ld	ra,24(sp)
    80002ce6:	6442                	ld	s0,16(sp)
    80002ce8:	64a2                	ld	s1,8(sp)
    80002cea:	6902                	ld	s2,0(sp)
    80002cec:	6105                	addi	sp,sp,32
    80002cee:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cf0:	40bc                	lw	a5,64(s1)
    80002cf2:	dff1                	beqz	a5,80002cce <iput+0x26>
    80002cf4:	04a49783          	lh	a5,74(s1)
    80002cf8:	fbf9                	bnez	a5,80002cce <iput+0x26>
    acquiresleep(&ip->lock);
    80002cfa:	01048913          	addi	s2,s1,16
    80002cfe:	854a                	mv	a0,s2
    80002d00:	00001097          	auipc	ra,0x1
    80002d04:	aa8080e7          	jalr	-1368(ra) # 800037a8 <acquiresleep>
    release(&itable.lock);
    80002d08:	00014517          	auipc	a0,0x14
    80002d0c:	13050513          	addi	a0,a0,304 # 80016e38 <itable>
    80002d10:	00003097          	auipc	ra,0x3
    80002d14:	550080e7          	jalr	1360(ra) # 80006260 <release>
    itrunc(ip);
    80002d18:	8526                	mv	a0,s1
    80002d1a:	00000097          	auipc	ra,0x0
    80002d1e:	ee2080e7          	jalr	-286(ra) # 80002bfc <itrunc>
    ip->type = 0;
    80002d22:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d26:	8526                	mv	a0,s1
    80002d28:	00000097          	auipc	ra,0x0
    80002d2c:	cfc080e7          	jalr	-772(ra) # 80002a24 <iupdate>
    ip->valid = 0;
    80002d30:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d34:	854a                	mv	a0,s2
    80002d36:	00001097          	auipc	ra,0x1
    80002d3a:	ac8080e7          	jalr	-1336(ra) # 800037fe <releasesleep>
    acquire(&itable.lock);
    80002d3e:	00014517          	auipc	a0,0x14
    80002d42:	0fa50513          	addi	a0,a0,250 # 80016e38 <itable>
    80002d46:	00003097          	auipc	ra,0x3
    80002d4a:	466080e7          	jalr	1126(ra) # 800061ac <acquire>
    80002d4e:	b741                	j	80002cce <iput+0x26>

0000000080002d50 <iunlockput>:
{
    80002d50:	1101                	addi	sp,sp,-32
    80002d52:	ec06                	sd	ra,24(sp)
    80002d54:	e822                	sd	s0,16(sp)
    80002d56:	e426                	sd	s1,8(sp)
    80002d58:	1000                	addi	s0,sp,32
    80002d5a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d5c:	00000097          	auipc	ra,0x0
    80002d60:	e54080e7          	jalr	-428(ra) # 80002bb0 <iunlock>
  iput(ip);
    80002d64:	8526                	mv	a0,s1
    80002d66:	00000097          	auipc	ra,0x0
    80002d6a:	f42080e7          	jalr	-190(ra) # 80002ca8 <iput>
}
    80002d6e:	60e2                	ld	ra,24(sp)
    80002d70:	6442                	ld	s0,16(sp)
    80002d72:	64a2                	ld	s1,8(sp)
    80002d74:	6105                	addi	sp,sp,32
    80002d76:	8082                	ret

0000000080002d78 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d78:	1141                	addi	sp,sp,-16
    80002d7a:	e422                	sd	s0,8(sp)
    80002d7c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d7e:	411c                	lw	a5,0(a0)
    80002d80:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d82:	415c                	lw	a5,4(a0)
    80002d84:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d86:	04451783          	lh	a5,68(a0)
    80002d8a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d8e:	04a51783          	lh	a5,74(a0)
    80002d92:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d96:	04c56783          	lwu	a5,76(a0)
    80002d9a:	e99c                	sd	a5,16(a1)
}
    80002d9c:	6422                	ld	s0,8(sp)
    80002d9e:	0141                	addi	sp,sp,16
    80002da0:	8082                	ret

0000000080002da2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002da2:	457c                	lw	a5,76(a0)
    80002da4:	0ed7e963          	bltu	a5,a3,80002e96 <readi+0xf4>
{
    80002da8:	7159                	addi	sp,sp,-112
    80002daa:	f486                	sd	ra,104(sp)
    80002dac:	f0a2                	sd	s0,96(sp)
    80002dae:	eca6                	sd	s1,88(sp)
    80002db0:	e8ca                	sd	s2,80(sp)
    80002db2:	e4ce                	sd	s3,72(sp)
    80002db4:	e0d2                	sd	s4,64(sp)
    80002db6:	fc56                	sd	s5,56(sp)
    80002db8:	f85a                	sd	s6,48(sp)
    80002dba:	f45e                	sd	s7,40(sp)
    80002dbc:	f062                	sd	s8,32(sp)
    80002dbe:	ec66                	sd	s9,24(sp)
    80002dc0:	e86a                	sd	s10,16(sp)
    80002dc2:	e46e                	sd	s11,8(sp)
    80002dc4:	1880                	addi	s0,sp,112
    80002dc6:	8b2a                	mv	s6,a0
    80002dc8:	8bae                	mv	s7,a1
    80002dca:	8a32                	mv	s4,a2
    80002dcc:	84b6                	mv	s1,a3
    80002dce:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002dd0:	9f35                	addw	a4,a4,a3
    return 0;
    80002dd2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002dd4:	0ad76063          	bltu	a4,a3,80002e74 <readi+0xd2>
  if(off + n > ip->size)
    80002dd8:	00e7f463          	bgeu	a5,a4,80002de0 <readi+0x3e>
    n = ip->size - off;
    80002ddc:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002de0:	0a0a8963          	beqz	s5,80002e92 <readi+0xf0>
    80002de4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002de6:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002dea:	5c7d                	li	s8,-1
    80002dec:	a82d                	j	80002e26 <readi+0x84>
    80002dee:	020d1d93          	slli	s11,s10,0x20
    80002df2:	020ddd93          	srli	s11,s11,0x20
    80002df6:	05890613          	addi	a2,s2,88
    80002dfa:	86ee                	mv	a3,s11
    80002dfc:	963a                	add	a2,a2,a4
    80002dfe:	85d2                	mv	a1,s4
    80002e00:	855e                	mv	a0,s7
    80002e02:	fffff097          	auipc	ra,0xfffff
    80002e06:	ae8080e7          	jalr	-1304(ra) # 800018ea <either_copyout>
    80002e0a:	05850d63          	beq	a0,s8,80002e64 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e0e:	854a                	mv	a0,s2
    80002e10:	fffff097          	auipc	ra,0xfffff
    80002e14:	5f4080e7          	jalr	1524(ra) # 80002404 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e18:	013d09bb          	addw	s3,s10,s3
    80002e1c:	009d04bb          	addw	s1,s10,s1
    80002e20:	9a6e                	add	s4,s4,s11
    80002e22:	0559f763          	bgeu	s3,s5,80002e70 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e26:	00a4d59b          	srliw	a1,s1,0xa
    80002e2a:	855a                	mv	a0,s6
    80002e2c:	00000097          	auipc	ra,0x0
    80002e30:	8a2080e7          	jalr	-1886(ra) # 800026ce <bmap>
    80002e34:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e38:	cd85                	beqz	a1,80002e70 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002e3a:	000b2503          	lw	a0,0(s6)
    80002e3e:	fffff097          	auipc	ra,0xfffff
    80002e42:	496080e7          	jalr	1174(ra) # 800022d4 <bread>
    80002e46:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e48:	3ff4f713          	andi	a4,s1,1023
    80002e4c:	40ec87bb          	subw	a5,s9,a4
    80002e50:	413a86bb          	subw	a3,s5,s3
    80002e54:	8d3e                	mv	s10,a5
    80002e56:	2781                	sext.w	a5,a5
    80002e58:	0006861b          	sext.w	a2,a3
    80002e5c:	f8f679e3          	bgeu	a2,a5,80002dee <readi+0x4c>
    80002e60:	8d36                	mv	s10,a3
    80002e62:	b771                	j	80002dee <readi+0x4c>
      brelse(bp);
    80002e64:	854a                	mv	a0,s2
    80002e66:	fffff097          	auipc	ra,0xfffff
    80002e6a:	59e080e7          	jalr	1438(ra) # 80002404 <brelse>
      tot = -1;
    80002e6e:	59fd                	li	s3,-1
  }
  return tot;
    80002e70:	0009851b          	sext.w	a0,s3
}
    80002e74:	70a6                	ld	ra,104(sp)
    80002e76:	7406                	ld	s0,96(sp)
    80002e78:	64e6                	ld	s1,88(sp)
    80002e7a:	6946                	ld	s2,80(sp)
    80002e7c:	69a6                	ld	s3,72(sp)
    80002e7e:	6a06                	ld	s4,64(sp)
    80002e80:	7ae2                	ld	s5,56(sp)
    80002e82:	7b42                	ld	s6,48(sp)
    80002e84:	7ba2                	ld	s7,40(sp)
    80002e86:	7c02                	ld	s8,32(sp)
    80002e88:	6ce2                	ld	s9,24(sp)
    80002e8a:	6d42                	ld	s10,16(sp)
    80002e8c:	6da2                	ld	s11,8(sp)
    80002e8e:	6165                	addi	sp,sp,112
    80002e90:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e92:	89d6                	mv	s3,s5
    80002e94:	bff1                	j	80002e70 <readi+0xce>
    return 0;
    80002e96:	4501                	li	a0,0
}
    80002e98:	8082                	ret

0000000080002e9a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e9a:	457c                	lw	a5,76(a0)
    80002e9c:	10d7e863          	bltu	a5,a3,80002fac <writei+0x112>
{
    80002ea0:	7159                	addi	sp,sp,-112
    80002ea2:	f486                	sd	ra,104(sp)
    80002ea4:	f0a2                	sd	s0,96(sp)
    80002ea6:	eca6                	sd	s1,88(sp)
    80002ea8:	e8ca                	sd	s2,80(sp)
    80002eaa:	e4ce                	sd	s3,72(sp)
    80002eac:	e0d2                	sd	s4,64(sp)
    80002eae:	fc56                	sd	s5,56(sp)
    80002eb0:	f85a                	sd	s6,48(sp)
    80002eb2:	f45e                	sd	s7,40(sp)
    80002eb4:	f062                	sd	s8,32(sp)
    80002eb6:	ec66                	sd	s9,24(sp)
    80002eb8:	e86a                	sd	s10,16(sp)
    80002eba:	e46e                	sd	s11,8(sp)
    80002ebc:	1880                	addi	s0,sp,112
    80002ebe:	8aaa                	mv	s5,a0
    80002ec0:	8bae                	mv	s7,a1
    80002ec2:	8a32                	mv	s4,a2
    80002ec4:	8936                	mv	s2,a3
    80002ec6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ec8:	00e687bb          	addw	a5,a3,a4
    80002ecc:	0ed7e263          	bltu	a5,a3,80002fb0 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ed0:	00043737          	lui	a4,0x43
    80002ed4:	0ef76063          	bltu	a4,a5,80002fb4 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ed8:	0c0b0863          	beqz	s6,80002fa8 <writei+0x10e>
    80002edc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ede:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ee2:	5c7d                	li	s8,-1
    80002ee4:	a091                	j	80002f28 <writei+0x8e>
    80002ee6:	020d1d93          	slli	s11,s10,0x20
    80002eea:	020ddd93          	srli	s11,s11,0x20
    80002eee:	05848513          	addi	a0,s1,88
    80002ef2:	86ee                	mv	a3,s11
    80002ef4:	8652                	mv	a2,s4
    80002ef6:	85de                	mv	a1,s7
    80002ef8:	953a                	add	a0,a0,a4
    80002efa:	fffff097          	auipc	ra,0xfffff
    80002efe:	a46080e7          	jalr	-1466(ra) # 80001940 <either_copyin>
    80002f02:	07850263          	beq	a0,s8,80002f66 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f06:	8526                	mv	a0,s1
    80002f08:	00000097          	auipc	ra,0x0
    80002f0c:	780080e7          	jalr	1920(ra) # 80003688 <log_write>
    brelse(bp);
    80002f10:	8526                	mv	a0,s1
    80002f12:	fffff097          	auipc	ra,0xfffff
    80002f16:	4f2080e7          	jalr	1266(ra) # 80002404 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f1a:	013d09bb          	addw	s3,s10,s3
    80002f1e:	012d093b          	addw	s2,s10,s2
    80002f22:	9a6e                	add	s4,s4,s11
    80002f24:	0569f663          	bgeu	s3,s6,80002f70 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002f28:	00a9559b          	srliw	a1,s2,0xa
    80002f2c:	8556                	mv	a0,s5
    80002f2e:	fffff097          	auipc	ra,0xfffff
    80002f32:	7a0080e7          	jalr	1952(ra) # 800026ce <bmap>
    80002f36:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f3a:	c99d                	beqz	a1,80002f70 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002f3c:	000aa503          	lw	a0,0(s5)
    80002f40:	fffff097          	auipc	ra,0xfffff
    80002f44:	394080e7          	jalr	916(ra) # 800022d4 <bread>
    80002f48:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f4a:	3ff97713          	andi	a4,s2,1023
    80002f4e:	40ec87bb          	subw	a5,s9,a4
    80002f52:	413b06bb          	subw	a3,s6,s3
    80002f56:	8d3e                	mv	s10,a5
    80002f58:	2781                	sext.w	a5,a5
    80002f5a:	0006861b          	sext.w	a2,a3
    80002f5e:	f8f674e3          	bgeu	a2,a5,80002ee6 <writei+0x4c>
    80002f62:	8d36                	mv	s10,a3
    80002f64:	b749                	j	80002ee6 <writei+0x4c>
      brelse(bp);
    80002f66:	8526                	mv	a0,s1
    80002f68:	fffff097          	auipc	ra,0xfffff
    80002f6c:	49c080e7          	jalr	1180(ra) # 80002404 <brelse>
  }

  if(off > ip->size)
    80002f70:	04caa783          	lw	a5,76(s5)
    80002f74:	0127f463          	bgeu	a5,s2,80002f7c <writei+0xe2>
    ip->size = off;
    80002f78:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f7c:	8556                	mv	a0,s5
    80002f7e:	00000097          	auipc	ra,0x0
    80002f82:	aa6080e7          	jalr	-1370(ra) # 80002a24 <iupdate>

  return tot;
    80002f86:	0009851b          	sext.w	a0,s3
}
    80002f8a:	70a6                	ld	ra,104(sp)
    80002f8c:	7406                	ld	s0,96(sp)
    80002f8e:	64e6                	ld	s1,88(sp)
    80002f90:	6946                	ld	s2,80(sp)
    80002f92:	69a6                	ld	s3,72(sp)
    80002f94:	6a06                	ld	s4,64(sp)
    80002f96:	7ae2                	ld	s5,56(sp)
    80002f98:	7b42                	ld	s6,48(sp)
    80002f9a:	7ba2                	ld	s7,40(sp)
    80002f9c:	7c02                	ld	s8,32(sp)
    80002f9e:	6ce2                	ld	s9,24(sp)
    80002fa0:	6d42                	ld	s10,16(sp)
    80002fa2:	6da2                	ld	s11,8(sp)
    80002fa4:	6165                	addi	sp,sp,112
    80002fa6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fa8:	89da                	mv	s3,s6
    80002faa:	bfc9                	j	80002f7c <writei+0xe2>
    return -1;
    80002fac:	557d                	li	a0,-1
}
    80002fae:	8082                	ret
    return -1;
    80002fb0:	557d                	li	a0,-1
    80002fb2:	bfe1                	j	80002f8a <writei+0xf0>
    return -1;
    80002fb4:	557d                	li	a0,-1
    80002fb6:	bfd1                	j	80002f8a <writei+0xf0>

0000000080002fb8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002fb8:	1141                	addi	sp,sp,-16
    80002fba:	e406                	sd	ra,8(sp)
    80002fbc:	e022                	sd	s0,0(sp)
    80002fbe:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fc0:	4639                	li	a2,14
    80002fc2:	ffffd097          	auipc	ra,0xffffd
    80002fc6:	28e080e7          	jalr	654(ra) # 80000250 <strncmp>
}
    80002fca:	60a2                	ld	ra,8(sp)
    80002fcc:	6402                	ld	s0,0(sp)
    80002fce:	0141                	addi	sp,sp,16
    80002fd0:	8082                	ret

0000000080002fd2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fd2:	7139                	addi	sp,sp,-64
    80002fd4:	fc06                	sd	ra,56(sp)
    80002fd6:	f822                	sd	s0,48(sp)
    80002fd8:	f426                	sd	s1,40(sp)
    80002fda:	f04a                	sd	s2,32(sp)
    80002fdc:	ec4e                	sd	s3,24(sp)
    80002fde:	e852                	sd	s4,16(sp)
    80002fe0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fe2:	04451703          	lh	a4,68(a0)
    80002fe6:	4785                	li	a5,1
    80002fe8:	00f71a63          	bne	a4,a5,80002ffc <dirlookup+0x2a>
    80002fec:	892a                	mv	s2,a0
    80002fee:	89ae                	mv	s3,a1
    80002ff0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ff2:	457c                	lw	a5,76(a0)
    80002ff4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002ff6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ff8:	e79d                	bnez	a5,80003026 <dirlookup+0x54>
    80002ffa:	a8a5                	j	80003072 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002ffc:	00005517          	auipc	a0,0x5
    80003000:	57450513          	addi	a0,a0,1396 # 80008570 <syscalls+0x1b0>
    80003004:	00003097          	auipc	ra,0x3
    80003008:	c5e080e7          	jalr	-930(ra) # 80005c62 <panic>
      panic("dirlookup read");
    8000300c:	00005517          	auipc	a0,0x5
    80003010:	57c50513          	addi	a0,a0,1404 # 80008588 <syscalls+0x1c8>
    80003014:	00003097          	auipc	ra,0x3
    80003018:	c4e080e7          	jalr	-946(ra) # 80005c62 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000301c:	24c1                	addiw	s1,s1,16
    8000301e:	04c92783          	lw	a5,76(s2)
    80003022:	04f4f763          	bgeu	s1,a5,80003070 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003026:	4741                	li	a4,16
    80003028:	86a6                	mv	a3,s1
    8000302a:	fc040613          	addi	a2,s0,-64
    8000302e:	4581                	li	a1,0
    80003030:	854a                	mv	a0,s2
    80003032:	00000097          	auipc	ra,0x0
    80003036:	d70080e7          	jalr	-656(ra) # 80002da2 <readi>
    8000303a:	47c1                	li	a5,16
    8000303c:	fcf518e3          	bne	a0,a5,8000300c <dirlookup+0x3a>
    if(de.inum == 0)
    80003040:	fc045783          	lhu	a5,-64(s0)
    80003044:	dfe1                	beqz	a5,8000301c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003046:	fc240593          	addi	a1,s0,-62
    8000304a:	854e                	mv	a0,s3
    8000304c:	00000097          	auipc	ra,0x0
    80003050:	f6c080e7          	jalr	-148(ra) # 80002fb8 <namecmp>
    80003054:	f561                	bnez	a0,8000301c <dirlookup+0x4a>
      if(poff)
    80003056:	000a0463          	beqz	s4,8000305e <dirlookup+0x8c>
        *poff = off;
    8000305a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000305e:	fc045583          	lhu	a1,-64(s0)
    80003062:	00092503          	lw	a0,0(s2)
    80003066:	fffff097          	auipc	ra,0xfffff
    8000306a:	750080e7          	jalr	1872(ra) # 800027b6 <iget>
    8000306e:	a011                	j	80003072 <dirlookup+0xa0>
  return 0;
    80003070:	4501                	li	a0,0
}
    80003072:	70e2                	ld	ra,56(sp)
    80003074:	7442                	ld	s0,48(sp)
    80003076:	74a2                	ld	s1,40(sp)
    80003078:	7902                	ld	s2,32(sp)
    8000307a:	69e2                	ld	s3,24(sp)
    8000307c:	6a42                	ld	s4,16(sp)
    8000307e:	6121                	addi	sp,sp,64
    80003080:	8082                	ret

0000000080003082 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003082:	711d                	addi	sp,sp,-96
    80003084:	ec86                	sd	ra,88(sp)
    80003086:	e8a2                	sd	s0,80(sp)
    80003088:	e4a6                	sd	s1,72(sp)
    8000308a:	e0ca                	sd	s2,64(sp)
    8000308c:	fc4e                	sd	s3,56(sp)
    8000308e:	f852                	sd	s4,48(sp)
    80003090:	f456                	sd	s5,40(sp)
    80003092:	f05a                	sd	s6,32(sp)
    80003094:	ec5e                	sd	s7,24(sp)
    80003096:	e862                	sd	s8,16(sp)
    80003098:	e466                	sd	s9,8(sp)
    8000309a:	1080                	addi	s0,sp,96
    8000309c:	84aa                	mv	s1,a0
    8000309e:	8b2e                	mv	s6,a1
    800030a0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800030a2:	00054703          	lbu	a4,0(a0)
    800030a6:	02f00793          	li	a5,47
    800030aa:	02f70363          	beq	a4,a5,800030d0 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030ae:	ffffe097          	auipc	ra,0xffffe
    800030b2:	d90080e7          	jalr	-624(ra) # 80000e3e <myproc>
    800030b6:	15053503          	ld	a0,336(a0)
    800030ba:	00000097          	auipc	ra,0x0
    800030be:	9f6080e7          	jalr	-1546(ra) # 80002ab0 <idup>
    800030c2:	89aa                	mv	s3,a0
  while(*path == '/')
    800030c4:	02f00913          	li	s2,47
  len = path - s;
    800030c8:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800030ca:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030cc:	4c05                	li	s8,1
    800030ce:	a865                	j	80003186 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800030d0:	4585                	li	a1,1
    800030d2:	4505                	li	a0,1
    800030d4:	fffff097          	auipc	ra,0xfffff
    800030d8:	6e2080e7          	jalr	1762(ra) # 800027b6 <iget>
    800030dc:	89aa                	mv	s3,a0
    800030de:	b7dd                	j	800030c4 <namex+0x42>
      iunlockput(ip);
    800030e0:	854e                	mv	a0,s3
    800030e2:	00000097          	auipc	ra,0x0
    800030e6:	c6e080e7          	jalr	-914(ra) # 80002d50 <iunlockput>
      return 0;
    800030ea:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030ec:	854e                	mv	a0,s3
    800030ee:	60e6                	ld	ra,88(sp)
    800030f0:	6446                	ld	s0,80(sp)
    800030f2:	64a6                	ld	s1,72(sp)
    800030f4:	6906                	ld	s2,64(sp)
    800030f6:	79e2                	ld	s3,56(sp)
    800030f8:	7a42                	ld	s4,48(sp)
    800030fa:	7aa2                	ld	s5,40(sp)
    800030fc:	7b02                	ld	s6,32(sp)
    800030fe:	6be2                	ld	s7,24(sp)
    80003100:	6c42                	ld	s8,16(sp)
    80003102:	6ca2                	ld	s9,8(sp)
    80003104:	6125                	addi	sp,sp,96
    80003106:	8082                	ret
      iunlock(ip);
    80003108:	854e                	mv	a0,s3
    8000310a:	00000097          	auipc	ra,0x0
    8000310e:	aa6080e7          	jalr	-1370(ra) # 80002bb0 <iunlock>
      return ip;
    80003112:	bfe9                	j	800030ec <namex+0x6a>
      iunlockput(ip);
    80003114:	854e                	mv	a0,s3
    80003116:	00000097          	auipc	ra,0x0
    8000311a:	c3a080e7          	jalr	-966(ra) # 80002d50 <iunlockput>
      return 0;
    8000311e:	89d2                	mv	s3,s4
    80003120:	b7f1                	j	800030ec <namex+0x6a>
  len = path - s;
    80003122:	40b48633          	sub	a2,s1,a1
    80003126:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000312a:	094cd463          	bge	s9,s4,800031b2 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000312e:	4639                	li	a2,14
    80003130:	8556                	mv	a0,s5
    80003132:	ffffd097          	auipc	ra,0xffffd
    80003136:	0a6080e7          	jalr	166(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000313a:	0004c783          	lbu	a5,0(s1)
    8000313e:	01279763          	bne	a5,s2,8000314c <namex+0xca>
    path++;
    80003142:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003144:	0004c783          	lbu	a5,0(s1)
    80003148:	ff278de3          	beq	a5,s2,80003142 <namex+0xc0>
    ilock(ip);
    8000314c:	854e                	mv	a0,s3
    8000314e:	00000097          	auipc	ra,0x0
    80003152:	9a0080e7          	jalr	-1632(ra) # 80002aee <ilock>
    if(ip->type != T_DIR){
    80003156:	04499783          	lh	a5,68(s3)
    8000315a:	f98793e3          	bne	a5,s8,800030e0 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000315e:	000b0563          	beqz	s6,80003168 <namex+0xe6>
    80003162:	0004c783          	lbu	a5,0(s1)
    80003166:	d3cd                	beqz	a5,80003108 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003168:	865e                	mv	a2,s7
    8000316a:	85d6                	mv	a1,s5
    8000316c:	854e                	mv	a0,s3
    8000316e:	00000097          	auipc	ra,0x0
    80003172:	e64080e7          	jalr	-412(ra) # 80002fd2 <dirlookup>
    80003176:	8a2a                	mv	s4,a0
    80003178:	dd51                	beqz	a0,80003114 <namex+0x92>
    iunlockput(ip);
    8000317a:	854e                	mv	a0,s3
    8000317c:	00000097          	auipc	ra,0x0
    80003180:	bd4080e7          	jalr	-1068(ra) # 80002d50 <iunlockput>
    ip = next;
    80003184:	89d2                	mv	s3,s4
  while(*path == '/')
    80003186:	0004c783          	lbu	a5,0(s1)
    8000318a:	05279763          	bne	a5,s2,800031d8 <namex+0x156>
    path++;
    8000318e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003190:	0004c783          	lbu	a5,0(s1)
    80003194:	ff278de3          	beq	a5,s2,8000318e <namex+0x10c>
  if(*path == 0)
    80003198:	c79d                	beqz	a5,800031c6 <namex+0x144>
    path++;
    8000319a:	85a6                	mv	a1,s1
  len = path - s;
    8000319c:	8a5e                	mv	s4,s7
    8000319e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800031a0:	01278963          	beq	a5,s2,800031b2 <namex+0x130>
    800031a4:	dfbd                	beqz	a5,80003122 <namex+0xa0>
    path++;
    800031a6:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800031a8:	0004c783          	lbu	a5,0(s1)
    800031ac:	ff279ce3          	bne	a5,s2,800031a4 <namex+0x122>
    800031b0:	bf8d                	j	80003122 <namex+0xa0>
    memmove(name, s, len);
    800031b2:	2601                	sext.w	a2,a2
    800031b4:	8556                	mv	a0,s5
    800031b6:	ffffd097          	auipc	ra,0xffffd
    800031ba:	022080e7          	jalr	34(ra) # 800001d8 <memmove>
    name[len] = 0;
    800031be:	9a56                	add	s4,s4,s5
    800031c0:	000a0023          	sb	zero,0(s4)
    800031c4:	bf9d                	j	8000313a <namex+0xb8>
  if(nameiparent){
    800031c6:	f20b03e3          	beqz	s6,800030ec <namex+0x6a>
    iput(ip);
    800031ca:	854e                	mv	a0,s3
    800031cc:	00000097          	auipc	ra,0x0
    800031d0:	adc080e7          	jalr	-1316(ra) # 80002ca8 <iput>
    return 0;
    800031d4:	4981                	li	s3,0
    800031d6:	bf19                	j	800030ec <namex+0x6a>
  if(*path == 0)
    800031d8:	d7fd                	beqz	a5,800031c6 <namex+0x144>
  while(*path != '/' && *path != 0)
    800031da:	0004c783          	lbu	a5,0(s1)
    800031de:	85a6                	mv	a1,s1
    800031e0:	b7d1                	j	800031a4 <namex+0x122>

00000000800031e2 <dirlink>:
{
    800031e2:	7139                	addi	sp,sp,-64
    800031e4:	fc06                	sd	ra,56(sp)
    800031e6:	f822                	sd	s0,48(sp)
    800031e8:	f426                	sd	s1,40(sp)
    800031ea:	f04a                	sd	s2,32(sp)
    800031ec:	ec4e                	sd	s3,24(sp)
    800031ee:	e852                	sd	s4,16(sp)
    800031f0:	0080                	addi	s0,sp,64
    800031f2:	892a                	mv	s2,a0
    800031f4:	8a2e                	mv	s4,a1
    800031f6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031f8:	4601                	li	a2,0
    800031fa:	00000097          	auipc	ra,0x0
    800031fe:	dd8080e7          	jalr	-552(ra) # 80002fd2 <dirlookup>
    80003202:	e93d                	bnez	a0,80003278 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003204:	04c92483          	lw	s1,76(s2)
    80003208:	c49d                	beqz	s1,80003236 <dirlink+0x54>
    8000320a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000320c:	4741                	li	a4,16
    8000320e:	86a6                	mv	a3,s1
    80003210:	fc040613          	addi	a2,s0,-64
    80003214:	4581                	li	a1,0
    80003216:	854a                	mv	a0,s2
    80003218:	00000097          	auipc	ra,0x0
    8000321c:	b8a080e7          	jalr	-1142(ra) # 80002da2 <readi>
    80003220:	47c1                	li	a5,16
    80003222:	06f51163          	bne	a0,a5,80003284 <dirlink+0xa2>
    if(de.inum == 0)
    80003226:	fc045783          	lhu	a5,-64(s0)
    8000322a:	c791                	beqz	a5,80003236 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000322c:	24c1                	addiw	s1,s1,16
    8000322e:	04c92783          	lw	a5,76(s2)
    80003232:	fcf4ede3          	bltu	s1,a5,8000320c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003236:	4639                	li	a2,14
    80003238:	85d2                	mv	a1,s4
    8000323a:	fc240513          	addi	a0,s0,-62
    8000323e:	ffffd097          	auipc	ra,0xffffd
    80003242:	04e080e7          	jalr	78(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003246:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000324a:	4741                	li	a4,16
    8000324c:	86a6                	mv	a3,s1
    8000324e:	fc040613          	addi	a2,s0,-64
    80003252:	4581                	li	a1,0
    80003254:	854a                	mv	a0,s2
    80003256:	00000097          	auipc	ra,0x0
    8000325a:	c44080e7          	jalr	-956(ra) # 80002e9a <writei>
    8000325e:	1541                	addi	a0,a0,-16
    80003260:	00a03533          	snez	a0,a0
    80003264:	40a00533          	neg	a0,a0
}
    80003268:	70e2                	ld	ra,56(sp)
    8000326a:	7442                	ld	s0,48(sp)
    8000326c:	74a2                	ld	s1,40(sp)
    8000326e:	7902                	ld	s2,32(sp)
    80003270:	69e2                	ld	s3,24(sp)
    80003272:	6a42                	ld	s4,16(sp)
    80003274:	6121                	addi	sp,sp,64
    80003276:	8082                	ret
    iput(ip);
    80003278:	00000097          	auipc	ra,0x0
    8000327c:	a30080e7          	jalr	-1488(ra) # 80002ca8 <iput>
    return -1;
    80003280:	557d                	li	a0,-1
    80003282:	b7dd                	j	80003268 <dirlink+0x86>
      panic("dirlink read");
    80003284:	00005517          	auipc	a0,0x5
    80003288:	31450513          	addi	a0,a0,788 # 80008598 <syscalls+0x1d8>
    8000328c:	00003097          	auipc	ra,0x3
    80003290:	9d6080e7          	jalr	-1578(ra) # 80005c62 <panic>

0000000080003294 <namei>:

struct inode*
namei(char *path)
{
    80003294:	1101                	addi	sp,sp,-32
    80003296:	ec06                	sd	ra,24(sp)
    80003298:	e822                	sd	s0,16(sp)
    8000329a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000329c:	fe040613          	addi	a2,s0,-32
    800032a0:	4581                	li	a1,0
    800032a2:	00000097          	auipc	ra,0x0
    800032a6:	de0080e7          	jalr	-544(ra) # 80003082 <namex>
}
    800032aa:	60e2                	ld	ra,24(sp)
    800032ac:	6442                	ld	s0,16(sp)
    800032ae:	6105                	addi	sp,sp,32
    800032b0:	8082                	ret

00000000800032b2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032b2:	1141                	addi	sp,sp,-16
    800032b4:	e406                	sd	ra,8(sp)
    800032b6:	e022                	sd	s0,0(sp)
    800032b8:	0800                	addi	s0,sp,16
    800032ba:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032bc:	4585                	li	a1,1
    800032be:	00000097          	auipc	ra,0x0
    800032c2:	dc4080e7          	jalr	-572(ra) # 80003082 <namex>
}
    800032c6:	60a2                	ld	ra,8(sp)
    800032c8:	6402                	ld	s0,0(sp)
    800032ca:	0141                	addi	sp,sp,16
    800032cc:	8082                	ret

00000000800032ce <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032ce:	1101                	addi	sp,sp,-32
    800032d0:	ec06                	sd	ra,24(sp)
    800032d2:	e822                	sd	s0,16(sp)
    800032d4:	e426                	sd	s1,8(sp)
    800032d6:	e04a                	sd	s2,0(sp)
    800032d8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032da:	00015917          	auipc	s2,0x15
    800032de:	60690913          	addi	s2,s2,1542 # 800188e0 <log>
    800032e2:	01892583          	lw	a1,24(s2)
    800032e6:	02892503          	lw	a0,40(s2)
    800032ea:	fffff097          	auipc	ra,0xfffff
    800032ee:	fea080e7          	jalr	-22(ra) # 800022d4 <bread>
    800032f2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800032f4:	02c92683          	lw	a3,44(s2)
    800032f8:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800032fa:	02d05763          	blez	a3,80003328 <write_head+0x5a>
    800032fe:	00015797          	auipc	a5,0x15
    80003302:	61278793          	addi	a5,a5,1554 # 80018910 <log+0x30>
    80003306:	05c50713          	addi	a4,a0,92
    8000330a:	36fd                	addiw	a3,a3,-1
    8000330c:	1682                	slli	a3,a3,0x20
    8000330e:	9281                	srli	a3,a3,0x20
    80003310:	068a                	slli	a3,a3,0x2
    80003312:	00015617          	auipc	a2,0x15
    80003316:	60260613          	addi	a2,a2,1538 # 80018914 <log+0x34>
    8000331a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000331c:	4390                	lw	a2,0(a5)
    8000331e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003320:	0791                	addi	a5,a5,4
    80003322:	0711                	addi	a4,a4,4
    80003324:	fed79ce3          	bne	a5,a3,8000331c <write_head+0x4e>
  }
  bwrite(buf);
    80003328:	8526                	mv	a0,s1
    8000332a:	fffff097          	auipc	ra,0xfffff
    8000332e:	09c080e7          	jalr	156(ra) # 800023c6 <bwrite>
  brelse(buf);
    80003332:	8526                	mv	a0,s1
    80003334:	fffff097          	auipc	ra,0xfffff
    80003338:	0d0080e7          	jalr	208(ra) # 80002404 <brelse>
}
    8000333c:	60e2                	ld	ra,24(sp)
    8000333e:	6442                	ld	s0,16(sp)
    80003340:	64a2                	ld	s1,8(sp)
    80003342:	6902                	ld	s2,0(sp)
    80003344:	6105                	addi	sp,sp,32
    80003346:	8082                	ret

0000000080003348 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003348:	00015797          	auipc	a5,0x15
    8000334c:	5c47a783          	lw	a5,1476(a5) # 8001890c <log+0x2c>
    80003350:	0af05d63          	blez	a5,8000340a <install_trans+0xc2>
{
    80003354:	7139                	addi	sp,sp,-64
    80003356:	fc06                	sd	ra,56(sp)
    80003358:	f822                	sd	s0,48(sp)
    8000335a:	f426                	sd	s1,40(sp)
    8000335c:	f04a                	sd	s2,32(sp)
    8000335e:	ec4e                	sd	s3,24(sp)
    80003360:	e852                	sd	s4,16(sp)
    80003362:	e456                	sd	s5,8(sp)
    80003364:	e05a                	sd	s6,0(sp)
    80003366:	0080                	addi	s0,sp,64
    80003368:	8b2a                	mv	s6,a0
    8000336a:	00015a97          	auipc	s5,0x15
    8000336e:	5a6a8a93          	addi	s5,s5,1446 # 80018910 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003372:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003374:	00015997          	auipc	s3,0x15
    80003378:	56c98993          	addi	s3,s3,1388 # 800188e0 <log>
    8000337c:	a035                	j	800033a8 <install_trans+0x60>
      bunpin(dbuf);
    8000337e:	8526                	mv	a0,s1
    80003380:	fffff097          	auipc	ra,0xfffff
    80003384:	15e080e7          	jalr	350(ra) # 800024de <bunpin>
    brelse(lbuf);
    80003388:	854a                	mv	a0,s2
    8000338a:	fffff097          	auipc	ra,0xfffff
    8000338e:	07a080e7          	jalr	122(ra) # 80002404 <brelse>
    brelse(dbuf);
    80003392:	8526                	mv	a0,s1
    80003394:	fffff097          	auipc	ra,0xfffff
    80003398:	070080e7          	jalr	112(ra) # 80002404 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000339c:	2a05                	addiw	s4,s4,1
    8000339e:	0a91                	addi	s5,s5,4
    800033a0:	02c9a783          	lw	a5,44(s3)
    800033a4:	04fa5963          	bge	s4,a5,800033f6 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033a8:	0189a583          	lw	a1,24(s3)
    800033ac:	014585bb          	addw	a1,a1,s4
    800033b0:	2585                	addiw	a1,a1,1
    800033b2:	0289a503          	lw	a0,40(s3)
    800033b6:	fffff097          	auipc	ra,0xfffff
    800033ba:	f1e080e7          	jalr	-226(ra) # 800022d4 <bread>
    800033be:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033c0:	000aa583          	lw	a1,0(s5)
    800033c4:	0289a503          	lw	a0,40(s3)
    800033c8:	fffff097          	auipc	ra,0xfffff
    800033cc:	f0c080e7          	jalr	-244(ra) # 800022d4 <bread>
    800033d0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033d2:	40000613          	li	a2,1024
    800033d6:	05890593          	addi	a1,s2,88
    800033da:	05850513          	addi	a0,a0,88
    800033de:	ffffd097          	auipc	ra,0xffffd
    800033e2:	dfa080e7          	jalr	-518(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033e6:	8526                	mv	a0,s1
    800033e8:	fffff097          	auipc	ra,0xfffff
    800033ec:	fde080e7          	jalr	-34(ra) # 800023c6 <bwrite>
    if(recovering == 0)
    800033f0:	f80b1ce3          	bnez	s6,80003388 <install_trans+0x40>
    800033f4:	b769                	j	8000337e <install_trans+0x36>
}
    800033f6:	70e2                	ld	ra,56(sp)
    800033f8:	7442                	ld	s0,48(sp)
    800033fa:	74a2                	ld	s1,40(sp)
    800033fc:	7902                	ld	s2,32(sp)
    800033fe:	69e2                	ld	s3,24(sp)
    80003400:	6a42                	ld	s4,16(sp)
    80003402:	6aa2                	ld	s5,8(sp)
    80003404:	6b02                	ld	s6,0(sp)
    80003406:	6121                	addi	sp,sp,64
    80003408:	8082                	ret
    8000340a:	8082                	ret

000000008000340c <initlog>:
{
    8000340c:	7179                	addi	sp,sp,-48
    8000340e:	f406                	sd	ra,40(sp)
    80003410:	f022                	sd	s0,32(sp)
    80003412:	ec26                	sd	s1,24(sp)
    80003414:	e84a                	sd	s2,16(sp)
    80003416:	e44e                	sd	s3,8(sp)
    80003418:	1800                	addi	s0,sp,48
    8000341a:	892a                	mv	s2,a0
    8000341c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000341e:	00015497          	auipc	s1,0x15
    80003422:	4c248493          	addi	s1,s1,1218 # 800188e0 <log>
    80003426:	00005597          	auipc	a1,0x5
    8000342a:	18258593          	addi	a1,a1,386 # 800085a8 <syscalls+0x1e8>
    8000342e:	8526                	mv	a0,s1
    80003430:	00003097          	auipc	ra,0x3
    80003434:	cec080e7          	jalr	-788(ra) # 8000611c <initlock>
  log.start = sb->logstart;
    80003438:	0149a583          	lw	a1,20(s3)
    8000343c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000343e:	0109a783          	lw	a5,16(s3)
    80003442:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003444:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003448:	854a                	mv	a0,s2
    8000344a:	fffff097          	auipc	ra,0xfffff
    8000344e:	e8a080e7          	jalr	-374(ra) # 800022d4 <bread>
  log.lh.n = lh->n;
    80003452:	4d3c                	lw	a5,88(a0)
    80003454:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003456:	02f05563          	blez	a5,80003480 <initlog+0x74>
    8000345a:	05c50713          	addi	a4,a0,92
    8000345e:	00015697          	auipc	a3,0x15
    80003462:	4b268693          	addi	a3,a3,1202 # 80018910 <log+0x30>
    80003466:	37fd                	addiw	a5,a5,-1
    80003468:	1782                	slli	a5,a5,0x20
    8000346a:	9381                	srli	a5,a5,0x20
    8000346c:	078a                	slli	a5,a5,0x2
    8000346e:	06050613          	addi	a2,a0,96
    80003472:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003474:	4310                	lw	a2,0(a4)
    80003476:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003478:	0711                	addi	a4,a4,4
    8000347a:	0691                	addi	a3,a3,4
    8000347c:	fef71ce3          	bne	a4,a5,80003474 <initlog+0x68>
  brelse(buf);
    80003480:	fffff097          	auipc	ra,0xfffff
    80003484:	f84080e7          	jalr	-124(ra) # 80002404 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003488:	4505                	li	a0,1
    8000348a:	00000097          	auipc	ra,0x0
    8000348e:	ebe080e7          	jalr	-322(ra) # 80003348 <install_trans>
  log.lh.n = 0;
    80003492:	00015797          	auipc	a5,0x15
    80003496:	4607ad23          	sw	zero,1146(a5) # 8001890c <log+0x2c>
  write_head(); // clear the log
    8000349a:	00000097          	auipc	ra,0x0
    8000349e:	e34080e7          	jalr	-460(ra) # 800032ce <write_head>
}
    800034a2:	70a2                	ld	ra,40(sp)
    800034a4:	7402                	ld	s0,32(sp)
    800034a6:	64e2                	ld	s1,24(sp)
    800034a8:	6942                	ld	s2,16(sp)
    800034aa:	69a2                	ld	s3,8(sp)
    800034ac:	6145                	addi	sp,sp,48
    800034ae:	8082                	ret

00000000800034b0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034b0:	1101                	addi	sp,sp,-32
    800034b2:	ec06                	sd	ra,24(sp)
    800034b4:	e822                	sd	s0,16(sp)
    800034b6:	e426                	sd	s1,8(sp)
    800034b8:	e04a                	sd	s2,0(sp)
    800034ba:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034bc:	00015517          	auipc	a0,0x15
    800034c0:	42450513          	addi	a0,a0,1060 # 800188e0 <log>
    800034c4:	00003097          	auipc	ra,0x3
    800034c8:	ce8080e7          	jalr	-792(ra) # 800061ac <acquire>
  while(1){
    if(log.committing){
    800034cc:	00015497          	auipc	s1,0x15
    800034d0:	41448493          	addi	s1,s1,1044 # 800188e0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034d4:	4979                	li	s2,30
    800034d6:	a039                	j	800034e4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800034d8:	85a6                	mv	a1,s1
    800034da:	8526                	mv	a0,s1
    800034dc:	ffffe097          	auipc	ra,0xffffe
    800034e0:	006080e7          	jalr	6(ra) # 800014e2 <sleep>
    if(log.committing){
    800034e4:	50dc                	lw	a5,36(s1)
    800034e6:	fbed                	bnez	a5,800034d8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034e8:	509c                	lw	a5,32(s1)
    800034ea:	0017871b          	addiw	a4,a5,1
    800034ee:	0007069b          	sext.w	a3,a4
    800034f2:	0027179b          	slliw	a5,a4,0x2
    800034f6:	9fb9                	addw	a5,a5,a4
    800034f8:	0017979b          	slliw	a5,a5,0x1
    800034fc:	54d8                	lw	a4,44(s1)
    800034fe:	9fb9                	addw	a5,a5,a4
    80003500:	00f95963          	bge	s2,a5,80003512 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003504:	85a6                	mv	a1,s1
    80003506:	8526                	mv	a0,s1
    80003508:	ffffe097          	auipc	ra,0xffffe
    8000350c:	fda080e7          	jalr	-38(ra) # 800014e2 <sleep>
    80003510:	bfd1                	j	800034e4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003512:	00015517          	auipc	a0,0x15
    80003516:	3ce50513          	addi	a0,a0,974 # 800188e0 <log>
    8000351a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000351c:	00003097          	auipc	ra,0x3
    80003520:	d44080e7          	jalr	-700(ra) # 80006260 <release>
      break;
    }
  }
}
    80003524:	60e2                	ld	ra,24(sp)
    80003526:	6442                	ld	s0,16(sp)
    80003528:	64a2                	ld	s1,8(sp)
    8000352a:	6902                	ld	s2,0(sp)
    8000352c:	6105                	addi	sp,sp,32
    8000352e:	8082                	ret

0000000080003530 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003530:	7139                	addi	sp,sp,-64
    80003532:	fc06                	sd	ra,56(sp)
    80003534:	f822                	sd	s0,48(sp)
    80003536:	f426                	sd	s1,40(sp)
    80003538:	f04a                	sd	s2,32(sp)
    8000353a:	ec4e                	sd	s3,24(sp)
    8000353c:	e852                	sd	s4,16(sp)
    8000353e:	e456                	sd	s5,8(sp)
    80003540:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003542:	00015497          	auipc	s1,0x15
    80003546:	39e48493          	addi	s1,s1,926 # 800188e0 <log>
    8000354a:	8526                	mv	a0,s1
    8000354c:	00003097          	auipc	ra,0x3
    80003550:	c60080e7          	jalr	-928(ra) # 800061ac <acquire>
  log.outstanding -= 1;
    80003554:	509c                	lw	a5,32(s1)
    80003556:	37fd                	addiw	a5,a5,-1
    80003558:	0007891b          	sext.w	s2,a5
    8000355c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000355e:	50dc                	lw	a5,36(s1)
    80003560:	efb9                	bnez	a5,800035be <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003562:	06091663          	bnez	s2,800035ce <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003566:	00015497          	auipc	s1,0x15
    8000356a:	37a48493          	addi	s1,s1,890 # 800188e0 <log>
    8000356e:	4785                	li	a5,1
    80003570:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003572:	8526                	mv	a0,s1
    80003574:	00003097          	auipc	ra,0x3
    80003578:	cec080e7          	jalr	-788(ra) # 80006260 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000357c:	54dc                	lw	a5,44(s1)
    8000357e:	06f04763          	bgtz	a5,800035ec <end_op+0xbc>
    acquire(&log.lock);
    80003582:	00015497          	auipc	s1,0x15
    80003586:	35e48493          	addi	s1,s1,862 # 800188e0 <log>
    8000358a:	8526                	mv	a0,s1
    8000358c:	00003097          	auipc	ra,0x3
    80003590:	c20080e7          	jalr	-992(ra) # 800061ac <acquire>
    log.committing = 0;
    80003594:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003598:	8526                	mv	a0,s1
    8000359a:	ffffe097          	auipc	ra,0xffffe
    8000359e:	fac080e7          	jalr	-84(ra) # 80001546 <wakeup>
    release(&log.lock);
    800035a2:	8526                	mv	a0,s1
    800035a4:	00003097          	auipc	ra,0x3
    800035a8:	cbc080e7          	jalr	-836(ra) # 80006260 <release>
}
    800035ac:	70e2                	ld	ra,56(sp)
    800035ae:	7442                	ld	s0,48(sp)
    800035b0:	74a2                	ld	s1,40(sp)
    800035b2:	7902                	ld	s2,32(sp)
    800035b4:	69e2                	ld	s3,24(sp)
    800035b6:	6a42                	ld	s4,16(sp)
    800035b8:	6aa2                	ld	s5,8(sp)
    800035ba:	6121                	addi	sp,sp,64
    800035bc:	8082                	ret
    panic("log.committing");
    800035be:	00005517          	auipc	a0,0x5
    800035c2:	ff250513          	addi	a0,a0,-14 # 800085b0 <syscalls+0x1f0>
    800035c6:	00002097          	auipc	ra,0x2
    800035ca:	69c080e7          	jalr	1692(ra) # 80005c62 <panic>
    wakeup(&log);
    800035ce:	00015497          	auipc	s1,0x15
    800035d2:	31248493          	addi	s1,s1,786 # 800188e0 <log>
    800035d6:	8526                	mv	a0,s1
    800035d8:	ffffe097          	auipc	ra,0xffffe
    800035dc:	f6e080e7          	jalr	-146(ra) # 80001546 <wakeup>
  release(&log.lock);
    800035e0:	8526                	mv	a0,s1
    800035e2:	00003097          	auipc	ra,0x3
    800035e6:	c7e080e7          	jalr	-898(ra) # 80006260 <release>
  if(do_commit){
    800035ea:	b7c9                	j	800035ac <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035ec:	00015a97          	auipc	s5,0x15
    800035f0:	324a8a93          	addi	s5,s5,804 # 80018910 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035f4:	00015a17          	auipc	s4,0x15
    800035f8:	2eca0a13          	addi	s4,s4,748 # 800188e0 <log>
    800035fc:	018a2583          	lw	a1,24(s4)
    80003600:	012585bb          	addw	a1,a1,s2
    80003604:	2585                	addiw	a1,a1,1
    80003606:	028a2503          	lw	a0,40(s4)
    8000360a:	fffff097          	auipc	ra,0xfffff
    8000360e:	cca080e7          	jalr	-822(ra) # 800022d4 <bread>
    80003612:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003614:	000aa583          	lw	a1,0(s5)
    80003618:	028a2503          	lw	a0,40(s4)
    8000361c:	fffff097          	auipc	ra,0xfffff
    80003620:	cb8080e7          	jalr	-840(ra) # 800022d4 <bread>
    80003624:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003626:	40000613          	li	a2,1024
    8000362a:	05850593          	addi	a1,a0,88
    8000362e:	05848513          	addi	a0,s1,88
    80003632:	ffffd097          	auipc	ra,0xffffd
    80003636:	ba6080e7          	jalr	-1114(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    8000363a:	8526                	mv	a0,s1
    8000363c:	fffff097          	auipc	ra,0xfffff
    80003640:	d8a080e7          	jalr	-630(ra) # 800023c6 <bwrite>
    brelse(from);
    80003644:	854e                	mv	a0,s3
    80003646:	fffff097          	auipc	ra,0xfffff
    8000364a:	dbe080e7          	jalr	-578(ra) # 80002404 <brelse>
    brelse(to);
    8000364e:	8526                	mv	a0,s1
    80003650:	fffff097          	auipc	ra,0xfffff
    80003654:	db4080e7          	jalr	-588(ra) # 80002404 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003658:	2905                	addiw	s2,s2,1
    8000365a:	0a91                	addi	s5,s5,4
    8000365c:	02ca2783          	lw	a5,44(s4)
    80003660:	f8f94ee3          	blt	s2,a5,800035fc <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003664:	00000097          	auipc	ra,0x0
    80003668:	c6a080e7          	jalr	-918(ra) # 800032ce <write_head>
    install_trans(0); // Now install writes to home locations
    8000366c:	4501                	li	a0,0
    8000366e:	00000097          	auipc	ra,0x0
    80003672:	cda080e7          	jalr	-806(ra) # 80003348 <install_trans>
    log.lh.n = 0;
    80003676:	00015797          	auipc	a5,0x15
    8000367a:	2807ab23          	sw	zero,662(a5) # 8001890c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000367e:	00000097          	auipc	ra,0x0
    80003682:	c50080e7          	jalr	-944(ra) # 800032ce <write_head>
    80003686:	bdf5                	j	80003582 <end_op+0x52>

0000000080003688 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003688:	1101                	addi	sp,sp,-32
    8000368a:	ec06                	sd	ra,24(sp)
    8000368c:	e822                	sd	s0,16(sp)
    8000368e:	e426                	sd	s1,8(sp)
    80003690:	e04a                	sd	s2,0(sp)
    80003692:	1000                	addi	s0,sp,32
    80003694:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003696:	00015917          	auipc	s2,0x15
    8000369a:	24a90913          	addi	s2,s2,586 # 800188e0 <log>
    8000369e:	854a                	mv	a0,s2
    800036a0:	00003097          	auipc	ra,0x3
    800036a4:	b0c080e7          	jalr	-1268(ra) # 800061ac <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036a8:	02c92603          	lw	a2,44(s2)
    800036ac:	47f5                	li	a5,29
    800036ae:	06c7c563          	blt	a5,a2,80003718 <log_write+0x90>
    800036b2:	00015797          	auipc	a5,0x15
    800036b6:	24a7a783          	lw	a5,586(a5) # 800188fc <log+0x1c>
    800036ba:	37fd                	addiw	a5,a5,-1
    800036bc:	04f65e63          	bge	a2,a5,80003718 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036c0:	00015797          	auipc	a5,0x15
    800036c4:	2407a783          	lw	a5,576(a5) # 80018900 <log+0x20>
    800036c8:	06f05063          	blez	a5,80003728 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036cc:	4781                	li	a5,0
    800036ce:	06c05563          	blez	a2,80003738 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036d2:	44cc                	lw	a1,12(s1)
    800036d4:	00015717          	auipc	a4,0x15
    800036d8:	23c70713          	addi	a4,a4,572 # 80018910 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036dc:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036de:	4314                	lw	a3,0(a4)
    800036e0:	04b68c63          	beq	a3,a1,80003738 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036e4:	2785                	addiw	a5,a5,1
    800036e6:	0711                	addi	a4,a4,4
    800036e8:	fef61be3          	bne	a2,a5,800036de <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036ec:	0621                	addi	a2,a2,8
    800036ee:	060a                	slli	a2,a2,0x2
    800036f0:	00015797          	auipc	a5,0x15
    800036f4:	1f078793          	addi	a5,a5,496 # 800188e0 <log>
    800036f8:	963e                	add	a2,a2,a5
    800036fa:	44dc                	lw	a5,12(s1)
    800036fc:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800036fe:	8526                	mv	a0,s1
    80003700:	fffff097          	auipc	ra,0xfffff
    80003704:	da2080e7          	jalr	-606(ra) # 800024a2 <bpin>
    log.lh.n++;
    80003708:	00015717          	auipc	a4,0x15
    8000370c:	1d870713          	addi	a4,a4,472 # 800188e0 <log>
    80003710:	575c                	lw	a5,44(a4)
    80003712:	2785                	addiw	a5,a5,1
    80003714:	d75c                	sw	a5,44(a4)
    80003716:	a835                	j	80003752 <log_write+0xca>
    panic("too big a transaction");
    80003718:	00005517          	auipc	a0,0x5
    8000371c:	ea850513          	addi	a0,a0,-344 # 800085c0 <syscalls+0x200>
    80003720:	00002097          	auipc	ra,0x2
    80003724:	542080e7          	jalr	1346(ra) # 80005c62 <panic>
    panic("log_write outside of trans");
    80003728:	00005517          	auipc	a0,0x5
    8000372c:	eb050513          	addi	a0,a0,-336 # 800085d8 <syscalls+0x218>
    80003730:	00002097          	auipc	ra,0x2
    80003734:	532080e7          	jalr	1330(ra) # 80005c62 <panic>
  log.lh.block[i] = b->blockno;
    80003738:	00878713          	addi	a4,a5,8
    8000373c:	00271693          	slli	a3,a4,0x2
    80003740:	00015717          	auipc	a4,0x15
    80003744:	1a070713          	addi	a4,a4,416 # 800188e0 <log>
    80003748:	9736                	add	a4,a4,a3
    8000374a:	44d4                	lw	a3,12(s1)
    8000374c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000374e:	faf608e3          	beq	a2,a5,800036fe <log_write+0x76>
  }
  release(&log.lock);
    80003752:	00015517          	auipc	a0,0x15
    80003756:	18e50513          	addi	a0,a0,398 # 800188e0 <log>
    8000375a:	00003097          	auipc	ra,0x3
    8000375e:	b06080e7          	jalr	-1274(ra) # 80006260 <release>
}
    80003762:	60e2                	ld	ra,24(sp)
    80003764:	6442                	ld	s0,16(sp)
    80003766:	64a2                	ld	s1,8(sp)
    80003768:	6902                	ld	s2,0(sp)
    8000376a:	6105                	addi	sp,sp,32
    8000376c:	8082                	ret

000000008000376e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000376e:	1101                	addi	sp,sp,-32
    80003770:	ec06                	sd	ra,24(sp)
    80003772:	e822                	sd	s0,16(sp)
    80003774:	e426                	sd	s1,8(sp)
    80003776:	e04a                	sd	s2,0(sp)
    80003778:	1000                	addi	s0,sp,32
    8000377a:	84aa                	mv	s1,a0
    8000377c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000377e:	00005597          	auipc	a1,0x5
    80003782:	e7a58593          	addi	a1,a1,-390 # 800085f8 <syscalls+0x238>
    80003786:	0521                	addi	a0,a0,8
    80003788:	00003097          	auipc	ra,0x3
    8000378c:	994080e7          	jalr	-1644(ra) # 8000611c <initlock>
  lk->name = name;
    80003790:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003794:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003798:	0204a423          	sw	zero,40(s1)
}
    8000379c:	60e2                	ld	ra,24(sp)
    8000379e:	6442                	ld	s0,16(sp)
    800037a0:	64a2                	ld	s1,8(sp)
    800037a2:	6902                	ld	s2,0(sp)
    800037a4:	6105                	addi	sp,sp,32
    800037a6:	8082                	ret

00000000800037a8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037a8:	1101                	addi	sp,sp,-32
    800037aa:	ec06                	sd	ra,24(sp)
    800037ac:	e822                	sd	s0,16(sp)
    800037ae:	e426                	sd	s1,8(sp)
    800037b0:	e04a                	sd	s2,0(sp)
    800037b2:	1000                	addi	s0,sp,32
    800037b4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037b6:	00850913          	addi	s2,a0,8
    800037ba:	854a                	mv	a0,s2
    800037bc:	00003097          	auipc	ra,0x3
    800037c0:	9f0080e7          	jalr	-1552(ra) # 800061ac <acquire>
  while (lk->locked) {
    800037c4:	409c                	lw	a5,0(s1)
    800037c6:	cb89                	beqz	a5,800037d8 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037c8:	85ca                	mv	a1,s2
    800037ca:	8526                	mv	a0,s1
    800037cc:	ffffe097          	auipc	ra,0xffffe
    800037d0:	d16080e7          	jalr	-746(ra) # 800014e2 <sleep>
  while (lk->locked) {
    800037d4:	409c                	lw	a5,0(s1)
    800037d6:	fbed                	bnez	a5,800037c8 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037d8:	4785                	li	a5,1
    800037da:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037dc:	ffffd097          	auipc	ra,0xffffd
    800037e0:	662080e7          	jalr	1634(ra) # 80000e3e <myproc>
    800037e4:	591c                	lw	a5,48(a0)
    800037e6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037e8:	854a                	mv	a0,s2
    800037ea:	00003097          	auipc	ra,0x3
    800037ee:	a76080e7          	jalr	-1418(ra) # 80006260 <release>
}
    800037f2:	60e2                	ld	ra,24(sp)
    800037f4:	6442                	ld	s0,16(sp)
    800037f6:	64a2                	ld	s1,8(sp)
    800037f8:	6902                	ld	s2,0(sp)
    800037fa:	6105                	addi	sp,sp,32
    800037fc:	8082                	ret

00000000800037fe <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800037fe:	1101                	addi	sp,sp,-32
    80003800:	ec06                	sd	ra,24(sp)
    80003802:	e822                	sd	s0,16(sp)
    80003804:	e426                	sd	s1,8(sp)
    80003806:	e04a                	sd	s2,0(sp)
    80003808:	1000                	addi	s0,sp,32
    8000380a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000380c:	00850913          	addi	s2,a0,8
    80003810:	854a                	mv	a0,s2
    80003812:	00003097          	auipc	ra,0x3
    80003816:	99a080e7          	jalr	-1638(ra) # 800061ac <acquire>
  lk->locked = 0;
    8000381a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000381e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003822:	8526                	mv	a0,s1
    80003824:	ffffe097          	auipc	ra,0xffffe
    80003828:	d22080e7          	jalr	-734(ra) # 80001546 <wakeup>
  release(&lk->lk);
    8000382c:	854a                	mv	a0,s2
    8000382e:	00003097          	auipc	ra,0x3
    80003832:	a32080e7          	jalr	-1486(ra) # 80006260 <release>
}
    80003836:	60e2                	ld	ra,24(sp)
    80003838:	6442                	ld	s0,16(sp)
    8000383a:	64a2                	ld	s1,8(sp)
    8000383c:	6902                	ld	s2,0(sp)
    8000383e:	6105                	addi	sp,sp,32
    80003840:	8082                	ret

0000000080003842 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003842:	7179                	addi	sp,sp,-48
    80003844:	f406                	sd	ra,40(sp)
    80003846:	f022                	sd	s0,32(sp)
    80003848:	ec26                	sd	s1,24(sp)
    8000384a:	e84a                	sd	s2,16(sp)
    8000384c:	e44e                	sd	s3,8(sp)
    8000384e:	1800                	addi	s0,sp,48
    80003850:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003852:	00850913          	addi	s2,a0,8
    80003856:	854a                	mv	a0,s2
    80003858:	00003097          	auipc	ra,0x3
    8000385c:	954080e7          	jalr	-1708(ra) # 800061ac <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003860:	409c                	lw	a5,0(s1)
    80003862:	ef99                	bnez	a5,80003880 <holdingsleep+0x3e>
    80003864:	4481                	li	s1,0
  release(&lk->lk);
    80003866:	854a                	mv	a0,s2
    80003868:	00003097          	auipc	ra,0x3
    8000386c:	9f8080e7          	jalr	-1544(ra) # 80006260 <release>
  return r;
}
    80003870:	8526                	mv	a0,s1
    80003872:	70a2                	ld	ra,40(sp)
    80003874:	7402                	ld	s0,32(sp)
    80003876:	64e2                	ld	s1,24(sp)
    80003878:	6942                	ld	s2,16(sp)
    8000387a:	69a2                	ld	s3,8(sp)
    8000387c:	6145                	addi	sp,sp,48
    8000387e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003880:	0284a983          	lw	s3,40(s1)
    80003884:	ffffd097          	auipc	ra,0xffffd
    80003888:	5ba080e7          	jalr	1466(ra) # 80000e3e <myproc>
    8000388c:	5904                	lw	s1,48(a0)
    8000388e:	413484b3          	sub	s1,s1,s3
    80003892:	0014b493          	seqz	s1,s1
    80003896:	bfc1                	j	80003866 <holdingsleep+0x24>

0000000080003898 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003898:	1141                	addi	sp,sp,-16
    8000389a:	e406                	sd	ra,8(sp)
    8000389c:	e022                	sd	s0,0(sp)
    8000389e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800038a0:	00005597          	auipc	a1,0x5
    800038a4:	d6858593          	addi	a1,a1,-664 # 80008608 <syscalls+0x248>
    800038a8:	00015517          	auipc	a0,0x15
    800038ac:	18050513          	addi	a0,a0,384 # 80018a28 <ftable>
    800038b0:	00003097          	auipc	ra,0x3
    800038b4:	86c080e7          	jalr	-1940(ra) # 8000611c <initlock>
}
    800038b8:	60a2                	ld	ra,8(sp)
    800038ba:	6402                	ld	s0,0(sp)
    800038bc:	0141                	addi	sp,sp,16
    800038be:	8082                	ret

00000000800038c0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038c0:	1101                	addi	sp,sp,-32
    800038c2:	ec06                	sd	ra,24(sp)
    800038c4:	e822                	sd	s0,16(sp)
    800038c6:	e426                	sd	s1,8(sp)
    800038c8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038ca:	00015517          	auipc	a0,0x15
    800038ce:	15e50513          	addi	a0,a0,350 # 80018a28 <ftable>
    800038d2:	00003097          	auipc	ra,0x3
    800038d6:	8da080e7          	jalr	-1830(ra) # 800061ac <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038da:	00015497          	auipc	s1,0x15
    800038de:	16648493          	addi	s1,s1,358 # 80018a40 <ftable+0x18>
    800038e2:	00016717          	auipc	a4,0x16
    800038e6:	0fe70713          	addi	a4,a4,254 # 800199e0 <disk>
    if(f->ref == 0){
    800038ea:	40dc                	lw	a5,4(s1)
    800038ec:	cf99                	beqz	a5,8000390a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038ee:	02848493          	addi	s1,s1,40
    800038f2:	fee49ce3          	bne	s1,a4,800038ea <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038f6:	00015517          	auipc	a0,0x15
    800038fa:	13250513          	addi	a0,a0,306 # 80018a28 <ftable>
    800038fe:	00003097          	auipc	ra,0x3
    80003902:	962080e7          	jalr	-1694(ra) # 80006260 <release>
  return 0;
    80003906:	4481                	li	s1,0
    80003908:	a819                	j	8000391e <filealloc+0x5e>
      f->ref = 1;
    8000390a:	4785                	li	a5,1
    8000390c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000390e:	00015517          	auipc	a0,0x15
    80003912:	11a50513          	addi	a0,a0,282 # 80018a28 <ftable>
    80003916:	00003097          	auipc	ra,0x3
    8000391a:	94a080e7          	jalr	-1718(ra) # 80006260 <release>
}
    8000391e:	8526                	mv	a0,s1
    80003920:	60e2                	ld	ra,24(sp)
    80003922:	6442                	ld	s0,16(sp)
    80003924:	64a2                	ld	s1,8(sp)
    80003926:	6105                	addi	sp,sp,32
    80003928:	8082                	ret

000000008000392a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000392a:	1101                	addi	sp,sp,-32
    8000392c:	ec06                	sd	ra,24(sp)
    8000392e:	e822                	sd	s0,16(sp)
    80003930:	e426                	sd	s1,8(sp)
    80003932:	1000                	addi	s0,sp,32
    80003934:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003936:	00015517          	auipc	a0,0x15
    8000393a:	0f250513          	addi	a0,a0,242 # 80018a28 <ftable>
    8000393e:	00003097          	auipc	ra,0x3
    80003942:	86e080e7          	jalr	-1938(ra) # 800061ac <acquire>
  if(f->ref < 1)
    80003946:	40dc                	lw	a5,4(s1)
    80003948:	02f05263          	blez	a5,8000396c <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000394c:	2785                	addiw	a5,a5,1
    8000394e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003950:	00015517          	auipc	a0,0x15
    80003954:	0d850513          	addi	a0,a0,216 # 80018a28 <ftable>
    80003958:	00003097          	auipc	ra,0x3
    8000395c:	908080e7          	jalr	-1784(ra) # 80006260 <release>
  return f;
}
    80003960:	8526                	mv	a0,s1
    80003962:	60e2                	ld	ra,24(sp)
    80003964:	6442                	ld	s0,16(sp)
    80003966:	64a2                	ld	s1,8(sp)
    80003968:	6105                	addi	sp,sp,32
    8000396a:	8082                	ret
    panic("filedup");
    8000396c:	00005517          	auipc	a0,0x5
    80003970:	ca450513          	addi	a0,a0,-860 # 80008610 <syscalls+0x250>
    80003974:	00002097          	auipc	ra,0x2
    80003978:	2ee080e7          	jalr	750(ra) # 80005c62 <panic>

000000008000397c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000397c:	7139                	addi	sp,sp,-64
    8000397e:	fc06                	sd	ra,56(sp)
    80003980:	f822                	sd	s0,48(sp)
    80003982:	f426                	sd	s1,40(sp)
    80003984:	f04a                	sd	s2,32(sp)
    80003986:	ec4e                	sd	s3,24(sp)
    80003988:	e852                	sd	s4,16(sp)
    8000398a:	e456                	sd	s5,8(sp)
    8000398c:	0080                	addi	s0,sp,64
    8000398e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003990:	00015517          	auipc	a0,0x15
    80003994:	09850513          	addi	a0,a0,152 # 80018a28 <ftable>
    80003998:	00003097          	auipc	ra,0x3
    8000399c:	814080e7          	jalr	-2028(ra) # 800061ac <acquire>
  if(f->ref < 1)
    800039a0:	40dc                	lw	a5,4(s1)
    800039a2:	06f05163          	blez	a5,80003a04 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800039a6:	37fd                	addiw	a5,a5,-1
    800039a8:	0007871b          	sext.w	a4,a5
    800039ac:	c0dc                	sw	a5,4(s1)
    800039ae:	06e04363          	bgtz	a4,80003a14 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800039b2:	0004a903          	lw	s2,0(s1)
    800039b6:	0094ca83          	lbu	s5,9(s1)
    800039ba:	0104ba03          	ld	s4,16(s1)
    800039be:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800039c2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039c6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039ca:	00015517          	auipc	a0,0x15
    800039ce:	05e50513          	addi	a0,a0,94 # 80018a28 <ftable>
    800039d2:	00003097          	auipc	ra,0x3
    800039d6:	88e080e7          	jalr	-1906(ra) # 80006260 <release>

  if(ff.type == FD_PIPE){
    800039da:	4785                	li	a5,1
    800039dc:	04f90d63          	beq	s2,a5,80003a36 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039e0:	3979                	addiw	s2,s2,-2
    800039e2:	4785                	li	a5,1
    800039e4:	0527e063          	bltu	a5,s2,80003a24 <fileclose+0xa8>
    begin_op();
    800039e8:	00000097          	auipc	ra,0x0
    800039ec:	ac8080e7          	jalr	-1336(ra) # 800034b0 <begin_op>
    iput(ff.ip);
    800039f0:	854e                	mv	a0,s3
    800039f2:	fffff097          	auipc	ra,0xfffff
    800039f6:	2b6080e7          	jalr	694(ra) # 80002ca8 <iput>
    end_op();
    800039fa:	00000097          	auipc	ra,0x0
    800039fe:	b36080e7          	jalr	-1226(ra) # 80003530 <end_op>
    80003a02:	a00d                	j	80003a24 <fileclose+0xa8>
    panic("fileclose");
    80003a04:	00005517          	auipc	a0,0x5
    80003a08:	c1450513          	addi	a0,a0,-1004 # 80008618 <syscalls+0x258>
    80003a0c:	00002097          	auipc	ra,0x2
    80003a10:	256080e7          	jalr	598(ra) # 80005c62 <panic>
    release(&ftable.lock);
    80003a14:	00015517          	auipc	a0,0x15
    80003a18:	01450513          	addi	a0,a0,20 # 80018a28 <ftable>
    80003a1c:	00003097          	auipc	ra,0x3
    80003a20:	844080e7          	jalr	-1980(ra) # 80006260 <release>
  }
}
    80003a24:	70e2                	ld	ra,56(sp)
    80003a26:	7442                	ld	s0,48(sp)
    80003a28:	74a2                	ld	s1,40(sp)
    80003a2a:	7902                	ld	s2,32(sp)
    80003a2c:	69e2                	ld	s3,24(sp)
    80003a2e:	6a42                	ld	s4,16(sp)
    80003a30:	6aa2                	ld	s5,8(sp)
    80003a32:	6121                	addi	sp,sp,64
    80003a34:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a36:	85d6                	mv	a1,s5
    80003a38:	8552                	mv	a0,s4
    80003a3a:	00000097          	auipc	ra,0x0
    80003a3e:	3a6080e7          	jalr	934(ra) # 80003de0 <pipeclose>
    80003a42:	b7cd                	j	80003a24 <fileclose+0xa8>

0000000080003a44 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a44:	715d                	addi	sp,sp,-80
    80003a46:	e486                	sd	ra,72(sp)
    80003a48:	e0a2                	sd	s0,64(sp)
    80003a4a:	fc26                	sd	s1,56(sp)
    80003a4c:	f84a                	sd	s2,48(sp)
    80003a4e:	f44e                	sd	s3,40(sp)
    80003a50:	0880                	addi	s0,sp,80
    80003a52:	84aa                	mv	s1,a0
    80003a54:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a56:	ffffd097          	auipc	ra,0xffffd
    80003a5a:	3e8080e7          	jalr	1000(ra) # 80000e3e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a5e:	409c                	lw	a5,0(s1)
    80003a60:	37f9                	addiw	a5,a5,-2
    80003a62:	4705                	li	a4,1
    80003a64:	04f76763          	bltu	a4,a5,80003ab2 <filestat+0x6e>
    80003a68:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a6a:	6c88                	ld	a0,24(s1)
    80003a6c:	fffff097          	auipc	ra,0xfffff
    80003a70:	082080e7          	jalr	130(ra) # 80002aee <ilock>
    stati(f->ip, &st);
    80003a74:	fb840593          	addi	a1,s0,-72
    80003a78:	6c88                	ld	a0,24(s1)
    80003a7a:	fffff097          	auipc	ra,0xfffff
    80003a7e:	2fe080e7          	jalr	766(ra) # 80002d78 <stati>
    iunlock(f->ip);
    80003a82:	6c88                	ld	a0,24(s1)
    80003a84:	fffff097          	auipc	ra,0xfffff
    80003a88:	12c080e7          	jalr	300(ra) # 80002bb0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a8c:	46e1                	li	a3,24
    80003a8e:	fb840613          	addi	a2,s0,-72
    80003a92:	85ce                	mv	a1,s3
    80003a94:	05093503          	ld	a0,80(s2)
    80003a98:	ffffd097          	auipc	ra,0xffffd
    80003a9c:	064080e7          	jalr	100(ra) # 80000afc <copyout>
    80003aa0:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003aa4:	60a6                	ld	ra,72(sp)
    80003aa6:	6406                	ld	s0,64(sp)
    80003aa8:	74e2                	ld	s1,56(sp)
    80003aaa:	7942                	ld	s2,48(sp)
    80003aac:	79a2                	ld	s3,40(sp)
    80003aae:	6161                	addi	sp,sp,80
    80003ab0:	8082                	ret
  return -1;
    80003ab2:	557d                	li	a0,-1
    80003ab4:	bfc5                	j	80003aa4 <filestat+0x60>

0000000080003ab6 <mapfile>:

void mapfile(struct file * f, char * mem, int offset){
    80003ab6:	7179                	addi	sp,sp,-48
    80003ab8:	f406                	sd	ra,40(sp)
    80003aba:	f022                	sd	s0,32(sp)
    80003abc:	ec26                	sd	s1,24(sp)
    80003abe:	e84a                	sd	s2,16(sp)
    80003ac0:	e44e                	sd	s3,8(sp)
    80003ac2:	1800                	addi	s0,sp,48
    80003ac4:	84aa                	mv	s1,a0
    80003ac6:	89ae                	mv	s3,a1
    80003ac8:	8932                	mv	s2,a2
  printf("off %d\n", offset);
    80003aca:	85b2                	mv	a1,a2
    80003acc:	00005517          	auipc	a0,0x5
    80003ad0:	b5c50513          	addi	a0,a0,-1188 # 80008628 <syscalls+0x268>
    80003ad4:	00002097          	auipc	ra,0x2
    80003ad8:	1d8080e7          	jalr	472(ra) # 80005cac <printf>
  ilock(f->ip);
    80003adc:	6c88                	ld	a0,24(s1)
    80003ade:	fffff097          	auipc	ra,0xfffff
    80003ae2:	010080e7          	jalr	16(ra) # 80002aee <ilock>
  readi(f->ip, 0, (uint64) mem, offset, PGSIZE);
    80003ae6:	6705                	lui	a4,0x1
    80003ae8:	86ca                	mv	a3,s2
    80003aea:	864e                	mv	a2,s3
    80003aec:	4581                	li	a1,0
    80003aee:	6c88                	ld	a0,24(s1)
    80003af0:	fffff097          	auipc	ra,0xfffff
    80003af4:	2b2080e7          	jalr	690(ra) # 80002da2 <readi>
  iunlock(f->ip);
    80003af8:	6c88                	ld	a0,24(s1)
    80003afa:	fffff097          	auipc	ra,0xfffff
    80003afe:	0b6080e7          	jalr	182(ra) # 80002bb0 <iunlock>
}
    80003b02:	70a2                	ld	ra,40(sp)
    80003b04:	7402                	ld	s0,32(sp)
    80003b06:	64e2                	ld	s1,24(sp)
    80003b08:	6942                	ld	s2,16(sp)
    80003b0a:	69a2                	ld	s3,8(sp)
    80003b0c:	6145                	addi	sp,sp,48
    80003b0e:	8082                	ret

0000000080003b10 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b10:	7179                	addi	sp,sp,-48
    80003b12:	f406                	sd	ra,40(sp)
    80003b14:	f022                	sd	s0,32(sp)
    80003b16:	ec26                	sd	s1,24(sp)
    80003b18:	e84a                	sd	s2,16(sp)
    80003b1a:	e44e                	sd	s3,8(sp)
    80003b1c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b1e:	00854783          	lbu	a5,8(a0)
    80003b22:	c3d5                	beqz	a5,80003bc6 <fileread+0xb6>
    80003b24:	84aa                	mv	s1,a0
    80003b26:	89ae                	mv	s3,a1
    80003b28:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b2a:	411c                	lw	a5,0(a0)
    80003b2c:	4705                	li	a4,1
    80003b2e:	04e78963          	beq	a5,a4,80003b80 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b32:	470d                	li	a4,3
    80003b34:	04e78d63          	beq	a5,a4,80003b8e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b38:	4709                	li	a4,2
    80003b3a:	06e79e63          	bne	a5,a4,80003bb6 <fileread+0xa6>
    ilock(f->ip);
    80003b3e:	6d08                	ld	a0,24(a0)
    80003b40:	fffff097          	auipc	ra,0xfffff
    80003b44:	fae080e7          	jalr	-82(ra) # 80002aee <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b48:	874a                	mv	a4,s2
    80003b4a:	5094                	lw	a3,32(s1)
    80003b4c:	864e                	mv	a2,s3
    80003b4e:	4585                	li	a1,1
    80003b50:	6c88                	ld	a0,24(s1)
    80003b52:	fffff097          	auipc	ra,0xfffff
    80003b56:	250080e7          	jalr	592(ra) # 80002da2 <readi>
    80003b5a:	892a                	mv	s2,a0
    80003b5c:	00a05563          	blez	a0,80003b66 <fileread+0x56>
      f->off += r;
    80003b60:	509c                	lw	a5,32(s1)
    80003b62:	9fa9                	addw	a5,a5,a0
    80003b64:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b66:	6c88                	ld	a0,24(s1)
    80003b68:	fffff097          	auipc	ra,0xfffff
    80003b6c:	048080e7          	jalr	72(ra) # 80002bb0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b70:	854a                	mv	a0,s2
    80003b72:	70a2                	ld	ra,40(sp)
    80003b74:	7402                	ld	s0,32(sp)
    80003b76:	64e2                	ld	s1,24(sp)
    80003b78:	6942                	ld	s2,16(sp)
    80003b7a:	69a2                	ld	s3,8(sp)
    80003b7c:	6145                	addi	sp,sp,48
    80003b7e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b80:	6908                	ld	a0,16(a0)
    80003b82:	00000097          	auipc	ra,0x0
    80003b86:	3ce080e7          	jalr	974(ra) # 80003f50 <piperead>
    80003b8a:	892a                	mv	s2,a0
    80003b8c:	b7d5                	j	80003b70 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b8e:	02451783          	lh	a5,36(a0)
    80003b92:	03079693          	slli	a3,a5,0x30
    80003b96:	92c1                	srli	a3,a3,0x30
    80003b98:	4725                	li	a4,9
    80003b9a:	02d76863          	bltu	a4,a3,80003bca <fileread+0xba>
    80003b9e:	0792                	slli	a5,a5,0x4
    80003ba0:	00015717          	auipc	a4,0x15
    80003ba4:	de870713          	addi	a4,a4,-536 # 80018988 <devsw>
    80003ba8:	97ba                	add	a5,a5,a4
    80003baa:	639c                	ld	a5,0(a5)
    80003bac:	c38d                	beqz	a5,80003bce <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003bae:	4505                	li	a0,1
    80003bb0:	9782                	jalr	a5
    80003bb2:	892a                	mv	s2,a0
    80003bb4:	bf75                	j	80003b70 <fileread+0x60>
    panic("fileread");
    80003bb6:	00005517          	auipc	a0,0x5
    80003bba:	a7a50513          	addi	a0,a0,-1414 # 80008630 <syscalls+0x270>
    80003bbe:	00002097          	auipc	ra,0x2
    80003bc2:	0a4080e7          	jalr	164(ra) # 80005c62 <panic>
    return -1;
    80003bc6:	597d                	li	s2,-1
    80003bc8:	b765                	j	80003b70 <fileread+0x60>
      return -1;
    80003bca:	597d                	li	s2,-1
    80003bcc:	b755                	j	80003b70 <fileread+0x60>
    80003bce:	597d                	li	s2,-1
    80003bd0:	b745                	j	80003b70 <fileread+0x60>

0000000080003bd2 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003bd2:	715d                	addi	sp,sp,-80
    80003bd4:	e486                	sd	ra,72(sp)
    80003bd6:	e0a2                	sd	s0,64(sp)
    80003bd8:	fc26                	sd	s1,56(sp)
    80003bda:	f84a                	sd	s2,48(sp)
    80003bdc:	f44e                	sd	s3,40(sp)
    80003bde:	f052                	sd	s4,32(sp)
    80003be0:	ec56                	sd	s5,24(sp)
    80003be2:	e85a                	sd	s6,16(sp)
    80003be4:	e45e                	sd	s7,8(sp)
    80003be6:	e062                	sd	s8,0(sp)
    80003be8:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003bea:	00954783          	lbu	a5,9(a0)
    80003bee:	10078663          	beqz	a5,80003cfa <filewrite+0x128>
    80003bf2:	892a                	mv	s2,a0
    80003bf4:	8aae                	mv	s5,a1
    80003bf6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bf8:	411c                	lw	a5,0(a0)
    80003bfa:	4705                	li	a4,1
    80003bfc:	02e78263          	beq	a5,a4,80003c20 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c00:	470d                	li	a4,3
    80003c02:	02e78663          	beq	a5,a4,80003c2e <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c06:	4709                	li	a4,2
    80003c08:	0ee79163          	bne	a5,a4,80003cea <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c0c:	0ac05d63          	blez	a2,80003cc6 <filewrite+0xf4>
    int i = 0;
    80003c10:	4981                	li	s3,0
    80003c12:	6b05                	lui	s6,0x1
    80003c14:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c18:	6b85                	lui	s7,0x1
    80003c1a:	c00b8b9b          	addiw	s7,s7,-1024
    80003c1e:	a861                	j	80003cb6 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c20:	6908                	ld	a0,16(a0)
    80003c22:	00000097          	auipc	ra,0x0
    80003c26:	22e080e7          	jalr	558(ra) # 80003e50 <pipewrite>
    80003c2a:	8a2a                	mv	s4,a0
    80003c2c:	a045                	j	80003ccc <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c2e:	02451783          	lh	a5,36(a0)
    80003c32:	03079693          	slli	a3,a5,0x30
    80003c36:	92c1                	srli	a3,a3,0x30
    80003c38:	4725                	li	a4,9
    80003c3a:	0cd76263          	bltu	a4,a3,80003cfe <filewrite+0x12c>
    80003c3e:	0792                	slli	a5,a5,0x4
    80003c40:	00015717          	auipc	a4,0x15
    80003c44:	d4870713          	addi	a4,a4,-696 # 80018988 <devsw>
    80003c48:	97ba                	add	a5,a5,a4
    80003c4a:	679c                	ld	a5,8(a5)
    80003c4c:	cbdd                	beqz	a5,80003d02 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003c4e:	4505                	li	a0,1
    80003c50:	9782                	jalr	a5
    80003c52:	8a2a                	mv	s4,a0
    80003c54:	a8a5                	j	80003ccc <filewrite+0xfa>
    80003c56:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003c5a:	00000097          	auipc	ra,0x0
    80003c5e:	856080e7          	jalr	-1962(ra) # 800034b0 <begin_op>
      ilock(f->ip);
    80003c62:	01893503          	ld	a0,24(s2)
    80003c66:	fffff097          	auipc	ra,0xfffff
    80003c6a:	e88080e7          	jalr	-376(ra) # 80002aee <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c6e:	8762                	mv	a4,s8
    80003c70:	02092683          	lw	a3,32(s2)
    80003c74:	01598633          	add	a2,s3,s5
    80003c78:	4585                	li	a1,1
    80003c7a:	01893503          	ld	a0,24(s2)
    80003c7e:	fffff097          	auipc	ra,0xfffff
    80003c82:	21c080e7          	jalr	540(ra) # 80002e9a <writei>
    80003c86:	84aa                	mv	s1,a0
    80003c88:	00a05763          	blez	a0,80003c96 <filewrite+0xc4>
        f->off += r;
    80003c8c:	02092783          	lw	a5,32(s2)
    80003c90:	9fa9                	addw	a5,a5,a0
    80003c92:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c96:	01893503          	ld	a0,24(s2)
    80003c9a:	fffff097          	auipc	ra,0xfffff
    80003c9e:	f16080e7          	jalr	-234(ra) # 80002bb0 <iunlock>
      end_op();
    80003ca2:	00000097          	auipc	ra,0x0
    80003ca6:	88e080e7          	jalr	-1906(ra) # 80003530 <end_op>

      if(r != n1){
    80003caa:	009c1f63          	bne	s8,s1,80003cc8 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003cae:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003cb2:	0149db63          	bge	s3,s4,80003cc8 <filewrite+0xf6>
      int n1 = n - i;
    80003cb6:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003cba:	84be                	mv	s1,a5
    80003cbc:	2781                	sext.w	a5,a5
    80003cbe:	f8fb5ce3          	bge	s6,a5,80003c56 <filewrite+0x84>
    80003cc2:	84de                	mv	s1,s7
    80003cc4:	bf49                	j	80003c56 <filewrite+0x84>
    int i = 0;
    80003cc6:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003cc8:	013a1f63          	bne	s4,s3,80003ce6 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ccc:	8552                	mv	a0,s4
    80003cce:	60a6                	ld	ra,72(sp)
    80003cd0:	6406                	ld	s0,64(sp)
    80003cd2:	74e2                	ld	s1,56(sp)
    80003cd4:	7942                	ld	s2,48(sp)
    80003cd6:	79a2                	ld	s3,40(sp)
    80003cd8:	7a02                	ld	s4,32(sp)
    80003cda:	6ae2                	ld	s5,24(sp)
    80003cdc:	6b42                	ld	s6,16(sp)
    80003cde:	6ba2                	ld	s7,8(sp)
    80003ce0:	6c02                	ld	s8,0(sp)
    80003ce2:	6161                	addi	sp,sp,80
    80003ce4:	8082                	ret
    ret = (i == n ? n : -1);
    80003ce6:	5a7d                	li	s4,-1
    80003ce8:	b7d5                	j	80003ccc <filewrite+0xfa>
    panic("filewrite");
    80003cea:	00005517          	auipc	a0,0x5
    80003cee:	95650513          	addi	a0,a0,-1706 # 80008640 <syscalls+0x280>
    80003cf2:	00002097          	auipc	ra,0x2
    80003cf6:	f70080e7          	jalr	-144(ra) # 80005c62 <panic>
    return -1;
    80003cfa:	5a7d                	li	s4,-1
    80003cfc:	bfc1                	j	80003ccc <filewrite+0xfa>
      return -1;
    80003cfe:	5a7d                	li	s4,-1
    80003d00:	b7f1                	j	80003ccc <filewrite+0xfa>
    80003d02:	5a7d                	li	s4,-1
    80003d04:	b7e1                	j	80003ccc <filewrite+0xfa>

0000000080003d06 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d06:	7179                	addi	sp,sp,-48
    80003d08:	f406                	sd	ra,40(sp)
    80003d0a:	f022                	sd	s0,32(sp)
    80003d0c:	ec26                	sd	s1,24(sp)
    80003d0e:	e84a                	sd	s2,16(sp)
    80003d10:	e44e                	sd	s3,8(sp)
    80003d12:	e052                	sd	s4,0(sp)
    80003d14:	1800                	addi	s0,sp,48
    80003d16:	84aa                	mv	s1,a0
    80003d18:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d1a:	0005b023          	sd	zero,0(a1)
    80003d1e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d22:	00000097          	auipc	ra,0x0
    80003d26:	b9e080e7          	jalr	-1122(ra) # 800038c0 <filealloc>
    80003d2a:	e088                	sd	a0,0(s1)
    80003d2c:	c551                	beqz	a0,80003db8 <pipealloc+0xb2>
    80003d2e:	00000097          	auipc	ra,0x0
    80003d32:	b92080e7          	jalr	-1134(ra) # 800038c0 <filealloc>
    80003d36:	00aa3023          	sd	a0,0(s4)
    80003d3a:	c92d                	beqz	a0,80003dac <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d3c:	ffffc097          	auipc	ra,0xffffc
    80003d40:	3dc080e7          	jalr	988(ra) # 80000118 <kalloc>
    80003d44:	892a                	mv	s2,a0
    80003d46:	c125                	beqz	a0,80003da6 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d48:	4985                	li	s3,1
    80003d4a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d4e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d52:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d56:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d5a:	00005597          	auipc	a1,0x5
    80003d5e:	8f658593          	addi	a1,a1,-1802 # 80008650 <syscalls+0x290>
    80003d62:	00002097          	auipc	ra,0x2
    80003d66:	3ba080e7          	jalr	954(ra) # 8000611c <initlock>
  (*f0)->type = FD_PIPE;
    80003d6a:	609c                	ld	a5,0(s1)
    80003d6c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d70:	609c                	ld	a5,0(s1)
    80003d72:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d76:	609c                	ld	a5,0(s1)
    80003d78:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d7c:	609c                	ld	a5,0(s1)
    80003d7e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d82:	000a3783          	ld	a5,0(s4)
    80003d86:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d8a:	000a3783          	ld	a5,0(s4)
    80003d8e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d92:	000a3783          	ld	a5,0(s4)
    80003d96:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d9a:	000a3783          	ld	a5,0(s4)
    80003d9e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003da2:	4501                	li	a0,0
    80003da4:	a025                	j	80003dcc <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003da6:	6088                	ld	a0,0(s1)
    80003da8:	e501                	bnez	a0,80003db0 <pipealloc+0xaa>
    80003daa:	a039                	j	80003db8 <pipealloc+0xb2>
    80003dac:	6088                	ld	a0,0(s1)
    80003dae:	c51d                	beqz	a0,80003ddc <pipealloc+0xd6>
    fileclose(*f0);
    80003db0:	00000097          	auipc	ra,0x0
    80003db4:	bcc080e7          	jalr	-1076(ra) # 8000397c <fileclose>
  if(*f1)
    80003db8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003dbc:	557d                	li	a0,-1
  if(*f1)
    80003dbe:	c799                	beqz	a5,80003dcc <pipealloc+0xc6>
    fileclose(*f1);
    80003dc0:	853e                	mv	a0,a5
    80003dc2:	00000097          	auipc	ra,0x0
    80003dc6:	bba080e7          	jalr	-1094(ra) # 8000397c <fileclose>
  return -1;
    80003dca:	557d                	li	a0,-1
}
    80003dcc:	70a2                	ld	ra,40(sp)
    80003dce:	7402                	ld	s0,32(sp)
    80003dd0:	64e2                	ld	s1,24(sp)
    80003dd2:	6942                	ld	s2,16(sp)
    80003dd4:	69a2                	ld	s3,8(sp)
    80003dd6:	6a02                	ld	s4,0(sp)
    80003dd8:	6145                	addi	sp,sp,48
    80003dda:	8082                	ret
  return -1;
    80003ddc:	557d                	li	a0,-1
    80003dde:	b7fd                	j	80003dcc <pipealloc+0xc6>

0000000080003de0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003de0:	1101                	addi	sp,sp,-32
    80003de2:	ec06                	sd	ra,24(sp)
    80003de4:	e822                	sd	s0,16(sp)
    80003de6:	e426                	sd	s1,8(sp)
    80003de8:	e04a                	sd	s2,0(sp)
    80003dea:	1000                	addi	s0,sp,32
    80003dec:	84aa                	mv	s1,a0
    80003dee:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003df0:	00002097          	auipc	ra,0x2
    80003df4:	3bc080e7          	jalr	956(ra) # 800061ac <acquire>
  if(writable){
    80003df8:	02090d63          	beqz	s2,80003e32 <pipeclose+0x52>
    pi->writeopen = 0;
    80003dfc:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e00:	21848513          	addi	a0,s1,536
    80003e04:	ffffd097          	auipc	ra,0xffffd
    80003e08:	742080e7          	jalr	1858(ra) # 80001546 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e0c:	2204b783          	ld	a5,544(s1)
    80003e10:	eb95                	bnez	a5,80003e44 <pipeclose+0x64>
    release(&pi->lock);
    80003e12:	8526                	mv	a0,s1
    80003e14:	00002097          	auipc	ra,0x2
    80003e18:	44c080e7          	jalr	1100(ra) # 80006260 <release>
    kfree((char*)pi);
    80003e1c:	8526                	mv	a0,s1
    80003e1e:	ffffc097          	auipc	ra,0xffffc
    80003e22:	1fe080e7          	jalr	510(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e26:	60e2                	ld	ra,24(sp)
    80003e28:	6442                	ld	s0,16(sp)
    80003e2a:	64a2                	ld	s1,8(sp)
    80003e2c:	6902                	ld	s2,0(sp)
    80003e2e:	6105                	addi	sp,sp,32
    80003e30:	8082                	ret
    pi->readopen = 0;
    80003e32:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e36:	21c48513          	addi	a0,s1,540
    80003e3a:	ffffd097          	auipc	ra,0xffffd
    80003e3e:	70c080e7          	jalr	1804(ra) # 80001546 <wakeup>
    80003e42:	b7e9                	j	80003e0c <pipeclose+0x2c>
    release(&pi->lock);
    80003e44:	8526                	mv	a0,s1
    80003e46:	00002097          	auipc	ra,0x2
    80003e4a:	41a080e7          	jalr	1050(ra) # 80006260 <release>
}
    80003e4e:	bfe1                	j	80003e26 <pipeclose+0x46>

0000000080003e50 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e50:	7159                	addi	sp,sp,-112
    80003e52:	f486                	sd	ra,104(sp)
    80003e54:	f0a2                	sd	s0,96(sp)
    80003e56:	eca6                	sd	s1,88(sp)
    80003e58:	e8ca                	sd	s2,80(sp)
    80003e5a:	e4ce                	sd	s3,72(sp)
    80003e5c:	e0d2                	sd	s4,64(sp)
    80003e5e:	fc56                	sd	s5,56(sp)
    80003e60:	f85a                	sd	s6,48(sp)
    80003e62:	f45e                	sd	s7,40(sp)
    80003e64:	f062                	sd	s8,32(sp)
    80003e66:	ec66                	sd	s9,24(sp)
    80003e68:	1880                	addi	s0,sp,112
    80003e6a:	84aa                	mv	s1,a0
    80003e6c:	8aae                	mv	s5,a1
    80003e6e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e70:	ffffd097          	auipc	ra,0xffffd
    80003e74:	fce080e7          	jalr	-50(ra) # 80000e3e <myproc>
    80003e78:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e7a:	8526                	mv	a0,s1
    80003e7c:	00002097          	auipc	ra,0x2
    80003e80:	330080e7          	jalr	816(ra) # 800061ac <acquire>
  while(i < n){
    80003e84:	0d405463          	blez	s4,80003f4c <pipewrite+0xfc>
    80003e88:	8ba6                	mv	s7,s1
  int i = 0;
    80003e8a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e8c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e8e:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e92:	21c48c13          	addi	s8,s1,540
    80003e96:	a08d                	j	80003ef8 <pipewrite+0xa8>
      release(&pi->lock);
    80003e98:	8526                	mv	a0,s1
    80003e9a:	00002097          	auipc	ra,0x2
    80003e9e:	3c6080e7          	jalr	966(ra) # 80006260 <release>
      return -1;
    80003ea2:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003ea4:	854a                	mv	a0,s2
    80003ea6:	70a6                	ld	ra,104(sp)
    80003ea8:	7406                	ld	s0,96(sp)
    80003eaa:	64e6                	ld	s1,88(sp)
    80003eac:	6946                	ld	s2,80(sp)
    80003eae:	69a6                	ld	s3,72(sp)
    80003eb0:	6a06                	ld	s4,64(sp)
    80003eb2:	7ae2                	ld	s5,56(sp)
    80003eb4:	7b42                	ld	s6,48(sp)
    80003eb6:	7ba2                	ld	s7,40(sp)
    80003eb8:	7c02                	ld	s8,32(sp)
    80003eba:	6ce2                	ld	s9,24(sp)
    80003ebc:	6165                	addi	sp,sp,112
    80003ebe:	8082                	ret
      wakeup(&pi->nread);
    80003ec0:	8566                	mv	a0,s9
    80003ec2:	ffffd097          	auipc	ra,0xffffd
    80003ec6:	684080e7          	jalr	1668(ra) # 80001546 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003eca:	85de                	mv	a1,s7
    80003ecc:	8562                	mv	a0,s8
    80003ece:	ffffd097          	auipc	ra,0xffffd
    80003ed2:	614080e7          	jalr	1556(ra) # 800014e2 <sleep>
    80003ed6:	a839                	j	80003ef4 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ed8:	21c4a783          	lw	a5,540(s1)
    80003edc:	0017871b          	addiw	a4,a5,1
    80003ee0:	20e4ae23          	sw	a4,540(s1)
    80003ee4:	1ff7f793          	andi	a5,a5,511
    80003ee8:	97a6                	add	a5,a5,s1
    80003eea:	f9f44703          	lbu	a4,-97(s0)
    80003eee:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ef2:	2905                	addiw	s2,s2,1
  while(i < n){
    80003ef4:	05495063          	bge	s2,s4,80003f34 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80003ef8:	2204a783          	lw	a5,544(s1)
    80003efc:	dfd1                	beqz	a5,80003e98 <pipewrite+0x48>
    80003efe:	854e                	mv	a0,s3
    80003f00:	ffffe097          	auipc	ra,0xffffe
    80003f04:	88a080e7          	jalr	-1910(ra) # 8000178a <killed>
    80003f08:	f941                	bnez	a0,80003e98 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f0a:	2184a783          	lw	a5,536(s1)
    80003f0e:	21c4a703          	lw	a4,540(s1)
    80003f12:	2007879b          	addiw	a5,a5,512
    80003f16:	faf705e3          	beq	a4,a5,80003ec0 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f1a:	4685                	li	a3,1
    80003f1c:	01590633          	add	a2,s2,s5
    80003f20:	f9f40593          	addi	a1,s0,-97
    80003f24:	0509b503          	ld	a0,80(s3)
    80003f28:	ffffd097          	auipc	ra,0xffffd
    80003f2c:	c60080e7          	jalr	-928(ra) # 80000b88 <copyin>
    80003f30:	fb6514e3          	bne	a0,s6,80003ed8 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003f34:	21848513          	addi	a0,s1,536
    80003f38:	ffffd097          	auipc	ra,0xffffd
    80003f3c:	60e080e7          	jalr	1550(ra) # 80001546 <wakeup>
  release(&pi->lock);
    80003f40:	8526                	mv	a0,s1
    80003f42:	00002097          	auipc	ra,0x2
    80003f46:	31e080e7          	jalr	798(ra) # 80006260 <release>
  return i;
    80003f4a:	bfa9                	j	80003ea4 <pipewrite+0x54>
  int i = 0;
    80003f4c:	4901                	li	s2,0
    80003f4e:	b7dd                	j	80003f34 <pipewrite+0xe4>

0000000080003f50 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f50:	715d                	addi	sp,sp,-80
    80003f52:	e486                	sd	ra,72(sp)
    80003f54:	e0a2                	sd	s0,64(sp)
    80003f56:	fc26                	sd	s1,56(sp)
    80003f58:	f84a                	sd	s2,48(sp)
    80003f5a:	f44e                	sd	s3,40(sp)
    80003f5c:	f052                	sd	s4,32(sp)
    80003f5e:	ec56                	sd	s5,24(sp)
    80003f60:	e85a                	sd	s6,16(sp)
    80003f62:	0880                	addi	s0,sp,80
    80003f64:	84aa                	mv	s1,a0
    80003f66:	892e                	mv	s2,a1
    80003f68:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f6a:	ffffd097          	auipc	ra,0xffffd
    80003f6e:	ed4080e7          	jalr	-300(ra) # 80000e3e <myproc>
    80003f72:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f74:	8b26                	mv	s6,s1
    80003f76:	8526                	mv	a0,s1
    80003f78:	00002097          	auipc	ra,0x2
    80003f7c:	234080e7          	jalr	564(ra) # 800061ac <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f80:	2184a703          	lw	a4,536(s1)
    80003f84:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f88:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f8c:	02f71763          	bne	a4,a5,80003fba <piperead+0x6a>
    80003f90:	2244a783          	lw	a5,548(s1)
    80003f94:	c39d                	beqz	a5,80003fba <piperead+0x6a>
    if(killed(pr)){
    80003f96:	8552                	mv	a0,s4
    80003f98:	ffffd097          	auipc	ra,0xffffd
    80003f9c:	7f2080e7          	jalr	2034(ra) # 8000178a <killed>
    80003fa0:	e941                	bnez	a0,80004030 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fa2:	85da                	mv	a1,s6
    80003fa4:	854e                	mv	a0,s3
    80003fa6:	ffffd097          	auipc	ra,0xffffd
    80003faa:	53c080e7          	jalr	1340(ra) # 800014e2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fae:	2184a703          	lw	a4,536(s1)
    80003fb2:	21c4a783          	lw	a5,540(s1)
    80003fb6:	fcf70de3          	beq	a4,a5,80003f90 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fba:	09505263          	blez	s5,8000403e <piperead+0xee>
    80003fbe:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fc0:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80003fc2:	2184a783          	lw	a5,536(s1)
    80003fc6:	21c4a703          	lw	a4,540(s1)
    80003fca:	02f70d63          	beq	a4,a5,80004004 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003fce:	0017871b          	addiw	a4,a5,1
    80003fd2:	20e4ac23          	sw	a4,536(s1)
    80003fd6:	1ff7f793          	andi	a5,a5,511
    80003fda:	97a6                	add	a5,a5,s1
    80003fdc:	0187c783          	lbu	a5,24(a5)
    80003fe0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fe4:	4685                	li	a3,1
    80003fe6:	fbf40613          	addi	a2,s0,-65
    80003fea:	85ca                	mv	a1,s2
    80003fec:	050a3503          	ld	a0,80(s4)
    80003ff0:	ffffd097          	auipc	ra,0xffffd
    80003ff4:	b0c080e7          	jalr	-1268(ra) # 80000afc <copyout>
    80003ff8:	01650663          	beq	a0,s6,80004004 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ffc:	2985                	addiw	s3,s3,1
    80003ffe:	0905                	addi	s2,s2,1
    80004000:	fd3a91e3          	bne	s5,s3,80003fc2 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004004:	21c48513          	addi	a0,s1,540
    80004008:	ffffd097          	auipc	ra,0xffffd
    8000400c:	53e080e7          	jalr	1342(ra) # 80001546 <wakeup>
  release(&pi->lock);
    80004010:	8526                	mv	a0,s1
    80004012:	00002097          	auipc	ra,0x2
    80004016:	24e080e7          	jalr	590(ra) # 80006260 <release>
  return i;
}
    8000401a:	854e                	mv	a0,s3
    8000401c:	60a6                	ld	ra,72(sp)
    8000401e:	6406                	ld	s0,64(sp)
    80004020:	74e2                	ld	s1,56(sp)
    80004022:	7942                	ld	s2,48(sp)
    80004024:	79a2                	ld	s3,40(sp)
    80004026:	7a02                	ld	s4,32(sp)
    80004028:	6ae2                	ld	s5,24(sp)
    8000402a:	6b42                	ld	s6,16(sp)
    8000402c:	6161                	addi	sp,sp,80
    8000402e:	8082                	ret
      release(&pi->lock);
    80004030:	8526                	mv	a0,s1
    80004032:	00002097          	auipc	ra,0x2
    80004036:	22e080e7          	jalr	558(ra) # 80006260 <release>
      return -1;
    8000403a:	59fd                	li	s3,-1
    8000403c:	bff9                	j	8000401a <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000403e:	4981                	li	s3,0
    80004040:	b7d1                	j	80004004 <piperead+0xb4>

0000000080004042 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004042:	1141                	addi	sp,sp,-16
    80004044:	e422                	sd	s0,8(sp)
    80004046:	0800                	addi	s0,sp,16
    80004048:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000404a:	8905                	andi	a0,a0,1
    8000404c:	c111                	beqz	a0,80004050 <flags2perm+0xe>
      perm = PTE_X;
    8000404e:	4521                	li	a0,8
    if(flags & 0x2)
    80004050:	8b89                	andi	a5,a5,2
    80004052:	c399                	beqz	a5,80004058 <flags2perm+0x16>
      perm |= PTE_W;
    80004054:	00456513          	ori	a0,a0,4
    return perm;
}
    80004058:	6422                	ld	s0,8(sp)
    8000405a:	0141                	addi	sp,sp,16
    8000405c:	8082                	ret

000000008000405e <exec>:

int
exec(char *path, char **argv)
{
    8000405e:	df010113          	addi	sp,sp,-528
    80004062:	20113423          	sd	ra,520(sp)
    80004066:	20813023          	sd	s0,512(sp)
    8000406a:	ffa6                	sd	s1,504(sp)
    8000406c:	fbca                	sd	s2,496(sp)
    8000406e:	f7ce                	sd	s3,488(sp)
    80004070:	f3d2                	sd	s4,480(sp)
    80004072:	efd6                	sd	s5,472(sp)
    80004074:	ebda                	sd	s6,464(sp)
    80004076:	e7de                	sd	s7,456(sp)
    80004078:	e3e2                	sd	s8,448(sp)
    8000407a:	ff66                	sd	s9,440(sp)
    8000407c:	fb6a                	sd	s10,432(sp)
    8000407e:	f76e                	sd	s11,424(sp)
    80004080:	0c00                	addi	s0,sp,528
    80004082:	84aa                	mv	s1,a0
    80004084:	dea43c23          	sd	a0,-520(s0)
    80004088:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000408c:	ffffd097          	auipc	ra,0xffffd
    80004090:	db2080e7          	jalr	-590(ra) # 80000e3e <myproc>
    80004094:	892a                	mv	s2,a0

  begin_op();
    80004096:	fffff097          	auipc	ra,0xfffff
    8000409a:	41a080e7          	jalr	1050(ra) # 800034b0 <begin_op>

  if((ip = namei(path)) == 0){
    8000409e:	8526                	mv	a0,s1
    800040a0:	fffff097          	auipc	ra,0xfffff
    800040a4:	1f4080e7          	jalr	500(ra) # 80003294 <namei>
    800040a8:	c92d                	beqz	a0,8000411a <exec+0xbc>
    800040aa:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040ac:	fffff097          	auipc	ra,0xfffff
    800040b0:	a42080e7          	jalr	-1470(ra) # 80002aee <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040b4:	04000713          	li	a4,64
    800040b8:	4681                	li	a3,0
    800040ba:	e5040613          	addi	a2,s0,-432
    800040be:	4581                	li	a1,0
    800040c0:	8526                	mv	a0,s1
    800040c2:	fffff097          	auipc	ra,0xfffff
    800040c6:	ce0080e7          	jalr	-800(ra) # 80002da2 <readi>
    800040ca:	04000793          	li	a5,64
    800040ce:	00f51a63          	bne	a0,a5,800040e2 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800040d2:	e5042703          	lw	a4,-432(s0)
    800040d6:	464c47b7          	lui	a5,0x464c4
    800040da:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800040de:	04f70463          	beq	a4,a5,80004126 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800040e2:	8526                	mv	a0,s1
    800040e4:	fffff097          	auipc	ra,0xfffff
    800040e8:	c6c080e7          	jalr	-916(ra) # 80002d50 <iunlockput>
    end_op();
    800040ec:	fffff097          	auipc	ra,0xfffff
    800040f0:	444080e7          	jalr	1092(ra) # 80003530 <end_op>
  }
  return -1;
    800040f4:	557d                	li	a0,-1
}
    800040f6:	20813083          	ld	ra,520(sp)
    800040fa:	20013403          	ld	s0,512(sp)
    800040fe:	74fe                	ld	s1,504(sp)
    80004100:	795e                	ld	s2,496(sp)
    80004102:	79be                	ld	s3,488(sp)
    80004104:	7a1e                	ld	s4,480(sp)
    80004106:	6afe                	ld	s5,472(sp)
    80004108:	6b5e                	ld	s6,464(sp)
    8000410a:	6bbe                	ld	s7,456(sp)
    8000410c:	6c1e                	ld	s8,448(sp)
    8000410e:	7cfa                	ld	s9,440(sp)
    80004110:	7d5a                	ld	s10,432(sp)
    80004112:	7dba                	ld	s11,424(sp)
    80004114:	21010113          	addi	sp,sp,528
    80004118:	8082                	ret
    end_op();
    8000411a:	fffff097          	auipc	ra,0xfffff
    8000411e:	416080e7          	jalr	1046(ra) # 80003530 <end_op>
    return -1;
    80004122:	557d                	li	a0,-1
    80004124:	bfc9                	j	800040f6 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004126:	854a                	mv	a0,s2
    80004128:	ffffd097          	auipc	ra,0xffffd
    8000412c:	dda080e7          	jalr	-550(ra) # 80000f02 <proc_pagetable>
    80004130:	8baa                	mv	s7,a0
    80004132:	d945                	beqz	a0,800040e2 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004134:	e7042983          	lw	s3,-400(s0)
    80004138:	e8845783          	lhu	a5,-376(s0)
    8000413c:	c7ad                	beqz	a5,800041a6 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000413e:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004140:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004142:	6c85                	lui	s9,0x1
    80004144:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004148:	def43823          	sd	a5,-528(s0)
    8000414c:	ac0d                	j	8000437e <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000414e:	00004517          	auipc	a0,0x4
    80004152:	50a50513          	addi	a0,a0,1290 # 80008658 <syscalls+0x298>
    80004156:	00002097          	auipc	ra,0x2
    8000415a:	b0c080e7          	jalr	-1268(ra) # 80005c62 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000415e:	8756                	mv	a4,s5
    80004160:	012d86bb          	addw	a3,s11,s2
    80004164:	4581                	li	a1,0
    80004166:	8526                	mv	a0,s1
    80004168:	fffff097          	auipc	ra,0xfffff
    8000416c:	c3a080e7          	jalr	-966(ra) # 80002da2 <readi>
    80004170:	2501                	sext.w	a0,a0
    80004172:	1aaa9a63          	bne	s5,a0,80004326 <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    80004176:	6785                	lui	a5,0x1
    80004178:	0127893b          	addw	s2,a5,s2
    8000417c:	77fd                	lui	a5,0xfffff
    8000417e:	01478a3b          	addw	s4,a5,s4
    80004182:	1f897563          	bgeu	s2,s8,8000436c <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    80004186:	02091593          	slli	a1,s2,0x20
    8000418a:	9181                	srli	a1,a1,0x20
    8000418c:	95ea                	add	a1,a1,s10
    8000418e:	855e                	mv	a0,s7
    80004190:	ffffc097          	auipc	ra,0xffffc
    80004194:	37a080e7          	jalr	890(ra) # 8000050a <walkaddr>
    80004198:	862a                	mv	a2,a0
    if(pa == 0)
    8000419a:	d955                	beqz	a0,8000414e <exec+0xf0>
      n = PGSIZE;
    8000419c:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000419e:	fd9a70e3          	bgeu	s4,s9,8000415e <exec+0x100>
      n = sz - i;
    800041a2:	8ad2                	mv	s5,s4
    800041a4:	bf6d                	j	8000415e <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041a6:	4a01                	li	s4,0
  iunlockput(ip);
    800041a8:	8526                	mv	a0,s1
    800041aa:	fffff097          	auipc	ra,0xfffff
    800041ae:	ba6080e7          	jalr	-1114(ra) # 80002d50 <iunlockput>
  end_op();
    800041b2:	fffff097          	auipc	ra,0xfffff
    800041b6:	37e080e7          	jalr	894(ra) # 80003530 <end_op>
  p = myproc();
    800041ba:	ffffd097          	auipc	ra,0xffffd
    800041be:	c84080e7          	jalr	-892(ra) # 80000e3e <myproc>
    800041c2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800041c4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800041c8:	6785                	lui	a5,0x1
    800041ca:	17fd                	addi	a5,a5,-1
    800041cc:	9a3e                	add	s4,s4,a5
    800041ce:	757d                	lui	a0,0xfffff
    800041d0:	00aa77b3          	and	a5,s4,a0
    800041d4:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800041d8:	4691                	li	a3,4
    800041da:	6609                	lui	a2,0x2
    800041dc:	963e                	add	a2,a2,a5
    800041de:	85be                	mv	a1,a5
    800041e0:	855e                	mv	a0,s7
    800041e2:	ffffc097          	auipc	ra,0xffffc
    800041e6:	6ce080e7          	jalr	1742(ra) # 800008b0 <uvmalloc>
    800041ea:	8b2a                	mv	s6,a0
  ip = 0;
    800041ec:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800041ee:	12050c63          	beqz	a0,80004326 <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    800041f2:	75f9                	lui	a1,0xffffe
    800041f4:	95aa                	add	a1,a1,a0
    800041f6:	855e                	mv	a0,s7
    800041f8:	ffffd097          	auipc	ra,0xffffd
    800041fc:	8d2080e7          	jalr	-1838(ra) # 80000aca <uvmclear>
  stackbase = sp - PGSIZE;
    80004200:	7c7d                	lui	s8,0xfffff
    80004202:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004204:	e0043783          	ld	a5,-512(s0)
    80004208:	6388                	ld	a0,0(a5)
    8000420a:	c535                	beqz	a0,80004276 <exec+0x218>
    8000420c:	e9040993          	addi	s3,s0,-368
    80004210:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004214:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004216:	ffffc097          	auipc	ra,0xffffc
    8000421a:	0e6080e7          	jalr	230(ra) # 800002fc <strlen>
    8000421e:	2505                	addiw	a0,a0,1
    80004220:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004224:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004228:	13896663          	bltu	s2,s8,80004354 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000422c:	e0043d83          	ld	s11,-512(s0)
    80004230:	000dba03          	ld	s4,0(s11)
    80004234:	8552                	mv	a0,s4
    80004236:	ffffc097          	auipc	ra,0xffffc
    8000423a:	0c6080e7          	jalr	198(ra) # 800002fc <strlen>
    8000423e:	0015069b          	addiw	a3,a0,1
    80004242:	8652                	mv	a2,s4
    80004244:	85ca                	mv	a1,s2
    80004246:	855e                	mv	a0,s7
    80004248:	ffffd097          	auipc	ra,0xffffd
    8000424c:	8b4080e7          	jalr	-1868(ra) # 80000afc <copyout>
    80004250:	10054663          	bltz	a0,8000435c <exec+0x2fe>
    ustack[argc] = sp;
    80004254:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004258:	0485                	addi	s1,s1,1
    8000425a:	008d8793          	addi	a5,s11,8
    8000425e:	e0f43023          	sd	a5,-512(s0)
    80004262:	008db503          	ld	a0,8(s11)
    80004266:	c911                	beqz	a0,8000427a <exec+0x21c>
    if(argc >= MAXARG)
    80004268:	09a1                	addi	s3,s3,8
    8000426a:	fb3c96e3          	bne	s9,s3,80004216 <exec+0x1b8>
  sz = sz1;
    8000426e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004272:	4481                	li	s1,0
    80004274:	a84d                	j	80004326 <exec+0x2c8>
  sp = sz;
    80004276:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004278:	4481                	li	s1,0
  ustack[argc] = 0;
    8000427a:	00349793          	slli	a5,s1,0x3
    8000427e:	f9040713          	addi	a4,s0,-112
    80004282:	97ba                	add	a5,a5,a4
    80004284:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004288:	00148693          	addi	a3,s1,1
    8000428c:	068e                	slli	a3,a3,0x3
    8000428e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004292:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004296:	01897663          	bgeu	s2,s8,800042a2 <exec+0x244>
  sz = sz1;
    8000429a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000429e:	4481                	li	s1,0
    800042a0:	a059                	j	80004326 <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042a2:	e9040613          	addi	a2,s0,-368
    800042a6:	85ca                	mv	a1,s2
    800042a8:	855e                	mv	a0,s7
    800042aa:	ffffd097          	auipc	ra,0xffffd
    800042ae:	852080e7          	jalr	-1966(ra) # 80000afc <copyout>
    800042b2:	0a054963          	bltz	a0,80004364 <exec+0x306>
  p->trapframe->a1 = sp;
    800042b6:	058ab783          	ld	a5,88(s5)
    800042ba:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042be:	df843783          	ld	a5,-520(s0)
    800042c2:	0007c703          	lbu	a4,0(a5)
    800042c6:	cf11                	beqz	a4,800042e2 <exec+0x284>
    800042c8:	0785                	addi	a5,a5,1
    if(*s == '/')
    800042ca:	02f00693          	li	a3,47
    800042ce:	a039                	j	800042dc <exec+0x27e>
      last = s+1;
    800042d0:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800042d4:	0785                	addi	a5,a5,1
    800042d6:	fff7c703          	lbu	a4,-1(a5)
    800042da:	c701                	beqz	a4,800042e2 <exec+0x284>
    if(*s == '/')
    800042dc:	fed71ce3          	bne	a4,a3,800042d4 <exec+0x276>
    800042e0:	bfc5                	j	800042d0 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    800042e2:	4641                	li	a2,16
    800042e4:	df843583          	ld	a1,-520(s0)
    800042e8:	158a8513          	addi	a0,s5,344
    800042ec:	ffffc097          	auipc	ra,0xffffc
    800042f0:	fde080e7          	jalr	-34(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800042f4:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800042f8:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800042fc:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004300:	058ab783          	ld	a5,88(s5)
    80004304:	e6843703          	ld	a4,-408(s0)
    80004308:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000430a:	058ab783          	ld	a5,88(s5)
    8000430e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004312:	85ea                	mv	a1,s10
    80004314:	ffffd097          	auipc	ra,0xffffd
    80004318:	c8a080e7          	jalr	-886(ra) # 80000f9e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000431c:	0004851b          	sext.w	a0,s1
    80004320:	bbd9                	j	800040f6 <exec+0x98>
    80004322:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004326:	e0843583          	ld	a1,-504(s0)
    8000432a:	855e                	mv	a0,s7
    8000432c:	ffffd097          	auipc	ra,0xffffd
    80004330:	c72080e7          	jalr	-910(ra) # 80000f9e <proc_freepagetable>
  if(ip){
    80004334:	da0497e3          	bnez	s1,800040e2 <exec+0x84>
  return -1;
    80004338:	557d                	li	a0,-1
    8000433a:	bb75                	j	800040f6 <exec+0x98>
    8000433c:	e1443423          	sd	s4,-504(s0)
    80004340:	b7dd                	j	80004326 <exec+0x2c8>
    80004342:	e1443423          	sd	s4,-504(s0)
    80004346:	b7c5                	j	80004326 <exec+0x2c8>
    80004348:	e1443423          	sd	s4,-504(s0)
    8000434c:	bfe9                	j	80004326 <exec+0x2c8>
    8000434e:	e1443423          	sd	s4,-504(s0)
    80004352:	bfd1                	j	80004326 <exec+0x2c8>
  sz = sz1;
    80004354:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004358:	4481                	li	s1,0
    8000435a:	b7f1                	j	80004326 <exec+0x2c8>
  sz = sz1;
    8000435c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004360:	4481                	li	s1,0
    80004362:	b7d1                	j	80004326 <exec+0x2c8>
  sz = sz1;
    80004364:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004368:	4481                	li	s1,0
    8000436a:	bf75                	j	80004326 <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000436c:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004370:	2b05                	addiw	s6,s6,1
    80004372:	0389899b          	addiw	s3,s3,56
    80004376:	e8845783          	lhu	a5,-376(s0)
    8000437a:	e2fb57e3          	bge	s6,a5,800041a8 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000437e:	2981                	sext.w	s3,s3
    80004380:	03800713          	li	a4,56
    80004384:	86ce                	mv	a3,s3
    80004386:	e1840613          	addi	a2,s0,-488
    8000438a:	4581                	li	a1,0
    8000438c:	8526                	mv	a0,s1
    8000438e:	fffff097          	auipc	ra,0xfffff
    80004392:	a14080e7          	jalr	-1516(ra) # 80002da2 <readi>
    80004396:	03800793          	li	a5,56
    8000439a:	f8f514e3          	bne	a0,a5,80004322 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    8000439e:	e1842783          	lw	a5,-488(s0)
    800043a2:	4705                	li	a4,1
    800043a4:	fce796e3          	bne	a5,a4,80004370 <exec+0x312>
    if(ph.memsz < ph.filesz)
    800043a8:	e4043903          	ld	s2,-448(s0)
    800043ac:	e3843783          	ld	a5,-456(s0)
    800043b0:	f8f966e3          	bltu	s2,a5,8000433c <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043b4:	e2843783          	ld	a5,-472(s0)
    800043b8:	993e                	add	s2,s2,a5
    800043ba:	f8f964e3          	bltu	s2,a5,80004342 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    800043be:	df043703          	ld	a4,-528(s0)
    800043c2:	8ff9                	and	a5,a5,a4
    800043c4:	f3d1                	bnez	a5,80004348 <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800043c6:	e1c42503          	lw	a0,-484(s0)
    800043ca:	00000097          	auipc	ra,0x0
    800043ce:	c78080e7          	jalr	-904(ra) # 80004042 <flags2perm>
    800043d2:	86aa                	mv	a3,a0
    800043d4:	864a                	mv	a2,s2
    800043d6:	85d2                	mv	a1,s4
    800043d8:	855e                	mv	a0,s7
    800043da:	ffffc097          	auipc	ra,0xffffc
    800043de:	4d6080e7          	jalr	1238(ra) # 800008b0 <uvmalloc>
    800043e2:	e0a43423          	sd	a0,-504(s0)
    800043e6:	d525                	beqz	a0,8000434e <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800043e8:	e2843d03          	ld	s10,-472(s0)
    800043ec:	e2042d83          	lw	s11,-480(s0)
    800043f0:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800043f4:	f60c0ce3          	beqz	s8,8000436c <exec+0x30e>
    800043f8:	8a62                	mv	s4,s8
    800043fa:	4901                	li	s2,0
    800043fc:	b369                	j	80004186 <exec+0x128>

00000000800043fe <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800043fe:	7179                	addi	sp,sp,-48
    80004400:	f406                	sd	ra,40(sp)
    80004402:	f022                	sd	s0,32(sp)
    80004404:	ec26                	sd	s1,24(sp)
    80004406:	e84a                	sd	s2,16(sp)
    80004408:	1800                	addi	s0,sp,48
    8000440a:	892e                	mv	s2,a1
    8000440c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000440e:	fdc40593          	addi	a1,s0,-36
    80004412:	ffffe097          	auipc	ra,0xffffe
    80004416:	b62080e7          	jalr	-1182(ra) # 80001f74 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000441a:	fdc42703          	lw	a4,-36(s0)
    8000441e:	47bd                	li	a5,15
    80004420:	02e7eb63          	bltu	a5,a4,80004456 <argfd+0x58>
    80004424:	ffffd097          	auipc	ra,0xffffd
    80004428:	a1a080e7          	jalr	-1510(ra) # 80000e3e <myproc>
    8000442c:	fdc42703          	lw	a4,-36(s0)
    80004430:	01a70793          	addi	a5,a4,26
    80004434:	078e                	slli	a5,a5,0x3
    80004436:	953e                	add	a0,a0,a5
    80004438:	611c                	ld	a5,0(a0)
    8000443a:	c385                	beqz	a5,8000445a <argfd+0x5c>
    return -1;
  if(pfd)
    8000443c:	00090463          	beqz	s2,80004444 <argfd+0x46>
    *pfd = fd;
    80004440:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004444:	4501                	li	a0,0
  if(pf)
    80004446:	c091                	beqz	s1,8000444a <argfd+0x4c>
    *pf = f;
    80004448:	e09c                	sd	a5,0(s1)
}
    8000444a:	70a2                	ld	ra,40(sp)
    8000444c:	7402                	ld	s0,32(sp)
    8000444e:	64e2                	ld	s1,24(sp)
    80004450:	6942                	ld	s2,16(sp)
    80004452:	6145                	addi	sp,sp,48
    80004454:	8082                	ret
    return -1;
    80004456:	557d                	li	a0,-1
    80004458:	bfcd                	j	8000444a <argfd+0x4c>
    8000445a:	557d                	li	a0,-1
    8000445c:	b7fd                	j	8000444a <argfd+0x4c>

000000008000445e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000445e:	1101                	addi	sp,sp,-32
    80004460:	ec06                	sd	ra,24(sp)
    80004462:	e822                	sd	s0,16(sp)
    80004464:	e426                	sd	s1,8(sp)
    80004466:	1000                	addi	s0,sp,32
    80004468:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000446a:	ffffd097          	auipc	ra,0xffffd
    8000446e:	9d4080e7          	jalr	-1580(ra) # 80000e3e <myproc>
    80004472:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004474:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdd370>
    80004478:	4501                	li	a0,0
    8000447a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000447c:	6398                	ld	a4,0(a5)
    8000447e:	cb19                	beqz	a4,80004494 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004480:	2505                	addiw	a0,a0,1
    80004482:	07a1                	addi	a5,a5,8
    80004484:	fed51ce3          	bne	a0,a3,8000447c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004488:	557d                	li	a0,-1
}
    8000448a:	60e2                	ld	ra,24(sp)
    8000448c:	6442                	ld	s0,16(sp)
    8000448e:	64a2                	ld	s1,8(sp)
    80004490:	6105                	addi	sp,sp,32
    80004492:	8082                	ret
      p->ofile[fd] = f;
    80004494:	01a50793          	addi	a5,a0,26
    80004498:	078e                	slli	a5,a5,0x3
    8000449a:	963e                	add	a2,a2,a5
    8000449c:	e204                	sd	s1,0(a2)
      return fd;
    8000449e:	b7f5                	j	8000448a <fdalloc+0x2c>

00000000800044a0 <create>:
}


static struct inode*
create(char *path, short type, short major, short minor)
{
    800044a0:	715d                	addi	sp,sp,-80
    800044a2:	e486                	sd	ra,72(sp)
    800044a4:	e0a2                	sd	s0,64(sp)
    800044a6:	fc26                	sd	s1,56(sp)
    800044a8:	f84a                	sd	s2,48(sp)
    800044aa:	f44e                	sd	s3,40(sp)
    800044ac:	f052                	sd	s4,32(sp)
    800044ae:	ec56                	sd	s5,24(sp)
    800044b0:	e85a                	sd	s6,16(sp)
    800044b2:	0880                	addi	s0,sp,80
    800044b4:	8b2e                	mv	s6,a1
    800044b6:	89b2                	mv	s3,a2
    800044b8:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044ba:	fb040593          	addi	a1,s0,-80
    800044be:	fffff097          	auipc	ra,0xfffff
    800044c2:	df4080e7          	jalr	-524(ra) # 800032b2 <nameiparent>
    800044c6:	84aa                	mv	s1,a0
    800044c8:	16050063          	beqz	a0,80004628 <create+0x188>
    return 0;

  ilock(dp);
    800044cc:	ffffe097          	auipc	ra,0xffffe
    800044d0:	622080e7          	jalr	1570(ra) # 80002aee <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044d4:	4601                	li	a2,0
    800044d6:	fb040593          	addi	a1,s0,-80
    800044da:	8526                	mv	a0,s1
    800044dc:	fffff097          	auipc	ra,0xfffff
    800044e0:	af6080e7          	jalr	-1290(ra) # 80002fd2 <dirlookup>
    800044e4:	8aaa                	mv	s5,a0
    800044e6:	c931                	beqz	a0,8000453a <create+0x9a>
    iunlockput(dp);
    800044e8:	8526                	mv	a0,s1
    800044ea:	fffff097          	auipc	ra,0xfffff
    800044ee:	866080e7          	jalr	-1946(ra) # 80002d50 <iunlockput>
    ilock(ip);
    800044f2:	8556                	mv	a0,s5
    800044f4:	ffffe097          	auipc	ra,0xffffe
    800044f8:	5fa080e7          	jalr	1530(ra) # 80002aee <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800044fc:	000b059b          	sext.w	a1,s6
    80004500:	4789                	li	a5,2
    80004502:	02f59563          	bne	a1,a5,8000452c <create+0x8c>
    80004506:	044ad783          	lhu	a5,68(s5)
    8000450a:	37f9                	addiw	a5,a5,-2
    8000450c:	17c2                	slli	a5,a5,0x30
    8000450e:	93c1                	srli	a5,a5,0x30
    80004510:	4705                	li	a4,1
    80004512:	00f76d63          	bltu	a4,a5,8000452c <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004516:	8556                	mv	a0,s5
    80004518:	60a6                	ld	ra,72(sp)
    8000451a:	6406                	ld	s0,64(sp)
    8000451c:	74e2                	ld	s1,56(sp)
    8000451e:	7942                	ld	s2,48(sp)
    80004520:	79a2                	ld	s3,40(sp)
    80004522:	7a02                	ld	s4,32(sp)
    80004524:	6ae2                	ld	s5,24(sp)
    80004526:	6b42                	ld	s6,16(sp)
    80004528:	6161                	addi	sp,sp,80
    8000452a:	8082                	ret
    iunlockput(ip);
    8000452c:	8556                	mv	a0,s5
    8000452e:	fffff097          	auipc	ra,0xfffff
    80004532:	822080e7          	jalr	-2014(ra) # 80002d50 <iunlockput>
    return 0;
    80004536:	4a81                	li	s5,0
    80004538:	bff9                	j	80004516 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000453a:	85da                	mv	a1,s6
    8000453c:	4088                	lw	a0,0(s1)
    8000453e:	ffffe097          	auipc	ra,0xffffe
    80004542:	414080e7          	jalr	1044(ra) # 80002952 <ialloc>
    80004546:	8a2a                	mv	s4,a0
    80004548:	c921                	beqz	a0,80004598 <create+0xf8>
  ilock(ip);
    8000454a:	ffffe097          	auipc	ra,0xffffe
    8000454e:	5a4080e7          	jalr	1444(ra) # 80002aee <ilock>
  ip->major = major;
    80004552:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004556:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000455a:	4785                	li	a5,1
    8000455c:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    80004560:	8552                	mv	a0,s4
    80004562:	ffffe097          	auipc	ra,0xffffe
    80004566:	4c2080e7          	jalr	1218(ra) # 80002a24 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000456a:	000b059b          	sext.w	a1,s6
    8000456e:	4785                	li	a5,1
    80004570:	02f58b63          	beq	a1,a5,800045a6 <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    80004574:	004a2603          	lw	a2,4(s4)
    80004578:	fb040593          	addi	a1,s0,-80
    8000457c:	8526                	mv	a0,s1
    8000457e:	fffff097          	auipc	ra,0xfffff
    80004582:	c64080e7          	jalr	-924(ra) # 800031e2 <dirlink>
    80004586:	06054f63          	bltz	a0,80004604 <create+0x164>
  iunlockput(dp);
    8000458a:	8526                	mv	a0,s1
    8000458c:	ffffe097          	auipc	ra,0xffffe
    80004590:	7c4080e7          	jalr	1988(ra) # 80002d50 <iunlockput>
  return ip;
    80004594:	8ad2                	mv	s5,s4
    80004596:	b741                	j	80004516 <create+0x76>
    iunlockput(dp);
    80004598:	8526                	mv	a0,s1
    8000459a:	ffffe097          	auipc	ra,0xffffe
    8000459e:	7b6080e7          	jalr	1974(ra) # 80002d50 <iunlockput>
    return 0;
    800045a2:	8ad2                	mv	s5,s4
    800045a4:	bf8d                	j	80004516 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045a6:	004a2603          	lw	a2,4(s4)
    800045aa:	00004597          	auipc	a1,0x4
    800045ae:	0ce58593          	addi	a1,a1,206 # 80008678 <syscalls+0x2b8>
    800045b2:	8552                	mv	a0,s4
    800045b4:	fffff097          	auipc	ra,0xfffff
    800045b8:	c2e080e7          	jalr	-978(ra) # 800031e2 <dirlink>
    800045bc:	04054463          	bltz	a0,80004604 <create+0x164>
    800045c0:	40d0                	lw	a2,4(s1)
    800045c2:	00004597          	auipc	a1,0x4
    800045c6:	0be58593          	addi	a1,a1,190 # 80008680 <syscalls+0x2c0>
    800045ca:	8552                	mv	a0,s4
    800045cc:	fffff097          	auipc	ra,0xfffff
    800045d0:	c16080e7          	jalr	-1002(ra) # 800031e2 <dirlink>
    800045d4:	02054863          	bltz	a0,80004604 <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    800045d8:	004a2603          	lw	a2,4(s4)
    800045dc:	fb040593          	addi	a1,s0,-80
    800045e0:	8526                	mv	a0,s1
    800045e2:	fffff097          	auipc	ra,0xfffff
    800045e6:	c00080e7          	jalr	-1024(ra) # 800031e2 <dirlink>
    800045ea:	00054d63          	bltz	a0,80004604 <create+0x164>
    dp->nlink++;  // for ".."
    800045ee:	04a4d783          	lhu	a5,74(s1)
    800045f2:	2785                	addiw	a5,a5,1
    800045f4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800045f8:	8526                	mv	a0,s1
    800045fa:	ffffe097          	auipc	ra,0xffffe
    800045fe:	42a080e7          	jalr	1066(ra) # 80002a24 <iupdate>
    80004602:	b761                	j	8000458a <create+0xea>
  ip->nlink = 0;
    80004604:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004608:	8552                	mv	a0,s4
    8000460a:	ffffe097          	auipc	ra,0xffffe
    8000460e:	41a080e7          	jalr	1050(ra) # 80002a24 <iupdate>
  iunlockput(ip);
    80004612:	8552                	mv	a0,s4
    80004614:	ffffe097          	auipc	ra,0xffffe
    80004618:	73c080e7          	jalr	1852(ra) # 80002d50 <iunlockput>
  iunlockput(dp);
    8000461c:	8526                	mv	a0,s1
    8000461e:	ffffe097          	auipc	ra,0xffffe
    80004622:	732080e7          	jalr	1842(ra) # 80002d50 <iunlockput>
  return 0;
    80004626:	bdc5                	j	80004516 <create+0x76>
    return 0;
    80004628:	8aaa                	mv	s5,a0
    8000462a:	b5f5                	j	80004516 <create+0x76>

000000008000462c <sys_dup>:
{
    8000462c:	7179                	addi	sp,sp,-48
    8000462e:	f406                	sd	ra,40(sp)
    80004630:	f022                	sd	s0,32(sp)
    80004632:	ec26                	sd	s1,24(sp)
    80004634:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004636:	fd840613          	addi	a2,s0,-40
    8000463a:	4581                	li	a1,0
    8000463c:	4501                	li	a0,0
    8000463e:	00000097          	auipc	ra,0x0
    80004642:	dc0080e7          	jalr	-576(ra) # 800043fe <argfd>
    return -1;
    80004646:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004648:	02054363          	bltz	a0,8000466e <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000464c:	fd843503          	ld	a0,-40(s0)
    80004650:	00000097          	auipc	ra,0x0
    80004654:	e0e080e7          	jalr	-498(ra) # 8000445e <fdalloc>
    80004658:	84aa                	mv	s1,a0
    return -1;
    8000465a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000465c:	00054963          	bltz	a0,8000466e <sys_dup+0x42>
  filedup(f);
    80004660:	fd843503          	ld	a0,-40(s0)
    80004664:	fffff097          	auipc	ra,0xfffff
    80004668:	2c6080e7          	jalr	710(ra) # 8000392a <filedup>
  return fd;
    8000466c:	87a6                	mv	a5,s1
}
    8000466e:	853e                	mv	a0,a5
    80004670:	70a2                	ld	ra,40(sp)
    80004672:	7402                	ld	s0,32(sp)
    80004674:	64e2                	ld	s1,24(sp)
    80004676:	6145                	addi	sp,sp,48
    80004678:	8082                	ret

000000008000467a <sys_read>:
{
    8000467a:	7179                	addi	sp,sp,-48
    8000467c:	f406                	sd	ra,40(sp)
    8000467e:	f022                	sd	s0,32(sp)
    80004680:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004682:	fd840593          	addi	a1,s0,-40
    80004686:	4505                	li	a0,1
    80004688:	ffffe097          	auipc	ra,0xffffe
    8000468c:	90c080e7          	jalr	-1780(ra) # 80001f94 <argaddr>
  argint(2, &n);
    80004690:	fe440593          	addi	a1,s0,-28
    80004694:	4509                	li	a0,2
    80004696:	ffffe097          	auipc	ra,0xffffe
    8000469a:	8de080e7          	jalr	-1826(ra) # 80001f74 <argint>
  if(argfd(0, 0, &f) < 0)
    8000469e:	fe840613          	addi	a2,s0,-24
    800046a2:	4581                	li	a1,0
    800046a4:	4501                	li	a0,0
    800046a6:	00000097          	auipc	ra,0x0
    800046aa:	d58080e7          	jalr	-680(ra) # 800043fe <argfd>
    800046ae:	87aa                	mv	a5,a0
    return -1;
    800046b0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046b2:	0007cc63          	bltz	a5,800046ca <sys_read+0x50>
  return fileread(f, p, n);
    800046b6:	fe442603          	lw	a2,-28(s0)
    800046ba:	fd843583          	ld	a1,-40(s0)
    800046be:	fe843503          	ld	a0,-24(s0)
    800046c2:	fffff097          	auipc	ra,0xfffff
    800046c6:	44e080e7          	jalr	1102(ra) # 80003b10 <fileread>
}
    800046ca:	70a2                	ld	ra,40(sp)
    800046cc:	7402                	ld	s0,32(sp)
    800046ce:	6145                	addi	sp,sp,48
    800046d0:	8082                	ret

00000000800046d2 <sys_write>:
{
    800046d2:	7179                	addi	sp,sp,-48
    800046d4:	f406                	sd	ra,40(sp)
    800046d6:	f022                	sd	s0,32(sp)
    800046d8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800046da:	fd840593          	addi	a1,s0,-40
    800046de:	4505                	li	a0,1
    800046e0:	ffffe097          	auipc	ra,0xffffe
    800046e4:	8b4080e7          	jalr	-1868(ra) # 80001f94 <argaddr>
  argint(2, &n);
    800046e8:	fe440593          	addi	a1,s0,-28
    800046ec:	4509                	li	a0,2
    800046ee:	ffffe097          	auipc	ra,0xffffe
    800046f2:	886080e7          	jalr	-1914(ra) # 80001f74 <argint>
  if(argfd(0, 0, &f) < 0)
    800046f6:	fe840613          	addi	a2,s0,-24
    800046fa:	4581                	li	a1,0
    800046fc:	4501                	li	a0,0
    800046fe:	00000097          	auipc	ra,0x0
    80004702:	d00080e7          	jalr	-768(ra) # 800043fe <argfd>
    80004706:	87aa                	mv	a5,a0
    return -1;
    80004708:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000470a:	0007cc63          	bltz	a5,80004722 <sys_write+0x50>
  return filewrite(f, p, n);
    8000470e:	fe442603          	lw	a2,-28(s0)
    80004712:	fd843583          	ld	a1,-40(s0)
    80004716:	fe843503          	ld	a0,-24(s0)
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	4b8080e7          	jalr	1208(ra) # 80003bd2 <filewrite>
}
    80004722:	70a2                	ld	ra,40(sp)
    80004724:	7402                	ld	s0,32(sp)
    80004726:	6145                	addi	sp,sp,48
    80004728:	8082                	ret

000000008000472a <sys_close>:
{
    8000472a:	1101                	addi	sp,sp,-32
    8000472c:	ec06                	sd	ra,24(sp)
    8000472e:	e822                	sd	s0,16(sp)
    80004730:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004732:	fe040613          	addi	a2,s0,-32
    80004736:	fec40593          	addi	a1,s0,-20
    8000473a:	4501                	li	a0,0
    8000473c:	00000097          	auipc	ra,0x0
    80004740:	cc2080e7          	jalr	-830(ra) # 800043fe <argfd>
    return -1;
    80004744:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004746:	02054463          	bltz	a0,8000476e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000474a:	ffffc097          	auipc	ra,0xffffc
    8000474e:	6f4080e7          	jalr	1780(ra) # 80000e3e <myproc>
    80004752:	fec42783          	lw	a5,-20(s0)
    80004756:	07e9                	addi	a5,a5,26
    80004758:	078e                	slli	a5,a5,0x3
    8000475a:	97aa                	add	a5,a5,a0
    8000475c:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004760:	fe043503          	ld	a0,-32(s0)
    80004764:	fffff097          	auipc	ra,0xfffff
    80004768:	218080e7          	jalr	536(ra) # 8000397c <fileclose>
  return 0;
    8000476c:	4781                	li	a5,0
}
    8000476e:	853e                	mv	a0,a5
    80004770:	60e2                	ld	ra,24(sp)
    80004772:	6442                	ld	s0,16(sp)
    80004774:	6105                	addi	sp,sp,32
    80004776:	8082                	ret

0000000080004778 <sys_fstat>:
{
    80004778:	1101                	addi	sp,sp,-32
    8000477a:	ec06                	sd	ra,24(sp)
    8000477c:	e822                	sd	s0,16(sp)
    8000477e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004780:	fe040593          	addi	a1,s0,-32
    80004784:	4505                	li	a0,1
    80004786:	ffffe097          	auipc	ra,0xffffe
    8000478a:	80e080e7          	jalr	-2034(ra) # 80001f94 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000478e:	fe840613          	addi	a2,s0,-24
    80004792:	4581                	li	a1,0
    80004794:	4501                	li	a0,0
    80004796:	00000097          	auipc	ra,0x0
    8000479a:	c68080e7          	jalr	-920(ra) # 800043fe <argfd>
    8000479e:	87aa                	mv	a5,a0
    return -1;
    800047a0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047a2:	0007ca63          	bltz	a5,800047b6 <sys_fstat+0x3e>
  return filestat(f, st);
    800047a6:	fe043583          	ld	a1,-32(s0)
    800047aa:	fe843503          	ld	a0,-24(s0)
    800047ae:	fffff097          	auipc	ra,0xfffff
    800047b2:	296080e7          	jalr	662(ra) # 80003a44 <filestat>
}
    800047b6:	60e2                	ld	ra,24(sp)
    800047b8:	6442                	ld	s0,16(sp)
    800047ba:	6105                	addi	sp,sp,32
    800047bc:	8082                	ret

00000000800047be <sys_link>:
{
    800047be:	7169                	addi	sp,sp,-304
    800047c0:	f606                	sd	ra,296(sp)
    800047c2:	f222                	sd	s0,288(sp)
    800047c4:	ee26                	sd	s1,280(sp)
    800047c6:	ea4a                	sd	s2,272(sp)
    800047c8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047ca:	08000613          	li	a2,128
    800047ce:	ed040593          	addi	a1,s0,-304
    800047d2:	4501                	li	a0,0
    800047d4:	ffffd097          	auipc	ra,0xffffd
    800047d8:	7e0080e7          	jalr	2016(ra) # 80001fb4 <argstr>
    return -1;
    800047dc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047de:	10054e63          	bltz	a0,800048fa <sys_link+0x13c>
    800047e2:	08000613          	li	a2,128
    800047e6:	f5040593          	addi	a1,s0,-176
    800047ea:	4505                	li	a0,1
    800047ec:	ffffd097          	auipc	ra,0xffffd
    800047f0:	7c8080e7          	jalr	1992(ra) # 80001fb4 <argstr>
    return -1;
    800047f4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047f6:	10054263          	bltz	a0,800048fa <sys_link+0x13c>
  begin_op();
    800047fa:	fffff097          	auipc	ra,0xfffff
    800047fe:	cb6080e7          	jalr	-842(ra) # 800034b0 <begin_op>
  if((ip = namei(old)) == 0){
    80004802:	ed040513          	addi	a0,s0,-304
    80004806:	fffff097          	auipc	ra,0xfffff
    8000480a:	a8e080e7          	jalr	-1394(ra) # 80003294 <namei>
    8000480e:	84aa                	mv	s1,a0
    80004810:	c551                	beqz	a0,8000489c <sys_link+0xde>
  ilock(ip);
    80004812:	ffffe097          	auipc	ra,0xffffe
    80004816:	2dc080e7          	jalr	732(ra) # 80002aee <ilock>
  if(ip->type == T_DIR){
    8000481a:	04449703          	lh	a4,68(s1)
    8000481e:	4785                	li	a5,1
    80004820:	08f70463          	beq	a4,a5,800048a8 <sys_link+0xea>
  ip->nlink++;
    80004824:	04a4d783          	lhu	a5,74(s1)
    80004828:	2785                	addiw	a5,a5,1
    8000482a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000482e:	8526                	mv	a0,s1
    80004830:	ffffe097          	auipc	ra,0xffffe
    80004834:	1f4080e7          	jalr	500(ra) # 80002a24 <iupdate>
  iunlock(ip);
    80004838:	8526                	mv	a0,s1
    8000483a:	ffffe097          	auipc	ra,0xffffe
    8000483e:	376080e7          	jalr	886(ra) # 80002bb0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004842:	fd040593          	addi	a1,s0,-48
    80004846:	f5040513          	addi	a0,s0,-176
    8000484a:	fffff097          	auipc	ra,0xfffff
    8000484e:	a68080e7          	jalr	-1432(ra) # 800032b2 <nameiparent>
    80004852:	892a                	mv	s2,a0
    80004854:	c935                	beqz	a0,800048c8 <sys_link+0x10a>
  ilock(dp);
    80004856:	ffffe097          	auipc	ra,0xffffe
    8000485a:	298080e7          	jalr	664(ra) # 80002aee <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000485e:	00092703          	lw	a4,0(s2)
    80004862:	409c                	lw	a5,0(s1)
    80004864:	04f71d63          	bne	a4,a5,800048be <sys_link+0x100>
    80004868:	40d0                	lw	a2,4(s1)
    8000486a:	fd040593          	addi	a1,s0,-48
    8000486e:	854a                	mv	a0,s2
    80004870:	fffff097          	auipc	ra,0xfffff
    80004874:	972080e7          	jalr	-1678(ra) # 800031e2 <dirlink>
    80004878:	04054363          	bltz	a0,800048be <sys_link+0x100>
  iunlockput(dp);
    8000487c:	854a                	mv	a0,s2
    8000487e:	ffffe097          	auipc	ra,0xffffe
    80004882:	4d2080e7          	jalr	1234(ra) # 80002d50 <iunlockput>
  iput(ip);
    80004886:	8526                	mv	a0,s1
    80004888:	ffffe097          	auipc	ra,0xffffe
    8000488c:	420080e7          	jalr	1056(ra) # 80002ca8 <iput>
  end_op();
    80004890:	fffff097          	auipc	ra,0xfffff
    80004894:	ca0080e7          	jalr	-864(ra) # 80003530 <end_op>
  return 0;
    80004898:	4781                	li	a5,0
    8000489a:	a085                	j	800048fa <sys_link+0x13c>
    end_op();
    8000489c:	fffff097          	auipc	ra,0xfffff
    800048a0:	c94080e7          	jalr	-876(ra) # 80003530 <end_op>
    return -1;
    800048a4:	57fd                	li	a5,-1
    800048a6:	a891                	j	800048fa <sys_link+0x13c>
    iunlockput(ip);
    800048a8:	8526                	mv	a0,s1
    800048aa:	ffffe097          	auipc	ra,0xffffe
    800048ae:	4a6080e7          	jalr	1190(ra) # 80002d50 <iunlockput>
    end_op();
    800048b2:	fffff097          	auipc	ra,0xfffff
    800048b6:	c7e080e7          	jalr	-898(ra) # 80003530 <end_op>
    return -1;
    800048ba:	57fd                	li	a5,-1
    800048bc:	a83d                	j	800048fa <sys_link+0x13c>
    iunlockput(dp);
    800048be:	854a                	mv	a0,s2
    800048c0:	ffffe097          	auipc	ra,0xffffe
    800048c4:	490080e7          	jalr	1168(ra) # 80002d50 <iunlockput>
  ilock(ip);
    800048c8:	8526                	mv	a0,s1
    800048ca:	ffffe097          	auipc	ra,0xffffe
    800048ce:	224080e7          	jalr	548(ra) # 80002aee <ilock>
  ip->nlink--;
    800048d2:	04a4d783          	lhu	a5,74(s1)
    800048d6:	37fd                	addiw	a5,a5,-1
    800048d8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048dc:	8526                	mv	a0,s1
    800048de:	ffffe097          	auipc	ra,0xffffe
    800048e2:	146080e7          	jalr	326(ra) # 80002a24 <iupdate>
  iunlockput(ip);
    800048e6:	8526                	mv	a0,s1
    800048e8:	ffffe097          	auipc	ra,0xffffe
    800048ec:	468080e7          	jalr	1128(ra) # 80002d50 <iunlockput>
  end_op();
    800048f0:	fffff097          	auipc	ra,0xfffff
    800048f4:	c40080e7          	jalr	-960(ra) # 80003530 <end_op>
  return -1;
    800048f8:	57fd                	li	a5,-1
}
    800048fa:	853e                	mv	a0,a5
    800048fc:	70b2                	ld	ra,296(sp)
    800048fe:	7412                	ld	s0,288(sp)
    80004900:	64f2                	ld	s1,280(sp)
    80004902:	6952                	ld	s2,272(sp)
    80004904:	6155                	addi	sp,sp,304
    80004906:	8082                	ret

0000000080004908 <sys_unlink>:
{
    80004908:	7151                	addi	sp,sp,-240
    8000490a:	f586                	sd	ra,232(sp)
    8000490c:	f1a2                	sd	s0,224(sp)
    8000490e:	eda6                	sd	s1,216(sp)
    80004910:	e9ca                	sd	s2,208(sp)
    80004912:	e5ce                	sd	s3,200(sp)
    80004914:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004916:	08000613          	li	a2,128
    8000491a:	f3040593          	addi	a1,s0,-208
    8000491e:	4501                	li	a0,0
    80004920:	ffffd097          	auipc	ra,0xffffd
    80004924:	694080e7          	jalr	1684(ra) # 80001fb4 <argstr>
    80004928:	18054163          	bltz	a0,80004aaa <sys_unlink+0x1a2>
  begin_op();
    8000492c:	fffff097          	auipc	ra,0xfffff
    80004930:	b84080e7          	jalr	-1148(ra) # 800034b0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004934:	fb040593          	addi	a1,s0,-80
    80004938:	f3040513          	addi	a0,s0,-208
    8000493c:	fffff097          	auipc	ra,0xfffff
    80004940:	976080e7          	jalr	-1674(ra) # 800032b2 <nameiparent>
    80004944:	84aa                	mv	s1,a0
    80004946:	c979                	beqz	a0,80004a1c <sys_unlink+0x114>
  ilock(dp);
    80004948:	ffffe097          	auipc	ra,0xffffe
    8000494c:	1a6080e7          	jalr	422(ra) # 80002aee <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004950:	00004597          	auipc	a1,0x4
    80004954:	d2858593          	addi	a1,a1,-728 # 80008678 <syscalls+0x2b8>
    80004958:	fb040513          	addi	a0,s0,-80
    8000495c:	ffffe097          	auipc	ra,0xffffe
    80004960:	65c080e7          	jalr	1628(ra) # 80002fb8 <namecmp>
    80004964:	14050a63          	beqz	a0,80004ab8 <sys_unlink+0x1b0>
    80004968:	00004597          	auipc	a1,0x4
    8000496c:	d1858593          	addi	a1,a1,-744 # 80008680 <syscalls+0x2c0>
    80004970:	fb040513          	addi	a0,s0,-80
    80004974:	ffffe097          	auipc	ra,0xffffe
    80004978:	644080e7          	jalr	1604(ra) # 80002fb8 <namecmp>
    8000497c:	12050e63          	beqz	a0,80004ab8 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004980:	f2c40613          	addi	a2,s0,-212
    80004984:	fb040593          	addi	a1,s0,-80
    80004988:	8526                	mv	a0,s1
    8000498a:	ffffe097          	auipc	ra,0xffffe
    8000498e:	648080e7          	jalr	1608(ra) # 80002fd2 <dirlookup>
    80004992:	892a                	mv	s2,a0
    80004994:	12050263          	beqz	a0,80004ab8 <sys_unlink+0x1b0>
  ilock(ip);
    80004998:	ffffe097          	auipc	ra,0xffffe
    8000499c:	156080e7          	jalr	342(ra) # 80002aee <ilock>
  if(ip->nlink < 1)
    800049a0:	04a91783          	lh	a5,74(s2)
    800049a4:	08f05263          	blez	a5,80004a28 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049a8:	04491703          	lh	a4,68(s2)
    800049ac:	4785                	li	a5,1
    800049ae:	08f70563          	beq	a4,a5,80004a38 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049b2:	4641                	li	a2,16
    800049b4:	4581                	li	a1,0
    800049b6:	fc040513          	addi	a0,s0,-64
    800049ba:	ffffb097          	auipc	ra,0xffffb
    800049be:	7be080e7          	jalr	1982(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049c2:	4741                	li	a4,16
    800049c4:	f2c42683          	lw	a3,-212(s0)
    800049c8:	fc040613          	addi	a2,s0,-64
    800049cc:	4581                	li	a1,0
    800049ce:	8526                	mv	a0,s1
    800049d0:	ffffe097          	auipc	ra,0xffffe
    800049d4:	4ca080e7          	jalr	1226(ra) # 80002e9a <writei>
    800049d8:	47c1                	li	a5,16
    800049da:	0af51563          	bne	a0,a5,80004a84 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800049de:	04491703          	lh	a4,68(s2)
    800049e2:	4785                	li	a5,1
    800049e4:	0af70863          	beq	a4,a5,80004a94 <sys_unlink+0x18c>
  iunlockput(dp);
    800049e8:	8526                	mv	a0,s1
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	366080e7          	jalr	870(ra) # 80002d50 <iunlockput>
  ip->nlink--;
    800049f2:	04a95783          	lhu	a5,74(s2)
    800049f6:	37fd                	addiw	a5,a5,-1
    800049f8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049fc:	854a                	mv	a0,s2
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	026080e7          	jalr	38(ra) # 80002a24 <iupdate>
  iunlockput(ip);
    80004a06:	854a                	mv	a0,s2
    80004a08:	ffffe097          	auipc	ra,0xffffe
    80004a0c:	348080e7          	jalr	840(ra) # 80002d50 <iunlockput>
  end_op();
    80004a10:	fffff097          	auipc	ra,0xfffff
    80004a14:	b20080e7          	jalr	-1248(ra) # 80003530 <end_op>
  return 0;
    80004a18:	4501                	li	a0,0
    80004a1a:	a84d                	j	80004acc <sys_unlink+0x1c4>
    end_op();
    80004a1c:	fffff097          	auipc	ra,0xfffff
    80004a20:	b14080e7          	jalr	-1260(ra) # 80003530 <end_op>
    return -1;
    80004a24:	557d                	li	a0,-1
    80004a26:	a05d                	j	80004acc <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a28:	00004517          	auipc	a0,0x4
    80004a2c:	c6050513          	addi	a0,a0,-928 # 80008688 <syscalls+0x2c8>
    80004a30:	00001097          	auipc	ra,0x1
    80004a34:	232080e7          	jalr	562(ra) # 80005c62 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a38:	04c92703          	lw	a4,76(s2)
    80004a3c:	02000793          	li	a5,32
    80004a40:	f6e7f9e3          	bgeu	a5,a4,800049b2 <sys_unlink+0xaa>
    80004a44:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a48:	4741                	li	a4,16
    80004a4a:	86ce                	mv	a3,s3
    80004a4c:	f1840613          	addi	a2,s0,-232
    80004a50:	4581                	li	a1,0
    80004a52:	854a                	mv	a0,s2
    80004a54:	ffffe097          	auipc	ra,0xffffe
    80004a58:	34e080e7          	jalr	846(ra) # 80002da2 <readi>
    80004a5c:	47c1                	li	a5,16
    80004a5e:	00f51b63          	bne	a0,a5,80004a74 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a62:	f1845783          	lhu	a5,-232(s0)
    80004a66:	e7a1                	bnez	a5,80004aae <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a68:	29c1                	addiw	s3,s3,16
    80004a6a:	04c92783          	lw	a5,76(s2)
    80004a6e:	fcf9ede3          	bltu	s3,a5,80004a48 <sys_unlink+0x140>
    80004a72:	b781                	j	800049b2 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a74:	00004517          	auipc	a0,0x4
    80004a78:	c2c50513          	addi	a0,a0,-980 # 800086a0 <syscalls+0x2e0>
    80004a7c:	00001097          	auipc	ra,0x1
    80004a80:	1e6080e7          	jalr	486(ra) # 80005c62 <panic>
    panic("unlink: writei");
    80004a84:	00004517          	auipc	a0,0x4
    80004a88:	c3450513          	addi	a0,a0,-972 # 800086b8 <syscalls+0x2f8>
    80004a8c:	00001097          	auipc	ra,0x1
    80004a90:	1d6080e7          	jalr	470(ra) # 80005c62 <panic>
    dp->nlink--;
    80004a94:	04a4d783          	lhu	a5,74(s1)
    80004a98:	37fd                	addiw	a5,a5,-1
    80004a9a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a9e:	8526                	mv	a0,s1
    80004aa0:	ffffe097          	auipc	ra,0xffffe
    80004aa4:	f84080e7          	jalr	-124(ra) # 80002a24 <iupdate>
    80004aa8:	b781                	j	800049e8 <sys_unlink+0xe0>
    return -1;
    80004aaa:	557d                	li	a0,-1
    80004aac:	a005                	j	80004acc <sys_unlink+0x1c4>
    iunlockput(ip);
    80004aae:	854a                	mv	a0,s2
    80004ab0:	ffffe097          	auipc	ra,0xffffe
    80004ab4:	2a0080e7          	jalr	672(ra) # 80002d50 <iunlockput>
  iunlockput(dp);
    80004ab8:	8526                	mv	a0,s1
    80004aba:	ffffe097          	auipc	ra,0xffffe
    80004abe:	296080e7          	jalr	662(ra) # 80002d50 <iunlockput>
  end_op();
    80004ac2:	fffff097          	auipc	ra,0xfffff
    80004ac6:	a6e080e7          	jalr	-1426(ra) # 80003530 <end_op>
  return -1;
    80004aca:	557d                	li	a0,-1
}
    80004acc:	70ae                	ld	ra,232(sp)
    80004ace:	740e                	ld	s0,224(sp)
    80004ad0:	64ee                	ld	s1,216(sp)
    80004ad2:	694e                	ld	s2,208(sp)
    80004ad4:	69ae                	ld	s3,200(sp)
    80004ad6:	616d                	addi	sp,sp,240
    80004ad8:	8082                	ret

0000000080004ada <sys_mmap>:
{
    80004ada:	1141                	addi	sp,sp,-16
    80004adc:	e422                	sd	s0,8(sp)
    80004ade:	0800                	addi	s0,sp,16
}
    80004ae0:	4501                	li	a0,0
    80004ae2:	6422                	ld	s0,8(sp)
    80004ae4:	0141                	addi	sp,sp,16
    80004ae6:	8082                	ret

0000000080004ae8 <sys_munmap>:
{
    80004ae8:	1141                	addi	sp,sp,-16
    80004aea:	e422                	sd	s0,8(sp)
    80004aec:	0800                	addi	s0,sp,16
}
    80004aee:	4501                	li	a0,0
    80004af0:	6422                	ld	s0,8(sp)
    80004af2:	0141                	addi	sp,sp,16
    80004af4:	8082                	ret

0000000080004af6 <sys_open>:

uint64
sys_open(void)
{
    80004af6:	7131                	addi	sp,sp,-192
    80004af8:	fd06                	sd	ra,184(sp)
    80004afa:	f922                	sd	s0,176(sp)
    80004afc:	f526                	sd	s1,168(sp)
    80004afe:	f14a                	sd	s2,160(sp)
    80004b00:	ed4e                	sd	s3,152(sp)
    80004b02:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b04:	f4c40593          	addi	a1,s0,-180
    80004b08:	4505                	li	a0,1
    80004b0a:	ffffd097          	auipc	ra,0xffffd
    80004b0e:	46a080e7          	jalr	1130(ra) # 80001f74 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b12:	08000613          	li	a2,128
    80004b16:	f5040593          	addi	a1,s0,-176
    80004b1a:	4501                	li	a0,0
    80004b1c:	ffffd097          	auipc	ra,0xffffd
    80004b20:	498080e7          	jalr	1176(ra) # 80001fb4 <argstr>
    80004b24:	87aa                	mv	a5,a0
    return -1;
    80004b26:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b28:	0a07c963          	bltz	a5,80004bda <sys_open+0xe4>

  begin_op();
    80004b2c:	fffff097          	auipc	ra,0xfffff
    80004b30:	984080e7          	jalr	-1660(ra) # 800034b0 <begin_op>

  if(omode & O_CREATE){
    80004b34:	f4c42783          	lw	a5,-180(s0)
    80004b38:	2007f793          	andi	a5,a5,512
    80004b3c:	cfc5                	beqz	a5,80004bf4 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b3e:	4681                	li	a3,0
    80004b40:	4601                	li	a2,0
    80004b42:	4589                	li	a1,2
    80004b44:	f5040513          	addi	a0,s0,-176
    80004b48:	00000097          	auipc	ra,0x0
    80004b4c:	958080e7          	jalr	-1704(ra) # 800044a0 <create>
    80004b50:	84aa                	mv	s1,a0
    if(ip == 0){
    80004b52:	c959                	beqz	a0,80004be8 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b54:	04449703          	lh	a4,68(s1)
    80004b58:	478d                	li	a5,3
    80004b5a:	00f71763          	bne	a4,a5,80004b68 <sys_open+0x72>
    80004b5e:	0464d703          	lhu	a4,70(s1)
    80004b62:	47a5                	li	a5,9
    80004b64:	0ce7ed63          	bltu	a5,a4,80004c3e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b68:	fffff097          	auipc	ra,0xfffff
    80004b6c:	d58080e7          	jalr	-680(ra) # 800038c0 <filealloc>
    80004b70:	89aa                	mv	s3,a0
    80004b72:	10050363          	beqz	a0,80004c78 <sys_open+0x182>
    80004b76:	00000097          	auipc	ra,0x0
    80004b7a:	8e8080e7          	jalr	-1816(ra) # 8000445e <fdalloc>
    80004b7e:	892a                	mv	s2,a0
    80004b80:	0e054763          	bltz	a0,80004c6e <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b84:	04449703          	lh	a4,68(s1)
    80004b88:	478d                	li	a5,3
    80004b8a:	0cf70563          	beq	a4,a5,80004c54 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b8e:	4789                	li	a5,2
    80004b90:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b94:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b98:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b9c:	f4c42783          	lw	a5,-180(s0)
    80004ba0:	0017c713          	xori	a4,a5,1
    80004ba4:	8b05                	andi	a4,a4,1
    80004ba6:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004baa:	0037f713          	andi	a4,a5,3
    80004bae:	00e03733          	snez	a4,a4
    80004bb2:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bb6:	4007f793          	andi	a5,a5,1024
    80004bba:	c791                	beqz	a5,80004bc6 <sys_open+0xd0>
    80004bbc:	04449703          	lh	a4,68(s1)
    80004bc0:	4789                	li	a5,2
    80004bc2:	0af70063          	beq	a4,a5,80004c62 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004bc6:	8526                	mv	a0,s1
    80004bc8:	ffffe097          	auipc	ra,0xffffe
    80004bcc:	fe8080e7          	jalr	-24(ra) # 80002bb0 <iunlock>
  end_op();
    80004bd0:	fffff097          	auipc	ra,0xfffff
    80004bd4:	960080e7          	jalr	-1696(ra) # 80003530 <end_op>

  return fd;
    80004bd8:	854a                	mv	a0,s2
}
    80004bda:	70ea                	ld	ra,184(sp)
    80004bdc:	744a                	ld	s0,176(sp)
    80004bde:	74aa                	ld	s1,168(sp)
    80004be0:	790a                	ld	s2,160(sp)
    80004be2:	69ea                	ld	s3,152(sp)
    80004be4:	6129                	addi	sp,sp,192
    80004be6:	8082                	ret
      end_op();
    80004be8:	fffff097          	auipc	ra,0xfffff
    80004bec:	948080e7          	jalr	-1720(ra) # 80003530 <end_op>
      return -1;
    80004bf0:	557d                	li	a0,-1
    80004bf2:	b7e5                	j	80004bda <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004bf4:	f5040513          	addi	a0,s0,-176
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	69c080e7          	jalr	1692(ra) # 80003294 <namei>
    80004c00:	84aa                	mv	s1,a0
    80004c02:	c905                	beqz	a0,80004c32 <sys_open+0x13c>
    ilock(ip);
    80004c04:	ffffe097          	auipc	ra,0xffffe
    80004c08:	eea080e7          	jalr	-278(ra) # 80002aee <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c0c:	04449703          	lh	a4,68(s1)
    80004c10:	4785                	li	a5,1
    80004c12:	f4f711e3          	bne	a4,a5,80004b54 <sys_open+0x5e>
    80004c16:	f4c42783          	lw	a5,-180(s0)
    80004c1a:	d7b9                	beqz	a5,80004b68 <sys_open+0x72>
      iunlockput(ip);
    80004c1c:	8526                	mv	a0,s1
    80004c1e:	ffffe097          	auipc	ra,0xffffe
    80004c22:	132080e7          	jalr	306(ra) # 80002d50 <iunlockput>
      end_op();
    80004c26:	fffff097          	auipc	ra,0xfffff
    80004c2a:	90a080e7          	jalr	-1782(ra) # 80003530 <end_op>
      return -1;
    80004c2e:	557d                	li	a0,-1
    80004c30:	b76d                	j	80004bda <sys_open+0xe4>
      end_op();
    80004c32:	fffff097          	auipc	ra,0xfffff
    80004c36:	8fe080e7          	jalr	-1794(ra) # 80003530 <end_op>
      return -1;
    80004c3a:	557d                	li	a0,-1
    80004c3c:	bf79                	j	80004bda <sys_open+0xe4>
    iunlockput(ip);
    80004c3e:	8526                	mv	a0,s1
    80004c40:	ffffe097          	auipc	ra,0xffffe
    80004c44:	110080e7          	jalr	272(ra) # 80002d50 <iunlockput>
    end_op();
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	8e8080e7          	jalr	-1816(ra) # 80003530 <end_op>
    return -1;
    80004c50:	557d                	li	a0,-1
    80004c52:	b761                	j	80004bda <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c54:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c58:	04649783          	lh	a5,70(s1)
    80004c5c:	02f99223          	sh	a5,36(s3)
    80004c60:	bf25                	j	80004b98 <sys_open+0xa2>
    itrunc(ip);
    80004c62:	8526                	mv	a0,s1
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	f98080e7          	jalr	-104(ra) # 80002bfc <itrunc>
    80004c6c:	bfa9                	j	80004bc6 <sys_open+0xd0>
      fileclose(f);
    80004c6e:	854e                	mv	a0,s3
    80004c70:	fffff097          	auipc	ra,0xfffff
    80004c74:	d0c080e7          	jalr	-756(ra) # 8000397c <fileclose>
    iunlockput(ip);
    80004c78:	8526                	mv	a0,s1
    80004c7a:	ffffe097          	auipc	ra,0xffffe
    80004c7e:	0d6080e7          	jalr	214(ra) # 80002d50 <iunlockput>
    end_op();
    80004c82:	fffff097          	auipc	ra,0xfffff
    80004c86:	8ae080e7          	jalr	-1874(ra) # 80003530 <end_op>
    return -1;
    80004c8a:	557d                	li	a0,-1
    80004c8c:	b7b9                	j	80004bda <sys_open+0xe4>

0000000080004c8e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c8e:	7175                	addi	sp,sp,-144
    80004c90:	e506                	sd	ra,136(sp)
    80004c92:	e122                	sd	s0,128(sp)
    80004c94:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c96:	fffff097          	auipc	ra,0xfffff
    80004c9a:	81a080e7          	jalr	-2022(ra) # 800034b0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c9e:	08000613          	li	a2,128
    80004ca2:	f7040593          	addi	a1,s0,-144
    80004ca6:	4501                	li	a0,0
    80004ca8:	ffffd097          	auipc	ra,0xffffd
    80004cac:	30c080e7          	jalr	780(ra) # 80001fb4 <argstr>
    80004cb0:	02054963          	bltz	a0,80004ce2 <sys_mkdir+0x54>
    80004cb4:	4681                	li	a3,0
    80004cb6:	4601                	li	a2,0
    80004cb8:	4585                	li	a1,1
    80004cba:	f7040513          	addi	a0,s0,-144
    80004cbe:	fffff097          	auipc	ra,0xfffff
    80004cc2:	7e2080e7          	jalr	2018(ra) # 800044a0 <create>
    80004cc6:	cd11                	beqz	a0,80004ce2 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cc8:	ffffe097          	auipc	ra,0xffffe
    80004ccc:	088080e7          	jalr	136(ra) # 80002d50 <iunlockput>
  end_op();
    80004cd0:	fffff097          	auipc	ra,0xfffff
    80004cd4:	860080e7          	jalr	-1952(ra) # 80003530 <end_op>
  return 0;
    80004cd8:	4501                	li	a0,0
}
    80004cda:	60aa                	ld	ra,136(sp)
    80004cdc:	640a                	ld	s0,128(sp)
    80004cde:	6149                	addi	sp,sp,144
    80004ce0:	8082                	ret
    end_op();
    80004ce2:	fffff097          	auipc	ra,0xfffff
    80004ce6:	84e080e7          	jalr	-1970(ra) # 80003530 <end_op>
    return -1;
    80004cea:	557d                	li	a0,-1
    80004cec:	b7fd                	j	80004cda <sys_mkdir+0x4c>

0000000080004cee <sys_mknod>:

uint64
sys_mknod(void)
{
    80004cee:	7135                	addi	sp,sp,-160
    80004cf0:	ed06                	sd	ra,152(sp)
    80004cf2:	e922                	sd	s0,144(sp)
    80004cf4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004cf6:	ffffe097          	auipc	ra,0xffffe
    80004cfa:	7ba080e7          	jalr	1978(ra) # 800034b0 <begin_op>
  argint(1, &major);
    80004cfe:	f6c40593          	addi	a1,s0,-148
    80004d02:	4505                	li	a0,1
    80004d04:	ffffd097          	auipc	ra,0xffffd
    80004d08:	270080e7          	jalr	624(ra) # 80001f74 <argint>
  argint(2, &minor);
    80004d0c:	f6840593          	addi	a1,s0,-152
    80004d10:	4509                	li	a0,2
    80004d12:	ffffd097          	auipc	ra,0xffffd
    80004d16:	262080e7          	jalr	610(ra) # 80001f74 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d1a:	08000613          	li	a2,128
    80004d1e:	f7040593          	addi	a1,s0,-144
    80004d22:	4501                	li	a0,0
    80004d24:	ffffd097          	auipc	ra,0xffffd
    80004d28:	290080e7          	jalr	656(ra) # 80001fb4 <argstr>
    80004d2c:	02054b63          	bltz	a0,80004d62 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d30:	f6841683          	lh	a3,-152(s0)
    80004d34:	f6c41603          	lh	a2,-148(s0)
    80004d38:	458d                	li	a1,3
    80004d3a:	f7040513          	addi	a0,s0,-144
    80004d3e:	fffff097          	auipc	ra,0xfffff
    80004d42:	762080e7          	jalr	1890(ra) # 800044a0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d46:	cd11                	beqz	a0,80004d62 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d48:	ffffe097          	auipc	ra,0xffffe
    80004d4c:	008080e7          	jalr	8(ra) # 80002d50 <iunlockput>
  end_op();
    80004d50:	ffffe097          	auipc	ra,0xffffe
    80004d54:	7e0080e7          	jalr	2016(ra) # 80003530 <end_op>
  return 0;
    80004d58:	4501                	li	a0,0
}
    80004d5a:	60ea                	ld	ra,152(sp)
    80004d5c:	644a                	ld	s0,144(sp)
    80004d5e:	610d                	addi	sp,sp,160
    80004d60:	8082                	ret
    end_op();
    80004d62:	ffffe097          	auipc	ra,0xffffe
    80004d66:	7ce080e7          	jalr	1998(ra) # 80003530 <end_op>
    return -1;
    80004d6a:	557d                	li	a0,-1
    80004d6c:	b7fd                	j	80004d5a <sys_mknod+0x6c>

0000000080004d6e <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d6e:	7135                	addi	sp,sp,-160
    80004d70:	ed06                	sd	ra,152(sp)
    80004d72:	e922                	sd	s0,144(sp)
    80004d74:	e526                	sd	s1,136(sp)
    80004d76:	e14a                	sd	s2,128(sp)
    80004d78:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d7a:	ffffc097          	auipc	ra,0xffffc
    80004d7e:	0c4080e7          	jalr	196(ra) # 80000e3e <myproc>
    80004d82:	892a                	mv	s2,a0
  
  begin_op();
    80004d84:	ffffe097          	auipc	ra,0xffffe
    80004d88:	72c080e7          	jalr	1836(ra) # 800034b0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d8c:	08000613          	li	a2,128
    80004d90:	f6040593          	addi	a1,s0,-160
    80004d94:	4501                	li	a0,0
    80004d96:	ffffd097          	auipc	ra,0xffffd
    80004d9a:	21e080e7          	jalr	542(ra) # 80001fb4 <argstr>
    80004d9e:	04054b63          	bltz	a0,80004df4 <sys_chdir+0x86>
    80004da2:	f6040513          	addi	a0,s0,-160
    80004da6:	ffffe097          	auipc	ra,0xffffe
    80004daa:	4ee080e7          	jalr	1262(ra) # 80003294 <namei>
    80004dae:	84aa                	mv	s1,a0
    80004db0:	c131                	beqz	a0,80004df4 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004db2:	ffffe097          	auipc	ra,0xffffe
    80004db6:	d3c080e7          	jalr	-708(ra) # 80002aee <ilock>
  if(ip->type != T_DIR){
    80004dba:	04449703          	lh	a4,68(s1)
    80004dbe:	4785                	li	a5,1
    80004dc0:	04f71063          	bne	a4,a5,80004e00 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004dc4:	8526                	mv	a0,s1
    80004dc6:	ffffe097          	auipc	ra,0xffffe
    80004dca:	dea080e7          	jalr	-534(ra) # 80002bb0 <iunlock>
  iput(p->cwd);
    80004dce:	15093503          	ld	a0,336(s2)
    80004dd2:	ffffe097          	auipc	ra,0xffffe
    80004dd6:	ed6080e7          	jalr	-298(ra) # 80002ca8 <iput>
  end_op();
    80004dda:	ffffe097          	auipc	ra,0xffffe
    80004dde:	756080e7          	jalr	1878(ra) # 80003530 <end_op>
  p->cwd = ip;
    80004de2:	14993823          	sd	s1,336(s2)
  return 0;
    80004de6:	4501                	li	a0,0
}
    80004de8:	60ea                	ld	ra,152(sp)
    80004dea:	644a                	ld	s0,144(sp)
    80004dec:	64aa                	ld	s1,136(sp)
    80004dee:	690a                	ld	s2,128(sp)
    80004df0:	610d                	addi	sp,sp,160
    80004df2:	8082                	ret
    end_op();
    80004df4:	ffffe097          	auipc	ra,0xffffe
    80004df8:	73c080e7          	jalr	1852(ra) # 80003530 <end_op>
    return -1;
    80004dfc:	557d                	li	a0,-1
    80004dfe:	b7ed                	j	80004de8 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e00:	8526                	mv	a0,s1
    80004e02:	ffffe097          	auipc	ra,0xffffe
    80004e06:	f4e080e7          	jalr	-178(ra) # 80002d50 <iunlockput>
    end_op();
    80004e0a:	ffffe097          	auipc	ra,0xffffe
    80004e0e:	726080e7          	jalr	1830(ra) # 80003530 <end_op>
    return -1;
    80004e12:	557d                	li	a0,-1
    80004e14:	bfd1                	j	80004de8 <sys_chdir+0x7a>

0000000080004e16 <sys_exec>:

uint64
sys_exec(void)
{
    80004e16:	7145                	addi	sp,sp,-464
    80004e18:	e786                	sd	ra,456(sp)
    80004e1a:	e3a2                	sd	s0,448(sp)
    80004e1c:	ff26                	sd	s1,440(sp)
    80004e1e:	fb4a                	sd	s2,432(sp)
    80004e20:	f74e                	sd	s3,424(sp)
    80004e22:	f352                	sd	s4,416(sp)
    80004e24:	ef56                	sd	s5,408(sp)
    80004e26:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e28:	e3840593          	addi	a1,s0,-456
    80004e2c:	4505                	li	a0,1
    80004e2e:	ffffd097          	auipc	ra,0xffffd
    80004e32:	166080e7          	jalr	358(ra) # 80001f94 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004e36:	08000613          	li	a2,128
    80004e3a:	f4040593          	addi	a1,s0,-192
    80004e3e:	4501                	li	a0,0
    80004e40:	ffffd097          	auipc	ra,0xffffd
    80004e44:	174080e7          	jalr	372(ra) # 80001fb4 <argstr>
    80004e48:	87aa                	mv	a5,a0
    return -1;
    80004e4a:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004e4c:	0c07c263          	bltz	a5,80004f10 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e50:	10000613          	li	a2,256
    80004e54:	4581                	li	a1,0
    80004e56:	e4040513          	addi	a0,s0,-448
    80004e5a:	ffffb097          	auipc	ra,0xffffb
    80004e5e:	31e080e7          	jalr	798(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e62:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e66:	89a6                	mv	s3,s1
    80004e68:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e6a:	02000a13          	li	s4,32
    80004e6e:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e72:	00391513          	slli	a0,s2,0x3
    80004e76:	e3040593          	addi	a1,s0,-464
    80004e7a:	e3843783          	ld	a5,-456(s0)
    80004e7e:	953e                	add	a0,a0,a5
    80004e80:	ffffd097          	auipc	ra,0xffffd
    80004e84:	056080e7          	jalr	86(ra) # 80001ed6 <fetchaddr>
    80004e88:	02054a63          	bltz	a0,80004ebc <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004e8c:	e3043783          	ld	a5,-464(s0)
    80004e90:	c3b9                	beqz	a5,80004ed6 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e92:	ffffb097          	auipc	ra,0xffffb
    80004e96:	286080e7          	jalr	646(ra) # 80000118 <kalloc>
    80004e9a:	85aa                	mv	a1,a0
    80004e9c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ea0:	cd11                	beqz	a0,80004ebc <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ea2:	6605                	lui	a2,0x1
    80004ea4:	e3043503          	ld	a0,-464(s0)
    80004ea8:	ffffd097          	auipc	ra,0xffffd
    80004eac:	080080e7          	jalr	128(ra) # 80001f28 <fetchstr>
    80004eb0:	00054663          	bltz	a0,80004ebc <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004eb4:	0905                	addi	s2,s2,1
    80004eb6:	09a1                	addi	s3,s3,8
    80004eb8:	fb491be3          	bne	s2,s4,80004e6e <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ebc:	10048913          	addi	s2,s1,256
    80004ec0:	6088                	ld	a0,0(s1)
    80004ec2:	c531                	beqz	a0,80004f0e <sys_exec+0xf8>
    kfree(argv[i]);
    80004ec4:	ffffb097          	auipc	ra,0xffffb
    80004ec8:	158080e7          	jalr	344(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ecc:	04a1                	addi	s1,s1,8
    80004ece:	ff2499e3          	bne	s1,s2,80004ec0 <sys_exec+0xaa>
  return -1;
    80004ed2:	557d                	li	a0,-1
    80004ed4:	a835                	j	80004f10 <sys_exec+0xfa>
      argv[i] = 0;
    80004ed6:	0a8e                	slli	s5,s5,0x3
    80004ed8:	fc040793          	addi	a5,s0,-64
    80004edc:	9abe                	add	s5,s5,a5
    80004ede:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004ee2:	e4040593          	addi	a1,s0,-448
    80004ee6:	f4040513          	addi	a0,s0,-192
    80004eea:	fffff097          	auipc	ra,0xfffff
    80004eee:	174080e7          	jalr	372(ra) # 8000405e <exec>
    80004ef2:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ef4:	10048993          	addi	s3,s1,256
    80004ef8:	6088                	ld	a0,0(s1)
    80004efa:	c901                	beqz	a0,80004f0a <sys_exec+0xf4>
    kfree(argv[i]);
    80004efc:	ffffb097          	auipc	ra,0xffffb
    80004f00:	120080e7          	jalr	288(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f04:	04a1                	addi	s1,s1,8
    80004f06:	ff3499e3          	bne	s1,s3,80004ef8 <sys_exec+0xe2>
  return ret;
    80004f0a:	854a                	mv	a0,s2
    80004f0c:	a011                	j	80004f10 <sys_exec+0xfa>
  return -1;
    80004f0e:	557d                	li	a0,-1
}
    80004f10:	60be                	ld	ra,456(sp)
    80004f12:	641e                	ld	s0,448(sp)
    80004f14:	74fa                	ld	s1,440(sp)
    80004f16:	795a                	ld	s2,432(sp)
    80004f18:	79ba                	ld	s3,424(sp)
    80004f1a:	7a1a                	ld	s4,416(sp)
    80004f1c:	6afa                	ld	s5,408(sp)
    80004f1e:	6179                	addi	sp,sp,464
    80004f20:	8082                	ret

0000000080004f22 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f22:	7139                	addi	sp,sp,-64
    80004f24:	fc06                	sd	ra,56(sp)
    80004f26:	f822                	sd	s0,48(sp)
    80004f28:	f426                	sd	s1,40(sp)
    80004f2a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f2c:	ffffc097          	auipc	ra,0xffffc
    80004f30:	f12080e7          	jalr	-238(ra) # 80000e3e <myproc>
    80004f34:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f36:	fd840593          	addi	a1,s0,-40
    80004f3a:	4501                	li	a0,0
    80004f3c:	ffffd097          	auipc	ra,0xffffd
    80004f40:	058080e7          	jalr	88(ra) # 80001f94 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004f44:	fc840593          	addi	a1,s0,-56
    80004f48:	fd040513          	addi	a0,s0,-48
    80004f4c:	fffff097          	auipc	ra,0xfffff
    80004f50:	dba080e7          	jalr	-582(ra) # 80003d06 <pipealloc>
    return -1;
    80004f54:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f56:	0c054463          	bltz	a0,8000501e <sys_pipe+0xfc>
  fd0 = -1;
    80004f5a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f5e:	fd043503          	ld	a0,-48(s0)
    80004f62:	fffff097          	auipc	ra,0xfffff
    80004f66:	4fc080e7          	jalr	1276(ra) # 8000445e <fdalloc>
    80004f6a:	fca42223          	sw	a0,-60(s0)
    80004f6e:	08054b63          	bltz	a0,80005004 <sys_pipe+0xe2>
    80004f72:	fc843503          	ld	a0,-56(s0)
    80004f76:	fffff097          	auipc	ra,0xfffff
    80004f7a:	4e8080e7          	jalr	1256(ra) # 8000445e <fdalloc>
    80004f7e:	fca42023          	sw	a0,-64(s0)
    80004f82:	06054863          	bltz	a0,80004ff2 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f86:	4691                	li	a3,4
    80004f88:	fc440613          	addi	a2,s0,-60
    80004f8c:	fd843583          	ld	a1,-40(s0)
    80004f90:	68a8                	ld	a0,80(s1)
    80004f92:	ffffc097          	auipc	ra,0xffffc
    80004f96:	b6a080e7          	jalr	-1174(ra) # 80000afc <copyout>
    80004f9a:	02054063          	bltz	a0,80004fba <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f9e:	4691                	li	a3,4
    80004fa0:	fc040613          	addi	a2,s0,-64
    80004fa4:	fd843583          	ld	a1,-40(s0)
    80004fa8:	0591                	addi	a1,a1,4
    80004faa:	68a8                	ld	a0,80(s1)
    80004fac:	ffffc097          	auipc	ra,0xffffc
    80004fb0:	b50080e7          	jalr	-1200(ra) # 80000afc <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fb4:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fb6:	06055463          	bgez	a0,8000501e <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004fba:	fc442783          	lw	a5,-60(s0)
    80004fbe:	07e9                	addi	a5,a5,26
    80004fc0:	078e                	slli	a5,a5,0x3
    80004fc2:	97a6                	add	a5,a5,s1
    80004fc4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004fc8:	fc042503          	lw	a0,-64(s0)
    80004fcc:	0569                	addi	a0,a0,26
    80004fce:	050e                	slli	a0,a0,0x3
    80004fd0:	94aa                	add	s1,s1,a0
    80004fd2:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004fd6:	fd043503          	ld	a0,-48(s0)
    80004fda:	fffff097          	auipc	ra,0xfffff
    80004fde:	9a2080e7          	jalr	-1630(ra) # 8000397c <fileclose>
    fileclose(wf);
    80004fe2:	fc843503          	ld	a0,-56(s0)
    80004fe6:	fffff097          	auipc	ra,0xfffff
    80004fea:	996080e7          	jalr	-1642(ra) # 8000397c <fileclose>
    return -1;
    80004fee:	57fd                	li	a5,-1
    80004ff0:	a03d                	j	8000501e <sys_pipe+0xfc>
    if(fd0 >= 0)
    80004ff2:	fc442783          	lw	a5,-60(s0)
    80004ff6:	0007c763          	bltz	a5,80005004 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80004ffa:	07e9                	addi	a5,a5,26
    80004ffc:	078e                	slli	a5,a5,0x3
    80004ffe:	94be                	add	s1,s1,a5
    80005000:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005004:	fd043503          	ld	a0,-48(s0)
    80005008:	fffff097          	auipc	ra,0xfffff
    8000500c:	974080e7          	jalr	-1676(ra) # 8000397c <fileclose>
    fileclose(wf);
    80005010:	fc843503          	ld	a0,-56(s0)
    80005014:	fffff097          	auipc	ra,0xfffff
    80005018:	968080e7          	jalr	-1688(ra) # 8000397c <fileclose>
    return -1;
    8000501c:	57fd                	li	a5,-1
}
    8000501e:	853e                	mv	a0,a5
    80005020:	70e2                	ld	ra,56(sp)
    80005022:	7442                	ld	s0,48(sp)
    80005024:	74a2                	ld	s1,40(sp)
    80005026:	6121                	addi	sp,sp,64
    80005028:	8082                	ret
    8000502a:	0000                	unimp
    8000502c:	0000                	unimp
	...

0000000080005030 <kernelvec>:
    80005030:	7111                	addi	sp,sp,-256
    80005032:	e006                	sd	ra,0(sp)
    80005034:	e40a                	sd	sp,8(sp)
    80005036:	e80e                	sd	gp,16(sp)
    80005038:	ec12                	sd	tp,24(sp)
    8000503a:	f016                	sd	t0,32(sp)
    8000503c:	f41a                	sd	t1,40(sp)
    8000503e:	f81e                	sd	t2,48(sp)
    80005040:	fc22                	sd	s0,56(sp)
    80005042:	e0a6                	sd	s1,64(sp)
    80005044:	e4aa                	sd	a0,72(sp)
    80005046:	e8ae                	sd	a1,80(sp)
    80005048:	ecb2                	sd	a2,88(sp)
    8000504a:	f0b6                	sd	a3,96(sp)
    8000504c:	f4ba                	sd	a4,104(sp)
    8000504e:	f8be                	sd	a5,112(sp)
    80005050:	fcc2                	sd	a6,120(sp)
    80005052:	e146                	sd	a7,128(sp)
    80005054:	e54a                	sd	s2,136(sp)
    80005056:	e94e                	sd	s3,144(sp)
    80005058:	ed52                	sd	s4,152(sp)
    8000505a:	f156                	sd	s5,160(sp)
    8000505c:	f55a                	sd	s6,168(sp)
    8000505e:	f95e                	sd	s7,176(sp)
    80005060:	fd62                	sd	s8,184(sp)
    80005062:	e1e6                	sd	s9,192(sp)
    80005064:	e5ea                	sd	s10,200(sp)
    80005066:	e9ee                	sd	s11,208(sp)
    80005068:	edf2                	sd	t3,216(sp)
    8000506a:	f1f6                	sd	t4,224(sp)
    8000506c:	f5fa                	sd	t5,232(sp)
    8000506e:	f9fe                	sd	t6,240(sp)
    80005070:	d33fc0ef          	jal	ra,80001da2 <kerneltrap>
    80005074:	6082                	ld	ra,0(sp)
    80005076:	6122                	ld	sp,8(sp)
    80005078:	61c2                	ld	gp,16(sp)
    8000507a:	7282                	ld	t0,32(sp)
    8000507c:	7322                	ld	t1,40(sp)
    8000507e:	73c2                	ld	t2,48(sp)
    80005080:	7462                	ld	s0,56(sp)
    80005082:	6486                	ld	s1,64(sp)
    80005084:	6526                	ld	a0,72(sp)
    80005086:	65c6                	ld	a1,80(sp)
    80005088:	6666                	ld	a2,88(sp)
    8000508a:	7686                	ld	a3,96(sp)
    8000508c:	7726                	ld	a4,104(sp)
    8000508e:	77c6                	ld	a5,112(sp)
    80005090:	7866                	ld	a6,120(sp)
    80005092:	688a                	ld	a7,128(sp)
    80005094:	692a                	ld	s2,136(sp)
    80005096:	69ca                	ld	s3,144(sp)
    80005098:	6a6a                	ld	s4,152(sp)
    8000509a:	7a8a                	ld	s5,160(sp)
    8000509c:	7b2a                	ld	s6,168(sp)
    8000509e:	7bca                	ld	s7,176(sp)
    800050a0:	7c6a                	ld	s8,184(sp)
    800050a2:	6c8e                	ld	s9,192(sp)
    800050a4:	6d2e                	ld	s10,200(sp)
    800050a6:	6dce                	ld	s11,208(sp)
    800050a8:	6e6e                	ld	t3,216(sp)
    800050aa:	7e8e                	ld	t4,224(sp)
    800050ac:	7f2e                	ld	t5,232(sp)
    800050ae:	7fce                	ld	t6,240(sp)
    800050b0:	6111                	addi	sp,sp,256
    800050b2:	10200073          	sret
    800050b6:	00000013          	nop
    800050ba:	00000013          	nop
    800050be:	0001                	nop

00000000800050c0 <timervec>:
    800050c0:	34051573          	csrrw	a0,mscratch,a0
    800050c4:	e10c                	sd	a1,0(a0)
    800050c6:	e510                	sd	a2,8(a0)
    800050c8:	e914                	sd	a3,16(a0)
    800050ca:	6d0c                	ld	a1,24(a0)
    800050cc:	7110                	ld	a2,32(a0)
    800050ce:	6194                	ld	a3,0(a1)
    800050d0:	96b2                	add	a3,a3,a2
    800050d2:	e194                	sd	a3,0(a1)
    800050d4:	4589                	li	a1,2
    800050d6:	14459073          	csrw	sip,a1
    800050da:	6914                	ld	a3,16(a0)
    800050dc:	6510                	ld	a2,8(a0)
    800050de:	610c                	ld	a1,0(a0)
    800050e0:	34051573          	csrrw	a0,mscratch,a0
    800050e4:	30200073          	mret
	...

00000000800050ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800050ea:	1141                	addi	sp,sp,-16
    800050ec:	e422                	sd	s0,8(sp)
    800050ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800050f0:	0c0007b7          	lui	a5,0xc000
    800050f4:	4705                	li	a4,1
    800050f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800050f8:	c3d8                	sw	a4,4(a5)
}
    800050fa:	6422                	ld	s0,8(sp)
    800050fc:	0141                	addi	sp,sp,16
    800050fe:	8082                	ret

0000000080005100 <plicinithart>:

void
plicinithart(void)
{
    80005100:	1141                	addi	sp,sp,-16
    80005102:	e406                	sd	ra,8(sp)
    80005104:	e022                	sd	s0,0(sp)
    80005106:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005108:	ffffc097          	auipc	ra,0xffffc
    8000510c:	d0a080e7          	jalr	-758(ra) # 80000e12 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005110:	0085171b          	slliw	a4,a0,0x8
    80005114:	0c0027b7          	lui	a5,0xc002
    80005118:	97ba                	add	a5,a5,a4
    8000511a:	40200713          	li	a4,1026
    8000511e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005122:	00d5151b          	slliw	a0,a0,0xd
    80005126:	0c2017b7          	lui	a5,0xc201
    8000512a:	953e                	add	a0,a0,a5
    8000512c:	00052023          	sw	zero,0(a0)
}
    80005130:	60a2                	ld	ra,8(sp)
    80005132:	6402                	ld	s0,0(sp)
    80005134:	0141                	addi	sp,sp,16
    80005136:	8082                	ret

0000000080005138 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005138:	1141                	addi	sp,sp,-16
    8000513a:	e406                	sd	ra,8(sp)
    8000513c:	e022                	sd	s0,0(sp)
    8000513e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005140:	ffffc097          	auipc	ra,0xffffc
    80005144:	cd2080e7          	jalr	-814(ra) # 80000e12 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005148:	00d5179b          	slliw	a5,a0,0xd
    8000514c:	0c201537          	lui	a0,0xc201
    80005150:	953e                	add	a0,a0,a5
  return irq;
}
    80005152:	4148                	lw	a0,4(a0)
    80005154:	60a2                	ld	ra,8(sp)
    80005156:	6402                	ld	s0,0(sp)
    80005158:	0141                	addi	sp,sp,16
    8000515a:	8082                	ret

000000008000515c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000515c:	1101                	addi	sp,sp,-32
    8000515e:	ec06                	sd	ra,24(sp)
    80005160:	e822                	sd	s0,16(sp)
    80005162:	e426                	sd	s1,8(sp)
    80005164:	1000                	addi	s0,sp,32
    80005166:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	caa080e7          	jalr	-854(ra) # 80000e12 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005170:	00d5151b          	slliw	a0,a0,0xd
    80005174:	0c2017b7          	lui	a5,0xc201
    80005178:	97aa                	add	a5,a5,a0
    8000517a:	c3c4                	sw	s1,4(a5)
}
    8000517c:	60e2                	ld	ra,24(sp)
    8000517e:	6442                	ld	s0,16(sp)
    80005180:	64a2                	ld	s1,8(sp)
    80005182:	6105                	addi	sp,sp,32
    80005184:	8082                	ret

0000000080005186 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005186:	1141                	addi	sp,sp,-16
    80005188:	e406                	sd	ra,8(sp)
    8000518a:	e022                	sd	s0,0(sp)
    8000518c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000518e:	479d                	li	a5,7
    80005190:	04a7cc63          	blt	a5,a0,800051e8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005194:	00015797          	auipc	a5,0x15
    80005198:	84c78793          	addi	a5,a5,-1972 # 800199e0 <disk>
    8000519c:	97aa                	add	a5,a5,a0
    8000519e:	0187c783          	lbu	a5,24(a5)
    800051a2:	ebb9                	bnez	a5,800051f8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051a4:	00451613          	slli	a2,a0,0x4
    800051a8:	00015797          	auipc	a5,0x15
    800051ac:	83878793          	addi	a5,a5,-1992 # 800199e0 <disk>
    800051b0:	6394                	ld	a3,0(a5)
    800051b2:	96b2                	add	a3,a3,a2
    800051b4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051b8:	6398                	ld	a4,0(a5)
    800051ba:	9732                	add	a4,a4,a2
    800051bc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800051c0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800051c4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800051c8:	953e                	add	a0,a0,a5
    800051ca:	4785                	li	a5,1
    800051cc:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800051d0:	00015517          	auipc	a0,0x15
    800051d4:	82850513          	addi	a0,a0,-2008 # 800199f8 <disk+0x18>
    800051d8:	ffffc097          	auipc	ra,0xffffc
    800051dc:	36e080e7          	jalr	878(ra) # 80001546 <wakeup>
}
    800051e0:	60a2                	ld	ra,8(sp)
    800051e2:	6402                	ld	s0,0(sp)
    800051e4:	0141                	addi	sp,sp,16
    800051e6:	8082                	ret
    panic("free_desc 1");
    800051e8:	00003517          	auipc	a0,0x3
    800051ec:	4e050513          	addi	a0,a0,1248 # 800086c8 <syscalls+0x308>
    800051f0:	00001097          	auipc	ra,0x1
    800051f4:	a72080e7          	jalr	-1422(ra) # 80005c62 <panic>
    panic("free_desc 2");
    800051f8:	00003517          	auipc	a0,0x3
    800051fc:	4e050513          	addi	a0,a0,1248 # 800086d8 <syscalls+0x318>
    80005200:	00001097          	auipc	ra,0x1
    80005204:	a62080e7          	jalr	-1438(ra) # 80005c62 <panic>

0000000080005208 <virtio_disk_init>:
{
    80005208:	1101                	addi	sp,sp,-32
    8000520a:	ec06                	sd	ra,24(sp)
    8000520c:	e822                	sd	s0,16(sp)
    8000520e:	e426                	sd	s1,8(sp)
    80005210:	e04a                	sd	s2,0(sp)
    80005212:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005214:	00003597          	auipc	a1,0x3
    80005218:	4d458593          	addi	a1,a1,1236 # 800086e8 <syscalls+0x328>
    8000521c:	00015517          	auipc	a0,0x15
    80005220:	8ec50513          	addi	a0,a0,-1812 # 80019b08 <disk+0x128>
    80005224:	00001097          	auipc	ra,0x1
    80005228:	ef8080e7          	jalr	-264(ra) # 8000611c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000522c:	100017b7          	lui	a5,0x10001
    80005230:	4398                	lw	a4,0(a5)
    80005232:	2701                	sext.w	a4,a4
    80005234:	747277b7          	lui	a5,0x74727
    80005238:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000523c:	14f71e63          	bne	a4,a5,80005398 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005240:	100017b7          	lui	a5,0x10001
    80005244:	43dc                	lw	a5,4(a5)
    80005246:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005248:	4709                	li	a4,2
    8000524a:	14e79763          	bne	a5,a4,80005398 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000524e:	100017b7          	lui	a5,0x10001
    80005252:	479c                	lw	a5,8(a5)
    80005254:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005256:	14e79163          	bne	a5,a4,80005398 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000525a:	100017b7          	lui	a5,0x10001
    8000525e:	47d8                	lw	a4,12(a5)
    80005260:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005262:	554d47b7          	lui	a5,0x554d4
    80005266:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000526a:	12f71763          	bne	a4,a5,80005398 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000526e:	100017b7          	lui	a5,0x10001
    80005272:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005276:	4705                	li	a4,1
    80005278:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000527a:	470d                	li	a4,3
    8000527c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000527e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005280:	c7ffe737          	lui	a4,0xc7ffe
    80005284:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc9ff>
    80005288:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000528a:	2701                	sext.w	a4,a4
    8000528c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000528e:	472d                	li	a4,11
    80005290:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005292:	0707a903          	lw	s2,112(a5)
    80005296:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005298:	00897793          	andi	a5,s2,8
    8000529c:	10078663          	beqz	a5,800053a8 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052a0:	100017b7          	lui	a5,0x10001
    800052a4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800052a8:	43fc                	lw	a5,68(a5)
    800052aa:	2781                	sext.w	a5,a5
    800052ac:	10079663          	bnez	a5,800053b8 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052b0:	100017b7          	lui	a5,0x10001
    800052b4:	5bdc                	lw	a5,52(a5)
    800052b6:	2781                	sext.w	a5,a5
  if(max == 0)
    800052b8:	10078863          	beqz	a5,800053c8 <virtio_disk_init+0x1c0>
  if(max < NUM)
    800052bc:	471d                	li	a4,7
    800052be:	10f77d63          	bgeu	a4,a5,800053d8 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    800052c2:	ffffb097          	auipc	ra,0xffffb
    800052c6:	e56080e7          	jalr	-426(ra) # 80000118 <kalloc>
    800052ca:	00014497          	auipc	s1,0x14
    800052ce:	71648493          	addi	s1,s1,1814 # 800199e0 <disk>
    800052d2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800052d4:	ffffb097          	auipc	ra,0xffffb
    800052d8:	e44080e7          	jalr	-444(ra) # 80000118 <kalloc>
    800052dc:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800052de:	ffffb097          	auipc	ra,0xffffb
    800052e2:	e3a080e7          	jalr	-454(ra) # 80000118 <kalloc>
    800052e6:	87aa                	mv	a5,a0
    800052e8:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800052ea:	6088                	ld	a0,0(s1)
    800052ec:	cd75                	beqz	a0,800053e8 <virtio_disk_init+0x1e0>
    800052ee:	00014717          	auipc	a4,0x14
    800052f2:	6fa73703          	ld	a4,1786(a4) # 800199e8 <disk+0x8>
    800052f6:	cb6d                	beqz	a4,800053e8 <virtio_disk_init+0x1e0>
    800052f8:	cbe5                	beqz	a5,800053e8 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    800052fa:	6605                	lui	a2,0x1
    800052fc:	4581                	li	a1,0
    800052fe:	ffffb097          	auipc	ra,0xffffb
    80005302:	e7a080e7          	jalr	-390(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005306:	00014497          	auipc	s1,0x14
    8000530a:	6da48493          	addi	s1,s1,1754 # 800199e0 <disk>
    8000530e:	6605                	lui	a2,0x1
    80005310:	4581                	li	a1,0
    80005312:	6488                	ld	a0,8(s1)
    80005314:	ffffb097          	auipc	ra,0xffffb
    80005318:	e64080e7          	jalr	-412(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000531c:	6605                	lui	a2,0x1
    8000531e:	4581                	li	a1,0
    80005320:	6888                	ld	a0,16(s1)
    80005322:	ffffb097          	auipc	ra,0xffffb
    80005326:	e56080e7          	jalr	-426(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000532a:	100017b7          	lui	a5,0x10001
    8000532e:	4721                	li	a4,8
    80005330:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005332:	4098                	lw	a4,0(s1)
    80005334:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005338:	40d8                	lw	a4,4(s1)
    8000533a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000533e:	6498                	ld	a4,8(s1)
    80005340:	0007069b          	sext.w	a3,a4
    80005344:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005348:	9701                	srai	a4,a4,0x20
    8000534a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000534e:	6898                	ld	a4,16(s1)
    80005350:	0007069b          	sext.w	a3,a4
    80005354:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005358:	9701                	srai	a4,a4,0x20
    8000535a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000535e:	4685                	li	a3,1
    80005360:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80005362:	4705                	li	a4,1
    80005364:	00d48c23          	sb	a3,24(s1)
    80005368:	00e48ca3          	sb	a4,25(s1)
    8000536c:	00e48d23          	sb	a4,26(s1)
    80005370:	00e48da3          	sb	a4,27(s1)
    80005374:	00e48e23          	sb	a4,28(s1)
    80005378:	00e48ea3          	sb	a4,29(s1)
    8000537c:	00e48f23          	sb	a4,30(s1)
    80005380:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005384:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005388:	0727a823          	sw	s2,112(a5)
}
    8000538c:	60e2                	ld	ra,24(sp)
    8000538e:	6442                	ld	s0,16(sp)
    80005390:	64a2                	ld	s1,8(sp)
    80005392:	6902                	ld	s2,0(sp)
    80005394:	6105                	addi	sp,sp,32
    80005396:	8082                	ret
    panic("could not find virtio disk");
    80005398:	00003517          	auipc	a0,0x3
    8000539c:	36050513          	addi	a0,a0,864 # 800086f8 <syscalls+0x338>
    800053a0:	00001097          	auipc	ra,0x1
    800053a4:	8c2080e7          	jalr	-1854(ra) # 80005c62 <panic>
    panic("virtio disk FEATURES_OK unset");
    800053a8:	00003517          	auipc	a0,0x3
    800053ac:	37050513          	addi	a0,a0,880 # 80008718 <syscalls+0x358>
    800053b0:	00001097          	auipc	ra,0x1
    800053b4:	8b2080e7          	jalr	-1870(ra) # 80005c62 <panic>
    panic("virtio disk should not be ready");
    800053b8:	00003517          	auipc	a0,0x3
    800053bc:	38050513          	addi	a0,a0,896 # 80008738 <syscalls+0x378>
    800053c0:	00001097          	auipc	ra,0x1
    800053c4:	8a2080e7          	jalr	-1886(ra) # 80005c62 <panic>
    panic("virtio disk has no queue 0");
    800053c8:	00003517          	auipc	a0,0x3
    800053cc:	39050513          	addi	a0,a0,912 # 80008758 <syscalls+0x398>
    800053d0:	00001097          	auipc	ra,0x1
    800053d4:	892080e7          	jalr	-1902(ra) # 80005c62 <panic>
    panic("virtio disk max queue too short");
    800053d8:	00003517          	auipc	a0,0x3
    800053dc:	3a050513          	addi	a0,a0,928 # 80008778 <syscalls+0x3b8>
    800053e0:	00001097          	auipc	ra,0x1
    800053e4:	882080e7          	jalr	-1918(ra) # 80005c62 <panic>
    panic("virtio disk kalloc");
    800053e8:	00003517          	auipc	a0,0x3
    800053ec:	3b050513          	addi	a0,a0,944 # 80008798 <syscalls+0x3d8>
    800053f0:	00001097          	auipc	ra,0x1
    800053f4:	872080e7          	jalr	-1934(ra) # 80005c62 <panic>

00000000800053f8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053f8:	7159                	addi	sp,sp,-112
    800053fa:	f486                	sd	ra,104(sp)
    800053fc:	f0a2                	sd	s0,96(sp)
    800053fe:	eca6                	sd	s1,88(sp)
    80005400:	e8ca                	sd	s2,80(sp)
    80005402:	e4ce                	sd	s3,72(sp)
    80005404:	e0d2                	sd	s4,64(sp)
    80005406:	fc56                	sd	s5,56(sp)
    80005408:	f85a                	sd	s6,48(sp)
    8000540a:	f45e                	sd	s7,40(sp)
    8000540c:	f062                	sd	s8,32(sp)
    8000540e:	ec66                	sd	s9,24(sp)
    80005410:	e86a                	sd	s10,16(sp)
    80005412:	1880                	addi	s0,sp,112
    80005414:	892a                	mv	s2,a0
    80005416:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005418:	00c52c83          	lw	s9,12(a0)
    8000541c:	001c9c9b          	slliw	s9,s9,0x1
    80005420:	1c82                	slli	s9,s9,0x20
    80005422:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005426:	00014517          	auipc	a0,0x14
    8000542a:	6e250513          	addi	a0,a0,1762 # 80019b08 <disk+0x128>
    8000542e:	00001097          	auipc	ra,0x1
    80005432:	d7e080e7          	jalr	-642(ra) # 800061ac <acquire>
  for(int i = 0; i < 3; i++){
    80005436:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005438:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000543a:	00014b17          	auipc	s6,0x14
    8000543e:	5a6b0b13          	addi	s6,s6,1446 # 800199e0 <disk>
  for(int i = 0; i < 3; i++){
    80005442:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005444:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005446:	00014c17          	auipc	s8,0x14
    8000544a:	6c2c0c13          	addi	s8,s8,1730 # 80019b08 <disk+0x128>
    8000544e:	a8b5                	j	800054ca <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80005450:	00fb06b3          	add	a3,s6,a5
    80005454:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005458:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000545a:	0207c563          	bltz	a5,80005484 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000545e:	2485                	addiw	s1,s1,1
    80005460:	0711                	addi	a4,a4,4
    80005462:	1f548a63          	beq	s1,s5,80005656 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    80005466:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005468:	00014697          	auipc	a3,0x14
    8000546c:	57868693          	addi	a3,a3,1400 # 800199e0 <disk>
    80005470:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005472:	0186c583          	lbu	a1,24(a3)
    80005476:	fde9                	bnez	a1,80005450 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005478:	2785                	addiw	a5,a5,1
    8000547a:	0685                	addi	a3,a3,1
    8000547c:	ff779be3          	bne	a5,s7,80005472 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80005480:	57fd                	li	a5,-1
    80005482:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005484:	02905a63          	blez	s1,800054b8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80005488:	f9042503          	lw	a0,-112(s0)
    8000548c:	00000097          	auipc	ra,0x0
    80005490:	cfa080e7          	jalr	-774(ra) # 80005186 <free_desc>
      for(int j = 0; j < i; j++)
    80005494:	4785                	li	a5,1
    80005496:	0297d163          	bge	a5,s1,800054b8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000549a:	f9442503          	lw	a0,-108(s0)
    8000549e:	00000097          	auipc	ra,0x0
    800054a2:	ce8080e7          	jalr	-792(ra) # 80005186 <free_desc>
      for(int j = 0; j < i; j++)
    800054a6:	4789                	li	a5,2
    800054a8:	0097d863          	bge	a5,s1,800054b8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800054ac:	f9842503          	lw	a0,-104(s0)
    800054b0:	00000097          	auipc	ra,0x0
    800054b4:	cd6080e7          	jalr	-810(ra) # 80005186 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054b8:	85e2                	mv	a1,s8
    800054ba:	00014517          	auipc	a0,0x14
    800054be:	53e50513          	addi	a0,a0,1342 # 800199f8 <disk+0x18>
    800054c2:	ffffc097          	auipc	ra,0xffffc
    800054c6:	020080e7          	jalr	32(ra) # 800014e2 <sleep>
  for(int i = 0; i < 3; i++){
    800054ca:	f9040713          	addi	a4,s0,-112
    800054ce:	84ce                	mv	s1,s3
    800054d0:	bf59                	j	80005466 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800054d2:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    800054d6:	00479693          	slli	a3,a5,0x4
    800054da:	00014797          	auipc	a5,0x14
    800054de:	50678793          	addi	a5,a5,1286 # 800199e0 <disk>
    800054e2:	97b6                	add	a5,a5,a3
    800054e4:	4685                	li	a3,1
    800054e6:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054e8:	00014597          	auipc	a1,0x14
    800054ec:	4f858593          	addi	a1,a1,1272 # 800199e0 <disk>
    800054f0:	00a60793          	addi	a5,a2,10
    800054f4:	0792                	slli	a5,a5,0x4
    800054f6:	97ae                	add	a5,a5,a1
    800054f8:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    800054fc:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005500:	f6070693          	addi	a3,a4,-160
    80005504:	619c                	ld	a5,0(a1)
    80005506:	97b6                	add	a5,a5,a3
    80005508:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000550a:	6188                	ld	a0,0(a1)
    8000550c:	96aa                	add	a3,a3,a0
    8000550e:	47c1                	li	a5,16
    80005510:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005512:	4785                	li	a5,1
    80005514:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005518:	f9442783          	lw	a5,-108(s0)
    8000551c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005520:	0792                	slli	a5,a5,0x4
    80005522:	953e                	add	a0,a0,a5
    80005524:	05890693          	addi	a3,s2,88
    80005528:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000552a:	6188                	ld	a0,0(a1)
    8000552c:	97aa                	add	a5,a5,a0
    8000552e:	40000693          	li	a3,1024
    80005532:	c794                	sw	a3,8(a5)
  if(write)
    80005534:	100d0d63          	beqz	s10,8000564e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005538:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000553c:	00c7d683          	lhu	a3,12(a5)
    80005540:	0016e693          	ori	a3,a3,1
    80005544:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005548:	f9842583          	lw	a1,-104(s0)
    8000554c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005550:	00014697          	auipc	a3,0x14
    80005554:	49068693          	addi	a3,a3,1168 # 800199e0 <disk>
    80005558:	00260793          	addi	a5,a2,2
    8000555c:	0792                	slli	a5,a5,0x4
    8000555e:	97b6                	add	a5,a5,a3
    80005560:	587d                	li	a6,-1
    80005562:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005566:	0592                	slli	a1,a1,0x4
    80005568:	952e                	add	a0,a0,a1
    8000556a:	f9070713          	addi	a4,a4,-112
    8000556e:	9736                	add	a4,a4,a3
    80005570:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80005572:	6298                	ld	a4,0(a3)
    80005574:	972e                	add	a4,a4,a1
    80005576:	4585                	li	a1,1
    80005578:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000557a:	4509                	li	a0,2
    8000557c:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80005580:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005584:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005588:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000558c:	6698                	ld	a4,8(a3)
    8000558e:	00275783          	lhu	a5,2(a4)
    80005592:	8b9d                	andi	a5,a5,7
    80005594:	0786                	slli	a5,a5,0x1
    80005596:	97ba                	add	a5,a5,a4
    80005598:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    8000559c:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055a0:	6698                	ld	a4,8(a3)
    800055a2:	00275783          	lhu	a5,2(a4)
    800055a6:	2785                	addiw	a5,a5,1
    800055a8:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055ac:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055b0:	100017b7          	lui	a5,0x10001
    800055b4:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055b8:	00492703          	lw	a4,4(s2)
    800055bc:	4785                	li	a5,1
    800055be:	02f71163          	bne	a4,a5,800055e0 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    800055c2:	00014997          	auipc	s3,0x14
    800055c6:	54698993          	addi	s3,s3,1350 # 80019b08 <disk+0x128>
  while(b->disk == 1) {
    800055ca:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800055cc:	85ce                	mv	a1,s3
    800055ce:	854a                	mv	a0,s2
    800055d0:	ffffc097          	auipc	ra,0xffffc
    800055d4:	f12080e7          	jalr	-238(ra) # 800014e2 <sleep>
  while(b->disk == 1) {
    800055d8:	00492783          	lw	a5,4(s2)
    800055dc:	fe9788e3          	beq	a5,s1,800055cc <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    800055e0:	f9042903          	lw	s2,-112(s0)
    800055e4:	00290793          	addi	a5,s2,2
    800055e8:	00479713          	slli	a4,a5,0x4
    800055ec:	00014797          	auipc	a5,0x14
    800055f0:	3f478793          	addi	a5,a5,1012 # 800199e0 <disk>
    800055f4:	97ba                	add	a5,a5,a4
    800055f6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800055fa:	00014997          	auipc	s3,0x14
    800055fe:	3e698993          	addi	s3,s3,998 # 800199e0 <disk>
    80005602:	00491713          	slli	a4,s2,0x4
    80005606:	0009b783          	ld	a5,0(s3)
    8000560a:	97ba                	add	a5,a5,a4
    8000560c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005610:	854a                	mv	a0,s2
    80005612:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005616:	00000097          	auipc	ra,0x0
    8000561a:	b70080e7          	jalr	-1168(ra) # 80005186 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000561e:	8885                	andi	s1,s1,1
    80005620:	f0ed                	bnez	s1,80005602 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005622:	00014517          	auipc	a0,0x14
    80005626:	4e650513          	addi	a0,a0,1254 # 80019b08 <disk+0x128>
    8000562a:	00001097          	auipc	ra,0x1
    8000562e:	c36080e7          	jalr	-970(ra) # 80006260 <release>
}
    80005632:	70a6                	ld	ra,104(sp)
    80005634:	7406                	ld	s0,96(sp)
    80005636:	64e6                	ld	s1,88(sp)
    80005638:	6946                	ld	s2,80(sp)
    8000563a:	69a6                	ld	s3,72(sp)
    8000563c:	6a06                	ld	s4,64(sp)
    8000563e:	7ae2                	ld	s5,56(sp)
    80005640:	7b42                	ld	s6,48(sp)
    80005642:	7ba2                	ld	s7,40(sp)
    80005644:	7c02                	ld	s8,32(sp)
    80005646:	6ce2                	ld	s9,24(sp)
    80005648:	6d42                	ld	s10,16(sp)
    8000564a:	6165                	addi	sp,sp,112
    8000564c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000564e:	4689                	li	a3,2
    80005650:	00d79623          	sh	a3,12(a5)
    80005654:	b5e5                	j	8000553c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005656:	f9042603          	lw	a2,-112(s0)
    8000565a:	00a60713          	addi	a4,a2,10
    8000565e:	0712                	slli	a4,a4,0x4
    80005660:	00014517          	auipc	a0,0x14
    80005664:	38850513          	addi	a0,a0,904 # 800199e8 <disk+0x8>
    80005668:	953a                	add	a0,a0,a4
  if(write)
    8000566a:	e60d14e3          	bnez	s10,800054d2 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000566e:	00a60793          	addi	a5,a2,10
    80005672:	00479693          	slli	a3,a5,0x4
    80005676:	00014797          	auipc	a5,0x14
    8000567a:	36a78793          	addi	a5,a5,874 # 800199e0 <disk>
    8000567e:	97b6                	add	a5,a5,a3
    80005680:	0007a423          	sw	zero,8(a5)
    80005684:	b595                	j	800054e8 <virtio_disk_rw+0xf0>

0000000080005686 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005686:	1101                	addi	sp,sp,-32
    80005688:	ec06                	sd	ra,24(sp)
    8000568a:	e822                	sd	s0,16(sp)
    8000568c:	e426                	sd	s1,8(sp)
    8000568e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005690:	00014497          	auipc	s1,0x14
    80005694:	35048493          	addi	s1,s1,848 # 800199e0 <disk>
    80005698:	00014517          	auipc	a0,0x14
    8000569c:	47050513          	addi	a0,a0,1136 # 80019b08 <disk+0x128>
    800056a0:	00001097          	auipc	ra,0x1
    800056a4:	b0c080e7          	jalr	-1268(ra) # 800061ac <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056a8:	10001737          	lui	a4,0x10001
    800056ac:	533c                	lw	a5,96(a4)
    800056ae:	8b8d                	andi	a5,a5,3
    800056b0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056b2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056b6:	689c                	ld	a5,16(s1)
    800056b8:	0204d703          	lhu	a4,32(s1)
    800056bc:	0027d783          	lhu	a5,2(a5)
    800056c0:	04f70863          	beq	a4,a5,80005710 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800056c4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056c8:	6898                	ld	a4,16(s1)
    800056ca:	0204d783          	lhu	a5,32(s1)
    800056ce:	8b9d                	andi	a5,a5,7
    800056d0:	078e                	slli	a5,a5,0x3
    800056d2:	97ba                	add	a5,a5,a4
    800056d4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056d6:	00278713          	addi	a4,a5,2
    800056da:	0712                	slli	a4,a4,0x4
    800056dc:	9726                	add	a4,a4,s1
    800056de:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800056e2:	e721                	bnez	a4,8000572a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056e4:	0789                	addi	a5,a5,2
    800056e6:	0792                	slli	a5,a5,0x4
    800056e8:	97a6                	add	a5,a5,s1
    800056ea:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800056ec:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056f0:	ffffc097          	auipc	ra,0xffffc
    800056f4:	e56080e7          	jalr	-426(ra) # 80001546 <wakeup>

    disk.used_idx += 1;
    800056f8:	0204d783          	lhu	a5,32(s1)
    800056fc:	2785                	addiw	a5,a5,1
    800056fe:	17c2                	slli	a5,a5,0x30
    80005700:	93c1                	srli	a5,a5,0x30
    80005702:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005706:	6898                	ld	a4,16(s1)
    80005708:	00275703          	lhu	a4,2(a4)
    8000570c:	faf71ce3          	bne	a4,a5,800056c4 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005710:	00014517          	auipc	a0,0x14
    80005714:	3f850513          	addi	a0,a0,1016 # 80019b08 <disk+0x128>
    80005718:	00001097          	auipc	ra,0x1
    8000571c:	b48080e7          	jalr	-1208(ra) # 80006260 <release>
}
    80005720:	60e2                	ld	ra,24(sp)
    80005722:	6442                	ld	s0,16(sp)
    80005724:	64a2                	ld	s1,8(sp)
    80005726:	6105                	addi	sp,sp,32
    80005728:	8082                	ret
      panic("virtio_disk_intr status");
    8000572a:	00003517          	auipc	a0,0x3
    8000572e:	08650513          	addi	a0,a0,134 # 800087b0 <syscalls+0x3f0>
    80005732:	00000097          	auipc	ra,0x0
    80005736:	530080e7          	jalr	1328(ra) # 80005c62 <panic>

000000008000573a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000573a:	1141                	addi	sp,sp,-16
    8000573c:	e422                	sd	s0,8(sp)
    8000573e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005740:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005744:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005748:	0037979b          	slliw	a5,a5,0x3
    8000574c:	02004737          	lui	a4,0x2004
    80005750:	97ba                	add	a5,a5,a4
    80005752:	0200c737          	lui	a4,0x200c
    80005756:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000575a:	000f4637          	lui	a2,0xf4
    8000575e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005762:	95b2                	add	a1,a1,a2
    80005764:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005766:	00269713          	slli	a4,a3,0x2
    8000576a:	9736                	add	a4,a4,a3
    8000576c:	00371693          	slli	a3,a4,0x3
    80005770:	00014717          	auipc	a4,0x14
    80005774:	3b070713          	addi	a4,a4,944 # 80019b20 <timer_scratch>
    80005778:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000577a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000577c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000577e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005782:	00000797          	auipc	a5,0x0
    80005786:	93e78793          	addi	a5,a5,-1730 # 800050c0 <timervec>
    8000578a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000578e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005792:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005796:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000579a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000579e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057a2:	30479073          	csrw	mie,a5
}
    800057a6:	6422                	ld	s0,8(sp)
    800057a8:	0141                	addi	sp,sp,16
    800057aa:	8082                	ret

00000000800057ac <start>:
{
    800057ac:	1141                	addi	sp,sp,-16
    800057ae:	e406                	sd	ra,8(sp)
    800057b0:	e022                	sd	s0,0(sp)
    800057b2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057b4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057b8:	7779                	lui	a4,0xffffe
    800057ba:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdca9f>
    800057be:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057c0:	6705                	lui	a4,0x1
    800057c2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057c6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057c8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057cc:	ffffb797          	auipc	a5,0xffffb
    800057d0:	b5a78793          	addi	a5,a5,-1190 # 80000326 <main>
    800057d4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057d8:	4781                	li	a5,0
    800057da:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057de:	67c1                	lui	a5,0x10
    800057e0:	17fd                	addi	a5,a5,-1
    800057e2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057e6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057ea:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057ee:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057f2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057f6:	57fd                	li	a5,-1
    800057f8:	83a9                	srli	a5,a5,0xa
    800057fa:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057fe:	47bd                	li	a5,15
    80005800:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005804:	00000097          	auipc	ra,0x0
    80005808:	f36080e7          	jalr	-202(ra) # 8000573a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000580c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005810:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005812:	823e                	mv	tp,a5
  asm volatile("mret");
    80005814:	30200073          	mret
}
    80005818:	60a2                	ld	ra,8(sp)
    8000581a:	6402                	ld	s0,0(sp)
    8000581c:	0141                	addi	sp,sp,16
    8000581e:	8082                	ret

0000000080005820 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005820:	715d                	addi	sp,sp,-80
    80005822:	e486                	sd	ra,72(sp)
    80005824:	e0a2                	sd	s0,64(sp)
    80005826:	fc26                	sd	s1,56(sp)
    80005828:	f84a                	sd	s2,48(sp)
    8000582a:	f44e                	sd	s3,40(sp)
    8000582c:	f052                	sd	s4,32(sp)
    8000582e:	ec56                	sd	s5,24(sp)
    80005830:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005832:	04c05663          	blez	a2,8000587e <consolewrite+0x5e>
    80005836:	8a2a                	mv	s4,a0
    80005838:	84ae                	mv	s1,a1
    8000583a:	89b2                	mv	s3,a2
    8000583c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000583e:	5afd                	li	s5,-1
    80005840:	4685                	li	a3,1
    80005842:	8626                	mv	a2,s1
    80005844:	85d2                	mv	a1,s4
    80005846:	fbf40513          	addi	a0,s0,-65
    8000584a:	ffffc097          	auipc	ra,0xffffc
    8000584e:	0f6080e7          	jalr	246(ra) # 80001940 <either_copyin>
    80005852:	01550c63          	beq	a0,s5,8000586a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005856:	fbf44503          	lbu	a0,-65(s0)
    8000585a:	00000097          	auipc	ra,0x0
    8000585e:	794080e7          	jalr	1940(ra) # 80005fee <uartputc>
  for(i = 0; i < n; i++){
    80005862:	2905                	addiw	s2,s2,1
    80005864:	0485                	addi	s1,s1,1
    80005866:	fd299de3          	bne	s3,s2,80005840 <consolewrite+0x20>
  }

  return i;
}
    8000586a:	854a                	mv	a0,s2
    8000586c:	60a6                	ld	ra,72(sp)
    8000586e:	6406                	ld	s0,64(sp)
    80005870:	74e2                	ld	s1,56(sp)
    80005872:	7942                	ld	s2,48(sp)
    80005874:	79a2                	ld	s3,40(sp)
    80005876:	7a02                	ld	s4,32(sp)
    80005878:	6ae2                	ld	s5,24(sp)
    8000587a:	6161                	addi	sp,sp,80
    8000587c:	8082                	ret
  for(i = 0; i < n; i++){
    8000587e:	4901                	li	s2,0
    80005880:	b7ed                	j	8000586a <consolewrite+0x4a>

0000000080005882 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005882:	7119                	addi	sp,sp,-128
    80005884:	fc86                	sd	ra,120(sp)
    80005886:	f8a2                	sd	s0,112(sp)
    80005888:	f4a6                	sd	s1,104(sp)
    8000588a:	f0ca                	sd	s2,96(sp)
    8000588c:	ecce                	sd	s3,88(sp)
    8000588e:	e8d2                	sd	s4,80(sp)
    80005890:	e4d6                	sd	s5,72(sp)
    80005892:	e0da                	sd	s6,64(sp)
    80005894:	fc5e                	sd	s7,56(sp)
    80005896:	f862                	sd	s8,48(sp)
    80005898:	f466                	sd	s9,40(sp)
    8000589a:	f06a                	sd	s10,32(sp)
    8000589c:	ec6e                	sd	s11,24(sp)
    8000589e:	0100                	addi	s0,sp,128
    800058a0:	8b2a                	mv	s6,a0
    800058a2:	8aae                	mv	s5,a1
    800058a4:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058a6:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800058aa:	0001c517          	auipc	a0,0x1c
    800058ae:	3b650513          	addi	a0,a0,950 # 80021c60 <cons>
    800058b2:	00001097          	auipc	ra,0x1
    800058b6:	8fa080e7          	jalr	-1798(ra) # 800061ac <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058ba:	0001c497          	auipc	s1,0x1c
    800058be:	3a648493          	addi	s1,s1,934 # 80021c60 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058c2:	89a6                	mv	s3,s1
    800058c4:	0001c917          	auipc	s2,0x1c
    800058c8:	43490913          	addi	s2,s2,1076 # 80021cf8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800058cc:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058ce:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058d0:	4da9                	li	s11,10
  while(n > 0){
    800058d2:	07405b63          	blez	s4,80005948 <consoleread+0xc6>
    while(cons.r == cons.w){
    800058d6:	0984a783          	lw	a5,152(s1)
    800058da:	09c4a703          	lw	a4,156(s1)
    800058de:	02f71763          	bne	a4,a5,8000590c <consoleread+0x8a>
      if(killed(myproc())){
    800058e2:	ffffb097          	auipc	ra,0xffffb
    800058e6:	55c080e7          	jalr	1372(ra) # 80000e3e <myproc>
    800058ea:	ffffc097          	auipc	ra,0xffffc
    800058ee:	ea0080e7          	jalr	-352(ra) # 8000178a <killed>
    800058f2:	e535                	bnez	a0,8000595e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    800058f4:	85ce                	mv	a1,s3
    800058f6:	854a                	mv	a0,s2
    800058f8:	ffffc097          	auipc	ra,0xffffc
    800058fc:	bea080e7          	jalr	-1046(ra) # 800014e2 <sleep>
    while(cons.r == cons.w){
    80005900:	0984a783          	lw	a5,152(s1)
    80005904:	09c4a703          	lw	a4,156(s1)
    80005908:	fcf70de3          	beq	a4,a5,800058e2 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000590c:	0017871b          	addiw	a4,a5,1
    80005910:	08e4ac23          	sw	a4,152(s1)
    80005914:	07f7f713          	andi	a4,a5,127
    80005918:	9726                	add	a4,a4,s1
    8000591a:	01874703          	lbu	a4,24(a4)
    8000591e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005922:	079c0663          	beq	s8,s9,8000598e <consoleread+0x10c>
    cbuf = c;
    80005926:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000592a:	4685                	li	a3,1
    8000592c:	f8f40613          	addi	a2,s0,-113
    80005930:	85d6                	mv	a1,s5
    80005932:	855a                	mv	a0,s6
    80005934:	ffffc097          	auipc	ra,0xffffc
    80005938:	fb6080e7          	jalr	-74(ra) # 800018ea <either_copyout>
    8000593c:	01a50663          	beq	a0,s10,80005948 <consoleread+0xc6>
    dst++;
    80005940:	0a85                	addi	s5,s5,1
    --n;
    80005942:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005944:	f9bc17e3          	bne	s8,s11,800058d2 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005948:	0001c517          	auipc	a0,0x1c
    8000594c:	31850513          	addi	a0,a0,792 # 80021c60 <cons>
    80005950:	00001097          	auipc	ra,0x1
    80005954:	910080e7          	jalr	-1776(ra) # 80006260 <release>

  return target - n;
    80005958:	414b853b          	subw	a0,s7,s4
    8000595c:	a811                	j	80005970 <consoleread+0xee>
        release(&cons.lock);
    8000595e:	0001c517          	auipc	a0,0x1c
    80005962:	30250513          	addi	a0,a0,770 # 80021c60 <cons>
    80005966:	00001097          	auipc	ra,0x1
    8000596a:	8fa080e7          	jalr	-1798(ra) # 80006260 <release>
        return -1;
    8000596e:	557d                	li	a0,-1
}
    80005970:	70e6                	ld	ra,120(sp)
    80005972:	7446                	ld	s0,112(sp)
    80005974:	74a6                	ld	s1,104(sp)
    80005976:	7906                	ld	s2,96(sp)
    80005978:	69e6                	ld	s3,88(sp)
    8000597a:	6a46                	ld	s4,80(sp)
    8000597c:	6aa6                	ld	s5,72(sp)
    8000597e:	6b06                	ld	s6,64(sp)
    80005980:	7be2                	ld	s7,56(sp)
    80005982:	7c42                	ld	s8,48(sp)
    80005984:	7ca2                	ld	s9,40(sp)
    80005986:	7d02                	ld	s10,32(sp)
    80005988:	6de2                	ld	s11,24(sp)
    8000598a:	6109                	addi	sp,sp,128
    8000598c:	8082                	ret
      if(n < target){
    8000598e:	000a071b          	sext.w	a4,s4
    80005992:	fb777be3          	bgeu	a4,s7,80005948 <consoleread+0xc6>
        cons.r--;
    80005996:	0001c717          	auipc	a4,0x1c
    8000599a:	36f72123          	sw	a5,866(a4) # 80021cf8 <cons+0x98>
    8000599e:	b76d                	j	80005948 <consoleread+0xc6>

00000000800059a0 <consputc>:
{
    800059a0:	1141                	addi	sp,sp,-16
    800059a2:	e406                	sd	ra,8(sp)
    800059a4:	e022                	sd	s0,0(sp)
    800059a6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059a8:	10000793          	li	a5,256
    800059ac:	00f50a63          	beq	a0,a5,800059c0 <consputc+0x20>
    uartputc_sync(c);
    800059b0:	00000097          	auipc	ra,0x0
    800059b4:	564080e7          	jalr	1380(ra) # 80005f14 <uartputc_sync>
}
    800059b8:	60a2                	ld	ra,8(sp)
    800059ba:	6402                	ld	s0,0(sp)
    800059bc:	0141                	addi	sp,sp,16
    800059be:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059c0:	4521                	li	a0,8
    800059c2:	00000097          	auipc	ra,0x0
    800059c6:	552080e7          	jalr	1362(ra) # 80005f14 <uartputc_sync>
    800059ca:	02000513          	li	a0,32
    800059ce:	00000097          	auipc	ra,0x0
    800059d2:	546080e7          	jalr	1350(ra) # 80005f14 <uartputc_sync>
    800059d6:	4521                	li	a0,8
    800059d8:	00000097          	auipc	ra,0x0
    800059dc:	53c080e7          	jalr	1340(ra) # 80005f14 <uartputc_sync>
    800059e0:	bfe1                	j	800059b8 <consputc+0x18>

00000000800059e2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059e2:	1101                	addi	sp,sp,-32
    800059e4:	ec06                	sd	ra,24(sp)
    800059e6:	e822                	sd	s0,16(sp)
    800059e8:	e426                	sd	s1,8(sp)
    800059ea:	e04a                	sd	s2,0(sp)
    800059ec:	1000                	addi	s0,sp,32
    800059ee:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059f0:	0001c517          	auipc	a0,0x1c
    800059f4:	27050513          	addi	a0,a0,624 # 80021c60 <cons>
    800059f8:	00000097          	auipc	ra,0x0
    800059fc:	7b4080e7          	jalr	1972(ra) # 800061ac <acquire>

  switch(c){
    80005a00:	47d5                	li	a5,21
    80005a02:	0af48663          	beq	s1,a5,80005aae <consoleintr+0xcc>
    80005a06:	0297ca63          	blt	a5,s1,80005a3a <consoleintr+0x58>
    80005a0a:	47a1                	li	a5,8
    80005a0c:	0ef48763          	beq	s1,a5,80005afa <consoleintr+0x118>
    80005a10:	47c1                	li	a5,16
    80005a12:	10f49a63          	bne	s1,a5,80005b26 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a16:	ffffc097          	auipc	ra,0xffffc
    80005a1a:	f80080e7          	jalr	-128(ra) # 80001996 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a1e:	0001c517          	auipc	a0,0x1c
    80005a22:	24250513          	addi	a0,a0,578 # 80021c60 <cons>
    80005a26:	00001097          	auipc	ra,0x1
    80005a2a:	83a080e7          	jalr	-1990(ra) # 80006260 <release>
}
    80005a2e:	60e2                	ld	ra,24(sp)
    80005a30:	6442                	ld	s0,16(sp)
    80005a32:	64a2                	ld	s1,8(sp)
    80005a34:	6902                	ld	s2,0(sp)
    80005a36:	6105                	addi	sp,sp,32
    80005a38:	8082                	ret
  switch(c){
    80005a3a:	07f00793          	li	a5,127
    80005a3e:	0af48e63          	beq	s1,a5,80005afa <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a42:	0001c717          	auipc	a4,0x1c
    80005a46:	21e70713          	addi	a4,a4,542 # 80021c60 <cons>
    80005a4a:	0a072783          	lw	a5,160(a4)
    80005a4e:	09872703          	lw	a4,152(a4)
    80005a52:	9f99                	subw	a5,a5,a4
    80005a54:	07f00713          	li	a4,127
    80005a58:	fcf763e3          	bltu	a4,a5,80005a1e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a5c:	47b5                	li	a5,13
    80005a5e:	0cf48763          	beq	s1,a5,80005b2c <consoleintr+0x14a>
      consputc(c);
    80005a62:	8526                	mv	a0,s1
    80005a64:	00000097          	auipc	ra,0x0
    80005a68:	f3c080e7          	jalr	-196(ra) # 800059a0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a6c:	0001c797          	auipc	a5,0x1c
    80005a70:	1f478793          	addi	a5,a5,500 # 80021c60 <cons>
    80005a74:	0a07a683          	lw	a3,160(a5)
    80005a78:	0016871b          	addiw	a4,a3,1
    80005a7c:	0007061b          	sext.w	a2,a4
    80005a80:	0ae7a023          	sw	a4,160(a5)
    80005a84:	07f6f693          	andi	a3,a3,127
    80005a88:	97b6                	add	a5,a5,a3
    80005a8a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005a8e:	47a9                	li	a5,10
    80005a90:	0cf48563          	beq	s1,a5,80005b5a <consoleintr+0x178>
    80005a94:	4791                	li	a5,4
    80005a96:	0cf48263          	beq	s1,a5,80005b5a <consoleintr+0x178>
    80005a9a:	0001c797          	auipc	a5,0x1c
    80005a9e:	25e7a783          	lw	a5,606(a5) # 80021cf8 <cons+0x98>
    80005aa2:	9f1d                	subw	a4,a4,a5
    80005aa4:	08000793          	li	a5,128
    80005aa8:	f6f71be3          	bne	a4,a5,80005a1e <consoleintr+0x3c>
    80005aac:	a07d                	j	80005b5a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005aae:	0001c717          	auipc	a4,0x1c
    80005ab2:	1b270713          	addi	a4,a4,434 # 80021c60 <cons>
    80005ab6:	0a072783          	lw	a5,160(a4)
    80005aba:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005abe:	0001c497          	auipc	s1,0x1c
    80005ac2:	1a248493          	addi	s1,s1,418 # 80021c60 <cons>
    while(cons.e != cons.w &&
    80005ac6:	4929                	li	s2,10
    80005ac8:	f4f70be3          	beq	a4,a5,80005a1e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005acc:	37fd                	addiw	a5,a5,-1
    80005ace:	07f7f713          	andi	a4,a5,127
    80005ad2:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ad4:	01874703          	lbu	a4,24(a4)
    80005ad8:	f52703e3          	beq	a4,s2,80005a1e <consoleintr+0x3c>
      cons.e--;
    80005adc:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ae0:	10000513          	li	a0,256
    80005ae4:	00000097          	auipc	ra,0x0
    80005ae8:	ebc080e7          	jalr	-324(ra) # 800059a0 <consputc>
    while(cons.e != cons.w &&
    80005aec:	0a04a783          	lw	a5,160(s1)
    80005af0:	09c4a703          	lw	a4,156(s1)
    80005af4:	fcf71ce3          	bne	a4,a5,80005acc <consoleintr+0xea>
    80005af8:	b71d                	j	80005a1e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005afa:	0001c717          	auipc	a4,0x1c
    80005afe:	16670713          	addi	a4,a4,358 # 80021c60 <cons>
    80005b02:	0a072783          	lw	a5,160(a4)
    80005b06:	09c72703          	lw	a4,156(a4)
    80005b0a:	f0f70ae3          	beq	a4,a5,80005a1e <consoleintr+0x3c>
      cons.e--;
    80005b0e:	37fd                	addiw	a5,a5,-1
    80005b10:	0001c717          	auipc	a4,0x1c
    80005b14:	1ef72823          	sw	a5,496(a4) # 80021d00 <cons+0xa0>
      consputc(BACKSPACE);
    80005b18:	10000513          	li	a0,256
    80005b1c:	00000097          	auipc	ra,0x0
    80005b20:	e84080e7          	jalr	-380(ra) # 800059a0 <consputc>
    80005b24:	bded                	j	80005a1e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b26:	ee048ce3          	beqz	s1,80005a1e <consoleintr+0x3c>
    80005b2a:	bf21                	j	80005a42 <consoleintr+0x60>
      consputc(c);
    80005b2c:	4529                	li	a0,10
    80005b2e:	00000097          	auipc	ra,0x0
    80005b32:	e72080e7          	jalr	-398(ra) # 800059a0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b36:	0001c797          	auipc	a5,0x1c
    80005b3a:	12a78793          	addi	a5,a5,298 # 80021c60 <cons>
    80005b3e:	0a07a703          	lw	a4,160(a5)
    80005b42:	0017069b          	addiw	a3,a4,1
    80005b46:	0006861b          	sext.w	a2,a3
    80005b4a:	0ad7a023          	sw	a3,160(a5)
    80005b4e:	07f77713          	andi	a4,a4,127
    80005b52:	97ba                	add	a5,a5,a4
    80005b54:	4729                	li	a4,10
    80005b56:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b5a:	0001c797          	auipc	a5,0x1c
    80005b5e:	1ac7a123          	sw	a2,418(a5) # 80021cfc <cons+0x9c>
        wakeup(&cons.r);
    80005b62:	0001c517          	auipc	a0,0x1c
    80005b66:	19650513          	addi	a0,a0,406 # 80021cf8 <cons+0x98>
    80005b6a:	ffffc097          	auipc	ra,0xffffc
    80005b6e:	9dc080e7          	jalr	-1572(ra) # 80001546 <wakeup>
    80005b72:	b575                	j	80005a1e <consoleintr+0x3c>

0000000080005b74 <consoleinit>:

void
consoleinit(void)
{
    80005b74:	1141                	addi	sp,sp,-16
    80005b76:	e406                	sd	ra,8(sp)
    80005b78:	e022                	sd	s0,0(sp)
    80005b7a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b7c:	00003597          	auipc	a1,0x3
    80005b80:	c4c58593          	addi	a1,a1,-948 # 800087c8 <syscalls+0x408>
    80005b84:	0001c517          	auipc	a0,0x1c
    80005b88:	0dc50513          	addi	a0,a0,220 # 80021c60 <cons>
    80005b8c:	00000097          	auipc	ra,0x0
    80005b90:	590080e7          	jalr	1424(ra) # 8000611c <initlock>

  uartinit();
    80005b94:	00000097          	auipc	ra,0x0
    80005b98:	330080e7          	jalr	816(ra) # 80005ec4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b9c:	00013797          	auipc	a5,0x13
    80005ba0:	dec78793          	addi	a5,a5,-532 # 80018988 <devsw>
    80005ba4:	00000717          	auipc	a4,0x0
    80005ba8:	cde70713          	addi	a4,a4,-802 # 80005882 <consoleread>
    80005bac:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bae:	00000717          	auipc	a4,0x0
    80005bb2:	c7270713          	addi	a4,a4,-910 # 80005820 <consolewrite>
    80005bb6:	ef98                	sd	a4,24(a5)
}
    80005bb8:	60a2                	ld	ra,8(sp)
    80005bba:	6402                	ld	s0,0(sp)
    80005bbc:	0141                	addi	sp,sp,16
    80005bbe:	8082                	ret

0000000080005bc0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bc0:	7179                	addi	sp,sp,-48
    80005bc2:	f406                	sd	ra,40(sp)
    80005bc4:	f022                	sd	s0,32(sp)
    80005bc6:	ec26                	sd	s1,24(sp)
    80005bc8:	e84a                	sd	s2,16(sp)
    80005bca:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bcc:	c219                	beqz	a2,80005bd2 <printint+0x12>
    80005bce:	08054663          	bltz	a0,80005c5a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005bd2:	2501                	sext.w	a0,a0
    80005bd4:	4881                	li	a7,0
    80005bd6:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bda:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bdc:	2581                	sext.w	a1,a1
    80005bde:	00003617          	auipc	a2,0x3
    80005be2:	c1a60613          	addi	a2,a2,-998 # 800087f8 <digits>
    80005be6:	883a                	mv	a6,a4
    80005be8:	2705                	addiw	a4,a4,1
    80005bea:	02b577bb          	remuw	a5,a0,a1
    80005bee:	1782                	slli	a5,a5,0x20
    80005bf0:	9381                	srli	a5,a5,0x20
    80005bf2:	97b2                	add	a5,a5,a2
    80005bf4:	0007c783          	lbu	a5,0(a5)
    80005bf8:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bfc:	0005079b          	sext.w	a5,a0
    80005c00:	02b5553b          	divuw	a0,a0,a1
    80005c04:	0685                	addi	a3,a3,1
    80005c06:	feb7f0e3          	bgeu	a5,a1,80005be6 <printint+0x26>

  if(sign)
    80005c0a:	00088b63          	beqz	a7,80005c20 <printint+0x60>
    buf[i++] = '-';
    80005c0e:	fe040793          	addi	a5,s0,-32
    80005c12:	973e                	add	a4,a4,a5
    80005c14:	02d00793          	li	a5,45
    80005c18:	fef70823          	sb	a5,-16(a4)
    80005c1c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c20:	02e05763          	blez	a4,80005c4e <printint+0x8e>
    80005c24:	fd040793          	addi	a5,s0,-48
    80005c28:	00e784b3          	add	s1,a5,a4
    80005c2c:	fff78913          	addi	s2,a5,-1
    80005c30:	993a                	add	s2,s2,a4
    80005c32:	377d                	addiw	a4,a4,-1
    80005c34:	1702                	slli	a4,a4,0x20
    80005c36:	9301                	srli	a4,a4,0x20
    80005c38:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c3c:	fff4c503          	lbu	a0,-1(s1)
    80005c40:	00000097          	auipc	ra,0x0
    80005c44:	d60080e7          	jalr	-672(ra) # 800059a0 <consputc>
  while(--i >= 0)
    80005c48:	14fd                	addi	s1,s1,-1
    80005c4a:	ff2499e3          	bne	s1,s2,80005c3c <printint+0x7c>
}
    80005c4e:	70a2                	ld	ra,40(sp)
    80005c50:	7402                	ld	s0,32(sp)
    80005c52:	64e2                	ld	s1,24(sp)
    80005c54:	6942                	ld	s2,16(sp)
    80005c56:	6145                	addi	sp,sp,48
    80005c58:	8082                	ret
    x = -xx;
    80005c5a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c5e:	4885                	li	a7,1
    x = -xx;
    80005c60:	bf9d                	j	80005bd6 <printint+0x16>

0000000080005c62 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c62:	1101                	addi	sp,sp,-32
    80005c64:	ec06                	sd	ra,24(sp)
    80005c66:	e822                	sd	s0,16(sp)
    80005c68:	e426                	sd	s1,8(sp)
    80005c6a:	1000                	addi	s0,sp,32
    80005c6c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c6e:	0001c797          	auipc	a5,0x1c
    80005c72:	0a07a923          	sw	zero,178(a5) # 80021d20 <pr+0x18>
  printf("panic: ");
    80005c76:	00003517          	auipc	a0,0x3
    80005c7a:	b5a50513          	addi	a0,a0,-1190 # 800087d0 <syscalls+0x410>
    80005c7e:	00000097          	auipc	ra,0x0
    80005c82:	02e080e7          	jalr	46(ra) # 80005cac <printf>
  printf(s);
    80005c86:	8526                	mv	a0,s1
    80005c88:	00000097          	auipc	ra,0x0
    80005c8c:	024080e7          	jalr	36(ra) # 80005cac <printf>
  printf("\n");
    80005c90:	00002517          	auipc	a0,0x2
    80005c94:	3b850513          	addi	a0,a0,952 # 80008048 <etext+0x48>
    80005c98:	00000097          	auipc	ra,0x0
    80005c9c:	014080e7          	jalr	20(ra) # 80005cac <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ca0:	4785                	li	a5,1
    80005ca2:	00003717          	auipc	a4,0x3
    80005ca6:	c2f72d23          	sw	a5,-966(a4) # 800088dc <panicked>
  for(;;)
    80005caa:	a001                	j	80005caa <panic+0x48>

0000000080005cac <printf>:
{
    80005cac:	7131                	addi	sp,sp,-192
    80005cae:	fc86                	sd	ra,120(sp)
    80005cb0:	f8a2                	sd	s0,112(sp)
    80005cb2:	f4a6                	sd	s1,104(sp)
    80005cb4:	f0ca                	sd	s2,96(sp)
    80005cb6:	ecce                	sd	s3,88(sp)
    80005cb8:	e8d2                	sd	s4,80(sp)
    80005cba:	e4d6                	sd	s5,72(sp)
    80005cbc:	e0da                	sd	s6,64(sp)
    80005cbe:	fc5e                	sd	s7,56(sp)
    80005cc0:	f862                	sd	s8,48(sp)
    80005cc2:	f466                	sd	s9,40(sp)
    80005cc4:	f06a                	sd	s10,32(sp)
    80005cc6:	ec6e                	sd	s11,24(sp)
    80005cc8:	0100                	addi	s0,sp,128
    80005cca:	8a2a                	mv	s4,a0
    80005ccc:	e40c                	sd	a1,8(s0)
    80005cce:	e810                	sd	a2,16(s0)
    80005cd0:	ec14                	sd	a3,24(s0)
    80005cd2:	f018                	sd	a4,32(s0)
    80005cd4:	f41c                	sd	a5,40(s0)
    80005cd6:	03043823          	sd	a6,48(s0)
    80005cda:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005cde:	0001cd97          	auipc	s11,0x1c
    80005ce2:	042dad83          	lw	s11,66(s11) # 80021d20 <pr+0x18>
  if(locking)
    80005ce6:	020d9b63          	bnez	s11,80005d1c <printf+0x70>
  if (fmt == 0)
    80005cea:	040a0263          	beqz	s4,80005d2e <printf+0x82>
  va_start(ap, fmt);
    80005cee:	00840793          	addi	a5,s0,8
    80005cf2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cf6:	000a4503          	lbu	a0,0(s4)
    80005cfa:	16050263          	beqz	a0,80005e5e <printf+0x1b2>
    80005cfe:	4481                	li	s1,0
    if(c != '%'){
    80005d00:	02500a93          	li	s5,37
    switch(c){
    80005d04:	07000b13          	li	s6,112
  consputc('x');
    80005d08:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d0a:	00003b97          	auipc	s7,0x3
    80005d0e:	aeeb8b93          	addi	s7,s7,-1298 # 800087f8 <digits>
    switch(c){
    80005d12:	07300c93          	li	s9,115
    80005d16:	06400c13          	li	s8,100
    80005d1a:	a82d                	j	80005d54 <printf+0xa8>
    acquire(&pr.lock);
    80005d1c:	0001c517          	auipc	a0,0x1c
    80005d20:	fec50513          	addi	a0,a0,-20 # 80021d08 <pr>
    80005d24:	00000097          	auipc	ra,0x0
    80005d28:	488080e7          	jalr	1160(ra) # 800061ac <acquire>
    80005d2c:	bf7d                	j	80005cea <printf+0x3e>
    panic("null fmt");
    80005d2e:	00003517          	auipc	a0,0x3
    80005d32:	ab250513          	addi	a0,a0,-1358 # 800087e0 <syscalls+0x420>
    80005d36:	00000097          	auipc	ra,0x0
    80005d3a:	f2c080e7          	jalr	-212(ra) # 80005c62 <panic>
      consputc(c);
    80005d3e:	00000097          	auipc	ra,0x0
    80005d42:	c62080e7          	jalr	-926(ra) # 800059a0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d46:	2485                	addiw	s1,s1,1
    80005d48:	009a07b3          	add	a5,s4,s1
    80005d4c:	0007c503          	lbu	a0,0(a5)
    80005d50:	10050763          	beqz	a0,80005e5e <printf+0x1b2>
    if(c != '%'){
    80005d54:	ff5515e3          	bne	a0,s5,80005d3e <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d58:	2485                	addiw	s1,s1,1
    80005d5a:	009a07b3          	add	a5,s4,s1
    80005d5e:	0007c783          	lbu	a5,0(a5)
    80005d62:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005d66:	cfe5                	beqz	a5,80005e5e <printf+0x1b2>
    switch(c){
    80005d68:	05678a63          	beq	a5,s6,80005dbc <printf+0x110>
    80005d6c:	02fb7663          	bgeu	s6,a5,80005d98 <printf+0xec>
    80005d70:	09978963          	beq	a5,s9,80005e02 <printf+0x156>
    80005d74:	07800713          	li	a4,120
    80005d78:	0ce79863          	bne	a5,a4,80005e48 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005d7c:	f8843783          	ld	a5,-120(s0)
    80005d80:	00878713          	addi	a4,a5,8
    80005d84:	f8e43423          	sd	a4,-120(s0)
    80005d88:	4605                	li	a2,1
    80005d8a:	85ea                	mv	a1,s10
    80005d8c:	4388                	lw	a0,0(a5)
    80005d8e:	00000097          	auipc	ra,0x0
    80005d92:	e32080e7          	jalr	-462(ra) # 80005bc0 <printint>
      break;
    80005d96:	bf45                	j	80005d46 <printf+0x9a>
    switch(c){
    80005d98:	0b578263          	beq	a5,s5,80005e3c <printf+0x190>
    80005d9c:	0b879663          	bne	a5,s8,80005e48 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005da0:	f8843783          	ld	a5,-120(s0)
    80005da4:	00878713          	addi	a4,a5,8
    80005da8:	f8e43423          	sd	a4,-120(s0)
    80005dac:	4605                	li	a2,1
    80005dae:	45a9                	li	a1,10
    80005db0:	4388                	lw	a0,0(a5)
    80005db2:	00000097          	auipc	ra,0x0
    80005db6:	e0e080e7          	jalr	-498(ra) # 80005bc0 <printint>
      break;
    80005dba:	b771                	j	80005d46 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005dbc:	f8843783          	ld	a5,-120(s0)
    80005dc0:	00878713          	addi	a4,a5,8
    80005dc4:	f8e43423          	sd	a4,-120(s0)
    80005dc8:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005dcc:	03000513          	li	a0,48
    80005dd0:	00000097          	auipc	ra,0x0
    80005dd4:	bd0080e7          	jalr	-1072(ra) # 800059a0 <consputc>
  consputc('x');
    80005dd8:	07800513          	li	a0,120
    80005ddc:	00000097          	auipc	ra,0x0
    80005de0:	bc4080e7          	jalr	-1084(ra) # 800059a0 <consputc>
    80005de4:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005de6:	03c9d793          	srli	a5,s3,0x3c
    80005dea:	97de                	add	a5,a5,s7
    80005dec:	0007c503          	lbu	a0,0(a5)
    80005df0:	00000097          	auipc	ra,0x0
    80005df4:	bb0080e7          	jalr	-1104(ra) # 800059a0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005df8:	0992                	slli	s3,s3,0x4
    80005dfa:	397d                	addiw	s2,s2,-1
    80005dfc:	fe0915e3          	bnez	s2,80005de6 <printf+0x13a>
    80005e00:	b799                	j	80005d46 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e02:	f8843783          	ld	a5,-120(s0)
    80005e06:	00878713          	addi	a4,a5,8
    80005e0a:	f8e43423          	sd	a4,-120(s0)
    80005e0e:	0007b903          	ld	s2,0(a5)
    80005e12:	00090e63          	beqz	s2,80005e2e <printf+0x182>
      for(; *s; s++)
    80005e16:	00094503          	lbu	a0,0(s2)
    80005e1a:	d515                	beqz	a0,80005d46 <printf+0x9a>
        consputc(*s);
    80005e1c:	00000097          	auipc	ra,0x0
    80005e20:	b84080e7          	jalr	-1148(ra) # 800059a0 <consputc>
      for(; *s; s++)
    80005e24:	0905                	addi	s2,s2,1
    80005e26:	00094503          	lbu	a0,0(s2)
    80005e2a:	f96d                	bnez	a0,80005e1c <printf+0x170>
    80005e2c:	bf29                	j	80005d46 <printf+0x9a>
        s = "(null)";
    80005e2e:	00003917          	auipc	s2,0x3
    80005e32:	9aa90913          	addi	s2,s2,-1622 # 800087d8 <syscalls+0x418>
      for(; *s; s++)
    80005e36:	02800513          	li	a0,40
    80005e3a:	b7cd                	j	80005e1c <printf+0x170>
      consputc('%');
    80005e3c:	8556                	mv	a0,s5
    80005e3e:	00000097          	auipc	ra,0x0
    80005e42:	b62080e7          	jalr	-1182(ra) # 800059a0 <consputc>
      break;
    80005e46:	b701                	j	80005d46 <printf+0x9a>
      consputc('%');
    80005e48:	8556                	mv	a0,s5
    80005e4a:	00000097          	auipc	ra,0x0
    80005e4e:	b56080e7          	jalr	-1194(ra) # 800059a0 <consputc>
      consputc(c);
    80005e52:	854a                	mv	a0,s2
    80005e54:	00000097          	auipc	ra,0x0
    80005e58:	b4c080e7          	jalr	-1204(ra) # 800059a0 <consputc>
      break;
    80005e5c:	b5ed                	j	80005d46 <printf+0x9a>
  if(locking)
    80005e5e:	020d9163          	bnez	s11,80005e80 <printf+0x1d4>
}
    80005e62:	70e6                	ld	ra,120(sp)
    80005e64:	7446                	ld	s0,112(sp)
    80005e66:	74a6                	ld	s1,104(sp)
    80005e68:	7906                	ld	s2,96(sp)
    80005e6a:	69e6                	ld	s3,88(sp)
    80005e6c:	6a46                	ld	s4,80(sp)
    80005e6e:	6aa6                	ld	s5,72(sp)
    80005e70:	6b06                	ld	s6,64(sp)
    80005e72:	7be2                	ld	s7,56(sp)
    80005e74:	7c42                	ld	s8,48(sp)
    80005e76:	7ca2                	ld	s9,40(sp)
    80005e78:	7d02                	ld	s10,32(sp)
    80005e7a:	6de2                	ld	s11,24(sp)
    80005e7c:	6129                	addi	sp,sp,192
    80005e7e:	8082                	ret
    release(&pr.lock);
    80005e80:	0001c517          	auipc	a0,0x1c
    80005e84:	e8850513          	addi	a0,a0,-376 # 80021d08 <pr>
    80005e88:	00000097          	auipc	ra,0x0
    80005e8c:	3d8080e7          	jalr	984(ra) # 80006260 <release>
}
    80005e90:	bfc9                	j	80005e62 <printf+0x1b6>

0000000080005e92 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e92:	1101                	addi	sp,sp,-32
    80005e94:	ec06                	sd	ra,24(sp)
    80005e96:	e822                	sd	s0,16(sp)
    80005e98:	e426                	sd	s1,8(sp)
    80005e9a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e9c:	0001c497          	auipc	s1,0x1c
    80005ea0:	e6c48493          	addi	s1,s1,-404 # 80021d08 <pr>
    80005ea4:	00003597          	auipc	a1,0x3
    80005ea8:	94c58593          	addi	a1,a1,-1716 # 800087f0 <syscalls+0x430>
    80005eac:	8526                	mv	a0,s1
    80005eae:	00000097          	auipc	ra,0x0
    80005eb2:	26e080e7          	jalr	622(ra) # 8000611c <initlock>
  pr.locking = 1;
    80005eb6:	4785                	li	a5,1
    80005eb8:	cc9c                	sw	a5,24(s1)
}
    80005eba:	60e2                	ld	ra,24(sp)
    80005ebc:	6442                	ld	s0,16(sp)
    80005ebe:	64a2                	ld	s1,8(sp)
    80005ec0:	6105                	addi	sp,sp,32
    80005ec2:	8082                	ret

0000000080005ec4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ec4:	1141                	addi	sp,sp,-16
    80005ec6:	e406                	sd	ra,8(sp)
    80005ec8:	e022                	sd	s0,0(sp)
    80005eca:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ecc:	100007b7          	lui	a5,0x10000
    80005ed0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ed4:	f8000713          	li	a4,-128
    80005ed8:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005edc:	470d                	li	a4,3
    80005ede:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005ee2:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ee6:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005eea:	469d                	li	a3,7
    80005eec:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ef0:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005ef4:	00003597          	auipc	a1,0x3
    80005ef8:	91c58593          	addi	a1,a1,-1764 # 80008810 <digits+0x18>
    80005efc:	0001c517          	auipc	a0,0x1c
    80005f00:	e2c50513          	addi	a0,a0,-468 # 80021d28 <uart_tx_lock>
    80005f04:	00000097          	auipc	ra,0x0
    80005f08:	218080e7          	jalr	536(ra) # 8000611c <initlock>
}
    80005f0c:	60a2                	ld	ra,8(sp)
    80005f0e:	6402                	ld	s0,0(sp)
    80005f10:	0141                	addi	sp,sp,16
    80005f12:	8082                	ret

0000000080005f14 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f14:	1101                	addi	sp,sp,-32
    80005f16:	ec06                	sd	ra,24(sp)
    80005f18:	e822                	sd	s0,16(sp)
    80005f1a:	e426                	sd	s1,8(sp)
    80005f1c:	1000                	addi	s0,sp,32
    80005f1e:	84aa                	mv	s1,a0
  push_off();
    80005f20:	00000097          	auipc	ra,0x0
    80005f24:	240080e7          	jalr	576(ra) # 80006160 <push_off>

  if(panicked){
    80005f28:	00003797          	auipc	a5,0x3
    80005f2c:	9b47a783          	lw	a5,-1612(a5) # 800088dc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f30:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f34:	c391                	beqz	a5,80005f38 <uartputc_sync+0x24>
    for(;;)
    80005f36:	a001                	j	80005f36 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f38:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f3c:	0ff7f793          	andi	a5,a5,255
    80005f40:	0207f793          	andi	a5,a5,32
    80005f44:	dbf5                	beqz	a5,80005f38 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f46:	0ff4f793          	andi	a5,s1,255
    80005f4a:	10000737          	lui	a4,0x10000
    80005f4e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f52:	00000097          	auipc	ra,0x0
    80005f56:	2ae080e7          	jalr	686(ra) # 80006200 <pop_off>
}
    80005f5a:	60e2                	ld	ra,24(sp)
    80005f5c:	6442                	ld	s0,16(sp)
    80005f5e:	64a2                	ld	s1,8(sp)
    80005f60:	6105                	addi	sp,sp,32
    80005f62:	8082                	ret

0000000080005f64 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f64:	00003717          	auipc	a4,0x3
    80005f68:	97c73703          	ld	a4,-1668(a4) # 800088e0 <uart_tx_r>
    80005f6c:	00003797          	auipc	a5,0x3
    80005f70:	97c7b783          	ld	a5,-1668(a5) # 800088e8 <uart_tx_w>
    80005f74:	06e78c63          	beq	a5,a4,80005fec <uartstart+0x88>
{
    80005f78:	7139                	addi	sp,sp,-64
    80005f7a:	fc06                	sd	ra,56(sp)
    80005f7c:	f822                	sd	s0,48(sp)
    80005f7e:	f426                	sd	s1,40(sp)
    80005f80:	f04a                	sd	s2,32(sp)
    80005f82:	ec4e                	sd	s3,24(sp)
    80005f84:	e852                	sd	s4,16(sp)
    80005f86:	e456                	sd	s5,8(sp)
    80005f88:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f8a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f8e:	0001ca17          	auipc	s4,0x1c
    80005f92:	d9aa0a13          	addi	s4,s4,-614 # 80021d28 <uart_tx_lock>
    uart_tx_r += 1;
    80005f96:	00003497          	auipc	s1,0x3
    80005f9a:	94a48493          	addi	s1,s1,-1718 # 800088e0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f9e:	00003997          	auipc	s3,0x3
    80005fa2:	94a98993          	addi	s3,s3,-1718 # 800088e8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fa6:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005faa:	0ff7f793          	andi	a5,a5,255
    80005fae:	0207f793          	andi	a5,a5,32
    80005fb2:	c785                	beqz	a5,80005fda <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fb4:	01f77793          	andi	a5,a4,31
    80005fb8:	97d2                	add	a5,a5,s4
    80005fba:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005fbe:	0705                	addi	a4,a4,1
    80005fc0:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fc2:	8526                	mv	a0,s1
    80005fc4:	ffffb097          	auipc	ra,0xffffb
    80005fc8:	582080e7          	jalr	1410(ra) # 80001546 <wakeup>
    
    WriteReg(THR, c);
    80005fcc:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fd0:	6098                	ld	a4,0(s1)
    80005fd2:	0009b783          	ld	a5,0(s3)
    80005fd6:	fce798e3          	bne	a5,a4,80005fa6 <uartstart+0x42>
  }
}
    80005fda:	70e2                	ld	ra,56(sp)
    80005fdc:	7442                	ld	s0,48(sp)
    80005fde:	74a2                	ld	s1,40(sp)
    80005fe0:	7902                	ld	s2,32(sp)
    80005fe2:	69e2                	ld	s3,24(sp)
    80005fe4:	6a42                	ld	s4,16(sp)
    80005fe6:	6aa2                	ld	s5,8(sp)
    80005fe8:	6121                	addi	sp,sp,64
    80005fea:	8082                	ret
    80005fec:	8082                	ret

0000000080005fee <uartputc>:
{
    80005fee:	7179                	addi	sp,sp,-48
    80005ff0:	f406                	sd	ra,40(sp)
    80005ff2:	f022                	sd	s0,32(sp)
    80005ff4:	ec26                	sd	s1,24(sp)
    80005ff6:	e84a                	sd	s2,16(sp)
    80005ff8:	e44e                	sd	s3,8(sp)
    80005ffa:	e052                	sd	s4,0(sp)
    80005ffc:	1800                	addi	s0,sp,48
    80005ffe:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006000:	0001c517          	auipc	a0,0x1c
    80006004:	d2850513          	addi	a0,a0,-728 # 80021d28 <uart_tx_lock>
    80006008:	00000097          	auipc	ra,0x0
    8000600c:	1a4080e7          	jalr	420(ra) # 800061ac <acquire>
  if(panicked){
    80006010:	00003797          	auipc	a5,0x3
    80006014:	8cc7a783          	lw	a5,-1844(a5) # 800088dc <panicked>
    80006018:	e7c9                	bnez	a5,800060a2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000601a:	00003797          	auipc	a5,0x3
    8000601e:	8ce7b783          	ld	a5,-1842(a5) # 800088e8 <uart_tx_w>
    80006022:	00003717          	auipc	a4,0x3
    80006026:	8be73703          	ld	a4,-1858(a4) # 800088e0 <uart_tx_r>
    8000602a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000602e:	0001ca17          	auipc	s4,0x1c
    80006032:	cfaa0a13          	addi	s4,s4,-774 # 80021d28 <uart_tx_lock>
    80006036:	00003497          	auipc	s1,0x3
    8000603a:	8aa48493          	addi	s1,s1,-1878 # 800088e0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000603e:	00003917          	auipc	s2,0x3
    80006042:	8aa90913          	addi	s2,s2,-1878 # 800088e8 <uart_tx_w>
    80006046:	00f71f63          	bne	a4,a5,80006064 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000604a:	85d2                	mv	a1,s4
    8000604c:	8526                	mv	a0,s1
    8000604e:	ffffb097          	auipc	ra,0xffffb
    80006052:	494080e7          	jalr	1172(ra) # 800014e2 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006056:	00093783          	ld	a5,0(s2)
    8000605a:	6098                	ld	a4,0(s1)
    8000605c:	02070713          	addi	a4,a4,32
    80006060:	fef705e3          	beq	a4,a5,8000604a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006064:	0001c497          	auipc	s1,0x1c
    80006068:	cc448493          	addi	s1,s1,-828 # 80021d28 <uart_tx_lock>
    8000606c:	01f7f713          	andi	a4,a5,31
    80006070:	9726                	add	a4,a4,s1
    80006072:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006076:	0785                	addi	a5,a5,1
    80006078:	00003717          	auipc	a4,0x3
    8000607c:	86f73823          	sd	a5,-1936(a4) # 800088e8 <uart_tx_w>
  uartstart();
    80006080:	00000097          	auipc	ra,0x0
    80006084:	ee4080e7          	jalr	-284(ra) # 80005f64 <uartstart>
  release(&uart_tx_lock);
    80006088:	8526                	mv	a0,s1
    8000608a:	00000097          	auipc	ra,0x0
    8000608e:	1d6080e7          	jalr	470(ra) # 80006260 <release>
}
    80006092:	70a2                	ld	ra,40(sp)
    80006094:	7402                	ld	s0,32(sp)
    80006096:	64e2                	ld	s1,24(sp)
    80006098:	6942                	ld	s2,16(sp)
    8000609a:	69a2                	ld	s3,8(sp)
    8000609c:	6a02                	ld	s4,0(sp)
    8000609e:	6145                	addi	sp,sp,48
    800060a0:	8082                	ret
    for(;;)
    800060a2:	a001                	j	800060a2 <uartputc+0xb4>

00000000800060a4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060a4:	1141                	addi	sp,sp,-16
    800060a6:	e422                	sd	s0,8(sp)
    800060a8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060aa:	100007b7          	lui	a5,0x10000
    800060ae:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060b2:	8b85                	andi	a5,a5,1
    800060b4:	cb91                	beqz	a5,800060c8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060b6:	100007b7          	lui	a5,0x10000
    800060ba:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800060be:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800060c2:	6422                	ld	s0,8(sp)
    800060c4:	0141                	addi	sp,sp,16
    800060c6:	8082                	ret
    return -1;
    800060c8:	557d                	li	a0,-1
    800060ca:	bfe5                	j	800060c2 <uartgetc+0x1e>

00000000800060cc <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800060cc:	1101                	addi	sp,sp,-32
    800060ce:	ec06                	sd	ra,24(sp)
    800060d0:	e822                	sd	s0,16(sp)
    800060d2:	e426                	sd	s1,8(sp)
    800060d4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060d6:	54fd                	li	s1,-1
    int c = uartgetc();
    800060d8:	00000097          	auipc	ra,0x0
    800060dc:	fcc080e7          	jalr	-52(ra) # 800060a4 <uartgetc>
    if(c == -1)
    800060e0:	00950763          	beq	a0,s1,800060ee <uartintr+0x22>
      break;
    consoleintr(c);
    800060e4:	00000097          	auipc	ra,0x0
    800060e8:	8fe080e7          	jalr	-1794(ra) # 800059e2 <consoleintr>
  while(1){
    800060ec:	b7f5                	j	800060d8 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060ee:	0001c497          	auipc	s1,0x1c
    800060f2:	c3a48493          	addi	s1,s1,-966 # 80021d28 <uart_tx_lock>
    800060f6:	8526                	mv	a0,s1
    800060f8:	00000097          	auipc	ra,0x0
    800060fc:	0b4080e7          	jalr	180(ra) # 800061ac <acquire>
  uartstart();
    80006100:	00000097          	auipc	ra,0x0
    80006104:	e64080e7          	jalr	-412(ra) # 80005f64 <uartstart>
  release(&uart_tx_lock);
    80006108:	8526                	mv	a0,s1
    8000610a:	00000097          	auipc	ra,0x0
    8000610e:	156080e7          	jalr	342(ra) # 80006260 <release>
}
    80006112:	60e2                	ld	ra,24(sp)
    80006114:	6442                	ld	s0,16(sp)
    80006116:	64a2                	ld	s1,8(sp)
    80006118:	6105                	addi	sp,sp,32
    8000611a:	8082                	ret

000000008000611c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000611c:	1141                	addi	sp,sp,-16
    8000611e:	e422                	sd	s0,8(sp)
    80006120:	0800                	addi	s0,sp,16
  lk->name = name;
    80006122:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006124:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006128:	00053823          	sd	zero,16(a0)
}
    8000612c:	6422                	ld	s0,8(sp)
    8000612e:	0141                	addi	sp,sp,16
    80006130:	8082                	ret

0000000080006132 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006132:	411c                	lw	a5,0(a0)
    80006134:	e399                	bnez	a5,8000613a <holding+0x8>
    80006136:	4501                	li	a0,0
  return r;
}
    80006138:	8082                	ret
{
    8000613a:	1101                	addi	sp,sp,-32
    8000613c:	ec06                	sd	ra,24(sp)
    8000613e:	e822                	sd	s0,16(sp)
    80006140:	e426                	sd	s1,8(sp)
    80006142:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006144:	6904                	ld	s1,16(a0)
    80006146:	ffffb097          	auipc	ra,0xffffb
    8000614a:	cdc080e7          	jalr	-804(ra) # 80000e22 <mycpu>
    8000614e:	40a48533          	sub	a0,s1,a0
    80006152:	00153513          	seqz	a0,a0
}
    80006156:	60e2                	ld	ra,24(sp)
    80006158:	6442                	ld	s0,16(sp)
    8000615a:	64a2                	ld	s1,8(sp)
    8000615c:	6105                	addi	sp,sp,32
    8000615e:	8082                	ret

0000000080006160 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006160:	1101                	addi	sp,sp,-32
    80006162:	ec06                	sd	ra,24(sp)
    80006164:	e822                	sd	s0,16(sp)
    80006166:	e426                	sd	s1,8(sp)
    80006168:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000616a:	100024f3          	csrr	s1,sstatus
    8000616e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006172:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006174:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006178:	ffffb097          	auipc	ra,0xffffb
    8000617c:	caa080e7          	jalr	-854(ra) # 80000e22 <mycpu>
    80006180:	5d3c                	lw	a5,120(a0)
    80006182:	cf89                	beqz	a5,8000619c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006184:	ffffb097          	auipc	ra,0xffffb
    80006188:	c9e080e7          	jalr	-866(ra) # 80000e22 <mycpu>
    8000618c:	5d3c                	lw	a5,120(a0)
    8000618e:	2785                	addiw	a5,a5,1
    80006190:	dd3c                	sw	a5,120(a0)
}
    80006192:	60e2                	ld	ra,24(sp)
    80006194:	6442                	ld	s0,16(sp)
    80006196:	64a2                	ld	s1,8(sp)
    80006198:	6105                	addi	sp,sp,32
    8000619a:	8082                	ret
    mycpu()->intena = old;
    8000619c:	ffffb097          	auipc	ra,0xffffb
    800061a0:	c86080e7          	jalr	-890(ra) # 80000e22 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061a4:	8085                	srli	s1,s1,0x1
    800061a6:	8885                	andi	s1,s1,1
    800061a8:	dd64                	sw	s1,124(a0)
    800061aa:	bfe9                	j	80006184 <push_off+0x24>

00000000800061ac <acquire>:
{
    800061ac:	1101                	addi	sp,sp,-32
    800061ae:	ec06                	sd	ra,24(sp)
    800061b0:	e822                	sd	s0,16(sp)
    800061b2:	e426                	sd	s1,8(sp)
    800061b4:	1000                	addi	s0,sp,32
    800061b6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061b8:	00000097          	auipc	ra,0x0
    800061bc:	fa8080e7          	jalr	-88(ra) # 80006160 <push_off>
  if(holding(lk))
    800061c0:	8526                	mv	a0,s1
    800061c2:	00000097          	auipc	ra,0x0
    800061c6:	f70080e7          	jalr	-144(ra) # 80006132 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061ca:	4705                	li	a4,1
  if(holding(lk))
    800061cc:	e115                	bnez	a0,800061f0 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061ce:	87ba                	mv	a5,a4
    800061d0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061d4:	2781                	sext.w	a5,a5
    800061d6:	ffe5                	bnez	a5,800061ce <acquire+0x22>
  __sync_synchronize();
    800061d8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061dc:	ffffb097          	auipc	ra,0xffffb
    800061e0:	c46080e7          	jalr	-954(ra) # 80000e22 <mycpu>
    800061e4:	e888                	sd	a0,16(s1)
}
    800061e6:	60e2                	ld	ra,24(sp)
    800061e8:	6442                	ld	s0,16(sp)
    800061ea:	64a2                	ld	s1,8(sp)
    800061ec:	6105                	addi	sp,sp,32
    800061ee:	8082                	ret
    panic("acquire");
    800061f0:	00002517          	auipc	a0,0x2
    800061f4:	62850513          	addi	a0,a0,1576 # 80008818 <digits+0x20>
    800061f8:	00000097          	auipc	ra,0x0
    800061fc:	a6a080e7          	jalr	-1430(ra) # 80005c62 <panic>

0000000080006200 <pop_off>:

void
pop_off(void)
{
    80006200:	1141                	addi	sp,sp,-16
    80006202:	e406                	sd	ra,8(sp)
    80006204:	e022                	sd	s0,0(sp)
    80006206:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006208:	ffffb097          	auipc	ra,0xffffb
    8000620c:	c1a080e7          	jalr	-998(ra) # 80000e22 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006210:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006214:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006216:	e78d                	bnez	a5,80006240 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006218:	5d3c                	lw	a5,120(a0)
    8000621a:	02f05b63          	blez	a5,80006250 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000621e:	37fd                	addiw	a5,a5,-1
    80006220:	0007871b          	sext.w	a4,a5
    80006224:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006226:	eb09                	bnez	a4,80006238 <pop_off+0x38>
    80006228:	5d7c                	lw	a5,124(a0)
    8000622a:	c799                	beqz	a5,80006238 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000622c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006230:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006234:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006238:	60a2                	ld	ra,8(sp)
    8000623a:	6402                	ld	s0,0(sp)
    8000623c:	0141                	addi	sp,sp,16
    8000623e:	8082                	ret
    panic("pop_off - interruptible");
    80006240:	00002517          	auipc	a0,0x2
    80006244:	5e050513          	addi	a0,a0,1504 # 80008820 <digits+0x28>
    80006248:	00000097          	auipc	ra,0x0
    8000624c:	a1a080e7          	jalr	-1510(ra) # 80005c62 <panic>
    panic("pop_off");
    80006250:	00002517          	auipc	a0,0x2
    80006254:	5e850513          	addi	a0,a0,1512 # 80008838 <digits+0x40>
    80006258:	00000097          	auipc	ra,0x0
    8000625c:	a0a080e7          	jalr	-1526(ra) # 80005c62 <panic>

0000000080006260 <release>:
{
    80006260:	1101                	addi	sp,sp,-32
    80006262:	ec06                	sd	ra,24(sp)
    80006264:	e822                	sd	s0,16(sp)
    80006266:	e426                	sd	s1,8(sp)
    80006268:	1000                	addi	s0,sp,32
    8000626a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000626c:	00000097          	auipc	ra,0x0
    80006270:	ec6080e7          	jalr	-314(ra) # 80006132 <holding>
    80006274:	c115                	beqz	a0,80006298 <release+0x38>
  lk->cpu = 0;
    80006276:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000627a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000627e:	0f50000f          	fence	iorw,ow
    80006282:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006286:	00000097          	auipc	ra,0x0
    8000628a:	f7a080e7          	jalr	-134(ra) # 80006200 <pop_off>
}
    8000628e:	60e2                	ld	ra,24(sp)
    80006290:	6442                	ld	s0,16(sp)
    80006292:	64a2                	ld	s1,8(sp)
    80006294:	6105                	addi	sp,sp,32
    80006296:	8082                	ret
    panic("release");
    80006298:	00002517          	auipc	a0,0x2
    8000629c:	5a850513          	addi	a0,a0,1448 # 80008840 <digits+0x48>
    800062a0:	00000097          	auipc	ra,0x0
    800062a4:	9c2080e7          	jalr	-1598(ra) # 80005c62 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
