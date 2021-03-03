
_ls:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	53                   	push   %rbx
    1009:	48 83 ec 28          	sub    $0x28,%rsp
    100d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    1011:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1015:	48 89 c7             	mov    %rax,%rdi
    1018:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    101f:	00 00 00 
    1022:	ff d0                	callq  *%rax
    1024:	89 c2                	mov    %eax,%edx
    1026:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    102a:	48 01 d0             	add    %rdx,%rax
    102d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    1031:	eb 05                	jmp    1038 <fmtname+0x38>
    1033:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
    1038:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    103c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
    1040:	72 0b                	jb     104d <fmtname+0x4d>
    1042:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1046:	0f b6 00             	movzbl (%rax),%eax
    1049:	3c 2f                	cmp    $0x2f,%al
    104b:	75 e6                	jne    1033 <fmtname+0x33>
    ;
  p++;
    104d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    1052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1056:	48 89 c7             	mov    %rax,%rdi
    1059:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    1060:	00 00 00 
    1063:	ff d0                	callq  *%rax
    1065:	83 f8 0d             	cmp    $0xd,%eax
    1068:	76 09                	jbe    1073 <fmtname+0x73>
    return p;
    106a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    106e:	e9 90 00 00 00       	jmpq   1103 <fmtname+0x103>
  memmove(buf, p, strlen(p));
    1073:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1077:	48 89 c7             	mov    %rax,%rdi
    107a:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    1081:	00 00 00 
    1084:	ff d0                	callq  *%rax
    1086:	89 c2                	mov    %eax,%edx
    1088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    108c:	48 89 c6             	mov    %rax,%rsi
    108f:	48 bf f0 25 00 00 00 	movabs $0x25f0,%rdi
    1096:	00 00 00 
    1099:	48 b8 7f 17 00 00 00 	movabs $0x177f,%rax
    10a0:	00 00 00 
    10a3:	ff d0                	callq  *%rax
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
    10a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10a9:	48 89 c7             	mov    %rax,%rdi
    10ac:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    10b3:	00 00 00 
    10b6:	ff d0                	callq  *%rax
    10b8:	ba 0e 00 00 00       	mov    $0xe,%edx
    10bd:	89 d3                	mov    %edx,%ebx
    10bf:	29 c3                	sub    %eax,%ebx
    10c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10c5:	48 89 c7             	mov    %rax,%rdi
    10c8:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    10cf:	00 00 00 
    10d2:	ff d0                	callq  *%rax
    10d4:	89 c2                	mov    %eax,%edx
    10d6:	48 b8 f0 25 00 00 00 	movabs $0x25f0,%rax
    10dd:	00 00 00 
    10e0:	48 01 d0             	add    %rdx,%rax
    10e3:	89 da                	mov    %ebx,%edx
    10e5:	be 20 00 00 00       	mov    $0x20,%esi
    10ea:	48 89 c7             	mov    %rax,%rdi
    10ed:	48 b8 b0 15 00 00 00 	movabs $0x15b0,%rax
    10f4:	00 00 00 
    10f7:	ff d0                	callq  *%rax
  return buf;
    10f9:	48 b8 f0 25 00 00 00 	movabs $0x25f0,%rax
    1100:	00 00 00 
}
    1103:	48 83 c4 28          	add    $0x28,%rsp
    1107:	5b                   	pop    %rbx
    1108:	5d                   	pop    %rbp
    1109:	c3                   	retq   

000000000000110a <ls>:

void
ls(char *path)
{
    110a:	f3 0f 1e fa          	endbr64 
    110e:	55                   	push   %rbp
    110f:	48 89 e5             	mov    %rsp,%rbp
    1112:	41 55                	push   %r13
    1114:	41 54                	push   %r12
    1116:	53                   	push   %rbx
    1117:	48 81 ec 58 02 00 00 	sub    $0x258,%rsp
    111e:	48 89 bd 98 fd ff ff 	mov    %rdi,-0x268(%rbp)
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    1125:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    112c:	be 00 00 00 00       	mov    $0x0,%esi
    1131:	48 89 c7             	mov    %rax,%rdi
    1134:	48 b8 4d 18 00 00 00 	movabs $0x184d,%rax
    113b:	00 00 00 
    113e:	ff d0                	callq  *%rax
    1140:	89 45 dc             	mov    %eax,-0x24(%rbp)
    1143:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
    1147:	79 2f                	jns    1178 <ls+0x6e>
    printf(2, "ls: cannot open %s\n", path);
    1149:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    1150:	48 89 c2             	mov    %rax,%rdx
    1153:	48 be 00 22 00 00 00 	movabs $0x2200,%rsi
    115a:	00 00 00 
    115d:	bf 02 00 00 00       	mov    $0x2,%edi
    1162:	b8 00 00 00 00       	mov    $0x0,%eax
    1167:	48 b9 e9 1a 00 00 00 	movabs $0x1ae9,%rcx
    116e:	00 00 00 
    1171:	ff d1                	callq  *%rcx
    return;
    1173:	e9 9a 02 00 00       	jmpq   1412 <ls+0x308>
  }

  if(fstat(fd, &st) < 0){
    1178:	48 8d 95 a0 fd ff ff 	lea    -0x260(%rbp),%rdx
    117f:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1182:	48 89 d6             	mov    %rdx,%rsi
    1185:	89 c7                	mov    %eax,%edi
    1187:	48 b8 74 18 00 00 00 	movabs $0x1874,%rax
    118e:	00 00 00 
    1191:	ff d0                	callq  *%rax
    1193:	85 c0                	test   %eax,%eax
    1195:	79 40                	jns    11d7 <ls+0xcd>
    printf(2, "ls: cannot stat %s\n", path);
    1197:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    119e:	48 89 c2             	mov    %rax,%rdx
    11a1:	48 be 14 22 00 00 00 	movabs $0x2214,%rsi
    11a8:	00 00 00 
    11ab:	bf 02 00 00 00       	mov    $0x2,%edi
    11b0:	b8 00 00 00 00       	mov    $0x0,%eax
    11b5:	48 b9 e9 1a 00 00 00 	movabs $0x1ae9,%rcx
    11bc:	00 00 00 
    11bf:	ff d1                	callq  *%rcx
    close(fd);
    11c1:	8b 45 dc             	mov    -0x24(%rbp),%eax
    11c4:	89 c7                	mov    %eax,%edi
    11c6:	48 b8 26 18 00 00 00 	movabs $0x1826,%rax
    11cd:	00 00 00 
    11d0:	ff d0                	callq  *%rax
    return;
    11d2:	e9 3b 02 00 00       	jmpq   1412 <ls+0x308>
  }

  switch(st.type){
    11d7:	0f b7 85 a0 fd ff ff 	movzwl -0x260(%rbp),%eax
    11de:	98                   	cwtl   
    11df:	83 f8 01             	cmp    $0x1,%eax
    11e2:	74 68                	je     124c <ls+0x142>
    11e4:	83 f8 02             	cmp    $0x2,%eax
    11e7:	0f 85 14 02 00 00    	jne    1401 <ls+0x2f7>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    11ed:	44 8b ad b0 fd ff ff 	mov    -0x250(%rbp),%r13d
    11f4:	44 8b a5 a8 fd ff ff 	mov    -0x258(%rbp),%r12d
    11fb:	0f b7 85 a0 fd ff ff 	movzwl -0x260(%rbp),%eax
    1202:	0f bf d8             	movswl %ax,%ebx
    1205:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    120c:	48 89 c7             	mov    %rax,%rdi
    120f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1216:	00 00 00 
    1219:	ff d0                	callq  *%rax
    121b:	45 89 e9             	mov    %r13d,%r9d
    121e:	45 89 e0             	mov    %r12d,%r8d
    1221:	89 d9                	mov    %ebx,%ecx
    1223:	48 89 c2             	mov    %rax,%rdx
    1226:	48 be 28 22 00 00 00 	movabs $0x2228,%rsi
    122d:	00 00 00 
    1230:	bf 01 00 00 00       	mov    $0x1,%edi
    1235:	b8 00 00 00 00       	mov    $0x0,%eax
    123a:	49 ba e9 1a 00 00 00 	movabs $0x1ae9,%r10
    1241:	00 00 00 
    1244:	41 ff d2             	callq  *%r10
    break;
    1247:	e9 b5 01 00 00       	jmpq   1401 <ls+0x2f7>

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
    124c:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    1253:	48 89 c7             	mov    %rax,%rdi
    1256:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    125d:	00 00 00 
    1260:	ff d0                	callq  *%rax
    1262:	83 c0 10             	add    $0x10,%eax
    1265:	3d 00 02 00 00       	cmp    $0x200,%eax
    126a:	76 25                	jbe    1291 <ls+0x187>
      printf(1, "ls: path too long\n");
    126c:	48 be 35 22 00 00 00 	movabs $0x2235,%rsi
    1273:	00 00 00 
    1276:	bf 01 00 00 00       	mov    $0x1,%edi
    127b:	b8 00 00 00 00       	mov    $0x0,%eax
    1280:	48 ba e9 1a 00 00 00 	movabs $0x1ae9,%rdx
    1287:	00 00 00 
    128a:	ff d2                	callq  *%rdx
      break;
    128c:	e9 70 01 00 00       	jmpq   1401 <ls+0x2f7>
    }
    strcpy(buf, path);
    1291:	48 8b 95 98 fd ff ff 	mov    -0x268(%rbp),%rdx
    1298:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    129f:	48 89 d6             	mov    %rdx,%rsi
    12a2:	48 89 c7             	mov    %rax,%rdi
    12a5:	48 b8 dc 14 00 00 00 	movabs $0x14dc,%rax
    12ac:	00 00 00 
    12af:	ff d0                	callq  *%rax
    p = buf+strlen(buf);
    12b1:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    12b8:	48 89 c7             	mov    %rax,%rdi
    12bb:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    12c2:	00 00 00 
    12c5:	ff d0                	callq  *%rax
    12c7:	89 c2                	mov    %eax,%edx
    12c9:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    12d0:	48 01 d0             	add    %rdx,%rax
    12d3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    *p++ = '/';
    12d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    12db:	48 8d 50 01          	lea    0x1(%rax),%rdx
    12df:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
    12e3:	c6 00 2f             	movb   $0x2f,(%rax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    12e6:	e9 ec 00 00 00       	jmpq   13d7 <ls+0x2cd>
      if(de.inum == 0)
    12eb:	0f b7 85 c0 fd ff ff 	movzwl -0x240(%rbp),%eax
    12f2:	66 85 c0             	test   %ax,%ax
    12f5:	75 05                	jne    12fc <ls+0x1f2>
        continue;
    12f7:	e9 db 00 00 00       	jmpq   13d7 <ls+0x2cd>
      memmove(p, de.name, DIRSIZ);
    12fc:	48 8d 85 c0 fd ff ff 	lea    -0x240(%rbp),%rax
    1303:	48 8d 48 02          	lea    0x2(%rax),%rcx
    1307:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    130b:	ba 0e 00 00 00       	mov    $0xe,%edx
    1310:	48 89 ce             	mov    %rcx,%rsi
    1313:	48 89 c7             	mov    %rax,%rdi
    1316:	48 b8 7f 17 00 00 00 	movabs $0x177f,%rax
    131d:	00 00 00 
    1320:	ff d0                	callq  *%rax
      p[DIRSIZ] = 0;
    1322:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1326:	48 83 c0 0e          	add    $0xe,%rax
    132a:	c6 00 00             	movb   $0x0,(%rax)
      if(stat(buf, &st) < 0){
    132d:	48 8d 95 a0 fd ff ff 	lea    -0x260(%rbp),%rdx
    1334:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    133b:	48 89 d6             	mov    %rdx,%rsi
    133e:	48 89 c7             	mov    %rax,%rdi
    1341:	48 b8 b6 16 00 00 00 	movabs $0x16b6,%rax
    1348:	00 00 00 
    134b:	ff d0                	callq  *%rax
    134d:	85 c0                	test   %eax,%eax
    134f:	79 2c                	jns    137d <ls+0x273>
        printf(1, "ls: cannot stat %s\n", buf);
    1351:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    1358:	48 89 c2             	mov    %rax,%rdx
    135b:	48 be 14 22 00 00 00 	movabs $0x2214,%rsi
    1362:	00 00 00 
    1365:	bf 01 00 00 00       	mov    $0x1,%edi
    136a:	b8 00 00 00 00       	mov    $0x0,%eax
    136f:	48 b9 e9 1a 00 00 00 	movabs $0x1ae9,%rcx
    1376:	00 00 00 
    1379:	ff d1                	callq  *%rcx
        continue;
    137b:	eb 5a                	jmp    13d7 <ls+0x2cd>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    137d:	44 8b ad b0 fd ff ff 	mov    -0x250(%rbp),%r13d
    1384:	44 8b a5 a8 fd ff ff 	mov    -0x258(%rbp),%r12d
    138b:	0f b7 85 a0 fd ff ff 	movzwl -0x260(%rbp),%eax
    1392:	0f bf d8             	movswl %ax,%ebx
    1395:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    139c:	48 89 c7             	mov    %rax,%rdi
    139f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    13a6:	00 00 00 
    13a9:	ff d0                	callq  *%rax
    13ab:	45 89 e9             	mov    %r13d,%r9d
    13ae:	45 89 e0             	mov    %r12d,%r8d
    13b1:	89 d9                	mov    %ebx,%ecx
    13b3:	48 89 c2             	mov    %rax,%rdx
    13b6:	48 be 28 22 00 00 00 	movabs $0x2228,%rsi
    13bd:	00 00 00 
    13c0:	bf 01 00 00 00       	mov    $0x1,%edi
    13c5:	b8 00 00 00 00       	mov    $0x0,%eax
    13ca:	49 ba e9 1a 00 00 00 	movabs $0x1ae9,%r10
    13d1:	00 00 00 
    13d4:	41 ff d2             	callq  *%r10
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    13d7:	48 8d 8d c0 fd ff ff 	lea    -0x240(%rbp),%rcx
    13de:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13e1:	ba 10 00 00 00       	mov    $0x10,%edx
    13e6:	48 89 ce             	mov    %rcx,%rsi
    13e9:	89 c7                	mov    %eax,%edi
    13eb:	48 b8 0c 18 00 00 00 	movabs $0x180c,%rax
    13f2:	00 00 00 
    13f5:	ff d0                	callq  *%rax
    13f7:	83 f8 10             	cmp    $0x10,%eax
    13fa:	0f 84 eb fe ff ff    	je     12eb <ls+0x1e1>
    }
    break;
    1400:	90                   	nop
  }
  close(fd);
    1401:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1404:	89 c7                	mov    %eax,%edi
    1406:	48 b8 26 18 00 00 00 	movabs $0x1826,%rax
    140d:	00 00 00 
    1410:	ff d0                	callq  *%rax
}
    1412:	48 81 c4 58 02 00 00 	add    $0x258,%rsp
    1419:	5b                   	pop    %rbx
    141a:	41 5c                	pop    %r12
    141c:	41 5d                	pop    %r13
    141e:	5d                   	pop    %rbp
    141f:	c3                   	retq   

0000000000001420 <main>:

int
main(int argc, char *argv[])
{
    1420:	f3 0f 1e fa          	endbr64 
    1424:	55                   	push   %rbp
    1425:	48 89 e5             	mov    %rsp,%rbp
    1428:	48 83 ec 20          	sub    $0x20,%rsp
    142c:	89 7d ec             	mov    %edi,-0x14(%rbp)
    142f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;

  if(argc < 2){
    1433:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
    1437:	7f 22                	jg     145b <main+0x3b>
    ls(".");
    1439:	48 bf 48 22 00 00 00 	movabs $0x2248,%rdi
    1440:	00 00 00 
    1443:	48 b8 0a 11 00 00 00 	movabs $0x110a,%rax
    144a:	00 00 00 
    144d:	ff d0                	callq  *%rax
    exit();
    144f:	48 b8 e5 17 00 00 00 	movabs $0x17e5,%rax
    1456:	00 00 00 
    1459:	ff d0                	callq  *%rax
  }
  for(i=1; i<argc; i++)
    145b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    1462:	eb 2a                	jmp    148e <main+0x6e>
    ls(argv[i]);
    1464:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1467:	48 98                	cltq   
    1469:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1470:	00 
    1471:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1475:	48 01 d0             	add    %rdx,%rax
    1478:	48 8b 00             	mov    (%rax),%rax
    147b:	48 89 c7             	mov    %rax,%rdi
    147e:	48 b8 0a 11 00 00 00 	movabs $0x110a,%rax
    1485:	00 00 00 
    1488:	ff d0                	callq  *%rax
  for(i=1; i<argc; i++)
    148a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    148e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1491:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1494:	7c ce                	jl     1464 <main+0x44>
  exit();
    1496:	48 b8 e5 17 00 00 00 	movabs $0x17e5,%rax
    149d:	00 00 00 
    14a0:	ff d0                	callq  *%rax

00000000000014a2 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    14a2:	f3 0f 1e fa          	endbr64 
    14a6:	55                   	push   %rbp
    14a7:	48 89 e5             	mov    %rsp,%rbp
    14aa:	48 83 ec 10          	sub    $0x10,%rsp
    14ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    14b2:	89 75 f4             	mov    %esi,-0xc(%rbp)
    14b5:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    14b8:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    14bc:	8b 55 f0             	mov    -0x10(%rbp),%edx
    14bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
    14c2:	48 89 ce             	mov    %rcx,%rsi
    14c5:	48 89 f7             	mov    %rsi,%rdi
    14c8:	89 d1                	mov    %edx,%ecx
    14ca:	fc                   	cld    
    14cb:	f3 aa                	rep stos %al,%es:(%rdi)
    14cd:	89 ca                	mov    %ecx,%edx
    14cf:	48 89 fe             	mov    %rdi,%rsi
    14d2:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    14d6:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    14d9:	90                   	nop
    14da:	c9                   	leaveq 
    14db:	c3                   	retq   

00000000000014dc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    14dc:	f3 0f 1e fa          	endbr64 
    14e0:	55                   	push   %rbp
    14e1:	48 89 e5             	mov    %rsp,%rbp
    14e4:	48 83 ec 20          	sub    $0x20,%rsp
    14e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    14ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    14f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    14f8:	90                   	nop
    14f9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    14fd:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1501:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    1505:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1509:	48 8d 48 01          	lea    0x1(%rax),%rcx
    150d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1511:	0f b6 12             	movzbl (%rdx),%edx
    1514:	88 10                	mov    %dl,(%rax)
    1516:	0f b6 00             	movzbl (%rax),%eax
    1519:	84 c0                	test   %al,%al
    151b:	75 dc                	jne    14f9 <strcpy+0x1d>
    ;
  return os;
    151d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1521:	c9                   	leaveq 
    1522:	c3                   	retq   

0000000000001523 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1523:	f3 0f 1e fa          	endbr64 
    1527:	55                   	push   %rbp
    1528:	48 89 e5             	mov    %rsp,%rbp
    152b:	48 83 ec 10          	sub    $0x10,%rsp
    152f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1533:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1537:	eb 0a                	jmp    1543 <strcmp+0x20>
    p++, q++;
    1539:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    153e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1543:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1547:	0f b6 00             	movzbl (%rax),%eax
    154a:	84 c0                	test   %al,%al
    154c:	74 12                	je     1560 <strcmp+0x3d>
    154e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1552:	0f b6 10             	movzbl (%rax),%edx
    1555:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1559:	0f b6 00             	movzbl (%rax),%eax
    155c:	38 c2                	cmp    %al,%dl
    155e:	74 d9                	je     1539 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1560:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1564:	0f b6 00             	movzbl (%rax),%eax
    1567:	0f b6 d0             	movzbl %al,%edx
    156a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    156e:	0f b6 00             	movzbl (%rax),%eax
    1571:	0f b6 c0             	movzbl %al,%eax
    1574:	29 c2                	sub    %eax,%edx
    1576:	89 d0                	mov    %edx,%eax
}
    1578:	c9                   	leaveq 
    1579:	c3                   	retq   

000000000000157a <strlen>:

uint
strlen(char *s)
{
    157a:	f3 0f 1e fa          	endbr64 
    157e:	55                   	push   %rbp
    157f:	48 89 e5             	mov    %rsp,%rbp
    1582:	48 83 ec 18          	sub    $0x18,%rsp
    1586:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    158a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1591:	eb 04                	jmp    1597 <strlen+0x1d>
    1593:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1597:	8b 45 fc             	mov    -0x4(%rbp),%eax
    159a:	48 63 d0             	movslq %eax,%rdx
    159d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    15a1:	48 01 d0             	add    %rdx,%rax
    15a4:	0f b6 00             	movzbl (%rax),%eax
    15a7:	84 c0                	test   %al,%al
    15a9:	75 e8                	jne    1593 <strlen+0x19>
    ;
  return n;
    15ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    15ae:	c9                   	leaveq 
    15af:	c3                   	retq   

00000000000015b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    15b0:	f3 0f 1e fa          	endbr64 
    15b4:	55                   	push   %rbp
    15b5:	48 89 e5             	mov    %rsp,%rbp
    15b8:	48 83 ec 10          	sub    $0x10,%rsp
    15bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    15c0:	89 75 f4             	mov    %esi,-0xc(%rbp)
    15c3:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    15c6:	8b 55 f0             	mov    -0x10(%rbp),%edx
    15c9:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    15cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15d0:	89 ce                	mov    %ecx,%esi
    15d2:	48 89 c7             	mov    %rax,%rdi
    15d5:	48 b8 a2 14 00 00 00 	movabs $0x14a2,%rax
    15dc:	00 00 00 
    15df:	ff d0                	callq  *%rax
  return dst;
    15e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    15e5:	c9                   	leaveq 
    15e6:	c3                   	retq   

00000000000015e7 <strchr>:

char*
strchr(const char *s, char c)
{
    15e7:	f3 0f 1e fa          	endbr64 
    15eb:	55                   	push   %rbp
    15ec:	48 89 e5             	mov    %rsp,%rbp
    15ef:	48 83 ec 10          	sub    $0x10,%rsp
    15f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    15f7:	89 f0                	mov    %esi,%eax
    15f9:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    15fc:	eb 17                	jmp    1615 <strchr+0x2e>
    if(*s == c)
    15fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1602:	0f b6 00             	movzbl (%rax),%eax
    1605:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1608:	75 06                	jne    1610 <strchr+0x29>
      return (char*)s;
    160a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    160e:	eb 15                	jmp    1625 <strchr+0x3e>
  for(; *s; s++)
    1610:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1615:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1619:	0f b6 00             	movzbl (%rax),%eax
    161c:	84 c0                	test   %al,%al
    161e:	75 de                	jne    15fe <strchr+0x17>
  return 0;
    1620:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1625:	c9                   	leaveq 
    1626:	c3                   	retq   

0000000000001627 <gets>:

char*
gets(char *buf, int max)
{
    1627:	f3 0f 1e fa          	endbr64 
    162b:	55                   	push   %rbp
    162c:	48 89 e5             	mov    %rsp,%rbp
    162f:	48 83 ec 20          	sub    $0x20,%rsp
    1633:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1637:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    163a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1641:	eb 4f                	jmp    1692 <gets+0x6b>
    cc = read(0, &c, 1);
    1643:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1647:	ba 01 00 00 00       	mov    $0x1,%edx
    164c:	48 89 c6             	mov    %rax,%rsi
    164f:	bf 00 00 00 00       	mov    $0x0,%edi
    1654:	48 b8 0c 18 00 00 00 	movabs $0x180c,%rax
    165b:	00 00 00 
    165e:	ff d0                	callq  *%rax
    1660:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1663:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1667:	7e 36                	jle    169f <gets+0x78>
      break;
    buf[i++] = c;
    1669:	8b 45 fc             	mov    -0x4(%rbp),%eax
    166c:	8d 50 01             	lea    0x1(%rax),%edx
    166f:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1672:	48 63 d0             	movslq %eax,%rdx
    1675:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1679:	48 01 c2             	add    %rax,%rdx
    167c:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1680:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1682:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1686:	3c 0a                	cmp    $0xa,%al
    1688:	74 16                	je     16a0 <gets+0x79>
    168a:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    168e:	3c 0d                	cmp    $0xd,%al
    1690:	74 0e                	je     16a0 <gets+0x79>
  for(i=0; i+1 < max; ){
    1692:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1695:	83 c0 01             	add    $0x1,%eax
    1698:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    169b:	7f a6                	jg     1643 <gets+0x1c>
    169d:	eb 01                	jmp    16a0 <gets+0x79>
      break;
    169f:	90                   	nop
      break;
  }
  buf[i] = '\0';
    16a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16a3:	48 63 d0             	movslq %eax,%rdx
    16a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    16aa:	48 01 d0             	add    %rdx,%rax
    16ad:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    16b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    16b4:	c9                   	leaveq 
    16b5:	c3                   	retq   

00000000000016b6 <stat>:

int
stat(char *n, struct stat *st)
{
    16b6:	f3 0f 1e fa          	endbr64 
    16ba:	55                   	push   %rbp
    16bb:	48 89 e5             	mov    %rsp,%rbp
    16be:	48 83 ec 20          	sub    $0x20,%rsp
    16c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    16c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    16ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    16ce:	be 00 00 00 00       	mov    $0x0,%esi
    16d3:	48 89 c7             	mov    %rax,%rdi
    16d6:	48 b8 4d 18 00 00 00 	movabs $0x184d,%rax
    16dd:	00 00 00 
    16e0:	ff d0                	callq  *%rax
    16e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    16e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    16e9:	79 07                	jns    16f2 <stat+0x3c>
    return -1;
    16eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    16f0:	eb 2f                	jmp    1721 <stat+0x6b>
  r = fstat(fd, st);
    16f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    16f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16f9:	48 89 d6             	mov    %rdx,%rsi
    16fc:	89 c7                	mov    %eax,%edi
    16fe:	48 b8 74 18 00 00 00 	movabs $0x1874,%rax
    1705:	00 00 00 
    1708:	ff d0                	callq  *%rax
    170a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    170d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1710:	89 c7                	mov    %eax,%edi
    1712:	48 b8 26 18 00 00 00 	movabs $0x1826,%rax
    1719:	00 00 00 
    171c:	ff d0                	callq  *%rax
  return r;
    171e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1721:	c9                   	leaveq 
    1722:	c3                   	retq   

0000000000001723 <atoi>:

int
atoi(const char *s)
{
    1723:	f3 0f 1e fa          	endbr64 
    1727:	55                   	push   %rbp
    1728:	48 89 e5             	mov    %rsp,%rbp
    172b:	48 83 ec 18          	sub    $0x18,%rsp
    172f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1733:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    173a:	eb 28                	jmp    1764 <atoi+0x41>
    n = n*10 + *s++ - '0';
    173c:	8b 55 fc             	mov    -0x4(%rbp),%edx
    173f:	89 d0                	mov    %edx,%eax
    1741:	c1 e0 02             	shl    $0x2,%eax
    1744:	01 d0                	add    %edx,%eax
    1746:	01 c0                	add    %eax,%eax
    1748:	89 c1                	mov    %eax,%ecx
    174a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    174e:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1752:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1756:	0f b6 00             	movzbl (%rax),%eax
    1759:	0f be c0             	movsbl %al,%eax
    175c:	01 c8                	add    %ecx,%eax
    175e:	83 e8 30             	sub    $0x30,%eax
    1761:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1768:	0f b6 00             	movzbl (%rax),%eax
    176b:	3c 2f                	cmp    $0x2f,%al
    176d:	7e 0b                	jle    177a <atoi+0x57>
    176f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1773:	0f b6 00             	movzbl (%rax),%eax
    1776:	3c 39                	cmp    $0x39,%al
    1778:	7e c2                	jle    173c <atoi+0x19>
  return n;
    177a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    177d:	c9                   	leaveq 
    177e:	c3                   	retq   

000000000000177f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    177f:	f3 0f 1e fa          	endbr64 
    1783:	55                   	push   %rbp
    1784:	48 89 e5             	mov    %rsp,%rbp
    1787:	48 83 ec 28          	sub    $0x28,%rsp
    178b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    178f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1793:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1796:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    179a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    179e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    17a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    17a6:	eb 1d                	jmp    17c5 <memmove+0x46>
    *dst++ = *src++;
    17a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    17ac:	48 8d 42 01          	lea    0x1(%rdx),%rax
    17b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    17b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    17b8:	48 8d 48 01          	lea    0x1(%rax),%rcx
    17bc:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    17c0:	0f b6 12             	movzbl (%rdx),%edx
    17c3:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    17c5:	8b 45 dc             	mov    -0x24(%rbp),%eax
    17c8:	8d 50 ff             	lea    -0x1(%rax),%edx
    17cb:	89 55 dc             	mov    %edx,-0x24(%rbp)
    17ce:	85 c0                	test   %eax,%eax
    17d0:	7f d6                	jg     17a8 <memmove+0x29>
  return vdst;
    17d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    17d6:	c9                   	leaveq 
    17d7:	c3                   	retq   

00000000000017d8 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    17d8:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    17df:	49 89 ca             	mov    %rcx,%r10
    17e2:	0f 05                	syscall 
    17e4:	c3                   	retq   

00000000000017e5 <exit>:
SYSCALL(exit)
    17e5:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    17ec:	49 89 ca             	mov    %rcx,%r10
    17ef:	0f 05                	syscall 
    17f1:	c3                   	retq   

00000000000017f2 <wait>:
SYSCALL(wait)
    17f2:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    17f9:	49 89 ca             	mov    %rcx,%r10
    17fc:	0f 05                	syscall 
    17fe:	c3                   	retq   

00000000000017ff <pipe>:
SYSCALL(pipe)
    17ff:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1806:	49 89 ca             	mov    %rcx,%r10
    1809:	0f 05                	syscall 
    180b:	c3                   	retq   

000000000000180c <read>:
SYSCALL(read)
    180c:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    1813:	49 89 ca             	mov    %rcx,%r10
    1816:	0f 05                	syscall 
    1818:	c3                   	retq   

0000000000001819 <write>:
SYSCALL(write)
    1819:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    1820:	49 89 ca             	mov    %rcx,%r10
    1823:	0f 05                	syscall 
    1825:	c3                   	retq   

0000000000001826 <close>:
SYSCALL(close)
    1826:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    182d:	49 89 ca             	mov    %rcx,%r10
    1830:	0f 05                	syscall 
    1832:	c3                   	retq   

0000000000001833 <kill>:
SYSCALL(kill)
    1833:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    183a:	49 89 ca             	mov    %rcx,%r10
    183d:	0f 05                	syscall 
    183f:	c3                   	retq   

0000000000001840 <exec>:
SYSCALL(exec)
    1840:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1847:	49 89 ca             	mov    %rcx,%r10
    184a:	0f 05                	syscall 
    184c:	c3                   	retq   

000000000000184d <open>:
SYSCALL(open)
    184d:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1854:	49 89 ca             	mov    %rcx,%r10
    1857:	0f 05                	syscall 
    1859:	c3                   	retq   

000000000000185a <mknod>:
SYSCALL(mknod)
    185a:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1861:	49 89 ca             	mov    %rcx,%r10
    1864:	0f 05                	syscall 
    1866:	c3                   	retq   

0000000000001867 <unlink>:
SYSCALL(unlink)
    1867:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    186e:	49 89 ca             	mov    %rcx,%r10
    1871:	0f 05                	syscall 
    1873:	c3                   	retq   

0000000000001874 <fstat>:
SYSCALL(fstat)
    1874:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    187b:	49 89 ca             	mov    %rcx,%r10
    187e:	0f 05                	syscall 
    1880:	c3                   	retq   

0000000000001881 <link>:
SYSCALL(link)
    1881:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1888:	49 89 ca             	mov    %rcx,%r10
    188b:	0f 05                	syscall 
    188d:	c3                   	retq   

000000000000188e <mkdir>:
SYSCALL(mkdir)
    188e:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1895:	49 89 ca             	mov    %rcx,%r10
    1898:	0f 05                	syscall 
    189a:	c3                   	retq   

000000000000189b <chdir>:
SYSCALL(chdir)
    189b:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    18a2:	49 89 ca             	mov    %rcx,%r10
    18a5:	0f 05                	syscall 
    18a7:	c3                   	retq   

00000000000018a8 <dup>:
SYSCALL(dup)
    18a8:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    18af:	49 89 ca             	mov    %rcx,%r10
    18b2:	0f 05                	syscall 
    18b4:	c3                   	retq   

00000000000018b5 <getpid>:
SYSCALL(getpid)
    18b5:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    18bc:	49 89 ca             	mov    %rcx,%r10
    18bf:	0f 05                	syscall 
    18c1:	c3                   	retq   

00000000000018c2 <sbrk>:
SYSCALL(sbrk)
    18c2:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    18c9:	49 89 ca             	mov    %rcx,%r10
    18cc:	0f 05                	syscall 
    18ce:	c3                   	retq   

00000000000018cf <sleep>:
SYSCALL(sleep)
    18cf:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    18d6:	49 89 ca             	mov    %rcx,%r10
    18d9:	0f 05                	syscall 
    18db:	c3                   	retq   

00000000000018dc <uptime>:
SYSCALL(uptime)
    18dc:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    18e3:	49 89 ca             	mov    %rcx,%r10
    18e6:	0f 05                	syscall 
    18e8:	c3                   	retq   

00000000000018e9 <dedup>:
SYSCALL(dedup)
    18e9:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    18f0:	49 89 ca             	mov    %rcx,%r10
    18f3:	0f 05                	syscall 
    18f5:	c3                   	retq   

00000000000018f6 <freepages>:
SYSCALL(freepages)
    18f6:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    18fd:	49 89 ca             	mov    %rcx,%r10
    1900:	0f 05                	syscall 
    1902:	c3                   	retq   

0000000000001903 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    1903:	f3 0f 1e fa          	endbr64 
    1907:	55                   	push   %rbp
    1908:	48 89 e5             	mov    %rsp,%rbp
    190b:	48 83 ec 10          	sub    $0x10,%rsp
    190f:	89 7d fc             	mov    %edi,-0x4(%rbp)
    1912:	89 f0                	mov    %esi,%eax
    1914:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1917:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    191b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    191e:	ba 01 00 00 00       	mov    $0x1,%edx
    1923:	48 89 ce             	mov    %rcx,%rsi
    1926:	89 c7                	mov    %eax,%edi
    1928:	48 b8 19 18 00 00 00 	movabs $0x1819,%rax
    192f:	00 00 00 
    1932:	ff d0                	callq  *%rax
}
    1934:	90                   	nop
    1935:	c9                   	leaveq 
    1936:	c3                   	retq   

0000000000001937 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1937:	f3 0f 1e fa          	endbr64 
    193b:	55                   	push   %rbp
    193c:	48 89 e5             	mov    %rsp,%rbp
    193f:	48 83 ec 20          	sub    $0x20,%rsp
    1943:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1946:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    194a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1951:	eb 35                	jmp    1988 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1953:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1957:	48 c1 e8 3c          	shr    $0x3c,%rax
    195b:	48 ba d0 25 00 00 00 	movabs $0x25d0,%rdx
    1962:	00 00 00 
    1965:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1969:	0f be d0             	movsbl %al,%edx
    196c:	8b 45 ec             	mov    -0x14(%rbp),%eax
    196f:	89 d6                	mov    %edx,%esi
    1971:	89 c7                	mov    %eax,%edi
    1973:	48 b8 03 19 00 00 00 	movabs $0x1903,%rax
    197a:	00 00 00 
    197d:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    197f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1983:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1988:	8b 45 fc             	mov    -0x4(%rbp),%eax
    198b:	83 f8 0f             	cmp    $0xf,%eax
    198e:	76 c3                	jbe    1953 <print_x64+0x1c>
}
    1990:	90                   	nop
    1991:	90                   	nop
    1992:	c9                   	leaveq 
    1993:	c3                   	retq   

0000000000001994 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1994:	f3 0f 1e fa          	endbr64 
    1998:	55                   	push   %rbp
    1999:	48 89 e5             	mov    %rsp,%rbp
    199c:	48 83 ec 20          	sub    $0x20,%rsp
    19a0:	89 7d ec             	mov    %edi,-0x14(%rbp)
    19a3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    19a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    19ad:	eb 36                	jmp    19e5 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    19af:	8b 45 e8             	mov    -0x18(%rbp),%eax
    19b2:	c1 e8 1c             	shr    $0x1c,%eax
    19b5:	89 c2                	mov    %eax,%edx
    19b7:	48 b8 d0 25 00 00 00 	movabs $0x25d0,%rax
    19be:	00 00 00 
    19c1:	89 d2                	mov    %edx,%edx
    19c3:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    19c7:	0f be d0             	movsbl %al,%edx
    19ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
    19cd:	89 d6                	mov    %edx,%esi
    19cf:	89 c7                	mov    %eax,%edi
    19d1:	48 b8 03 19 00 00 00 	movabs $0x1903,%rax
    19d8:	00 00 00 
    19db:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    19dd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    19e1:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    19e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    19e8:	83 f8 07             	cmp    $0x7,%eax
    19eb:	76 c2                	jbe    19af <print_x32+0x1b>
}
    19ed:	90                   	nop
    19ee:	90                   	nop
    19ef:	c9                   	leaveq 
    19f0:	c3                   	retq   

00000000000019f1 <print_d>:

  static void
print_d(int fd, int v)
{
    19f1:	f3 0f 1e fa          	endbr64 
    19f5:	55                   	push   %rbp
    19f6:	48 89 e5             	mov    %rsp,%rbp
    19f9:	48 83 ec 30          	sub    $0x30,%rsp
    19fd:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1a00:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    1a03:	8b 45 d8             	mov    -0x28(%rbp),%eax
    1a06:	48 98                	cltq   
    1a08:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1a0c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1a10:	79 04                	jns    1a16 <print_d+0x25>
    x = -x;
    1a12:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1a16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1a1d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1a21:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1a28:	66 66 66 
    1a2b:	48 89 c8             	mov    %rcx,%rax
    1a2e:	48 f7 ea             	imul   %rdx
    1a31:	48 c1 fa 02          	sar    $0x2,%rdx
    1a35:	48 89 c8             	mov    %rcx,%rax
    1a38:	48 c1 f8 3f          	sar    $0x3f,%rax
    1a3c:	48 29 c2             	sub    %rax,%rdx
    1a3f:	48 89 d0             	mov    %rdx,%rax
    1a42:	48 c1 e0 02          	shl    $0x2,%rax
    1a46:	48 01 d0             	add    %rdx,%rax
    1a49:	48 01 c0             	add    %rax,%rax
    1a4c:	48 29 c1             	sub    %rax,%rcx
    1a4f:	48 89 ca             	mov    %rcx,%rdx
    1a52:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1a55:	8d 48 01             	lea    0x1(%rax),%ecx
    1a58:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1a5b:	48 b9 d0 25 00 00 00 	movabs $0x25d0,%rcx
    1a62:	00 00 00 
    1a65:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1a69:	48 98                	cltq   
    1a6b:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1a6f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1a73:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1a7a:	66 66 66 
    1a7d:	48 89 c8             	mov    %rcx,%rax
    1a80:	48 f7 ea             	imul   %rdx
    1a83:	48 c1 fa 02          	sar    $0x2,%rdx
    1a87:	48 89 c8             	mov    %rcx,%rax
    1a8a:	48 c1 f8 3f          	sar    $0x3f,%rax
    1a8e:	48 29 c2             	sub    %rax,%rdx
    1a91:	48 89 d0             	mov    %rdx,%rax
    1a94:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1a98:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1a9d:	0f 85 7a ff ff ff    	jne    1a1d <print_d+0x2c>

  if (v < 0)
    1aa3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1aa7:	79 32                	jns    1adb <print_d+0xea>
    buf[i++] = '-';
    1aa9:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1aac:	8d 50 01             	lea    0x1(%rax),%edx
    1aaf:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1ab2:	48 98                	cltq   
    1ab4:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1ab9:	eb 20                	jmp    1adb <print_d+0xea>
    putc(fd, buf[i]);
    1abb:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1abe:	48 98                	cltq   
    1ac0:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1ac5:	0f be d0             	movsbl %al,%edx
    1ac8:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1acb:	89 d6                	mov    %edx,%esi
    1acd:	89 c7                	mov    %eax,%edi
    1acf:	48 b8 03 19 00 00 00 	movabs $0x1903,%rax
    1ad6:	00 00 00 
    1ad9:	ff d0                	callq  *%rax
  while (--i >= 0)
    1adb:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1adf:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1ae3:	79 d6                	jns    1abb <print_d+0xca>
}
    1ae5:	90                   	nop
    1ae6:	90                   	nop
    1ae7:	c9                   	leaveq 
    1ae8:	c3                   	retq   

0000000000001ae9 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1ae9:	f3 0f 1e fa          	endbr64 
    1aed:	55                   	push   %rbp
    1aee:	48 89 e5             	mov    %rsp,%rbp
    1af1:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1af8:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1afe:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1b05:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1b0c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1b13:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1b1a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1b21:	84 c0                	test   %al,%al
    1b23:	74 20                	je     1b45 <printf+0x5c>
    1b25:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1b29:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1b2d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1b31:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1b35:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1b39:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1b3d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1b41:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1b45:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1b4c:	00 00 00 
    1b4f:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1b56:	00 00 00 
    1b59:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1b5d:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1b64:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1b6b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1b72:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1b79:	00 00 00 
    1b7c:	e9 41 03 00 00       	jmpq   1ec2 <printf+0x3d9>
    if (c != '%') {
    1b81:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1b88:	74 24                	je     1bae <printf+0xc5>
      putc(fd, c);
    1b8a:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1b90:	0f be d0             	movsbl %al,%edx
    1b93:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b99:	89 d6                	mov    %edx,%esi
    1b9b:	89 c7                	mov    %eax,%edi
    1b9d:	48 b8 03 19 00 00 00 	movabs $0x1903,%rax
    1ba4:	00 00 00 
    1ba7:	ff d0                	callq  *%rax
      continue;
    1ba9:	e9 0d 03 00 00       	jmpq   1ebb <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1bae:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1bb5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1bbb:	48 63 d0             	movslq %eax,%rdx
    1bbe:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1bc5:	48 01 d0             	add    %rdx,%rax
    1bc8:	0f b6 00             	movzbl (%rax),%eax
    1bcb:	0f be c0             	movsbl %al,%eax
    1bce:	25 ff 00 00 00       	and    $0xff,%eax
    1bd3:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1bd9:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1be0:	0f 84 0f 03 00 00    	je     1ef5 <printf+0x40c>
      break;
    switch(c) {
    1be6:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1bed:	0f 84 74 02 00 00    	je     1e67 <printf+0x37e>
    1bf3:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1bfa:	0f 8c 82 02 00 00    	jl     1e82 <printf+0x399>
    1c00:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1c07:	0f 8f 75 02 00 00    	jg     1e82 <printf+0x399>
    1c0d:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1c14:	0f 8c 68 02 00 00    	jl     1e82 <printf+0x399>
    1c1a:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1c20:	83 e8 63             	sub    $0x63,%eax
    1c23:	83 f8 15             	cmp    $0x15,%eax
    1c26:	0f 87 56 02 00 00    	ja     1e82 <printf+0x399>
    1c2c:	89 c0                	mov    %eax,%eax
    1c2e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1c35:	00 
    1c36:	48 b8 58 22 00 00 00 	movabs $0x2258,%rax
    1c3d:	00 00 00 
    1c40:	48 01 d0             	add    %rdx,%rax
    1c43:	48 8b 00             	mov    (%rax),%rax
    1c46:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1c49:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1c4f:	83 f8 2f             	cmp    $0x2f,%eax
    1c52:	77 23                	ja     1c77 <printf+0x18e>
    1c54:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1c5b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c61:	89 d2                	mov    %edx,%edx
    1c63:	48 01 d0             	add    %rdx,%rax
    1c66:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c6c:	83 c2 08             	add    $0x8,%edx
    1c6f:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1c75:	eb 12                	jmp    1c89 <printf+0x1a0>
    1c77:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1c7e:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1c82:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1c89:	8b 00                	mov    (%rax),%eax
    1c8b:	0f be d0             	movsbl %al,%edx
    1c8e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c94:	89 d6                	mov    %edx,%esi
    1c96:	89 c7                	mov    %eax,%edi
    1c98:	48 b8 03 19 00 00 00 	movabs $0x1903,%rax
    1c9f:	00 00 00 
    1ca2:	ff d0                	callq  *%rax
      break;
    1ca4:	e9 12 02 00 00       	jmpq   1ebb <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1ca9:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1caf:	83 f8 2f             	cmp    $0x2f,%eax
    1cb2:	77 23                	ja     1cd7 <printf+0x1ee>
    1cb4:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1cbb:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1cc1:	89 d2                	mov    %edx,%edx
    1cc3:	48 01 d0             	add    %rdx,%rax
    1cc6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ccc:	83 c2 08             	add    $0x8,%edx
    1ccf:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1cd5:	eb 12                	jmp    1ce9 <printf+0x200>
    1cd7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1cde:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1ce2:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1ce9:	8b 10                	mov    (%rax),%edx
    1ceb:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1cf1:	89 d6                	mov    %edx,%esi
    1cf3:	89 c7                	mov    %eax,%edi
    1cf5:	48 b8 f1 19 00 00 00 	movabs $0x19f1,%rax
    1cfc:	00 00 00 
    1cff:	ff d0                	callq  *%rax
      break;
    1d01:	e9 b5 01 00 00       	jmpq   1ebb <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1d06:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1d0c:	83 f8 2f             	cmp    $0x2f,%eax
    1d0f:	77 23                	ja     1d34 <printf+0x24b>
    1d11:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1d18:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d1e:	89 d2                	mov    %edx,%edx
    1d20:	48 01 d0             	add    %rdx,%rax
    1d23:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d29:	83 c2 08             	add    $0x8,%edx
    1d2c:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1d32:	eb 12                	jmp    1d46 <printf+0x25d>
    1d34:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1d3b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1d3f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1d46:	8b 10                	mov    (%rax),%edx
    1d48:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1d4e:	89 d6                	mov    %edx,%esi
    1d50:	89 c7                	mov    %eax,%edi
    1d52:	48 b8 94 19 00 00 00 	movabs $0x1994,%rax
    1d59:	00 00 00 
    1d5c:	ff d0                	callq  *%rax
      break;
    1d5e:	e9 58 01 00 00       	jmpq   1ebb <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1d63:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1d69:	83 f8 2f             	cmp    $0x2f,%eax
    1d6c:	77 23                	ja     1d91 <printf+0x2a8>
    1d6e:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1d75:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d7b:	89 d2                	mov    %edx,%edx
    1d7d:	48 01 d0             	add    %rdx,%rax
    1d80:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d86:	83 c2 08             	add    $0x8,%edx
    1d89:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1d8f:	eb 12                	jmp    1da3 <printf+0x2ba>
    1d91:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1d98:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1d9c:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1da3:	48 8b 10             	mov    (%rax),%rdx
    1da6:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1dac:	48 89 d6             	mov    %rdx,%rsi
    1daf:	89 c7                	mov    %eax,%edi
    1db1:	48 b8 37 19 00 00 00 	movabs $0x1937,%rax
    1db8:	00 00 00 
    1dbb:	ff d0                	callq  *%rax
      break;
    1dbd:	e9 f9 00 00 00       	jmpq   1ebb <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1dc2:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1dc8:	83 f8 2f             	cmp    $0x2f,%eax
    1dcb:	77 23                	ja     1df0 <printf+0x307>
    1dcd:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1dd4:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1dda:	89 d2                	mov    %edx,%edx
    1ddc:	48 01 d0             	add    %rdx,%rax
    1ddf:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1de5:	83 c2 08             	add    $0x8,%edx
    1de8:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1dee:	eb 12                	jmp    1e02 <printf+0x319>
    1df0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1df7:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1dfb:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1e02:	48 8b 00             	mov    (%rax),%rax
    1e05:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1e0c:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1e13:	00 
    1e14:	75 41                	jne    1e57 <printf+0x36e>
        s = "(null)";
    1e16:	48 b8 50 22 00 00 00 	movabs $0x2250,%rax
    1e1d:	00 00 00 
    1e20:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1e27:	eb 2e                	jmp    1e57 <printf+0x36e>
        putc(fd, *(s++));
    1e29:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1e30:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1e34:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1e3b:	0f b6 00             	movzbl (%rax),%eax
    1e3e:	0f be d0             	movsbl %al,%edx
    1e41:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e47:	89 d6                	mov    %edx,%esi
    1e49:	89 c7                	mov    %eax,%edi
    1e4b:	48 b8 03 19 00 00 00 	movabs $0x1903,%rax
    1e52:	00 00 00 
    1e55:	ff d0                	callq  *%rax
      while (*s)
    1e57:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1e5e:	0f b6 00             	movzbl (%rax),%eax
    1e61:	84 c0                	test   %al,%al
    1e63:	75 c4                	jne    1e29 <printf+0x340>
      break;
    1e65:	eb 54                	jmp    1ebb <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1e67:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e6d:	be 25 00 00 00       	mov    $0x25,%esi
    1e72:	89 c7                	mov    %eax,%edi
    1e74:	48 b8 03 19 00 00 00 	movabs $0x1903,%rax
    1e7b:	00 00 00 
    1e7e:	ff d0                	callq  *%rax
      break;
    1e80:	eb 39                	jmp    1ebb <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1e82:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e88:	be 25 00 00 00       	mov    $0x25,%esi
    1e8d:	89 c7                	mov    %eax,%edi
    1e8f:	48 b8 03 19 00 00 00 	movabs $0x1903,%rax
    1e96:	00 00 00 
    1e99:	ff d0                	callq  *%rax
      putc(fd, c);
    1e9b:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1ea1:	0f be d0             	movsbl %al,%edx
    1ea4:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1eaa:	89 d6                	mov    %edx,%esi
    1eac:	89 c7                	mov    %eax,%edi
    1eae:	48 b8 03 19 00 00 00 	movabs $0x1903,%rax
    1eb5:	00 00 00 
    1eb8:	ff d0                	callq  *%rax
      break;
    1eba:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1ebb:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1ec2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1ec8:	48 63 d0             	movslq %eax,%rdx
    1ecb:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1ed2:	48 01 d0             	add    %rdx,%rax
    1ed5:	0f b6 00             	movzbl (%rax),%eax
    1ed8:	0f be c0             	movsbl %al,%eax
    1edb:	25 ff 00 00 00       	and    $0xff,%eax
    1ee0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1ee6:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1eed:	0f 85 8e fc ff ff    	jne    1b81 <printf+0x98>
    }
  }
}
    1ef3:	eb 01                	jmp    1ef6 <printf+0x40d>
      break;
    1ef5:	90                   	nop
}
    1ef6:	90                   	nop
    1ef7:	c9                   	leaveq 
    1ef8:	c3                   	retq   

