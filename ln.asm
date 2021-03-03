
_ln:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 10          	sub    $0x10,%rsp
    100c:	89 7d fc             	mov    %edi,-0x4(%rbp)
    100f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(argc != 3){
    1013:	83 7d fc 03          	cmpl   $0x3,-0x4(%rbp)
    1017:	74 2c                	je     1045 <main+0x45>
    printf(2, "Usage: ln old new\n");
    1019:	48 be 18 1e 00 00 00 	movabs $0x1e18,%rsi
    1020:	00 00 00 
    1023:	bf 02 00 00 00       	mov    $0x2,%edi
    1028:	b8 00 00 00 00       	mov    $0x0,%eax
    102d:	48 ba 01 17 00 00 00 	movabs $0x1701,%rdx
    1034:	00 00 00 
    1037:	ff d2                	callq  *%rdx
    exit();
    1039:	48 b8 fd 13 00 00 00 	movabs $0x13fd,%rax
    1040:	00 00 00 
    1043:	ff d0                	callq  *%rax
  }
  if(link(argv[1], argv[2]) < 0)
    1045:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1049:	48 83 c0 10          	add    $0x10,%rax
    104d:	48 8b 10             	mov    (%rax),%rdx
    1050:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1054:	48 83 c0 08          	add    $0x8,%rax
    1058:	48 8b 00             	mov    (%rax),%rax
    105b:	48 89 d6             	mov    %rdx,%rsi
    105e:	48 89 c7             	mov    %rax,%rdi
    1061:	48 b8 99 14 00 00 00 	movabs $0x1499,%rax
    1068:	00 00 00 
    106b:	ff d0                	callq  *%rax
    106d:	85 c0                	test   %eax,%eax
    106f:	79 3d                	jns    10ae <main+0xae>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
    1071:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1075:	48 83 c0 10          	add    $0x10,%rax
    1079:	48 8b 10             	mov    (%rax),%rdx
    107c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1080:	48 83 c0 08          	add    $0x8,%rax
    1084:	48 8b 00             	mov    (%rax),%rax
    1087:	48 89 d1             	mov    %rdx,%rcx
    108a:	48 89 c2             	mov    %rax,%rdx
    108d:	48 be 2b 1e 00 00 00 	movabs $0x1e2b,%rsi
    1094:	00 00 00 
    1097:	bf 02 00 00 00       	mov    $0x2,%edi
    109c:	b8 00 00 00 00       	mov    $0x0,%eax
    10a1:	49 b8 01 17 00 00 00 	movabs $0x1701,%r8
    10a8:	00 00 00 
    10ab:	41 ff d0             	callq  *%r8
  exit();
    10ae:	48 b8 fd 13 00 00 00 	movabs $0x13fd,%rax
    10b5:	00 00 00 
    10b8:	ff d0                	callq  *%rax

00000000000010ba <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    10ba:	f3 0f 1e fa          	endbr64 
    10be:	55                   	push   %rbp
    10bf:	48 89 e5             	mov    %rsp,%rbp
    10c2:	48 83 ec 10          	sub    $0x10,%rsp
    10c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10ca:	89 75 f4             	mov    %esi,-0xc(%rbp)
    10cd:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    10d0:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    10d4:	8b 55 f0             	mov    -0x10(%rbp),%edx
    10d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
    10da:	48 89 ce             	mov    %rcx,%rsi
    10dd:	48 89 f7             	mov    %rsi,%rdi
    10e0:	89 d1                	mov    %edx,%ecx
    10e2:	fc                   	cld    
    10e3:	f3 aa                	rep stos %al,%es:(%rdi)
    10e5:	89 ca                	mov    %ecx,%edx
    10e7:	48 89 fe             	mov    %rdi,%rsi
    10ea:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    10ee:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10f1:	90                   	nop
    10f2:	c9                   	leaveq 
    10f3:	c3                   	retq   

00000000000010f4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10f4:	f3 0f 1e fa          	endbr64 
    10f8:	55                   	push   %rbp
    10f9:	48 89 e5             	mov    %rsp,%rbp
    10fc:	48 83 ec 20          	sub    $0x20,%rsp
    1100:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1104:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    1108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    110c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1110:	90                   	nop
    1111:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1115:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1119:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    111d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1121:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1125:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1129:	0f b6 12             	movzbl (%rdx),%edx
    112c:	88 10                	mov    %dl,(%rax)
    112e:	0f b6 00             	movzbl (%rax),%eax
    1131:	84 c0                	test   %al,%al
    1133:	75 dc                	jne    1111 <strcpy+0x1d>
    ;
  return os;
    1135:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1139:	c9                   	leaveq 
    113a:	c3                   	retq   

000000000000113b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    113b:	f3 0f 1e fa          	endbr64 
    113f:	55                   	push   %rbp
    1140:	48 89 e5             	mov    %rsp,%rbp
    1143:	48 83 ec 10          	sub    $0x10,%rsp
    1147:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    114b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    114f:	eb 0a                	jmp    115b <strcmp+0x20>
    p++, q++;
    1151:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1156:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    115b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    115f:	0f b6 00             	movzbl (%rax),%eax
    1162:	84 c0                	test   %al,%al
    1164:	74 12                	je     1178 <strcmp+0x3d>
    1166:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    116a:	0f b6 10             	movzbl (%rax),%edx
    116d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1171:	0f b6 00             	movzbl (%rax),%eax
    1174:	38 c2                	cmp    %al,%dl
    1176:	74 d9                	je     1151 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1178:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    117c:	0f b6 00             	movzbl (%rax),%eax
    117f:	0f b6 d0             	movzbl %al,%edx
    1182:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1186:	0f b6 00             	movzbl (%rax),%eax
    1189:	0f b6 c0             	movzbl %al,%eax
    118c:	29 c2                	sub    %eax,%edx
    118e:	89 d0                	mov    %edx,%eax
}
    1190:	c9                   	leaveq 
    1191:	c3                   	retq   

