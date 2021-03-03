
_init:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 10          	sub    $0x10,%rsp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    100c:	be 02 00 00 00       	mov    $0x2,%esi
    1011:	48 bf e3 1e 00 00 00 	movabs $0x1ee3,%rdi
    1018:	00 00 00 
    101b:	48 b8 2c 15 00 00 00 	movabs $0x152c,%rax
    1022:	00 00 00 
    1025:	ff d0                	callq  *%rax
    1027:	85 c0                	test   %eax,%eax
    1029:	79 3b                	jns    1066 <main+0x66>
    mknod("console", 1, 1);
    102b:	ba 01 00 00 00       	mov    $0x1,%edx
    1030:	be 01 00 00 00       	mov    $0x1,%esi
    1035:	48 bf e3 1e 00 00 00 	movabs $0x1ee3,%rdi
    103c:	00 00 00 
    103f:	48 b8 39 15 00 00 00 	movabs $0x1539,%rax
    1046:	00 00 00 
    1049:	ff d0                	callq  *%rax
    open("console", O_RDWR);
    104b:	be 02 00 00 00       	mov    $0x2,%esi
    1050:	48 bf e3 1e 00 00 00 	movabs $0x1ee3,%rdi
    1057:	00 00 00 
    105a:	48 b8 2c 15 00 00 00 	movabs $0x152c,%rax
    1061:	00 00 00 
    1064:	ff d0                	callq  *%rax
  }
  dup(0);  // stdout
    1066:	bf 00 00 00 00       	mov    $0x0,%edi
    106b:	48 b8 87 15 00 00 00 	movabs $0x1587,%rax
    1072:	00 00 00 
    1075:	ff d0                	callq  *%rax
  dup(0);  // stderr
    1077:	bf 00 00 00 00       	mov    $0x0,%edi
    107c:	48 b8 87 15 00 00 00 	movabs $0x1587,%rax
    1083:	00 00 00 
    1086:	ff d0                	callq  *%rax

  for(;;){
    printf(1, "init: starting sh\n");
    1088:	48 be eb 1e 00 00 00 	movabs $0x1eeb,%rsi
    108f:	00 00 00 
    1092:	bf 01 00 00 00       	mov    $0x1,%edi
    1097:	b8 00 00 00 00       	mov    $0x0,%eax
    109c:	48 ba c8 17 00 00 00 	movabs $0x17c8,%rdx
    10a3:	00 00 00 
    10a6:	ff d2                	callq  *%rdx
    pid = fork();
    10a8:	48 b8 b7 14 00 00 00 	movabs $0x14b7,%rax
    10af:	00 00 00 
    10b2:	ff d0                	callq  *%rax
    10b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
    if(pid < 0){
    10b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    10bb:	79 2c                	jns    10e9 <main+0xe9>
      printf(1, "init: fork failed\n");
    10bd:	48 be fe 1e 00 00 00 	movabs $0x1efe,%rsi
    10c4:	00 00 00 
    10c7:	bf 01 00 00 00       	mov    $0x1,%edi
    10cc:	b8 00 00 00 00       	mov    $0x0,%eax
    10d1:	48 ba c8 17 00 00 00 	movabs $0x17c8,%rdx
    10d8:	00 00 00 
    10db:	ff d2                	callq  *%rdx
      exit();
    10dd:	48 b8 c4 14 00 00 00 	movabs $0x14c4,%rax
    10e4:	00 00 00 
    10e7:	ff d0                	callq  *%rax
    }
    if(pid == 0){
    10e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    10ed:	75 6c                	jne    115b <main+0x15b>
      exec("sh", argv);
    10ef:	48 be 60 22 00 00 00 	movabs $0x2260,%rsi
    10f6:	00 00 00 
    10f9:	48 bf e0 1e 00 00 00 	movabs $0x1ee0,%rdi
    1100:	00 00 00 
    1103:	48 b8 1f 15 00 00 00 	movabs $0x151f,%rax
    110a:	00 00 00 
    110d:	ff d0                	callq  *%rax
      printf(1, "init: exec sh failed\n");
    110f:	48 be 11 1f 00 00 00 	movabs $0x1f11,%rsi
    1116:	00 00 00 
    1119:	bf 01 00 00 00       	mov    $0x1,%edi
    111e:	b8 00 00 00 00       	mov    $0x0,%eax
    1123:	48 ba c8 17 00 00 00 	movabs $0x17c8,%rdx
    112a:	00 00 00 
    112d:	ff d2                	callq  *%rdx
      exit();
    112f:	48 b8 c4 14 00 00 00 	movabs $0x14c4,%rax
    1136:	00 00 00 
    1139:	ff d0                	callq  *%rax
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
    113b:	48 be 27 1f 00 00 00 	movabs $0x1f27,%rsi
    1142:	00 00 00 
    1145:	bf 01 00 00 00       	mov    $0x1,%edi
    114a:	b8 00 00 00 00       	mov    $0x0,%eax
    114f:	48 ba c8 17 00 00 00 	movabs $0x17c8,%rdx
    1156:	00 00 00 
    1159:	ff d2                	callq  *%rdx
    while((wpid=wait()) >= 0 && wpid != pid)
    115b:	48 b8 d1 14 00 00 00 	movabs $0x14d1,%rax
    1162:	00 00 00 
    1165:	ff d0                	callq  *%rax
    1167:	89 45 f8             	mov    %eax,-0x8(%rbp)
    116a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    116e:	0f 88 14 ff ff ff    	js     1088 <main+0x88>
    1174:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1177:	3b 45 fc             	cmp    -0x4(%rbp),%eax
    117a:	75 bf                	jne    113b <main+0x13b>
    printf(1, "init: starting sh\n");
    117c:	e9 07 ff ff ff       	jmpq   1088 <main+0x88>

0000000000001181 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1181:	f3 0f 1e fa          	endbr64 
    1185:	55                   	push   %rbp
    1186:	48 89 e5             	mov    %rsp,%rbp
    1189:	48 83 ec 10          	sub    $0x10,%rsp
    118d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1191:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1194:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    1197:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    119b:	8b 55 f0             	mov    -0x10(%rbp),%edx
    119e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    11a1:	48 89 ce             	mov    %rcx,%rsi
    11a4:	48 89 f7             	mov    %rsi,%rdi
    11a7:	89 d1                	mov    %edx,%ecx
    11a9:	fc                   	cld    
    11aa:	f3 aa                	rep stos %al,%es:(%rdi)
    11ac:	89 ca                	mov    %ecx,%edx
    11ae:	48 89 fe             	mov    %rdi,%rsi
    11b1:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    11b5:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11b8:	90                   	nop
    11b9:	c9                   	leaveq 
    11ba:	c3                   	retq   

00000000000011bb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11bb:	f3 0f 1e fa          	endbr64 
    11bf:	55                   	push   %rbp
    11c0:	48 89 e5             	mov    %rsp,%rbp
    11c3:	48 83 ec 20          	sub    $0x20,%rsp
    11c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    11cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    11cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    11d7:	90                   	nop
    11d8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    11dc:	48 8d 42 01          	lea    0x1(%rdx),%rax
    11e0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    11e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11e8:	48 8d 48 01          	lea    0x1(%rax),%rcx
    11ec:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    11f0:	0f b6 12             	movzbl (%rdx),%edx
    11f3:	88 10                	mov    %dl,(%rax)
    11f5:	0f b6 00             	movzbl (%rax),%eax
    11f8:	84 c0                	test   %al,%al
    11fa:	75 dc                	jne    11d8 <strcpy+0x1d>
    ;
  return os;
    11fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1200:	c9                   	leaveq 
    1201:	c3                   	retq   

0000000000001202 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1202:	f3 0f 1e fa          	endbr64 
    1206:	55                   	push   %rbp
    1207:	48 89 e5             	mov    %rsp,%rbp
    120a:	48 83 ec 10          	sub    $0x10,%rsp
    120e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1212:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1216:	eb 0a                	jmp    1222 <strcmp+0x20>
    p++, q++;
    1218:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    121d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1222:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1226:	0f b6 00             	movzbl (%rax),%eax
    1229:	84 c0                	test   %al,%al
    122b:	74 12                	je     123f <strcmp+0x3d>
    122d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1231:	0f b6 10             	movzbl (%rax),%edx
    1234:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1238:	0f b6 00             	movzbl (%rax),%eax
    123b:	38 c2                	cmp    %al,%dl
    123d:	74 d9                	je     1218 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    123f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1243:	0f b6 00             	movzbl (%rax),%eax
    1246:	0f b6 d0             	movzbl %al,%edx
    1249:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    124d:	0f b6 00             	movzbl (%rax),%eax
    1250:	0f b6 c0             	movzbl %al,%eax
    1253:	29 c2                	sub    %eax,%edx
    1255:	89 d0                	mov    %edx,%eax
}
    1257:	c9                   	leaveq 
    1258:	c3                   	retq   

0000000000001259 <strlen>:

uint
strlen(char *s)
{
    1259:	f3 0f 1e fa          	endbr64 
    125d:	55                   	push   %rbp
    125e:	48 89 e5             	mov    %rsp,%rbp
    1261:	48 83 ec 18          	sub    $0x18,%rsp
    1265:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1269:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1270:	eb 04                	jmp    1276 <strlen+0x1d>
    1272:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1276:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1279:	48 63 d0             	movslq %eax,%rdx
    127c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1280:	48 01 d0             	add    %rdx,%rax
    1283:	0f b6 00             	movzbl (%rax),%eax
    1286:	84 c0                	test   %al,%al
    1288:	75 e8                	jne    1272 <strlen+0x19>
    ;
  return n;
    128a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    128d:	c9                   	leaveq 
    128e:	c3                   	retq   

000000000000128f <memset>:

void*
memset(void *dst, int c, uint n)
{
    128f:	f3 0f 1e fa          	endbr64 
    1293:	55                   	push   %rbp
    1294:	48 89 e5             	mov    %rsp,%rbp
    1297:	48 83 ec 10          	sub    $0x10,%rsp
    129b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    129f:	89 75 f4             	mov    %esi,-0xc(%rbp)
    12a2:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    12a5:	8b 55 f0             	mov    -0x10(%rbp),%edx
    12a8:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    12ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12af:	89 ce                	mov    %ecx,%esi
    12b1:	48 89 c7             	mov    %rax,%rdi
    12b4:	48 b8 81 11 00 00 00 	movabs $0x1181,%rax
    12bb:	00 00 00 
    12be:	ff d0                	callq  *%rax
  return dst;
    12c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    12c4:	c9                   	leaveq 
    12c5:	c3                   	retq   

00000000000012c6 <strchr>:

char*
strchr(const char *s, char c)
{
    12c6:	f3 0f 1e fa          	endbr64 
    12ca:	55                   	push   %rbp
    12cb:	48 89 e5             	mov    %rsp,%rbp
    12ce:	48 83 ec 10          	sub    $0x10,%rsp
    12d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12d6:	89 f0                	mov    %esi,%eax
    12d8:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    12db:	eb 17                	jmp    12f4 <strchr+0x2e>
    if(*s == c)
    12dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12e1:	0f b6 00             	movzbl (%rax),%eax
    12e4:	38 45 f4             	cmp    %al,-0xc(%rbp)
    12e7:	75 06                	jne    12ef <strchr+0x29>
      return (char*)s;
    12e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12ed:	eb 15                	jmp    1304 <strchr+0x3e>
  for(; *s; s++)
    12ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    12f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12f8:	0f b6 00             	movzbl (%rax),%eax
    12fb:	84 c0                	test   %al,%al
    12fd:	75 de                	jne    12dd <strchr+0x17>
  return 0;
    12ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1304:	c9                   	leaveq 
    1305:	c3                   	retq   

0000000000001306 <gets>:

char*
gets(char *buf, int max)
{
    1306:	f3 0f 1e fa          	endbr64 
    130a:	55                   	push   %rbp
    130b:	48 89 e5             	mov    %rsp,%rbp
    130e:	48 83 ec 20          	sub    $0x20,%rsp
    1312:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1316:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1319:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1320:	eb 4f                	jmp    1371 <gets+0x6b>
    cc = read(0, &c, 1);
    1322:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1326:	ba 01 00 00 00       	mov    $0x1,%edx
    132b:	48 89 c6             	mov    %rax,%rsi
    132e:	bf 00 00 00 00       	mov    $0x0,%edi
    1333:	48 b8 eb 14 00 00 00 	movabs $0x14eb,%rax
    133a:	00 00 00 
    133d:	ff d0                	callq  *%rax
    133f:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1342:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1346:	7e 36                	jle    137e <gets+0x78>
      break;
    buf[i++] = c;
    1348:	8b 45 fc             	mov    -0x4(%rbp),%eax
    134b:	8d 50 01             	lea    0x1(%rax),%edx
    134e:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1351:	48 63 d0             	movslq %eax,%rdx
    1354:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1358:	48 01 c2             	add    %rax,%rdx
    135b:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    135f:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1361:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1365:	3c 0a                	cmp    $0xa,%al
    1367:	74 16                	je     137f <gets+0x79>
    1369:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    136d:	3c 0d                	cmp    $0xd,%al
    136f:	74 0e                	je     137f <gets+0x79>
  for(i=0; i+1 < max; ){
    1371:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1374:	83 c0 01             	add    $0x1,%eax
    1377:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    137a:	7f a6                	jg     1322 <gets+0x1c>
    137c:	eb 01                	jmp    137f <gets+0x79>
      break;
    137e:	90                   	nop
      break;
  }
  buf[i] = '\0';
    137f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1382:	48 63 d0             	movslq %eax,%rdx
    1385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1389:	48 01 d0             	add    %rdx,%rax
    138c:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    138f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1393:	c9                   	leaveq 
    1394:	c3                   	retq   

0000000000001395 <stat>:

int
stat(char *n, struct stat *st)
{
    1395:	f3 0f 1e fa          	endbr64 
    1399:	55                   	push   %rbp
    139a:	48 89 e5             	mov    %rsp,%rbp
    139d:	48 83 ec 20          	sub    $0x20,%rsp
    13a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13ad:	be 00 00 00 00       	mov    $0x0,%esi
    13b2:	48 89 c7             	mov    %rax,%rdi
    13b5:	48 b8 2c 15 00 00 00 	movabs $0x152c,%rax
    13bc:	00 00 00 
    13bf:	ff d0                	callq  *%rax
    13c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    13c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    13c8:	79 07                	jns    13d1 <stat+0x3c>
    return -1;
    13ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    13cf:	eb 2f                	jmp    1400 <stat+0x6b>
  r = fstat(fd, st);
    13d1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    13d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13d8:	48 89 d6             	mov    %rdx,%rsi
    13db:	89 c7                	mov    %eax,%edi
    13dd:	48 b8 53 15 00 00 00 	movabs $0x1553,%rax
    13e4:	00 00 00 
    13e7:	ff d0                	callq  *%rax
    13e9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    13ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13ef:	89 c7                	mov    %eax,%edi
    13f1:	48 b8 05 15 00 00 00 	movabs $0x1505,%rax
    13f8:	00 00 00 
    13fb:	ff d0                	callq  *%rax
  return r;
    13fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1400:	c9                   	leaveq 
    1401:	c3                   	retq   

0000000000001402 <atoi>:

int
atoi(const char *s)
{
    1402:	f3 0f 1e fa          	endbr64 
    1406:	55                   	push   %rbp
    1407:	48 89 e5             	mov    %rsp,%rbp
    140a:	48 83 ec 18          	sub    $0x18,%rsp
    140e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1412:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1419:	eb 28                	jmp    1443 <atoi+0x41>
    n = n*10 + *s++ - '0';
    141b:	8b 55 fc             	mov    -0x4(%rbp),%edx
    141e:	89 d0                	mov    %edx,%eax
    1420:	c1 e0 02             	shl    $0x2,%eax
    1423:	01 d0                	add    %edx,%eax
    1425:	01 c0                	add    %eax,%eax
    1427:	89 c1                	mov    %eax,%ecx
    1429:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    142d:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1431:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1435:	0f b6 00             	movzbl (%rax),%eax
    1438:	0f be c0             	movsbl %al,%eax
    143b:	01 c8                	add    %ecx,%eax
    143d:	83 e8 30             	sub    $0x30,%eax
    1440:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1447:	0f b6 00             	movzbl (%rax),%eax
    144a:	3c 2f                	cmp    $0x2f,%al
    144c:	7e 0b                	jle    1459 <atoi+0x57>
    144e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1452:	0f b6 00             	movzbl (%rax),%eax
    1455:	3c 39                	cmp    $0x39,%al
    1457:	7e c2                	jle    141b <atoi+0x19>
  return n;
    1459:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    145c:	c9                   	leaveq 
    145d:	c3                   	retq   

000000000000145e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    145e:	f3 0f 1e fa          	endbr64 
    1462:	55                   	push   %rbp
    1463:	48 89 e5             	mov    %rsp,%rbp
    1466:	48 83 ec 28          	sub    $0x28,%rsp
    146a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    146e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1472:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1479:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    147d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1481:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1485:	eb 1d                	jmp    14a4 <memmove+0x46>
    *dst++ = *src++;
    1487:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    148b:	48 8d 42 01          	lea    0x1(%rdx),%rax
    148f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1497:	48 8d 48 01          	lea    0x1(%rax),%rcx
    149b:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    149f:	0f b6 12             	movzbl (%rdx),%edx
    14a2:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    14a4:	8b 45 dc             	mov    -0x24(%rbp),%eax
    14a7:	8d 50 ff             	lea    -0x1(%rax),%edx
    14aa:	89 55 dc             	mov    %edx,-0x24(%rbp)
    14ad:	85 c0                	test   %eax,%eax
    14af:	7f d6                	jg     1487 <memmove+0x29>
  return vdst;
    14b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    14b5:	c9                   	leaveq 
    14b6:	c3                   	retq   

00000000000014b7 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    14b7:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    14be:	49 89 ca             	mov    %rcx,%r10
    14c1:	0f 05                	syscall 
    14c3:	c3                   	retq   

00000000000014c4 <exit>:
SYSCALL(exit)
    14c4:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    14cb:	49 89 ca             	mov    %rcx,%r10
    14ce:	0f 05                	syscall 
    14d0:	c3                   	retq   

00000000000014d1 <wait>:
SYSCALL(wait)
    14d1:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    14d8:	49 89 ca             	mov    %rcx,%r10
    14db:	0f 05                	syscall 
    14dd:	c3                   	retq   

00000000000014de <pipe>:
SYSCALL(pipe)
    14de:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    14e5:	49 89 ca             	mov    %rcx,%r10
    14e8:	0f 05                	syscall 
    14ea:	c3                   	retq   

00000000000014eb <read>:
SYSCALL(read)
    14eb:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    14f2:	49 89 ca             	mov    %rcx,%r10
    14f5:	0f 05                	syscall 
    14f7:	c3                   	retq   

00000000000014f8 <write>:
SYSCALL(write)
    14f8:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    14ff:	49 89 ca             	mov    %rcx,%r10
    1502:	0f 05                	syscall 
    1504:	c3                   	retq   

0000000000001505 <close>:
SYSCALL(close)
    1505:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    150c:	49 89 ca             	mov    %rcx,%r10
    150f:	0f 05                	syscall 
    1511:	c3                   	retq   

0000000000001512 <kill>:
SYSCALL(kill)
    1512:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1519:	49 89 ca             	mov    %rcx,%r10
    151c:	0f 05                	syscall 
    151e:	c3                   	retq   

000000000000151f <exec>:
SYSCALL(exec)
    151f:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1526:	49 89 ca             	mov    %rcx,%r10
    1529:	0f 05                	syscall 
    152b:	c3                   	retq   

000000000000152c <open>:
SYSCALL(open)
    152c:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1533:	49 89 ca             	mov    %rcx,%r10
    1536:	0f 05                	syscall 
    1538:	c3                   	retq   

0000000000001539 <mknod>:
SYSCALL(mknod)
    1539:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1540:	49 89 ca             	mov    %rcx,%r10
    1543:	0f 05                	syscall 
    1545:	c3                   	retq   

0000000000001546 <unlink>:
SYSCALL(unlink)
    1546:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    154d:	49 89 ca             	mov    %rcx,%r10
    1550:	0f 05                	syscall 
    1552:	c3                   	retq   

0000000000001553 <fstat>:
SYSCALL(fstat)
    1553:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    155a:	49 89 ca             	mov    %rcx,%r10
    155d:	0f 05                	syscall 
    155f:	c3                   	retq   

0000000000001560 <link>:
SYSCALL(link)
    1560:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1567:	49 89 ca             	mov    %rcx,%r10
    156a:	0f 05                	syscall 
    156c:	c3                   	retq   

000000000000156d <mkdir>:
SYSCALL(mkdir)
    156d:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1574:	49 89 ca             	mov    %rcx,%r10
    1577:	0f 05                	syscall 
    1579:	c3                   	retq   

000000000000157a <chdir>:
SYSCALL(chdir)
    157a:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1581:	49 89 ca             	mov    %rcx,%r10
    1584:	0f 05                	syscall 
    1586:	c3                   	retq   

0000000000001587 <dup>:
SYSCALL(dup)
    1587:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    158e:	49 89 ca             	mov    %rcx,%r10
    1591:	0f 05                	syscall 
    1593:	c3                   	retq   

0000000000001594 <getpid>:
SYSCALL(getpid)
    1594:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    159b:	49 89 ca             	mov    %rcx,%r10
    159e:	0f 05                	syscall 
    15a0:	c3                   	retq   

00000000000015a1 <sbrk>:
SYSCALL(sbrk)
    15a1:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    15a8:	49 89 ca             	mov    %rcx,%r10
    15ab:	0f 05                	syscall 
    15ad:	c3                   	retq   

00000000000015ae <sleep>:
SYSCALL(sleep)
    15ae:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    15b5:	49 89 ca             	mov    %rcx,%r10
    15b8:	0f 05                	syscall 
    15ba:	c3                   	retq   

00000000000015bb <uptime>:
SYSCALL(uptime)
    15bb:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    15c2:	49 89 ca             	mov    %rcx,%r10
    15c5:	0f 05                	syscall 
    15c7:	c3                   	retq   

00000000000015c8 <dedup>:
SYSCALL(dedup)
    15c8:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    15cf:	49 89 ca             	mov    %rcx,%r10
    15d2:	0f 05                	syscall 
    15d4:	c3                   	retq   

00000000000015d5 <freepages>:
SYSCALL(freepages)
    15d5:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    15dc:	49 89 ca             	mov    %rcx,%r10
    15df:	0f 05                	syscall 
    15e1:	c3                   	retq   

00000000000015e2 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    15e2:	f3 0f 1e fa          	endbr64 
    15e6:	55                   	push   %rbp
    15e7:	48 89 e5             	mov    %rsp,%rbp
    15ea:	48 83 ec 10          	sub    $0x10,%rsp
    15ee:	89 7d fc             	mov    %edi,-0x4(%rbp)
    15f1:	89 f0                	mov    %esi,%eax
    15f3:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    15f6:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    15fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15fd:	ba 01 00 00 00       	mov    $0x1,%edx
    1602:	48 89 ce             	mov    %rcx,%rsi
    1605:	89 c7                	mov    %eax,%edi
    1607:	48 b8 f8 14 00 00 00 	movabs $0x14f8,%rax
    160e:	00 00 00 
    1611:	ff d0                	callq  *%rax
}
    1613:	90                   	nop
    1614:	c9                   	leaveq 
    1615:	c3                   	retq   

0000000000001616 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1616:	f3 0f 1e fa          	endbr64 
    161a:	55                   	push   %rbp
    161b:	48 89 e5             	mov    %rsp,%rbp
    161e:	48 83 ec 20          	sub    $0x20,%rsp
    1622:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1625:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1629:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1630:	eb 35                	jmp    1667 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1632:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1636:	48 c1 e8 3c          	shr    $0x3c,%rax
    163a:	48 ba 70 22 00 00 00 	movabs $0x2270,%rdx
    1641:	00 00 00 
    1644:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1648:	0f be d0             	movsbl %al,%edx
    164b:	8b 45 ec             	mov    -0x14(%rbp),%eax
    164e:	89 d6                	mov    %edx,%esi
    1650:	89 c7                	mov    %eax,%edi
    1652:	48 b8 e2 15 00 00 00 	movabs $0x15e2,%rax
    1659:	00 00 00 
    165c:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    165e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1662:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1667:	8b 45 fc             	mov    -0x4(%rbp),%eax
    166a:	83 f8 0f             	cmp    $0xf,%eax
    166d:	76 c3                	jbe    1632 <print_x64+0x1c>
}
    166f:	90                   	nop
    1670:	90                   	nop
    1671:	c9                   	leaveq 
    1672:	c3                   	retq   

0000000000001673 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1673:	f3 0f 1e fa          	endbr64 
    1677:	55                   	push   %rbp
    1678:	48 89 e5             	mov    %rsp,%rbp
    167b:	48 83 ec 20          	sub    $0x20,%rsp
    167f:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1682:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1685:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    168c:	eb 36                	jmp    16c4 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    168e:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1691:	c1 e8 1c             	shr    $0x1c,%eax
    1694:	89 c2                	mov    %eax,%edx
    1696:	48 b8 70 22 00 00 00 	movabs $0x2270,%rax
    169d:	00 00 00 
    16a0:	89 d2                	mov    %edx,%edx
    16a2:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    16a6:	0f be d0             	movsbl %al,%edx
    16a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
    16ac:	89 d6                	mov    %edx,%esi
    16ae:	89 c7                	mov    %eax,%edi
    16b0:	48 b8 e2 15 00 00 00 	movabs $0x15e2,%rax
    16b7:	00 00 00 
    16ba:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16bc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    16c0:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    16c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16c7:	83 f8 07             	cmp    $0x7,%eax
    16ca:	76 c2                	jbe    168e <print_x32+0x1b>
}
    16cc:	90                   	nop
    16cd:	90                   	nop
    16ce:	c9                   	leaveq 
    16cf:	c3                   	retq   

00000000000016d0 <print_d>:

  static void
print_d(int fd, int v)
{
    16d0:	f3 0f 1e fa          	endbr64 
    16d4:	55                   	push   %rbp
    16d5:	48 89 e5             	mov    %rsp,%rbp
    16d8:	48 83 ec 30          	sub    $0x30,%rsp
    16dc:	89 7d dc             	mov    %edi,-0x24(%rbp)
    16df:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    16e2:	8b 45 d8             	mov    -0x28(%rbp),%eax
    16e5:	48 98                	cltq   
    16e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    16eb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    16ef:	79 04                	jns    16f5 <print_d+0x25>
    x = -x;
    16f1:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    16f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    16fc:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1700:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1707:	66 66 66 
    170a:	48 89 c8             	mov    %rcx,%rax
    170d:	48 f7 ea             	imul   %rdx
    1710:	48 c1 fa 02          	sar    $0x2,%rdx
    1714:	48 89 c8             	mov    %rcx,%rax
    1717:	48 c1 f8 3f          	sar    $0x3f,%rax
    171b:	48 29 c2             	sub    %rax,%rdx
    171e:	48 89 d0             	mov    %rdx,%rax
    1721:	48 c1 e0 02          	shl    $0x2,%rax
    1725:	48 01 d0             	add    %rdx,%rax
    1728:	48 01 c0             	add    %rax,%rax
    172b:	48 29 c1             	sub    %rax,%rcx
    172e:	48 89 ca             	mov    %rcx,%rdx
    1731:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1734:	8d 48 01             	lea    0x1(%rax),%ecx
    1737:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    173a:	48 b9 70 22 00 00 00 	movabs $0x2270,%rcx
    1741:	00 00 00 
    1744:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1748:	48 98                	cltq   
    174a:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    174e:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1752:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1759:	66 66 66 
    175c:	48 89 c8             	mov    %rcx,%rax
    175f:	48 f7 ea             	imul   %rdx
    1762:	48 c1 fa 02          	sar    $0x2,%rdx
    1766:	48 89 c8             	mov    %rcx,%rax
    1769:	48 c1 f8 3f          	sar    $0x3f,%rax
    176d:	48 29 c2             	sub    %rax,%rdx
    1770:	48 89 d0             	mov    %rdx,%rax
    1773:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1777:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    177c:	0f 85 7a ff ff ff    	jne    16fc <print_d+0x2c>

  if (v < 0)
    1782:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1786:	79 32                	jns    17ba <print_d+0xea>
    buf[i++] = '-';
    1788:	8b 45 f4             	mov    -0xc(%rbp),%eax
    178b:	8d 50 01             	lea    0x1(%rax),%edx
    178e:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1791:	48 98                	cltq   
    1793:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1798:	eb 20                	jmp    17ba <print_d+0xea>
    putc(fd, buf[i]);
    179a:	8b 45 f4             	mov    -0xc(%rbp),%eax
    179d:	48 98                	cltq   
    179f:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    17a4:	0f be d0             	movsbl %al,%edx
    17a7:	8b 45 dc             	mov    -0x24(%rbp),%eax
    17aa:	89 d6                	mov    %edx,%esi
    17ac:	89 c7                	mov    %eax,%edi
    17ae:	48 b8 e2 15 00 00 00 	movabs $0x15e2,%rax
    17b5:	00 00 00 
    17b8:	ff d0                	callq  *%rax
  while (--i >= 0)
    17ba:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    17be:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    17c2:	79 d6                	jns    179a <print_d+0xca>
}
    17c4:	90                   	nop
    17c5:	90                   	nop
    17c6:	c9                   	leaveq 
    17c7:	c3                   	retq   

00000000000017c8 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    17c8:	f3 0f 1e fa          	endbr64 
    17cc:	55                   	push   %rbp
    17cd:	48 89 e5             	mov    %rsp,%rbp
    17d0:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    17d7:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    17dd:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    17e4:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    17eb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    17f2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    17f9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1800:	84 c0                	test   %al,%al
    1802:	74 20                	je     1824 <printf+0x5c>
    1804:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1808:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    180c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1810:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1814:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1818:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    181c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1820:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1824:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    182b:	00 00 00 
    182e:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1835:	00 00 00 
    1838:	48 8d 45 10          	lea    0x10(%rbp),%rax
    183c:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1843:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    184a:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1851:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1858:	00 00 00 
    185b:	e9 41 03 00 00       	jmpq   1ba1 <printf+0x3d9>
    if (c != '%') {
    1860:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1867:	74 24                	je     188d <printf+0xc5>
      putc(fd, c);
    1869:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    186f:	0f be d0             	movsbl %al,%edx
    1872:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1878:	89 d6                	mov    %edx,%esi
    187a:	89 c7                	mov    %eax,%edi
    187c:	48 b8 e2 15 00 00 00 	movabs $0x15e2,%rax
    1883:	00 00 00 
    1886:	ff d0                	callq  *%rax
      continue;
    1888:	e9 0d 03 00 00       	jmpq   1b9a <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    188d:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1894:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    189a:	48 63 d0             	movslq %eax,%rdx
    189d:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    18a4:	48 01 d0             	add    %rdx,%rax
    18a7:	0f b6 00             	movzbl (%rax),%eax
    18aa:	0f be c0             	movsbl %al,%eax
    18ad:	25 ff 00 00 00       	and    $0xff,%eax
    18b2:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    18b8:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    18bf:	0f 84 0f 03 00 00    	je     1bd4 <printf+0x40c>
      break;
    switch(c) {
    18c5:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18cc:	0f 84 74 02 00 00    	je     1b46 <printf+0x37e>
    18d2:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18d9:	0f 8c 82 02 00 00    	jl     1b61 <printf+0x399>
    18df:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    18e6:	0f 8f 75 02 00 00    	jg     1b61 <printf+0x399>
    18ec:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    18f3:	0f 8c 68 02 00 00    	jl     1b61 <printf+0x399>
    18f9:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    18ff:	83 e8 63             	sub    $0x63,%eax
    1902:	83 f8 15             	cmp    $0x15,%eax
    1905:	0f 87 56 02 00 00    	ja     1b61 <printf+0x399>
    190b:	89 c0                	mov    %eax,%eax
    190d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1914:	00 
    1915:	48 b8 38 1f 00 00 00 	movabs $0x1f38,%rax
    191c:	00 00 00 
    191f:	48 01 d0             	add    %rdx,%rax
    1922:	48 8b 00             	mov    (%rax),%rax
    1925:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1928:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    192e:	83 f8 2f             	cmp    $0x2f,%eax
    1931:	77 23                	ja     1956 <printf+0x18e>
    1933:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    193a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1940:	89 d2                	mov    %edx,%edx
    1942:	48 01 d0             	add    %rdx,%rax
    1945:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    194b:	83 c2 08             	add    $0x8,%edx
    194e:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1954:	eb 12                	jmp    1968 <printf+0x1a0>
    1956:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    195d:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1961:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1968:	8b 00                	mov    (%rax),%eax
    196a:	0f be d0             	movsbl %al,%edx
    196d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1973:	89 d6                	mov    %edx,%esi
    1975:	89 c7                	mov    %eax,%edi
    1977:	48 b8 e2 15 00 00 00 	movabs $0x15e2,%rax
    197e:	00 00 00 
    1981:	ff d0                	callq  *%rax
      break;
    1983:	e9 12 02 00 00       	jmpq   1b9a <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1988:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    198e:	83 f8 2f             	cmp    $0x2f,%eax
    1991:	77 23                	ja     19b6 <printf+0x1ee>
    1993:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    199a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19a0:	89 d2                	mov    %edx,%edx
    19a2:	48 01 d0             	add    %rdx,%rax
    19a5:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19ab:	83 c2 08             	add    $0x8,%edx
    19ae:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19b4:	eb 12                	jmp    19c8 <printf+0x200>
    19b6:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19bd:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19c1:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19c8:	8b 10                	mov    (%rax),%edx
    19ca:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19d0:	89 d6                	mov    %edx,%esi
    19d2:	89 c7                	mov    %eax,%edi
    19d4:	48 b8 d0 16 00 00 00 	movabs $0x16d0,%rax
    19db:	00 00 00 
    19de:	ff d0                	callq  *%rax
      break;
    19e0:	e9 b5 01 00 00       	jmpq   1b9a <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    19e5:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19eb:	83 f8 2f             	cmp    $0x2f,%eax
    19ee:	77 23                	ja     1a13 <printf+0x24b>
    19f0:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19f7:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19fd:	89 d2                	mov    %edx,%edx
    19ff:	48 01 d0             	add    %rdx,%rax
    1a02:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a08:	83 c2 08             	add    $0x8,%edx
    1a0b:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a11:	eb 12                	jmp    1a25 <printf+0x25d>
    1a13:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a1a:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a1e:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a25:	8b 10                	mov    (%rax),%edx
    1a27:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a2d:	89 d6                	mov    %edx,%esi
    1a2f:	89 c7                	mov    %eax,%edi
    1a31:	48 b8 73 16 00 00 00 	movabs $0x1673,%rax
    1a38:	00 00 00 
    1a3b:	ff d0                	callq  *%rax
      break;
    1a3d:	e9 58 01 00 00       	jmpq   1b9a <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1a42:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a48:	83 f8 2f             	cmp    $0x2f,%eax
    1a4b:	77 23                	ja     1a70 <printf+0x2a8>
    1a4d:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a54:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a5a:	89 d2                	mov    %edx,%edx
    1a5c:	48 01 d0             	add    %rdx,%rax
    1a5f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a65:	83 c2 08             	add    $0x8,%edx
    1a68:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a6e:	eb 12                	jmp    1a82 <printf+0x2ba>
    1a70:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a77:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a7b:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a82:	48 8b 10             	mov    (%rax),%rdx
    1a85:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a8b:	48 89 d6             	mov    %rdx,%rsi
    1a8e:	89 c7                	mov    %eax,%edi
    1a90:	48 b8 16 16 00 00 00 	movabs $0x1616,%rax
    1a97:	00 00 00 
    1a9a:	ff d0                	callq  *%rax
      break;
    1a9c:	e9 f9 00 00 00       	jmpq   1b9a <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1aa1:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1aa7:	83 f8 2f             	cmp    $0x2f,%eax
    1aaa:	77 23                	ja     1acf <printf+0x307>
    1aac:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1ab3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ab9:	89 d2                	mov    %edx,%edx
    1abb:	48 01 d0             	add    %rdx,%rax
    1abe:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ac4:	83 c2 08             	add    $0x8,%edx
    1ac7:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1acd:	eb 12                	jmp    1ae1 <printf+0x319>
    1acf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1ad6:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1ada:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1ae1:	48 8b 00             	mov    (%rax),%rax
    1ae4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1aeb:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1af2:	00 
    1af3:	75 41                	jne    1b36 <printf+0x36e>
        s = "(null)";
    1af5:	48 b8 30 1f 00 00 00 	movabs $0x1f30,%rax
    1afc:	00 00 00 
    1aff:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1b06:	eb 2e                	jmp    1b36 <printf+0x36e>
        putc(fd, *(s++));
    1b08:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b0f:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1b13:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1b1a:	0f b6 00             	movzbl (%rax),%eax
    1b1d:	0f be d0             	movsbl %al,%edx
    1b20:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b26:	89 d6                	mov    %edx,%esi
    1b28:	89 c7                	mov    %eax,%edi
    1b2a:	48 b8 e2 15 00 00 00 	movabs $0x15e2,%rax
    1b31:	00 00 00 
    1b34:	ff d0                	callq  *%rax
      while (*s)
    1b36:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b3d:	0f b6 00             	movzbl (%rax),%eax
    1b40:	84 c0                	test   %al,%al
    1b42:	75 c4                	jne    1b08 <printf+0x340>
      break;
    1b44:	eb 54                	jmp    1b9a <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1b46:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b4c:	be 25 00 00 00       	mov    $0x25,%esi
    1b51:	89 c7                	mov    %eax,%edi
    1b53:	48 b8 e2 15 00 00 00 	movabs $0x15e2,%rax
    1b5a:	00 00 00 
    1b5d:	ff d0                	callq  *%rax
      break;
    1b5f:	eb 39                	jmp    1b9a <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1b61:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b67:	be 25 00 00 00       	mov    $0x25,%esi
    1b6c:	89 c7                	mov    %eax,%edi
    1b6e:	48 b8 e2 15 00 00 00 	movabs $0x15e2,%rax
    1b75:	00 00 00 
    1b78:	ff d0                	callq  *%rax
      putc(fd, c);
    1b7a:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1b80:	0f be d0             	movsbl %al,%edx
    1b83:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b89:	89 d6                	mov    %edx,%esi
    1b8b:	89 c7                	mov    %eax,%edi
    1b8d:	48 b8 e2 15 00 00 00 	movabs $0x15e2,%rax
    1b94:	00 00 00 
    1b97:	ff d0                	callq  *%rax
      break;
    1b99:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1b9a:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1ba1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1ba7:	48 63 d0             	movslq %eax,%rdx
    1baa:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1bb1:	48 01 d0             	add    %rdx,%rax
    1bb4:	0f b6 00             	movzbl (%rax),%eax
    1bb7:	0f be c0             	movsbl %al,%eax
    1bba:	25 ff 00 00 00       	and    $0xff,%eax
    1bbf:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1bc5:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1bcc:	0f 85 8e fc ff ff    	jne    1860 <printf+0x98>
    }
  }
}
    1bd2:	eb 01                	jmp    1bd5 <printf+0x40d>
      break;
    1bd4:	90                   	nop
}
    1bd5:	90                   	nop
    1bd6:	c9                   	leaveq 
    1bd7:	c3                   	retq   

0000000000001bd8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1bd8:	f3 0f 1e fa          	endbr64 
    1bdc:	55                   	push   %rbp
    1bdd:	48 89 e5             	mov    %rsp,%rbp
    1be0:	48 83 ec 18          	sub    $0x18,%rsp
    1be4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1be8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1bec:	48 83 e8 10          	sub    $0x10,%rax
    1bf0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1bf4:	48 b8 a0 22 00 00 00 	movabs $0x22a0,%rax
    1bfb:	00 00 00 
    1bfe:	48 8b 00             	mov    (%rax),%rax
    1c01:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c05:	eb 2f                	jmp    1c36 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1c07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c0b:	48 8b 00             	mov    (%rax),%rax
    1c0e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c12:	72 17                	jb     1c2b <free+0x53>
    1c14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c18:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c1c:	77 2f                	ja     1c4d <free+0x75>
    1c1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c22:	48 8b 00             	mov    (%rax),%rax
    1c25:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c29:	72 22                	jb     1c4d <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c2f:	48 8b 00             	mov    (%rax),%rax
    1c32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c3a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c3e:	76 c7                	jbe    1c07 <free+0x2f>
    1c40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c44:	48 8b 00             	mov    (%rax),%rax
    1c47:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c4b:	73 ba                	jae    1c07 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1c4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c51:	8b 40 08             	mov    0x8(%rax),%eax
    1c54:	89 c0                	mov    %eax,%eax
    1c56:	48 c1 e0 04          	shl    $0x4,%rax
    1c5a:	48 89 c2             	mov    %rax,%rdx
    1c5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c61:	48 01 c2             	add    %rax,%rdx
    1c64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c68:	48 8b 00             	mov    (%rax),%rax
    1c6b:	48 39 c2             	cmp    %rax,%rdx
    1c6e:	75 2d                	jne    1c9d <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1c70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c74:	8b 50 08             	mov    0x8(%rax),%edx
    1c77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c7b:	48 8b 00             	mov    (%rax),%rax
    1c7e:	8b 40 08             	mov    0x8(%rax),%eax
    1c81:	01 c2                	add    %eax,%edx
    1c83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c87:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1c8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c8e:	48 8b 00             	mov    (%rax),%rax
    1c91:	48 8b 10             	mov    (%rax),%rdx
    1c94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c98:	48 89 10             	mov    %rdx,(%rax)
    1c9b:	eb 0e                	jmp    1cab <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1c9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ca1:	48 8b 10             	mov    (%rax),%rdx
    1ca4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ca8:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1cab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1caf:	8b 40 08             	mov    0x8(%rax),%eax
    1cb2:	89 c0                	mov    %eax,%eax
    1cb4:	48 c1 e0 04          	shl    $0x4,%rax
    1cb8:	48 89 c2             	mov    %rax,%rdx
    1cbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cbf:	48 01 d0             	add    %rdx,%rax
    1cc2:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1cc6:	75 27                	jne    1cef <free+0x117>
    p->s.size += bp->s.size;
    1cc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ccc:	8b 50 08             	mov    0x8(%rax),%edx
    1ccf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cd3:	8b 40 08             	mov    0x8(%rax),%eax
    1cd6:	01 c2                	add    %eax,%edx
    1cd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cdc:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1cdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ce3:	48 8b 10             	mov    (%rax),%rdx
    1ce6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cea:	48 89 10             	mov    %rdx,(%rax)
    1ced:	eb 0b                	jmp    1cfa <free+0x122>
  } else
    p->s.ptr = bp;
    1cef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cf3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1cf7:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1cfa:	48 ba a0 22 00 00 00 	movabs $0x22a0,%rdx
    1d01:	00 00 00 
    1d04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d08:	48 89 02             	mov    %rax,(%rdx)
}
    1d0b:	90                   	nop
    1d0c:	c9                   	leaveq 
    1d0d:	c3                   	retq   

