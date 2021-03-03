
_dedup_reader:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[]) {
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 20          	sub    $0x20,%rsp
    100c:	89 7d ec             	mov    %edi,-0x14(%rbp)
    100f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  printf(1,"Freepages at start: %d\n",freepages());
    1013:	48 b8 9a 15 00 00 00 	movabs $0x159a,%rax
    101a:	00 00 00 
    101d:	ff d0                	callq  *%rax
    101f:	89 c2                	mov    %eax,%edx
    1021:	48 be a0 1e 00 00 00 	movabs $0x1ea0,%rsi
    1028:	00 00 00 
    102b:	bf 01 00 00 00       	mov    $0x1,%edi
    1030:	b8 00 00 00 00       	mov    $0x0,%eax
    1035:	48 b9 8d 17 00 00 00 	movabs $0x178d,%rcx
    103c:	00 00 00 
    103f:	ff d1                	callq  *%rcx
  int* buf = malloc(10000000);
    1041:	bf 80 96 98 00       	mov    $0x989680,%edi
    1046:	48 b8 52 1d 00 00 00 	movabs $0x1d52,%rax
    104d:	00 00 00 
    1050:	ff d0                	callq  *%rax
    1052:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  memset(buf,0x88,10000000);
    1056:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    105a:	ba 80 96 98 00       	mov    $0x989680,%edx
    105f:	be 88 00 00 00       	mov    $0x88,%esi
    1064:	48 89 c7             	mov    %rax,%rdi
    1067:	48 b8 54 12 00 00 00 	movabs $0x1254,%rax
    106e:	00 00 00 
    1071:	ff d0                	callq  *%rax
  printf(1,"Freepages after malloc: %d\n",freepages());
    1073:	48 b8 9a 15 00 00 00 	movabs $0x159a,%rax
    107a:	00 00 00 
    107d:	ff d0                	callq  *%rax
    107f:	89 c2                	mov    %eax,%edx
    1081:	48 be b8 1e 00 00 00 	movabs $0x1eb8,%rsi
    1088:	00 00 00 
    108b:	bf 01 00 00 00       	mov    $0x1,%edi
    1090:	b8 00 00 00 00       	mov    $0x0,%eax
    1095:	48 b9 8d 17 00 00 00 	movabs $0x178d,%rcx
    109c:	00 00 00 
    109f:	ff d1                	callq  *%rcx
  dedup();
    10a1:	48 b8 8d 15 00 00 00 	movabs $0x158d,%rax
    10a8:	00 00 00 
    10ab:	ff d0                	callq  *%rax
  for(int i=0;i<10000000/4;i++) {
    10ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    10b4:	eb 4d                	jmp    1103 <main+0x103>
    if(buf[i] != 0x88888888) {
    10b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10b9:	48 98                	cltq   
    10bb:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
    10c2:	00 
    10c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    10c7:	48 01 d0             	add    %rdx,%rax
    10ca:	8b 00                	mov    (%rax),%eax
    10cc:	3d 88 88 88 88       	cmp    $0x88888888,%eax
    10d1:	74 2c                	je     10ff <main+0xff>
      printf(2,"Argh, found an incorrect value in memory!\n");
    10d3:	48 be d8 1e 00 00 00 	movabs $0x1ed8,%rsi
    10da:	00 00 00 
    10dd:	bf 02 00 00 00       	mov    $0x2,%edi
    10e2:	b8 00 00 00 00       	mov    $0x0,%eax
    10e7:	48 ba 8d 17 00 00 00 	movabs $0x178d,%rdx
    10ee:	00 00 00 
    10f1:	ff d2                	callq  *%rdx
      exit();
    10f3:	48 b8 89 14 00 00 00 	movabs $0x1489,%rax
    10fa:	00 00 00 
    10fd:	ff d0                	callq  *%rax
  for(int i=0;i<10000000/4;i++) {
    10ff:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1103:	81 7d fc 9f 25 26 00 	cmpl   $0x26259f,-0x4(%rbp)
    110a:	7e aa                	jle    10b6 <main+0xb6>
    }
  }
  printf(1,"Freepages after dedup: %d\n",freepages());
    110c:	48 b8 9a 15 00 00 00 	movabs $0x159a,%rax
    1113:	00 00 00 
    1116:	ff d0                	callq  *%rax
    1118:	89 c2                	mov    %eax,%edx
    111a:	48 be 03 1f 00 00 00 	movabs $0x1f03,%rsi
    1121:	00 00 00 
    1124:	bf 01 00 00 00       	mov    $0x1,%edi
    1129:	b8 00 00 00 00       	mov    $0x0,%eax
    112e:	48 b9 8d 17 00 00 00 	movabs $0x178d,%rcx
    1135:	00 00 00 
    1138:	ff d1                	callq  *%rcx
  exit();
    113a:	48 b8 89 14 00 00 00 	movabs $0x1489,%rax
    1141:	00 00 00 
    1144:	ff d0                	callq  *%rax

0000000000001146 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1146:	f3 0f 1e fa          	endbr64 
    114a:	55                   	push   %rbp
    114b:	48 89 e5             	mov    %rsp,%rbp
    114e:	48 83 ec 10          	sub    $0x10,%rsp
    1152:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1156:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1159:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    115c:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1160:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1163:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1166:	48 89 ce             	mov    %rcx,%rsi
    1169:	48 89 f7             	mov    %rsi,%rdi
    116c:	89 d1                	mov    %edx,%ecx
    116e:	fc                   	cld    
    116f:	f3 aa                	rep stos %al,%es:(%rdi)
    1171:	89 ca                	mov    %ecx,%edx
    1173:	48 89 fe             	mov    %rdi,%rsi
    1176:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    117a:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    117d:	90                   	nop
    117e:	c9                   	leaveq 
    117f:	c3                   	retq   

0000000000001180 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1180:	f3 0f 1e fa          	endbr64 
    1184:	55                   	push   %rbp
    1185:	48 89 e5             	mov    %rsp,%rbp
    1188:	48 83 ec 20          	sub    $0x20,%rsp
    118c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1190:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    1194:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1198:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    119c:	90                   	nop
    119d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    11a1:	48 8d 42 01          	lea    0x1(%rdx),%rax
    11a5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    11a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11ad:	48 8d 48 01          	lea    0x1(%rax),%rcx
    11b1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    11b5:	0f b6 12             	movzbl (%rdx),%edx
    11b8:	88 10                	mov    %dl,(%rax)
    11ba:	0f b6 00             	movzbl (%rax),%eax
    11bd:	84 c0                	test   %al,%al
    11bf:	75 dc                	jne    119d <strcpy+0x1d>
    ;
  return os;
    11c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    11c5:	c9                   	leaveq 
    11c6:	c3                   	retq   

00000000000011c7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    11c7:	f3 0f 1e fa          	endbr64 
    11cb:	55                   	push   %rbp
    11cc:	48 89 e5             	mov    %rsp,%rbp
    11cf:	48 83 ec 10          	sub    $0x10,%rsp
    11d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    11db:	eb 0a                	jmp    11e7 <strcmp+0x20>
    p++, q++;
    11dd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    11e2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    11e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11eb:	0f b6 00             	movzbl (%rax),%eax
    11ee:	84 c0                	test   %al,%al
    11f0:	74 12                	je     1204 <strcmp+0x3d>
    11f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11f6:	0f b6 10             	movzbl (%rax),%edx
    11f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    11fd:	0f b6 00             	movzbl (%rax),%eax
    1200:	38 c2                	cmp    %al,%dl
    1202:	74 d9                	je     11dd <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1204:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1208:	0f b6 00             	movzbl (%rax),%eax
    120b:	0f b6 d0             	movzbl %al,%edx
    120e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1212:	0f b6 00             	movzbl (%rax),%eax
    1215:	0f b6 c0             	movzbl %al,%eax
    1218:	29 c2                	sub    %eax,%edx
    121a:	89 d0                	mov    %edx,%eax
}
    121c:	c9                   	leaveq 
    121d:	c3                   	retq   

000000000000121e <strlen>:

uint
strlen(char *s)
{
    121e:	f3 0f 1e fa          	endbr64 
    1222:	55                   	push   %rbp
    1223:	48 89 e5             	mov    %rsp,%rbp
    1226:	48 83 ec 18          	sub    $0x18,%rsp
    122a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    122e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1235:	eb 04                	jmp    123b <strlen+0x1d>
    1237:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    123b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    123e:	48 63 d0             	movslq %eax,%rdx
    1241:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1245:	48 01 d0             	add    %rdx,%rax
    1248:	0f b6 00             	movzbl (%rax),%eax
    124b:	84 c0                	test   %al,%al
    124d:	75 e8                	jne    1237 <strlen+0x19>
    ;
  return n;
    124f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1252:	c9                   	leaveq 
    1253:	c3                   	retq   

0000000000001254 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1254:	f3 0f 1e fa          	endbr64 
    1258:	55                   	push   %rbp
    1259:	48 89 e5             	mov    %rsp,%rbp
    125c:	48 83 ec 10          	sub    $0x10,%rsp
    1260:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1264:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1267:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    126a:	8b 55 f0             	mov    -0x10(%rbp),%edx
    126d:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    1270:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1274:	89 ce                	mov    %ecx,%esi
    1276:	48 89 c7             	mov    %rax,%rdi
    1279:	48 b8 46 11 00 00 00 	movabs $0x1146,%rax
    1280:	00 00 00 
    1283:	ff d0                	callq  *%rax
  return dst;
    1285:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1289:	c9                   	leaveq 
    128a:	c3                   	retq   

000000000000128b <strchr>:

char*
strchr(const char *s, char c)
{
    128b:	f3 0f 1e fa          	endbr64 
    128f:	55                   	push   %rbp
    1290:	48 89 e5             	mov    %rsp,%rbp
    1293:	48 83 ec 10          	sub    $0x10,%rsp
    1297:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    129b:	89 f0                	mov    %esi,%eax
    129d:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    12a0:	eb 17                	jmp    12b9 <strchr+0x2e>
    if(*s == c)
    12a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12a6:	0f b6 00             	movzbl (%rax),%eax
    12a9:	38 45 f4             	cmp    %al,-0xc(%rbp)
    12ac:	75 06                	jne    12b4 <strchr+0x29>
      return (char*)s;
    12ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12b2:	eb 15                	jmp    12c9 <strchr+0x3e>
  for(; *s; s++)
    12b4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    12b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12bd:	0f b6 00             	movzbl (%rax),%eax
    12c0:	84 c0                	test   %al,%al
    12c2:	75 de                	jne    12a2 <strchr+0x17>
  return 0;
    12c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
    12c9:	c9                   	leaveq 
    12ca:	c3                   	retq   

00000000000012cb <gets>:

char*
gets(char *buf, int max)
{
    12cb:	f3 0f 1e fa          	endbr64 
    12cf:	55                   	push   %rbp
    12d0:	48 89 e5             	mov    %rsp,%rbp
    12d3:	48 83 ec 20          	sub    $0x20,%rsp
    12d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12db:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    12e5:	eb 4f                	jmp    1336 <gets+0x6b>
    cc = read(0, &c, 1);
    12e7:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    12eb:	ba 01 00 00 00       	mov    $0x1,%edx
    12f0:	48 89 c6             	mov    %rax,%rsi
    12f3:	bf 00 00 00 00       	mov    $0x0,%edi
    12f8:	48 b8 b0 14 00 00 00 	movabs $0x14b0,%rax
    12ff:	00 00 00 
    1302:	ff d0                	callq  *%rax
    1304:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1307:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    130b:	7e 36                	jle    1343 <gets+0x78>
      break;
    buf[i++] = c;
    130d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1310:	8d 50 01             	lea    0x1(%rax),%edx
    1313:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1316:	48 63 d0             	movslq %eax,%rdx
    1319:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    131d:	48 01 c2             	add    %rax,%rdx
    1320:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1324:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1326:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    132a:	3c 0a                	cmp    $0xa,%al
    132c:	74 16                	je     1344 <gets+0x79>
    132e:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1332:	3c 0d                	cmp    $0xd,%al
    1334:	74 0e                	je     1344 <gets+0x79>
  for(i=0; i+1 < max; ){
    1336:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1339:	83 c0 01             	add    $0x1,%eax
    133c:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    133f:	7f a6                	jg     12e7 <gets+0x1c>
    1341:	eb 01                	jmp    1344 <gets+0x79>
      break;
    1343:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1344:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1347:	48 63 d0             	movslq %eax,%rdx
    134a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    134e:	48 01 d0             	add    %rdx,%rax
    1351:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1354:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1358:	c9                   	leaveq 
    1359:	c3                   	retq   

000000000000135a <stat>:

int
stat(char *n, struct stat *st)
{
    135a:	f3 0f 1e fa          	endbr64 
    135e:	55                   	push   %rbp
    135f:	48 89 e5             	mov    %rsp,%rbp
    1362:	48 83 ec 20          	sub    $0x20,%rsp
    1366:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    136a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    136e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1372:	be 00 00 00 00       	mov    $0x0,%esi
    1377:	48 89 c7             	mov    %rax,%rdi
    137a:	48 b8 f1 14 00 00 00 	movabs $0x14f1,%rax
    1381:	00 00 00 
    1384:	ff d0                	callq  *%rax
    1386:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    1389:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    138d:	79 07                	jns    1396 <stat+0x3c>
    return -1;
    138f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1394:	eb 2f                	jmp    13c5 <stat+0x6b>
  r = fstat(fd, st);
    1396:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    139a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    139d:	48 89 d6             	mov    %rdx,%rsi
    13a0:	89 c7                	mov    %eax,%edi
    13a2:	48 b8 18 15 00 00 00 	movabs $0x1518,%rax
    13a9:	00 00 00 
    13ac:	ff d0                	callq  *%rax
    13ae:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    13b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13b4:	89 c7                	mov    %eax,%edi
    13b6:	48 b8 ca 14 00 00 00 	movabs $0x14ca,%rax
    13bd:	00 00 00 
    13c0:	ff d0                	callq  *%rax
  return r;
    13c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    13c5:	c9                   	leaveq 
    13c6:	c3                   	retq   

00000000000013c7 <atoi>:

int
atoi(const char *s)
{
    13c7:	f3 0f 1e fa          	endbr64 
    13cb:	55                   	push   %rbp
    13cc:	48 89 e5             	mov    %rsp,%rbp
    13cf:	48 83 ec 18          	sub    $0x18,%rsp
    13d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    13d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    13de:	eb 28                	jmp    1408 <atoi+0x41>
    n = n*10 + *s++ - '0';
    13e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
    13e3:	89 d0                	mov    %edx,%eax
    13e5:	c1 e0 02             	shl    $0x2,%eax
    13e8:	01 d0                	add    %edx,%eax
    13ea:	01 c0                	add    %eax,%eax
    13ec:	89 c1                	mov    %eax,%ecx
    13ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13f2:	48 8d 50 01          	lea    0x1(%rax),%rdx
    13f6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    13fa:	0f b6 00             	movzbl (%rax),%eax
    13fd:	0f be c0             	movsbl %al,%eax
    1400:	01 c8                	add    %ecx,%eax
    1402:	83 e8 30             	sub    $0x30,%eax
    1405:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1408:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    140c:	0f b6 00             	movzbl (%rax),%eax
    140f:	3c 2f                	cmp    $0x2f,%al
    1411:	7e 0b                	jle    141e <atoi+0x57>
    1413:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1417:	0f b6 00             	movzbl (%rax),%eax
    141a:	3c 39                	cmp    $0x39,%al
    141c:	7e c2                	jle    13e0 <atoi+0x19>
  return n;
    141e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1421:	c9                   	leaveq 
    1422:	c3                   	retq   

0000000000001423 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1423:	f3 0f 1e fa          	endbr64 
    1427:	55                   	push   %rbp
    1428:	48 89 e5             	mov    %rsp,%rbp
    142b:	48 83 ec 28          	sub    $0x28,%rsp
    142f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1433:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1437:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    143a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    143e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1442:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1446:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    144a:	eb 1d                	jmp    1469 <memmove+0x46>
    *dst++ = *src++;
    144c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1450:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1454:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    145c:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1460:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    1464:	0f b6 12             	movzbl (%rdx),%edx
    1467:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1469:	8b 45 dc             	mov    -0x24(%rbp),%eax
    146c:	8d 50 ff             	lea    -0x1(%rax),%edx
    146f:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1472:	85 c0                	test   %eax,%eax
    1474:	7f d6                	jg     144c <memmove+0x29>
  return vdst;
    1476:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    147a:	c9                   	leaveq 
    147b:	c3                   	retq   

000000000000147c <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    147c:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    1483:	49 89 ca             	mov    %rcx,%r10
    1486:	0f 05                	syscall 
    1488:	c3                   	retq   

0000000000001489 <exit>:
SYSCALL(exit)
    1489:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1490:	49 89 ca             	mov    %rcx,%r10
    1493:	0f 05                	syscall 
    1495:	c3                   	retq   

0000000000001496 <wait>:
SYSCALL(wait)
    1496:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    149d:	49 89 ca             	mov    %rcx,%r10
    14a0:	0f 05                	syscall 
    14a2:	c3                   	retq   

00000000000014a3 <pipe>:
SYSCALL(pipe)
    14a3:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    14aa:	49 89 ca             	mov    %rcx,%r10
    14ad:	0f 05                	syscall 
    14af:	c3                   	retq   

00000000000014b0 <read>:
SYSCALL(read)
    14b0:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    14b7:	49 89 ca             	mov    %rcx,%r10
    14ba:	0f 05                	syscall 
    14bc:	c3                   	retq   

00000000000014bd <write>:
SYSCALL(write)
    14bd:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    14c4:	49 89 ca             	mov    %rcx,%r10
    14c7:	0f 05                	syscall 
    14c9:	c3                   	retq   

00000000000014ca <close>:
SYSCALL(close)
    14ca:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    14d1:	49 89 ca             	mov    %rcx,%r10
    14d4:	0f 05                	syscall 
    14d6:	c3                   	retq   

00000000000014d7 <kill>:
SYSCALL(kill)
    14d7:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    14de:	49 89 ca             	mov    %rcx,%r10
    14e1:	0f 05                	syscall 
    14e3:	c3                   	retq   

00000000000014e4 <exec>:
SYSCALL(exec)
    14e4:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    14eb:	49 89 ca             	mov    %rcx,%r10
    14ee:	0f 05                	syscall 
    14f0:	c3                   	retq   

00000000000014f1 <open>:
SYSCALL(open)
    14f1:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    14f8:	49 89 ca             	mov    %rcx,%r10
    14fb:	0f 05                	syscall 
    14fd:	c3                   	retq   

00000000000014fe <mknod>:
SYSCALL(mknod)
    14fe:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1505:	49 89 ca             	mov    %rcx,%r10
    1508:	0f 05                	syscall 
    150a:	c3                   	retq   

000000000000150b <unlink>:
SYSCALL(unlink)
    150b:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1512:	49 89 ca             	mov    %rcx,%r10
    1515:	0f 05                	syscall 
    1517:	c3                   	retq   

0000000000001518 <fstat>:
SYSCALL(fstat)
    1518:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    151f:	49 89 ca             	mov    %rcx,%r10
    1522:	0f 05                	syscall 
    1524:	c3                   	retq   

0000000000001525 <link>:
SYSCALL(link)
    1525:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    152c:	49 89 ca             	mov    %rcx,%r10
    152f:	0f 05                	syscall 
    1531:	c3                   	retq   

0000000000001532 <mkdir>:
SYSCALL(mkdir)
    1532:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1539:	49 89 ca             	mov    %rcx,%r10
    153c:	0f 05                	syscall 
    153e:	c3                   	retq   

000000000000153f <chdir>:
SYSCALL(chdir)
    153f:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1546:	49 89 ca             	mov    %rcx,%r10
    1549:	0f 05                	syscall 
    154b:	c3                   	retq   

000000000000154c <dup>:
SYSCALL(dup)
    154c:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1553:	49 89 ca             	mov    %rcx,%r10
    1556:	0f 05                	syscall 
    1558:	c3                   	retq   

0000000000001559 <getpid>:
SYSCALL(getpid)
    1559:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    1560:	49 89 ca             	mov    %rcx,%r10
    1563:	0f 05                	syscall 
    1565:	c3                   	retq   

0000000000001566 <sbrk>:
SYSCALL(sbrk)
    1566:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    156d:	49 89 ca             	mov    %rcx,%r10
    1570:	0f 05                	syscall 
    1572:	c3                   	retq   

0000000000001573 <sleep>:
SYSCALL(sleep)
    1573:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    157a:	49 89 ca             	mov    %rcx,%r10
    157d:	0f 05                	syscall 
    157f:	c3                   	retq   

0000000000001580 <uptime>:
SYSCALL(uptime)
    1580:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    1587:	49 89 ca             	mov    %rcx,%r10
    158a:	0f 05                	syscall 
    158c:	c3                   	retq   

000000000000158d <dedup>:
SYSCALL(dedup)
    158d:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    1594:	49 89 ca             	mov    %rcx,%r10
    1597:	0f 05                	syscall 
    1599:	c3                   	retq   

000000000000159a <freepages>:
SYSCALL(freepages)
    159a:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    15a1:	49 89 ca             	mov    %rcx,%r10
    15a4:	0f 05                	syscall 
    15a6:	c3                   	retq   

00000000000015a7 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    15a7:	f3 0f 1e fa          	endbr64 
    15ab:	55                   	push   %rbp
    15ac:	48 89 e5             	mov    %rsp,%rbp
    15af:	48 83 ec 10          	sub    $0x10,%rsp
    15b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
    15b6:	89 f0                	mov    %esi,%eax
    15b8:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    15bb:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    15bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15c2:	ba 01 00 00 00       	mov    $0x1,%edx
    15c7:	48 89 ce             	mov    %rcx,%rsi
    15ca:	89 c7                	mov    %eax,%edi
    15cc:	48 b8 bd 14 00 00 00 	movabs $0x14bd,%rax
    15d3:	00 00 00 
    15d6:	ff d0                	callq  *%rax
}
    15d8:	90                   	nop
    15d9:	c9                   	leaveq 
    15da:	c3                   	retq   

00000000000015db <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    15db:	f3 0f 1e fa          	endbr64 
    15df:	55                   	push   %rbp
    15e0:	48 89 e5             	mov    %rsp,%rbp
    15e3:	48 83 ec 20          	sub    $0x20,%rsp
    15e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
    15ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    15ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    15f5:	eb 35                	jmp    162c <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    15f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    15fb:	48 c1 e8 3c          	shr    $0x3c,%rax
    15ff:	48 ba 50 22 00 00 00 	movabs $0x2250,%rdx
    1606:	00 00 00 
    1609:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    160d:	0f be d0             	movsbl %al,%edx
    1610:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1613:	89 d6                	mov    %edx,%esi
    1615:	89 c7                	mov    %eax,%edi
    1617:	48 b8 a7 15 00 00 00 	movabs $0x15a7,%rax
    161e:	00 00 00 
    1621:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1623:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1627:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    162c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    162f:	83 f8 0f             	cmp    $0xf,%eax
    1632:	76 c3                	jbe    15f7 <print_x64+0x1c>
}
    1634:	90                   	nop
    1635:	90                   	nop
    1636:	c9                   	leaveq 
    1637:	c3                   	retq   

0000000000001638 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1638:	f3 0f 1e fa          	endbr64 
    163c:	55                   	push   %rbp
    163d:	48 89 e5             	mov    %rsp,%rbp
    1640:	48 83 ec 20          	sub    $0x20,%rsp
    1644:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1647:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    164a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1651:	eb 36                	jmp    1689 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1653:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1656:	c1 e8 1c             	shr    $0x1c,%eax
    1659:	89 c2                	mov    %eax,%edx
    165b:	48 b8 50 22 00 00 00 	movabs $0x2250,%rax
    1662:	00 00 00 
    1665:	89 d2                	mov    %edx,%edx
    1667:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    166b:	0f be d0             	movsbl %al,%edx
    166e:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1671:	89 d6                	mov    %edx,%esi
    1673:	89 c7                	mov    %eax,%edi
    1675:	48 b8 a7 15 00 00 00 	movabs $0x15a7,%rax
    167c:	00 00 00 
    167f:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1681:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1685:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    1689:	8b 45 fc             	mov    -0x4(%rbp),%eax
    168c:	83 f8 07             	cmp    $0x7,%eax
    168f:	76 c2                	jbe    1653 <print_x32+0x1b>
}
    1691:	90                   	nop
    1692:	90                   	nop
    1693:	c9                   	leaveq 
    1694:	c3                   	retq   

0000000000001695 <print_d>:

  static void
print_d(int fd, int v)
{
    1695:	f3 0f 1e fa          	endbr64 
    1699:	55                   	push   %rbp
    169a:	48 89 e5             	mov    %rsp,%rbp
    169d:	48 83 ec 30          	sub    $0x30,%rsp
    16a1:	89 7d dc             	mov    %edi,-0x24(%rbp)
    16a4:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    16a7:	8b 45 d8             	mov    -0x28(%rbp),%eax
    16aa:	48 98                	cltq   
    16ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    16b0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    16b4:	79 04                	jns    16ba <print_d+0x25>
    x = -x;
    16b6:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    16ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    16c1:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    16c5:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    16cc:	66 66 66 
    16cf:	48 89 c8             	mov    %rcx,%rax
    16d2:	48 f7 ea             	imul   %rdx
    16d5:	48 c1 fa 02          	sar    $0x2,%rdx
    16d9:	48 89 c8             	mov    %rcx,%rax
    16dc:	48 c1 f8 3f          	sar    $0x3f,%rax
    16e0:	48 29 c2             	sub    %rax,%rdx
    16e3:	48 89 d0             	mov    %rdx,%rax
    16e6:	48 c1 e0 02          	shl    $0x2,%rax
    16ea:	48 01 d0             	add    %rdx,%rax
    16ed:	48 01 c0             	add    %rax,%rax
    16f0:	48 29 c1             	sub    %rax,%rcx
    16f3:	48 89 ca             	mov    %rcx,%rdx
    16f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16f9:	8d 48 01             	lea    0x1(%rax),%ecx
    16fc:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    16ff:	48 b9 50 22 00 00 00 	movabs $0x2250,%rcx
    1706:	00 00 00 
    1709:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    170d:	48 98                	cltq   
    170f:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1713:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1717:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    171e:	66 66 66 
    1721:	48 89 c8             	mov    %rcx,%rax
    1724:	48 f7 ea             	imul   %rdx
    1727:	48 c1 fa 02          	sar    $0x2,%rdx
    172b:	48 89 c8             	mov    %rcx,%rax
    172e:	48 c1 f8 3f          	sar    $0x3f,%rax
    1732:	48 29 c2             	sub    %rax,%rdx
    1735:	48 89 d0             	mov    %rdx,%rax
    1738:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    173c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1741:	0f 85 7a ff ff ff    	jne    16c1 <print_d+0x2c>

  if (v < 0)
    1747:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    174b:	79 32                	jns    177f <print_d+0xea>
    buf[i++] = '-';
    174d:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1750:	8d 50 01             	lea    0x1(%rax),%edx
    1753:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1756:	48 98                	cltq   
    1758:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    175d:	eb 20                	jmp    177f <print_d+0xea>
    putc(fd, buf[i]);
    175f:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1762:	48 98                	cltq   
    1764:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1769:	0f be d0             	movsbl %al,%edx
    176c:	8b 45 dc             	mov    -0x24(%rbp),%eax
    176f:	89 d6                	mov    %edx,%esi
    1771:	89 c7                	mov    %eax,%edi
    1773:	48 b8 a7 15 00 00 00 	movabs $0x15a7,%rax
    177a:	00 00 00 
    177d:	ff d0                	callq  *%rax
  while (--i >= 0)
    177f:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1783:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1787:	79 d6                	jns    175f <print_d+0xca>
}
    1789:	90                   	nop
    178a:	90                   	nop
    178b:	c9                   	leaveq 
    178c:	c3                   	retq   

000000000000178d <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    178d:	f3 0f 1e fa          	endbr64 
    1791:	55                   	push   %rbp
    1792:	48 89 e5             	mov    %rsp,%rbp
    1795:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    179c:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    17a2:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    17a9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    17b0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    17b7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    17be:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    17c5:	84 c0                	test   %al,%al
    17c7:	74 20                	je     17e9 <printf+0x5c>
    17c9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    17cd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    17d1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    17d5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    17d9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    17dd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    17e1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    17e5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    17e9:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    17f0:	00 00 00 
    17f3:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    17fa:	00 00 00 
    17fd:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1801:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1808:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    180f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1816:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    181d:	00 00 00 
    1820:	e9 41 03 00 00       	jmpq   1b66 <printf+0x3d9>
    if (c != '%') {
    1825:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    182c:	74 24                	je     1852 <printf+0xc5>
      putc(fd, c);
    182e:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1834:	0f be d0             	movsbl %al,%edx
    1837:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    183d:	89 d6                	mov    %edx,%esi
    183f:	89 c7                	mov    %eax,%edi
    1841:	48 b8 a7 15 00 00 00 	movabs $0x15a7,%rax
    1848:	00 00 00 
    184b:	ff d0                	callq  *%rax
      continue;
    184d:	e9 0d 03 00 00       	jmpq   1b5f <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1852:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1859:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    185f:	48 63 d0             	movslq %eax,%rdx
    1862:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1869:	48 01 d0             	add    %rdx,%rax
    186c:	0f b6 00             	movzbl (%rax),%eax
    186f:	0f be c0             	movsbl %al,%eax
    1872:	25 ff 00 00 00       	and    $0xff,%eax
    1877:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    187d:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1884:	0f 84 0f 03 00 00    	je     1b99 <printf+0x40c>
      break;
    switch(c) {
    188a:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1891:	0f 84 74 02 00 00    	je     1b0b <printf+0x37e>
    1897:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    189e:	0f 8c 82 02 00 00    	jl     1b26 <printf+0x399>
    18a4:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    18ab:	0f 8f 75 02 00 00    	jg     1b26 <printf+0x399>
    18b1:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    18b8:	0f 8c 68 02 00 00    	jl     1b26 <printf+0x399>
    18be:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    18c4:	83 e8 63             	sub    $0x63,%eax
    18c7:	83 f8 15             	cmp    $0x15,%eax
    18ca:	0f 87 56 02 00 00    	ja     1b26 <printf+0x399>
    18d0:	89 c0                	mov    %eax,%eax
    18d2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    18d9:	00 
    18da:	48 b8 28 1f 00 00 00 	movabs $0x1f28,%rax
    18e1:	00 00 00 
    18e4:	48 01 d0             	add    %rdx,%rax
    18e7:	48 8b 00             	mov    (%rax),%rax
    18ea:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    18ed:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18f3:	83 f8 2f             	cmp    $0x2f,%eax
    18f6:	77 23                	ja     191b <printf+0x18e>
    18f8:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18ff:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1905:	89 d2                	mov    %edx,%edx
    1907:	48 01 d0             	add    %rdx,%rax
    190a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1910:	83 c2 08             	add    $0x8,%edx
    1913:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1919:	eb 12                	jmp    192d <printf+0x1a0>
    191b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1922:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1926:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    192d:	8b 00                	mov    (%rax),%eax
    192f:	0f be d0             	movsbl %al,%edx
    1932:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1938:	89 d6                	mov    %edx,%esi
    193a:	89 c7                	mov    %eax,%edi
    193c:	48 b8 a7 15 00 00 00 	movabs $0x15a7,%rax
    1943:	00 00 00 
    1946:	ff d0                	callq  *%rax
      break;
    1948:	e9 12 02 00 00       	jmpq   1b5f <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    194d:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1953:	83 f8 2f             	cmp    $0x2f,%eax
    1956:	77 23                	ja     197b <printf+0x1ee>
    1958:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    195f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1965:	89 d2                	mov    %edx,%edx
    1967:	48 01 d0             	add    %rdx,%rax
    196a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1970:	83 c2 08             	add    $0x8,%edx
    1973:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1979:	eb 12                	jmp    198d <printf+0x200>
    197b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1982:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1986:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    198d:	8b 10                	mov    (%rax),%edx
    198f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1995:	89 d6                	mov    %edx,%esi
    1997:	89 c7                	mov    %eax,%edi
    1999:	48 b8 95 16 00 00 00 	movabs $0x1695,%rax
    19a0:	00 00 00 
    19a3:	ff d0                	callq  *%rax
      break;
    19a5:	e9 b5 01 00 00       	jmpq   1b5f <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    19aa:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19b0:	83 f8 2f             	cmp    $0x2f,%eax
    19b3:	77 23                	ja     19d8 <printf+0x24b>
    19b5:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19bc:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19c2:	89 d2                	mov    %edx,%edx
    19c4:	48 01 d0             	add    %rdx,%rax
    19c7:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19cd:	83 c2 08             	add    $0x8,%edx
    19d0:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19d6:	eb 12                	jmp    19ea <printf+0x25d>
    19d8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19df:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19e3:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19ea:	8b 10                	mov    (%rax),%edx
    19ec:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19f2:	89 d6                	mov    %edx,%esi
    19f4:	89 c7                	mov    %eax,%edi
    19f6:	48 b8 38 16 00 00 00 	movabs $0x1638,%rax
    19fd:	00 00 00 
    1a00:	ff d0                	callq  *%rax
      break;
    1a02:	e9 58 01 00 00       	jmpq   1b5f <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1a07:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a0d:	83 f8 2f             	cmp    $0x2f,%eax
    1a10:	77 23                	ja     1a35 <printf+0x2a8>
    1a12:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a19:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a1f:	89 d2                	mov    %edx,%edx
    1a21:	48 01 d0             	add    %rdx,%rax
    1a24:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a2a:	83 c2 08             	add    $0x8,%edx
    1a2d:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a33:	eb 12                	jmp    1a47 <printf+0x2ba>
    1a35:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a3c:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a40:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a47:	48 8b 10             	mov    (%rax),%rdx
    1a4a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a50:	48 89 d6             	mov    %rdx,%rsi
    1a53:	89 c7                	mov    %eax,%edi
    1a55:	48 b8 db 15 00 00 00 	movabs $0x15db,%rax
    1a5c:	00 00 00 
    1a5f:	ff d0                	callq  *%rax
      break;
    1a61:	e9 f9 00 00 00       	jmpq   1b5f <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1a66:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a6c:	83 f8 2f             	cmp    $0x2f,%eax
    1a6f:	77 23                	ja     1a94 <printf+0x307>
    1a71:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a78:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a7e:	89 d2                	mov    %edx,%edx
    1a80:	48 01 d0             	add    %rdx,%rax
    1a83:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a89:	83 c2 08             	add    $0x8,%edx
    1a8c:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a92:	eb 12                	jmp    1aa6 <printf+0x319>
    1a94:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a9b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a9f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1aa6:	48 8b 00             	mov    (%rax),%rax
    1aa9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1ab0:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1ab7:	00 
    1ab8:	75 41                	jne    1afb <printf+0x36e>
        s = "(null)";
    1aba:	48 b8 20 1f 00 00 00 	movabs $0x1f20,%rax
    1ac1:	00 00 00 
    1ac4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1acb:	eb 2e                	jmp    1afb <printf+0x36e>
        putc(fd, *(s++));
    1acd:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1ad4:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1ad8:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1adf:	0f b6 00             	movzbl (%rax),%eax
    1ae2:	0f be d0             	movsbl %al,%edx
    1ae5:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1aeb:	89 d6                	mov    %edx,%esi
    1aed:	89 c7                	mov    %eax,%edi
    1aef:	48 b8 a7 15 00 00 00 	movabs $0x15a7,%rax
    1af6:	00 00 00 
    1af9:	ff d0                	callq  *%rax
      while (*s)
    1afb:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b02:	0f b6 00             	movzbl (%rax),%eax
    1b05:	84 c0                	test   %al,%al
    1b07:	75 c4                	jne    1acd <printf+0x340>
      break;
    1b09:	eb 54                	jmp    1b5f <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1b0b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b11:	be 25 00 00 00       	mov    $0x25,%esi
    1b16:	89 c7                	mov    %eax,%edi
    1b18:	48 b8 a7 15 00 00 00 	movabs $0x15a7,%rax
    1b1f:	00 00 00 
    1b22:	ff d0                	callq  *%rax
      break;
    1b24:	eb 39                	jmp    1b5f <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1b26:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b2c:	be 25 00 00 00       	mov    $0x25,%esi
    1b31:	89 c7                	mov    %eax,%edi
    1b33:	48 b8 a7 15 00 00 00 	movabs $0x15a7,%rax
    1b3a:	00 00 00 
    1b3d:	ff d0                	callq  *%rax
      putc(fd, c);
    1b3f:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1b45:	0f be d0             	movsbl %al,%edx
    1b48:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b4e:	89 d6                	mov    %edx,%esi
    1b50:	89 c7                	mov    %eax,%edi
    1b52:	48 b8 a7 15 00 00 00 	movabs $0x15a7,%rax
    1b59:	00 00 00 
    1b5c:	ff d0                	callq  *%rax
      break;
    1b5e:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1b5f:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1b66:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1b6c:	48 63 d0             	movslq %eax,%rdx
    1b6f:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1b76:	48 01 d0             	add    %rdx,%rax
    1b79:	0f b6 00             	movzbl (%rax),%eax
    1b7c:	0f be c0             	movsbl %al,%eax
    1b7f:	25 ff 00 00 00       	and    $0xff,%eax
    1b84:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1b8a:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1b91:	0f 85 8e fc ff ff    	jne    1825 <printf+0x98>
    }
  }
}
    1b97:	eb 01                	jmp    1b9a <printf+0x40d>
      break;
    1b99:	90                   	nop
}
    1b9a:	90                   	nop
    1b9b:	c9                   	leaveq 
    1b9c:	c3                   	retq   

0000000000001b9d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1b9d:	f3 0f 1e fa          	endbr64 
    1ba1:	55                   	push   %rbp
    1ba2:	48 89 e5             	mov    %rsp,%rbp
    1ba5:	48 83 ec 18          	sub    $0x18,%rsp
    1ba9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1bad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1bb1:	48 83 e8 10          	sub    $0x10,%rax
    1bb5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1bb9:	48 b8 80 22 00 00 00 	movabs $0x2280,%rax
    1bc0:	00 00 00 
    1bc3:	48 8b 00             	mov    (%rax),%rax
    1bc6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1bca:	eb 2f                	jmp    1bfb <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1bcc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bd0:	48 8b 00             	mov    (%rax),%rax
    1bd3:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1bd7:	72 17                	jb     1bf0 <free+0x53>
    1bd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bdd:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1be1:	77 2f                	ja     1c12 <free+0x75>
    1be3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1be7:	48 8b 00             	mov    (%rax),%rax
    1bea:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1bee:	72 22                	jb     1c12 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1bf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bf4:	48 8b 00             	mov    (%rax),%rax
    1bf7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1bfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bff:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c03:	76 c7                	jbe    1bcc <free+0x2f>
    1c05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c09:	48 8b 00             	mov    (%rax),%rax
    1c0c:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c10:	73 ba                	jae    1bcc <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1c12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c16:	8b 40 08             	mov    0x8(%rax),%eax
    1c19:	89 c0                	mov    %eax,%eax
    1c1b:	48 c1 e0 04          	shl    $0x4,%rax
    1c1f:	48 89 c2             	mov    %rax,%rdx
    1c22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c26:	48 01 c2             	add    %rax,%rdx
    1c29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c2d:	48 8b 00             	mov    (%rax),%rax
    1c30:	48 39 c2             	cmp    %rax,%rdx
    1c33:	75 2d                	jne    1c62 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1c35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c39:	8b 50 08             	mov    0x8(%rax),%edx
    1c3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c40:	48 8b 00             	mov    (%rax),%rax
    1c43:	8b 40 08             	mov    0x8(%rax),%eax
    1c46:	01 c2                	add    %eax,%edx
    1c48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c4c:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1c4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c53:	48 8b 00             	mov    (%rax),%rax
    1c56:	48 8b 10             	mov    (%rax),%rdx
    1c59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c5d:	48 89 10             	mov    %rdx,(%rax)
    1c60:	eb 0e                	jmp    1c70 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1c62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c66:	48 8b 10             	mov    (%rax),%rdx
    1c69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c6d:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1c70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c74:	8b 40 08             	mov    0x8(%rax),%eax
    1c77:	89 c0                	mov    %eax,%eax
    1c79:	48 c1 e0 04          	shl    $0x4,%rax
    1c7d:	48 89 c2             	mov    %rax,%rdx
    1c80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c84:	48 01 d0             	add    %rdx,%rax
    1c87:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c8b:	75 27                	jne    1cb4 <free+0x117>
    p->s.size += bp->s.size;
    1c8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c91:	8b 50 08             	mov    0x8(%rax),%edx
    1c94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c98:	8b 40 08             	mov    0x8(%rax),%eax
    1c9b:	01 c2                	add    %eax,%edx
    1c9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ca1:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1ca4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ca8:	48 8b 10             	mov    (%rax),%rdx
    1cab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1caf:	48 89 10             	mov    %rdx,(%rax)
    1cb2:	eb 0b                	jmp    1cbf <free+0x122>
  } else
    p->s.ptr = bp;
    1cb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cb8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1cbc:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1cbf:	48 ba 80 22 00 00 00 	movabs $0x2280,%rdx
    1cc6:	00 00 00 
    1cc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ccd:	48 89 02             	mov    %rax,(%rdx)
}
    1cd0:	90                   	nop
    1cd1:	c9                   	leaveq 
    1cd2:	c3                   	retq   