0000000000001192 <strlen>:

uint
strlen(char *s)
{
    1192:	f3 0f 1e fa          	endbr64 
    1196:	55                   	push   %rbp
    1197:	48 89 e5             	mov    %rsp,%rbp
    119a:	48 83 ec 18          	sub    $0x18,%rsp
    119e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    11a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    11a9:	eb 04                	jmp    11af <strlen+0x1d>
    11ab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    11af:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11b2:	48 63 d0             	movslq %eax,%rdx
    11b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11b9:	48 01 d0             	add    %rdx,%rax
    11bc:	0f b6 00             	movzbl (%rax),%eax
    11bf:	84 c0                	test   %al,%al
    11c1:	75 e8                	jne    11ab <strlen+0x19>
    ;
  return n;
    11c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    11c6:	c9                   	leaveq 
    11c7:	c3                   	retq   

00000000000011c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11c8:	f3 0f 1e fa          	endbr64 
    11cc:	55                   	push   %rbp
    11cd:	48 89 e5             	mov    %rsp,%rbp
    11d0:	48 83 ec 10          	sub    $0x10,%rsp
    11d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11d8:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11db:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    11de:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11e1:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    11e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11e8:	89 ce                	mov    %ecx,%esi
    11ea:	48 89 c7             	mov    %rax,%rdi
    11ed:	48 b8 ba 10 00 00 00 	movabs $0x10ba,%rax
    11f4:	00 00 00 
    11f7:	ff d0                	callq  *%rax
  return dst;
    11f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    11fd:	c9                   	leaveq 
    11fe:	c3                   	retq   

00000000000011ff <strchr>:

char*
strchr(const char *s, char c)
{
    11ff:	f3 0f 1e fa          	endbr64 
    1203:	55                   	push   %rbp
    1204:	48 89 e5             	mov    %rsp,%rbp
    1207:	48 83 ec 10          	sub    $0x10,%rsp
    120b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    120f:	89 f0                	mov    %esi,%eax
    1211:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1214:	eb 17                	jmp    122d <strchr+0x2e>
    if(*s == c)
    1216:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    121a:	0f b6 00             	movzbl (%rax),%eax
    121d:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1220:	75 06                	jne    1228 <strchr+0x29>
      return (char*)s;
    1222:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1226:	eb 15                	jmp    123d <strchr+0x3e>
  for(; *s; s++)
    1228:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    122d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1231:	0f b6 00             	movzbl (%rax),%eax
    1234:	84 c0                	test   %al,%al
    1236:	75 de                	jne    1216 <strchr+0x17>
  return 0;
    1238:	b8 00 00 00 00       	mov    $0x0,%eax
}
    123d:	c9                   	leaveq 
    123e:	c3                   	retq   

000000000000123f <gets>:

char*
gets(char *buf, int max)
{
    123f:	f3 0f 1e fa          	endbr64 
    1243:	55                   	push   %rbp
    1244:	48 89 e5             	mov    %rsp,%rbp
    1247:	48 83 ec 20          	sub    $0x20,%rsp
    124b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    124f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1252:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1259:	eb 4f                	jmp    12aa <gets+0x6b>
    cc = read(0, &c, 1);
    125b:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    125f:	ba 01 00 00 00       	mov    $0x1,%edx
    1264:	48 89 c6             	mov    %rax,%rsi
    1267:	bf 00 00 00 00       	mov    $0x0,%edi
    126c:	48 b8 24 14 00 00 00 	movabs $0x1424,%rax
    1273:	00 00 00 
    1276:	ff d0                	callq  *%rax
    1278:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    127b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    127f:	7e 36                	jle    12b7 <gets+0x78>
      break;
    buf[i++] = c;
    1281:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1284:	8d 50 01             	lea    0x1(%rax),%edx
    1287:	89 55 fc             	mov    %edx,-0x4(%rbp)
    128a:	48 63 d0             	movslq %eax,%rdx
    128d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1291:	48 01 c2             	add    %rax,%rdx
    1294:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1298:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    129a:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    129e:	3c 0a                	cmp    $0xa,%al
    12a0:	74 16                	je     12b8 <gets+0x79>
    12a2:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    12a6:	3c 0d                	cmp    $0xd,%al
    12a8:	74 0e                	je     12b8 <gets+0x79>
  for(i=0; i+1 < max; ){
    12aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12ad:	83 c0 01             	add    $0x1,%eax
    12b0:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    12b3:	7f a6                	jg     125b <gets+0x1c>
    12b5:	eb 01                	jmp    12b8 <gets+0x79>
      break;
    12b7:	90                   	nop
      break;
  }
  buf[i] = '\0';
    12b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12bb:	48 63 d0             	movslq %eax,%rdx
    12be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12c2:	48 01 d0             	add    %rdx,%rax
    12c5:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    12c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    12cc:	c9                   	leaveq 
    12cd:	c3                   	retq   

00000000000012ce <stat>:

int
stat(char *n, struct stat *st)
{
    12ce:	f3 0f 1e fa          	endbr64 
    12d2:	55                   	push   %rbp
    12d3:	48 89 e5             	mov    %rsp,%rbp
    12d6:	48 83 ec 20          	sub    $0x20,%rsp
    12da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12e6:	be 00 00 00 00       	mov    $0x0,%esi
    12eb:	48 89 c7             	mov    %rax,%rdi
    12ee:	48 b8 65 14 00 00 00 	movabs $0x1465,%rax
    12f5:	00 00 00 
    12f8:	ff d0                	callq  *%rax
    12fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    12fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1301:	79 07                	jns    130a <stat+0x3c>
    return -1;
    1303:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1308:	eb 2f                	jmp    1339 <stat+0x6b>
  r = fstat(fd, st);
    130a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    130e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1311:	48 89 d6             	mov    %rdx,%rsi
    1314:	89 c7                	mov    %eax,%edi
    1316:	48 b8 8c 14 00 00 00 	movabs $0x148c,%rax
    131d:	00 00 00 
    1320:	ff d0                	callq  *%rax
    1322:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1325:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1328:	89 c7                	mov    %eax,%edi
    132a:	48 b8 3e 14 00 00 00 	movabs $0x143e,%rax
    1331:	00 00 00 
    1334:	ff d0                	callq  *%rax
  return r;
    1336:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1339:	c9                   	leaveq 
    133a:	c3                   	retq   

000000000000133b <atoi>:

int
atoi(const char *s)
{
    133b:	f3 0f 1e fa          	endbr64 
    133f:	55                   	push   %rbp
    1340:	48 89 e5             	mov    %rsp,%rbp
    1343:	48 83 ec 18          	sub    $0x18,%rsp
    1347:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    134b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1352:	eb 28                	jmp    137c <atoi+0x41>
    n = n*10 + *s++ - '0';
    1354:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1357:	89 d0                	mov    %edx,%eax
    1359:	c1 e0 02             	shl    $0x2,%eax
    135c:	01 d0                	add    %edx,%eax
    135e:	01 c0                	add    %eax,%eax
    1360:	89 c1                	mov    %eax,%ecx
    1362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1366:	48 8d 50 01          	lea    0x1(%rax),%rdx
    136a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    136e:	0f b6 00             	movzbl (%rax),%eax
    1371:	0f be c0             	movsbl %al,%eax
    1374:	01 c8                	add    %ecx,%eax
    1376:	83 e8 30             	sub    $0x30,%eax
    1379:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    137c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1380:	0f b6 00             	movzbl (%rax),%eax
    1383:	3c 2f                	cmp    $0x2f,%al
    1385:	7e 0b                	jle    1392 <atoi+0x57>
    1387:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    138b:	0f b6 00             	movzbl (%rax),%eax
    138e:	3c 39                	cmp    $0x39,%al
    1390:	7e c2                	jle    1354 <atoi+0x19>
  return n;
    1392:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1395:	c9                   	leaveq 
    1396:	c3                   	retq   

0000000000001397 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1397:	f3 0f 1e fa          	endbr64 
    139b:	55                   	push   %rbp
    139c:	48 89 e5             	mov    %rsp,%rbp
    139f:	48 83 ec 28          	sub    $0x28,%rsp
    13a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    13ab:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    13ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    13b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    13ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    13be:	eb 1d                	jmp    13dd <memmove+0x46>
    *dst++ = *src++;
    13c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    13c4:	48 8d 42 01          	lea    0x1(%rdx),%rax
    13c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    13cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13d0:	48 8d 48 01          	lea    0x1(%rax),%rcx
    13d4:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    13d8:	0f b6 12             	movzbl (%rdx),%edx
    13db:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    13dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13e0:	8d 50 ff             	lea    -0x1(%rax),%edx
    13e3:	89 55 dc             	mov    %edx,-0x24(%rbp)
    13e6:	85 c0                	test   %eax,%eax
    13e8:	7f d6                	jg     13c0 <memmove+0x29>
  return vdst;
    13ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13ee:	c9                   	leaveq 
    13ef:	c3                   	retq   

00000000000013f0 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    13f0:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    13f7:	49 89 ca             	mov    %rcx,%r10
    13fa:	0f 05                	syscall 
    13fc:	c3                   	retq   

00000000000013fd <exit>:
SYSCALL(exit)
    13fd:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1404:	49 89 ca             	mov    %rcx,%r10
    1407:	0f 05                	syscall 
    1409:	c3                   	retq   

000000000000140a <wait>:
SYSCALL(wait)
    140a:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1411:	49 89 ca             	mov    %rcx,%r10
    1414:	0f 05                	syscall 
    1416:	c3                   	retq   

0000000000001417 <pipe>:
SYSCALL(pipe)
    1417:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    141e:	49 89 ca             	mov    %rcx,%r10
    1421:	0f 05                	syscall 
    1423:	c3                   	retq   

0000000000001424 <read>:
SYSCALL(read)
    1424:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    142b:	49 89 ca             	mov    %rcx,%r10
    142e:	0f 05                	syscall 
    1430:	c3                   	retq   

0000000000001431 <write>:
SYSCALL(write)
    1431:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    1438:	49 89 ca             	mov    %rcx,%r10
    143b:	0f 05                	syscall 
    143d:	c3                   	retq   

000000000000143e <close>:
SYSCALL(close)
    143e:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1445:	49 89 ca             	mov    %rcx,%r10
    1448:	0f 05                	syscall 
    144a:	c3                   	retq   

000000000000144b <kill>:
SYSCALL(kill)
    144b:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1452:	49 89 ca             	mov    %rcx,%r10
    1455:	0f 05                	syscall 
    1457:	c3                   	retq   

0000000000001458 <exec>:
SYSCALL(exec)
    1458:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    145f:	49 89 ca             	mov    %rcx,%r10
    1462:	0f 05                	syscall 
    1464:	c3                   	retq   

0000000000001465 <open>:
SYSCALL(open)
    1465:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    146c:	49 89 ca             	mov    %rcx,%r10
    146f:	0f 05                	syscall 
    1471:	c3                   	retq   

0000000000001472 <mknod>:
SYSCALL(mknod)
    1472:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1479:	49 89 ca             	mov    %rcx,%r10
    147c:	0f 05                	syscall 
    147e:	c3                   	retq   

000000000000147f <unlink>:
SYSCALL(unlink)
    147f:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1486:	49 89 ca             	mov    %rcx,%r10
    1489:	0f 05                	syscall 
    148b:	c3                   	retq   

000000000000148c <fstat>:
SYSCALL(fstat)
    148c:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1493:	49 89 ca             	mov    %rcx,%r10
    1496:	0f 05                	syscall 
    1498:	c3                   	retq   

0000000000001499 <link>:
SYSCALL(link)
    1499:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    14a0:	49 89 ca             	mov    %rcx,%r10
    14a3:	0f 05                	syscall 
    14a5:	c3                   	retq   

00000000000014a6 <mkdir>:
SYSCALL(mkdir)
    14a6:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    14ad:	49 89 ca             	mov    %rcx,%r10
    14b0:	0f 05                	syscall 
    14b2:	c3                   	retq   

00000000000014b3 <chdir>:
SYSCALL(chdir)
    14b3:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    14ba:	49 89 ca             	mov    %rcx,%r10
    14bd:	0f 05                	syscall 
    14bf:	c3                   	retq   

00000000000014c0 <dup>:
SYSCALL(dup)
    14c0:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    14c7:	49 89 ca             	mov    %rcx,%r10
    14ca:	0f 05                	syscall 
    14cc:	c3                   	retq   

00000000000014cd <getpid>:
SYSCALL(getpid)
    14cd:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    14d4:	49 89 ca             	mov    %rcx,%r10
    14d7:	0f 05                	syscall 
    14d9:	c3                   	retq   

00000000000014da <sbrk>:
SYSCALL(sbrk)
    14da:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    14e1:	49 89 ca             	mov    %rcx,%r10
    14e4:	0f 05                	syscall 
    14e6:	c3                   	retq   

00000000000014e7 <sleep>:
SYSCALL(sleep)
    14e7:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    14ee:	49 89 ca             	mov    %rcx,%r10
    14f1:	0f 05                	syscall 
    14f3:	c3                   	retq   

00000000000014f4 <uptime>:
SYSCALL(uptime)
    14f4:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    14fb:	49 89 ca             	mov    %rcx,%r10
    14fe:	0f 05                	syscall 
    1500:	c3                   	retq   

0000000000001501 <dedup>:
SYSCALL(dedup)
    1501:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    1508:	49 89 ca             	mov    %rcx,%r10
    150b:	0f 05                	syscall 
    150d:	c3                   	retq   

000000000000150e <freepages>:
SYSCALL(freepages)
    150e:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    1515:	49 89 ca             	mov    %rcx,%r10
    1518:	0f 05                	syscall 
    151a:	c3                   	retq   

000000000000151b <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    151b:	f3 0f 1e fa          	endbr64 
    151f:	55                   	push   %rbp
    1520:	48 89 e5             	mov    %rsp,%rbp
    1523:	48 83 ec 10          	sub    $0x10,%rsp
    1527:	89 7d fc             	mov    %edi,-0x4(%rbp)
    152a:	89 f0                	mov    %esi,%eax
    152c:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    152f:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1533:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1536:	ba 01 00 00 00       	mov    $0x1,%edx
    153b:	48 89 ce             	mov    %rcx,%rsi
    153e:	89 c7                	mov    %eax,%edi
    1540:	48 b8 31 14 00 00 00 	movabs $0x1431,%rax
    1547:	00 00 00 
    154a:	ff d0                	callq  *%rax
}
    154c:	90                   	nop
    154d:	c9                   	leaveq 
    154e:	c3                   	retq   

000000000000154f <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    154f:	f3 0f 1e fa          	endbr64 
    1553:	55                   	push   %rbp
    1554:	48 89 e5             	mov    %rsp,%rbp
    1557:	48 83 ec 20          	sub    $0x20,%rsp
    155b:	89 7d ec             	mov    %edi,-0x14(%rbp)
    155e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1562:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1569:	eb 35                	jmp    15a0 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    156b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    156f:	48 c1 e8 3c          	shr    $0x3c,%rax
    1573:	48 ba 70 21 00 00 00 	movabs $0x2170,%rdx
    157a:	00 00 00 
    157d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1581:	0f be d0             	movsbl %al,%edx
    1584:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1587:	89 d6                	mov    %edx,%esi
    1589:	89 c7                	mov    %eax,%edi
    158b:	48 b8 1b 15 00 00 00 	movabs $0x151b,%rax
    1592:	00 00 00 
    1595:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1597:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    159b:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    15a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15a3:	83 f8 0f             	cmp    $0xf,%eax
    15a6:	76 c3                	jbe    156b <print_x64+0x1c>
}
    15a8:	90                   	nop
    15a9:	90                   	nop
    15aa:	c9                   	leaveq 
    15ab:	c3                   	retq   

00000000000015ac <print_x32>:

  static void
print_x32(int fd, uint x)
{
    15ac:	f3 0f 1e fa          	endbr64 
    15b0:	55                   	push   %rbp
    15b1:	48 89 e5             	mov    %rsp,%rbp
    15b4:	48 83 ec 20          	sub    $0x20,%rsp
    15b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
    15bb:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    15c5:	eb 36                	jmp    15fd <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    15c7:	8b 45 e8             	mov    -0x18(%rbp),%eax
    15ca:	c1 e8 1c             	shr    $0x1c,%eax
    15cd:	89 c2                	mov    %eax,%edx
    15cf:	48 b8 70 21 00 00 00 	movabs $0x2170,%rax
    15d6:	00 00 00 
    15d9:	89 d2                	mov    %edx,%edx
    15db:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    15df:	0f be d0             	movsbl %al,%edx
    15e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15e5:	89 d6                	mov    %edx,%esi
    15e7:	89 c7                	mov    %eax,%edi
    15e9:	48 b8 1b 15 00 00 00 	movabs $0x151b,%rax
    15f0:	00 00 00 
    15f3:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15f5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15f9:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    15fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1600:	83 f8 07             	cmp    $0x7,%eax
    1603:	76 c2                	jbe    15c7 <print_x32+0x1b>
}
    1605:	90                   	nop
    1606:	90                   	nop
    1607:	c9                   	leaveq 
    1608:	c3                   	retq   

0000000000001609 <print_d>:

  static void
print_d(int fd, int v)
{
    1609:	f3 0f 1e fa          	endbr64 
    160d:	55                   	push   %rbp
    160e:	48 89 e5             	mov    %rsp,%rbp
    1611:	48 83 ec 30          	sub    $0x30,%rsp
    1615:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1618:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    161b:	8b 45 d8             	mov    -0x28(%rbp),%eax
    161e:	48 98                	cltq   
    1620:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1624:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1628:	79 04                	jns    162e <print_d+0x25>
    x = -x;
    162a:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    162e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1635:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1639:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1640:	66 66 66 
    1643:	48 89 c8             	mov    %rcx,%rax
    1646:	48 f7 ea             	imul   %rdx
    1649:	48 c1 fa 02          	sar    $0x2,%rdx
    164d:	48 89 c8             	mov    %rcx,%rax
    1650:	48 c1 f8 3f          	sar    $0x3f,%rax
    1654:	48 29 c2             	sub    %rax,%rdx
    1657:	48 89 d0             	mov    %rdx,%rax
    165a:	48 c1 e0 02          	shl    $0x2,%rax
    165e:	48 01 d0             	add    %rdx,%rax
    1661:	48 01 c0             	add    %rax,%rax
    1664:	48 29 c1             	sub    %rax,%rcx
    1667:	48 89 ca             	mov    %rcx,%rdx
    166a:	8b 45 f4             	mov    -0xc(%rbp),%eax
    166d:	8d 48 01             	lea    0x1(%rax),%ecx
    1670:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1673:	48 b9 70 21 00 00 00 	movabs $0x2170,%rcx
    167a:	00 00 00 
    167d:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1681:	48 98                	cltq   
    1683:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1687:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    168b:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1692:	66 66 66 
    1695:	48 89 c8             	mov    %rcx,%rax
    1698:	48 f7 ea             	imul   %rdx
    169b:	48 c1 fa 02          	sar    $0x2,%rdx
    169f:	48 89 c8             	mov    %rcx,%rax
    16a2:	48 c1 f8 3f          	sar    $0x3f,%rax
    16a6:	48 29 c2             	sub    %rax,%rdx
    16a9:	48 89 d0             	mov    %rdx,%rax
    16ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    16b0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    16b5:	0f 85 7a ff ff ff    	jne    1635 <print_d+0x2c>

  if (v < 0)
    16bb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    16bf:	79 32                	jns    16f3 <print_d+0xea>
    buf[i++] = '-';
    16c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16c4:	8d 50 01             	lea    0x1(%rax),%edx
    16c7:	89 55 f4             	mov    %edx,-0xc(%rbp)
    16ca:	48 98                	cltq   
    16cc:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    16d1:	eb 20                	jmp    16f3 <print_d+0xea>
    putc(fd, buf[i]);
    16d3:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16d6:	48 98                	cltq   
    16d8:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    16dd:	0f be d0             	movsbl %al,%edx
    16e0:	8b 45 dc             	mov    -0x24(%rbp),%eax
    16e3:	89 d6                	mov    %edx,%esi
    16e5:	89 c7                	mov    %eax,%edi
    16e7:	48 b8 1b 15 00 00 00 	movabs $0x151b,%rax
    16ee:	00 00 00 
    16f1:	ff d0                	callq  *%rax
  while (--i >= 0)
    16f3:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    16f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    16fb:	79 d6                	jns    16d3 <print_d+0xca>
}
    16fd:	90                   	nop
    16fe:	90                   	nop
    16ff:	c9                   	leaveq 
    1700:	c3                   	retq   

0000000000001701 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1701:	f3 0f 1e fa          	endbr64 
    1705:	55                   	push   %rbp
    1706:	48 89 e5             	mov    %rsp,%rbp
    1709:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1710:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1716:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    171d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1724:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    172b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1732:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1739:	84 c0                	test   %al,%al
    173b:	74 20                	je     175d <printf+0x5c>
    173d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1741:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1745:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1749:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    174d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1751:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1755:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1759:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    175d:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1764:	00 00 00 
    1767:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    176e:	00 00 00 
    1771:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1775:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    177c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1783:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    178a:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1791:	00 00 00 
    1794:	e9 41 03 00 00       	jmpq   1ada <printf+0x3d9>
    if (c != '%') {
    1799:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17a0:	74 24                	je     17c6 <printf+0xc5>
      putc(fd, c);
    17a2:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    17a8:	0f be d0             	movsbl %al,%edx
    17ab:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    17b1:	89 d6                	mov    %edx,%esi
    17b3:	89 c7                	mov    %eax,%edi
    17b5:	48 b8 1b 15 00 00 00 	movabs $0x151b,%rax
    17bc:	00 00 00 
    17bf:	ff d0                	callq  *%rax
      continue;
    17c1:	e9 0d 03 00 00       	jmpq   1ad3 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    17c6:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    17cd:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    17d3:	48 63 d0             	movslq %eax,%rdx
    17d6:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    17dd:	48 01 d0             	add    %rdx,%rax
    17e0:	0f b6 00             	movzbl (%rax),%eax
    17e3:	0f be c0             	movsbl %al,%eax
    17e6:	25 ff 00 00 00       	and    $0xff,%eax
    17eb:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    17f1:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    17f8:	0f 84 0f 03 00 00    	je     1b0d <printf+0x40c>
      break;
    switch(c) {
    17fe:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1805:	0f 84 74 02 00 00    	je     1a7f <printf+0x37e>
    180b:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1812:	0f 8c 82 02 00 00    	jl     1a9a <printf+0x399>
    1818:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    181f:	0f 8f 75 02 00 00    	jg     1a9a <printf+0x399>
    1825:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    182c:	0f 8c 68 02 00 00    	jl     1a9a <printf+0x399>
    1832:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1838:	83 e8 63             	sub    $0x63,%eax
    183b:	83 f8 15             	cmp    $0x15,%eax
    183e:	0f 87 56 02 00 00    	ja     1a9a <printf+0x399>
    1844:	89 c0                	mov    %eax,%eax
    1846:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    184d:	00 
    184e:	48 b8 48 1e 00 00 00 	movabs $0x1e48,%rax
    1855:	00 00 00 
    1858:	48 01 d0             	add    %rdx,%rax
    185b:	48 8b 00             	mov    (%rax),%rax
    185e:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1861:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1867:	83 f8 2f             	cmp    $0x2f,%eax
    186a:	77 23                	ja     188f <printf+0x18e>
    186c:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1873:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1879:	89 d2                	mov    %edx,%edx
    187b:	48 01 d0             	add    %rdx,%rax
    187e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1884:	83 c2 08             	add    $0x8,%edx
    1887:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    188d:	eb 12                	jmp    18a1 <printf+0x1a0>
    188f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1896:	48 8d 50 08          	lea    0x8(%rax),%rdx
    189a:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18a1:	8b 00                	mov    (%rax),%eax
    18a3:	0f be d0             	movsbl %al,%edx
    18a6:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18ac:	89 d6                	mov    %edx,%esi
    18ae:	89 c7                	mov    %eax,%edi
    18b0:	48 b8 1b 15 00 00 00 	movabs $0x151b,%rax
    18b7:	00 00 00 
    18ba:	ff d0                	callq  *%rax
      break;
    18bc:	e9 12 02 00 00       	jmpq   1ad3 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    18c1:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18c7:	83 f8 2f             	cmp    $0x2f,%eax
    18ca:	77 23                	ja     18ef <printf+0x1ee>
    18cc:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18d3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18d9:	89 d2                	mov    %edx,%edx
    18db:	48 01 d0             	add    %rdx,%rax
    18de:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18e4:	83 c2 08             	add    $0x8,%edx
    18e7:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18ed:	eb 12                	jmp    1901 <printf+0x200>
    18ef:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18f6:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18fa:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1901:	8b 10                	mov    (%rax),%edx
    1903:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1909:	89 d6                	mov    %edx,%esi
    190b:	89 c7                	mov    %eax,%edi
    190d:	48 b8 09 16 00 00 00 	movabs $0x1609,%rax
    1914:	00 00 00 
    1917:	ff d0                	callq  *%rax
      break;
    1919:	e9 b5 01 00 00       	jmpq   1ad3 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    191e:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1924:	83 f8 2f             	cmp    $0x2f,%eax
    1927:	77 23                	ja     194c <printf+0x24b>
    1929:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1930:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1936:	89 d2                	mov    %edx,%edx
    1938:	48 01 d0             	add    %rdx,%rax
    193b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1941:	83 c2 08             	add    $0x8,%edx
    1944:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    194a:	eb 12                	jmp    195e <printf+0x25d>
    194c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1953:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1957:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    195e:	8b 10                	mov    (%rax),%edx
    1960:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1966:	89 d6                	mov    %edx,%esi
    1968:	89 c7                	mov    %eax,%edi
    196a:	48 b8 ac 15 00 00 00 	movabs $0x15ac,%rax
    1971:	00 00 00 
    1974:	ff d0                	callq  *%rax
      break;
    1976:	e9 58 01 00 00       	jmpq   1ad3 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    197b:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1981:	83 f8 2f             	cmp    $0x2f,%eax
    1984:	77 23                	ja     19a9 <printf+0x2a8>
    1986:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    198d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1993:	89 d2                	mov    %edx,%edx
    1995:	48 01 d0             	add    %rdx,%rax
    1998:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    199e:	83 c2 08             	add    $0x8,%edx
    19a1:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19a7:	eb 12                	jmp    19bb <printf+0x2ba>
    19a9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19b0:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19b4:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19bb:	48 8b 10             	mov    (%rax),%rdx
    19be:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19c4:	48 89 d6             	mov    %rdx,%rsi
    19c7:	89 c7                	mov    %eax,%edi
    19c9:	48 b8 4f 15 00 00 00 	movabs $0x154f,%rax
    19d0:	00 00 00 
    19d3:	ff d0                	callq  *%rax
      break;
    19d5:	e9 f9 00 00 00       	jmpq   1ad3 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    19da:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19e0:	83 f8 2f             	cmp    $0x2f,%eax
    19e3:	77 23                	ja     1a08 <printf+0x307>
    19e5:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19ec:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19f2:	89 d2                	mov    %edx,%edx
    19f4:	48 01 d0             	add    %rdx,%rax
    19f7:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19fd:	83 c2 08             	add    $0x8,%edx
    1a00:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a06:	eb 12                	jmp    1a1a <printf+0x319>
    1a08:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a0f:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a13:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a1a:	48 8b 00             	mov    (%rax),%rax
    1a1d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1a24:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1a2b:	00 
    1a2c:	75 41                	jne    1a6f <printf+0x36e>
        s = "(null)";
    1a2e:	48 b8 40 1e 00 00 00 	movabs $0x1e40,%rax
    1a35:	00 00 00 
    1a38:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1a3f:	eb 2e                	jmp    1a6f <printf+0x36e>
        putc(fd, *(s++));
    1a41:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a48:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a4c:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a53:	0f b6 00             	movzbl (%rax),%eax
    1a56:	0f be d0             	movsbl %al,%edx
    1a59:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a5f:	89 d6                	mov    %edx,%esi
    1a61:	89 c7                	mov    %eax,%edi
    1a63:	48 b8 1b 15 00 00 00 	movabs $0x151b,%rax
    1a6a:	00 00 00 
    1a6d:	ff d0                	callq  *%rax
      while (*s)
    1a6f:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a76:	0f b6 00             	movzbl (%rax),%eax
    1a79:	84 c0                	test   %al,%al
    1a7b:	75 c4                	jne    1a41 <printf+0x340>
      break;
    1a7d:	eb 54                	jmp    1ad3 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1a7f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a85:	be 25 00 00 00       	mov    $0x25,%esi
    1a8a:	89 c7                	mov    %eax,%edi
    1a8c:	48 b8 1b 15 00 00 00 	movabs $0x151b,%rax
    1a93:	00 00 00 
    1a96:	ff d0                	callq  *%rax
      break;
    1a98:	eb 39                	jmp    1ad3 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a9a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1aa0:	be 25 00 00 00       	mov    $0x25,%esi
    1aa5:	89 c7                	mov    %eax,%edi
    1aa7:	48 b8 1b 15 00 00 00 	movabs $0x151b,%rax
    1aae:	00 00 00 
    1ab1:	ff d0                	callq  *%rax
      putc(fd, c);
    1ab3:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1ab9:	0f be d0             	movsbl %al,%edx
    1abc:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ac2:	89 d6                	mov    %edx,%esi
    1ac4:	89 c7                	mov    %eax,%edi
    1ac6:	48 b8 1b 15 00 00 00 	movabs $0x151b,%rax
    1acd:	00 00 00 
    1ad0:	ff d0                	callq  *%rax
      break;
    1ad2:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1ad3:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1ada:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1ae0:	48 63 d0             	movslq %eax,%rdx
    1ae3:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1aea:	48 01 d0             	add    %rdx,%rax
    1aed:	0f b6 00             	movzbl (%rax),%eax
    1af0:	0f be c0             	movsbl %al,%eax
    1af3:	25 ff 00 00 00       	and    $0xff,%eax
    1af8:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1afe:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1b05:	0f 85 8e fc ff ff    	jne    1799 <printf+0x98>
    }
  }
}
    1b0b:	eb 01                	jmp    1b0e <printf+0x40d>
      break;
    1b0d:	90                   	nop
}
    1b0e:	90                   	nop
    1b0f:	c9                   	leaveq 
    1b10:	c3                   	retq   

