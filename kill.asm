
_kill:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 20          	sub    $0x20,%rsp
    100c:	89 7d ec             	mov    %edi,-0x14(%rbp)
    100f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;

  if(argc < 2){
    1013:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
    1017:	7f 2c                	jg     1045 <main+0x45>
    printf(2, "usage: kill pid...\n");
    1019:	48 be f8 1d 00 00 00 	movabs $0x1df8,%rsi
    1020:	00 00 00 
    1023:	bf 02 00 00 00       	mov    $0x2,%edi
    1028:	b8 00 00 00 00       	mov    $0x0,%eax
    102d:	48 ba e1 16 00 00 00 	movabs $0x16e1,%rdx
    1034:	00 00 00 
    1037:	ff d2                	callq  *%rdx
    exit();
    1039:	48 b8 dd 13 00 00 00 	movabs $0x13dd,%rax
    1040:	00 00 00 
    1043:	ff d0                	callq  *%rax
  }
  for(i=1; i<argc; i++)
    1045:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    104c:	eb 38                	jmp    1086 <main+0x86>
    kill(atoi(argv[i]));
    104e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1051:	48 98                	cltq   
    1053:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    105a:	00 
    105b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    105f:	48 01 d0             	add    %rdx,%rax
    1062:	48 8b 00             	mov    (%rax),%rax
    1065:	48 89 c7             	mov    %rax,%rdi
    1068:	48 b8 1b 13 00 00 00 	movabs $0x131b,%rax
    106f:	00 00 00 
    1072:	ff d0                	callq  *%rax
    1074:	89 c7                	mov    %eax,%edi
    1076:	48 b8 2b 14 00 00 00 	movabs $0x142b,%rax
    107d:	00 00 00 
    1080:	ff d0                	callq  *%rax
  for(i=1; i<argc; i++)
    1082:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1086:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1089:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    108c:	7c c0                	jl     104e <main+0x4e>
  exit();
    108e:	48 b8 dd 13 00 00 00 	movabs $0x13dd,%rax
    1095:	00 00 00 
    1098:	ff d0                	callq  *%rax

000000000000109a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    109a:	f3 0f 1e fa          	endbr64 
    109e:	55                   	push   %rbp
    109f:	48 89 e5             	mov    %rsp,%rbp
    10a2:	48 83 ec 10          	sub    $0x10,%rsp
    10a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10aa:	89 75 f4             	mov    %esi,-0xc(%rbp)
    10ad:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    10b0:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    10b4:	8b 55 f0             	mov    -0x10(%rbp),%edx
    10b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
    10ba:	48 89 ce             	mov    %rcx,%rsi
    10bd:	48 89 f7             	mov    %rsi,%rdi
    10c0:	89 d1                	mov    %edx,%ecx
    10c2:	fc                   	cld    
    10c3:	f3 aa                	rep stos %al,%es:(%rdi)
    10c5:	89 ca                	mov    %ecx,%edx
    10c7:	48 89 fe             	mov    %rdi,%rsi
    10ca:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    10ce:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10d1:	90                   	nop
    10d2:	c9                   	leaveq 
    10d3:	c3                   	retq   

00000000000010d4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10d4:	f3 0f 1e fa          	endbr64 
    10d8:	55                   	push   %rbp
    10d9:	48 89 e5             	mov    %rsp,%rbp
    10dc:	48 83 ec 20          	sub    $0x20,%rsp
    10e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    10e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    10e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    10f0:	90                   	nop
    10f1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    10f5:	48 8d 42 01          	lea    0x1(%rdx),%rax
    10f9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    10fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1101:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1105:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1109:	0f b6 12             	movzbl (%rdx),%edx
    110c:	88 10                	mov    %dl,(%rax)
    110e:	0f b6 00             	movzbl (%rax),%eax
    1111:	84 c0                	test   %al,%al
    1113:	75 dc                	jne    10f1 <strcpy+0x1d>
    ;
  return os;
    1115:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1119:	c9                   	leaveq 
    111a:	c3                   	retq   

000000000000111b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    111b:	f3 0f 1e fa          	endbr64 
    111f:	55                   	push   %rbp
    1120:	48 89 e5             	mov    %rsp,%rbp
    1123:	48 83 ec 10          	sub    $0x10,%rsp
    1127:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    112b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    112f:	eb 0a                	jmp    113b <strcmp+0x20>
    p++, q++;
    1131:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1136:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    113b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    113f:	0f b6 00             	movzbl (%rax),%eax
    1142:	84 c0                	test   %al,%al
    1144:	74 12                	je     1158 <strcmp+0x3d>
    1146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    114a:	0f b6 10             	movzbl (%rax),%edx
    114d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1151:	0f b6 00             	movzbl (%rax),%eax
    1154:	38 c2                	cmp    %al,%dl
    1156:	74 d9                	je     1131 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1158:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    115c:	0f b6 00             	movzbl (%rax),%eax
    115f:	0f b6 d0             	movzbl %al,%edx
    1162:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1166:	0f b6 00             	movzbl (%rax),%eax
    1169:	0f b6 c0             	movzbl %al,%eax
    116c:	29 c2                	sub    %eax,%edx
    116e:	89 d0                	mov    %edx,%eax
}
    1170:	c9                   	leaveq 
    1171:	c3                   	retq   

0000000000001172 <strlen>:

uint
strlen(char *s)
{
    1172:	f3 0f 1e fa          	endbr64 
    1176:	55                   	push   %rbp
    1177:	48 89 e5             	mov    %rsp,%rbp
    117a:	48 83 ec 18          	sub    $0x18,%rsp
    117e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1182:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1189:	eb 04                	jmp    118f <strlen+0x1d>
    118b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    118f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1192:	48 63 d0             	movslq %eax,%rdx
    1195:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1199:	48 01 d0             	add    %rdx,%rax
    119c:	0f b6 00             	movzbl (%rax),%eax
    119f:	84 c0                	test   %al,%al
    11a1:	75 e8                	jne    118b <strlen+0x19>
    ;
  return n;
    11a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    11a6:	c9                   	leaveq 
    11a7:	c3                   	retq   

00000000000011a8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11a8:	f3 0f 1e fa          	endbr64 
    11ac:	55                   	push   %rbp
    11ad:	48 89 e5             	mov    %rsp,%rbp
    11b0:	48 83 ec 10          	sub    $0x10,%rsp
    11b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11b8:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11bb:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    11be:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11c1:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    11c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11c8:	89 ce                	mov    %ecx,%esi
    11ca:	48 89 c7             	mov    %rax,%rdi
    11cd:	48 b8 9a 10 00 00 00 	movabs $0x109a,%rax
    11d4:	00 00 00 
    11d7:	ff d0                	callq  *%rax
  return dst;
    11d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    11dd:	c9                   	leaveq 
    11de:	c3                   	retq   

00000000000011df <strchr>:

char*
strchr(const char *s, char c)
{
    11df:	f3 0f 1e fa          	endbr64 
    11e3:	55                   	push   %rbp
    11e4:	48 89 e5             	mov    %rsp,%rbp
    11e7:	48 83 ec 10          	sub    $0x10,%rsp
    11eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11ef:	89 f0                	mov    %esi,%eax
    11f1:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    11f4:	eb 17                	jmp    120d <strchr+0x2e>
    if(*s == c)
    11f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11fa:	0f b6 00             	movzbl (%rax),%eax
    11fd:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1200:	75 06                	jne    1208 <strchr+0x29>
      return (char*)s;
    1202:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1206:	eb 15                	jmp    121d <strchr+0x3e>
  for(; *s; s++)
    1208:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    120d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1211:	0f b6 00             	movzbl (%rax),%eax
    1214:	84 c0                	test   %al,%al
    1216:	75 de                	jne    11f6 <strchr+0x17>
  return 0;
    1218:	b8 00 00 00 00       	mov    $0x0,%eax
}
    121d:	c9                   	leaveq 
    121e:	c3                   	retq   

000000000000121f <gets>:

char*
gets(char *buf, int max)
{
    121f:	f3 0f 1e fa          	endbr64 
    1223:	55                   	push   %rbp
    1224:	48 89 e5             	mov    %rsp,%rbp
    1227:	48 83 ec 20          	sub    $0x20,%rsp
    122b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    122f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1232:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1239:	eb 4f                	jmp    128a <gets+0x6b>
    cc = read(0, &c, 1);
    123b:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    123f:	ba 01 00 00 00       	mov    $0x1,%edx
    1244:	48 89 c6             	mov    %rax,%rsi
    1247:	bf 00 00 00 00       	mov    $0x0,%edi
    124c:	48 b8 04 14 00 00 00 	movabs $0x1404,%rax
    1253:	00 00 00 
    1256:	ff d0                	callq  *%rax
    1258:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    125b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    125f:	7e 36                	jle    1297 <gets+0x78>
      break;
    buf[i++] = c;
    1261:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1264:	8d 50 01             	lea    0x1(%rax),%edx
    1267:	89 55 fc             	mov    %edx,-0x4(%rbp)
    126a:	48 63 d0             	movslq %eax,%rdx
    126d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1271:	48 01 c2             	add    %rax,%rdx
    1274:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1278:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    127a:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    127e:	3c 0a                	cmp    $0xa,%al
    1280:	74 16                	je     1298 <gets+0x79>
    1282:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1286:	3c 0d                	cmp    $0xd,%al
    1288:	74 0e                	je     1298 <gets+0x79>
  for(i=0; i+1 < max; ){
    128a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    128d:	83 c0 01             	add    $0x1,%eax
    1290:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    1293:	7f a6                	jg     123b <gets+0x1c>
    1295:	eb 01                	jmp    1298 <gets+0x79>
      break;
    1297:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1298:	8b 45 fc             	mov    -0x4(%rbp),%eax
    129b:	48 63 d0             	movslq %eax,%rdx
    129e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12a2:	48 01 d0             	add    %rdx,%rax
    12a5:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    12a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    12ac:	c9                   	leaveq 
    12ad:	c3                   	retq   

00000000000012ae <stat>:

int
stat(char *n, struct stat *st)
{
    12ae:	f3 0f 1e fa          	endbr64 
    12b2:	55                   	push   %rbp
    12b3:	48 89 e5             	mov    %rsp,%rbp
    12b6:	48 83 ec 20          	sub    $0x20,%rsp
    12ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12c6:	be 00 00 00 00       	mov    $0x0,%esi
    12cb:	48 89 c7             	mov    %rax,%rdi
    12ce:	48 b8 45 14 00 00 00 	movabs $0x1445,%rax
    12d5:	00 00 00 
    12d8:	ff d0                	callq  *%rax
    12da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    12dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    12e1:	79 07                	jns    12ea <stat+0x3c>
    return -1;
    12e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12e8:	eb 2f                	jmp    1319 <stat+0x6b>
  r = fstat(fd, st);
    12ea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    12ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12f1:	48 89 d6             	mov    %rdx,%rsi
    12f4:	89 c7                	mov    %eax,%edi
    12f6:	48 b8 6c 14 00 00 00 	movabs $0x146c,%rax
    12fd:	00 00 00 
    1300:	ff d0                	callq  *%rax
    1302:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1305:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1308:	89 c7                	mov    %eax,%edi
    130a:	48 b8 1e 14 00 00 00 	movabs $0x141e,%rax
    1311:	00 00 00 
    1314:	ff d0                	callq  *%rax
  return r;
    1316:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1319:	c9                   	leaveq 
    131a:	c3                   	retq   

000000000000131b <atoi>:

int
atoi(const char *s)
{
    131b:	f3 0f 1e fa          	endbr64 
    131f:	55                   	push   %rbp
    1320:	48 89 e5             	mov    %rsp,%rbp
    1323:	48 83 ec 18          	sub    $0x18,%rsp
    1327:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    132b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1332:	eb 28                	jmp    135c <atoi+0x41>
    n = n*10 + *s++ - '0';
    1334:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1337:	89 d0                	mov    %edx,%eax
    1339:	c1 e0 02             	shl    $0x2,%eax
    133c:	01 d0                	add    %edx,%eax
    133e:	01 c0                	add    %eax,%eax
    1340:	89 c1                	mov    %eax,%ecx
    1342:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1346:	48 8d 50 01          	lea    0x1(%rax),%rdx
    134a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    134e:	0f b6 00             	movzbl (%rax),%eax
    1351:	0f be c0             	movsbl %al,%eax
    1354:	01 c8                	add    %ecx,%eax
    1356:	83 e8 30             	sub    $0x30,%eax
    1359:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    135c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1360:	0f b6 00             	movzbl (%rax),%eax
    1363:	3c 2f                	cmp    $0x2f,%al
    1365:	7e 0b                	jle    1372 <atoi+0x57>
    1367:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    136b:	0f b6 00             	movzbl (%rax),%eax
    136e:	3c 39                	cmp    $0x39,%al
    1370:	7e c2                	jle    1334 <atoi+0x19>
  return n;
    1372:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1375:	c9                   	leaveq 
    1376:	c3                   	retq   

0000000000001377 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1377:	f3 0f 1e fa          	endbr64 
    137b:	55                   	push   %rbp
    137c:	48 89 e5             	mov    %rsp,%rbp
    137f:	48 83 ec 28          	sub    $0x28,%rsp
    1383:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1387:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    138b:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    138e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1392:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1396:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    139a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    139e:	eb 1d                	jmp    13bd <memmove+0x46>
    *dst++ = *src++;
    13a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    13a4:	48 8d 42 01          	lea    0x1(%rdx),%rax
    13a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    13ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13b0:	48 8d 48 01          	lea    0x1(%rax),%rcx
    13b4:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    13b8:	0f b6 12             	movzbl (%rdx),%edx
    13bb:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    13bd:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13c0:	8d 50 ff             	lea    -0x1(%rax),%edx
    13c3:	89 55 dc             	mov    %edx,-0x24(%rbp)
    13c6:	85 c0                	test   %eax,%eax
    13c8:	7f d6                	jg     13a0 <memmove+0x29>
  return vdst;
    13ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13ce:	c9                   	leaveq 
    13cf:	c3                   	retq   

00000000000013d0 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    13d0:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    13d7:	49 89 ca             	mov    %rcx,%r10
    13da:	0f 05                	syscall 
    13dc:	c3                   	retq   

00000000000013dd <exit>:
SYSCALL(exit)
    13dd:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    13e4:	49 89 ca             	mov    %rcx,%r10
    13e7:	0f 05                	syscall 
    13e9:	c3                   	retq   

00000000000013ea <wait>:
SYSCALL(wait)
    13ea:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    13f1:	49 89 ca             	mov    %rcx,%r10
    13f4:	0f 05                	syscall 
    13f6:	c3                   	retq   

00000000000013f7 <pipe>:
SYSCALL(pipe)
    13f7:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    13fe:	49 89 ca             	mov    %rcx,%r10
    1401:	0f 05                	syscall 
    1403:	c3                   	retq   

0000000000001404 <read>:
SYSCALL(read)
    1404:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    140b:	49 89 ca             	mov    %rcx,%r10
    140e:	0f 05                	syscall 
    1410:	c3                   	retq   

0000000000001411 <write>:
SYSCALL(write)
    1411:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    1418:	49 89 ca             	mov    %rcx,%r10
    141b:	0f 05                	syscall 
    141d:	c3                   	retq   

000000000000141e <close>:
SYSCALL(close)
    141e:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1425:	49 89 ca             	mov    %rcx,%r10
    1428:	0f 05                	syscall 
    142a:	c3                   	retq   

000000000000142b <kill>:
SYSCALL(kill)
    142b:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1432:	49 89 ca             	mov    %rcx,%r10
    1435:	0f 05                	syscall 
    1437:	c3                   	retq   

0000000000001438 <exec>:
SYSCALL(exec)
    1438:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    143f:	49 89 ca             	mov    %rcx,%r10
    1442:	0f 05                	syscall 
    1444:	c3                   	retq   

0000000000001445 <open>:
SYSCALL(open)
    1445:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    144c:	49 89 ca             	mov    %rcx,%r10
    144f:	0f 05                	syscall 
    1451:	c3                   	retq   

0000000000001452 <mknod>:
SYSCALL(mknod)
    1452:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1459:	49 89 ca             	mov    %rcx,%r10
    145c:	0f 05                	syscall 
    145e:	c3                   	retq   

000000000000145f <unlink>:
SYSCALL(unlink)
    145f:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1466:	49 89 ca             	mov    %rcx,%r10
    1469:	0f 05                	syscall 
    146b:	c3                   	retq   

000000000000146c <fstat>:
SYSCALL(fstat)
    146c:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1473:	49 89 ca             	mov    %rcx,%r10
    1476:	0f 05                	syscall 
    1478:	c3                   	retq   

0000000000001479 <link>:
SYSCALL(link)
    1479:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1480:	49 89 ca             	mov    %rcx,%r10
    1483:	0f 05                	syscall 
    1485:	c3                   	retq   

0000000000001486 <mkdir>:
SYSCALL(mkdir)
    1486:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    148d:	49 89 ca             	mov    %rcx,%r10
    1490:	0f 05                	syscall 
    1492:	c3                   	retq   

0000000000001493 <chdir>:
SYSCALL(chdir)
    1493:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    149a:	49 89 ca             	mov    %rcx,%r10
    149d:	0f 05                	syscall 
    149f:	c3                   	retq   

00000000000014a0 <dup>:
SYSCALL(dup)
    14a0:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    14a7:	49 89 ca             	mov    %rcx,%r10
    14aa:	0f 05                	syscall 
    14ac:	c3                   	retq   

00000000000014ad <getpid>:
SYSCALL(getpid)
    14ad:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    14b4:	49 89 ca             	mov    %rcx,%r10
    14b7:	0f 05                	syscall 
    14b9:	c3                   	retq   

00000000000014ba <sbrk>:
SYSCALL(sbrk)
    14ba:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    14c1:	49 89 ca             	mov    %rcx,%r10
    14c4:	0f 05                	syscall 
    14c6:	c3                   	retq   

00000000000014c7 <sleep>:
SYSCALL(sleep)
    14c7:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    14ce:	49 89 ca             	mov    %rcx,%r10
    14d1:	0f 05                	syscall 
    14d3:	c3                   	retq   

00000000000014d4 <uptime>:
SYSCALL(uptime)
    14d4:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    14db:	49 89 ca             	mov    %rcx,%r10
    14de:	0f 05                	syscall 
    14e0:	c3                   	retq   

00000000000014e1 <dedup>:
SYSCALL(dedup)
    14e1:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    14e8:	49 89 ca             	mov    %rcx,%r10
    14eb:	0f 05                	syscall 
    14ed:	c3                   	retq   

00000000000014ee <freepages>:
SYSCALL(freepages)
    14ee:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    14f5:	49 89 ca             	mov    %rcx,%r10
    14f8:	0f 05                	syscall 
    14fa:	c3                   	retq   

00000000000014fb <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    14fb:	f3 0f 1e fa          	endbr64 
    14ff:	55                   	push   %rbp
    1500:	48 89 e5             	mov    %rsp,%rbp
    1503:	48 83 ec 10          	sub    $0x10,%rsp
    1507:	89 7d fc             	mov    %edi,-0x4(%rbp)
    150a:	89 f0                	mov    %esi,%eax
    150c:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    150f:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1513:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1516:	ba 01 00 00 00       	mov    $0x1,%edx
    151b:	48 89 ce             	mov    %rcx,%rsi
    151e:	89 c7                	mov    %eax,%edi
    1520:	48 b8 11 14 00 00 00 	movabs $0x1411,%rax
    1527:	00 00 00 
    152a:	ff d0                	callq  *%rax
}
    152c:	90                   	nop
    152d:	c9                   	leaveq 
    152e:	c3                   	retq   

000000000000152f <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    152f:	f3 0f 1e fa          	endbr64 
    1533:	55                   	push   %rbp
    1534:	48 89 e5             	mov    %rsp,%rbp
    1537:	48 83 ec 20          	sub    $0x20,%rsp
    153b:	89 7d ec             	mov    %edi,-0x14(%rbp)
    153e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1542:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1549:	eb 35                	jmp    1580 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    154b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    154f:	48 c1 e8 3c          	shr    $0x3c,%rax
    1553:	48 ba 40 21 00 00 00 	movabs $0x2140,%rdx
    155a:	00 00 00 
    155d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1561:	0f be d0             	movsbl %al,%edx
    1564:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1567:	89 d6                	mov    %edx,%esi
    1569:	89 c7                	mov    %eax,%edi
    156b:	48 b8 fb 14 00 00 00 	movabs $0x14fb,%rax
    1572:	00 00 00 
    1575:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1577:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    157b:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1580:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1583:	83 f8 0f             	cmp    $0xf,%eax
    1586:	76 c3                	jbe    154b <print_x64+0x1c>
}
    1588:	90                   	nop
    1589:	90                   	nop
    158a:	c9                   	leaveq 
    158b:	c3                   	retq   

000000000000158c <print_x32>:

  static void
print_x32(int fd, uint x)
{
    158c:	f3 0f 1e fa          	endbr64 
    1590:	55                   	push   %rbp
    1591:	48 89 e5             	mov    %rsp,%rbp
    1594:	48 83 ec 20          	sub    $0x20,%rsp
    1598:	89 7d ec             	mov    %edi,-0x14(%rbp)
    159b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    159e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    15a5:	eb 36                	jmp    15dd <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    15a7:	8b 45 e8             	mov    -0x18(%rbp),%eax
    15aa:	c1 e8 1c             	shr    $0x1c,%eax
    15ad:	89 c2                	mov    %eax,%edx
    15af:	48 b8 40 21 00 00 00 	movabs $0x2140,%rax
    15b6:	00 00 00 
    15b9:	89 d2                	mov    %edx,%edx
    15bb:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    15bf:	0f be d0             	movsbl %al,%edx
    15c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15c5:	89 d6                	mov    %edx,%esi
    15c7:	89 c7                	mov    %eax,%edi
    15c9:	48 b8 fb 14 00 00 00 	movabs $0x14fb,%rax
    15d0:	00 00 00 
    15d3:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15d5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15d9:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    15dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15e0:	83 f8 07             	cmp    $0x7,%eax
    15e3:	76 c2                	jbe    15a7 <print_x32+0x1b>
}
    15e5:	90                   	nop
    15e6:	90                   	nop
    15e7:	c9                   	leaveq 
    15e8:	c3                   	retq   

00000000000015e9 <print_d>:

  static void
print_d(int fd, int v)
{
    15e9:	f3 0f 1e fa          	endbr64 
    15ed:	55                   	push   %rbp
    15ee:	48 89 e5             	mov    %rsp,%rbp
    15f1:	48 83 ec 30          	sub    $0x30,%rsp
    15f5:	89 7d dc             	mov    %edi,-0x24(%rbp)
    15f8:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    15fb:	8b 45 d8             	mov    -0x28(%rbp),%eax
    15fe:	48 98                	cltq   
    1600:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1604:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1608:	79 04                	jns    160e <print_d+0x25>
    x = -x;
    160a:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    160e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1615:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1619:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1620:	66 66 66 
    1623:	48 89 c8             	mov    %rcx,%rax
    1626:	48 f7 ea             	imul   %rdx
    1629:	48 c1 fa 02          	sar    $0x2,%rdx
    162d:	48 89 c8             	mov    %rcx,%rax
    1630:	48 c1 f8 3f          	sar    $0x3f,%rax
    1634:	48 29 c2             	sub    %rax,%rdx
    1637:	48 89 d0             	mov    %rdx,%rax
    163a:	48 c1 e0 02          	shl    $0x2,%rax
    163e:	48 01 d0             	add    %rdx,%rax
    1641:	48 01 c0             	add    %rax,%rax
    1644:	48 29 c1             	sub    %rax,%rcx
    1647:	48 89 ca             	mov    %rcx,%rdx
    164a:	8b 45 f4             	mov    -0xc(%rbp),%eax
    164d:	8d 48 01             	lea    0x1(%rax),%ecx
    1650:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1653:	48 b9 40 21 00 00 00 	movabs $0x2140,%rcx
    165a:	00 00 00 
    165d:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1661:	48 98                	cltq   
    1663:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1667:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    166b:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1672:	66 66 66 
    1675:	48 89 c8             	mov    %rcx,%rax
    1678:	48 f7 ea             	imul   %rdx
    167b:	48 c1 fa 02          	sar    $0x2,%rdx
    167f:	48 89 c8             	mov    %rcx,%rax
    1682:	48 c1 f8 3f          	sar    $0x3f,%rax
    1686:	48 29 c2             	sub    %rax,%rdx
    1689:	48 89 d0             	mov    %rdx,%rax
    168c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1690:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1695:	0f 85 7a ff ff ff    	jne    1615 <print_d+0x2c>

  if (v < 0)
    169b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    169f:	79 32                	jns    16d3 <print_d+0xea>
    buf[i++] = '-';
    16a1:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16a4:	8d 50 01             	lea    0x1(%rax),%edx
    16a7:	89 55 f4             	mov    %edx,-0xc(%rbp)
    16aa:	48 98                	cltq   
    16ac:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    16b1:	eb 20                	jmp    16d3 <print_d+0xea>
    putc(fd, buf[i]);
    16b3:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16b6:	48 98                	cltq   
    16b8:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    16bd:	0f be d0             	movsbl %al,%edx
    16c0:	8b 45 dc             	mov    -0x24(%rbp),%eax
    16c3:	89 d6                	mov    %edx,%esi
    16c5:	89 c7                	mov    %eax,%edi
    16c7:	48 b8 fb 14 00 00 00 	movabs $0x14fb,%rax
    16ce:	00 00 00 
    16d1:	ff d0                	callq  *%rax
  while (--i >= 0)
    16d3:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    16d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    16db:	79 d6                	jns    16b3 <print_d+0xca>
}
    16dd:	90                   	nop
    16de:	90                   	nop
    16df:	c9                   	leaveq 
    16e0:	c3                   	retq   

00000000000016e1 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    16e1:	f3 0f 1e fa          	endbr64 
    16e5:	55                   	push   %rbp
    16e6:	48 89 e5             	mov    %rsp,%rbp
    16e9:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    16f0:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    16f6:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    16fd:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1704:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    170b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1712:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1719:	84 c0                	test   %al,%al
    171b:	74 20                	je     173d <printf+0x5c>
    171d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1721:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1725:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1729:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    172d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1731:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1735:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1739:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    173d:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1744:	00 00 00 
    1747:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    174e:	00 00 00 
    1751:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1755:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    175c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1763:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    176a:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1771:	00 00 00 
    1774:	e9 41 03 00 00       	jmpq   1aba <printf+0x3d9>
    if (c != '%') {
    1779:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1780:	74 24                	je     17a6 <printf+0xc5>
      putc(fd, c);
    1782:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1788:	0f be d0             	movsbl %al,%edx
    178b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1791:	89 d6                	mov    %edx,%esi
    1793:	89 c7                	mov    %eax,%edi
    1795:	48 b8 fb 14 00 00 00 	movabs $0x14fb,%rax
    179c:	00 00 00 
    179f:	ff d0                	callq  *%rax
      continue;
    17a1:	e9 0d 03 00 00       	jmpq   1ab3 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    17a6:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    17ad:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    17b3:	48 63 d0             	movslq %eax,%rdx
    17b6:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    17bd:	48 01 d0             	add    %rdx,%rax
    17c0:	0f b6 00             	movzbl (%rax),%eax
    17c3:	0f be c0             	movsbl %al,%eax
    17c6:	25 ff 00 00 00       	and    $0xff,%eax
    17cb:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    17d1:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    17d8:	0f 84 0f 03 00 00    	je     1aed <printf+0x40c>
      break;
    switch(c) {
    17de:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17e5:	0f 84 74 02 00 00    	je     1a5f <printf+0x37e>
    17eb:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17f2:	0f 8c 82 02 00 00    	jl     1a7a <printf+0x399>
    17f8:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    17ff:	0f 8f 75 02 00 00    	jg     1a7a <printf+0x399>
    1805:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    180c:	0f 8c 68 02 00 00    	jl     1a7a <printf+0x399>
    1812:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1818:	83 e8 63             	sub    $0x63,%eax
    181b:	83 f8 15             	cmp    $0x15,%eax
    181e:	0f 87 56 02 00 00    	ja     1a7a <printf+0x399>
    1824:	89 c0                	mov    %eax,%eax
    1826:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    182d:	00 
    182e:	48 b8 18 1e 00 00 00 	movabs $0x1e18,%rax
    1835:	00 00 00 
    1838:	48 01 d0             	add    %rdx,%rax
    183b:	48 8b 00             	mov    (%rax),%rax
    183e:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1841:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1847:	83 f8 2f             	cmp    $0x2f,%eax
    184a:	77 23                	ja     186f <printf+0x18e>
    184c:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1853:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1859:	89 d2                	mov    %edx,%edx
    185b:	48 01 d0             	add    %rdx,%rax
    185e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1864:	83 c2 08             	add    $0x8,%edx
    1867:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    186d:	eb 12                	jmp    1881 <printf+0x1a0>
    186f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1876:	48 8d 50 08          	lea    0x8(%rax),%rdx
    187a:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1881:	8b 00                	mov    (%rax),%eax
    1883:	0f be d0             	movsbl %al,%edx
    1886:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    188c:	89 d6                	mov    %edx,%esi
    188e:	89 c7                	mov    %eax,%edi
    1890:	48 b8 fb 14 00 00 00 	movabs $0x14fb,%rax
    1897:	00 00 00 
    189a:	ff d0                	callq  *%rax
      break;
    189c:	e9 12 02 00 00       	jmpq   1ab3 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    18a1:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18a7:	83 f8 2f             	cmp    $0x2f,%eax
    18aa:	77 23                	ja     18cf <printf+0x1ee>
    18ac:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18b3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18b9:	89 d2                	mov    %edx,%edx
    18bb:	48 01 d0             	add    %rdx,%rax
    18be:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18c4:	83 c2 08             	add    $0x8,%edx
    18c7:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18cd:	eb 12                	jmp    18e1 <printf+0x200>
    18cf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18d6:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18da:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18e1:	8b 10                	mov    (%rax),%edx
    18e3:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18e9:	89 d6                	mov    %edx,%esi
    18eb:	89 c7                	mov    %eax,%edi
    18ed:	48 b8 e9 15 00 00 00 	movabs $0x15e9,%rax
    18f4:	00 00 00 
    18f7:	ff d0                	callq  *%rax
      break;
    18f9:	e9 b5 01 00 00       	jmpq   1ab3 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    18fe:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1904:	83 f8 2f             	cmp    $0x2f,%eax
    1907:	77 23                	ja     192c <printf+0x24b>
    1909:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1910:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1916:	89 d2                	mov    %edx,%edx
    1918:	48 01 d0             	add    %rdx,%rax
    191b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1921:	83 c2 08             	add    $0x8,%edx
    1924:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    192a:	eb 12                	jmp    193e <printf+0x25d>
    192c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1933:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1937:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    193e:	8b 10                	mov    (%rax),%edx
    1940:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1946:	89 d6                	mov    %edx,%esi
    1948:	89 c7                	mov    %eax,%edi
    194a:	48 b8 8c 15 00 00 00 	movabs $0x158c,%rax
    1951:	00 00 00 
    1954:	ff d0                	callq  *%rax
      break;
    1956:	e9 58 01 00 00       	jmpq   1ab3 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    195b:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1961:	83 f8 2f             	cmp    $0x2f,%eax
    1964:	77 23                	ja     1989 <printf+0x2a8>
    1966:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    196d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1973:	89 d2                	mov    %edx,%edx
    1975:	48 01 d0             	add    %rdx,%rax
    1978:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    197e:	83 c2 08             	add    $0x8,%edx
    1981:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1987:	eb 12                	jmp    199b <printf+0x2ba>
    1989:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1990:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1994:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    199b:	48 8b 10             	mov    (%rax),%rdx
    199e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19a4:	48 89 d6             	mov    %rdx,%rsi
    19a7:	89 c7                	mov    %eax,%edi
    19a9:	48 b8 2f 15 00 00 00 	movabs $0x152f,%rax
    19b0:	00 00 00 
    19b3:	ff d0                	callq  *%rax
      break;
    19b5:	e9 f9 00 00 00       	jmpq   1ab3 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    19ba:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19c0:	83 f8 2f             	cmp    $0x2f,%eax
    19c3:	77 23                	ja     19e8 <printf+0x307>
    19c5:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19cc:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19d2:	89 d2                	mov    %edx,%edx
    19d4:	48 01 d0             	add    %rdx,%rax
    19d7:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19dd:	83 c2 08             	add    $0x8,%edx
    19e0:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19e6:	eb 12                	jmp    19fa <printf+0x319>
    19e8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19ef:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19f3:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19fa:	48 8b 00             	mov    (%rax),%rax
    19fd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1a04:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1a0b:	00 
    1a0c:	75 41                	jne    1a4f <printf+0x36e>
        s = "(null)";
    1a0e:	48 b8 10 1e 00 00 00 	movabs $0x1e10,%rax
    1a15:	00 00 00 
    1a18:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1a1f:	eb 2e                	jmp    1a4f <printf+0x36e>
        putc(fd, *(s++));
    1a21:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a28:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a2c:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a33:	0f b6 00             	movzbl (%rax),%eax
    1a36:	0f be d0             	movsbl %al,%edx
    1a39:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a3f:	89 d6                	mov    %edx,%esi
    1a41:	89 c7                	mov    %eax,%edi
    1a43:	48 b8 fb 14 00 00 00 	movabs $0x14fb,%rax
    1a4a:	00 00 00 
    1a4d:	ff d0                	callq  *%rax
      while (*s)
    1a4f:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a56:	0f b6 00             	movzbl (%rax),%eax
    1a59:	84 c0                	test   %al,%al
    1a5b:	75 c4                	jne    1a21 <printf+0x340>
      break;
    1a5d:	eb 54                	jmp    1ab3 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1a5f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a65:	be 25 00 00 00       	mov    $0x25,%esi
    1a6a:	89 c7                	mov    %eax,%edi
    1a6c:	48 b8 fb 14 00 00 00 	movabs $0x14fb,%rax
    1a73:	00 00 00 
    1a76:	ff d0                	callq  *%rax
      break;
    1a78:	eb 39                	jmp    1ab3 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a7a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a80:	be 25 00 00 00       	mov    $0x25,%esi
    1a85:	89 c7                	mov    %eax,%edi
    1a87:	48 b8 fb 14 00 00 00 	movabs $0x14fb,%rax
    1a8e:	00 00 00 
    1a91:	ff d0                	callq  *%rax
      putc(fd, c);
    1a93:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1a99:	0f be d0             	movsbl %al,%edx
    1a9c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1aa2:	89 d6                	mov    %edx,%esi
    1aa4:	89 c7                	mov    %eax,%edi
    1aa6:	48 b8 fb 14 00 00 00 	movabs $0x14fb,%rax
    1aad:	00 00 00 
    1ab0:	ff d0                	callq  *%rax
      break;
    1ab2:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1ab3:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1aba:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1ac0:	48 63 d0             	movslq %eax,%rdx
    1ac3:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1aca:	48 01 d0             	add    %rdx,%rax
    1acd:	0f b6 00             	movzbl (%rax),%eax
    1ad0:	0f be c0             	movsbl %al,%eax
    1ad3:	25 ff 00 00 00       	and    $0xff,%eax
    1ad8:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1ade:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1ae5:	0f 85 8e fc ff ff    	jne    1779 <printf+0x98>
    }
  }
}
    1aeb:	eb 01                	jmp    1aee <printf+0x40d>
      break;
    1aed:	90                   	nop
}
    1aee:	90                   	nop
    1aef:	c9                   	leaveq 
    1af0:	c3                   	retq   

0000000000001af1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1af1:	f3 0f 1e fa          	endbr64 
    1af5:	55                   	push   %rbp
    1af6:	48 89 e5             	mov    %rsp,%rbp
    1af9:	48 83 ec 18          	sub    $0x18,%rsp
    1afd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1b01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b05:	48 83 e8 10          	sub    $0x10,%rax
    1b09:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b0d:	48 b8 70 21 00 00 00 	movabs $0x2170,%rax
    1b14:	00 00 00 
    1b17:	48 8b 00             	mov    (%rax),%rax
    1b1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b1e:	eb 2f                	jmp    1b4f <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1b20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b24:	48 8b 00             	mov    (%rax),%rax
    1b27:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b2b:	72 17                	jb     1b44 <free+0x53>
    1b2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b31:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b35:	77 2f                	ja     1b66 <free+0x75>
    1b37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b3b:	48 8b 00             	mov    (%rax),%rax
    1b3e:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b42:	72 22                	jb     1b66 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b48:	48 8b 00             	mov    (%rax),%rax
    1b4b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b53:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b57:	76 c7                	jbe    1b20 <free+0x2f>
    1b59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b5d:	48 8b 00             	mov    (%rax),%rax
    1b60:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b64:	73 ba                	jae    1b20 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b6a:	8b 40 08             	mov    0x8(%rax),%eax
    1b6d:	89 c0                	mov    %eax,%eax
    1b6f:	48 c1 e0 04          	shl    $0x4,%rax
    1b73:	48 89 c2             	mov    %rax,%rdx
    1b76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b7a:	48 01 c2             	add    %rax,%rdx
    1b7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b81:	48 8b 00             	mov    (%rax),%rax
    1b84:	48 39 c2             	cmp    %rax,%rdx
    1b87:	75 2d                	jne    1bb6 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1b89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b8d:	8b 50 08             	mov    0x8(%rax),%edx
    1b90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b94:	48 8b 00             	mov    (%rax),%rax
    1b97:	8b 40 08             	mov    0x8(%rax),%eax
    1b9a:	01 c2                	add    %eax,%edx
    1b9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ba0:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1ba3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ba7:	48 8b 00             	mov    (%rax),%rax
    1baa:	48 8b 10             	mov    (%rax),%rdx
    1bad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bb1:	48 89 10             	mov    %rdx,(%rax)
    1bb4:	eb 0e                	jmp    1bc4 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1bb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bba:	48 8b 10             	mov    (%rax),%rdx
    1bbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bc1:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1bc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bc8:	8b 40 08             	mov    0x8(%rax),%eax
    1bcb:	89 c0                	mov    %eax,%eax
    1bcd:	48 c1 e0 04          	shl    $0x4,%rax
    1bd1:	48 89 c2             	mov    %rax,%rdx
    1bd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bd8:	48 01 d0             	add    %rdx,%rax
    1bdb:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1bdf:	75 27                	jne    1c08 <free+0x117>
    p->s.size += bp->s.size;
    1be1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1be5:	8b 50 08             	mov    0x8(%rax),%edx
    1be8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bec:	8b 40 08             	mov    0x8(%rax),%eax
    1bef:	01 c2                	add    %eax,%edx
    1bf1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bf5:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1bf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bfc:	48 8b 10             	mov    (%rax),%rdx
    1bff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c03:	48 89 10             	mov    %rdx,(%rax)
    1c06:	eb 0b                	jmp    1c13 <free+0x122>
  } else
    p->s.ptr = bp;
    1c08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c0c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1c10:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1c13:	48 ba 70 21 00 00 00 	movabs $0x2170,%rdx
    1c1a:	00 00 00 
    1c1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c21:	48 89 02             	mov    %rax,(%rdx)
}
    1c24:	90                   	nop
    1c25:	c9                   	leaveq 
    1c26:	c3                   	retq   

