
_echo:     file format elf64-x86-64


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
    1008:	48 83 ec 20          	sub    $0x20,%rsp
    100c:	89 7d ec             	mov    %edi,-0x14(%rbp)
    100f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;

  for(i = 1; i < argc; i++)
    1013:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    101a:	eb 61                	jmp    107d <main+0x7d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
    101c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    101f:	83 c0 01             	add    $0x1,%eax
    1022:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1025:	7e 0c                	jle    1033 <main+0x33>
    1027:	48 b8 f0 1d 00 00 00 	movabs $0x1df0,%rax
    102e:	00 00 00 
    1031:	eb 0a                	jmp    103d <main+0x3d>
    1033:	48 b8 f2 1d 00 00 00 	movabs $0x1df2,%rax
    103a:	00 00 00 
    103d:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1040:	48 63 d2             	movslq %edx,%rdx
    1043:	48 8d 0c d5 00 00 00 	lea    0x0(,%rdx,8),%rcx
    104a:	00 
    104b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    104f:	48 01 ca             	add    %rcx,%rdx
    1052:	48 8b 12             	mov    (%rdx),%rdx
    1055:	48 89 c1             	mov    %rax,%rcx
    1058:	48 be f4 1d 00 00 00 	movabs $0x1df4,%rsi
    105f:	00 00 00 
    1062:	bf 01 00 00 00       	mov    $0x1,%edi
    1067:	b8 00 00 00 00       	mov    $0x0,%eax
    106c:	49 b8 d8 16 00 00 00 	movabs $0x16d8,%r8
    1073:	00 00 00 
    1076:	41 ff d0             	callq  *%r8
  for(i = 1; i < argc; i++)
    1079:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    107d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1080:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1083:	7c 97                	jl     101c <main+0x1c>
  exit();
    1085:	48 b8 d4 13 00 00 00 	movabs $0x13d4,%rax
    108c:	00 00 00 
    108f:	ff d0                	callq  *%rax

0000000000001091 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1091:	f3 0f 1e fa          	endbr64 
    1095:	55                   	push   %rbp
    1096:	48 89 e5             	mov    %rsp,%rbp
    1099:	48 83 ec 10          	sub    $0x10,%rsp
    109d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10a1:	89 75 f4             	mov    %esi,-0xc(%rbp)
    10a4:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    10a7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    10ab:	8b 55 f0             	mov    -0x10(%rbp),%edx
    10ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
    10b1:	48 89 ce             	mov    %rcx,%rsi
    10b4:	48 89 f7             	mov    %rsi,%rdi
    10b7:	89 d1                	mov    %edx,%ecx
    10b9:	fc                   	cld    
    10ba:	f3 aa                	rep stos %al,%es:(%rdi)
    10bc:	89 ca                	mov    %ecx,%edx
    10be:	48 89 fe             	mov    %rdi,%rsi
    10c1:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    10c5:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10c8:	90                   	nop
    10c9:	c9                   	leaveq 
    10ca:	c3                   	retq   

00000000000010cb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10cb:	f3 0f 1e fa          	endbr64 
    10cf:	55                   	push   %rbp
    10d0:	48 89 e5             	mov    %rsp,%rbp
    10d3:	48 83 ec 20          	sub    $0x20,%rsp
    10d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    10db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    10df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    10e7:	90                   	nop
    10e8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    10ec:	48 8d 42 01          	lea    0x1(%rdx),%rax
    10f0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    10f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10f8:	48 8d 48 01          	lea    0x1(%rax),%rcx
    10fc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1100:	0f b6 12             	movzbl (%rdx),%edx
    1103:	88 10                	mov    %dl,(%rax)
    1105:	0f b6 00             	movzbl (%rax),%eax
    1108:	84 c0                	test   %al,%al
    110a:	75 dc                	jne    10e8 <strcpy+0x1d>
    ;
  return os;
    110c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1110:	c9                   	leaveq 
    1111:	c3                   	retq   

0000000000001112 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1112:	f3 0f 1e fa          	endbr64 
    1116:	55                   	push   %rbp
    1117:	48 89 e5             	mov    %rsp,%rbp
    111a:	48 83 ec 10          	sub    $0x10,%rsp
    111e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1122:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1126:	eb 0a                	jmp    1132 <strcmp+0x20>
    p++, q++;
    1128:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    112d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1132:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1136:	0f b6 00             	movzbl (%rax),%eax
    1139:	84 c0                	test   %al,%al
    113b:	74 12                	je     114f <strcmp+0x3d>
    113d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1141:	0f b6 10             	movzbl (%rax),%edx
    1144:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1148:	0f b6 00             	movzbl (%rax),%eax
    114b:	38 c2                	cmp    %al,%dl
    114d:	74 d9                	je     1128 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    114f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1153:	0f b6 00             	movzbl (%rax),%eax
    1156:	0f b6 d0             	movzbl %al,%edx
    1159:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    115d:	0f b6 00             	movzbl (%rax),%eax
    1160:	0f b6 c0             	movzbl %al,%eax
    1163:	29 c2                	sub    %eax,%edx
    1165:	89 d0                	mov    %edx,%eax
}
    1167:	c9                   	leaveq 
    1168:	c3                   	retq   

0000000000001169 <strlen>:

uint
strlen(char *s)
{
    1169:	f3 0f 1e fa          	endbr64 
    116d:	55                   	push   %rbp
    116e:	48 89 e5             	mov    %rsp,%rbp
    1171:	48 83 ec 18          	sub    $0x18,%rsp
    1175:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1179:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1180:	eb 04                	jmp    1186 <strlen+0x1d>
    1182:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1186:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1189:	48 63 d0             	movslq %eax,%rdx
    118c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1190:	48 01 d0             	add    %rdx,%rax
    1193:	0f b6 00             	movzbl (%rax),%eax
    1196:	84 c0                	test   %al,%al
    1198:	75 e8                	jne    1182 <strlen+0x19>
    ;
  return n;
    119a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    119d:	c9                   	leaveq 
    119e:	c3                   	retq   

000000000000119f <memset>:

void*
memset(void *dst, int c, uint n)
{
    119f:	f3 0f 1e fa          	endbr64 
    11a3:	55                   	push   %rbp
    11a4:	48 89 e5             	mov    %rsp,%rbp
    11a7:	48 83 ec 10          	sub    $0x10,%rsp
    11ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11af:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11b2:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    11b5:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11b8:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    11bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11bf:	89 ce                	mov    %ecx,%esi
    11c1:	48 89 c7             	mov    %rax,%rdi
    11c4:	48 b8 91 10 00 00 00 	movabs $0x1091,%rax
    11cb:	00 00 00 
    11ce:	ff d0                	callq  *%rax
  return dst;
    11d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    11d4:	c9                   	leaveq 
    11d5:	c3                   	retq   

00000000000011d6 <strchr>:

char*
strchr(const char *s, char c)
{
    11d6:	f3 0f 1e fa          	endbr64 
    11da:	55                   	push   %rbp
    11db:	48 89 e5             	mov    %rsp,%rbp
    11de:	48 83 ec 10          	sub    $0x10,%rsp
    11e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11e6:	89 f0                	mov    %esi,%eax
    11e8:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    11eb:	eb 17                	jmp    1204 <strchr+0x2e>
    if(*s == c)
    11ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11f1:	0f b6 00             	movzbl (%rax),%eax
    11f4:	38 45 f4             	cmp    %al,-0xc(%rbp)
    11f7:	75 06                	jne    11ff <strchr+0x29>
      return (char*)s;
    11f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11fd:	eb 15                	jmp    1214 <strchr+0x3e>
  for(; *s; s++)
    11ff:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1204:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1208:	0f b6 00             	movzbl (%rax),%eax
    120b:	84 c0                	test   %al,%al
    120d:	75 de                	jne    11ed <strchr+0x17>
  return 0;
    120f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1214:	c9                   	leaveq 
    1215:	c3                   	retq   

0000000000001216 <gets>:

char*
gets(char *buf, int max)
{
    1216:	f3 0f 1e fa          	endbr64 
    121a:	55                   	push   %rbp
    121b:	48 89 e5             	mov    %rsp,%rbp
    121e:	48 83 ec 20          	sub    $0x20,%rsp
    1222:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1226:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1229:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1230:	eb 4f                	jmp    1281 <gets+0x6b>
    cc = read(0, &c, 1);
    1232:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1236:	ba 01 00 00 00       	mov    $0x1,%edx
    123b:	48 89 c6             	mov    %rax,%rsi
    123e:	bf 00 00 00 00       	mov    $0x0,%edi
    1243:	48 b8 fb 13 00 00 00 	movabs $0x13fb,%rax
    124a:	00 00 00 
    124d:	ff d0                	callq  *%rax
    124f:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1252:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1256:	7e 36                	jle    128e <gets+0x78>
      break;
    buf[i++] = c;
    1258:	8b 45 fc             	mov    -0x4(%rbp),%eax
    125b:	8d 50 01             	lea    0x1(%rax),%edx
    125e:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1261:	48 63 d0             	movslq %eax,%rdx
    1264:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1268:	48 01 c2             	add    %rax,%rdx
    126b:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    126f:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1271:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1275:	3c 0a                	cmp    $0xa,%al
    1277:	74 16                	je     128f <gets+0x79>
    1279:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    127d:	3c 0d                	cmp    $0xd,%al
    127f:	74 0e                	je     128f <gets+0x79>
  for(i=0; i+1 < max; ){
    1281:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1284:	83 c0 01             	add    $0x1,%eax
    1287:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    128a:	7f a6                	jg     1232 <gets+0x1c>
    128c:	eb 01                	jmp    128f <gets+0x79>
      break;
    128e:	90                   	nop
      break;
  }
  buf[i] = '\0';
    128f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1292:	48 63 d0             	movslq %eax,%rdx
    1295:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1299:	48 01 d0             	add    %rdx,%rax
    129c:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    129f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    12a3:	c9                   	leaveq 
    12a4:	c3                   	retq   

00000000000012a5 <stat>:

int
stat(char *n, struct stat *st)
{
    12a5:	f3 0f 1e fa          	endbr64 
    12a9:	55                   	push   %rbp
    12aa:	48 89 e5             	mov    %rsp,%rbp
    12ad:	48 83 ec 20          	sub    $0x20,%rsp
    12b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12bd:	be 00 00 00 00       	mov    $0x0,%esi
    12c2:	48 89 c7             	mov    %rax,%rdi
    12c5:	48 b8 3c 14 00 00 00 	movabs $0x143c,%rax
    12cc:	00 00 00 
    12cf:	ff d0                	callq  *%rax
    12d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    12d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    12d8:	79 07                	jns    12e1 <stat+0x3c>
    return -1;
    12da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12df:	eb 2f                	jmp    1310 <stat+0x6b>
  r = fstat(fd, st);
    12e1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    12e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12e8:	48 89 d6             	mov    %rdx,%rsi
    12eb:	89 c7                	mov    %eax,%edi
    12ed:	48 b8 63 14 00 00 00 	movabs $0x1463,%rax
    12f4:	00 00 00 
    12f7:	ff d0                	callq  *%rax
    12f9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    12fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12ff:	89 c7                	mov    %eax,%edi
    1301:	48 b8 15 14 00 00 00 	movabs $0x1415,%rax
    1308:	00 00 00 
    130b:	ff d0                	callq  *%rax
  return r;
    130d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1310:	c9                   	leaveq 
    1311:	c3                   	retq   

0000000000001312 <atoi>:

int
atoi(const char *s)
{
    1312:	f3 0f 1e fa          	endbr64 
    1316:	55                   	push   %rbp
    1317:	48 89 e5             	mov    %rsp,%rbp
    131a:	48 83 ec 18          	sub    $0x18,%rsp
    131e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1322:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1329:	eb 28                	jmp    1353 <atoi+0x41>
    n = n*10 + *s++ - '0';
    132b:	8b 55 fc             	mov    -0x4(%rbp),%edx
    132e:	89 d0                	mov    %edx,%eax
    1330:	c1 e0 02             	shl    $0x2,%eax
    1333:	01 d0                	add    %edx,%eax
    1335:	01 c0                	add    %eax,%eax
    1337:	89 c1                	mov    %eax,%ecx
    1339:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    133d:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1341:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1345:	0f b6 00             	movzbl (%rax),%eax
    1348:	0f be c0             	movsbl %al,%eax
    134b:	01 c8                	add    %ecx,%eax
    134d:	83 e8 30             	sub    $0x30,%eax
    1350:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1353:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1357:	0f b6 00             	movzbl (%rax),%eax
    135a:	3c 2f                	cmp    $0x2f,%al
    135c:	7e 0b                	jle    1369 <atoi+0x57>
    135e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1362:	0f b6 00             	movzbl (%rax),%eax
    1365:	3c 39                	cmp    $0x39,%al
    1367:	7e c2                	jle    132b <atoi+0x19>
  return n;
    1369:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    136c:	c9                   	leaveq 
    136d:	c3                   	retq   

000000000000136e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    136e:	f3 0f 1e fa          	endbr64 
    1372:	55                   	push   %rbp
    1373:	48 89 e5             	mov    %rsp,%rbp
    1376:	48 83 ec 28          	sub    $0x28,%rsp
    137a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    137e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1382:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1389:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    138d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1391:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1395:	eb 1d                	jmp    13b4 <memmove+0x46>
    *dst++ = *src++;
    1397:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    139b:	48 8d 42 01          	lea    0x1(%rdx),%rax
    139f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    13a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13a7:	48 8d 48 01          	lea    0x1(%rax),%rcx
    13ab:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    13af:	0f b6 12             	movzbl (%rdx),%edx
    13b2:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    13b4:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13b7:	8d 50 ff             	lea    -0x1(%rax),%edx
    13ba:	89 55 dc             	mov    %edx,-0x24(%rbp)
    13bd:	85 c0                	test   %eax,%eax
    13bf:	7f d6                	jg     1397 <memmove+0x29>
  return vdst;
    13c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13c5:	c9                   	leaveq 
    13c6:	c3                   	retq   

00000000000013c7 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    13c7:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    13ce:	49 89 ca             	mov    %rcx,%r10
    13d1:	0f 05                	syscall 
    13d3:	c3                   	retq   

00000000000013d4 <exit>:
SYSCALL(exit)
    13d4:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    13db:	49 89 ca             	mov    %rcx,%r10
    13de:	0f 05                	syscall 
    13e0:	c3                   	retq   

00000000000013e1 <wait>:
SYSCALL(wait)
    13e1:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    13e8:	49 89 ca             	mov    %rcx,%r10
    13eb:	0f 05                	syscall 
    13ed:	c3                   	retq   

00000000000013ee <pipe>:
SYSCALL(pipe)
    13ee:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    13f5:	49 89 ca             	mov    %rcx,%r10
    13f8:	0f 05                	syscall 
    13fa:	c3                   	retq   

00000000000013fb <read>:
SYSCALL(read)
    13fb:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    1402:	49 89 ca             	mov    %rcx,%r10
    1405:	0f 05                	syscall 
    1407:	c3                   	retq   

0000000000001408 <write>:
SYSCALL(write)
    1408:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    140f:	49 89 ca             	mov    %rcx,%r10
    1412:	0f 05                	syscall 
    1414:	c3                   	retq   

0000000000001415 <close>:
SYSCALL(close)
    1415:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    141c:	49 89 ca             	mov    %rcx,%r10
    141f:	0f 05                	syscall 
    1421:	c3                   	retq   

0000000000001422 <kill>:
SYSCALL(kill)
    1422:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1429:	49 89 ca             	mov    %rcx,%r10
    142c:	0f 05                	syscall 
    142e:	c3                   	retq   

000000000000142f <exec>:
SYSCALL(exec)
    142f:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1436:	49 89 ca             	mov    %rcx,%r10
    1439:	0f 05                	syscall 
    143b:	c3                   	retq   

000000000000143c <open>:
SYSCALL(open)
    143c:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1443:	49 89 ca             	mov    %rcx,%r10
    1446:	0f 05                	syscall 
    1448:	c3                   	retq   

0000000000001449 <mknod>:
SYSCALL(mknod)
    1449:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1450:	49 89 ca             	mov    %rcx,%r10
    1453:	0f 05                	syscall 
    1455:	c3                   	retq   

0000000000001456 <unlink>:
SYSCALL(unlink)
    1456:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    145d:	49 89 ca             	mov    %rcx,%r10
    1460:	0f 05                	syscall 
    1462:	c3                   	retq   

0000000000001463 <fstat>:
SYSCALL(fstat)
    1463:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    146a:	49 89 ca             	mov    %rcx,%r10
    146d:	0f 05                	syscall 
    146f:	c3                   	retq   

0000000000001470 <link>:
SYSCALL(link)
    1470:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1477:	49 89 ca             	mov    %rcx,%r10
    147a:	0f 05                	syscall 
    147c:	c3                   	retq   

000000000000147d <mkdir>:
SYSCALL(mkdir)
    147d:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1484:	49 89 ca             	mov    %rcx,%r10
    1487:	0f 05                	syscall 
    1489:	c3                   	retq   

000000000000148a <chdir>:
SYSCALL(chdir)
    148a:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1491:	49 89 ca             	mov    %rcx,%r10
    1494:	0f 05                	syscall 
    1496:	c3                   	retq   

0000000000001497 <dup>:
SYSCALL(dup)
    1497:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    149e:	49 89 ca             	mov    %rcx,%r10
    14a1:	0f 05                	syscall 
    14a3:	c3                   	retq   

00000000000014a4 <getpid>:
SYSCALL(getpid)
    14a4:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    14ab:	49 89 ca             	mov    %rcx,%r10
    14ae:	0f 05                	syscall 
    14b0:	c3                   	retq   

00000000000014b1 <sbrk>:
SYSCALL(sbrk)
    14b1:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    14b8:	49 89 ca             	mov    %rcx,%r10
    14bb:	0f 05                	syscall 
    14bd:	c3                   	retq   

00000000000014be <sleep>:
SYSCALL(sleep)
    14be:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    14c5:	49 89 ca             	mov    %rcx,%r10
    14c8:	0f 05                	syscall 
    14ca:	c3                   	retq   

00000000000014cb <uptime>:
SYSCALL(uptime)
    14cb:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    14d2:	49 89 ca             	mov    %rcx,%r10
    14d5:	0f 05                	syscall 
    14d7:	c3                   	retq   

00000000000014d8 <dedup>:
SYSCALL(dedup)
    14d8:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    14df:	49 89 ca             	mov    %rcx,%r10
    14e2:	0f 05                	syscall 
    14e4:	c3                   	retq   

00000000000014e5 <freepages>:
SYSCALL(freepages)
    14e5:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    14ec:	49 89 ca             	mov    %rcx,%r10
    14ef:	0f 05                	syscall 
    14f1:	c3                   	retq   

00000000000014f2 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    14f2:	f3 0f 1e fa          	endbr64 
    14f6:	55                   	push   %rbp
    14f7:	48 89 e5             	mov    %rsp,%rbp
    14fa:	48 83 ec 10          	sub    $0x10,%rsp
    14fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
    1501:	89 f0                	mov    %esi,%eax
    1503:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1506:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    150a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    150d:	ba 01 00 00 00       	mov    $0x1,%edx
    1512:	48 89 ce             	mov    %rcx,%rsi
    1515:	89 c7                	mov    %eax,%edi
    1517:	48 b8 08 14 00 00 00 	movabs $0x1408,%rax
    151e:	00 00 00 
    1521:	ff d0                	callq  *%rax
}
    1523:	90                   	nop
    1524:	c9                   	leaveq 
    1525:	c3                   	retq   

0000000000001526 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1526:	f3 0f 1e fa          	endbr64 
    152a:	55                   	push   %rbp
    152b:	48 89 e5             	mov    %rsp,%rbp
    152e:	48 83 ec 20          	sub    $0x20,%rsp
    1532:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1535:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1539:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1540:	eb 35                	jmp    1577 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1542:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1546:	48 c1 e8 3c          	shr    $0x3c,%rax
    154a:	48 ba 30 21 00 00 00 	movabs $0x2130,%rdx
    1551:	00 00 00 
    1554:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1558:	0f be d0             	movsbl %al,%edx
    155b:	8b 45 ec             	mov    -0x14(%rbp),%eax
    155e:	89 d6                	mov    %edx,%esi
    1560:	89 c7                	mov    %eax,%edi
    1562:	48 b8 f2 14 00 00 00 	movabs $0x14f2,%rax
    1569:	00 00 00 
    156c:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    156e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1572:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1577:	8b 45 fc             	mov    -0x4(%rbp),%eax
    157a:	83 f8 0f             	cmp    $0xf,%eax
    157d:	76 c3                	jbe    1542 <print_x64+0x1c>
}
    157f:	90                   	nop
    1580:	90                   	nop
    1581:	c9                   	leaveq 
    1582:	c3                   	retq   

0000000000001583 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1583:	f3 0f 1e fa          	endbr64 
    1587:	55                   	push   %rbp
    1588:	48 89 e5             	mov    %rsp,%rbp
    158b:	48 83 ec 20          	sub    $0x20,%rsp
    158f:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1592:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1595:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    159c:	eb 36                	jmp    15d4 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    159e:	8b 45 e8             	mov    -0x18(%rbp),%eax
    15a1:	c1 e8 1c             	shr    $0x1c,%eax
    15a4:	89 c2                	mov    %eax,%edx
    15a6:	48 b8 30 21 00 00 00 	movabs $0x2130,%rax
    15ad:	00 00 00 
    15b0:	89 d2                	mov    %edx,%edx
    15b2:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    15b6:	0f be d0             	movsbl %al,%edx
    15b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15bc:	89 d6                	mov    %edx,%esi
    15be:	89 c7                	mov    %eax,%edi
    15c0:	48 b8 f2 14 00 00 00 	movabs $0x14f2,%rax
    15c7:	00 00 00 
    15ca:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15cc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15d0:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    15d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15d7:	83 f8 07             	cmp    $0x7,%eax
    15da:	76 c2                	jbe    159e <print_x32+0x1b>
}
    15dc:	90                   	nop
    15dd:	90                   	nop
    15de:	c9                   	leaveq 
    15df:	c3                   	retq   

00000000000015e0 <print_d>:

  static void
print_d(int fd, int v)
{
    15e0:	f3 0f 1e fa          	endbr64 
    15e4:	55                   	push   %rbp
    15e5:	48 89 e5             	mov    %rsp,%rbp
    15e8:	48 83 ec 30          	sub    $0x30,%rsp
    15ec:	89 7d dc             	mov    %edi,-0x24(%rbp)
    15ef:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    15f2:	8b 45 d8             	mov    -0x28(%rbp),%eax
    15f5:	48 98                	cltq   
    15f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    15fb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    15ff:	79 04                	jns    1605 <print_d+0x25>
    x = -x;
    1601:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1605:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    160c:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1610:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1617:	66 66 66 
    161a:	48 89 c8             	mov    %rcx,%rax
    161d:	48 f7 ea             	imul   %rdx
    1620:	48 c1 fa 02          	sar    $0x2,%rdx
    1624:	48 89 c8             	mov    %rcx,%rax
    1627:	48 c1 f8 3f          	sar    $0x3f,%rax
    162b:	48 29 c2             	sub    %rax,%rdx
    162e:	48 89 d0             	mov    %rdx,%rax
    1631:	48 c1 e0 02          	shl    $0x2,%rax
    1635:	48 01 d0             	add    %rdx,%rax
    1638:	48 01 c0             	add    %rax,%rax
    163b:	48 29 c1             	sub    %rax,%rcx
    163e:	48 89 ca             	mov    %rcx,%rdx
    1641:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1644:	8d 48 01             	lea    0x1(%rax),%ecx
    1647:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    164a:	48 b9 30 21 00 00 00 	movabs $0x2130,%rcx
    1651:	00 00 00 
    1654:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1658:	48 98                	cltq   
    165a:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    165e:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1662:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1669:	66 66 66 
    166c:	48 89 c8             	mov    %rcx,%rax
    166f:	48 f7 ea             	imul   %rdx
    1672:	48 c1 fa 02          	sar    $0x2,%rdx
    1676:	48 89 c8             	mov    %rcx,%rax
    1679:	48 c1 f8 3f          	sar    $0x3f,%rax
    167d:	48 29 c2             	sub    %rax,%rdx
    1680:	48 89 d0             	mov    %rdx,%rax
    1683:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1687:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    168c:	0f 85 7a ff ff ff    	jne    160c <print_d+0x2c>

  if (v < 0)
    1692:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1696:	79 32                	jns    16ca <print_d+0xea>
    buf[i++] = '-';
    1698:	8b 45 f4             	mov    -0xc(%rbp),%eax
    169b:	8d 50 01             	lea    0x1(%rax),%edx
    169e:	89 55 f4             	mov    %edx,-0xc(%rbp)
    16a1:	48 98                	cltq   
    16a3:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    16a8:	eb 20                	jmp    16ca <print_d+0xea>
    putc(fd, buf[i]);
    16aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16ad:	48 98                	cltq   
    16af:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    16b4:	0f be d0             	movsbl %al,%edx
    16b7:	8b 45 dc             	mov    -0x24(%rbp),%eax
    16ba:	89 d6                	mov    %edx,%esi
    16bc:	89 c7                	mov    %eax,%edi
    16be:	48 b8 f2 14 00 00 00 	movabs $0x14f2,%rax
    16c5:	00 00 00 
    16c8:	ff d0                	callq  *%rax
  while (--i >= 0)
    16ca:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    16ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    16d2:	79 d6                	jns    16aa <print_d+0xca>
}
    16d4:	90                   	nop
    16d5:	90                   	nop
    16d6:	c9                   	leaveq 
    16d7:	c3                   	retq   

00000000000016d8 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    16d8:	f3 0f 1e fa          	endbr64 
    16dc:	55                   	push   %rbp
    16dd:	48 89 e5             	mov    %rsp,%rbp
    16e0:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    16e7:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    16ed:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    16f4:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    16fb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1702:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1709:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1710:	84 c0                	test   %al,%al
    1712:	74 20                	je     1734 <printf+0x5c>
    1714:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1718:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    171c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1720:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1724:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1728:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    172c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1730:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1734:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    173b:	00 00 00 
    173e:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1745:	00 00 00 
    1748:	48 8d 45 10          	lea    0x10(%rbp),%rax
    174c:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1753:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    175a:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1761:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1768:	00 00 00 
    176b:	e9 41 03 00 00       	jmpq   1ab1 <printf+0x3d9>
    if (c != '%') {
    1770:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1777:	74 24                	je     179d <printf+0xc5>
      putc(fd, c);
    1779:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    177f:	0f be d0             	movsbl %al,%edx
    1782:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1788:	89 d6                	mov    %edx,%esi
    178a:	89 c7                	mov    %eax,%edi
    178c:	48 b8 f2 14 00 00 00 	movabs $0x14f2,%rax
    1793:	00 00 00 
    1796:	ff d0                	callq  *%rax
      continue;
    1798:	e9 0d 03 00 00       	jmpq   1aaa <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    179d:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    17a4:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    17aa:	48 63 d0             	movslq %eax,%rdx
    17ad:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    17b4:	48 01 d0             	add    %rdx,%rax
    17b7:	0f b6 00             	movzbl (%rax),%eax
    17ba:	0f be c0             	movsbl %al,%eax
    17bd:	25 ff 00 00 00       	and    $0xff,%eax
    17c2:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    17c8:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    17cf:	0f 84 0f 03 00 00    	je     1ae4 <printf+0x40c>
      break;
    switch(c) {
    17d5:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17dc:	0f 84 74 02 00 00    	je     1a56 <printf+0x37e>
    17e2:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17e9:	0f 8c 82 02 00 00    	jl     1a71 <printf+0x399>
    17ef:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    17f6:	0f 8f 75 02 00 00    	jg     1a71 <printf+0x399>
    17fc:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1803:	0f 8c 68 02 00 00    	jl     1a71 <printf+0x399>
    1809:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    180f:	83 e8 63             	sub    $0x63,%eax
    1812:	83 f8 15             	cmp    $0x15,%eax
    1815:	0f 87 56 02 00 00    	ja     1a71 <printf+0x399>
    181b:	89 c0                	mov    %eax,%eax
    181d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1824:	00 
    1825:	48 b8 08 1e 00 00 00 	movabs $0x1e08,%rax
    182c:	00 00 00 
    182f:	48 01 d0             	add    %rdx,%rax
    1832:	48 8b 00             	mov    (%rax),%rax
    1835:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1838:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    183e:	83 f8 2f             	cmp    $0x2f,%eax
    1841:	77 23                	ja     1866 <printf+0x18e>
    1843:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    184a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1850:	89 d2                	mov    %edx,%edx
    1852:	48 01 d0             	add    %rdx,%rax
    1855:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    185b:	83 c2 08             	add    $0x8,%edx
    185e:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1864:	eb 12                	jmp    1878 <printf+0x1a0>
    1866:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    186d:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1871:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1878:	8b 00                	mov    (%rax),%eax
    187a:	0f be d0             	movsbl %al,%edx
    187d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1883:	89 d6                	mov    %edx,%esi
    1885:	89 c7                	mov    %eax,%edi
    1887:	48 b8 f2 14 00 00 00 	movabs $0x14f2,%rax
    188e:	00 00 00 
    1891:	ff d0                	callq  *%rax
      break;
    1893:	e9 12 02 00 00       	jmpq   1aaa <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1898:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    189e:	83 f8 2f             	cmp    $0x2f,%eax
    18a1:	77 23                	ja     18c6 <printf+0x1ee>
    18a3:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18aa:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18b0:	89 d2                	mov    %edx,%edx
    18b2:	48 01 d0             	add    %rdx,%rax
    18b5:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18bb:	83 c2 08             	add    $0x8,%edx
    18be:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18c4:	eb 12                	jmp    18d8 <printf+0x200>
    18c6:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18cd:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18d1:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18d8:	8b 10                	mov    (%rax),%edx
    18da:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18e0:	89 d6                	mov    %edx,%esi
    18e2:	89 c7                	mov    %eax,%edi
    18e4:	48 b8 e0 15 00 00 00 	movabs $0x15e0,%rax
    18eb:	00 00 00 
    18ee:	ff d0                	callq  *%rax
      break;
    18f0:	e9 b5 01 00 00       	jmpq   1aaa <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    18f5:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18fb:	83 f8 2f             	cmp    $0x2f,%eax
    18fe:	77 23                	ja     1923 <printf+0x24b>
    1900:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1907:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    190d:	89 d2                	mov    %edx,%edx
    190f:	48 01 d0             	add    %rdx,%rax
    1912:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1918:	83 c2 08             	add    $0x8,%edx
    191b:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1921:	eb 12                	jmp    1935 <printf+0x25d>
    1923:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    192a:	48 8d 50 08          	lea    0x8(%rax),%rdx
    192e:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1935:	8b 10                	mov    (%rax),%edx
    1937:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    193d:	89 d6                	mov    %edx,%esi
    193f:	89 c7                	mov    %eax,%edi
    1941:	48 b8 83 15 00 00 00 	movabs $0x1583,%rax
    1948:	00 00 00 
    194b:	ff d0                	callq  *%rax
      break;
    194d:	e9 58 01 00 00       	jmpq   1aaa <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1952:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1958:	83 f8 2f             	cmp    $0x2f,%eax
    195b:	77 23                	ja     1980 <printf+0x2a8>
    195d:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1964:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    196a:	89 d2                	mov    %edx,%edx
    196c:	48 01 d0             	add    %rdx,%rax
    196f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1975:	83 c2 08             	add    $0x8,%edx
    1978:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    197e:	eb 12                	jmp    1992 <printf+0x2ba>
    1980:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1987:	48 8d 50 08          	lea    0x8(%rax),%rdx
    198b:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1992:	48 8b 10             	mov    (%rax),%rdx
    1995:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    199b:	48 89 d6             	mov    %rdx,%rsi
    199e:	89 c7                	mov    %eax,%edi
    19a0:	48 b8 26 15 00 00 00 	movabs $0x1526,%rax
    19a7:	00 00 00 
    19aa:	ff d0                	callq  *%rax
      break;
    19ac:	e9 f9 00 00 00       	jmpq   1aaa <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    19b1:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19b7:	83 f8 2f             	cmp    $0x2f,%eax
    19ba:	77 23                	ja     19df <printf+0x307>
    19bc:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19c3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19c9:	89 d2                	mov    %edx,%edx
    19cb:	48 01 d0             	add    %rdx,%rax
    19ce:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19d4:	83 c2 08             	add    $0x8,%edx
    19d7:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19dd:	eb 12                	jmp    19f1 <printf+0x319>
    19df:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19e6:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19ea:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19f1:	48 8b 00             	mov    (%rax),%rax
    19f4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    19fb:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1a02:	00 
    1a03:	75 41                	jne    1a46 <printf+0x36e>
        s = "(null)";
    1a05:	48 b8 00 1e 00 00 00 	movabs $0x1e00,%rax
    1a0c:	00 00 00 
    1a0f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1a16:	eb 2e                	jmp    1a46 <printf+0x36e>
        putc(fd, *(s++));
    1a18:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a1f:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a23:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a2a:	0f b6 00             	movzbl (%rax),%eax
    1a2d:	0f be d0             	movsbl %al,%edx
    1a30:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a36:	89 d6                	mov    %edx,%esi
    1a38:	89 c7                	mov    %eax,%edi
    1a3a:	48 b8 f2 14 00 00 00 	movabs $0x14f2,%rax
    1a41:	00 00 00 
    1a44:	ff d0                	callq  *%rax
      while (*s)
    1a46:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a4d:	0f b6 00             	movzbl (%rax),%eax
    1a50:	84 c0                	test   %al,%al
    1a52:	75 c4                	jne    1a18 <printf+0x340>
      break;
    1a54:	eb 54                	jmp    1aaa <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1a56:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a5c:	be 25 00 00 00       	mov    $0x25,%esi
    1a61:	89 c7                	mov    %eax,%edi
    1a63:	48 b8 f2 14 00 00 00 	movabs $0x14f2,%rax
    1a6a:	00 00 00 
    1a6d:	ff d0                	callq  *%rax
      break;
    1a6f:	eb 39                	jmp    1aaa <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a71:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a77:	be 25 00 00 00       	mov    $0x25,%esi
    1a7c:	89 c7                	mov    %eax,%edi
    1a7e:	48 b8 f2 14 00 00 00 	movabs $0x14f2,%rax
    1a85:	00 00 00 
    1a88:	ff d0                	callq  *%rax
      putc(fd, c);
    1a8a:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1a90:	0f be d0             	movsbl %al,%edx
    1a93:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a99:	89 d6                	mov    %edx,%esi
    1a9b:	89 c7                	mov    %eax,%edi
    1a9d:	48 b8 f2 14 00 00 00 	movabs $0x14f2,%rax
    1aa4:	00 00 00 
    1aa7:	ff d0                	callq  *%rax
      break;
    1aa9:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1aaa:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1ab1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1ab7:	48 63 d0             	movslq %eax,%rdx
    1aba:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1ac1:	48 01 d0             	add    %rdx,%rax
    1ac4:	0f b6 00             	movzbl (%rax),%eax
    1ac7:	0f be c0             	movsbl %al,%eax
    1aca:	25 ff 00 00 00       	and    $0xff,%eax
    1acf:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1ad5:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1adc:	0f 85 8e fc ff ff    	jne    1770 <printf+0x98>
    }
  }
}
    1ae2:	eb 01                	jmp    1ae5 <printf+0x40d>
      break;
    1ae4:	90                   	nop
}
    1ae5:	90                   	nop
    1ae6:	c9                   	leaveq 
    1ae7:	c3                   	retq   

0000000000001ae8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1ae8:	f3 0f 1e fa          	endbr64 
    1aec:	55                   	push   %rbp
    1aed:	48 89 e5             	mov    %rsp,%rbp
    1af0:	48 83 ec 18          	sub    $0x18,%rsp
    1af4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1af8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1afc:	48 83 e8 10          	sub    $0x10,%rax
    1b00:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b04:	48 b8 60 21 00 00 00 	movabs $0x2160,%rax
    1b0b:	00 00 00 
    1b0e:	48 8b 00             	mov    (%rax),%rax
    1b11:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b15:	eb 2f                	jmp    1b46 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1b17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b1b:	48 8b 00             	mov    (%rax),%rax
    1b1e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b22:	72 17                	jb     1b3b <free+0x53>
    1b24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b28:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b2c:	77 2f                	ja     1b5d <free+0x75>
    1b2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b32:	48 8b 00             	mov    (%rax),%rax
    1b35:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b39:	72 22                	jb     1b5d <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b3f:	48 8b 00             	mov    (%rax),%rax
    1b42:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b4a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b4e:	76 c7                	jbe    1b17 <free+0x2f>
    1b50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b54:	48 8b 00             	mov    (%rax),%rax
    1b57:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b5b:	73 ba                	jae    1b17 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b61:	8b 40 08             	mov    0x8(%rax),%eax
    1b64:	89 c0                	mov    %eax,%eax
    1b66:	48 c1 e0 04          	shl    $0x4,%rax
    1b6a:	48 89 c2             	mov    %rax,%rdx
    1b6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b71:	48 01 c2             	add    %rax,%rdx
    1b74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b78:	48 8b 00             	mov    (%rax),%rax
    1b7b:	48 39 c2             	cmp    %rax,%rdx
    1b7e:	75 2d                	jne    1bad <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1b80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b84:	8b 50 08             	mov    0x8(%rax),%edx
    1b87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b8b:	48 8b 00             	mov    (%rax),%rax
    1b8e:	8b 40 08             	mov    0x8(%rax),%eax
    1b91:	01 c2                	add    %eax,%edx
    1b93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b97:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1b9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b9e:	48 8b 00             	mov    (%rax),%rax
    1ba1:	48 8b 10             	mov    (%rax),%rdx
    1ba4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ba8:	48 89 10             	mov    %rdx,(%rax)
    1bab:	eb 0e                	jmp    1bbb <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1bad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bb1:	48 8b 10             	mov    (%rax),%rdx
    1bb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bb8:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1bbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bbf:	8b 40 08             	mov    0x8(%rax),%eax
    1bc2:	89 c0                	mov    %eax,%eax
    1bc4:	48 c1 e0 04          	shl    $0x4,%rax
    1bc8:	48 89 c2             	mov    %rax,%rdx
    1bcb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bcf:	48 01 d0             	add    %rdx,%rax
    1bd2:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1bd6:	75 27                	jne    1bff <free+0x117>
    p->s.size += bp->s.size;
    1bd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bdc:	8b 50 08             	mov    0x8(%rax),%edx
    1bdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1be3:	8b 40 08             	mov    0x8(%rax),%eax
    1be6:	01 c2                	add    %eax,%edx
    1be8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bec:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1bef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bf3:	48 8b 10             	mov    (%rax),%rdx
    1bf6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bfa:	48 89 10             	mov    %rdx,(%rax)
    1bfd:	eb 0b                	jmp    1c0a <free+0x122>
  } else
    p->s.ptr = bp;
    1bff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1c07:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1c0a:	48 ba 60 21 00 00 00 	movabs $0x2160,%rdx
    1c11:	00 00 00 
    1c14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c18:	48 89 02             	mov    %rax,(%rdx)
}
    1c1b:	90                   	nop
    1c1c:	c9                   	leaveq 
    1c1d:	c3                   	retq   