0000000000001b11 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1b11:	f3 0f 1e fa          	endbr64 
    1b15:	55                   	push   %rbp
    1b16:	48 89 e5             	mov    %rsp,%rbp
    1b19:	48 83 ec 18          	sub    $0x18,%rsp
    1b1d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1b21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b25:	48 83 e8 10          	sub    $0x10,%rax
    1b29:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b2d:	48 b8 a0 21 00 00 00 	movabs $0x21a0,%rax
    1b34:	00 00 00 
    1b37:	48 8b 00             	mov    (%rax),%rax
    1b3a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b3e:	eb 2f                	jmp    1b6f <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1b40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b44:	48 8b 00             	mov    (%rax),%rax
    1b47:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b4b:	72 17                	jb     1b64 <free+0x53>
    1b4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b51:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b55:	77 2f                	ja     1b86 <free+0x75>
    1b57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b5b:	48 8b 00             	mov    (%rax),%rax
    1b5e:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b62:	72 22                	jb     1b86 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b68:	48 8b 00             	mov    (%rax),%rax
    1b6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b73:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b77:	76 c7                	jbe    1b40 <free+0x2f>
    1b79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b7d:	48 8b 00             	mov    (%rax),%rax
    1b80:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b84:	73 ba                	jae    1b40 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b8a:	8b 40 08             	mov    0x8(%rax),%eax
    1b8d:	89 c0                	mov    %eax,%eax
    1b8f:	48 c1 e0 04          	shl    $0x4,%rax
    1b93:	48 89 c2             	mov    %rax,%rdx
    1b96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b9a:	48 01 c2             	add    %rax,%rdx
    1b9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ba1:	48 8b 00             	mov    (%rax),%rax
    1ba4:	48 39 c2             	cmp    %rax,%rdx
    1ba7:	75 2d                	jne    1bd6 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1ba9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bad:	8b 50 08             	mov    0x8(%rax),%edx
    1bb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bb4:	48 8b 00             	mov    (%rax),%rax
    1bb7:	8b 40 08             	mov    0x8(%rax),%eax
    1bba:	01 c2                	add    %eax,%edx
    1bbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bc0:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1bc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bc7:	48 8b 00             	mov    (%rax),%rax
    1bca:	48 8b 10             	mov    (%rax),%rdx
    1bcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bd1:	48 89 10             	mov    %rdx,(%rax)
    1bd4:	eb 0e                	jmp    1be4 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1bd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bda:	48 8b 10             	mov    (%rax),%rdx
    1bdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1be1:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1be4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1be8:	8b 40 08             	mov    0x8(%rax),%eax
    1beb:	89 c0                	mov    %eax,%eax
    1bed:	48 c1 e0 04          	shl    $0x4,%rax
    1bf1:	48 89 c2             	mov    %rax,%rdx
    1bf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bf8:	48 01 d0             	add    %rdx,%rax
    1bfb:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1bff:	75 27                	jne    1c28 <free+0x117>
    p->s.size += bp->s.size;
    1c01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c05:	8b 50 08             	mov    0x8(%rax),%edx
    1c08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c0c:	8b 40 08             	mov    0x8(%rax),%eax
    1c0f:	01 c2                	add    %eax,%edx
    1c11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c15:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1c18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c1c:	48 8b 10             	mov    (%rax),%rdx
    1c1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c23:	48 89 10             	mov    %rdx,(%rax)
    1c26:	eb 0b                	jmp    1c33 <free+0x122>
  } else
    p->s.ptr = bp;
    1c28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c2c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1c30:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1c33:	48 ba a0 21 00 00 00 	movabs $0x21a0,%rdx
    1c3a:	00 00 00 
    1c3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c41:	48 89 02             	mov    %rax,(%rdx)
}
    1c44:	90                   	nop
    1c45:	c9                   	leaveq 
    1c46:	c3                   	retq   