0000000000001d0e <morecore>:

static Header*
morecore(uint nu)
{
    1d0e:	f3 0f 1e fa          	endbr64 
    1d12:	55                   	push   %rbp
    1d13:	48 89 e5             	mov    %rsp,%rbp
    1d16:	48 83 ec 20          	sub    $0x20,%rsp
    1d1a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1d1d:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1d24:	77 07                	ja     1d2d <morecore+0x1f>
    nu = 4096;
    1d26:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1d2d:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d30:	48 c1 e0 04          	shl    $0x4,%rax
    1d34:	48 89 c7             	mov    %rax,%rdi
    1d37:	48 b8 a1 15 00 00 00 	movabs $0x15a1,%rax
    1d3e:	00 00 00 
    1d41:	ff d0                	callq  *%rax
    1d43:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1d47:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1d4c:	75 07                	jne    1d55 <morecore+0x47>
    return 0;
    1d4e:	b8 00 00 00 00       	mov    $0x0,%eax
    1d53:	eb 36                	jmp    1d8b <morecore+0x7d>
  hp = (Header*)p;
    1d55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d59:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1d5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d61:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d64:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1d67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d6b:	48 83 c0 10          	add    $0x10,%rax
    1d6f:	48 89 c7             	mov    %rax,%rdi
    1d72:	48 b8 d8 1b 00 00 00 	movabs $0x1bd8,%rax
    1d79:	00 00 00 
    1d7c:	ff d0                	callq  *%rax
  return freep;
    1d7e:	48 b8 a0 22 00 00 00 	movabs $0x22a0,%rax
    1d85:	00 00 00 
    1d88:	48 8b 00             	mov    (%rax),%rax
}
    1d8b:	c9                   	leaveq 
    1d8c:	c3                   	retq   