0000000000001c1e <morecore>:

static Header*
morecore(uint nu)
{
    1c1e:	f3 0f 1e fa          	endbr64 
    1c22:	55                   	push   %rbp
    1c23:	48 89 e5             	mov    %rsp,%rbp
    1c26:	48 83 ec 20          	sub    $0x20,%rsp
    1c2a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c2d:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c34:	77 07                	ja     1c3d <morecore+0x1f>
    nu = 4096;
    1c36:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c3d:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c40:	48 c1 e0 04          	shl    $0x4,%rax
    1c44:	48 89 c7             	mov    %rax,%rdi
    1c47:	48 b8 b1 14 00 00 00 	movabs $0x14b1,%rax
    1c4e:	00 00 00 
    1c51:	ff d0                	callq  *%rax
    1c53:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c57:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c5c:	75 07                	jne    1c65 <morecore+0x47>
    return 0;
    1c5e:	b8 00 00 00 00       	mov    $0x0,%eax
    1c63:	eb 36                	jmp    1c9b <morecore+0x7d>
  hp = (Header*)p;
    1c65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c69:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c71:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1c74:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1c77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c7b:	48 83 c0 10          	add    $0x10,%rax
    1c7f:	48 89 c7             	mov    %rax,%rdi
    1c82:	48 b8 e8 1a 00 00 00 	movabs $0x1ae8,%rax
    1c89:	00 00 00 
    1c8c:	ff d0                	callq  *%rax
  return freep;
    1c8e:	48 b8 60 21 00 00 00 	movabs $0x2160,%rax
    1c95:	00 00 00 
    1c98:	48 8b 00             	mov    (%rax),%rax
}
    1c9b:	c9                   	leaveq 
    1c9c:	c3                   	retq   

