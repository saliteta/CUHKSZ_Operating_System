
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4981                	li	s3,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  2e:	00001d97          	auipc	s11,0x1
  32:	fe3d8d93          	addi	s11,s11,-29 # 1011 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	918a0a13          	addi	s4,s4,-1768 # 950 <malloc+0xe4>
        inword = 0;
  40:	4b01                	li	s6,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	202080e7          	jalr	514(ra) # 248 <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	89da                	mv	s3,s6
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01248d63          	beq	s1,s2,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2b85                	addiw	s7,s7,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0997e3          	bnez	s3,52 <wc+0x52>
        w++;
  68:	2c05                	addiw	s8,s8,1
        inword = 1;
  6a:	4985                	li	s3,1
  6c:	b7dd                	j	52 <wc+0x52>
  6e:	01ac8cbb          	addw	s9,s9,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	00001597          	auipc	a1,0x1
  7a:	f9a58593          	addi	a1,a1,-102 # 1010 <buf>
  7e:	f8843503          	ld	a0,-120(s0)
  82:	00000097          	auipc	ra,0x0
  86:	3bc080e7          	jalr	956(ra) # 43e <read>
  8a:	00a05f63          	blez	a0,a8 <wc+0xa8>
    for(i=0; i<n; i++){
  8e:	00001497          	auipc	s1,0x1
  92:	f8248493          	addi	s1,s1,-126 # 1010 <buf>
  96:	00050d1b          	sext.w	s10,a0
  9a:	fff5091b          	addiw	s2,a0,-1
  9e:	1902                	slli	s2,s2,0x20
  a0:	02095913          	srli	s2,s2,0x20
  a4:	996e                	add	s2,s2,s11
  a6:	bf4d                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  a8:	02054e63          	bltz	a0,e4 <wc+0xe4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  ac:	f8043703          	ld	a4,-128(s0)
  b0:	86e6                	mv	a3,s9
  b2:	8662                	mv	a2,s8
  b4:	85de                	mv	a1,s7
  b6:	00001517          	auipc	a0,0x1
  ba:	8b250513          	addi	a0,a0,-1870 # 968 <malloc+0xfc>
  be:	00000097          	auipc	ra,0x0
  c2:	6f0080e7          	jalr	1776(ra) # 7ae <printf>
}
  c6:	70e6                	ld	ra,120(sp)
  c8:	7446                	ld	s0,112(sp)
  ca:	74a6                	ld	s1,104(sp)
  cc:	7906                	ld	s2,96(sp)
  ce:	69e6                	ld	s3,88(sp)
  d0:	6a46                	ld	s4,80(sp)
  d2:	6aa6                	ld	s5,72(sp)
  d4:	6b06                	ld	s6,64(sp)
  d6:	7be2                	ld	s7,56(sp)
  d8:	7c42                	ld	s8,48(sp)
  da:	7ca2                	ld	s9,40(sp)
  dc:	7d02                	ld	s10,32(sp)
  de:	6de2                	ld	s11,24(sp)
  e0:	6109                	addi	sp,sp,128
  e2:	8082                	ret
    printf("wc: read error\n");
  e4:	00001517          	auipc	a0,0x1
  e8:	87450513          	addi	a0,a0,-1932 # 958 <malloc+0xec>
  ec:	00000097          	auipc	ra,0x0
  f0:	6c2080e7          	jalr	1730(ra) # 7ae <printf>
    exit(1);
  f4:	4505                	li	a0,1
  f6:	00000097          	auipc	ra,0x0
  fa:	330080e7          	jalr	816(ra) # 426 <exit>

00000000000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	7179                	addi	sp,sp,-48
 100:	f406                	sd	ra,40(sp)
 102:	f022                	sd	s0,32(sp)
 104:	ec26                	sd	s1,24(sp)
 106:	e84a                	sd	s2,16(sp)
 108:	e44e                	sd	s3,8(sp)
 10a:	e052                	sd	s4,0(sp)
 10c:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
 10e:	4785                	li	a5,1
 110:	04a7d763          	bge	a5,a0,15e <main+0x60>
 114:	00858493          	addi	s1,a1,8
 118:	ffe5099b          	addiw	s3,a0,-2
 11c:	1982                	slli	s3,s3,0x20
 11e:	0209d993          	srli	s3,s3,0x20
 122:	098e                	slli	s3,s3,0x3
 124:	05c1                	addi	a1,a1,16
 126:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 128:	4581                	li	a1,0
 12a:	6088                	ld	a0,0(s1)
 12c:	00000097          	auipc	ra,0x0
 130:	33a080e7          	jalr	826(ra) # 466 <open>
 134:	892a                	mv	s2,a0
 136:	04054263          	bltz	a0,17a <main+0x7c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 13a:	608c                	ld	a1,0(s1)
 13c:	00000097          	auipc	ra,0x0
 140:	ec4080e7          	jalr	-316(ra) # 0 <wc>
    close(fd);
 144:	854a                	mv	a0,s2
 146:	00000097          	auipc	ra,0x0
 14a:	308080e7          	jalr	776(ra) # 44e <close>
  for(i = 1; i < argc; i++){
 14e:	04a1                	addi	s1,s1,8
 150:	fd349ce3          	bne	s1,s3,128 <main+0x2a>
  }
  exit(0);
 154:	4501                	li	a0,0
 156:	00000097          	auipc	ra,0x0
 15a:	2d0080e7          	jalr	720(ra) # 426 <exit>
    wc(0, "");
 15e:	00001597          	auipc	a1,0x1
 162:	81a58593          	addi	a1,a1,-2022 # 978 <malloc+0x10c>
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	e98080e7          	jalr	-360(ra) # 0 <wc>
    exit(0);
 170:	4501                	li	a0,0
 172:	00000097          	auipc	ra,0x0
 176:	2b4080e7          	jalr	692(ra) # 426 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 17a:	608c                	ld	a1,0(s1)
 17c:	00001517          	auipc	a0,0x1
 180:	80450513          	addi	a0,a0,-2044 # 980 <malloc+0x114>
 184:	00000097          	auipc	ra,0x0
 188:	62a080e7          	jalr	1578(ra) # 7ae <printf>
      exit(1);
 18c:	4505                	li	a0,1
 18e:	00000097          	auipc	ra,0x0
 192:	298080e7          	jalr	664(ra) # 426 <exit>

