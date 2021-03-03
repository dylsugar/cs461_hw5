
_rm:     file format elf64-x86-64


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

  if(argc < 2){
    1013:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
    1017:	7f 2c                	jg     1045 <main+0x45>
    printf(2, "Usage: rm files...\n");
    1019:	48 be 28 1e 00 00 00 	movabs $0x1e28,%rsi
    1020:	00 00 00 
    1023:	bf 02 00 00 00       	mov    $0x2,%edi
    1028:	b8 00 00 00 00       	mov    $0x0,%eax
    102d:	48 ba 13 17 00 00 00 	movabs $0x1713,%rdx
    1034:	00 00 00 
    1037:	ff d2                	callq  *%rdx
    exit();
    1039:	48 b8 0f 14 00 00 00 	movabs $0x140f,%rax
    1040:	00 00 00 
    1043:	ff d0                	callq  *%rax
  }

  for(i = 1; i < argc; i++){
    1045:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    104c:	eb 6a                	jmp    10b8 <main+0xb8>
    if(unlink(argv[i]) < 0){
    104e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1051:	48 98                	cltq   
    1053:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    105a:	00 
    105b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    105f:	48 01 d0             	add    %rdx,%rax
    1062:	48 8b 00             	mov    (%rax),%rax
    1065:	48 89 c7             	mov    %rax,%rdi
    1068:	48 b8 91 14 00 00 00 	movabs $0x1491,%rax
    106f:	00 00 00 
    1072:	ff d0                	callq  *%rax
    1074:	85 c0                	test   %eax,%eax
    1076:	79 3c                	jns    10b4 <main+0xb4>
      printf(2, "rm: %s failed to delete\n", argv[i]);
    1078:	8b 45 fc             	mov    -0x4(%rbp),%eax
    107b:	48 98                	cltq   
    107d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1084:	00 
    1085:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1089:	48 01 d0             	add    %rdx,%rax
    108c:	48 8b 00             	mov    (%rax),%rax
    108f:	48 89 c2             	mov    %rax,%rdx
    1092:	48 be 3c 1e 00 00 00 	movabs $0x1e3c,%rsi
    1099:	00 00 00 
    109c:	bf 02 00 00 00       	mov    $0x2,%edi
    10a1:	b8 00 00 00 00       	mov    $0x0,%eax
    10a6:	48 b9 13 17 00 00 00 	movabs $0x1713,%rcx
    10ad:	00 00 00 
    10b0:	ff d1                	callq  *%rcx
      break;
    10b2:	eb 0c                	jmp    10c0 <main+0xc0>
  for(i = 1; i < argc; i++){
    10b4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    10b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10bb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    10be:	7c 8e                	jl     104e <main+0x4e>
    }
  }

  exit();
    10c0:	48 b8 0f 14 00 00 00 	movabs $0x140f,%rax
    10c7:	00 00 00 
    10ca:	ff d0                	callq  *%rax

00000000000010cc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    10cc:	f3 0f 1e fa          	endbr64 
    10d0:	55                   	push   %rbp
    10d1:	48 89 e5             	mov    %rsp,%rbp
    10d4:	48 83 ec 10          	sub    $0x10,%rsp
    10d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10dc:	89 75 f4             	mov    %esi,-0xc(%rbp)
    10df:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    10e2:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    10e6:	8b 55 f0             	mov    -0x10(%rbp),%edx
    10e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
    10ec:	48 89 ce             	mov    %rcx,%rsi
    10ef:	48 89 f7             	mov    %rsi,%rdi
    10f2:	89 d1                	mov    %edx,%ecx
    10f4:	fc                   	cld    
    10f5:	f3 aa                	rep stos %al,%es:(%rdi)
    10f7:	89 ca                	mov    %ecx,%edx
    10f9:	48 89 fe             	mov    %rdi,%rsi
    10fc:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    1100:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1103:	90                   	nop
    1104:	c9                   	leaveq 
    1105:	c3                   	retq   

0000000000001106 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1106:	f3 0f 1e fa          	endbr64 
    110a:	55                   	push   %rbp
    110b:	48 89 e5             	mov    %rsp,%rbp
    110e:	48 83 ec 20          	sub    $0x20,%rsp
    1112:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1116:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    111a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    111e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1122:	90                   	nop
    1123:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1127:	48 8d 42 01          	lea    0x1(%rdx),%rax
    112b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    112f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1133:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1137:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    113b:	0f b6 12             	movzbl (%rdx),%edx
    113e:	88 10                	mov    %dl,(%rax)
    1140:	0f b6 00             	movzbl (%rax),%eax
    1143:	84 c0                	test   %al,%al
    1145:	75 dc                	jne    1123 <strcpy+0x1d>
    ;
  return os;
    1147:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    114b:	c9                   	leaveq 
    114c:	c3                   	retq   

000000000000114d <strcmp>:

int
strcmp(const char *p, const char *q)
{
    114d:	f3 0f 1e fa          	endbr64 
    1151:	55                   	push   %rbp
    1152:	48 89 e5             	mov    %rsp,%rbp
    1155:	48 83 ec 10          	sub    $0x10,%rsp
    1159:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    115d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1161:	eb 0a                	jmp    116d <strcmp+0x20>
    p++, q++;
    1163:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1168:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    116d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1171:	0f b6 00             	movzbl (%rax),%eax
    1174:	84 c0                	test   %al,%al
    1176:	74 12                	je     118a <strcmp+0x3d>
    1178:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    117c:	0f b6 10             	movzbl (%rax),%edx
    117f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1183:	0f b6 00             	movzbl (%rax),%eax
    1186:	38 c2                	cmp    %al,%dl
    1188:	74 d9                	je     1163 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    118a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    118e:	0f b6 00             	movzbl (%rax),%eax
    1191:	0f b6 d0             	movzbl %al,%edx
    1194:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1198:	0f b6 00             	movzbl (%rax),%eax
    119b:	0f b6 c0             	movzbl %al,%eax
    119e:	29 c2                	sub    %eax,%edx
    11a0:	89 d0                	mov    %edx,%eax
}
    11a2:	c9                   	leaveq 
    11a3:	c3                   	retq   

00000000000011a4 <strlen>:

uint
strlen(char *s)
{
    11a4:	f3 0f 1e fa          	endbr64 
    11a8:	55                   	push   %rbp
    11a9:	48 89 e5             	mov    %rsp,%rbp
    11ac:	48 83 ec 18          	sub    $0x18,%rsp
    11b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    11b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    11bb:	eb 04                	jmp    11c1 <strlen+0x1d>
    11bd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    11c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11c4:	48 63 d0             	movslq %eax,%rdx
    11c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11cb:	48 01 d0             	add    %rdx,%rax
    11ce:	0f b6 00             	movzbl (%rax),%eax
    11d1:	84 c0                	test   %al,%al
    11d3:	75 e8                	jne    11bd <strlen+0x19>
    ;
  return n;
    11d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    11d8:	c9                   	leaveq 
    11d9:	c3                   	retq   

00000000000011da <memset>:

void*
memset(void *dst, int c, uint n)
{
    11da:	f3 0f 1e fa          	endbr64 
    11de:	55                   	push   %rbp
    11df:	48 89 e5             	mov    %rsp,%rbp
    11e2:	48 83 ec 10          	sub    $0x10,%rsp
    11e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11ea:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11ed:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    11f0:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11f3:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    11f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11fa:	89 ce                	mov    %ecx,%esi
    11fc:	48 89 c7             	mov    %rax,%rdi
    11ff:	48 b8 cc 10 00 00 00 	movabs $0x10cc,%rax
    1206:	00 00 00 
    1209:	ff d0                	callq  *%rax
  return dst;
    120b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    120f:	c9                   	leaveq 
    1210:	c3                   	retq   

0000000000001211 <strchr>:

char*
strchr(const char *s, char c)
{
    1211:	f3 0f 1e fa          	endbr64 
    1215:	55                   	push   %rbp
    1216:	48 89 e5             	mov    %rsp,%rbp
    1219:	48 83 ec 10          	sub    $0x10,%rsp
    121d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1221:	89 f0                	mov    %esi,%eax
    1223:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1226:	eb 17                	jmp    123f <strchr+0x2e>
    if(*s == c)
    1228:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    122c:	0f b6 00             	movzbl (%rax),%eax
    122f:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1232:	75 06                	jne    123a <strchr+0x29>
      return (char*)s;
    1234:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1238:	eb 15                	jmp    124f <strchr+0x3e>
  for(; *s; s++)
    123a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    123f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1243:	0f b6 00             	movzbl (%rax),%eax
    1246:	84 c0                	test   %al,%al
    1248:	75 de                	jne    1228 <strchr+0x17>
  return 0;
    124a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    124f:	c9                   	leaveq 
    1250:	c3                   	retq   

0000000000001251 <gets>:

char*
gets(char *buf, int max)
{
    1251:	f3 0f 1e fa          	endbr64 
    1255:	55                   	push   %rbp
    1256:	48 89 e5             	mov    %rsp,%rbp
    1259:	48 83 ec 20          	sub    $0x20,%rsp
    125d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1261:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1264:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    126b:	eb 4f                	jmp    12bc <gets+0x6b>
    cc = read(0, &c, 1);
    126d:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1271:	ba 01 00 00 00       	mov    $0x1,%edx
    1276:	48 89 c6             	mov    %rax,%rsi
    1279:	bf 00 00 00 00       	mov    $0x0,%edi
    127e:	48 b8 36 14 00 00 00 	movabs $0x1436,%rax
    1285:	00 00 00 
    1288:	ff d0                	callq  *%rax
    128a:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    128d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1291:	7e 36                	jle    12c9 <gets+0x78>
      break;
    buf[i++] = c;
    1293:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1296:	8d 50 01             	lea    0x1(%rax),%edx
    1299:	89 55 fc             	mov    %edx,-0x4(%rbp)
    129c:	48 63 d0             	movslq %eax,%rdx
    129f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12a3:	48 01 c2             	add    %rax,%rdx
    12a6:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    12aa:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    12ac:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    12b0:	3c 0a                	cmp    $0xa,%al
    12b2:	74 16                	je     12ca <gets+0x79>
    12b4:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    12b8:	3c 0d                	cmp    $0xd,%al
    12ba:	74 0e                	je     12ca <gets+0x79>
  for(i=0; i+1 < max; ){
    12bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12bf:	83 c0 01             	add    $0x1,%eax
    12c2:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    12c5:	7f a6                	jg     126d <gets+0x1c>
    12c7:	eb 01                	jmp    12ca <gets+0x79>
      break;
    12c9:	90                   	nop
      break;
  }
  buf[i] = '\0';
    12ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12cd:	48 63 d0             	movslq %eax,%rdx
    12d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12d4:	48 01 d0             	add    %rdx,%rax
    12d7:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    12da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    12de:	c9                   	leaveq 
    12df:	c3                   	retq   

00000000000012e0 <stat>:

int
stat(char *n, struct stat *st)
{
    12e0:	f3 0f 1e fa          	endbr64 
    12e4:	55                   	push   %rbp
    12e5:	48 89 e5             	mov    %rsp,%rbp
    12e8:	48 83 ec 20          	sub    $0x20,%rsp
    12ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12f8:	be 00 00 00 00       	mov    $0x0,%esi
    12fd:	48 89 c7             	mov    %rax,%rdi
    1300:	48 b8 77 14 00 00 00 	movabs $0x1477,%rax
    1307:	00 00 00 
    130a:	ff d0                	callq  *%rax
    130c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    130f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1313:	79 07                	jns    131c <stat+0x3c>
    return -1;
    1315:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    131a:	eb 2f                	jmp    134b <stat+0x6b>
  r = fstat(fd, st);
    131c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1320:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1323:	48 89 d6             	mov    %rdx,%rsi
    1326:	89 c7                	mov    %eax,%edi
    1328:	48 b8 9e 14 00 00 00 	movabs $0x149e,%rax
    132f:	00 00 00 
    1332:	ff d0                	callq  *%rax
    1334:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1337:	8b 45 fc             	mov    -0x4(%rbp),%eax
    133a:	89 c7                	mov    %eax,%edi
    133c:	48 b8 50 14 00 00 00 	movabs $0x1450,%rax
    1343:	00 00 00 
    1346:	ff d0                	callq  *%rax
  return r;
    1348:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    134b:	c9                   	leaveq 
    134c:	c3                   	retq   

000000000000134d <atoi>:

int
atoi(const char *s)
{
    134d:	f3 0f 1e fa          	endbr64 
    1351:	55                   	push   %rbp
    1352:	48 89 e5             	mov    %rsp,%rbp
    1355:	48 83 ec 18          	sub    $0x18,%rsp
    1359:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    135d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1364:	eb 28                	jmp    138e <atoi+0x41>
    n = n*10 + *s++ - '0';
    1366:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1369:	89 d0                	mov    %edx,%eax
    136b:	c1 e0 02             	shl    $0x2,%eax
    136e:	01 d0                	add    %edx,%eax
    1370:	01 c0                	add    %eax,%eax
    1372:	89 c1                	mov    %eax,%ecx
    1374:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1378:	48 8d 50 01          	lea    0x1(%rax),%rdx
    137c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1380:	0f b6 00             	movzbl (%rax),%eax
    1383:	0f be c0             	movsbl %al,%eax
    1386:	01 c8                	add    %ecx,%eax
    1388:	83 e8 30             	sub    $0x30,%eax
    138b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    138e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1392:	0f b6 00             	movzbl (%rax),%eax
    1395:	3c 2f                	cmp    $0x2f,%al
    1397:	7e 0b                	jle    13a4 <atoi+0x57>
    1399:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    139d:	0f b6 00             	movzbl (%rax),%eax
    13a0:	3c 39                	cmp    $0x39,%al
    13a2:	7e c2                	jle    1366 <atoi+0x19>
  return n;
    13a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    13a7:	c9                   	leaveq 
    13a8:	c3                   	retq   

00000000000013a9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    13a9:	f3 0f 1e fa          	endbr64 
    13ad:	55                   	push   %rbp
    13ae:	48 89 e5             	mov    %rsp,%rbp
    13b1:	48 83 ec 28          	sub    $0x28,%rsp
    13b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    13bd:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    13c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    13c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    13cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    13d0:	eb 1d                	jmp    13ef <memmove+0x46>
    *dst++ = *src++;
    13d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    13d6:	48 8d 42 01          	lea    0x1(%rdx),%rax
    13da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    13de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13e2:	48 8d 48 01          	lea    0x1(%rax),%rcx
    13e6:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    13ea:	0f b6 12             	movzbl (%rdx),%edx
    13ed:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    13ef:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13f2:	8d 50 ff             	lea    -0x1(%rax),%edx
    13f5:	89 55 dc             	mov    %edx,-0x24(%rbp)
    13f8:	85 c0                	test   %eax,%eax
    13fa:	7f d6                	jg     13d2 <memmove+0x29>
  return vdst;
    13fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1400:	c9                   	leaveq 
    1401:	c3                   	retq   

0000000000001402 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    1402:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    1409:	49 89 ca             	mov    %rcx,%r10
    140c:	0f 05                	syscall 
    140e:	c3                   	retq   

000000000000140f <exit>:
SYSCALL(exit)
    140f:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1416:	49 89 ca             	mov    %rcx,%r10
    1419:	0f 05                	syscall 
    141b:	c3                   	retq   

000000000000141c <wait>:
SYSCALL(wait)
    141c:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1423:	49 89 ca             	mov    %rcx,%r10
    1426:	0f 05                	syscall 
    1428:	c3                   	retq   

0000000000001429 <pipe>:
SYSCALL(pipe)
    1429:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1430:	49 89 ca             	mov    %rcx,%r10
    1433:	0f 05                	syscall 
    1435:	c3                   	retq   

0000000000001436 <read>:
SYSCALL(read)
    1436:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    143d:	49 89 ca             	mov    %rcx,%r10
    1440:	0f 05                	syscall 
    1442:	c3                   	retq   

0000000000001443 <write>:
SYSCALL(write)
    1443:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    144a:	49 89 ca             	mov    %rcx,%r10
    144d:	0f 05                	syscall 
    144f:	c3                   	retq   

0000000000001450 <close>:
SYSCALL(close)
    1450:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1457:	49 89 ca             	mov    %rcx,%r10
    145a:	0f 05                	syscall 
    145c:	c3                   	retq   

000000000000145d <kill>:
SYSCALL(kill)
    145d:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1464:	49 89 ca             	mov    %rcx,%r10
    1467:	0f 05                	syscall 
    1469:	c3                   	retq   

000000000000146a <exec>:
SYSCALL(exec)
    146a:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1471:	49 89 ca             	mov    %rcx,%r10
    1474:	0f 05                	syscall 
    1476:	c3                   	retq   

0000000000001477 <open>:
SYSCALL(open)
    1477:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    147e:	49 89 ca             	mov    %rcx,%r10
    1481:	0f 05                	syscall 
    1483:	c3                   	retq   

0000000000001484 <mknod>:
SYSCALL(mknod)
    1484:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    148b:	49 89 ca             	mov    %rcx,%r10
    148e:	0f 05                	syscall 
    1490:	c3                   	retq   

0000000000001491 <unlink>:
SYSCALL(unlink)
    1491:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1498:	49 89 ca             	mov    %rcx,%r10
    149b:	0f 05                	syscall 
    149d:	c3                   	retq   

000000000000149e <fstat>:
SYSCALL(fstat)
    149e:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    14a5:	49 89 ca             	mov    %rcx,%r10
    14a8:	0f 05                	syscall 
    14aa:	c3                   	retq   

00000000000014ab <link>:
SYSCALL(link)
    14ab:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    14b2:	49 89 ca             	mov    %rcx,%r10
    14b5:	0f 05                	syscall 
    14b7:	c3                   	retq   

00000000000014b8 <mkdir>:
SYSCALL(mkdir)
    14b8:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    14bf:	49 89 ca             	mov    %rcx,%r10
    14c2:	0f 05                	syscall 
    14c4:	c3                   	retq   

00000000000014c5 <chdir>:
SYSCALL(chdir)
    14c5:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    14cc:	49 89 ca             	mov    %rcx,%r10
    14cf:	0f 05                	syscall 
    14d1:	c3                   	retq   

00000000000014d2 <dup>:
SYSCALL(dup)
    14d2:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    14d9:	49 89 ca             	mov    %rcx,%r10
    14dc:	0f 05                	syscall 
    14de:	c3                   	retq   

00000000000014df <getpid>:
SYSCALL(getpid)
    14df:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    14e6:	49 89 ca             	mov    %rcx,%r10
    14e9:	0f 05                	syscall 
    14eb:	c3                   	retq   

00000000000014ec <sbrk>:
SYSCALL(sbrk)
    14ec:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    14f3:	49 89 ca             	mov    %rcx,%r10
    14f6:	0f 05                	syscall 
    14f8:	c3                   	retq   

00000000000014f9 <sleep>:
SYSCALL(sleep)
    14f9:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    1500:	49 89 ca             	mov    %rcx,%r10
    1503:	0f 05                	syscall 
    1505:	c3                   	retq   

0000000000001506 <uptime>:
SYSCALL(uptime)
    1506:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    150d:	49 89 ca             	mov    %rcx,%r10
    1510:	0f 05                	syscall 
    1512:	c3                   	retq   

0000000000001513 <dedup>:
SYSCALL(dedup)
    1513:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    151a:	49 89 ca             	mov    %rcx,%r10
    151d:	0f 05                	syscall 
    151f:	c3                   	retq   

0000000000001520 <freepages>:
SYSCALL(freepages)
    1520:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    1527:	49 89 ca             	mov    %rcx,%r10
    152a:	0f 05                	syscall 
    152c:	c3                   	retq   

000000000000152d <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    152d:	f3 0f 1e fa          	endbr64 
    1531:	55                   	push   %rbp
    1532:	48 89 e5             	mov    %rsp,%rbp
    1535:	48 83 ec 10          	sub    $0x10,%rsp
    1539:	89 7d fc             	mov    %edi,-0x4(%rbp)
    153c:	89 f0                	mov    %esi,%eax
    153e:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1541:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1545:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1548:	ba 01 00 00 00       	mov    $0x1,%edx
    154d:	48 89 ce             	mov    %rcx,%rsi
    1550:	89 c7                	mov    %eax,%edi
    1552:	48 b8 43 14 00 00 00 	movabs $0x1443,%rax
    1559:	00 00 00 
    155c:	ff d0                	callq  *%rax
}
    155e:	90                   	nop
    155f:	c9                   	leaveq 
    1560:	c3                   	retq   

0000000000001561 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1561:	f3 0f 1e fa          	endbr64 
    1565:	55                   	push   %rbp
    1566:	48 89 e5             	mov    %rsp,%rbp
    1569:	48 83 ec 20          	sub    $0x20,%rsp
    156d:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1570:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1574:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    157b:	eb 35                	jmp    15b2 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    157d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1581:	48 c1 e8 3c          	shr    $0x3c,%rax
    1585:	48 ba 90 21 00 00 00 	movabs $0x2190,%rdx
    158c:	00 00 00 
    158f:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1593:	0f be d0             	movsbl %al,%edx
    1596:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1599:	89 d6                	mov    %edx,%esi
    159b:	89 c7                	mov    %eax,%edi
    159d:	48 b8 2d 15 00 00 00 	movabs $0x152d,%rax
    15a4:	00 00 00 
    15a7:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    15a9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15ad:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    15b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15b5:	83 f8 0f             	cmp    $0xf,%eax
    15b8:	76 c3                	jbe    157d <print_x64+0x1c>
}
    15ba:	90                   	nop
    15bb:	90                   	nop
    15bc:	c9                   	leaveq 
    15bd:	c3                   	retq   

00000000000015be <print_x32>:

  static void
print_x32(int fd, uint x)
{
    15be:	f3 0f 1e fa          	endbr64 
    15c2:	55                   	push   %rbp
    15c3:	48 89 e5             	mov    %rsp,%rbp
    15c6:	48 83 ec 20          	sub    $0x20,%rsp
    15ca:	89 7d ec             	mov    %edi,-0x14(%rbp)
    15cd:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    15d7:	eb 36                	jmp    160f <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    15d9:	8b 45 e8             	mov    -0x18(%rbp),%eax
    15dc:	c1 e8 1c             	shr    $0x1c,%eax
    15df:	89 c2                	mov    %eax,%edx
    15e1:	48 b8 90 21 00 00 00 	movabs $0x2190,%rax
    15e8:	00 00 00 
    15eb:	89 d2                	mov    %edx,%edx
    15ed:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    15f1:	0f be d0             	movsbl %al,%edx
    15f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15f7:	89 d6                	mov    %edx,%esi
    15f9:	89 c7                	mov    %eax,%edi
    15fb:	48 b8 2d 15 00 00 00 	movabs $0x152d,%rax
    1602:	00 00 00 
    1605:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1607:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    160b:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    160f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1612:	83 f8 07             	cmp    $0x7,%eax
    1615:	76 c2                	jbe    15d9 <print_x32+0x1b>
}
    1617:	90                   	nop
    1618:	90                   	nop
    1619:	c9                   	leaveq 
    161a:	c3                   	retq   

000000000000161b <print_d>:

  static void
print_d(int fd, int v)
{
    161b:	f3 0f 1e fa          	endbr64 
    161f:	55                   	push   %rbp
    1620:	48 89 e5             	mov    %rsp,%rbp
    1623:	48 83 ec 30          	sub    $0x30,%rsp
    1627:	89 7d dc             	mov    %edi,-0x24(%rbp)
    162a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    162d:	8b 45 d8             	mov    -0x28(%rbp),%eax
    1630:	48 98                	cltq   
    1632:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1636:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    163a:	79 04                	jns    1640 <print_d+0x25>
    x = -x;
    163c:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1640:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1647:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    164b:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1652:	66 66 66 
    1655:	48 89 c8             	mov    %rcx,%rax
    1658:	48 f7 ea             	imul   %rdx
    165b:	48 c1 fa 02          	sar    $0x2,%rdx
    165f:	48 89 c8             	mov    %rcx,%rax
    1662:	48 c1 f8 3f          	sar    $0x3f,%rax
    1666:	48 29 c2             	sub    %rax,%rdx
    1669:	48 89 d0             	mov    %rdx,%rax
    166c:	48 c1 e0 02          	shl    $0x2,%rax
    1670:	48 01 d0             	add    %rdx,%rax
    1673:	48 01 c0             	add    %rax,%rax
    1676:	48 29 c1             	sub    %rax,%rcx
    1679:	48 89 ca             	mov    %rcx,%rdx
    167c:	8b 45 f4             	mov    -0xc(%rbp),%eax
    167f:	8d 48 01             	lea    0x1(%rax),%ecx
    1682:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1685:	48 b9 90 21 00 00 00 	movabs $0x2190,%rcx
    168c:	00 00 00 
    168f:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1693:	48 98                	cltq   
    1695:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1699:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    169d:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    16a4:	66 66 66 
    16a7:	48 89 c8             	mov    %rcx,%rax
    16aa:	48 f7 ea             	imul   %rdx
    16ad:	48 c1 fa 02          	sar    $0x2,%rdx
    16b1:	48 89 c8             	mov    %rcx,%rax
    16b4:	48 c1 f8 3f          	sar    $0x3f,%rax
    16b8:	48 29 c2             	sub    %rax,%rdx
    16bb:	48 89 d0             	mov    %rdx,%rax
    16be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    16c2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    16c7:	0f 85 7a ff ff ff    	jne    1647 <print_d+0x2c>

  if (v < 0)
    16cd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    16d1:	79 32                	jns    1705 <print_d+0xea>
    buf[i++] = '-';
    16d3:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16d6:	8d 50 01             	lea    0x1(%rax),%edx
    16d9:	89 55 f4             	mov    %edx,-0xc(%rbp)
    16dc:	48 98                	cltq   
    16de:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    16e3:	eb 20                	jmp    1705 <print_d+0xea>
    putc(fd, buf[i]);
    16e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16e8:	48 98                	cltq   
    16ea:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    16ef:	0f be d0             	movsbl %al,%edx
    16f2:	8b 45 dc             	mov    -0x24(%rbp),%eax
    16f5:	89 d6                	mov    %edx,%esi
    16f7:	89 c7                	mov    %eax,%edi
    16f9:	48 b8 2d 15 00 00 00 	movabs $0x152d,%rax
    1700:	00 00 00 
    1703:	ff d0                	callq  *%rax
  while (--i >= 0)
    1705:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1709:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    170d:	79 d6                	jns    16e5 <print_d+0xca>
}
    170f:	90                   	nop
    1710:	90                   	nop
    1711:	c9                   	leaveq 
    1712:	c3                   	retq   

0000000000001713 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1713:	f3 0f 1e fa          	endbr64 
    1717:	55                   	push   %rbp
    1718:	48 89 e5             	mov    %rsp,%rbp
    171b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1722:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1728:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    172f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1736:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    173d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1744:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    174b:	84 c0                	test   %al,%al
    174d:	74 20                	je     176f <printf+0x5c>
    174f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1753:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1757:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    175b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    175f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1763:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1767:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    176b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    176f:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1776:	00 00 00 
    1779:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1780:	00 00 00 
    1783:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1787:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    178e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1795:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    179c:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    17a3:	00 00 00 
    17a6:	e9 41 03 00 00       	jmpq   1aec <printf+0x3d9>
    if (c != '%') {
    17ab:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17b2:	74 24                	je     17d8 <printf+0xc5>
      putc(fd, c);
    17b4:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    17ba:	0f be d0             	movsbl %al,%edx
    17bd:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    17c3:	89 d6                	mov    %edx,%esi
    17c5:	89 c7                	mov    %eax,%edi
    17c7:	48 b8 2d 15 00 00 00 	movabs $0x152d,%rax
    17ce:	00 00 00 
    17d1:	ff d0                	callq  *%rax
      continue;
    17d3:	e9 0d 03 00 00       	jmpq   1ae5 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    17d8:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    17df:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    17e5:	48 63 d0             	movslq %eax,%rdx
    17e8:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    17ef:	48 01 d0             	add    %rdx,%rax
    17f2:	0f b6 00             	movzbl (%rax),%eax
    17f5:	0f be c0             	movsbl %al,%eax
    17f8:	25 ff 00 00 00       	and    $0xff,%eax
    17fd:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1803:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    180a:	0f 84 0f 03 00 00    	je     1b1f <printf+0x40c>
      break;
    switch(c) {
    1810:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1817:	0f 84 74 02 00 00    	je     1a91 <printf+0x37e>
    181d:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1824:	0f 8c 82 02 00 00    	jl     1aac <printf+0x399>
    182a:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1831:	0f 8f 75 02 00 00    	jg     1aac <printf+0x399>
    1837:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    183e:	0f 8c 68 02 00 00    	jl     1aac <printf+0x399>
    1844:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    184a:	83 e8 63             	sub    $0x63,%eax
    184d:	83 f8 15             	cmp    $0x15,%eax
    1850:	0f 87 56 02 00 00    	ja     1aac <printf+0x399>
    1856:	89 c0                	mov    %eax,%eax
    1858:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    185f:	00 
    1860:	48 b8 60 1e 00 00 00 	movabs $0x1e60,%rax
    1867:	00 00 00 
    186a:	48 01 d0             	add    %rdx,%rax
    186d:	48 8b 00             	mov    (%rax),%rax
    1870:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1873:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1879:	83 f8 2f             	cmp    $0x2f,%eax
    187c:	77 23                	ja     18a1 <printf+0x18e>
    187e:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1885:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    188b:	89 d2                	mov    %edx,%edx
    188d:	48 01 d0             	add    %rdx,%rax
    1890:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1896:	83 c2 08             	add    $0x8,%edx
    1899:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    189f:	eb 12                	jmp    18b3 <printf+0x1a0>
    18a1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18a8:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18ac:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18b3:	8b 00                	mov    (%rax),%eax
    18b5:	0f be d0             	movsbl %al,%edx
    18b8:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18be:	89 d6                	mov    %edx,%esi
    18c0:	89 c7                	mov    %eax,%edi
    18c2:	48 b8 2d 15 00 00 00 	movabs $0x152d,%rax
    18c9:	00 00 00 
    18cc:	ff d0                	callq  *%rax
      break;
    18ce:	e9 12 02 00 00       	jmpq   1ae5 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    18d3:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18d9:	83 f8 2f             	cmp    $0x2f,%eax
    18dc:	77 23                	ja     1901 <printf+0x1ee>
    18de:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18e5:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18eb:	89 d2                	mov    %edx,%edx
    18ed:	48 01 d0             	add    %rdx,%rax
    18f0:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18f6:	83 c2 08             	add    $0x8,%edx
    18f9:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18ff:	eb 12                	jmp    1913 <printf+0x200>
    1901:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1908:	48 8d 50 08          	lea    0x8(%rax),%rdx
    190c:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1913:	8b 10                	mov    (%rax),%edx
    1915:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    191b:	89 d6                	mov    %edx,%esi
    191d:	89 c7                	mov    %eax,%edi
    191f:	48 b8 1b 16 00 00 00 	movabs $0x161b,%rax
    1926:	00 00 00 
    1929:	ff d0                	callq  *%rax
      break;
    192b:	e9 b5 01 00 00       	jmpq   1ae5 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1930:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1936:	83 f8 2f             	cmp    $0x2f,%eax
    1939:	77 23                	ja     195e <printf+0x24b>
    193b:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1942:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1948:	89 d2                	mov    %edx,%edx
    194a:	48 01 d0             	add    %rdx,%rax
    194d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1953:	83 c2 08             	add    $0x8,%edx
    1956:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    195c:	eb 12                	jmp    1970 <printf+0x25d>
    195e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1965:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1969:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1970:	8b 10                	mov    (%rax),%edx
    1972:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1978:	89 d6                	mov    %edx,%esi
    197a:	89 c7                	mov    %eax,%edi
    197c:	48 b8 be 15 00 00 00 	movabs $0x15be,%rax
    1983:	00 00 00 
    1986:	ff d0                	callq  *%rax
      break;
    1988:	e9 58 01 00 00       	jmpq   1ae5 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    198d:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1993:	83 f8 2f             	cmp    $0x2f,%eax
    1996:	77 23                	ja     19bb <printf+0x2a8>
    1998:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    199f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19a5:	89 d2                	mov    %edx,%edx
    19a7:	48 01 d0             	add    %rdx,%rax
    19aa:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19b0:	83 c2 08             	add    $0x8,%edx
    19b3:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19b9:	eb 12                	jmp    19cd <printf+0x2ba>
    19bb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19c2:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19c6:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19cd:	48 8b 10             	mov    (%rax),%rdx
    19d0:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19d6:	48 89 d6             	mov    %rdx,%rsi
    19d9:	89 c7                	mov    %eax,%edi
    19db:	48 b8 61 15 00 00 00 	movabs $0x1561,%rax
    19e2:	00 00 00 
    19e5:	ff d0                	callq  *%rax
      break;
    19e7:	e9 f9 00 00 00       	jmpq   1ae5 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    19ec:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19f2:	83 f8 2f             	cmp    $0x2f,%eax
    19f5:	77 23                	ja     1a1a <printf+0x307>
    19f7:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19fe:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a04:	89 d2                	mov    %edx,%edx
    1a06:	48 01 d0             	add    %rdx,%rax
    1a09:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a0f:	83 c2 08             	add    $0x8,%edx
    1a12:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a18:	eb 12                	jmp    1a2c <printf+0x319>
    1a1a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a21:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a25:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a2c:	48 8b 00             	mov    (%rax),%rax
    1a2f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1a36:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1a3d:	00 
    1a3e:	75 41                	jne    1a81 <printf+0x36e>
        s = "(null)";
    1a40:	48 b8 58 1e 00 00 00 	movabs $0x1e58,%rax
    1a47:	00 00 00 
    1a4a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1a51:	eb 2e                	jmp    1a81 <printf+0x36e>
        putc(fd, *(s++));
    1a53:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a5a:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a5e:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a65:	0f b6 00             	movzbl (%rax),%eax
    1a68:	0f be d0             	movsbl %al,%edx
    1a6b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a71:	89 d6                	mov    %edx,%esi
    1a73:	89 c7                	mov    %eax,%edi
    1a75:	48 b8 2d 15 00 00 00 	movabs $0x152d,%rax
    1a7c:	00 00 00 
    1a7f:	ff d0                	callq  *%rax
      while (*s)
    1a81:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a88:	0f b6 00             	movzbl (%rax),%eax
    1a8b:	84 c0                	test   %al,%al
    1a8d:	75 c4                	jne    1a53 <printf+0x340>
      break;
    1a8f:	eb 54                	jmp    1ae5 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1a91:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a97:	be 25 00 00 00       	mov    $0x25,%esi
    1a9c:	89 c7                	mov    %eax,%edi
    1a9e:	48 b8 2d 15 00 00 00 	movabs $0x152d,%rax
    1aa5:	00 00 00 
    1aa8:	ff d0                	callq  *%rax
      break;
    1aaa:	eb 39                	jmp    1ae5 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1aac:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ab2:	be 25 00 00 00       	mov    $0x25,%esi
    1ab7:	89 c7                	mov    %eax,%edi
    1ab9:	48 b8 2d 15 00 00 00 	movabs $0x152d,%rax
    1ac0:	00 00 00 
    1ac3:	ff d0                	callq  *%rax
      putc(fd, c);
    1ac5:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1acb:	0f be d0             	movsbl %al,%edx
    1ace:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ad4:	89 d6                	mov    %edx,%esi
    1ad6:	89 c7                	mov    %eax,%edi
    1ad8:	48 b8 2d 15 00 00 00 	movabs $0x152d,%rax
    1adf:	00 00 00 
    1ae2:	ff d0                	callq  *%rax
      break;
    1ae4:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1ae5:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1aec:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1af2:	48 63 d0             	movslq %eax,%rdx
    1af5:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1afc:	48 01 d0             	add    %rdx,%rax
    1aff:	0f b6 00             	movzbl (%rax),%eax
    1b02:	0f be c0             	movsbl %al,%eax
    1b05:	25 ff 00 00 00       	and    $0xff,%eax
    1b0a:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1b10:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1b17:	0f 85 8e fc ff ff    	jne    17ab <printf+0x98>
    }
  }
}
    1b1d:	eb 01                	jmp    1b20 <printf+0x40d>
      break;
    1b1f:	90                   	nop
}
    1b20:	90                   	nop
    1b21:	c9                   	leaveq 
    1b22:	c3                   	retq   

0000000000001b23 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1b23:	f3 0f 1e fa          	endbr64 
    1b27:	55                   	push   %rbp
    1b28:	48 89 e5             	mov    %rsp,%rbp
    1b2b:	48 83 ec 18          	sub    $0x18,%rsp
    1b2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1b33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b37:	48 83 e8 10          	sub    $0x10,%rax
    1b3b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b3f:	48 b8 c0 21 00 00 00 	movabs $0x21c0,%rax
    1b46:	00 00 00 
    1b49:	48 8b 00             	mov    (%rax),%rax
    1b4c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b50:	eb 2f                	jmp    1b81 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1b52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b56:	48 8b 00             	mov    (%rax),%rax
    1b59:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b5d:	72 17                	jb     1b76 <free+0x53>
    1b5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b63:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b67:	77 2f                	ja     1b98 <free+0x75>
    1b69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b6d:	48 8b 00             	mov    (%rax),%rax
    1b70:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b74:	72 22                	jb     1b98 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b7a:	48 8b 00             	mov    (%rax),%rax
    1b7d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b85:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b89:	76 c7                	jbe    1b52 <free+0x2f>
    1b8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b8f:	48 8b 00             	mov    (%rax),%rax
    1b92:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b96:	73 ba                	jae    1b52 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b9c:	8b 40 08             	mov    0x8(%rax),%eax
    1b9f:	89 c0                	mov    %eax,%eax
    1ba1:	48 c1 e0 04          	shl    $0x4,%rax
    1ba5:	48 89 c2             	mov    %rax,%rdx
    1ba8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bac:	48 01 c2             	add    %rax,%rdx
    1baf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bb3:	48 8b 00             	mov    (%rax),%rax
    1bb6:	48 39 c2             	cmp    %rax,%rdx
    1bb9:	75 2d                	jne    1be8 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1bbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bbf:	8b 50 08             	mov    0x8(%rax),%edx
    1bc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bc6:	48 8b 00             	mov    (%rax),%rax
    1bc9:	8b 40 08             	mov    0x8(%rax),%eax
    1bcc:	01 c2                	add    %eax,%edx
    1bce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bd2:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1bd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bd9:	48 8b 00             	mov    (%rax),%rax
    1bdc:	48 8b 10             	mov    (%rax),%rdx
    1bdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1be3:	48 89 10             	mov    %rdx,(%rax)
    1be6:	eb 0e                	jmp    1bf6 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1be8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bec:	48 8b 10             	mov    (%rax),%rdx
    1bef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bf3:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1bf6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bfa:	8b 40 08             	mov    0x8(%rax),%eax
    1bfd:	89 c0                	mov    %eax,%eax
    1bff:	48 c1 e0 04          	shl    $0x4,%rax
    1c03:	48 89 c2             	mov    %rax,%rdx
    1c06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c0a:	48 01 d0             	add    %rdx,%rax
    1c0d:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c11:	75 27                	jne    1c3a <free+0x117>
    p->s.size += bp->s.size;
    1c13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c17:	8b 50 08             	mov    0x8(%rax),%edx
    1c1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c1e:	8b 40 08             	mov    0x8(%rax),%eax
    1c21:	01 c2                	add    %eax,%edx
    1c23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c27:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1c2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c2e:	48 8b 10             	mov    (%rax),%rdx
    1c31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c35:	48 89 10             	mov    %rdx,(%rax)
    1c38:	eb 0b                	jmp    1c45 <free+0x122>
  } else
    p->s.ptr = bp;
    1c3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c3e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1c42:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1c45:	48 ba c0 21 00 00 00 	movabs $0x21c0,%rdx
    1c4c:	00 00 00 
    1c4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c53:	48 89 02             	mov    %rax,(%rdx)
}
    1c56:	90                   	nop
    1c57:	c9                   	leaveq 
    1c58:	c3                   	retq   

0000000000001c59 <morecore>:

static Header*
morecore(uint nu)
{
    1c59:	f3 0f 1e fa          	endbr64 
    1c5d:	55                   	push   %rbp
    1c5e:	48 89 e5             	mov    %rsp,%rbp
    1c61:	48 83 ec 20          	sub    $0x20,%rsp
    1c65:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c68:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c6f:	77 07                	ja     1c78 <morecore+0x1f>
    nu = 4096;
    1c71:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c78:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c7b:	48 c1 e0 04          	shl    $0x4,%rax
    1c7f:	48 89 c7             	mov    %rax,%rdi
    1c82:	48 b8 ec 14 00 00 00 	movabs $0x14ec,%rax
    1c89:	00 00 00 
    1c8c:	ff d0                	callq  *%rax
    1c8e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c92:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c97:	75 07                	jne    1ca0 <morecore+0x47>
    return 0;
    1c99:	b8 00 00 00 00       	mov    $0x0,%eax
    1c9e:	eb 36                	jmp    1cd6 <morecore+0x7d>
  hp = (Header*)p;
    1ca0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ca4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1ca8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cac:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1caf:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1cb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cb6:	48 83 c0 10          	add    $0x10,%rax
    1cba:	48 89 c7             	mov    %rax,%rdi
    1cbd:	48 b8 23 1b 00 00 00 	movabs $0x1b23,%rax
    1cc4:	00 00 00 
    1cc7:	ff d0                	callq  *%rax
  return freep;
    1cc9:	48 b8 c0 21 00 00 00 	movabs $0x21c0,%rax
    1cd0:	00 00 00 
    1cd3:	48 8b 00             	mov    (%rax),%rax
}
    1cd6:	c9                   	leaveq 
    1cd7:	c3                   	retq   

0000000000001cd8 <malloc>:

void*
malloc(uint nbytes)
{
    1cd8:	f3 0f 1e fa          	endbr64 
    1cdc:	55                   	push   %rbp
    1cdd:	48 89 e5             	mov    %rsp,%rbp
    1ce0:	48 83 ec 30          	sub    $0x30,%rsp
    1ce4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1ce7:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1cea:	48 83 c0 0f          	add    $0xf,%rax
    1cee:	48 c1 e8 04          	shr    $0x4,%rax
    1cf2:	83 c0 01             	add    $0x1,%eax
    1cf5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1cf8:	48 b8 c0 21 00 00 00 	movabs $0x21c0,%rax
    1cff:	00 00 00 
    1d02:	48 8b 00             	mov    (%rax),%rax
    1d05:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d09:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1d0e:	75 4a                	jne    1d5a <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1d10:	48 b8 b0 21 00 00 00 	movabs $0x21b0,%rax
    1d17:	00 00 00 
    1d1a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d1e:	48 ba c0 21 00 00 00 	movabs $0x21c0,%rdx
    1d25:	00 00 00 
    1d28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d2c:	48 89 02             	mov    %rax,(%rdx)
    1d2f:	48 b8 c0 21 00 00 00 	movabs $0x21c0,%rax
    1d36:	00 00 00 
    1d39:	48 8b 00             	mov    (%rax),%rax
    1d3c:	48 ba b0 21 00 00 00 	movabs $0x21b0,%rdx
    1d43:	00 00 00 
    1d46:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1d49:	48 b8 b0 21 00 00 00 	movabs $0x21b0,%rax
    1d50:	00 00 00 
    1d53:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d5e:	48 8b 00             	mov    (%rax),%rax
    1d61:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d69:	8b 40 08             	mov    0x8(%rax),%eax
    1d6c:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d6f:	77 65                	ja     1dd6 <malloc+0xfe>
      if(p->s.size == nunits)
    1d71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d75:	8b 40 08             	mov    0x8(%rax),%eax
    1d78:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d7b:	75 10                	jne    1d8d <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1d7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d81:	48 8b 10             	mov    (%rax),%rdx
    1d84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d88:	48 89 10             	mov    %rdx,(%rax)
    1d8b:	eb 2e                	jmp    1dbb <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1d8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d91:	8b 40 08             	mov    0x8(%rax),%eax
    1d94:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d97:	89 c2                	mov    %eax,%edx
    1d99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d9d:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1da0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1da4:	8b 40 08             	mov    0x8(%rax),%eax
    1da7:	89 c0                	mov    %eax,%eax
    1da9:	48 c1 e0 04          	shl    $0x4,%rax
    1dad:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1db1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1db5:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1db8:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1dbb:	48 ba c0 21 00 00 00 	movabs $0x21c0,%rdx
    1dc2:	00 00 00 
    1dc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dc9:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1dcc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dd0:	48 83 c0 10          	add    $0x10,%rax
    1dd4:	eb 4e                	jmp    1e24 <malloc+0x14c>
    }
    if(p == freep)
    1dd6:	48 b8 c0 21 00 00 00 	movabs $0x21c0,%rax
    1ddd:	00 00 00 
    1de0:	48 8b 00             	mov    (%rax),%rax
    1de3:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1de7:	75 23                	jne    1e0c <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1de9:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1dec:	89 c7                	mov    %eax,%edi
    1dee:	48 b8 59 1c 00 00 00 	movabs $0x1c59,%rax
    1df5:	00 00 00 
    1df8:	ff d0                	callq  *%rax
    1dfa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1dfe:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1e03:	75 07                	jne    1e0c <malloc+0x134>
        return 0;
    1e05:	b8 00 00 00 00       	mov    $0x0,%eax
    1e0a:	eb 18                	jmp    1e24 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e10:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e18:	48 8b 00             	mov    (%rax),%rax
    1e1b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e1f:	e9 41 ff ff ff       	jmpq   1d65 <malloc+0x8d>
  }
}
    1e24:	c9                   	leaveq 
    1e25:	c3                   	retq   
