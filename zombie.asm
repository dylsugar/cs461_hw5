
_zombie:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
  if(fork() > 0)
    1008:	48 b8 6b 13 00 00 00 	movabs $0x136b,%rax
    100f:	00 00 00 
    1012:	ff d0                	callq  *%rax
    1014:	85 c0                	test   %eax,%eax
    1016:	7e 11                	jle    1029 <main+0x29>
    sleep(5);  // Let child exit before parent.
    1018:	bf 05 00 00 00       	mov    $0x5,%edi
    101d:	48 b8 62 14 00 00 00 	movabs $0x1462,%rax
    1024:	00 00 00 
    1027:	ff d0                	callq  *%rax
  exit();
    1029:	48 b8 78 13 00 00 00 	movabs $0x1378,%rax
    1030:	00 00 00 
    1033:	ff d0                	callq  *%rax

0000000000001035 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1035:	f3 0f 1e fa          	endbr64 
    1039:	55                   	push   %rbp
    103a:	48 89 e5             	mov    %rsp,%rbp
    103d:	48 83 ec 10          	sub    $0x10,%rsp
    1041:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1045:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1048:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    104b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    104f:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1052:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1055:	48 89 ce             	mov    %rcx,%rsi
    1058:	48 89 f7             	mov    %rsi,%rdi
    105b:	89 d1                	mov    %edx,%ecx
    105d:	fc                   	cld    
    105e:	f3 aa                	rep stos %al,%es:(%rdi)
    1060:	89 ca                	mov    %ecx,%edx
    1062:	48 89 fe             	mov    %rdi,%rsi
    1065:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    1069:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    106c:	90                   	nop
    106d:	c9                   	leaveq 
    106e:	c3                   	retq   

000000000000106f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    106f:	f3 0f 1e fa          	endbr64 
    1073:	55                   	push   %rbp
    1074:	48 89 e5             	mov    %rsp,%rbp
    1077:	48 83 ec 20          	sub    $0x20,%rsp
    107b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    107f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    1083:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1087:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    108b:	90                   	nop
    108c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1090:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1094:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    1098:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    109c:	48 8d 48 01          	lea    0x1(%rax),%rcx
    10a0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    10a4:	0f b6 12             	movzbl (%rdx),%edx
    10a7:	88 10                	mov    %dl,(%rax)
    10a9:	0f b6 00             	movzbl (%rax),%eax
    10ac:	84 c0                	test   %al,%al
    10ae:	75 dc                	jne    108c <strcpy+0x1d>
    ;
  return os;
    10b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    10b4:	c9                   	leaveq 
    10b5:	c3                   	retq   

00000000000010b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10b6:	f3 0f 1e fa          	endbr64 
    10ba:	55                   	push   %rbp
    10bb:	48 89 e5             	mov    %rsp,%rbp
    10be:	48 83 ec 10          	sub    $0x10,%rsp
    10c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10c6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    10ca:	eb 0a                	jmp    10d6 <strcmp+0x20>
    p++, q++;
    10cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    10d1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    10d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    10da:	0f b6 00             	movzbl (%rax),%eax
    10dd:	84 c0                	test   %al,%al
    10df:	74 12                	je     10f3 <strcmp+0x3d>
    10e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    10e5:	0f b6 10             	movzbl (%rax),%edx
    10e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    10ec:	0f b6 00             	movzbl (%rax),%eax
    10ef:	38 c2                	cmp    %al,%dl
    10f1:	74 d9                	je     10cc <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    10f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    10f7:	0f b6 00             	movzbl (%rax),%eax
    10fa:	0f b6 d0             	movzbl %al,%edx
    10fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1101:	0f b6 00             	movzbl (%rax),%eax
    1104:	0f b6 c0             	movzbl %al,%eax
    1107:	29 c2                	sub    %eax,%edx
    1109:	89 d0                	mov    %edx,%eax
}
    110b:	c9                   	leaveq 
    110c:	c3                   	retq   

000000000000110d <strlen>:

uint
strlen(char *s)
{
    110d:	f3 0f 1e fa          	endbr64 
    1111:	55                   	push   %rbp
    1112:	48 89 e5             	mov    %rsp,%rbp
    1115:	48 83 ec 18          	sub    $0x18,%rsp
    1119:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    111d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1124:	eb 04                	jmp    112a <strlen+0x1d>
    1126:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    112a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    112d:	48 63 d0             	movslq %eax,%rdx
    1130:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1134:	48 01 d0             	add    %rdx,%rax
    1137:	0f b6 00             	movzbl (%rax),%eax
    113a:	84 c0                	test   %al,%al
    113c:	75 e8                	jne    1126 <strlen+0x19>
    ;
  return n;
    113e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1141:	c9                   	leaveq 
    1142:	c3                   	retq   

0000000000001143 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1143:	f3 0f 1e fa          	endbr64 
    1147:	55                   	push   %rbp
    1148:	48 89 e5             	mov    %rsp,%rbp
    114b:	48 83 ec 10          	sub    $0x10,%rsp
    114f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1153:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1156:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    1159:	8b 55 f0             	mov    -0x10(%rbp),%edx
    115c:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    115f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1163:	89 ce                	mov    %ecx,%esi
    1165:	48 89 c7             	mov    %rax,%rdi
    1168:	48 b8 35 10 00 00 00 	movabs $0x1035,%rax
    116f:	00 00 00 
    1172:	ff d0                	callq  *%rax
  return dst;
    1174:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1178:	c9                   	leaveq 
    1179:	c3                   	retq   

000000000000117a <strchr>:

char*
strchr(const char *s, char c)
{
    117a:	f3 0f 1e fa          	endbr64 
    117e:	55                   	push   %rbp
    117f:	48 89 e5             	mov    %rsp,%rbp
    1182:	48 83 ec 10          	sub    $0x10,%rsp
    1186:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    118a:	89 f0                	mov    %esi,%eax
    118c:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    118f:	eb 17                	jmp    11a8 <strchr+0x2e>
    if(*s == c)
    1191:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1195:	0f b6 00             	movzbl (%rax),%eax
    1198:	38 45 f4             	cmp    %al,-0xc(%rbp)
    119b:	75 06                	jne    11a3 <strchr+0x29>
      return (char*)s;
    119d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11a1:	eb 15                	jmp    11b8 <strchr+0x3e>
  for(; *s; s++)
    11a3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    11a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11ac:	0f b6 00             	movzbl (%rax),%eax
    11af:	84 c0                	test   %al,%al
    11b1:	75 de                	jne    1191 <strchr+0x17>
  return 0;
    11b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
    11b8:	c9                   	leaveq 
    11b9:	c3                   	retq   

00000000000011ba <gets>:

char*
gets(char *buf, int max)
{
    11ba:	f3 0f 1e fa          	endbr64 
    11be:	55                   	push   %rbp
    11bf:	48 89 e5             	mov    %rsp,%rbp
    11c2:	48 83 ec 20          	sub    $0x20,%rsp
    11c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    11ca:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    11d4:	eb 4f                	jmp    1225 <gets+0x6b>
    cc = read(0, &c, 1);
    11d6:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    11da:	ba 01 00 00 00       	mov    $0x1,%edx
    11df:	48 89 c6             	mov    %rax,%rsi
    11e2:	bf 00 00 00 00       	mov    $0x0,%edi
    11e7:	48 b8 9f 13 00 00 00 	movabs $0x139f,%rax
    11ee:	00 00 00 
    11f1:	ff d0                	callq  *%rax
    11f3:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    11f6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    11fa:	7e 36                	jle    1232 <gets+0x78>
      break;
    buf[i++] = c;
    11fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11ff:	8d 50 01             	lea    0x1(%rax),%edx
    1202:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1205:	48 63 d0             	movslq %eax,%rdx
    1208:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    120c:	48 01 c2             	add    %rax,%rdx
    120f:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1213:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1215:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1219:	3c 0a                	cmp    $0xa,%al
    121b:	74 16                	je     1233 <gets+0x79>
    121d:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1221:	3c 0d                	cmp    $0xd,%al
    1223:	74 0e                	je     1233 <gets+0x79>
  for(i=0; i+1 < max; ){
    1225:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1228:	83 c0 01             	add    $0x1,%eax
    122b:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    122e:	7f a6                	jg     11d6 <gets+0x1c>
    1230:	eb 01                	jmp    1233 <gets+0x79>
      break;
    1232:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1233:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1236:	48 63 d0             	movslq %eax,%rdx
    1239:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    123d:	48 01 d0             	add    %rdx,%rax
    1240:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1243:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1247:	c9                   	leaveq 
    1248:	c3                   	retq   

0000000000001249 <stat>:

int
stat(char *n, struct stat *st)
{
    1249:	f3 0f 1e fa          	endbr64 
    124d:	55                   	push   %rbp
    124e:	48 89 e5             	mov    %rsp,%rbp
    1251:	48 83 ec 20          	sub    $0x20,%rsp
    1255:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1259:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    125d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1261:	be 00 00 00 00       	mov    $0x0,%esi
    1266:	48 89 c7             	mov    %rax,%rdi
    1269:	48 b8 e0 13 00 00 00 	movabs $0x13e0,%rax
    1270:	00 00 00 
    1273:	ff d0                	callq  *%rax
    1275:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    1278:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    127c:	79 07                	jns    1285 <stat+0x3c>
    return -1;
    127e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1283:	eb 2f                	jmp    12b4 <stat+0x6b>
  r = fstat(fd, st);
    1285:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1289:	8b 45 fc             	mov    -0x4(%rbp),%eax
    128c:	48 89 d6             	mov    %rdx,%rsi
    128f:	89 c7                	mov    %eax,%edi
    1291:	48 b8 07 14 00 00 00 	movabs $0x1407,%rax
    1298:	00 00 00 
    129b:	ff d0                	callq  *%rax
    129d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    12a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12a3:	89 c7                	mov    %eax,%edi
    12a5:	48 b8 b9 13 00 00 00 	movabs $0x13b9,%rax
    12ac:	00 00 00 
    12af:	ff d0                	callq  *%rax
  return r;
    12b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    12b4:	c9                   	leaveq 
    12b5:	c3                   	retq   

00000000000012b6 <atoi>:

int
atoi(const char *s)
{
    12b6:	f3 0f 1e fa          	endbr64 
    12ba:	55                   	push   %rbp
    12bb:	48 89 e5             	mov    %rsp,%rbp
    12be:	48 83 ec 18          	sub    $0x18,%rsp
    12c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    12c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    12cd:	eb 28                	jmp    12f7 <atoi+0x41>
    n = n*10 + *s++ - '0';
    12cf:	8b 55 fc             	mov    -0x4(%rbp),%edx
    12d2:	89 d0                	mov    %edx,%eax
    12d4:	c1 e0 02             	shl    $0x2,%eax
    12d7:	01 d0                	add    %edx,%eax
    12d9:	01 c0                	add    %eax,%eax
    12db:	89 c1                	mov    %eax,%ecx
    12dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12e1:	48 8d 50 01          	lea    0x1(%rax),%rdx
    12e5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    12e9:	0f b6 00             	movzbl (%rax),%eax
    12ec:	0f be c0             	movsbl %al,%eax
    12ef:	01 c8                	add    %ecx,%eax
    12f1:	83 e8 30             	sub    $0x30,%eax
    12f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    12f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12fb:	0f b6 00             	movzbl (%rax),%eax
    12fe:	3c 2f                	cmp    $0x2f,%al
    1300:	7e 0b                	jle    130d <atoi+0x57>
    1302:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1306:	0f b6 00             	movzbl (%rax),%eax
    1309:	3c 39                	cmp    $0x39,%al
    130b:	7e c2                	jle    12cf <atoi+0x19>
  return n;
    130d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1310:	c9                   	leaveq 
    1311:	c3                   	retq   

0000000000001312 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1312:	f3 0f 1e fa          	endbr64 
    1316:	55                   	push   %rbp
    1317:	48 89 e5             	mov    %rsp,%rbp
    131a:	48 83 ec 28          	sub    $0x28,%rsp
    131e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1322:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1326:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1329:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    132d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1331:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1335:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1339:	eb 1d                	jmp    1358 <memmove+0x46>
    *dst++ = *src++;
    133b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    133f:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1343:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1347:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    134b:	48 8d 48 01          	lea    0x1(%rax),%rcx
    134f:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    1353:	0f b6 12             	movzbl (%rdx),%edx
    1356:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1358:	8b 45 dc             	mov    -0x24(%rbp),%eax
    135b:	8d 50 ff             	lea    -0x1(%rax),%edx
    135e:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1361:	85 c0                	test   %eax,%eax
    1363:	7f d6                	jg     133b <memmove+0x29>
  return vdst;
    1365:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1369:	c9                   	leaveq 
    136a:	c3                   	retq   

000000000000136b <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    136b:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    1372:	49 89 ca             	mov    %rcx,%r10
    1375:	0f 05                	syscall 
    1377:	c3                   	retq   

0000000000001378 <exit>:
SYSCALL(exit)
    1378:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    137f:	49 89 ca             	mov    %rcx,%r10
    1382:	0f 05                	syscall 
    1384:	c3                   	retq   

0000000000001385 <wait>:
SYSCALL(wait)
    1385:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    138c:	49 89 ca             	mov    %rcx,%r10
    138f:	0f 05                	syscall 
    1391:	c3                   	retq   

0000000000001392 <pipe>:
SYSCALL(pipe)
    1392:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1399:	49 89 ca             	mov    %rcx,%r10
    139c:	0f 05                	syscall 
    139e:	c3                   	retq   

000000000000139f <read>:
SYSCALL(read)
    139f:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    13a6:	49 89 ca             	mov    %rcx,%r10
    13a9:	0f 05                	syscall 
    13ab:	c3                   	retq   

00000000000013ac <write>:
SYSCALL(write)
    13ac:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    13b3:	49 89 ca             	mov    %rcx,%r10
    13b6:	0f 05                	syscall 
    13b8:	c3                   	retq   

00000000000013b9 <close>:
SYSCALL(close)
    13b9:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    13c0:	49 89 ca             	mov    %rcx,%r10
    13c3:	0f 05                	syscall 
    13c5:	c3                   	retq   

00000000000013c6 <kill>:
SYSCALL(kill)
    13c6:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    13cd:	49 89 ca             	mov    %rcx,%r10
    13d0:	0f 05                	syscall 
    13d2:	c3                   	retq   

00000000000013d3 <exec>:
SYSCALL(exec)
    13d3:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    13da:	49 89 ca             	mov    %rcx,%r10
    13dd:	0f 05                	syscall 
    13df:	c3                   	retq   

00000000000013e0 <open>:
SYSCALL(open)
    13e0:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    13e7:	49 89 ca             	mov    %rcx,%r10
    13ea:	0f 05                	syscall 
    13ec:	c3                   	retq   

00000000000013ed <mknod>:
SYSCALL(mknod)
    13ed:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    13f4:	49 89 ca             	mov    %rcx,%r10
    13f7:	0f 05                	syscall 
    13f9:	c3                   	retq   

00000000000013fa <unlink>:
SYSCALL(unlink)
    13fa:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1401:	49 89 ca             	mov    %rcx,%r10
    1404:	0f 05                	syscall 
    1406:	c3                   	retq   

0000000000001407 <fstat>:
SYSCALL(fstat)
    1407:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    140e:	49 89 ca             	mov    %rcx,%r10
    1411:	0f 05                	syscall 
    1413:	c3                   	retq   

0000000000001414 <link>:
SYSCALL(link)
    1414:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    141b:	49 89 ca             	mov    %rcx,%r10
    141e:	0f 05                	syscall 
    1420:	c3                   	retq   

0000000000001421 <mkdir>:
SYSCALL(mkdir)
    1421:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1428:	49 89 ca             	mov    %rcx,%r10
    142b:	0f 05                	syscall 
    142d:	c3                   	retq   

000000000000142e <chdir>:
SYSCALL(chdir)
    142e:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1435:	49 89 ca             	mov    %rcx,%r10
    1438:	0f 05                	syscall 
    143a:	c3                   	retq   

000000000000143b <dup>:
SYSCALL(dup)
    143b:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1442:	49 89 ca             	mov    %rcx,%r10
    1445:	0f 05                	syscall 
    1447:	c3                   	retq   

0000000000001448 <getpid>:
SYSCALL(getpid)
    1448:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    144f:	49 89 ca             	mov    %rcx,%r10
    1452:	0f 05                	syscall 
    1454:	c3                   	retq   

0000000000001455 <sbrk>:
SYSCALL(sbrk)
    1455:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    145c:	49 89 ca             	mov    %rcx,%r10
    145f:	0f 05                	syscall 
    1461:	c3                   	retq   

0000000000001462 <sleep>:
SYSCALL(sleep)
    1462:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    1469:	49 89 ca             	mov    %rcx,%r10
    146c:	0f 05                	syscall 
    146e:	c3                   	retq   

000000000000146f <uptime>:
SYSCALL(uptime)
    146f:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    1476:	49 89 ca             	mov    %rcx,%r10
    1479:	0f 05                	syscall 
    147b:	c3                   	retq   

000000000000147c <dedup>:
SYSCALL(dedup)
    147c:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    1483:	49 89 ca             	mov    %rcx,%r10
    1486:	0f 05                	syscall 
    1488:	c3                   	retq   

0000000000001489 <freepages>:
SYSCALL(freepages)
    1489:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    1490:	49 89 ca             	mov    %rcx,%r10
    1493:	0f 05                	syscall 
    1495:	c3                   	retq   

0000000000001496 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    1496:	f3 0f 1e fa          	endbr64 
    149a:	55                   	push   %rbp
    149b:	48 89 e5             	mov    %rsp,%rbp
    149e:	48 83 ec 10          	sub    $0x10,%rsp
    14a2:	89 7d fc             	mov    %edi,-0x4(%rbp)
    14a5:	89 f0                	mov    %esi,%eax
    14a7:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    14aa:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    14ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14b1:	ba 01 00 00 00       	mov    $0x1,%edx
    14b6:	48 89 ce             	mov    %rcx,%rsi
    14b9:	89 c7                	mov    %eax,%edi
    14bb:	48 b8 ac 13 00 00 00 	movabs $0x13ac,%rax
    14c2:	00 00 00 
    14c5:	ff d0                	callq  *%rax
}
    14c7:	90                   	nop
    14c8:	c9                   	leaveq 
    14c9:	c3                   	retq   

00000000000014ca <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    14ca:	f3 0f 1e fa          	endbr64 
    14ce:	55                   	push   %rbp
    14cf:	48 89 e5             	mov    %rsp,%rbp
    14d2:	48 83 ec 20          	sub    $0x20,%rsp
    14d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
    14d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    14dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    14e4:	eb 35                	jmp    151b <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    14e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    14ea:	48 c1 e8 3c          	shr    $0x3c,%rax
    14ee:	48 ba c0 20 00 00 00 	movabs $0x20c0,%rdx
    14f5:	00 00 00 
    14f8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    14fc:	0f be d0             	movsbl %al,%edx
    14ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1502:	89 d6                	mov    %edx,%esi
    1504:	89 c7                	mov    %eax,%edi
    1506:	48 b8 96 14 00 00 00 	movabs $0x1496,%rax
    150d:	00 00 00 
    1510:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1512:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1516:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    151b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    151e:	83 f8 0f             	cmp    $0xf,%eax
    1521:	76 c3                	jbe    14e6 <print_x64+0x1c>
}
    1523:	90                   	nop
    1524:	90                   	nop
    1525:	c9                   	leaveq 
    1526:	c3                   	retq   

0000000000001527 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1527:	f3 0f 1e fa          	endbr64 
    152b:	55                   	push   %rbp
    152c:	48 89 e5             	mov    %rsp,%rbp
    152f:	48 83 ec 20          	sub    $0x20,%rsp
    1533:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1536:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1539:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1540:	eb 36                	jmp    1578 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1542:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1545:	c1 e8 1c             	shr    $0x1c,%eax
    1548:	89 c2                	mov    %eax,%edx
    154a:	48 b8 c0 20 00 00 00 	movabs $0x20c0,%rax
    1551:	00 00 00 
    1554:	89 d2                	mov    %edx,%edx
    1556:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    155a:	0f be d0             	movsbl %al,%edx
    155d:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1560:	89 d6                	mov    %edx,%esi
    1562:	89 c7                	mov    %eax,%edi
    1564:	48 b8 96 14 00 00 00 	movabs $0x1496,%rax
    156b:	00 00 00 
    156e:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1570:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1574:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    1578:	8b 45 fc             	mov    -0x4(%rbp),%eax
    157b:	83 f8 07             	cmp    $0x7,%eax
    157e:	76 c2                	jbe    1542 <print_x32+0x1b>
}
    1580:	90                   	nop
    1581:	90                   	nop
    1582:	c9                   	leaveq 
    1583:	c3                   	retq   

0000000000001584 <print_d>:

  static void
print_d(int fd, int v)
{
    1584:	f3 0f 1e fa          	endbr64 
    1588:	55                   	push   %rbp
    1589:	48 89 e5             	mov    %rsp,%rbp
    158c:	48 83 ec 30          	sub    $0x30,%rsp
    1590:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1593:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    1596:	8b 45 d8             	mov    -0x28(%rbp),%eax
    1599:	48 98                	cltq   
    159b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    159f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    15a3:	79 04                	jns    15a9 <print_d+0x25>
    x = -x;
    15a5:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    15a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    15b0:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    15b4:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    15bb:	66 66 66 
    15be:	48 89 c8             	mov    %rcx,%rax
    15c1:	48 f7 ea             	imul   %rdx
    15c4:	48 c1 fa 02          	sar    $0x2,%rdx
    15c8:	48 89 c8             	mov    %rcx,%rax
    15cb:	48 c1 f8 3f          	sar    $0x3f,%rax
    15cf:	48 29 c2             	sub    %rax,%rdx
    15d2:	48 89 d0             	mov    %rdx,%rax
    15d5:	48 c1 e0 02          	shl    $0x2,%rax
    15d9:	48 01 d0             	add    %rdx,%rax
    15dc:	48 01 c0             	add    %rax,%rax
    15df:	48 29 c1             	sub    %rax,%rcx
    15e2:	48 89 ca             	mov    %rcx,%rdx
    15e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
    15e8:	8d 48 01             	lea    0x1(%rax),%ecx
    15eb:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    15ee:	48 b9 c0 20 00 00 00 	movabs $0x20c0,%rcx
    15f5:	00 00 00 
    15f8:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    15fc:	48 98                	cltq   
    15fe:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1602:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1606:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    160d:	66 66 66 
    1610:	48 89 c8             	mov    %rcx,%rax
    1613:	48 f7 ea             	imul   %rdx
    1616:	48 c1 fa 02          	sar    $0x2,%rdx
    161a:	48 89 c8             	mov    %rcx,%rax
    161d:	48 c1 f8 3f          	sar    $0x3f,%rax
    1621:	48 29 c2             	sub    %rax,%rdx
    1624:	48 89 d0             	mov    %rdx,%rax
    1627:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    162b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1630:	0f 85 7a ff ff ff    	jne    15b0 <print_d+0x2c>

  if (v < 0)
    1636:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    163a:	79 32                	jns    166e <print_d+0xea>
    buf[i++] = '-';
    163c:	8b 45 f4             	mov    -0xc(%rbp),%eax
    163f:	8d 50 01             	lea    0x1(%rax),%edx
    1642:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1645:	48 98                	cltq   
    1647:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    164c:	eb 20                	jmp    166e <print_d+0xea>
    putc(fd, buf[i]);
    164e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1651:	48 98                	cltq   
    1653:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1658:	0f be d0             	movsbl %al,%edx
    165b:	8b 45 dc             	mov    -0x24(%rbp),%eax
    165e:	89 d6                	mov    %edx,%esi
    1660:	89 c7                	mov    %eax,%edi
    1662:	48 b8 96 14 00 00 00 	movabs $0x1496,%rax
    1669:	00 00 00 
    166c:	ff d0                	callq  *%rax
  while (--i >= 0)
    166e:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1672:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1676:	79 d6                	jns    164e <print_d+0xca>
}
    1678:	90                   	nop
    1679:	90                   	nop
    167a:	c9                   	leaveq 
    167b:	c3                   	retq   

000000000000167c <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    167c:	f3 0f 1e fa          	endbr64 
    1680:	55                   	push   %rbp
    1681:	48 89 e5             	mov    %rsp,%rbp
    1684:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    168b:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1691:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1698:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    169f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    16a6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    16ad:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    16b4:	84 c0                	test   %al,%al
    16b6:	74 20                	je     16d8 <printf+0x5c>
    16b8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    16bc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    16c0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    16c4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    16c8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    16cc:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    16d0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    16d4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    16d8:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    16df:	00 00 00 
    16e2:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    16e9:	00 00 00 
    16ec:	48 8d 45 10          	lea    0x10(%rbp),%rax
    16f0:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    16f7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    16fe:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1705:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    170c:	00 00 00 
    170f:	e9 41 03 00 00       	jmpq   1a55 <printf+0x3d9>
    if (c != '%') {
    1714:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    171b:	74 24                	je     1741 <printf+0xc5>
      putc(fd, c);
    171d:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1723:	0f be d0             	movsbl %al,%edx
    1726:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    172c:	89 d6                	mov    %edx,%esi
    172e:	89 c7                	mov    %eax,%edi
    1730:	48 b8 96 14 00 00 00 	movabs $0x1496,%rax
    1737:	00 00 00 
    173a:	ff d0                	callq  *%rax
      continue;
    173c:	e9 0d 03 00 00       	jmpq   1a4e <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1741:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1748:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    174e:	48 63 d0             	movslq %eax,%rdx
    1751:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1758:	48 01 d0             	add    %rdx,%rax
    175b:	0f b6 00             	movzbl (%rax),%eax
    175e:	0f be c0             	movsbl %al,%eax
    1761:	25 ff 00 00 00       	and    $0xff,%eax
    1766:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    176c:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1773:	0f 84 0f 03 00 00    	je     1a88 <printf+0x40c>
      break;
    switch(c) {
    1779:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1780:	0f 84 74 02 00 00    	je     19fa <printf+0x37e>
    1786:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    178d:	0f 8c 82 02 00 00    	jl     1a15 <printf+0x399>
    1793:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    179a:	0f 8f 75 02 00 00    	jg     1a15 <printf+0x399>
    17a0:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    17a7:	0f 8c 68 02 00 00    	jl     1a15 <printf+0x399>
    17ad:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    17b3:	83 e8 63             	sub    $0x63,%eax
    17b6:	83 f8 15             	cmp    $0x15,%eax
    17b9:	0f 87 56 02 00 00    	ja     1a15 <printf+0x399>
    17bf:	89 c0                	mov    %eax,%eax
    17c1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    17c8:	00 
    17c9:	48 b8 98 1d 00 00 00 	movabs $0x1d98,%rax
    17d0:	00 00 00 
    17d3:	48 01 d0             	add    %rdx,%rax
    17d6:	48 8b 00             	mov    (%rax),%rax
    17d9:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    17dc:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    17e2:	83 f8 2f             	cmp    $0x2f,%eax
    17e5:	77 23                	ja     180a <printf+0x18e>
    17e7:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    17ee:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    17f4:	89 d2                	mov    %edx,%edx
    17f6:	48 01 d0             	add    %rdx,%rax
    17f9:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    17ff:	83 c2 08             	add    $0x8,%edx
    1802:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1808:	eb 12                	jmp    181c <printf+0x1a0>
    180a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1811:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1815:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    181c:	8b 00                	mov    (%rax),%eax
    181e:	0f be d0             	movsbl %al,%edx
    1821:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1827:	89 d6                	mov    %edx,%esi
    1829:	89 c7                	mov    %eax,%edi
    182b:	48 b8 96 14 00 00 00 	movabs $0x1496,%rax
    1832:	00 00 00 
    1835:	ff d0                	callq  *%rax
      break;
    1837:	e9 12 02 00 00       	jmpq   1a4e <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    183c:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1842:	83 f8 2f             	cmp    $0x2f,%eax
    1845:	77 23                	ja     186a <printf+0x1ee>
    1847:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    184e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1854:	89 d2                	mov    %edx,%edx
    1856:	48 01 d0             	add    %rdx,%rax
    1859:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    185f:	83 c2 08             	add    $0x8,%edx
    1862:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1868:	eb 12                	jmp    187c <printf+0x200>
    186a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1871:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1875:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    187c:	8b 10                	mov    (%rax),%edx
    187e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1884:	89 d6                	mov    %edx,%esi
    1886:	89 c7                	mov    %eax,%edi
    1888:	48 b8 84 15 00 00 00 	movabs $0x1584,%rax
    188f:	00 00 00 
    1892:	ff d0                	callq  *%rax
      break;
    1894:	e9 b5 01 00 00       	jmpq   1a4e <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1899:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    189f:	83 f8 2f             	cmp    $0x2f,%eax
    18a2:	77 23                	ja     18c7 <printf+0x24b>
    18a4:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18ab:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18b1:	89 d2                	mov    %edx,%edx
    18b3:	48 01 d0             	add    %rdx,%rax
    18b6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18bc:	83 c2 08             	add    $0x8,%edx
    18bf:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18c5:	eb 12                	jmp    18d9 <printf+0x25d>
    18c7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18ce:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18d2:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18d9:	8b 10                	mov    (%rax),%edx
    18db:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18e1:	89 d6                	mov    %edx,%esi
    18e3:	89 c7                	mov    %eax,%edi
    18e5:	48 b8 27 15 00 00 00 	movabs $0x1527,%rax
    18ec:	00 00 00 
    18ef:	ff d0                	callq  *%rax
      break;
    18f1:	e9 58 01 00 00       	jmpq   1a4e <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    18f6:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18fc:	83 f8 2f             	cmp    $0x2f,%eax
    18ff:	77 23                	ja     1924 <printf+0x2a8>
    1901:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1908:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    190e:	89 d2                	mov    %edx,%edx
    1910:	48 01 d0             	add    %rdx,%rax
    1913:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1919:	83 c2 08             	add    $0x8,%edx
    191c:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1922:	eb 12                	jmp    1936 <printf+0x2ba>
    1924:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    192b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    192f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1936:	48 8b 10             	mov    (%rax),%rdx
    1939:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    193f:	48 89 d6             	mov    %rdx,%rsi
    1942:	89 c7                	mov    %eax,%edi
    1944:	48 b8 ca 14 00 00 00 	movabs $0x14ca,%rax
    194b:	00 00 00 
    194e:	ff d0                	callq  *%rax
      break;
    1950:	e9 f9 00 00 00       	jmpq   1a4e <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1955:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    195b:	83 f8 2f             	cmp    $0x2f,%eax
    195e:	77 23                	ja     1983 <printf+0x307>
    1960:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1967:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    196d:	89 d2                	mov    %edx,%edx
    196f:	48 01 d0             	add    %rdx,%rax
    1972:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1978:	83 c2 08             	add    $0x8,%edx
    197b:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1981:	eb 12                	jmp    1995 <printf+0x319>
    1983:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    198a:	48 8d 50 08          	lea    0x8(%rax),%rdx
    198e:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1995:	48 8b 00             	mov    (%rax),%rax
    1998:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    199f:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    19a6:	00 
    19a7:	75 41                	jne    19ea <printf+0x36e>
        s = "(null)";
    19a9:	48 b8 90 1d 00 00 00 	movabs $0x1d90,%rax
    19b0:	00 00 00 
    19b3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    19ba:	eb 2e                	jmp    19ea <printf+0x36e>
        putc(fd, *(s++));
    19bc:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    19c3:	48 8d 50 01          	lea    0x1(%rax),%rdx
    19c7:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    19ce:	0f b6 00             	movzbl (%rax),%eax
    19d1:	0f be d0             	movsbl %al,%edx
    19d4:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19da:	89 d6                	mov    %edx,%esi
    19dc:	89 c7                	mov    %eax,%edi
    19de:	48 b8 96 14 00 00 00 	movabs $0x1496,%rax
    19e5:	00 00 00 
    19e8:	ff d0                	callq  *%rax
      while (*s)
    19ea:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    19f1:	0f b6 00             	movzbl (%rax),%eax
    19f4:	84 c0                	test   %al,%al
    19f6:	75 c4                	jne    19bc <printf+0x340>
      break;
    19f8:	eb 54                	jmp    1a4e <printf+0x3d2>
    case '%':
      putc(fd, '%');
    19fa:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a00:	be 25 00 00 00       	mov    $0x25,%esi
    1a05:	89 c7                	mov    %eax,%edi
    1a07:	48 b8 96 14 00 00 00 	movabs $0x1496,%rax
    1a0e:	00 00 00 
    1a11:	ff d0                	callq  *%rax
      break;
    1a13:	eb 39                	jmp    1a4e <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a15:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a1b:	be 25 00 00 00       	mov    $0x25,%esi
    1a20:	89 c7                	mov    %eax,%edi
    1a22:	48 b8 96 14 00 00 00 	movabs $0x1496,%rax
    1a29:	00 00 00 
    1a2c:	ff d0                	callq  *%rax
      putc(fd, c);
    1a2e:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1a34:	0f be d0             	movsbl %al,%edx
    1a37:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a3d:	89 d6                	mov    %edx,%esi
    1a3f:	89 c7                	mov    %eax,%edi
    1a41:	48 b8 96 14 00 00 00 	movabs $0x1496,%rax
    1a48:	00 00 00 
    1a4b:	ff d0                	callq  *%rax
      break;
    1a4d:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1a4e:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1a55:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1a5b:	48 63 d0             	movslq %eax,%rdx
    1a5e:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1a65:	48 01 d0             	add    %rdx,%rax
    1a68:	0f b6 00             	movzbl (%rax),%eax
    1a6b:	0f be c0             	movsbl %al,%eax
    1a6e:	25 ff 00 00 00       	and    $0xff,%eax
    1a73:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1a79:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1a80:	0f 85 8e fc ff ff    	jne    1714 <printf+0x98>
    }
  }
}
    1a86:	eb 01                	jmp    1a89 <printf+0x40d>
      break;
    1a88:	90                   	nop
}
    1a89:	90                   	nop
    1a8a:	c9                   	leaveq 
    1a8b:	c3                   	retq   

0000000000001a8c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1a8c:	f3 0f 1e fa          	endbr64 
    1a90:	55                   	push   %rbp
    1a91:	48 89 e5             	mov    %rsp,%rbp
    1a94:	48 83 ec 18          	sub    $0x18,%rsp
    1a98:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1a9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1aa0:	48 83 e8 10          	sub    $0x10,%rax
    1aa4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1aa8:	48 b8 f0 20 00 00 00 	movabs $0x20f0,%rax
    1aaf:	00 00 00 
    1ab2:	48 8b 00             	mov    (%rax),%rax
    1ab5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1ab9:	eb 2f                	jmp    1aea <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1abb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1abf:	48 8b 00             	mov    (%rax),%rax
    1ac2:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1ac6:	72 17                	jb     1adf <free+0x53>
    1ac8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1acc:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1ad0:	77 2f                	ja     1b01 <free+0x75>
    1ad2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ad6:	48 8b 00             	mov    (%rax),%rax
    1ad9:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1add:	72 22                	jb     1b01 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1adf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ae3:	48 8b 00             	mov    (%rax),%rax
    1ae6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1aea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1aee:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1af2:	76 c7                	jbe    1abb <free+0x2f>
    1af4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1af8:	48 8b 00             	mov    (%rax),%rax
    1afb:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1aff:	73 ba                	jae    1abb <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b05:	8b 40 08             	mov    0x8(%rax),%eax
    1b08:	89 c0                	mov    %eax,%eax
    1b0a:	48 c1 e0 04          	shl    $0x4,%rax
    1b0e:	48 89 c2             	mov    %rax,%rdx
    1b11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b15:	48 01 c2             	add    %rax,%rdx
    1b18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b1c:	48 8b 00             	mov    (%rax),%rax
    1b1f:	48 39 c2             	cmp    %rax,%rdx
    1b22:	75 2d                	jne    1b51 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1b24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b28:	8b 50 08             	mov    0x8(%rax),%edx
    1b2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b2f:	48 8b 00             	mov    (%rax),%rax
    1b32:	8b 40 08             	mov    0x8(%rax),%eax
    1b35:	01 c2                	add    %eax,%edx
    1b37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b3b:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1b3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b42:	48 8b 00             	mov    (%rax),%rax
    1b45:	48 8b 10             	mov    (%rax),%rdx
    1b48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b4c:	48 89 10             	mov    %rdx,(%rax)
    1b4f:	eb 0e                	jmp    1b5f <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1b51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b55:	48 8b 10             	mov    (%rax),%rdx
    1b58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b5c:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1b5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b63:	8b 40 08             	mov    0x8(%rax),%eax
    1b66:	89 c0                	mov    %eax,%eax
    1b68:	48 c1 e0 04          	shl    $0x4,%rax
    1b6c:	48 89 c2             	mov    %rax,%rdx
    1b6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b73:	48 01 d0             	add    %rdx,%rax
    1b76:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b7a:	75 27                	jne    1ba3 <free+0x117>
    p->s.size += bp->s.size;
    1b7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b80:	8b 50 08             	mov    0x8(%rax),%edx
    1b83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b87:	8b 40 08             	mov    0x8(%rax),%eax
    1b8a:	01 c2                	add    %eax,%edx
    1b8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b90:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1b93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b97:	48 8b 10             	mov    (%rax),%rdx
    1b9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b9e:	48 89 10             	mov    %rdx,(%rax)
    1ba1:	eb 0b                	jmp    1bae <free+0x122>
  } else
    p->s.ptr = bp;
    1ba3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ba7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1bab:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1bae:	48 ba f0 20 00 00 00 	movabs $0x20f0,%rdx
    1bb5:	00 00 00 
    1bb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bbc:	48 89 02             	mov    %rax,(%rdx)
}
    1bbf:	90                   	nop
    1bc0:	c9                   	leaveq 
    1bc1:	c3                   	retq   