0000000000000196 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 196:	1141                	addi	sp,sp,-16
 198:	e406                	sd	ra,8(sp)
 19a:	e022                	sd	s0,0(sp)
 19c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 19e:	00000097          	auipc	ra,0x0
 1a2:	f60080e7          	jalr	-160(ra) # fe <main>
  exit(0);
 1a6:	4501                	li	a0,0
 1a8:	00000097          	auipc	ra,0x0
 1ac:	27e080e7          	jalr	638(ra) # 426 <exit>

00000000000001b0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e422                	sd	s0,8(sp)
 1b4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b6:	87aa                	mv	a5,a0
 1b8:	0585                	addi	a1,a1,1
 1ba:	0785                	addi	a5,a5,1
 1bc:	fff5c703          	lbu	a4,-1(a1)
 1c0:	fee78fa3          	sb	a4,-1(a5)
 1c4:	fb75                	bnez	a4,1b8 <strcpy+0x8>
    ;
  return os;
}
 1c6:	6422                	ld	s0,8(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret

00000000000001cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1cc:	1141                	addi	sp,sp,-16
 1ce:	e422                	sd	s0,8(sp)
 1d0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1d2:	00054783          	lbu	a5,0(a0)
 1d6:	cb91                	beqz	a5,1ea <strcmp+0x1e>
 1d8:	0005c703          	lbu	a4,0(a1)
 1dc:	00f71763          	bne	a4,a5,1ea <strcmp+0x1e>
    p++, q++;
 1e0:	0505                	addi	a0,a0,1
 1e2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	fbe5                	bnez	a5,1d8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1ea:	0005c503          	lbu	a0,0(a1)
}
 1ee:	40a7853b          	subw	a0,a5,a0
 1f2:	6422                	ld	s0,8(sp)
 1f4:	0141                	addi	sp,sp,16
 1f6:	8082                	ret

00000000000001f8 <strlen>:

uint
strlen(const char *s)
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e422                	sd	s0,8(sp)
 1fc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1fe:	00054783          	lbu	a5,0(a0)
 202:	cf91                	beqz	a5,21e <strlen+0x26>
 204:	0505                	addi	a0,a0,1
 206:	87aa                	mv	a5,a0
 208:	4685                	li	a3,1
 20a:	9e89                	subw	a3,a3,a0
 20c:	00f6853b          	addw	a0,a3,a5
 210:	0785                	addi	a5,a5,1
 212:	fff7c703          	lbu	a4,-1(a5)
 216:	fb7d                	bnez	a4,20c <strlen+0x14>
    ;
  return n;
}
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret
  for(n = 0; s[n]; n++)
 21e:	4501                	li	a0,0
 220:	bfe5                	j	218 <strlen+0x20>

0000000000000222 <memset>:

void*
memset(void *dst, int c, uint n)
{
 222:	1141                	addi	sp,sp,-16
 224:	e422                	sd	s0,8(sp)
 226:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 228:	ce09                	beqz	a2,242 <memset+0x20>
 22a:	87aa                	mv	a5,a0
 22c:	fff6071b          	addiw	a4,a2,-1
 230:	1702                	slli	a4,a4,0x20
 232:	9301                	srli	a4,a4,0x20
 234:	0705                	addi	a4,a4,1
 236:	972a                	add	a4,a4,a0
    cdst[i] = c;
 238:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 23c:	0785                	addi	a5,a5,1
 23e:	fee79de3          	bne	a5,a4,238 <memset+0x16>
  }
  return dst;
}
 242:	6422                	ld	s0,8(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret

0000000000000248 <strchr>:

char*
strchr(const char *s, char c)
{
 248:	1141                	addi	sp,sp,-16
 24a:	e422                	sd	s0,8(sp)
 24c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 24e:	00054783          	lbu	a5,0(a0)
 252:	cb99                	beqz	a5,268 <strchr+0x20>
    if(*s == c)
 254:	00f58763          	beq	a1,a5,262 <strchr+0x1a>
  for(; *s; s++)
 258:	0505                	addi	a0,a0,1
 25a:	00054783          	lbu	a5,0(a0)
 25e:	fbfd                	bnez	a5,254 <strchr+0xc>
      return (char*)s;
  return 0;
 260:	4501                	li	a0,0
}
 262:	6422                	ld	s0,8(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
  return 0;
 268:	4501                	li	a0,0
 26a:	bfe5                	j	262 <strchr+0x1a>

000000000000026c <gets>:

char*
gets(char *buf, int max)
{
 26c:	711d                	addi	sp,sp,-96
 26e:	ec86                	sd	ra,88(sp)
 270:	e8a2                	sd	s0,80(sp)
 272:	e4a6                	sd	s1,72(sp)
 274:	e0ca                	sd	s2,64(sp)
 276:	fc4e                	sd	s3,56(sp)
 278:	f852                	sd	s4,48(sp)
 27a:	f456                	sd	s5,40(sp)
 27c:	f05a                	sd	s6,32(sp)
 27e:	ec5e                	sd	s7,24(sp)
 280:	1080                	addi	s0,sp,96
 282:	8baa                	mv	s7,a0
 284:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 286:	892a                	mv	s2,a0
 288:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 28a:	4aa9                	li	s5,10
 28c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 28e:	89a6                	mv	s3,s1
 290:	2485                	addiw	s1,s1,1
 292:	0344d863          	bge	s1,s4,2c2 <gets+0x56>
    cc = read(0, &c, 1);
 296:	4605                	li	a2,1
 298:	faf40593          	addi	a1,s0,-81
 29c:	4501                	li	a0,0
 29e:	00000097          	auipc	ra,0x0
 2a2:	1a0080e7          	jalr	416(ra) # 43e <read>
    if(cc < 1)
 2a6:	00a05e63          	blez	a0,2c2 <gets+0x56>
    buf[i++] = c;
 2aa:	faf44783          	lbu	a5,-81(s0)
 2ae:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2b2:	01578763          	beq	a5,s5,2c0 <gets+0x54>
 2b6:	0905                	addi	s2,s2,1
 2b8:	fd679be3          	bne	a5,s6,28e <gets+0x22>
  for(i=0; i+1 < max; ){
 2bc:	89a6                	mv	s3,s1
 2be:	a011                	j	2c2 <gets+0x56>
 2c0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2c2:	99de                	add	s3,s3,s7
 2c4:	00098023          	sb	zero,0(s3)
  return buf;
}
 2c8:	855e                	mv	a0,s7
 2ca:	60e6                	ld	ra,88(sp)
 2cc:	6446                	ld	s0,80(sp)
 2ce:	64a6                	ld	s1,72(sp)
 2d0:	6906                	ld	s2,64(sp)
 2d2:	79e2                	ld	s3,56(sp)
 2d4:	7a42                	ld	s4,48(sp)
 2d6:	7aa2                	ld	s5,40(sp)
 2d8:	7b02                	ld	s6,32(sp)
 2da:	6be2                	ld	s7,24(sp)
 2dc:	6125                	addi	sp,sp,96
 2de:	8082                	ret

00000000000002e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2e0:	1101                	addi	sp,sp,-32
 2e2:	ec06                	sd	ra,24(sp)
 2e4:	e822                	sd	s0,16(sp)
 2e6:	e426                	sd	s1,8(sp)
 2e8:	e04a                	sd	s2,0(sp)
 2ea:	1000                	addi	s0,sp,32
 2ec:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ee:	4581                	li	a1,0
 2f0:	00000097          	auipc	ra,0x0
 2f4:	176080e7          	jalr	374(ra) # 466 <open>
  if(fd < 0)
 2f8:	02054563          	bltz	a0,322 <stat+0x42>
 2fc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2fe:	85ca                	mv	a1,s2
 300:	00000097          	auipc	ra,0x0
 304:	17e080e7          	jalr	382(ra) # 47e <fstat>
 308:	892a                	mv	s2,a0
  close(fd);
 30a:	8526                	mv	a0,s1
 30c:	00000097          	auipc	ra,0x0
 310:	142080e7          	jalr	322(ra) # 44e <close>
  return r;
}
 314:	854a                	mv	a0,s2
 316:	60e2                	ld	ra,24(sp)
 318:	6442                	ld	s0,16(sp)
 31a:	64a2                	ld	s1,8(sp)
 31c:	6902                	ld	s2,0(sp)
 31e:	6105                	addi	sp,sp,32
 320:	8082                	ret
    return -1;
 322:	597d                	li	s2,-1
 324:	bfc5                	j	314 <stat+0x34>

0000000000000326 <atoi>:

int
atoi(const char *s)
{
 326:	1141                	addi	sp,sp,-16
 328:	e422                	sd	s0,8(sp)
 32a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 32c:	00054603          	lbu	a2,0(a0)
 330:	fd06079b          	addiw	a5,a2,-48
 334:	0ff7f793          	andi	a5,a5,255
 338:	4725                	li	a4,9
 33a:	02f76963          	bltu	a4,a5,36c <atoi+0x46>
 33e:	86aa                	mv	a3,a0
  n = 0;
 340:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 342:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 344:	0685                	addi	a3,a3,1
 346:	0025179b          	slliw	a5,a0,0x2
 34a:	9fa9                	addw	a5,a5,a0
 34c:	0017979b          	slliw	a5,a5,0x1
 350:	9fb1                	addw	a5,a5,a2
 352:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 356:	0006c603          	lbu	a2,0(a3)
 35a:	fd06071b          	addiw	a4,a2,-48
 35e:	0ff77713          	andi	a4,a4,255
 362:	fee5f1e3          	bgeu	a1,a4,344 <atoi+0x1e>
  return n;
}
 366:	6422                	ld	s0,8(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret
  n = 0;
 36c:	4501                	li	a0,0
 36e:	bfe5                	j	366 <atoi+0x40>

0000000000000370 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e422                	sd	s0,8(sp)
 374:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 376:	02b57663          	bgeu	a0,a1,3a2 <memmove+0x32>
    while(n-- > 0)
 37a:	02c05163          	blez	a2,39c <memmove+0x2c>
 37e:	fff6079b          	addiw	a5,a2,-1
 382:	1782                	slli	a5,a5,0x20
 384:	9381                	srli	a5,a5,0x20
 386:	0785                	addi	a5,a5,1
 388:	97aa                	add	a5,a5,a0
  dst = vdst;
 38a:	872a                	mv	a4,a0
      *dst++ = *src++;
 38c:	0585                	addi	a1,a1,1
 38e:	0705                	addi	a4,a4,1
 390:	fff5c683          	lbu	a3,-1(a1)
 394:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 398:	fee79ae3          	bne	a5,a4,38c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 39c:	6422                	ld	s0,8(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret
    dst += n;
 3a2:	00c50733          	add	a4,a0,a2
    src += n;
 3a6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3a8:	fec05ae3          	blez	a2,39c <memmove+0x2c>
 3ac:	fff6079b          	addiw	a5,a2,-1
 3b0:	1782                	slli	a5,a5,0x20
 3b2:	9381                	srli	a5,a5,0x20
 3b4:	fff7c793          	not	a5,a5
 3b8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3ba:	15fd                	addi	a1,a1,-1
 3bc:	177d                	addi	a4,a4,-1
 3be:	0005c683          	lbu	a3,0(a1)
 3c2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3c6:	fee79ae3          	bne	a5,a4,3ba <memmove+0x4a>
 3ca:	bfc9                	j	39c <memmove+0x2c>

00000000000003cc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3cc:	1141                	addi	sp,sp,-16
 3ce:	e422                	sd	s0,8(sp)
 3d0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3d2:	ca05                	beqz	a2,402 <memcmp+0x36>
 3d4:	fff6069b          	addiw	a3,a2,-1
 3d8:	1682                	slli	a3,a3,0x20
 3da:	9281                	srli	a3,a3,0x20
 3dc:	0685                	addi	a3,a3,1
 3de:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3e0:	00054783          	lbu	a5,0(a0)
 3e4:	0005c703          	lbu	a4,0(a1)
 3e8:	00e79863          	bne	a5,a4,3f8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3ec:	0505                	addi	a0,a0,1
    p2++;
 3ee:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3f0:	fed518e3          	bne	a0,a3,3e0 <memcmp+0x14>
  }
  return 0;
 3f4:	4501                	li	a0,0
 3f6:	a019                	j	3fc <memcmp+0x30>
      return *p1 - *p2;
 3f8:	40e7853b          	subw	a0,a5,a4
}
 3fc:	6422                	ld	s0,8(sp)
 3fe:	0141                	addi	sp,sp,16
 400:	8082                	ret
  return 0;
 402:	4501                	li	a0,0
 404:	bfe5                	j	3fc <memcmp+0x30>

0000000000000406 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 406:	1141                	addi	sp,sp,-16
 408:	e406                	sd	ra,8(sp)
 40a:	e022                	sd	s0,0(sp)
 40c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 40e:	00000097          	auipc	ra,0x0
 412:	f62080e7          	jalr	-158(ra) # 370 <memmove>
}
 416:	60a2                	ld	ra,8(sp)
 418:	6402                	ld	s0,0(sp)
 41a:	0141                	addi	sp,sp,16
 41c:	8082                	ret

000000000000041e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 41e:	4885                	li	a7,1
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <exit>:
.global exit
exit:
 li a7, SYS_exit
 426:	4889                	li	a7,2
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <wait>:
.global wait
wait:
 li a7, SYS_wait
 42e:	488d                	li	a7,3
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 436:	4891                	li	a7,4
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <read>:
.global read
read:
 li a7, SYS_read
 43e:	4895                	li	a7,5
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <write>:
.global write
write:
 li a7, SYS_write
 446:	48c1                	li	a7,16
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <close>:
.global close
close:
 li a7, SYS_close
 44e:	48d5                	li	a7,21
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <kill>:
.global kill
kill:
 li a7, SYS_kill
 456:	4899                	li	a7,6
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <exec>:
.global exec
exec:
 li a7, SYS_exec
 45e:	489d                	li	a7,7
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <open>:
.global open
open:
 li a7, SYS_open
 466:	48bd                	li	a7,15
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 46e:	48c5                	li	a7,17
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 476:	48c9                	li	a7,18
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 47e:	48a1                	li	a7,8
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <link>:
.global link
link:
 li a7, SYS_link
 486:	48cd                	li	a7,19
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 48e:	48d1                	li	a7,20
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 496:	48a5                	li	a7,9
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <dup>:
.global dup
dup:
 li a7, SYS_dup
 49e:	48a9                	li	a7,10
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4a6:	48ad                	li	a7,11
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4ae:	48b1                	li	a7,12
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4b6:	48b5                	li	a7,13
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4be:	48b9                	li	a7,14
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 4c6:	48d9                	li	a7,22
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 4ce:	48dd                	li	a7,23
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4d6:	1101                	addi	sp,sp,-32
 4d8:	ec06                	sd	ra,24(sp)
 4da:	e822                	sd	s0,16(sp)
 4dc:	1000                	addi	s0,sp,32
 4de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4e2:	4605                	li	a2,1
 4e4:	fef40593          	addi	a1,s0,-17
 4e8:	00000097          	auipc	ra,0x0
 4ec:	f5e080e7          	jalr	-162(ra) # 446 <write>
}
 4f0:	60e2                	ld	ra,24(sp)
 4f2:	6442                	ld	s0,16(sp)
 4f4:	6105                	addi	sp,sp,32
 4f6:	8082                	ret

