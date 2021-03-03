
_dedup_writer:     file format elf64-x86-64


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
    1013:	48 b8 4f 17 00 00 00 	movabs $0x174f,%rax
    101a:	00 00 00 
    101d:	ff d0                	callq  *%rax
    101f:	89 c2                	mov    %eax,%edx
    1021:	48 be 58 20 00 00 00 	movabs $0x2058,%rsi
    1028:	00 00 00 
    102b:	bf 01 00 00 00       	mov    $0x1,%edi
    1030:	b8 00 00 00 00       	mov    $0x0,%eax
    1035:	48 b9 42 19 00 00 00 	movabs $0x1942,%rcx
    103c:	00 00 00 
    103f:	ff d1                	callq  *%rcx
  char* buf = malloc(10000000);
    1041:	bf 80 96 98 00       	mov    $0x989680,%edi
    1046:	48 b8 07 1f 00 00 00 	movabs $0x1f07,%rax
    104d:	00 00 00 
    1050:	ff d0                	callq  *%rax
    1052:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  memset(buf,0,10000000);
    1056:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    105a:	ba 80 96 98 00       	mov    $0x989680,%edx
    105f:	be 00 00 00 00       	mov    $0x0,%esi
    1064:	48 89 c7             	mov    %rax,%rdi
    1067:	48 b8 09 14 00 00 00 	movabs $0x1409,%rax
    106e:	00 00 00 
    1071:	ff d0                	callq  *%rax
  printf(1,"Freepages after malloc: %d\n",freepages());
    1073:	48 b8 4f 17 00 00 00 	movabs $0x174f,%rax
    107a:	00 00 00 
    107d:	ff d0                	callq  *%rax
    107f:	89 c2                	mov    %eax,%edx
    1081:	48 be 70 20 00 00 00 	movabs $0x2070,%rsi
    1088:	00 00 00 
    108b:	bf 01 00 00 00       	mov    $0x1,%edi
    1090:	b8 00 00 00 00       	mov    $0x0,%eax
    1095:	48 b9 42 19 00 00 00 	movabs $0x1942,%rcx
    109c:	00 00 00 
    109f:	ff d1                	callq  *%rcx
  dedup();
    10a1:	48 b8 42 17 00 00 00 	movabs $0x1742,%rax
    10a8:	00 00 00 
    10ab:	ff d0                	callq  *%rax
  printf(1,"Freepages after dedup: %d\n",freepages());
    10ad:	48 b8 4f 17 00 00 00 	movabs $0x174f,%rax
    10b4:	00 00 00 
    10b7:	ff d0                	callq  *%rax
    10b9:	89 c2                	mov    %eax,%edx
    10bb:	48 be 8c 20 00 00 00 	movabs $0x208c,%rsi
    10c2:	00 00 00 
    10c5:	bf 01 00 00 00       	mov    $0x1,%edi
    10ca:	b8 00 00 00 00       	mov    $0x0,%eax
    10cf:	48 b9 42 19 00 00 00 	movabs $0x1942,%rcx
    10d6:	00 00 00 
    10d9:	ff d1                	callq  *%rcx
  memset(buf,1,1000000);
    10db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    10df:	ba 40 42 0f 00       	mov    $0xf4240,%edx
    10e4:	be 01 00 00 00       	mov    $0x1,%esi
    10e9:	48 89 c7             	mov    %rax,%rdi
    10ec:	48 b8 09 14 00 00 00 	movabs $0x1409,%rax
    10f3:	00 00 00 
    10f6:	ff d0                	callq  *%rax
  printf(1,"Freepages after writing a little: %d\n",freepages());
    10f8:	48 b8 4f 17 00 00 00 	movabs $0x174f,%rax
    10ff:	00 00 00 
    1102:	ff d0                	callq  *%rax
    1104:	89 c2                	mov    %eax,%edx
    1106:	48 be a8 20 00 00 00 	movabs $0x20a8,%rsi
    110d:	00 00 00 
    1110:	bf 01 00 00 00       	mov    $0x1,%edi
    1115:	b8 00 00 00 00       	mov    $0x0,%eax
    111a:	48 b9 42 19 00 00 00 	movabs $0x1942,%rcx
    1121:	00 00 00 
    1124:	ff d1                	callq  *%rcx
  dedup();
    1126:	48 b8 42 17 00 00 00 	movabs $0x1742,%rax
    112d:	00 00 00 
    1130:	ff d0                	callq  *%rax

  for(int i=0;i<1000000;i++) {
    1132:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1139:	eb 70                	jmp    11ab <main+0x1ab>
    if(buf[i]!=1) {
    113b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    113e:	48 63 d0             	movslq %eax,%rdx
    1141:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1145:	48 01 d0             	add    %rdx,%rax
    1148:	0f b6 00             	movzbl (%rax),%eax
    114b:	3c 01                	cmp    $0x1,%al
    114d:	74 58                	je     11a7 <main+0x1a7>
      printf(1,"Uh-oh! Found some junk in my frunk! at %d, %p: %d!\n", i, &buf[i], buf[i]);
    114f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1152:	48 63 d0             	movslq %eax,%rdx
    1155:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1159:	48 01 d0             	add    %rdx,%rax
    115c:	0f b6 00             	movzbl (%rax),%eax
    115f:	0f be c8             	movsbl %al,%ecx
    1162:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1165:	48 63 d0             	movslq %eax,%rdx
    1168:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    116c:	48 01 c2             	add    %rax,%rdx
    116f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1172:	41 89 c8             	mov    %ecx,%r8d
    1175:	48 89 d1             	mov    %rdx,%rcx
    1178:	89 c2                	mov    %eax,%edx
    117a:	48 be d0 20 00 00 00 	movabs $0x20d0,%rsi
    1181:	00 00 00 
    1184:	bf 01 00 00 00       	mov    $0x1,%edi
    1189:	b8 00 00 00 00       	mov    $0x0,%eax
    118e:	49 b9 42 19 00 00 00 	movabs $0x1942,%r9
    1195:	00 00 00 
    1198:	41 ff d1             	callq  *%r9
      exit();
    119b:	48 b8 3e 16 00 00 00 	movabs $0x163e,%rax
    11a2:	00 00 00 
    11a5:	ff d0                	callq  *%rax
  for(int i=0;i<1000000;i++) {
    11a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    11ab:	81 7d fc 3f 42 0f 00 	cmpl   $0xf423f,-0x4(%rbp)
    11b2:	7e 87                	jle    113b <main+0x13b>
    }
  }
  for(int i=1000000;i<10000000;i++) {
    11b4:	c7 45 f8 40 42 0f 00 	movl   $0xf4240,-0x8(%rbp)
    11bb:	eb 70                	jmp    122d <main+0x22d>
    if(buf[i]) {
    11bd:	8b 45 f8             	mov    -0x8(%rbp),%eax
    11c0:	48 63 d0             	movslq %eax,%rdx
    11c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    11c7:	48 01 d0             	add    %rdx,%rax
    11ca:	0f b6 00             	movzbl (%rax),%eax
    11cd:	84 c0                	test   %al,%al
    11cf:	74 58                	je     1229 <main+0x229>
      printf(1,"Uh-oh! Found some junk in my trunk! at %d, %p: %d!\n", i, &buf[i], buf[i]);
    11d1:	8b 45 f8             	mov    -0x8(%rbp),%eax
    11d4:	48 63 d0             	movslq %eax,%rdx
    11d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    11db:	48 01 d0             	add    %rdx,%rax
    11de:	0f b6 00             	movzbl (%rax),%eax
    11e1:	0f be c8             	movsbl %al,%ecx
    11e4:	8b 45 f8             	mov    -0x8(%rbp),%eax
    11e7:	48 63 d0             	movslq %eax,%rdx
    11ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    11ee:	48 01 c2             	add    %rax,%rdx
    11f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
    11f4:	41 89 c8             	mov    %ecx,%r8d
    11f7:	48 89 d1             	mov    %rdx,%rcx
    11fa:	89 c2                	mov    %eax,%edx
    11fc:	48 be 08 21 00 00 00 	movabs $0x2108,%rsi
    1203:	00 00 00 
    1206:	bf 01 00 00 00       	mov    $0x1,%edi
    120b:	b8 00 00 00 00       	mov    $0x0,%eax
    1210:	49 b9 42 19 00 00 00 	movabs $0x1942,%r9
    1217:	00 00 00 
    121a:	41 ff d1             	callq  *%r9
      exit();
    121d:	48 b8 3e 16 00 00 00 	movabs $0x163e,%rax
    1224:	00 00 00 
    1227:	ff d0                	callq  *%rax
  for(int i=1000000;i<10000000;i++) {
    1229:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    122d:	81 7d f8 7f 96 98 00 	cmpl   $0x98967f,-0x8(%rbp)
    1234:	7e 87                	jle    11bd <main+0x1bd>
    }
  }

  printf(1,"Freepages after dedup: %d\n",freepages());
    1236:	48 b8 4f 17 00 00 00 	movabs $0x174f,%rax
    123d:	00 00 00 
    1240:	ff d0                	callq  *%rax
    1242:	89 c2                	mov    %eax,%edx
    1244:	48 be 8c 20 00 00 00 	movabs $0x208c,%rsi
    124b:	00 00 00 
    124e:	bf 01 00 00 00       	mov    $0x1,%edi
    1253:	b8 00 00 00 00       	mov    $0x0,%eax
    1258:	48 b9 42 19 00 00 00 	movabs $0x1942,%rcx
    125f:	00 00 00 
    1262:	ff d1                	callq  *%rcx
  memset(buf+1000000,1,9000000);
    1264:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1268:	48 05 40 42 0f 00    	add    $0xf4240,%rax
    126e:	ba 40 54 89 00       	mov    $0x895440,%edx
    1273:	be 01 00 00 00       	mov    $0x1,%esi
    1278:	48 89 c7             	mov    %rax,%rdi
    127b:	48 b8 09 14 00 00 00 	movabs $0x1409,%rax
    1282:	00 00 00 
    1285:	ff d0                	callq  *%rax
  printf(1,"Freepages after writing the rest: %d\n",freepages());
    1287:	48 b8 4f 17 00 00 00 	movabs $0x174f,%rax
    128e:	00 00 00 
    1291:	ff d0                	callq  *%rax
    1293:	89 c2                	mov    %eax,%edx
    1295:	48 be 40 21 00 00 00 	movabs $0x2140,%rsi
    129c:	00 00 00 
    129f:	bf 01 00 00 00       	mov    $0x1,%edi
    12a4:	b8 00 00 00 00       	mov    $0x0,%eax
    12a9:	48 b9 42 19 00 00 00 	movabs $0x1942,%rcx
    12b0:	00 00 00 
    12b3:	ff d1                	callq  *%rcx
  dedup();
    12b5:	48 b8 42 17 00 00 00 	movabs $0x1742,%rax
    12bc:	00 00 00 
    12bf:	ff d0                	callq  *%rax
  printf(1,"Freepages after dedup: %d\n",freepages());
    12c1:	48 b8 4f 17 00 00 00 	movabs $0x174f,%rax
    12c8:	00 00 00 
    12cb:	ff d0                	callq  *%rax
    12cd:	89 c2                	mov    %eax,%edx
    12cf:	48 be 8c 20 00 00 00 	movabs $0x208c,%rsi
    12d6:	00 00 00 
    12d9:	bf 01 00 00 00       	mov    $0x1,%edi
    12de:	b8 00 00 00 00       	mov    $0x0,%eax
    12e3:	48 b9 42 19 00 00 00 	movabs $0x1942,%rcx
    12ea:	00 00 00 
    12ed:	ff d1                	callq  *%rcx
  exit();
    12ef:	48 b8 3e 16 00 00 00 	movabs $0x163e,%rax
    12f6:	00 00 00 
    12f9:	ff d0                	callq  *%rax

00000000000012fb <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    12fb:	f3 0f 1e fa          	endbr64 
    12ff:	55                   	push   %rbp
    1300:	48 89 e5             	mov    %rsp,%rbp
    1303:	48 83 ec 10          	sub    $0x10,%rsp
    1307:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    130b:	89 75 f4             	mov    %esi,-0xc(%rbp)
    130e:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    1311:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1315:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1318:	8b 45 f4             	mov    -0xc(%rbp),%eax
    131b:	48 89 ce             	mov    %rcx,%rsi
    131e:	48 89 f7             	mov    %rsi,%rdi
    1321:	89 d1                	mov    %edx,%ecx
    1323:	fc                   	cld    
    1324:	f3 aa                	rep stos %al,%es:(%rdi)
    1326:	89 ca                	mov    %ecx,%edx
    1328:	48 89 fe             	mov    %rdi,%rsi
    132b:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    132f:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1332:	90                   	nop
    1333:	c9                   	leaveq 
    1334:	c3                   	retq   

0000000000001335 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1335:	f3 0f 1e fa          	endbr64 
    1339:	55                   	push   %rbp
    133a:	48 89 e5             	mov    %rsp,%rbp
    133d:	48 83 ec 20          	sub    $0x20,%rsp
    1341:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1345:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    1349:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    134d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1351:	90                   	nop
    1352:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1356:	48 8d 42 01          	lea    0x1(%rdx),%rax
    135a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    135e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1362:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1366:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    136a:	0f b6 12             	movzbl (%rdx),%edx
    136d:	88 10                	mov    %dl,(%rax)
    136f:	0f b6 00             	movzbl (%rax),%eax
    1372:	84 c0                	test   %al,%al
    1374:	75 dc                	jne    1352 <strcpy+0x1d>
    ;
  return os;
    1376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    137a:	c9                   	leaveq 
    137b:	c3                   	retq   

000000000000137c <strcmp>:

int
strcmp(const char *p, const char *q)
{
    137c:	f3 0f 1e fa          	endbr64 
    1380:	55                   	push   %rbp
    1381:	48 89 e5             	mov    %rsp,%rbp
    1384:	48 83 ec 10          	sub    $0x10,%rsp
    1388:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    138c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1390:	eb 0a                	jmp    139c <strcmp+0x20>
    p++, q++;
    1392:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1397:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    139c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13a0:	0f b6 00             	movzbl (%rax),%eax
    13a3:	84 c0                	test   %al,%al
    13a5:	74 12                	je     13b9 <strcmp+0x3d>
    13a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13ab:	0f b6 10             	movzbl (%rax),%edx
    13ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    13b2:	0f b6 00             	movzbl (%rax),%eax
    13b5:	38 c2                	cmp    %al,%dl
    13b7:	74 d9                	je     1392 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    13b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13bd:	0f b6 00             	movzbl (%rax),%eax
    13c0:	0f b6 d0             	movzbl %al,%edx
    13c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    13c7:	0f b6 00             	movzbl (%rax),%eax
    13ca:	0f b6 c0             	movzbl %al,%eax
    13cd:	29 c2                	sub    %eax,%edx
    13cf:	89 d0                	mov    %edx,%eax
}
    13d1:	c9                   	leaveq 
    13d2:	c3                   	retq   

00000000000013d3 <strlen>:

uint
strlen(char *s)
{
    13d3:	f3 0f 1e fa          	endbr64 
    13d7:	55                   	push   %rbp
    13d8:	48 89 e5             	mov    %rsp,%rbp
    13db:	48 83 ec 18          	sub    $0x18,%rsp
    13df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    13e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    13ea:	eb 04                	jmp    13f0 <strlen+0x1d>
    13ec:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    13f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13f3:	48 63 d0             	movslq %eax,%rdx
    13f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13fa:	48 01 d0             	add    %rdx,%rax
    13fd:	0f b6 00             	movzbl (%rax),%eax
    1400:	84 c0                	test   %al,%al
    1402:	75 e8                	jne    13ec <strlen+0x19>
    ;
  return n;
    1404:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1407:	c9                   	leaveq 
    1408:	c3                   	retq   

0000000000001409 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1409:	f3 0f 1e fa          	endbr64 
    140d:	55                   	push   %rbp
    140e:	48 89 e5             	mov    %rsp,%rbp
    1411:	48 83 ec 10          	sub    $0x10,%rsp
    1415:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1419:	89 75 f4             	mov    %esi,-0xc(%rbp)
    141c:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    141f:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1422:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    1425:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1429:	89 ce                	mov    %ecx,%esi
    142b:	48 89 c7             	mov    %rax,%rdi
    142e:	48 b8 fb 12 00 00 00 	movabs $0x12fb,%rax
    1435:	00 00 00 
    1438:	ff d0                	callq  *%rax
  return dst;
    143a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    143e:	c9                   	leaveq 
    143f:	c3                   	retq   

0000000000001440 <strchr>:

char*
strchr(const char *s, char c)
{
    1440:	f3 0f 1e fa          	endbr64 
    1444:	55                   	push   %rbp
    1445:	48 89 e5             	mov    %rsp,%rbp
    1448:	48 83 ec 10          	sub    $0x10,%rsp
    144c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1450:	89 f0                	mov    %esi,%eax
    1452:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1455:	eb 17                	jmp    146e <strchr+0x2e>
    if(*s == c)
    1457:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    145b:	0f b6 00             	movzbl (%rax),%eax
    145e:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1461:	75 06                	jne    1469 <strchr+0x29>
      return (char*)s;
    1463:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1467:	eb 15                	jmp    147e <strchr+0x3e>
  for(; *s; s++)
    1469:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    146e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1472:	0f b6 00             	movzbl (%rax),%eax
    1475:	84 c0                	test   %al,%al
    1477:	75 de                	jne    1457 <strchr+0x17>
  return 0;
    1479:	b8 00 00 00 00       	mov    $0x0,%eax
}
    147e:	c9                   	leaveq 
    147f:	c3                   	retq   

0000000000001480 <gets>:

char*
gets(char *buf, int max)
{
    1480:	f3 0f 1e fa          	endbr64 
    1484:	55                   	push   %rbp
    1485:	48 89 e5             	mov    %rsp,%rbp
    1488:	48 83 ec 20          	sub    $0x20,%rsp
    148c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1490:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1493:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    149a:	eb 4f                	jmp    14eb <gets+0x6b>
    cc = read(0, &c, 1);
    149c:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    14a0:	ba 01 00 00 00       	mov    $0x1,%edx
    14a5:	48 89 c6             	mov    %rax,%rsi
    14a8:	bf 00 00 00 00       	mov    $0x0,%edi
    14ad:	48 b8 65 16 00 00 00 	movabs $0x1665,%rax
    14b4:	00 00 00 
    14b7:	ff d0                	callq  *%rax
    14b9:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    14bc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    14c0:	7e 36                	jle    14f8 <gets+0x78>
      break;
    buf[i++] = c;
    14c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14c5:	8d 50 01             	lea    0x1(%rax),%edx
    14c8:	89 55 fc             	mov    %edx,-0x4(%rbp)
    14cb:	48 63 d0             	movslq %eax,%rdx
    14ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14d2:	48 01 c2             	add    %rax,%rdx
    14d5:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    14d9:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    14db:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    14df:	3c 0a                	cmp    $0xa,%al
    14e1:	74 16                	je     14f9 <gets+0x79>
    14e3:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    14e7:	3c 0d                	cmp    $0xd,%al
    14e9:	74 0e                	je     14f9 <gets+0x79>
  for(i=0; i+1 < max; ){
    14eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14ee:	83 c0 01             	add    $0x1,%eax
    14f1:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    14f4:	7f a6                	jg     149c <gets+0x1c>
    14f6:	eb 01                	jmp    14f9 <gets+0x79>
      break;
    14f8:	90                   	nop
      break;
  }
  buf[i] = '\0';
    14f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14fc:	48 63 d0             	movslq %eax,%rdx
    14ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1503:	48 01 d0             	add    %rdx,%rax
    1506:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    150d:	c9                   	leaveq 
    150e:	c3                   	retq   

000000000000150f <stat>:

int
stat(char *n, struct stat *st)
{
    150f:	f3 0f 1e fa          	endbr64 
    1513:	55                   	push   %rbp
    1514:	48 89 e5             	mov    %rsp,%rbp
    1517:	48 83 ec 20          	sub    $0x20,%rsp
    151b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    151f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1527:	be 00 00 00 00       	mov    $0x0,%esi
    152c:	48 89 c7             	mov    %rax,%rdi
    152f:	48 b8 a6 16 00 00 00 	movabs $0x16a6,%rax
    1536:	00 00 00 
    1539:	ff d0                	callq  *%rax
    153b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    153e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1542:	79 07                	jns    154b <stat+0x3c>
    return -1;
    1544:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1549:	eb 2f                	jmp    157a <stat+0x6b>
  r = fstat(fd, st);
    154b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    154f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1552:	48 89 d6             	mov    %rdx,%rsi
    1555:	89 c7                	mov    %eax,%edi
    1557:	48 b8 cd 16 00 00 00 	movabs $0x16cd,%rax
    155e:	00 00 00 
    1561:	ff d0                	callq  *%rax
    1563:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1566:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1569:	89 c7                	mov    %eax,%edi
    156b:	48 b8 7f 16 00 00 00 	movabs $0x167f,%rax
    1572:	00 00 00 
    1575:	ff d0                	callq  *%rax
  return r;
    1577:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    157a:	c9                   	leaveq 
    157b:	c3                   	retq   

000000000000157c <atoi>:

int
atoi(const char *s)
{
    157c:	f3 0f 1e fa          	endbr64 
    1580:	55                   	push   %rbp
    1581:	48 89 e5             	mov    %rsp,%rbp
    1584:	48 83 ec 18          	sub    $0x18,%rsp
    1588:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    158c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1593:	eb 28                	jmp    15bd <atoi+0x41>
    n = n*10 + *s++ - '0';
    1595:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1598:	89 d0                	mov    %edx,%eax
    159a:	c1 e0 02             	shl    $0x2,%eax
    159d:	01 d0                	add    %edx,%eax
    159f:	01 c0                	add    %eax,%eax
    15a1:	89 c1                	mov    %eax,%ecx
    15a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    15a7:	48 8d 50 01          	lea    0x1(%rax),%rdx
    15ab:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    15af:	0f b6 00             	movzbl (%rax),%eax
    15b2:	0f be c0             	movsbl %al,%eax
    15b5:	01 c8                	add    %ecx,%eax
    15b7:	83 e8 30             	sub    $0x30,%eax
    15ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    15bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    15c1:	0f b6 00             	movzbl (%rax),%eax
    15c4:	3c 2f                	cmp    $0x2f,%al
    15c6:	7e 0b                	jle    15d3 <atoi+0x57>
    15c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    15cc:	0f b6 00             	movzbl (%rax),%eax
    15cf:	3c 39                	cmp    $0x39,%al
    15d1:	7e c2                	jle    1595 <atoi+0x19>
  return n;
    15d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    15d6:	c9                   	leaveq 
    15d7:	c3                   	retq   

00000000000015d8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    15d8:	f3 0f 1e fa          	endbr64 
    15dc:	55                   	push   %rbp
    15dd:	48 89 e5             	mov    %rsp,%rbp
    15e0:	48 83 ec 28          	sub    $0x28,%rsp
    15e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    15e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    15ec:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    15ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    15f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    15f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    15fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    15ff:	eb 1d                	jmp    161e <memmove+0x46>
    *dst++ = *src++;
    1601:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1605:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1609:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    160d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1611:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1615:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    1619:	0f b6 12             	movzbl (%rdx),%edx
    161c:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    161e:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1621:	8d 50 ff             	lea    -0x1(%rax),%edx
    1624:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1627:	85 c0                	test   %eax,%eax
    1629:	7f d6                	jg     1601 <memmove+0x29>
  return vdst;
    162b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    162f:	c9                   	leaveq 
    1630:	c3                   	retq   

0000000000001631 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    1631:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    1638:	49 89 ca             	mov    %rcx,%r10
    163b:	0f 05                	syscall 
    163d:	c3                   	retq   

000000000000163e <exit>:
SYSCALL(exit)
    163e:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1645:	49 89 ca             	mov    %rcx,%r10
    1648:	0f 05                	syscall 
    164a:	c3                   	retq   

000000000000164b <wait>:
SYSCALL(wait)
    164b:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1652:	49 89 ca             	mov    %rcx,%r10
    1655:	0f 05                	syscall 
    1657:	c3                   	retq   

0000000000001658 <pipe>:
SYSCALL(pipe)
    1658:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    165f:	49 89 ca             	mov    %rcx,%r10
    1662:	0f 05                	syscall 
    1664:	c3                   	retq   

0000000000001665 <read>:
SYSCALL(read)
    1665:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    166c:	49 89 ca             	mov    %rcx,%r10
    166f:	0f 05                	syscall 
    1671:	c3                   	retq   

0000000000001672 <write>:
SYSCALL(write)
    1672:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    1679:	49 89 ca             	mov    %rcx,%r10
    167c:	0f 05                	syscall 
    167e:	c3                   	retq   

000000000000167f <close>:
SYSCALL(close)
    167f:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1686:	49 89 ca             	mov    %rcx,%r10
    1689:	0f 05                	syscall 
    168b:	c3                   	retq   

000000000000168c <kill>:
SYSCALL(kill)
    168c:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1693:	49 89 ca             	mov    %rcx,%r10
    1696:	0f 05                	syscall 
    1698:	c3                   	retq   

0000000000001699 <exec>:
SYSCALL(exec)
    1699:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    16a0:	49 89 ca             	mov    %rcx,%r10
    16a3:	0f 05                	syscall 
    16a5:	c3                   	retq   

00000000000016a6 <open>:
SYSCALL(open)
    16a6:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    16ad:	49 89 ca             	mov    %rcx,%r10
    16b0:	0f 05                	syscall 
    16b2:	c3                   	retq   

00000000000016b3 <mknod>:
SYSCALL(mknod)
    16b3:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    16ba:	49 89 ca             	mov    %rcx,%r10
    16bd:	0f 05                	syscall 
    16bf:	c3                   	retq   

00000000000016c0 <unlink>:
SYSCALL(unlink)
    16c0:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    16c7:	49 89 ca             	mov    %rcx,%r10
    16ca:	0f 05                	syscall 
    16cc:	c3                   	retq   

00000000000016cd <fstat>:
SYSCALL(fstat)
    16cd:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    16d4:	49 89 ca             	mov    %rcx,%r10
    16d7:	0f 05                	syscall 
    16d9:	c3                   	retq   

00000000000016da <link>:
SYSCALL(link)
    16da:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    16e1:	49 89 ca             	mov    %rcx,%r10
    16e4:	0f 05                	syscall 
    16e6:	c3                   	retq   

00000000000016e7 <mkdir>:
SYSCALL(mkdir)
    16e7:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    16ee:	49 89 ca             	mov    %rcx,%r10
    16f1:	0f 05                	syscall 
    16f3:	c3                   	retq   

00000000000016f4 <chdir>:
SYSCALL(chdir)
    16f4:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    16fb:	49 89 ca             	mov    %rcx,%r10
    16fe:	0f 05                	syscall 
    1700:	c3                   	retq   

0000000000001701 <dup>:
SYSCALL(dup)
    1701:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1708:	49 89 ca             	mov    %rcx,%r10
    170b:	0f 05                	syscall 
    170d:	c3                   	retq   

000000000000170e <getpid>:
SYSCALL(getpid)
    170e:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    1715:	49 89 ca             	mov    %rcx,%r10
    1718:	0f 05                	syscall 
    171a:	c3                   	retq   

000000000000171b <sbrk>:
SYSCALL(sbrk)
    171b:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    1722:	49 89 ca             	mov    %rcx,%r10
    1725:	0f 05                	syscall 
    1727:	c3                   	retq   

0000000000001728 <sleep>:
SYSCALL(sleep)
    1728:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    172f:	49 89 ca             	mov    %rcx,%r10
    1732:	0f 05                	syscall 
    1734:	c3                   	retq   

0000000000001735 <uptime>:
SYSCALL(uptime)
    1735:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    173c:	49 89 ca             	mov    %rcx,%r10
    173f:	0f 05                	syscall 
    1741:	c3                   	retq   

0000000000001742 <dedup>:
SYSCALL(dedup)
    1742:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    1749:	49 89 ca             	mov    %rcx,%r10
    174c:	0f 05                	syscall 
    174e:	c3                   	retq   

000000000000174f <freepages>:
SYSCALL(freepages)
    174f:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    1756:	49 89 ca             	mov    %rcx,%r10
    1759:	0f 05                	syscall 
    175b:	c3                   	retq   

000000000000175c <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    175c:	f3 0f 1e fa          	endbr64 
    1760:	55                   	push   %rbp
    1761:	48 89 e5             	mov    %rsp,%rbp
    1764:	48 83 ec 10          	sub    $0x10,%rsp
    1768:	89 7d fc             	mov    %edi,-0x4(%rbp)
    176b:	89 f0                	mov    %esi,%eax
    176d:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1770:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1774:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1777:	ba 01 00 00 00       	mov    $0x1,%edx
    177c:	48 89 ce             	mov    %rcx,%rsi
    177f:	89 c7                	mov    %eax,%edi
    1781:	48 b8 72 16 00 00 00 	movabs $0x1672,%rax
    1788:	00 00 00 
    178b:	ff d0                	callq  *%rax
}
    178d:	90                   	nop
    178e:	c9                   	leaveq 
    178f:	c3                   	retq   

0000000000001790 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1790:	f3 0f 1e fa          	endbr64 
    1794:	55                   	push   %rbp
    1795:	48 89 e5             	mov    %rsp,%rbp
    1798:	48 83 ec 20          	sub    $0x20,%rsp
    179c:	89 7d ec             	mov    %edi,-0x14(%rbp)
    179f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    17a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    17aa:	eb 35                	jmp    17e1 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    17ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    17b0:	48 c1 e8 3c          	shr    $0x3c,%rax
    17b4:	48 ba a0 24 00 00 00 	movabs $0x24a0,%rdx
    17bb:	00 00 00 
    17be:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    17c2:	0f be d0             	movsbl %al,%edx
    17c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
    17c8:	89 d6                	mov    %edx,%esi
    17ca:	89 c7                	mov    %eax,%edi
    17cc:	48 b8 5c 17 00 00 00 	movabs $0x175c,%rax
    17d3:	00 00 00 
    17d6:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    17d8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    17dc:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    17e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    17e4:	83 f8 0f             	cmp    $0xf,%eax
    17e7:	76 c3                	jbe    17ac <print_x64+0x1c>
}
    17e9:	90                   	nop
    17ea:	90                   	nop
    17eb:	c9                   	leaveq 
    17ec:	c3                   	retq   

00000000000017ed <print_x32>:

  static void
print_x32(int fd, uint x)
{
    17ed:	f3 0f 1e fa          	endbr64 
    17f1:	55                   	push   %rbp
    17f2:	48 89 e5             	mov    %rsp,%rbp
    17f5:	48 83 ec 20          	sub    $0x20,%rsp
    17f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
    17fc:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    17ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1806:	eb 36                	jmp    183e <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1808:	8b 45 e8             	mov    -0x18(%rbp),%eax
    180b:	c1 e8 1c             	shr    $0x1c,%eax
    180e:	89 c2                	mov    %eax,%edx
    1810:	48 b8 a0 24 00 00 00 	movabs $0x24a0,%rax
    1817:	00 00 00 
    181a:	89 d2                	mov    %edx,%edx
    181c:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    1820:	0f be d0             	movsbl %al,%edx
    1823:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1826:	89 d6                	mov    %edx,%esi
    1828:	89 c7                	mov    %eax,%edi
    182a:	48 b8 5c 17 00 00 00 	movabs $0x175c,%rax
    1831:	00 00 00 
    1834:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1836:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    183a:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    183e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1841:	83 f8 07             	cmp    $0x7,%eax
    1844:	76 c2                	jbe    1808 <print_x32+0x1b>
}
    1846:	90                   	nop
    1847:	90                   	nop
    1848:	c9                   	leaveq 
    1849:	c3                   	retq   

000000000000184a <print_d>:

  static void
print_d(int fd, int v)
{
    184a:	f3 0f 1e fa          	endbr64 
    184e:	55                   	push   %rbp
    184f:	48 89 e5             	mov    %rsp,%rbp
    1852:	48 83 ec 30          	sub    $0x30,%rsp
    1856:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1859:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    185c:	8b 45 d8             	mov    -0x28(%rbp),%eax
    185f:	48 98                	cltq   
    1861:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1865:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1869:	79 04                	jns    186f <print_d+0x25>
    x = -x;
    186b:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    186f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1876:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    187a:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1881:	66 66 66 
    1884:	48 89 c8             	mov    %rcx,%rax
    1887:	48 f7 ea             	imul   %rdx
    188a:	48 c1 fa 02          	sar    $0x2,%rdx
    188e:	48 89 c8             	mov    %rcx,%rax
    1891:	48 c1 f8 3f          	sar    $0x3f,%rax
    1895:	48 29 c2             	sub    %rax,%rdx
    1898:	48 89 d0             	mov    %rdx,%rax
    189b:	48 c1 e0 02          	shl    $0x2,%rax
    189f:	48 01 d0             	add    %rdx,%rax
    18a2:	48 01 c0             	add    %rax,%rax
    18a5:	48 29 c1             	sub    %rax,%rcx
    18a8:	48 89 ca             	mov    %rcx,%rdx
    18ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
    18ae:	8d 48 01             	lea    0x1(%rax),%ecx
    18b1:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    18b4:	48 b9 a0 24 00 00 00 	movabs $0x24a0,%rcx
    18bb:	00 00 00 
    18be:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    18c2:	48 98                	cltq   
    18c4:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    18c8:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    18cc:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    18d3:	66 66 66 
    18d6:	48 89 c8             	mov    %rcx,%rax
    18d9:	48 f7 ea             	imul   %rdx
    18dc:	48 c1 fa 02          	sar    $0x2,%rdx
    18e0:	48 89 c8             	mov    %rcx,%rax
    18e3:	48 c1 f8 3f          	sar    $0x3f,%rax
    18e7:	48 29 c2             	sub    %rax,%rdx
    18ea:	48 89 d0             	mov    %rdx,%rax
    18ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    18f1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    18f6:	0f 85 7a ff ff ff    	jne    1876 <print_d+0x2c>

  if (v < 0)
    18fc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1900:	79 32                	jns    1934 <print_d+0xea>
    buf[i++] = '-';
    1902:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1905:	8d 50 01             	lea    0x1(%rax),%edx
    1908:	89 55 f4             	mov    %edx,-0xc(%rbp)
    190b:	48 98                	cltq   
    190d:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1912:	eb 20                	jmp    1934 <print_d+0xea>
    putc(fd, buf[i]);
    1914:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1917:	48 98                	cltq   
    1919:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    191e:	0f be d0             	movsbl %al,%edx
    1921:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1924:	89 d6                	mov    %edx,%esi
    1926:	89 c7                	mov    %eax,%edi
    1928:	48 b8 5c 17 00 00 00 	movabs $0x175c,%rax
    192f:	00 00 00 
    1932:	ff d0                	callq  *%rax
  while (--i >= 0)
    1934:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1938:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    193c:	79 d6                	jns    1914 <print_d+0xca>
}
    193e:	90                   	nop
    193f:	90                   	nop
    1940:	c9                   	leaveq 
    1941:	c3                   	retq   

0000000000001942 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1942:	f3 0f 1e fa          	endbr64 
    1946:	55                   	push   %rbp
    1947:	48 89 e5             	mov    %rsp,%rbp
    194a:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1951:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1957:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    195e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1965:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    196c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1973:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    197a:	84 c0                	test   %al,%al
    197c:	74 20                	je     199e <printf+0x5c>
    197e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1982:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1986:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    198a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    198e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1992:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1996:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    199a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    199e:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    19a5:	00 00 00 
    19a8:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    19af:	00 00 00 
    19b2:	48 8d 45 10          	lea    0x10(%rbp),%rax
    19b6:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    19bd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    19c4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    19cb:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    19d2:	00 00 00 
    19d5:	e9 41 03 00 00       	jmpq   1d1b <printf+0x3d9>
    if (c != '%') {
    19da:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    19e1:	74 24                	je     1a07 <printf+0xc5>
      putc(fd, c);
    19e3:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    19e9:	0f be d0             	movsbl %al,%edx
    19ec:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19f2:	89 d6                	mov    %edx,%esi
    19f4:	89 c7                	mov    %eax,%edi
    19f6:	48 b8 5c 17 00 00 00 	movabs $0x175c,%rax
    19fd:	00 00 00 
    1a00:	ff d0                	callq  *%rax
      continue;
    1a02:	e9 0d 03 00 00       	jmpq   1d14 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1a07:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1a0e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1a14:	48 63 d0             	movslq %eax,%rdx
    1a17:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1a1e:	48 01 d0             	add    %rdx,%rax
    1a21:	0f b6 00             	movzbl (%rax),%eax
    1a24:	0f be c0             	movsbl %al,%eax
    1a27:	25 ff 00 00 00       	and    $0xff,%eax
    1a2c:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1a32:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1a39:	0f 84 0f 03 00 00    	je     1d4e <printf+0x40c>
      break;
    switch(c) {
    1a3f:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1a46:	0f 84 74 02 00 00    	je     1cc0 <printf+0x37e>
    1a4c:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1a53:	0f 8c 82 02 00 00    	jl     1cdb <printf+0x399>
    1a59:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1a60:	0f 8f 75 02 00 00    	jg     1cdb <printf+0x399>
    1a66:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1a6d:	0f 8c 68 02 00 00    	jl     1cdb <printf+0x399>
    1a73:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1a79:	83 e8 63             	sub    $0x63,%eax
    1a7c:	83 f8 15             	cmp    $0x15,%eax
    1a7f:	0f 87 56 02 00 00    	ja     1cdb <printf+0x399>
    1a85:	89 c0                	mov    %eax,%eax
    1a87:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1a8e:	00 
    1a8f:	48 b8 70 21 00 00 00 	movabs $0x2170,%rax
    1a96:	00 00 00 
    1a99:	48 01 d0             	add    %rdx,%rax
    1a9c:	48 8b 00             	mov    (%rax),%rax
    1a9f:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1aa2:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1aa8:	83 f8 2f             	cmp    $0x2f,%eax
    1aab:	77 23                	ja     1ad0 <printf+0x18e>
    1aad:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1ab4:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1aba:	89 d2                	mov    %edx,%edx
    1abc:	48 01 d0             	add    %rdx,%rax
    1abf:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ac5:	83 c2 08             	add    $0x8,%edx
    1ac8:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1ace:	eb 12                	jmp    1ae2 <printf+0x1a0>
    1ad0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1ad7:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1adb:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1ae2:	8b 00                	mov    (%rax),%eax
    1ae4:	0f be d0             	movsbl %al,%edx
    1ae7:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1aed:	89 d6                	mov    %edx,%esi
    1aef:	89 c7                	mov    %eax,%edi
    1af1:	48 b8 5c 17 00 00 00 	movabs $0x175c,%rax
    1af8:	00 00 00 
    1afb:	ff d0                	callq  *%rax
      break;
    1afd:	e9 12 02 00 00       	jmpq   1d14 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1b02:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1b08:	83 f8 2f             	cmp    $0x2f,%eax
    1b0b:	77 23                	ja     1b30 <printf+0x1ee>
    1b0d:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1b14:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b1a:	89 d2                	mov    %edx,%edx
    1b1c:	48 01 d0             	add    %rdx,%rax
    1b1f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b25:	83 c2 08             	add    $0x8,%edx
    1b28:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1b2e:	eb 12                	jmp    1b42 <printf+0x200>
    1b30:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b37:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b3b:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b42:	8b 10                	mov    (%rax),%edx
    1b44:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b4a:	89 d6                	mov    %edx,%esi
    1b4c:	89 c7                	mov    %eax,%edi
    1b4e:	48 b8 4a 18 00 00 00 	movabs $0x184a,%rax
    1b55:	00 00 00 
    1b58:	ff d0                	callq  *%rax
      break;
    1b5a:	e9 b5 01 00 00       	jmpq   1d14 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1b5f:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1b65:	83 f8 2f             	cmp    $0x2f,%eax
    1b68:	77 23                	ja     1b8d <printf+0x24b>
    1b6a:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1b71:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b77:	89 d2                	mov    %edx,%edx
    1b79:	48 01 d0             	add    %rdx,%rax
    1b7c:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b82:	83 c2 08             	add    $0x8,%edx
    1b85:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1b8b:	eb 12                	jmp    1b9f <printf+0x25d>
    1b8d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b94:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b98:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b9f:	8b 10                	mov    (%rax),%edx
    1ba1:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ba7:	89 d6                	mov    %edx,%esi
    1ba9:	89 c7                	mov    %eax,%edi
    1bab:	48 b8 ed 17 00 00 00 	movabs $0x17ed,%rax
    1bb2:	00 00 00 
    1bb5:	ff d0                	callq  *%rax
      break;
    1bb7:	e9 58 01 00 00       	jmpq   1d14 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1bbc:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1bc2:	83 f8 2f             	cmp    $0x2f,%eax
    1bc5:	77 23                	ja     1bea <printf+0x2a8>
    1bc7:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1bce:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1bd4:	89 d2                	mov    %edx,%edx
    1bd6:	48 01 d0             	add    %rdx,%rax
    1bd9:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1bdf:	83 c2 08             	add    $0x8,%edx
    1be2:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1be8:	eb 12                	jmp    1bfc <printf+0x2ba>
    1bea:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1bf1:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1bf5:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1bfc:	48 8b 10             	mov    (%rax),%rdx
    1bff:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c05:	48 89 d6             	mov    %rdx,%rsi
    1c08:	89 c7                	mov    %eax,%edi
    1c0a:	48 b8 90 17 00 00 00 	movabs $0x1790,%rax
    1c11:	00 00 00 
    1c14:	ff d0                	callq  *%rax
      break;
    1c16:	e9 f9 00 00 00       	jmpq   1d14 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1c1b:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1c21:	83 f8 2f             	cmp    $0x2f,%eax
    1c24:	77 23                	ja     1c49 <printf+0x307>
    1c26:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1c2d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c33:	89 d2                	mov    %edx,%edx
    1c35:	48 01 d0             	add    %rdx,%rax
    1c38:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c3e:	83 c2 08             	add    $0x8,%edx
    1c41:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1c47:	eb 12                	jmp    1c5b <printf+0x319>
    1c49:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1c50:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1c54:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1c5b:	48 8b 00             	mov    (%rax),%rax
    1c5e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1c65:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1c6c:	00 
    1c6d:	75 41                	jne    1cb0 <printf+0x36e>
        s = "(null)";
    1c6f:	48 b8 68 21 00 00 00 	movabs $0x2168,%rax
    1c76:	00 00 00 
    1c79:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1c80:	eb 2e                	jmp    1cb0 <printf+0x36e>
        putc(fd, *(s++));
    1c82:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1c89:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1c8d:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1c94:	0f b6 00             	movzbl (%rax),%eax
    1c97:	0f be d0             	movsbl %al,%edx
    1c9a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ca0:	89 d6                	mov    %edx,%esi
    1ca2:	89 c7                	mov    %eax,%edi
    1ca4:	48 b8 5c 17 00 00 00 	movabs $0x175c,%rax
    1cab:	00 00 00 
    1cae:	ff d0                	callq  *%rax
      while (*s)
    1cb0:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1cb7:	0f b6 00             	movzbl (%rax),%eax
    1cba:	84 c0                	test   %al,%al
    1cbc:	75 c4                	jne    1c82 <printf+0x340>
      break;
    1cbe:	eb 54                	jmp    1d14 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1cc0:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1cc6:	be 25 00 00 00       	mov    $0x25,%esi
    1ccb:	89 c7                	mov    %eax,%edi
    1ccd:	48 b8 5c 17 00 00 00 	movabs $0x175c,%rax
    1cd4:	00 00 00 
    1cd7:	ff d0                	callq  *%rax
      break;
    1cd9:	eb 39                	jmp    1d14 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1cdb:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ce1:	be 25 00 00 00       	mov    $0x25,%esi
    1ce6:	89 c7                	mov    %eax,%edi
    1ce8:	48 b8 5c 17 00 00 00 	movabs $0x175c,%rax
    1cef:	00 00 00 
    1cf2:	ff d0                	callq  *%rax
      putc(fd, c);
    1cf4:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1cfa:	0f be d0             	movsbl %al,%edx
    1cfd:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1d03:	89 d6                	mov    %edx,%esi
    1d05:	89 c7                	mov    %eax,%edi
    1d07:	48 b8 5c 17 00 00 00 	movabs $0x175c,%rax
    1d0e:	00 00 00 
    1d11:	ff d0                	callq  *%rax
      break;
    1d13:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1d14:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1d1b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1d21:	48 63 d0             	movslq %eax,%rdx
    1d24:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1d2b:	48 01 d0             	add    %rdx,%rax
    1d2e:	0f b6 00             	movzbl (%rax),%eax
    1d31:	0f be c0             	movsbl %al,%eax
    1d34:	25 ff 00 00 00       	and    $0xff,%eax
    1d39:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1d3f:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1d46:	0f 85 8e fc ff ff    	jne    19da <printf+0x98>
    }
  }
}
    1d4c:	eb 01                	jmp    1d4f <printf+0x40d>
      break;
    1d4e:	90                   	nop
}
    1d4f:	90                   	nop
    1d50:	c9                   	leaveq 
    1d51:	c3                   	retq   

0000000000001d52 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1d52:	f3 0f 1e fa          	endbr64 
    1d56:	55                   	push   %rbp
    1d57:	48 89 e5             	mov    %rsp,%rbp
    1d5a:	48 83 ec 18          	sub    $0x18,%rsp
    1d5e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1d62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1d66:	48 83 e8 10          	sub    $0x10,%rax
    1d6a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1d6e:	48 b8 d0 24 00 00 00 	movabs $0x24d0,%rax
    1d75:	00 00 00 
    1d78:	48 8b 00             	mov    (%rax),%rax
    1d7b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1d7f:	eb 2f                	jmp    1db0 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1d81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d85:	48 8b 00             	mov    (%rax),%rax
    1d88:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1d8c:	72 17                	jb     1da5 <free+0x53>
    1d8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d92:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1d96:	77 2f                	ja     1dc7 <free+0x75>
    1d98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d9c:	48 8b 00             	mov    (%rax),%rax
    1d9f:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1da3:	72 22                	jb     1dc7 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1da5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1da9:	48 8b 00             	mov    (%rax),%rax
    1dac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1db0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1db4:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1db8:	76 c7                	jbe    1d81 <free+0x2f>
    1dba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dbe:	48 8b 00             	mov    (%rax),%rax
    1dc1:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1dc5:	73 ba                	jae    1d81 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1dc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dcb:	8b 40 08             	mov    0x8(%rax),%eax
    1dce:	89 c0                	mov    %eax,%eax
    1dd0:	48 c1 e0 04          	shl    $0x4,%rax
    1dd4:	48 89 c2             	mov    %rax,%rdx
    1dd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ddb:	48 01 c2             	add    %rax,%rdx
    1dde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1de2:	48 8b 00             	mov    (%rax),%rax
    1de5:	48 39 c2             	cmp    %rax,%rdx
    1de8:	75 2d                	jne    1e17 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1dea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dee:	8b 50 08             	mov    0x8(%rax),%edx
    1df1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1df5:	48 8b 00             	mov    (%rax),%rax
    1df8:	8b 40 08             	mov    0x8(%rax),%eax
    1dfb:	01 c2                	add    %eax,%edx
    1dfd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e01:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1e04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e08:	48 8b 00             	mov    (%rax),%rax
    1e0b:	48 8b 10             	mov    (%rax),%rdx
    1e0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e12:	48 89 10             	mov    %rdx,(%rax)
    1e15:	eb 0e                	jmp    1e25 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1e17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e1b:	48 8b 10             	mov    (%rax),%rdx
    1e1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e22:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1e25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e29:	8b 40 08             	mov    0x8(%rax),%eax
    1e2c:	89 c0                	mov    %eax,%eax
    1e2e:	48 c1 e0 04          	shl    $0x4,%rax
    1e32:	48 89 c2             	mov    %rax,%rdx
    1e35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e39:	48 01 d0             	add    %rdx,%rax
    1e3c:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1e40:	75 27                	jne    1e69 <free+0x117>
    p->s.size += bp->s.size;
    1e42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e46:	8b 50 08             	mov    0x8(%rax),%edx
    1e49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e4d:	8b 40 08             	mov    0x8(%rax),%eax
    1e50:	01 c2                	add    %eax,%edx
    1e52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e56:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1e59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e5d:	48 8b 10             	mov    (%rax),%rdx
    1e60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e64:	48 89 10             	mov    %rdx,(%rax)
    1e67:	eb 0b                	jmp    1e74 <free+0x122>
  } else
    p->s.ptr = bp;
    1e69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e6d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1e71:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1e74:	48 ba d0 24 00 00 00 	movabs $0x24d0,%rdx
    1e7b:	00 00 00 
    1e7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e82:	48 89 02             	mov    %rax,(%rdx)
}
    1e85:	90                   	nop
    1e86:	c9                   	leaveq 
    1e87:	c3                   	retq   