0000000000001bc2 <morecore>:

static Header*
morecore(uint nu)
{
    1bc2:	f3 0f 1e fa          	endbr64 
    1bc6:	55                   	push   %rbp
    1bc7:	48 89 e5             	mov    %rsp,%rbp
    1bca:	48 83 ec 20          	sub    $0x20,%rsp
    1bce:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1bd1:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1bd8:	77 07                	ja     1be1 <morecore+0x1f>
    nu = 4096;
    1bda:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1be1:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1be4:	48 c1 e0 04          	shl    $0x4,%rax
    1be8:	48 89 c7             	mov    %rax,%rdi
    1beb:	48 b8 55 14 00 00 00 	movabs $0x1455,%rax
    1bf2:	00 00 00 
    1bf5:	ff d0                	callq  *%rax
    1bf7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1bfb:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c00:	75 07                	jne    1c09 <morecore+0x47>
    return 0;
    1c02:	b8 00 00 00 00       	mov    $0x0,%eax
    1c07:	eb 36                	jmp    1c3f <morecore+0x7d>
  hp = (Header*)p;
    1c09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c0d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c15:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1c18:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1c1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c1f:	48 83 c0 10          	add    $0x10,%rax
    1c23:	48 89 c7             	mov    %rax,%rdi
    1c26:	48 b8 8c 1a 00 00 00 	movabs $0x1a8c,%rax
    1c2d:	00 00 00 
    1c30:	ff d0                	callq  *%rax
  return freep;
    1c32:	48 b8 f0 20 00 00 00 	movabs $0x20f0,%rax
    1c39:	00 00 00 
    1c3c:	48 8b 00             	mov    (%rax),%rax
}
    1c3f:	c9                   	leaveq 
    1c40:	c3                   	retq   