00000000000004f8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f8:	7139                	addi	sp,sp,-64
 4fa:	fc06                	sd	ra,56(sp)
 4fc:	f822                	sd	s0,48(sp)
 4fe:	f426                	sd	s1,40(sp)
 500:	f04a                	sd	s2,32(sp)
 502:	ec4e                	sd	s3,24(sp)
 504:	0080                	addi	s0,sp,64
 506:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 508:	c299                	beqz	a3,50e <printint+0x16>
 50a:	0805c863          	bltz	a1,59a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 50e:	2581                	sext.w	a1,a1
  neg = 0;
 510:	4881                	li	a7,0
 512:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 516:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 518:	2601                	sext.w	a2,a2
 51a:	00000517          	auipc	a0,0x0
 51e:	48650513          	addi	a0,a0,1158 # 9a0 <digits>
 522:	883a                	mv	a6,a4
 524:	2705                	addiw	a4,a4,1
 526:	02c5f7bb          	remuw	a5,a1,a2
 52a:	1782                	slli	a5,a5,0x20
 52c:	9381                	srli	a5,a5,0x20
 52e:	97aa                	add	a5,a5,a0
 530:	0007c783          	lbu	a5,0(a5)
 534:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 538:	0005879b          	sext.w	a5,a1
 53c:	02c5d5bb          	divuw	a1,a1,a2
 540:	0685                	addi	a3,a3,1
 542:	fec7f0e3          	bgeu	a5,a2,522 <printint+0x2a>
  if(neg)
 546:	00088b63          	beqz	a7,55c <printint+0x64>
    buf[i++] = '-';
 54a:	fd040793          	addi	a5,s0,-48
 54e:	973e                	add	a4,a4,a5
 550:	02d00793          	li	a5,45
 554:	fef70823          	sb	a5,-16(a4)
 558:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 55c:	02e05863          	blez	a4,58c <printint+0x94>
 560:	fc040793          	addi	a5,s0,-64
 564:	00e78933          	add	s2,a5,a4
 568:	fff78993          	addi	s3,a5,-1
 56c:	99ba                	add	s3,s3,a4
 56e:	377d                	addiw	a4,a4,-1
 570:	1702                	slli	a4,a4,0x20
 572:	9301                	srli	a4,a4,0x20
 574:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 578:	fff94583          	lbu	a1,-1(s2)
 57c:	8526                	mv	a0,s1
 57e:	00000097          	auipc	ra,0x0
 582:	f58080e7          	jalr	-168(ra) # 4d6 <putc>
  while(--i >= 0)
 586:	197d                	addi	s2,s2,-1
 588:	ff3918e3          	bne	s2,s3,578 <printint+0x80>
}
 58c:	70e2                	ld	ra,56(sp)
 58e:	7442                	ld	s0,48(sp)
 590:	74a2                	ld	s1,40(sp)
 592:	7902                	ld	s2,32(sp)
 594:	69e2                	ld	s3,24(sp)
 596:	6121                	addi	sp,sp,64
 598:	8082                	ret
    x = -xx;
 59a:	40b005bb          	negw	a1,a1
    neg = 1;
 59e:	4885                	li	a7,1
    x = -xx;
 5a0:	bf8d                	j	512 <printint+0x1a>

