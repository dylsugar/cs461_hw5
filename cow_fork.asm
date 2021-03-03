
_cow_fork:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char * argv[])
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	53                   	push   %rbx
    1009:	48 83 ec 28          	sub    $0x28,%rsp
    100d:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1010:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  printf(1, "Freepages before malloc: %d\n", freepages());
    1014:	48 b8 91 16 00 00 00 	movabs $0x1691,%rax
    101b:	00 00 00 
    101e:	ff d0                	callq  *%rax
    1020:	89 c2                	mov    %eax,%edx
    1022:	48 be 98 1f 00 00 00 	movabs $0x1f98,%rsi
    1029:	00 00 00 
    102c:	bf 01 00 00 00       	mov    $0x1,%edi
    1031:	b8 00 00 00 00       	mov    $0x0,%eax
    1036:	48 b9 84 18 00 00 00 	movabs $0x1884,%rcx
    103d:	00 00 00 
    1040:	ff d1                	callq  *%rcx
  char * x = malloc(500000);
    1042:	bf 20 a1 07 00       	mov    $0x7a120,%edi
    1047:	48 b8 49 1e 00 00 00 	movabs $0x1e49,%rax
    104e:	00 00 00 
    1051:	ff d0                	callq  *%rax
    1053:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  memset(x, '?', 500000);
    1057:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    105b:	ba 20 a1 07 00       	mov    $0x7a120,%edx
    1060:	be 3f 00 00 00       	mov    $0x3f,%esi
    1065:	48 89 c7             	mov    %rax,%rdi
    1068:	48 b8 4b 13 00 00 00 	movabs $0x134b,%rax
    106f:	00 00 00 
    1072:	ff d0                	callq  *%rax
  printf(1, "Freepages after malloc: %d     data: %c\n", freepages(), x[100000]);
    1074:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1078:	48 05 a0 86 01 00    	add    $0x186a0,%rax
    107e:	0f b6 00             	movzbl (%rax),%eax
    1081:	0f be d8             	movsbl %al,%ebx
    1084:	48 b8 91 16 00 00 00 	movabs $0x1691,%rax
    108b:	00 00 00 
    108e:	ff d0                	callq  *%rax
    1090:	89 d9                	mov    %ebx,%ecx
    1092:	89 c2                	mov    %eax,%edx
    1094:	48 be b8 1f 00 00 00 	movabs $0x1fb8,%rsi
    109b:	00 00 00 
    109e:	bf 01 00 00 00       	mov    $0x1,%edi
    10a3:	b8 00 00 00 00       	mov    $0x0,%eax
    10a8:	49 b8 84 18 00 00 00 	movabs $0x1884,%r8
    10af:	00 00 00 
    10b2:	41 ff d0             	callq  *%r8

  if (fork() == 0) {
    10b5:	48 b8 73 15 00 00 00 	movabs $0x1573,%rax
    10bc:	00 00 00 
    10bf:	ff d0                	callq  *%rax
    10c1:	85 c0                	test   %eax,%eax
    10c3:	0f 85 91 00 00 00    	jne    115a <main+0x15a>
    printf(1, "Child: freepages before memset: %d\n", freepages());
    10c9:	48 b8 91 16 00 00 00 	movabs $0x1691,%rax
    10d0:	00 00 00 
    10d3:	ff d0                	callq  *%rax
    10d5:	89 c2                	mov    %eax,%edx
    10d7:	48 be e8 1f 00 00 00 	movabs $0x1fe8,%rsi
    10de:	00 00 00 
    10e1:	bf 01 00 00 00       	mov    $0x1,%edi
    10e6:	b8 00 00 00 00       	mov    $0x0,%eax
    10eb:	48 b9 84 18 00 00 00 	movabs $0x1884,%rcx
    10f2:	00 00 00 
    10f5:	ff d1                	callq  *%rcx
    memset(x, 'C', 500000);
    10f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10fb:	ba 20 a1 07 00       	mov    $0x7a120,%edx
    1100:	be 43 00 00 00       	mov    $0x43,%esi
    1105:	48 89 c7             	mov    %rax,%rdi
    1108:	48 b8 4b 13 00 00 00 	movabs $0x134b,%rax
    110f:	00 00 00 
    1112:	ff d0                	callq  *%rax
    printf(1, "Child: freepages after  memset: %d     data: %c\n", freepages(), x[100000]);
    1114:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1118:	48 05 a0 86 01 00    	add    $0x186a0,%rax
    111e:	0f b6 00             	movzbl (%rax),%eax
    1121:	0f be d8             	movsbl %al,%ebx
    1124:	48 b8 91 16 00 00 00 	movabs $0x1691,%rax
    112b:	00 00 00 
    112e:	ff d0                	callq  *%rax
    1130:	89 d9                	mov    %ebx,%ecx
    1132:	89 c2                	mov    %eax,%edx
    1134:	48 be 10 20 00 00 00 	movabs $0x2010,%rsi
    113b:	00 00 00 
    113e:	bf 01 00 00 00       	mov    $0x1,%edi
    1143:	b8 00 00 00 00       	mov    $0x0,%eax
    1148:	49 b8 84 18 00 00 00 	movabs $0x1884,%r8
    114f:	00 00 00 
    1152:	41 ff d0             	callq  *%r8
    1155:	e9 d7 00 00 00       	jmpq   1231 <main+0x231>
  } else {
    sleep(30);
    115a:	bf 1e 00 00 00       	mov    $0x1e,%edi
    115f:	48 b8 6a 16 00 00 00 	movabs $0x166a,%rax
    1166:	00 00 00 
    1169:	ff d0                	callq  *%rax
    printf(1, "Parent: freepages before memset: %d\n", freepages());
    116b:	48 b8 91 16 00 00 00 	movabs $0x1691,%rax
    1172:	00 00 00 
    1175:	ff d0                	callq  *%rax
    1177:	89 c2                	mov    %eax,%edx
    1179:	48 be 48 20 00 00 00 	movabs $0x2048,%rsi
    1180:	00 00 00 
    1183:	bf 01 00 00 00       	mov    $0x1,%edi
    1188:	b8 00 00 00 00       	mov    $0x0,%eax
    118d:	48 b9 84 18 00 00 00 	movabs $0x1884,%rcx
    1194:	00 00 00 
    1197:	ff d1                	callq  *%rcx
    memset(x, 'P', 500000);
    1199:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    119d:	ba 20 a1 07 00       	mov    $0x7a120,%edx
    11a2:	be 50 00 00 00       	mov    $0x50,%esi
    11a7:	48 89 c7             	mov    %rax,%rdi
    11aa:	48 b8 4b 13 00 00 00 	movabs $0x134b,%rax
    11b1:	00 00 00 
    11b4:	ff d0                	callq  *%rax
    printf(1, "Parent: freepages after  memset: %d     data: %c\n", freepages(), x[100000]);
    11b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11ba:	48 05 a0 86 01 00    	add    $0x186a0,%rax
    11c0:	0f b6 00             	movzbl (%rax),%eax
    11c3:	0f be d8             	movsbl %al,%ebx
    11c6:	48 b8 91 16 00 00 00 	movabs $0x1691,%rax
    11cd:	00 00 00 
    11d0:	ff d0                	callq  *%rax
    11d2:	89 d9                	mov    %ebx,%ecx
    11d4:	89 c2                	mov    %eax,%edx
    11d6:	48 be 70 20 00 00 00 	movabs $0x2070,%rsi
    11dd:	00 00 00 
    11e0:	bf 01 00 00 00       	mov    $0x1,%edi
    11e5:	b8 00 00 00 00       	mov    $0x0,%eax
    11ea:	49 b8 84 18 00 00 00 	movabs $0x1884,%r8
    11f1:	00 00 00 
    11f4:	41 ff d0             	callq  *%r8
    wait();
    11f7:	48 b8 8d 15 00 00 00 	movabs $0x158d,%rax
    11fe:	00 00 00 
    1201:	ff d0                	callq  *%rax
    printf(1, "Parent: freepages after wait(child): %d\n", freepages());
    1203:	48 b8 91 16 00 00 00 	movabs $0x1691,%rax
    120a:	00 00 00 
    120d:	ff d0                	callq  *%rax
    120f:	89 c2                	mov    %eax,%edx
    1211:	48 be a8 20 00 00 00 	movabs $0x20a8,%rsi
    1218:	00 00 00 
    121b:	bf 01 00 00 00       	mov    $0x1,%edi
    1220:	b8 00 00 00 00       	mov    $0x0,%eax
    1225:	48 b9 84 18 00 00 00 	movabs $0x1884,%rcx
    122c:	00 00 00 
    122f:	ff d1                	callq  *%rcx
  }
  exit();
    1231:	48 b8 80 15 00 00 00 	movabs $0x1580,%rax
    1238:	00 00 00 
    123b:	ff d0                	callq  *%rax

