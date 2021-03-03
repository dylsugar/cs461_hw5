
_grep:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 30          	sub    $0x30,%rsp
    100c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
    1010:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  int n, m;
  char *p, *q;

  m = 0;
    1013:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    101a:	e9 04 01 00 00       	jmpq   1123 <grep+0x123>
    m += n;
    101f:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1022:	01 45 fc             	add    %eax,-0x4(%rbp)
    buf[m] = '\0';
    1025:	48 ba e0 25 00 00 00 	movabs $0x25e0,%rdx
    102c:	00 00 00 
    102f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1032:	48 98                	cltq   
    1034:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
    p = buf;
    1038:	48 b8 e0 25 00 00 00 	movabs $0x25e0,%rax
    103f:	00 00 00 
    1042:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    while((q = strchr(p, '\n')) != 0){
    1046:	eb 5e                	jmp    10a6 <grep+0xa6>
      *q = 0;
    1048:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    104c:	c6 00 00             	movb   $0x0,(%rax)
      if(match(pattern, p)){
    104f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1053:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1057:	48 89 d6             	mov    %rdx,%rsi
    105a:	48 89 c7             	mov    %rax,%rdi
    105d:	48 b8 b1 12 00 00 00 	movabs $0x12b1,%rax
    1064:	00 00 00 
    1067:	ff d0                	callq  *%rax
    1069:	85 c0                	test   %eax,%eax
    106b:	74 2d                	je     109a <grep+0x9a>
        *q = '\n';
    106d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1071:	c6 00 0a             	movb   $0xa,(%rax)
        write(1, p, q+1 - p);
    1074:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1078:	48 83 c0 01          	add    $0x1,%rax
    107c:	48 2b 45 f0          	sub    -0x10(%rbp),%rax
    1080:	89 c2                	mov    %eax,%edx
    1082:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1086:	48 89 c6             	mov    %rax,%rsi
    1089:	bf 01 00 00 00       	mov    $0x1,%edi
    108e:	48 b8 f0 17 00 00 00 	movabs $0x17f0,%rax
    1095:	00 00 00 
    1098:	ff d0                	callq  *%rax
      }
      p = q+1;
    109a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    109e:	48 83 c0 01          	add    $0x1,%rax
    10a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    while((q = strchr(p, '\n')) != 0){
    10a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    10aa:	be 0a 00 00 00       	mov    $0xa,%esi
    10af:	48 89 c7             	mov    %rax,%rdi
    10b2:	48 b8 be 15 00 00 00 	movabs $0x15be,%rax
    10b9:	00 00 00 
    10bc:	ff d0                	callq  *%rax
    10be:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    10c2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
    10c7:	0f 85 7b ff ff ff    	jne    1048 <grep+0x48>
    }
    if(p == buf)
    10cd:	48 b8 e0 25 00 00 00 	movabs $0x25e0,%rax
    10d4:	00 00 00 
    10d7:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    10db:	75 07                	jne    10e4 <grep+0xe4>
      m = 0;
    10dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    if(m > 0){
    10e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    10e8:	7e 39                	jle    1123 <grep+0x123>
      m -= p - buf;
    10ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10ed:	48 b9 e0 25 00 00 00 	movabs $0x25e0,%rcx
    10f4:	00 00 00 
    10f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    10fb:	48 29 ca             	sub    %rcx,%rdx
    10fe:	29 d0                	sub    %edx,%eax
    1100:	89 45 fc             	mov    %eax,-0x4(%rbp)
      memmove(buf, p, m);
    1103:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1106:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    110a:	48 89 c6             	mov    %rax,%rsi
    110d:	48 bf e0 25 00 00 00 	movabs $0x25e0,%rdi
    1114:	00 00 00 
    1117:	48 b8 56 17 00 00 00 	movabs $0x1756,%rax
    111e:	00 00 00 
    1121:	ff d0                	callq  *%rax
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    1123:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1126:	ba ff 03 00 00       	mov    $0x3ff,%edx
    112b:	29 c2                	sub    %eax,%edx
    112d:	89 d0                	mov    %edx,%eax
    112f:	89 c6                	mov    %eax,%esi
    1131:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1134:	48 98                	cltq   
    1136:	48 ba e0 25 00 00 00 	movabs $0x25e0,%rdx
    113d:	00 00 00 
    1140:	48 8d 0c 10          	lea    (%rax,%rdx,1),%rcx
    1144:	8b 45 d4             	mov    -0x2c(%rbp),%eax
    1147:	89 f2                	mov    %esi,%edx
    1149:	48 89 ce             	mov    %rcx,%rsi
    114c:	89 c7                	mov    %eax,%edi
    114e:	48 b8 e3 17 00 00 00 	movabs $0x17e3,%rax
    1155:	00 00 00 
    1158:	ff d0                	callq  *%rax
    115a:	89 45 ec             	mov    %eax,-0x14(%rbp)
    115d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
    1161:	0f 8f b8 fe ff ff    	jg     101f <grep+0x1f>
    }
  }
}
    1167:	90                   	nop
    1168:	90                   	nop
    1169:	c9                   	leaveq 
    116a:	c3                   	retq   

000000000000116b <main>:

int
main(int argc, char *argv[])
{
    116b:	f3 0f 1e fa          	endbr64 
    116f:	55                   	push   %rbp
    1170:	48 89 e5             	mov    %rsp,%rbp
    1173:	48 83 ec 30          	sub    $0x30,%rsp
    1177:	89 7d dc             	mov    %edi,-0x24(%rbp)
    117a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  int fd, i;
  char *pattern;

  if(argc <= 1){
    117e:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
    1182:	7f 2c                	jg     11b0 <main+0x45>
    printf(2, "usage: grep pattern [file ...]\n");
    1184:	48 be d8 21 00 00 00 	movabs $0x21d8,%rsi
    118b:	00 00 00 
    118e:	bf 02 00 00 00       	mov    $0x2,%edi
    1193:	b8 00 00 00 00       	mov    $0x0,%eax
    1198:	48 ba c0 1a 00 00 00 	movabs $0x1ac0,%rdx
    119f:	00 00 00 
    11a2:	ff d2                	callq  *%rdx
    exit();
    11a4:	48 b8 bc 17 00 00 00 	movabs $0x17bc,%rax
    11ab:	00 00 00 
    11ae:	ff d0                	callq  *%rax
  }
  pattern = argv[1];
    11b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    11b4:	48 8b 40 08          	mov    0x8(%rax),%rax
    11b8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

  if(argc <= 2){
    11bc:	83 7d dc 02          	cmpl   $0x2,-0x24(%rbp)
    11c0:	7f 24                	jg     11e6 <main+0x7b>
    grep(pattern, 0);
    11c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    11c6:	be 00 00 00 00       	mov    $0x0,%esi
    11cb:	48 89 c7             	mov    %rax,%rdi
    11ce:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    11d5:	00 00 00 
    11d8:	ff d0                	callq  *%rax
    exit();
    11da:	48 b8 bc 17 00 00 00 	movabs $0x17bc,%rax
    11e1:	00 00 00 
    11e4:	ff d0                	callq  *%rax
  }

  for(i = 2; i < argc; i++){
    11e6:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
    11ed:	e9 a7 00 00 00       	jmpq   1299 <main+0x12e>
    if((fd = open(argv[i], 0)) < 0){
    11f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11f5:	48 98                	cltq   
    11f7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    11fe:	00 
    11ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1203:	48 01 d0             	add    %rdx,%rax
    1206:	48 8b 00             	mov    (%rax),%rax
    1209:	be 00 00 00 00       	mov    $0x0,%esi
    120e:	48 89 c7             	mov    %rax,%rdi
    1211:	48 b8 24 18 00 00 00 	movabs $0x1824,%rax
    1218:	00 00 00 
    121b:	ff d0                	callq  *%rax
    121d:	89 45 ec             	mov    %eax,-0x14(%rbp)
    1220:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
    1224:	79 46                	jns    126c <main+0x101>
      printf(1, "grep: cannot open %s\n", argv[i]);
    1226:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1229:	48 98                	cltq   
    122b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1232:	00 
    1233:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1237:	48 01 d0             	add    %rdx,%rax
    123a:	48 8b 00             	mov    (%rax),%rax
    123d:	48 89 c2             	mov    %rax,%rdx
    1240:	48 be f8 21 00 00 00 	movabs $0x21f8,%rsi
    1247:	00 00 00 
    124a:	bf 01 00 00 00       	mov    $0x1,%edi
    124f:	b8 00 00 00 00       	mov    $0x0,%eax
    1254:	48 b9 c0 1a 00 00 00 	movabs $0x1ac0,%rcx
    125b:	00 00 00 
    125e:	ff d1                	callq  *%rcx
      exit();
    1260:	48 b8 bc 17 00 00 00 	movabs $0x17bc,%rax
    1267:	00 00 00 
    126a:	ff d0                	callq  *%rax
    }
    grep(pattern, fd);
    126c:	8b 55 ec             	mov    -0x14(%rbp),%edx
    126f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1273:	89 d6                	mov    %edx,%esi
    1275:	48 89 c7             	mov    %rax,%rdi
    1278:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    127f:	00 00 00 
    1282:	ff d0                	callq  *%rax
    close(fd);
    1284:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1287:	89 c7                	mov    %eax,%edi
    1289:	48 b8 fd 17 00 00 00 	movabs $0x17fd,%rax
    1290:	00 00 00 
    1293:	ff d0                	callq  *%rax
  for(i = 2; i < argc; i++){
    1295:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1299:	8b 45 fc             	mov    -0x4(%rbp),%eax
    129c:	3b 45 dc             	cmp    -0x24(%rbp),%eax
    129f:	0f 8c 4d ff ff ff    	jl     11f2 <main+0x87>
  }
  exit();
    12a5:	48 b8 bc 17 00 00 00 	movabs $0x17bc,%rax
    12ac:	00 00 00 
    12af:	ff d0                	callq  *%rax

00000000000012b1 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
    12b1:	f3 0f 1e fa          	endbr64 
    12b5:	55                   	push   %rbp
    12b6:	48 89 e5             	mov    %rsp,%rbp
    12b9:	48 83 ec 10          	sub    $0x10,%rsp
    12bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(re[0] == '^')
    12c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12c9:	0f b6 00             	movzbl (%rax),%eax
    12cc:	3c 5e                	cmp    $0x5e,%al
    12ce:	75 20                	jne    12f0 <match+0x3f>
    return matchhere(re+1, text);
    12d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12d4:	48 8d 50 01          	lea    0x1(%rax),%rdx
    12d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    12dc:	48 89 c6             	mov    %rax,%rsi
    12df:	48 89 d7             	mov    %rdx,%rdi
    12e2:	48 b8 2f 13 00 00 00 	movabs $0x132f,%rax
    12e9:	00 00 00 
    12ec:	ff d0                	callq  *%rax
    12ee:	eb 3d                	jmp    132d <match+0x7c>
  do{  // must look at empty string
    if(matchhere(re, text))
    12f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    12f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12f8:	48 89 d6             	mov    %rdx,%rsi
    12fb:	48 89 c7             	mov    %rax,%rdi
    12fe:	48 b8 2f 13 00 00 00 	movabs $0x132f,%rax
    1305:	00 00 00 
    1308:	ff d0                	callq  *%rax
    130a:	85 c0                	test   %eax,%eax
    130c:	74 07                	je     1315 <match+0x64>
      return 1;
    130e:	b8 01 00 00 00       	mov    $0x1,%eax
    1313:	eb 18                	jmp    132d <match+0x7c>
  }while(*text++ != '\0');
    1315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1319:	48 8d 50 01          	lea    0x1(%rax),%rdx
    131d:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
    1321:	0f b6 00             	movzbl (%rax),%eax
    1324:	84 c0                	test   %al,%al
    1326:	75 c8                	jne    12f0 <match+0x3f>
  return 0;
    1328:	b8 00 00 00 00       	mov    $0x0,%eax
}
    132d:	c9                   	leaveq 
    132e:	c3                   	retq   

000000000000132f <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
    132f:	f3 0f 1e fa          	endbr64 
    1333:	55                   	push   %rbp
    1334:	48 89 e5             	mov    %rsp,%rbp
    1337:	48 83 ec 10          	sub    $0x10,%rsp
    133b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    133f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(re[0] == '\0')
    1343:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1347:	0f b6 00             	movzbl (%rax),%eax
    134a:	84 c0                	test   %al,%al
    134c:	75 0a                	jne    1358 <matchhere+0x29>
    return 1;
    134e:	b8 01 00 00 00       	mov    $0x1,%eax
    1353:	e9 b4 00 00 00       	jmpq   140c <matchhere+0xdd>
  if(re[1] == '*')
    1358:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    135c:	48 83 c0 01          	add    $0x1,%rax
    1360:	0f b6 00             	movzbl (%rax),%eax
    1363:	3c 2a                	cmp    $0x2a,%al
    1365:	75 29                	jne    1390 <matchhere+0x61>
    return matchstar(re[0], re+2, text);
    1367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    136b:	48 8d 48 02          	lea    0x2(%rax),%rcx
    136f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1373:	0f b6 00             	movzbl (%rax),%eax
    1376:	0f be c0             	movsbl %al,%eax
    1379:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    137d:	48 89 ce             	mov    %rcx,%rsi
    1380:	89 c7                	mov    %eax,%edi
    1382:	48 b8 0e 14 00 00 00 	movabs $0x140e,%rax
    1389:	00 00 00 
    138c:	ff d0                	callq  *%rax
    138e:	eb 7c                	jmp    140c <matchhere+0xdd>
  if(re[0] == '$' && re[1] == '\0')
    1390:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1394:	0f b6 00             	movzbl (%rax),%eax
    1397:	3c 24                	cmp    $0x24,%al
    1399:	75 20                	jne    13bb <matchhere+0x8c>
    139b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    139f:	48 83 c0 01          	add    $0x1,%rax
    13a3:	0f b6 00             	movzbl (%rax),%eax
    13a6:	84 c0                	test   %al,%al
    13a8:	75 11                	jne    13bb <matchhere+0x8c>
    return *text == '\0';
    13aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    13ae:	0f b6 00             	movzbl (%rax),%eax
    13b1:	84 c0                	test   %al,%al
    13b3:	0f 94 c0             	sete   %al
    13b6:	0f b6 c0             	movzbl %al,%eax
    13b9:	eb 51                	jmp    140c <matchhere+0xdd>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    13bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    13bf:	0f b6 00             	movzbl (%rax),%eax
    13c2:	84 c0                	test   %al,%al
    13c4:	74 41                	je     1407 <matchhere+0xd8>
    13c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13ca:	0f b6 00             	movzbl (%rax),%eax
    13cd:	3c 2e                	cmp    $0x2e,%al
    13cf:	74 12                	je     13e3 <matchhere+0xb4>
    13d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13d5:	0f b6 10             	movzbl (%rax),%edx
    13d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    13dc:	0f b6 00             	movzbl (%rax),%eax
    13df:	38 c2                	cmp    %al,%dl
    13e1:	75 24                	jne    1407 <matchhere+0xd8>
    return matchhere(re+1, text+1);
    13e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    13e7:	48 8d 50 01          	lea    0x1(%rax),%rdx
    13eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13ef:	48 83 c0 01          	add    $0x1,%rax
    13f3:	48 89 d6             	mov    %rdx,%rsi
    13f6:	48 89 c7             	mov    %rax,%rdi
    13f9:	48 b8 2f 13 00 00 00 	movabs $0x132f,%rax
    1400:	00 00 00 
    1403:	ff d0                	callq  *%rax
    1405:	eb 05                	jmp    140c <matchhere+0xdd>
  return 0;
    1407:	b8 00 00 00 00       	mov    $0x0,%eax
}
    140c:	c9                   	leaveq 
    140d:	c3                   	retq   