0000000000001ef9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1ef9:	f3 0f 1e fa          	endbr64 
    1efd:	55                   	push   %rbp
    1efe:	48 89 e5             	mov    %rsp,%rbp
    1f01:	48 83 ec 18          	sub    $0x18,%rsp
    1f05:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1f09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1f0d:	48 83 e8 10          	sub    $0x10,%rax
    1f11:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1f15:	48 b8 10 26 00 00 00 	movabs $0x2610,%rax
    1f1c:	00 00 00 
    1f1f:	48 8b 00             	mov    (%rax),%rax
    1f22:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f26:	eb 2f                	jmp    1f57 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1f28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f2c:	48 8b 00             	mov    (%rax),%rax
    1f2f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f33:	72 17                	jb     1f4c <free+0x53>
    1f35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f39:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1f3d:	77 2f                	ja     1f6e <free+0x75>
    1f3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f43:	48 8b 00             	mov    (%rax),%rax
    1f46:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1f4a:	72 22                	jb     1f6e <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1f4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f50:	48 8b 00             	mov    (%rax),%rax
    1f53:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f5b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1f5f:	76 c7                	jbe    1f28 <free+0x2f>
    1f61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f65:	48 8b 00             	mov    (%rax),%rax
    1f68:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1f6c:	73 ba                	jae    1f28 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1f6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f72:	8b 40 08             	mov    0x8(%rax),%eax
    1f75:	89 c0                	mov    %eax,%eax
    1f77:	48 c1 e0 04          	shl    $0x4,%rax
    1f7b:	48 89 c2             	mov    %rax,%rdx
    1f7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f82:	48 01 c2             	add    %rax,%rdx
    1f85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f89:	48 8b 00             	mov    (%rax),%rax
    1f8c:	48 39 c2             	cmp    %rax,%rdx
    1f8f:	75 2d                	jne    1fbe <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1f91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f95:	8b 50 08             	mov    0x8(%rax),%edx
    1f98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f9c:	48 8b 00             	mov    (%rax),%rax
    1f9f:	8b 40 08             	mov    0x8(%rax),%eax
    1fa2:	01 c2                	add    %eax,%edx
    1fa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fa8:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1fab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1faf:	48 8b 00             	mov    (%rax),%rax
    1fb2:	48 8b 10             	mov    (%rax),%rdx
    1fb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fb9:	48 89 10             	mov    %rdx,(%rax)
    1fbc:	eb 0e                	jmp    1fcc <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1fbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fc2:	48 8b 10             	mov    (%rax),%rdx
    1fc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fc9:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1fcc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fd0:	8b 40 08             	mov    0x8(%rax),%eax
    1fd3:	89 c0                	mov    %eax,%eax
    1fd5:	48 c1 e0 04          	shl    $0x4,%rax
    1fd9:	48 89 c2             	mov    %rax,%rdx
    1fdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fe0:	48 01 d0             	add    %rdx,%rax
    1fe3:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1fe7:	75 27                	jne    2010 <free+0x117>
    p->s.size += bp->s.size;
    1fe9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fed:	8b 50 08             	mov    0x8(%rax),%edx
    1ff0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ff4:	8b 40 08             	mov    0x8(%rax),%eax
    1ff7:	01 c2                	add    %eax,%edx
    1ff9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ffd:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    2000:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2004:	48 8b 10             	mov    (%rax),%rdx
    2007:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    200b:	48 89 10             	mov    %rdx,(%rax)
    200e:	eb 0b                	jmp    201b <free+0x122>
  } else
    p->s.ptr = bp;
    2010:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2014:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    2018:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    201b:	48 ba 10 26 00 00 00 	movabs $0x2610,%rdx
    2022:	00 00 00 
    2025:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2029:	48 89 02             	mov    %rax,(%rdx)
}
    202c:	90                   	nop
    202d:	c9                   	leaveq 
    202e:	c3                   	retq   

