
_cat:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <cat>:

char buf[512];

void
cat(int fd)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 20          	sub    $0x20,%rsp
    100c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
    100f:	eb 51                	jmp    1062 <cat+0x62>
    if (write(1, buf, n) != n) {
    1011:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1014:	89 c2                	mov    %eax,%edx
    1016:	48 be c0 22 00 00 00 	movabs $0x22c0,%rsi
    101d:	00 00 00 
    1020:	bf 01 00 00 00       	mov    $0x1,%edi
    1025:	48 b8 31 15 00 00 00 	movabs $0x1531,%rax
    102c:	00 00 00 
    102f:	ff d0                	callq  *%rax
    1031:	39 45 fc             	cmp    %eax,-0x4(%rbp)
    1034:	74 2c                	je     1062 <cat+0x62>
      printf(1, "cat: write error\n");
    1036:	48 be 18 1f 00 00 00 	movabs $0x1f18,%rsi
    103d:	00 00 00 
    1040:	bf 01 00 00 00       	mov    $0x1,%edi
    1045:	b8 00 00 00 00       	mov    $0x0,%eax
    104a:	48 ba 01 18 00 00 00 	movabs $0x1801,%rdx
    1051:	00 00 00 
    1054:	ff d2                	callq  *%rdx
      exit();
    1056:	48 b8 fd 14 00 00 00 	movabs $0x14fd,%rax
    105d:	00 00 00 
    1060:	ff d0                	callq  *%rax
  while((n = read(fd, buf, sizeof(buf))) > 0) {
    1062:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1065:	ba 00 02 00 00       	mov    $0x200,%edx
    106a:	48 be c0 22 00 00 00 	movabs $0x22c0,%rsi
    1071:	00 00 00 
    1074:	89 c7                	mov    %eax,%edi
    1076:	48 b8 24 15 00 00 00 	movabs $0x1524,%rax
    107d:	00 00 00 
    1080:	ff d0                	callq  *%rax
    1082:	89 45 fc             	mov    %eax,-0x4(%rbp)
    1085:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1089:	7f 86                	jg     1011 <cat+0x11>
    }
  }
  if(n < 0){
    108b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    108f:	79 2c                	jns    10bd <cat+0xbd>
    printf(1, "cat: read error\n");
    1091:	48 be 2a 1f 00 00 00 	movabs $0x1f2a,%rsi
    1098:	00 00 00 
    109b:	bf 01 00 00 00       	mov    $0x1,%edi
    10a0:	b8 00 00 00 00       	mov    $0x0,%eax
    10a5:	48 ba 01 18 00 00 00 	movabs $0x1801,%rdx
    10ac:	00 00 00 
    10af:	ff d2                	callq  *%rdx
    exit();
    10b1:	48 b8 fd 14 00 00 00 	movabs $0x14fd,%rax
    10b8:	00 00 00 
    10bb:	ff d0                	callq  *%rax
  }
}
    10bd:	90                   	nop
    10be:	c9                   	leaveq 
    10bf:	c3                   	retq   

00000000000010c0 <main>:

int
main(int argc, char *argv[])
{
    10c0:	f3 0f 1e fa          	endbr64 
    10c4:	55                   	push   %rbp
    10c5:	48 89 e5             	mov    %rsp,%rbp
    10c8:	48 83 ec 20          	sub    $0x20,%rsp
    10cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
    10cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd, i;

  if(argc <= 1){
    10d3:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
    10d7:	7f 1d                	jg     10f6 <main+0x36>
    cat(0);
    10d9:	bf 00 00 00 00       	mov    $0x0,%edi
    10de:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    10e5:	00 00 00 
    10e8:	ff d0                	callq  *%rax
    exit();
    10ea:	48 b8 fd 14 00 00 00 	movabs $0x14fd,%rax
    10f1:	00 00 00 
    10f4:	ff d0                	callq  *%rax
  }

  for(i = 1; i < argc; i++){
    10f6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    10fd:	e9 a0 00 00 00       	jmpq   11a2 <main+0xe2>
    if((fd = open(argv[i], 0)) < 0){
    1102:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1105:	48 98                	cltq   
    1107:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    110e:	00 
    110f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1113:	48 01 d0             	add    %rdx,%rax
    1116:	48 8b 00             	mov    (%rax),%rax
    1119:	be 00 00 00 00       	mov    $0x0,%esi
    111e:	48 89 c7             	mov    %rax,%rdi
    1121:	48 b8 65 15 00 00 00 	movabs $0x1565,%rax
    1128:	00 00 00 
    112b:	ff d0                	callq  *%rax
    112d:	89 45 f8             	mov    %eax,-0x8(%rbp)
    1130:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1134:	79 46                	jns    117c <main+0xbc>
      printf(1, "cat: cannot open %s\n", argv[i]);
    1136:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1139:	48 98                	cltq   
    113b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1142:	00 
    1143:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1147:	48 01 d0             	add    %rdx,%rax
    114a:	48 8b 00             	mov    (%rax),%rax
    114d:	48 89 c2             	mov    %rax,%rdx
    1150:	48 be 3b 1f 00 00 00 	movabs $0x1f3b,%rsi
    1157:	00 00 00 
    115a:	bf 01 00 00 00       	mov    $0x1,%edi
    115f:	b8 00 00 00 00       	mov    $0x0,%eax
    1164:	48 b9 01 18 00 00 00 	movabs $0x1801,%rcx
    116b:	00 00 00 
    116e:	ff d1                	callq  *%rcx
      exit();
    1170:	48 b8 fd 14 00 00 00 	movabs $0x14fd,%rax
    1177:	00 00 00 
    117a:	ff d0                	callq  *%rax
    }
    cat(fd);
    117c:	8b 45 f8             	mov    -0x8(%rbp),%eax
    117f:	89 c7                	mov    %eax,%edi
    1181:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1188:	00 00 00 
    118b:	ff d0                	callq  *%rax
    close(fd);
    118d:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1190:	89 c7                	mov    %eax,%edi
    1192:	48 b8 3e 15 00 00 00 	movabs $0x153e,%rax
    1199:	00 00 00 
    119c:	ff d0                	callq  *%rax
  for(i = 1; i < argc; i++){
    119e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    11a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11a5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    11a8:	0f 8c 54 ff ff ff    	jl     1102 <main+0x42>
  }
  exit();
    11ae:	48 b8 fd 14 00 00 00 	movabs $0x14fd,%rax
    11b5:	00 00 00 
    11b8:	ff d0                	callq  *%rax

00000000000011ba <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    11ba:	f3 0f 1e fa          	endbr64 
    11be:	55                   	push   %rbp
    11bf:	48 89 e5             	mov    %rsp,%rbp
    11c2:	48 83 ec 10          	sub    $0x10,%rsp
    11c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11ca:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11cd:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    11d0:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    11d4:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
    11da:	48 89 ce             	mov    %rcx,%rsi
    11dd:	48 89 f7             	mov    %rsi,%rdi
    11e0:	89 d1                	mov    %edx,%ecx
    11e2:	fc                   	cld    
    11e3:	f3 aa                	rep stos %al,%es:(%rdi)
    11e5:	89 ca                	mov    %ecx,%edx
    11e7:	48 89 fe             	mov    %rdi,%rsi
    11ea:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    11ee:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11f1:	90                   	nop
    11f2:	c9                   	leaveq 
    11f3:	c3                   	retq   

00000000000011f4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11f4:	f3 0f 1e fa          	endbr64 
    11f8:	55                   	push   %rbp
    11f9:	48 89 e5             	mov    %rsp,%rbp
    11fc:	48 83 ec 20          	sub    $0x20,%rsp
    1200:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1204:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    1208:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    120c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1210:	90                   	nop
    1211:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1215:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1219:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    121d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1221:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1225:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1229:	0f b6 12             	movzbl (%rdx),%edx
    122c:	88 10                	mov    %dl,(%rax)
    122e:	0f b6 00             	movzbl (%rax),%eax
    1231:	84 c0                	test   %al,%al
    1233:	75 dc                	jne    1211 <strcpy+0x1d>
    ;
  return os;
    1235:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1239:	c9                   	leaveq 
    123a:	c3                   	retq   

000000000000123b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    123b:	f3 0f 1e fa          	endbr64 
    123f:	55                   	push   %rbp
    1240:	48 89 e5             	mov    %rsp,%rbp
    1243:	48 83 ec 10          	sub    $0x10,%rsp
    1247:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    124b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    124f:	eb 0a                	jmp    125b <strcmp+0x20>
    p++, q++;
    1251:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1256:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    125b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    125f:	0f b6 00             	movzbl (%rax),%eax
    1262:	84 c0                	test   %al,%al
    1264:	74 12                	je     1278 <strcmp+0x3d>
    1266:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    126a:	0f b6 10             	movzbl (%rax),%edx
    126d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1271:	0f b6 00             	movzbl (%rax),%eax
    1274:	38 c2                	cmp    %al,%dl
    1276:	74 d9                	je     1251 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1278:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    127c:	0f b6 00             	movzbl (%rax),%eax
    127f:	0f b6 d0             	movzbl %al,%edx
    1282:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1286:	0f b6 00             	movzbl (%rax),%eax
    1289:	0f b6 c0             	movzbl %al,%eax
    128c:	29 c2                	sub    %eax,%edx
    128e:	89 d0                	mov    %edx,%eax
}
    1290:	c9                   	leaveq 
    1291:	c3                   	retq   

0000000000001292 <strlen>:

uint
strlen(char *s)
{
    1292:	f3 0f 1e fa          	endbr64 
    1296:	55                   	push   %rbp
    1297:	48 89 e5             	mov    %rsp,%rbp
    129a:	48 83 ec 18          	sub    $0x18,%rsp
    129e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    12a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    12a9:	eb 04                	jmp    12af <strlen+0x1d>
    12ab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    12af:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12b2:	48 63 d0             	movslq %eax,%rdx
    12b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12b9:	48 01 d0             	add    %rdx,%rax
    12bc:	0f b6 00             	movzbl (%rax),%eax
    12bf:	84 c0                	test   %al,%al
    12c1:	75 e8                	jne    12ab <strlen+0x19>
    ;
  return n;
    12c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    12c6:	c9                   	leaveq 
    12c7:	c3                   	retq   

00000000000012c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    12c8:	f3 0f 1e fa          	endbr64 
    12cc:	55                   	push   %rbp
    12cd:	48 89 e5             	mov    %rsp,%rbp
    12d0:	48 83 ec 10          	sub    $0x10,%rsp
    12d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12d8:	89 75 f4             	mov    %esi,-0xc(%rbp)
    12db:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    12de:	8b 55 f0             	mov    -0x10(%rbp),%edx
    12e1:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    12e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12e8:	89 ce                	mov    %ecx,%esi
    12ea:	48 89 c7             	mov    %rax,%rdi
    12ed:	48 b8 ba 11 00 00 00 	movabs $0x11ba,%rax
    12f4:	00 00 00 
    12f7:	ff d0                	callq  *%rax
  return dst;
    12f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    12fd:	c9                   	leaveq 
    12fe:	c3                   	retq   

00000000000012ff <strchr>:

char*
strchr(const char *s, char c)
{
    12ff:	f3 0f 1e fa          	endbr64 
    1303:	55                   	push   %rbp
    1304:	48 89 e5             	mov    %rsp,%rbp
    1307:	48 83 ec 10          	sub    $0x10,%rsp
    130b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    130f:	89 f0                	mov    %esi,%eax
    1311:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1314:	eb 17                	jmp    132d <strchr+0x2e>
    if(*s == c)
    1316:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    131a:	0f b6 00             	movzbl (%rax),%eax
    131d:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1320:	75 06                	jne    1328 <strchr+0x29>
      return (char*)s;
    1322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1326:	eb 15                	jmp    133d <strchr+0x3e>
  for(; *s; s++)
    1328:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    132d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1331:	0f b6 00             	movzbl (%rax),%eax
    1334:	84 c0                	test   %al,%al
    1336:	75 de                	jne    1316 <strchr+0x17>
  return 0;
    1338:	b8 00 00 00 00       	mov    $0x0,%eax
}
    133d:	c9                   	leaveq 
    133e:	c3                   	retq   

000000000000133f <gets>:

char*
gets(char *buf, int max)
{
    133f:	f3 0f 1e fa          	endbr64 
    1343:	55                   	push   %rbp
    1344:	48 89 e5             	mov    %rsp,%rbp
    1347:	48 83 ec 20          	sub    $0x20,%rsp
    134b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    134f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1352:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1359:	eb 4f                	jmp    13aa <gets+0x6b>
    cc = read(0, &c, 1);
    135b:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    135f:	ba 01 00 00 00       	mov    $0x1,%edx
    1364:	48 89 c6             	mov    %rax,%rsi
    1367:	bf 00 00 00 00       	mov    $0x0,%edi
    136c:	48 b8 24 15 00 00 00 	movabs $0x1524,%rax
    1373:	00 00 00 
    1376:	ff d0                	callq  *%rax
    1378:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    137b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    137f:	7e 36                	jle    13b7 <gets+0x78>
      break;
    buf[i++] = c;
    1381:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1384:	8d 50 01             	lea    0x1(%rax),%edx
    1387:	89 55 fc             	mov    %edx,-0x4(%rbp)
    138a:	48 63 d0             	movslq %eax,%rdx
    138d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1391:	48 01 c2             	add    %rax,%rdx
    1394:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1398:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    139a:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    139e:	3c 0a                	cmp    $0xa,%al
    13a0:	74 16                	je     13b8 <gets+0x79>
    13a2:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    13a6:	3c 0d                	cmp    $0xd,%al
    13a8:	74 0e                	je     13b8 <gets+0x79>
  for(i=0; i+1 < max; ){
    13aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13ad:	83 c0 01             	add    $0x1,%eax
    13b0:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    13b3:	7f a6                	jg     135b <gets+0x1c>
    13b5:	eb 01                	jmp    13b8 <gets+0x79>
      break;
    13b7:	90                   	nop
      break;
  }
  buf[i] = '\0';
    13b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13bb:	48 63 d0             	movslq %eax,%rdx
    13be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13c2:	48 01 d0             	add    %rdx,%rax
    13c5:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    13c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13cc:	c9                   	leaveq 
    13cd:	c3                   	retq   

00000000000013ce <stat>:

int
stat(char *n, struct stat *st)
{
    13ce:	f3 0f 1e fa          	endbr64 
    13d2:	55                   	push   %rbp
    13d3:	48 89 e5             	mov    %rsp,%rbp
    13d6:	48 83 ec 20          	sub    $0x20,%rsp
    13da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13e6:	be 00 00 00 00       	mov    $0x0,%esi
    13eb:	48 89 c7             	mov    %rax,%rdi
    13ee:	48 b8 65 15 00 00 00 	movabs $0x1565,%rax
    13f5:	00 00 00 
    13f8:	ff d0                	callq  *%rax
    13fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    13fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1401:	79 07                	jns    140a <stat+0x3c>
    return -1;
    1403:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1408:	eb 2f                	jmp    1439 <stat+0x6b>
  r = fstat(fd, st);
    140a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    140e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1411:	48 89 d6             	mov    %rdx,%rsi
    1414:	89 c7                	mov    %eax,%edi
    1416:	48 b8 8c 15 00 00 00 	movabs $0x158c,%rax
    141d:	00 00 00 
    1420:	ff d0                	callq  *%rax
    1422:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1425:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1428:	89 c7                	mov    %eax,%edi
    142a:	48 b8 3e 15 00 00 00 	movabs $0x153e,%rax
    1431:	00 00 00 
    1434:	ff d0                	callq  *%rax
  return r;
    1436:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1439:	c9                   	leaveq 
    143a:	c3                   	retq   

000000000000143b <atoi>:

int
atoi(const char *s)
{
    143b:	f3 0f 1e fa          	endbr64 
    143f:	55                   	push   %rbp
    1440:	48 89 e5             	mov    %rsp,%rbp
    1443:	48 83 ec 18          	sub    $0x18,%rsp
    1447:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    144b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1452:	eb 28                	jmp    147c <atoi+0x41>
    n = n*10 + *s++ - '0';
    1454:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1457:	89 d0                	mov    %edx,%eax
    1459:	c1 e0 02             	shl    $0x2,%eax
    145c:	01 d0                	add    %edx,%eax
    145e:	01 c0                	add    %eax,%eax
    1460:	89 c1                	mov    %eax,%ecx
    1462:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1466:	48 8d 50 01          	lea    0x1(%rax),%rdx
    146a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    146e:	0f b6 00             	movzbl (%rax),%eax
    1471:	0f be c0             	movsbl %al,%eax
    1474:	01 c8                	add    %ecx,%eax
    1476:	83 e8 30             	sub    $0x30,%eax
    1479:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    147c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1480:	0f b6 00             	movzbl (%rax),%eax
    1483:	3c 2f                	cmp    $0x2f,%al
    1485:	7e 0b                	jle    1492 <atoi+0x57>
    1487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    148b:	0f b6 00             	movzbl (%rax),%eax
    148e:	3c 39                	cmp    $0x39,%al
    1490:	7e c2                	jle    1454 <atoi+0x19>
  return n;
    1492:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1495:	c9                   	leaveq 
    1496:	c3                   	retq   

0000000000001497 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1497:	f3 0f 1e fa          	endbr64 
    149b:	55                   	push   %rbp
    149c:	48 89 e5             	mov    %rsp,%rbp
    149f:	48 83 ec 28          	sub    $0x28,%rsp
    14a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    14a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    14ab:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    14ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    14b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    14ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    14be:	eb 1d                	jmp    14dd <memmove+0x46>
    *dst++ = *src++;
    14c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    14c4:	48 8d 42 01          	lea    0x1(%rdx),%rax
    14c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    14cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    14d0:	48 8d 48 01          	lea    0x1(%rax),%rcx
    14d4:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    14d8:	0f b6 12             	movzbl (%rdx),%edx
    14db:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    14dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
    14e0:	8d 50 ff             	lea    -0x1(%rax),%edx
    14e3:	89 55 dc             	mov    %edx,-0x24(%rbp)
    14e6:	85 c0                	test   %eax,%eax
    14e8:	7f d6                	jg     14c0 <memmove+0x29>
  return vdst;
    14ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    14ee:	c9                   	leaveq 
    14ef:	c3                   	retq   

00000000000014f0 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    14f0:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    14f7:	49 89 ca             	mov    %rcx,%r10
    14fa:	0f 05                	syscall 
    14fc:	c3                   	retq   

00000000000014fd <exit>:
SYSCALL(exit)
    14fd:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1504:	49 89 ca             	mov    %rcx,%r10
    1507:	0f 05                	syscall 
    1509:	c3                   	retq   

000000000000150a <wait>:
SYSCALL(wait)
    150a:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1511:	49 89 ca             	mov    %rcx,%r10
    1514:	0f 05                	syscall 
    1516:	c3                   	retq   

0000000000001517 <pipe>:
SYSCALL(pipe)
    1517:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    151e:	49 89 ca             	mov    %rcx,%r10
    1521:	0f 05                	syscall 
    1523:	c3                   	retq   

0000000000001524 <read>:
SYSCALL(read)
    1524:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    152b:	49 89 ca             	mov    %rcx,%r10
    152e:	0f 05                	syscall 
    1530:	c3                   	retq   

0000000000001531 <write>:
SYSCALL(write)
    1531:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    1538:	49 89 ca             	mov    %rcx,%r10
    153b:	0f 05                	syscall 
    153d:	c3                   	retq   

000000000000153e <close>:
SYSCALL(close)
    153e:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1545:	49 89 ca             	mov    %rcx,%r10
    1548:	0f 05                	syscall 
    154a:	c3                   	retq   

000000000000154b <kill>:
SYSCALL(kill)
    154b:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1552:	49 89 ca             	mov    %rcx,%r10
    1555:	0f 05                	syscall 
    1557:	c3                   	retq   

0000000000001558 <exec>:
SYSCALL(exec)
    1558:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    155f:	49 89 ca             	mov    %rcx,%r10
    1562:	0f 05                	syscall 
    1564:	c3                   	retq   

0000000000001565 <open>:
SYSCALL(open)
    1565:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    156c:	49 89 ca             	mov    %rcx,%r10
    156f:	0f 05                	syscall 
    1571:	c3                   	retq   

0000000000001572 <mknod>:
SYSCALL(mknod)
    1572:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1579:	49 89 ca             	mov    %rcx,%r10
    157c:	0f 05                	syscall 
    157e:	c3                   	retq   

000000000000157f <unlink>:
SYSCALL(unlink)
    157f:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1586:	49 89 ca             	mov    %rcx,%r10
    1589:	0f 05                	syscall 
    158b:	c3                   	retq   

000000000000158c <fstat>:
SYSCALL(fstat)
    158c:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1593:	49 89 ca             	mov    %rcx,%r10
    1596:	0f 05                	syscall 
    1598:	c3                   	retq   

0000000000001599 <link>:
SYSCALL(link)
    1599:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    15a0:	49 89 ca             	mov    %rcx,%r10
    15a3:	0f 05                	syscall 
    15a5:	c3                   	retq   

00000000000015a6 <mkdir>:
SYSCALL(mkdir)
    15a6:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    15ad:	49 89 ca             	mov    %rcx,%r10
    15b0:	0f 05                	syscall 
    15b2:	c3                   	retq   

00000000000015b3 <chdir>:
SYSCALL(chdir)
    15b3:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    15ba:	49 89 ca             	mov    %rcx,%r10
    15bd:	0f 05                	syscall 
    15bf:	c3                   	retq   

00000000000015c0 <dup>:
SYSCALL(dup)
    15c0:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    15c7:	49 89 ca             	mov    %rcx,%r10
    15ca:	0f 05                	syscall 
    15cc:	c3                   	retq   

00000000000015cd <getpid>:
SYSCALL(getpid)
    15cd:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    15d4:	49 89 ca             	mov    %rcx,%r10
    15d7:	0f 05                	syscall 
    15d9:	c3                   	retq   

00000000000015da <sbrk>:
SYSCALL(sbrk)
    15da:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    15e1:	49 89 ca             	mov    %rcx,%r10
    15e4:	0f 05                	syscall 
    15e6:	c3                   	retq   

00000000000015e7 <sleep>:
SYSCALL(sleep)
    15e7:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    15ee:	49 89 ca             	mov    %rcx,%r10
    15f1:	0f 05                	syscall 
    15f3:	c3                   	retq   

00000000000015f4 <uptime>:
SYSCALL(uptime)
    15f4:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    15fb:	49 89 ca             	mov    %rcx,%r10
    15fe:	0f 05                	syscall 
    1600:	c3                   	retq   

0000000000001601 <dedup>:
SYSCALL(dedup)
    1601:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    1608:	49 89 ca             	mov    %rcx,%r10
    160b:	0f 05                	syscall 
    160d:	c3                   	retq   

000000000000160e <freepages>:
SYSCALL(freepages)
    160e:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    1615:	49 89 ca             	mov    %rcx,%r10
    1618:	0f 05                	syscall 
    161a:	c3                   	retq   

000000000000161b <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    161b:	f3 0f 1e fa          	endbr64 
    161f:	55                   	push   %rbp
    1620:	48 89 e5             	mov    %rsp,%rbp
    1623:	48 83 ec 10          	sub    $0x10,%rsp
    1627:	89 7d fc             	mov    %edi,-0x4(%rbp)
    162a:	89 f0                	mov    %esi,%eax
    162c:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    162f:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1633:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1636:	ba 01 00 00 00       	mov    $0x1,%edx
    163b:	48 89 ce             	mov    %rcx,%rsi
    163e:	89 c7                	mov    %eax,%edi
    1640:	48 b8 31 15 00 00 00 	movabs $0x1531,%rax
    1647:	00 00 00 
    164a:	ff d0                	callq  *%rax
}
    164c:	90                   	nop
    164d:	c9                   	leaveq 
    164e:	c3                   	retq   

000000000000164f <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    164f:	f3 0f 1e fa          	endbr64 
    1653:	55                   	push   %rbp
    1654:	48 89 e5             	mov    %rsp,%rbp
    1657:	48 83 ec 20          	sub    $0x20,%rsp
    165b:	89 7d ec             	mov    %edi,-0x14(%rbp)
    165e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1662:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1669:	eb 35                	jmp    16a0 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    166b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    166f:	48 c1 e8 3c          	shr    $0x3c,%rax
    1673:	48 ba a0 22 00 00 00 	movabs $0x22a0,%rdx
    167a:	00 00 00 
    167d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1681:	0f be d0             	movsbl %al,%edx
    1684:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1687:	89 d6                	mov    %edx,%esi
    1689:	89 c7                	mov    %eax,%edi
    168b:	48 b8 1b 16 00 00 00 	movabs $0x161b,%rax
    1692:	00 00 00 
    1695:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1697:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    169b:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    16a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16a3:	83 f8 0f             	cmp    $0xf,%eax
    16a6:	76 c3                	jbe    166b <print_x64+0x1c>
}
    16a8:	90                   	nop
    16a9:	90                   	nop
    16aa:	c9                   	leaveq 
    16ab:	c3                   	retq   

00000000000016ac <print_x32>:

  static void
print_x32(int fd, uint x)
{
    16ac:	f3 0f 1e fa          	endbr64 
    16b0:	55                   	push   %rbp
    16b1:	48 89 e5             	mov    %rsp,%rbp
    16b4:	48 83 ec 20          	sub    $0x20,%rsp
    16b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
    16bb:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    16c5:	eb 36                	jmp    16fd <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    16c7:	8b 45 e8             	mov    -0x18(%rbp),%eax
    16ca:	c1 e8 1c             	shr    $0x1c,%eax
    16cd:	89 c2                	mov    %eax,%edx
    16cf:	48 b8 a0 22 00 00 00 	movabs $0x22a0,%rax
    16d6:	00 00 00 
    16d9:	89 d2                	mov    %edx,%edx
    16db:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    16df:	0f be d0             	movsbl %al,%edx
    16e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
    16e5:	89 d6                	mov    %edx,%esi
    16e7:	89 c7                	mov    %eax,%edi
    16e9:	48 b8 1b 16 00 00 00 	movabs $0x161b,%rax
    16f0:	00 00 00 
    16f3:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16f5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    16f9:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    16fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1700:	83 f8 07             	cmp    $0x7,%eax
    1703:	76 c2                	jbe    16c7 <print_x32+0x1b>
}
    1705:	90                   	nop
    1706:	90                   	nop
    1707:	c9                   	leaveq 
    1708:	c3                   	retq   

0000000000001709 <print_d>:

  static void
print_d(int fd, int v)
{
    1709:	f3 0f 1e fa          	endbr64 
    170d:	55                   	push   %rbp
    170e:	48 89 e5             	mov    %rsp,%rbp
    1711:	48 83 ec 30          	sub    $0x30,%rsp
    1715:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1718:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    171b:	8b 45 d8             	mov    -0x28(%rbp),%eax
    171e:	48 98                	cltq   
    1720:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1724:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1728:	79 04                	jns    172e <print_d+0x25>
    x = -x;
    172a:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    172e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1735:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1739:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1740:	66 66 66 
    1743:	48 89 c8             	mov    %rcx,%rax
    1746:	48 f7 ea             	imul   %rdx
    1749:	48 c1 fa 02          	sar    $0x2,%rdx
    174d:	48 89 c8             	mov    %rcx,%rax
    1750:	48 c1 f8 3f          	sar    $0x3f,%rax
    1754:	48 29 c2             	sub    %rax,%rdx
    1757:	48 89 d0             	mov    %rdx,%rax
    175a:	48 c1 e0 02          	shl    $0x2,%rax
    175e:	48 01 d0             	add    %rdx,%rax
    1761:	48 01 c0             	add    %rax,%rax
    1764:	48 29 c1             	sub    %rax,%rcx
    1767:	48 89 ca             	mov    %rcx,%rdx
    176a:	8b 45 f4             	mov    -0xc(%rbp),%eax
    176d:	8d 48 01             	lea    0x1(%rax),%ecx
    1770:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1773:	48 b9 a0 22 00 00 00 	movabs $0x22a0,%rcx
    177a:	00 00 00 
    177d:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1781:	48 98                	cltq   
    1783:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1787:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    178b:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1792:	66 66 66 
    1795:	48 89 c8             	mov    %rcx,%rax
    1798:	48 f7 ea             	imul   %rdx
    179b:	48 c1 fa 02          	sar    $0x2,%rdx
    179f:	48 89 c8             	mov    %rcx,%rax
    17a2:	48 c1 f8 3f          	sar    $0x3f,%rax
    17a6:	48 29 c2             	sub    %rax,%rdx
    17a9:	48 89 d0             	mov    %rdx,%rax
    17ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    17b0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    17b5:	0f 85 7a ff ff ff    	jne    1735 <print_d+0x2c>

  if (v < 0)
    17bb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    17bf:	79 32                	jns    17f3 <print_d+0xea>
    buf[i++] = '-';
    17c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17c4:	8d 50 01             	lea    0x1(%rax),%edx
    17c7:	89 55 f4             	mov    %edx,-0xc(%rbp)
    17ca:	48 98                	cltq   
    17cc:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    17d1:	eb 20                	jmp    17f3 <print_d+0xea>
    putc(fd, buf[i]);
    17d3:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17d6:	48 98                	cltq   
    17d8:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    17dd:	0f be d0             	movsbl %al,%edx
    17e0:	8b 45 dc             	mov    -0x24(%rbp),%eax
    17e3:	89 d6                	mov    %edx,%esi
    17e5:	89 c7                	mov    %eax,%edi
    17e7:	48 b8 1b 16 00 00 00 	movabs $0x161b,%rax
    17ee:	00 00 00 
    17f1:	ff d0                	callq  *%rax
  while (--i >= 0)
    17f3:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    17f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    17fb:	79 d6                	jns    17d3 <print_d+0xca>
}
    17fd:	90                   	nop
    17fe:	90                   	nop
    17ff:	c9                   	leaveq 
    1800:	c3                   	retq   

0000000000001801 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1801:	f3 0f 1e fa          	endbr64 
    1805:	55                   	push   %rbp
    1806:	48 89 e5             	mov    %rsp,%rbp
    1809:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1810:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1816:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    181d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1824:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    182b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1832:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1839:	84 c0                	test   %al,%al
    183b:	74 20                	je     185d <printf+0x5c>
    183d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1841:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1845:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1849:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    184d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1851:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1855:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1859:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    185d:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1864:	00 00 00 
    1867:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    186e:	00 00 00 
    1871:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1875:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    187c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1883:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    188a:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1891:	00 00 00 
    1894:	e9 41 03 00 00       	jmpq   1bda <printf+0x3d9>
    if (c != '%') {
    1899:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18a0:	74 24                	je     18c6 <printf+0xc5>
      putc(fd, c);
    18a2:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    18a8:	0f be d0             	movsbl %al,%edx
    18ab:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18b1:	89 d6                	mov    %edx,%esi
    18b3:	89 c7                	mov    %eax,%edi
    18b5:	48 b8 1b 16 00 00 00 	movabs $0x161b,%rax
    18bc:	00 00 00 
    18bf:	ff d0                	callq  *%rax
      continue;
    18c1:	e9 0d 03 00 00       	jmpq   1bd3 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    18c6:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    18cd:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    18d3:	48 63 d0             	movslq %eax,%rdx
    18d6:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    18dd:	48 01 d0             	add    %rdx,%rax
    18e0:	0f b6 00             	movzbl (%rax),%eax
    18e3:	0f be c0             	movsbl %al,%eax
    18e6:	25 ff 00 00 00       	and    $0xff,%eax
    18eb:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    18f1:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    18f8:	0f 84 0f 03 00 00    	je     1c0d <printf+0x40c>
      break;
    switch(c) {
    18fe:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1905:	0f 84 74 02 00 00    	je     1b7f <printf+0x37e>
    190b:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1912:	0f 8c 82 02 00 00    	jl     1b9a <printf+0x399>
    1918:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    191f:	0f 8f 75 02 00 00    	jg     1b9a <printf+0x399>
    1925:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    192c:	0f 8c 68 02 00 00    	jl     1b9a <printf+0x399>
    1932:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1938:	83 e8 63             	sub    $0x63,%eax
    193b:	83 f8 15             	cmp    $0x15,%eax
    193e:	0f 87 56 02 00 00    	ja     1b9a <printf+0x399>
    1944:	89 c0                	mov    %eax,%eax
    1946:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    194d:	00 
    194e:	48 b8 58 1f 00 00 00 	movabs $0x1f58,%rax
    1955:	00 00 00 
    1958:	48 01 d0             	add    %rdx,%rax
    195b:	48 8b 00             	mov    (%rax),%rax
    195e:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1961:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1967:	83 f8 2f             	cmp    $0x2f,%eax
    196a:	77 23                	ja     198f <printf+0x18e>
    196c:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1973:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1979:	89 d2                	mov    %edx,%edx
    197b:	48 01 d0             	add    %rdx,%rax
    197e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1984:	83 c2 08             	add    $0x8,%edx
    1987:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    198d:	eb 12                	jmp    19a1 <printf+0x1a0>
    198f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1996:	48 8d 50 08          	lea    0x8(%rax),%rdx
    199a:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19a1:	8b 00                	mov    (%rax),%eax
    19a3:	0f be d0             	movsbl %al,%edx
    19a6:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19ac:	89 d6                	mov    %edx,%esi
    19ae:	89 c7                	mov    %eax,%edi
    19b0:	48 b8 1b 16 00 00 00 	movabs $0x161b,%rax
    19b7:	00 00 00 
    19ba:	ff d0                	callq  *%rax
      break;
    19bc:	e9 12 02 00 00       	jmpq   1bd3 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    19c1:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19c7:	83 f8 2f             	cmp    $0x2f,%eax
    19ca:	77 23                	ja     19ef <printf+0x1ee>
    19cc:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19d3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19d9:	89 d2                	mov    %edx,%edx
    19db:	48 01 d0             	add    %rdx,%rax
    19de:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19e4:	83 c2 08             	add    $0x8,%edx
    19e7:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19ed:	eb 12                	jmp    1a01 <printf+0x200>
    19ef:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19f6:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19fa:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a01:	8b 10                	mov    (%rax),%edx
    1a03:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a09:	89 d6                	mov    %edx,%esi
    1a0b:	89 c7                	mov    %eax,%edi
    1a0d:	48 b8 09 17 00 00 00 	movabs $0x1709,%rax
    1a14:	00 00 00 
    1a17:	ff d0                	callq  *%rax
      break;
    1a19:	e9 b5 01 00 00       	jmpq   1bd3 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1a1e:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a24:	83 f8 2f             	cmp    $0x2f,%eax
    1a27:	77 23                	ja     1a4c <printf+0x24b>
    1a29:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a30:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a36:	89 d2                	mov    %edx,%edx
    1a38:	48 01 d0             	add    %rdx,%rax
    1a3b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a41:	83 c2 08             	add    $0x8,%edx
    1a44:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a4a:	eb 12                	jmp    1a5e <printf+0x25d>
    1a4c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a53:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a57:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a5e:	8b 10                	mov    (%rax),%edx
    1a60:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a66:	89 d6                	mov    %edx,%esi
    1a68:	89 c7                	mov    %eax,%edi
    1a6a:	48 b8 ac 16 00 00 00 	movabs $0x16ac,%rax
    1a71:	00 00 00 
    1a74:	ff d0                	callq  *%rax
      break;
    1a76:	e9 58 01 00 00       	jmpq   1bd3 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1a7b:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a81:	83 f8 2f             	cmp    $0x2f,%eax
    1a84:	77 23                	ja     1aa9 <printf+0x2a8>
    1a86:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a8d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a93:	89 d2                	mov    %edx,%edx
    1a95:	48 01 d0             	add    %rdx,%rax
    1a98:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a9e:	83 c2 08             	add    $0x8,%edx
    1aa1:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1aa7:	eb 12                	jmp    1abb <printf+0x2ba>
    1aa9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1ab0:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1ab4:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1abb:	48 8b 10             	mov    (%rax),%rdx
    1abe:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ac4:	48 89 d6             	mov    %rdx,%rsi
    1ac7:	89 c7                	mov    %eax,%edi
    1ac9:	48 b8 4f 16 00 00 00 	movabs $0x164f,%rax
    1ad0:	00 00 00 
    1ad3:	ff d0                	callq  *%rax
      break;
    1ad5:	e9 f9 00 00 00       	jmpq   1bd3 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1ada:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1ae0:	83 f8 2f             	cmp    $0x2f,%eax
    1ae3:	77 23                	ja     1b08 <printf+0x307>
    1ae5:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1aec:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1af2:	89 d2                	mov    %edx,%edx
    1af4:	48 01 d0             	add    %rdx,%rax
    1af7:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1afd:	83 c2 08             	add    $0x8,%edx
    1b00:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1b06:	eb 12                	jmp    1b1a <printf+0x319>
    1b08:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b0f:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b13:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b1a:	48 8b 00             	mov    (%rax),%rax
    1b1d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1b24:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1b2b:	00 
    1b2c:	75 41                	jne    1b6f <printf+0x36e>
        s = "(null)";
    1b2e:	48 b8 50 1f 00 00 00 	movabs $0x1f50,%rax
    1b35:	00 00 00 
    1b38:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1b3f:	eb 2e                	jmp    1b6f <printf+0x36e>
        putc(fd, *(s++));
    1b41:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b48:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1b4c:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1b53:	0f b6 00             	movzbl (%rax),%eax
    1b56:	0f be d0             	movsbl %al,%edx
    1b59:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b5f:	89 d6                	mov    %edx,%esi
    1b61:	89 c7                	mov    %eax,%edi
    1b63:	48 b8 1b 16 00 00 00 	movabs $0x161b,%rax
    1b6a:	00 00 00 
    1b6d:	ff d0                	callq  *%rax
      while (*s)
    1b6f:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b76:	0f b6 00             	movzbl (%rax),%eax
    1b79:	84 c0                	test   %al,%al
    1b7b:	75 c4                	jne    1b41 <printf+0x340>
      break;
    1b7d:	eb 54                	jmp    1bd3 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1b7f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b85:	be 25 00 00 00       	mov    $0x25,%esi
    1b8a:	89 c7                	mov    %eax,%edi
    1b8c:	48 b8 1b 16 00 00 00 	movabs $0x161b,%rax
    1b93:	00 00 00 
    1b96:	ff d0                	callq  *%rax
      break;
    1b98:	eb 39                	jmp    1bd3 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1b9a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ba0:	be 25 00 00 00       	mov    $0x25,%esi
    1ba5:	89 c7                	mov    %eax,%edi
    1ba7:	48 b8 1b 16 00 00 00 	movabs $0x161b,%rax
    1bae:	00 00 00 
    1bb1:	ff d0                	callq  *%rax
      putc(fd, c);
    1bb3:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1bb9:	0f be d0             	movsbl %al,%edx
    1bbc:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1bc2:	89 d6                	mov    %edx,%esi
    1bc4:	89 c7                	mov    %eax,%edi
    1bc6:	48 b8 1b 16 00 00 00 	movabs $0x161b,%rax
    1bcd:	00 00 00 
    1bd0:	ff d0                	callq  *%rax
      break;
    1bd2:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1bd3:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1bda:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1be0:	48 63 d0             	movslq %eax,%rdx
    1be3:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1bea:	48 01 d0             	add    %rdx,%rax
    1bed:	0f b6 00             	movzbl (%rax),%eax
    1bf0:	0f be c0             	movsbl %al,%eax
    1bf3:	25 ff 00 00 00       	and    $0xff,%eax
    1bf8:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1bfe:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1c05:	0f 85 8e fc ff ff    	jne    1899 <printf+0x98>
    }
  }
}
    1c0b:	eb 01                	jmp    1c0e <printf+0x40d>
      break;
    1c0d:	90                   	nop
}
    1c0e:	90                   	nop
    1c0f:	c9                   	leaveq 
    1c10:	c3                   	retq   

0000000000001c11 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1c11:	f3 0f 1e fa          	endbr64 
    1c15:	55                   	push   %rbp
    1c16:	48 89 e5             	mov    %rsp,%rbp
    1c19:	48 83 ec 18          	sub    $0x18,%rsp
    1c1d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1c21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1c25:	48 83 e8 10          	sub    $0x10,%rax
    1c29:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c2d:	48 b8 d0 24 00 00 00 	movabs $0x24d0,%rax
    1c34:	00 00 00 
    1c37:	48 8b 00             	mov    (%rax),%rax
    1c3a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c3e:	eb 2f                	jmp    1c6f <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1c40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c44:	48 8b 00             	mov    (%rax),%rax
    1c47:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c4b:	72 17                	jb     1c64 <free+0x53>
    1c4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c51:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c55:	77 2f                	ja     1c86 <free+0x75>
    1c57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c5b:	48 8b 00             	mov    (%rax),%rax
    1c5e:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c62:	72 22                	jb     1c86 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c68:	48 8b 00             	mov    (%rax),%rax
    1c6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c73:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c77:	76 c7                	jbe    1c40 <free+0x2f>
    1c79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c7d:	48 8b 00             	mov    (%rax),%rax
    1c80:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c84:	73 ba                	jae    1c40 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1c86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c8a:	8b 40 08             	mov    0x8(%rax),%eax
    1c8d:	89 c0                	mov    %eax,%eax
    1c8f:	48 c1 e0 04          	shl    $0x4,%rax
    1c93:	48 89 c2             	mov    %rax,%rdx
    1c96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c9a:	48 01 c2             	add    %rax,%rdx
    1c9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ca1:	48 8b 00             	mov    (%rax),%rax
    1ca4:	48 39 c2             	cmp    %rax,%rdx
    1ca7:	75 2d                	jne    1cd6 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1ca9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cad:	8b 50 08             	mov    0x8(%rax),%edx
    1cb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cb4:	48 8b 00             	mov    (%rax),%rax
    1cb7:	8b 40 08             	mov    0x8(%rax),%eax
    1cba:	01 c2                	add    %eax,%edx
    1cbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cc0:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1cc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cc7:	48 8b 00             	mov    (%rax),%rax
    1cca:	48 8b 10             	mov    (%rax),%rdx
    1ccd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cd1:	48 89 10             	mov    %rdx,(%rax)
    1cd4:	eb 0e                	jmp    1ce4 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1cd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cda:	48 8b 10             	mov    (%rax),%rdx
    1cdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ce1:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1ce4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ce8:	8b 40 08             	mov    0x8(%rax),%eax
    1ceb:	89 c0                	mov    %eax,%eax
    1ced:	48 c1 e0 04          	shl    $0x4,%rax
    1cf1:	48 89 c2             	mov    %rax,%rdx
    1cf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cf8:	48 01 d0             	add    %rdx,%rax
    1cfb:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1cff:	75 27                	jne    1d28 <free+0x117>
    p->s.size += bp->s.size;
    1d01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d05:	8b 50 08             	mov    0x8(%rax),%edx
    1d08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d0c:	8b 40 08             	mov    0x8(%rax),%eax
    1d0f:	01 c2                	add    %eax,%edx
    1d11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d15:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1d18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d1c:	48 8b 10             	mov    (%rax),%rdx
    1d1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d23:	48 89 10             	mov    %rdx,(%rax)
    1d26:	eb 0b                	jmp    1d33 <free+0x122>
  } else
    p->s.ptr = bp;
    1d28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d2c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1d30:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1d33:	48 ba d0 24 00 00 00 	movabs $0x24d0,%rdx
    1d3a:	00 00 00 
    1d3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d41:	48 89 02             	mov    %rax,(%rdx)
}
    1d44:	90                   	nop
    1d45:	c9                   	leaveq 
    1d46:	c3                   	retq   