000000000000123d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    123d:	f3 0f 1e fa          	endbr64 
    1241:	55                   	push   %rbp
    1242:	48 89 e5             	mov    %rsp,%rbp
    1245:	48 83 ec 10          	sub    $0x10,%rsp
    1249:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    124d:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1250:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    1253:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1257:	8b 55 f0             	mov    -0x10(%rbp),%edx
    125a:	8b 45 f4             	mov    -0xc(%rbp),%eax
    125d:	48 89 ce             	mov    %rcx,%rsi
    1260:	48 89 f7             	mov    %rsi,%rdi
    1263:	89 d1                	mov    %edx,%ecx
    1265:	fc                   	cld    
    1266:	f3 aa                	rep stos %al,%es:(%rdi)
    1268:	89 ca                	mov    %ecx,%edx
    126a:	48 89 fe             	mov    %rdi,%rsi
    126d:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    1271:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1274:	90                   	nop
    1275:	c9                   	leaveq 
    1276:	c3                   	retq   

0000000000001277 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1277:	f3 0f 1e fa          	endbr64 
    127b:	55                   	push   %rbp
    127c:	48 89 e5             	mov    %rsp,%rbp
    127f:	48 83 ec 20          	sub    $0x20,%rsp
    1283:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1287:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    128b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    128f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1293:	90                   	nop
    1294:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1298:	48 8d 42 01          	lea    0x1(%rdx),%rax
    129c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    12a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12a4:	48 8d 48 01          	lea    0x1(%rax),%rcx
    12a8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    12ac:	0f b6 12             	movzbl (%rdx),%edx
    12af:	88 10                	mov    %dl,(%rax)
    12b1:	0f b6 00             	movzbl (%rax),%eax
    12b4:	84 c0                	test   %al,%al
    12b6:	75 dc                	jne    1294 <strcpy+0x1d>
    ;
  return os;
    12b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    12bc:	c9                   	leaveq 
    12bd:	c3                   	retq   

00000000000012be <strcmp>:

int
strcmp(const char *p, const char *q)
{
    12be:	f3 0f 1e fa          	endbr64 
    12c2:	55                   	push   %rbp
    12c3:	48 89 e5             	mov    %rsp,%rbp
    12c6:	48 83 ec 10          	sub    $0x10,%rsp
    12ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12ce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    12d2:	eb 0a                	jmp    12de <strcmp+0x20>
    p++, q++;
    12d4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    12d9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    12de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12e2:	0f b6 00             	movzbl (%rax),%eax
    12e5:	84 c0                	test   %al,%al
    12e7:	74 12                	je     12fb <strcmp+0x3d>
    12e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12ed:	0f b6 10             	movzbl (%rax),%edx
    12f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    12f4:	0f b6 00             	movzbl (%rax),%eax
    12f7:	38 c2                	cmp    %al,%dl
    12f9:	74 d9                	je     12d4 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    12fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12ff:	0f b6 00             	movzbl (%rax),%eax
    1302:	0f b6 d0             	movzbl %al,%edx
    1305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1309:	0f b6 00             	movzbl (%rax),%eax
    130c:	0f b6 c0             	movzbl %al,%eax
    130f:	29 c2                	sub    %eax,%edx
    1311:	89 d0                	mov    %edx,%eax
}
    1313:	c9                   	leaveq 
    1314:	c3                   	retq   

0000000000001315 <strlen>:

uint
strlen(char *s)
{
    1315:	f3 0f 1e fa          	endbr64 
    1319:	55                   	push   %rbp
    131a:	48 89 e5             	mov    %rsp,%rbp
    131d:	48 83 ec 18          	sub    $0x18,%rsp
    1321:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1325:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    132c:	eb 04                	jmp    1332 <strlen+0x1d>
    132e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1332:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1335:	48 63 d0             	movslq %eax,%rdx
    1338:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    133c:	48 01 d0             	add    %rdx,%rax
    133f:	0f b6 00             	movzbl (%rax),%eax
    1342:	84 c0                	test   %al,%al
    1344:	75 e8                	jne    132e <strlen+0x19>
    ;
  return n;
    1346:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1349:	c9                   	leaveq 
    134a:	c3                   	retq   

000000000000134b <memset>:

void*
memset(void *dst, int c, uint n)
{
    134b:	f3 0f 1e fa          	endbr64 
    134f:	55                   	push   %rbp
    1350:	48 89 e5             	mov    %rsp,%rbp
    1353:	48 83 ec 10          	sub    $0x10,%rsp
    1357:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    135b:	89 75 f4             	mov    %esi,-0xc(%rbp)
    135e:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    1361:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1364:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    1367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    136b:	89 ce                	mov    %ecx,%esi
    136d:	48 89 c7             	mov    %rax,%rdi
    1370:	48 b8 3d 12 00 00 00 	movabs $0x123d,%rax
    1377:	00 00 00 
    137a:	ff d0                	callq  *%rax
  return dst;
    137c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1380:	c9                   	leaveq 
    1381:	c3                   	retq   

0000000000001382 <strchr>:

char*
strchr(const char *s, char c)
{
    1382:	f3 0f 1e fa          	endbr64 
    1386:	55                   	push   %rbp
    1387:	48 89 e5             	mov    %rsp,%rbp
    138a:	48 83 ec 10          	sub    $0x10,%rsp
    138e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1392:	89 f0                	mov    %esi,%eax
    1394:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1397:	eb 17                	jmp    13b0 <strchr+0x2e>
    if(*s == c)
    1399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    139d:	0f b6 00             	movzbl (%rax),%eax
    13a0:	38 45 f4             	cmp    %al,-0xc(%rbp)
    13a3:	75 06                	jne    13ab <strchr+0x29>
      return (char*)s;
    13a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13a9:	eb 15                	jmp    13c0 <strchr+0x3e>
  for(; *s; s++)
    13ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    13b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13b4:	0f b6 00             	movzbl (%rax),%eax
    13b7:	84 c0                	test   %al,%al
    13b9:	75 de                	jne    1399 <strchr+0x17>
  return 0;
    13bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
    13c0:	c9                   	leaveq 
    13c1:	c3                   	retq   

00000000000013c2 <gets>:

char*
gets(char *buf, int max)
{
    13c2:	f3 0f 1e fa          	endbr64 
    13c6:	55                   	push   %rbp
    13c7:	48 89 e5             	mov    %rsp,%rbp
    13ca:	48 83 ec 20          	sub    $0x20,%rsp
    13ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13d2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    13d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    13dc:	eb 4f                	jmp    142d <gets+0x6b>
    cc = read(0, &c, 1);
    13de:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    13e2:	ba 01 00 00 00       	mov    $0x1,%edx
    13e7:	48 89 c6             	mov    %rax,%rsi
    13ea:	bf 00 00 00 00       	mov    $0x0,%edi
    13ef:	48 b8 a7 15 00 00 00 	movabs $0x15a7,%rax
    13f6:	00 00 00 
    13f9:	ff d0                	callq  *%rax
    13fb:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    13fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1402:	7e 36                	jle    143a <gets+0x78>
      break;
    buf[i++] = c;
    1404:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1407:	8d 50 01             	lea    0x1(%rax),%edx
    140a:	89 55 fc             	mov    %edx,-0x4(%rbp)
    140d:	48 63 d0             	movslq %eax,%rdx
    1410:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1414:	48 01 c2             	add    %rax,%rdx
    1417:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    141b:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    141d:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1421:	3c 0a                	cmp    $0xa,%al
    1423:	74 16                	je     143b <gets+0x79>
    1425:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1429:	3c 0d                	cmp    $0xd,%al
    142b:	74 0e                	je     143b <gets+0x79>
  for(i=0; i+1 < max; ){
    142d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1430:	83 c0 01             	add    $0x1,%eax
    1433:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    1436:	7f a6                	jg     13de <gets+0x1c>
    1438:	eb 01                	jmp    143b <gets+0x79>
      break;
    143a:	90                   	nop
      break;
  }
  buf[i] = '\0';
    143b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    143e:	48 63 d0             	movslq %eax,%rdx
    1441:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1445:	48 01 d0             	add    %rdx,%rax
    1448:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    144b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    144f:	c9                   	leaveq 
    1450:	c3                   	retq   

0000000000001451 <stat>:

int
stat(char *n, struct stat *st)
{
    1451:	f3 0f 1e fa          	endbr64 
    1455:	55                   	push   %rbp
    1456:	48 89 e5             	mov    %rsp,%rbp
    1459:	48 83 ec 20          	sub    $0x20,%rsp
    145d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1461:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1465:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1469:	be 00 00 00 00       	mov    $0x0,%esi
    146e:	48 89 c7             	mov    %rax,%rdi
    1471:	48 b8 e8 15 00 00 00 	movabs $0x15e8,%rax
    1478:	00 00 00 
    147b:	ff d0                	callq  *%rax
    147d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    1480:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1484:	79 07                	jns    148d <stat+0x3c>
    return -1;
    1486:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    148b:	eb 2f                	jmp    14bc <stat+0x6b>
  r = fstat(fd, st);
    148d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1491:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1494:	48 89 d6             	mov    %rdx,%rsi
    1497:	89 c7                	mov    %eax,%edi
    1499:	48 b8 0f 16 00 00 00 	movabs $0x160f,%rax
    14a0:	00 00 00 
    14a3:	ff d0                	callq  *%rax
    14a5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    14a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14ab:	89 c7                	mov    %eax,%edi
    14ad:	48 b8 c1 15 00 00 00 	movabs $0x15c1,%rax
    14b4:	00 00 00 
    14b7:	ff d0                	callq  *%rax
  return r;
    14b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    14bc:	c9                   	leaveq 
    14bd:	c3                   	retq   

00000000000014be <atoi>:

int
atoi(const char *s)
{
    14be:	f3 0f 1e fa          	endbr64 
    14c2:	55                   	push   %rbp
    14c3:	48 89 e5             	mov    %rsp,%rbp
    14c6:	48 83 ec 18          	sub    $0x18,%rsp
    14ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    14ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    14d5:	eb 28                	jmp    14ff <atoi+0x41>
    n = n*10 + *s++ - '0';
    14d7:	8b 55 fc             	mov    -0x4(%rbp),%edx
    14da:	89 d0                	mov    %edx,%eax
    14dc:	c1 e0 02             	shl    $0x2,%eax
    14df:	01 d0                	add    %edx,%eax
    14e1:	01 c0                	add    %eax,%eax
    14e3:	89 c1                	mov    %eax,%ecx
    14e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14e9:	48 8d 50 01          	lea    0x1(%rax),%rdx
    14ed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    14f1:	0f b6 00             	movzbl (%rax),%eax
    14f4:	0f be c0             	movsbl %al,%eax
    14f7:	01 c8                	add    %ecx,%eax
    14f9:	83 e8 30             	sub    $0x30,%eax
    14fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    14ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1503:	0f b6 00             	movzbl (%rax),%eax
    1506:	3c 2f                	cmp    $0x2f,%al
    1508:	7e 0b                	jle    1515 <atoi+0x57>
    150a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    150e:	0f b6 00             	movzbl (%rax),%eax
    1511:	3c 39                	cmp    $0x39,%al
    1513:	7e c2                	jle    14d7 <atoi+0x19>
  return n;
    1515:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1518:	c9                   	leaveq 
    1519:	c3                   	retq   

000000000000151a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    151a:	f3 0f 1e fa          	endbr64 
    151e:	55                   	push   %rbp
    151f:	48 89 e5             	mov    %rsp,%rbp
    1522:	48 83 ec 28          	sub    $0x28,%rsp
    1526:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    152a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    152e:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1531:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1535:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1539:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    153d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1541:	eb 1d                	jmp    1560 <memmove+0x46>
    *dst++ = *src++;
    1543:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1547:	48 8d 42 01          	lea    0x1(%rdx),%rax
    154b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    154f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1553:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1557:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    155b:	0f b6 12             	movzbl (%rdx),%edx
    155e:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1560:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1563:	8d 50 ff             	lea    -0x1(%rax),%edx
    1566:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1569:	85 c0                	test   %eax,%eax
    156b:	7f d6                	jg     1543 <memmove+0x29>
  return vdst;
    156d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1571:	c9                   	leaveq 
    1572:	c3                   	retq   

0000000000001573 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    1573:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    157a:	49 89 ca             	mov    %rcx,%r10
    157d:	0f 05                	syscall 
    157f:	c3                   	retq   

0000000000001580 <exit>:
SYSCALL(exit)
    1580:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1587:	49 89 ca             	mov    %rcx,%r10
    158a:	0f 05                	syscall 
    158c:	c3                   	retq   

000000000000158d <wait>:
SYSCALL(wait)
    158d:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1594:	49 89 ca             	mov    %rcx,%r10
    1597:	0f 05                	syscall 
    1599:	c3                   	retq   

000000000000159a <pipe>:
SYSCALL(pipe)
    159a:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    15a1:	49 89 ca             	mov    %rcx,%r10
    15a4:	0f 05                	syscall 
    15a6:	c3                   	retq   

00000000000015a7 <read>:
SYSCALL(read)
    15a7:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    15ae:	49 89 ca             	mov    %rcx,%r10
    15b1:	0f 05                	syscall 
    15b3:	c3                   	retq   

00000000000015b4 <write>:
SYSCALL(write)
    15b4:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    15bb:	49 89 ca             	mov    %rcx,%r10
    15be:	0f 05                	syscall 
    15c0:	c3                   	retq   

00000000000015c1 <close>:
SYSCALL(close)
    15c1:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    15c8:	49 89 ca             	mov    %rcx,%r10
    15cb:	0f 05                	syscall 
    15cd:	c3                   	retq   

00000000000015ce <kill>:
SYSCALL(kill)
    15ce:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    15d5:	49 89 ca             	mov    %rcx,%r10
    15d8:	0f 05                	syscall 
    15da:	c3                   	retq   

00000000000015db <exec>:
SYSCALL(exec)
    15db:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    15e2:	49 89 ca             	mov    %rcx,%r10
    15e5:	0f 05                	syscall 
    15e7:	c3                   	retq   

00000000000015e8 <open>:
SYSCALL(open)
    15e8:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    15ef:	49 89 ca             	mov    %rcx,%r10
    15f2:	0f 05                	syscall 
    15f4:	c3                   	retq   

00000000000015f5 <mknod>:
SYSCALL(mknod)
    15f5:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    15fc:	49 89 ca             	mov    %rcx,%r10
    15ff:	0f 05                	syscall 
    1601:	c3                   	retq   

0000000000001602 <unlink>:
SYSCALL(unlink)
    1602:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1609:	49 89 ca             	mov    %rcx,%r10
    160c:	0f 05                	syscall 
    160e:	c3                   	retq   

000000000000160f <fstat>:
SYSCALL(fstat)
    160f:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1616:	49 89 ca             	mov    %rcx,%r10
    1619:	0f 05                	syscall 
    161b:	c3                   	retq   

000000000000161c <link>:
SYSCALL(link)
    161c:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1623:	49 89 ca             	mov    %rcx,%r10
    1626:	0f 05                	syscall 
    1628:	c3                   	retq   

0000000000001629 <mkdir>:
SYSCALL(mkdir)
    1629:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1630:	49 89 ca             	mov    %rcx,%r10
    1633:	0f 05                	syscall 
    1635:	c3                   	retq   

0000000000001636 <chdir>:
SYSCALL(chdir)
    1636:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    163d:	49 89 ca             	mov    %rcx,%r10
    1640:	0f 05                	syscall 
    1642:	c3                   	retq   

0000000000001643 <dup>:
SYSCALL(dup)
    1643:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    164a:	49 89 ca             	mov    %rcx,%r10
    164d:	0f 05                	syscall 
    164f:	c3                   	retq   

0000000000001650 <getpid>:
SYSCALL(getpid)
    1650:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    1657:	49 89 ca             	mov    %rcx,%r10
    165a:	0f 05                	syscall 
    165c:	c3                   	retq   

000000000000165d <sbrk>:
SYSCALL(sbrk)
    165d:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    1664:	49 89 ca             	mov    %rcx,%r10
    1667:	0f 05                	syscall 
    1669:	c3                   	retq   

000000000000166a <sleep>:
SYSCALL(sleep)
    166a:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    1671:	49 89 ca             	mov    %rcx,%r10
    1674:	0f 05                	syscall 
    1676:	c3                   	retq   

0000000000001677 <uptime>:
SYSCALL(uptime)
    1677:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    167e:	49 89 ca             	mov    %rcx,%r10
    1681:	0f 05                	syscall 
    1683:	c3                   	retq   

0000000000001684 <dedup>:
SYSCALL(dedup)
    1684:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    168b:	49 89 ca             	mov    %rcx,%r10
    168e:	0f 05                	syscall 
    1690:	c3                   	retq   

0000000000001691 <freepages>:
SYSCALL(freepages)
    1691:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    1698:	49 89 ca             	mov    %rcx,%r10
    169b:	0f 05                	syscall 
    169d:	c3                   	retq   

000000000000169e <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    169e:	f3 0f 1e fa          	endbr64 
    16a2:	55                   	push   %rbp
    16a3:	48 89 e5             	mov    %rsp,%rbp
    16a6:	48 83 ec 10          	sub    $0x10,%rsp
    16aa:	89 7d fc             	mov    %edi,-0x4(%rbp)
    16ad:	89 f0                	mov    %esi,%eax
    16af:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    16b2:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    16b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16b9:	ba 01 00 00 00       	mov    $0x1,%edx
    16be:	48 89 ce             	mov    %rcx,%rsi
    16c1:	89 c7                	mov    %eax,%edi
    16c3:	48 b8 b4 15 00 00 00 	movabs $0x15b4,%rax
    16ca:	00 00 00 
    16cd:	ff d0                	callq  *%rax
}
    16cf:	90                   	nop
    16d0:	c9                   	leaveq 
    16d1:	c3                   	retq   

00000000000016d2 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    16d2:	f3 0f 1e fa          	endbr64 
    16d6:	55                   	push   %rbp
    16d7:	48 89 e5             	mov    %rsp,%rbp
    16da:	48 83 ec 20          	sub    $0x20,%rsp
    16de:	89 7d ec             	mov    %edi,-0x14(%rbp)
    16e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    16e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    16ec:	eb 35                	jmp    1723 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    16ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    16f2:	48 c1 e8 3c          	shr    $0x3c,%rax
    16f6:	48 ba 10 24 00 00 00 	movabs $0x2410,%rdx
    16fd:	00 00 00 
    1700:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1704:	0f be d0             	movsbl %al,%edx
    1707:	8b 45 ec             	mov    -0x14(%rbp),%eax
    170a:	89 d6                	mov    %edx,%esi
    170c:	89 c7                	mov    %eax,%edi
    170e:	48 b8 9e 16 00 00 00 	movabs $0x169e,%rax
    1715:	00 00 00 
    1718:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    171a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    171e:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1723:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1726:	83 f8 0f             	cmp    $0xf,%eax
    1729:	76 c3                	jbe    16ee <print_x64+0x1c>
}
    172b:	90                   	nop
    172c:	90                   	nop
    172d:	c9                   	leaveq 
    172e:	c3                   	retq   

000000000000172f <print_x32>:

  static void
print_x32(int fd, uint x)
{
    172f:	f3 0f 1e fa          	endbr64 
    1733:	55                   	push   %rbp
    1734:	48 89 e5             	mov    %rsp,%rbp
    1737:	48 83 ec 20          	sub    $0x20,%rsp
    173b:	89 7d ec             	mov    %edi,-0x14(%rbp)
    173e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1741:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1748:	eb 36                	jmp    1780 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    174a:	8b 45 e8             	mov    -0x18(%rbp),%eax
    174d:	c1 e8 1c             	shr    $0x1c,%eax
    1750:	89 c2                	mov    %eax,%edx
    1752:	48 b8 10 24 00 00 00 	movabs $0x2410,%rax
    1759:	00 00 00 
    175c:	89 d2                	mov    %edx,%edx
    175e:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    1762:	0f be d0             	movsbl %al,%edx
    1765:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1768:	89 d6                	mov    %edx,%esi
    176a:	89 c7                	mov    %eax,%edi
    176c:	48 b8 9e 16 00 00 00 	movabs $0x169e,%rax
    1773:	00 00 00 
    1776:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1778:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    177c:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    1780:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1783:	83 f8 07             	cmp    $0x7,%eax
    1786:	76 c2                	jbe    174a <print_x32+0x1b>
}
    1788:	90                   	nop
    1789:	90                   	nop
    178a:	c9                   	leaveq 
    178b:	c3                   	retq   

000000000000178c <print_d>:

  static void
print_d(int fd, int v)
{
    178c:	f3 0f 1e fa          	endbr64 
    1790:	55                   	push   %rbp
    1791:	48 89 e5             	mov    %rsp,%rbp
    1794:	48 83 ec 30          	sub    $0x30,%rsp
    1798:	89 7d dc             	mov    %edi,-0x24(%rbp)
    179b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    179e:	8b 45 d8             	mov    -0x28(%rbp),%eax
    17a1:	48 98                	cltq   
    17a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    17a7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    17ab:	79 04                	jns    17b1 <print_d+0x25>
    x = -x;
    17ad:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    17b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    17b8:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    17bc:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    17c3:	66 66 66 
    17c6:	48 89 c8             	mov    %rcx,%rax
    17c9:	48 f7 ea             	imul   %rdx
    17cc:	48 c1 fa 02          	sar    $0x2,%rdx
    17d0:	48 89 c8             	mov    %rcx,%rax
    17d3:	48 c1 f8 3f          	sar    $0x3f,%rax
    17d7:	48 29 c2             	sub    %rax,%rdx
    17da:	48 89 d0             	mov    %rdx,%rax
    17dd:	48 c1 e0 02          	shl    $0x2,%rax
    17e1:	48 01 d0             	add    %rdx,%rax
    17e4:	48 01 c0             	add    %rax,%rax
    17e7:	48 29 c1             	sub    %rax,%rcx
    17ea:	48 89 ca             	mov    %rcx,%rdx
    17ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17f0:	8d 48 01             	lea    0x1(%rax),%ecx
    17f3:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    17f6:	48 b9 10 24 00 00 00 	movabs $0x2410,%rcx
    17fd:	00 00 00 
    1800:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1804:	48 98                	cltq   
    1806:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    180a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    180e:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1815:	66 66 66 
    1818:	48 89 c8             	mov    %rcx,%rax
    181b:	48 f7 ea             	imul   %rdx
    181e:	48 c1 fa 02          	sar    $0x2,%rdx
    1822:	48 89 c8             	mov    %rcx,%rax
    1825:	48 c1 f8 3f          	sar    $0x3f,%rax
    1829:	48 29 c2             	sub    %rax,%rdx
    182c:	48 89 d0             	mov    %rdx,%rax
    182f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1833:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1838:	0f 85 7a ff ff ff    	jne    17b8 <print_d+0x2c>

  if (v < 0)
    183e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1842:	79 32                	jns    1876 <print_d+0xea>
    buf[i++] = '-';
    1844:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1847:	8d 50 01             	lea    0x1(%rax),%edx
    184a:	89 55 f4             	mov    %edx,-0xc(%rbp)
    184d:	48 98                	cltq   
    184f:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1854:	eb 20                	jmp    1876 <print_d+0xea>
    putc(fd, buf[i]);
    1856:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1859:	48 98                	cltq   
    185b:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1860:	0f be d0             	movsbl %al,%edx
    1863:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1866:	89 d6                	mov    %edx,%esi
    1868:	89 c7                	mov    %eax,%edi
    186a:	48 b8 9e 16 00 00 00 	movabs $0x169e,%rax
    1871:	00 00 00 
    1874:	ff d0                	callq  *%rax
  while (--i >= 0)
    1876:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    187a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    187e:	79 d6                	jns    1856 <print_d+0xca>
}
    1880:	90                   	nop
    1881:	90                   	nop
    1882:	c9                   	leaveq 
    1883:	c3                   	retq   

0000000000001884 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1884:	f3 0f 1e fa          	endbr64 
    1888:	55                   	push   %rbp
    1889:	48 89 e5             	mov    %rsp,%rbp
    188c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1893:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1899:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    18a0:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    18a7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    18ae:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    18b5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    18bc:	84 c0                	test   %al,%al
    18be:	74 20                	je     18e0 <printf+0x5c>
    18c0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    18c4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    18c8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    18cc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    18d0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    18d4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    18d8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    18dc:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    18e0:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    18e7:	00 00 00 
    18ea:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    18f1:	00 00 00 
    18f4:	48 8d 45 10          	lea    0x10(%rbp),%rax
    18f8:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    18ff:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1906:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    190d:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1914:	00 00 00 
    1917:	e9 41 03 00 00       	jmpq   1c5d <printf+0x3d9>
    if (c != '%') {
    191c:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1923:	74 24                	je     1949 <printf+0xc5>
      putc(fd, c);
    1925:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    192b:	0f be d0             	movsbl %al,%edx
    192e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1934:	89 d6                	mov    %edx,%esi
    1936:	89 c7                	mov    %eax,%edi
    1938:	48 b8 9e 16 00 00 00 	movabs $0x169e,%rax
    193f:	00 00 00 
    1942:	ff d0                	callq  *%rax
      continue;
    1944:	e9 0d 03 00 00       	jmpq   1c56 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1949:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1950:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1956:	48 63 d0             	movslq %eax,%rdx
    1959:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1960:	48 01 d0             	add    %rdx,%rax
    1963:	0f b6 00             	movzbl (%rax),%eax
    1966:	0f be c0             	movsbl %al,%eax
    1969:	25 ff 00 00 00       	and    $0xff,%eax
    196e:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1974:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    197b:	0f 84 0f 03 00 00    	je     1c90 <printf+0x40c>
      break;
    switch(c) {
    1981:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1988:	0f 84 74 02 00 00    	je     1c02 <printf+0x37e>
    198e:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1995:	0f 8c 82 02 00 00    	jl     1c1d <printf+0x399>
    199b:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    19a2:	0f 8f 75 02 00 00    	jg     1c1d <printf+0x399>
    19a8:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    19af:	0f 8c 68 02 00 00    	jl     1c1d <printf+0x399>
    19b5:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    19bb:	83 e8 63             	sub    $0x63,%eax
    19be:	83 f8 15             	cmp    $0x15,%eax
    19c1:	0f 87 56 02 00 00    	ja     1c1d <printf+0x399>
    19c7:	89 c0                	mov    %eax,%eax
    19c9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    19d0:	00 
    19d1:	48 b8 e0 20 00 00 00 	movabs $0x20e0,%rax
    19d8:	00 00 00 
    19db:	48 01 d0             	add    %rdx,%rax
    19de:	48 8b 00             	mov    (%rax),%rax
    19e1:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    19e4:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19ea:	83 f8 2f             	cmp    $0x2f,%eax
    19ed:	77 23                	ja     1a12 <printf+0x18e>
    19ef:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19f6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19fc:	89 d2                	mov    %edx,%edx
    19fe:	48 01 d0             	add    %rdx,%rax
    1a01:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a07:	83 c2 08             	add    $0x8,%edx
    1a0a:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a10:	eb 12                	jmp    1a24 <printf+0x1a0>
    1a12:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a19:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a1d:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a24:	8b 00                	mov    (%rax),%eax
    1a26:	0f be d0             	movsbl %al,%edx
    1a29:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a2f:	89 d6                	mov    %edx,%esi
    1a31:	89 c7                	mov    %eax,%edi
    1a33:	48 b8 9e 16 00 00 00 	movabs $0x169e,%rax
    1a3a:	00 00 00 
    1a3d:	ff d0                	callq  *%rax
      break;
    1a3f:	e9 12 02 00 00       	jmpq   1c56 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1a44:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a4a:	83 f8 2f             	cmp    $0x2f,%eax
    1a4d:	77 23                	ja     1a72 <printf+0x1ee>
    1a4f:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a56:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a5c:	89 d2                	mov    %edx,%edx
    1a5e:	48 01 d0             	add    %rdx,%rax
    1a61:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a67:	83 c2 08             	add    $0x8,%edx
    1a6a:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a70:	eb 12                	jmp    1a84 <printf+0x200>
    1a72:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a79:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a7d:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a84:	8b 10                	mov    (%rax),%edx
    1a86:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a8c:	89 d6                	mov    %edx,%esi
    1a8e:	89 c7                	mov    %eax,%edi
    1a90:	48 b8 8c 17 00 00 00 	movabs $0x178c,%rax
    1a97:	00 00 00 
    1a9a:	ff d0                	callq  *%rax
      break;
    1a9c:	e9 b5 01 00 00       	jmpq   1c56 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1aa1:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1aa7:	83 f8 2f             	cmp    $0x2f,%eax
    1aaa:	77 23                	ja     1acf <printf+0x24b>
    1aac:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1ab3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ab9:	89 d2                	mov    %edx,%edx
    1abb:	48 01 d0             	add    %rdx,%rax
    1abe:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ac4:	83 c2 08             	add    $0x8,%edx
    1ac7:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1acd:	eb 12                	jmp    1ae1 <printf+0x25d>
    1acf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1ad6:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1ada:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1ae1:	8b 10                	mov    (%rax),%edx
    1ae3:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ae9:	89 d6                	mov    %edx,%esi
    1aeb:	89 c7                	mov    %eax,%edi
    1aed:	48 b8 2f 17 00 00 00 	movabs $0x172f,%rax
    1af4:	00 00 00 
    1af7:	ff d0                	callq  *%rax
      break;
    1af9:	e9 58 01 00 00       	jmpq   1c56 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1afe:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1b04:	83 f8 2f             	cmp    $0x2f,%eax
    1b07:	77 23                	ja     1b2c <printf+0x2a8>
    1b09:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1b10:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b16:	89 d2                	mov    %edx,%edx
    1b18:	48 01 d0             	add    %rdx,%rax
    1b1b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b21:	83 c2 08             	add    $0x8,%edx
    1b24:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1b2a:	eb 12                	jmp    1b3e <printf+0x2ba>
    1b2c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b33:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b37:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b3e:	48 8b 10             	mov    (%rax),%rdx
    1b41:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b47:	48 89 d6             	mov    %rdx,%rsi
    1b4a:	89 c7                	mov    %eax,%edi
    1b4c:	48 b8 d2 16 00 00 00 	movabs $0x16d2,%rax
    1b53:	00 00 00 
    1b56:	ff d0                	callq  *%rax
      break;
    1b58:	e9 f9 00 00 00       	jmpq   1c56 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1b5d:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1b63:	83 f8 2f             	cmp    $0x2f,%eax
    1b66:	77 23                	ja     1b8b <printf+0x307>
    1b68:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1b6f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b75:	89 d2                	mov    %edx,%edx
    1b77:	48 01 d0             	add    %rdx,%rax
    1b7a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b80:	83 c2 08             	add    $0x8,%edx
    1b83:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1b89:	eb 12                	jmp    1b9d <printf+0x319>
    1b8b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b92:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b96:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b9d:	48 8b 00             	mov    (%rax),%rax
    1ba0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1ba7:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1bae:	00 
    1baf:	75 41                	jne    1bf2 <printf+0x36e>
        s = "(null)";
    1bb1:	48 b8 d8 20 00 00 00 	movabs $0x20d8,%rax
    1bb8:	00 00 00 
    1bbb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1bc2:	eb 2e                	jmp    1bf2 <printf+0x36e>
        putc(fd, *(s++));
    1bc4:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1bcb:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1bcf:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1bd6:	0f b6 00             	movzbl (%rax),%eax
    1bd9:	0f be d0             	movsbl %al,%edx
    1bdc:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1be2:	89 d6                	mov    %edx,%esi
    1be4:	89 c7                	mov    %eax,%edi
    1be6:	48 b8 9e 16 00 00 00 	movabs $0x169e,%rax
    1bed:	00 00 00 
    1bf0:	ff d0                	callq  *%rax
      while (*s)
    1bf2:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1bf9:	0f b6 00             	movzbl (%rax),%eax
    1bfc:	84 c0                	test   %al,%al
    1bfe:	75 c4                	jne    1bc4 <printf+0x340>
      break;
    1c00:	eb 54                	jmp    1c56 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1c02:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c08:	be 25 00 00 00       	mov    $0x25,%esi
    1c0d:	89 c7                	mov    %eax,%edi
    1c0f:	48 b8 9e 16 00 00 00 	movabs $0x169e,%rax
    1c16:	00 00 00 
    1c19:	ff d0                	callq  *%rax
      break;
    1c1b:	eb 39                	jmp    1c56 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1c1d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c23:	be 25 00 00 00       	mov    $0x25,%esi
    1c28:	89 c7                	mov    %eax,%edi
    1c2a:	48 b8 9e 16 00 00 00 	movabs $0x169e,%rax
    1c31:	00 00 00 
    1c34:	ff d0                	callq  *%rax
      putc(fd, c);
    1c36:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1c3c:	0f be d0             	movsbl %al,%edx
    1c3f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c45:	89 d6                	mov    %edx,%esi
    1c47:	89 c7                	mov    %eax,%edi
    1c49:	48 b8 9e 16 00 00 00 	movabs $0x169e,%rax
    1c50:	00 00 00 
    1c53:	ff d0                	callq  *%rax
      break;
    1c55:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1c56:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1c5d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1c63:	48 63 d0             	movslq %eax,%rdx
    1c66:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1c6d:	48 01 d0             	add    %rdx,%rax
    1c70:	0f b6 00             	movzbl (%rax),%eax
    1c73:	0f be c0             	movsbl %al,%eax
    1c76:	25 ff 00 00 00       	and    $0xff,%eax
    1c7b:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1c81:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1c88:	0f 85 8e fc ff ff    	jne    191c <printf+0x98>
    }
  }
}
    1c8e:	eb 01                	jmp    1c91 <printf+0x40d>
      break;
    1c90:	90                   	nop
}
    1c91:	90                   	nop
    1c92:	c9                   	leaveq 
    1c93:	c3                   	retq   

0000000000001c94 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1c94:	f3 0f 1e fa          	endbr64 
    1c98:	55                   	push   %rbp
    1c99:	48 89 e5             	mov    %rsp,%rbp
    1c9c:	48 83 ec 18          	sub    $0x18,%rsp
    1ca0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1ca4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1ca8:	48 83 e8 10          	sub    $0x10,%rax
    1cac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1cb0:	48 b8 40 24 00 00 00 	movabs $0x2440,%rax
    1cb7:	00 00 00 
    1cba:	48 8b 00             	mov    (%rax),%rax
    1cbd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1cc1:	eb 2f                	jmp    1cf2 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1cc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cc7:	48 8b 00             	mov    (%rax),%rax
    1cca:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1cce:	72 17                	jb     1ce7 <free+0x53>
    1cd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cd4:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1cd8:	77 2f                	ja     1d09 <free+0x75>
    1cda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cde:	48 8b 00             	mov    (%rax),%rax
    1ce1:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1ce5:	72 22                	jb     1d09 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1ce7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ceb:	48 8b 00             	mov    (%rax),%rax
    1cee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1cf2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cf6:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1cfa:	76 c7                	jbe    1cc3 <free+0x2f>
    1cfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d00:	48 8b 00             	mov    (%rax),%rax
    1d03:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1d07:	73 ba                	jae    1cc3 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1d09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d0d:	8b 40 08             	mov    0x8(%rax),%eax
    1d10:	89 c0                	mov    %eax,%eax
    1d12:	48 c1 e0 04          	shl    $0x4,%rax
    1d16:	48 89 c2             	mov    %rax,%rdx
    1d19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d1d:	48 01 c2             	add    %rax,%rdx
    1d20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d24:	48 8b 00             	mov    (%rax),%rax
    1d27:	48 39 c2             	cmp    %rax,%rdx
    1d2a:	75 2d                	jne    1d59 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1d2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d30:	8b 50 08             	mov    0x8(%rax),%edx
    1d33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d37:	48 8b 00             	mov    (%rax),%rax
    1d3a:	8b 40 08             	mov    0x8(%rax),%eax
    1d3d:	01 c2                	add    %eax,%edx
    1d3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d43:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1d46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d4a:	48 8b 00             	mov    (%rax),%rax
    1d4d:	48 8b 10             	mov    (%rax),%rdx
    1d50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d54:	48 89 10             	mov    %rdx,(%rax)
    1d57:	eb 0e                	jmp    1d67 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1d59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d5d:	48 8b 10             	mov    (%rax),%rdx
    1d60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d64:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1d67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d6b:	8b 40 08             	mov    0x8(%rax),%eax
    1d6e:	89 c0                	mov    %eax,%eax
    1d70:	48 c1 e0 04          	shl    $0x4,%rax
    1d74:	48 89 c2             	mov    %rax,%rdx
    1d77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d7b:	48 01 d0             	add    %rdx,%rax
    1d7e:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1d82:	75 27                	jne    1dab <free+0x117>
    p->s.size += bp->s.size;
    1d84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d88:	8b 50 08             	mov    0x8(%rax),%edx
    1d8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d8f:	8b 40 08             	mov    0x8(%rax),%eax
    1d92:	01 c2                	add    %eax,%edx
    1d94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d98:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1d9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d9f:	48 8b 10             	mov    (%rax),%rdx
    1da2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1da6:	48 89 10             	mov    %rdx,(%rax)
    1da9:	eb 0b                	jmp    1db6 <free+0x122>
  } else
    p->s.ptr = bp;
    1dab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1daf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1db3:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1db6:	48 ba 40 24 00 00 00 	movabs $0x2440,%rdx
    1dbd:	00 00 00 
    1dc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dc4:	48 89 02             	mov    %rax,(%rdx)
}
    1dc7:	90                   	nop
    1dc8:	c9                   	leaveq 
    1dc9:	c3                   	retq   