000000000000140e <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
    140e:	f3 0f 1e fa          	endbr64 
    1412:	55                   	push   %rbp
    1413:	48 89 e5             	mov    %rsp,%rbp
    1416:	48 83 ec 20          	sub    $0x20,%rsp
    141a:	89 7d fc             	mov    %edi,-0x4(%rbp)
    141d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    1421:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
    1425:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1429:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    142d:	48 89 d6             	mov    %rdx,%rsi
    1430:	48 89 c7             	mov    %rax,%rdi
    1433:	48 b8 2f 13 00 00 00 	movabs $0x132f,%rax
    143a:	00 00 00 
    143d:	ff d0                	callq  *%rax
    143f:	85 c0                	test   %eax,%eax
    1441:	74 07                	je     144a <matchstar+0x3c>
      return 1;
    1443:	b8 01 00 00 00       	mov    $0x1,%eax
    1448:	eb 2d                	jmp    1477 <matchstar+0x69>
  }while(*text!='\0' && (*text++==c || c=='.'));
    144a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    144e:	0f b6 00             	movzbl (%rax),%eax
    1451:	84 c0                	test   %al,%al
    1453:	74 1d                	je     1472 <matchstar+0x64>
    1455:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1459:	48 8d 50 01          	lea    0x1(%rax),%rdx
    145d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1461:	0f b6 00             	movzbl (%rax),%eax
    1464:	0f be c0             	movsbl %al,%eax
    1467:	39 45 fc             	cmp    %eax,-0x4(%rbp)
    146a:	74 b9                	je     1425 <matchstar+0x17>
    146c:	83 7d fc 2e          	cmpl   $0x2e,-0x4(%rbp)
    1470:	74 b3                	je     1425 <matchstar+0x17>
  return 0;
    1472:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1477:	c9                   	leaveq 
    1478:	c3                   	retq   

0000000000001479 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1479:	f3 0f 1e fa          	endbr64 
    147d:	55                   	push   %rbp
    147e:	48 89 e5             	mov    %rsp,%rbp
    1481:	48 83 ec 10          	sub    $0x10,%rsp
    1485:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1489:	89 75 f4             	mov    %esi,-0xc(%rbp)
    148c:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    148f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1493:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1496:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1499:	48 89 ce             	mov    %rcx,%rsi
    149c:	48 89 f7             	mov    %rsi,%rdi
    149f:	89 d1                	mov    %edx,%ecx
    14a1:	fc                   	cld    
    14a2:	f3 aa                	rep stos %al,%es:(%rdi)
    14a4:	89 ca                	mov    %ecx,%edx
    14a6:	48 89 fe             	mov    %rdi,%rsi
    14a9:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    14ad:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    14b0:	90                   	nop
    14b1:	c9                   	leaveq 
    14b2:	c3                   	retq   

00000000000014b3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    14b3:	f3 0f 1e fa          	endbr64 
    14b7:	55                   	push   %rbp
    14b8:	48 89 e5             	mov    %rsp,%rbp
    14bb:	48 83 ec 20          	sub    $0x20,%rsp
    14bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    14c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    14c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    14cf:	90                   	nop
    14d0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    14d4:	48 8d 42 01          	lea    0x1(%rdx),%rax
    14d8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    14dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14e0:	48 8d 48 01          	lea    0x1(%rax),%rcx
    14e4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    14e8:	0f b6 12             	movzbl (%rdx),%edx
    14eb:	88 10                	mov    %dl,(%rax)
    14ed:	0f b6 00             	movzbl (%rax),%eax
    14f0:	84 c0                	test   %al,%al
    14f2:	75 dc                	jne    14d0 <strcpy+0x1d>
    ;
  return os;
    14f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    14f8:	c9                   	leaveq 
    14f9:	c3                   	retq   

00000000000014fa <strcmp>:

int
strcmp(const char *p, const char *q)
{
    14fa:	f3 0f 1e fa          	endbr64 
    14fe:	55                   	push   %rbp
    14ff:	48 89 e5             	mov    %rsp,%rbp
    1502:	48 83 ec 10          	sub    $0x10,%rsp
    1506:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    150a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    150e:	eb 0a                	jmp    151a <strcmp+0x20>
    p++, q++;
    1510:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1515:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    151a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    151e:	0f b6 00             	movzbl (%rax),%eax
    1521:	84 c0                	test   %al,%al
    1523:	74 12                	je     1537 <strcmp+0x3d>
    1525:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1529:	0f b6 10             	movzbl (%rax),%edx
    152c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1530:	0f b6 00             	movzbl (%rax),%eax
    1533:	38 c2                	cmp    %al,%dl
    1535:	74 d9                	je     1510 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1537:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    153b:	0f b6 00             	movzbl (%rax),%eax
    153e:	0f b6 d0             	movzbl %al,%edx
    1541:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1545:	0f b6 00             	movzbl (%rax),%eax
    1548:	0f b6 c0             	movzbl %al,%eax
    154b:	29 c2                	sub    %eax,%edx
    154d:	89 d0                	mov    %edx,%eax
}
    154f:	c9                   	leaveq 
    1550:	c3                   	retq   

0000000000001551 <strlen>:

uint
strlen(char *s)
{
    1551:	f3 0f 1e fa          	endbr64 
    1555:	55                   	push   %rbp
    1556:	48 89 e5             	mov    %rsp,%rbp
    1559:	48 83 ec 18          	sub    $0x18,%rsp
    155d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1561:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1568:	eb 04                	jmp    156e <strlen+0x1d>
    156a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    156e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1571:	48 63 d0             	movslq %eax,%rdx
    1574:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1578:	48 01 d0             	add    %rdx,%rax
    157b:	0f b6 00             	movzbl (%rax),%eax
    157e:	84 c0                	test   %al,%al
    1580:	75 e8                	jne    156a <strlen+0x19>
    ;
  return n;
    1582:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1585:	c9                   	leaveq 
    1586:	c3                   	retq   

0000000000001587 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1587:	f3 0f 1e fa          	endbr64 
    158b:	55                   	push   %rbp
    158c:	48 89 e5             	mov    %rsp,%rbp
    158f:	48 83 ec 10          	sub    $0x10,%rsp
    1593:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1597:	89 75 f4             	mov    %esi,-0xc(%rbp)
    159a:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    159d:	8b 55 f0             	mov    -0x10(%rbp),%edx
    15a0:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    15a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15a7:	89 ce                	mov    %ecx,%esi
    15a9:	48 89 c7             	mov    %rax,%rdi
    15ac:	48 b8 79 14 00 00 00 	movabs $0x1479,%rax
    15b3:	00 00 00 
    15b6:	ff d0                	callq  *%rax
  return dst;
    15b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    15bc:	c9                   	leaveq 
    15bd:	c3                   	retq   

00000000000015be <strchr>:

char*
strchr(const char *s, char c)
{
    15be:	f3 0f 1e fa          	endbr64 
    15c2:	55                   	push   %rbp
    15c3:	48 89 e5             	mov    %rsp,%rbp
    15c6:	48 83 ec 10          	sub    $0x10,%rsp
    15ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    15ce:	89 f0                	mov    %esi,%eax
    15d0:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    15d3:	eb 17                	jmp    15ec <strchr+0x2e>
    if(*s == c)
    15d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15d9:	0f b6 00             	movzbl (%rax),%eax
    15dc:	38 45 f4             	cmp    %al,-0xc(%rbp)
    15df:	75 06                	jne    15e7 <strchr+0x29>
      return (char*)s;
    15e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15e5:	eb 15                	jmp    15fc <strchr+0x3e>
  for(; *s; s++)
    15e7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    15ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15f0:	0f b6 00             	movzbl (%rax),%eax
    15f3:	84 c0                	test   %al,%al
    15f5:	75 de                	jne    15d5 <strchr+0x17>
  return 0;
    15f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
    15fc:	c9                   	leaveq 
    15fd:	c3                   	retq   

00000000000015fe <gets>:

char*
gets(char *buf, int max)
{
    15fe:	f3 0f 1e fa          	endbr64 
    1602:	55                   	push   %rbp
    1603:	48 89 e5             	mov    %rsp,%rbp
    1606:	48 83 ec 20          	sub    $0x20,%rsp
    160a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    160e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1611:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1618:	eb 4f                	jmp    1669 <gets+0x6b>
    cc = read(0, &c, 1);
    161a:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    161e:	ba 01 00 00 00       	mov    $0x1,%edx
    1623:	48 89 c6             	mov    %rax,%rsi
    1626:	bf 00 00 00 00       	mov    $0x0,%edi
    162b:	48 b8 e3 17 00 00 00 	movabs $0x17e3,%rax
    1632:	00 00 00 
    1635:	ff d0                	callq  *%rax
    1637:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    163a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    163e:	7e 36                	jle    1676 <gets+0x78>
      break;
    buf[i++] = c;
    1640:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1643:	8d 50 01             	lea    0x1(%rax),%edx
    1646:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1649:	48 63 d0             	movslq %eax,%rdx
    164c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1650:	48 01 c2             	add    %rax,%rdx
    1653:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1657:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1659:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    165d:	3c 0a                	cmp    $0xa,%al
    165f:	74 16                	je     1677 <gets+0x79>
    1661:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1665:	3c 0d                	cmp    $0xd,%al
    1667:	74 0e                	je     1677 <gets+0x79>
  for(i=0; i+1 < max; ){
    1669:	8b 45 fc             	mov    -0x4(%rbp),%eax
    166c:	83 c0 01             	add    $0x1,%eax
    166f:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    1672:	7f a6                	jg     161a <gets+0x1c>
    1674:	eb 01                	jmp    1677 <gets+0x79>
      break;
    1676:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1677:	8b 45 fc             	mov    -0x4(%rbp),%eax
    167a:	48 63 d0             	movslq %eax,%rdx
    167d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1681:	48 01 d0             	add    %rdx,%rax
    1684:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1687:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    168b:	c9                   	leaveq 
    168c:	c3                   	retq   

000000000000168d <stat>:

int
stat(char *n, struct stat *st)
{
    168d:	f3 0f 1e fa          	endbr64 
    1691:	55                   	push   %rbp
    1692:	48 89 e5             	mov    %rsp,%rbp
    1695:	48 83 ec 20          	sub    $0x20,%rsp
    1699:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    169d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    16a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    16a5:	be 00 00 00 00       	mov    $0x0,%esi
    16aa:	48 89 c7             	mov    %rax,%rdi
    16ad:	48 b8 24 18 00 00 00 	movabs $0x1824,%rax
    16b4:	00 00 00 
    16b7:	ff d0                	callq  *%rax
    16b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    16bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    16c0:	79 07                	jns    16c9 <stat+0x3c>
    return -1;
    16c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    16c7:	eb 2f                	jmp    16f8 <stat+0x6b>
  r = fstat(fd, st);
    16c9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    16cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16d0:	48 89 d6             	mov    %rdx,%rsi
    16d3:	89 c7                	mov    %eax,%edi
    16d5:	48 b8 4b 18 00 00 00 	movabs $0x184b,%rax
    16dc:	00 00 00 
    16df:	ff d0                	callq  *%rax
    16e1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    16e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16e7:	89 c7                	mov    %eax,%edi
    16e9:	48 b8 fd 17 00 00 00 	movabs $0x17fd,%rax
    16f0:	00 00 00 
    16f3:	ff d0                	callq  *%rax
  return r;
    16f5:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    16f8:	c9                   	leaveq 
    16f9:	c3                   	retq   

00000000000016fa <atoi>:

int
atoi(const char *s)
{
    16fa:	f3 0f 1e fa          	endbr64 
    16fe:	55                   	push   %rbp
    16ff:	48 89 e5             	mov    %rsp,%rbp
    1702:	48 83 ec 18          	sub    $0x18,%rsp
    1706:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    170a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1711:	eb 28                	jmp    173b <atoi+0x41>
    n = n*10 + *s++ - '0';
    1713:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1716:	89 d0                	mov    %edx,%eax
    1718:	c1 e0 02             	shl    $0x2,%eax
    171b:	01 d0                	add    %edx,%eax
    171d:	01 c0                	add    %eax,%eax
    171f:	89 c1                	mov    %eax,%ecx
    1721:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1725:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1729:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    172d:	0f b6 00             	movzbl (%rax),%eax
    1730:	0f be c0             	movsbl %al,%eax
    1733:	01 c8                	add    %ecx,%eax
    1735:	83 e8 30             	sub    $0x30,%eax
    1738:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    173b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    173f:	0f b6 00             	movzbl (%rax),%eax
    1742:	3c 2f                	cmp    $0x2f,%al
    1744:	7e 0b                	jle    1751 <atoi+0x57>
    1746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    174a:	0f b6 00             	movzbl (%rax),%eax
    174d:	3c 39                	cmp    $0x39,%al
    174f:	7e c2                	jle    1713 <atoi+0x19>
  return n;
    1751:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1754:	c9                   	leaveq 
    1755:	c3                   	retq   

0000000000001756 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1756:	f3 0f 1e fa          	endbr64 
    175a:	55                   	push   %rbp
    175b:	48 89 e5             	mov    %rsp,%rbp
    175e:	48 83 ec 28          	sub    $0x28,%rsp
    1762:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1766:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    176a:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    176d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1771:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1775:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1779:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    177d:	eb 1d                	jmp    179c <memmove+0x46>
    *dst++ = *src++;
    177f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1783:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1787:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    178b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    178f:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1793:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    1797:	0f b6 12             	movzbl (%rdx),%edx
    179a:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    179c:	8b 45 dc             	mov    -0x24(%rbp),%eax
    179f:	8d 50 ff             	lea    -0x1(%rax),%edx
    17a2:	89 55 dc             	mov    %edx,-0x24(%rbp)
    17a5:	85 c0                	test   %eax,%eax
    17a7:	7f d6                	jg     177f <memmove+0x29>
  return vdst;
    17a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    17ad:	c9                   	leaveq 
    17ae:	c3                   	retq   

00000000000017af <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    17af:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    17b6:	49 89 ca             	mov    %rcx,%r10
    17b9:	0f 05                	syscall 
    17bb:	c3                   	retq   

00000000000017bc <exit>:
SYSCALL(exit)
    17bc:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    17c3:	49 89 ca             	mov    %rcx,%r10
    17c6:	0f 05                	syscall 
    17c8:	c3                   	retq   

00000000000017c9 <wait>:
SYSCALL(wait)
    17c9:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    17d0:	49 89 ca             	mov    %rcx,%r10
    17d3:	0f 05                	syscall 
    17d5:	c3                   	retq   

00000000000017d6 <pipe>:
SYSCALL(pipe)
    17d6:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    17dd:	49 89 ca             	mov    %rcx,%r10
    17e0:	0f 05                	syscall 
    17e2:	c3                   	retq   

00000000000017e3 <read>:
SYSCALL(read)
    17e3:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    17ea:	49 89 ca             	mov    %rcx,%r10
    17ed:	0f 05                	syscall 
    17ef:	c3                   	retq   

00000000000017f0 <write>:
SYSCALL(write)
    17f0:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    17f7:	49 89 ca             	mov    %rcx,%r10
    17fa:	0f 05                	syscall 
    17fc:	c3                   	retq   

00000000000017fd <close>:
SYSCALL(close)
    17fd:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1804:	49 89 ca             	mov    %rcx,%r10
    1807:	0f 05                	syscall 
    1809:	c3                   	retq   

000000000000180a <kill>:
SYSCALL(kill)
    180a:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1811:	49 89 ca             	mov    %rcx,%r10
    1814:	0f 05                	syscall 
    1816:	c3                   	retq   

0000000000001817 <exec>:
SYSCALL(exec)
    1817:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    181e:	49 89 ca             	mov    %rcx,%r10
    1821:	0f 05                	syscall 
    1823:	c3                   	retq   

0000000000001824 <open>:
SYSCALL(open)
    1824:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    182b:	49 89 ca             	mov    %rcx,%r10
    182e:	0f 05                	syscall 
    1830:	c3                   	retq   

0000000000001831 <mknod>:
SYSCALL(mknod)
    1831:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1838:	49 89 ca             	mov    %rcx,%r10
    183b:	0f 05                	syscall 
    183d:	c3                   	retq   

000000000000183e <unlink>:
SYSCALL(unlink)
    183e:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1845:	49 89 ca             	mov    %rcx,%r10
    1848:	0f 05                	syscall 
    184a:	c3                   	retq   

000000000000184b <fstat>:
SYSCALL(fstat)
    184b:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1852:	49 89 ca             	mov    %rcx,%r10
    1855:	0f 05                	syscall 
    1857:	c3                   	retq   

0000000000001858 <link>:
SYSCALL(link)
    1858:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    185f:	49 89 ca             	mov    %rcx,%r10
    1862:	0f 05                	syscall 
    1864:	c3                   	retq   

0000000000001865 <mkdir>:
SYSCALL(mkdir)
    1865:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    186c:	49 89 ca             	mov    %rcx,%r10
    186f:	0f 05                	syscall 
    1871:	c3                   	retq   

0000000000001872 <chdir>:
SYSCALL(chdir)
    1872:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1879:	49 89 ca             	mov    %rcx,%r10
    187c:	0f 05                	syscall 
    187e:	c3                   	retq   

000000000000187f <dup>:
SYSCALL(dup)
    187f:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1886:	49 89 ca             	mov    %rcx,%r10
    1889:	0f 05                	syscall 
    188b:	c3                   	retq   

000000000000188c <getpid>:
SYSCALL(getpid)
    188c:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    1893:	49 89 ca             	mov    %rcx,%r10
    1896:	0f 05                	syscall 
    1898:	c3                   	retq   

0000000000001899 <sbrk>:
SYSCALL(sbrk)
    1899:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    18a0:	49 89 ca             	mov    %rcx,%r10
    18a3:	0f 05                	syscall 
    18a5:	c3                   	retq   

00000000000018a6 <sleep>:
SYSCALL(sleep)
    18a6:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    18ad:	49 89 ca             	mov    %rcx,%r10
    18b0:	0f 05                	syscall 
    18b2:	c3                   	retq   

00000000000018b3 <uptime>:
SYSCALL(uptime)
    18b3:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    18ba:	49 89 ca             	mov    %rcx,%r10
    18bd:	0f 05                	syscall 
    18bf:	c3                   	retq   

00000000000018c0 <dedup>:
SYSCALL(dedup)
    18c0:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    18c7:	49 89 ca             	mov    %rcx,%r10
    18ca:	0f 05                	syscall 
    18cc:	c3                   	retq   

00000000000018cd <freepages>:
SYSCALL(freepages)
    18cd:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    18d4:	49 89 ca             	mov    %rcx,%r10
    18d7:	0f 05                	syscall 
    18d9:	c3                   	retq   

00000000000018da <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    18da:	f3 0f 1e fa          	endbr64 
    18de:	55                   	push   %rbp
    18df:	48 89 e5             	mov    %rsp,%rbp
    18e2:	48 83 ec 10          	sub    $0x10,%rsp
    18e6:	89 7d fc             	mov    %edi,-0x4(%rbp)
    18e9:	89 f0                	mov    %esi,%eax
    18eb:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    18ee:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    18f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
    18f5:	ba 01 00 00 00       	mov    $0x1,%edx
    18fa:	48 89 ce             	mov    %rcx,%rsi
    18fd:	89 c7                	mov    %eax,%edi
    18ff:	48 b8 f0 17 00 00 00 	movabs $0x17f0,%rax
    1906:	00 00 00 
    1909:	ff d0                	callq  *%rax
}
    190b:	90                   	nop
    190c:	c9                   	leaveq 
    190d:	c3                   	retq   

000000000000190e <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    190e:	f3 0f 1e fa          	endbr64 
    1912:	55                   	push   %rbp
    1913:	48 89 e5             	mov    %rsp,%rbp
    1916:	48 83 ec 20          	sub    $0x20,%rsp
    191a:	89 7d ec             	mov    %edi,-0x14(%rbp)
    191d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1921:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1928:	eb 35                	jmp    195f <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    192a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    192e:	48 c1 e8 3c          	shr    $0x3c,%rax
    1932:	48 ba c0 25 00 00 00 	movabs $0x25c0,%rdx
    1939:	00 00 00 
    193c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1940:	0f be d0             	movsbl %al,%edx
    1943:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1946:	89 d6                	mov    %edx,%esi
    1948:	89 c7                	mov    %eax,%edi
    194a:	48 b8 da 18 00 00 00 	movabs $0x18da,%rax
    1951:	00 00 00 
    1954:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1956:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    195a:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    195f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1962:	83 f8 0f             	cmp    $0xf,%eax
    1965:	76 c3                	jbe    192a <print_x64+0x1c>
}
    1967:	90                   	nop
    1968:	90                   	nop
    1969:	c9                   	leaveq 
    196a:	c3                   	retq   

000000000000196b <print_x32>:

  static void
print_x32(int fd, uint x)
{
    196b:	f3 0f 1e fa          	endbr64 
    196f:	55                   	push   %rbp
    1970:	48 89 e5             	mov    %rsp,%rbp
    1973:	48 83 ec 20          	sub    $0x20,%rsp
    1977:	89 7d ec             	mov    %edi,-0x14(%rbp)
    197a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    197d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1984:	eb 36                	jmp    19bc <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1986:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1989:	c1 e8 1c             	shr    $0x1c,%eax
    198c:	89 c2                	mov    %eax,%edx
    198e:	48 b8 c0 25 00 00 00 	movabs $0x25c0,%rax
    1995:	00 00 00 
    1998:	89 d2                	mov    %edx,%edx
    199a:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    199e:	0f be d0             	movsbl %al,%edx
    19a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
    19a4:	89 d6                	mov    %edx,%esi
    19a6:	89 c7                	mov    %eax,%edi
    19a8:	48 b8 da 18 00 00 00 	movabs $0x18da,%rax
    19af:	00 00 00 
    19b2:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    19b4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    19b8:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    19bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    19bf:	83 f8 07             	cmp    $0x7,%eax
    19c2:	76 c2                	jbe    1986 <print_x32+0x1b>
}
    19c4:	90                   	nop
    19c5:	90                   	nop
    19c6:	c9                   	leaveq 
    19c7:	c3                   	retq   

00000000000019c8 <print_d>:

  static void
print_d(int fd, int v)
{
    19c8:	f3 0f 1e fa          	endbr64 
    19cc:	55                   	push   %rbp
    19cd:	48 89 e5             	mov    %rsp,%rbp
    19d0:	48 83 ec 30          	sub    $0x30,%rsp
    19d4:	89 7d dc             	mov    %edi,-0x24(%rbp)
    19d7:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    19da:	8b 45 d8             	mov    -0x28(%rbp),%eax
    19dd:	48 98                	cltq   
    19df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    19e3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    19e7:	79 04                	jns    19ed <print_d+0x25>
    x = -x;
    19e9:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    19ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    19f4:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    19f8:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    19ff:	66 66 66 
    1a02:	48 89 c8             	mov    %rcx,%rax
    1a05:	48 f7 ea             	imul   %rdx
    1a08:	48 c1 fa 02          	sar    $0x2,%rdx
    1a0c:	48 89 c8             	mov    %rcx,%rax
    1a0f:	48 c1 f8 3f          	sar    $0x3f,%rax
    1a13:	48 29 c2             	sub    %rax,%rdx
    1a16:	48 89 d0             	mov    %rdx,%rax
    1a19:	48 c1 e0 02          	shl    $0x2,%rax
    1a1d:	48 01 d0             	add    %rdx,%rax
    1a20:	48 01 c0             	add    %rax,%rax
    1a23:	48 29 c1             	sub    %rax,%rcx
    1a26:	48 89 ca             	mov    %rcx,%rdx
    1a29:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1a2c:	8d 48 01             	lea    0x1(%rax),%ecx
    1a2f:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1a32:	48 b9 c0 25 00 00 00 	movabs $0x25c0,%rcx
    1a39:	00 00 00 
    1a3c:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1a40:	48 98                	cltq   
    1a42:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1a46:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1a4a:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1a51:	66 66 66 
    1a54:	48 89 c8             	mov    %rcx,%rax
    1a57:	48 f7 ea             	imul   %rdx
    1a5a:	48 c1 fa 02          	sar    $0x2,%rdx
    1a5e:	48 89 c8             	mov    %rcx,%rax
    1a61:	48 c1 f8 3f          	sar    $0x3f,%rax
    1a65:	48 29 c2             	sub    %rax,%rdx
    1a68:	48 89 d0             	mov    %rdx,%rax
    1a6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1a6f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1a74:	0f 85 7a ff ff ff    	jne    19f4 <print_d+0x2c>

  if (v < 0)
    1a7a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1a7e:	79 32                	jns    1ab2 <print_d+0xea>
    buf[i++] = '-';
    1a80:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1a83:	8d 50 01             	lea    0x1(%rax),%edx
    1a86:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1a89:	48 98                	cltq   
    1a8b:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1a90:	eb 20                	jmp    1ab2 <print_d+0xea>
    putc(fd, buf[i]);
    1a92:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1a95:	48 98                	cltq   
    1a97:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1a9c:	0f be d0             	movsbl %al,%edx
    1a9f:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1aa2:	89 d6                	mov    %edx,%esi
    1aa4:	89 c7                	mov    %eax,%edi
    1aa6:	48 b8 da 18 00 00 00 	movabs $0x18da,%rax
    1aad:	00 00 00 
    1ab0:	ff d0                	callq  *%rax
  while (--i >= 0)
    1ab2:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1ab6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1aba:	79 d6                	jns    1a92 <print_d+0xca>
}
    1abc:	90                   	nop
    1abd:	90                   	nop
    1abe:	c9                   	leaveq 
    1abf:	c3                   	retq   

0000000000001ac0 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1ac0:	f3 0f 1e fa          	endbr64 
    1ac4:	55                   	push   %rbp
    1ac5:	48 89 e5             	mov    %rsp,%rbp
    1ac8:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1acf:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1ad5:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1adc:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1ae3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1aea:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1af1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1af8:	84 c0                	test   %al,%al
    1afa:	74 20                	je     1b1c <printf+0x5c>
    1afc:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1b00:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1b04:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1b08:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1b0c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1b10:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1b14:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1b18:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1b1c:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1b23:	00 00 00 
    1b26:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1b2d:	00 00 00 
    1b30:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1b34:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1b3b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1b42:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1b49:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1b50:	00 00 00 
    1b53:	e9 41 03 00 00       	jmpq   1e99 <printf+0x3d9>
    if (c != '%') {
    1b58:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1b5f:	74 24                	je     1b85 <printf+0xc5>
      putc(fd, c);
    1b61:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1b67:	0f be d0             	movsbl %al,%edx
    1b6a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b70:	89 d6                	mov    %edx,%esi
    1b72:	89 c7                	mov    %eax,%edi
    1b74:	48 b8 da 18 00 00 00 	movabs $0x18da,%rax
    1b7b:	00 00 00 
    1b7e:	ff d0                	callq  *%rax
      continue;
    1b80:	e9 0d 03 00 00       	jmpq   1e92 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1b85:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1b8c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1b92:	48 63 d0             	movslq %eax,%rdx
    1b95:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1b9c:	48 01 d0             	add    %rdx,%rax
    1b9f:	0f b6 00             	movzbl (%rax),%eax
    1ba2:	0f be c0             	movsbl %al,%eax
    1ba5:	25 ff 00 00 00       	and    $0xff,%eax
    1baa:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1bb0:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1bb7:	0f 84 0f 03 00 00    	je     1ecc <printf+0x40c>
      break;
    switch(c) {
    1bbd:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1bc4:	0f 84 74 02 00 00    	je     1e3e <printf+0x37e>
    1bca:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1bd1:	0f 8c 82 02 00 00    	jl     1e59 <printf+0x399>
    1bd7:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1bde:	0f 8f 75 02 00 00    	jg     1e59 <printf+0x399>
    1be4:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1beb:	0f 8c 68 02 00 00    	jl     1e59 <printf+0x399>
    1bf1:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1bf7:	83 e8 63             	sub    $0x63,%eax
    1bfa:	83 f8 15             	cmp    $0x15,%eax
    1bfd:	0f 87 56 02 00 00    	ja     1e59 <printf+0x399>
    1c03:	89 c0                	mov    %eax,%eax
    1c05:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1c0c:	00 
    1c0d:	48 b8 18 22 00 00 00 	movabs $0x2218,%rax
    1c14:	00 00 00 
    1c17:	48 01 d0             	add    %rdx,%rax
    1c1a:	48 8b 00             	mov    (%rax),%rax
    1c1d:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1c20:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1c26:	83 f8 2f             	cmp    $0x2f,%eax
    1c29:	77 23                	ja     1c4e <printf+0x18e>
    1c2b:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1c32:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c38:	89 d2                	mov    %edx,%edx
    1c3a:	48 01 d0             	add    %rdx,%rax
    1c3d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c43:	83 c2 08             	add    $0x8,%edx
    1c46:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1c4c:	eb 12                	jmp    1c60 <printf+0x1a0>
    1c4e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1c55:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1c59:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1c60:	8b 00                	mov    (%rax),%eax
    1c62:	0f be d0             	movsbl %al,%edx
    1c65:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c6b:	89 d6                	mov    %edx,%esi
    1c6d:	89 c7                	mov    %eax,%edi
    1c6f:	48 b8 da 18 00 00 00 	movabs $0x18da,%rax
    1c76:	00 00 00 
    1c79:	ff d0                	callq  *%rax
      break;
    1c7b:	e9 12 02 00 00       	jmpq   1e92 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1c80:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1c86:	83 f8 2f             	cmp    $0x2f,%eax
    1c89:	77 23                	ja     1cae <printf+0x1ee>
    1c8b:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1c92:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c98:	89 d2                	mov    %edx,%edx
    1c9a:	48 01 d0             	add    %rdx,%rax
    1c9d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ca3:	83 c2 08             	add    $0x8,%edx
    1ca6:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1cac:	eb 12                	jmp    1cc0 <printf+0x200>
    1cae:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1cb5:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1cb9:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1cc0:	8b 10                	mov    (%rax),%edx
    1cc2:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1cc8:	89 d6                	mov    %edx,%esi
    1cca:	89 c7                	mov    %eax,%edi
    1ccc:	48 b8 c8 19 00 00 00 	movabs $0x19c8,%rax
    1cd3:	00 00 00 
    1cd6:	ff d0                	callq  *%rax
      break;
    1cd8:	e9 b5 01 00 00       	jmpq   1e92 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1cdd:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1ce3:	83 f8 2f             	cmp    $0x2f,%eax
    1ce6:	77 23                	ja     1d0b <printf+0x24b>
    1ce8:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1cef:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1cf5:	89 d2                	mov    %edx,%edx
    1cf7:	48 01 d0             	add    %rdx,%rax
    1cfa:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d00:	83 c2 08             	add    $0x8,%edx
    1d03:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1d09:	eb 12                	jmp    1d1d <printf+0x25d>
    1d0b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1d12:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1d16:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1d1d:	8b 10                	mov    (%rax),%edx
    1d1f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1d25:	89 d6                	mov    %edx,%esi
    1d27:	89 c7                	mov    %eax,%edi
    1d29:	48 b8 6b 19 00 00 00 	movabs $0x196b,%rax
    1d30:	00 00 00 
    1d33:	ff d0                	callq  *%rax
      break;
    1d35:	e9 58 01 00 00       	jmpq   1e92 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1d3a:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1d40:	83 f8 2f             	cmp    $0x2f,%eax
    1d43:	77 23                	ja     1d68 <printf+0x2a8>
    1d45:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1d4c:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d52:	89 d2                	mov    %edx,%edx
    1d54:	48 01 d0             	add    %rdx,%rax
    1d57:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d5d:	83 c2 08             	add    $0x8,%edx
    1d60:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1d66:	eb 12                	jmp    1d7a <printf+0x2ba>
    1d68:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1d6f:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1d73:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1d7a:	48 8b 10             	mov    (%rax),%rdx
    1d7d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1d83:	48 89 d6             	mov    %rdx,%rsi
    1d86:	89 c7                	mov    %eax,%edi
    1d88:	48 b8 0e 19 00 00 00 	movabs $0x190e,%rax
    1d8f:	00 00 00 
    1d92:	ff d0                	callq  *%rax
      break;
    1d94:	e9 f9 00 00 00       	jmpq   1e92 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1d99:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1d9f:	83 f8 2f             	cmp    $0x2f,%eax
    1da2:	77 23                	ja     1dc7 <printf+0x307>
    1da4:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1dab:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1db1:	89 d2                	mov    %edx,%edx
    1db3:	48 01 d0             	add    %rdx,%rax
    1db6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1dbc:	83 c2 08             	add    $0x8,%edx
    1dbf:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1dc5:	eb 12                	jmp    1dd9 <printf+0x319>
    1dc7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1dce:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1dd2:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1dd9:	48 8b 00             	mov    (%rax),%rax
    1ddc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1de3:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1dea:	00 
    1deb:	75 41                	jne    1e2e <printf+0x36e>
        s = "(null)";
    1ded:	48 b8 10 22 00 00 00 	movabs $0x2210,%rax
    1df4:	00 00 00 
    1df7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1dfe:	eb 2e                	jmp    1e2e <printf+0x36e>
        putc(fd, *(s++));
    1e00:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1e07:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1e0b:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1e12:	0f b6 00             	movzbl (%rax),%eax
    1e15:	0f be d0             	movsbl %al,%edx
    1e18:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e1e:	89 d6                	mov    %edx,%esi
    1e20:	89 c7                	mov    %eax,%edi
    1e22:	48 b8 da 18 00 00 00 	movabs $0x18da,%rax
    1e29:	00 00 00 
    1e2c:	ff d0                	callq  *%rax
      while (*s)
    1e2e:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1e35:	0f b6 00             	movzbl (%rax),%eax
    1e38:	84 c0                	test   %al,%al
    1e3a:	75 c4                	jne    1e00 <printf+0x340>
      break;
    1e3c:	eb 54                	jmp    1e92 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1e3e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e44:	be 25 00 00 00       	mov    $0x25,%esi
    1e49:	89 c7                	mov    %eax,%edi
    1e4b:	48 b8 da 18 00 00 00 	movabs $0x18da,%rax
    1e52:	00 00 00 
    1e55:	ff d0                	callq  *%rax
      break;
    1e57:	eb 39                	jmp    1e92 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1e59:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e5f:	be 25 00 00 00       	mov    $0x25,%esi
    1e64:	89 c7                	mov    %eax,%edi
    1e66:	48 b8 da 18 00 00 00 	movabs $0x18da,%rax
    1e6d:	00 00 00 
    1e70:	ff d0                	callq  *%rax
      putc(fd, c);
    1e72:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1e78:	0f be d0             	movsbl %al,%edx
    1e7b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e81:	89 d6                	mov    %edx,%esi
    1e83:	89 c7                	mov    %eax,%edi
    1e85:	48 b8 da 18 00 00 00 	movabs $0x18da,%rax
    1e8c:	00 00 00 
    1e8f:	ff d0                	callq  *%rax
      break;
    1e91:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1e92:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1e99:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1e9f:	48 63 d0             	movslq %eax,%rdx
    1ea2:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1ea9:	48 01 d0             	add    %rdx,%rax
    1eac:	0f b6 00             	movzbl (%rax),%eax
    1eaf:	0f be c0             	movsbl %al,%eax
    1eb2:	25 ff 00 00 00       	and    $0xff,%eax
    1eb7:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1ebd:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1ec4:	0f 85 8e fc ff ff    	jne    1b58 <printf+0x98>
    }
  }
}
    1eca:	eb 01                	jmp    1ecd <printf+0x40d>
      break;
    1ecc:	90                   	nop
}
    1ecd:	90                   	nop
    1ece:	c9                   	leaveq 
    1ecf:	c3                   	retq   

0000000000001ed0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1ed0:	f3 0f 1e fa          	endbr64 
    1ed4:	55                   	push   %rbp
    1ed5:	48 89 e5             	mov    %rsp,%rbp
    1ed8:	48 83 ec 18          	sub    $0x18,%rsp
    1edc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1ee0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1ee4:	48 83 e8 10          	sub    $0x10,%rax
    1ee8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1eec:	48 b8 f0 29 00 00 00 	movabs $0x29f0,%rax
    1ef3:	00 00 00 
    1ef6:	48 8b 00             	mov    (%rax),%rax
    1ef9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1efd:	eb 2f                	jmp    1f2e <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1eff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f03:	48 8b 00             	mov    (%rax),%rax
    1f06:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f0a:	72 17                	jb     1f23 <free+0x53>
    1f0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f10:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1f14:	77 2f                	ja     1f45 <free+0x75>
    1f16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f1a:	48 8b 00             	mov    (%rax),%rax
    1f1d:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1f21:	72 22                	jb     1f45 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1f23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f27:	48 8b 00             	mov    (%rax),%rax
    1f2a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f32:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1f36:	76 c7                	jbe    1eff <free+0x2f>
    1f38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f3c:	48 8b 00             	mov    (%rax),%rax
    1f3f:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1f43:	73 ba                	jae    1eff <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1f45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f49:	8b 40 08             	mov    0x8(%rax),%eax
    1f4c:	89 c0                	mov    %eax,%eax
    1f4e:	48 c1 e0 04          	shl    $0x4,%rax
    1f52:	48 89 c2             	mov    %rax,%rdx
    1f55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f59:	48 01 c2             	add    %rax,%rdx
    1f5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f60:	48 8b 00             	mov    (%rax),%rax
    1f63:	48 39 c2             	cmp    %rax,%rdx
    1f66:	75 2d                	jne    1f95 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1f68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f6c:	8b 50 08             	mov    0x8(%rax),%edx
    1f6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f73:	48 8b 00             	mov    (%rax),%rax
    1f76:	8b 40 08             	mov    0x8(%rax),%eax
    1f79:	01 c2                	add    %eax,%edx
    1f7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f7f:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1f82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f86:	48 8b 00             	mov    (%rax),%rax
    1f89:	48 8b 10             	mov    (%rax),%rdx
    1f8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f90:	48 89 10             	mov    %rdx,(%rax)
    1f93:	eb 0e                	jmp    1fa3 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1f95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f99:	48 8b 10             	mov    (%rax),%rdx
    1f9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fa0:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1fa3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fa7:	8b 40 08             	mov    0x8(%rax),%eax
    1faa:	89 c0                	mov    %eax,%eax
    1fac:	48 c1 e0 04          	shl    $0x4,%rax
    1fb0:	48 89 c2             	mov    %rax,%rdx
    1fb3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fb7:	48 01 d0             	add    %rdx,%rax
    1fba:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1fbe:	75 27                	jne    1fe7 <free+0x117>
    p->s.size += bp->s.size;
    1fc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fc4:	8b 50 08             	mov    0x8(%rax),%edx
    1fc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fcb:	8b 40 08             	mov    0x8(%rax),%eax
    1fce:	01 c2                	add    %eax,%edx
    1fd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fd4:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1fd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fdb:	48 8b 10             	mov    (%rax),%rdx
    1fde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fe2:	48 89 10             	mov    %rdx,(%rax)
    1fe5:	eb 0b                	jmp    1ff2 <free+0x122>
  } else
    p->s.ptr = bp;
    1fe7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1feb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1fef:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1ff2:	48 ba f0 29 00 00 00 	movabs $0x29f0,%rdx
    1ff9:	00 00 00 
    1ffc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2000:	48 89 02             	mov    %rax,(%rdx)
}
    2003:	90                   	nop
    2004:	c9                   	leaveq 
    2005:	c3                   	retq   