0000000000001c47 <morecore>:

static Header*
morecore(uint nu)
{
    1c47:	f3 0f 1e fa          	endbr64 
    1c4b:	55                   	push   %rbp
    1c4c:	48 89 e5             	mov    %rsp,%rbp
    1c4f:	48 83 ec 20          	sub    $0x20,%rsp
    1c53:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c56:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c5d:	77 07                	ja     1c66 <morecore+0x1f>
    nu = 4096;
    1c5f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c66:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c69:	48 c1 e0 04          	shl    $0x4,%rax
    1c6d:	48 89 c7             	mov    %rax,%rdi
    1c70:	48 b8 da 14 00 00 00 	movabs $0x14da,%rax
    1c77:	00 00 00 
    1c7a:	ff d0                	callq  *%rax
    1c7c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c80:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c85:	75 07                	jne    1c8e <morecore+0x47>
    return 0;
    1c87:	b8 00 00 00 00       	mov    $0x0,%eax
    1c8c:	eb 36                	jmp    1cc4 <morecore+0x7d>
  hp = (Header*)p;
    1c8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c92:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c9a:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1c9d:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1ca0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ca4:	48 83 c0 10          	add    $0x10,%rax
    1ca8:	48 89 c7             	mov    %rax,%rdi
    1cab:	48 b8 11 1b 00 00 00 	movabs $0x1b11,%rax
    1cb2:	00 00 00 
    1cb5:	ff d0                	callq  *%rax
  return freep;
    1cb7:	48 b8 a0 21 00 00 00 	movabs $0x21a0,%rax
    1cbe:	00 00 00 
    1cc1:	48 8b 00             	mov    (%rax),%rax
}
    1cc4:	c9                   	leaveq 
    1cc5:	c3                   	retq   