000000000000202f <morecore>:

static Header*
morecore(uint nu)
{
    202f:	f3 0f 1e fa          	endbr64 
    2033:	55                   	push   %rbp
    2034:	48 89 e5             	mov    %rsp,%rbp
    2037:	48 83 ec 20          	sub    $0x20,%rsp
    203b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    203e:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    2045:	77 07                	ja     204e <morecore+0x1f>
    nu = 4096;
    2047:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    204e:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2051:	48 c1 e0 04          	shl    $0x4,%rax
    2055:	48 89 c7             	mov    %rax,%rdi
    2058:	48 b8 c2 18 00 00 00 	movabs $0x18c2,%rax
    205f:	00 00 00 
    2062:	ff d0                	callq  *%rax
    2064:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    2068:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    206d:	75 07                	jne    2076 <morecore+0x47>
    return 0;
    206f:	b8 00 00 00 00       	mov    $0x0,%eax
    2074:	eb 36                	jmp    20ac <morecore+0x7d>
  hp = (Header*)p;
    2076:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    207a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    207e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2082:	8b 55 ec             	mov    -0x14(%rbp),%edx
    2085:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    2088:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    208c:	48 83 c0 10          	add    $0x10,%rax
    2090:	48 89 c7             	mov    %rax,%rdi
    2093:	48 b8 f9 1e 00 00 00 	movabs $0x1ef9,%rax
    209a:	00 00 00 
    209d:	ff d0                	callq  *%rax
  return freep;
    209f:	48 b8 10 26 00 00 00 	movabs $0x2610,%rax
    20a6:	00 00 00 
    20a9:	48 8b 00             	mov    (%rax),%rax
}
    20ac:	c9                   	leaveq 
    20ad:	c3                   	retq   