0000000000001c27 <morecore>:

static Header*
morecore(uint nu)
{
    1c27:	f3 0f 1e fa          	endbr64 
    1c2b:	55                   	push   %rbp
    1c2c:	48 89 e5             	mov    %rsp,%rbp
    1c2f:	48 83 ec 20          	sub    $0x20,%rsp
    1c33:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c36:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c3d:	77 07                	ja     1c46 <morecore+0x1f>
    nu = 4096;
    1c3f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c46:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c49:	48 c1 e0 04          	shl    $0x4,%rax
    1c4d:	48 89 c7             	mov    %rax,%rdi
    1c50:	48 b8 ba 14 00 00 00 	movabs $0x14ba,%rax
    1c57:	00 00 00 
    1c5a:	ff d0                	callq  *%rax
    1c5c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c60:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c65:	75 07                	jne    1c6e <morecore+0x47>
    return 0;
    1c67:	b8 00 00 00 00       	mov    $0x0,%eax
    1c6c:	eb 36                	jmp    1ca4 <morecore+0x7d>
  hp = (Header*)p;
    1c6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c72:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c7a:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1c7d:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1c80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c84:	48 83 c0 10          	add    $0x10,%rax
    1c88:	48 89 c7             	mov    %rax,%rdi
    1c8b:	48 b8 f1 1a 00 00 00 	movabs $0x1af1,%rax
    1c92:	00 00 00 
    1c95:	ff d0                	callq  *%rax
  return freep;
    1c97:	48 b8 70 21 00 00 00 	movabs $0x2170,%rax
    1c9e:	00 00 00 
    1ca1:	48 8b 00             	mov    (%rax),%rax
}
    1ca4:	c9                   	leaveq 
    1ca5:	c3                   	retq   

