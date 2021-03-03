
_forktest:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <printf>:

#define N  1000

void
printf(int fd, char *s, ...)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 81 ec c0 00 00 00 	sub    $0xc0,%rsp
    100f:	89 bd 4c ff ff ff    	mov    %edi,-0xb4(%rbp)
    1015:	48 89 b5 40 ff ff ff 	mov    %rsi,-0xc0(%rbp)
    101c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1023:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    102a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1031:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1038:	84 c0                	test   %al,%al
    103a:	74 20                	je     105c <printf+0x5c>
    103c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1040:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1044:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1048:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    104c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1050:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1054:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1058:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  write(fd, s, strlen(s));
    105c:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1063:	48 89 c7             	mov    %rax,%rdi
    1066:	48 b8 d9 12 00 00 00 	movabs $0x12d9,%rax
    106d:	00 00 00 
    1070:	ff d0                	callq  *%rax
    1072:	89 c2                	mov    %eax,%edx
    1074:	48 8b 8d 40 ff ff ff 	mov    -0xc0(%rbp),%rcx
    107b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1081:	48 89 ce             	mov    %rcx,%rsi
    1084:	89 c7                	mov    %eax,%edi
    1086:	48 b8 78 15 00 00 00 	movabs $0x1578,%rax
    108d:	00 00 00 
    1090:	ff d0                	callq  *%rax
}
    1092:	90                   	nop
    1093:	c9                   	leaveq 
    1094:	c3                   	retq   

0000000000001095 <forktest>:

void
forktest(void)
{
    1095:	f3 0f 1e fa          	endbr64 
    1099:	55                   	push   %rbp
    109a:	48 89 e5             	mov    %rsp,%rbp
    109d:	48 83 ec 10          	sub    $0x10,%rsp
  int n, pid;

  printf(1, "fork test\n");
    10a1:	48 be 68 16 00 00 00 	movabs $0x1668,%rsi
    10a8:	00 00 00 
    10ab:	bf 01 00 00 00       	mov    $0x1,%edi
    10b0:	b8 00 00 00 00       	mov    $0x0,%eax
    10b5:	48 ba 00 10 00 00 00 	movabs $0x1000,%rdx
    10bc:	00 00 00 
    10bf:	ff d2                	callq  *%rdx

  for(n=0; n<N; n++){
    10c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    10c8:	eb 2b                	jmp    10f5 <forktest+0x60>
    pid = fork();
    10ca:	48 b8 37 15 00 00 00 	movabs $0x1537,%rax
    10d1:	00 00 00 
    10d4:	ff d0                	callq  *%rax
    10d6:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(pid < 0)
    10d9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    10dd:	78 21                	js     1100 <forktest+0x6b>
      break;
    if(pid == 0)
    10df:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    10e3:	75 0c                	jne    10f1 <forktest+0x5c>
      exit();
    10e5:	48 b8 44 15 00 00 00 	movabs $0x1544,%rax
    10ec:	00 00 00 
    10ef:	ff d0                	callq  *%rax
  for(n=0; n<N; n++){
    10f1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    10f5:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
    10fc:	7e cc                	jle    10ca <forktest+0x35>
    10fe:	eb 01                	jmp    1101 <forktest+0x6c>
      break;
    1100:	90                   	nop
  }

  if(n == N){
    1101:	81 7d fc e8 03 00 00 	cmpl   $0x3e8,-0x4(%rbp)
    1108:	75 71                	jne    117b <forktest+0xe6>
    printf(1, "fork claimed to work N times!\n", N);
    110a:	ba e8 03 00 00       	mov    $0x3e8,%edx
    110f:	48 be 78 16 00 00 00 	movabs $0x1678,%rsi
    1116:	00 00 00 
    1119:	bf 01 00 00 00       	mov    $0x1,%edi
    111e:	b8 00 00 00 00       	mov    $0x0,%eax
    1123:	48 b9 00 10 00 00 00 	movabs $0x1000,%rcx
    112a:	00 00 00 
    112d:	ff d1                	callq  *%rcx
    exit();
    112f:	48 b8 44 15 00 00 00 	movabs $0x1544,%rax
    1136:	00 00 00 
    1139:	ff d0                	callq  *%rax
  }

  for(; n > 0; n--){
    if(wait() < 0){
    113b:	48 b8 51 15 00 00 00 	movabs $0x1551,%rax
    1142:	00 00 00 
    1145:	ff d0                	callq  *%rax
    1147:	85 c0                	test   %eax,%eax
    1149:	79 2c                	jns    1177 <forktest+0xe2>
      printf(1, "wait stopped early\n");
    114b:	48 be 97 16 00 00 00 	movabs $0x1697,%rsi
    1152:	00 00 00 
    1155:	bf 01 00 00 00       	mov    $0x1,%edi
    115a:	b8 00 00 00 00       	mov    $0x0,%eax
    115f:	48 ba 00 10 00 00 00 	movabs $0x1000,%rdx
    1166:	00 00 00 
    1169:	ff d2                	callq  *%rdx
      exit();
    116b:	48 b8 44 15 00 00 00 	movabs $0x1544,%rax
    1172:	00 00 00 
    1175:	ff d0                	callq  *%rax
  for(; n > 0; n--){
    1177:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
    117b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    117f:	7f ba                	jg     113b <forktest+0xa6>
    }
  }

  if(wait() != -1){
    1181:	48 b8 51 15 00 00 00 	movabs $0x1551,%rax
    1188:	00 00 00 
    118b:	ff d0                	callq  *%rax
    118d:	83 f8 ff             	cmp    $0xffffffff,%eax
    1190:	74 2c                	je     11be <forktest+0x129>
    printf(1, "wait got too many\n");
    1192:	48 be ab 16 00 00 00 	movabs $0x16ab,%rsi
    1199:	00 00 00 
    119c:	bf 01 00 00 00       	mov    $0x1,%edi
    11a1:	b8 00 00 00 00       	mov    $0x0,%eax
    11a6:	48 ba 00 10 00 00 00 	movabs $0x1000,%rdx
    11ad:	00 00 00 
    11b0:	ff d2                	callq  *%rdx
    exit();
    11b2:	48 b8 44 15 00 00 00 	movabs $0x1544,%rax
    11b9:	00 00 00 
    11bc:	ff d0                	callq  *%rax
  }

  printf(1, "fork test OK\n");
    11be:	48 be be 16 00 00 00 	movabs $0x16be,%rsi
    11c5:	00 00 00 
    11c8:	bf 01 00 00 00       	mov    $0x1,%edi
    11cd:	b8 00 00 00 00       	mov    $0x0,%eax
    11d2:	48 ba 00 10 00 00 00 	movabs $0x1000,%rdx
    11d9:	00 00 00 
    11dc:	ff d2                	callq  *%rdx
}
    11de:	90                   	nop
    11df:	c9                   	leaveq 
    11e0:	c3                   	retq   

00000000000011e1 <main>:

int
main(void)
{
    11e1:	f3 0f 1e fa          	endbr64 
    11e5:	55                   	push   %rbp
    11e6:	48 89 e5             	mov    %rsp,%rbp
  forktest();
    11e9:	48 b8 95 10 00 00 00 	movabs $0x1095,%rax
    11f0:	00 00 00 
    11f3:	ff d0                	callq  *%rax
  exit();
    11f5:	48 b8 44 15 00 00 00 	movabs $0x1544,%rax
    11fc:	00 00 00 
    11ff:	ff d0                	callq  *%rax

0000000000001201 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1201:	f3 0f 1e fa          	endbr64 
    1205:	55                   	push   %rbp
    1206:	48 89 e5             	mov    %rsp,%rbp
    1209:	48 83 ec 10          	sub    $0x10,%rsp
    120d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1211:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1214:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    1217:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    121b:	8b 55 f0             	mov    -0x10(%rbp),%edx
    121e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1221:	48 89 ce             	mov    %rcx,%rsi
    1224:	48 89 f7             	mov    %rsi,%rdi
    1227:	89 d1                	mov    %edx,%ecx
    1229:	fc                   	cld    
    122a:	f3 aa                	rep stos %al,%es:(%rdi)
    122c:	89 ca                	mov    %ecx,%edx
    122e:	48 89 fe             	mov    %rdi,%rsi
    1231:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    1235:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1238:	90                   	nop
    1239:	c9                   	leaveq 
    123a:	c3                   	retq   

000000000000123b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    123b:	f3 0f 1e fa          	endbr64 
    123f:	55                   	push   %rbp
    1240:	48 89 e5             	mov    %rsp,%rbp
    1243:	48 83 ec 20          	sub    $0x20,%rsp
    1247:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    124b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    124f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1253:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1257:	90                   	nop
    1258:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    125c:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1260:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    1264:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1268:	48 8d 48 01          	lea    0x1(%rax),%rcx
    126c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1270:	0f b6 12             	movzbl (%rdx),%edx
    1273:	88 10                	mov    %dl,(%rax)
    1275:	0f b6 00             	movzbl (%rax),%eax
    1278:	84 c0                	test   %al,%al
    127a:	75 dc                	jne    1258 <strcpy+0x1d>
    ;
  return os;
    127c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1280:	c9                   	leaveq 
    1281:	c3                   	retq   

0000000000001282 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1282:	f3 0f 1e fa          	endbr64 
    1286:	55                   	push   %rbp
    1287:	48 89 e5             	mov    %rsp,%rbp
    128a:	48 83 ec 10          	sub    $0x10,%rsp
    128e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1292:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1296:	eb 0a                	jmp    12a2 <strcmp+0x20>
    p++, q++;
    1298:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    129d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    12a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12a6:	0f b6 00             	movzbl (%rax),%eax
    12a9:	84 c0                	test   %al,%al
    12ab:	74 12                	je     12bf <strcmp+0x3d>
    12ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12b1:	0f b6 10             	movzbl (%rax),%edx
    12b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    12b8:	0f b6 00             	movzbl (%rax),%eax
    12bb:	38 c2                	cmp    %al,%dl
    12bd:	74 d9                	je     1298 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    12bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12c3:	0f b6 00             	movzbl (%rax),%eax
    12c6:	0f b6 d0             	movzbl %al,%edx
    12c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    12cd:	0f b6 00             	movzbl (%rax),%eax
    12d0:	0f b6 c0             	movzbl %al,%eax
    12d3:	29 c2                	sub    %eax,%edx
    12d5:	89 d0                	mov    %edx,%eax
}
    12d7:	c9                   	leaveq 
    12d8:	c3                   	retq   

00000000000012d9 <strlen>:

uint
strlen(char *s)
{
    12d9:	f3 0f 1e fa          	endbr64 
    12dd:	55                   	push   %rbp
    12de:	48 89 e5             	mov    %rsp,%rbp
    12e1:	48 83 ec 18          	sub    $0x18,%rsp
    12e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    12e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    12f0:	eb 04                	jmp    12f6 <strlen+0x1d>
    12f2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    12f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12f9:	48 63 d0             	movslq %eax,%rdx
    12fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1300:	48 01 d0             	add    %rdx,%rax
    1303:	0f b6 00             	movzbl (%rax),%eax
    1306:	84 c0                	test   %al,%al
    1308:	75 e8                	jne    12f2 <strlen+0x19>
    ;
  return n;
    130a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    130d:	c9                   	leaveq 
    130e:	c3                   	retq   

000000000000130f <memset>:

void*
memset(void *dst, int c, uint n)
{
    130f:	f3 0f 1e fa          	endbr64 
    1313:	55                   	push   %rbp
    1314:	48 89 e5             	mov    %rsp,%rbp
    1317:	48 83 ec 10          	sub    $0x10,%rsp
    131b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    131f:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1322:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    1325:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1328:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    132b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    132f:	89 ce                	mov    %ecx,%esi
    1331:	48 89 c7             	mov    %rax,%rdi
    1334:	48 b8 01 12 00 00 00 	movabs $0x1201,%rax
    133b:	00 00 00 
    133e:	ff d0                	callq  *%rax
  return dst;
    1340:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1344:	c9                   	leaveq 
    1345:	c3                   	retq   

0000000000001346 <strchr>:

char*
strchr(const char *s, char c)
{
    1346:	f3 0f 1e fa          	endbr64 
    134a:	55                   	push   %rbp
    134b:	48 89 e5             	mov    %rsp,%rbp
    134e:	48 83 ec 10          	sub    $0x10,%rsp
    1352:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1356:	89 f0                	mov    %esi,%eax
    1358:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    135b:	eb 17                	jmp    1374 <strchr+0x2e>
    if(*s == c)
    135d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1361:	0f b6 00             	movzbl (%rax),%eax
    1364:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1367:	75 06                	jne    136f <strchr+0x29>
      return (char*)s;
    1369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    136d:	eb 15                	jmp    1384 <strchr+0x3e>
  for(; *s; s++)
    136f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1374:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1378:	0f b6 00             	movzbl (%rax),%eax
    137b:	84 c0                	test   %al,%al
    137d:	75 de                	jne    135d <strchr+0x17>
  return 0;
    137f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1384:	c9                   	leaveq 
    1385:	c3                   	retq   

0000000000001386 <gets>:

char*
gets(char *buf, int max)
{
    1386:	f3 0f 1e fa          	endbr64 
    138a:	55                   	push   %rbp
    138b:	48 89 e5             	mov    %rsp,%rbp
    138e:	48 83 ec 20          	sub    $0x20,%rsp
    1392:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1396:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1399:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    13a0:	eb 4f                	jmp    13f1 <gets+0x6b>
    cc = read(0, &c, 1);
    13a2:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    13a6:	ba 01 00 00 00       	mov    $0x1,%edx
    13ab:	48 89 c6             	mov    %rax,%rsi
    13ae:	bf 00 00 00 00       	mov    $0x0,%edi
    13b3:	48 b8 6b 15 00 00 00 	movabs $0x156b,%rax
    13ba:	00 00 00 
    13bd:	ff d0                	callq  *%rax
    13bf:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    13c2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    13c6:	7e 36                	jle    13fe <gets+0x78>
      break;
    buf[i++] = c;
    13c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13cb:	8d 50 01             	lea    0x1(%rax),%edx
    13ce:	89 55 fc             	mov    %edx,-0x4(%rbp)
    13d1:	48 63 d0             	movslq %eax,%rdx
    13d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13d8:	48 01 c2             	add    %rax,%rdx
    13db:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    13df:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    13e1:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    13e5:	3c 0a                	cmp    $0xa,%al
    13e7:	74 16                	je     13ff <gets+0x79>
    13e9:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    13ed:	3c 0d                	cmp    $0xd,%al
    13ef:	74 0e                	je     13ff <gets+0x79>
  for(i=0; i+1 < max; ){
    13f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13f4:	83 c0 01             	add    $0x1,%eax
    13f7:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    13fa:	7f a6                	jg     13a2 <gets+0x1c>
    13fc:	eb 01                	jmp    13ff <gets+0x79>
      break;
    13fe:	90                   	nop
      break;
  }
  buf[i] = '\0';
    13ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1402:	48 63 d0             	movslq %eax,%rdx
    1405:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1409:	48 01 d0             	add    %rdx,%rax
    140c:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    140f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1413:	c9                   	leaveq 
    1414:	c3                   	retq   

0000000000001415 <stat>:

int
stat(char *n, struct stat *st)
{
    1415:	f3 0f 1e fa          	endbr64 
    1419:	55                   	push   %rbp
    141a:	48 89 e5             	mov    %rsp,%rbp
    141d:	48 83 ec 20          	sub    $0x20,%rsp
    1421:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1425:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1429:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    142d:	be 00 00 00 00       	mov    $0x0,%esi
    1432:	48 89 c7             	mov    %rax,%rdi
    1435:	48 b8 ac 15 00 00 00 	movabs $0x15ac,%rax
    143c:	00 00 00 
    143f:	ff d0                	callq  *%rax
    1441:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    1444:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1448:	79 07                	jns    1451 <stat+0x3c>
    return -1;
    144a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    144f:	eb 2f                	jmp    1480 <stat+0x6b>
  r = fstat(fd, st);
    1451:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1455:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1458:	48 89 d6             	mov    %rdx,%rsi
    145b:	89 c7                	mov    %eax,%edi
    145d:	48 b8 d3 15 00 00 00 	movabs $0x15d3,%rax
    1464:	00 00 00 
    1467:	ff d0                	callq  *%rax
    1469:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    146c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    146f:	89 c7                	mov    %eax,%edi
    1471:	48 b8 85 15 00 00 00 	movabs $0x1585,%rax
    1478:	00 00 00 
    147b:	ff d0                	callq  *%rax
  return r;
    147d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1480:	c9                   	leaveq 
    1481:	c3                   	retq   

0000000000001482 <atoi>:

int
atoi(const char *s)
{
    1482:	f3 0f 1e fa          	endbr64 
    1486:	55                   	push   %rbp
    1487:	48 89 e5             	mov    %rsp,%rbp
    148a:	48 83 ec 18          	sub    $0x18,%rsp
    148e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1492:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1499:	eb 28                	jmp    14c3 <atoi+0x41>
    n = n*10 + *s++ - '0';
    149b:	8b 55 fc             	mov    -0x4(%rbp),%edx
    149e:	89 d0                	mov    %edx,%eax
    14a0:	c1 e0 02             	shl    $0x2,%eax
    14a3:	01 d0                	add    %edx,%eax
    14a5:	01 c0                	add    %eax,%eax
    14a7:	89 c1                	mov    %eax,%ecx
    14a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14ad:	48 8d 50 01          	lea    0x1(%rax),%rdx
    14b1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    14b5:	0f b6 00             	movzbl (%rax),%eax
    14b8:	0f be c0             	movsbl %al,%eax
    14bb:	01 c8                	add    %ecx,%eax
    14bd:	83 e8 30             	sub    $0x30,%eax
    14c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    14c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14c7:	0f b6 00             	movzbl (%rax),%eax
    14ca:	3c 2f                	cmp    $0x2f,%al
    14cc:	7e 0b                	jle    14d9 <atoi+0x57>
    14ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14d2:	0f b6 00             	movzbl (%rax),%eax
    14d5:	3c 39                	cmp    $0x39,%al
    14d7:	7e c2                	jle    149b <atoi+0x19>
  return n;
    14d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    14dc:	c9                   	leaveq 
    14dd:	c3                   	retq   

00000000000014de <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    14de:	f3 0f 1e fa          	endbr64 
    14e2:	55                   	push   %rbp
    14e3:	48 89 e5             	mov    %rsp,%rbp
    14e6:	48 83 ec 28          	sub    $0x28,%rsp
    14ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    14ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    14f2:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    14f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    14fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1501:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1505:	eb 1d                	jmp    1524 <memmove+0x46>
    *dst++ = *src++;
    1507:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    150b:	48 8d 42 01          	lea    0x1(%rdx),%rax
    150f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1513:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1517:	48 8d 48 01          	lea    0x1(%rax),%rcx
    151b:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    151f:	0f b6 12             	movzbl (%rdx),%edx
    1522:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1524:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1527:	8d 50 ff             	lea    -0x1(%rax),%edx
    152a:	89 55 dc             	mov    %edx,-0x24(%rbp)
    152d:	85 c0                	test   %eax,%eax
    152f:	7f d6                	jg     1507 <memmove+0x29>
  return vdst;
    1531:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1535:	c9                   	leaveq 
    1536:	c3                   	retq   

0000000000001537 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    1537:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    153e:	49 89 ca             	mov    %rcx,%r10
    1541:	0f 05                	syscall 
    1543:	c3                   	retq   

0000000000001544 <exit>:
SYSCALL(exit)
    1544:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    154b:	49 89 ca             	mov    %rcx,%r10
    154e:	0f 05                	syscall 
    1550:	c3                   	retq   

0000000000001551 <wait>:
SYSCALL(wait)
    1551:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1558:	49 89 ca             	mov    %rcx,%r10
    155b:	0f 05                	syscall 
    155d:	c3                   	retq   

000000000000155e <pipe>:
SYSCALL(pipe)
    155e:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1565:	49 89 ca             	mov    %rcx,%r10
    1568:	0f 05                	syscall 
    156a:	c3                   	retq   

000000000000156b <read>:
SYSCALL(read)
    156b:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    1572:	49 89 ca             	mov    %rcx,%r10
    1575:	0f 05                	syscall 
    1577:	c3                   	retq   

0000000000001578 <write>:
SYSCALL(write)
    1578:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    157f:	49 89 ca             	mov    %rcx,%r10
    1582:	0f 05                	syscall 
    1584:	c3                   	retq   

0000000000001585 <close>:
SYSCALL(close)
    1585:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    158c:	49 89 ca             	mov    %rcx,%r10
    158f:	0f 05                	syscall 
    1591:	c3                   	retq   

0000000000001592 <kill>:
SYSCALL(kill)
    1592:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1599:	49 89 ca             	mov    %rcx,%r10
    159c:	0f 05                	syscall 
    159e:	c3                   	retq   

000000000000159f <exec>:
SYSCALL(exec)
    159f:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    15a6:	49 89 ca             	mov    %rcx,%r10
    15a9:	0f 05                	syscall 
    15ab:	c3                   	retq   

00000000000015ac <open>:
SYSCALL(open)
    15ac:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    15b3:	49 89 ca             	mov    %rcx,%r10
    15b6:	0f 05                	syscall 
    15b8:	c3                   	retq   

00000000000015b9 <mknod>:
SYSCALL(mknod)
    15b9:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    15c0:	49 89 ca             	mov    %rcx,%r10
    15c3:	0f 05                	syscall 
    15c5:	c3                   	retq   

00000000000015c6 <unlink>:
SYSCALL(unlink)
    15c6:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    15cd:	49 89 ca             	mov    %rcx,%r10
    15d0:	0f 05                	syscall 
    15d2:	c3                   	retq   

00000000000015d3 <fstat>:
SYSCALL(fstat)
    15d3:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    15da:	49 89 ca             	mov    %rcx,%r10
    15dd:	0f 05                	syscall 
    15df:	c3                   	retq   

00000000000015e0 <link>:
SYSCALL(link)
    15e0:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    15e7:	49 89 ca             	mov    %rcx,%r10
    15ea:	0f 05                	syscall 
    15ec:	c3                   	retq   

00000000000015ed <mkdir>:
SYSCALL(mkdir)
    15ed:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    15f4:	49 89 ca             	mov    %rcx,%r10
    15f7:	0f 05                	syscall 
    15f9:	c3                   	retq   

00000000000015fa <chdir>:
SYSCALL(chdir)
    15fa:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1601:	49 89 ca             	mov    %rcx,%r10
    1604:	0f 05                	syscall 
    1606:	c3                   	retq   

0000000000001607 <dup>:
SYSCALL(dup)
    1607:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    160e:	49 89 ca             	mov    %rcx,%r10
    1611:	0f 05                	syscall 
    1613:	c3                   	retq   

0000000000001614 <getpid>:
SYSCALL(getpid)
    1614:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    161b:	49 89 ca             	mov    %rcx,%r10
    161e:	0f 05                	syscall 
    1620:	c3                   	retq   

0000000000001621 <sbrk>:
SYSCALL(sbrk)
    1621:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    1628:	49 89 ca             	mov    %rcx,%r10
    162b:	0f 05                	syscall 
    162d:	c3                   	retq   

000000000000162e <sleep>:
SYSCALL(sleep)
    162e:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    1635:	49 89 ca             	mov    %rcx,%r10
    1638:	0f 05                	syscall 
    163a:	c3                   	retq   

000000000000163b <uptime>:
SYSCALL(uptime)
    163b:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    1642:	49 89 ca             	mov    %rcx,%r10
    1645:	0f 05                	syscall 
    1647:	c3                   	retq   

0000000000001648 <dedup>:
SYSCALL(dedup)
    1648:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    164f:	49 89 ca             	mov    %rcx,%r10
    1652:	0f 05                	syscall 
    1654:	c3                   	retq   

0000000000001655 <freepages>:
SYSCALL(freepages)
    1655:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    165c:	49 89 ca             	mov    %rcx,%r10
    165f:	0f 05                	syscall 
    1661:	c3                   	retq   