00000000000005a2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5a2:	7119                	addi	sp,sp,-128
 5a4:	fc86                	sd	ra,120(sp)
 5a6:	f8a2                	sd	s0,112(sp)
 5a8:	f4a6                	sd	s1,104(sp)
 5aa:	f0ca                	sd	s2,96(sp)
 5ac:	ecce                	sd	s3,88(sp)
 5ae:	e8d2                	sd	s4,80(sp)
 5b0:	e4d6                	sd	s5,72(sp)
 5b2:	e0da                	sd	s6,64(sp)
 5b4:	fc5e                	sd	s7,56(sp)
 5b6:	f862                	sd	s8,48(sp)
 5b8:	f466                	sd	s9,40(sp)
 5ba:	f06a                	sd	s10,32(sp)
 5bc:	ec6e                	sd	s11,24(sp)
 5be:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5c0:	0005c903          	lbu	s2,0(a1)
 5c4:	18090f63          	beqz	s2,762 <vprintf+0x1c0>
 5c8:	8aaa                	mv	s5,a0
 5ca:	8b32                	mv	s6,a2
 5cc:	00158493          	addi	s1,a1,1
  state = 0;
 5d0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5d2:	02500a13          	li	s4,37
      if(c == 'd'){
 5d6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5da:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5de:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5e2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e6:	00000b97          	auipc	s7,0x0
 5ea:	3bab8b93          	addi	s7,s7,954 # 9a0 <digits>
 5ee:	a839                	j	60c <vprintf+0x6a>
        putc(fd, c);
 5f0:	85ca                	mv	a1,s2
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	ee2080e7          	jalr	-286(ra) # 4d6 <putc>
 5fc:	a019                	j	602 <vprintf+0x60>
    } else if(state == '%'){
 5fe:	01498f63          	beq	s3,s4,61c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 602:	0485                	addi	s1,s1,1
 604:	fff4c903          	lbu	s2,-1(s1)
 608:	14090d63          	beqz	s2,762 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 60c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 610:	fe0997e3          	bnez	s3,5fe <vprintf+0x5c>
      if(c == '%'){
 614:	fd479ee3          	bne	a5,s4,5f0 <vprintf+0x4e>
        state = '%';
 618:	89be                	mv	s3,a5
 61a:	b7e5                	j	602 <vprintf+0x60>
      if(c == 'd'){
 61c:	05878063          	beq	a5,s8,65c <vprintf+0xba>
      } else if(c == 'l') {
 620:	05978c63          	beq	a5,s9,678 <vprintf+0xd6>
      } else if(c == 'x') {
 624:	07a78863          	beq	a5,s10,694 <vprintf+0xf2>
      } else if(c == 'p') {
 628:	09b78463          	beq	a5,s11,6b0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 62c:	07300713          	li	a4,115
 630:	0ce78663          	beq	a5,a4,6fc <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 634:	06300713          	li	a4,99
 638:	0ee78e63          	beq	a5,a4,734 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 63c:	11478863          	beq	a5,s4,74c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 640:	85d2                	mv	a1,s4
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	e92080e7          	jalr	-366(ra) # 4d6 <putc>
        putc(fd, c);
 64c:	85ca                	mv	a1,s2
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	e86080e7          	jalr	-378(ra) # 4d6 <putc>
      }
      state = 0;
 658:	4981                	li	s3,0
 65a:	b765                	j	602 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 65c:	008b0913          	addi	s2,s6,8
 660:	4685                	li	a3,1
 662:	4629                	li	a2,10
 664:	000b2583          	lw	a1,0(s6)
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	e8e080e7          	jalr	-370(ra) # 4f8 <printint>
 672:	8b4a                	mv	s6,s2
      state = 0;
 674:	4981                	li	s3,0
 676:	b771                	j	602 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 678:	008b0913          	addi	s2,s6,8
 67c:	4681                	li	a3,0
 67e:	4629                	li	a2,10
 680:	000b2583          	lw	a1,0(s6)
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	e72080e7          	jalr	-398(ra) # 4f8 <printint>
 68e:	8b4a                	mv	s6,s2
      state = 0;
 690:	4981                	li	s3,0
 692:	bf85                	j	602 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 694:	008b0913          	addi	s2,s6,8
 698:	4681                	li	a3,0
 69a:	4641                	li	a2,16
 69c:	000b2583          	lw	a1,0(s6)
 6a0:	8556                	mv	a0,s5
 6a2:	00000097          	auipc	ra,0x0
 6a6:	e56080e7          	jalr	-426(ra) # 4f8 <printint>
 6aa:	8b4a                	mv	s6,s2
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	bf91                	j	602 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6b0:	008b0793          	addi	a5,s6,8
 6b4:	f8f43423          	sd	a5,-120(s0)
 6b8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6bc:	03000593          	li	a1,48
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	e14080e7          	jalr	-492(ra) # 4d6 <putc>
  putc(fd, 'x');
 6ca:	85ea                	mv	a1,s10
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	e08080e7          	jalr	-504(ra) # 4d6 <putc>
 6d6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d8:	03c9d793          	srli	a5,s3,0x3c
 6dc:	97de                	add	a5,a5,s7
 6de:	0007c583          	lbu	a1,0(a5)
 6e2:	8556                	mv	a0,s5
 6e4:	00000097          	auipc	ra,0x0
 6e8:	df2080e7          	jalr	-526(ra) # 4d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ec:	0992                	slli	s3,s3,0x4
 6ee:	397d                	addiw	s2,s2,-1
 6f0:	fe0914e3          	bnez	s2,6d8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6f4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	b721                	j	602 <vprintf+0x60>
        s = va_arg(ap, char*);
 6fc:	008b0993          	addi	s3,s6,8
 700:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 704:	02090163          	beqz	s2,726 <vprintf+0x184>
        while(*s != 0){
 708:	00094583          	lbu	a1,0(s2)
 70c:	c9a1                	beqz	a1,75c <vprintf+0x1ba>
          putc(fd, *s);
 70e:	8556                	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	dc6080e7          	jalr	-570(ra) # 4d6 <putc>
          s++;
 718:	0905                	addi	s2,s2,1
        while(*s != 0){
 71a:	00094583          	lbu	a1,0(s2)
 71e:	f9e5                	bnez	a1,70e <vprintf+0x16c>
        s = va_arg(ap, char*);
 720:	8b4e                	mv	s6,s3
      state = 0;
 722:	4981                	li	s3,0
 724:	bdf9                	j	602 <vprintf+0x60>
          s = "(null)";
 726:	00000917          	auipc	s2,0x0
 72a:	27290913          	addi	s2,s2,626 # 998 <malloc+0x12c>
        while(*s != 0){
 72e:	02800593          	li	a1,40
 732:	bff1                	j	70e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 734:	008b0913          	addi	s2,s6,8
 738:	000b4583          	lbu	a1,0(s6)
 73c:	8556                	mv	a0,s5
 73e:	00000097          	auipc	ra,0x0
 742:	d98080e7          	jalr	-616(ra) # 4d6 <putc>
 746:	8b4a                	mv	s6,s2
      state = 0;
 748:	4981                	li	s3,0
 74a:	bd65                	j	602 <vprintf+0x60>
        putc(fd, c);
 74c:	85d2                	mv	a1,s4
 74e:	8556                	mv	a0,s5
 750:	00000097          	auipc	ra,0x0
 754:	d86080e7          	jalr	-634(ra) # 4d6 <putc>
      state = 0;
 758:	4981                	li	s3,0
 75a:	b565                	j	602 <vprintf+0x60>
        s = va_arg(ap, char*);
 75c:	8b4e                	mv	s6,s3
      state = 0;
 75e:	4981                	li	s3,0
 760:	b54d                	j	602 <vprintf+0x60>
    }
  }
}
 762:	70e6                	ld	ra,120(sp)
 764:	7446                	ld	s0,112(sp)
 766:	74a6                	ld	s1,104(sp)
 768:	7906                	ld	s2,96(sp)
 76a:	69e6                	ld	s3,88(sp)
 76c:	6a46                	ld	s4,80(sp)
 76e:	6aa6                	ld	s5,72(sp)
 770:	6b06                	ld	s6,64(sp)
 772:	7be2                	ld	s7,56(sp)
 774:	7c42                	ld	s8,48(sp)
 776:	7ca2                	ld	s9,40(sp)
 778:	7d02                	ld	s10,32(sp)
 77a:	6de2                	ld	s11,24(sp)
 77c:	6109                	addi	sp,sp,128
 77e:	8082                	ret

0000000000000780 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 780:	715d                	addi	sp,sp,-80
 782:	ec06                	sd	ra,24(sp)
 784:	e822                	sd	s0,16(sp)
 786:	1000                	addi	s0,sp,32
 788:	e010                	sd	a2,0(s0)
 78a:	e414                	sd	a3,8(s0)
 78c:	e818                	sd	a4,16(s0)
 78e:	ec1c                	sd	a5,24(s0)
 790:	03043023          	sd	a6,32(s0)
 794:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 798:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 79c:	8622                	mv	a2,s0
 79e:	00000097          	auipc	ra,0x0
 7a2:	e04080e7          	jalr	-508(ra) # 5a2 <vprintf>
}
 7a6:	60e2                	ld	ra,24(sp)
 7a8:	6442                	ld	s0,16(sp)
 7aa:	6161                	addi	sp,sp,80
 7ac:	8082                	ret

00000000000007ae <printf>:

void
printf(const char *fmt, ...)
{
 7ae:	711d                	addi	sp,sp,-96
 7b0:	ec06                	sd	ra,24(sp)
 7b2:	e822                	sd	s0,16(sp)
 7b4:	1000                	addi	s0,sp,32
 7b6:	e40c                	sd	a1,8(s0)
 7b8:	e810                	sd	a2,16(s0)
 7ba:	ec14                	sd	a3,24(s0)
 7bc:	f018                	sd	a4,32(s0)
 7be:	f41c                	sd	a5,40(s0)
 7c0:	03043823          	sd	a6,48(s0)
 7c4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c8:	00840613          	addi	a2,s0,8
 7cc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d0:	85aa                	mv	a1,a0
 7d2:	4505                	li	a0,1
 7d4:	00000097          	auipc	ra,0x0
 7d8:	dce080e7          	jalr	-562(ra) # 5a2 <vprintf>
}
 7dc:	60e2                	ld	ra,24(sp)
 7de:	6442                	ld	s0,16(sp)
 7e0:	6125                	addi	sp,sp,96
 7e2:	8082                	ret

00000000000007e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e4:	1141                	addi	sp,sp,-16
 7e6:	e422                	sd	s0,8(sp)
 7e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ee:	00001797          	auipc	a5,0x1
 7f2:	8127b783          	ld	a5,-2030(a5) # 1000 <freep>
 7f6:	a805                	j	826 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7f8:	4618                	lw	a4,8(a2)
 7fa:	9db9                	addw	a1,a1,a4
 7fc:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 800:	6398                	ld	a4,0(a5)
 802:	6318                	ld	a4,0(a4)
 804:	fee53823          	sd	a4,-16(a0)
 808:	a091                	j	84c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 80a:	ff852703          	lw	a4,-8(a0)
 80e:	9e39                	addw	a2,a2,a4
 810:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 812:	ff053703          	ld	a4,-16(a0)
 816:	e398                	sd	a4,0(a5)
 818:	a099                	j	85e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81a:	6398                	ld	a4,0(a5)
 81c:	00e7e463          	bltu	a5,a4,824 <free+0x40>
 820:	00e6ea63          	bltu	a3,a4,834 <free+0x50>
{
 824:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 826:	fed7fae3          	bgeu	a5,a3,81a <free+0x36>
 82a:	6398                	ld	a4,0(a5)
 82c:	00e6e463          	bltu	a3,a4,834 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 830:	fee7eae3          	bltu	a5,a4,824 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 834:	ff852583          	lw	a1,-8(a0)
 838:	6390                	ld	a2,0(a5)
 83a:	02059713          	slli	a4,a1,0x20
 83e:	9301                	srli	a4,a4,0x20
 840:	0712                	slli	a4,a4,0x4
 842:	9736                	add	a4,a4,a3
 844:	fae60ae3          	beq	a2,a4,7f8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 848:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 84c:	4790                	lw	a2,8(a5)
 84e:	02061713          	slli	a4,a2,0x20
 852:	9301                	srli	a4,a4,0x20
 854:	0712                	slli	a4,a4,0x4
 856:	973e                	add	a4,a4,a5
 858:	fae689e3          	beq	a3,a4,80a <free+0x26>
  } else
    p->s.ptr = bp;
 85c:	e394                	sd	a3,0(a5)
  freep = p;
 85e:	00000717          	auipc	a4,0x0
 862:	7af73123          	sd	a5,1954(a4) # 1000 <freep>
}
 866:	6422                	ld	s0,8(sp)
 868:	0141                	addi	sp,sp,16
 86a:	8082                	ret