0000000000001ca6 <malloc>:

void*
malloc(uint nbytes)
{
    1ca6:	f3 0f 1e fa          	endbr64 
    1caa:	55                   	push   %rbp
    1cab:	48 89 e5             	mov    %rsp,%rbp
    1cae:	48 83 ec 30          	sub    $0x30,%rsp
    1cb2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1cb5:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1cb8:	48 83 c0 0f          	add    $0xf,%rax
    1cbc:	48 c1 e8 04          	shr    $0x4,%rax
    1cc0:	83 c0 01             	add    $0x1,%eax
    1cc3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1cc6:	48 b8 70 21 00 00 00 	movabs $0x2170,%rax
    1ccd:	00 00 00 
    1cd0:	48 8b 00             	mov    (%rax),%rax
    1cd3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cd7:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1cdc:	75 4a                	jne    1d28 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1cde:	48 b8 60 21 00 00 00 	movabs $0x2160,%rax
    1ce5:	00 00 00 
    1ce8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cec:	48 ba 70 21 00 00 00 	movabs $0x2170,%rdx
    1cf3:	00 00 00 
    1cf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cfa:	48 89 02             	mov    %rax,(%rdx)
    1cfd:	48 b8 70 21 00 00 00 	movabs $0x2170,%rax
    1d04:	00 00 00 
    1d07:	48 8b 00             	mov    (%rax),%rax
    1d0a:	48 ba 60 21 00 00 00 	movabs $0x2160,%rdx
    1d11:	00 00 00 
    1d14:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1d17:	48 b8 60 21 00 00 00 	movabs $0x2160,%rax
    1d1e:	00 00 00 
    1d21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d2c:	48 8b 00             	mov    (%rax),%rax
    1d2f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d37:	8b 40 08             	mov    0x8(%rax),%eax
    1d3a:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d3d:	77 65                	ja     1da4 <malloc+0xfe>
      if(p->s.size == nunits)
    1d3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d43:	8b 40 08             	mov    0x8(%rax),%eax
    1d46:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d49:	75 10                	jne    1d5b <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1d4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d4f:	48 8b 10             	mov    (%rax),%rdx
    1d52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d56:	48 89 10             	mov    %rdx,(%rax)
    1d59:	eb 2e                	jmp    1d89 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1d5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d5f:	8b 40 08             	mov    0x8(%rax),%eax
    1d62:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d65:	89 c2                	mov    %eax,%edx
    1d67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d6b:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1d6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d72:	8b 40 08             	mov    0x8(%rax),%eax
    1d75:	89 c0                	mov    %eax,%eax
    1d77:	48 c1 e0 04          	shl    $0x4,%rax
    1d7b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d83:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d86:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1d89:	48 ba 70 21 00 00 00 	movabs $0x2170,%rdx
    1d90:	00 00 00 
    1d93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d97:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1d9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d9e:	48 83 c0 10          	add    $0x10,%rax
    1da2:	eb 4e                	jmp    1df2 <malloc+0x14c>
    }
    if(p == freep)
    1da4:	48 b8 70 21 00 00 00 	movabs $0x2170,%rax
    1dab:	00 00 00 
    1dae:	48 8b 00             	mov    (%rax),%rax
    1db1:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1db5:	75 23                	jne    1dda <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1db7:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1dba:	89 c7                	mov    %eax,%edi
    1dbc:	48 b8 27 1c 00 00 00 	movabs $0x1c27,%rax
    1dc3:	00 00 00 
    1dc6:	ff d0                	callq  *%rax
    1dc8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1dcc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1dd1:	75 07                	jne    1dda <malloc+0x134>
        return 0;
    1dd3:	b8 00 00 00 00       	mov    $0x0,%eax
    1dd8:	eb 18                	jmp    1df2 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1dda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dde:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1de2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1de6:	48 8b 00             	mov    (%rax),%rax
    1de9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1ded:	e9 41 ff ff ff       	jmpq   1d33 <malloc+0x8d>
  }
}
    1df2:	c9                   	leaveq 
    1df3:	c3                   	retq   
