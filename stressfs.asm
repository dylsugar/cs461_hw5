
_stressfs:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 81 ec 30 02 00 00 	sub    $0x230,%rsp
    100f:	89 bd dc fd ff ff    	mov    %edi,-0x224(%rbp)
    1015:	48 89 b5 d0 fd ff ff 	mov    %rsi,-0x230(%rbp)
  int fd, i;
  char path[] = "stressfs0";
    101c:	48 b8 73 74 72 65 73 	movabs $0x7366737365727473,%rax
    1023:	73 66 73 
    1026:	48 89 45 ee          	mov    %rax,-0x12(%rbp)
    102a:	66 c7 45 f6 30 00    	movw   $0x30,-0xa(%rbp)
  char data[512];

  printf(1, "stressfs starting\n");
    1030:	48 be 20 1f 00 00 00 	movabs $0x1f20,%rsi
    1037:	00 00 00 
    103a:	bf 01 00 00 00       	mov    $0x1,%edi
    103f:	b8 00 00 00 00       	mov    $0x0,%eax
    1044:	48 ba 06 18 00 00 00 	movabs $0x1806,%rdx
    104b:	00 00 00 
    104e:	ff d2                	callq  *%rdx
  memset(data, 'a', sizeof(data));
    1050:	48 8d 85 e0 fd ff ff 	lea    -0x220(%rbp),%rax
    1057:	ba 00 02 00 00       	mov    $0x200,%edx
    105c:	be 61 00 00 00       	mov    $0x61,%esi
    1061:	48 89 c7             	mov    %rax,%rdi
    1064:	48 b8 cd 12 00 00 00 	movabs $0x12cd,%rax
    106b:	00 00 00 
    106e:	ff d0                	callq  *%rax

  for(i = 0; i < 4; i++)
    1070:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1077:	eb 14                	jmp    108d <main+0x8d>
    if(fork() > 0)
    1079:	48 b8 f5 14 00 00 00 	movabs $0x14f5,%rax
    1080:	00 00 00 
    1083:	ff d0                	callq  *%rax
    1085:	85 c0                	test   %eax,%eax
    1087:	7f 0c                	jg     1095 <main+0x95>
  for(i = 0; i < 4; i++)
    1089:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    108d:	83 7d fc 03          	cmpl   $0x3,-0x4(%rbp)
    1091:	7e e6                	jle    1079 <main+0x79>
    1093:	eb 01                	jmp    1096 <main+0x96>
      break;
    1095:	90                   	nop

  printf(1, "write %d\n", i);
    1096:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1099:	89 c2                	mov    %eax,%edx
    109b:	48 be 33 1f 00 00 00 	movabs $0x1f33,%rsi
    10a2:	00 00 00 
    10a5:	bf 01 00 00 00       	mov    $0x1,%edi
    10aa:	b8 00 00 00 00       	mov    $0x0,%eax
    10af:	48 b9 06 18 00 00 00 	movabs $0x1806,%rcx
    10b6:	00 00 00 
    10b9:	ff d1                	callq  *%rcx

  path[8] += i;
    10bb:	0f b6 45 f6          	movzbl -0xa(%rbp),%eax
    10bf:	89 c2                	mov    %eax,%edx
    10c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10c4:	01 d0                	add    %edx,%eax
    10c6:	88 45 f6             	mov    %al,-0xa(%rbp)
  fd = open(path, O_CREATE | O_RDWR);
    10c9:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
    10cd:	be 02 02 00 00       	mov    $0x202,%esi
    10d2:	48 89 c7             	mov    %rax,%rdi
    10d5:	48 b8 6a 15 00 00 00 	movabs $0x156a,%rax
    10dc:	00 00 00 
    10df:	ff d0                	callq  *%rax
    10e1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  for(i = 0; i < 20; i++)
    10e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    10eb:	eb 24                	jmp    1111 <main+0x111>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
    10ed:	48 8d 8d e0 fd ff ff 	lea    -0x220(%rbp),%rcx
    10f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
    10f7:	ba 00 02 00 00       	mov    $0x200,%edx
    10fc:	48 89 ce             	mov    %rcx,%rsi
    10ff:	89 c7                	mov    %eax,%edi
    1101:	48 b8 36 15 00 00 00 	movabs $0x1536,%rax
    1108:	00 00 00 
    110b:	ff d0                	callq  *%rax
  for(i = 0; i < 20; i++)
    110d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1111:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
    1115:	7e d6                	jle    10ed <main+0xed>
  close(fd);
    1117:	8b 45 f8             	mov    -0x8(%rbp),%eax
    111a:	89 c7                	mov    %eax,%edi
    111c:	48 b8 43 15 00 00 00 	movabs $0x1543,%rax
    1123:	00 00 00 
    1126:	ff d0                	callq  *%rax

  printf(1, "read\n");
    1128:	48 be 3d 1f 00 00 00 	movabs $0x1f3d,%rsi
    112f:	00 00 00 
    1132:	bf 01 00 00 00       	mov    $0x1,%edi
    1137:	b8 00 00 00 00       	mov    $0x0,%eax
    113c:	48 ba 06 18 00 00 00 	movabs $0x1806,%rdx
    1143:	00 00 00 
    1146:	ff d2                	callq  *%rdx

  fd = open(path, O_RDONLY);
    1148:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
    114c:	be 00 00 00 00       	mov    $0x0,%esi
    1151:	48 89 c7             	mov    %rax,%rdi
    1154:	48 b8 6a 15 00 00 00 	movabs $0x156a,%rax
    115b:	00 00 00 
    115e:	ff d0                	callq  *%rax
    1160:	89 45 f8             	mov    %eax,-0x8(%rbp)
  for (i = 0; i < 20; i++)
    1163:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    116a:	eb 24                	jmp    1190 <main+0x190>
    read(fd, data, sizeof(data));
    116c:	48 8d 8d e0 fd ff ff 	lea    -0x220(%rbp),%rcx
    1173:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1176:	ba 00 02 00 00       	mov    $0x200,%edx
    117b:	48 89 ce             	mov    %rcx,%rsi
    117e:	89 c7                	mov    %eax,%edi
    1180:	48 b8 29 15 00 00 00 	movabs $0x1529,%rax
    1187:	00 00 00 
    118a:	ff d0                	callq  *%rax
  for (i = 0; i < 20; i++)
    118c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1190:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
    1194:	7e d6                	jle    116c <main+0x16c>
  close(fd);
    1196:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1199:	89 c7                	mov    %eax,%edi
    119b:	48 b8 43 15 00 00 00 	movabs $0x1543,%rax
    11a2:	00 00 00 
    11a5:	ff d0                	callq  *%rax

  wait();
    11a7:	48 b8 0f 15 00 00 00 	movabs $0x150f,%rax
    11ae:	00 00 00 
    11b1:	ff d0                	callq  *%rax

  exit();
    11b3:	48 b8 02 15 00 00 00 	movabs $0x1502,%rax
    11ba:	00 00 00 
    11bd:	ff d0                	callq  *%rax