0000000000001cc6 <malloc>:

void*
malloc(uint nbytes)
{
    1cc6:	f3 0f 1e fa          	endbr64 
    1cca:	55                   	push   %rbp
    1ccb:	48 89 e5             	mov    %rsp,%rbp
    1cce:	48 83 ec 30          	sub    $0x30,%rsp
    1cd2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1cd5:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1cd8:	48 83 c0 0f          	add    $0xf,%rax
    1cdc:	48 c1 e8 04          	shr    $0x4,%rax
    1ce0:	83 c0 01             	add    $0x1,%eax
    1ce3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1ce6:	48 b8 a0 21 00 00 00 	movabs $0x21a0,%rax
    1ced:	00 00 00 
    1cf0:	48 8b 00             	mov    (%rax),%rax
    1cf3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cf7:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1cfc:	75 4a                	jne    1d48 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1cfe:	48 b8 90 21 00 00 00 	movabs $0x2190,%rax
    1d05:	00 00 00 
    1d08:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d0c:	48 ba a0 21 00 00 00 	movabs $0x21a0,%rdx
    1d13:	00 00 00 
    1d16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d1a:	48 89 02             	mov    %rax,(%rdx)
    1d1d:	48 b8 a0 21 00 00 00 	movabs $0x21a0,%rax
    1d24:	00 00 00 
    1d27:	48 8b 00             	mov    (%rax),%rax
    1d2a:	48 ba 90 21 00 00 00 	movabs $0x2190,%rdx
    1d31:	00 00 00 
    1d34:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1d37:	48 b8 90 21 00 00 00 	movabs $0x2190,%rax
    1d3e:	00 00 00 
    1d41:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d4c:	48 8b 00             	mov    (%rax),%rax
    1d4f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d57:	8b 40 08             	mov    0x8(%rax),%eax
    1d5a:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d5d:	77 65                	ja     1dc4 <malloc+0xfe>
      if(p->s.size == nunits)
    1d5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d63:	8b 40 08             	mov    0x8(%rax),%eax
    1d66:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d69:	75 10                	jne    1d7b <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1d6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d6f:	48 8b 10             	mov    (%rax),%rdx
    1d72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d76:	48 89 10             	mov    %rdx,(%rax)
    1d79:	eb 2e                	jmp    1da9 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1d7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d7f:	8b 40 08             	mov    0x8(%rax),%eax
    1d82:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d85:	89 c2                	mov    %eax,%edx
    1d87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d8b:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1d8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d92:	8b 40 08             	mov    0x8(%rax),%eax
    1d95:	89 c0                	mov    %eax,%eax
    1d97:	48 c1 e0 04          	shl    $0x4,%rax
    1d9b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1da3:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1da6:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1da9:	48 ba a0 21 00 00 00 	movabs $0x21a0,%rdx
    1db0:	00 00 00 
    1db3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1db7:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1dba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dbe:	48 83 c0 10          	add    $0x10,%rax
    1dc2:	eb 4e                	jmp    1e12 <malloc+0x14c>
    }
    if(p == freep)
    1dc4:	48 b8 a0 21 00 00 00 	movabs $0x21a0,%rax
    1dcb:	00 00 00 
    1dce:	48 8b 00             	mov    (%rax),%rax
    1dd1:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1dd5:	75 23                	jne    1dfa <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1dd7:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1dda:	89 c7                	mov    %eax,%edi
    1ddc:	48 b8 47 1c 00 00 00 	movabs $0x1c47,%rax
    1de3:	00 00 00 
    1de6:	ff d0                	callq  *%rax
    1de8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1dec:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1df1:	75 07                	jne    1dfa <malloc+0x134>
        return 0;
    1df3:	b8 00 00 00 00       	mov    $0x0,%eax
    1df8:	eb 18                	jmp    1e12 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1dfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dfe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e06:	48 8b 00             	mov    (%rax),%rax
    1e09:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e0d:	e9 41 ff ff ff       	jmpq   1d53 <malloc+0x8d>
  }
}
    1e12:	c9                   	leaveq 
    1e13:	c3                   	retq   