0000000000001d47 <morecore>:

static Header*
morecore(uint nu)
{
    1d47:	f3 0f 1e fa          	endbr64 
    1d4b:	55                   	push   %rbp
    1d4c:	48 89 e5             	mov    %rsp,%rbp
    1d4f:	48 83 ec 20          	sub    $0x20,%rsp
    1d53:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1d56:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1d5d:	77 07                	ja     1d66 <morecore+0x1f>
    nu = 4096;
    1d5f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1d66:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d69:	48 c1 e0 04          	shl    $0x4,%rax
    1d6d:	48 89 c7             	mov    %rax,%rdi
    1d70:	48 b8 da 15 00 00 00 	movabs $0x15da,%rax
    1d77:	00 00 00 
    1d7a:	ff d0                	callq  *%rax
    1d7c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1d80:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1d85:	75 07                	jne    1d8e <morecore+0x47>
    return 0;
    1d87:	b8 00 00 00 00       	mov    $0x0,%eax
    1d8c:	eb 36                	jmp    1dc4 <morecore+0x7d>
  hp = (Header*)p;
    1d8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d92:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1d96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d9a:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d9d:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1da0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1da4:	48 83 c0 10          	add    $0x10,%rax
    1da8:	48 89 c7             	mov    %rax,%rdi
    1dab:	48 b8 11 1c 00 00 00 	movabs $0x1c11,%rax
    1db2:	00 00 00 
    1db5:	ff d0                	callq  *%rax
  return freep;
    1db7:	48 b8 d0 24 00 00 00 	movabs $0x24d0,%rax
    1dbe:	00 00 00 
    1dc1:	48 8b 00             	mov    (%rax),%rax
}
    1dc4:	c9                   	leaveq 
    1dc5:	c3                   	retq   