0000000000002006 <morecore>:

static Header*
morecore(uint nu)
{
    2006:	f3 0f 1e fa          	endbr64 
    200a:	55                   	push   %rbp
    200b:	48 89 e5             	mov    %rsp,%rbp
    200e:	48 83 ec 20          	sub    $0x20,%rsp
    2012:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    2015:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    201c:	77 07                	ja     2025 <morecore+0x1f>
    nu = 4096;
    201e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    2025:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2028:	48 c1 e0 04          	shl    $0x4,%rax
    202c:	48 89 c7             	mov    %rax,%rdi
    202f:	48 b8 99 18 00 00 00 	movabs $0x1899,%rax
    2036:	00 00 00 
    2039:	ff d0                	callq  *%rax
    203b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    203f:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    2044:	75 07                	jne    204d <morecore+0x47>
    return 0;
    2046:	b8 00 00 00 00       	mov    $0x0,%eax
    204b:	eb 36                	jmp    2083 <morecore+0x7d>
  hp = (Header*)p;
    204d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2051:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    2055:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2059:	8b 55 ec             	mov    -0x14(%rbp),%edx
    205c:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    205f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2063:	48 83 c0 10          	add    $0x10,%rax
    2067:	48 89 c7             	mov    %rax,%rdi
    206a:	48 b8 d0 1e 00 00 00 	movabs $0x1ed0,%rax
    2071:	00 00 00 
    2074:	ff d0                	callq  *%rax
  return freep;
    2076:	48 b8 f0 29 00 00 00 	movabs $0x29f0,%rax
    207d:	00 00 00 
    2080:	48 8b 00             	mov    (%rax),%rax
}
    2083:	c9                   	leaveq 
    2084:	c3                   	retq   