0000000000001dca <morecore>:

static Header*
morecore(uint nu)
{
    1dca:	f3 0f 1e fa          	endbr64 
    1dce:	55                   	push   %rbp
    1dcf:	48 89 e5             	mov    %rsp,%rbp
    1dd2:	48 83 ec 20          	sub    $0x20,%rsp
    1dd6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1dd9:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1de0:	77 07                	ja     1de9 <morecore+0x1f>
    nu = 4096;
    1de2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1de9:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1dec:	48 c1 e0 04          	shl    $0x4,%rax
    1df0:	48 89 c7             	mov    %rax,%rdi
    1df3:	48 b8 5d 16 00 00 00 	movabs $0x165d,%rax
    1dfa:	00 00 00 
    1dfd:	ff d0                	callq  *%rax
    1dff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1e03:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1e08:	75 07                	jne    1e11 <morecore+0x47>
    return 0;
    1e0a:	b8 00 00 00 00       	mov    $0x0,%eax
    1e0f:	eb 36                	jmp    1e47 <morecore+0x7d>
  hp = (Header*)p;
    1e11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e15:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1e19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e1d:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1e20:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1e23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e27:	48 83 c0 10          	add    $0x10,%rax
    1e2b:	48 89 c7             	mov    %rax,%rdi
    1e2e:	48 b8 94 1c 00 00 00 	movabs $0x1c94,%rax
    1e35:	00 00 00 
    1e38:	ff d0                	callq  *%rax
  return freep;
    1e3a:	48 b8 40 24 00 00 00 	movabs $0x2440,%rax
    1e41:	00 00 00 
    1e44:	48 8b 00             	mov    (%rax),%rax
}
    1e47:	c9                   	leaveq 
    1e48:	c3                   	retq   