000000000000086c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 86c:	7139                	addi	sp,sp,-64
 86e:	fc06                	sd	ra,56(sp)
 870:	f822                	sd	s0,48(sp)
 872:	f426                	sd	s1,40(sp)
 874:	f04a                	sd	s2,32(sp)
 876:	ec4e                	sd	s3,24(sp)
 878:	e852                	sd	s4,16(sp)
 87a:	e456                	sd	s5,8(sp)
 87c:	e05a                	sd	s6,0(sp)
 87e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 880:	02051493          	slli	s1,a0,0x20
 884:	9081                	srli	s1,s1,0x20
 886:	04bd                	addi	s1,s1,15
 888:	8091                	srli	s1,s1,0x4
 88a:	0014899b          	addiw	s3,s1,1
 88e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 890:	00000517          	auipc	a0,0x0
 894:	77053503          	ld	a0,1904(a0) # 1000 <freep>
 898:	c515                	beqz	a0,8c4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89c:	4798                	lw	a4,8(a5)
 89e:	02977f63          	bgeu	a4,s1,8dc <malloc+0x70>
 8a2:	8a4e                	mv	s4,s3
 8a4:	0009871b          	sext.w	a4,s3
 8a8:	6685                	lui	a3,0x1
 8aa:	00d77363          	bgeu	a4,a3,8b0 <malloc+0x44>
 8ae:	6a05                	lui	s4,0x1
 8b0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b8:	00000917          	auipc	s2,0x0
 8bc:	74890913          	addi	s2,s2,1864 # 1000 <freep>
  if(p == (char*)-1)
 8c0:	5afd                	li	s5,-1
 8c2:	a88d                	j	934 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8c4:	00001797          	auipc	a5,0x1
 8c8:	94c78793          	addi	a5,a5,-1716 # 1210 <base>
 8cc:	00000717          	auipc	a4,0x0
 8d0:	72f73a23          	sd	a5,1844(a4) # 1000 <freep>
 8d4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8da:	b7e1                	j	8a2 <malloc+0x36>
      if(p->s.size == nunits)
 8dc:	02e48b63          	beq	s1,a4,912 <malloc+0xa6>
        p->s.size -= nunits;
 8e0:	4137073b          	subw	a4,a4,s3
 8e4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e6:	1702                	slli	a4,a4,0x20
 8e8:	9301                	srli	a4,a4,0x20
 8ea:	0712                	slli	a4,a4,0x4
 8ec:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ee:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f2:	00000717          	auipc	a4,0x0
 8f6:	70a73723          	sd	a0,1806(a4) # 1000 <freep>
      return (void*)(p + 1);
 8fa:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8fe:	70e2                	ld	ra,56(sp)
 900:	7442                	ld	s0,48(sp)
 902:	74a2                	ld	s1,40(sp)
 904:	7902                	ld	s2,32(sp)
 906:	69e2                	ld	s3,24(sp)
 908:	6a42                	ld	s4,16(sp)
 90a:	6aa2                	ld	s5,8(sp)
 90c:	6b02                	ld	s6,0(sp)
 90e:	6121                	addi	sp,sp,64
 910:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 912:	6398                	ld	a4,0(a5)
 914:	e118                	sd	a4,0(a0)
 916:	bff1                	j	8f2 <malloc+0x86>
  hp->s.size = nu;
 918:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 91c:	0541                	addi	a0,a0,16
 91e:	00000097          	auipc	ra,0x0
 922:	ec6080e7          	jalr	-314(ra) # 7e4 <free>
  return freep;
 926:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 92a:	d971                	beqz	a0,8fe <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 92e:	4798                	lw	a4,8(a5)
 930:	fa9776e3          	bgeu	a4,s1,8dc <malloc+0x70>
    if(p == freep)
 934:	00093703          	ld	a4,0(s2)
 938:	853e                	mv	a0,a5
 93a:	fef719e3          	bne	a4,a5,92c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 93e:	8552                	mv	a0,s4
 940:	00000097          	auipc	ra,0x0
 944:	b6e080e7          	jalr	-1170(ra) # 4ae <sbrk>
  if(p == (char*)-1)
 948:	fd5518e3          	bne	a0,s5,918 <malloc+0xac>
        return 0;
 94c:	4501                	li	a0,0
 94e:	bf45                	j	8fe <malloc+0x92>