00000000000020ae <malloc>:

void*
malloc(uint nbytes)
{
    20ae:	f3 0f 1e fa          	endbr64 
    20b2:	55                   	push   %rbp
    20b3:	48 89 e5             	mov    %rsp,%rbp
    20b6:	48 83 ec 30          	sub    $0x30,%rsp
    20ba:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    20bd:	8b 45 dc             	mov    -0x24(%rbp),%eax
    20c0:	48 83 c0 0f          	add    $0xf,%rax
    20c4:	48 c1 e8 04          	shr    $0x4,%rax
    20c8:	83 c0 01             	add    $0x1,%eax
    20cb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    20ce:	48 b8 10 26 00 00 00 	movabs $0x2610,%rax
    20d5:	00 00 00 
    20d8:	48 8b 00             	mov    (%rax),%rax
    20db:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    20df:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    20e4:	75 4a                	jne    2130 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    20e6:	48 b8 00 26 00 00 00 	movabs $0x2600,%rax
    20ed:	00 00 00 
    20f0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    20f4:	48 ba 10 26 00 00 00 	movabs $0x2610,%rdx
    20fb:	00 00 00 
    20fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2102:	48 89 02             	mov    %rax,(%rdx)
    2105:	48 b8 10 26 00 00 00 	movabs $0x2610,%rax
    210c:	00 00 00 
    210f:	48 8b 00             	mov    (%rax),%rax
    2112:	48 ba 00 26 00 00 00 	movabs $0x2600,%rdx
    2119:	00 00 00 
    211c:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    211f:	48 b8 00 26 00 00 00 	movabs $0x2600,%rax
    2126:	00 00 00 
    2129:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2130:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2134:	48 8b 00             	mov    (%rax),%rax
    2137:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    213b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    213f:	8b 40 08             	mov    0x8(%rax),%eax
    2142:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    2145:	77 65                	ja     21ac <malloc+0xfe>
      if(p->s.size == nunits)
    2147:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    214b:	8b 40 08             	mov    0x8(%rax),%eax
    214e:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    2151:	75 10                	jne    2163 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    2153:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2157:	48 8b 10             	mov    (%rax),%rdx
    215a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    215e:	48 89 10             	mov    %rdx,(%rax)
    2161:	eb 2e                	jmp    2191 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    2163:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2167:	8b 40 08             	mov    0x8(%rax),%eax
    216a:	2b 45 ec             	sub    -0x14(%rbp),%eax
    216d:	89 c2                	mov    %eax,%edx
    216f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2173:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    2176:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    217a:	8b 40 08             	mov    0x8(%rax),%eax
    217d:	89 c0                	mov    %eax,%eax
    217f:	48 c1 e0 04          	shl    $0x4,%rax
    2183:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    2187:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    218b:	8b 55 ec             	mov    -0x14(%rbp),%edx
    218e:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    2191:	48 ba 10 26 00 00 00 	movabs $0x2610,%rdx
    2198:	00 00 00 
    219b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    219f:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    21a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21a6:	48 83 c0 10          	add    $0x10,%rax
    21aa:	eb 4e                	jmp    21fa <malloc+0x14c>
    }
    if(p == freep)
    21ac:	48 b8 10 26 00 00 00 	movabs $0x2610,%rax
    21b3:	00 00 00 
    21b6:	48 8b 00             	mov    (%rax),%rax
    21b9:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    21bd:	75 23                	jne    21e2 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    21bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
    21c2:	89 c7                	mov    %eax,%edi
    21c4:	48 b8 2f 20 00 00 00 	movabs $0x202f,%rax
    21cb:	00 00 00 
    21ce:	ff d0                	callq  *%rax
    21d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    21d4:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    21d9:	75 07                	jne    21e2 <malloc+0x134>
        return 0;
    21db:	b8 00 00 00 00       	mov    $0x0,%eax
    21e0:	eb 18                	jmp    21fa <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    21e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    21ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21ee:	48 8b 00             	mov    (%rax),%rax
    21f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    21f5:	e9 41 ff ff ff       	jmpq   213b <malloc+0x8d>
  }
}
    21fa:	c9                   	leaveq 
    21fb:	c3                   	retq   