0000000000001cd3 <morecore>:

static Header*
morecore(uint nu)
{
    1cd3:	f3 0f 1e fa          	endbr64 
    1cd7:	55                   	push   %rbp
    1cd8:	48 89 e5             	mov    %rsp,%rbp
    1cdb:	48 83 ec 20          	sub    $0x20,%rsp
    1cdf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1ce2:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1ce9:	77 07                	ja     1cf2 <morecore+0x1f>
    nu = 4096;
    1ceb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1cf2:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1cf5:	48 c1 e0 04          	shl    $0x4,%rax
    1cf9:	48 89 c7             	mov    %rax,%rdi
    1cfc:	48 b8 66 15 00 00 00 	movabs $0x1566,%rax
    1d03:	00 00 00 
    1d06:	ff d0                	callq  *%rax
    1d08:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1d0c:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1d11:	75 07                	jne    1d1a <morecore+0x47>
    return 0;
    1d13:	b8 00 00 00 00       	mov    $0x0,%eax
    1d18:	eb 36                	jmp    1d50 <morecore+0x7d>
  hp = (Header*)p;
    1d1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d1e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1d22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d26:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d29:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1d2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d30:	48 83 c0 10          	add    $0x10,%rax
    1d34:	48 89 c7             	mov    %rax,%rdi
    1d37:	48 b8 9d 1b 00 00 00 	movabs $0x1b9d,%rax
    1d3e:	00 00 00 
    1d41:	ff d0                	callq  *%rax
  return freep;
    1d43:	48 b8 80 22 00 00 00 	movabs $0x2280,%rax
    1d4a:	00 00 00 
    1d4d:	48 8b 00             	mov    (%rax),%rax
}
    1d50:	c9                   	leaveq 
    1d51:	c3                   	retq   

