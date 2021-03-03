
_wc:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 30          	sub    $0x30,%rsp
    100c:	89 7d dc             	mov    %edi,-0x24(%rbp)
    100f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
    1013:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
    101a:	8b 45 f0             	mov    -0x10(%rbp),%eax
    101d:	89 45 f4             	mov    %eax,-0xc(%rbp)
    1020:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1023:	89 45 f8             	mov    %eax,-0x8(%rbp)
  inword = 0;
    1026:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    102d:	e9 81 00 00 00       	jmpq   10b3 <wc+0xb3>
    for(i=0; i<n; i++){
    1032:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1039:	eb 70                	jmp    10ab <wc+0xab>
      c++;
    103b:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
      if(buf[i] == '\n')
    103f:	48 ba 80 23 00 00 00 	movabs $0x2380,%rdx
    1046:	00 00 00 
    1049:	8b 45 fc             	mov    -0x4(%rbp),%eax
    104c:	48 98                	cltq   
    104e:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1052:	3c 0a                	cmp    $0xa,%al
    1054:	75 04                	jne    105a <wc+0x5a>
        l++;
    1056:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
      if(strchr(" \r\t\n\v", buf[i]))
    105a:	48 ba 80 23 00 00 00 	movabs $0x2380,%rdx
    1061:	00 00 00 
    1064:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1067:	48 98                	cltq   
    1069:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    106d:	0f be c0             	movsbl %al,%eax
    1070:	89 c6                	mov    %eax,%esi
    1072:	48 bf c8 1f 00 00 00 	movabs $0x1fc8,%rdi
    1079:	00 00 00 
    107c:	48 b8 b0 13 00 00 00 	movabs $0x13b0,%rax
    1083:	00 00 00 
    1086:	ff d0                	callq  *%rax
    1088:	48 85 c0             	test   %rax,%rax
    108b:	74 09                	je     1096 <wc+0x96>
        inword = 0;
    108d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    1094:	eb 11                	jmp    10a7 <wc+0xa7>
      else if(!inword){
    1096:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
    109a:	75 0b                	jne    10a7 <wc+0xa7>
        w++;
    109c:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
        inword = 1;
    10a0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
    for(i=0; i<n; i++){
    10a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    10ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10ae:	3b 45 e8             	cmp    -0x18(%rbp),%eax
    10b1:	7c 88                	jl     103b <wc+0x3b>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    10b3:	8b 45 dc             	mov    -0x24(%rbp),%eax
    10b6:	ba 00 02 00 00       	mov    $0x200,%edx
    10bb:	48 be 80 23 00 00 00 	movabs $0x2380,%rsi
    10c2:	00 00 00 
    10c5:	89 c7                	mov    %eax,%edi
    10c7:	48 b8 d5 15 00 00 00 	movabs $0x15d5,%rax
    10ce:	00 00 00 
    10d1:	ff d0                	callq  *%rax
    10d3:	89 45 e8             	mov    %eax,-0x18(%rbp)
    10d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
    10da:	0f 8f 52 ff ff ff    	jg     1032 <wc+0x32>
      }
    }
  }
  if(n < 0){
    10e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
    10e4:	79 2c                	jns    1112 <wc+0x112>
    printf(1, "wc: read error\n");
    10e6:	48 be ce 1f 00 00 00 	movabs $0x1fce,%rsi
    10ed:	00 00 00 
    10f0:	bf 01 00 00 00       	mov    $0x1,%edi
    10f5:	b8 00 00 00 00       	mov    $0x0,%eax
    10fa:	48 ba b2 18 00 00 00 	movabs $0x18b2,%rdx
    1101:	00 00 00 
    1104:	ff d2                	callq  *%rdx
    exit();
    1106:	48 b8 ae 15 00 00 00 	movabs $0x15ae,%rax
    110d:	00 00 00 
    1110:	ff d0                	callq  *%rax
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
    1112:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
    1116:	8b 4d f0             	mov    -0x10(%rbp),%ecx
    1119:	8b 55 f4             	mov    -0xc(%rbp),%edx
    111c:	8b 45 f8             	mov    -0x8(%rbp),%eax
    111f:	49 89 f1             	mov    %rsi,%r9
    1122:	41 89 c8             	mov    %ecx,%r8d
    1125:	89 d1                	mov    %edx,%ecx
    1127:	89 c2                	mov    %eax,%edx
    1129:	48 be de 1f 00 00 00 	movabs $0x1fde,%rsi
    1130:	00 00 00 
    1133:	bf 01 00 00 00       	mov    $0x1,%edi
    1138:	b8 00 00 00 00       	mov    $0x0,%eax
    113d:	49 ba b2 18 00 00 00 	movabs $0x18b2,%r10
    1144:	00 00 00 
    1147:	41 ff d2             	callq  *%r10
}
    114a:	90                   	nop
    114b:	c9                   	leaveq 
    114c:	c3                   	retq   

000000000000114d <main>:

int
main(int argc, char *argv[])
{
    114d:	f3 0f 1e fa          	endbr64 
    1151:	55                   	push   %rbp
    1152:	48 89 e5             	mov    %rsp,%rbp
    1155:	48 83 ec 20          	sub    $0x20,%rsp
    1159:	89 7d ec             	mov    %edi,-0x14(%rbp)
    115c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd, i;

  if(argc <= 1){
    1160:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
    1164:	7f 27                	jg     118d <main+0x40>
    wc(0, "");
    1166:	48 be eb 1f 00 00 00 	movabs $0x1feb,%rsi
    116d:	00 00 00 
    1170:	bf 00 00 00 00       	mov    $0x0,%edi
    1175:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    117c:	00 00 00 
    117f:	ff d0                	callq  *%rax
    exit();
    1181:	48 b8 ae 15 00 00 00 	movabs $0x15ae,%rax
    1188:	00 00 00 
    118b:	ff d0                	callq  *%rax
  }

  for(i = 1; i < argc; i++){
    118d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    1194:	e9 ba 00 00 00       	jmpq   1253 <main+0x106>
    if((fd = open(argv[i], 0)) < 0){
    1199:	8b 45 fc             	mov    -0x4(%rbp),%eax
    119c:	48 98                	cltq   
    119e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    11a5:	00 
    11a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    11aa:	48 01 d0             	add    %rdx,%rax
    11ad:	48 8b 00             	mov    (%rax),%rax
    11b0:	be 00 00 00 00       	mov    $0x0,%esi
    11b5:	48 89 c7             	mov    %rax,%rdi
    11b8:	48 b8 16 16 00 00 00 	movabs $0x1616,%rax
    11bf:	00 00 00 
    11c2:	ff d0                	callq  *%rax
    11c4:	89 45 f8             	mov    %eax,-0x8(%rbp)
    11c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    11cb:	79 46                	jns    1213 <main+0xc6>
      printf(1, "wc: cannot open %s\n", argv[i]);
    11cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11d0:	48 98                	cltq   
    11d2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    11d9:	00 
    11da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    11de:	48 01 d0             	add    %rdx,%rax
    11e1:	48 8b 00             	mov    (%rax),%rax
    11e4:	48 89 c2             	mov    %rax,%rdx
    11e7:	48 be ec 1f 00 00 00 	movabs $0x1fec,%rsi
    11ee:	00 00 00 
    11f1:	bf 01 00 00 00       	mov    $0x1,%edi
    11f6:	b8 00 00 00 00       	mov    $0x0,%eax
    11fb:	48 b9 b2 18 00 00 00 	movabs $0x18b2,%rcx
    1202:	00 00 00 
    1205:	ff d1                	callq  *%rcx
      exit();
    1207:	48 b8 ae 15 00 00 00 	movabs $0x15ae,%rax
    120e:	00 00 00 
    1211:	ff d0                	callq  *%rax
    }
    wc(fd, argv[i]);
    1213:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1216:	48 98                	cltq   
    1218:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    121f:	00 
    1220:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1224:	48 01 d0             	add    %rdx,%rax
    1227:	48 8b 10             	mov    (%rax),%rdx
    122a:	8b 45 f8             	mov    -0x8(%rbp),%eax
    122d:	48 89 d6             	mov    %rdx,%rsi
    1230:	89 c7                	mov    %eax,%edi
    1232:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1239:	00 00 00 
    123c:	ff d0                	callq  *%rax
    close(fd);
    123e:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1241:	89 c7                	mov    %eax,%edi
    1243:	48 b8 ef 15 00 00 00 	movabs $0x15ef,%rax
    124a:	00 00 00 
    124d:	ff d0                	callq  *%rax
  for(i = 1; i < argc; i++){
    124f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1253:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1256:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1259:	0f 8c 3a ff ff ff    	jl     1199 <main+0x4c>
  }
  exit();
    125f:	48 b8 ae 15 00 00 00 	movabs $0x15ae,%rax
    1266:	00 00 00 
    1269:	ff d0                	callq  *%rax

000000000000126b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    126b:	f3 0f 1e fa          	endbr64 
    126f:	55                   	push   %rbp
    1270:	48 89 e5             	mov    %rsp,%rbp
    1273:	48 83 ec 10          	sub    $0x10,%rsp
    1277:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    127b:	89 75 f4             	mov    %esi,-0xc(%rbp)
    127e:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    1281:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1285:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1288:	8b 45 f4             	mov    -0xc(%rbp),%eax
    128b:	48 89 ce             	mov    %rcx,%rsi
    128e:	48 89 f7             	mov    %rsi,%rdi
    1291:	89 d1                	mov    %edx,%ecx
    1293:	fc                   	cld    
    1294:	f3 aa                	rep stos %al,%es:(%rdi)
    1296:	89 ca                	mov    %ecx,%edx
    1298:	48 89 fe             	mov    %rdi,%rsi
    129b:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    129f:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    12a2:	90                   	nop
    12a3:	c9                   	leaveq 
    12a4:	c3                   	retq   

00000000000012a5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    12a5:	f3 0f 1e fa          	endbr64 
    12a9:	55                   	push   %rbp
    12aa:	48 89 e5             	mov    %rsp,%rbp
    12ad:	48 83 ec 20          	sub    $0x20,%rsp
    12b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    12b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    12c1:	90                   	nop
    12c2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    12c6:	48 8d 42 01          	lea    0x1(%rdx),%rax
    12ca:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    12ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12d2:	48 8d 48 01          	lea    0x1(%rax),%rcx
    12d6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    12da:	0f b6 12             	movzbl (%rdx),%edx
    12dd:	88 10                	mov    %dl,(%rax)
    12df:	0f b6 00             	movzbl (%rax),%eax
    12e2:	84 c0                	test   %al,%al
    12e4:	75 dc                	jne    12c2 <strcpy+0x1d>
    ;
  return os;
    12e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    12ea:	c9                   	leaveq 
    12eb:	c3                   	retq   

00000000000012ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
    12ec:	f3 0f 1e fa          	endbr64 
    12f0:	55                   	push   %rbp
    12f1:	48 89 e5             	mov    %rsp,%rbp
    12f4:	48 83 ec 10          	sub    $0x10,%rsp
    12f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12fc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1300:	eb 0a                	jmp    130c <strcmp+0x20>
    p++, q++;
    1302:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1307:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    130c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1310:	0f b6 00             	movzbl (%rax),%eax
    1313:	84 c0                	test   %al,%al
    1315:	74 12                	je     1329 <strcmp+0x3d>
    1317:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    131b:	0f b6 10             	movzbl (%rax),%edx
    131e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1322:	0f b6 00             	movzbl (%rax),%eax
    1325:	38 c2                	cmp    %al,%dl
    1327:	74 d9                	je     1302 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1329:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    132d:	0f b6 00             	movzbl (%rax),%eax
    1330:	0f b6 d0             	movzbl %al,%edx
    1333:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1337:	0f b6 00             	movzbl (%rax),%eax
    133a:	0f b6 c0             	movzbl %al,%eax
    133d:	29 c2                	sub    %eax,%edx
    133f:	89 d0                	mov    %edx,%eax
}
    1341:	c9                   	leaveq 
    1342:	c3                   	retq   

0000000000001343 <strlen>:

uint
strlen(char *s)
{
    1343:	f3 0f 1e fa          	endbr64 
    1347:	55                   	push   %rbp
    1348:	48 89 e5             	mov    %rsp,%rbp
    134b:	48 83 ec 18          	sub    $0x18,%rsp
    134f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1353:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    135a:	eb 04                	jmp    1360 <strlen+0x1d>
    135c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1360:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1363:	48 63 d0             	movslq %eax,%rdx
    1366:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    136a:	48 01 d0             	add    %rdx,%rax
    136d:	0f b6 00             	movzbl (%rax),%eax
    1370:	84 c0                	test   %al,%al
    1372:	75 e8                	jne    135c <strlen+0x19>
    ;
  return n;
    1374:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1377:	c9                   	leaveq 
    1378:	c3                   	retq   

0000000000001379 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1379:	f3 0f 1e fa          	endbr64 
    137d:	55                   	push   %rbp
    137e:	48 89 e5             	mov    %rsp,%rbp
    1381:	48 83 ec 10          	sub    $0x10,%rsp
    1385:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1389:	89 75 f4             	mov    %esi,-0xc(%rbp)
    138c:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    138f:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1392:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    1395:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1399:	89 ce                	mov    %ecx,%esi
    139b:	48 89 c7             	mov    %rax,%rdi
    139e:	48 b8 6b 12 00 00 00 	movabs $0x126b,%rax
    13a5:	00 00 00 
    13a8:	ff d0                	callq  *%rax
  return dst;
    13aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    13ae:	c9                   	leaveq 
    13af:	c3                   	retq   

00000000000013b0 <strchr>:

char*
strchr(const char *s, char c)
{
    13b0:	f3 0f 1e fa          	endbr64 
    13b4:	55                   	push   %rbp
    13b5:	48 89 e5             	mov    %rsp,%rbp
    13b8:	48 83 ec 10          	sub    $0x10,%rsp
    13bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    13c0:	89 f0                	mov    %esi,%eax
    13c2:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    13c5:	eb 17                	jmp    13de <strchr+0x2e>
    if(*s == c)
    13c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13cb:	0f b6 00             	movzbl (%rax),%eax
    13ce:	38 45 f4             	cmp    %al,-0xc(%rbp)
    13d1:	75 06                	jne    13d9 <strchr+0x29>
      return (char*)s;
    13d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13d7:	eb 15                	jmp    13ee <strchr+0x3e>
  for(; *s; s++)
    13d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    13de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13e2:	0f b6 00             	movzbl (%rax),%eax
    13e5:	84 c0                	test   %al,%al
    13e7:	75 de                	jne    13c7 <strchr+0x17>
  return 0;
    13e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
    13ee:	c9                   	leaveq 
    13ef:	c3                   	retq   

00000000000013f0 <gets>:

char*
gets(char *buf, int max)
{
    13f0:	f3 0f 1e fa          	endbr64 
    13f4:	55                   	push   %rbp
    13f5:	48 89 e5             	mov    %rsp,%rbp
    13f8:	48 83 ec 20          	sub    $0x20,%rsp
    13fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1400:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1403:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    140a:	eb 4f                	jmp    145b <gets+0x6b>
    cc = read(0, &c, 1);
    140c:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1410:	ba 01 00 00 00       	mov    $0x1,%edx
    1415:	48 89 c6             	mov    %rax,%rsi
    1418:	bf 00 00 00 00       	mov    $0x0,%edi
    141d:	48 b8 d5 15 00 00 00 	movabs $0x15d5,%rax
    1424:	00 00 00 
    1427:	ff d0                	callq  *%rax
    1429:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    142c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1430:	7e 36                	jle    1468 <gets+0x78>
      break;
    buf[i++] = c;
    1432:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1435:	8d 50 01             	lea    0x1(%rax),%edx
    1438:	89 55 fc             	mov    %edx,-0x4(%rbp)
    143b:	48 63 d0             	movslq %eax,%rdx
    143e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1442:	48 01 c2             	add    %rax,%rdx
    1445:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1449:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    144b:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    144f:	3c 0a                	cmp    $0xa,%al
    1451:	74 16                	je     1469 <gets+0x79>
    1453:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1457:	3c 0d                	cmp    $0xd,%al
    1459:	74 0e                	je     1469 <gets+0x79>
  for(i=0; i+1 < max; ){
    145b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    145e:	83 c0 01             	add    $0x1,%eax
    1461:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    1464:	7f a6                	jg     140c <gets+0x1c>
    1466:	eb 01                	jmp    1469 <gets+0x79>
      break;
    1468:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1469:	8b 45 fc             	mov    -0x4(%rbp),%eax
    146c:	48 63 d0             	movslq %eax,%rdx
    146f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1473:	48 01 d0             	add    %rdx,%rax
    1476:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1479:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    147d:	c9                   	leaveq 
    147e:	c3                   	retq   

000000000000147f <stat>:

int
stat(char *n, struct stat *st)
{
    147f:	f3 0f 1e fa          	endbr64 
    1483:	55                   	push   %rbp
    1484:	48 89 e5             	mov    %rsp,%rbp
    1487:	48 83 ec 20          	sub    $0x20,%rsp
    148b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    148f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1497:	be 00 00 00 00       	mov    $0x0,%esi
    149c:	48 89 c7             	mov    %rax,%rdi
    149f:	48 b8 16 16 00 00 00 	movabs $0x1616,%rax
    14a6:	00 00 00 
    14a9:	ff d0                	callq  *%rax
    14ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    14ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    14b2:	79 07                	jns    14bb <stat+0x3c>
    return -1;
    14b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    14b9:	eb 2f                	jmp    14ea <stat+0x6b>
  r = fstat(fd, st);
    14bb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    14bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14c2:	48 89 d6             	mov    %rdx,%rsi
    14c5:	89 c7                	mov    %eax,%edi
    14c7:	48 b8 3d 16 00 00 00 	movabs $0x163d,%rax
    14ce:	00 00 00 
    14d1:	ff d0                	callq  *%rax
    14d3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    14d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14d9:	89 c7                	mov    %eax,%edi
    14db:	48 b8 ef 15 00 00 00 	movabs $0x15ef,%rax
    14e2:	00 00 00 
    14e5:	ff d0                	callq  *%rax
  return r;
    14e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    14ea:	c9                   	leaveq 
    14eb:	c3                   	retq   

00000000000014ec <atoi>:

int
atoi(const char *s)
{
    14ec:	f3 0f 1e fa          	endbr64 
    14f0:	55                   	push   %rbp
    14f1:	48 89 e5             	mov    %rsp,%rbp
    14f4:	48 83 ec 18          	sub    $0x18,%rsp
    14f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    14fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1503:	eb 28                	jmp    152d <atoi+0x41>
    n = n*10 + *s++ - '0';
    1505:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1508:	89 d0                	mov    %edx,%eax
    150a:	c1 e0 02             	shl    $0x2,%eax
    150d:	01 d0                	add    %edx,%eax
    150f:	01 c0                	add    %eax,%eax
    1511:	89 c1                	mov    %eax,%ecx
    1513:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1517:	48 8d 50 01          	lea    0x1(%rax),%rdx
    151b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    151f:	0f b6 00             	movzbl (%rax),%eax
    1522:	0f be c0             	movsbl %al,%eax
    1525:	01 c8                	add    %ecx,%eax
    1527:	83 e8 30             	sub    $0x30,%eax
    152a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    152d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1531:	0f b6 00             	movzbl (%rax),%eax
    1534:	3c 2f                	cmp    $0x2f,%al
    1536:	7e 0b                	jle    1543 <atoi+0x57>
    1538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    153c:	0f b6 00             	movzbl (%rax),%eax
    153f:	3c 39                	cmp    $0x39,%al
    1541:	7e c2                	jle    1505 <atoi+0x19>
  return n;
    1543:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1546:	c9                   	leaveq 
    1547:	c3                   	retq   

0000000000001548 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1548:	f3 0f 1e fa          	endbr64 
    154c:	55                   	push   %rbp
    154d:	48 89 e5             	mov    %rsp,%rbp
    1550:	48 83 ec 28          	sub    $0x28,%rsp
    1554:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1558:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    155c:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    155f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1563:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1567:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    156b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    156f:	eb 1d                	jmp    158e <memmove+0x46>
    *dst++ = *src++;
    1571:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1575:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1579:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    157d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1581:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1585:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    1589:	0f b6 12             	movzbl (%rdx),%edx
    158c:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    158e:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1591:	8d 50 ff             	lea    -0x1(%rax),%edx
    1594:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1597:	85 c0                	test   %eax,%eax
    1599:	7f d6                	jg     1571 <memmove+0x29>
  return vdst;
    159b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    159f:	c9                   	leaveq 
    15a0:	c3                   	retq   

00000000000015a1 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    15a1:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    15a8:	49 89 ca             	mov    %rcx,%r10
    15ab:	0f 05                	syscall 
    15ad:	c3                   	retq   

00000000000015ae <exit>:
SYSCALL(exit)
    15ae:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    15b5:	49 89 ca             	mov    %rcx,%r10
    15b8:	0f 05                	syscall 
    15ba:	c3                   	retq   

00000000000015bb <wait>:
SYSCALL(wait)
    15bb:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    15c2:	49 89 ca             	mov    %rcx,%r10
    15c5:	0f 05                	syscall 
    15c7:	c3                   	retq   

00000000000015c8 <pipe>:
SYSCALL(pipe)
    15c8:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    15cf:	49 89 ca             	mov    %rcx,%r10
    15d2:	0f 05                	syscall 
    15d4:	c3                   	retq   

00000000000015d5 <read>:
SYSCALL(read)
    15d5:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    15dc:	49 89 ca             	mov    %rcx,%r10
    15df:	0f 05                	syscall 
    15e1:	c3                   	retq   

00000000000015e2 <write>:
SYSCALL(write)
    15e2:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    15e9:	49 89 ca             	mov    %rcx,%r10
    15ec:	0f 05                	syscall 
    15ee:	c3                   	retq   

00000000000015ef <close>:
SYSCALL(close)
    15ef:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    15f6:	49 89 ca             	mov    %rcx,%r10
    15f9:	0f 05                	syscall 
    15fb:	c3                   	retq   

00000000000015fc <kill>:
SYSCALL(kill)
    15fc:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1603:	49 89 ca             	mov    %rcx,%r10
    1606:	0f 05                	syscall 
    1608:	c3                   	retq   

0000000000001609 <exec>:
SYSCALL(exec)
    1609:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1610:	49 89 ca             	mov    %rcx,%r10
    1613:	0f 05                	syscall 
    1615:	c3                   	retq   

0000000000001616 <open>:
SYSCALL(open)
    1616:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    161d:	49 89 ca             	mov    %rcx,%r10
    1620:	0f 05                	syscall 
    1622:	c3                   	retq   

0000000000001623 <mknod>:
SYSCALL(mknod)
    1623:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    162a:	49 89 ca             	mov    %rcx,%r10
    162d:	0f 05                	syscall 
    162f:	c3                   	retq   

0000000000001630 <unlink>:
SYSCALL(unlink)
    1630:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1637:	49 89 ca             	mov    %rcx,%r10
    163a:	0f 05                	syscall 
    163c:	c3                   	retq   

000000000000163d <fstat>:
SYSCALL(fstat)
    163d:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1644:	49 89 ca             	mov    %rcx,%r10
    1647:	0f 05                	syscall 
    1649:	c3                   	retq   

000000000000164a <link>:
SYSCALL(link)
    164a:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1651:	49 89 ca             	mov    %rcx,%r10
    1654:	0f 05                	syscall 
    1656:	c3                   	retq   

0000000000001657 <mkdir>:
SYSCALL(mkdir)
    1657:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    165e:	49 89 ca             	mov    %rcx,%r10
    1661:	0f 05                	syscall 
    1663:	c3                   	retq   

0000000000001664 <chdir>:
SYSCALL(chdir)
    1664:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    166b:	49 89 ca             	mov    %rcx,%r10
    166e:	0f 05                	syscall 
    1670:	c3                   	retq   

0000000000001671 <dup>:
SYSCALL(dup)
    1671:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1678:	49 89 ca             	mov    %rcx,%r10
    167b:	0f 05                	syscall 
    167d:	c3                   	retq   

000000000000167e <getpid>:
SYSCALL(getpid)
    167e:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    1685:	49 89 ca             	mov    %rcx,%r10
    1688:	0f 05                	syscall 
    168a:	c3                   	retq   

000000000000168b <sbrk>:
SYSCALL(sbrk)
    168b:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    1692:	49 89 ca             	mov    %rcx,%r10
    1695:	0f 05                	syscall 
    1697:	c3                   	retq   

0000000000001698 <sleep>:
SYSCALL(sleep)
    1698:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    169f:	49 89 ca             	mov    %rcx,%r10
    16a2:	0f 05                	syscall 
    16a4:	c3                   	retq   

00000000000016a5 <uptime>:
SYSCALL(uptime)
    16a5:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    16ac:	49 89 ca             	mov    %rcx,%r10
    16af:	0f 05                	syscall 
    16b1:	c3                   	retq   

00000000000016b2 <dedup>:
SYSCALL(dedup)
    16b2:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    16b9:	49 89 ca             	mov    %rcx,%r10
    16bc:	0f 05                	syscall 
    16be:	c3                   	retq   

00000000000016bf <freepages>:
SYSCALL(freepages)
    16bf:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    16c6:	49 89 ca             	mov    %rcx,%r10
    16c9:	0f 05                	syscall 
    16cb:	c3                   	retq   

00000000000016cc <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    16cc:	f3 0f 1e fa          	endbr64 
    16d0:	55                   	push   %rbp
    16d1:	48 89 e5             	mov    %rsp,%rbp
    16d4:	48 83 ec 10          	sub    $0x10,%rsp
    16d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
    16db:	89 f0                	mov    %esi,%eax
    16dd:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    16e0:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    16e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16e7:	ba 01 00 00 00       	mov    $0x1,%edx
    16ec:	48 89 ce             	mov    %rcx,%rsi
    16ef:	89 c7                	mov    %eax,%edi
    16f1:	48 b8 e2 15 00 00 00 	movabs $0x15e2,%rax
    16f8:	00 00 00 
    16fb:	ff d0                	callq  *%rax
}
    16fd:	90                   	nop
    16fe:	c9                   	leaveq 
    16ff:	c3                   	retq   

0000000000001700 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1700:	f3 0f 1e fa          	endbr64 
    1704:	55                   	push   %rbp
    1705:	48 89 e5             	mov    %rsp,%rbp
    1708:	48 83 ec 20          	sub    $0x20,%rsp
    170c:	89 7d ec             	mov    %edi,-0x14(%rbp)
    170f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1713:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    171a:	eb 35                	jmp    1751 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    171c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1720:	48 c1 e8 3c          	shr    $0x3c,%rax
    1724:	48 ba 50 23 00 00 00 	movabs $0x2350,%rdx
    172b:	00 00 00 
    172e:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1732:	0f be d0             	movsbl %al,%edx
    1735:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1738:	89 d6                	mov    %edx,%esi
    173a:	89 c7                	mov    %eax,%edi
    173c:	48 b8 cc 16 00 00 00 	movabs $0x16cc,%rax
    1743:	00 00 00 
    1746:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1748:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    174c:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1751:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1754:	83 f8 0f             	cmp    $0xf,%eax
    1757:	76 c3                	jbe    171c <print_x64+0x1c>
}
    1759:	90                   	nop
    175a:	90                   	nop
    175b:	c9                   	leaveq 
    175c:	c3                   	retq   

000000000000175d <print_x32>:

  static void
print_x32(int fd, uint x)
{
    175d:	f3 0f 1e fa          	endbr64 
    1761:	55                   	push   %rbp
    1762:	48 89 e5             	mov    %rsp,%rbp
    1765:	48 83 ec 20          	sub    $0x20,%rsp
    1769:	89 7d ec             	mov    %edi,-0x14(%rbp)
    176c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    176f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1776:	eb 36                	jmp    17ae <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1778:	8b 45 e8             	mov    -0x18(%rbp),%eax
    177b:	c1 e8 1c             	shr    $0x1c,%eax
    177e:	89 c2                	mov    %eax,%edx
    1780:	48 b8 50 23 00 00 00 	movabs $0x2350,%rax
    1787:	00 00 00 
    178a:	89 d2                	mov    %edx,%edx
    178c:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    1790:	0f be d0             	movsbl %al,%edx
    1793:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1796:	89 d6                	mov    %edx,%esi
    1798:	89 c7                	mov    %eax,%edi
    179a:	48 b8 cc 16 00 00 00 	movabs $0x16cc,%rax
    17a1:	00 00 00 
    17a4:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    17a6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    17aa:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    17ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
    17b1:	83 f8 07             	cmp    $0x7,%eax
    17b4:	76 c2                	jbe    1778 <print_x32+0x1b>
}
    17b6:	90                   	nop
    17b7:	90                   	nop
    17b8:	c9                   	leaveq 
    17b9:	c3                   	retq   

00000000000017ba <print_d>:

  static void
print_d(int fd, int v)
{
    17ba:	f3 0f 1e fa          	endbr64 
    17be:	55                   	push   %rbp
    17bf:	48 89 e5             	mov    %rsp,%rbp
    17c2:	48 83 ec 30          	sub    $0x30,%rsp
    17c6:	89 7d dc             	mov    %edi,-0x24(%rbp)
    17c9:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    17cc:	8b 45 d8             	mov    -0x28(%rbp),%eax
    17cf:	48 98                	cltq   
    17d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    17d5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    17d9:	79 04                	jns    17df <print_d+0x25>
    x = -x;
    17db:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    17df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    17e6:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    17ea:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    17f1:	66 66 66 
    17f4:	48 89 c8             	mov    %rcx,%rax
    17f7:	48 f7 ea             	imul   %rdx
    17fa:	48 c1 fa 02          	sar    $0x2,%rdx
    17fe:	48 89 c8             	mov    %rcx,%rax
    1801:	48 c1 f8 3f          	sar    $0x3f,%rax
    1805:	48 29 c2             	sub    %rax,%rdx
    1808:	48 89 d0             	mov    %rdx,%rax
    180b:	48 c1 e0 02          	shl    $0x2,%rax
    180f:	48 01 d0             	add    %rdx,%rax
    1812:	48 01 c0             	add    %rax,%rax
    1815:	48 29 c1             	sub    %rax,%rcx
    1818:	48 89 ca             	mov    %rcx,%rdx
    181b:	8b 45 f4             	mov    -0xc(%rbp),%eax
    181e:	8d 48 01             	lea    0x1(%rax),%ecx
    1821:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1824:	48 b9 50 23 00 00 00 	movabs $0x2350,%rcx
    182b:	00 00 00 
    182e:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1832:	48 98                	cltq   
    1834:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1838:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    183c:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1843:	66 66 66 
    1846:	48 89 c8             	mov    %rcx,%rax
    1849:	48 f7 ea             	imul   %rdx
    184c:	48 c1 fa 02          	sar    $0x2,%rdx
    1850:	48 89 c8             	mov    %rcx,%rax
    1853:	48 c1 f8 3f          	sar    $0x3f,%rax
    1857:	48 29 c2             	sub    %rax,%rdx
    185a:	48 89 d0             	mov    %rdx,%rax
    185d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1861:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1866:	0f 85 7a ff ff ff    	jne    17e6 <print_d+0x2c>

  if (v < 0)
    186c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1870:	79 32                	jns    18a4 <print_d+0xea>
    buf[i++] = '-';
    1872:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1875:	8d 50 01             	lea    0x1(%rax),%edx
    1878:	89 55 f4             	mov    %edx,-0xc(%rbp)
    187b:	48 98                	cltq   
    187d:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1882:	eb 20                	jmp    18a4 <print_d+0xea>
    putc(fd, buf[i]);
    1884:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1887:	48 98                	cltq   
    1889:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    188e:	0f be d0             	movsbl %al,%edx
    1891:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1894:	89 d6                	mov    %edx,%esi
    1896:	89 c7                	mov    %eax,%edi
    1898:	48 b8 cc 16 00 00 00 	movabs $0x16cc,%rax
    189f:	00 00 00 
    18a2:	ff d0                	callq  *%rax
  while (--i >= 0)
    18a4:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    18a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    18ac:	79 d6                	jns    1884 <print_d+0xca>
}
    18ae:	90                   	nop
    18af:	90                   	nop
    18b0:	c9                   	leaveq 
    18b1:	c3                   	retq   

00000000000018b2 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    18b2:	f3 0f 1e fa          	endbr64 
    18b6:	55                   	push   %rbp
    18b7:	48 89 e5             	mov    %rsp,%rbp
    18ba:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    18c1:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    18c7:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    18ce:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    18d5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    18dc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    18e3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    18ea:	84 c0                	test   %al,%al
    18ec:	74 20                	je     190e <printf+0x5c>
    18ee:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    18f2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    18f6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    18fa:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    18fe:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1902:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1906:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    190a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    190e:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1915:	00 00 00 
    1918:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    191f:	00 00 00 
    1922:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1926:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    192d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1934:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    193b:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1942:	00 00 00 
    1945:	e9 41 03 00 00       	jmpq   1c8b <printf+0x3d9>
    if (c != '%') {
    194a:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1951:	74 24                	je     1977 <printf+0xc5>
      putc(fd, c);
    1953:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1959:	0f be d0             	movsbl %al,%edx
    195c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1962:	89 d6                	mov    %edx,%esi
    1964:	89 c7                	mov    %eax,%edi
    1966:	48 b8 cc 16 00 00 00 	movabs $0x16cc,%rax
    196d:	00 00 00 
    1970:	ff d0                	callq  *%rax
      continue;
    1972:	e9 0d 03 00 00       	jmpq   1c84 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1977:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    197e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1984:	48 63 d0             	movslq %eax,%rdx
    1987:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    198e:	48 01 d0             	add    %rdx,%rax
    1991:	0f b6 00             	movzbl (%rax),%eax
    1994:	0f be c0             	movsbl %al,%eax
    1997:	25 ff 00 00 00       	and    $0xff,%eax
    199c:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    19a2:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    19a9:	0f 84 0f 03 00 00    	je     1cbe <printf+0x40c>
      break;
    switch(c) {
    19af:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    19b6:	0f 84 74 02 00 00    	je     1c30 <printf+0x37e>
    19bc:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    19c3:	0f 8c 82 02 00 00    	jl     1c4b <printf+0x399>
    19c9:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    19d0:	0f 8f 75 02 00 00    	jg     1c4b <printf+0x399>
    19d6:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    19dd:	0f 8c 68 02 00 00    	jl     1c4b <printf+0x399>
    19e3:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    19e9:	83 e8 63             	sub    $0x63,%eax
    19ec:	83 f8 15             	cmp    $0x15,%eax
    19ef:	0f 87 56 02 00 00    	ja     1c4b <printf+0x399>
    19f5:	89 c0                	mov    %eax,%eax
    19f7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    19fe:	00 
    19ff:	48 b8 08 20 00 00 00 	movabs $0x2008,%rax
    1a06:	00 00 00 
    1a09:	48 01 d0             	add    %rdx,%rax
    1a0c:	48 8b 00             	mov    (%rax),%rax
    1a0f:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1a12:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a18:	83 f8 2f             	cmp    $0x2f,%eax
    1a1b:	77 23                	ja     1a40 <printf+0x18e>
    1a1d:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a24:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a2a:	89 d2                	mov    %edx,%edx
    1a2c:	48 01 d0             	add    %rdx,%rax
    1a2f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a35:	83 c2 08             	add    $0x8,%edx
    1a38:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a3e:	eb 12                	jmp    1a52 <printf+0x1a0>
    1a40:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a47:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a4b:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a52:	8b 00                	mov    (%rax),%eax
    1a54:	0f be d0             	movsbl %al,%edx
    1a57:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a5d:	89 d6                	mov    %edx,%esi
    1a5f:	89 c7                	mov    %eax,%edi
    1a61:	48 b8 cc 16 00 00 00 	movabs $0x16cc,%rax
    1a68:	00 00 00 
    1a6b:	ff d0                	callq  *%rax
      break;
    1a6d:	e9 12 02 00 00       	jmpq   1c84 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1a72:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a78:	83 f8 2f             	cmp    $0x2f,%eax
    1a7b:	77 23                	ja     1aa0 <printf+0x1ee>
    1a7d:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a84:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a8a:	89 d2                	mov    %edx,%edx
    1a8c:	48 01 d0             	add    %rdx,%rax
    1a8f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a95:	83 c2 08             	add    $0x8,%edx
    1a98:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a9e:	eb 12                	jmp    1ab2 <printf+0x200>
    1aa0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1aa7:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1aab:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1ab2:	8b 10                	mov    (%rax),%edx
    1ab4:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1aba:	89 d6                	mov    %edx,%esi
    1abc:	89 c7                	mov    %eax,%edi
    1abe:	48 b8 ba 17 00 00 00 	movabs $0x17ba,%rax
    1ac5:	00 00 00 
    1ac8:	ff d0                	callq  *%rax
      break;
    1aca:	e9 b5 01 00 00       	jmpq   1c84 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1acf:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1ad5:	83 f8 2f             	cmp    $0x2f,%eax
    1ad8:	77 23                	ja     1afd <printf+0x24b>
    1ada:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1ae1:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ae7:	89 d2                	mov    %edx,%edx
    1ae9:	48 01 d0             	add    %rdx,%rax
    1aec:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1af2:	83 c2 08             	add    $0x8,%edx
    1af5:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1afb:	eb 12                	jmp    1b0f <printf+0x25d>
    1afd:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b04:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b08:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b0f:	8b 10                	mov    (%rax),%edx
    1b11:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b17:	89 d6                	mov    %edx,%esi
    1b19:	89 c7                	mov    %eax,%edi
    1b1b:	48 b8 5d 17 00 00 00 	movabs $0x175d,%rax
    1b22:	00 00 00 
    1b25:	ff d0                	callq  *%rax
      break;
    1b27:	e9 58 01 00 00       	jmpq   1c84 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1b2c:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1b32:	83 f8 2f             	cmp    $0x2f,%eax
    1b35:	77 23                	ja     1b5a <printf+0x2a8>
    1b37:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1b3e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b44:	89 d2                	mov    %edx,%edx
    1b46:	48 01 d0             	add    %rdx,%rax
    1b49:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b4f:	83 c2 08             	add    $0x8,%edx
    1b52:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1b58:	eb 12                	jmp    1b6c <printf+0x2ba>
    1b5a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b61:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b65:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b6c:	48 8b 10             	mov    (%rax),%rdx
    1b6f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b75:	48 89 d6             	mov    %rdx,%rsi
    1b78:	89 c7                	mov    %eax,%edi
    1b7a:	48 b8 00 17 00 00 00 	movabs $0x1700,%rax
    1b81:	00 00 00 
    1b84:	ff d0                	callq  *%rax
      break;
    1b86:	e9 f9 00 00 00       	jmpq   1c84 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1b8b:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1b91:	83 f8 2f             	cmp    $0x2f,%eax
    1b94:	77 23                	ja     1bb9 <printf+0x307>
    1b96:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1b9d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ba3:	89 d2                	mov    %edx,%edx
    1ba5:	48 01 d0             	add    %rdx,%rax
    1ba8:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1bae:	83 c2 08             	add    $0x8,%edx
    1bb1:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1bb7:	eb 12                	jmp    1bcb <printf+0x319>
    1bb9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1bc0:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1bc4:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1bcb:	48 8b 00             	mov    (%rax),%rax
    1bce:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1bd5:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1bdc:	00 
    1bdd:	75 41                	jne    1c20 <printf+0x36e>
        s = "(null)";
    1bdf:	48 b8 00 20 00 00 00 	movabs $0x2000,%rax
    1be6:	00 00 00 
    1be9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1bf0:	eb 2e                	jmp    1c20 <printf+0x36e>
        putc(fd, *(s++));
    1bf2:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1bf9:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1bfd:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1c04:	0f b6 00             	movzbl (%rax),%eax
    1c07:	0f be d0             	movsbl %al,%edx
    1c0a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c10:	89 d6                	mov    %edx,%esi
    1c12:	89 c7                	mov    %eax,%edi
    1c14:	48 b8 cc 16 00 00 00 	movabs $0x16cc,%rax
    1c1b:	00 00 00 
    1c1e:	ff d0                	callq  *%rax
      while (*s)
    1c20:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1c27:	0f b6 00             	movzbl (%rax),%eax
    1c2a:	84 c0                	test   %al,%al
    1c2c:	75 c4                	jne    1bf2 <printf+0x340>
      break;
    1c2e:	eb 54                	jmp    1c84 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1c30:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c36:	be 25 00 00 00       	mov    $0x25,%esi
    1c3b:	89 c7                	mov    %eax,%edi
    1c3d:	48 b8 cc 16 00 00 00 	movabs $0x16cc,%rax
    1c44:	00 00 00 
    1c47:	ff d0                	callq  *%rax
      break;
    1c49:	eb 39                	jmp    1c84 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1c4b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c51:	be 25 00 00 00       	mov    $0x25,%esi
    1c56:	89 c7                	mov    %eax,%edi
    1c58:	48 b8 cc 16 00 00 00 	movabs $0x16cc,%rax
    1c5f:	00 00 00 
    1c62:	ff d0                	callq  *%rax
      putc(fd, c);
    1c64:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1c6a:	0f be d0             	movsbl %al,%edx
    1c6d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c73:	89 d6                	mov    %edx,%esi
    1c75:	89 c7                	mov    %eax,%edi
    1c77:	48 b8 cc 16 00 00 00 	movabs $0x16cc,%rax
    1c7e:	00 00 00 
    1c81:	ff d0                	callq  *%rax
      break;
    1c83:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1c84:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1c8b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1c91:	48 63 d0             	movslq %eax,%rdx
    1c94:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1c9b:	48 01 d0             	add    %rdx,%rax
    1c9e:	0f b6 00             	movzbl (%rax),%eax
    1ca1:	0f be c0             	movsbl %al,%eax
    1ca4:	25 ff 00 00 00       	and    $0xff,%eax
    1ca9:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1caf:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1cb6:	0f 85 8e fc ff ff    	jne    194a <printf+0x98>
    }
  }
}
    1cbc:	eb 01                	jmp    1cbf <printf+0x40d>
      break;
    1cbe:	90                   	nop
}
    1cbf:	90                   	nop
    1cc0:	c9                   	leaveq 
    1cc1:	c3                   	retq   

0000000000001cc2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1cc2:	f3 0f 1e fa          	endbr64 
    1cc6:	55                   	push   %rbp
    1cc7:	48 89 e5             	mov    %rsp,%rbp
    1cca:	48 83 ec 18          	sub    $0x18,%rsp
    1cce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1cd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1cd6:	48 83 e8 10          	sub    $0x10,%rax
    1cda:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1cde:	48 b8 90 25 00 00 00 	movabs $0x2590,%rax
    1ce5:	00 00 00 
    1ce8:	48 8b 00             	mov    (%rax),%rax
    1ceb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1cef:	eb 2f                	jmp    1d20 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1cf1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cf5:	48 8b 00             	mov    (%rax),%rax
    1cf8:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1cfc:	72 17                	jb     1d15 <free+0x53>
    1cfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d02:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1d06:	77 2f                	ja     1d37 <free+0x75>
    1d08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d0c:	48 8b 00             	mov    (%rax),%rax
    1d0f:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1d13:	72 22                	jb     1d37 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1d15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d19:	48 8b 00             	mov    (%rax),%rax
    1d1c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1d20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d24:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1d28:	76 c7                	jbe    1cf1 <free+0x2f>
    1d2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d2e:	48 8b 00             	mov    (%rax),%rax
    1d31:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1d35:	73 ba                	jae    1cf1 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1d37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d3b:	8b 40 08             	mov    0x8(%rax),%eax
    1d3e:	89 c0                	mov    %eax,%eax
    1d40:	48 c1 e0 04          	shl    $0x4,%rax
    1d44:	48 89 c2             	mov    %rax,%rdx
    1d47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d4b:	48 01 c2             	add    %rax,%rdx
    1d4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d52:	48 8b 00             	mov    (%rax),%rax
    1d55:	48 39 c2             	cmp    %rax,%rdx
    1d58:	75 2d                	jne    1d87 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1d5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d5e:	8b 50 08             	mov    0x8(%rax),%edx
    1d61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d65:	48 8b 00             	mov    (%rax),%rax
    1d68:	8b 40 08             	mov    0x8(%rax),%eax
    1d6b:	01 c2                	add    %eax,%edx
    1d6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d71:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1d74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d78:	48 8b 00             	mov    (%rax),%rax
    1d7b:	48 8b 10             	mov    (%rax),%rdx
    1d7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d82:	48 89 10             	mov    %rdx,(%rax)
    1d85:	eb 0e                	jmp    1d95 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1d87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d8b:	48 8b 10             	mov    (%rax),%rdx
    1d8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d92:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1d95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d99:	8b 40 08             	mov    0x8(%rax),%eax
    1d9c:	89 c0                	mov    %eax,%eax
    1d9e:	48 c1 e0 04          	shl    $0x4,%rax
    1da2:	48 89 c2             	mov    %rax,%rdx
    1da5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1da9:	48 01 d0             	add    %rdx,%rax
    1dac:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1db0:	75 27                	jne    1dd9 <free+0x117>
    p->s.size += bp->s.size;
    1db2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1db6:	8b 50 08             	mov    0x8(%rax),%edx
    1db9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dbd:	8b 40 08             	mov    0x8(%rax),%eax
    1dc0:	01 c2                	add    %eax,%edx
    1dc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dc6:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1dc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dcd:	48 8b 10             	mov    (%rax),%rdx
    1dd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dd4:	48 89 10             	mov    %rdx,(%rax)
    1dd7:	eb 0b                	jmp    1de4 <free+0x122>
  } else
    p->s.ptr = bp;
    1dd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ddd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1de1:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1de4:	48 ba 90 25 00 00 00 	movabs $0x2590,%rdx
    1deb:	00 00 00 
    1dee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1df2:	48 89 02             	mov    %rax,(%rdx)
}
    1df5:	90                   	nop
    1df6:	c9                   	leaveq 
    1df7:	c3                   	retq   

0000000000001df8 <morecore>:

static Header*
morecore(uint nu)
{
    1df8:	f3 0f 1e fa          	endbr64 
    1dfc:	55                   	push   %rbp
    1dfd:	48 89 e5             	mov    %rsp,%rbp
    1e00:	48 83 ec 20          	sub    $0x20,%rsp
    1e04:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1e07:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1e0e:	77 07                	ja     1e17 <morecore+0x1f>
    nu = 4096;
    1e10:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1e17:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1e1a:	48 c1 e0 04          	shl    $0x4,%rax
    1e1e:	48 89 c7             	mov    %rax,%rdi
    1e21:	48 b8 8b 16 00 00 00 	movabs $0x168b,%rax
    1e28:	00 00 00 
    1e2b:	ff d0                	callq  *%rax
    1e2d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1e31:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1e36:	75 07                	jne    1e3f <morecore+0x47>
    return 0;
    1e38:	b8 00 00 00 00       	mov    $0x0,%eax
    1e3d:	eb 36                	jmp    1e75 <morecore+0x7d>
  hp = (Header*)p;
    1e3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e43:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1e47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e4b:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1e4e:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1e51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e55:	48 83 c0 10          	add    $0x10,%rax
    1e59:	48 89 c7             	mov    %rax,%rdi
    1e5c:	48 b8 c2 1c 00 00 00 	movabs $0x1cc2,%rax
    1e63:	00 00 00 
    1e66:	ff d0                	callq  *%rax
  return freep;
    1e68:	48 b8 90 25 00 00 00 	movabs $0x2590,%rax
    1e6f:	00 00 00 
    1e72:	48 8b 00             	mov    (%rax),%rax
}
    1e75:	c9                   	leaveq 
    1e76:	c3                   	retq   

0000000000001e77 <malloc>:

void*
malloc(uint nbytes)
{
    1e77:	f3 0f 1e fa          	endbr64 
    1e7b:	55                   	push   %rbp
    1e7c:	48 89 e5             	mov    %rsp,%rbp
    1e7f:	48 83 ec 30          	sub    $0x30,%rsp
    1e83:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1e86:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1e89:	48 83 c0 0f          	add    $0xf,%rax
    1e8d:	48 c1 e8 04          	shr    $0x4,%rax
    1e91:	83 c0 01             	add    $0x1,%eax
    1e94:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1e97:	48 b8 90 25 00 00 00 	movabs $0x2590,%rax
    1e9e:	00 00 00 
    1ea1:	48 8b 00             	mov    (%rax),%rax
    1ea4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1ea8:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1ead:	75 4a                	jne    1ef9 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1eaf:	48 b8 80 25 00 00 00 	movabs $0x2580,%rax
    1eb6:	00 00 00 
    1eb9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1ebd:	48 ba 90 25 00 00 00 	movabs $0x2590,%rdx
    1ec4:	00 00 00 
    1ec7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ecb:	48 89 02             	mov    %rax,(%rdx)
    1ece:	48 b8 90 25 00 00 00 	movabs $0x2590,%rax
    1ed5:	00 00 00 
    1ed8:	48 8b 00             	mov    (%rax),%rax
    1edb:	48 ba 80 25 00 00 00 	movabs $0x2580,%rdx
    1ee2:	00 00 00 
    1ee5:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1ee8:	48 b8 80 25 00 00 00 	movabs $0x2580,%rax
    1eef:	00 00 00 
    1ef2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ef9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1efd:	48 8b 00             	mov    (%rax),%rax
    1f00:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1f04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f08:	8b 40 08             	mov    0x8(%rax),%eax
    1f0b:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1f0e:	77 65                	ja     1f75 <malloc+0xfe>
      if(p->s.size == nunits)
    1f10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f14:	8b 40 08             	mov    0x8(%rax),%eax
    1f17:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1f1a:	75 10                	jne    1f2c <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1f1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f20:	48 8b 10             	mov    (%rax),%rdx
    1f23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f27:	48 89 10             	mov    %rdx,(%rax)
    1f2a:	eb 2e                	jmp    1f5a <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1f2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f30:	8b 40 08             	mov    0x8(%rax),%eax
    1f33:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1f36:	89 c2                	mov    %eax,%edx
    1f38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f3c:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1f3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f43:	8b 40 08             	mov    0x8(%rax),%eax
    1f46:	89 c0                	mov    %eax,%eax
    1f48:	48 c1 e0 04          	shl    $0x4,%rax
    1f4c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1f50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f54:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1f57:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1f5a:	48 ba 90 25 00 00 00 	movabs $0x2590,%rdx
    1f61:	00 00 00 
    1f64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f68:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1f6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f6f:	48 83 c0 10          	add    $0x10,%rax
    1f73:	eb 4e                	jmp    1fc3 <malloc+0x14c>
    }
    if(p == freep)
    1f75:	48 b8 90 25 00 00 00 	movabs $0x2590,%rax
    1f7c:	00 00 00 
    1f7f:	48 8b 00             	mov    (%rax),%rax
    1f82:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f86:	75 23                	jne    1fab <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1f88:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1f8b:	89 c7                	mov    %eax,%edi
    1f8d:	48 b8 f8 1d 00 00 00 	movabs $0x1df8,%rax
    1f94:	00 00 00 
    1f97:	ff d0                	callq  *%rax
    1f99:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f9d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1fa2:	75 07                	jne    1fab <malloc+0x134>
        return 0;
    1fa4:	b8 00 00 00 00       	mov    $0x0,%eax
    1fa9:	eb 18                	jmp    1fc3 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1fab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1faf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1fb3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fb7:	48 8b 00             	mov    (%rax),%rax
    1fba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1fbe:	e9 41 ff ff ff       	jmpq   1f04 <malloc+0x8d>
  }
}
    1fc3:	c9                   	leaveq 
    1fc4:	c3                   	retq   