0000000000001e88 <morecore>:

static Header*
morecore(uint nu)
{
    1e88:	f3 0f 1e fa          	endbr64 
    1e8c:	55                   	push   %rbp
    1e8d:	48 89 e5             	mov    %rsp,%rbp
    1e90:	48 83 ec 20          	sub    $0x20,%rsp
    1e94:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1e97:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1e9e:	77 07                	ja     1ea7 <morecore+0x1f>
    nu = 4096;
    1ea0:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1ea7:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1eaa:	48 c1 e0 04          	shl    $0x4,%rax
    1eae:	48 89 c7             	mov    %rax,%rdi
    1eb1:	48 b8 1b 17 00 00 00 	movabs $0x171b,%rax
    1eb8:	00 00 00 
    1ebb:	ff d0                	callq  *%rax
    1ebd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1ec1:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1ec6:	75 07                	jne    1ecf <morecore+0x47>
    return 0;
    1ec8:	b8 00 00 00 00       	mov    $0x0,%eax
    1ecd:	eb 36                	jmp    1f05 <morecore+0x7d>
  hp = (Header*)p;
    1ecf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ed3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1ed7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1edb:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1ede:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1ee1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ee5:	48 83 c0 10          	add    $0x10,%rax
    1ee9:	48 89 c7             	mov    %rax,%rdi
    1eec:	48 b8 52 1d 00 00 00 	movabs $0x1d52,%rax
    1ef3:	00 00 00 
    1ef6:	ff d0                	callq  *%rax
  return freep;
    1ef8:	48 b8 d0 24 00 00 00 	movabs $0x24d0,%rax
    1eff:	00 00 00 
    1f02:	48 8b 00             	mov    (%rax),%rax
}
    1f05:	c9                   	leaveq 
    1f06:	c3                   	retq   