00000000000011bf <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    11bf:	f3 0f 1e fa          	endbr64 
    11c3:	55                   	push   %rbp
    11c4:	48 89 e5             	mov    %rsp,%rbp
    11c7:	48 83 ec 10          	sub    $0x10,%rsp
    11cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11cf:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11d2:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    11d5:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    11d9:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11dc:	8b 45 f4             	mov    -0xc(%rbp),%eax
    11df:	48 89 ce             	mov    %rcx,%rsi
    11e2:	48 89 f7             	mov    %rsi,%rdi
    11e5:	89 d1                	mov    %edx,%ecx
    11e7:	fc                   	cld    
    11e8:	f3 aa                	rep stos %al,%es:(%rdi)
    11ea:	89 ca                	mov    %ecx,%edx
    11ec:	48 89 fe             	mov    %rdi,%rsi
    11ef:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    11f3:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11f6:	90                   	nop
    11f7:	c9                   	leaveq 
    11f8:	c3                   	retq   

00000000000011f9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11f9:	f3 0f 1e fa          	endbr64 
    11fd:	55                   	push   %rbp
    11fe:	48 89 e5             	mov    %rsp,%rbp
    1201:	48 83 ec 20          	sub    $0x20,%rsp
    1205:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1209:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    120d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1211:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1215:	90                   	nop
    1216:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    121a:	48 8d 42 01          	lea    0x1(%rdx),%rax
    121e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    1222:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1226:	48 8d 48 01          	lea    0x1(%rax),%rcx
    122a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    122e:	0f b6 12             	movzbl (%rdx),%edx
    1231:	88 10                	mov    %dl,(%rax)
    1233:	0f b6 00             	movzbl (%rax),%eax
    1236:	84 c0                	test   %al,%al
    1238:	75 dc                	jne    1216 <strcpy+0x1d>
    ;
  return os;
    123a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    123e:	c9                   	leaveq 
    123f:	c3                   	retq   

0000000000001240 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1240:	f3 0f 1e fa          	endbr64 
    1244:	55                   	push   %rbp
    1245:	48 89 e5             	mov    %rsp,%rbp
    1248:	48 83 ec 10          	sub    $0x10,%rsp
    124c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1250:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1254:	eb 0a                	jmp    1260 <strcmp+0x20>
    p++, q++;
    1256:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    125b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1260:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1264:	0f b6 00             	movzbl (%rax),%eax
    1267:	84 c0                	test   %al,%al
    1269:	74 12                	je     127d <strcmp+0x3d>
    126b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    126f:	0f b6 10             	movzbl (%rax),%edx
    1272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1276:	0f b6 00             	movzbl (%rax),%eax
    1279:	38 c2                	cmp    %al,%dl
    127b:	74 d9                	je     1256 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    127d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1281:	0f b6 00             	movzbl (%rax),%eax
    1284:	0f b6 d0             	movzbl %al,%edx
    1287:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    128b:	0f b6 00             	movzbl (%rax),%eax
    128e:	0f b6 c0             	movzbl %al,%eax
    1291:	29 c2                	sub    %eax,%edx
    1293:	89 d0                	mov    %edx,%eax
}
    1295:	c9                   	leaveq 
    1296:	c3                   	retq   

0000000000001297 <strlen>:

uint
strlen(char *s)
{
    1297:	f3 0f 1e fa          	endbr64 
    129b:	55                   	push   %rbp
    129c:	48 89 e5             	mov    %rsp,%rbp
    129f:	48 83 ec 18          	sub    $0x18,%rsp
    12a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    12a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    12ae:	eb 04                	jmp    12b4 <strlen+0x1d>
    12b0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    12b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12b7:	48 63 d0             	movslq %eax,%rdx
    12ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12be:	48 01 d0             	add    %rdx,%rax
    12c1:	0f b6 00             	movzbl (%rax),%eax
    12c4:	84 c0                	test   %al,%al
    12c6:	75 e8                	jne    12b0 <strlen+0x19>
    ;
  return n;
    12c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    12cb:	c9                   	leaveq 
    12cc:	c3                   	retq   

00000000000012cd <memset>:

void*
memset(void *dst, int c, uint n)
{
    12cd:	f3 0f 1e fa          	endbr64 
    12d1:	55                   	push   %rbp
    12d2:	48 89 e5             	mov    %rsp,%rbp
    12d5:	48 83 ec 10          	sub    $0x10,%rsp
    12d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12dd:	89 75 f4             	mov    %esi,-0xc(%rbp)
    12e0:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    12e3:	8b 55 f0             	mov    -0x10(%rbp),%edx
    12e6:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    12e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12ed:	89 ce                	mov    %ecx,%esi
    12ef:	48 89 c7             	mov    %rax,%rdi
    12f2:	48 b8 bf 11 00 00 00 	movabs $0x11bf,%rax
    12f9:	00 00 00 
    12fc:	ff d0                	callq  *%rax
  return dst;
    12fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1302:	c9                   	leaveq 
    1303:	c3                   	retq   

0000000000001304 <strchr>:

char*
strchr(const char *s, char c)
{
    1304:	f3 0f 1e fa          	endbr64 
    1308:	55                   	push   %rbp
    1309:	48 89 e5             	mov    %rsp,%rbp
    130c:	48 83 ec 10          	sub    $0x10,%rsp
    1310:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1314:	89 f0                	mov    %esi,%eax
    1316:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1319:	eb 17                	jmp    1332 <strchr+0x2e>
    if(*s == c)
    131b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    131f:	0f b6 00             	movzbl (%rax),%eax
    1322:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1325:	75 06                	jne    132d <strchr+0x29>
      return (char*)s;
    1327:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    132b:	eb 15                	jmp    1342 <strchr+0x3e>
  for(; *s; s++)
    132d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1332:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1336:	0f b6 00             	movzbl (%rax),%eax
    1339:	84 c0                	test   %al,%al
    133b:	75 de                	jne    131b <strchr+0x17>
  return 0;
    133d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1342:	c9                   	leaveq 
    1343:	c3                   	retq   

0000000000001344 <gets>:

char*
gets(char *buf, int max)
{
    1344:	f3 0f 1e fa          	endbr64 
    1348:	55                   	push   %rbp
    1349:	48 89 e5             	mov    %rsp,%rbp
    134c:	48 83 ec 20          	sub    $0x20,%rsp
    1350:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1354:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1357:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    135e:	eb 4f                	jmp    13af <gets+0x6b>
    cc = read(0, &c, 1);
    1360:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1364:	ba 01 00 00 00       	mov    $0x1,%edx
    1369:	48 89 c6             	mov    %rax,%rsi
    136c:	bf 00 00 00 00       	mov    $0x0,%edi
    1371:	48 b8 29 15 00 00 00 	movabs $0x1529,%rax
    1378:	00 00 00 
    137b:	ff d0                	callq  *%rax
    137d:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1380:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1384:	7e 36                	jle    13bc <gets+0x78>
      break;
    buf[i++] = c;
    1386:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1389:	8d 50 01             	lea    0x1(%rax),%edx
    138c:	89 55 fc             	mov    %edx,-0x4(%rbp)
    138f:	48 63 d0             	movslq %eax,%rdx
    1392:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1396:	48 01 c2             	add    %rax,%rdx
    1399:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    139d:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    139f:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    13a3:	3c 0a                	cmp    $0xa,%al
    13a5:	74 16                	je     13bd <gets+0x79>
    13a7:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    13ab:	3c 0d                	cmp    $0xd,%al
    13ad:	74 0e                	je     13bd <gets+0x79>
  for(i=0; i+1 < max; ){
    13af:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13b2:	83 c0 01             	add    $0x1,%eax
    13b5:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    13b8:	7f a6                	jg     1360 <gets+0x1c>
    13ba:	eb 01                	jmp    13bd <gets+0x79>
      break;
    13bc:	90                   	nop
      break;
  }
  buf[i] = '\0';
    13bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13c0:	48 63 d0             	movslq %eax,%rdx
    13c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13c7:	48 01 d0             	add    %rdx,%rax
    13ca:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    13cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13d1:	c9                   	leaveq 
    13d2:	c3                   	retq   

00000000000013d3 <stat>:

int
stat(char *n, struct stat *st)
{
    13d3:	f3 0f 1e fa          	endbr64 
    13d7:	55                   	push   %rbp
    13d8:	48 89 e5             	mov    %rsp,%rbp
    13db:	48 83 ec 20          	sub    $0x20,%rsp
    13df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13eb:	be 00 00 00 00       	mov    $0x0,%esi
    13f0:	48 89 c7             	mov    %rax,%rdi
    13f3:	48 b8 6a 15 00 00 00 	movabs $0x156a,%rax
    13fa:	00 00 00 
    13fd:	ff d0                	callq  *%rax
    13ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    1402:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1406:	79 07                	jns    140f <stat+0x3c>
    return -1;
    1408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    140d:	eb 2f                	jmp    143e <stat+0x6b>
  r = fstat(fd, st);
    140f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1413:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1416:	48 89 d6             	mov    %rdx,%rsi
    1419:	89 c7                	mov    %eax,%edi
    141b:	48 b8 91 15 00 00 00 	movabs $0x1591,%rax
    1422:	00 00 00 
    1425:	ff d0                	callq  *%rax
    1427:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    142a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    142d:	89 c7                	mov    %eax,%edi
    142f:	48 b8 43 15 00 00 00 	movabs $0x1543,%rax
    1436:	00 00 00 
    1439:	ff d0                	callq  *%rax
  return r;
    143b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    143e:	c9                   	leaveq 
    143f:	c3                   	retq   

0000000000001440 <atoi>:

int
atoi(const char *s)
{
    1440:	f3 0f 1e fa          	endbr64 
    1444:	55                   	push   %rbp
    1445:	48 89 e5             	mov    %rsp,%rbp
    1448:	48 83 ec 18          	sub    $0x18,%rsp
    144c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1450:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1457:	eb 28                	jmp    1481 <atoi+0x41>
    n = n*10 + *s++ - '0';
    1459:	8b 55 fc             	mov    -0x4(%rbp),%edx
    145c:	89 d0                	mov    %edx,%eax
    145e:	c1 e0 02             	shl    $0x2,%eax
    1461:	01 d0                	add    %edx,%eax
    1463:	01 c0                	add    %eax,%eax
    1465:	89 c1                	mov    %eax,%ecx
    1467:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    146b:	48 8d 50 01          	lea    0x1(%rax),%rdx
    146f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1473:	0f b6 00             	movzbl (%rax),%eax
    1476:	0f be c0             	movsbl %al,%eax
    1479:	01 c8                	add    %ecx,%eax
    147b:	83 e8 30             	sub    $0x30,%eax
    147e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1481:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1485:	0f b6 00             	movzbl (%rax),%eax
    1488:	3c 2f                	cmp    $0x2f,%al
    148a:	7e 0b                	jle    1497 <atoi+0x57>
    148c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1490:	0f b6 00             	movzbl (%rax),%eax
    1493:	3c 39                	cmp    $0x39,%al
    1495:	7e c2                	jle    1459 <atoi+0x19>
  return n;
    1497:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    149a:	c9                   	leaveq 
    149b:	c3                   	retq   

000000000000149c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    149c:	f3 0f 1e fa          	endbr64 
    14a0:	55                   	push   %rbp
    14a1:	48 89 e5             	mov    %rsp,%rbp
    14a4:	48 83 ec 28          	sub    $0x28,%rsp
    14a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    14ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    14b0:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    14b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    14bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    14bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    14c3:	eb 1d                	jmp    14e2 <memmove+0x46>
    *dst++ = *src++;
    14c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    14c9:	48 8d 42 01          	lea    0x1(%rdx),%rax
    14cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    14d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    14d5:	48 8d 48 01          	lea    0x1(%rax),%rcx
    14d9:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    14dd:	0f b6 12             	movzbl (%rdx),%edx
    14e0:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    14e2:	8b 45 dc             	mov    -0x24(%rbp),%eax
    14e5:	8d 50 ff             	lea    -0x1(%rax),%edx
    14e8:	89 55 dc             	mov    %edx,-0x24(%rbp)
    14eb:	85 c0                	test   %eax,%eax
    14ed:	7f d6                	jg     14c5 <memmove+0x29>
  return vdst;
    14ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    14f3:	c9                   	leaveq 
    14f4:	c3                   	retq   

00000000000014f5 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    14f5:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    14fc:	49 89 ca             	mov    %rcx,%r10
    14ff:	0f 05                	syscall 
    1501:	c3                   	retq   

0000000000001502 <exit>:
SYSCALL(exit)
    1502:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1509:	49 89 ca             	mov    %rcx,%r10
    150c:	0f 05                	syscall 
    150e:	c3                   	retq   

000000000000150f <wait>:
SYSCALL(wait)
    150f:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1516:	49 89 ca             	mov    %rcx,%r10
    1519:	0f 05                	syscall 
    151b:	c3                   	retq   

000000000000151c <pipe>:
SYSCALL(pipe)
    151c:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1523:	49 89 ca             	mov    %rcx,%r10
    1526:	0f 05                	syscall 
    1528:	c3                   	retq   

0000000000001529 <read>:
SYSCALL(read)
    1529:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    1530:	49 89 ca             	mov    %rcx,%r10
    1533:	0f 05                	syscall 
    1535:	c3                   	retq   

0000000000001536 <write>:
SYSCALL(write)
    1536:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    153d:	49 89 ca             	mov    %rcx,%r10
    1540:	0f 05                	syscall 
    1542:	c3                   	retq   

0000000000001543 <close>:
SYSCALL(close)
    1543:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    154a:	49 89 ca             	mov    %rcx,%r10
    154d:	0f 05                	syscall 
    154f:	c3                   	retq   

0000000000001550 <kill>:
SYSCALL(kill)
    1550:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1557:	49 89 ca             	mov    %rcx,%r10
    155a:	0f 05                	syscall 
    155c:	c3                   	retq   

000000000000155d <exec>:
SYSCALL(exec)
    155d:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1564:	49 89 ca             	mov    %rcx,%r10
    1567:	0f 05                	syscall 
    1569:	c3                   	retq   

000000000000156a <open>:
SYSCALL(open)
    156a:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1571:	49 89 ca             	mov    %rcx,%r10
    1574:	0f 05                	syscall 
    1576:	c3                   	retq   

0000000000001577 <mknod>:
SYSCALL(mknod)
    1577:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    157e:	49 89 ca             	mov    %rcx,%r10
    1581:	0f 05                	syscall 
    1583:	c3                   	retq   

0000000000001584 <unlink>:
SYSCALL(unlink)
    1584:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    158b:	49 89 ca             	mov    %rcx,%r10
    158e:	0f 05                	syscall 
    1590:	c3                   	retq   

0000000000001591 <fstat>:
SYSCALL(fstat)
    1591:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1598:	49 89 ca             	mov    %rcx,%r10
    159b:	0f 05                	syscall 
    159d:	c3                   	retq   

000000000000159e <link>:
SYSCALL(link)
    159e:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    15a5:	49 89 ca             	mov    %rcx,%r10
    15a8:	0f 05                	syscall 
    15aa:	c3                   	retq   

00000000000015ab <mkdir>:
SYSCALL(mkdir)
    15ab:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    15b2:	49 89 ca             	mov    %rcx,%r10
    15b5:	0f 05                	syscall 
    15b7:	c3                   	retq   

00000000000015b8 <chdir>:
SYSCALL(chdir)
    15b8:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    15bf:	49 89 ca             	mov    %rcx,%r10
    15c2:	0f 05                	syscall 
    15c4:	c3                   	retq   

00000000000015c5 <dup>:
SYSCALL(dup)
    15c5:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    15cc:	49 89 ca             	mov    %rcx,%r10
    15cf:	0f 05                	syscall 
    15d1:	c3                   	retq   

00000000000015d2 <getpid>:
SYSCALL(getpid)
    15d2:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    15d9:	49 89 ca             	mov    %rcx,%r10
    15dc:	0f 05                	syscall 
    15de:	c3                   	retq   

00000000000015df <sbrk>:
SYSCALL(sbrk)
    15df:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    15e6:	49 89 ca             	mov    %rcx,%r10
    15e9:	0f 05                	syscall 
    15eb:	c3                   	retq   

00000000000015ec <sleep>:
SYSCALL(sleep)
    15ec:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    15f3:	49 89 ca             	mov    %rcx,%r10
    15f6:	0f 05                	syscall 
    15f8:	c3                   	retq   

00000000000015f9 <uptime>:
SYSCALL(uptime)
    15f9:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    1600:	49 89 ca             	mov    %rcx,%r10
    1603:	0f 05                	syscall 
    1605:	c3                   	retq   

0000000000001606 <dedup>:
SYSCALL(dedup)
    1606:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    160d:	49 89 ca             	mov    %rcx,%r10
    1610:	0f 05                	syscall 
    1612:	c3                   	retq   

0000000000001613 <freepages>:
SYSCALL(freepages)
    1613:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    161a:	49 89 ca             	mov    %rcx,%r10
    161d:	0f 05                	syscall 
    161f:	c3                   	retq   

0000000000001620 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    1620:	f3 0f 1e fa          	endbr64 
    1624:	55                   	push   %rbp
    1625:	48 89 e5             	mov    %rsp,%rbp
    1628:	48 83 ec 10          	sub    $0x10,%rsp
    162c:	89 7d fc             	mov    %edi,-0x4(%rbp)
    162f:	89 f0                	mov    %esi,%eax
    1631:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1634:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1638:	8b 45 fc             	mov    -0x4(%rbp),%eax
    163b:	ba 01 00 00 00       	mov    $0x1,%edx
    1640:	48 89 ce             	mov    %rcx,%rsi
    1643:	89 c7                	mov    %eax,%edi
    1645:	48 b8 36 15 00 00 00 	movabs $0x1536,%rax
    164c:	00 00 00 
    164f:	ff d0                	callq  *%rax
}
    1651:	90                   	nop
    1652:	c9                   	leaveq 
    1653:	c3                   	retq   

0000000000001654 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1654:	f3 0f 1e fa          	endbr64 
    1658:	55                   	push   %rbp
    1659:	48 89 e5             	mov    %rsp,%rbp
    165c:	48 83 ec 20          	sub    $0x20,%rsp
    1660:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1663:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1667:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    166e:	eb 35                	jmp    16a5 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1670:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1674:	48 c1 e8 3c          	shr    $0x3c,%rax
    1678:	48 ba 80 22 00 00 00 	movabs $0x2280,%rdx
    167f:	00 00 00 
    1682:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1686:	0f be d0             	movsbl %al,%edx
    1689:	8b 45 ec             	mov    -0x14(%rbp),%eax
    168c:	89 d6                	mov    %edx,%esi
    168e:	89 c7                	mov    %eax,%edi
    1690:	48 b8 20 16 00 00 00 	movabs $0x1620,%rax
    1697:	00 00 00 
    169a:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    169c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    16a0:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    16a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16a8:	83 f8 0f             	cmp    $0xf,%eax
    16ab:	76 c3                	jbe    1670 <print_x64+0x1c>
}
    16ad:	90                   	nop
    16ae:	90                   	nop
    16af:	c9                   	leaveq 
    16b0:	c3                   	retq   

00000000000016b1 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    16b1:	f3 0f 1e fa          	endbr64 
    16b5:	55                   	push   %rbp
    16b6:	48 89 e5             	mov    %rsp,%rbp
    16b9:	48 83 ec 20          	sub    $0x20,%rsp
    16bd:	89 7d ec             	mov    %edi,-0x14(%rbp)
    16c0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    16ca:	eb 36                	jmp    1702 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    16cc:	8b 45 e8             	mov    -0x18(%rbp),%eax
    16cf:	c1 e8 1c             	shr    $0x1c,%eax
    16d2:	89 c2                	mov    %eax,%edx
    16d4:	48 b8 80 22 00 00 00 	movabs $0x2280,%rax
    16db:	00 00 00 
    16de:	89 d2                	mov    %edx,%edx
    16e0:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    16e4:	0f be d0             	movsbl %al,%edx
    16e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
    16ea:	89 d6                	mov    %edx,%esi
    16ec:	89 c7                	mov    %eax,%edi
    16ee:	48 b8 20 16 00 00 00 	movabs $0x1620,%rax
    16f5:	00 00 00 
    16f8:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16fa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    16fe:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    1702:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1705:	83 f8 07             	cmp    $0x7,%eax
    1708:	76 c2                	jbe    16cc <print_x32+0x1b>
}
    170a:	90                   	nop
    170b:	90                   	nop
    170c:	c9                   	leaveq 
    170d:	c3                   	retq   

000000000000170e <print_d>:

  static void
print_d(int fd, int v)
{
    170e:	f3 0f 1e fa          	endbr64 
    1712:	55                   	push   %rbp
    1713:	48 89 e5             	mov    %rsp,%rbp
    1716:	48 83 ec 30          	sub    $0x30,%rsp
    171a:	89 7d dc             	mov    %edi,-0x24(%rbp)
    171d:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    1720:	8b 45 d8             	mov    -0x28(%rbp),%eax
    1723:	48 98                	cltq   
    1725:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1729:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    172d:	79 04                	jns    1733 <print_d+0x25>
    x = -x;
    172f:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1733:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    173a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    173e:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1745:	66 66 66 
    1748:	48 89 c8             	mov    %rcx,%rax
    174b:	48 f7 ea             	imul   %rdx
    174e:	48 c1 fa 02          	sar    $0x2,%rdx
    1752:	48 89 c8             	mov    %rcx,%rax
    1755:	48 c1 f8 3f          	sar    $0x3f,%rax
    1759:	48 29 c2             	sub    %rax,%rdx
    175c:	48 89 d0             	mov    %rdx,%rax
    175f:	48 c1 e0 02          	shl    $0x2,%rax
    1763:	48 01 d0             	add    %rdx,%rax
    1766:	48 01 c0             	add    %rax,%rax
    1769:	48 29 c1             	sub    %rax,%rcx
    176c:	48 89 ca             	mov    %rcx,%rdx
    176f:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1772:	8d 48 01             	lea    0x1(%rax),%ecx
    1775:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1778:	48 b9 80 22 00 00 00 	movabs $0x2280,%rcx
    177f:	00 00 00 
    1782:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1786:	48 98                	cltq   
    1788:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    178c:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1790:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1797:	66 66 66 
    179a:	48 89 c8             	mov    %rcx,%rax
    179d:	48 f7 ea             	imul   %rdx
    17a0:	48 c1 fa 02          	sar    $0x2,%rdx
    17a4:	48 89 c8             	mov    %rcx,%rax
    17a7:	48 c1 f8 3f          	sar    $0x3f,%rax
    17ab:	48 29 c2             	sub    %rax,%rdx
    17ae:	48 89 d0             	mov    %rdx,%rax
    17b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    17b5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    17ba:	0f 85 7a ff ff ff    	jne    173a <print_d+0x2c>

  if (v < 0)
    17c0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    17c4:	79 32                	jns    17f8 <print_d+0xea>
    buf[i++] = '-';
    17c6:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17c9:	8d 50 01             	lea    0x1(%rax),%edx
    17cc:	89 55 f4             	mov    %edx,-0xc(%rbp)
    17cf:	48 98                	cltq   
    17d1:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    17d6:	eb 20                	jmp    17f8 <print_d+0xea>
    putc(fd, buf[i]);
    17d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17db:	48 98                	cltq   
    17dd:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    17e2:	0f be d0             	movsbl %al,%edx
    17e5:	8b 45 dc             	mov    -0x24(%rbp),%eax
    17e8:	89 d6                	mov    %edx,%esi
    17ea:	89 c7                	mov    %eax,%edi
    17ec:	48 b8 20 16 00 00 00 	movabs $0x1620,%rax
    17f3:	00 00 00 
    17f6:	ff d0                	callq  *%rax
  while (--i >= 0)
    17f8:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    17fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1800:	79 d6                	jns    17d8 <print_d+0xca>
}
    1802:	90                   	nop
    1803:	90                   	nop
    1804:	c9                   	leaveq 
    1805:	c3                   	retq   

0000000000001806 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1806:	f3 0f 1e fa          	endbr64 
    180a:	55                   	push   %rbp
    180b:	48 89 e5             	mov    %rsp,%rbp
    180e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1815:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    181b:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1822:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1829:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1830:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1837:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    183e:	84 c0                	test   %al,%al
    1840:	74 20                	je     1862 <printf+0x5c>
    1842:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1846:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    184a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    184e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1852:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1856:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    185a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    185e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1862:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1869:	00 00 00 
    186c:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1873:	00 00 00 
    1876:	48 8d 45 10          	lea    0x10(%rbp),%rax
    187a:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1881:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1888:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    188f:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1896:	00 00 00 
    1899:	e9 41 03 00 00       	jmpq   1bdf <printf+0x3d9>
    if (c != '%') {
    189e:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18a5:	74 24                	je     18cb <printf+0xc5>
      putc(fd, c);
    18a7:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    18ad:	0f be d0             	movsbl %al,%edx
    18b0:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18b6:	89 d6                	mov    %edx,%esi
    18b8:	89 c7                	mov    %eax,%edi
    18ba:	48 b8 20 16 00 00 00 	movabs $0x1620,%rax
    18c1:	00 00 00 
    18c4:	ff d0                	callq  *%rax
      continue;
    18c6:	e9 0d 03 00 00       	jmpq   1bd8 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    18cb:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    18d2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    18d8:	48 63 d0             	movslq %eax,%rdx
    18db:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    18e2:	48 01 d0             	add    %rdx,%rax
    18e5:	0f b6 00             	movzbl (%rax),%eax
    18e8:	0f be c0             	movsbl %al,%eax
    18eb:	25 ff 00 00 00       	and    $0xff,%eax
    18f0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    18f6:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    18fd:	0f 84 0f 03 00 00    	je     1c12 <printf+0x40c>
      break;
    switch(c) {
    1903:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    190a:	0f 84 74 02 00 00    	je     1b84 <printf+0x37e>
    1910:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1917:	0f 8c 82 02 00 00    	jl     1b9f <printf+0x399>
    191d:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1924:	0f 8f 75 02 00 00    	jg     1b9f <printf+0x399>
    192a:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1931:	0f 8c 68 02 00 00    	jl     1b9f <printf+0x399>
    1937:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    193d:	83 e8 63             	sub    $0x63,%eax
    1940:	83 f8 15             	cmp    $0x15,%eax
    1943:	0f 87 56 02 00 00    	ja     1b9f <printf+0x399>
    1949:	89 c0                	mov    %eax,%eax
    194b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1952:	00 
    1953:	48 b8 50 1f 00 00 00 	movabs $0x1f50,%rax
    195a:	00 00 00 
    195d:	48 01 d0             	add    %rdx,%rax
    1960:	48 8b 00             	mov    (%rax),%rax
    1963:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1966:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    196c:	83 f8 2f             	cmp    $0x2f,%eax
    196f:	77 23                	ja     1994 <printf+0x18e>
    1971:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1978:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    197e:	89 d2                	mov    %edx,%edx
    1980:	48 01 d0             	add    %rdx,%rax
    1983:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1989:	83 c2 08             	add    $0x8,%edx
    198c:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1992:	eb 12                	jmp    19a6 <printf+0x1a0>
    1994:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    199b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    199f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19a6:	8b 00                	mov    (%rax),%eax
    19a8:	0f be d0             	movsbl %al,%edx
    19ab:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19b1:	89 d6                	mov    %edx,%esi
    19b3:	89 c7                	mov    %eax,%edi
    19b5:	48 b8 20 16 00 00 00 	movabs $0x1620,%rax
    19bc:	00 00 00 
    19bf:	ff d0                	callq  *%rax
      break;
    19c1:	e9 12 02 00 00       	jmpq   1bd8 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    19c6:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19cc:	83 f8 2f             	cmp    $0x2f,%eax
    19cf:	77 23                	ja     19f4 <printf+0x1ee>
    19d1:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19d8:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19de:	89 d2                	mov    %edx,%edx
    19e0:	48 01 d0             	add    %rdx,%rax
    19e3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19e9:	83 c2 08             	add    $0x8,%edx
    19ec:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19f2:	eb 12                	jmp    1a06 <printf+0x200>
    19f4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19fb:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19ff:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a06:	8b 10                	mov    (%rax),%edx
    1a08:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a0e:	89 d6                	mov    %edx,%esi
    1a10:	89 c7                	mov    %eax,%edi
    1a12:	48 b8 0e 17 00 00 00 	movabs $0x170e,%rax
    1a19:	00 00 00 
    1a1c:	ff d0                	callq  *%rax
      break;
    1a1e:	e9 b5 01 00 00       	jmpq   1bd8 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1a23:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a29:	83 f8 2f             	cmp    $0x2f,%eax
    1a2c:	77 23                	ja     1a51 <printf+0x24b>
    1a2e:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a35:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a3b:	89 d2                	mov    %edx,%edx
    1a3d:	48 01 d0             	add    %rdx,%rax
    1a40:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a46:	83 c2 08             	add    $0x8,%edx
    1a49:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a4f:	eb 12                	jmp    1a63 <printf+0x25d>
    1a51:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a58:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a5c:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a63:	8b 10                	mov    (%rax),%edx
    1a65:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a6b:	89 d6                	mov    %edx,%esi
    1a6d:	89 c7                	mov    %eax,%edi
    1a6f:	48 b8 b1 16 00 00 00 	movabs $0x16b1,%rax
    1a76:	00 00 00 
    1a79:	ff d0                	callq  *%rax
      break;
    1a7b:	e9 58 01 00 00       	jmpq   1bd8 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1a80:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a86:	83 f8 2f             	cmp    $0x2f,%eax
    1a89:	77 23                	ja     1aae <printf+0x2a8>
    1a8b:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a92:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a98:	89 d2                	mov    %edx,%edx
    1a9a:	48 01 d0             	add    %rdx,%rax
    1a9d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1aa3:	83 c2 08             	add    $0x8,%edx
    1aa6:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1aac:	eb 12                	jmp    1ac0 <printf+0x2ba>
    1aae:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1ab5:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1ab9:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1ac0:	48 8b 10             	mov    (%rax),%rdx
    1ac3:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ac9:	48 89 d6             	mov    %rdx,%rsi
    1acc:	89 c7                	mov    %eax,%edi
    1ace:	48 b8 54 16 00 00 00 	movabs $0x1654,%rax
    1ad5:	00 00 00 
    1ad8:	ff d0                	callq  *%rax
      break;
    1ada:	e9 f9 00 00 00       	jmpq   1bd8 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1adf:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1ae5:	83 f8 2f             	cmp    $0x2f,%eax
    1ae8:	77 23                	ja     1b0d <printf+0x307>
    1aea:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1af1:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1af7:	89 d2                	mov    %edx,%edx
    1af9:	48 01 d0             	add    %rdx,%rax
    1afc:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b02:	83 c2 08             	add    $0x8,%edx
    1b05:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1b0b:	eb 12                	jmp    1b1f <printf+0x319>
    1b0d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b14:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b18:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b1f:	48 8b 00             	mov    (%rax),%rax
    1b22:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1b29:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1b30:	00 
    1b31:	75 41                	jne    1b74 <printf+0x36e>
        s = "(null)";
    1b33:	48 b8 48 1f 00 00 00 	movabs $0x1f48,%rax
    1b3a:	00 00 00 
    1b3d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1b44:	eb 2e                	jmp    1b74 <printf+0x36e>
        putc(fd, *(s++));
    1b46:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b4d:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1b51:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1b58:	0f b6 00             	movzbl (%rax),%eax
    1b5b:	0f be d0             	movsbl %al,%edx
    1b5e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b64:	89 d6                	mov    %edx,%esi
    1b66:	89 c7                	mov    %eax,%edi
    1b68:	48 b8 20 16 00 00 00 	movabs $0x1620,%rax
    1b6f:	00 00 00 
    1b72:	ff d0                	callq  *%rax
      while (*s)
    1b74:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b7b:	0f b6 00             	movzbl (%rax),%eax
    1b7e:	84 c0                	test   %al,%al
    1b80:	75 c4                	jne    1b46 <printf+0x340>
      break;
    1b82:	eb 54                	jmp    1bd8 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1b84:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b8a:	be 25 00 00 00       	mov    $0x25,%esi
    1b8f:	89 c7                	mov    %eax,%edi
    1b91:	48 b8 20 16 00 00 00 	movabs $0x1620,%rax
    1b98:	00 00 00 
    1b9b:	ff d0                	callq  *%rax
      break;
    1b9d:	eb 39                	jmp    1bd8 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1b9f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ba5:	be 25 00 00 00       	mov    $0x25,%esi
    1baa:	89 c7                	mov    %eax,%edi
    1bac:	48 b8 20 16 00 00 00 	movabs $0x1620,%rax
    1bb3:	00 00 00 
    1bb6:	ff d0                	callq  *%rax
      putc(fd, c);
    1bb8:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1bbe:	0f be d0             	movsbl %al,%edx
    1bc1:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1bc7:	89 d6                	mov    %edx,%esi
    1bc9:	89 c7                	mov    %eax,%edi
    1bcb:	48 b8 20 16 00 00 00 	movabs $0x1620,%rax
    1bd2:	00 00 00 
    1bd5:	ff d0                	callq  *%rax
      break;
    1bd7:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1bd8:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1bdf:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1be5:	48 63 d0             	movslq %eax,%rdx
    1be8:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1bef:	48 01 d0             	add    %rdx,%rax
    1bf2:	0f b6 00             	movzbl (%rax),%eax
    1bf5:	0f be c0             	movsbl %al,%eax
    1bf8:	25 ff 00 00 00       	and    $0xff,%eax
    1bfd:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1c03:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1c0a:	0f 85 8e fc ff ff    	jne    189e <printf+0x98>
    }
  }
}
    1c10:	eb 01                	jmp    1c13 <printf+0x40d>
      break;
    1c12:	90                   	nop
}
    1c13:	90                   	nop
    1c14:	c9                   	leaveq 
    1c15:	c3                   	retq   

0000000000001c16 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1c16:	f3 0f 1e fa          	endbr64 
    1c1a:	55                   	push   %rbp
    1c1b:	48 89 e5             	mov    %rsp,%rbp
    1c1e:	48 83 ec 18          	sub    $0x18,%rsp
    1c22:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1c26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1c2a:	48 83 e8 10          	sub    $0x10,%rax
    1c2e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c32:	48 b8 b0 22 00 00 00 	movabs $0x22b0,%rax
    1c39:	00 00 00 
    1c3c:	48 8b 00             	mov    (%rax),%rax
    1c3f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c43:	eb 2f                	jmp    1c74 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1c45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c49:	48 8b 00             	mov    (%rax),%rax
    1c4c:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c50:	72 17                	jb     1c69 <free+0x53>
    1c52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c56:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c5a:	77 2f                	ja     1c8b <free+0x75>
    1c5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c60:	48 8b 00             	mov    (%rax),%rax
    1c63:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c67:	72 22                	jb     1c8b <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c6d:	48 8b 00             	mov    (%rax),%rax
    1c70:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c78:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c7c:	76 c7                	jbe    1c45 <free+0x2f>
    1c7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c82:	48 8b 00             	mov    (%rax),%rax
    1c85:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c89:	73 ba                	jae    1c45 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1c8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c8f:	8b 40 08             	mov    0x8(%rax),%eax
    1c92:	89 c0                	mov    %eax,%eax
    1c94:	48 c1 e0 04          	shl    $0x4,%rax
    1c98:	48 89 c2             	mov    %rax,%rdx
    1c9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c9f:	48 01 c2             	add    %rax,%rdx
    1ca2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ca6:	48 8b 00             	mov    (%rax),%rax
    1ca9:	48 39 c2             	cmp    %rax,%rdx
    1cac:	75 2d                	jne    1cdb <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1cae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cb2:	8b 50 08             	mov    0x8(%rax),%edx
    1cb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cb9:	48 8b 00             	mov    (%rax),%rax
    1cbc:	8b 40 08             	mov    0x8(%rax),%eax
    1cbf:	01 c2                	add    %eax,%edx
    1cc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cc5:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1cc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ccc:	48 8b 00             	mov    (%rax),%rax
    1ccf:	48 8b 10             	mov    (%rax),%rdx
    1cd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cd6:	48 89 10             	mov    %rdx,(%rax)
    1cd9:	eb 0e                	jmp    1ce9 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1cdb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cdf:	48 8b 10             	mov    (%rax),%rdx
    1ce2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ce6:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1ce9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ced:	8b 40 08             	mov    0x8(%rax),%eax
    1cf0:	89 c0                	mov    %eax,%eax
    1cf2:	48 c1 e0 04          	shl    $0x4,%rax
    1cf6:	48 89 c2             	mov    %rax,%rdx
    1cf9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cfd:	48 01 d0             	add    %rdx,%rax
    1d00:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1d04:	75 27                	jne    1d2d <free+0x117>
    p->s.size += bp->s.size;
    1d06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d0a:	8b 50 08             	mov    0x8(%rax),%edx
    1d0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d11:	8b 40 08             	mov    0x8(%rax),%eax
    1d14:	01 c2                	add    %eax,%edx
    1d16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d1a:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1d1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d21:	48 8b 10             	mov    (%rax),%rdx
    1d24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d28:	48 89 10             	mov    %rdx,(%rax)
    1d2b:	eb 0b                	jmp    1d38 <free+0x122>
  } else
    p->s.ptr = bp;
    1d2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1d35:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1d38:	48 ba b0 22 00 00 00 	movabs $0x22b0,%rdx
    1d3f:	00 00 00 
    1d42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d46:	48 89 02             	mov    %rax,(%rdx)
}
    1d49:	90                   	nop
    1d4a:	c9                   	leaveq 
    1d4b:	c3                   	retq   

