
user/_mmaptest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:

char *testname = "???";

void
err(char *why)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
  printf("mmaptest: %s failed: %s, pid=%d\n", testname, why, getpid());
       e:	00002917          	auipc	s2,0x2
      12:	ff293903          	ld	s2,-14(s2) # 2000 <testname>
      16:	00001097          	auipc	ra,0x1
      1a:	c2a080e7          	jalr	-982(ra) # c40 <getpid>
      1e:	86aa                	mv	a3,a0
      20:	8626                	mv	a2,s1
      22:	85ca                	mv	a1,s2
      24:	00001517          	auipc	a0,0x1
      28:	0cc50513          	addi	a0,a0,204 # 10f0 <malloc+0xea>
      2c:	00001097          	auipc	ra,0x1
      30:	f1c080e7          	jalr	-228(ra) # f48 <printf>
  exit(1);
      34:	4505                	li	a0,1
      36:	00001097          	auipc	ra,0x1
      3a:	b8a080e7          	jalr	-1142(ra) # bc0 <exit>

000000000000003e <_v1>:
//
// check the content of the two mapped pages.
//
void
_v1(char *p)
{
      3e:	1141                	addi	sp,sp,-16
      40:	e406                	sd	ra,8(sp)
      42:	e022                	sd	s0,0(sp)
      44:	0800                	addi	s0,sp,16
      46:	4781                	li	a5,0
  int i;
  for (i = 0; i < PGSIZE*2; i++) {
    if (i < PGSIZE + (PGSIZE/2)) {
      48:	6685                	lui	a3,0x1
      4a:	7ff68693          	addi	a3,a3,2047 # 17ff <digits+0x257>
  for (i = 0; i < PGSIZE*2; i++) {
      4e:	6889                	lui	a7,0x2
      if (p[i] != 'A') {
      50:	04100813          	li	a6,65
      54:	a811                	j	68 <_v1+0x2a>
        printf("mismatch at %d, wanted 'A', got 0x%x\n", i, p[i]);
        err("v1 mismatch (1)");
      }
    } else {
      if (p[i] != 0) {
      56:	00f50633          	add	a2,a0,a5
      5a:	00064603          	lbu	a2,0(a2)
      5e:	e221                	bnez	a2,9e <_v1+0x60>
  for (i = 0; i < PGSIZE*2; i++) {
      60:	2705                	addiw	a4,a4,1
      62:	05175e63          	bge	a4,a7,be <_v1+0x80>
      66:	0785                	addi	a5,a5,1
      68:	0007871b          	sext.w	a4,a5
      6c:	85ba                	mv	a1,a4
    if (i < PGSIZE + (PGSIZE/2)) {
      6e:	fee6c4e3          	blt	a3,a4,56 <_v1+0x18>
      if (p[i] != 'A') {
      72:	00f50733          	add	a4,a0,a5
      76:	00074603          	lbu	a2,0(a4)
      7a:	ff0606e3          	beq	a2,a6,66 <_v1+0x28>
        printf("mismatch at %d, wanted 'A', got 0x%x\n", i, p[i]);
      7e:	00001517          	auipc	a0,0x1
      82:	09a50513          	addi	a0,a0,154 # 1118 <malloc+0x112>
      86:	00001097          	auipc	ra,0x1
      8a:	ec2080e7          	jalr	-318(ra) # f48 <printf>
        err("v1 mismatch (1)");
      8e:	00001517          	auipc	a0,0x1
      92:	0b250513          	addi	a0,a0,178 # 1140 <malloc+0x13a>
      96:	00000097          	auipc	ra,0x0
      9a:	f6a080e7          	jalr	-150(ra) # 0 <err>
        printf("mismatch at %d, wanted zero, got 0x%x\n", i, p[i]);
      9e:	00001517          	auipc	a0,0x1
      a2:	0b250513          	addi	a0,a0,178 # 1150 <malloc+0x14a>
      a6:	00001097          	auipc	ra,0x1
      aa:	ea2080e7          	jalr	-350(ra) # f48 <printf>
        err("v1 mismatch (2)");
      ae:	00001517          	auipc	a0,0x1
      b2:	0ca50513          	addi	a0,a0,202 # 1178 <malloc+0x172>
      b6:	00000097          	auipc	ra,0x0
      ba:	f4a080e7          	jalr	-182(ra) # 0 <err>
      }
    }
  }
}
      be:	60a2                	ld	ra,8(sp)
      c0:	6402                	ld	s0,0(sp)
      c2:	0141                	addi	sp,sp,16
      c4:	8082                	ret

00000000000000c6 <makefile>:
// create a file to be mapped, containing
// 1.5 pages of 'A' and half a page of zeros.
//
void
makefile(const char *f)
{
      c6:	7179                	addi	sp,sp,-48
      c8:	f406                	sd	ra,40(sp)
      ca:	f022                	sd	s0,32(sp)
      cc:	ec26                	sd	s1,24(sp)
      ce:	e84a                	sd	s2,16(sp)
      d0:	e44e                	sd	s3,8(sp)
      d2:	1800                	addi	s0,sp,48
      d4:	84aa                	mv	s1,a0
  int i;
  int n = PGSIZE/BSIZE;

  unlink(f);
      d6:	00001097          	auipc	ra,0x1
      da:	b3a080e7          	jalr	-1222(ra) # c10 <unlink>
  int fd = open(f, O_WRONLY | O_CREATE);
      de:	20100593          	li	a1,513
      e2:	8526                	mv	a0,s1
      e4:	00001097          	auipc	ra,0x1
      e8:	b1c080e7          	jalr	-1252(ra) # c00 <open>
  if (fd == -1)
      ec:	57fd                	li	a5,-1
      ee:	06f50163          	beq	a0,a5,150 <makefile+0x8a>
      f2:	892a                	mv	s2,a0
    err("open");
  memset(buf, 'A', BSIZE);
      f4:	40000613          	li	a2,1024
      f8:	04100593          	li	a1,65
      fc:	00002517          	auipc	a0,0x2
     100:	f2450513          	addi	a0,a0,-220 # 2020 <buf>
     104:	00001097          	auipc	ra,0x1
     108:	8b8080e7          	jalr	-1864(ra) # 9bc <memset>
     10c:	4499                	li	s1,6
  // write 1.5 page
  for (i = 0; i < n + n/2; i++) {
    if (write(fd, buf, BSIZE) != BSIZE)
     10e:	00002997          	auipc	s3,0x2
     112:	f1298993          	addi	s3,s3,-238 # 2020 <buf>
     116:	40000613          	li	a2,1024
     11a:	85ce                	mv	a1,s3
     11c:	854a                	mv	a0,s2
     11e:	00001097          	auipc	ra,0x1
     122:	ac2080e7          	jalr	-1342(ra) # be0 <write>
     126:	40000793          	li	a5,1024
     12a:	02f51b63          	bne	a0,a5,160 <makefile+0x9a>
  for (i = 0; i < n + n/2; i++) {
     12e:	34fd                	addiw	s1,s1,-1
     130:	f0fd                	bnez	s1,116 <makefile+0x50>
      err("write 0 makefile");
  }
  if (close(fd) == -1)
     132:	854a                	mv	a0,s2
     134:	00001097          	auipc	ra,0x1
     138:	ab4080e7          	jalr	-1356(ra) # be8 <close>
     13c:	57fd                	li	a5,-1
     13e:	02f50963          	beq	a0,a5,170 <makefile+0xaa>
    err("close");
}
     142:	70a2                	ld	ra,40(sp)
     144:	7402                	ld	s0,32(sp)
     146:	64e2                	ld	s1,24(sp)
     148:	6942                	ld	s2,16(sp)
     14a:	69a2                	ld	s3,8(sp)
     14c:	6145                	addi	sp,sp,48
     14e:	8082                	ret
    err("open");
     150:	00001517          	auipc	a0,0x1
     154:	03850513          	addi	a0,a0,56 # 1188 <malloc+0x182>
     158:	00000097          	auipc	ra,0x0
     15c:	ea8080e7          	jalr	-344(ra) # 0 <err>
      err("write 0 makefile");
     160:	00001517          	auipc	a0,0x1
     164:	03050513          	addi	a0,a0,48 # 1190 <malloc+0x18a>
     168:	00000097          	auipc	ra,0x0
     16c:	e98080e7          	jalr	-360(ra) # 0 <err>
    err("close");
     170:	00001517          	auipc	a0,0x1
     174:	03850513          	addi	a0,a0,56 # 11a8 <malloc+0x1a2>
     178:	00000097          	auipc	ra,0x0
     17c:	e88080e7          	jalr	-376(ra) # 0 <err>

0000000000000180 <mmap_test>:

void
mmap_test(void)
{
     180:	7139                	addi	sp,sp,-64
     182:	fc06                	sd	ra,56(sp)
     184:	f822                	sd	s0,48(sp)
     186:	f426                	sd	s1,40(sp)
     188:	f04a                	sd	s2,32(sp)
     18a:	ec4e                	sd	s3,24(sp)
     18c:	e852                	sd	s4,16(sp)
     18e:	0080                	addi	s0,sp,64
  int fd;
  int i;
  const char * const f = "mmap.dur";
  printf("mmap_test starting\n");
     190:	00001517          	auipc	a0,0x1
     194:	02050513          	addi	a0,a0,32 # 11b0 <malloc+0x1aa>
     198:	00001097          	auipc	ra,0x1
     19c:	db0080e7          	jalr	-592(ra) # f48 <printf>
  testname = "mmap_test";
     1a0:	00001797          	auipc	a5,0x1
     1a4:	02878793          	addi	a5,a5,40 # 11c8 <malloc+0x1c2>
     1a8:	00002717          	auipc	a4,0x2
     1ac:	e4f73c23          	sd	a5,-424(a4) # 2000 <testname>
  //
  // create a file with known content, map it into memory, check that
  // the mapped memory has the same bytes as originally written to the
  // file.
  //
  makefile(f);
     1b0:	00001517          	auipc	a0,0x1
     1b4:	02850513          	addi	a0,a0,40 # 11d8 <malloc+0x1d2>
     1b8:	00000097          	auipc	ra,0x0
     1bc:	f0e080e7          	jalr	-242(ra) # c6 <makefile>
  if ((fd = open(f, O_RDONLY)) == -1)
     1c0:	4581                	li	a1,0
     1c2:	00001517          	auipc	a0,0x1
     1c6:	01650513          	addi	a0,a0,22 # 11d8 <malloc+0x1d2>
     1ca:	00001097          	auipc	ra,0x1
     1ce:	a36080e7          	jalr	-1482(ra) # c00 <open>
     1d2:	57fd                	li	a5,-1
     1d4:	3ef50663          	beq	a0,a5,5c0 <mmap_test+0x440>
     1d8:	892a                	mv	s2,a0
    err("open");

  printf("test mmap f\n");
     1da:	00001517          	auipc	a0,0x1
     1de:	00e50513          	addi	a0,a0,14 # 11e8 <malloc+0x1e2>
     1e2:	00001097          	auipc	ra,0x1
     1e6:	d66080e7          	jalr	-666(ra) # f48 <printf>
  // same file (of course in this case updates are prohibited
  // due to PROT_READ). the fifth argument is the file descriptor
  // of the file to be mapped. the last argument is the starting
  // offset in the file.
  //
  char *p = mmap(0, PGSIZE*2, PROT_READ, MAP_PRIVATE, fd, 0);
     1ea:	4781                	li	a5,0
     1ec:	874a                	mv	a4,s2
     1ee:	4689                	li	a3,2
     1f0:	4605                	li	a2,1
     1f2:	6589                	lui	a1,0x2
     1f4:	4501                	li	a0,0
     1f6:	00001097          	auipc	ra,0x1
     1fa:	a6a080e7          	jalr	-1430(ra) # c60 <mmap>
     1fe:	84aa                	mv	s1,a0
  if (p == MAP_FAILED)
     200:	57fd                	li	a5,-1
     202:	3cf50763          	beq	a0,a5,5d0 <mmap_test+0x450>
    err("mmap (1)");
  _v1(p);
     206:	00000097          	auipc	ra,0x0
     20a:	e38080e7          	jalr	-456(ra) # 3e <_v1>
  if (munmap(p, PGSIZE*2) == -1)
     20e:	6589                	lui	a1,0x2
     210:	8526                	mv	a0,s1
     212:	00001097          	auipc	ra,0x1
     216:	a56080e7          	jalr	-1450(ra) # c68 <munmap>
     21a:	57fd                	li	a5,-1
     21c:	3cf50263          	beq	a0,a5,5e0 <mmap_test+0x460>
    err("munmap (1)");

  printf("test mmap f: OK\n");
     220:	00001517          	auipc	a0,0x1
     224:	ff850513          	addi	a0,a0,-8 # 1218 <malloc+0x212>
     228:	00001097          	auipc	ra,0x1
     22c:	d20080e7          	jalr	-736(ra) # f48 <printf>
    
  printf("test mmap private\n");
     230:	00001517          	auipc	a0,0x1
     234:	00050513          	mv	a0,a0
     238:	00001097          	auipc	ra,0x1
     23c:	d10080e7          	jalr	-752(ra) # f48 <printf>
  // should be able to map file opened read-only with private writable
  // mapping
  p = mmap(0, PGSIZE*2, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
     240:	4781                	li	a5,0
     242:	874a                	mv	a4,s2
     244:	4689                	li	a3,2
     246:	460d                	li	a2,3
     248:	6589                	lui	a1,0x2
     24a:	4501                	li	a0,0
     24c:	00001097          	auipc	ra,0x1
     250:	a14080e7          	jalr	-1516(ra) # c60 <mmap>
     254:	84aa                	mv	s1,a0
  if (p == MAP_FAILED)
     256:	57fd                	li	a5,-1
     258:	38f50c63          	beq	a0,a5,5f0 <mmap_test+0x470>
    err("mmap (2)");
  if (close(fd) == -1)
     25c:	854a                	mv	a0,s2
     25e:	00001097          	auipc	ra,0x1
     262:	98a080e7          	jalr	-1654(ra) # be8 <close>
     266:	57fd                	li	a5,-1
     268:	38f50c63          	beq	a0,a5,600 <mmap_test+0x480>
    err("close");
  _v1(p);
     26c:	8526                	mv	a0,s1
     26e:	00000097          	auipc	ra,0x0
     272:	dd0080e7          	jalr	-560(ra) # 3e <_v1>
  for (i = 0; i < PGSIZE*2; i++)
     276:	87a6                	mv	a5,s1
     278:	6709                	lui	a4,0x2
     27a:	9726                	add	a4,a4,s1
    p[i] = 'Z';
     27c:	05a00693          	li	a3,90
     280:	00d78023          	sb	a3,0(a5)
  for (i = 0; i < PGSIZE*2; i++)
     284:	0785                	addi	a5,a5,1
     286:	fef71de3          	bne	a4,a5,280 <mmap_test+0x100>
  if (munmap(p, PGSIZE*2) == -1)
     28a:	6589                	lui	a1,0x2
     28c:	8526                	mv	a0,s1
     28e:	00001097          	auipc	ra,0x1
     292:	9da080e7          	jalr	-1574(ra) # c68 <munmap>
     296:	57fd                	li	a5,-1
     298:	36f50c63          	beq	a0,a5,610 <mmap_test+0x490>
    err("munmap (2)");

  printf("test mmap private: OK\n");
     29c:	00001517          	auipc	a0,0x1
     2a0:	fcc50513          	addi	a0,a0,-52 # 1268 <malloc+0x262>
     2a4:	00001097          	auipc	ra,0x1
     2a8:	ca4080e7          	jalr	-860(ra) # f48 <printf>
    
  printf("test mmap read-only\n");
     2ac:	00001517          	auipc	a0,0x1
     2b0:	fd450513          	addi	a0,a0,-44 # 1280 <malloc+0x27a>
     2b4:	00001097          	auipc	ra,0x1
     2b8:	c94080e7          	jalr	-876(ra) # f48 <printf>
    
  // check that mmap doesn't allow read/write mapping of a
  // file opened read-only.
  if ((fd = open(f, O_RDONLY)) == -1)
     2bc:	4581                	li	a1,0
     2be:	00001517          	auipc	a0,0x1
     2c2:	f1a50513          	addi	a0,a0,-230 # 11d8 <malloc+0x1d2>
     2c6:	00001097          	auipc	ra,0x1
     2ca:	93a080e7          	jalr	-1734(ra) # c00 <open>
     2ce:	84aa                	mv	s1,a0
     2d0:	57fd                	li	a5,-1
     2d2:	34f50763          	beq	a0,a5,620 <mmap_test+0x4a0>
    err("open");
  p = mmap(0, PGSIZE*3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     2d6:	4781                	li	a5,0
     2d8:	872a                	mv	a4,a0
     2da:	4685                	li	a3,1
     2dc:	460d                	li	a2,3
     2de:	658d                	lui	a1,0x3
     2e0:	4501                	li	a0,0
     2e2:	00001097          	auipc	ra,0x1
     2e6:	97e080e7          	jalr	-1666(ra) # c60 <mmap>
  if (p != MAP_FAILED)
     2ea:	57fd                	li	a5,-1
     2ec:	34f51263          	bne	a0,a5,630 <mmap_test+0x4b0>
    err("mmap call should have failed");
  if (close(fd) == -1)
     2f0:	8526                	mv	a0,s1
     2f2:	00001097          	auipc	ra,0x1
     2f6:	8f6080e7          	jalr	-1802(ra) # be8 <close>
     2fa:	57fd                	li	a5,-1
     2fc:	34f50263          	beq	a0,a5,640 <mmap_test+0x4c0>
    err("close");

  printf("test mmap read-only: OK\n");
     300:	00001517          	auipc	a0,0x1
     304:	fb850513          	addi	a0,a0,-72 # 12b8 <malloc+0x2b2>
     308:	00001097          	auipc	ra,0x1
     30c:	c40080e7          	jalr	-960(ra) # f48 <printf>
    
  printf("test mmap read/write\n");
     310:	00001517          	auipc	a0,0x1
     314:	fc850513          	addi	a0,a0,-56 # 12d8 <malloc+0x2d2>
     318:	00001097          	auipc	ra,0x1
     31c:	c30080e7          	jalr	-976(ra) # f48 <printf>
  
  // check that mmap does allow read/write mapping of a
  // file opened read/write.
  if ((fd = open(f, O_RDWR)) == -1)
     320:	4589                	li	a1,2
     322:	00001517          	auipc	a0,0x1
     326:	eb650513          	addi	a0,a0,-330 # 11d8 <malloc+0x1d2>
     32a:	00001097          	auipc	ra,0x1
     32e:	8d6080e7          	jalr	-1834(ra) # c00 <open>
     332:	84aa                	mv	s1,a0
     334:	57fd                	li	a5,-1
     336:	30f50d63          	beq	a0,a5,650 <mmap_test+0x4d0>
    err("open");
  p = mmap(0, PGSIZE*3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     33a:	4781                	li	a5,0
     33c:	872a                	mv	a4,a0
     33e:	4685                	li	a3,1
     340:	460d                	li	a2,3
     342:	658d                	lui	a1,0x3
     344:	4501                	li	a0,0
     346:	00001097          	auipc	ra,0x1
     34a:	91a080e7          	jalr	-1766(ra) # c60 <mmap>
     34e:	89aa                	mv	s3,a0
  if (p == MAP_FAILED)
     350:	57fd                	li	a5,-1
     352:	30f50763          	beq	a0,a5,660 <mmap_test+0x4e0>
    err("mmap (3)");
  if (close(fd) == -1)
     356:	8526                	mv	a0,s1
     358:	00001097          	auipc	ra,0x1
     35c:	890080e7          	jalr	-1904(ra) # be8 <close>
     360:	57fd                	li	a5,-1
     362:	30f50763          	beq	a0,a5,670 <mmap_test+0x4f0>
    err("close");

  // check that the mapping still works after close(fd).
  _v1(p);
     366:	854e                	mv	a0,s3
     368:	00000097          	auipc	ra,0x0
     36c:	cd6080e7          	jalr	-810(ra) # 3e <_v1>

  // write the mapped memory.
  for (i = 0; i < PGSIZE*2; i++)
     370:	87ce                	mv	a5,s3
     372:	6709                	lui	a4,0x2
     374:	974e                	add	a4,a4,s3
    p[i] = 'Z';
     376:	05a00693          	li	a3,90
     37a:	00d78023          	sb	a3,0(a5)
  for (i = 0; i < PGSIZE*2; i++)
     37e:	0785                	addi	a5,a5,1
     380:	fee79de3          	bne	a5,a4,37a <mmap_test+0x1fa>

  // unmap just the first two of three pages of mapped memory.
  if (munmap(p, PGSIZE*2) == -1)
     384:	6589                	lui	a1,0x2
     386:	854e                	mv	a0,s3
     388:	00001097          	auipc	ra,0x1
     38c:	8e0080e7          	jalr	-1824(ra) # c68 <munmap>
     390:	57fd                	li	a5,-1
     392:	2ef50763          	beq	a0,a5,680 <mmap_test+0x500>
    err("munmap (3)");
  
  printf("test mmap read/write: OK\n");
     396:	00001517          	auipc	a0,0x1
     39a:	f7a50513          	addi	a0,a0,-134 # 1310 <malloc+0x30a>
     39e:	00001097          	auipc	ra,0x1
     3a2:	baa080e7          	jalr	-1110(ra) # f48 <printf>
  
  printf("test mmap dirty\n");
     3a6:	00001517          	auipc	a0,0x1
     3aa:	f8a50513          	addi	a0,a0,-118 # 1330 <malloc+0x32a>
     3ae:	00001097          	auipc	ra,0x1
     3b2:	b9a080e7          	jalr	-1126(ra) # f48 <printf>
  
  // check that the writes to the mapped memory were
  // written to the file.
  if ((fd = open(f, O_RDWR)) == -1)
     3b6:	4589                	li	a1,2
     3b8:	00001517          	auipc	a0,0x1
     3bc:	e2050513          	addi	a0,a0,-480 # 11d8 <malloc+0x1d2>
     3c0:	00001097          	auipc	ra,0x1
     3c4:	840080e7          	jalr	-1984(ra) # c00 <open>
     3c8:	892a                	mv	s2,a0
     3ca:	57fd                	li	a5,-1
     3cc:	6489                	lui	s1,0x2
     3ce:	80048493          	addi	s1,s1,-2048 # 1800 <digits+0x258>
    err("open");
  for (i = 0; i < PGSIZE + (PGSIZE/2); i++){
    char b;
    if (read(fd, &b, 1) != 1)
      err("read (1)");
    if (b != 'Z')
     3d2:	05a00a13          	li	s4,90
  if ((fd = open(f, O_RDWR)) == -1)
     3d6:	2af50d63          	beq	a0,a5,690 <mmap_test+0x510>
    if (read(fd, &b, 1) != 1)
     3da:	4605                	li	a2,1
     3dc:	fcf40593          	addi	a1,s0,-49
     3e0:	854a                	mv	a0,s2
     3e2:	00000097          	auipc	ra,0x0
     3e6:	7f6080e7          	jalr	2038(ra) # bd8 <read>
     3ea:	4785                	li	a5,1
     3ec:	2af51a63          	bne	a0,a5,6a0 <mmap_test+0x520>
    if (b != 'Z')
     3f0:	fcf44783          	lbu	a5,-49(s0)
     3f4:	2b479e63          	bne	a5,s4,6b0 <mmap_test+0x530>
  for (i = 0; i < PGSIZE + (PGSIZE/2); i++){
     3f8:	34fd                	addiw	s1,s1,-1
     3fa:	f0e5                	bnez	s1,3da <mmap_test+0x25a>
      err("file does not contain modifications");
  }
  if (close(fd) == -1)
     3fc:	854a                	mv	a0,s2
     3fe:	00000097          	auipc	ra,0x0
     402:	7ea080e7          	jalr	2026(ra) # be8 <close>
     406:	57fd                	li	a5,-1
     408:	2af50c63          	beq	a0,a5,6c0 <mmap_test+0x540>
    err("close");

  printf("test mmap dirty: OK\n");
     40c:	00001517          	auipc	a0,0x1
     410:	f7450513          	addi	a0,a0,-140 # 1380 <malloc+0x37a>
     414:	00001097          	auipc	ra,0x1
     418:	b34080e7          	jalr	-1228(ra) # f48 <printf>

  printf("test not-mapped unmap\n");
     41c:	00001517          	auipc	a0,0x1
     420:	f7c50513          	addi	a0,a0,-132 # 1398 <malloc+0x392>
     424:	00001097          	auipc	ra,0x1
     428:	b24080e7          	jalr	-1244(ra) # f48 <printf>
  
  // unmap the rest of the mapped memory.
  if (munmap(p+PGSIZE*2, PGSIZE) == -1)
     42c:	6585                	lui	a1,0x1
     42e:	6509                	lui	a0,0x2
     430:	954e                	add	a0,a0,s3
     432:	00001097          	auipc	ra,0x1
     436:	836080e7          	jalr	-1994(ra) # c68 <munmap>
     43a:	57fd                	li	a5,-1
     43c:	28f50a63          	beq	a0,a5,6d0 <mmap_test+0x550>
    err("munmap (4)");

  printf("test not-mapped unmap: OK\n");
     440:	00001517          	auipc	a0,0x1
     444:	f8050513          	addi	a0,a0,-128 # 13c0 <malloc+0x3ba>
     448:	00001097          	auipc	ra,0x1
     44c:	b00080e7          	jalr	-1280(ra) # f48 <printf>
    
  printf("test mmap two files\n");
     450:	00001517          	auipc	a0,0x1
     454:	f9050513          	addi	a0,a0,-112 # 13e0 <malloc+0x3da>
     458:	00001097          	auipc	ra,0x1
     45c:	af0080e7          	jalr	-1296(ra) # f48 <printf>
  
  //
  // mmap two files at the same time.
  //
  int fd1;
  if((fd1 = open("mmap1", O_RDWR|O_CREATE)) < 0)
     460:	20200593          	li	a1,514
     464:	00001517          	auipc	a0,0x1
     468:	f9450513          	addi	a0,a0,-108 # 13f8 <malloc+0x3f2>
     46c:	00000097          	auipc	ra,0x0
     470:	794080e7          	jalr	1940(ra) # c00 <open>
     474:	84aa                	mv	s1,a0
     476:	26054563          	bltz	a0,6e0 <mmap_test+0x560>
    err("open mmap1");
  if(write(fd1, "12345", 5) != 5)
     47a:	4615                	li	a2,5
     47c:	00001597          	auipc	a1,0x1
     480:	f9458593          	addi	a1,a1,-108 # 1410 <malloc+0x40a>
     484:	00000097          	auipc	ra,0x0
     488:	75c080e7          	jalr	1884(ra) # be0 <write>
     48c:	4795                	li	a5,5
     48e:	26f51163          	bne	a0,a5,6f0 <mmap_test+0x570>
    err("write mmap1");
  char *p1 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd1, 0);
     492:	4781                	li	a5,0
     494:	8726                	mv	a4,s1
     496:	4689                	li	a3,2
     498:	4605                	li	a2,1
     49a:	6585                	lui	a1,0x1
     49c:	4501                	li	a0,0
     49e:	00000097          	auipc	ra,0x0
     4a2:	7c2080e7          	jalr	1986(ra) # c60 <mmap>
     4a6:	89aa                	mv	s3,a0
  if(p1 == MAP_FAILED)
     4a8:	57fd                	li	a5,-1
     4aa:	24f50b63          	beq	a0,a5,700 <mmap_test+0x580>
    err("mmap mmap1");
  close(fd1);
     4ae:	8526                	mv	a0,s1
     4b0:	00000097          	auipc	ra,0x0
     4b4:	738080e7          	jalr	1848(ra) # be8 <close>
  unlink("mmap1");
     4b8:	00001517          	auipc	a0,0x1
     4bc:	f4050513          	addi	a0,a0,-192 # 13f8 <malloc+0x3f2>
     4c0:	00000097          	auipc	ra,0x0
     4c4:	750080e7          	jalr	1872(ra) # c10 <unlink>

  int fd2;
  if((fd2 = open("mmap2", O_RDWR|O_CREATE)) < 0)
     4c8:	20200593          	li	a1,514
     4cc:	00001517          	auipc	a0,0x1
     4d0:	f6c50513          	addi	a0,a0,-148 # 1438 <malloc+0x432>
     4d4:	00000097          	auipc	ra,0x0
     4d8:	72c080e7          	jalr	1836(ra) # c00 <open>
     4dc:	892a                	mv	s2,a0
     4de:	22054963          	bltz	a0,710 <mmap_test+0x590>
    err("open mmap2");
  if(write(fd2, "67890", 5) != 5)
     4e2:	4615                	li	a2,5
     4e4:	00001597          	auipc	a1,0x1
     4e8:	f6c58593          	addi	a1,a1,-148 # 1450 <malloc+0x44a>
     4ec:	00000097          	auipc	ra,0x0
     4f0:	6f4080e7          	jalr	1780(ra) # be0 <write>
     4f4:	4795                	li	a5,5
     4f6:	22f51563          	bne	a0,a5,720 <mmap_test+0x5a0>
    err("write mmap2");
  char *p2 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd2, 0);
     4fa:	4781                	li	a5,0
     4fc:	874a                	mv	a4,s2
     4fe:	4689                	li	a3,2
     500:	4605                	li	a2,1
     502:	6585                	lui	a1,0x1
     504:	4501                	li	a0,0
     506:	00000097          	auipc	ra,0x0
     50a:	75a080e7          	jalr	1882(ra) # c60 <mmap>
     50e:	84aa                	mv	s1,a0
  if(p2 == MAP_FAILED)
     510:	57fd                	li	a5,-1
     512:	20f50f63          	beq	a0,a5,730 <mmap_test+0x5b0>
    err("mmap mmap2");
  close(fd2);
     516:	854a                	mv	a0,s2
     518:	00000097          	auipc	ra,0x0
     51c:	6d0080e7          	jalr	1744(ra) # be8 <close>
  unlink("mmap2");
     520:	00001517          	auipc	a0,0x1
     524:	f1850513          	addi	a0,a0,-232 # 1438 <malloc+0x432>
     528:	00000097          	auipc	ra,0x0
     52c:	6e8080e7          	jalr	1768(ra) # c10 <unlink>

  if(memcmp(p1, "12345", 5) != 0)
     530:	4615                	li	a2,5
     532:	00001597          	auipc	a1,0x1
     536:	ede58593          	addi	a1,a1,-290 # 1410 <malloc+0x40a>
     53a:	854e                	mv	a0,s3
     53c:	00000097          	auipc	ra,0x0
     540:	62a080e7          	jalr	1578(ra) # b66 <memcmp>
     544:	1e051e63          	bnez	a0,740 <mmap_test+0x5c0>
    err("mmap1 mismatch");
  if(memcmp(p2, "67890", 5) != 0)
     548:	4615                	li	a2,5
     54a:	00001597          	auipc	a1,0x1
     54e:	f0658593          	addi	a1,a1,-250 # 1450 <malloc+0x44a>
     552:	8526                	mv	a0,s1
     554:	00000097          	auipc	ra,0x0
     558:	612080e7          	jalr	1554(ra) # b66 <memcmp>
     55c:	1e051a63          	bnez	a0,750 <mmap_test+0x5d0>
    err("mmap2 mismatch");

  munmap(p1, PGSIZE);
     560:	6585                	lui	a1,0x1
     562:	854e                	mv	a0,s3
     564:	00000097          	auipc	ra,0x0
     568:	704080e7          	jalr	1796(ra) # c68 <munmap>
  if(memcmp(p2, "67890", 5) != 0)
     56c:	4615                	li	a2,5
     56e:	00001597          	auipc	a1,0x1
     572:	ee258593          	addi	a1,a1,-286 # 1450 <malloc+0x44a>
     576:	8526                	mv	a0,s1
     578:	00000097          	auipc	ra,0x0
     57c:	5ee080e7          	jalr	1518(ra) # b66 <memcmp>
     580:	1e051063          	bnez	a0,760 <mmap_test+0x5e0>
    err("mmap2 mismatch (2)");
  munmap(p2, PGSIZE);
     584:	6585                	lui	a1,0x1
     586:	8526                	mv	a0,s1
     588:	00000097          	auipc	ra,0x0
     58c:	6e0080e7          	jalr	1760(ra) # c68 <munmap>
  
  printf("test mmap two files: OK\n");
     590:	00001517          	auipc	a0,0x1
     594:	f2050513          	addi	a0,a0,-224 # 14b0 <malloc+0x4aa>
     598:	00001097          	auipc	ra,0x1
     59c:	9b0080e7          	jalr	-1616(ra) # f48 <printf>
  
  printf("mmap_test: ALL OK\n");
     5a0:	00001517          	auipc	a0,0x1
     5a4:	f3050513          	addi	a0,a0,-208 # 14d0 <malloc+0x4ca>
     5a8:	00001097          	auipc	ra,0x1
     5ac:	9a0080e7          	jalr	-1632(ra) # f48 <printf>
}
     5b0:	70e2                	ld	ra,56(sp)
     5b2:	7442                	ld	s0,48(sp)
     5b4:	74a2                	ld	s1,40(sp)
     5b6:	7902                	ld	s2,32(sp)
     5b8:	69e2                	ld	s3,24(sp)
     5ba:	6a42                	ld	s4,16(sp)
     5bc:	6121                	addi	sp,sp,64
     5be:	8082                	ret
    err("open");
     5c0:	00001517          	auipc	a0,0x1
     5c4:	bc850513          	addi	a0,a0,-1080 # 1188 <malloc+0x182>
     5c8:	00000097          	auipc	ra,0x0
     5cc:	a38080e7          	jalr	-1480(ra) # 0 <err>
    err("mmap (1)");
     5d0:	00001517          	auipc	a0,0x1
     5d4:	c2850513          	addi	a0,a0,-984 # 11f8 <malloc+0x1f2>
     5d8:	00000097          	auipc	ra,0x0
     5dc:	a28080e7          	jalr	-1496(ra) # 0 <err>
    err("munmap (1)");
     5e0:	00001517          	auipc	a0,0x1
     5e4:	c2850513          	addi	a0,a0,-984 # 1208 <malloc+0x202>
     5e8:	00000097          	auipc	ra,0x0
     5ec:	a18080e7          	jalr	-1512(ra) # 0 <err>
    err("mmap (2)");
     5f0:	00001517          	auipc	a0,0x1
     5f4:	c5850513          	addi	a0,a0,-936 # 1248 <malloc+0x242>
     5f8:	00000097          	auipc	ra,0x0
     5fc:	a08080e7          	jalr	-1528(ra) # 0 <err>
    err("close");
     600:	00001517          	auipc	a0,0x1
     604:	ba850513          	addi	a0,a0,-1112 # 11a8 <malloc+0x1a2>
     608:	00000097          	auipc	ra,0x0
     60c:	9f8080e7          	jalr	-1544(ra) # 0 <err>
    err("munmap (2)");
     610:	00001517          	auipc	a0,0x1
     614:	c4850513          	addi	a0,a0,-952 # 1258 <malloc+0x252>
     618:	00000097          	auipc	ra,0x0
     61c:	9e8080e7          	jalr	-1560(ra) # 0 <err>
    err("open");
     620:	00001517          	auipc	a0,0x1
     624:	b6850513          	addi	a0,a0,-1176 # 1188 <malloc+0x182>
     628:	00000097          	auipc	ra,0x0
     62c:	9d8080e7          	jalr	-1576(ra) # 0 <err>
    err("mmap call should have failed");
     630:	00001517          	auipc	a0,0x1
     634:	c6850513          	addi	a0,a0,-920 # 1298 <malloc+0x292>
     638:	00000097          	auipc	ra,0x0
     63c:	9c8080e7          	jalr	-1592(ra) # 0 <err>
    err("close");
     640:	00001517          	auipc	a0,0x1
     644:	b6850513          	addi	a0,a0,-1176 # 11a8 <malloc+0x1a2>
     648:	00000097          	auipc	ra,0x0
     64c:	9b8080e7          	jalr	-1608(ra) # 0 <err>
    err("open");
     650:	00001517          	auipc	a0,0x1
     654:	b3850513          	addi	a0,a0,-1224 # 1188 <malloc+0x182>
     658:	00000097          	auipc	ra,0x0
     65c:	9a8080e7          	jalr	-1624(ra) # 0 <err>
    err("mmap (3)");
     660:	00001517          	auipc	a0,0x1
     664:	c9050513          	addi	a0,a0,-880 # 12f0 <malloc+0x2ea>
     668:	00000097          	auipc	ra,0x0
     66c:	998080e7          	jalr	-1640(ra) # 0 <err>
    err("close");
     670:	00001517          	auipc	a0,0x1
     674:	b3850513          	addi	a0,a0,-1224 # 11a8 <malloc+0x1a2>
     678:	00000097          	auipc	ra,0x0
     67c:	988080e7          	jalr	-1656(ra) # 0 <err>
    err("munmap (3)");
     680:	00001517          	auipc	a0,0x1
     684:	c8050513          	addi	a0,a0,-896 # 1300 <malloc+0x2fa>
     688:	00000097          	auipc	ra,0x0
     68c:	978080e7          	jalr	-1672(ra) # 0 <err>
    err("open");
     690:	00001517          	auipc	a0,0x1
     694:	af850513          	addi	a0,a0,-1288 # 1188 <malloc+0x182>
     698:	00000097          	auipc	ra,0x0
     69c:	968080e7          	jalr	-1688(ra) # 0 <err>
      err("read (1)");
     6a0:	00001517          	auipc	a0,0x1
     6a4:	ca850513          	addi	a0,a0,-856 # 1348 <malloc+0x342>
     6a8:	00000097          	auipc	ra,0x0
     6ac:	958080e7          	jalr	-1704(ra) # 0 <err>
      err("file does not contain modifications");
     6b0:	00001517          	auipc	a0,0x1
     6b4:	ca850513          	addi	a0,a0,-856 # 1358 <malloc+0x352>
     6b8:	00000097          	auipc	ra,0x0
     6bc:	948080e7          	jalr	-1720(ra) # 0 <err>
    err("close");
     6c0:	00001517          	auipc	a0,0x1
     6c4:	ae850513          	addi	a0,a0,-1304 # 11a8 <malloc+0x1a2>
     6c8:	00000097          	auipc	ra,0x0
     6cc:	938080e7          	jalr	-1736(ra) # 0 <err>
    err("munmap (4)");
     6d0:	00001517          	auipc	a0,0x1
     6d4:	ce050513          	addi	a0,a0,-800 # 13b0 <malloc+0x3aa>
     6d8:	00000097          	auipc	ra,0x0
     6dc:	928080e7          	jalr	-1752(ra) # 0 <err>
    err("open mmap1");
     6e0:	00001517          	auipc	a0,0x1
     6e4:	d2050513          	addi	a0,a0,-736 # 1400 <malloc+0x3fa>
     6e8:	00000097          	auipc	ra,0x0
     6ec:	918080e7          	jalr	-1768(ra) # 0 <err>
    err("write mmap1");
     6f0:	00001517          	auipc	a0,0x1
     6f4:	d2850513          	addi	a0,a0,-728 # 1418 <malloc+0x412>
     6f8:	00000097          	auipc	ra,0x0
     6fc:	908080e7          	jalr	-1784(ra) # 0 <err>
    err("mmap mmap1");
     700:	00001517          	auipc	a0,0x1
     704:	d2850513          	addi	a0,a0,-728 # 1428 <malloc+0x422>
     708:	00000097          	auipc	ra,0x0
     70c:	8f8080e7          	jalr	-1800(ra) # 0 <err>
    err("open mmap2");
     710:	00001517          	auipc	a0,0x1
     714:	d3050513          	addi	a0,a0,-720 # 1440 <malloc+0x43a>
     718:	00000097          	auipc	ra,0x0
     71c:	8e8080e7          	jalr	-1816(ra) # 0 <err>
    err("write mmap2");
     720:	00001517          	auipc	a0,0x1
     724:	d3850513          	addi	a0,a0,-712 # 1458 <malloc+0x452>
     728:	00000097          	auipc	ra,0x0
     72c:	8d8080e7          	jalr	-1832(ra) # 0 <err>
    err("mmap mmap2");
     730:	00001517          	auipc	a0,0x1
     734:	d3850513          	addi	a0,a0,-712 # 1468 <malloc+0x462>
     738:	00000097          	auipc	ra,0x0
     73c:	8c8080e7          	jalr	-1848(ra) # 0 <err>
    err("mmap1 mismatch");
     740:	00001517          	auipc	a0,0x1
     744:	d3850513          	addi	a0,a0,-712 # 1478 <malloc+0x472>
     748:	00000097          	auipc	ra,0x0
     74c:	8b8080e7          	jalr	-1864(ra) # 0 <err>
    err("mmap2 mismatch");
     750:	00001517          	auipc	a0,0x1
     754:	d3850513          	addi	a0,a0,-712 # 1488 <malloc+0x482>
     758:	00000097          	auipc	ra,0x0
     75c:	8a8080e7          	jalr	-1880(ra) # 0 <err>
    err("mmap2 mismatch (2)");
     760:	00001517          	auipc	a0,0x1
     764:	d3850513          	addi	a0,a0,-712 # 1498 <malloc+0x492>
     768:	00000097          	auipc	ra,0x0
     76c:	898080e7          	jalr	-1896(ra) # 0 <err>

0000000000000770 <fork_test>:
// mmap a file, then fork.
// check that the child sees the mapped file.
//
void
fork_test(void)
{
     770:	7179                	addi	sp,sp,-48
     772:	f406                	sd	ra,40(sp)
     774:	f022                	sd	s0,32(sp)
     776:	ec26                	sd	s1,24(sp)
     778:	e84a                	sd	s2,16(sp)
     77a:	1800                	addi	s0,sp,48
  int fd;
  int pid;
  const char * const f = "mmap.dur";
  
  printf("fork_test starting\n");
     77c:	00001517          	auipc	a0,0x1
     780:	d6c50513          	addi	a0,a0,-660 # 14e8 <malloc+0x4e2>
     784:	00000097          	auipc	ra,0x0
     788:	7c4080e7          	jalr	1988(ra) # f48 <printf>
  testname = "fork_test";
     78c:	00001797          	auipc	a5,0x1
     790:	d7478793          	addi	a5,a5,-652 # 1500 <malloc+0x4fa>
     794:	00002717          	auipc	a4,0x2
     798:	86f73623          	sd	a5,-1940(a4) # 2000 <testname>
  
  // mmap the file twice.
  makefile(f);
     79c:	00001517          	auipc	a0,0x1
     7a0:	a3c50513          	addi	a0,a0,-1476 # 11d8 <malloc+0x1d2>
     7a4:	00000097          	auipc	ra,0x0
     7a8:	922080e7          	jalr	-1758(ra) # c6 <makefile>
  if ((fd = open(f, O_RDONLY)) == -1)
     7ac:	4581                	li	a1,0
     7ae:	00001517          	auipc	a0,0x1
     7b2:	a2a50513          	addi	a0,a0,-1494 # 11d8 <malloc+0x1d2>
     7b6:	00000097          	auipc	ra,0x0
     7ba:	44a080e7          	jalr	1098(ra) # c00 <open>
     7be:	57fd                	li	a5,-1
     7c0:	0af50a63          	beq	a0,a5,874 <fork_test+0x104>
     7c4:	84aa                	mv	s1,a0
    err("open");
  unlink(f);
     7c6:	00001517          	auipc	a0,0x1
     7ca:	a1250513          	addi	a0,a0,-1518 # 11d8 <malloc+0x1d2>
     7ce:	00000097          	auipc	ra,0x0
     7d2:	442080e7          	jalr	1090(ra) # c10 <unlink>
  char *p1 = mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
     7d6:	4781                	li	a5,0
     7d8:	8726                	mv	a4,s1
     7da:	4685                	li	a3,1
     7dc:	4605                	li	a2,1
     7de:	6589                	lui	a1,0x2
     7e0:	4501                	li	a0,0
     7e2:	00000097          	auipc	ra,0x0
     7e6:	47e080e7          	jalr	1150(ra) # c60 <mmap>
     7ea:	892a                	mv	s2,a0
  if (p1 == MAP_FAILED)
     7ec:	57fd                	li	a5,-1
     7ee:	08f50b63          	beq	a0,a5,884 <fork_test+0x114>
    err("mmap (4)");
  char *p2 = mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
     7f2:	4781                	li	a5,0
     7f4:	8726                	mv	a4,s1
     7f6:	4685                	li	a3,1
     7f8:	4605                	li	a2,1
     7fa:	6589                	lui	a1,0x2
     7fc:	4501                	li	a0,0
     7fe:	00000097          	auipc	ra,0x0
     802:	462080e7          	jalr	1122(ra) # c60 <mmap>
     806:	84aa                	mv	s1,a0
  if (p2 == MAP_FAILED)
     808:	57fd                	li	a5,-1
     80a:	08f50563          	beq	a0,a5,894 <fork_test+0x124>
    err("mmap (5)");

  // read just 2nd page.
  if(*(p1+PGSIZE) != 'A')
     80e:	6785                	lui	a5,0x1
     810:	97ca                	add	a5,a5,s2
     812:	0007c703          	lbu	a4,0(a5) # 1000 <free+0x82>
     816:	04100793          	li	a5,65
     81a:	08f71563          	bne	a4,a5,8a4 <fork_test+0x134>
    err("fork mismatch (1)");

  if((pid = fork()) < 0)
     81e:	00000097          	auipc	ra,0x0
     822:	39a080e7          	jalr	922(ra) # bb8 <fork>
     826:	08054763          	bltz	a0,8b4 <fork_test+0x144>
    err("fork");
  if (pid == 0) {
     82a:	cd49                	beqz	a0,8c4 <fork_test+0x154>
    _v1(p1);
    munmap(p1, PGSIZE); // just the first page
    exit(0); // tell the parent that the mapping looks OK.
  }

  int status = -1;
     82c:	57fd                	li	a5,-1
     82e:	fcf42e23          	sw	a5,-36(s0)
  wait(&status);
     832:	fdc40513          	addi	a0,s0,-36
     836:	00000097          	auipc	ra,0x0
     83a:	392080e7          	jalr	914(ra) # bc8 <wait>

  if(status != 0){
     83e:	fdc42783          	lw	a5,-36(s0)
     842:	e3cd                	bnez	a5,8e4 <fork_test+0x174>
    printf("fork_test failed\n");
    exit(1);
  }

  // check that the parent's mappings are still there.
  _v1(p1);
     844:	854a                	mv	a0,s2
     846:	fffff097          	auipc	ra,0xfffff
     84a:	7f8080e7          	jalr	2040(ra) # 3e <_v1>
  _v1(p2);
     84e:	8526                	mv	a0,s1
     850:	fffff097          	auipc	ra,0xfffff
     854:	7ee080e7          	jalr	2030(ra) # 3e <_v1>

  printf("fork_test OK\n");
     858:	00001517          	auipc	a0,0x1
     85c:	d1050513          	addi	a0,a0,-752 # 1568 <malloc+0x562>
     860:	00000097          	auipc	ra,0x0
     864:	6e8080e7          	jalr	1768(ra) # f48 <printf>
}
     868:	70a2                	ld	ra,40(sp)
     86a:	7402                	ld	s0,32(sp)
     86c:	64e2                	ld	s1,24(sp)
     86e:	6942                	ld	s2,16(sp)
     870:	6145                	addi	sp,sp,48
     872:	8082                	ret
    err("open");
     874:	00001517          	auipc	a0,0x1
     878:	91450513          	addi	a0,a0,-1772 # 1188 <malloc+0x182>
     87c:	fffff097          	auipc	ra,0xfffff
     880:	784080e7          	jalr	1924(ra) # 0 <err>
    err("mmap (4)");
     884:	00001517          	auipc	a0,0x1
     888:	c8c50513          	addi	a0,a0,-884 # 1510 <malloc+0x50a>
     88c:	fffff097          	auipc	ra,0xfffff
     890:	774080e7          	jalr	1908(ra) # 0 <err>
    err("mmap (5)");
     894:	00001517          	auipc	a0,0x1
     898:	c8c50513          	addi	a0,a0,-884 # 1520 <malloc+0x51a>
     89c:	fffff097          	auipc	ra,0xfffff
     8a0:	764080e7          	jalr	1892(ra) # 0 <err>
    err("fork mismatch (1)");
     8a4:	00001517          	auipc	a0,0x1
     8a8:	c8c50513          	addi	a0,a0,-884 # 1530 <malloc+0x52a>
     8ac:	fffff097          	auipc	ra,0xfffff
     8b0:	754080e7          	jalr	1876(ra) # 0 <err>
    err("fork");
     8b4:	00001517          	auipc	a0,0x1
     8b8:	c9450513          	addi	a0,a0,-876 # 1548 <malloc+0x542>
     8bc:	fffff097          	auipc	ra,0xfffff
     8c0:	744080e7          	jalr	1860(ra) # 0 <err>
    _v1(p1);
     8c4:	854a                	mv	a0,s2
     8c6:	fffff097          	auipc	ra,0xfffff
     8ca:	778080e7          	jalr	1912(ra) # 3e <_v1>
    munmap(p1, PGSIZE); // just the first page
     8ce:	6585                	lui	a1,0x1
     8d0:	854a                	mv	a0,s2
     8d2:	00000097          	auipc	ra,0x0
     8d6:	396080e7          	jalr	918(ra) # c68 <munmap>
    exit(0); // tell the parent that the mapping looks OK.
     8da:	4501                	li	a0,0
     8dc:	00000097          	auipc	ra,0x0
     8e0:	2e4080e7          	jalr	740(ra) # bc0 <exit>
    printf("fork_test failed\n");
     8e4:	00001517          	auipc	a0,0x1
     8e8:	c6c50513          	addi	a0,a0,-916 # 1550 <malloc+0x54a>
     8ec:	00000097          	auipc	ra,0x0
     8f0:	65c080e7          	jalr	1628(ra) # f48 <printf>
    exit(1);
     8f4:	4505                	li	a0,1
     8f6:	00000097          	auipc	ra,0x0
     8fa:	2ca080e7          	jalr	714(ra) # bc0 <exit>

00000000000008fe <main>:
{
     8fe:	1141                	addi	sp,sp,-16
     900:	e406                	sd	ra,8(sp)
     902:	e022                	sd	s0,0(sp)
     904:	0800                	addi	s0,sp,16
  mmap_test();
     906:	00000097          	auipc	ra,0x0
     90a:	87a080e7          	jalr	-1926(ra) # 180 <mmap_test>
  fork_test();
     90e:	00000097          	auipc	ra,0x0
     912:	e62080e7          	jalr	-414(ra) # 770 <fork_test>
  printf("mmaptest: all tests succeeded\n");
     916:	00001517          	auipc	a0,0x1
     91a:	c6250513          	addi	a0,a0,-926 # 1578 <malloc+0x572>
     91e:	00000097          	auipc	ra,0x0
     922:	62a080e7          	jalr	1578(ra) # f48 <printf>
  exit(0);
     926:	4501                	li	a0,0
     928:	00000097          	auipc	ra,0x0
     92c:	298080e7          	jalr	664(ra) # bc0 <exit>

0000000000000930 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     930:	1141                	addi	sp,sp,-16
     932:	e406                	sd	ra,8(sp)
     934:	e022                	sd	s0,0(sp)
     936:	0800                	addi	s0,sp,16
  extern int main();
  main();
     938:	00000097          	auipc	ra,0x0
     93c:	fc6080e7          	jalr	-58(ra) # 8fe <main>
  exit(0);
     940:	4501                	li	a0,0
     942:	00000097          	auipc	ra,0x0
     946:	27e080e7          	jalr	638(ra) # bc0 <exit>

000000000000094a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     94a:	1141                	addi	sp,sp,-16
     94c:	e422                	sd	s0,8(sp)
     94e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     950:	87aa                	mv	a5,a0
     952:	0585                	addi	a1,a1,1
     954:	0785                	addi	a5,a5,1
     956:	fff5c703          	lbu	a4,-1(a1) # fff <free+0x81>
     95a:	fee78fa3          	sb	a4,-1(a5)
     95e:	fb75                	bnez	a4,952 <strcpy+0x8>
    ;
  return os;
}
     960:	6422                	ld	s0,8(sp)
     962:	0141                	addi	sp,sp,16
     964:	8082                	ret

0000000000000966 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     966:	1141                	addi	sp,sp,-16
     968:	e422                	sd	s0,8(sp)
     96a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     96c:	00054783          	lbu	a5,0(a0)
     970:	cb91                	beqz	a5,984 <strcmp+0x1e>
     972:	0005c703          	lbu	a4,0(a1)
     976:	00f71763          	bne	a4,a5,984 <strcmp+0x1e>
    p++, q++;
     97a:	0505                	addi	a0,a0,1
     97c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     97e:	00054783          	lbu	a5,0(a0)
     982:	fbe5                	bnez	a5,972 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     984:	0005c503          	lbu	a0,0(a1)
}
     988:	40a7853b          	subw	a0,a5,a0
     98c:	6422                	ld	s0,8(sp)
     98e:	0141                	addi	sp,sp,16
     990:	8082                	ret

0000000000000992 <strlen>:

uint
strlen(const char *s)
{
     992:	1141                	addi	sp,sp,-16
     994:	e422                	sd	s0,8(sp)
     996:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     998:	00054783          	lbu	a5,0(a0)
     99c:	cf91                	beqz	a5,9b8 <strlen+0x26>
     99e:	0505                	addi	a0,a0,1
     9a0:	87aa                	mv	a5,a0
     9a2:	4685                	li	a3,1
     9a4:	9e89                	subw	a3,a3,a0
     9a6:	00f6853b          	addw	a0,a3,a5
     9aa:	0785                	addi	a5,a5,1
     9ac:	fff7c703          	lbu	a4,-1(a5)
     9b0:	fb7d                	bnez	a4,9a6 <strlen+0x14>
    ;
  return n;
}
     9b2:	6422                	ld	s0,8(sp)
     9b4:	0141                	addi	sp,sp,16
     9b6:	8082                	ret
  for(n = 0; s[n]; n++)
     9b8:	4501                	li	a0,0
     9ba:	bfe5                	j	9b2 <strlen+0x20>

00000000000009bc <memset>:

void*
memset(void *dst, int c, uint n)
{
     9bc:	1141                	addi	sp,sp,-16
     9be:	e422                	sd	s0,8(sp)
     9c0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     9c2:	ce09                	beqz	a2,9dc <memset+0x20>
     9c4:	87aa                	mv	a5,a0
     9c6:	fff6071b          	addiw	a4,a2,-1
     9ca:	1702                	slli	a4,a4,0x20
     9cc:	9301                	srli	a4,a4,0x20
     9ce:	0705                	addi	a4,a4,1
     9d0:	972a                	add	a4,a4,a0
    cdst[i] = c;
     9d2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     9d6:	0785                	addi	a5,a5,1
     9d8:	fee79de3          	bne	a5,a4,9d2 <memset+0x16>
  }
  return dst;
}
     9dc:	6422                	ld	s0,8(sp)
     9de:	0141                	addi	sp,sp,16
     9e0:	8082                	ret

00000000000009e2 <strchr>:

char*
strchr(const char *s, char c)
{
     9e2:	1141                	addi	sp,sp,-16
     9e4:	e422                	sd	s0,8(sp)
     9e6:	0800                	addi	s0,sp,16
  for(; *s; s++)
     9e8:	00054783          	lbu	a5,0(a0)
     9ec:	cb99                	beqz	a5,a02 <strchr+0x20>
    if(*s == c)
     9ee:	00f58763          	beq	a1,a5,9fc <strchr+0x1a>
  for(; *s; s++)
     9f2:	0505                	addi	a0,a0,1
     9f4:	00054783          	lbu	a5,0(a0)
     9f8:	fbfd                	bnez	a5,9ee <strchr+0xc>
      return (char*)s;
  return 0;
     9fa:	4501                	li	a0,0
}
     9fc:	6422                	ld	s0,8(sp)
     9fe:	0141                	addi	sp,sp,16
     a00:	8082                	ret
  return 0;
     a02:	4501                	li	a0,0
     a04:	bfe5                	j	9fc <strchr+0x1a>

0000000000000a06 <gets>:

char*
gets(char *buf, int max)
{
     a06:	711d                	addi	sp,sp,-96
     a08:	ec86                	sd	ra,88(sp)
     a0a:	e8a2                	sd	s0,80(sp)
     a0c:	e4a6                	sd	s1,72(sp)
     a0e:	e0ca                	sd	s2,64(sp)
     a10:	fc4e                	sd	s3,56(sp)
     a12:	f852                	sd	s4,48(sp)
     a14:	f456                	sd	s5,40(sp)
     a16:	f05a                	sd	s6,32(sp)
     a18:	ec5e                	sd	s7,24(sp)
     a1a:	1080                	addi	s0,sp,96
     a1c:	8baa                	mv	s7,a0
     a1e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a20:	892a                	mv	s2,a0
     a22:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a24:	4aa9                	li	s5,10
     a26:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     a28:	89a6                	mv	s3,s1
     a2a:	2485                	addiw	s1,s1,1
     a2c:	0344d863          	bge	s1,s4,a5c <gets+0x56>
    cc = read(0, &c, 1);
     a30:	4605                	li	a2,1
     a32:	faf40593          	addi	a1,s0,-81
     a36:	4501                	li	a0,0
     a38:	00000097          	auipc	ra,0x0
     a3c:	1a0080e7          	jalr	416(ra) # bd8 <read>
    if(cc < 1)
     a40:	00a05e63          	blez	a0,a5c <gets+0x56>
    buf[i++] = c;
     a44:	faf44783          	lbu	a5,-81(s0)
     a48:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     a4c:	01578763          	beq	a5,s5,a5a <gets+0x54>
     a50:	0905                	addi	s2,s2,1
     a52:	fd679be3          	bne	a5,s6,a28 <gets+0x22>
  for(i=0; i+1 < max; ){
     a56:	89a6                	mv	s3,s1
     a58:	a011                	j	a5c <gets+0x56>
     a5a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     a5c:	99de                	add	s3,s3,s7
     a5e:	00098023          	sb	zero,0(s3)
  return buf;
}
     a62:	855e                	mv	a0,s7
     a64:	60e6                	ld	ra,88(sp)
     a66:	6446                	ld	s0,80(sp)
     a68:	64a6                	ld	s1,72(sp)
     a6a:	6906                	ld	s2,64(sp)
     a6c:	79e2                	ld	s3,56(sp)
     a6e:	7a42                	ld	s4,48(sp)
     a70:	7aa2                	ld	s5,40(sp)
     a72:	7b02                	ld	s6,32(sp)
     a74:	6be2                	ld	s7,24(sp)
     a76:	6125                	addi	sp,sp,96
     a78:	8082                	ret

0000000000000a7a <stat>:

int
stat(const char *n, struct stat *st)
{
     a7a:	1101                	addi	sp,sp,-32
     a7c:	ec06                	sd	ra,24(sp)
     a7e:	e822                	sd	s0,16(sp)
     a80:	e426                	sd	s1,8(sp)
     a82:	e04a                	sd	s2,0(sp)
     a84:	1000                	addi	s0,sp,32
     a86:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a88:	4581                	li	a1,0
     a8a:	00000097          	auipc	ra,0x0
     a8e:	176080e7          	jalr	374(ra) # c00 <open>
  if(fd < 0)
     a92:	02054563          	bltz	a0,abc <stat+0x42>
     a96:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a98:	85ca                	mv	a1,s2
     a9a:	00000097          	auipc	ra,0x0
     a9e:	17e080e7          	jalr	382(ra) # c18 <fstat>
     aa2:	892a                	mv	s2,a0
  close(fd);
     aa4:	8526                	mv	a0,s1
     aa6:	00000097          	auipc	ra,0x0
     aaa:	142080e7          	jalr	322(ra) # be8 <close>
  return r;
}
     aae:	854a                	mv	a0,s2
     ab0:	60e2                	ld	ra,24(sp)
     ab2:	6442                	ld	s0,16(sp)
     ab4:	64a2                	ld	s1,8(sp)
     ab6:	6902                	ld	s2,0(sp)
     ab8:	6105                	addi	sp,sp,32
     aba:	8082                	ret
    return -1;
     abc:	597d                	li	s2,-1
     abe:	bfc5                	j	aae <stat+0x34>

0000000000000ac0 <atoi>:

int
atoi(const char *s)
{
     ac0:	1141                	addi	sp,sp,-16
     ac2:	e422                	sd	s0,8(sp)
     ac4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     ac6:	00054603          	lbu	a2,0(a0)
     aca:	fd06079b          	addiw	a5,a2,-48
     ace:	0ff7f793          	andi	a5,a5,255
     ad2:	4725                	li	a4,9
     ad4:	02f76963          	bltu	a4,a5,b06 <atoi+0x46>
     ad8:	86aa                	mv	a3,a0
  n = 0;
     ada:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     adc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     ade:	0685                	addi	a3,a3,1
     ae0:	0025179b          	slliw	a5,a0,0x2
     ae4:	9fa9                	addw	a5,a5,a0
     ae6:	0017979b          	slliw	a5,a5,0x1
     aea:	9fb1                	addw	a5,a5,a2
     aec:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     af0:	0006c603          	lbu	a2,0(a3)
     af4:	fd06071b          	addiw	a4,a2,-48
     af8:	0ff77713          	andi	a4,a4,255
     afc:	fee5f1e3          	bgeu	a1,a4,ade <atoi+0x1e>
  return n;
}
     b00:	6422                	ld	s0,8(sp)
     b02:	0141                	addi	sp,sp,16
     b04:	8082                	ret
  n = 0;
     b06:	4501                	li	a0,0
     b08:	bfe5                	j	b00 <atoi+0x40>

0000000000000b0a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b0a:	1141                	addi	sp,sp,-16
     b0c:	e422                	sd	s0,8(sp)
     b0e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b10:	02b57663          	bgeu	a0,a1,b3c <memmove+0x32>
    while(n-- > 0)
     b14:	02c05163          	blez	a2,b36 <memmove+0x2c>
     b18:	fff6079b          	addiw	a5,a2,-1
     b1c:	1782                	slli	a5,a5,0x20
     b1e:	9381                	srli	a5,a5,0x20
     b20:	0785                	addi	a5,a5,1
     b22:	97aa                	add	a5,a5,a0
  dst = vdst;
     b24:	872a                	mv	a4,a0
      *dst++ = *src++;
     b26:	0585                	addi	a1,a1,1
     b28:	0705                	addi	a4,a4,1
     b2a:	fff5c683          	lbu	a3,-1(a1)
     b2e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b32:	fee79ae3          	bne	a5,a4,b26 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b36:	6422                	ld	s0,8(sp)
     b38:	0141                	addi	sp,sp,16
     b3a:	8082                	ret
    dst += n;
     b3c:	00c50733          	add	a4,a0,a2
    src += n;
     b40:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b42:	fec05ae3          	blez	a2,b36 <memmove+0x2c>
     b46:	fff6079b          	addiw	a5,a2,-1
     b4a:	1782                	slli	a5,a5,0x20
     b4c:	9381                	srli	a5,a5,0x20
     b4e:	fff7c793          	not	a5,a5
     b52:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b54:	15fd                	addi	a1,a1,-1
     b56:	177d                	addi	a4,a4,-1
     b58:	0005c683          	lbu	a3,0(a1)
     b5c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b60:	fee79ae3          	bne	a5,a4,b54 <memmove+0x4a>
     b64:	bfc9                	j	b36 <memmove+0x2c>

0000000000000b66 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b66:	1141                	addi	sp,sp,-16
     b68:	e422                	sd	s0,8(sp)
     b6a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     b6c:	ca05                	beqz	a2,b9c <memcmp+0x36>
     b6e:	fff6069b          	addiw	a3,a2,-1
     b72:	1682                	slli	a3,a3,0x20
     b74:	9281                	srli	a3,a3,0x20
     b76:	0685                	addi	a3,a3,1
     b78:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b7a:	00054783          	lbu	a5,0(a0)
     b7e:	0005c703          	lbu	a4,0(a1)
     b82:	00e79863          	bne	a5,a4,b92 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b86:	0505                	addi	a0,a0,1
    p2++;
     b88:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b8a:	fed518e3          	bne	a0,a3,b7a <memcmp+0x14>
  }
  return 0;
     b8e:	4501                	li	a0,0
     b90:	a019                	j	b96 <memcmp+0x30>
      return *p1 - *p2;
     b92:	40e7853b          	subw	a0,a5,a4
}
     b96:	6422                	ld	s0,8(sp)
     b98:	0141                	addi	sp,sp,16
     b9a:	8082                	ret
  return 0;
     b9c:	4501                	li	a0,0
     b9e:	bfe5                	j	b96 <memcmp+0x30>

0000000000000ba0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     ba0:	1141                	addi	sp,sp,-16
     ba2:	e406                	sd	ra,8(sp)
     ba4:	e022                	sd	s0,0(sp)
     ba6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     ba8:	00000097          	auipc	ra,0x0
     bac:	f62080e7          	jalr	-158(ra) # b0a <memmove>
}
     bb0:	60a2                	ld	ra,8(sp)
     bb2:	6402                	ld	s0,0(sp)
     bb4:	0141                	addi	sp,sp,16
     bb6:	8082                	ret

0000000000000bb8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     bb8:	4885                	li	a7,1
 ecall
     bba:	00000073          	ecall
 ret
     bbe:	8082                	ret

0000000000000bc0 <exit>:
.global exit
exit:
 li a7, SYS_exit
     bc0:	4889                	li	a7,2
 ecall
     bc2:	00000073          	ecall
 ret
     bc6:	8082                	ret

0000000000000bc8 <wait>:
.global wait
wait:
 li a7, SYS_wait
     bc8:	488d                	li	a7,3
 ecall
     bca:	00000073          	ecall
 ret
     bce:	8082                	ret

0000000000000bd0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     bd0:	4891                	li	a7,4
 ecall
     bd2:	00000073          	ecall
 ret
     bd6:	8082                	ret

0000000000000bd8 <read>:
.global read
read:
 li a7, SYS_read
     bd8:	4895                	li	a7,5
 ecall
     bda:	00000073          	ecall
 ret
     bde:	8082                	ret

0000000000000be0 <write>:
.global write
write:
 li a7, SYS_write
     be0:	48c1                	li	a7,16
 ecall
     be2:	00000073          	ecall
 ret
     be6:	8082                	ret

0000000000000be8 <close>:
.global close
close:
 li a7, SYS_close
     be8:	48d5                	li	a7,21
 ecall
     bea:	00000073          	ecall
 ret
     bee:	8082                	ret

0000000000000bf0 <kill>:
.global kill
kill:
 li a7, SYS_kill
     bf0:	4899                	li	a7,6
 ecall
     bf2:	00000073          	ecall
 ret
     bf6:	8082                	ret

0000000000000bf8 <exec>:
.global exec
exec:
 li a7, SYS_exec
     bf8:	489d                	li	a7,7
 ecall
     bfa:	00000073          	ecall
 ret
     bfe:	8082                	ret

0000000000000c00 <open>:
.global open
open:
 li a7, SYS_open
     c00:	48bd                	li	a7,15
 ecall
     c02:	00000073          	ecall
 ret
     c06:	8082                	ret

0000000000000c08 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c08:	48c5                	li	a7,17
 ecall
     c0a:	00000073          	ecall
 ret
     c0e:	8082                	ret

0000000000000c10 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c10:	48c9                	li	a7,18
 ecall
     c12:	00000073          	ecall
 ret
     c16:	8082                	ret

0000000000000c18 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c18:	48a1                	li	a7,8
 ecall
     c1a:	00000073          	ecall
 ret
     c1e:	8082                	ret

0000000000000c20 <link>:
.global link
link:
 li a7, SYS_link
     c20:	48cd                	li	a7,19
 ecall
     c22:	00000073          	ecall
 ret
     c26:	8082                	ret

0000000000000c28 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c28:	48d1                	li	a7,20
 ecall
     c2a:	00000073          	ecall
 ret
     c2e:	8082                	ret

0000000000000c30 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c30:	48a5                	li	a7,9
 ecall
     c32:	00000073          	ecall
 ret
     c36:	8082                	ret

0000000000000c38 <dup>:
.global dup
dup:
 li a7, SYS_dup
     c38:	48a9                	li	a7,10
 ecall
     c3a:	00000073          	ecall
 ret
     c3e:	8082                	ret

0000000000000c40 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c40:	48ad                	li	a7,11
 ecall
     c42:	00000073          	ecall
 ret
     c46:	8082                	ret

0000000000000c48 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c48:	48b1                	li	a7,12
 ecall
     c4a:	00000073          	ecall
 ret
     c4e:	8082                	ret

0000000000000c50 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c50:	48b5                	li	a7,13
 ecall
     c52:	00000073          	ecall
 ret
     c56:	8082                	ret

0000000000000c58 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c58:	48b9                	li	a7,14
 ecall
     c5a:	00000073          	ecall
 ret
     c5e:	8082                	ret

0000000000000c60 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
     c60:	48d9                	li	a7,22
 ecall
     c62:	00000073          	ecall
 ret
     c66:	8082                	ret

0000000000000c68 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
     c68:	48dd                	li	a7,23
 ecall
     c6a:	00000073          	ecall
 ret
     c6e:	8082                	ret

0000000000000c70 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c70:	1101                	addi	sp,sp,-32
     c72:	ec06                	sd	ra,24(sp)
     c74:	e822                	sd	s0,16(sp)
     c76:	1000                	addi	s0,sp,32
     c78:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c7c:	4605                	li	a2,1
     c7e:	fef40593          	addi	a1,s0,-17
     c82:	00000097          	auipc	ra,0x0
     c86:	f5e080e7          	jalr	-162(ra) # be0 <write>
}
     c8a:	60e2                	ld	ra,24(sp)
     c8c:	6442                	ld	s0,16(sp)
     c8e:	6105                	addi	sp,sp,32
     c90:	8082                	ret

0000000000000c92 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c92:	7139                	addi	sp,sp,-64
     c94:	fc06                	sd	ra,56(sp)
     c96:	f822                	sd	s0,48(sp)
     c98:	f426                	sd	s1,40(sp)
     c9a:	f04a                	sd	s2,32(sp)
     c9c:	ec4e                	sd	s3,24(sp)
     c9e:	0080                	addi	s0,sp,64
     ca0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ca2:	c299                	beqz	a3,ca8 <printint+0x16>
     ca4:	0805c863          	bltz	a1,d34 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     ca8:	2581                	sext.w	a1,a1
  neg = 0;
     caa:	4881                	li	a7,0
     cac:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     cb0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     cb2:	2601                	sext.w	a2,a2
     cb4:	00001517          	auipc	a0,0x1
     cb8:	8f450513          	addi	a0,a0,-1804 # 15a8 <digits>
     cbc:	883a                	mv	a6,a4
     cbe:	2705                	addiw	a4,a4,1
     cc0:	02c5f7bb          	remuw	a5,a1,a2
     cc4:	1782                	slli	a5,a5,0x20
     cc6:	9381                	srli	a5,a5,0x20
     cc8:	97aa                	add	a5,a5,a0
     cca:	0007c783          	lbu	a5,0(a5)
     cce:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     cd2:	0005879b          	sext.w	a5,a1
     cd6:	02c5d5bb          	divuw	a1,a1,a2
     cda:	0685                	addi	a3,a3,1
     cdc:	fec7f0e3          	bgeu	a5,a2,cbc <printint+0x2a>
  if(neg)
     ce0:	00088b63          	beqz	a7,cf6 <printint+0x64>
    buf[i++] = '-';
     ce4:	fd040793          	addi	a5,s0,-48
     ce8:	973e                	add	a4,a4,a5
     cea:	02d00793          	li	a5,45
     cee:	fef70823          	sb	a5,-16(a4)
     cf2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     cf6:	02e05863          	blez	a4,d26 <printint+0x94>
     cfa:	fc040793          	addi	a5,s0,-64
     cfe:	00e78933          	add	s2,a5,a4
     d02:	fff78993          	addi	s3,a5,-1
     d06:	99ba                	add	s3,s3,a4
     d08:	377d                	addiw	a4,a4,-1
     d0a:	1702                	slli	a4,a4,0x20
     d0c:	9301                	srli	a4,a4,0x20
     d0e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d12:	fff94583          	lbu	a1,-1(s2)
     d16:	8526                	mv	a0,s1
     d18:	00000097          	auipc	ra,0x0
     d1c:	f58080e7          	jalr	-168(ra) # c70 <putc>
  while(--i >= 0)
     d20:	197d                	addi	s2,s2,-1
     d22:	ff3918e3          	bne	s2,s3,d12 <printint+0x80>
}
     d26:	70e2                	ld	ra,56(sp)
     d28:	7442                	ld	s0,48(sp)
     d2a:	74a2                	ld	s1,40(sp)
     d2c:	7902                	ld	s2,32(sp)
     d2e:	69e2                	ld	s3,24(sp)
     d30:	6121                	addi	sp,sp,64
     d32:	8082                	ret
    x = -xx;
     d34:	40b005bb          	negw	a1,a1
    neg = 1;
     d38:	4885                	li	a7,1
    x = -xx;
     d3a:	bf8d                	j	cac <printint+0x1a>

0000000000000d3c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d3c:	7119                	addi	sp,sp,-128
     d3e:	fc86                	sd	ra,120(sp)
     d40:	f8a2                	sd	s0,112(sp)
     d42:	f4a6                	sd	s1,104(sp)
     d44:	f0ca                	sd	s2,96(sp)
     d46:	ecce                	sd	s3,88(sp)
     d48:	e8d2                	sd	s4,80(sp)
     d4a:	e4d6                	sd	s5,72(sp)
     d4c:	e0da                	sd	s6,64(sp)
     d4e:	fc5e                	sd	s7,56(sp)
     d50:	f862                	sd	s8,48(sp)
     d52:	f466                	sd	s9,40(sp)
     d54:	f06a                	sd	s10,32(sp)
     d56:	ec6e                	sd	s11,24(sp)
     d58:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d5a:	0005c903          	lbu	s2,0(a1)
     d5e:	18090f63          	beqz	s2,efc <vprintf+0x1c0>
     d62:	8aaa                	mv	s5,a0
     d64:	8b32                	mv	s6,a2
     d66:	00158493          	addi	s1,a1,1
  state = 0;
     d6a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     d6c:	02500a13          	li	s4,37
      if(c == 'd'){
     d70:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     d74:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     d78:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     d7c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d80:	00001b97          	auipc	s7,0x1
     d84:	828b8b93          	addi	s7,s7,-2008 # 15a8 <digits>
     d88:	a839                	j	da6 <vprintf+0x6a>
        putc(fd, c);
     d8a:	85ca                	mv	a1,s2
     d8c:	8556                	mv	a0,s5
     d8e:	00000097          	auipc	ra,0x0
     d92:	ee2080e7          	jalr	-286(ra) # c70 <putc>
     d96:	a019                	j	d9c <vprintf+0x60>
    } else if(state == '%'){
     d98:	01498f63          	beq	s3,s4,db6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     d9c:	0485                	addi	s1,s1,1
     d9e:	fff4c903          	lbu	s2,-1(s1)
     da2:	14090d63          	beqz	s2,efc <vprintf+0x1c0>
    c = fmt[i] & 0xff;
     da6:	0009079b          	sext.w	a5,s2
    if(state == 0){
     daa:	fe0997e3          	bnez	s3,d98 <vprintf+0x5c>
      if(c == '%'){
     dae:	fd479ee3          	bne	a5,s4,d8a <vprintf+0x4e>
        state = '%';
     db2:	89be                	mv	s3,a5
     db4:	b7e5                	j	d9c <vprintf+0x60>
      if(c == 'd'){
     db6:	05878063          	beq	a5,s8,df6 <vprintf+0xba>
      } else if(c == 'l') {
     dba:	05978c63          	beq	a5,s9,e12 <vprintf+0xd6>
      } else if(c == 'x') {
     dbe:	07a78863          	beq	a5,s10,e2e <vprintf+0xf2>
      } else if(c == 'p') {
     dc2:	09b78463          	beq	a5,s11,e4a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
     dc6:	07300713          	li	a4,115
     dca:	0ce78663          	beq	a5,a4,e96 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     dce:	06300713          	li	a4,99
     dd2:	0ee78e63          	beq	a5,a4,ece <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
     dd6:	11478863          	beq	a5,s4,ee6 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     dda:	85d2                	mv	a1,s4
     ddc:	8556                	mv	a0,s5
     dde:	00000097          	auipc	ra,0x0
     de2:	e92080e7          	jalr	-366(ra) # c70 <putc>
        putc(fd, c);
     de6:	85ca                	mv	a1,s2
     de8:	8556                	mv	a0,s5
     dea:	00000097          	auipc	ra,0x0
     dee:	e86080e7          	jalr	-378(ra) # c70 <putc>
      }
      state = 0;
     df2:	4981                	li	s3,0
     df4:	b765                	j	d9c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
     df6:	008b0913          	addi	s2,s6,8
     dfa:	4685                	li	a3,1
     dfc:	4629                	li	a2,10
     dfe:	000b2583          	lw	a1,0(s6)
     e02:	8556                	mv	a0,s5
     e04:	00000097          	auipc	ra,0x0
     e08:	e8e080e7          	jalr	-370(ra) # c92 <printint>
     e0c:	8b4a                	mv	s6,s2
      state = 0;
     e0e:	4981                	li	s3,0
     e10:	b771                	j	d9c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e12:	008b0913          	addi	s2,s6,8
     e16:	4681                	li	a3,0
     e18:	4629                	li	a2,10
     e1a:	000b2583          	lw	a1,0(s6)
     e1e:	8556                	mv	a0,s5
     e20:	00000097          	auipc	ra,0x0
     e24:	e72080e7          	jalr	-398(ra) # c92 <printint>
     e28:	8b4a                	mv	s6,s2
      state = 0;
     e2a:	4981                	li	s3,0
     e2c:	bf85                	j	d9c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     e2e:	008b0913          	addi	s2,s6,8
     e32:	4681                	li	a3,0
     e34:	4641                	li	a2,16
     e36:	000b2583          	lw	a1,0(s6)
     e3a:	8556                	mv	a0,s5
     e3c:	00000097          	auipc	ra,0x0
     e40:	e56080e7          	jalr	-426(ra) # c92 <printint>
     e44:	8b4a                	mv	s6,s2
      state = 0;
     e46:	4981                	li	s3,0
     e48:	bf91                	j	d9c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     e4a:	008b0793          	addi	a5,s6,8
     e4e:	f8f43423          	sd	a5,-120(s0)
     e52:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     e56:	03000593          	li	a1,48
     e5a:	8556                	mv	a0,s5
     e5c:	00000097          	auipc	ra,0x0
     e60:	e14080e7          	jalr	-492(ra) # c70 <putc>
  putc(fd, 'x');
     e64:	85ea                	mv	a1,s10
     e66:	8556                	mv	a0,s5
     e68:	00000097          	auipc	ra,0x0
     e6c:	e08080e7          	jalr	-504(ra) # c70 <putc>
     e70:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e72:	03c9d793          	srli	a5,s3,0x3c
     e76:	97de                	add	a5,a5,s7
     e78:	0007c583          	lbu	a1,0(a5)
     e7c:	8556                	mv	a0,s5
     e7e:	00000097          	auipc	ra,0x0
     e82:	df2080e7          	jalr	-526(ra) # c70 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e86:	0992                	slli	s3,s3,0x4
     e88:	397d                	addiw	s2,s2,-1
     e8a:	fe0914e3          	bnez	s2,e72 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
     e8e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     e92:	4981                	li	s3,0
     e94:	b721                	j	d9c <vprintf+0x60>
        s = va_arg(ap, char*);
     e96:	008b0993          	addi	s3,s6,8
     e9a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
     e9e:	02090163          	beqz	s2,ec0 <vprintf+0x184>
        while(*s != 0){
     ea2:	00094583          	lbu	a1,0(s2)
     ea6:	c9a1                	beqz	a1,ef6 <vprintf+0x1ba>
          putc(fd, *s);
     ea8:	8556                	mv	a0,s5
     eaa:	00000097          	auipc	ra,0x0
     eae:	dc6080e7          	jalr	-570(ra) # c70 <putc>
          s++;
     eb2:	0905                	addi	s2,s2,1
        while(*s != 0){
     eb4:	00094583          	lbu	a1,0(s2)
     eb8:	f9e5                	bnez	a1,ea8 <vprintf+0x16c>
        s = va_arg(ap, char*);
     eba:	8b4e                	mv	s6,s3
      state = 0;
     ebc:	4981                	li	s3,0
     ebe:	bdf9                	j	d9c <vprintf+0x60>
          s = "(null)";
     ec0:	00000917          	auipc	s2,0x0
     ec4:	6e090913          	addi	s2,s2,1760 # 15a0 <malloc+0x59a>
        while(*s != 0){
     ec8:	02800593          	li	a1,40
     ecc:	bff1                	j	ea8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
     ece:	008b0913          	addi	s2,s6,8
     ed2:	000b4583          	lbu	a1,0(s6)
     ed6:	8556                	mv	a0,s5
     ed8:	00000097          	auipc	ra,0x0
     edc:	d98080e7          	jalr	-616(ra) # c70 <putc>
     ee0:	8b4a                	mv	s6,s2
      state = 0;
     ee2:	4981                	li	s3,0
     ee4:	bd65                	j	d9c <vprintf+0x60>
        putc(fd, c);
     ee6:	85d2                	mv	a1,s4
     ee8:	8556                	mv	a0,s5
     eea:	00000097          	auipc	ra,0x0
     eee:	d86080e7          	jalr	-634(ra) # c70 <putc>
      state = 0;
     ef2:	4981                	li	s3,0
     ef4:	b565                	j	d9c <vprintf+0x60>
        s = va_arg(ap, char*);
     ef6:	8b4e                	mv	s6,s3
      state = 0;
     ef8:	4981                	li	s3,0
     efa:	b54d                	j	d9c <vprintf+0x60>
    }
  }
}
     efc:	70e6                	ld	ra,120(sp)
     efe:	7446                	ld	s0,112(sp)
     f00:	74a6                	ld	s1,104(sp)
     f02:	7906                	ld	s2,96(sp)
     f04:	69e6                	ld	s3,88(sp)
     f06:	6a46                	ld	s4,80(sp)
     f08:	6aa6                	ld	s5,72(sp)
     f0a:	6b06                	ld	s6,64(sp)
     f0c:	7be2                	ld	s7,56(sp)
     f0e:	7c42                	ld	s8,48(sp)
     f10:	7ca2                	ld	s9,40(sp)
     f12:	7d02                	ld	s10,32(sp)
     f14:	6de2                	ld	s11,24(sp)
     f16:	6109                	addi	sp,sp,128
     f18:	8082                	ret

0000000000000f1a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     f1a:	715d                	addi	sp,sp,-80
     f1c:	ec06                	sd	ra,24(sp)
     f1e:	e822                	sd	s0,16(sp)
     f20:	1000                	addi	s0,sp,32
     f22:	e010                	sd	a2,0(s0)
     f24:	e414                	sd	a3,8(s0)
     f26:	e818                	sd	a4,16(s0)
     f28:	ec1c                	sd	a5,24(s0)
     f2a:	03043023          	sd	a6,32(s0)
     f2e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     f32:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     f36:	8622                	mv	a2,s0
     f38:	00000097          	auipc	ra,0x0
     f3c:	e04080e7          	jalr	-508(ra) # d3c <vprintf>
}
     f40:	60e2                	ld	ra,24(sp)
     f42:	6442                	ld	s0,16(sp)
     f44:	6161                	addi	sp,sp,80
     f46:	8082                	ret

0000000000000f48 <printf>:

void
printf(const char *fmt, ...)
{
     f48:	711d                	addi	sp,sp,-96
     f4a:	ec06                	sd	ra,24(sp)
     f4c:	e822                	sd	s0,16(sp)
     f4e:	1000                	addi	s0,sp,32
     f50:	e40c                	sd	a1,8(s0)
     f52:	e810                	sd	a2,16(s0)
     f54:	ec14                	sd	a3,24(s0)
     f56:	f018                	sd	a4,32(s0)
     f58:	f41c                	sd	a5,40(s0)
     f5a:	03043823          	sd	a6,48(s0)
     f5e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     f62:	00840613          	addi	a2,s0,8
     f66:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     f6a:	85aa                	mv	a1,a0
     f6c:	4505                	li	a0,1
     f6e:	00000097          	auipc	ra,0x0
     f72:	dce080e7          	jalr	-562(ra) # d3c <vprintf>
}
     f76:	60e2                	ld	ra,24(sp)
     f78:	6442                	ld	s0,16(sp)
     f7a:	6125                	addi	sp,sp,96
     f7c:	8082                	ret

0000000000000f7e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     f7e:	1141                	addi	sp,sp,-16
     f80:	e422                	sd	s0,8(sp)
     f82:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f84:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f88:	00001797          	auipc	a5,0x1
     f8c:	0887b783          	ld	a5,136(a5) # 2010 <freep>
     f90:	a805                	j	fc0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     f92:	4618                	lw	a4,8(a2)
     f94:	9db9                	addw	a1,a1,a4
     f96:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     f9a:	6398                	ld	a4,0(a5)
     f9c:	6318                	ld	a4,0(a4)
     f9e:	fee53823          	sd	a4,-16(a0)
     fa2:	a091                	j	fe6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     fa4:	ff852703          	lw	a4,-8(a0)
     fa8:	9e39                	addw	a2,a2,a4
     faa:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
     fac:	ff053703          	ld	a4,-16(a0)
     fb0:	e398                	sd	a4,0(a5)
     fb2:	a099                	j	ff8 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     fb4:	6398                	ld	a4,0(a5)
     fb6:	00e7e463          	bltu	a5,a4,fbe <free+0x40>
     fba:	00e6ea63          	bltu	a3,a4,fce <free+0x50>
{
     fbe:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     fc0:	fed7fae3          	bgeu	a5,a3,fb4 <free+0x36>
     fc4:	6398                	ld	a4,0(a5)
     fc6:	00e6e463          	bltu	a3,a4,fce <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     fca:	fee7eae3          	bltu	a5,a4,fbe <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
     fce:	ff852583          	lw	a1,-8(a0)
     fd2:	6390                	ld	a2,0(a5)
     fd4:	02059713          	slli	a4,a1,0x20
     fd8:	9301                	srli	a4,a4,0x20
     fda:	0712                	slli	a4,a4,0x4
     fdc:	9736                	add	a4,a4,a3
     fde:	fae60ae3          	beq	a2,a4,f92 <free+0x14>
    bp->s.ptr = p->s.ptr;
     fe2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     fe6:	4790                	lw	a2,8(a5)
     fe8:	02061713          	slli	a4,a2,0x20
     fec:	9301                	srli	a4,a4,0x20
     fee:	0712                	slli	a4,a4,0x4
     ff0:	973e                	add	a4,a4,a5
     ff2:	fae689e3          	beq	a3,a4,fa4 <free+0x26>
  } else
    p->s.ptr = bp;
     ff6:	e394                	sd	a3,0(a5)
  freep = p;
     ff8:	00001717          	auipc	a4,0x1
     ffc:	00f73c23          	sd	a5,24(a4) # 2010 <freep>
}
    1000:	6422                	ld	s0,8(sp)
    1002:	0141                	addi	sp,sp,16
    1004:	8082                	ret

0000000000001006 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1006:	7139                	addi	sp,sp,-64
    1008:	fc06                	sd	ra,56(sp)
    100a:	f822                	sd	s0,48(sp)
    100c:	f426                	sd	s1,40(sp)
    100e:	f04a                	sd	s2,32(sp)
    1010:	ec4e                	sd	s3,24(sp)
    1012:	e852                	sd	s4,16(sp)
    1014:	e456                	sd	s5,8(sp)
    1016:	e05a                	sd	s6,0(sp)
    1018:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    101a:	02051493          	slli	s1,a0,0x20
    101e:	9081                	srli	s1,s1,0x20
    1020:	04bd                	addi	s1,s1,15
    1022:	8091                	srli	s1,s1,0x4
    1024:	0014899b          	addiw	s3,s1,1
    1028:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    102a:	00001517          	auipc	a0,0x1
    102e:	fe653503          	ld	a0,-26(a0) # 2010 <freep>
    1032:	c515                	beqz	a0,105e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1034:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1036:	4798                	lw	a4,8(a5)
    1038:	02977f63          	bgeu	a4,s1,1076 <malloc+0x70>
    103c:	8a4e                	mv	s4,s3
    103e:	0009871b          	sext.w	a4,s3
    1042:	6685                	lui	a3,0x1
    1044:	00d77363          	bgeu	a4,a3,104a <malloc+0x44>
    1048:	6a05                	lui	s4,0x1
    104a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    104e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1052:	00001917          	auipc	s2,0x1
    1056:	fbe90913          	addi	s2,s2,-66 # 2010 <freep>
  if(p == (char*)-1)
    105a:	5afd                	li	s5,-1
    105c:	a88d                	j	10ce <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    105e:	00001797          	auipc	a5,0x1
    1062:	3c278793          	addi	a5,a5,962 # 2420 <base>
    1066:	00001717          	auipc	a4,0x1
    106a:	faf73523          	sd	a5,-86(a4) # 2010 <freep>
    106e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1070:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1074:	b7e1                	j	103c <malloc+0x36>
      if(p->s.size == nunits)
    1076:	02e48b63          	beq	s1,a4,10ac <malloc+0xa6>
        p->s.size -= nunits;
    107a:	4137073b          	subw	a4,a4,s3
    107e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1080:	1702                	slli	a4,a4,0x20
    1082:	9301                	srli	a4,a4,0x20
    1084:	0712                	slli	a4,a4,0x4
    1086:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1088:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    108c:	00001717          	auipc	a4,0x1
    1090:	f8a73223          	sd	a0,-124(a4) # 2010 <freep>
      return (void*)(p + 1);
    1094:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1098:	70e2                	ld	ra,56(sp)
    109a:	7442                	ld	s0,48(sp)
    109c:	74a2                	ld	s1,40(sp)
    109e:	7902                	ld	s2,32(sp)
    10a0:	69e2                	ld	s3,24(sp)
    10a2:	6a42                	ld	s4,16(sp)
    10a4:	6aa2                	ld	s5,8(sp)
    10a6:	6b02                	ld	s6,0(sp)
    10a8:	6121                	addi	sp,sp,64
    10aa:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    10ac:	6398                	ld	a4,0(a5)
    10ae:	e118                	sd	a4,0(a0)
    10b0:	bff1                	j	108c <malloc+0x86>
  hp->s.size = nu;
    10b2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    10b6:	0541                	addi	a0,a0,16
    10b8:	00000097          	auipc	ra,0x0
    10bc:	ec6080e7          	jalr	-314(ra) # f7e <free>
  return freep;
    10c0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    10c4:	d971                	beqz	a0,1098 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10c6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10c8:	4798                	lw	a4,8(a5)
    10ca:	fa9776e3          	bgeu	a4,s1,1076 <malloc+0x70>
    if(p == freep)
    10ce:	00093703          	ld	a4,0(s2)
    10d2:	853e                	mv	a0,a5
    10d4:	fef719e3          	bne	a4,a5,10c6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    10d8:	8552                	mv	a0,s4
    10da:	00000097          	auipc	ra,0x0
    10de:	b6e080e7          	jalr	-1170(ra) # c48 <sbrk>
  if(p == (char*)-1)
    10e2:	fd5518e3          	bne	a0,s5,10b2 <malloc+0xac>
        return 0;
    10e6:	4501                	li	a0,0
    10e8:	bf45                	j	1098 <malloc+0x92>