0000000000001e49 <malloc>:

void*
malloc(uint nbytes)
{
    1e49:	f3 0f 1e fa          	endbr64 
    1e4d:	55                   	push   %rbp
    1e4e:	48 89 e5             	mov    %rsp,%rbp
    1e51:	48 83 ec 30          	sub    $0x30,%rsp
    1e55:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1e58:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1e5b:	48 83 c0 0f          	add    $0xf,%rax
    1e5f:	48 c1 e8 04          	shr    $0x4,%rax
    1e63:	83 c0 01             	add    $0x1,%eax
    1e66:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1e69:	48 b8 40 24 00 00 00 	movabs $0x2440,%rax
    1e70:	00 00 00 
    1e73:	48 8b 00             	mov    (%rax),%rax
    1e76:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e7a:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1e7f:	75 4a                	jne    1ecb <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1e81:	48 b8 30 24 00 00 00 	movabs $0x2430,%rax
    1e88:	00 00 00 
    1e8b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e8f:	48 ba 40 24 00 00 00 	movabs $0x2440,%rdx
    1e96:	00 00 00 
    1e99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e9d:	48 89 02             	mov    %rax,(%rdx)
    1ea0:	48 b8 40 24 00 00 00 	movabs $0x2440,%rax
    1ea7:	00 00 00 
    1eaa:	48 8b 00             	mov    (%rax),%rax
    1ead:	48 ba 30 24 00 00 00 	movabs $0x2430,%rdx
    1eb4:	00 00 00 
    1eb7:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1eba:	48 b8 30 24 00 00 00 	movabs $0x2430,%rax
    1ec1:	00 00 00 
    1ec4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ecb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ecf:	48 8b 00             	mov    (%rax),%rax
    1ed2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1ed6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1eda:	8b 40 08             	mov    0x8(%rax),%eax
    1edd:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1ee0:	77 65                	ja     1f47 <malloc+0xfe>
      if(p->s.size == nunits)
    1ee2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ee6:	8b 40 08             	mov    0x8(%rax),%eax
    1ee9:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1eec:	75 10                	jne    1efe <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1eee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ef2:	48 8b 10             	mov    (%rax),%rdx
    1ef5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ef9:	48 89 10             	mov    %rdx,(%rax)
    1efc:	eb 2e                	jmp    1f2c <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1efe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f02:	8b 40 08             	mov    0x8(%rax),%eax
    1f05:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1f08:	89 c2                	mov    %eax,%edx
    1f0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f0e:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1f11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f15:	8b 40 08             	mov    0x8(%rax),%eax
    1f18:	89 c0                	mov    %eax,%eax
    1f1a:	48 c1 e0 04          	shl    $0x4,%rax
    1f1e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1f22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f26:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1f29:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1f2c:	48 ba 40 24 00 00 00 	movabs $0x2440,%rdx
    1f33:	00 00 00 
    1f36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f3a:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1f3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f41:	48 83 c0 10          	add    $0x10,%rax
    1f45:	eb 4e                	jmp    1f95 <malloc+0x14c>
    }
    if(p == freep)
    1f47:	48 b8 40 24 00 00 00 	movabs $0x2440,%rax
    1f4e:	00 00 00 
    1f51:	48 8b 00             	mov    (%rax),%rax
    1f54:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f58:	75 23                	jne    1f7d <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1f5a:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1f5d:	89 c7                	mov    %eax,%edi
    1f5f:	48 b8 ca 1d 00 00 00 	movabs $0x1dca,%rax
    1f66:	00 00 00 
    1f69:	ff d0                	callq  *%rax
    1f6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f6f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1f74:	75 07                	jne    1f7d <malloc+0x134>
        return 0;
    1f76:	b8 00 00 00 00       	mov    $0x0,%eax
    1f7b:	eb 18                	jmp    1f95 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1f7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f81:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1f85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f89:	48 8b 00             	mov    (%rax),%rax
    1f8c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1f90:	e9 41 ff ff ff       	jmpq   1ed6 <malloc+0x8d>
  }
}
    1f95:	c9                   	leaveq 
    1f96:	c3                   	retq   