0000000000001d8d <malloc>:

void*
malloc(uint nbytes)
{
    1d8d:	f3 0f 1e fa          	endbr64 
    1d91:	55                   	push   %rbp
    1d92:	48 89 e5             	mov    %rsp,%rbp
    1d95:	48 83 ec 30          	sub    $0x30,%rsp
    1d99:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1d9c:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1d9f:	48 83 c0 0f          	add    $0xf,%rax
    1da3:	48 c1 e8 04          	shr    $0x4,%rax
    1da7:	83 c0 01             	add    $0x1,%eax
    1daa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1dad:	48 b8 a0 22 00 00 00 	movabs $0x22a0,%rax
    1db4:	00 00 00 
    1db7:	48 8b 00             	mov    (%rax),%rax
    1dba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1dbe:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1dc3:	75 4a                	jne    1e0f <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1dc5:	48 b8 90 22 00 00 00 	movabs $0x2290,%rax
    1dcc:	00 00 00 
    1dcf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1dd3:	48 ba a0 22 00 00 00 	movabs $0x22a0,%rdx
    1dda:	00 00 00 
    1ddd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1de1:	48 89 02             	mov    %rax,(%rdx)
    1de4:	48 b8 a0 22 00 00 00 	movabs $0x22a0,%rax
    1deb:	00 00 00 
    1dee:	48 8b 00             	mov    (%rax),%rax
    1df1:	48 ba 90 22 00 00 00 	movabs $0x2290,%rdx
    1df8:	00 00 00 
    1dfb:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1dfe:	48 b8 90 22 00 00 00 	movabs $0x2290,%rax
    1e05:	00 00 00 
    1e08:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e13:	48 8b 00             	mov    (%rax),%rax
    1e16:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e1e:	8b 40 08             	mov    0x8(%rax),%eax
    1e21:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e24:	77 65                	ja     1e8b <malloc+0xfe>
      if(p->s.size == nunits)
    1e26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e2a:	8b 40 08             	mov    0x8(%rax),%eax
    1e2d:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e30:	75 10                	jne    1e42 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1e32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e36:	48 8b 10             	mov    (%rax),%rdx
    1e39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e3d:	48 89 10             	mov    %rdx,(%rax)
    1e40:	eb 2e                	jmp    1e70 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1e42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e46:	8b 40 08             	mov    0x8(%rax),%eax
    1e49:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1e4c:	89 c2                	mov    %eax,%edx
    1e4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e52:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1e55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e59:	8b 40 08             	mov    0x8(%rax),%eax
    1e5c:	89 c0                	mov    %eax,%eax
    1e5e:	48 c1 e0 04          	shl    $0x4,%rax
    1e62:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1e66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e6a:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1e6d:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1e70:	48 ba a0 22 00 00 00 	movabs $0x22a0,%rdx
    1e77:	00 00 00 
    1e7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e7e:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1e81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e85:	48 83 c0 10          	add    $0x10,%rax
    1e89:	eb 4e                	jmp    1ed9 <malloc+0x14c>
    }
    if(p == freep)
    1e8b:	48 b8 a0 22 00 00 00 	movabs $0x22a0,%rax
    1e92:	00 00 00 
    1e95:	48 8b 00             	mov    (%rax),%rax
    1e98:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1e9c:	75 23                	jne    1ec1 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1e9e:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1ea1:	89 c7                	mov    %eax,%edi
    1ea3:	48 b8 0e 1d 00 00 00 	movabs $0x1d0e,%rax
    1eaa:	00 00 00 
    1ead:	ff d0                	callq  *%rax
    1eaf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1eb3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1eb8:	75 07                	jne    1ec1 <malloc+0x134>
        return 0;
    1eba:	b8 00 00 00 00       	mov    $0x0,%eax
    1ebf:	eb 18                	jmp    1ed9 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ec1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ec5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1ec9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ecd:	48 8b 00             	mov    (%rax),%rax
    1ed0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1ed4:	e9 41 ff ff ff       	jmpq   1e1a <malloc+0x8d>
  }
}
    1ed9:	c9                   	leaveq 
    1eda:	c3                   	retq   