0000000000001c9d <malloc>:

void*
malloc(uint nbytes)
{
    1c9d:	f3 0f 1e fa          	endbr64 
    1ca1:	55                   	push   %rbp
    1ca2:	48 89 e5             	mov    %rsp,%rbp
    1ca5:	48 83 ec 30          	sub    $0x30,%rsp
    1ca9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1cac:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1caf:	48 83 c0 0f          	add    $0xf,%rax
    1cb3:	48 c1 e8 04          	shr    $0x4,%rax
    1cb7:	83 c0 01             	add    $0x1,%eax
    1cba:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1cbd:	48 b8 60 21 00 00 00 	movabs $0x2160,%rax
    1cc4:	00 00 00 
    1cc7:	48 8b 00             	mov    (%rax),%rax
    1cca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cce:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1cd3:	75 4a                	jne    1d1f <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1cd5:	48 b8 50 21 00 00 00 	movabs $0x2150,%rax
    1cdc:	00 00 00 
    1cdf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1ce3:	48 ba 60 21 00 00 00 	movabs $0x2160,%rdx
    1cea:	00 00 00 
    1ced:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cf1:	48 89 02             	mov    %rax,(%rdx)
    1cf4:	48 b8 60 21 00 00 00 	movabs $0x2160,%rax
    1cfb:	00 00 00 
    1cfe:	48 8b 00             	mov    (%rax),%rax
    1d01:	48 ba 50 21 00 00 00 	movabs $0x2150,%rdx
    1d08:	00 00 00 
    1d0b:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1d0e:	48 b8 50 21 00 00 00 	movabs $0x2150,%rax
    1d15:	00 00 00 
    1d18:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d23:	48 8b 00             	mov    (%rax),%rax
    1d26:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d2e:	8b 40 08             	mov    0x8(%rax),%eax
    1d31:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d34:	77 65                	ja     1d9b <malloc+0xfe>
      if(p->s.size == nunits)
    1d36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d3a:	8b 40 08             	mov    0x8(%rax),%eax
    1d3d:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d40:	75 10                	jne    1d52 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1d42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d46:	48 8b 10             	mov    (%rax),%rdx
    1d49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d4d:	48 89 10             	mov    %rdx,(%rax)
    1d50:	eb 2e                	jmp    1d80 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1d52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d56:	8b 40 08             	mov    0x8(%rax),%eax
    1d59:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d5c:	89 c2                	mov    %eax,%edx
    1d5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d62:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1d65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d69:	8b 40 08             	mov    0x8(%rax),%eax
    1d6c:	89 c0                	mov    %eax,%eax
    1d6e:	48 c1 e0 04          	shl    $0x4,%rax
    1d72:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d7a:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d7d:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1d80:	48 ba 60 21 00 00 00 	movabs $0x2160,%rdx
    1d87:	00 00 00 
    1d8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d8e:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1d91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d95:	48 83 c0 10          	add    $0x10,%rax
    1d99:	eb 4e                	jmp    1de9 <malloc+0x14c>
    }
    if(p == freep)
    1d9b:	48 b8 60 21 00 00 00 	movabs $0x2160,%rax
    1da2:	00 00 00 
    1da5:	48 8b 00             	mov    (%rax),%rax
    1da8:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1dac:	75 23                	jne    1dd1 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1dae:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1db1:	89 c7                	mov    %eax,%edi
    1db3:	48 b8 1e 1c 00 00 00 	movabs $0x1c1e,%rax
    1dba:	00 00 00 
    1dbd:	ff d0                	callq  *%rax
    1dbf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1dc3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1dc8:	75 07                	jne    1dd1 <malloc+0x134>
        return 0;
    1dca:	b8 00 00 00 00       	mov    $0x0,%eax
    1dcf:	eb 18                	jmp    1de9 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1dd1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dd5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1dd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ddd:	48 8b 00             	mov    (%rax),%rax
    1de0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1de4:	e9 41 ff ff ff       	jmpq   1d2a <malloc+0x8d>
  }
}
    1de9:	c9                   	leaveq 
    1dea:	c3                   	retq   