0000000000002085 <malloc>:

void*
malloc(uint nbytes)
{
    2085:	f3 0f 1e fa          	endbr64 
    2089:	55                   	push   %rbp
    208a:	48 89 e5             	mov    %rsp,%rbp
    208d:	48 83 ec 30          	sub    $0x30,%rsp
    2091:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    2094:	8b 45 dc             	mov    -0x24(%rbp),%eax
    2097:	48 83 c0 0f          	add    $0xf,%rax
    209b:	48 c1 e8 04          	shr    $0x4,%rax
    209f:	83 c0 01             	add    $0x1,%eax
    20a2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    20a5:	48 b8 f0 29 00 00 00 	movabs $0x29f0,%rax
    20ac:	00 00 00 
    20af:	48 8b 00             	mov    (%rax),%rax
    20b2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    20b6:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    20bb:	75 4a                	jne    2107 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    20bd:	48 b8 e0 29 00 00 00 	movabs $0x29e0,%rax
    20c4:	00 00 00 
    20c7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    20cb:	48 ba f0 29 00 00 00 	movabs $0x29f0,%rdx
    20d2:	00 00 00 
    20d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    20d9:	48 89 02             	mov    %rax,(%rdx)
    20dc:	48 b8 f0 29 00 00 00 	movabs $0x29f0,%rax
    20e3:	00 00 00 
    20e6:	48 8b 00             	mov    (%rax),%rax
    20e9:	48 ba e0 29 00 00 00 	movabs $0x29e0,%rdx
    20f0:	00 00 00 
    20f3:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    20f6:	48 b8 e0 29 00 00 00 	movabs $0x29e0,%rax
    20fd:	00 00 00 
    2100:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2107:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    210b:	48 8b 00             	mov    (%rax),%rax
    210e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    2112:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2116:	8b 40 08             	mov    0x8(%rax),%eax
    2119:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    211c:	77 65                	ja     2183 <malloc+0xfe>
      if(p->s.size == nunits)
    211e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2122:	8b 40 08             	mov    0x8(%rax),%eax
    2125:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    2128:	75 10                	jne    213a <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    212a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    212e:	48 8b 10             	mov    (%rax),%rdx
    2131:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2135:	48 89 10             	mov    %rdx,(%rax)
    2138:	eb 2e                	jmp    2168 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    213a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    213e:	8b 40 08             	mov    0x8(%rax),%eax
    2141:	2b 45 ec             	sub    -0x14(%rbp),%eax
    2144:	89 c2                	mov    %eax,%edx
    2146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    214a:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    214d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2151:	8b 40 08             	mov    0x8(%rax),%eax
    2154:	89 c0                	mov    %eax,%eax
    2156:	48 c1 e0 04          	shl    $0x4,%rax
    215a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    215e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2162:	8b 55 ec             	mov    -0x14(%rbp),%edx
    2165:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    2168:	48 ba f0 29 00 00 00 	movabs $0x29f0,%rdx
    216f:	00 00 00 
    2172:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2176:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    2179:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    217d:	48 83 c0 10          	add    $0x10,%rax
    2181:	eb 4e                	jmp    21d1 <malloc+0x14c>
    }
    if(p == freep)
    2183:	48 b8 f0 29 00 00 00 	movabs $0x29f0,%rax
    218a:	00 00 00 
    218d:	48 8b 00             	mov    (%rax),%rax
    2190:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    2194:	75 23                	jne    21b9 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    2196:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2199:	89 c7                	mov    %eax,%edi
    219b:	48 b8 06 20 00 00 00 	movabs $0x2006,%rax
    21a2:	00 00 00 
    21a5:	ff d0                	callq  *%rax
    21a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    21ab:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    21b0:	75 07                	jne    21b9 <malloc+0x134>
        return 0;
    21b2:	b8 00 00 00 00       	mov    $0x0,%eax
    21b7:	eb 18                	jmp    21d1 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    21b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    21c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21c5:	48 8b 00             	mov    (%rax),%rax
    21c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    21cc:	e9 41 ff ff ff       	jmpq   2112 <malloc+0x8d>
  }
}
    21d1:	c9                   	leaveq 
    21d2:	c3                   	retq   