0000000000001d52 <malloc>:

void*
malloc(uint nbytes)
{
    1d52:	f3 0f 1e fa          	endbr64 
    1d56:	55                   	push   %rbp
    1d57:	48 89 e5             	mov    %rsp,%rbp
    1d5a:	48 83 ec 30          	sub    $0x30,%rsp
    1d5e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1d61:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1d64:	48 83 c0 0f          	add    $0xf,%rax
    1d68:	48 c1 e8 04          	shr    $0x4,%rax
    1d6c:	83 c0 01             	add    $0x1,%eax
    1d6f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1d72:	48 b8 80 22 00 00 00 	movabs $0x2280,%rax
    1d79:	00 00 00 
    1d7c:	48 8b 00             	mov    (%rax),%rax
    1d7f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d83:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1d88:	75 4a                	jne    1dd4 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1d8a:	48 b8 70 22 00 00 00 	movabs $0x2270,%rax
    1d91:	00 00 00 
    1d94:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d98:	48 ba 80 22 00 00 00 	movabs $0x2280,%rdx
    1d9f:	00 00 00 
    1da2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1da6:	48 89 02             	mov    %rax,(%rdx)
    1da9:	48 b8 80 22 00 00 00 	movabs $0x2280,%rax
    1db0:	00 00 00 
    1db3:	48 8b 00             	mov    (%rax),%rax
    1db6:	48 ba 70 22 00 00 00 	movabs $0x2270,%rdx
    1dbd:	00 00 00 
    1dc0:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1dc3:	48 b8 70 22 00 00 00 	movabs $0x2270,%rax
    1dca:	00 00 00 
    1dcd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1dd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dd8:	48 8b 00             	mov    (%rax),%rax
    1ddb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1ddf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1de3:	8b 40 08             	mov    0x8(%rax),%eax
    1de6:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1de9:	77 65                	ja     1e50 <malloc+0xfe>
      if(p->s.size == nunits)
    1deb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1def:	8b 40 08             	mov    0x8(%rax),%eax
    1df2:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1df5:	75 10                	jne    1e07 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1df7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dfb:	48 8b 10             	mov    (%rax),%rdx
    1dfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e02:	48 89 10             	mov    %rdx,(%rax)
    1e05:	eb 2e                	jmp    1e35 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1e07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e0b:	8b 40 08             	mov    0x8(%rax),%eax
    1e0e:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1e11:	89 c2                	mov    %eax,%edx
    1e13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e17:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1e1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e1e:	8b 40 08             	mov    0x8(%rax),%eax
    1e21:	89 c0                	mov    %eax,%eax
    1e23:	48 c1 e0 04          	shl    $0x4,%rax
    1e27:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1e2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e2f:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1e32:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1e35:	48 ba 80 22 00 00 00 	movabs $0x2280,%rdx
    1e3c:	00 00 00 
    1e3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e43:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1e46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e4a:	48 83 c0 10          	add    $0x10,%rax
    1e4e:	eb 4e                	jmp    1e9e <malloc+0x14c>
    }
    if(p == freep)
    1e50:	48 b8 80 22 00 00 00 	movabs $0x2280,%rax
    1e57:	00 00 00 
    1e5a:	48 8b 00             	mov    (%rax),%rax
    1e5d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1e61:	75 23                	jne    1e86 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1e63:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1e66:	89 c7                	mov    %eax,%edi
    1e68:	48 b8 d3 1c 00 00 00 	movabs $0x1cd3,%rax
    1e6f:	00 00 00 
    1e72:	ff d0                	callq  *%rax
    1e74:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1e78:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1e7d:	75 07                	jne    1e86 <malloc+0x134>
        return 0;
    1e7f:	b8 00 00 00 00       	mov    $0x0,%eax
    1e84:	eb 18                	jmp    1e9e <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e8a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e92:	48 8b 00             	mov    (%rax),%rax
    1e95:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e99:	e9 41 ff ff ff       	jmpq   1ddf <malloc+0x8d>
  }
}
    1e9e:	c9                   	leaveq 
    1e9f:	c3                   	retq   