0000000000001dc6 <malloc>:

void*
malloc(uint nbytes)
{
    1dc6:	f3 0f 1e fa          	endbr64 
    1dca:	55                   	push   %rbp
    1dcb:	48 89 e5             	mov    %rsp,%rbp
    1dce:	48 83 ec 30          	sub    $0x30,%rsp
    1dd2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1dd5:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1dd8:	48 83 c0 0f          	add    $0xf,%rax
    1ddc:	48 c1 e8 04          	shr    $0x4,%rax
    1de0:	83 c0 01             	add    $0x1,%eax
    1de3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1de6:	48 b8 d0 24 00 00 00 	movabs $0x24d0,%rax
    1ded:	00 00 00 
    1df0:	48 8b 00             	mov    (%rax),%rax
    1df3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1df7:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1dfc:	75 4a                	jne    1e48 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1dfe:	48 b8 c0 24 00 00 00 	movabs $0x24c0,%rax
    1e05:	00 00 00 
    1e08:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e0c:	48 ba d0 24 00 00 00 	movabs $0x24d0,%rdx
    1e13:	00 00 00 
    1e16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e1a:	48 89 02             	mov    %rax,(%rdx)
    1e1d:	48 b8 d0 24 00 00 00 	movabs $0x24d0,%rax
    1e24:	00 00 00 
    1e27:	48 8b 00             	mov    (%rax),%rax
    1e2a:	48 ba c0 24 00 00 00 	movabs $0x24c0,%rdx
    1e31:	00 00 00 
    1e34:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1e37:	48 b8 c0 24 00 00 00 	movabs $0x24c0,%rax
    1e3e:	00 00 00 
    1e41:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e4c:	48 8b 00             	mov    (%rax),%rax
    1e4f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e57:	8b 40 08             	mov    0x8(%rax),%eax
    1e5a:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e5d:	77 65                	ja     1ec4 <malloc+0xfe>
      if(p->s.size == nunits)
    1e5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e63:	8b 40 08             	mov    0x8(%rax),%eax
    1e66:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e69:	75 10                	jne    1e7b <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1e6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e6f:	48 8b 10             	mov    (%rax),%rdx
    1e72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e76:	48 89 10             	mov    %rdx,(%rax)
    1e79:	eb 2e                	jmp    1ea9 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1e7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e7f:	8b 40 08             	mov    0x8(%rax),%eax
    1e82:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1e85:	89 c2                	mov    %eax,%edx
    1e87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e8b:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1e8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e92:	8b 40 08             	mov    0x8(%rax),%eax
    1e95:	89 c0                	mov    %eax,%eax
    1e97:	48 c1 e0 04          	shl    $0x4,%rax
    1e9b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1e9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ea3:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1ea6:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1ea9:	48 ba d0 24 00 00 00 	movabs $0x24d0,%rdx
    1eb0:	00 00 00 
    1eb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1eb7:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1eba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ebe:	48 83 c0 10          	add    $0x10,%rax
    1ec2:	eb 4e                	jmp    1f12 <malloc+0x14c>
    }
    if(p == freep)
    1ec4:	48 b8 d0 24 00 00 00 	movabs $0x24d0,%rax
    1ecb:	00 00 00 
    1ece:	48 8b 00             	mov    (%rax),%rax
    1ed1:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1ed5:	75 23                	jne    1efa <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1ed7:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1eda:	89 c7                	mov    %eax,%edi
    1edc:	48 b8 47 1d 00 00 00 	movabs $0x1d47,%rax
    1ee3:	00 00 00 
    1ee6:	ff d0                	callq  *%rax
    1ee8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1eec:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1ef1:	75 07                	jne    1efa <malloc+0x134>
        return 0;
    1ef3:	b8 00 00 00 00       	mov    $0x0,%eax
    1ef8:	eb 18                	jmp    1f12 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1efa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1efe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1f02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f06:	48 8b 00             	mov    (%rax),%rax
    1f09:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1f0d:	e9 41 ff ff ff       	jmpq   1e53 <malloc+0x8d>
  }
}
    1f12:	c9                   	leaveq 
    1f13:	c3                   	retq   