0000000000001c41 <malloc>:

void*
malloc(uint nbytes)
{
    1c41:	f3 0f 1e fa          	endbr64 
    1c45:	55                   	push   %rbp
    1c46:	48 89 e5             	mov    %rsp,%rbp
    1c49:	48 83 ec 30          	sub    $0x30,%rsp
    1c4d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1c50:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1c53:	48 83 c0 0f          	add    $0xf,%rax
    1c57:	48 c1 e8 04          	shr    $0x4,%rax
    1c5b:	83 c0 01             	add    $0x1,%eax
    1c5e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1c61:	48 b8 f0 20 00 00 00 	movabs $0x20f0,%rax
    1c68:	00 00 00 
    1c6b:	48 8b 00             	mov    (%rax),%rax
    1c6e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1c72:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1c77:	75 4a                	jne    1cc3 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1c79:	48 b8 e0 20 00 00 00 	movabs $0x20e0,%rax
    1c80:	00 00 00 
    1c83:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1c87:	48 ba f0 20 00 00 00 	movabs $0x20f0,%rdx
    1c8e:	00 00 00 
    1c91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c95:	48 89 02             	mov    %rax,(%rdx)
    1c98:	48 b8 f0 20 00 00 00 	movabs $0x20f0,%rax
    1c9f:	00 00 00 
    1ca2:	48 8b 00             	mov    (%rax),%rax
    1ca5:	48 ba e0 20 00 00 00 	movabs $0x20e0,%rdx
    1cac:	00 00 00 
    1caf:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1cb2:	48 b8 e0 20 00 00 00 	movabs $0x20e0,%rax
    1cb9:	00 00 00 
    1cbc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1cc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cc7:	48 8b 00             	mov    (%rax),%rax
    1cca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1cce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cd2:	8b 40 08             	mov    0x8(%rax),%eax
    1cd5:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1cd8:	77 65                	ja     1d3f <malloc+0xfe>
      if(p->s.size == nunits)
    1cda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cde:	8b 40 08             	mov    0x8(%rax),%eax
    1ce1:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1ce4:	75 10                	jne    1cf6 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1ce6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cea:	48 8b 10             	mov    (%rax),%rdx
    1ced:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cf1:	48 89 10             	mov    %rdx,(%rax)
    1cf4:	eb 2e                	jmp    1d24 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1cf6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cfa:	8b 40 08             	mov    0x8(%rax),%eax
    1cfd:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d00:	89 c2                	mov    %eax,%edx
    1d02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d06:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1d09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d0d:	8b 40 08             	mov    0x8(%rax),%eax
    1d10:	89 c0                	mov    %eax,%eax
    1d12:	48 c1 e0 04          	shl    $0x4,%rax
    1d16:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d1e:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d21:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1d24:	48 ba f0 20 00 00 00 	movabs $0x20f0,%rdx
    1d2b:	00 00 00 
    1d2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d32:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1d35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d39:	48 83 c0 10          	add    $0x10,%rax
    1d3d:	eb 4e                	jmp    1d8d <malloc+0x14c>
    }
    if(p == freep)
    1d3f:	48 b8 f0 20 00 00 00 	movabs $0x20f0,%rax
    1d46:	00 00 00 
    1d49:	48 8b 00             	mov    (%rax),%rax
    1d4c:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1d50:	75 23                	jne    1d75 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1d52:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d55:	89 c7                	mov    %eax,%edi
    1d57:	48 b8 c2 1b 00 00 00 	movabs $0x1bc2,%rax
    1d5e:	00 00 00 
    1d61:	ff d0                	callq  *%rax
    1d63:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1d67:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1d6c:	75 07                	jne    1d75 <malloc+0x134>
        return 0;
    1d6e:	b8 00 00 00 00       	mov    $0x0,%eax
    1d73:	eb 18                	jmp    1d8d <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d79:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d81:	48 8b 00             	mov    (%rax),%rax
    1d84:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d88:	e9 41 ff ff ff       	jmpq   1cce <malloc+0x8d>
  }
}
    1d8d:	c9                   	leaveq 
    1d8e:	c3                   	retq   