0000000000001d4c <morecore>:

static Header*
morecore(uint nu)
{
    1d4c:	f3 0f 1e fa          	endbr64 
    1d50:	55                   	push   %rbp
    1d51:	48 89 e5             	mov    %rsp,%rbp
    1d54:	48 83 ec 20          	sub    $0x20,%rsp
    1d58:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1d5b:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1d62:	77 07                	ja     1d6b <morecore+0x1f>
    nu = 4096;
    1d64:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1d6b:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d6e:	48 c1 e0 04          	shl    $0x4,%rax
    1d72:	48 89 c7             	mov    %rax,%rdi
    1d75:	48 b8 df 15 00 00 00 	movabs $0x15df,%rax
    1d7c:	00 00 00 
    1d7f:	ff d0                	callq  *%rax
    1d81:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1d85:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1d8a:	75 07                	jne    1d93 <morecore+0x47>
    return 0;
    1d8c:	b8 00 00 00 00       	mov    $0x0,%eax
    1d91:	eb 36                	jmp    1dc9 <morecore+0x7d>
  hp = (Header*)p;
    1d93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d97:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1d9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d9f:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1da2:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1da5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1da9:	48 83 c0 10          	add    $0x10,%rax
    1dad:	48 89 c7             	mov    %rax,%rdi
    1db0:	48 b8 16 1c 00 00 00 	movabs $0x1c16,%rax
    1db7:	00 00 00 
    1dba:	ff d0                	callq  *%rax
  return freep;
    1dbc:	48 b8 b0 22 00 00 00 	movabs $0x22b0,%rax
    1dc3:	00 00 00 
    1dc6:	48 8b 00             	mov    (%rax),%rax
}
    1dc9:	c9                   	leaveq 
    1dca:	c3                   	retq   