0000000000001f07 <malloc>:

void*
malloc(uint nbytes)
{
    1f07:	f3 0f 1e fa          	endbr64 
    1f0b:	55                   	push   %rbp
    1f0c:	48 89 e5             	mov    %rsp,%rbp
    1f0f:	48 83 ec 30          	sub    $0x30,%rsp
    1f13:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1f16:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1f19:	48 83 c0 0f          	add    $0xf,%rax
    1f1d:	48 c1 e8 04          	shr    $0x4,%rax
    1f21:	83 c0 01             	add    $0x1,%eax
    1f24:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1f27:	48 b8 d0 24 00 00 00 	movabs $0x24d0,%rax
    1f2e:	00 00 00 
    1f31:	48 8b 00             	mov    (%rax),%rax
    1f34:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1f38:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1f3d:	75 4a                	jne    1f89 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1f3f:	48 b8 c0 24 00 00 00 	movabs $0x24c0,%rax
    1f46:	00 00 00 
    1f49:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1f4d:	48 ba d0 24 00 00 00 	movabs $0x24d0,%rdx
    1f54:	00 00 00 
    1f57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f5b:	48 89 02             	mov    %rax,(%rdx)
    1f5e:	48 b8 d0 24 00 00 00 	movabs $0x24d0,%rax
    1f65:	00 00 00 
    1f68:	48 8b 00             	mov    (%rax),%rax
    1f6b:	48 ba c0 24 00 00 00 	movabs $0x24c0,%rdx
    1f72:	00 00 00 
    1f75:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1f78:	48 b8 c0 24 00 00 00 	movabs $0x24c0,%rax
    1f7f:	00 00 00 
    1f82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1f89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f8d:	48 8b 00             	mov    (%rax),%rax
    1f90:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1f94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f98:	8b 40 08             	mov    0x8(%rax),%eax
    1f9b:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1f9e:	77 65                	ja     2005 <malloc+0xfe>
      if(p->s.size == nunits)
    1fa0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fa4:	8b 40 08             	mov    0x8(%rax),%eax
    1fa7:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1faa:	75 10                	jne    1fbc <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1fac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fb0:	48 8b 10             	mov    (%rax),%rdx
    1fb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fb7:	48 89 10             	mov    %rdx,(%rax)
    1fba:	eb 2e                	jmp    1fea <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1fbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fc0:	8b 40 08             	mov    0x8(%rax),%eax
    1fc3:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1fc6:	89 c2                	mov    %eax,%edx
    1fc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fcc:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1fcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fd3:	8b 40 08             	mov    0x8(%rax),%eax
    1fd6:	89 c0                	mov    %eax,%eax
    1fd8:	48 c1 e0 04          	shl    $0x4,%rax
    1fdc:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1fe0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fe4:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1fe7:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1fea:	48 ba d0 24 00 00 00 	movabs $0x24d0,%rdx
    1ff1:	00 00 00 
    1ff4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ff8:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1ffb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fff:	48 83 c0 10          	add    $0x10,%rax
    2003:	eb 4e                	jmp    2053 <malloc+0x14c>
    }
    if(p == freep)
    2005:	48 b8 d0 24 00 00 00 	movabs $0x24d0,%rax
    200c:	00 00 00 
    200f:	48 8b 00             	mov    (%rax),%rax
    2012:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    2016:	75 23                	jne    203b <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    2018:	8b 45 ec             	mov    -0x14(%rbp),%eax
    201b:	89 c7                	mov    %eax,%edi
    201d:	48 b8 88 1e 00 00 00 	movabs $0x1e88,%rax
    2024:	00 00 00 
    2027:	ff d0                	callq  *%rax
    2029:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    202d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2032:	75 07                	jne    203b <malloc+0x134>
        return 0;
    2034:	b8 00 00 00 00       	mov    $0x0,%eax
    2039:	eb 18                	jmp    2053 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    203b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    203f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    2043:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2047:	48 8b 00             	mov    (%rax),%rax
    204a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    204e:	e9 41 ff ff ff       	jmpq   1f94 <malloc+0x8d>
  }
}
    2053:	c9                   	leaveq 
    2054:	c3                   	retq   