0000000000001dcb <malloc>:

void*
malloc(uint nbytes)
{
    1dcb:	f3 0f 1e fa          	endbr64 
    1dcf:	55                   	push   %rbp
    1dd0:	48 89 e5             	mov    %rsp,%rbp
    1dd3:	48 83 ec 30          	sub    $0x30,%rsp
    1dd7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1dda:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1ddd:	48 83 c0 0f          	add    $0xf,%rax
    1de1:	48 c1 e8 04          	shr    $0x4,%rax
    1de5:	83 c0 01             	add    $0x1,%eax
    1de8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1deb:	48 b8 b0 22 00 00 00 	movabs $0x22b0,%rax
    1df2:	00 00 00 
    1df5:	48 8b 00             	mov    (%rax),%rax
    1df8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1dfc:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1e01:	75 4a                	jne    1e4d <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1e03:	48 b8 a0 22 00 00 00 	movabs $0x22a0,%rax
    1e0a:	00 00 00 
    1e0d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e11:	48 ba b0 22 00 00 00 	movabs $0x22b0,%rdx
    1e18:	00 00 00 
    1e1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e1f:	48 89 02             	mov    %rax,(%rdx)
    1e22:	48 b8 b0 22 00 00 00 	movabs $0x22b0,%rax
    1e29:	00 00 00 
    1e2c:	48 8b 00             	mov    (%rax),%rax
    1e2f:	48 ba a0 22 00 00 00 	movabs $0x22a0,%rdx
    1e36:	00 00 00 
    1e39:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1e3c:	48 b8 a0 22 00 00 00 	movabs $0x22a0,%rax
    1e43:	00 00 00 
    1e46:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e51:	48 8b 00             	mov    (%rax),%rax
    1e54:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e5c:	8b 40 08             	mov    0x8(%rax),%eax
    1e5f:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e62:	77 65                	ja     1ec9 <malloc+0xfe>
      if(p->s.size == nunits)
    1e64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e68:	8b 40 08             	mov    0x8(%rax),%eax
    1e6b:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e6e:	75 10                	jne    1e80 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1e70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e74:	48 8b 10             	mov    (%rax),%rdx
    1e77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e7b:	48 89 10             	mov    %rdx,(%rax)
    1e7e:	eb 2e                	jmp    1eae <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1e80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e84:	8b 40 08             	mov    0x8(%rax),%eax
    1e87:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1e8a:	89 c2                	mov    %eax,%edx
    1e8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e90:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1e93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e97:	8b 40 08             	mov    0x8(%rax),%eax
    1e9a:	89 c0                	mov    %eax,%eax
    1e9c:	48 c1 e0 04          	shl    $0x4,%rax
    1ea0:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1ea4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ea8:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1eab:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1eae:	48 ba b0 22 00 00 00 	movabs $0x22b0,%rdx
    1eb5:	00 00 00 
    1eb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ebc:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1ebf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ec3:	48 83 c0 10          	add    $0x10,%rax
    1ec7:	eb 4e                	jmp    1f17 <malloc+0x14c>
    }
    if(p == freep)
    1ec9:	48 b8 b0 22 00 00 00 	movabs $0x22b0,%rax
    1ed0:	00 00 00 
    1ed3:	48 8b 00             	mov    (%rax),%rax
    1ed6:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1eda:	75 23                	jne    1eff <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1edc:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1edf:	89 c7                	mov    %eax,%edi
    1ee1:	48 b8 4c 1d 00 00 00 	movabs $0x1d4c,%rax
    1ee8:	00 00 00 
    1eeb:	ff d0                	callq  *%rax
    1eed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1ef1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1ef6:	75 07                	jne    1eff <malloc+0x134>
        return 0;
    1ef8:	b8 00 00 00 00       	mov    $0x0,%eax
    1efd:	eb 18                	jmp    1f17 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1eff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f03:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1f07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f0b:	48 8b 00             	mov    (%rax),%rax
    1f0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1f12:	e9 41 ff ff ff       	jmpq   1e58 <malloc+0x8d>
  }
}
    1f17:	c9                   	leaveq 
    1f18:	c3                   	retq   
