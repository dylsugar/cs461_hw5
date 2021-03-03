
_usertests:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <failexit>:
char name[3];
char *echoargv[] = { "echo", "ALL", "TESTS", "PASSED", 0 };

void
failexit(const char * const msg)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 10          	sub    $0x10,%rsp
    100c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  printf(1, "!! FAILED %s\n", msg);
    1010:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1014:	48 89 c2             	mov    %rax,%rdx
    1017:	48 be 3e 6d 00 00 00 	movabs $0x6d3e,%rsi
    101e:	00 00 00 
    1021:	bf 01 00 00 00       	mov    $0x1,%edi
    1026:	b8 00 00 00 00       	mov    $0x0,%eax
    102b:	48 b9 11 66 00 00 00 	movabs $0x6611,%rcx
    1032:	00 00 00 
    1035:	ff d1                	callq  *%rcx
  exit();
    1037:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    103e:	00 00 00 
    1041:	ff d0                	callq  *%rax

0000000000001043 <iputtest>:
}

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
    1043:	f3 0f 1e fa          	endbr64 
    1047:	55                   	push   %rbp
    1048:	48 89 e5             	mov    %rsp,%rbp
  printf(1, "iput test\n");
    104b:	48 be 4c 6d 00 00 00 	movabs $0x6d4c,%rsi
    1052:	00 00 00 
    1055:	bf 01 00 00 00       	mov    $0x1,%edi
    105a:	b8 00 00 00 00       	mov    $0x0,%eax
    105f:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    1066:	00 00 00 
    1069:	ff d2                	callq  *%rdx

  if(mkdir("iputdir") < 0){
    106b:	48 bf 57 6d 00 00 00 	movabs $0x6d57,%rdi
    1072:	00 00 00 
    1075:	48 b8 b6 63 00 00 00 	movabs $0x63b6,%rax
    107c:	00 00 00 
    107f:	ff d0                	callq  *%rax
    1081:	85 c0                	test   %eax,%eax
    1083:	79 16                	jns    109b <iputtest+0x58>
    failexit("mkdir");
    1085:	48 bf 5f 6d 00 00 00 	movabs $0x6d5f,%rdi
    108c:	00 00 00 
    108f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1096:	00 00 00 
    1099:	ff d0                	callq  *%rax
  }
  if(chdir("iputdir") < 0){
    109b:	48 bf 57 6d 00 00 00 	movabs $0x6d57,%rdi
    10a2:	00 00 00 
    10a5:	48 b8 c3 63 00 00 00 	movabs $0x63c3,%rax
    10ac:	00 00 00 
    10af:	ff d0                	callq  *%rax
    10b1:	85 c0                	test   %eax,%eax
    10b3:	79 16                	jns    10cb <iputtest+0x88>
    failexit("chdir iputdir");
    10b5:	48 bf 65 6d 00 00 00 	movabs $0x6d65,%rdi
    10bc:	00 00 00 
    10bf:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    10c6:	00 00 00 
    10c9:	ff d0                	callq  *%rax
  }
  if(unlink("../iputdir") < 0){
    10cb:	48 bf 73 6d 00 00 00 	movabs $0x6d73,%rdi
    10d2:	00 00 00 
    10d5:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    10dc:	00 00 00 
    10df:	ff d0                	callq  *%rax
    10e1:	85 c0                	test   %eax,%eax
    10e3:	79 16                	jns    10fb <iputtest+0xb8>
    failexit("unlink ../iputdir");
    10e5:	48 bf 7e 6d 00 00 00 	movabs $0x6d7e,%rdi
    10ec:	00 00 00 
    10ef:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    10f6:	00 00 00 
    10f9:	ff d0                	callq  *%rax
  }
  if(chdir("/") < 0){
    10fb:	48 bf 90 6d 00 00 00 	movabs $0x6d90,%rdi
    1102:	00 00 00 
    1105:	48 b8 c3 63 00 00 00 	movabs $0x63c3,%rax
    110c:	00 00 00 
    110f:	ff d0                	callq  *%rax
    1111:	85 c0                	test   %eax,%eax
    1113:	79 16                	jns    112b <iputtest+0xe8>
    failexit("chdir /");
    1115:	48 bf 92 6d 00 00 00 	movabs $0x6d92,%rdi
    111c:	00 00 00 
    111f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1126:	00 00 00 
    1129:	ff d0                	callq  *%rax
  }
  printf(1, "iput test ok\n");
    112b:	48 be 9a 6d 00 00 00 	movabs $0x6d9a,%rsi
    1132:	00 00 00 
    1135:	bf 01 00 00 00       	mov    $0x1,%edi
    113a:	b8 00 00 00 00       	mov    $0x0,%eax
    113f:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    1146:	00 00 00 
    1149:	ff d2                	callq  *%rdx
}
    114b:	90                   	nop
    114c:	5d                   	pop    %rbp
    114d:	c3                   	retq   

000000000000114e <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
    114e:	f3 0f 1e fa          	endbr64 
    1152:	55                   	push   %rbp
    1153:	48 89 e5             	mov    %rsp,%rbp
    1156:	48 83 ec 10          	sub    $0x10,%rsp
  int pid;

  printf(1, "exitiput test\n");
    115a:	48 be a8 6d 00 00 00 	movabs $0x6da8,%rsi
    1161:	00 00 00 
    1164:	bf 01 00 00 00       	mov    $0x1,%edi
    1169:	b8 00 00 00 00       	mov    $0x0,%eax
    116e:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    1175:	00 00 00 
    1178:	ff d2                	callq  *%rdx

  pid = fork();
    117a:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    1181:	00 00 00 
    1184:	ff d0                	callq  *%rax
    1186:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(pid < 0){
    1189:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    118d:	79 16                	jns    11a5 <exitiputtest+0x57>
    failexit("fork");
    118f:	48 bf b7 6d 00 00 00 	movabs $0x6db7,%rdi
    1196:	00 00 00 
    1199:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    11a0:	00 00 00 
    11a3:	ff d0                	callq  *%rax
  }
  if(pid == 0){
    11a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    11a9:	0f 85 9c 00 00 00    	jne    124b <exitiputtest+0xfd>
    if(mkdir("iputdir") < 0){
    11af:	48 bf 57 6d 00 00 00 	movabs $0x6d57,%rdi
    11b6:	00 00 00 
    11b9:	48 b8 b6 63 00 00 00 	movabs $0x63b6,%rax
    11c0:	00 00 00 
    11c3:	ff d0                	callq  *%rax
    11c5:	85 c0                	test   %eax,%eax
    11c7:	79 16                	jns    11df <exitiputtest+0x91>
      failexit("mkdir");
    11c9:	48 bf 5f 6d 00 00 00 	movabs $0x6d5f,%rdi
    11d0:	00 00 00 
    11d3:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    11da:	00 00 00 
    11dd:	ff d0                	callq  *%rax
    }
    if(chdir("iputdir") < 0){
    11df:	48 bf 57 6d 00 00 00 	movabs $0x6d57,%rdi
    11e6:	00 00 00 
    11e9:	48 b8 c3 63 00 00 00 	movabs $0x63c3,%rax
    11f0:	00 00 00 
    11f3:	ff d0                	callq  *%rax
    11f5:	85 c0                	test   %eax,%eax
    11f7:	79 16                	jns    120f <exitiputtest+0xc1>
      failexit("child chdir");
    11f9:	48 bf bc 6d 00 00 00 	movabs $0x6dbc,%rdi
    1200:	00 00 00 
    1203:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    120a:	00 00 00 
    120d:	ff d0                	callq  *%rax
    }
    if(unlink("../iputdir") < 0){
    120f:	48 bf 73 6d 00 00 00 	movabs $0x6d73,%rdi
    1216:	00 00 00 
    1219:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    1220:	00 00 00 
    1223:	ff d0                	callq  *%rax
    1225:	85 c0                	test   %eax,%eax
    1227:	79 16                	jns    123f <exitiputtest+0xf1>
      failexit("unlink ../iputdir");
    1229:	48 bf 7e 6d 00 00 00 	movabs $0x6d7e,%rdi
    1230:	00 00 00 
    1233:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    123a:	00 00 00 
    123d:	ff d0                	callq  *%rax
    }
    exit();
    123f:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    1246:	00 00 00 
    1249:	ff d0                	callq  *%rax
  }
  wait();
    124b:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    1252:	00 00 00 
    1255:	ff d0                	callq  *%rax
  printf(1, "exitiput test ok\n");
    1257:	48 be c8 6d 00 00 00 	movabs $0x6dc8,%rsi
    125e:	00 00 00 
    1261:	bf 01 00 00 00       	mov    $0x1,%edi
    1266:	b8 00 00 00 00       	mov    $0x0,%eax
    126b:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    1272:	00 00 00 
    1275:	ff d2                	callq  *%rdx
}
    1277:	90                   	nop
    1278:	c9                   	leaveq 
    1279:	c3                   	retq   

000000000000127a <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
    127a:	f3 0f 1e fa          	endbr64 
    127e:	55                   	push   %rbp
    127f:	48 89 e5             	mov    %rsp,%rbp
    1282:	48 83 ec 10          	sub    $0x10,%rsp
  int pid;

  printf(1, "openiput test\n");
    1286:	48 be da 6d 00 00 00 	movabs $0x6dda,%rsi
    128d:	00 00 00 
    1290:	bf 01 00 00 00       	mov    $0x1,%edi
    1295:	b8 00 00 00 00       	mov    $0x0,%eax
    129a:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    12a1:	00 00 00 
    12a4:	ff d2                	callq  *%rdx
  if(mkdir("oidir") < 0){
    12a6:	48 bf e9 6d 00 00 00 	movabs $0x6de9,%rdi
    12ad:	00 00 00 
    12b0:	48 b8 b6 63 00 00 00 	movabs $0x63b6,%rax
    12b7:	00 00 00 
    12ba:	ff d0                	callq  *%rax
    12bc:	85 c0                	test   %eax,%eax
    12be:	79 16                	jns    12d6 <openiputtest+0x5c>
    failexit("mkdir oidir");
    12c0:	48 bf ef 6d 00 00 00 	movabs $0x6def,%rdi
    12c7:	00 00 00 
    12ca:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    12d1:	00 00 00 
    12d4:	ff d0                	callq  *%rax
  }
  pid = fork();
    12d6:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    12dd:	00 00 00 
    12e0:	ff d0                	callq  *%rax
    12e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(pid < 0){
    12e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    12e9:	79 16                	jns    1301 <openiputtest+0x87>
    failexit("fork");
    12eb:	48 bf b7 6d 00 00 00 	movabs $0x6db7,%rdi
    12f2:	00 00 00 
    12f5:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    12fc:	00 00 00 
    12ff:	ff d0                	callq  *%rax
  }
  if(pid == 0){
    1301:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1305:	75 46                	jne    134d <openiputtest+0xd3>
    int fd = open("oidir", O_RDWR);
    1307:	be 02 00 00 00       	mov    $0x2,%esi
    130c:	48 bf e9 6d 00 00 00 	movabs $0x6de9,%rdi
    1313:	00 00 00 
    1316:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    131d:	00 00 00 
    1320:	ff d0                	callq  *%rax
    1322:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(fd >= 0){
    1325:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1329:	78 16                	js     1341 <openiputtest+0xc7>
      failexit("open directory for write succeeded");
    132b:	48 bf 00 6e 00 00 00 	movabs $0x6e00,%rdi
    1332:	00 00 00 
    1335:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    133c:	00 00 00 
    133f:	ff d0                	callq  *%rax
    }
    exit();
    1341:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    1348:	00 00 00 
    134b:	ff d0                	callq  *%rax
  }
  sleep(1);
    134d:	bf 01 00 00 00       	mov    $0x1,%edi
    1352:	48 b8 f7 63 00 00 00 	movabs $0x63f7,%rax
    1359:	00 00 00 
    135c:	ff d0                	callq  *%rax
  if(unlink("oidir") != 0){
    135e:	48 bf e9 6d 00 00 00 	movabs $0x6de9,%rdi
    1365:	00 00 00 
    1368:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    136f:	00 00 00 
    1372:	ff d0                	callq  *%rax
    1374:	85 c0                	test   %eax,%eax
    1376:	74 16                	je     138e <openiputtest+0x114>
    failexit("unlink");
    1378:	48 bf 23 6e 00 00 00 	movabs $0x6e23,%rdi
    137f:	00 00 00 
    1382:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1389:	00 00 00 
    138c:	ff d0                	callq  *%rax
  }
  wait();
    138e:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    1395:	00 00 00 
    1398:	ff d0                	callq  *%rax
  printf(1, "openiput test ok\n");
    139a:	48 be 2a 6e 00 00 00 	movabs $0x6e2a,%rsi
    13a1:	00 00 00 
    13a4:	bf 01 00 00 00       	mov    $0x1,%edi
    13a9:	b8 00 00 00 00       	mov    $0x0,%eax
    13ae:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    13b5:	00 00 00 
    13b8:	ff d2                	callq  *%rdx
}
    13ba:	90                   	nop
    13bb:	c9                   	leaveq 
    13bc:	c3                   	retq   

00000000000013bd <opentest>:

// simple file system tests

void
opentest(void)
{
    13bd:	f3 0f 1e fa          	endbr64 
    13c1:	55                   	push   %rbp
    13c2:	48 89 e5             	mov    %rsp,%rbp
    13c5:	48 83 ec 10          	sub    $0x10,%rsp
  int fd;

  printf(1, "open test\n");
    13c9:	48 be 3c 6e 00 00 00 	movabs $0x6e3c,%rsi
    13d0:	00 00 00 
    13d3:	bf 01 00 00 00       	mov    $0x1,%edi
    13d8:	b8 00 00 00 00       	mov    $0x0,%eax
    13dd:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    13e4:	00 00 00 
    13e7:	ff d2                	callq  *%rdx
  fd = open("echo", 0);
    13e9:	be 00 00 00 00       	mov    $0x0,%esi
    13ee:	48 bf 28 6d 00 00 00 	movabs $0x6d28,%rdi
    13f5:	00 00 00 
    13f8:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    13ff:	00 00 00 
    1402:	ff d0                	callq  *%rax
    1404:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    1407:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    140b:	79 16                	jns    1423 <opentest+0x66>
    failexit("open echo");
    140d:	48 bf 47 6e 00 00 00 	movabs $0x6e47,%rdi
    1414:	00 00 00 
    1417:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    141e:	00 00 00 
    1421:	ff d0                	callq  *%rax
  }
  close(fd);
    1423:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1426:	89 c7                	mov    %eax,%edi
    1428:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    142f:	00 00 00 
    1432:	ff d0                	callq  *%rax
  fd = open("doesnotexist", 0);
    1434:	be 00 00 00 00       	mov    $0x0,%esi
    1439:	48 bf 51 6e 00 00 00 	movabs $0x6e51,%rdi
    1440:	00 00 00 
    1443:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    144a:	00 00 00 
    144d:	ff d0                	callq  *%rax
    144f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd >= 0){
    1452:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1456:	78 16                	js     146e <opentest+0xb1>
    failexit("open doesnotexist succeeded!");
    1458:	48 bf 5e 6e 00 00 00 	movabs $0x6e5e,%rdi
    145f:	00 00 00 
    1462:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1469:	00 00 00 
    146c:	ff d0                	callq  *%rax
  }
  printf(1, "open test ok\n");
    146e:	48 be 7b 6e 00 00 00 	movabs $0x6e7b,%rsi
    1475:	00 00 00 
    1478:	bf 01 00 00 00       	mov    $0x1,%edi
    147d:	b8 00 00 00 00       	mov    $0x0,%eax
    1482:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    1489:	00 00 00 
    148c:	ff d2                	callq  *%rdx
}
    148e:	90                   	nop
    148f:	c9                   	leaveq 
    1490:	c3                   	retq   

0000000000001491 <writetest>:

void
writetest(void)
{
    1491:	f3 0f 1e fa          	endbr64 
    1495:	55                   	push   %rbp
    1496:	48 89 e5             	mov    %rsp,%rbp
    1499:	48 83 ec 10          	sub    $0x10,%rsp
  int fd;
  int i;

  printf(1, "small file test\n");
    149d:	48 be 89 6e 00 00 00 	movabs $0x6e89,%rsi
    14a4:	00 00 00 
    14a7:	bf 01 00 00 00       	mov    $0x1,%edi
    14ac:	b8 00 00 00 00       	mov    $0x0,%eax
    14b1:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    14b8:	00 00 00 
    14bb:	ff d2                	callq  *%rdx
  fd = open("small", O_CREATE|O_RDWR);
    14bd:	be 02 02 00 00       	mov    $0x202,%esi
    14c2:	48 bf 9a 6e 00 00 00 	movabs $0x6e9a,%rdi
    14c9:	00 00 00 
    14cc:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    14d3:	00 00 00 
    14d6:	ff d0                	callq  *%rax
    14d8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(fd < 0){
    14db:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    14df:	79 16                	jns    14f7 <writetest+0x66>
    failexit("error: creat small");
    14e1:	48 bf a0 6e 00 00 00 	movabs $0x6ea0,%rdi
    14e8:	00 00 00 
    14eb:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    14f2:	00 00 00 
    14f5:	ff d0                	callq  *%rax
  }
  for(i = 0; i < 100; i++){
    14f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    14fe:	e9 b0 00 00 00       	jmpq   15b3 <writetest+0x122>
    if(write(fd, "aaaaaaaaaa", 10) != 10){
    1503:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1506:	ba 0a 00 00 00       	mov    $0xa,%edx
    150b:	48 be b3 6e 00 00 00 	movabs $0x6eb3,%rsi
    1512:	00 00 00 
    1515:	89 c7                	mov    %eax,%edi
    1517:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    151e:	00 00 00 
    1521:	ff d0                	callq  *%rax
    1523:	83 f8 0a             	cmp    $0xa,%eax
    1526:	74 31                	je     1559 <writetest+0xc8>
      printf(1, "error: write aa %d new file failed\n", i);
    1528:	8b 45 fc             	mov    -0x4(%rbp),%eax
    152b:	89 c2                	mov    %eax,%edx
    152d:	48 be c0 6e 00 00 00 	movabs $0x6ec0,%rsi
    1534:	00 00 00 
    1537:	bf 01 00 00 00       	mov    $0x1,%edi
    153c:	b8 00 00 00 00       	mov    $0x0,%eax
    1541:	48 b9 11 66 00 00 00 	movabs $0x6611,%rcx
    1548:	00 00 00 
    154b:	ff d1                	callq  *%rcx
      exit();
    154d:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    1554:	00 00 00 
    1557:	ff d0                	callq  *%rax
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
    1559:	8b 45 f8             	mov    -0x8(%rbp),%eax
    155c:	ba 0a 00 00 00       	mov    $0xa,%edx
    1561:	48 be e4 6e 00 00 00 	movabs $0x6ee4,%rsi
    1568:	00 00 00 
    156b:	89 c7                	mov    %eax,%edi
    156d:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    1574:	00 00 00 
    1577:	ff d0                	callq  *%rax
    1579:	83 f8 0a             	cmp    $0xa,%eax
    157c:	74 31                	je     15af <writetest+0x11e>
      printf(1, "error: write bb %d new file failed\n", i);
    157e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1581:	89 c2                	mov    %eax,%edx
    1583:	48 be f0 6e 00 00 00 	movabs $0x6ef0,%rsi
    158a:	00 00 00 
    158d:	bf 01 00 00 00       	mov    $0x1,%edi
    1592:	b8 00 00 00 00       	mov    $0x0,%eax
    1597:	48 b9 11 66 00 00 00 	movabs $0x6611,%rcx
    159e:	00 00 00 
    15a1:	ff d1                	callq  *%rcx
      exit();
    15a3:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    15aa:	00 00 00 
    15ad:	ff d0                	callq  *%rax
  for(i = 0; i < 100; i++){
    15af:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15b3:	83 7d fc 63          	cmpl   $0x63,-0x4(%rbp)
    15b7:	0f 8e 46 ff ff ff    	jle    1503 <writetest+0x72>
    }
  }
  close(fd);
    15bd:	8b 45 f8             	mov    -0x8(%rbp),%eax
    15c0:	89 c7                	mov    %eax,%edi
    15c2:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    15c9:	00 00 00 
    15cc:	ff d0                	callq  *%rax
  fd = open("small", O_RDONLY);
    15ce:	be 00 00 00 00       	mov    $0x0,%esi
    15d3:	48 bf 9a 6e 00 00 00 	movabs $0x6e9a,%rdi
    15da:	00 00 00 
    15dd:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    15e4:	00 00 00 
    15e7:	ff d0                	callq  *%rax
    15e9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(fd < 0){
    15ec:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    15f0:	79 16                	jns    1608 <writetest+0x177>
    failexit("error: open small");
    15f2:	48 bf 14 6f 00 00 00 	movabs $0x6f14,%rdi
    15f9:	00 00 00 
    15fc:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1603:	00 00 00 
    1606:	ff d0                	callq  *%rax
  }
  i = read(fd, buf, 2000);
    1608:	8b 45 f8             	mov    -0x8(%rbp),%eax
    160b:	ba d0 07 00 00       	mov    $0x7d0,%edx
    1610:	48 be 20 8c 00 00 00 	movabs $0x8c20,%rsi
    1617:	00 00 00 
    161a:	89 c7                	mov    %eax,%edi
    161c:	48 b8 34 63 00 00 00 	movabs $0x6334,%rax
    1623:	00 00 00 
    1626:	ff d0                	callq  *%rax
    1628:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(i != 2000){
    162b:	81 7d fc d0 07 00 00 	cmpl   $0x7d0,-0x4(%rbp)
    1632:	74 16                	je     164a <writetest+0x1b9>
    failexit("read");
    1634:	48 bf 26 6f 00 00 00 	movabs $0x6f26,%rdi
    163b:	00 00 00 
    163e:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1645:	00 00 00 
    1648:	ff d0                	callq  *%rax
  }
  close(fd);
    164a:	8b 45 f8             	mov    -0x8(%rbp),%eax
    164d:	89 c7                	mov    %eax,%edi
    164f:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    1656:	00 00 00 
    1659:	ff d0                	callq  *%rax

  if(unlink("small") < 0){
    165b:	48 bf 9a 6e 00 00 00 	movabs $0x6e9a,%rdi
    1662:	00 00 00 
    1665:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    166c:	00 00 00 
    166f:	ff d0                	callq  *%rax
    1671:	85 c0                	test   %eax,%eax
    1673:	79 22                	jns    1697 <writetest+0x206>
    failexit("unlink small");
    1675:	48 bf 2b 6f 00 00 00 	movabs $0x6f2b,%rdi
    167c:	00 00 00 
    167f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1686:	00 00 00 
    1689:	ff d0                	callq  *%rax
    exit();
    168b:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    1692:	00 00 00 
    1695:	ff d0                	callq  *%rax
  }
  printf(1, "small file test ok\n");
    1697:	48 be 38 6f 00 00 00 	movabs $0x6f38,%rsi
    169e:	00 00 00 
    16a1:	bf 01 00 00 00       	mov    $0x1,%edi
    16a6:	b8 00 00 00 00       	mov    $0x0,%eax
    16ab:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    16b2:	00 00 00 
    16b5:	ff d2                	callq  *%rdx
}
    16b7:	90                   	nop
    16b8:	c9                   	leaveq 
    16b9:	c3                   	retq   

00000000000016ba <writetest1>:

void
writetest1(void)
{
    16ba:	f3 0f 1e fa          	endbr64 
    16be:	55                   	push   %rbp
    16bf:	48 89 e5             	mov    %rsp,%rbp
    16c2:	48 83 ec 10          	sub    $0x10,%rsp
  int i, fd, n;

  printf(1, "big files test\n");
    16c6:	48 be 4c 6f 00 00 00 	movabs $0x6f4c,%rsi
    16cd:	00 00 00 
    16d0:	bf 01 00 00 00       	mov    $0x1,%edi
    16d5:	b8 00 00 00 00       	mov    $0x0,%eax
    16da:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    16e1:	00 00 00 
    16e4:	ff d2                	callq  *%rdx

  fd = open("big", O_CREATE|O_RDWR);
    16e6:	be 02 02 00 00       	mov    $0x202,%esi
    16eb:	48 bf 5c 6f 00 00 00 	movabs $0x6f5c,%rdi
    16f2:	00 00 00 
    16f5:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    16fc:	00 00 00 
    16ff:	ff d0                	callq  *%rax
    1701:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(fd < 0){
    1704:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1708:	79 16                	jns    1720 <writetest1+0x66>
    failexit("error: creat big");
    170a:	48 bf 60 6f 00 00 00 	movabs $0x6f60,%rdi
    1711:	00 00 00 
    1714:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    171b:	00 00 00 
    171e:	ff d0                	callq  *%rax
  }

  for(i = 0; i < MAXFILE; i++){
    1720:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1727:	eb 50                	jmp    1779 <writetest1+0xbf>
    ((int*)buf)[0] = i;
    1729:	48 ba 20 8c 00 00 00 	movabs $0x8c20,%rdx
    1730:	00 00 00 
    1733:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1736:	89 02                	mov    %eax,(%rdx)
    if(write(fd, buf, 512) != 512){
    1738:	8b 45 f4             	mov    -0xc(%rbp),%eax
    173b:	ba 00 02 00 00       	mov    $0x200,%edx
    1740:	48 be 20 8c 00 00 00 	movabs $0x8c20,%rsi
    1747:	00 00 00 
    174a:	89 c7                	mov    %eax,%edi
    174c:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    1753:	00 00 00 
    1756:	ff d0                	callq  *%rax
    1758:	3d 00 02 00 00       	cmp    $0x200,%eax
    175d:	74 16                	je     1775 <writetest1+0xbb>
      failexit("error: write big file");
    175f:	48 bf 71 6f 00 00 00 	movabs $0x6f71,%rdi
    1766:	00 00 00 
    1769:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1770:	00 00 00 
    1773:	ff d0                	callq  *%rax
  for(i = 0; i < MAXFILE; i++){
    1775:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1779:	8b 45 fc             	mov    -0x4(%rbp),%eax
    177c:	3d 8b 00 00 00       	cmp    $0x8b,%eax
    1781:	76 a6                	jbe    1729 <writetest1+0x6f>
    }
  }

  close(fd);
    1783:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1786:	89 c7                	mov    %eax,%edi
    1788:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    178f:	00 00 00 
    1792:	ff d0                	callq  *%rax

  fd = open("big", O_RDONLY);
    1794:	be 00 00 00 00       	mov    $0x0,%esi
    1799:	48 bf 5c 6f 00 00 00 	movabs $0x6f5c,%rdi
    17a0:	00 00 00 
    17a3:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    17aa:	00 00 00 
    17ad:	ff d0                	callq  *%rax
    17af:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(fd < 0){
    17b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    17b6:	79 16                	jns    17ce <writetest1+0x114>
    failexit("error: open big");
    17b8:	48 bf 87 6f 00 00 00 	movabs $0x6f87,%rdi
    17bf:	00 00 00 
    17c2:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    17c9:	00 00 00 
    17cc:	ff d0                	callq  *%rax
  }

  n = 0;
    17ce:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  for(;;){
    i = read(fd, buf, 512);
    17d5:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17d8:	ba 00 02 00 00       	mov    $0x200,%edx
    17dd:	48 be 20 8c 00 00 00 	movabs $0x8c20,%rsi
    17e4:	00 00 00 
    17e7:	89 c7                	mov    %eax,%edi
    17e9:	48 b8 34 63 00 00 00 	movabs $0x6334,%rax
    17f0:	00 00 00 
    17f3:	ff d0                	callq  *%rax
    17f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
    if(i == 0){
    17f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    17fc:	75 3e                	jne    183c <writetest1+0x182>
      if(n == MAXFILE - 1){
    17fe:	81 7d f8 8b 00 00 00 	cmpl   $0x8b,-0x8(%rbp)
    1805:	0f 85 c5 00 00 00    	jne    18d0 <writetest1+0x216>
        printf(1, "read only %d blocks from big. failed", n);
    180b:	8b 45 f8             	mov    -0x8(%rbp),%eax
    180e:	89 c2                	mov    %eax,%edx
    1810:	48 be 98 6f 00 00 00 	movabs $0x6f98,%rsi
    1817:	00 00 00 
    181a:	bf 01 00 00 00       	mov    $0x1,%edi
    181f:	b8 00 00 00 00       	mov    $0x0,%eax
    1824:	48 b9 11 66 00 00 00 	movabs $0x6611,%rcx
    182b:	00 00 00 
    182e:	ff d1                	callq  *%rcx
        exit();
    1830:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    1837:	00 00 00 
    183a:	ff d0                	callq  *%rax
      }
      break;
    } else if(i != 512){
    183c:	81 7d fc 00 02 00 00 	cmpl   $0x200,-0x4(%rbp)
    1843:	74 31                	je     1876 <writetest1+0x1bc>
      printf(1, "read failed %d\n", i);
    1845:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1848:	89 c2                	mov    %eax,%edx
    184a:	48 be bd 6f 00 00 00 	movabs $0x6fbd,%rsi
    1851:	00 00 00 
    1854:	bf 01 00 00 00       	mov    $0x1,%edi
    1859:	b8 00 00 00 00       	mov    $0x0,%eax
    185e:	48 b9 11 66 00 00 00 	movabs $0x6611,%rcx
    1865:	00 00 00 
    1868:	ff d1                	callq  *%rcx
      exit();
    186a:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    1871:	00 00 00 
    1874:	ff d0                	callq  *%rax
    }
    if(((int*)buf)[0] != n){
    1876:	48 b8 20 8c 00 00 00 	movabs $0x8c20,%rax
    187d:	00 00 00 
    1880:	8b 00                	mov    (%rax),%eax
    1882:	39 45 f8             	cmp    %eax,-0x8(%rbp)
    1885:	74 40                	je     18c7 <writetest1+0x20d>
      printf(1, "read content of block %d is %d. failed\n",
             n, ((int*)buf)[0]);
    1887:	48 b8 20 8c 00 00 00 	movabs $0x8c20,%rax
    188e:	00 00 00 
      printf(1, "read content of block %d is %d. failed\n",
    1891:	8b 10                	mov    (%rax),%edx
    1893:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1896:	89 d1                	mov    %edx,%ecx
    1898:	89 c2                	mov    %eax,%edx
    189a:	48 be d0 6f 00 00 00 	movabs $0x6fd0,%rsi
    18a1:	00 00 00 
    18a4:	bf 01 00 00 00       	mov    $0x1,%edi
    18a9:	b8 00 00 00 00       	mov    $0x0,%eax
    18ae:	49 b8 11 66 00 00 00 	movabs $0x6611,%r8
    18b5:	00 00 00 
    18b8:	41 ff d0             	callq  *%r8
      exit();
    18bb:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    18c2:	00 00 00 
    18c5:	ff d0                	callq  *%rax
    }
    n++;
    18c7:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    i = read(fd, buf, 512);
    18cb:	e9 05 ff ff ff       	jmpq   17d5 <writetest1+0x11b>
      break;
    18d0:	90                   	nop
  }
  close(fd);
    18d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
    18d4:	89 c7                	mov    %eax,%edi
    18d6:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    18dd:	00 00 00 
    18e0:	ff d0                	callq  *%rax
  if(unlink("big") < 0){
    18e2:	48 bf 5c 6f 00 00 00 	movabs $0x6f5c,%rdi
    18e9:	00 00 00 
    18ec:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    18f3:	00 00 00 
    18f6:	ff d0                	callq  *%rax
    18f8:	85 c0                	test   %eax,%eax
    18fa:	79 22                	jns    191e <writetest1+0x264>
    failexit("unlink big");
    18fc:	48 bf f8 6f 00 00 00 	movabs $0x6ff8,%rdi
    1903:	00 00 00 
    1906:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    190d:	00 00 00 
    1910:	ff d0                	callq  *%rax
    exit();
    1912:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    1919:	00 00 00 
    191c:	ff d0                	callq  *%rax
  }
  printf(1, "big files ok\n");
    191e:	48 be 03 70 00 00 00 	movabs $0x7003,%rsi
    1925:	00 00 00 
    1928:	bf 01 00 00 00       	mov    $0x1,%edi
    192d:	b8 00 00 00 00       	mov    $0x0,%eax
    1932:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    1939:	00 00 00 
    193c:	ff d2                	callq  *%rdx
}
    193e:	90                   	nop
    193f:	c9                   	leaveq 
    1940:	c3                   	retq   

0000000000001941 <createtest>:

void
createtest(void)
{
    1941:	f3 0f 1e fa          	endbr64 
    1945:	55                   	push   %rbp
    1946:	48 89 e5             	mov    %rsp,%rbp
    1949:	48 83 ec 10          	sub    $0x10,%rsp
  int i, fd;

  printf(1, "many creates, followed by unlink test\n");
    194d:	48 be 18 70 00 00 00 	movabs $0x7018,%rsi
    1954:	00 00 00 
    1957:	bf 01 00 00 00       	mov    $0x1,%edi
    195c:	b8 00 00 00 00       	mov    $0x0,%eax
    1961:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    1968:	00 00 00 
    196b:	ff d2                	callq  *%rdx

  name[0] = 'a';
    196d:	48 b8 20 ac 00 00 00 	movabs $0xac20,%rax
    1974:	00 00 00 
    1977:	c6 00 61             	movb   $0x61,(%rax)
  name[2] = '\0';
    197a:	48 b8 20 ac 00 00 00 	movabs $0xac20,%rax
    1981:	00 00 00 
    1984:	c6 40 02 00          	movb   $0x0,0x2(%rax)
  for(i = 0; i < 52; i++){
    1988:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    198f:	eb 48                	jmp    19d9 <createtest+0x98>
    name[1] = '0' + i;
    1991:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1994:	83 c0 30             	add    $0x30,%eax
    1997:	89 c2                	mov    %eax,%edx
    1999:	48 b8 20 ac 00 00 00 	movabs $0xac20,%rax
    19a0:	00 00 00 
    19a3:	88 50 01             	mov    %dl,0x1(%rax)
    fd = open(name, O_CREATE|O_RDWR);
    19a6:	be 02 02 00 00       	mov    $0x202,%esi
    19ab:	48 bf 20 ac 00 00 00 	movabs $0xac20,%rdi
    19b2:	00 00 00 
    19b5:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    19bc:	00 00 00 
    19bf:	ff d0                	callq  *%rax
    19c1:	89 45 f8             	mov    %eax,-0x8(%rbp)
    close(fd);
    19c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
    19c7:	89 c7                	mov    %eax,%edi
    19c9:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    19d0:	00 00 00 
    19d3:	ff d0                	callq  *%rax
  for(i = 0; i < 52; i++){
    19d5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    19d9:	83 7d fc 33          	cmpl   $0x33,-0x4(%rbp)
    19dd:	7e b2                	jle    1991 <createtest+0x50>
  }
  for(i = 0; i < 52; i++){
    19df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    19e6:	eb 2f                	jmp    1a17 <createtest+0xd6>
    name[1] = '0' + i;
    19e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    19eb:	83 c0 30             	add    $0x30,%eax
    19ee:	89 c2                	mov    %eax,%edx
    19f0:	48 b8 20 ac 00 00 00 	movabs $0xac20,%rax
    19f7:	00 00 00 
    19fa:	88 50 01             	mov    %dl,0x1(%rax)
    unlink(name);
    19fd:	48 bf 20 ac 00 00 00 	movabs $0xac20,%rdi
    1a04:	00 00 00 
    1a07:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    1a0e:	00 00 00 
    1a11:	ff d0                	callq  *%rax
  for(i = 0; i < 52; i++){
    1a13:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1a17:	83 7d fc 33          	cmpl   $0x33,-0x4(%rbp)
    1a1b:	7e cb                	jle    19e8 <createtest+0xa7>
  }
  for(i = 0; i < 52; i++){
    1a1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1a24:	eb 53                	jmp    1a79 <createtest+0x138>
    name[1] = '0' + i;
    1a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1a29:	83 c0 30             	add    $0x30,%eax
    1a2c:	89 c2                	mov    %eax,%edx
    1a2e:	48 b8 20 ac 00 00 00 	movabs $0xac20,%rax
    1a35:	00 00 00 
    1a38:	88 50 01             	mov    %dl,0x1(%rax)
    fd = open(name, O_RDWR);
    1a3b:	be 02 00 00 00       	mov    $0x2,%esi
    1a40:	48 bf 20 ac 00 00 00 	movabs $0xac20,%rdi
    1a47:	00 00 00 
    1a4a:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    1a51:	00 00 00 
    1a54:	ff d0                	callq  *%rax
    1a56:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(fd >= 0) {
    1a59:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1a5d:	78 16                	js     1a75 <createtest+0x134>
      failexit("open should fail.");
    1a5f:	48 bf 3f 70 00 00 00 	movabs $0x703f,%rdi
    1a66:	00 00 00 
    1a69:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1a70:	00 00 00 
    1a73:	ff d0                	callq  *%rax
  for(i = 0; i < 52; i++){
    1a75:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1a79:	83 7d fc 33          	cmpl   $0x33,-0x4(%rbp)
    1a7d:	7e a7                	jle    1a26 <createtest+0xe5>
    }
  }

  printf(1, "many creates, followed by unlink; ok\n");
    1a7f:	48 be 58 70 00 00 00 	movabs $0x7058,%rsi
    1a86:	00 00 00 
    1a89:	bf 01 00 00 00       	mov    $0x1,%edi
    1a8e:	b8 00 00 00 00       	mov    $0x0,%eax
    1a93:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    1a9a:	00 00 00 
    1a9d:	ff d2                	callq  *%rdx
}
    1a9f:	90                   	nop
    1aa0:	c9                   	leaveq 
    1aa1:	c3                   	retq   

0000000000001aa2 <dirtest>:

void dirtest(void)
{
    1aa2:	f3 0f 1e fa          	endbr64 
    1aa6:	55                   	push   %rbp
    1aa7:	48 89 e5             	mov    %rsp,%rbp
  printf(1, "mkdir test\n");
    1aaa:	48 be 7e 70 00 00 00 	movabs $0x707e,%rsi
    1ab1:	00 00 00 
    1ab4:	bf 01 00 00 00       	mov    $0x1,%edi
    1ab9:	b8 00 00 00 00       	mov    $0x0,%eax
    1abe:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    1ac5:	00 00 00 
    1ac8:	ff d2                	callq  *%rdx

  if(mkdir("dir0") < 0){
    1aca:	48 bf 8a 70 00 00 00 	movabs $0x708a,%rdi
    1ad1:	00 00 00 
    1ad4:	48 b8 b6 63 00 00 00 	movabs $0x63b6,%rax
    1adb:	00 00 00 
    1ade:	ff d0                	callq  *%rax
    1ae0:	85 c0                	test   %eax,%eax
    1ae2:	79 16                	jns    1afa <dirtest+0x58>
    failexit("mkdir");
    1ae4:	48 bf 5f 6d 00 00 00 	movabs $0x6d5f,%rdi
    1aeb:	00 00 00 
    1aee:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1af5:	00 00 00 
    1af8:	ff d0                	callq  *%rax
  }

  if(chdir("dir0") < 0){
    1afa:	48 bf 8a 70 00 00 00 	movabs $0x708a,%rdi
    1b01:	00 00 00 
    1b04:	48 b8 c3 63 00 00 00 	movabs $0x63c3,%rax
    1b0b:	00 00 00 
    1b0e:	ff d0                	callq  *%rax
    1b10:	85 c0                	test   %eax,%eax
    1b12:	79 16                	jns    1b2a <dirtest+0x88>
    failexit("chdir dir0");
    1b14:	48 bf 8f 70 00 00 00 	movabs $0x708f,%rdi
    1b1b:	00 00 00 
    1b1e:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1b25:	00 00 00 
    1b28:	ff d0                	callq  *%rax
  }

  if(chdir("..") < 0){
    1b2a:	48 bf 9a 70 00 00 00 	movabs $0x709a,%rdi
    1b31:	00 00 00 
    1b34:	48 b8 c3 63 00 00 00 	movabs $0x63c3,%rax
    1b3b:	00 00 00 
    1b3e:	ff d0                	callq  *%rax
    1b40:	85 c0                	test   %eax,%eax
    1b42:	79 16                	jns    1b5a <dirtest+0xb8>
    failexit("chdir ..");
    1b44:	48 bf 9d 70 00 00 00 	movabs $0x709d,%rdi
    1b4b:	00 00 00 
    1b4e:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1b55:	00 00 00 
    1b58:	ff d0                	callq  *%rax
  }

  if(unlink("dir0") < 0){
    1b5a:	48 bf 8a 70 00 00 00 	movabs $0x708a,%rdi
    1b61:	00 00 00 
    1b64:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    1b6b:	00 00 00 
    1b6e:	ff d0                	callq  *%rax
    1b70:	85 c0                	test   %eax,%eax
    1b72:	79 16                	jns    1b8a <dirtest+0xe8>
    failexit("unlink dir0");
    1b74:	48 bf a6 70 00 00 00 	movabs $0x70a6,%rdi
    1b7b:	00 00 00 
    1b7e:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1b85:	00 00 00 
    1b88:	ff d0                	callq  *%rax
  }
  printf(1, "mkdir test ok\n");
    1b8a:	48 be b2 70 00 00 00 	movabs $0x70b2,%rsi
    1b91:	00 00 00 
    1b94:	bf 01 00 00 00       	mov    $0x1,%edi
    1b99:	b8 00 00 00 00       	mov    $0x0,%eax
    1b9e:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    1ba5:	00 00 00 
    1ba8:	ff d2                	callq  *%rdx
}
    1baa:	90                   	nop
    1bab:	5d                   	pop    %rbp
    1bac:	c3                   	retq   

0000000000001bad <exectest>:

void
exectest(void)
{
    1bad:	f3 0f 1e fa          	endbr64 
    1bb1:	55                   	push   %rbp
    1bb2:	48 89 e5             	mov    %rsp,%rbp
  printf(1, "exec test\n");
    1bb5:	48 be c1 70 00 00 00 	movabs $0x70c1,%rsi
    1bbc:	00 00 00 
    1bbf:	bf 01 00 00 00       	mov    $0x1,%edi
    1bc4:	b8 00 00 00 00       	mov    $0x0,%eax
    1bc9:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    1bd0:	00 00 00 
    1bd3:	ff d2                	callq  *%rdx
  if(exec("echo", echoargv) < 0){
    1bd5:	48 be c0 8b 00 00 00 	movabs $0x8bc0,%rsi
    1bdc:	00 00 00 
    1bdf:	48 bf 28 6d 00 00 00 	movabs $0x6d28,%rdi
    1be6:	00 00 00 
    1be9:	48 b8 68 63 00 00 00 	movabs $0x6368,%rax
    1bf0:	00 00 00 
    1bf3:	ff d0                	callq  *%rax
    1bf5:	85 c0                	test   %eax,%eax
    1bf7:	79 16                	jns    1c0f <exectest+0x62>
    failexit("exec echo");
    1bf9:	48 bf cc 70 00 00 00 	movabs $0x70cc,%rdi
    1c00:	00 00 00 
    1c03:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1c0a:	00 00 00 
    1c0d:	ff d0                	callq  *%rax
  }
  printf(1, "exec test ok\n");
    1c0f:	48 be d6 70 00 00 00 	movabs $0x70d6,%rsi
    1c16:	00 00 00 
    1c19:	bf 01 00 00 00       	mov    $0x1,%edi
    1c1e:	b8 00 00 00 00       	mov    $0x0,%eax
    1c23:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    1c2a:	00 00 00 
    1c2d:	ff d2                	callq  *%rdx
}
    1c2f:	90                   	nop
    1c30:	5d                   	pop    %rbp
    1c31:	c3                   	retq   

0000000000001c32 <nullptr>:

void
nullptr(void)
{
    1c32:	f3 0f 1e fa          	endbr64 
    1c36:	55                   	push   %rbp
    1c37:	48 89 e5             	mov    %rsp,%rbp
    1c3a:	48 83 ec 10          	sub    $0x10,%rsp
  printf(1, "null pointer test\n");
    1c3e:	48 be e4 70 00 00 00 	movabs $0x70e4,%rsi
    1c45:	00 00 00 
    1c48:	bf 01 00 00 00       	mov    $0x1,%edi
    1c4d:	b8 00 00 00 00       	mov    $0x0,%eax
    1c52:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    1c59:	00 00 00 
    1c5c:	ff d2                	callq  *%rdx
  printf(1, "expect one killed process\n");
    1c5e:	48 be f7 70 00 00 00 	movabs $0x70f7,%rsi
    1c65:	00 00 00 
    1c68:	bf 01 00 00 00       	mov    $0x1,%edi
    1c6d:	b8 00 00 00 00       	mov    $0x0,%eax
    1c72:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    1c79:	00 00 00 
    1c7c:	ff d2                	callq  *%rdx
  int ppid = getpid();
    1c7e:	48 b8 dd 63 00 00 00 	movabs $0x63dd,%rax
    1c85:	00 00 00 
    1c88:	ff d0                	callq  *%rax
    1c8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if (fork() == 0) {
    1c8d:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    1c94:	00 00 00 
    1c97:	ff d0                	callq  *%rax
    1c99:	85 c0                	test   %eax,%eax
    1c9b:	75 49                	jne    1ce6 <nullptr+0xb4>
    *(addr_t *)(0) = 10;
    1c9d:	b8 00 00 00 00       	mov    $0x0,%eax
    1ca2:	48 c7 00 0a 00 00 00 	movq   $0xa,(%rax)
    printf(1, "can write to unmapped page 0, failed");
    1ca9:	48 be 18 71 00 00 00 	movabs $0x7118,%rsi
    1cb0:	00 00 00 
    1cb3:	bf 01 00 00 00       	mov    $0x1,%edi
    1cb8:	b8 00 00 00 00       	mov    $0x0,%eax
    1cbd:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    1cc4:	00 00 00 
    1cc7:	ff d2                	callq  *%rdx
    kill(ppid);
    1cc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1ccc:	89 c7                	mov    %eax,%edi
    1cce:	48 b8 5b 63 00 00 00 	movabs $0x635b,%rax
    1cd5:	00 00 00 
    1cd8:	ff d0                	callq  *%rax
    exit();
    1cda:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    1ce1:	00 00 00 
    1ce4:	ff d0                	callq  *%rax
  } else {
    wait();
    1ce6:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    1ced:	00 00 00 
    1cf0:	ff d0                	callq  *%rax
  }
  printf(1, "null pointer test ok\n");
    1cf2:	48 be 3d 71 00 00 00 	movabs $0x713d,%rsi
    1cf9:	00 00 00 
    1cfc:	bf 01 00 00 00       	mov    $0x1,%edi
    1d01:	b8 00 00 00 00       	mov    $0x0,%eax
    1d06:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    1d0d:	00 00 00 
    1d10:	ff d2                	callq  *%rdx
}
    1d12:	90                   	nop
    1d13:	c9                   	leaveq 
    1d14:	c3                   	retq   

0000000000001d15 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
    1d15:	f3 0f 1e fa          	endbr64 
    1d19:	55                   	push   %rbp
    1d1a:	48 89 e5             	mov    %rsp,%rbp
    1d1d:	48 83 ec 20          	sub    $0x20,%rsp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
    1d21:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
    1d25:	48 89 c7             	mov    %rax,%rdi
    1d28:	48 b8 27 63 00 00 00 	movabs $0x6327,%rax
    1d2f:	00 00 00 
    1d32:	ff d0                	callq  *%rax
    1d34:	85 c0                	test   %eax,%eax
    1d36:	74 16                	je     1d4e <pipe1+0x39>
    failexit("pipe()");
    1d38:	48 bf 53 71 00 00 00 	movabs $0x7153,%rdi
    1d3f:	00 00 00 
    1d42:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1d49:	00 00 00 
    1d4c:	ff d0                	callq  *%rax
  }
  pid = fork();
    1d4e:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    1d55:	00 00 00 
    1d58:	ff d0                	callq  *%rax
    1d5a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  seq = 0;
    1d5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  if(pid == 0){
    1d64:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
    1d68:	0f 85 a0 00 00 00    	jne    1e0e <pipe1+0xf9>
    close(fds[0]);
    1d6e:	8b 45 e0             	mov    -0x20(%rbp),%eax
    1d71:	89 c7                	mov    %eax,%edi
    1d73:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    1d7a:	00 00 00 
    1d7d:	ff d0                	callq  *%rax
    for(n = 0; n < 5; n++){
    1d7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    1d86:	eb 74                	jmp    1dfc <pipe1+0xe7>
      for(i = 0; i < 1033; i++)
    1d88:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    1d8f:	eb 21                	jmp    1db2 <pipe1+0x9d>
        buf[i] = seq++;
    1d91:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1d94:	8d 50 01             	lea    0x1(%rax),%edx
    1d97:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1d9a:	89 c1                	mov    %eax,%ecx
    1d9c:	48 ba 20 8c 00 00 00 	movabs $0x8c20,%rdx
    1da3:	00 00 00 
    1da6:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1da9:	48 98                	cltq   
    1dab:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
      for(i = 0; i < 1033; i++)
    1dae:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    1db2:	81 7d f8 08 04 00 00 	cmpl   $0x408,-0x8(%rbp)
    1db9:	7e d6                	jle    1d91 <pipe1+0x7c>
      if(write(fds[1], buf, 1033) != 1033){
    1dbb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
    1dbe:	ba 09 04 00 00       	mov    $0x409,%edx
    1dc3:	48 be 20 8c 00 00 00 	movabs $0x8c20,%rsi
    1dca:	00 00 00 
    1dcd:	89 c7                	mov    %eax,%edi
    1dcf:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    1dd6:	00 00 00 
    1dd9:	ff d0                	callq  *%rax
    1ddb:	3d 09 04 00 00       	cmp    $0x409,%eax
    1de0:	74 16                	je     1df8 <pipe1+0xe3>
        failexit("pipe1 oops 1");
    1de2:	48 bf 5a 71 00 00 00 	movabs $0x715a,%rdi
    1de9:	00 00 00 
    1dec:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1df3:	00 00 00 
    1df6:	ff d0                	callq  *%rax
    for(n = 0; n < 5; n++){
    1df8:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
    1dfc:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
    1e00:	7e 86                	jle    1d88 <pipe1+0x73>
      }
    }
    exit();
    1e02:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    1e09:	00 00 00 
    1e0c:	ff d0                	callq  *%rax
  } else if(pid > 0){
    1e0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
    1e12:	0f 8e 17 01 00 00    	jle    1f2f <pipe1+0x21a>
    close(fds[1]);
    1e18:	8b 45 e4             	mov    -0x1c(%rbp),%eax
    1e1b:	89 c7                	mov    %eax,%edi
    1e1d:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    1e24:	00 00 00 
    1e27:	ff d0                	callq  *%rax
    total = 0;
    1e29:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    cc = 1;
    1e30:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%rbp)
    while((n = read(fds[0], buf, cc)) > 0){
    1e37:	eb 72                	jmp    1eab <pipe1+0x196>
      for(i = 0; i < n; i++){
    1e39:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    1e40:	eb 47                	jmp    1e89 <pipe1+0x174>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1e42:	48 ba 20 8c 00 00 00 	movabs $0x8c20,%rdx
    1e49:	00 00 00 
    1e4c:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1e4f:	48 98                	cltq   
    1e51:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1e55:	0f be c8             	movsbl %al,%ecx
    1e58:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1e5b:	8d 50 01             	lea    0x1(%rax),%edx
    1e5e:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1e61:	31 c8                	xor    %ecx,%eax
    1e63:	0f b6 c0             	movzbl %al,%eax
    1e66:	85 c0                	test   %eax,%eax
    1e68:	74 1b                	je     1e85 <pipe1+0x170>
          failexit("pipe1 oops 2");
    1e6a:	48 bf 67 71 00 00 00 	movabs $0x7167,%rdi
    1e71:	00 00 00 
    1e74:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1e7b:	00 00 00 
    1e7e:	ff d0                	callq  *%rax
    1e80:	e9 e0 00 00 00       	jmpq   1f65 <pipe1+0x250>
      for(i = 0; i < n; i++){
    1e85:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    1e89:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1e8c:	3b 45 f4             	cmp    -0xc(%rbp),%eax
    1e8f:	7c b1                	jl     1e42 <pipe1+0x12d>
          return;
        }
      }
      total += n;
    1e91:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1e94:	01 45 ec             	add    %eax,-0x14(%rbp)
      cc = cc * 2;
    1e97:	d1 65 f0             	shll   -0x10(%rbp)
      if(cc > sizeof(buf))
    1e9a:	8b 45 f0             	mov    -0x10(%rbp),%eax
    1e9d:	3d 00 20 00 00       	cmp    $0x2000,%eax
    1ea2:	76 07                	jbe    1eab <pipe1+0x196>
        cc = sizeof(buf);
    1ea4:	c7 45 f0 00 20 00 00 	movl   $0x2000,-0x10(%rbp)
    while((n = read(fds[0], buf, cc)) > 0){
    1eab:	8b 45 e0             	mov    -0x20(%rbp),%eax
    1eae:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1eb1:	48 be 20 8c 00 00 00 	movabs $0x8c20,%rsi
    1eb8:	00 00 00 
    1ebb:	89 c7                	mov    %eax,%edi
    1ebd:	48 b8 34 63 00 00 00 	movabs $0x6334,%rax
    1ec4:	00 00 00 
    1ec7:	ff d0                	callq  *%rax
    1ec9:	89 45 f4             	mov    %eax,-0xc(%rbp)
    1ecc:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1ed0:	0f 8f 63 ff ff ff    	jg     1e39 <pipe1+0x124>
    }
    if(total != 5 * 1033){
    1ed6:	81 7d ec 2d 14 00 00 	cmpl   $0x142d,-0x14(%rbp)
    1edd:	74 31                	je     1f10 <pipe1+0x1fb>
      printf(1, "pipe1 oops 3 total %d\n", total);
    1edf:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1ee2:	89 c2                	mov    %eax,%edx
    1ee4:	48 be 74 71 00 00 00 	movabs $0x7174,%rsi
    1eeb:	00 00 00 
    1eee:	bf 01 00 00 00       	mov    $0x1,%edi
    1ef3:	b8 00 00 00 00       	mov    $0x0,%eax
    1ef8:	48 b9 11 66 00 00 00 	movabs $0x6611,%rcx
    1eff:	00 00 00 
    1f02:	ff d1                	callq  *%rcx
      exit();
    1f04:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    1f0b:	00 00 00 
    1f0e:	ff d0                	callq  *%rax
    }
    close(fds[0]);
    1f10:	8b 45 e0             	mov    -0x20(%rbp),%eax
    1f13:	89 c7                	mov    %eax,%edi
    1f15:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    1f1c:	00 00 00 
    1f1f:	ff d0                	callq  *%rax
    wait();
    1f21:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    1f28:	00 00 00 
    1f2b:	ff d0                	callq  *%rax
    1f2d:	eb 16                	jmp    1f45 <pipe1+0x230>
  } else {
    failexit("fork()");
    1f2f:	48 bf 8b 71 00 00 00 	movabs $0x718b,%rdi
    1f36:	00 00 00 
    1f39:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1f40:	00 00 00 
    1f43:	ff d0                	callq  *%rax
  }
  printf(1, "pipe1 ok\n");
    1f45:	48 be 92 71 00 00 00 	movabs $0x7192,%rsi
    1f4c:	00 00 00 
    1f4f:	bf 01 00 00 00       	mov    $0x1,%edi
    1f54:	b8 00 00 00 00       	mov    $0x0,%eax
    1f59:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    1f60:	00 00 00 
    1f63:	ff d2                	callq  *%rdx
}
    1f65:	c9                   	leaveq 
    1f66:	c3                   	retq   

0000000000001f67 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
    1f67:	f3 0f 1e fa          	endbr64 
    1f6b:	55                   	push   %rbp
    1f6c:	48 89 e5             	mov    %rsp,%rbp
    1f6f:	48 83 ec 20          	sub    $0x20,%rsp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
    1f73:	48 be 9c 71 00 00 00 	movabs $0x719c,%rsi
    1f7a:	00 00 00 
    1f7d:	bf 01 00 00 00       	mov    $0x1,%edi
    1f82:	b8 00 00 00 00       	mov    $0x0,%eax
    1f87:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    1f8e:	00 00 00 
    1f91:	ff d2                	callq  *%rdx
  pid1 = fork();
    1f93:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    1f9a:	00 00 00 
    1f9d:	ff d0                	callq  *%rax
    1f9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(pid1 == 0)
    1fa2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1fa6:	75 02                	jne    1faa <preempt+0x43>
    for(;;)
    1fa8:	eb fe                	jmp    1fa8 <preempt+0x41>
      ;

  pid2 = fork();
    1faa:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    1fb1:	00 00 00 
    1fb4:	ff d0                	callq  *%rax
    1fb6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(pid2 == 0)
    1fb9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1fbd:	75 02                	jne    1fc1 <preempt+0x5a>
    for(;;)
    1fbf:	eb fe                	jmp    1fbf <preempt+0x58>
      ;

  pipe(pfds);
    1fc1:	48 8d 45 ec          	lea    -0x14(%rbp),%rax
    1fc5:	48 89 c7             	mov    %rax,%rdi
    1fc8:	48 b8 27 63 00 00 00 	movabs $0x6327,%rax
    1fcf:	00 00 00 
    1fd2:	ff d0                	callq  *%rax
  pid3 = fork();
    1fd4:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    1fdb:	00 00 00 
    1fde:	ff d0                	callq  *%rax
    1fe0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(pid3 == 0){
    1fe3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1fe7:	75 69                	jne    2052 <preempt+0xeb>
    close(pfds[0]);
    1fe9:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1fec:	89 c7                	mov    %eax,%edi
    1fee:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    1ff5:	00 00 00 
    1ff8:	ff d0                	callq  *%rax
    if(write(pfds[1], "x", 1) != 1)
    1ffa:	8b 45 f0             	mov    -0x10(%rbp),%eax
    1ffd:	ba 01 00 00 00       	mov    $0x1,%edx
    2002:	48 be a6 71 00 00 00 	movabs $0x71a6,%rsi
    2009:	00 00 00 
    200c:	89 c7                	mov    %eax,%edi
    200e:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    2015:	00 00 00 
    2018:	ff d0                	callq  *%rax
    201a:	83 f8 01             	cmp    $0x1,%eax
    201d:	74 20                	je     203f <preempt+0xd8>
      printf(1, "preempt write error");
    201f:	48 be a8 71 00 00 00 	movabs $0x71a8,%rsi
    2026:	00 00 00 
    2029:	bf 01 00 00 00       	mov    $0x1,%edi
    202e:	b8 00 00 00 00       	mov    $0x0,%eax
    2033:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    203a:	00 00 00 
    203d:	ff d2                	callq  *%rdx
    close(pfds[1]);
    203f:	8b 45 f0             	mov    -0x10(%rbp),%eax
    2042:	89 c7                	mov    %eax,%edi
    2044:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    204b:	00 00 00 
    204e:	ff d0                	callq  *%rax
    for(;;)
    2050:	eb fe                	jmp    2050 <preempt+0xe9>
      ;
  }

  close(pfds[1]);
    2052:	8b 45 f0             	mov    -0x10(%rbp),%eax
    2055:	89 c7                	mov    %eax,%edi
    2057:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    205e:	00 00 00 
    2061:	ff d0                	callq  *%rax
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    2063:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2066:	ba 00 20 00 00       	mov    $0x2000,%edx
    206b:	48 be 20 8c 00 00 00 	movabs $0x8c20,%rsi
    2072:	00 00 00 
    2075:	89 c7                	mov    %eax,%edi
    2077:	48 b8 34 63 00 00 00 	movabs $0x6334,%rax
    207e:	00 00 00 
    2081:	ff d0                	callq  *%rax
    2083:	83 f8 01             	cmp    $0x1,%eax
    2086:	74 25                	je     20ad <preempt+0x146>
    printf(1, "preempt read error");
    2088:	48 be bc 71 00 00 00 	movabs $0x71bc,%rsi
    208f:	00 00 00 
    2092:	bf 01 00 00 00       	mov    $0x1,%edi
    2097:	b8 00 00 00 00       	mov    $0x0,%eax
    209c:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    20a3:	00 00 00 
    20a6:	ff d2                	callq  *%rdx
    20a8:	e9 c8 00 00 00       	jmpq   2175 <preempt+0x20e>
    return;
  }
  close(pfds[0]);
    20ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
    20b0:	89 c7                	mov    %eax,%edi
    20b2:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    20b9:	00 00 00 
    20bc:	ff d0                	callq  *%rax
  printf(1, "kill... ");
    20be:	48 be cf 71 00 00 00 	movabs $0x71cf,%rsi
    20c5:	00 00 00 
    20c8:	bf 01 00 00 00       	mov    $0x1,%edi
    20cd:	b8 00 00 00 00       	mov    $0x0,%eax
    20d2:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    20d9:	00 00 00 
    20dc:	ff d2                	callq  *%rdx
  kill(pid1);
    20de:	8b 45 fc             	mov    -0x4(%rbp),%eax
    20e1:	89 c7                	mov    %eax,%edi
    20e3:	48 b8 5b 63 00 00 00 	movabs $0x635b,%rax
    20ea:	00 00 00 
    20ed:	ff d0                	callq  *%rax
  kill(pid2);
    20ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
    20f2:	89 c7                	mov    %eax,%edi
    20f4:	48 b8 5b 63 00 00 00 	movabs $0x635b,%rax
    20fb:	00 00 00 
    20fe:	ff d0                	callq  *%rax
  kill(pid3);
    2100:	8b 45 f4             	mov    -0xc(%rbp),%eax
    2103:	89 c7                	mov    %eax,%edi
    2105:	48 b8 5b 63 00 00 00 	movabs $0x635b,%rax
    210c:	00 00 00 
    210f:	ff d0                	callq  *%rax
  printf(1, "wait... ");
    2111:	48 be d8 71 00 00 00 	movabs $0x71d8,%rsi
    2118:	00 00 00 
    211b:	bf 01 00 00 00       	mov    $0x1,%edi
    2120:	b8 00 00 00 00       	mov    $0x0,%eax
    2125:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    212c:	00 00 00 
    212f:	ff d2                	callq  *%rdx
  wait();
    2131:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    2138:	00 00 00 
    213b:	ff d0                	callq  *%rax
  wait();
    213d:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    2144:	00 00 00 
    2147:	ff d0                	callq  *%rax
  wait();
    2149:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    2150:	00 00 00 
    2153:	ff d0                	callq  *%rax
  printf(1, "preempt ok\n");
    2155:	48 be e1 71 00 00 00 	movabs $0x71e1,%rsi
    215c:	00 00 00 
    215f:	bf 01 00 00 00       	mov    $0x1,%edi
    2164:	b8 00 00 00 00       	mov    $0x0,%eax
    2169:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    2170:	00 00 00 
    2173:	ff d2                	callq  *%rdx
}
    2175:	c9                   	leaveq 
    2176:	c3                   	retq   

0000000000002177 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
    2177:	f3 0f 1e fa          	endbr64 
    217b:	55                   	push   %rbp
    217c:	48 89 e5             	mov    %rsp,%rbp
    217f:	48 83 ec 10          	sub    $0x10,%rsp
  int i, pid;

  for(i = 0; i < 100; i++){
    2183:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    218a:	e9 80 00 00 00       	jmpq   220f <exitwait+0x98>
    pid = fork();
    218f:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    2196:	00 00 00 
    2199:	ff d0                	callq  *%rax
    219b:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(pid < 0){
    219e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    21a2:	79 22                	jns    21c6 <exitwait+0x4f>
      printf(1, "fork");
    21a4:	48 be b7 6d 00 00 00 	movabs $0x6db7,%rsi
    21ab:	00 00 00 
    21ae:	bf 01 00 00 00       	mov    $0x1,%edi
    21b3:	b8 00 00 00 00       	mov    $0x0,%eax
    21b8:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    21bf:	00 00 00 
    21c2:	ff d2                	callq  *%rdx
      return;
    21c4:	eb 73                	jmp    2239 <exitwait+0xc2>
    }
    if(pid){
    21c6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    21ca:	74 33                	je     21ff <exitwait+0x88>
      if(wait() != pid){
    21cc:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    21d3:	00 00 00 
    21d6:	ff d0                	callq  *%rax
    21d8:	39 45 f8             	cmp    %eax,-0x8(%rbp)
    21db:	74 2e                	je     220b <exitwait+0x94>
        printf(1, "wait wrong pid\n");
    21dd:	48 be ed 71 00 00 00 	movabs $0x71ed,%rsi
    21e4:	00 00 00 
    21e7:	bf 01 00 00 00       	mov    $0x1,%edi
    21ec:	b8 00 00 00 00       	mov    $0x0,%eax
    21f1:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    21f8:	00 00 00 
    21fb:	ff d2                	callq  *%rdx
        return;
    21fd:	eb 3a                	jmp    2239 <exitwait+0xc2>
      }
    } else {
      exit();
    21ff:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    2206:	00 00 00 
    2209:	ff d0                	callq  *%rax
  for(i = 0; i < 100; i++){
    220b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    220f:	83 7d fc 63          	cmpl   $0x63,-0x4(%rbp)
    2213:	0f 8e 76 ff ff ff    	jle    218f <exitwait+0x18>
    }
  }
  printf(1, "exitwait ok\n");
    2219:	48 be fd 71 00 00 00 	movabs $0x71fd,%rsi
    2220:	00 00 00 
    2223:	bf 01 00 00 00       	mov    $0x1,%edi
    2228:	b8 00 00 00 00       	mov    $0x0,%eax
    222d:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    2234:	00 00 00 
    2237:	ff d2                	callq  *%rdx
}
    2239:	c9                   	leaveq 
    223a:	c3                   	retq   

000000000000223b <mem>:

void
mem(void)
{
    223b:	f3 0f 1e fa          	endbr64 
    223f:	55                   	push   %rbp
    2240:	48 89 e5             	mov    %rsp,%rbp
    2243:	48 83 ec 20          	sub    $0x20,%rsp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
    2247:	48 be 0a 72 00 00 00 	movabs $0x720a,%rsi
    224e:	00 00 00 
    2251:	bf 01 00 00 00       	mov    $0x1,%edi
    2256:	b8 00 00 00 00       	mov    $0x0,%eax
    225b:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    2262:	00 00 00 
    2265:	ff d2                	callq  *%rdx
  ppid = getpid();
    2267:	48 b8 dd 63 00 00 00 	movabs $0x63dd,%rax
    226e:	00 00 00 
    2271:	ff d0                	callq  *%rax
    2273:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if((pid = fork()) == 0){
    2276:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    227d:	00 00 00 
    2280:	ff d0                	callq  *%rax
    2282:	89 45 f0             	mov    %eax,-0x10(%rbp)
    2285:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    2289:	0f 85 20 01 00 00    	jne    23af <mem+0x174>
    m1 = 0;
    228f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
    2296:	00 
    while((m2 = malloc(100001)) != 0){
    2297:	eb 13                	jmp    22ac <mem+0x71>
      //printf(1, "m2 %p\n", m2);
      *(void**)m2 = m1;
    2299:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    229d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
    22a1:	48 89 10             	mov    %rdx,(%rax)
      m1 = m2;
    22a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    22a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    while((m2 = malloc(100001)) != 0){
    22ac:	bf a1 86 01 00       	mov    $0x186a1,%edi
    22b1:	48 b8 d6 6b 00 00 00 	movabs $0x6bd6,%rax
    22b8:	00 00 00 
    22bb:	ff d0                	callq  *%rax
    22bd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    22c1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
    22c6:	75 d1                	jne    2299 <mem+0x5e>
    }
    printf(1, "alloc ended\n");
    22c8:	48 be 14 72 00 00 00 	movabs $0x7214,%rsi
    22cf:	00 00 00 
    22d2:	bf 01 00 00 00       	mov    $0x1,%edi
    22d7:	b8 00 00 00 00       	mov    $0x0,%eax
    22dc:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    22e3:	00 00 00 
    22e6:	ff d2                	callq  *%rdx
    while(m1){
    22e8:	eb 26                	jmp    2310 <mem+0xd5>
      m2 = *(void**)m1;
    22ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22ee:	48 8b 00             	mov    (%rax),%rax
    22f1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      free(m1);
    22f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22f9:	48 89 c7             	mov    %rax,%rdi
    22fc:	48 b8 21 6a 00 00 00 	movabs $0x6a21,%rax
    2303:	00 00 00 
    2306:	ff d0                	callq  *%rax
      m1 = m2;
    2308:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    230c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    while(m1){
    2310:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2315:	75 d3                	jne    22ea <mem+0xaf>
    }
    m1 = malloc(1024*20);
    2317:	bf 00 50 00 00       	mov    $0x5000,%edi
    231c:	48 b8 d6 6b 00 00 00 	movabs $0x6bd6,%rax
    2323:	00 00 00 
    2326:	ff d0                	callq  *%rax
    2328:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(m1 == 0){
    232c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2331:	75 3d                	jne    2370 <mem+0x135>
      printf(1, "couldn't allocate mem?!!\n");
    2333:	48 be 21 72 00 00 00 	movabs $0x7221,%rsi
    233a:	00 00 00 
    233d:	bf 01 00 00 00       	mov    $0x1,%edi
    2342:	b8 00 00 00 00       	mov    $0x0,%eax
    2347:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    234e:	00 00 00 
    2351:	ff d2                	callq  *%rdx
      kill(ppid);
    2353:	8b 45 f4             	mov    -0xc(%rbp),%eax
    2356:	89 c7                	mov    %eax,%edi
    2358:	48 b8 5b 63 00 00 00 	movabs $0x635b,%rax
    235f:	00 00 00 
    2362:	ff d0                	callq  *%rax
      exit();
    2364:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    236b:	00 00 00 
    236e:	ff d0                	callq  *%rax
    }
    free(m1);
    2370:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2374:	48 89 c7             	mov    %rax,%rdi
    2377:	48 b8 21 6a 00 00 00 	movabs $0x6a21,%rax
    237e:	00 00 00 
    2381:	ff d0                	callq  *%rax
    printf(1, "mem ok\n");
    2383:	48 be 3b 72 00 00 00 	movabs $0x723b,%rsi
    238a:	00 00 00 
    238d:	bf 01 00 00 00       	mov    $0x1,%edi
    2392:	b8 00 00 00 00       	mov    $0x0,%eax
    2397:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    239e:	00 00 00 
    23a1:	ff d2                	callq  *%rdx
    exit();
    23a3:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    23aa:	00 00 00 
    23ad:	ff d0                	callq  *%rax
  } else {
    wait();
    23af:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    23b6:	00 00 00 
    23b9:	ff d0                	callq  *%rax
  }
}
    23bb:	90                   	nop
    23bc:	c9                   	leaveq 
    23bd:	c3                   	retq   

00000000000023be <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
    23be:	f3 0f 1e fa          	endbr64 
    23c2:	55                   	push   %rbp
    23c3:	48 89 e5             	mov    %rsp,%rbp
    23c6:	48 83 ec 30          	sub    $0x30,%rsp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
    23ca:	48 be 43 72 00 00 00 	movabs $0x7243,%rsi
    23d1:	00 00 00 
    23d4:	bf 01 00 00 00       	mov    $0x1,%edi
    23d9:	b8 00 00 00 00       	mov    $0x0,%eax
    23de:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    23e5:	00 00 00 
    23e8:	ff d2                	callq  *%rdx

  unlink("sharedfd");
    23ea:	48 bf 52 72 00 00 00 	movabs $0x7252,%rdi
    23f1:	00 00 00 
    23f4:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    23fb:	00 00 00 
    23fe:	ff d0                	callq  *%rax
  fd = open("sharedfd", O_CREATE|O_RDWR);
    2400:	be 02 02 00 00       	mov    $0x202,%esi
    2405:	48 bf 52 72 00 00 00 	movabs $0x7252,%rdi
    240c:	00 00 00 
    240f:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    2416:	00 00 00 
    2419:	ff d0                	callq  *%rax
    241b:	89 45 f0             	mov    %eax,-0x10(%rbp)
  if(fd < 0){
    241e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    2422:	79 25                	jns    2449 <sharedfd+0x8b>
    printf(1, "fstests: cannot open sharedfd for writing");
    2424:	48 be 60 72 00 00 00 	movabs $0x7260,%rsi
    242b:	00 00 00 
    242e:	bf 01 00 00 00       	mov    $0x1,%edi
    2433:	b8 00 00 00 00       	mov    $0x0,%eax
    2438:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    243f:	00 00 00 
    2442:	ff d2                	callq  *%rdx
    return;
    2444:	e9 0d 02 00 00       	jmpq   2656 <sharedfd+0x298>
  }
  pid = fork();
    2449:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    2450:	00 00 00 
    2453:	ff d0                	callq  *%rax
    2455:	89 45 ec             	mov    %eax,-0x14(%rbp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
    2458:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
    245c:	75 07                	jne    2465 <sharedfd+0xa7>
    245e:	b9 63 00 00 00       	mov    $0x63,%ecx
    2463:	eb 05                	jmp    246a <sharedfd+0xac>
    2465:	b9 70 00 00 00       	mov    $0x70,%ecx
    246a:	48 8d 45 de          	lea    -0x22(%rbp),%rax
    246e:	ba 0a 00 00 00       	mov    $0xa,%edx
    2473:	89 ce                	mov    %ecx,%esi
    2475:	48 89 c7             	mov    %rax,%rdi
    2478:	48 b8 d8 60 00 00 00 	movabs $0x60d8,%rax
    247f:	00 00 00 
    2482:	ff d0                	callq  *%rax
  for(i = 0; i < 1000; i++){
    2484:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    248b:	eb 48                	jmp    24d5 <sharedfd+0x117>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    248d:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
    2491:	8b 45 f0             	mov    -0x10(%rbp),%eax
    2494:	ba 0a 00 00 00       	mov    $0xa,%edx
    2499:	48 89 ce             	mov    %rcx,%rsi
    249c:	89 c7                	mov    %eax,%edi
    249e:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    24a5:	00 00 00 
    24a8:	ff d0                	callq  *%rax
    24aa:	83 f8 0a             	cmp    $0xa,%eax
    24ad:	74 22                	je     24d1 <sharedfd+0x113>
      printf(1, "fstests: write sharedfd failed\n");
    24af:	48 be 90 72 00 00 00 	movabs $0x7290,%rsi
    24b6:	00 00 00 
    24b9:	bf 01 00 00 00       	mov    $0x1,%edi
    24be:	b8 00 00 00 00       	mov    $0x0,%eax
    24c3:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    24ca:	00 00 00 
    24cd:	ff d2                	callq  *%rdx
      break;
    24cf:	eb 0d                	jmp    24de <sharedfd+0x120>
  for(i = 0; i < 1000; i++){
    24d1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    24d5:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
    24dc:	7e af                	jle    248d <sharedfd+0xcf>
    }
  }
  if(pid == 0)
    24de:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
    24e2:	75 0c                	jne    24f0 <sharedfd+0x132>
    exit();
    24e4:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    24eb:	00 00 00 
    24ee:	ff d0                	callq  *%rax
  else
    wait();
    24f0:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    24f7:	00 00 00 
    24fa:	ff d0                	callq  *%rax
  close(fd);
    24fc:	8b 45 f0             	mov    -0x10(%rbp),%eax
    24ff:	89 c7                	mov    %eax,%edi
    2501:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    2508:	00 00 00 
    250b:	ff d0                	callq  *%rax
  fd = open("sharedfd", 0);
    250d:	be 00 00 00 00       	mov    $0x0,%esi
    2512:	48 bf 52 72 00 00 00 	movabs $0x7252,%rdi
    2519:	00 00 00 
    251c:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    2523:	00 00 00 
    2526:	ff d0                	callq  *%rax
    2528:	89 45 f0             	mov    %eax,-0x10(%rbp)
  if(fd < 0){
    252b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    252f:	79 25                	jns    2556 <sharedfd+0x198>
    printf(1, "fstests: cannot open sharedfd for reading\n");
    2531:	48 be b0 72 00 00 00 	movabs $0x72b0,%rsi
    2538:	00 00 00 
    253b:	bf 01 00 00 00       	mov    $0x1,%edi
    2540:	b8 00 00 00 00       	mov    $0x0,%eax
    2545:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    254c:	00 00 00 
    254f:	ff d2                	callq  *%rdx
    return;
    2551:	e9 00 01 00 00       	jmpq   2656 <sharedfd+0x298>
  }
  nc = np = 0;
    2556:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    255d:	8b 45 f4             	mov    -0xc(%rbp),%eax
    2560:	89 45 f8             	mov    %eax,-0x8(%rbp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    2563:	eb 39                	jmp    259e <sharedfd+0x1e0>
    for(i = 0; i < sizeof(buf); i++){
    2565:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    256c:	eb 28                	jmp    2596 <sharedfd+0x1d8>
      if(buf[i] == 'c')
    256e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2571:	48 98                	cltq   
    2573:	0f b6 44 05 de       	movzbl -0x22(%rbp,%rax,1),%eax
    2578:	3c 63                	cmp    $0x63,%al
    257a:	75 04                	jne    2580 <sharedfd+0x1c2>
        nc++;
    257c:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
      if(buf[i] == 'p')
    2580:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2583:	48 98                	cltq   
    2585:	0f b6 44 05 de       	movzbl -0x22(%rbp,%rax,1),%eax
    258a:	3c 70                	cmp    $0x70,%al
    258c:	75 04                	jne    2592 <sharedfd+0x1d4>
        np++;
    258e:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
    for(i = 0; i < sizeof(buf); i++){
    2592:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2596:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2599:	83 f8 09             	cmp    $0x9,%eax
    259c:	76 d0                	jbe    256e <sharedfd+0x1b0>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    259e:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
    25a2:	8b 45 f0             	mov    -0x10(%rbp),%eax
    25a5:	ba 0a 00 00 00       	mov    $0xa,%edx
    25aa:	48 89 ce             	mov    %rcx,%rsi
    25ad:	89 c7                	mov    %eax,%edi
    25af:	48 b8 34 63 00 00 00 	movabs $0x6334,%rax
    25b6:	00 00 00 
    25b9:	ff d0                	callq  *%rax
    25bb:	89 45 e8             	mov    %eax,-0x18(%rbp)
    25be:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
    25c2:	7f a1                	jg     2565 <sharedfd+0x1a7>
    }
  }
  close(fd);
    25c4:	8b 45 f0             	mov    -0x10(%rbp),%eax
    25c7:	89 c7                	mov    %eax,%edi
    25c9:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    25d0:	00 00 00 
    25d3:	ff d0                	callq  *%rax
  unlink("sharedfd");
    25d5:	48 bf 52 72 00 00 00 	movabs $0x7252,%rdi
    25dc:	00 00 00 
    25df:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    25e6:	00 00 00 
    25e9:	ff d0                	callq  *%rax
  if(nc == 10000 && np == 10000){
    25eb:	81 7d f8 10 27 00 00 	cmpl   $0x2710,-0x8(%rbp)
    25f2:	75 2b                	jne    261f <sharedfd+0x261>
    25f4:	81 7d f4 10 27 00 00 	cmpl   $0x2710,-0xc(%rbp)
    25fb:	75 22                	jne    261f <sharedfd+0x261>
    printf(1, "sharedfd ok\n");
    25fd:	48 be db 72 00 00 00 	movabs $0x72db,%rsi
    2604:	00 00 00 
    2607:	bf 01 00 00 00       	mov    $0x1,%edi
    260c:	b8 00 00 00 00       	mov    $0x0,%eax
    2611:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    2618:	00 00 00 
    261b:	ff d2                	callq  *%rdx
    261d:	eb 37                	jmp    2656 <sharedfd+0x298>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    261f:	8b 55 f4             	mov    -0xc(%rbp),%edx
    2622:	8b 45 f8             	mov    -0x8(%rbp),%eax
    2625:	89 d1                	mov    %edx,%ecx
    2627:	89 c2                	mov    %eax,%edx
    2629:	48 be e8 72 00 00 00 	movabs $0x72e8,%rsi
    2630:	00 00 00 
    2633:	bf 01 00 00 00       	mov    $0x1,%edi
    2638:	b8 00 00 00 00       	mov    $0x0,%eax
    263d:	49 b8 11 66 00 00 00 	movabs $0x6611,%r8
    2644:	00 00 00 
    2647:	41 ff d0             	callq  *%r8
    exit();
    264a:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    2651:	00 00 00 
    2654:	ff d0                	callq  *%rax
  }
}
    2656:	c9                   	leaveq 
    2657:	c3                   	retq   

0000000000002658 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    2658:	f3 0f 1e fa          	endbr64 
    265c:	55                   	push   %rbp
    265d:	48 89 e5             	mov    %rsp,%rbp
    2660:	48 83 ec 50          	sub    $0x50,%rsp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    2664:	48 b8 fd 72 00 00 00 	movabs $0x72fd,%rax
    266b:	00 00 00 
    266e:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
    2672:	48 b8 00 73 00 00 00 	movabs $0x7300,%rax
    2679:	00 00 00 
    267c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    2680:	48 b8 03 73 00 00 00 	movabs $0x7303,%rax
    2687:	00 00 00 
    268a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    268e:	48 b8 06 73 00 00 00 	movabs $0x7306,%rax
    2695:	00 00 00 
    2698:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  char *fname;

  printf(1, "fourfiles test\n");
    269c:	48 be 09 73 00 00 00 	movabs $0x7309,%rsi
    26a3:	00 00 00 
    26a6:	bf 01 00 00 00       	mov    $0x1,%edi
    26ab:	b8 00 00 00 00       	mov    $0x0,%eax
    26b0:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    26b7:	00 00 00 
    26ba:	ff d2                	callq  *%rdx

  for(pi = 0; pi < 4; pi++){
    26bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
    26c3:	e9 30 01 00 00       	jmpq   27f8 <fourfiles+0x1a0>
    fname = names[pi];
    26c8:	8b 45 f0             	mov    -0x10(%rbp),%eax
    26cb:	48 98                	cltq   
    26cd:	48 8b 44 c5 b0       	mov    -0x50(%rbp,%rax,8),%rax
    26d2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    unlink(fname);
    26d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    26da:	48 89 c7             	mov    %rax,%rdi
    26dd:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    26e4:	00 00 00 
    26e7:	ff d0                	callq  *%rax

    pid = fork();
    26e9:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    26f0:	00 00 00 
    26f3:	ff d0                	callq  *%rax
    26f5:	89 45 dc             	mov    %eax,-0x24(%rbp)
    if(pid < 0){
    26f8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
    26fc:	79 16                	jns    2714 <fourfiles+0xbc>
      failexit("fork");
    26fe:	48 bf b7 6d 00 00 00 	movabs $0x6db7,%rdi
    2705:	00 00 00 
    2708:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    270f:	00 00 00 
    2712:	ff d0                	callq  *%rax
    }

    if(pid == 0){
    2714:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
    2718:	0f 85 d6 00 00 00    	jne    27f4 <fourfiles+0x19c>
      fd = open(fname, O_CREATE | O_RDWR);
    271e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2722:	be 02 02 00 00       	mov    $0x202,%esi
    2727:	48 89 c7             	mov    %rax,%rdi
    272a:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    2731:	00 00 00 
    2734:	ff d0                	callq  *%rax
    2736:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      if(fd < 0){
    2739:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
    273d:	79 16                	jns    2755 <fourfiles+0xfd>
        failexit("create");
    273f:	48 bf 19 73 00 00 00 	movabs $0x7319,%rdi
    2746:	00 00 00 
    2749:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2750:	00 00 00 
    2753:	ff d0                	callq  *%rax
      }

      memset(buf, '0'+pi, 512);
    2755:	8b 45 f0             	mov    -0x10(%rbp),%eax
    2758:	83 c0 30             	add    $0x30,%eax
    275b:	ba 00 02 00 00       	mov    $0x200,%edx
    2760:	89 c6                	mov    %eax,%esi
    2762:	48 bf 20 8c 00 00 00 	movabs $0x8c20,%rdi
    2769:	00 00 00 
    276c:	48 b8 d8 60 00 00 00 	movabs $0x60d8,%rax
    2773:	00 00 00 
    2776:	ff d0                	callq  *%rax
      for(i = 0; i < 12; i++){
    2778:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    277f:	eb 61                	jmp    27e2 <fourfiles+0x18a>
        if((n = write(fd, buf, 500)) != 500){
    2781:	8b 45 e4             	mov    -0x1c(%rbp),%eax
    2784:	ba f4 01 00 00       	mov    $0x1f4,%edx
    2789:	48 be 20 8c 00 00 00 	movabs $0x8c20,%rsi
    2790:	00 00 00 
    2793:	89 c7                	mov    %eax,%edi
    2795:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    279c:	00 00 00 
    279f:	ff d0                	callq  *%rax
    27a1:	89 45 e0             	mov    %eax,-0x20(%rbp)
    27a4:	81 7d e0 f4 01 00 00 	cmpl   $0x1f4,-0x20(%rbp)
    27ab:	74 31                	je     27de <fourfiles+0x186>
          printf(1, "write failed %d\n", n);
    27ad:	8b 45 e0             	mov    -0x20(%rbp),%eax
    27b0:	89 c2                	mov    %eax,%edx
    27b2:	48 be 20 73 00 00 00 	movabs $0x7320,%rsi
    27b9:	00 00 00 
    27bc:	bf 01 00 00 00       	mov    $0x1,%edi
    27c1:	b8 00 00 00 00       	mov    $0x0,%eax
    27c6:	48 b9 11 66 00 00 00 	movabs $0x6611,%rcx
    27cd:	00 00 00 
    27d0:	ff d1                	callq  *%rcx
          exit();
    27d2:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    27d9:	00 00 00 
    27dc:	ff d0                	callq  *%rax
      for(i = 0; i < 12; i++){
    27de:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    27e2:	83 7d fc 0b          	cmpl   $0xb,-0x4(%rbp)
    27e6:	7e 99                	jle    2781 <fourfiles+0x129>
        }
      }
      exit();
    27e8:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    27ef:	00 00 00 
    27f2:	ff d0                	callq  *%rax
  for(pi = 0; pi < 4; pi++){
    27f4:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
    27f8:	83 7d f0 03          	cmpl   $0x3,-0x10(%rbp)
    27fc:	0f 8e c6 fe ff ff    	jle    26c8 <fourfiles+0x70>
    }
  }

  for(pi = 0; pi < 4; pi++){
    2802:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
    2809:	eb 10                	jmp    281b <fourfiles+0x1c3>
    wait();
    280b:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    2812:	00 00 00 
    2815:	ff d0                	callq  *%rax
  for(pi = 0; pi < 4; pi++){
    2817:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
    281b:	83 7d f0 03          	cmpl   $0x3,-0x10(%rbp)
    281f:	7e ea                	jle    280b <fourfiles+0x1b3>
  }

  for(i = 0; i < 2; i++){
    2821:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    2828:	e9 0e 01 00 00       	jmpq   293b <fourfiles+0x2e3>
    fname = names[i];
    282d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2830:	48 98                	cltq   
    2832:	48 8b 44 c5 b0       	mov    -0x50(%rbp,%rax,8),%rax
    2837:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    fd = open(fname, 0);
    283b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    283f:	be 00 00 00 00       	mov    $0x0,%esi
    2844:	48 89 c7             	mov    %rax,%rdi
    2847:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    284e:	00 00 00 
    2851:	ff d0                	callq  *%rax
    2853:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    total = 0;
    2856:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    285d:	eb 51                	jmp    28b0 <fourfiles+0x258>
      for(j = 0; j < n; j++){
    285f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    2866:	eb 3a                	jmp    28a2 <fourfiles+0x24a>
        if(buf[j] != '0'+i){
    2868:	48 ba 20 8c 00 00 00 	movabs $0x8c20,%rdx
    286f:	00 00 00 
    2872:	8b 45 f8             	mov    -0x8(%rbp),%eax
    2875:	48 98                	cltq   
    2877:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    287b:	0f be c0             	movsbl %al,%eax
    287e:	8b 55 fc             	mov    -0x4(%rbp),%edx
    2881:	83 c2 30             	add    $0x30,%edx
    2884:	39 d0                	cmp    %edx,%eax
    2886:	74 16                	je     289e <fourfiles+0x246>
          failexit("wrong char");
    2888:	48 bf 31 73 00 00 00 	movabs $0x7331,%rdi
    288f:	00 00 00 
    2892:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2899:	00 00 00 
    289c:	ff d0                	callq  *%rax
      for(j = 0; j < n; j++){
    289e:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    28a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
    28a5:	3b 45 e0             	cmp    -0x20(%rbp),%eax
    28a8:	7c be                	jl     2868 <fourfiles+0x210>
        }
      }
      total += n;
    28aa:	8b 45 e0             	mov    -0x20(%rbp),%eax
    28ad:	01 45 f4             	add    %eax,-0xc(%rbp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    28b0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
    28b3:	ba 00 20 00 00       	mov    $0x2000,%edx
    28b8:	48 be 20 8c 00 00 00 	movabs $0x8c20,%rsi
    28bf:	00 00 00 
    28c2:	89 c7                	mov    %eax,%edi
    28c4:	48 b8 34 63 00 00 00 	movabs $0x6334,%rax
    28cb:	00 00 00 
    28ce:	ff d0                	callq  *%rax
    28d0:	89 45 e0             	mov    %eax,-0x20(%rbp)
    28d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
    28d7:	7f 86                	jg     285f <fourfiles+0x207>
    }
    close(fd);
    28d9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
    28dc:	89 c7                	mov    %eax,%edi
    28de:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    28e5:	00 00 00 
    28e8:	ff d0                	callq  *%rax
    if(total != 12*500){
    28ea:	81 7d f4 70 17 00 00 	cmpl   $0x1770,-0xc(%rbp)
    28f1:	74 31                	je     2924 <fourfiles+0x2cc>
      printf(1, "wrong length %d\n", total);
    28f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
    28f6:	89 c2                	mov    %eax,%edx
    28f8:	48 be 3c 73 00 00 00 	movabs $0x733c,%rsi
    28ff:	00 00 00 
    2902:	bf 01 00 00 00       	mov    $0x1,%edi
    2907:	b8 00 00 00 00       	mov    $0x0,%eax
    290c:	48 b9 11 66 00 00 00 	movabs $0x6611,%rcx
    2913:	00 00 00 
    2916:	ff d1                	callq  *%rcx
      exit();
    2918:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    291f:	00 00 00 
    2922:	ff d0                	callq  *%rax
    }
    unlink(fname);
    2924:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2928:	48 89 c7             	mov    %rax,%rdi
    292b:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    2932:	00 00 00 
    2935:	ff d0                	callq  *%rax
  for(i = 0; i < 2; i++){
    2937:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    293b:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
    293f:	0f 8e e8 fe ff ff    	jle    282d <fourfiles+0x1d5>
  }

  printf(1, "fourfiles ok\n");
    2945:	48 be 4d 73 00 00 00 	movabs $0x734d,%rsi
    294c:	00 00 00 
    294f:	bf 01 00 00 00       	mov    $0x1,%edi
    2954:	b8 00 00 00 00       	mov    $0x0,%eax
    2959:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    2960:	00 00 00 
    2963:	ff d2                	callq  *%rdx
}
    2965:	90                   	nop
    2966:	c9                   	leaveq 
    2967:	c3                   	retq   

0000000000002968 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    2968:	f3 0f 1e fa          	endbr64 
    296c:	55                   	push   %rbp
    296d:	48 89 e5             	mov    %rsp,%rbp
    2970:	48 83 ec 30          	sub    $0x30,%rsp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    2974:	48 be 5b 73 00 00 00 	movabs $0x735b,%rsi
    297b:	00 00 00 
    297e:	bf 01 00 00 00       	mov    $0x1,%edi
    2983:	b8 00 00 00 00       	mov    $0x0,%eax
    2988:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    298f:	00 00 00 
    2992:	ff d2                	callq  *%rdx

  for(pi = 0; pi < 4; pi++){
    2994:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    299b:	e9 0c 01 00 00       	jmpq   2aac <createdelete+0x144>
    pid = fork();
    29a0:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    29a7:	00 00 00 
    29aa:	ff d0                	callq  *%rax
    29ac:	89 45 f0             	mov    %eax,-0x10(%rbp)
    if(pid < 0){
    29af:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    29b3:	79 16                	jns    29cb <createdelete+0x63>
      failexit("fork");
    29b5:	48 bf b7 6d 00 00 00 	movabs $0x6db7,%rdi
    29bc:	00 00 00 
    29bf:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    29c6:	00 00 00 
    29c9:	ff d0                	callq  *%rax
    }

    if(pid == 0){
    29cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    29cf:	0f 85 d3 00 00 00    	jne    2aa8 <createdelete+0x140>
      name[0] = 'p' + pi;
    29d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
    29d8:	83 c0 70             	add    $0x70,%eax
    29db:	88 45 d0             	mov    %al,-0x30(%rbp)
      name[2] = '\0';
    29de:	c6 45 d2 00          	movb   $0x0,-0x2e(%rbp)
      for(i = 0; i < N; i++){
    29e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    29e9:	e9 a4 00 00 00       	jmpq   2a92 <createdelete+0x12a>
        name[1] = '0' + i;
    29ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
    29f1:	83 c0 30             	add    $0x30,%eax
    29f4:	88 45 d1             	mov    %al,-0x2f(%rbp)
        fd = open(name, O_CREATE | O_RDWR);
    29f7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
    29fb:	be 02 02 00 00       	mov    $0x202,%esi
    2a00:	48 89 c7             	mov    %rax,%rdi
    2a03:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    2a0a:	00 00 00 
    2a0d:	ff d0                	callq  *%rax
    2a0f:	89 45 f4             	mov    %eax,-0xc(%rbp)
        if(fd < 0){
    2a12:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    2a16:	79 16                	jns    2a2e <createdelete+0xc6>
          failexit("create");
    2a18:	48 bf 19 73 00 00 00 	movabs $0x7319,%rdi
    2a1f:	00 00 00 
    2a22:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2a29:	00 00 00 
    2a2c:	ff d0                	callq  *%rax
        }
        close(fd);
    2a2e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    2a31:	89 c7                	mov    %eax,%edi
    2a33:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    2a3a:	00 00 00 
    2a3d:	ff d0                	callq  *%rax
        if(i > 0 && (i % 2 ) == 0){
    2a3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    2a43:	7e 49                	jle    2a8e <createdelete+0x126>
    2a45:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2a48:	83 e0 01             	and    $0x1,%eax
    2a4b:	85 c0                	test   %eax,%eax
    2a4d:	75 3f                	jne    2a8e <createdelete+0x126>
          name[1] = '0' + (i / 2);
    2a4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2a52:	89 c2                	mov    %eax,%edx
    2a54:	c1 ea 1f             	shr    $0x1f,%edx
    2a57:	01 d0                	add    %edx,%eax
    2a59:	d1 f8                	sar    %eax
    2a5b:	83 c0 30             	add    $0x30,%eax
    2a5e:	88 45 d1             	mov    %al,-0x2f(%rbp)
          if(unlink(name) < 0){
    2a61:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
    2a65:	48 89 c7             	mov    %rax,%rdi
    2a68:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    2a6f:	00 00 00 
    2a72:	ff d0                	callq  *%rax
    2a74:	85 c0                	test   %eax,%eax
    2a76:	79 16                	jns    2a8e <createdelete+0x126>
            failexit("unlink");
    2a78:	48 bf 23 6e 00 00 00 	movabs $0x6e23,%rdi
    2a7f:	00 00 00 
    2a82:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2a89:	00 00 00 
    2a8c:	ff d0                	callq  *%rax
      for(i = 0; i < N; i++){
    2a8e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2a92:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
    2a96:	0f 8e 52 ff ff ff    	jle    29ee <createdelete+0x86>
          }
        }
      }
      exit();
    2a9c:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    2aa3:	00 00 00 
    2aa6:	ff d0                	callq  *%rax
  for(pi = 0; pi < 4; pi++){
    2aa8:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    2aac:	83 7d f8 03          	cmpl   $0x3,-0x8(%rbp)
    2ab0:	0f 8e ea fe ff ff    	jle    29a0 <createdelete+0x38>
    }
  }

  for(pi = 0; pi < 4; pi++){
    2ab6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    2abd:	eb 10                	jmp    2acf <createdelete+0x167>
    wait();
    2abf:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    2ac6:	00 00 00 
    2ac9:	ff d0                	callq  *%rax
  for(pi = 0; pi < 4; pi++){
    2acb:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    2acf:	83 7d f8 03          	cmpl   $0x3,-0x8(%rbp)
    2ad3:	7e ea                	jle    2abf <createdelete+0x157>
  }

  name[0] = name[1] = name[2] = 0;
    2ad5:	c6 45 d2 00          	movb   $0x0,-0x2e(%rbp)
    2ad9:	0f b6 45 d2          	movzbl -0x2e(%rbp),%eax
    2add:	88 45 d1             	mov    %al,-0x2f(%rbp)
    2ae0:	0f b6 45 d1          	movzbl -0x2f(%rbp),%eax
    2ae4:	88 45 d0             	mov    %al,-0x30(%rbp)
  for(i = 0; i < N; i++){
    2ae7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    2aee:	e9 ec 00 00 00       	jmpq   2bdf <createdelete+0x277>
    for(pi = 0; pi < 4; pi++){
    2af3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    2afa:	e9 d2 00 00 00       	jmpq   2bd1 <createdelete+0x269>
      name[0] = 'p' + pi;
    2aff:	8b 45 f8             	mov    -0x8(%rbp),%eax
    2b02:	83 c0 70             	add    $0x70,%eax
    2b05:	88 45 d0             	mov    %al,-0x30(%rbp)
      name[1] = '0' + i;
    2b08:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2b0b:	83 c0 30             	add    $0x30,%eax
    2b0e:	88 45 d1             	mov    %al,-0x2f(%rbp)
      fd = open(name, 0);
    2b11:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
    2b15:	be 00 00 00 00       	mov    $0x0,%esi
    2b1a:	48 89 c7             	mov    %rax,%rdi
    2b1d:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    2b24:	00 00 00 
    2b27:	ff d0                	callq  *%rax
    2b29:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if((i == 0 || i >= N/2) && fd < 0){
    2b2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    2b30:	74 06                	je     2b38 <createdelete+0x1d0>
    2b32:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
    2b36:	7e 39                	jle    2b71 <createdelete+0x209>
    2b38:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    2b3c:	79 33                	jns    2b71 <createdelete+0x209>
        printf(1, "oops createdelete %s didn't exist\n", name);
    2b3e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
    2b42:	48 89 c2             	mov    %rax,%rdx
    2b45:	48 be 70 73 00 00 00 	movabs $0x7370,%rsi
    2b4c:	00 00 00 
    2b4f:	bf 01 00 00 00       	mov    $0x1,%edi
    2b54:	b8 00 00 00 00       	mov    $0x0,%eax
    2b59:	48 b9 11 66 00 00 00 	movabs $0x6611,%rcx
    2b60:	00 00 00 
    2b63:	ff d1                	callq  *%rcx
        exit();
    2b65:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    2b6c:	00 00 00 
    2b6f:	ff d0                	callq  *%rax
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2b71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    2b75:	7e 3f                	jle    2bb6 <createdelete+0x24e>
    2b77:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
    2b7b:	7f 39                	jg     2bb6 <createdelete+0x24e>
    2b7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    2b81:	78 33                	js     2bb6 <createdelete+0x24e>
        printf(1, "oops createdelete %s did exist\n", name);
    2b83:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
    2b87:	48 89 c2             	mov    %rax,%rdx
    2b8a:	48 be 98 73 00 00 00 	movabs $0x7398,%rsi
    2b91:	00 00 00 
    2b94:	bf 01 00 00 00       	mov    $0x1,%edi
    2b99:	b8 00 00 00 00       	mov    $0x0,%eax
    2b9e:	48 b9 11 66 00 00 00 	movabs $0x6611,%rcx
    2ba5:	00 00 00 
    2ba8:	ff d1                	callq  *%rcx
        exit();
    2baa:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    2bb1:	00 00 00 
    2bb4:	ff d0                	callq  *%rax
      }
      if(fd >= 0)
    2bb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    2bba:	78 11                	js     2bcd <createdelete+0x265>
        close(fd);
    2bbc:	8b 45 f4             	mov    -0xc(%rbp),%eax
    2bbf:	89 c7                	mov    %eax,%edi
    2bc1:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    2bc8:	00 00 00 
    2bcb:	ff d0                	callq  *%rax
    for(pi = 0; pi < 4; pi++){
    2bcd:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    2bd1:	83 7d f8 03          	cmpl   $0x3,-0x8(%rbp)
    2bd5:	0f 8e 24 ff ff ff    	jle    2aff <createdelete+0x197>
  for(i = 0; i < N; i++){
    2bdb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2bdf:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
    2be3:	0f 8e 0a ff ff ff    	jle    2af3 <createdelete+0x18b>
    }
  }

  for(i = 0; i < N; i++){
    2be9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    2bf0:	eb 3c                	jmp    2c2e <createdelete+0x2c6>
    for(pi = 0; pi < 4; pi++){
    2bf2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    2bf9:	eb 29                	jmp    2c24 <createdelete+0x2bc>
      name[0] = 'p' + i;
    2bfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2bfe:	83 c0 70             	add    $0x70,%eax
    2c01:	88 45 d0             	mov    %al,-0x30(%rbp)
      name[1] = '0' + i;
    2c04:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2c07:	83 c0 30             	add    $0x30,%eax
    2c0a:	88 45 d1             	mov    %al,-0x2f(%rbp)
      unlink(name);
    2c0d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
    2c11:	48 89 c7             	mov    %rax,%rdi
    2c14:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    2c1b:	00 00 00 
    2c1e:	ff d0                	callq  *%rax
    for(pi = 0; pi < 4; pi++){
    2c20:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    2c24:	83 7d f8 03          	cmpl   $0x3,-0x8(%rbp)
    2c28:	7e d1                	jle    2bfb <createdelete+0x293>
  for(i = 0; i < N; i++){
    2c2a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2c2e:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
    2c32:	7e be                	jle    2bf2 <createdelete+0x28a>
    }
  }

  printf(1, "createdelete ok\n");
    2c34:	48 be b8 73 00 00 00 	movabs $0x73b8,%rsi
    2c3b:	00 00 00 
    2c3e:	bf 01 00 00 00       	mov    $0x1,%edi
    2c43:	b8 00 00 00 00       	mov    $0x0,%eax
    2c48:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    2c4f:	00 00 00 
    2c52:	ff d2                	callq  *%rdx
}
    2c54:	90                   	nop
    2c55:	c9                   	leaveq 
    2c56:	c3                   	retq   

0000000000002c57 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    2c57:	f3 0f 1e fa          	endbr64 
    2c5b:	55                   	push   %rbp
    2c5c:	48 89 e5             	mov    %rsp,%rbp
    2c5f:	48 83 ec 10          	sub    $0x10,%rsp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    2c63:	48 be c9 73 00 00 00 	movabs $0x73c9,%rsi
    2c6a:	00 00 00 
    2c6d:	bf 01 00 00 00       	mov    $0x1,%edi
    2c72:	b8 00 00 00 00       	mov    $0x0,%eax
    2c77:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    2c7e:	00 00 00 
    2c81:	ff d2                	callq  *%rdx
  fd = open("unlinkread", O_CREATE | O_RDWR);
    2c83:	be 02 02 00 00       	mov    $0x202,%esi
    2c88:	48 bf da 73 00 00 00 	movabs $0x73da,%rdi
    2c8f:	00 00 00 
    2c92:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    2c99:	00 00 00 
    2c9c:	ff d0                	callq  *%rax
    2c9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    2ca1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    2ca5:	79 16                	jns    2cbd <unlinkread+0x66>
    failexit("create unlinkread");
    2ca7:	48 bf e5 73 00 00 00 	movabs $0x73e5,%rdi
    2cae:	00 00 00 
    2cb1:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2cb8:	00 00 00 
    2cbb:	ff d0                	callq  *%rax
  }
  write(fd, "hello", 5);
    2cbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2cc0:	ba 05 00 00 00       	mov    $0x5,%edx
    2cc5:	48 be f7 73 00 00 00 	movabs $0x73f7,%rsi
    2ccc:	00 00 00 
    2ccf:	89 c7                	mov    %eax,%edi
    2cd1:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    2cd8:	00 00 00 
    2cdb:	ff d0                	callq  *%rax
  close(fd);
    2cdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2ce0:	89 c7                	mov    %eax,%edi
    2ce2:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    2ce9:	00 00 00 
    2cec:	ff d0                	callq  *%rax

  fd = open("unlinkread", O_RDWR);
    2cee:	be 02 00 00 00       	mov    $0x2,%esi
    2cf3:	48 bf da 73 00 00 00 	movabs $0x73da,%rdi
    2cfa:	00 00 00 
    2cfd:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    2d04:	00 00 00 
    2d07:	ff d0                	callq  *%rax
    2d09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    2d0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    2d10:	79 16                	jns    2d28 <unlinkread+0xd1>
    failexit("open unlinkread");
    2d12:	48 bf fd 73 00 00 00 	movabs $0x73fd,%rdi
    2d19:	00 00 00 
    2d1c:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2d23:	00 00 00 
    2d26:	ff d0                	callq  *%rax
  }
  if(unlink("unlinkread") != 0){
    2d28:	48 bf da 73 00 00 00 	movabs $0x73da,%rdi
    2d2f:	00 00 00 
    2d32:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    2d39:	00 00 00 
    2d3c:	ff d0                	callq  *%rax
    2d3e:	85 c0                	test   %eax,%eax
    2d40:	74 16                	je     2d58 <unlinkread+0x101>
    failexit("unlink unlinkread");
    2d42:	48 bf 0d 74 00 00 00 	movabs $0x740d,%rdi
    2d49:	00 00 00 
    2d4c:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2d53:	00 00 00 
    2d56:	ff d0                	callq  *%rax
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    2d58:	be 02 02 00 00       	mov    $0x202,%esi
    2d5d:	48 bf da 73 00 00 00 	movabs $0x73da,%rdi
    2d64:	00 00 00 
    2d67:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    2d6e:	00 00 00 
    2d71:	ff d0                	callq  *%rax
    2d73:	89 45 f8             	mov    %eax,-0x8(%rbp)
  write(fd1, "yyy", 3);
    2d76:	8b 45 f8             	mov    -0x8(%rbp),%eax
    2d79:	ba 03 00 00 00       	mov    $0x3,%edx
    2d7e:	48 be 1f 74 00 00 00 	movabs $0x741f,%rsi
    2d85:	00 00 00 
    2d88:	89 c7                	mov    %eax,%edi
    2d8a:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    2d91:	00 00 00 
    2d94:	ff d0                	callq  *%rax
  close(fd1);
    2d96:	8b 45 f8             	mov    -0x8(%rbp),%eax
    2d99:	89 c7                	mov    %eax,%edi
    2d9b:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    2da2:	00 00 00 
    2da5:	ff d0                	callq  *%rax

  if(read(fd, buf, sizeof(buf)) != 5){
    2da7:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2daa:	ba 00 20 00 00       	mov    $0x2000,%edx
    2daf:	48 be 20 8c 00 00 00 	movabs $0x8c20,%rsi
    2db6:	00 00 00 
    2db9:	89 c7                	mov    %eax,%edi
    2dbb:	48 b8 34 63 00 00 00 	movabs $0x6334,%rax
    2dc2:	00 00 00 
    2dc5:	ff d0                	callq  *%rax
    2dc7:	83 f8 05             	cmp    $0x5,%eax
    2dca:	74 16                	je     2de2 <unlinkread+0x18b>
    failexit("unlinkread read failed");
    2dcc:	48 bf 23 74 00 00 00 	movabs $0x7423,%rdi
    2dd3:	00 00 00 
    2dd6:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2ddd:	00 00 00 
    2de0:	ff d0                	callq  *%rax
  }
  if(buf[0] != 'h'){
    2de2:	48 b8 20 8c 00 00 00 	movabs $0x8c20,%rax
    2de9:	00 00 00 
    2dec:	0f b6 00             	movzbl (%rax),%eax
    2def:	3c 68                	cmp    $0x68,%al
    2df1:	74 16                	je     2e09 <unlinkread+0x1b2>
    failexit("unlinkread wrong data");
    2df3:	48 bf 3a 74 00 00 00 	movabs $0x743a,%rdi
    2dfa:	00 00 00 
    2dfd:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2e04:	00 00 00 
    2e07:	ff d0                	callq  *%rax
  }
  if(write(fd, buf, 10) != 10){
    2e09:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2e0c:	ba 0a 00 00 00       	mov    $0xa,%edx
    2e11:	48 be 20 8c 00 00 00 	movabs $0x8c20,%rsi
    2e18:	00 00 00 
    2e1b:	89 c7                	mov    %eax,%edi
    2e1d:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    2e24:	00 00 00 
    2e27:	ff d0                	callq  *%rax
    2e29:	83 f8 0a             	cmp    $0xa,%eax
    2e2c:	74 16                	je     2e44 <unlinkread+0x1ed>
    failexit("unlinkread write");
    2e2e:	48 bf 50 74 00 00 00 	movabs $0x7450,%rdi
    2e35:	00 00 00 
    2e38:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2e3f:	00 00 00 
    2e42:	ff d0                	callq  *%rax
  }
  close(fd);
    2e44:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2e47:	89 c7                	mov    %eax,%edi
    2e49:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    2e50:	00 00 00 
    2e53:	ff d0                	callq  *%rax
  unlink("unlinkread");
    2e55:	48 bf da 73 00 00 00 	movabs $0x73da,%rdi
    2e5c:	00 00 00 
    2e5f:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    2e66:	00 00 00 
    2e69:	ff d0                	callq  *%rax
  printf(1, "unlinkread ok\n");
    2e6b:	48 be 61 74 00 00 00 	movabs $0x7461,%rsi
    2e72:	00 00 00 
    2e75:	bf 01 00 00 00       	mov    $0x1,%edi
    2e7a:	b8 00 00 00 00       	mov    $0x0,%eax
    2e7f:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    2e86:	00 00 00 
    2e89:	ff d2                	callq  *%rdx
}
    2e8b:	90                   	nop
    2e8c:	c9                   	leaveq 
    2e8d:	c3                   	retq   

0000000000002e8e <linktest>:

void
linktest(void)
{
    2e8e:	f3 0f 1e fa          	endbr64 
    2e92:	55                   	push   %rbp
    2e93:	48 89 e5             	mov    %rsp,%rbp
    2e96:	48 83 ec 10          	sub    $0x10,%rsp
  int fd;

  printf(1, "linktest\n");
    2e9a:	48 be 70 74 00 00 00 	movabs $0x7470,%rsi
    2ea1:	00 00 00 
    2ea4:	bf 01 00 00 00       	mov    $0x1,%edi
    2ea9:	b8 00 00 00 00       	mov    $0x0,%eax
    2eae:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    2eb5:	00 00 00 
    2eb8:	ff d2                	callq  *%rdx

  unlink("lf1");
    2eba:	48 bf 7a 74 00 00 00 	movabs $0x747a,%rdi
    2ec1:	00 00 00 
    2ec4:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    2ecb:	00 00 00 
    2ece:	ff d0                	callq  *%rax
  unlink("lf2");
    2ed0:	48 bf 7e 74 00 00 00 	movabs $0x747e,%rdi
    2ed7:	00 00 00 
    2eda:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    2ee1:	00 00 00 
    2ee4:	ff d0                	callq  *%rax

  fd = open("lf1", O_CREATE|O_RDWR);
    2ee6:	be 02 02 00 00       	mov    $0x202,%esi
    2eeb:	48 bf 7a 74 00 00 00 	movabs $0x747a,%rdi
    2ef2:	00 00 00 
    2ef5:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    2efc:	00 00 00 
    2eff:	ff d0                	callq  *%rax
    2f01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    2f04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    2f08:	79 16                	jns    2f20 <linktest+0x92>
    failexit("create lf1");
    2f0a:	48 bf 82 74 00 00 00 	movabs $0x7482,%rdi
    2f11:	00 00 00 
    2f14:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2f1b:	00 00 00 
    2f1e:	ff d0                	callq  *%rax
  }
  if(write(fd, "hello", 5) != 5){
    2f20:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2f23:	ba 05 00 00 00       	mov    $0x5,%edx
    2f28:	48 be f7 73 00 00 00 	movabs $0x73f7,%rsi
    2f2f:	00 00 00 
    2f32:	89 c7                	mov    %eax,%edi
    2f34:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    2f3b:	00 00 00 
    2f3e:	ff d0                	callq  *%rax
    2f40:	83 f8 05             	cmp    $0x5,%eax
    2f43:	74 16                	je     2f5b <linktest+0xcd>
    failexit("write lf1");
    2f45:	48 bf 8d 74 00 00 00 	movabs $0x748d,%rdi
    2f4c:	00 00 00 
    2f4f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2f56:	00 00 00 
    2f59:	ff d0                	callq  *%rax
  }
  close(fd);
    2f5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2f5e:	89 c7                	mov    %eax,%edi
    2f60:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    2f67:	00 00 00 
    2f6a:	ff d0                	callq  *%rax

  if(link("lf1", "lf2") < 0){
    2f6c:	48 be 7e 74 00 00 00 	movabs $0x747e,%rsi
    2f73:	00 00 00 
    2f76:	48 bf 7a 74 00 00 00 	movabs $0x747a,%rdi
    2f7d:	00 00 00 
    2f80:	48 b8 a9 63 00 00 00 	movabs $0x63a9,%rax
    2f87:	00 00 00 
    2f8a:	ff d0                	callq  *%rax
    2f8c:	85 c0                	test   %eax,%eax
    2f8e:	79 16                	jns    2fa6 <linktest+0x118>
    failexit("link lf1 lf2");
    2f90:	48 bf 97 74 00 00 00 	movabs $0x7497,%rdi
    2f97:	00 00 00 
    2f9a:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2fa1:	00 00 00 
    2fa4:	ff d0                	callq  *%rax
  }
  unlink("lf1");
    2fa6:	48 bf 7a 74 00 00 00 	movabs $0x747a,%rdi
    2fad:	00 00 00 
    2fb0:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    2fb7:	00 00 00 
    2fba:	ff d0                	callq  *%rax

  if(open("lf1", 0) >= 0){
    2fbc:	be 00 00 00 00       	mov    $0x0,%esi
    2fc1:	48 bf 7a 74 00 00 00 	movabs $0x747a,%rdi
    2fc8:	00 00 00 
    2fcb:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    2fd2:	00 00 00 
    2fd5:	ff d0                	callq  *%rax
    2fd7:	85 c0                	test   %eax,%eax
    2fd9:	78 16                	js     2ff1 <linktest+0x163>
    failexit("unlinked lf1 but it is still there!");
    2fdb:	48 bf a8 74 00 00 00 	movabs $0x74a8,%rdi
    2fe2:	00 00 00 
    2fe5:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2fec:	00 00 00 
    2fef:	ff d0                	callq  *%rax
  }

  fd = open("lf2", 0);
    2ff1:	be 00 00 00 00       	mov    $0x0,%esi
    2ff6:	48 bf 7e 74 00 00 00 	movabs $0x747e,%rdi
    2ffd:	00 00 00 
    3000:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    3007:	00 00 00 
    300a:	ff d0                	callq  *%rax
    300c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    300f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    3013:	79 16                	jns    302b <linktest+0x19d>
    failexit("open lf2");
    3015:	48 bf cc 74 00 00 00 	movabs $0x74cc,%rdi
    301c:	00 00 00 
    301f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3026:	00 00 00 
    3029:	ff d0                	callq  *%rax
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    302b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    302e:	ba 00 20 00 00       	mov    $0x2000,%edx
    3033:	48 be 20 8c 00 00 00 	movabs $0x8c20,%rsi
    303a:	00 00 00 
    303d:	89 c7                	mov    %eax,%edi
    303f:	48 b8 34 63 00 00 00 	movabs $0x6334,%rax
    3046:	00 00 00 
    3049:	ff d0                	callq  *%rax
    304b:	83 f8 05             	cmp    $0x5,%eax
    304e:	74 16                	je     3066 <linktest+0x1d8>
    failexit("read lf2");
    3050:	48 bf d5 74 00 00 00 	movabs $0x74d5,%rdi
    3057:	00 00 00 
    305a:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3061:	00 00 00 
    3064:	ff d0                	callq  *%rax
  }
  close(fd);
    3066:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3069:	89 c7                	mov    %eax,%edi
    306b:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    3072:	00 00 00 
    3075:	ff d0                	callq  *%rax

  if(link("lf2", "lf2") >= 0){
    3077:	48 be 7e 74 00 00 00 	movabs $0x747e,%rsi
    307e:	00 00 00 
    3081:	48 bf 7e 74 00 00 00 	movabs $0x747e,%rdi
    3088:	00 00 00 
    308b:	48 b8 a9 63 00 00 00 	movabs $0x63a9,%rax
    3092:	00 00 00 
    3095:	ff d0                	callq  *%rax
    3097:	85 c0                	test   %eax,%eax
    3099:	78 16                	js     30b1 <linktest+0x223>
    failexit("link lf2 lf2 succeeded! oops");
    309b:	48 bf de 74 00 00 00 	movabs $0x74de,%rdi
    30a2:	00 00 00 
    30a5:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    30ac:	00 00 00 
    30af:	ff d0                	callq  *%rax
  }

  unlink("lf2");
    30b1:	48 bf 7e 74 00 00 00 	movabs $0x747e,%rdi
    30b8:	00 00 00 
    30bb:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    30c2:	00 00 00 
    30c5:	ff d0                	callq  *%rax
  if(link("lf2", "lf1") >= 0){
    30c7:	48 be 7a 74 00 00 00 	movabs $0x747a,%rsi
    30ce:	00 00 00 
    30d1:	48 bf 7e 74 00 00 00 	movabs $0x747e,%rdi
    30d8:	00 00 00 
    30db:	48 b8 a9 63 00 00 00 	movabs $0x63a9,%rax
    30e2:	00 00 00 
    30e5:	ff d0                	callq  *%rax
    30e7:	85 c0                	test   %eax,%eax
    30e9:	78 16                	js     3101 <linktest+0x273>
    failexit("link non-existant succeeded! oops");
    30eb:	48 bf 00 75 00 00 00 	movabs $0x7500,%rdi
    30f2:	00 00 00 
    30f5:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    30fc:	00 00 00 
    30ff:	ff d0                	callq  *%rax
  }

  if(link(".", "lf1") >= 0){
    3101:	48 be 7a 74 00 00 00 	movabs $0x747a,%rsi
    3108:	00 00 00 
    310b:	48 bf 22 75 00 00 00 	movabs $0x7522,%rdi
    3112:	00 00 00 
    3115:	48 b8 a9 63 00 00 00 	movabs $0x63a9,%rax
    311c:	00 00 00 
    311f:	ff d0                	callq  *%rax
    3121:	85 c0                	test   %eax,%eax
    3123:	78 16                	js     313b <linktest+0x2ad>
    failexit("link . lf1 succeeded! oops");
    3125:	48 bf 24 75 00 00 00 	movabs $0x7524,%rdi
    312c:	00 00 00 
    312f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3136:	00 00 00 
    3139:	ff d0                	callq  *%rax
  }

  printf(1, "linktest ok\n");
    313b:	48 be 3f 75 00 00 00 	movabs $0x753f,%rsi
    3142:	00 00 00 
    3145:	bf 01 00 00 00       	mov    $0x1,%edi
    314a:	b8 00 00 00 00       	mov    $0x0,%eax
    314f:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    3156:	00 00 00 
    3159:	ff d2                	callq  *%rdx
}
    315b:	90                   	nop
    315c:	c9                   	leaveq 
    315d:	c3                   	retq   

000000000000315e <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    315e:	f3 0f 1e fa          	endbr64 
    3162:	55                   	push   %rbp
    3163:	48 89 e5             	mov    %rsp,%rbp
    3166:	48 83 ec 50          	sub    $0x50,%rsp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    316a:	48 be 4c 75 00 00 00 	movabs $0x754c,%rsi
    3171:	00 00 00 
    3174:	bf 01 00 00 00       	mov    $0x1,%edi
    3179:	b8 00 00 00 00       	mov    $0x0,%eax
    317e:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    3185:	00 00 00 
    3188:	ff d2                	callq  *%rdx
  file[0] = 'C';
    318a:	c6 45 ed 43          	movb   $0x43,-0x13(%rbp)
  file[2] = '\0';
    318e:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  for(i = 0; i < 40; i++){
    3192:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    3199:	e9 55 01 00 00       	jmpq   32f3 <concreate+0x195>
    file[1] = '0' + i;
    319e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    31a1:	83 c0 30             	add    $0x30,%eax
    31a4:	88 45 ee             	mov    %al,-0x12(%rbp)
    unlink(file);
    31a7:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    31ab:	48 89 c7             	mov    %rax,%rdi
    31ae:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    31b5:	00 00 00 
    31b8:	ff d0                	callq  *%rax
    pid = fork();
    31ba:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    31c1:	00 00 00 
    31c4:	ff d0                	callq  *%rax
    31c6:	89 45 f0             	mov    %eax,-0x10(%rbp)
    if(pid && (i % 3) == 1){
    31c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    31cd:	74 4c                	je     321b <concreate+0xbd>
    31cf:	8b 4d fc             	mov    -0x4(%rbp),%ecx
    31d2:	48 63 c1             	movslq %ecx,%rax
    31d5:	48 69 c0 56 55 55 55 	imul   $0x55555556,%rax,%rax
    31dc:	48 c1 e8 20          	shr    $0x20,%rax
    31e0:	48 89 c2             	mov    %rax,%rdx
    31e3:	89 c8                	mov    %ecx,%eax
    31e5:	c1 f8 1f             	sar    $0x1f,%eax
    31e8:	29 c2                	sub    %eax,%edx
    31ea:	89 d0                	mov    %edx,%eax
    31ec:	01 c0                	add    %eax,%eax
    31ee:	01 d0                	add    %edx,%eax
    31f0:	29 c1                	sub    %eax,%ecx
    31f2:	89 ca                	mov    %ecx,%edx
    31f4:	83 fa 01             	cmp    $0x1,%edx
    31f7:	75 22                	jne    321b <concreate+0xbd>
      link("C0", file);
    31f9:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    31fd:	48 89 c6             	mov    %rax,%rsi
    3200:	48 bf 5c 75 00 00 00 	movabs $0x755c,%rdi
    3207:	00 00 00 
    320a:	48 b8 a9 63 00 00 00 	movabs $0x63a9,%rax
    3211:	00 00 00 
    3214:	ff d0                	callq  *%rax
    3216:	e9 b6 00 00 00       	jmpq   32d1 <concreate+0x173>
    } else if(pid == 0 && (i % 5) == 1){
    321b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    321f:	75 4b                	jne    326c <concreate+0x10e>
    3221:	8b 4d fc             	mov    -0x4(%rbp),%ecx
    3224:	48 63 c1             	movslq %ecx,%rax
    3227:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
    322e:	48 c1 e8 20          	shr    $0x20,%rax
    3232:	89 c2                	mov    %eax,%edx
    3234:	d1 fa                	sar    %edx
    3236:	89 c8                	mov    %ecx,%eax
    3238:	c1 f8 1f             	sar    $0x1f,%eax
    323b:	29 c2                	sub    %eax,%edx
    323d:	89 d0                	mov    %edx,%eax
    323f:	c1 e0 02             	shl    $0x2,%eax
    3242:	01 d0                	add    %edx,%eax
    3244:	29 c1                	sub    %eax,%ecx
    3246:	89 ca                	mov    %ecx,%edx
    3248:	83 fa 01             	cmp    $0x1,%edx
    324b:	75 1f                	jne    326c <concreate+0x10e>
      link("C0", file);
    324d:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    3251:	48 89 c6             	mov    %rax,%rsi
    3254:	48 bf 5c 75 00 00 00 	movabs $0x755c,%rdi
    325b:	00 00 00 
    325e:	48 b8 a9 63 00 00 00 	movabs $0x63a9,%rax
    3265:	00 00 00 
    3268:	ff d0                	callq  *%rax
    326a:	eb 65                	jmp    32d1 <concreate+0x173>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    326c:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    3270:	be 02 02 00 00       	mov    $0x202,%esi
    3275:	48 89 c7             	mov    %rax,%rdi
    3278:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    327f:	00 00 00 
    3282:	ff d0                	callq  *%rax
    3284:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if(fd < 0){
    3287:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    328b:	79 33                	jns    32c0 <concreate+0x162>
        printf(1, "concreate create %s failed\n", file);
    328d:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    3291:	48 89 c2             	mov    %rax,%rdx
    3294:	48 be 5f 75 00 00 00 	movabs $0x755f,%rsi
    329b:	00 00 00 
    329e:	bf 01 00 00 00       	mov    $0x1,%edi
    32a3:	b8 00 00 00 00       	mov    $0x0,%eax
    32a8:	48 b9 11 66 00 00 00 	movabs $0x6611,%rcx
    32af:	00 00 00 
    32b2:	ff d1                	callq  *%rcx
        exit();
    32b4:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    32bb:	00 00 00 
    32be:	ff d0                	callq  *%rax
      }
      close(fd);
    32c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
    32c3:	89 c7                	mov    %eax,%edi
    32c5:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    32cc:	00 00 00 
    32cf:	ff d0                	callq  *%rax
    }
    if(pid == 0)
    32d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    32d5:	75 0c                	jne    32e3 <concreate+0x185>
      exit();
    32d7:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    32de:	00 00 00 
    32e1:	ff d0                	callq  *%rax
    else
      wait();
    32e3:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    32ea:	00 00 00 
    32ed:	ff d0                	callq  *%rax
  for(i = 0; i < 40; i++){
    32ef:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    32f3:	83 7d fc 27          	cmpl   $0x27,-0x4(%rbp)
    32f7:	0f 8e a1 fe ff ff    	jle    319e <concreate+0x40>
  }

  memset(fa, 0, sizeof(fa));
    32fd:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
    3301:	ba 28 00 00 00       	mov    $0x28,%edx
    3306:	be 00 00 00 00       	mov    $0x0,%esi
    330b:	48 89 c7             	mov    %rax,%rdi
    330e:	48 b8 d8 60 00 00 00 	movabs $0x60d8,%rax
    3315:	00 00 00 
    3318:	ff d0                	callq  *%rax
  fd = open(".", 0);
    331a:	be 00 00 00 00       	mov    $0x0,%esi
    331f:	48 bf 22 75 00 00 00 	movabs $0x7522,%rdi
    3326:	00 00 00 
    3329:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    3330:	00 00 00 
    3333:	ff d0                	callq  *%rax
    3335:	89 45 f4             	mov    %eax,-0xc(%rbp)
  n = 0;
    3338:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  while(read(fd, &de, sizeof(de)) > 0){
    333f:	e9 cb 00 00 00       	jmpq   340f <concreate+0x2b1>
    if(de.inum == 0)
    3344:	0f b7 45 b0          	movzwl -0x50(%rbp),%eax
    3348:	66 85 c0             	test   %ax,%ax
    334b:	75 05                	jne    3352 <concreate+0x1f4>
      continue;
    334d:	e9 bd 00 00 00       	jmpq   340f <concreate+0x2b1>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3352:	0f b6 45 b2          	movzbl -0x4e(%rbp),%eax
    3356:	3c 43                	cmp    $0x43,%al
    3358:	0f 85 b1 00 00 00    	jne    340f <concreate+0x2b1>
    335e:	0f b6 45 b4          	movzbl -0x4c(%rbp),%eax
    3362:	84 c0                	test   %al,%al
    3364:	0f 85 a5 00 00 00    	jne    340f <concreate+0x2b1>
      i = de.name[1] - '0';
    336a:	0f b6 45 b3          	movzbl -0x4d(%rbp),%eax
    336e:	0f be c0             	movsbl %al,%eax
    3371:	83 e8 30             	sub    $0x30,%eax
    3374:	89 45 fc             	mov    %eax,-0x4(%rbp)
      if(i < 0 || i >= sizeof(fa)){
    3377:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    337b:	78 08                	js     3385 <concreate+0x227>
    337d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3380:	83 f8 27             	cmp    $0x27,%eax
    3383:	76 37                	jbe    33bc <concreate+0x25e>
        printf(1, "concreate weird file %s\n", de.name);
    3385:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
    3389:	48 83 c0 02          	add    $0x2,%rax
    338d:	48 89 c2             	mov    %rax,%rdx
    3390:	48 be 7b 75 00 00 00 	movabs $0x757b,%rsi
    3397:	00 00 00 
    339a:	bf 01 00 00 00       	mov    $0x1,%edi
    339f:	b8 00 00 00 00       	mov    $0x0,%eax
    33a4:	48 b9 11 66 00 00 00 	movabs $0x6611,%rcx
    33ab:	00 00 00 
    33ae:	ff d1                	callq  *%rcx
        exit();
    33b0:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    33b7:	00 00 00 
    33ba:	ff d0                	callq  *%rax
      }
      if(fa[i]){
    33bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    33bf:	48 98                	cltq   
    33c1:	0f b6 44 05 c0       	movzbl -0x40(%rbp,%rax,1),%eax
    33c6:	84 c0                	test   %al,%al
    33c8:	74 37                	je     3401 <concreate+0x2a3>
        printf(1, "concreate duplicate file %s\n", de.name);
    33ca:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
    33ce:	48 83 c0 02          	add    $0x2,%rax
    33d2:	48 89 c2             	mov    %rax,%rdx
    33d5:	48 be 94 75 00 00 00 	movabs $0x7594,%rsi
    33dc:	00 00 00 
    33df:	bf 01 00 00 00       	mov    $0x1,%edi
    33e4:	b8 00 00 00 00       	mov    $0x0,%eax
    33e9:	48 b9 11 66 00 00 00 	movabs $0x6611,%rcx
    33f0:	00 00 00 
    33f3:	ff d1                	callq  *%rcx
        exit();
    33f5:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    33fc:	00 00 00 
    33ff:	ff d0                	callq  *%rax
      }
      fa[i] = 1;
    3401:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3404:	48 98                	cltq   
    3406:	c6 44 05 c0 01       	movb   $0x1,-0x40(%rbp,%rax,1)
      n++;
    340b:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  while(read(fd, &de, sizeof(de)) > 0){
    340f:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
    3413:	8b 45 f4             	mov    -0xc(%rbp),%eax
    3416:	ba 10 00 00 00       	mov    $0x10,%edx
    341b:	48 89 ce             	mov    %rcx,%rsi
    341e:	89 c7                	mov    %eax,%edi
    3420:	48 b8 34 63 00 00 00 	movabs $0x6334,%rax
    3427:	00 00 00 
    342a:	ff d0                	callq  *%rax
    342c:	85 c0                	test   %eax,%eax
    342e:	0f 8f 10 ff ff ff    	jg     3344 <concreate+0x1e6>
    }
  }
  close(fd);
    3434:	8b 45 f4             	mov    -0xc(%rbp),%eax
    3437:	89 c7                	mov    %eax,%edi
    3439:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    3440:	00 00 00 
    3443:	ff d0                	callq  *%rax

  if(n != 40){
    3445:	83 7d f8 28          	cmpl   $0x28,-0x8(%rbp)
    3449:	74 16                	je     3461 <concreate+0x303>
    failexit("concreate not enough files in directory listing");
    344b:	48 bf b8 75 00 00 00 	movabs $0x75b8,%rdi
    3452:	00 00 00 
    3455:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    345c:	00 00 00 
    345f:	ff d0                	callq  *%rax
  }

  for(i = 0; i < 40; i++){
    3461:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    3468:	e9 a7 01 00 00       	jmpq   3614 <concreate+0x4b6>
    file[1] = '0' + i;
    346d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3470:	83 c0 30             	add    $0x30,%eax
    3473:	88 45 ee             	mov    %al,-0x12(%rbp)
    pid = fork();
    3476:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    347d:	00 00 00 
    3480:	ff d0                	callq  *%rax
    3482:	89 45 f0             	mov    %eax,-0x10(%rbp)
    if(pid < 0){
    3485:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    3489:	79 16                	jns    34a1 <concreate+0x343>
      failexit("fork");
    348b:	48 bf b7 6d 00 00 00 	movabs $0x6db7,%rdi
    3492:	00 00 00 
    3495:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    349c:	00 00 00 
    349f:	ff d0                	callq  *%rax
    }
    if(((i % 3) == 0 && pid == 0) ||
    34a1:	8b 4d fc             	mov    -0x4(%rbp),%ecx
    34a4:	48 63 c1             	movslq %ecx,%rax
    34a7:	48 69 c0 56 55 55 55 	imul   $0x55555556,%rax,%rax
    34ae:	48 c1 e8 20          	shr    $0x20,%rax
    34b2:	48 89 c2             	mov    %rax,%rdx
    34b5:	89 c8                	mov    %ecx,%eax
    34b7:	c1 f8 1f             	sar    $0x1f,%eax
    34ba:	89 d6                	mov    %edx,%esi
    34bc:	29 c6                	sub    %eax,%esi
    34be:	89 f0                	mov    %esi,%eax
    34c0:	89 c2                	mov    %eax,%edx
    34c2:	01 d2                	add    %edx,%edx
    34c4:	01 c2                	add    %eax,%edx
    34c6:	89 c8                	mov    %ecx,%eax
    34c8:	29 d0                	sub    %edx,%eax
    34ca:	85 c0                	test   %eax,%eax
    34cc:	75 06                	jne    34d4 <concreate+0x376>
    34ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    34d2:	74 38                	je     350c <concreate+0x3ae>
       ((i % 3) == 1 && pid != 0)){
    34d4:	8b 4d fc             	mov    -0x4(%rbp),%ecx
    34d7:	48 63 c1             	movslq %ecx,%rax
    34da:	48 69 c0 56 55 55 55 	imul   $0x55555556,%rax,%rax
    34e1:	48 c1 e8 20          	shr    $0x20,%rax
    34e5:	48 89 c2             	mov    %rax,%rdx
    34e8:	89 c8                	mov    %ecx,%eax
    34ea:	c1 f8 1f             	sar    $0x1f,%eax
    34ed:	29 c2                	sub    %eax,%edx
    34ef:	89 d0                	mov    %edx,%eax
    34f1:	01 c0                	add    %eax,%eax
    34f3:	01 d0                	add    %edx,%eax
    34f5:	29 c1                	sub    %eax,%ecx
    34f7:	89 ca                	mov    %ecx,%edx
    if(((i % 3) == 0 && pid == 0) ||
    34f9:	83 fa 01             	cmp    $0x1,%edx
    34fc:	0f 85 a4 00 00 00    	jne    35a6 <concreate+0x448>
       ((i % 3) == 1 && pid != 0)){
    3502:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    3506:	0f 84 9a 00 00 00    	je     35a6 <concreate+0x448>
      close(open(file, 0));
    350c:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    3510:	be 00 00 00 00       	mov    $0x0,%esi
    3515:	48 89 c7             	mov    %rax,%rdi
    3518:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    351f:	00 00 00 
    3522:	ff d0                	callq  *%rax
    3524:	89 c7                	mov    %eax,%edi
    3526:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    352d:	00 00 00 
    3530:	ff d0                	callq  *%rax
      close(open(file, 0));
    3532:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    3536:	be 00 00 00 00       	mov    $0x0,%esi
    353b:	48 89 c7             	mov    %rax,%rdi
    353e:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    3545:	00 00 00 
    3548:	ff d0                	callq  *%rax
    354a:	89 c7                	mov    %eax,%edi
    354c:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    3553:	00 00 00 
    3556:	ff d0                	callq  *%rax
      close(open(file, 0));
    3558:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    355c:	be 00 00 00 00       	mov    $0x0,%esi
    3561:	48 89 c7             	mov    %rax,%rdi
    3564:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    356b:	00 00 00 
    356e:	ff d0                	callq  *%rax
    3570:	89 c7                	mov    %eax,%edi
    3572:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    3579:	00 00 00 
    357c:	ff d0                	callq  *%rax
      close(open(file, 0));
    357e:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    3582:	be 00 00 00 00       	mov    $0x0,%esi
    3587:	48 89 c7             	mov    %rax,%rdi
    358a:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    3591:	00 00 00 
    3594:	ff d0                	callq  *%rax
    3596:	89 c7                	mov    %eax,%edi
    3598:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    359f:	00 00 00 
    35a2:	ff d0                	callq  *%rax
    35a4:	eb 4c                	jmp    35f2 <concreate+0x494>
    } else {
      unlink(file);
    35a6:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    35aa:	48 89 c7             	mov    %rax,%rdi
    35ad:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    35b4:	00 00 00 
    35b7:	ff d0                	callq  *%rax
      unlink(file);
    35b9:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    35bd:	48 89 c7             	mov    %rax,%rdi
    35c0:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    35c7:	00 00 00 
    35ca:	ff d0                	callq  *%rax
      unlink(file);
    35cc:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    35d0:	48 89 c7             	mov    %rax,%rdi
    35d3:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    35da:	00 00 00 
    35dd:	ff d0                	callq  *%rax
      unlink(file);
    35df:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    35e3:	48 89 c7             	mov    %rax,%rdi
    35e6:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    35ed:	00 00 00 
    35f0:	ff d0                	callq  *%rax
    }
    if(pid == 0)
    35f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    35f6:	75 0c                	jne    3604 <concreate+0x4a6>
      exit();
    35f8:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    35ff:	00 00 00 
    3602:	ff d0                	callq  *%rax
    else
      wait();
    3604:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    360b:	00 00 00 
    360e:	ff d0                	callq  *%rax
  for(i = 0; i < 40; i++){
    3610:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    3614:	83 7d fc 27          	cmpl   $0x27,-0x4(%rbp)
    3618:	0f 8e 4f fe ff ff    	jle    346d <concreate+0x30f>
  }

  printf(1, "concreate ok\n");
    361e:	48 be e8 75 00 00 00 	movabs $0x75e8,%rsi
    3625:	00 00 00 
    3628:	bf 01 00 00 00       	mov    $0x1,%edi
    362d:	b8 00 00 00 00       	mov    $0x0,%eax
    3632:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    3639:	00 00 00 
    363c:	ff d2                	callq  *%rdx
}
    363e:	90                   	nop
    363f:	c9                   	leaveq 
    3640:	c3                   	retq   

0000000000003641 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    3641:	f3 0f 1e fa          	endbr64 
    3645:	55                   	push   %rbp
    3646:	48 89 e5             	mov    %rsp,%rbp
    3649:	48 83 ec 10          	sub    $0x10,%rsp
  int pid, i;

  printf(1, "linkunlink test\n");
    364d:	48 be f6 75 00 00 00 	movabs $0x75f6,%rsi
    3654:	00 00 00 
    3657:	bf 01 00 00 00       	mov    $0x1,%edi
    365c:	b8 00 00 00 00       	mov    $0x0,%eax
    3661:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    3668:	00 00 00 
    366b:	ff d2                	callq  *%rdx

  unlink("x");
    366d:	48 bf a6 71 00 00 00 	movabs $0x71a6,%rdi
    3674:	00 00 00 
    3677:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    367e:	00 00 00 
    3681:	ff d0                	callq  *%rax
  pid = fork();
    3683:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    368a:	00 00 00 
    368d:	ff d0                	callq  *%rax
    368f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(pid < 0){
    3692:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    3696:	79 16                	jns    36ae <linkunlink+0x6d>
    failexit("fork");
    3698:	48 bf b7 6d 00 00 00 	movabs $0x6db7,%rdi
    369f:	00 00 00 
    36a2:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    36a9:	00 00 00 
    36ac:	ff d0                	callq  *%rax
  }

  unsigned int x = (pid ? 1 : 97);
    36ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    36b2:	74 07                	je     36bb <linkunlink+0x7a>
    36b4:	b8 01 00 00 00       	mov    $0x1,%eax
    36b9:	eb 05                	jmp    36c0 <linkunlink+0x7f>
    36bb:	b8 61 00 00 00       	mov    $0x61,%eax
    36c0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  for(i = 0; i < 100; i++){
    36c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    36ca:	e9 bf 00 00 00       	jmpq   378e <linkunlink+0x14d>
    x = x * 1103515245 + 12345;
    36cf:	8b 45 f8             	mov    -0x8(%rbp),%eax
    36d2:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    36d8:	05 39 30 00 00       	add    $0x3039,%eax
    36dd:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if((x % 3) == 0){
    36e0:	8b 4d f8             	mov    -0x8(%rbp),%ecx
    36e3:	89 ca                	mov    %ecx,%edx
    36e5:	b8 ab aa aa aa       	mov    $0xaaaaaaab,%eax
    36ea:	48 0f af c2          	imul   %rdx,%rax
    36ee:	48 c1 e8 20          	shr    $0x20,%rax
    36f2:	d1 e8                	shr    %eax
    36f4:	89 c2                	mov    %eax,%edx
    36f6:	01 d2                	add    %edx,%edx
    36f8:	01 c2                	add    %eax,%edx
    36fa:	89 c8                	mov    %ecx,%eax
    36fc:	29 d0                	sub    %edx,%eax
    36fe:	85 c0                	test   %eax,%eax
    3700:	75 2b                	jne    372d <linkunlink+0xec>
      close(open("x", O_RDWR | O_CREATE));
    3702:	be 02 02 00 00       	mov    $0x202,%esi
    3707:	48 bf a6 71 00 00 00 	movabs $0x71a6,%rdi
    370e:	00 00 00 
    3711:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    3718:	00 00 00 
    371b:	ff d0                	callq  *%rax
    371d:	89 c7                	mov    %eax,%edi
    371f:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    3726:	00 00 00 
    3729:	ff d0                	callq  *%rax
    372b:	eb 5d                	jmp    378a <linkunlink+0x149>
    } else if((x % 3) == 1){
    372d:	8b 4d f8             	mov    -0x8(%rbp),%ecx
    3730:	89 ca                	mov    %ecx,%edx
    3732:	b8 ab aa aa aa       	mov    $0xaaaaaaab,%eax
    3737:	48 0f af c2          	imul   %rdx,%rax
    373b:	48 c1 e8 20          	shr    $0x20,%rax
    373f:	89 c2                	mov    %eax,%edx
    3741:	d1 ea                	shr    %edx
    3743:	89 d0                	mov    %edx,%eax
    3745:	01 c0                	add    %eax,%eax
    3747:	01 d0                	add    %edx,%eax
    3749:	29 c1                	sub    %eax,%ecx
    374b:	89 ca                	mov    %ecx,%edx
    374d:	83 fa 01             	cmp    $0x1,%edx
    3750:	75 22                	jne    3774 <linkunlink+0x133>
      link("cat", "x");
    3752:	48 be a6 71 00 00 00 	movabs $0x71a6,%rsi
    3759:	00 00 00 
    375c:	48 bf 07 76 00 00 00 	movabs $0x7607,%rdi
    3763:	00 00 00 
    3766:	48 b8 a9 63 00 00 00 	movabs $0x63a9,%rax
    376d:	00 00 00 
    3770:	ff d0                	callq  *%rax
    3772:	eb 16                	jmp    378a <linkunlink+0x149>
    } else {
      unlink("x");
    3774:	48 bf a6 71 00 00 00 	movabs $0x71a6,%rdi
    377b:	00 00 00 
    377e:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    3785:	00 00 00 
    3788:	ff d0                	callq  *%rax
  for(i = 0; i < 100; i++){
    378a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    378e:	83 7d fc 63          	cmpl   $0x63,-0x4(%rbp)
    3792:	0f 8e 37 ff ff ff    	jle    36cf <linkunlink+0x8e>
    }
  }

  if(pid)
    3798:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    379c:	74 0e                	je     37ac <linkunlink+0x16b>
    wait();
    379e:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    37a5:	00 00 00 
    37a8:	ff d0                	callq  *%rax
    37aa:	eb 0c                	jmp    37b8 <linkunlink+0x177>
  else
    exit();
    37ac:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    37b3:	00 00 00 
    37b6:	ff d0                	callq  *%rax

  printf(1, "linkunlink ok\n");
    37b8:	48 be 0b 76 00 00 00 	movabs $0x760b,%rsi
    37bf:	00 00 00 
    37c2:	bf 01 00 00 00       	mov    $0x1,%edi
    37c7:	b8 00 00 00 00       	mov    $0x0,%eax
    37cc:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    37d3:	00 00 00 
    37d6:	ff d2                	callq  *%rdx
}
    37d8:	90                   	nop
    37d9:	c9                   	leaveq 
    37da:	c3                   	retq   

00000000000037db <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    37db:	f3 0f 1e fa          	endbr64 
    37df:	55                   	push   %rbp
    37e0:	48 89 e5             	mov    %rsp,%rbp
    37e3:	48 83 ec 20          	sub    $0x20,%rsp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    37e7:	48 be 1a 76 00 00 00 	movabs $0x761a,%rsi
    37ee:	00 00 00 
    37f1:	bf 01 00 00 00       	mov    $0x1,%edi
    37f6:	b8 00 00 00 00       	mov    $0x0,%eax
    37fb:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    3802:	00 00 00 
    3805:	ff d2                	callq  *%rdx
  unlink("bd");
    3807:	48 bf 27 76 00 00 00 	movabs $0x7627,%rdi
    380e:	00 00 00 
    3811:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    3818:	00 00 00 
    381b:	ff d0                	callq  *%rax

  fd = open("bd", O_CREATE);
    381d:	be 00 02 00 00       	mov    $0x200,%esi
    3822:	48 bf 27 76 00 00 00 	movabs $0x7627,%rdi
    3829:	00 00 00 
    382c:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    3833:	00 00 00 
    3836:	ff d0                	callq  *%rax
    3838:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(fd < 0){
    383b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    383f:	79 16                	jns    3857 <bigdir+0x7c>
    failexit("bigdir create");
    3841:	48 bf 2a 76 00 00 00 	movabs $0x762a,%rdi
    3848:	00 00 00 
    384b:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3852:	00 00 00 
    3855:	ff d0                	callq  *%rax
  }
  close(fd);
    3857:	8b 45 f8             	mov    -0x8(%rbp),%eax
    385a:	89 c7                	mov    %eax,%edi
    385c:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    3863:	00 00 00 
    3866:	ff d0                	callq  *%rax

  for(i = 0; i < 500; i++){
    3868:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    386f:	eb 6b                	jmp    38dc <bigdir+0x101>
    name[0] = 'x';
    3871:	c6 45 ee 78          	movb   $0x78,-0x12(%rbp)
    name[1] = '0' + (i / 64);
    3875:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3878:	8d 50 3f             	lea    0x3f(%rax),%edx
    387b:	85 c0                	test   %eax,%eax
    387d:	0f 48 c2             	cmovs  %edx,%eax
    3880:	c1 f8 06             	sar    $0x6,%eax
    3883:	83 c0 30             	add    $0x30,%eax
    3886:	88 45 ef             	mov    %al,-0x11(%rbp)
    name[2] = '0' + (i % 64);
    3889:	8b 45 fc             	mov    -0x4(%rbp),%eax
    388c:	99                   	cltd   
    388d:	c1 ea 1a             	shr    $0x1a,%edx
    3890:	01 d0                	add    %edx,%eax
    3892:	83 e0 3f             	and    $0x3f,%eax
    3895:	29 d0                	sub    %edx,%eax
    3897:	83 c0 30             	add    $0x30,%eax
    389a:	88 45 f0             	mov    %al,-0x10(%rbp)
    name[3] = '\0';
    389d:	c6 45 f1 00          	movb   $0x0,-0xf(%rbp)
    if(link("bd", name) != 0){
    38a1:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
    38a5:	48 89 c6             	mov    %rax,%rsi
    38a8:	48 bf 27 76 00 00 00 	movabs $0x7627,%rdi
    38af:	00 00 00 
    38b2:	48 b8 a9 63 00 00 00 	movabs $0x63a9,%rax
    38b9:	00 00 00 
    38bc:	ff d0                	callq  *%rax
    38be:	85 c0                	test   %eax,%eax
    38c0:	74 16                	je     38d8 <bigdir+0xfd>
      failexit("bigdir link");
    38c2:	48 bf 38 76 00 00 00 	movabs $0x7638,%rdi
    38c9:	00 00 00 
    38cc:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    38d3:	00 00 00 
    38d6:	ff d0                	callq  *%rax
  for(i = 0; i < 500; i++){
    38d8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    38dc:	81 7d fc f3 01 00 00 	cmpl   $0x1f3,-0x4(%rbp)
    38e3:	7e 8c                	jle    3871 <bigdir+0x96>
    }
  }

  unlink("bd");
    38e5:	48 bf 27 76 00 00 00 	movabs $0x7627,%rdi
    38ec:	00 00 00 
    38ef:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    38f6:	00 00 00 
    38f9:	ff d0                	callq  *%rax
  for(i = 0; i < 500; i++){
    38fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    3902:	eb 61                	jmp    3965 <bigdir+0x18a>
    name[0] = 'x';
    3904:	c6 45 ee 78          	movb   $0x78,-0x12(%rbp)
    name[1] = '0' + (i / 64);
    3908:	8b 45 fc             	mov    -0x4(%rbp),%eax
    390b:	8d 50 3f             	lea    0x3f(%rax),%edx
    390e:	85 c0                	test   %eax,%eax
    3910:	0f 48 c2             	cmovs  %edx,%eax
    3913:	c1 f8 06             	sar    $0x6,%eax
    3916:	83 c0 30             	add    $0x30,%eax
    3919:	88 45 ef             	mov    %al,-0x11(%rbp)
    name[2] = '0' + (i % 64);
    391c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    391f:	99                   	cltd   
    3920:	c1 ea 1a             	shr    $0x1a,%edx
    3923:	01 d0                	add    %edx,%eax
    3925:	83 e0 3f             	and    $0x3f,%eax
    3928:	29 d0                	sub    %edx,%eax
    392a:	83 c0 30             	add    $0x30,%eax
    392d:	88 45 f0             	mov    %al,-0x10(%rbp)
    name[3] = '\0';
    3930:	c6 45 f1 00          	movb   $0x0,-0xf(%rbp)
    if(unlink(name) != 0){
    3934:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
    3938:	48 89 c7             	mov    %rax,%rdi
    393b:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    3942:	00 00 00 
    3945:	ff d0                	callq  *%rax
    3947:	85 c0                	test   %eax,%eax
    3949:	74 16                	je     3961 <bigdir+0x186>
      failexit("bigdir unlink failed");
    394b:	48 bf 44 76 00 00 00 	movabs $0x7644,%rdi
    3952:	00 00 00 
    3955:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    395c:	00 00 00 
    395f:	ff d0                	callq  *%rax
  for(i = 0; i < 500; i++){
    3961:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    3965:	81 7d fc f3 01 00 00 	cmpl   $0x1f3,-0x4(%rbp)
    396c:	7e 96                	jle    3904 <bigdir+0x129>
    }
  }

  printf(1, "bigdir ok\n");
    396e:	48 be 59 76 00 00 00 	movabs $0x7659,%rsi
    3975:	00 00 00 
    3978:	bf 01 00 00 00       	mov    $0x1,%edi
    397d:	b8 00 00 00 00       	mov    $0x0,%eax
    3982:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    3989:	00 00 00 
    398c:	ff d2                	callq  *%rdx
}
    398e:	90                   	nop
    398f:	c9                   	leaveq 
    3990:	c3                   	retq   

0000000000003991 <subdir>:

void
subdir(void)
{
    3991:	f3 0f 1e fa          	endbr64 
    3995:	55                   	push   %rbp
    3996:	48 89 e5             	mov    %rsp,%rbp
    3999:	48 83 ec 10          	sub    $0x10,%rsp
  int fd, cc;

  printf(1, "subdir test\n");
    399d:	48 be 64 76 00 00 00 	movabs $0x7664,%rsi
    39a4:	00 00 00 
    39a7:	bf 01 00 00 00       	mov    $0x1,%edi
    39ac:	b8 00 00 00 00       	mov    $0x0,%eax
    39b1:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    39b8:	00 00 00 
    39bb:	ff d2                	callq  *%rdx

  unlink("ff");
    39bd:	48 bf 71 76 00 00 00 	movabs $0x7671,%rdi
    39c4:	00 00 00 
    39c7:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    39ce:	00 00 00 
    39d1:	ff d0                	callq  *%rax
  if(mkdir("dd") != 0){
    39d3:	48 bf 74 76 00 00 00 	movabs $0x7674,%rdi
    39da:	00 00 00 
    39dd:	48 b8 b6 63 00 00 00 	movabs $0x63b6,%rax
    39e4:	00 00 00 
    39e7:	ff d0                	callq  *%rax
    39e9:	85 c0                	test   %eax,%eax
    39eb:	74 16                	je     3a03 <subdir+0x72>
    failexit("subdir mkdir dd");
    39ed:	48 bf 77 76 00 00 00 	movabs $0x7677,%rdi
    39f4:	00 00 00 
    39f7:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    39fe:	00 00 00 
    3a01:	ff d0                	callq  *%rax
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    3a03:	be 02 02 00 00       	mov    $0x202,%esi
    3a08:	48 bf 87 76 00 00 00 	movabs $0x7687,%rdi
    3a0f:	00 00 00 
    3a12:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    3a19:	00 00 00 
    3a1c:	ff d0                	callq  *%rax
    3a1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    3a21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    3a25:	79 16                	jns    3a3d <subdir+0xac>
    failexit("create dd/ff");
    3a27:	48 bf 8d 76 00 00 00 	movabs $0x768d,%rdi
    3a2e:	00 00 00 
    3a31:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3a38:	00 00 00 
    3a3b:	ff d0                	callq  *%rax
  }
  write(fd, "ff", 2);
    3a3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3a40:	ba 02 00 00 00       	mov    $0x2,%edx
    3a45:	48 be 71 76 00 00 00 	movabs $0x7671,%rsi
    3a4c:	00 00 00 
    3a4f:	89 c7                	mov    %eax,%edi
    3a51:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    3a58:	00 00 00 
    3a5b:	ff d0                	callq  *%rax
  close(fd);
    3a5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3a60:	89 c7                	mov    %eax,%edi
    3a62:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    3a69:	00 00 00 
    3a6c:	ff d0                	callq  *%rax

  if(unlink("dd") >= 0){
    3a6e:	48 bf 74 76 00 00 00 	movabs $0x7674,%rdi
    3a75:	00 00 00 
    3a78:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    3a7f:	00 00 00 
    3a82:	ff d0                	callq  *%rax
    3a84:	85 c0                	test   %eax,%eax
    3a86:	78 16                	js     3a9e <subdir+0x10d>
    failexit("unlink dd (non-empty dir) succeeded!");
    3a88:	48 bf a0 76 00 00 00 	movabs $0x76a0,%rdi
    3a8f:	00 00 00 
    3a92:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3a99:	00 00 00 
    3a9c:	ff d0                	callq  *%rax
  }

  if(mkdir("/dd/dd") != 0){
    3a9e:	48 bf c5 76 00 00 00 	movabs $0x76c5,%rdi
    3aa5:	00 00 00 
    3aa8:	48 b8 b6 63 00 00 00 	movabs $0x63b6,%rax
    3aaf:	00 00 00 
    3ab2:	ff d0                	callq  *%rax
    3ab4:	85 c0                	test   %eax,%eax
    3ab6:	74 16                	je     3ace <subdir+0x13d>
    failexit("subdir mkdir dd/dd");
    3ab8:	48 bf cc 76 00 00 00 	movabs $0x76cc,%rdi
    3abf:	00 00 00 
    3ac2:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3ac9:	00 00 00 
    3acc:	ff d0                	callq  *%rax
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3ace:	be 02 02 00 00       	mov    $0x202,%esi
    3ad3:	48 bf df 76 00 00 00 	movabs $0x76df,%rdi
    3ada:	00 00 00 
    3add:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    3ae4:	00 00 00 
    3ae7:	ff d0                	callq  *%rax
    3ae9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    3aec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    3af0:	79 16                	jns    3b08 <subdir+0x177>
    failexit("create dd/dd/ff");
    3af2:	48 bf e8 76 00 00 00 	movabs $0x76e8,%rdi
    3af9:	00 00 00 
    3afc:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3b03:	00 00 00 
    3b06:	ff d0                	callq  *%rax
  }
  write(fd, "FF", 2);
    3b08:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3b0b:	ba 02 00 00 00       	mov    $0x2,%edx
    3b10:	48 be f8 76 00 00 00 	movabs $0x76f8,%rsi
    3b17:	00 00 00 
    3b1a:	89 c7                	mov    %eax,%edi
    3b1c:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    3b23:	00 00 00 
    3b26:	ff d0                	callq  *%rax
  close(fd);
    3b28:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3b2b:	89 c7                	mov    %eax,%edi
    3b2d:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    3b34:	00 00 00 
    3b37:	ff d0                	callq  *%rax

  fd = open("dd/dd/../ff", 0);
    3b39:	be 00 00 00 00       	mov    $0x0,%esi
    3b3e:	48 bf fb 76 00 00 00 	movabs $0x76fb,%rdi
    3b45:	00 00 00 
    3b48:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    3b4f:	00 00 00 
    3b52:	ff d0                	callq  *%rax
    3b54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    3b57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    3b5b:	79 16                	jns    3b73 <subdir+0x1e2>
    failexit("open dd/dd/../ff");
    3b5d:	48 bf 07 77 00 00 00 	movabs $0x7707,%rdi
    3b64:	00 00 00 
    3b67:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3b6e:	00 00 00 
    3b71:	ff d0                	callq  *%rax
  }
  cc = read(fd, buf, sizeof(buf));
    3b73:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3b76:	ba 00 20 00 00       	mov    $0x2000,%edx
    3b7b:	48 be 20 8c 00 00 00 	movabs $0x8c20,%rsi
    3b82:	00 00 00 
    3b85:	89 c7                	mov    %eax,%edi
    3b87:	48 b8 34 63 00 00 00 	movabs $0x6334,%rax
    3b8e:	00 00 00 
    3b91:	ff d0                	callq  *%rax
    3b93:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(cc != 2 || buf[0] != 'f'){
    3b96:	83 7d f8 02          	cmpl   $0x2,-0x8(%rbp)
    3b9a:	75 11                	jne    3bad <subdir+0x21c>
    3b9c:	48 b8 20 8c 00 00 00 	movabs $0x8c20,%rax
    3ba3:	00 00 00 
    3ba6:	0f b6 00             	movzbl (%rax),%eax
    3ba9:	3c 66                	cmp    $0x66,%al
    3bab:	74 16                	je     3bc3 <subdir+0x232>
    failexit("dd/dd/../ff wrong content");
    3bad:	48 bf 18 77 00 00 00 	movabs $0x7718,%rdi
    3bb4:	00 00 00 
    3bb7:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3bbe:	00 00 00 
    3bc1:	ff d0                	callq  *%rax
  }
  close(fd);
    3bc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3bc6:	89 c7                	mov    %eax,%edi
    3bc8:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    3bcf:	00 00 00 
    3bd2:	ff d0                	callq  *%rax

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3bd4:	48 be 32 77 00 00 00 	movabs $0x7732,%rsi
    3bdb:	00 00 00 
    3bde:	48 bf df 76 00 00 00 	movabs $0x76df,%rdi
    3be5:	00 00 00 
    3be8:	48 b8 a9 63 00 00 00 	movabs $0x63a9,%rax
    3bef:	00 00 00 
    3bf2:	ff d0                	callq  *%rax
    3bf4:	85 c0                	test   %eax,%eax
    3bf6:	74 16                	je     3c0e <subdir+0x27d>
    failexit("link dd/dd/ff dd/dd/ffff");
    3bf8:	48 bf 3d 77 00 00 00 	movabs $0x773d,%rdi
    3bff:	00 00 00 
    3c02:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3c09:	00 00 00 
    3c0c:	ff d0                	callq  *%rax
  }

  if(unlink("dd/dd/ff") != 0){
    3c0e:	48 bf df 76 00 00 00 	movabs $0x76df,%rdi
    3c15:	00 00 00 
    3c18:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    3c1f:	00 00 00 
    3c22:	ff d0                	callq  *%rax
    3c24:	85 c0                	test   %eax,%eax
    3c26:	74 16                	je     3c3e <subdir+0x2ad>
    failexit("unlink dd/dd/ff");
    3c28:	48 bf 56 77 00 00 00 	movabs $0x7756,%rdi
    3c2f:	00 00 00 
    3c32:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3c39:	00 00 00 
    3c3c:	ff d0                	callq  *%rax
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3c3e:	be 00 00 00 00       	mov    $0x0,%esi
    3c43:	48 bf df 76 00 00 00 	movabs $0x76df,%rdi
    3c4a:	00 00 00 
    3c4d:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    3c54:	00 00 00 
    3c57:	ff d0                	callq  *%rax
    3c59:	85 c0                	test   %eax,%eax
    3c5b:	78 16                	js     3c73 <subdir+0x2e2>
    failexit("open (unlinked) dd/dd/ff succeeded");
    3c5d:	48 bf 68 77 00 00 00 	movabs $0x7768,%rdi
    3c64:	00 00 00 
    3c67:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3c6e:	00 00 00 
    3c71:	ff d0                	callq  *%rax
  }

  if(chdir("dd") != 0){
    3c73:	48 bf 74 76 00 00 00 	movabs $0x7674,%rdi
    3c7a:	00 00 00 
    3c7d:	48 b8 c3 63 00 00 00 	movabs $0x63c3,%rax
    3c84:	00 00 00 
    3c87:	ff d0                	callq  *%rax
    3c89:	85 c0                	test   %eax,%eax
    3c8b:	74 16                	je     3ca3 <subdir+0x312>
    failexit("chdir dd");
    3c8d:	48 bf 8b 77 00 00 00 	movabs $0x778b,%rdi
    3c94:	00 00 00 
    3c97:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3c9e:	00 00 00 
    3ca1:	ff d0                	callq  *%rax
  }
  if(chdir("dd/../../dd") != 0){
    3ca3:	48 bf 94 77 00 00 00 	movabs $0x7794,%rdi
    3caa:	00 00 00 
    3cad:	48 b8 c3 63 00 00 00 	movabs $0x63c3,%rax
    3cb4:	00 00 00 
    3cb7:	ff d0                	callq  *%rax
    3cb9:	85 c0                	test   %eax,%eax
    3cbb:	74 16                	je     3cd3 <subdir+0x342>
    failexit("chdir dd/../../dd");
    3cbd:	48 bf a0 77 00 00 00 	movabs $0x77a0,%rdi
    3cc4:	00 00 00 
    3cc7:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3cce:	00 00 00 
    3cd1:	ff d0                	callq  *%rax
  }
  if(chdir("dd/../../../dd") != 0){
    3cd3:	48 bf b2 77 00 00 00 	movabs $0x77b2,%rdi
    3cda:	00 00 00 
    3cdd:	48 b8 c3 63 00 00 00 	movabs $0x63c3,%rax
    3ce4:	00 00 00 
    3ce7:	ff d0                	callq  *%rax
    3ce9:	85 c0                	test   %eax,%eax
    3ceb:	74 16                	je     3d03 <subdir+0x372>
    failexit("chdir dd/../../dd");
    3ced:	48 bf a0 77 00 00 00 	movabs $0x77a0,%rdi
    3cf4:	00 00 00 
    3cf7:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3cfe:	00 00 00 
    3d01:	ff d0                	callq  *%rax
  }
  if(chdir("./..") != 0){
    3d03:	48 bf c1 77 00 00 00 	movabs $0x77c1,%rdi
    3d0a:	00 00 00 
    3d0d:	48 b8 c3 63 00 00 00 	movabs $0x63c3,%rax
    3d14:	00 00 00 
    3d17:	ff d0                	callq  *%rax
    3d19:	85 c0                	test   %eax,%eax
    3d1b:	74 16                	je     3d33 <subdir+0x3a2>
    failexit("chdir ./..");
    3d1d:	48 bf c6 77 00 00 00 	movabs $0x77c6,%rdi
    3d24:	00 00 00 
    3d27:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3d2e:	00 00 00 
    3d31:	ff d0                	callq  *%rax
  }

  fd = open("dd/dd/ffff", 0);
    3d33:	be 00 00 00 00       	mov    $0x0,%esi
    3d38:	48 bf 32 77 00 00 00 	movabs $0x7732,%rdi
    3d3f:	00 00 00 
    3d42:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    3d49:	00 00 00 
    3d4c:	ff d0                	callq  *%rax
    3d4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    3d51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    3d55:	79 16                	jns    3d6d <subdir+0x3dc>
    failexit("open dd/dd/ffff");
    3d57:	48 bf d1 77 00 00 00 	movabs $0x77d1,%rdi
    3d5e:	00 00 00 
    3d61:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3d68:	00 00 00 
    3d6b:	ff d0                	callq  *%rax
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    3d6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3d70:	ba 00 20 00 00       	mov    $0x2000,%edx
    3d75:	48 be 20 8c 00 00 00 	movabs $0x8c20,%rsi
    3d7c:	00 00 00 
    3d7f:	89 c7                	mov    %eax,%edi
    3d81:	48 b8 34 63 00 00 00 	movabs $0x6334,%rax
    3d88:	00 00 00 
    3d8b:	ff d0                	callq  *%rax
    3d8d:	83 f8 02             	cmp    $0x2,%eax
    3d90:	74 16                	je     3da8 <subdir+0x417>
    failexit("read dd/dd/ffff wrong len");
    3d92:	48 bf e1 77 00 00 00 	movabs $0x77e1,%rdi
    3d99:	00 00 00 
    3d9c:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3da3:	00 00 00 
    3da6:	ff d0                	callq  *%rax
  }
  close(fd);
    3da8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3dab:	89 c7                	mov    %eax,%edi
    3dad:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    3db4:	00 00 00 
    3db7:	ff d0                	callq  *%rax

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3db9:	be 00 00 00 00       	mov    $0x0,%esi
    3dbe:	48 bf df 76 00 00 00 	movabs $0x76df,%rdi
    3dc5:	00 00 00 
    3dc8:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    3dcf:	00 00 00 
    3dd2:	ff d0                	callq  *%rax
    3dd4:	85 c0                	test   %eax,%eax
    3dd6:	78 16                	js     3dee <subdir+0x45d>
    failexit("open (unlinked) dd/dd/ff succeeded");
    3dd8:	48 bf 68 77 00 00 00 	movabs $0x7768,%rdi
    3ddf:	00 00 00 
    3de2:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3de9:	00 00 00 
    3dec:	ff d0                	callq  *%rax
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3dee:	be 02 02 00 00       	mov    $0x202,%esi
    3df3:	48 bf fb 77 00 00 00 	movabs $0x77fb,%rdi
    3dfa:	00 00 00 
    3dfd:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    3e04:	00 00 00 
    3e07:	ff d0                	callq  *%rax
    3e09:	85 c0                	test   %eax,%eax
    3e0b:	78 16                	js     3e23 <subdir+0x492>
    failexit("create dd/ff/ff succeeded");
    3e0d:	48 bf 04 78 00 00 00 	movabs $0x7804,%rdi
    3e14:	00 00 00 
    3e17:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3e1e:	00 00 00 
    3e21:	ff d0                	callq  *%rax
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3e23:	be 02 02 00 00       	mov    $0x202,%esi
    3e28:	48 bf 1e 78 00 00 00 	movabs $0x781e,%rdi
    3e2f:	00 00 00 
    3e32:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    3e39:	00 00 00 
    3e3c:	ff d0                	callq  *%rax
    3e3e:	85 c0                	test   %eax,%eax
    3e40:	78 16                	js     3e58 <subdir+0x4c7>
    failexit("create dd/xx/ff succeeded");
    3e42:	48 bf 27 78 00 00 00 	movabs $0x7827,%rdi
    3e49:	00 00 00 
    3e4c:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3e53:	00 00 00 
    3e56:	ff d0                	callq  *%rax
  }
  if(open("dd", O_CREATE) >= 0){
    3e58:	be 00 02 00 00       	mov    $0x200,%esi
    3e5d:	48 bf 74 76 00 00 00 	movabs $0x7674,%rdi
    3e64:	00 00 00 
    3e67:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    3e6e:	00 00 00 
    3e71:	ff d0                	callq  *%rax
    3e73:	85 c0                	test   %eax,%eax
    3e75:	78 16                	js     3e8d <subdir+0x4fc>
    failexit("create dd succeeded");
    3e77:	48 bf 41 78 00 00 00 	movabs $0x7841,%rdi
    3e7e:	00 00 00 
    3e81:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3e88:	00 00 00 
    3e8b:	ff d0                	callq  *%rax
  }
  if(open("dd", O_RDWR) >= 0){
    3e8d:	be 02 00 00 00       	mov    $0x2,%esi
    3e92:	48 bf 74 76 00 00 00 	movabs $0x7674,%rdi
    3e99:	00 00 00 
    3e9c:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    3ea3:	00 00 00 
    3ea6:	ff d0                	callq  *%rax
    3ea8:	85 c0                	test   %eax,%eax
    3eaa:	78 16                	js     3ec2 <subdir+0x531>
    failexit("open dd rdwr succeeded");
    3eac:	48 bf 55 78 00 00 00 	movabs $0x7855,%rdi
    3eb3:	00 00 00 
    3eb6:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3ebd:	00 00 00 
    3ec0:	ff d0                	callq  *%rax
  }
  if(open("dd", O_WRONLY) >= 0){
    3ec2:	be 01 00 00 00       	mov    $0x1,%esi
    3ec7:	48 bf 74 76 00 00 00 	movabs $0x7674,%rdi
    3ece:	00 00 00 
    3ed1:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    3ed8:	00 00 00 
    3edb:	ff d0                	callq  *%rax
    3edd:	85 c0                	test   %eax,%eax
    3edf:	78 16                	js     3ef7 <subdir+0x566>
    failexit("open dd wronly succeeded");
    3ee1:	48 bf 6c 78 00 00 00 	movabs $0x786c,%rdi
    3ee8:	00 00 00 
    3eeb:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3ef2:	00 00 00 
    3ef5:	ff d0                	callq  *%rax
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3ef7:	48 be 85 78 00 00 00 	movabs $0x7885,%rsi
    3efe:	00 00 00 
    3f01:	48 bf fb 77 00 00 00 	movabs $0x77fb,%rdi
    3f08:	00 00 00 
    3f0b:	48 b8 a9 63 00 00 00 	movabs $0x63a9,%rax
    3f12:	00 00 00 
    3f15:	ff d0                	callq  *%rax
    3f17:	85 c0                	test   %eax,%eax
    3f19:	75 16                	jne    3f31 <subdir+0x5a0>
    failexit("link dd/ff/ff dd/dd/xx succeeded");
    3f1b:	48 bf 90 78 00 00 00 	movabs $0x7890,%rdi
    3f22:	00 00 00 
    3f25:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3f2c:	00 00 00 
    3f2f:	ff d0                	callq  *%rax
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3f31:	48 be 85 78 00 00 00 	movabs $0x7885,%rsi
    3f38:	00 00 00 
    3f3b:	48 bf 1e 78 00 00 00 	movabs $0x781e,%rdi
    3f42:	00 00 00 
    3f45:	48 b8 a9 63 00 00 00 	movabs $0x63a9,%rax
    3f4c:	00 00 00 
    3f4f:	ff d0                	callq  *%rax
    3f51:	85 c0                	test   %eax,%eax
    3f53:	75 16                	jne    3f6b <subdir+0x5da>
    failexit("link dd/xx/ff dd/dd/xx succeededn");
    3f55:	48 bf b8 78 00 00 00 	movabs $0x78b8,%rdi
    3f5c:	00 00 00 
    3f5f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3f66:	00 00 00 
    3f69:	ff d0                	callq  *%rax
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3f6b:	48 be 32 77 00 00 00 	movabs $0x7732,%rsi
    3f72:	00 00 00 
    3f75:	48 bf 87 76 00 00 00 	movabs $0x7687,%rdi
    3f7c:	00 00 00 
    3f7f:	48 b8 a9 63 00 00 00 	movabs $0x63a9,%rax
    3f86:	00 00 00 
    3f89:	ff d0                	callq  *%rax
    3f8b:	85 c0                	test   %eax,%eax
    3f8d:	75 16                	jne    3fa5 <subdir+0x614>
    failexit("link dd/ff dd/dd/ffff succeeded");
    3f8f:	48 bf e0 78 00 00 00 	movabs $0x78e0,%rdi
    3f96:	00 00 00 
    3f99:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3fa0:	00 00 00 
    3fa3:	ff d0                	callq  *%rax
  }
  if(mkdir("dd/ff/ff") == 0){
    3fa5:	48 bf fb 77 00 00 00 	movabs $0x77fb,%rdi
    3fac:	00 00 00 
    3faf:	48 b8 b6 63 00 00 00 	movabs $0x63b6,%rax
    3fb6:	00 00 00 
    3fb9:	ff d0                	callq  *%rax
    3fbb:	85 c0                	test   %eax,%eax
    3fbd:	75 16                	jne    3fd5 <subdir+0x644>
    failexit("mkdir dd/ff/ff succeeded");
    3fbf:	48 bf 00 79 00 00 00 	movabs $0x7900,%rdi
    3fc6:	00 00 00 
    3fc9:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3fd0:	00 00 00 
    3fd3:	ff d0                	callq  *%rax
  }
  if(mkdir("dd/xx/ff") == 0){
    3fd5:	48 bf 1e 78 00 00 00 	movabs $0x781e,%rdi
    3fdc:	00 00 00 
    3fdf:	48 b8 b6 63 00 00 00 	movabs $0x63b6,%rax
    3fe6:	00 00 00 
    3fe9:	ff d0                	callq  *%rax
    3feb:	85 c0                	test   %eax,%eax
    3fed:	75 16                	jne    4005 <subdir+0x674>
    failexit("mkdir dd/xx/ff succeeded");
    3fef:	48 bf 19 79 00 00 00 	movabs $0x7919,%rdi
    3ff6:	00 00 00 
    3ff9:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4000:	00 00 00 
    4003:	ff d0                	callq  *%rax
  }
  if(mkdir("dd/dd/ffff") == 0){
    4005:	48 bf 32 77 00 00 00 	movabs $0x7732,%rdi
    400c:	00 00 00 
    400f:	48 b8 b6 63 00 00 00 	movabs $0x63b6,%rax
    4016:	00 00 00 
    4019:	ff d0                	callq  *%rax
    401b:	85 c0                	test   %eax,%eax
    401d:	75 16                	jne    4035 <subdir+0x6a4>
    failexit("mkdir dd/dd/ffff succeeded");
    401f:	48 bf 32 79 00 00 00 	movabs $0x7932,%rdi
    4026:	00 00 00 
    4029:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4030:	00 00 00 
    4033:	ff d0                	callq  *%rax
  }
  if(unlink("dd/xx/ff") == 0){
    4035:	48 bf 1e 78 00 00 00 	movabs $0x781e,%rdi
    403c:	00 00 00 
    403f:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    4046:	00 00 00 
    4049:	ff d0                	callq  *%rax
    404b:	85 c0                	test   %eax,%eax
    404d:	75 16                	jne    4065 <subdir+0x6d4>
    failexit("unlink dd/xx/ff succeeded");
    404f:	48 bf 4d 79 00 00 00 	movabs $0x794d,%rdi
    4056:	00 00 00 
    4059:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4060:	00 00 00 
    4063:	ff d0                	callq  *%rax
  }
  if(unlink("dd/ff/ff") == 0){
    4065:	48 bf fb 77 00 00 00 	movabs $0x77fb,%rdi
    406c:	00 00 00 
    406f:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    4076:	00 00 00 
    4079:	ff d0                	callq  *%rax
    407b:	85 c0                	test   %eax,%eax
    407d:	75 16                	jne    4095 <subdir+0x704>
    failexit("unlink dd/ff/ff succeeded");
    407f:	48 bf 67 79 00 00 00 	movabs $0x7967,%rdi
    4086:	00 00 00 
    4089:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4090:	00 00 00 
    4093:	ff d0                	callq  *%rax
  }
  if(chdir("dd/ff") == 0){
    4095:	48 bf 87 76 00 00 00 	movabs $0x7687,%rdi
    409c:	00 00 00 
    409f:	48 b8 c3 63 00 00 00 	movabs $0x63c3,%rax
    40a6:	00 00 00 
    40a9:	ff d0                	callq  *%rax
    40ab:	85 c0                	test   %eax,%eax
    40ad:	75 16                	jne    40c5 <subdir+0x734>
    failexit("chdir dd/ff succeeded");
    40af:	48 bf 81 79 00 00 00 	movabs $0x7981,%rdi
    40b6:	00 00 00 
    40b9:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    40c0:	00 00 00 
    40c3:	ff d0                	callq  *%rax
  }
  if(chdir("dd/xx") == 0){
    40c5:	48 bf 97 79 00 00 00 	movabs $0x7997,%rdi
    40cc:	00 00 00 
    40cf:	48 b8 c3 63 00 00 00 	movabs $0x63c3,%rax
    40d6:	00 00 00 
    40d9:	ff d0                	callq  *%rax
    40db:	85 c0                	test   %eax,%eax
    40dd:	75 16                	jne    40f5 <subdir+0x764>
    failexit("chdir dd/xx succeeded");
    40df:	48 bf 9d 79 00 00 00 	movabs $0x799d,%rdi
    40e6:	00 00 00 
    40e9:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    40f0:	00 00 00 
    40f3:	ff d0                	callq  *%rax
  }

  if(unlink("dd/dd/ffff") != 0){
    40f5:	48 bf 32 77 00 00 00 	movabs $0x7732,%rdi
    40fc:	00 00 00 
    40ff:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    4106:	00 00 00 
    4109:	ff d0                	callq  *%rax
    410b:	85 c0                	test   %eax,%eax
    410d:	74 16                	je     4125 <subdir+0x794>
    failexit("unlink dd/dd/ff");
    410f:	48 bf 56 77 00 00 00 	movabs $0x7756,%rdi
    4116:	00 00 00 
    4119:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4120:	00 00 00 
    4123:	ff d0                	callq  *%rax
  }
  if(unlink("dd/ff") != 0){
    4125:	48 bf 87 76 00 00 00 	movabs $0x7687,%rdi
    412c:	00 00 00 
    412f:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    4136:	00 00 00 
    4139:	ff d0                	callq  *%rax
    413b:	85 c0                	test   %eax,%eax
    413d:	74 16                	je     4155 <subdir+0x7c4>
    failexit("unlink dd/ff");
    413f:	48 bf b3 79 00 00 00 	movabs $0x79b3,%rdi
    4146:	00 00 00 
    4149:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4150:	00 00 00 
    4153:	ff d0                	callq  *%rax
  }
  if(unlink("dd") == 0){
    4155:	48 bf 74 76 00 00 00 	movabs $0x7674,%rdi
    415c:	00 00 00 
    415f:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    4166:	00 00 00 
    4169:	ff d0                	callq  *%rax
    416b:	85 c0                	test   %eax,%eax
    416d:	75 16                	jne    4185 <subdir+0x7f4>
    failexit("unlink non-empty dd succeeded");
    416f:	48 bf c0 79 00 00 00 	movabs $0x79c0,%rdi
    4176:	00 00 00 
    4179:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4180:	00 00 00 
    4183:	ff d0                	callq  *%rax
  }
  if(unlink("dd/dd") < 0){
    4185:	48 bf de 79 00 00 00 	movabs $0x79de,%rdi
    418c:	00 00 00 
    418f:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    4196:	00 00 00 
    4199:	ff d0                	callq  *%rax
    419b:	85 c0                	test   %eax,%eax
    419d:	79 16                	jns    41b5 <subdir+0x824>
    failexit("unlink dd/dd");
    419f:	48 bf e4 79 00 00 00 	movabs $0x79e4,%rdi
    41a6:	00 00 00 
    41a9:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    41b0:	00 00 00 
    41b3:	ff d0                	callq  *%rax
  }
  if(unlink("dd") < 0){
    41b5:	48 bf 74 76 00 00 00 	movabs $0x7674,%rdi
    41bc:	00 00 00 
    41bf:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    41c6:	00 00 00 
    41c9:	ff d0                	callq  *%rax
    41cb:	85 c0                	test   %eax,%eax
    41cd:	79 16                	jns    41e5 <subdir+0x854>
    failexit("unlink dd");
    41cf:	48 bf f1 79 00 00 00 	movabs $0x79f1,%rdi
    41d6:	00 00 00 
    41d9:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    41e0:	00 00 00 
    41e3:	ff d0                	callq  *%rax
  }

  printf(1, "subdir ok\n");
    41e5:	48 be fb 79 00 00 00 	movabs $0x79fb,%rsi
    41ec:	00 00 00 
    41ef:	bf 01 00 00 00       	mov    $0x1,%edi
    41f4:	b8 00 00 00 00       	mov    $0x0,%eax
    41f9:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    4200:	00 00 00 
    4203:	ff d2                	callq  *%rdx
}
    4205:	90                   	nop
    4206:	c9                   	leaveq 
    4207:	c3                   	retq   

0000000000004208 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    4208:	f3 0f 1e fa          	endbr64 
    420c:	55                   	push   %rbp
    420d:	48 89 e5             	mov    %rsp,%rbp
    4210:	48 83 ec 10          	sub    $0x10,%rsp
  int fd, sz;

  printf(1, "bigwrite test\n");
    4214:	48 be 06 7a 00 00 00 	movabs $0x7a06,%rsi
    421b:	00 00 00 
    421e:	bf 01 00 00 00       	mov    $0x1,%edi
    4223:	b8 00 00 00 00       	mov    $0x0,%eax
    4228:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    422f:	00 00 00 
    4232:	ff d2                	callq  *%rdx

  unlink("bigwrite");
    4234:	48 bf 15 7a 00 00 00 	movabs $0x7a15,%rdi
    423b:	00 00 00 
    423e:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    4245:	00 00 00 
    4248:	ff d0                	callq  *%rax
  for(sz = 499; sz < 12*512; sz += 471){
    424a:	c7 45 fc f3 01 00 00 	movl   $0x1f3,-0x4(%rbp)
    4251:	e9 db 00 00 00       	jmpq   4331 <bigwrite+0x129>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    4256:	be 02 02 00 00       	mov    $0x202,%esi
    425b:	48 bf 15 7a 00 00 00 	movabs $0x7a15,%rdi
    4262:	00 00 00 
    4265:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    426c:	00 00 00 
    426f:	ff d0                	callq  *%rax
    4271:	89 45 f4             	mov    %eax,-0xc(%rbp)
    if(fd < 0){
    4274:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    4278:	79 16                	jns    4290 <bigwrite+0x88>
      failexit("cannot create bigwrite");
    427a:	48 bf 1e 7a 00 00 00 	movabs $0x7a1e,%rdi
    4281:	00 00 00 
    4284:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    428b:	00 00 00 
    428e:	ff d0                	callq  *%rax
    }
    int i;
    for(i = 0; i < 2; i++){
    4290:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    4297:	eb 64                	jmp    42fd <bigwrite+0xf5>
      int cc = write(fd, buf, sz);
    4299:	8b 55 fc             	mov    -0x4(%rbp),%edx
    429c:	8b 45 f4             	mov    -0xc(%rbp),%eax
    429f:	48 be 20 8c 00 00 00 	movabs $0x8c20,%rsi
    42a6:	00 00 00 
    42a9:	89 c7                	mov    %eax,%edi
    42ab:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    42b2:	00 00 00 
    42b5:	ff d0                	callq  *%rax
    42b7:	89 45 f0             	mov    %eax,-0x10(%rbp)
      if(cc != sz){
    42ba:	8b 45 f0             	mov    -0x10(%rbp),%eax
    42bd:	3b 45 fc             	cmp    -0x4(%rbp),%eax
    42c0:	74 37                	je     42f9 <bigwrite+0xf1>
        printf(1, "write(%d) ret %d\n", sz, cc);
    42c2:	8b 55 f0             	mov    -0x10(%rbp),%edx
    42c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    42c8:	89 d1                	mov    %edx,%ecx
    42ca:	89 c2                	mov    %eax,%edx
    42cc:	48 be 35 7a 00 00 00 	movabs $0x7a35,%rsi
    42d3:	00 00 00 
    42d6:	bf 01 00 00 00       	mov    $0x1,%edi
    42db:	b8 00 00 00 00       	mov    $0x0,%eax
    42e0:	49 b8 11 66 00 00 00 	movabs $0x6611,%r8
    42e7:	00 00 00 
    42ea:	41 ff d0             	callq  *%r8
        exit();
    42ed:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    42f4:	00 00 00 
    42f7:	ff d0                	callq  *%rax
    for(i = 0; i < 2; i++){
    42f9:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    42fd:	83 7d f8 01          	cmpl   $0x1,-0x8(%rbp)
    4301:	7e 96                	jle    4299 <bigwrite+0x91>
      }
    }
    close(fd);
    4303:	8b 45 f4             	mov    -0xc(%rbp),%eax
    4306:	89 c7                	mov    %eax,%edi
    4308:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    430f:	00 00 00 
    4312:	ff d0                	callq  *%rax
    unlink("bigwrite");
    4314:	48 bf 15 7a 00 00 00 	movabs $0x7a15,%rdi
    431b:	00 00 00 
    431e:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    4325:	00 00 00 
    4328:	ff d0                	callq  *%rax
  for(sz = 499; sz < 12*512; sz += 471){
    432a:	81 45 fc d7 01 00 00 	addl   $0x1d7,-0x4(%rbp)
    4331:	81 7d fc ff 17 00 00 	cmpl   $0x17ff,-0x4(%rbp)
    4338:	0f 8e 18 ff ff ff    	jle    4256 <bigwrite+0x4e>
  }

  printf(1, "bigwrite ok\n");
    433e:	48 be 47 7a 00 00 00 	movabs $0x7a47,%rsi
    4345:	00 00 00 
    4348:	bf 01 00 00 00       	mov    $0x1,%edi
    434d:	b8 00 00 00 00       	mov    $0x0,%eax
    4352:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    4359:	00 00 00 
    435c:	ff d2                	callq  *%rdx
}
    435e:	90                   	nop
    435f:	c9                   	leaveq 
    4360:	c3                   	retq   

0000000000004361 <bigfile>:

void
bigfile(void)
{
    4361:	f3 0f 1e fa          	endbr64 
    4365:	55                   	push   %rbp
    4366:	48 89 e5             	mov    %rsp,%rbp
    4369:	48 83 ec 10          	sub    $0x10,%rsp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    436d:	48 be 54 7a 00 00 00 	movabs $0x7a54,%rsi
    4374:	00 00 00 
    4377:	bf 01 00 00 00       	mov    $0x1,%edi
    437c:	b8 00 00 00 00       	mov    $0x0,%eax
    4381:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    4388:	00 00 00 
    438b:	ff d2                	callq  *%rdx

  unlink("bigfile");
    438d:	48 bf 62 7a 00 00 00 	movabs $0x7a62,%rdi
    4394:	00 00 00 
    4397:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    439e:	00 00 00 
    43a1:	ff d0                	callq  *%rax
  fd = open("bigfile", O_CREATE | O_RDWR);
    43a3:	be 02 02 00 00       	mov    $0x202,%esi
    43a8:	48 bf 62 7a 00 00 00 	movabs $0x7a62,%rdi
    43af:	00 00 00 
    43b2:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    43b9:	00 00 00 
    43bc:	ff d0                	callq  *%rax
    43be:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(fd < 0){
    43c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    43c5:	79 16                	jns    43dd <bigfile+0x7c>
    failexit("cannot create bigfile");
    43c7:	48 bf 6a 7a 00 00 00 	movabs $0x7a6a,%rdi
    43ce:	00 00 00 
    43d1:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    43d8:	00 00 00 
    43db:	ff d0                	callq  *%rax
  }
  for(i = 0; i < 20; i++){
    43dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    43e4:	eb 61                	jmp    4447 <bigfile+0xe6>
    memset(buf, i, 600);
    43e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    43e9:	ba 58 02 00 00       	mov    $0x258,%edx
    43ee:	89 c6                	mov    %eax,%esi
    43f0:	48 bf 20 8c 00 00 00 	movabs $0x8c20,%rdi
    43f7:	00 00 00 
    43fa:	48 b8 d8 60 00 00 00 	movabs $0x60d8,%rax
    4401:	00 00 00 
    4404:	ff d0                	callq  *%rax
    if(write(fd, buf, 600) != 600){
    4406:	8b 45 f4             	mov    -0xc(%rbp),%eax
    4409:	ba 58 02 00 00       	mov    $0x258,%edx
    440e:	48 be 20 8c 00 00 00 	movabs $0x8c20,%rsi
    4415:	00 00 00 
    4418:	89 c7                	mov    %eax,%edi
    441a:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    4421:	00 00 00 
    4424:	ff d0                	callq  *%rax
    4426:	3d 58 02 00 00       	cmp    $0x258,%eax
    442b:	74 16                	je     4443 <bigfile+0xe2>
      failexit("write bigfile");
    442d:	48 bf 80 7a 00 00 00 	movabs $0x7a80,%rdi
    4434:	00 00 00 
    4437:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    443e:	00 00 00 
    4441:	ff d0                	callq  *%rax
  for(i = 0; i < 20; i++){
    4443:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    4447:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
    444b:	7e 99                	jle    43e6 <bigfile+0x85>
    }
  }
  close(fd);
    444d:	8b 45 f4             	mov    -0xc(%rbp),%eax
    4450:	89 c7                	mov    %eax,%edi
    4452:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    4459:	00 00 00 
    445c:	ff d0                	callq  *%rax

  fd = open("bigfile", 0);
    445e:	be 00 00 00 00       	mov    $0x0,%esi
    4463:	48 bf 62 7a 00 00 00 	movabs $0x7a62,%rdi
    446a:	00 00 00 
    446d:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    4474:	00 00 00 
    4477:	ff d0                	callq  *%rax
    4479:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(fd < 0){
    447c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    4480:	79 16                	jns    4498 <bigfile+0x137>
    failexit("cannot open bigfile");
    4482:	48 bf 8e 7a 00 00 00 	movabs $0x7a8e,%rdi
    4489:	00 00 00 
    448c:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4493:	00 00 00 
    4496:	ff d0                	callq  *%rax
  }
  total = 0;
    4498:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  for(i = 0; ; i++){
    449f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    cc = read(fd, buf, 300);
    44a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
    44a9:	ba 2c 01 00 00       	mov    $0x12c,%edx
    44ae:	48 be 20 8c 00 00 00 	movabs $0x8c20,%rsi
    44b5:	00 00 00 
    44b8:	89 c7                	mov    %eax,%edi
    44ba:	48 b8 34 63 00 00 00 	movabs $0x6334,%rax
    44c1:	00 00 00 
    44c4:	ff d0                	callq  *%rax
    44c6:	89 45 f0             	mov    %eax,-0x10(%rbp)
    if(cc < 0){
    44c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    44cd:	79 16                	jns    44e5 <bigfile+0x184>
      failexit("read bigfile");
    44cf:	48 bf a2 7a 00 00 00 	movabs $0x7aa2,%rdi
    44d6:	00 00 00 
    44d9:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    44e0:	00 00 00 
    44e3:	ff d0                	callq  *%rax
    }
    if(cc == 0)
    44e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    44e9:	0f 84 88 00 00 00    	je     4577 <bigfile+0x216>
      break;
    if(cc != 300){
    44ef:	81 7d f0 2c 01 00 00 	cmpl   $0x12c,-0x10(%rbp)
    44f6:	74 16                	je     450e <bigfile+0x1ad>
      failexit("short read bigfile");
    44f8:	48 bf af 7a 00 00 00 	movabs $0x7aaf,%rdi
    44ff:	00 00 00 
    4502:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4509:	00 00 00 
    450c:	ff d0                	callq  *%rax
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    450e:	48 b8 20 8c 00 00 00 	movabs $0x8c20,%rax
    4515:	00 00 00 
    4518:	0f b6 00             	movzbl (%rax),%eax
    451b:	0f be d0             	movsbl %al,%edx
    451e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    4521:	89 c1                	mov    %eax,%ecx
    4523:	c1 e9 1f             	shr    $0x1f,%ecx
    4526:	01 c8                	add    %ecx,%eax
    4528:	d1 f8                	sar    %eax
    452a:	39 c2                	cmp    %eax,%edx
    452c:	75 24                	jne    4552 <bigfile+0x1f1>
    452e:	48 b8 20 8c 00 00 00 	movabs $0x8c20,%rax
    4535:	00 00 00 
    4538:	0f b6 80 2b 01 00 00 	movzbl 0x12b(%rax),%eax
    453f:	0f be d0             	movsbl %al,%edx
    4542:	8b 45 fc             	mov    -0x4(%rbp),%eax
    4545:	89 c1                	mov    %eax,%ecx
    4547:	c1 e9 1f             	shr    $0x1f,%ecx
    454a:	01 c8                	add    %ecx,%eax
    454c:	d1 f8                	sar    %eax
    454e:	39 c2                	cmp    %eax,%edx
    4550:	74 16                	je     4568 <bigfile+0x207>
      failexit("read bigfile wrong data");
    4552:	48 bf c2 7a 00 00 00 	movabs $0x7ac2,%rdi
    4559:	00 00 00 
    455c:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4563:	00 00 00 
    4566:	ff d0                	callq  *%rax
    }
    total += cc;
    4568:	8b 45 f0             	mov    -0x10(%rbp),%eax
    456b:	01 45 f8             	add    %eax,-0x8(%rbp)
  for(i = 0; ; i++){
    456e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    cc = read(fd, buf, 300);
    4572:	e9 2f ff ff ff       	jmpq   44a6 <bigfile+0x145>
      break;
    4577:	90                   	nop
  }
  close(fd);
    4578:	8b 45 f4             	mov    -0xc(%rbp),%eax
    457b:	89 c7                	mov    %eax,%edi
    457d:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    4584:	00 00 00 
    4587:	ff d0                	callq  *%rax
  if(total != 20*600){
    4589:	81 7d f8 e0 2e 00 00 	cmpl   $0x2ee0,-0x8(%rbp)
    4590:	74 16                	je     45a8 <bigfile+0x247>
    failexit("read bigfile wrong total");
    4592:	48 bf da 7a 00 00 00 	movabs $0x7ada,%rdi
    4599:	00 00 00 
    459c:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    45a3:	00 00 00 
    45a6:	ff d0                	callq  *%rax
  }
  unlink("bigfile");
    45a8:	48 bf 62 7a 00 00 00 	movabs $0x7a62,%rdi
    45af:	00 00 00 
    45b2:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    45b9:	00 00 00 
    45bc:	ff d0                	callq  *%rax

  printf(1, "bigfile test ok\n");
    45be:	48 be f3 7a 00 00 00 	movabs $0x7af3,%rsi
    45c5:	00 00 00 
    45c8:	bf 01 00 00 00       	mov    $0x1,%edi
    45cd:	b8 00 00 00 00       	mov    $0x0,%eax
    45d2:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    45d9:	00 00 00 
    45dc:	ff d2                	callq  *%rdx
}
    45de:	90                   	nop
    45df:	c9                   	leaveq 
    45e0:	c3                   	retq   

00000000000045e1 <fourteen>:

void
fourteen(void)
{
    45e1:	f3 0f 1e fa          	endbr64 
    45e5:	55                   	push   %rbp
    45e6:	48 89 e5             	mov    %rsp,%rbp
    45e9:	48 83 ec 10          	sub    $0x10,%rsp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    45ed:	48 be 04 7b 00 00 00 	movabs $0x7b04,%rsi
    45f4:	00 00 00 
    45f7:	bf 01 00 00 00       	mov    $0x1,%edi
    45fc:	b8 00 00 00 00       	mov    $0x0,%eax
    4601:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    4608:	00 00 00 
    460b:	ff d2                	callq  *%rdx

  if(mkdir("12345678901234") != 0){
    460d:	48 bf 13 7b 00 00 00 	movabs $0x7b13,%rdi
    4614:	00 00 00 
    4617:	48 b8 b6 63 00 00 00 	movabs $0x63b6,%rax
    461e:	00 00 00 
    4621:	ff d0                	callq  *%rax
    4623:	85 c0                	test   %eax,%eax
    4625:	74 16                	je     463d <fourteen+0x5c>
    failexit("mkdir 12345678901234");
    4627:	48 bf 22 7b 00 00 00 	movabs $0x7b22,%rdi
    462e:	00 00 00 
    4631:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4638:	00 00 00 
    463b:	ff d0                	callq  *%rax
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    463d:	48 bf 38 7b 00 00 00 	movabs $0x7b38,%rdi
    4644:	00 00 00 
    4647:	48 b8 b6 63 00 00 00 	movabs $0x63b6,%rax
    464e:	00 00 00 
    4651:	ff d0                	callq  *%rax
    4653:	85 c0                	test   %eax,%eax
    4655:	74 16                	je     466d <fourteen+0x8c>
    failexit("mkdir 12345678901234/123456789012345");
    4657:	48 bf 58 7b 00 00 00 	movabs $0x7b58,%rdi
    465e:	00 00 00 
    4661:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4668:	00 00 00 
    466b:	ff d0                	callq  *%rax
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    466d:	be 00 02 00 00       	mov    $0x200,%esi
    4672:	48 bf 80 7b 00 00 00 	movabs $0x7b80,%rdi
    4679:	00 00 00 
    467c:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    4683:	00 00 00 
    4686:	ff d0                	callq  *%rax
    4688:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    468b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    468f:	79 16                	jns    46a7 <fourteen+0xc6>
    failexit("create 123456789012345/123456789012345/123456789012345");
    4691:	48 bf b0 7b 00 00 00 	movabs $0x7bb0,%rdi
    4698:	00 00 00 
    469b:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    46a2:	00 00 00 
    46a5:	ff d0                	callq  *%rax
  }
  close(fd);
    46a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
    46aa:	89 c7                	mov    %eax,%edi
    46ac:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    46b3:	00 00 00 
    46b6:	ff d0                	callq  *%rax
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    46b8:	be 00 00 00 00       	mov    $0x0,%esi
    46bd:	48 bf e8 7b 00 00 00 	movabs $0x7be8,%rdi
    46c4:	00 00 00 
    46c7:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    46ce:	00 00 00 
    46d1:	ff d0                	callq  *%rax
    46d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    46d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    46da:	79 16                	jns    46f2 <fourteen+0x111>
    failexit("open 12345678901234/12345678901234/12345678901234");
    46dc:	48 bf 18 7c 00 00 00 	movabs $0x7c18,%rdi
    46e3:	00 00 00 
    46e6:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    46ed:	00 00 00 
    46f0:	ff d0                	callq  *%rax
  }
  close(fd);
    46f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
    46f5:	89 c7                	mov    %eax,%edi
    46f7:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    46fe:	00 00 00 
    4701:	ff d0                	callq  *%rax

  if(mkdir("12345678901234/12345678901234") == 0){
    4703:	48 bf 4a 7c 00 00 00 	movabs $0x7c4a,%rdi
    470a:	00 00 00 
    470d:	48 b8 b6 63 00 00 00 	movabs $0x63b6,%rax
    4714:	00 00 00 
    4717:	ff d0                	callq  *%rax
    4719:	85 c0                	test   %eax,%eax
    471b:	75 16                	jne    4733 <fourteen+0x152>
    failexit("mkdir 12345678901234/12345678901234 succeeded");
    471d:	48 bf 68 7c 00 00 00 	movabs $0x7c68,%rdi
    4724:	00 00 00 
    4727:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    472e:	00 00 00 
    4731:	ff d0                	callq  *%rax
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    4733:	48 bf 98 7c 00 00 00 	movabs $0x7c98,%rdi
    473a:	00 00 00 
    473d:	48 b8 b6 63 00 00 00 	movabs $0x63b6,%rax
    4744:	00 00 00 
    4747:	ff d0                	callq  *%rax
    4749:	85 c0                	test   %eax,%eax
    474b:	75 16                	jne    4763 <fourteen+0x182>
    failexit("mkdir 12345678901234/123456789012345 succeeded");
    474d:	48 bf b8 7c 00 00 00 	movabs $0x7cb8,%rdi
    4754:	00 00 00 
    4757:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    475e:	00 00 00 
    4761:	ff d0                	callq  *%rax
  }

  printf(1, "fourteen ok\n");
    4763:	48 be e7 7c 00 00 00 	movabs $0x7ce7,%rsi
    476a:	00 00 00 
    476d:	bf 01 00 00 00       	mov    $0x1,%edi
    4772:	b8 00 00 00 00       	mov    $0x0,%eax
    4777:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    477e:	00 00 00 
    4781:	ff d2                	callq  *%rdx
}
    4783:	90                   	nop
    4784:	c9                   	leaveq 
    4785:	c3                   	retq   

0000000000004786 <rmdot>:

void
rmdot(void)
{
    4786:	f3 0f 1e fa          	endbr64 
    478a:	55                   	push   %rbp
    478b:	48 89 e5             	mov    %rsp,%rbp
  printf(1, "rmdot test\n");
    478e:	48 be f4 7c 00 00 00 	movabs $0x7cf4,%rsi
    4795:	00 00 00 
    4798:	bf 01 00 00 00       	mov    $0x1,%edi
    479d:	b8 00 00 00 00       	mov    $0x0,%eax
    47a2:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    47a9:	00 00 00 
    47ac:	ff d2                	callq  *%rdx
  if(mkdir("dots") != 0){
    47ae:	48 bf 00 7d 00 00 00 	movabs $0x7d00,%rdi
    47b5:	00 00 00 
    47b8:	48 b8 b6 63 00 00 00 	movabs $0x63b6,%rax
    47bf:	00 00 00 
    47c2:	ff d0                	callq  *%rax
    47c4:	85 c0                	test   %eax,%eax
    47c6:	74 16                	je     47de <rmdot+0x58>
    failexit("mkdir dots");
    47c8:	48 bf 05 7d 00 00 00 	movabs $0x7d05,%rdi
    47cf:	00 00 00 
    47d2:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    47d9:	00 00 00 
    47dc:	ff d0                	callq  *%rax
  }
  if(chdir("dots") != 0){
    47de:	48 bf 00 7d 00 00 00 	movabs $0x7d00,%rdi
    47e5:	00 00 00 
    47e8:	48 b8 c3 63 00 00 00 	movabs $0x63c3,%rax
    47ef:	00 00 00 
    47f2:	ff d0                	callq  *%rax
    47f4:	85 c0                	test   %eax,%eax
    47f6:	74 16                	je     480e <rmdot+0x88>
    failexit("chdir dots");
    47f8:	48 bf 10 7d 00 00 00 	movabs $0x7d10,%rdi
    47ff:	00 00 00 
    4802:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4809:	00 00 00 
    480c:	ff d0                	callq  *%rax
  }
  if(unlink(".") == 0){
    480e:	48 bf 22 75 00 00 00 	movabs $0x7522,%rdi
    4815:	00 00 00 
    4818:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    481f:	00 00 00 
    4822:	ff d0                	callq  *%rax
    4824:	85 c0                	test   %eax,%eax
    4826:	75 16                	jne    483e <rmdot+0xb8>
    failexit("rm . worked");
    4828:	48 bf 1b 7d 00 00 00 	movabs $0x7d1b,%rdi
    482f:	00 00 00 
    4832:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4839:	00 00 00 
    483c:	ff d0                	callq  *%rax
  }
  if(unlink("..") == 0){
    483e:	48 bf 9a 70 00 00 00 	movabs $0x709a,%rdi
    4845:	00 00 00 
    4848:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    484f:	00 00 00 
    4852:	ff d0                	callq  *%rax
    4854:	85 c0                	test   %eax,%eax
    4856:	75 16                	jne    486e <rmdot+0xe8>
    failexit("rm .. worked");
    4858:	48 bf 27 7d 00 00 00 	movabs $0x7d27,%rdi
    485f:	00 00 00 
    4862:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4869:	00 00 00 
    486c:	ff d0                	callq  *%rax
  }
  if(chdir("/") != 0){
    486e:	48 bf 90 6d 00 00 00 	movabs $0x6d90,%rdi
    4875:	00 00 00 
    4878:	48 b8 c3 63 00 00 00 	movabs $0x63c3,%rax
    487f:	00 00 00 
    4882:	ff d0                	callq  *%rax
    4884:	85 c0                	test   %eax,%eax
    4886:	74 16                	je     489e <rmdot+0x118>
    failexit("chdir /");
    4888:	48 bf 92 6d 00 00 00 	movabs $0x6d92,%rdi
    488f:	00 00 00 
    4892:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4899:	00 00 00 
    489c:	ff d0                	callq  *%rax
  }
  if(unlink("dots/.") == 0){
    489e:	48 bf 34 7d 00 00 00 	movabs $0x7d34,%rdi
    48a5:	00 00 00 
    48a8:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    48af:	00 00 00 
    48b2:	ff d0                	callq  *%rax
    48b4:	85 c0                	test   %eax,%eax
    48b6:	75 16                	jne    48ce <rmdot+0x148>
    failexit("unlink dots/. worked");
    48b8:	48 bf 3b 7d 00 00 00 	movabs $0x7d3b,%rdi
    48bf:	00 00 00 
    48c2:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    48c9:	00 00 00 
    48cc:	ff d0                	callq  *%rax
  }
  if(unlink("dots/..") == 0){
    48ce:	48 bf 50 7d 00 00 00 	movabs $0x7d50,%rdi
    48d5:	00 00 00 
    48d8:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    48df:	00 00 00 
    48e2:	ff d0                	callq  *%rax
    48e4:	85 c0                	test   %eax,%eax
    48e6:	75 16                	jne    48fe <rmdot+0x178>
    failexit("unlink dots/.. worked");
    48e8:	48 bf 58 7d 00 00 00 	movabs $0x7d58,%rdi
    48ef:	00 00 00 
    48f2:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    48f9:	00 00 00 
    48fc:	ff d0                	callq  *%rax
  }
  if(unlink("dots") != 0){
    48fe:	48 bf 00 7d 00 00 00 	movabs $0x7d00,%rdi
    4905:	00 00 00 
    4908:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    490f:	00 00 00 
    4912:	ff d0                	callq  *%rax
    4914:	85 c0                	test   %eax,%eax
    4916:	74 16                	je     492e <rmdot+0x1a8>
    failexit("unlink dots");
    4918:	48 bf 6e 7d 00 00 00 	movabs $0x7d6e,%rdi
    491f:	00 00 00 
    4922:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4929:	00 00 00 
    492c:	ff d0                	callq  *%rax
  }
  printf(1, "rmdot ok\n");
    492e:	48 be 7a 7d 00 00 00 	movabs $0x7d7a,%rsi
    4935:	00 00 00 
    4938:	bf 01 00 00 00       	mov    $0x1,%edi
    493d:	b8 00 00 00 00       	mov    $0x0,%eax
    4942:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    4949:	00 00 00 
    494c:	ff d2                	callq  *%rdx
}
    494e:	90                   	nop
    494f:	5d                   	pop    %rbp
    4950:	c3                   	retq   

0000000000004951 <dirfile>:

void
dirfile(void)
{
    4951:	f3 0f 1e fa          	endbr64 
    4955:	55                   	push   %rbp
    4956:	48 89 e5             	mov    %rsp,%rbp
    4959:	48 83 ec 10          	sub    $0x10,%rsp
  int fd;

  printf(1, "dir vs file\n");
    495d:	48 be 84 7d 00 00 00 	movabs $0x7d84,%rsi
    4964:	00 00 00 
    4967:	bf 01 00 00 00       	mov    $0x1,%edi
    496c:	b8 00 00 00 00       	mov    $0x0,%eax
    4971:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    4978:	00 00 00 
    497b:	ff d2                	callq  *%rdx

  fd = open("dirfile", O_CREATE);
    497d:	be 00 02 00 00       	mov    $0x200,%esi
    4982:	48 bf 91 7d 00 00 00 	movabs $0x7d91,%rdi
    4989:	00 00 00 
    498c:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    4993:	00 00 00 
    4996:	ff d0                	callq  *%rax
    4998:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    499b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    499f:	79 16                	jns    49b7 <dirfile+0x66>
    failexit("create dirfile");
    49a1:	48 bf 99 7d 00 00 00 	movabs $0x7d99,%rdi
    49a8:	00 00 00 
    49ab:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    49b2:	00 00 00 
    49b5:	ff d0                	callq  *%rax
  }
  close(fd);
    49b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
    49ba:	89 c7                	mov    %eax,%edi
    49bc:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    49c3:	00 00 00 
    49c6:	ff d0                	callq  *%rax
  if(chdir("dirfile") == 0){
    49c8:	48 bf 91 7d 00 00 00 	movabs $0x7d91,%rdi
    49cf:	00 00 00 
    49d2:	48 b8 c3 63 00 00 00 	movabs $0x63c3,%rax
    49d9:	00 00 00 
    49dc:	ff d0                	callq  *%rax
    49de:	85 c0                	test   %eax,%eax
    49e0:	75 16                	jne    49f8 <dirfile+0xa7>
    failexit("chdir dirfile succeeded");
    49e2:	48 bf a8 7d 00 00 00 	movabs $0x7da8,%rdi
    49e9:	00 00 00 
    49ec:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    49f3:	00 00 00 
    49f6:	ff d0                	callq  *%rax
  }
  fd = open("dirfile/xx", 0);
    49f8:	be 00 00 00 00       	mov    $0x0,%esi
    49fd:	48 bf c0 7d 00 00 00 	movabs $0x7dc0,%rdi
    4a04:	00 00 00 
    4a07:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    4a0e:	00 00 00 
    4a11:	ff d0                	callq  *%rax
    4a13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd >= 0){
    4a16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    4a1a:	78 16                	js     4a32 <dirfile+0xe1>
    failexit("create dirfile/xx succeeded");
    4a1c:	48 bf cb 7d 00 00 00 	movabs $0x7dcb,%rdi
    4a23:	00 00 00 
    4a26:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4a2d:	00 00 00 
    4a30:	ff d0                	callq  *%rax
  }
  fd = open("dirfile/xx", O_CREATE);
    4a32:	be 00 02 00 00       	mov    $0x200,%esi
    4a37:	48 bf c0 7d 00 00 00 	movabs $0x7dc0,%rdi
    4a3e:	00 00 00 
    4a41:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    4a48:	00 00 00 
    4a4b:	ff d0                	callq  *%rax
    4a4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd >= 0){
    4a50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    4a54:	78 16                	js     4a6c <dirfile+0x11b>
    failexit("create dirfile/xx succeeded");
    4a56:	48 bf cb 7d 00 00 00 	movabs $0x7dcb,%rdi
    4a5d:	00 00 00 
    4a60:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4a67:	00 00 00 
    4a6a:	ff d0                	callq  *%rax
  }
  if(mkdir("dirfile/xx") == 0){
    4a6c:	48 bf c0 7d 00 00 00 	movabs $0x7dc0,%rdi
    4a73:	00 00 00 
    4a76:	48 b8 b6 63 00 00 00 	movabs $0x63b6,%rax
    4a7d:	00 00 00 
    4a80:	ff d0                	callq  *%rax
    4a82:	85 c0                	test   %eax,%eax
    4a84:	75 16                	jne    4a9c <dirfile+0x14b>
    failexit("mkdir dirfile/xx succeeded");
    4a86:	48 bf e7 7d 00 00 00 	movabs $0x7de7,%rdi
    4a8d:	00 00 00 
    4a90:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4a97:	00 00 00 
    4a9a:	ff d0                	callq  *%rax
  }
  if(unlink("dirfile/xx") == 0){
    4a9c:	48 bf c0 7d 00 00 00 	movabs $0x7dc0,%rdi
    4aa3:	00 00 00 
    4aa6:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    4aad:	00 00 00 
    4ab0:	ff d0                	callq  *%rax
    4ab2:	85 c0                	test   %eax,%eax
    4ab4:	75 16                	jne    4acc <dirfile+0x17b>
    failexit("unlink dirfile/xx succeeded");
    4ab6:	48 bf 02 7e 00 00 00 	movabs $0x7e02,%rdi
    4abd:	00 00 00 
    4ac0:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4ac7:	00 00 00 
    4aca:	ff d0                	callq  *%rax
  }
  if(link("README", "dirfile/xx") == 0){
    4acc:	48 be c0 7d 00 00 00 	movabs $0x7dc0,%rsi
    4ad3:	00 00 00 
    4ad6:	48 bf 1e 7e 00 00 00 	movabs $0x7e1e,%rdi
    4add:	00 00 00 
    4ae0:	48 b8 a9 63 00 00 00 	movabs $0x63a9,%rax
    4ae7:	00 00 00 
    4aea:	ff d0                	callq  *%rax
    4aec:	85 c0                	test   %eax,%eax
    4aee:	75 16                	jne    4b06 <dirfile+0x1b5>
    failexit("link to dirfile/xx succeeded");
    4af0:	48 bf 25 7e 00 00 00 	movabs $0x7e25,%rdi
    4af7:	00 00 00 
    4afa:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4b01:	00 00 00 
    4b04:	ff d0                	callq  *%rax
  }
  if(unlink("dirfile") != 0){
    4b06:	48 bf 91 7d 00 00 00 	movabs $0x7d91,%rdi
    4b0d:	00 00 00 
    4b10:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    4b17:	00 00 00 
    4b1a:	ff d0                	callq  *%rax
    4b1c:	85 c0                	test   %eax,%eax
    4b1e:	74 16                	je     4b36 <dirfile+0x1e5>
    failexit("unlink dirfile");
    4b20:	48 bf 42 7e 00 00 00 	movabs $0x7e42,%rdi
    4b27:	00 00 00 
    4b2a:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4b31:	00 00 00 
    4b34:	ff d0                	callq  *%rax
  }

  fd = open(".", O_RDWR);
    4b36:	be 02 00 00 00       	mov    $0x2,%esi
    4b3b:	48 bf 22 75 00 00 00 	movabs $0x7522,%rdi
    4b42:	00 00 00 
    4b45:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    4b4c:	00 00 00 
    4b4f:	ff d0                	callq  *%rax
    4b51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd >= 0){
    4b54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    4b58:	78 16                	js     4b70 <dirfile+0x21f>
    failexit("open . for writing succeeded");
    4b5a:	48 bf 51 7e 00 00 00 	movabs $0x7e51,%rdi
    4b61:	00 00 00 
    4b64:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4b6b:	00 00 00 
    4b6e:	ff d0                	callq  *%rax
  }
  fd = open(".", 0);
    4b70:	be 00 00 00 00       	mov    $0x0,%esi
    4b75:	48 bf 22 75 00 00 00 	movabs $0x7522,%rdi
    4b7c:	00 00 00 
    4b7f:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    4b86:	00 00 00 
    4b89:	ff d0                	callq  *%rax
    4b8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(write(fd, "x", 1) > 0){
    4b8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    4b91:	ba 01 00 00 00       	mov    $0x1,%edx
    4b96:	48 be a6 71 00 00 00 	movabs $0x71a6,%rsi
    4b9d:	00 00 00 
    4ba0:	89 c7                	mov    %eax,%edi
    4ba2:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    4ba9:	00 00 00 
    4bac:	ff d0                	callq  *%rax
    4bae:	85 c0                	test   %eax,%eax
    4bb0:	7e 16                	jle    4bc8 <dirfile+0x277>
    failexit("write . succeeded");
    4bb2:	48 bf 6e 7e 00 00 00 	movabs $0x7e6e,%rdi
    4bb9:	00 00 00 
    4bbc:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4bc3:	00 00 00 
    4bc6:	ff d0                	callq  *%rax
  }
  close(fd);
    4bc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    4bcb:	89 c7                	mov    %eax,%edi
    4bcd:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    4bd4:	00 00 00 
    4bd7:	ff d0                	callq  *%rax

  printf(1, "dir vs file OK\n");
    4bd9:	48 be 80 7e 00 00 00 	movabs $0x7e80,%rsi
    4be0:	00 00 00 
    4be3:	bf 01 00 00 00       	mov    $0x1,%edi
    4be8:	b8 00 00 00 00       	mov    $0x0,%eax
    4bed:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    4bf4:	00 00 00 
    4bf7:	ff d2                	callq  *%rdx
}
    4bf9:	90                   	nop
    4bfa:	c9                   	leaveq 
    4bfb:	c3                   	retq   

0000000000004bfc <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    4bfc:	f3 0f 1e fa          	endbr64 
    4c00:	55                   	push   %rbp
    4c01:	48 89 e5             	mov    %rsp,%rbp
    4c04:	48 83 ec 10          	sub    $0x10,%rsp
  int i, fd;

  printf(1, "empty file name\n");
    4c08:	48 be 90 7e 00 00 00 	movabs $0x7e90,%rsi
    4c0f:	00 00 00 
    4c12:	bf 01 00 00 00       	mov    $0x1,%edi
    4c17:	b8 00 00 00 00       	mov    $0x0,%eax
    4c1c:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    4c23:	00 00 00 
    4c26:	ff d2                	callq  *%rdx

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    4c28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    4c2f:	e9 1a 01 00 00       	jmpq   4d4e <iref+0x152>
    if(mkdir("irefd") != 0){
    4c34:	48 bf a1 7e 00 00 00 	movabs $0x7ea1,%rdi
    4c3b:	00 00 00 
    4c3e:	48 b8 b6 63 00 00 00 	movabs $0x63b6,%rax
    4c45:	00 00 00 
    4c48:	ff d0                	callq  *%rax
    4c4a:	85 c0                	test   %eax,%eax
    4c4c:	74 16                	je     4c64 <iref+0x68>
      failexit("mkdir irefd");
    4c4e:	48 bf a7 7e 00 00 00 	movabs $0x7ea7,%rdi
    4c55:	00 00 00 
    4c58:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4c5f:	00 00 00 
    4c62:	ff d0                	callq  *%rax
    }
    if(chdir("irefd") != 0){
    4c64:	48 bf a1 7e 00 00 00 	movabs $0x7ea1,%rdi
    4c6b:	00 00 00 
    4c6e:	48 b8 c3 63 00 00 00 	movabs $0x63c3,%rax
    4c75:	00 00 00 
    4c78:	ff d0                	callq  *%rax
    4c7a:	85 c0                	test   %eax,%eax
    4c7c:	74 16                	je     4c94 <iref+0x98>
      failexit("chdir irefd");
    4c7e:	48 bf b3 7e 00 00 00 	movabs $0x7eb3,%rdi
    4c85:	00 00 00 
    4c88:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4c8f:	00 00 00 
    4c92:	ff d0                	callq  *%rax
    }

    mkdir("");
    4c94:	48 bf bf 7e 00 00 00 	movabs $0x7ebf,%rdi
    4c9b:	00 00 00 
    4c9e:	48 b8 b6 63 00 00 00 	movabs $0x63b6,%rax
    4ca5:	00 00 00 
    4ca8:	ff d0                	callq  *%rax
    link("README", "");
    4caa:	48 be bf 7e 00 00 00 	movabs $0x7ebf,%rsi
    4cb1:	00 00 00 
    4cb4:	48 bf 1e 7e 00 00 00 	movabs $0x7e1e,%rdi
    4cbb:	00 00 00 
    4cbe:	48 b8 a9 63 00 00 00 	movabs $0x63a9,%rax
    4cc5:	00 00 00 
    4cc8:	ff d0                	callq  *%rax
    fd = open("", O_CREATE);
    4cca:	be 00 02 00 00       	mov    $0x200,%esi
    4ccf:	48 bf bf 7e 00 00 00 	movabs $0x7ebf,%rdi
    4cd6:	00 00 00 
    4cd9:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    4ce0:	00 00 00 
    4ce3:	ff d0                	callq  *%rax
    4ce5:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(fd >= 0)
    4ce8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    4cec:	78 11                	js     4cff <iref+0x103>
      close(fd);
    4cee:	8b 45 f8             	mov    -0x8(%rbp),%eax
    4cf1:	89 c7                	mov    %eax,%edi
    4cf3:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    4cfa:	00 00 00 
    4cfd:	ff d0                	callq  *%rax
    fd = open("xx", O_CREATE);
    4cff:	be 00 02 00 00       	mov    $0x200,%esi
    4d04:	48 bf c0 7e 00 00 00 	movabs $0x7ec0,%rdi
    4d0b:	00 00 00 
    4d0e:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    4d15:	00 00 00 
    4d18:	ff d0                	callq  *%rax
    4d1a:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(fd >= 0)
    4d1d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    4d21:	78 11                	js     4d34 <iref+0x138>
      close(fd);
    4d23:	8b 45 f8             	mov    -0x8(%rbp),%eax
    4d26:	89 c7                	mov    %eax,%edi
    4d28:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    4d2f:	00 00 00 
    4d32:	ff d0                	callq  *%rax
    unlink("xx");
    4d34:	48 bf c0 7e 00 00 00 	movabs $0x7ec0,%rdi
    4d3b:	00 00 00 
    4d3e:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    4d45:	00 00 00 
    4d48:	ff d0                	callq  *%rax
  for(i = 0; i < 50 + 1; i++){
    4d4a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    4d4e:	83 7d fc 32          	cmpl   $0x32,-0x4(%rbp)
    4d52:	0f 8e dc fe ff ff    	jle    4c34 <iref+0x38>
  }

  chdir("/");
    4d58:	48 bf 90 6d 00 00 00 	movabs $0x6d90,%rdi
    4d5f:	00 00 00 
    4d62:	48 b8 c3 63 00 00 00 	movabs $0x63c3,%rax
    4d69:	00 00 00 
    4d6c:	ff d0                	callq  *%rax
  printf(1, "empty file name OK\n");
    4d6e:	48 be c3 7e 00 00 00 	movabs $0x7ec3,%rsi
    4d75:	00 00 00 
    4d78:	bf 01 00 00 00       	mov    $0x1,%edi
    4d7d:	b8 00 00 00 00       	mov    $0x0,%eax
    4d82:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    4d89:	00 00 00 
    4d8c:	ff d2                	callq  *%rdx
}
    4d8e:	90                   	nop
    4d8f:	c9                   	leaveq 
    4d90:	c3                   	retq   

0000000000004d91 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    4d91:	f3 0f 1e fa          	endbr64 
    4d95:	55                   	push   %rbp
    4d96:	48 89 e5             	mov    %rsp,%rbp
    4d99:	48 83 ec 10          	sub    $0x10,%rsp
  int n, pid;

  printf(1, "fork test\n");
    4d9d:	48 be d7 7e 00 00 00 	movabs $0x7ed7,%rsi
    4da4:	00 00 00 
    4da7:	bf 01 00 00 00       	mov    $0x1,%edi
    4dac:	b8 00 00 00 00       	mov    $0x0,%eax
    4db1:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    4db8:	00 00 00 
    4dbb:	ff d2                	callq  *%rdx

  for(n=0; n<1000; n++){
    4dbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    4dc4:	eb 2b                	jmp    4df1 <forktest+0x60>
    pid = fork();
    4dc6:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    4dcd:	00 00 00 
    4dd0:	ff d0                	callq  *%rax
    4dd2:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(pid < 0)
    4dd5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    4dd9:	78 21                	js     4dfc <forktest+0x6b>
      break;
    if(pid == 0)
    4ddb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    4ddf:	75 0c                	jne    4ded <forktest+0x5c>
      exit();
    4de1:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    4de8:	00 00 00 
    4deb:	ff d0                	callq  *%rax
  for(n=0; n<1000; n++){
    4ded:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    4df1:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
    4df8:	7e cc                	jle    4dc6 <forktest+0x35>
    4dfa:	eb 01                	jmp    4dfd <forktest+0x6c>
      break;
    4dfc:	90                   	nop
  }

  if(n == 1000){
    4dfd:	81 7d fc e8 03 00 00 	cmpl   $0x3e8,-0x4(%rbp)
    4e04:	75 42                	jne    4e48 <forktest+0xb7>
    failexit("fork claimed to work 1000 times");
    4e06:	48 bf e8 7e 00 00 00 	movabs $0x7ee8,%rdi
    4e0d:	00 00 00 
    4e10:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4e17:	00 00 00 
    4e1a:	ff d0                	callq  *%rax
  }

  for(; n > 0; n--){
    4e1c:	eb 2a                	jmp    4e48 <forktest+0xb7>
    if(wait() < 0){
    4e1e:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    4e25:	00 00 00 
    4e28:	ff d0                	callq  *%rax
    4e2a:	85 c0                	test   %eax,%eax
    4e2c:	79 16                	jns    4e44 <forktest+0xb3>
      failexit("wait stopped early");
    4e2e:	48 bf 08 7f 00 00 00 	movabs $0x7f08,%rdi
    4e35:	00 00 00 
    4e38:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4e3f:	00 00 00 
    4e42:	ff d0                	callq  *%rax
  for(; n > 0; n--){
    4e44:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
    4e48:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    4e4c:	7f d0                	jg     4e1e <forktest+0x8d>
    }
  }

  if(wait() != -1){
    4e4e:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    4e55:	00 00 00 
    4e58:	ff d0                	callq  *%rax
    4e5a:	83 f8 ff             	cmp    $0xffffffff,%eax
    4e5d:	74 16                	je     4e75 <forktest+0xe4>
    failexit("wait got too many");
    4e5f:	48 bf 1b 7f 00 00 00 	movabs $0x7f1b,%rdi
    4e66:	00 00 00 
    4e69:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4e70:	00 00 00 
    4e73:	ff d0                	callq  *%rax
  }

  printf(1, "fork test OK\n");
    4e75:	48 be 2d 7f 00 00 00 	movabs $0x7f2d,%rsi
    4e7c:	00 00 00 
    4e7f:	bf 01 00 00 00       	mov    $0x1,%edi
    4e84:	b8 00 00 00 00       	mov    $0x0,%eax
    4e89:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    4e90:	00 00 00 
    4e93:	ff d2                	callq  *%rdx
}
    4e95:	90                   	nop
    4e96:	c9                   	leaveq 
    4e97:	c3                   	retq   

0000000000004e98 <sbrktest>:

void
sbrktest(void)
{
    4e98:	f3 0f 1e fa          	endbr64 
    4e9c:	55                   	push   %rbp
    4e9d:	48 89 e5             	mov    %rsp,%rbp
    4ea0:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(1, "sbrk test\n");
    4ea7:	48 be 3b 7f 00 00 00 	movabs $0x7f3b,%rsi
    4eae:	00 00 00 
    4eb1:	bf 01 00 00 00       	mov    $0x1,%edi
    4eb6:	b8 00 00 00 00       	mov    $0x0,%eax
    4ebb:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    4ec2:	00 00 00 
    4ec5:	ff d2                	callq  *%rdx
  oldbrk = sbrk(0);
    4ec7:	bf 00 00 00 00       	mov    $0x0,%edi
    4ecc:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    4ed3:	00 00 00 
    4ed6:	ff d0                	callq  *%rax
    4ed8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    4edc:	bf 00 00 00 00       	mov    $0x0,%edi
    4ee1:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    4ee8:	00 00 00 
    4eeb:	ff d0                	callq  *%rax
    4eed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  int i;
  for(i = 0; i < 5000; i++){
    4ef1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    4ef8:	eb 76                	jmp    4f70 <sbrktest+0xd8>
    b = sbrk(1);
    4efa:	bf 01 00 00 00       	mov    $0x1,%edi
    4eff:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    4f06:	00 00 00 
    4f09:	ff d0                	callq  *%rax
    4f0b:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
    if(b != a){
    4f0f:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
    4f13:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    4f17:	74 40                	je     4f59 <sbrktest+0xc1>
      printf(1, "sbrk test failed %d %p %p\n", i, a, b);
    4f19:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
    4f1d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
    4f21:	8b 45 f4             	mov    -0xc(%rbp),%eax
    4f24:	49 89 c8             	mov    %rcx,%r8
    4f27:	48 89 d1             	mov    %rdx,%rcx
    4f2a:	89 c2                	mov    %eax,%edx
    4f2c:	48 be 46 7f 00 00 00 	movabs $0x7f46,%rsi
    4f33:	00 00 00 
    4f36:	bf 01 00 00 00       	mov    $0x1,%edi
    4f3b:	b8 00 00 00 00       	mov    $0x0,%eax
    4f40:	49 b9 11 66 00 00 00 	movabs $0x6611,%r9
    4f47:	00 00 00 
    4f4a:	41 ff d1             	callq  *%r9
      exit();
    4f4d:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    4f54:	00 00 00 
    4f57:	ff d0                	callq  *%rax
    }
    *b = 1;
    4f59:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
    4f5d:	c6 00 01             	movb   $0x1,(%rax)
    a = b + 1;
    4f60:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
    4f64:	48 83 c0 01          	add    $0x1,%rax
    4f68:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(i = 0; i < 5000; i++){
    4f6c:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
    4f70:	81 7d f4 87 13 00 00 	cmpl   $0x1387,-0xc(%rbp)
    4f77:	7e 81                	jle    4efa <sbrktest+0x62>
  }
  pid = fork();
    4f79:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    4f80:	00 00 00 
    4f83:	ff d0                	callq  *%rax
    4f85:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  if(pid < 0){
    4f88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
    4f8c:	79 16                	jns    4fa4 <sbrktest+0x10c>
    failexit("sbrk test fork");
    4f8e:	48 bf 61 7f 00 00 00 	movabs $0x7f61,%rdi
    4f95:	00 00 00 
    4f98:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4f9f:	00 00 00 
    4fa2:	ff d0                	callq  *%rax
  }
  c = sbrk(1);
    4fa4:	bf 01 00 00 00       	mov    $0x1,%edi
    4fa9:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    4fb0:	00 00 00 
    4fb3:	ff d0                	callq  *%rax
    4fb5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  c = sbrk(1);
    4fb9:	bf 01 00 00 00       	mov    $0x1,%edi
    4fbe:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    4fc5:	00 00 00 
    4fc8:	ff d0                	callq  *%rax
    4fca:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if(c != a + 1){
    4fce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    4fd2:	48 83 c0 01          	add    $0x1,%rax
    4fd6:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
    4fda:	74 16                	je     4ff2 <sbrktest+0x15a>
    failexit("sbrk test failed post-fork");
    4fdc:	48 bf 70 7f 00 00 00 	movabs $0x7f70,%rdi
    4fe3:	00 00 00 
    4fe6:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4fed:	00 00 00 
    4ff0:	ff d0                	callq  *%rax
  }
  if(pid == 0)
    4ff2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
    4ff6:	75 0c                	jne    5004 <sbrktest+0x16c>
    exit();
    4ff8:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    4fff:	00 00 00 
    5002:	ff d0                	callq  *%rax
  wait();
    5004:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    500b:	00 00 00 
    500e:	ff d0                	callq  *%rax

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    5010:	bf 00 00 00 00       	mov    $0x0,%edi
    5015:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    501c:	00 00 00 
    501f:	ff d0                	callq  *%rax
    5021:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  amt = (BIG) - (addr_t)a;
    5025:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    5029:	ba 00 00 40 06       	mov    $0x6400000,%edx
    502e:	29 c2                	sub    %eax,%edx
    5030:	89 d0                	mov    %edx,%eax
    5032:	89 45 d4             	mov    %eax,-0x2c(%rbp)
  p = sbrk(amt);
    5035:	8b 45 d4             	mov    -0x2c(%rbp),%eax
    5038:	48 89 c7             	mov    %rax,%rdi
    503b:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    5042:	00 00 00 
    5045:	ff d0                	callq  *%rax
    5047:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  if (p != a) {
    504b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    504f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    5053:	74 16                	je     506b <sbrktest+0x1d3>
    failexit("sbrk test failed to grow big address space; enough phys mem?");
    5055:	48 bf 90 7f 00 00 00 	movabs $0x7f90,%rdi
    505c:	00 00 00 
    505f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    5066:	00 00 00 
    5069:	ff d0                	callq  *%rax
  }
  lastaddr = (char*) (BIG-1);
    506b:	48 c7 45 c0 ff ff 3f 	movq   $0x63fffff,-0x40(%rbp)
    5072:	06 
  *lastaddr = 99;
    5073:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
    5077:	c6 00 63             	movb   $0x63,(%rax)

  // can one de-allocate?
  a = sbrk(0);
    507a:	bf 00 00 00 00       	mov    $0x0,%edi
    507f:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    5086:	00 00 00 
    5089:	ff d0                	callq  *%rax
    508b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  c = sbrk(-4096);
    508f:	48 c7 c7 00 f0 ff ff 	mov    $0xfffffffffffff000,%rdi
    5096:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    509d:	00 00 00 
    50a0:	ff d0                	callq  *%rax
    50a2:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if(c == (char*)0xffffffff){
    50a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    50ab:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
    50af:	75 16                	jne    50c7 <sbrktest+0x22f>
    failexit("sbrk could not deallocate");
    50b1:	48 bf cd 7f 00 00 00 	movabs $0x7fcd,%rdi
    50b8:	00 00 00 
    50bb:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    50c2:	00 00 00 
    50c5:	ff d0                	callq  *%rax
  }
  c = sbrk(0);
    50c7:	bf 00 00 00 00       	mov    $0x0,%edi
    50cc:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    50d3:	00 00 00 
    50d6:	ff d0                	callq  *%rax
    50d8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if(c != a - 4096){
    50dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    50e0:	48 2d 00 10 00 00    	sub    $0x1000,%rax
    50e6:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
    50ea:	74 3b                	je     5127 <sbrktest+0x28f>
    printf(1, "sbrk deallocation produced wrong address, a %p c %p\n", a, c);
    50ec:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
    50f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    50f4:	48 89 d1             	mov    %rdx,%rcx
    50f7:	48 89 c2             	mov    %rax,%rdx
    50fa:	48 be e8 7f 00 00 00 	movabs $0x7fe8,%rsi
    5101:	00 00 00 
    5104:	bf 01 00 00 00       	mov    $0x1,%edi
    5109:	b8 00 00 00 00       	mov    $0x0,%eax
    510e:	49 b8 11 66 00 00 00 	movabs $0x6611,%r8
    5115:	00 00 00 
    5118:	41 ff d0             	callq  *%r8
    exit();
    511b:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    5122:	00 00 00 
    5125:	ff d0                	callq  *%rax
  }

  // can one re-allocate that page?
  a = sbrk(0);
    5127:	bf 00 00 00 00       	mov    $0x0,%edi
    512c:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    5133:	00 00 00 
    5136:	ff d0                	callq  *%rax
    5138:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  c = sbrk(4096);
    513c:	bf 00 10 00 00       	mov    $0x1000,%edi
    5141:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    5148:	00 00 00 
    514b:	ff d0                	callq  *%rax
    514d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if(c != a || sbrk(0) != a + 4096){
    5151:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    5155:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    5159:	75 21                	jne    517c <sbrktest+0x2e4>
    515b:	bf 00 00 00 00       	mov    $0x0,%edi
    5160:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    5167:	00 00 00 
    516a:	ff d0                	callq  *%rax
    516c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
    5170:	48 81 c2 00 10 00 00 	add    $0x1000,%rdx
    5177:	48 39 d0             	cmp    %rdx,%rax
    517a:	74 3b                	je     51b7 <sbrktest+0x31f>
    printf(1, "sbrk re-allocation failed, a %p c %p\n", a, c);
    517c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
    5180:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    5184:	48 89 d1             	mov    %rdx,%rcx
    5187:	48 89 c2             	mov    %rax,%rdx
    518a:	48 be 20 80 00 00 00 	movabs $0x8020,%rsi
    5191:	00 00 00 
    5194:	bf 01 00 00 00       	mov    $0x1,%edi
    5199:	b8 00 00 00 00       	mov    $0x0,%eax
    519e:	49 b8 11 66 00 00 00 	movabs $0x6611,%r8
    51a5:	00 00 00 
    51a8:	41 ff d0             	callq  *%r8
    exit();
    51ab:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    51b2:	00 00 00 
    51b5:	ff d0                	callq  *%rax
  }
  if(*lastaddr == 99){
    51b7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
    51bb:	0f b6 00             	movzbl (%rax),%eax
    51be:	3c 63                	cmp    $0x63,%al
    51c0:	75 16                	jne    51d8 <sbrktest+0x340>
    // should be zero
    failexit("sbrk de-allocation didn't really deallocate");
    51c2:	48 bf 48 80 00 00 00 	movabs $0x8048,%rdi
    51c9:	00 00 00 
    51cc:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    51d3:	00 00 00 
    51d6:	ff d0                	callq  *%rax
  }

  a = sbrk(0);
    51d8:	bf 00 00 00 00       	mov    $0x0,%edi
    51dd:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    51e4:	00 00 00 
    51e7:	ff d0                	callq  *%rax
    51e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  c = sbrk(-(sbrk(0) - oldbrk));
    51ed:	bf 00 00 00 00       	mov    $0x0,%edi
    51f2:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    51f9:	00 00 00 
    51fc:	ff d0                	callq  *%rax
    51fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    5202:	48 29 c2             	sub    %rax,%rdx
    5205:	48 89 d0             	mov    %rdx,%rax
    5208:	48 89 c7             	mov    %rax,%rdi
    520b:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    5212:	00 00 00 
    5215:	ff d0                	callq  *%rax
    5217:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if(c != a){
    521b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    521f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    5223:	74 3b                	je     5260 <sbrktest+0x3c8>
    printf(1, "sbrk downsize failed, a %p c %p\n", a, c);
    5225:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
    5229:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    522d:	48 89 d1             	mov    %rdx,%rcx
    5230:	48 89 c2             	mov    %rax,%rdx
    5233:	48 be 78 80 00 00 00 	movabs $0x8078,%rsi
    523a:	00 00 00 
    523d:	bf 01 00 00 00       	mov    $0x1,%edi
    5242:	b8 00 00 00 00       	mov    $0x0,%eax
    5247:	49 b8 11 66 00 00 00 	movabs $0x6611,%r8
    524e:	00 00 00 
    5251:	41 ff d0             	callq  *%r8
    exit();
    5254:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    525b:	00 00 00 
    525e:	ff d0                	callq  *%rax
  }

  printf(1, "expecting 10 killed processes:\n");
    5260:	48 be a0 80 00 00 00 	movabs $0x80a0,%rsi
    5267:	00 00 00 
    526a:	bf 01 00 00 00       	mov    $0x1,%edi
    526f:	b8 00 00 00 00       	mov    $0x0,%eax
    5274:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    527b:	00 00 00 
    527e:	ff d2                	callq  *%rdx
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+1000000); a += 100000){
    5280:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
    5287:	80 ff ff 
    528a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    528e:	e9 a5 00 00 00       	jmpq   5338 <sbrktest+0x4a0>
    ppid = getpid();
    5293:	48 b8 dd 63 00 00 00 	movabs $0x63dd,%rax
    529a:	00 00 00 
    529d:	ff d0                	callq  *%rax
    529f:	89 45 b8             	mov    %eax,-0x48(%rbp)
    pid = fork();
    52a2:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    52a9:	00 00 00 
    52ac:	ff d0                	callq  *%rax
    52ae:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    if(pid < 0){
    52b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
    52b5:	79 16                	jns    52cd <sbrktest+0x435>
      failexit("fork");
    52b7:	48 bf b7 6d 00 00 00 	movabs $0x6db7,%rdi
    52be:	00 00 00 
    52c1:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    52c8:	00 00 00 
    52cb:	ff d0                	callq  *%rax
    }
    if(pid == 0){
    52cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
    52d1:	75 51                	jne    5324 <sbrktest+0x48c>
      printf(1, "oops could read %p = %c\n", a, *a);
    52d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    52d7:	0f b6 00             	movzbl (%rax),%eax
    52da:	0f be d0             	movsbl %al,%edx
    52dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    52e1:	89 d1                	mov    %edx,%ecx
    52e3:	48 89 c2             	mov    %rax,%rdx
    52e6:	48 be c0 80 00 00 00 	movabs $0x80c0,%rsi
    52ed:	00 00 00 
    52f0:	bf 01 00 00 00       	mov    $0x1,%edi
    52f5:	b8 00 00 00 00       	mov    $0x0,%eax
    52fa:	49 b8 11 66 00 00 00 	movabs $0x6611,%r8
    5301:	00 00 00 
    5304:	41 ff d0             	callq  *%r8
      kill(ppid);
    5307:	8b 45 b8             	mov    -0x48(%rbp),%eax
    530a:	89 c7                	mov    %eax,%edi
    530c:	48 b8 5b 63 00 00 00 	movabs $0x635b,%rax
    5313:	00 00 00 
    5316:	ff d0                	callq  *%rax
      exit();
    5318:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    531f:	00 00 00 
    5322:	ff d0                	callq  *%rax
    }
    wait();
    5324:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    532b:	00 00 00 
    532e:	ff d0                	callq  *%rax
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+1000000); a += 100000){
    5330:	48 81 45 f8 a0 86 01 	addq   $0x186a0,-0x8(%rbp)
    5337:	00 
    5338:	48 b8 3f 42 0f 00 00 	movabs $0xffff8000000f423f,%rax
    533f:	80 ff ff 
    5342:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    5346:	0f 86 47 ff ff ff    	jbe    5293 <sbrktest+0x3fb>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    534c:	48 8d 45 a8          	lea    -0x58(%rbp),%rax
    5350:	48 89 c7             	mov    %rax,%rdi
    5353:	48 b8 27 63 00 00 00 	movabs $0x6327,%rax
    535a:	00 00 00 
    535d:	ff d0                	callq  *%rax
    535f:	85 c0                	test   %eax,%eax
    5361:	74 16                	je     5379 <sbrktest+0x4e1>
    failexit("pipe()");
    5363:	48 bf 53 71 00 00 00 	movabs $0x7153,%rdi
    536a:	00 00 00 
    536d:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    5374:	00 00 00 
    5377:	ff d0                	callq  *%rax
  }
  printf(1, "expecting failed sbrk()s:\n");
    5379:	48 be d9 80 00 00 00 	movabs $0x80d9,%rsi
    5380:	00 00 00 
    5383:	bf 01 00 00 00       	mov    $0x1,%edi
    5388:	b8 00 00 00 00       	mov    $0x0,%eax
    538d:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    5394:	00 00 00 
    5397:	ff d2                	callq  *%rdx
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    5399:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    53a0:	e9 e0 00 00 00       	jmpq   5485 <sbrktest+0x5ed>
    if((pids[i] = fork()) == 0){
    53a5:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    53ac:	00 00 00 
    53af:	ff d0                	callq  *%rax
    53b1:	8b 55 f4             	mov    -0xc(%rbp),%edx
    53b4:	48 63 d2             	movslq %edx,%rdx
    53b7:	89 44 95 80          	mov    %eax,-0x80(%rbp,%rdx,4)
    53bb:	8b 45 f4             	mov    -0xc(%rbp),%eax
    53be:	48 98                	cltq   
    53c0:	8b 44 85 80          	mov    -0x80(%rbp,%rax,4),%eax
    53c4:	85 c0                	test   %eax,%eax
    53c6:	0f 85 87 00 00 00    	jne    5453 <sbrktest+0x5bb>
      // allocate a lot of memory
      int ret = (int)(addr_t)sbrk(BIG - (addr_t)sbrk(0));
    53cc:	bf 00 00 00 00       	mov    $0x0,%edi
    53d1:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    53d8:	00 00 00 
    53db:	ff d0                	callq  *%rax
    53dd:	ba 00 00 40 06       	mov    $0x6400000,%edx
    53e2:	48 29 c2             	sub    %rax,%rdx
    53e5:	48 89 d0             	mov    %rdx,%rax
    53e8:	48 89 c7             	mov    %rax,%rdi
    53eb:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    53f2:	00 00 00 
    53f5:	ff d0                	callq  *%rax
    53f7:	89 45 bc             	mov    %eax,-0x44(%rbp)
      if(ret < 0)
    53fa:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
    53fe:	79 20                	jns    5420 <sbrktest+0x588>
        printf(1, "sbrk returned -1 as expected\n");
    5400:	48 be f4 80 00 00 00 	movabs $0x80f4,%rsi
    5407:	00 00 00 
    540a:	bf 01 00 00 00       	mov    $0x1,%edi
    540f:	b8 00 00 00 00       	mov    $0x0,%eax
    5414:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    541b:	00 00 00 
    541e:	ff d2                	callq  *%rdx
      write(fds[1], "x", 1);
    5420:	8b 45 ac             	mov    -0x54(%rbp),%eax
    5423:	ba 01 00 00 00       	mov    $0x1,%edx
    5428:	48 be a6 71 00 00 00 	movabs $0x71a6,%rsi
    542f:	00 00 00 
    5432:	89 c7                	mov    %eax,%edi
    5434:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    543b:	00 00 00 
    543e:	ff d0                	callq  *%rax
      // sit around until killed
      for(;;)
        sleep(1000);
    5440:	bf e8 03 00 00       	mov    $0x3e8,%edi
    5445:	48 b8 f7 63 00 00 00 	movabs $0x63f7,%rax
    544c:	00 00 00 
    544f:	ff d0                	callq  *%rax
    5451:	eb ed                	jmp    5440 <sbrktest+0x5a8>
    }
    if(pids[i] != -1)
    5453:	8b 45 f4             	mov    -0xc(%rbp),%eax
    5456:	48 98                	cltq   
    5458:	8b 44 85 80          	mov    -0x80(%rbp,%rax,4),%eax
    545c:	83 f8 ff             	cmp    $0xffffffff,%eax
    545f:	74 20                	je     5481 <sbrktest+0x5e9>
      read(fds[0], &scratch, 1); // wait
    5461:	8b 45 a8             	mov    -0x58(%rbp),%eax
    5464:	48 8d 8d 7f ff ff ff 	lea    -0x81(%rbp),%rcx
    546b:	ba 01 00 00 00       	mov    $0x1,%edx
    5470:	48 89 ce             	mov    %rcx,%rsi
    5473:	89 c7                	mov    %eax,%edi
    5475:	48 b8 34 63 00 00 00 	movabs $0x6334,%rax
    547c:	00 00 00 
    547f:	ff d0                	callq  *%rax
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    5481:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
    5485:	8b 45 f4             	mov    -0xc(%rbp),%eax
    5488:	83 f8 09             	cmp    $0x9,%eax
    548b:	0f 86 14 ff ff ff    	jbe    53a5 <sbrktest+0x50d>
  }

  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate one here
  c = sbrk(4096);
    5491:	bf 00 10 00 00       	mov    $0x1000,%edi
    5496:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    549d:	00 00 00 
    54a0:	ff d0                	callq  *%rax
    54a2:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    54a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    54ad:	eb 38                	jmp    54e7 <sbrktest+0x64f>
    if(pids[i] == -1)
    54af:	8b 45 f4             	mov    -0xc(%rbp),%eax
    54b2:	48 98                	cltq   
    54b4:	8b 44 85 80          	mov    -0x80(%rbp,%rax,4),%eax
    54b8:	83 f8 ff             	cmp    $0xffffffff,%eax
    54bb:	74 25                	je     54e2 <sbrktest+0x64a>
      continue;
    kill(pids[i]);
    54bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
    54c0:	48 98                	cltq   
    54c2:	8b 44 85 80          	mov    -0x80(%rbp,%rax,4),%eax
    54c6:	89 c7                	mov    %eax,%edi
    54c8:	48 b8 5b 63 00 00 00 	movabs $0x635b,%rax
    54cf:	00 00 00 
    54d2:	ff d0                	callq  *%rax
    wait();
    54d4:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    54db:	00 00 00 
    54de:	ff d0                	callq  *%rax
    54e0:	eb 01                	jmp    54e3 <sbrktest+0x64b>
      continue;
    54e2:	90                   	nop
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    54e3:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
    54e7:	8b 45 f4             	mov    -0xc(%rbp),%eax
    54ea:	83 f8 09             	cmp    $0x9,%eax
    54ed:	76 c0                	jbe    54af <sbrktest+0x617>
  }
  if(c == (char*)0xffffffff){ // ?
    54ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    54f4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
    54f8:	75 16                	jne    5510 <sbrktest+0x678>
    failexit("failed sbrk leaked memory");
    54fa:	48 bf 12 81 00 00 00 	movabs $0x8112,%rdi
    5501:	00 00 00 
    5504:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    550b:	00 00 00 
    550e:	ff d0                	callq  *%rax
  }

  if(sbrk(0) > oldbrk)
    5510:	bf 00 00 00 00       	mov    $0x0,%edi
    5515:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    551c:	00 00 00 
    551f:	ff d0                	callq  *%rax
    5521:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
    5525:	73 2a                	jae    5551 <sbrktest+0x6b9>
    sbrk(-(sbrk(0) - oldbrk));
    5527:	bf 00 00 00 00       	mov    $0x0,%edi
    552c:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    5533:	00 00 00 
    5536:	ff d0                	callq  *%rax
    5538:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    553c:	48 29 c2             	sub    %rax,%rdx
    553f:	48 89 d0             	mov    %rdx,%rax
    5542:	48 89 c7             	mov    %rax,%rdi
    5545:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    554c:	00 00 00 
    554f:	ff d0                	callq  *%rax

  printf(1, "sbrk test OK\n");
    5551:	48 be 2c 81 00 00 00 	movabs $0x812c,%rsi
    5558:	00 00 00 
    555b:	bf 01 00 00 00       	mov    $0x1,%edi
    5560:	b8 00 00 00 00       	mov    $0x0,%eax
    5565:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    556c:	00 00 00 
    556f:	ff d2                	callq  *%rdx
}
    5571:	90                   	nop
    5572:	c9                   	leaveq 
    5573:	c3                   	retq   

0000000000005574 <validatetest>:

void
validatetest(void)
{
    5574:	f3 0f 1e fa          	endbr64 
    5578:	55                   	push   %rbp
    5579:	48 89 e5             	mov    %rsp,%rbp
    557c:	48 83 ec 10          	sub    $0x10,%rsp
  int hi;
  addr_t p;

  printf(1, "validate test\n");
    5580:	48 be 3a 81 00 00 00 	movabs $0x813a,%rsi
    5587:	00 00 00 
    558a:	bf 01 00 00 00       	mov    $0x1,%edi
    558f:	b8 00 00 00 00       	mov    $0x0,%eax
    5594:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    559b:	00 00 00 
    559e:	ff d2                	callq  *%rdx
  hi = 1100*1024;
    55a0:	c7 45 f4 00 30 11 00 	movl   $0x113000,-0xc(%rbp)

  // first page not mapped
  for(p = 4096; p <= (uint)hi; p += 4096){
    55a7:	48 c7 45 f8 00 10 00 	movq   $0x1000,-0x8(%rbp)
    55ae:	00 
    55af:	eb 40                	jmp    55f1 <validatetest+0x7d>
    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    55b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    55b5:	48 89 c6             	mov    %rax,%rsi
    55b8:	48 bf 49 81 00 00 00 	movabs $0x8149,%rdi
    55bf:	00 00 00 
    55c2:	48 b8 a9 63 00 00 00 	movabs $0x63a9,%rax
    55c9:	00 00 00 
    55cc:	ff d0                	callq  *%rax
    55ce:	83 f8 ff             	cmp    $0xffffffff,%eax
    55d1:	74 16                	je     55e9 <validatetest+0x75>
      failexit("link should not succeed.");
    55d3:	48 bf 54 81 00 00 00 	movabs $0x8154,%rdi
    55da:	00 00 00 
    55dd:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    55e4:	00 00 00 
    55e7:	ff d0                	callq  *%rax
  for(p = 4096; p <= (uint)hi; p += 4096){
    55e9:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
    55f0:	00 
    55f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
    55f4:	89 c0                	mov    %eax,%eax
    55f6:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    55fa:	76 b5                	jbe    55b1 <validatetest+0x3d>
    }
  }

  printf(1, "validate ok\n");
    55fc:	48 be 6d 81 00 00 00 	movabs $0x816d,%rsi
    5603:	00 00 00 
    5606:	bf 01 00 00 00       	mov    $0x1,%edi
    560b:	b8 00 00 00 00       	mov    $0x0,%eax
    5610:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    5617:	00 00 00 
    561a:	ff d2                	callq  *%rdx
}
    561c:	90                   	nop
    561d:	c9                   	leaveq 
    561e:	c3                   	retq   

000000000000561f <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    561f:	f3 0f 1e fa          	endbr64 
    5623:	55                   	push   %rbp
    5624:	48 89 e5             	mov    %rsp,%rbp
    5627:	48 83 ec 10          	sub    $0x10,%rsp
  int i;

  printf(1, "bss test\n");
    562b:	48 be 7a 81 00 00 00 	movabs $0x817a,%rsi
    5632:	00 00 00 
    5635:	bf 01 00 00 00       	mov    $0x1,%edi
    563a:	b8 00 00 00 00       	mov    $0x0,%eax
    563f:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    5646:	00 00 00 
    5649:	ff d2                	callq  *%rdx
  for(i = 0; i < sizeof(uninit); i++){
    564b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    5652:	eb 31                	jmp    5685 <bsstest+0x66>
    if(uninit[i] != '\0'){
    5654:	48 ba 40 ac 00 00 00 	movabs $0xac40,%rdx
    565b:	00 00 00 
    565e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    5661:	48 98                	cltq   
    5663:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    5667:	84 c0                	test   %al,%al
    5669:	74 16                	je     5681 <bsstest+0x62>
      failexit("bss test");
    566b:	48 bf 84 81 00 00 00 	movabs $0x8184,%rdi
    5672:	00 00 00 
    5675:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    567c:	00 00 00 
    567f:	ff d0                	callq  *%rax
  for(i = 0; i < sizeof(uninit); i++){
    5681:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    5685:	8b 45 fc             	mov    -0x4(%rbp),%eax
    5688:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    568d:	76 c5                	jbe    5654 <bsstest+0x35>
    }
  }
  printf(1, "bss test ok\n");
    568f:	48 be 8d 81 00 00 00 	movabs $0x818d,%rsi
    5696:	00 00 00 
    5699:	bf 01 00 00 00       	mov    $0x1,%edi
    569e:	b8 00 00 00 00       	mov    $0x0,%eax
    56a3:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    56aa:	00 00 00 
    56ad:	ff d2                	callq  *%rdx
}
    56af:	90                   	nop
    56b0:	c9                   	leaveq 
    56b1:	c3                   	retq   

00000000000056b2 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    56b2:	f3 0f 1e fa          	endbr64 
    56b6:	55                   	push   %rbp
    56b7:	48 89 e5             	mov    %rsp,%rbp
    56ba:	48 83 ec 10          	sub    $0x10,%rsp
  int pid, fd;

  unlink("bigarg-ok");
    56be:	48 bf 9a 81 00 00 00 	movabs $0x819a,%rdi
    56c5:	00 00 00 
    56c8:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    56cf:	00 00 00 
    56d2:	ff d0                	callq  *%rax
  pid = fork();
    56d4:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    56db:	00 00 00 
    56de:	ff d0                	callq  *%rax
    56e0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(pid == 0){
    56e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    56e7:	0f 85 e0 00 00 00    	jne    57cd <bigargtest+0x11b>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    56ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    56f4:	eb 21                	jmp    5717 <bigargtest+0x65>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    56f6:	48 ba 60 d3 00 00 00 	movabs $0xd360,%rdx
    56fd:	00 00 00 
    5700:	8b 45 fc             	mov    -0x4(%rbp),%eax
    5703:	48 98                	cltq   
    5705:	48 b9 a8 81 00 00 00 	movabs $0x81a8,%rcx
    570c:	00 00 00 
    570f:	48 89 0c c2          	mov    %rcx,(%rdx,%rax,8)
    for(i = 0; i < MAXARG-1; i++)
    5713:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    5717:	83 7d fc 1e          	cmpl   $0x1e,-0x4(%rbp)
    571b:	7e d9                	jle    56f6 <bigargtest+0x44>
    args[MAXARG-1] = 0;
    571d:	48 b8 60 d3 00 00 00 	movabs $0xd360,%rax
    5724:	00 00 00 
    5727:	48 c7 80 f8 00 00 00 	movq   $0x0,0xf8(%rax)
    572e:	00 00 00 00 
    printf(1, "bigarg test\n");
    5732:	48 be 85 82 00 00 00 	movabs $0x8285,%rsi
    5739:	00 00 00 
    573c:	bf 01 00 00 00       	mov    $0x1,%edi
    5741:	b8 00 00 00 00       	mov    $0x0,%eax
    5746:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    574d:	00 00 00 
    5750:	ff d2                	callq  *%rdx
    exec("echo", args);
    5752:	48 be 60 d3 00 00 00 	movabs $0xd360,%rsi
    5759:	00 00 00 
    575c:	48 bf 28 6d 00 00 00 	movabs $0x6d28,%rdi
    5763:	00 00 00 
    5766:	48 b8 68 63 00 00 00 	movabs $0x6368,%rax
    576d:	00 00 00 
    5770:	ff d0                	callq  *%rax
    printf(1, "bigarg test ok\n");
    5772:	48 be 92 82 00 00 00 	movabs $0x8292,%rsi
    5779:	00 00 00 
    577c:	bf 01 00 00 00       	mov    $0x1,%edi
    5781:	b8 00 00 00 00       	mov    $0x0,%eax
    5786:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    578d:	00 00 00 
    5790:	ff d2                	callq  *%rdx
    fd = open("bigarg-ok", O_CREATE);
    5792:	be 00 02 00 00       	mov    $0x200,%esi
    5797:	48 bf 9a 81 00 00 00 	movabs $0x819a,%rdi
    579e:	00 00 00 
    57a1:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    57a8:	00 00 00 
    57ab:	ff d0                	callq  *%rax
    57ad:	89 45 f4             	mov    %eax,-0xc(%rbp)
    close(fd);
    57b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
    57b3:	89 c7                	mov    %eax,%edi
    57b5:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    57bc:	00 00 00 
    57bf:	ff d0                	callq  *%rax
    exit();
    57c1:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    57c8:	00 00 00 
    57cb:	ff d0                	callq  *%rax
  } else if(pid < 0){
    57cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    57d1:	79 16                	jns    57e9 <bigargtest+0x137>
    failexit("bigargtest: fork");
    57d3:	48 bf a2 82 00 00 00 	movabs $0x82a2,%rdi
    57da:	00 00 00 
    57dd:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    57e4:	00 00 00 
    57e7:	ff d0                	callq  *%rax
  }
  wait();
    57e9:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    57f0:	00 00 00 
    57f3:	ff d0                	callq  *%rax
  fd = open("bigarg-ok", 0);
    57f5:	be 00 00 00 00       	mov    $0x0,%esi
    57fa:	48 bf 9a 81 00 00 00 	movabs $0x819a,%rdi
    5801:	00 00 00 
    5804:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    580b:	00 00 00 
    580e:	ff d0                	callq  *%rax
    5810:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(fd < 0){
    5813:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    5817:	79 16                	jns    582f <bigargtest+0x17d>
    failexit("bigarg test");
    5819:	48 bf b3 82 00 00 00 	movabs $0x82b3,%rdi
    5820:	00 00 00 
    5823:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    582a:	00 00 00 
    582d:	ff d0                	callq  *%rax
  }
  close(fd);
    582f:	8b 45 f4             	mov    -0xc(%rbp),%eax
    5832:	89 c7                	mov    %eax,%edi
    5834:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    583b:	00 00 00 
    583e:	ff d0                	callq  *%rax
  unlink("bigarg-ok");
    5840:	48 bf 9a 81 00 00 00 	movabs $0x819a,%rdi
    5847:	00 00 00 
    584a:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    5851:	00 00 00 
    5854:	ff d0                	callq  *%rax
}
    5856:	90                   	nop
    5857:	c9                   	leaveq 
    5858:	c3                   	retq   

0000000000005859 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    5859:	f3 0f 1e fa          	endbr64 
    585d:	55                   	push   %rbp
    585e:	48 89 e5             	mov    %rsp,%rbp
    5861:	48 83 ec 60          	sub    $0x60,%rsp
  int nfiles;
  int fsblocks = 0;
    5865:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

  printf(1, "fsfull test\n");
    586c:	48 be bf 82 00 00 00 	movabs $0x82bf,%rsi
    5873:	00 00 00 
    5876:	bf 01 00 00 00       	mov    $0x1,%edi
    587b:	b8 00 00 00 00       	mov    $0x0,%eax
    5880:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    5887:	00 00 00 
    588a:	ff d2                	callq  *%rdx

  for(nfiles = 0; ; nfiles++){
    588c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    char name[64];
    name[0] = 'f';
    5893:	c6 45 a0 66          	movb   $0x66,-0x60(%rbp)
    name[1] = '0' + nfiles / 1000;
    5897:	8b 45 fc             	mov    -0x4(%rbp),%eax
    589a:	48 63 d0             	movslq %eax,%rdx
    589d:	48 69 d2 d3 4d 62 10 	imul   $0x10624dd3,%rdx,%rdx
    58a4:	48 c1 ea 20          	shr    $0x20,%rdx
    58a8:	c1 fa 06             	sar    $0x6,%edx
    58ab:	c1 f8 1f             	sar    $0x1f,%eax
    58ae:	29 c2                	sub    %eax,%edx
    58b0:	89 d0                	mov    %edx,%eax
    58b2:	83 c0 30             	add    $0x30,%eax
    58b5:	88 45 a1             	mov    %al,-0x5f(%rbp)
    name[2] = '0' + (nfiles % 1000) / 100;
    58b8:	8b 55 fc             	mov    -0x4(%rbp),%edx
    58bb:	48 63 c2             	movslq %edx,%rax
    58be:	48 69 c0 d3 4d 62 10 	imul   $0x10624dd3,%rax,%rax
    58c5:	48 c1 e8 20          	shr    $0x20,%rax
    58c9:	89 c1                	mov    %eax,%ecx
    58cb:	c1 f9 06             	sar    $0x6,%ecx
    58ce:	89 d0                	mov    %edx,%eax
    58d0:	c1 f8 1f             	sar    $0x1f,%eax
    58d3:	29 c1                	sub    %eax,%ecx
    58d5:	89 c8                	mov    %ecx,%eax
    58d7:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
    58dd:	29 c2                	sub    %eax,%edx
    58df:	89 d0                	mov    %edx,%eax
    58e1:	48 63 d0             	movslq %eax,%rdx
    58e4:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
    58eb:	48 c1 ea 20          	shr    $0x20,%rdx
    58ef:	c1 fa 05             	sar    $0x5,%edx
    58f2:	c1 f8 1f             	sar    $0x1f,%eax
    58f5:	29 c2                	sub    %eax,%edx
    58f7:	89 d0                	mov    %edx,%eax
    58f9:	83 c0 30             	add    $0x30,%eax
    58fc:	88 45 a2             	mov    %al,-0x5e(%rbp)
    name[3] = '0' + (nfiles % 100) / 10;
    58ff:	8b 55 fc             	mov    -0x4(%rbp),%edx
    5902:	48 63 c2             	movslq %edx,%rax
    5905:	48 69 c0 1f 85 eb 51 	imul   $0x51eb851f,%rax,%rax
    590c:	48 c1 e8 20          	shr    $0x20,%rax
    5910:	89 c1                	mov    %eax,%ecx
    5912:	c1 f9 05             	sar    $0x5,%ecx
    5915:	89 d0                	mov    %edx,%eax
    5917:	c1 f8 1f             	sar    $0x1f,%eax
    591a:	29 c1                	sub    %eax,%ecx
    591c:	89 c8                	mov    %ecx,%eax
    591e:	6b c0 64             	imul   $0x64,%eax,%eax
    5921:	29 c2                	sub    %eax,%edx
    5923:	89 d0                	mov    %edx,%eax
    5925:	48 63 d0             	movslq %eax,%rdx
    5928:	48 69 d2 67 66 66 66 	imul   $0x66666667,%rdx,%rdx
    592f:	48 c1 ea 20          	shr    $0x20,%rdx
    5933:	c1 fa 02             	sar    $0x2,%edx
    5936:	c1 f8 1f             	sar    $0x1f,%eax
    5939:	29 c2                	sub    %eax,%edx
    593b:	89 d0                	mov    %edx,%eax
    593d:	83 c0 30             	add    $0x30,%eax
    5940:	88 45 a3             	mov    %al,-0x5d(%rbp)
    name[4] = '0' + (nfiles % 10);
    5943:	8b 4d fc             	mov    -0x4(%rbp),%ecx
    5946:	48 63 c1             	movslq %ecx,%rax
    5949:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
    5950:	48 c1 e8 20          	shr    $0x20,%rax
    5954:	89 c2                	mov    %eax,%edx
    5956:	c1 fa 02             	sar    $0x2,%edx
    5959:	89 c8                	mov    %ecx,%eax
    595b:	c1 f8 1f             	sar    $0x1f,%eax
    595e:	29 c2                	sub    %eax,%edx
    5960:	89 d0                	mov    %edx,%eax
    5962:	c1 e0 02             	shl    $0x2,%eax
    5965:	01 d0                	add    %edx,%eax
    5967:	01 c0                	add    %eax,%eax
    5969:	29 c1                	sub    %eax,%ecx
    596b:	89 ca                	mov    %ecx,%edx
    596d:	89 d0                	mov    %edx,%eax
    596f:	83 c0 30             	add    $0x30,%eax
    5972:	88 45 a4             	mov    %al,-0x5c(%rbp)
    name[5] = '\0';
    5975:	c6 45 a5 00          	movb   $0x0,-0x5b(%rbp)
    printf(1, "writing %s\n", name);
    5979:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
    597d:	48 89 c2             	mov    %rax,%rdx
    5980:	48 be cc 82 00 00 00 	movabs $0x82cc,%rsi
    5987:	00 00 00 
    598a:	bf 01 00 00 00       	mov    $0x1,%edi
    598f:	b8 00 00 00 00       	mov    $0x0,%eax
    5994:	48 b9 11 66 00 00 00 	movabs $0x6611,%rcx
    599b:	00 00 00 
    599e:	ff d1                	callq  *%rcx
    int fd = open(name, O_CREATE|O_RDWR);
    59a0:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
    59a4:	be 02 02 00 00       	mov    $0x202,%esi
    59a9:	48 89 c7             	mov    %rax,%rdi
    59ac:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    59b3:	00 00 00 
    59b6:	ff d0                	callq  *%rax
    59b8:	89 45 f0             	mov    %eax,-0x10(%rbp)
    if(fd < 0){
    59bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    59bf:	79 2c                	jns    59ed <fsfull+0x194>
      printf(1, "open %s failed\n", name);
    59c1:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
    59c5:	48 89 c2             	mov    %rax,%rdx
    59c8:	48 be d8 82 00 00 00 	movabs $0x82d8,%rsi
    59cf:	00 00 00 
    59d2:	bf 01 00 00 00       	mov    $0x1,%edi
    59d7:	b8 00 00 00 00       	mov    $0x0,%eax
    59dc:	48 b9 11 66 00 00 00 	movabs $0x6611,%rcx
    59e3:	00 00 00 
    59e6:	ff d1                	callq  *%rcx
      break;
    59e8:	e9 86 00 00 00       	jmpq   5a73 <fsfull+0x21a>
    }
    int total = 0;
    59ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    while(1){
      int cc = write(fd, buf, 512);
    59f4:	8b 45 f0             	mov    -0x10(%rbp),%eax
    59f7:	ba 00 02 00 00       	mov    $0x200,%edx
    59fc:	48 be 20 8c 00 00 00 	movabs $0x8c20,%rsi
    5a03:	00 00 00 
    5a06:	89 c7                	mov    %eax,%edi
    5a08:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    5a0f:	00 00 00 
    5a12:	ff d0                	callq  *%rax
    5a14:	89 45 ec             	mov    %eax,-0x14(%rbp)
      if(cc < 512)
    5a17:	81 7d ec ff 01 00 00 	cmpl   $0x1ff,-0x14(%rbp)
    5a1e:	7e 0c                	jle    5a2c <fsfull+0x1d3>
        break;
      total += cc;
    5a20:	8b 45 ec             	mov    -0x14(%rbp),%eax
    5a23:	01 45 f4             	add    %eax,-0xc(%rbp)
      fsblocks++;
    5a26:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    while(1){
    5a2a:	eb c8                	jmp    59f4 <fsfull+0x19b>
        break;
    5a2c:	90                   	nop
    }
    printf(1, "wrote %d bytes\n", total);
    5a2d:	8b 45 f4             	mov    -0xc(%rbp),%eax
    5a30:	89 c2                	mov    %eax,%edx
    5a32:	48 be e8 82 00 00 00 	movabs $0x82e8,%rsi
    5a39:	00 00 00 
    5a3c:	bf 01 00 00 00       	mov    $0x1,%edi
    5a41:	b8 00 00 00 00       	mov    $0x0,%eax
    5a46:	48 b9 11 66 00 00 00 	movabs $0x6611,%rcx
    5a4d:	00 00 00 
    5a50:	ff d1                	callq  *%rcx
    close(fd);
    5a52:	8b 45 f0             	mov    -0x10(%rbp),%eax
    5a55:	89 c7                	mov    %eax,%edi
    5a57:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    5a5e:	00 00 00 
    5a61:	ff d0                	callq  *%rax
    if(total == 0)
    5a63:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    5a67:	74 09                	je     5a72 <fsfull+0x219>
  for(nfiles = 0; ; nfiles++){
    5a69:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    5a6d:	e9 21 fe ff ff       	jmpq   5893 <fsfull+0x3a>
      break;
    5a72:	90                   	nop
  }

  while(nfiles >= 0){
    5a73:	e9 fd 00 00 00       	jmpq   5b75 <fsfull+0x31c>
    char name[64];
    name[0] = 'f';
    5a78:	c6 45 a0 66          	movb   $0x66,-0x60(%rbp)
    name[1] = '0' + nfiles / 1000;
    5a7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    5a7f:	48 63 d0             	movslq %eax,%rdx
    5a82:	48 69 d2 d3 4d 62 10 	imul   $0x10624dd3,%rdx,%rdx
    5a89:	48 c1 ea 20          	shr    $0x20,%rdx
    5a8d:	c1 fa 06             	sar    $0x6,%edx
    5a90:	c1 f8 1f             	sar    $0x1f,%eax
    5a93:	29 c2                	sub    %eax,%edx
    5a95:	89 d0                	mov    %edx,%eax
    5a97:	83 c0 30             	add    $0x30,%eax
    5a9a:	88 45 a1             	mov    %al,-0x5f(%rbp)
    name[2] = '0' + (nfiles % 1000) / 100;
    5a9d:	8b 55 fc             	mov    -0x4(%rbp),%edx
    5aa0:	48 63 c2             	movslq %edx,%rax
    5aa3:	48 69 c0 d3 4d 62 10 	imul   $0x10624dd3,%rax,%rax
    5aaa:	48 c1 e8 20          	shr    $0x20,%rax
    5aae:	89 c1                	mov    %eax,%ecx
    5ab0:	c1 f9 06             	sar    $0x6,%ecx
    5ab3:	89 d0                	mov    %edx,%eax
    5ab5:	c1 f8 1f             	sar    $0x1f,%eax
    5ab8:	29 c1                	sub    %eax,%ecx
    5aba:	89 c8                	mov    %ecx,%eax
    5abc:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
    5ac2:	29 c2                	sub    %eax,%edx
    5ac4:	89 d0                	mov    %edx,%eax
    5ac6:	48 63 d0             	movslq %eax,%rdx
    5ac9:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
    5ad0:	48 c1 ea 20          	shr    $0x20,%rdx
    5ad4:	c1 fa 05             	sar    $0x5,%edx
    5ad7:	c1 f8 1f             	sar    $0x1f,%eax
    5ada:	29 c2                	sub    %eax,%edx
    5adc:	89 d0                	mov    %edx,%eax
    5ade:	83 c0 30             	add    $0x30,%eax
    5ae1:	88 45 a2             	mov    %al,-0x5e(%rbp)
    name[3] = '0' + (nfiles % 100) / 10;
    5ae4:	8b 55 fc             	mov    -0x4(%rbp),%edx
    5ae7:	48 63 c2             	movslq %edx,%rax
    5aea:	48 69 c0 1f 85 eb 51 	imul   $0x51eb851f,%rax,%rax
    5af1:	48 c1 e8 20          	shr    $0x20,%rax
    5af5:	89 c1                	mov    %eax,%ecx
    5af7:	c1 f9 05             	sar    $0x5,%ecx
    5afa:	89 d0                	mov    %edx,%eax
    5afc:	c1 f8 1f             	sar    $0x1f,%eax
    5aff:	29 c1                	sub    %eax,%ecx
    5b01:	89 c8                	mov    %ecx,%eax
    5b03:	6b c0 64             	imul   $0x64,%eax,%eax
    5b06:	29 c2                	sub    %eax,%edx
    5b08:	89 d0                	mov    %edx,%eax
    5b0a:	48 63 d0             	movslq %eax,%rdx
    5b0d:	48 69 d2 67 66 66 66 	imul   $0x66666667,%rdx,%rdx
    5b14:	48 c1 ea 20          	shr    $0x20,%rdx
    5b18:	c1 fa 02             	sar    $0x2,%edx
    5b1b:	c1 f8 1f             	sar    $0x1f,%eax
    5b1e:	29 c2                	sub    %eax,%edx
    5b20:	89 d0                	mov    %edx,%eax
    5b22:	83 c0 30             	add    $0x30,%eax
    5b25:	88 45 a3             	mov    %al,-0x5d(%rbp)
    name[4] = '0' + (nfiles % 10);
    5b28:	8b 4d fc             	mov    -0x4(%rbp),%ecx
    5b2b:	48 63 c1             	movslq %ecx,%rax
    5b2e:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
    5b35:	48 c1 e8 20          	shr    $0x20,%rax
    5b39:	89 c2                	mov    %eax,%edx
    5b3b:	c1 fa 02             	sar    $0x2,%edx
    5b3e:	89 c8                	mov    %ecx,%eax
    5b40:	c1 f8 1f             	sar    $0x1f,%eax
    5b43:	29 c2                	sub    %eax,%edx
    5b45:	89 d0                	mov    %edx,%eax
    5b47:	c1 e0 02             	shl    $0x2,%eax
    5b4a:	01 d0                	add    %edx,%eax
    5b4c:	01 c0                	add    %eax,%eax
    5b4e:	29 c1                	sub    %eax,%ecx
    5b50:	89 ca                	mov    %ecx,%edx
    5b52:	89 d0                	mov    %edx,%eax
    5b54:	83 c0 30             	add    $0x30,%eax
    5b57:	88 45 a4             	mov    %al,-0x5c(%rbp)
    name[5] = '\0';
    5b5a:	c6 45 a5 00          	movb   $0x0,-0x5b(%rbp)
    unlink(name);
    5b5e:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
    5b62:	48 89 c7             	mov    %rax,%rdi
    5b65:	48 b8 8f 63 00 00 00 	movabs $0x638f,%rax
    5b6c:	00 00 00 
    5b6f:	ff d0                	callq  *%rax
    nfiles--;
    5b71:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  while(nfiles >= 0){
    5b75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    5b79:	0f 89 f9 fe ff ff    	jns    5a78 <fsfull+0x21f>
  }

  printf(1, "fsfull test finished\n");
    5b7f:	48 be f8 82 00 00 00 	movabs $0x82f8,%rsi
    5b86:	00 00 00 
    5b89:	bf 01 00 00 00       	mov    $0x1,%edi
    5b8e:	b8 00 00 00 00       	mov    $0x0,%eax
    5b93:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    5b9a:	00 00 00 
    5b9d:	ff d2                	callq  *%rdx
}
    5b9f:	90                   	nop
    5ba0:	c9                   	leaveq 
    5ba1:	c3                   	retq   

0000000000005ba2 <uio>:

void
uio()
{
    5ba2:	f3 0f 1e fa          	endbr64 
    5ba6:	55                   	push   %rbp
    5ba7:	48 89 e5             	mov    %rsp,%rbp
    5baa:	48 83 ec 10          	sub    $0x10,%rsp
  #define RTC_ADDR 0x70
  #define RTC_DATA 0x71

  ushort port = 0;
    5bae:	66 c7 45 fe 00 00    	movw   $0x0,-0x2(%rbp)
  uchar val = 0;
    5bb4:	c6 45 fd 00          	movb   $0x0,-0x3(%rbp)
  int pid;

  printf(1, "uio test\n");
    5bb8:	48 be 0e 83 00 00 00 	movabs $0x830e,%rsi
    5bbf:	00 00 00 
    5bc2:	bf 01 00 00 00       	mov    $0x1,%edi
    5bc7:	b8 00 00 00 00       	mov    $0x0,%eax
    5bcc:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    5bd3:	00 00 00 
    5bd6:	ff d2                	callq  *%rdx
  pid = fork();
    5bd8:	48 b8 00 63 00 00 00 	movabs $0x6300,%rax
    5bdf:	00 00 00 
    5be2:	ff d0                	callq  *%rax
    5be4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(pid == 0){
    5be7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    5beb:	75 4f                	jne    5c3c <uio+0x9a>
    port = RTC_ADDR;
    5bed:	66 c7 45 fe 70 00    	movw   $0x70,-0x2(%rbp)
    val = 0x09;  /* year */
    5bf3:	c6 45 fd 09          	movb   $0x9,-0x3(%rbp)
    /* http://wiki.osdev.org/Inline_Assembly/Examples */
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    5bf7:	0f b6 45 fd          	movzbl -0x3(%rbp),%eax
    5bfb:	0f b7 55 fe          	movzwl -0x2(%rbp),%edx
    5bff:	ee                   	out    %al,(%dx)
    port = RTC_DATA;
    5c00:	66 c7 45 fe 71 00    	movw   $0x71,-0x2(%rbp)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    5c06:	0f b7 45 fe          	movzwl -0x2(%rbp),%eax
    5c0a:	89 c2                	mov    %eax,%edx
    5c0c:	ec                   	in     (%dx),%al
    5c0d:	88 45 fd             	mov    %al,-0x3(%rbp)
    printf(1, "uio test succeeded\n");
    5c10:	48 be 18 83 00 00 00 	movabs $0x8318,%rsi
    5c17:	00 00 00 
    5c1a:	bf 01 00 00 00       	mov    $0x1,%edi
    5c1f:	b8 00 00 00 00       	mov    $0x0,%eax
    5c24:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    5c2b:	00 00 00 
    5c2e:	ff d2                	callq  *%rdx
    exit();
    5c30:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    5c37:	00 00 00 
    5c3a:	ff d0                	callq  *%rax
  } else if(pid < 0){
    5c3c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    5c40:	79 16                	jns    5c58 <uio+0xb6>
    failexit("fork");
    5c42:	48 bf b7 6d 00 00 00 	movabs $0x6db7,%rdi
    5c49:	00 00 00 
    5c4c:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    5c53:	00 00 00 
    5c56:	ff d0                	callq  *%rax
  }
  wait();
    5c58:	48 b8 1a 63 00 00 00 	movabs $0x631a,%rax
    5c5f:	00 00 00 
    5c62:	ff d0                	callq  *%rax
  printf(1, "uio test done\n");
    5c64:	48 be 2c 83 00 00 00 	movabs $0x832c,%rsi
    5c6b:	00 00 00 
    5c6e:	bf 01 00 00 00       	mov    $0x1,%edi
    5c73:	b8 00 00 00 00       	mov    $0x0,%eax
    5c78:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    5c7f:	00 00 00 
    5c82:	ff d2                	callq  *%rdx
}
    5c84:	90                   	nop
    5c85:	c9                   	leaveq 
    5c86:	c3                   	retq   

0000000000005c87 <argptest>:

void argptest()
{
    5c87:	f3 0f 1e fa          	endbr64 
    5c8b:	55                   	push   %rbp
    5c8c:	48 89 e5             	mov    %rsp,%rbp
    5c8f:	48 83 ec 10          	sub    $0x10,%rsp
  int fd;
  fd = open("init", O_RDONLY);
    5c93:	be 00 00 00 00       	mov    $0x0,%esi
    5c98:	48 bf 3b 83 00 00 00 	movabs $0x833b,%rdi
    5c9f:	00 00 00 
    5ca2:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    5ca9:	00 00 00 
    5cac:	ff d0                	callq  *%rax
    5cae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if (fd < 0) {
    5cb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    5cb5:	79 16                	jns    5ccd <argptest+0x46>
    failexit("open");
    5cb7:	48 bf 40 83 00 00 00 	movabs $0x8340,%rdi
    5cbe:	00 00 00 
    5cc1:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    5cc8:	00 00 00 
    5ccb:	ff d0                	callq  *%rax
  }
  read(fd, sbrk(0) - 1, -1);
    5ccd:	bf 00 00 00 00       	mov    $0x0,%edi
    5cd2:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    5cd9:	00 00 00 
    5cdc:	ff d0                	callq  *%rax
    5cde:	48 8d 48 ff          	lea    -0x1(%rax),%rcx
    5ce2:	8b 45 fc             	mov    -0x4(%rbp),%eax
    5ce5:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    5cea:	48 89 ce             	mov    %rcx,%rsi
    5ced:	89 c7                	mov    %eax,%edi
    5cef:	48 b8 34 63 00 00 00 	movabs $0x6334,%rax
    5cf6:	00 00 00 
    5cf9:	ff d0                	callq  *%rax
  close(fd);
    5cfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
    5cfe:	89 c7                	mov    %eax,%edi
    5d00:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    5d07:	00 00 00 
    5d0a:	ff d0                	callq  *%rax
  printf(1, "arg test passed\n");
    5d0c:	48 be 45 83 00 00 00 	movabs $0x8345,%rsi
    5d13:	00 00 00 
    5d16:	bf 01 00 00 00       	mov    $0x1,%edi
    5d1b:	b8 00 00 00 00       	mov    $0x0,%eax
    5d20:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    5d27:	00 00 00 
    5d2a:	ff d2                	callq  *%rdx
}
    5d2c:	90                   	nop
    5d2d:	c9                   	leaveq 
    5d2e:	c3                   	retq   

0000000000005d2f <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    5d2f:	f3 0f 1e fa          	endbr64 
    5d33:	55                   	push   %rbp
    5d34:	48 89 e5             	mov    %rsp,%rbp
  randstate = randstate * 1664525 + 1013904223;
    5d37:	48 b8 e8 8b 00 00 00 	movabs $0x8be8,%rax
    5d3e:	00 00 00 
    5d41:	48 8b 00             	mov    (%rax),%rax
    5d44:	48 69 c0 0d 66 19 00 	imul   $0x19660d,%rax,%rax
    5d4b:	48 8d 90 5f f3 6e 3c 	lea    0x3c6ef35f(%rax),%rdx
    5d52:	48 b8 e8 8b 00 00 00 	movabs $0x8be8,%rax
    5d59:	00 00 00 
    5d5c:	48 89 10             	mov    %rdx,(%rax)
  return randstate;
    5d5f:	48 b8 e8 8b 00 00 00 	movabs $0x8be8,%rax
    5d66:	00 00 00 
    5d69:	48 8b 00             	mov    (%rax),%rax
}
    5d6c:	5d                   	pop    %rbp
    5d6d:	c3                   	retq   

0000000000005d6e <main>:

int
main(int argc, char *argv[])
{
    5d6e:	f3 0f 1e fa          	endbr64 
    5d72:	55                   	push   %rbp
    5d73:	48 89 e5             	mov    %rsp,%rbp
    5d76:	48 83 ec 10          	sub    $0x10,%rsp
    5d7a:	89 7d fc             	mov    %edi,-0x4(%rbp)
    5d7d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  printf(1, "usertests starting\n");
    5d81:	48 be 56 83 00 00 00 	movabs $0x8356,%rsi
    5d88:	00 00 00 
    5d8b:	bf 01 00 00 00       	mov    $0x1,%edi
    5d90:	b8 00 00 00 00       	mov    $0x0,%eax
    5d95:	48 ba 11 66 00 00 00 	movabs $0x6611,%rdx
    5d9c:	00 00 00 
    5d9f:	ff d2                	callq  *%rdx

  if(open("usertests.ran", 0) >= 0){
    5da1:	be 00 00 00 00       	mov    $0x0,%esi
    5da6:	48 bf 6a 83 00 00 00 	movabs $0x836a,%rdi
    5dad:	00 00 00 
    5db0:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    5db7:	00 00 00 
    5dba:	ff d0                	callq  *%rax
    5dbc:	85 c0                	test   %eax,%eax
    5dbe:	78 16                	js     5dd6 <main+0x68>
    failexit("already ran user tests -- rebuild fs.img");
    5dc0:	48 bf 78 83 00 00 00 	movabs $0x8378,%rdi
    5dc7:	00 00 00 
    5dca:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    5dd1:	00 00 00 
    5dd4:	ff d0                	callq  *%rax
  }
  close(open("usertests.ran", O_CREATE));
    5dd6:	be 00 02 00 00       	mov    $0x200,%esi
    5ddb:	48 bf 6a 83 00 00 00 	movabs $0x836a,%rdi
    5de2:	00 00 00 
    5de5:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    5dec:	00 00 00 
    5def:	ff d0                	callq  *%rax
    5df1:	89 c7                	mov    %eax,%edi
    5df3:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    5dfa:	00 00 00 
    5dfd:	ff d0                	callq  *%rax

  argptest();
    5dff:	b8 00 00 00 00       	mov    $0x0,%eax
    5e04:	48 ba 87 5c 00 00 00 	movabs $0x5c87,%rdx
    5e0b:	00 00 00 
    5e0e:	ff d2                	callq  *%rdx
  createdelete();
    5e10:	48 b8 68 29 00 00 00 	movabs $0x2968,%rax
    5e17:	00 00 00 
    5e1a:	ff d0                	callq  *%rax
  linkunlink();
    5e1c:	b8 00 00 00 00       	mov    $0x0,%eax
    5e21:	48 ba 41 36 00 00 00 	movabs $0x3641,%rdx
    5e28:	00 00 00 
    5e2b:	ff d2                	callq  *%rdx
  concreate();
    5e2d:	48 b8 5e 31 00 00 00 	movabs $0x315e,%rax
    5e34:	00 00 00 
    5e37:	ff d0                	callq  *%rax
  fourfiles();
    5e39:	48 b8 58 26 00 00 00 	movabs $0x2658,%rax
    5e40:	00 00 00 
    5e43:	ff d0                	callq  *%rax
  sharedfd();
    5e45:	48 b8 be 23 00 00 00 	movabs $0x23be,%rax
    5e4c:	00 00 00 
    5e4f:	ff d0                	callq  *%rax

  bigargtest();
    5e51:	48 b8 b2 56 00 00 00 	movabs $0x56b2,%rax
    5e58:	00 00 00 
    5e5b:	ff d0                	callq  *%rax
  bigwrite();
    5e5d:	48 b8 08 42 00 00 00 	movabs $0x4208,%rax
    5e64:	00 00 00 
    5e67:	ff d0                	callq  *%rax
  bigargtest();
    5e69:	48 b8 b2 56 00 00 00 	movabs $0x56b2,%rax
    5e70:	00 00 00 
    5e73:	ff d0                	callq  *%rax
  bsstest();
    5e75:	48 b8 1f 56 00 00 00 	movabs $0x561f,%rax
    5e7c:	00 00 00 
    5e7f:	ff d0                	callq  *%rax
  sbrktest();
    5e81:	48 b8 98 4e 00 00 00 	movabs $0x4e98,%rax
    5e88:	00 00 00 
    5e8b:	ff d0                	callq  *%rax
  validatetest();
    5e8d:	48 b8 74 55 00 00 00 	movabs $0x5574,%rax
    5e94:	00 00 00 
    5e97:	ff d0                	callq  *%rax

  opentest();
    5e99:	48 b8 bd 13 00 00 00 	movabs $0x13bd,%rax
    5ea0:	00 00 00 
    5ea3:	ff d0                	callq  *%rax
  writetest();
    5ea5:	48 b8 91 14 00 00 00 	movabs $0x1491,%rax
    5eac:	00 00 00 
    5eaf:	ff d0                	callq  *%rax
  writetest1();
    5eb1:	48 b8 ba 16 00 00 00 	movabs $0x16ba,%rax
    5eb8:	00 00 00 
    5ebb:	ff d0                	callq  *%rax
  createtest();
    5ebd:	48 b8 41 19 00 00 00 	movabs $0x1941,%rax
    5ec4:	00 00 00 
    5ec7:	ff d0                	callq  *%rax

  openiputtest();
    5ec9:	48 b8 7a 12 00 00 00 	movabs $0x127a,%rax
    5ed0:	00 00 00 
    5ed3:	ff d0                	callq  *%rax
  exitiputtest();
    5ed5:	48 b8 4e 11 00 00 00 	movabs $0x114e,%rax
    5edc:	00 00 00 
    5edf:	ff d0                	callq  *%rax
  iputtest();
    5ee1:	48 b8 43 10 00 00 00 	movabs $0x1043,%rax
    5ee8:	00 00 00 
    5eeb:	ff d0                	callq  *%rax

  mem();
    5eed:	48 b8 3b 22 00 00 00 	movabs $0x223b,%rax
    5ef4:	00 00 00 
    5ef7:	ff d0                	callq  *%rax
  pipe1();
    5ef9:	48 b8 15 1d 00 00 00 	movabs $0x1d15,%rax
    5f00:	00 00 00 
    5f03:	ff d0                	callq  *%rax
  preempt();
    5f05:	48 b8 67 1f 00 00 00 	movabs $0x1f67,%rax
    5f0c:	00 00 00 
    5f0f:	ff d0                	callq  *%rax
  exitwait();
    5f11:	48 b8 77 21 00 00 00 	movabs $0x2177,%rax
    5f18:	00 00 00 
    5f1b:	ff d0                	callq  *%rax
  nullptr();
    5f1d:	48 b8 32 1c 00 00 00 	movabs $0x1c32,%rax
    5f24:	00 00 00 
    5f27:	ff d0                	callq  *%rax

  rmdot();
    5f29:	48 b8 86 47 00 00 00 	movabs $0x4786,%rax
    5f30:	00 00 00 
    5f33:	ff d0                	callq  *%rax
  fourteen();
    5f35:	48 b8 e1 45 00 00 00 	movabs $0x45e1,%rax
    5f3c:	00 00 00 
    5f3f:	ff d0                	callq  *%rax
  bigfile();
    5f41:	48 b8 61 43 00 00 00 	movabs $0x4361,%rax
    5f48:	00 00 00 
    5f4b:	ff d0                	callq  *%rax
  subdir();
    5f4d:	48 b8 91 39 00 00 00 	movabs $0x3991,%rax
    5f54:	00 00 00 
    5f57:	ff d0                	callq  *%rax
  linktest();
    5f59:	48 b8 8e 2e 00 00 00 	movabs $0x2e8e,%rax
    5f60:	00 00 00 
    5f63:	ff d0                	callq  *%rax
  unlinkread();
    5f65:	48 b8 57 2c 00 00 00 	movabs $0x2c57,%rax
    5f6c:	00 00 00 
    5f6f:	ff d0                	callq  *%rax
  dirfile();
    5f71:	48 b8 51 49 00 00 00 	movabs $0x4951,%rax
    5f78:	00 00 00 
    5f7b:	ff d0                	callq  *%rax
  iref();
    5f7d:	48 b8 fc 4b 00 00 00 	movabs $0x4bfc,%rax
    5f84:	00 00 00 
    5f87:	ff d0                	callq  *%rax
  forktest();
    5f89:	48 b8 91 4d 00 00 00 	movabs $0x4d91,%rax
    5f90:	00 00 00 
    5f93:	ff d0                	callq  *%rax
  bigdir(); // slow
    5f95:	48 b8 db 37 00 00 00 	movabs $0x37db,%rax
    5f9c:	00 00 00 
    5f9f:	ff d0                	callq  *%rax
  uio();
    5fa1:	b8 00 00 00 00       	mov    $0x0,%eax
    5fa6:	48 ba a2 5b 00 00 00 	movabs $0x5ba2,%rdx
    5fad:	00 00 00 
    5fb0:	ff d2                	callq  *%rdx

  exectest(); // will exit
    5fb2:	48 b8 ad 1b 00 00 00 	movabs $0x1bad,%rax
    5fb9:	00 00 00 
    5fbc:	ff d0                	callq  *%rax

  exit();
    5fbe:	48 b8 0d 63 00 00 00 	movabs $0x630d,%rax
    5fc5:	00 00 00 
    5fc8:	ff d0                	callq  *%rax

0000000000005fca <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    5fca:	f3 0f 1e fa          	endbr64 
    5fce:	55                   	push   %rbp
    5fcf:	48 89 e5             	mov    %rsp,%rbp
    5fd2:	48 83 ec 10          	sub    $0x10,%rsp
    5fd6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    5fda:	89 75 f4             	mov    %esi,-0xc(%rbp)
    5fdd:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    5fe0:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    5fe4:	8b 55 f0             	mov    -0x10(%rbp),%edx
    5fe7:	8b 45 f4             	mov    -0xc(%rbp),%eax
    5fea:	48 89 ce             	mov    %rcx,%rsi
    5fed:	48 89 f7             	mov    %rsi,%rdi
    5ff0:	89 d1                	mov    %edx,%ecx
    5ff2:	fc                   	cld    
    5ff3:	f3 aa                	rep stos %al,%es:(%rdi)
    5ff5:	89 ca                	mov    %ecx,%edx
    5ff7:	48 89 fe             	mov    %rdi,%rsi
    5ffa:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    5ffe:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    6001:	90                   	nop
    6002:	c9                   	leaveq 
    6003:	c3                   	retq   

0000000000006004 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    6004:	f3 0f 1e fa          	endbr64 
    6008:	55                   	push   %rbp
    6009:	48 89 e5             	mov    %rsp,%rbp
    600c:	48 83 ec 20          	sub    $0x20,%rsp
    6010:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    6014:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    6018:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    601c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    6020:	90                   	nop
    6021:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    6025:	48 8d 42 01          	lea    0x1(%rdx),%rax
    6029:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    602d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    6031:	48 8d 48 01          	lea    0x1(%rax),%rcx
    6035:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    6039:	0f b6 12             	movzbl (%rdx),%edx
    603c:	88 10                	mov    %dl,(%rax)
    603e:	0f b6 00             	movzbl (%rax),%eax
    6041:	84 c0                	test   %al,%al
    6043:	75 dc                	jne    6021 <strcpy+0x1d>
    ;
  return os;
    6045:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    6049:	c9                   	leaveq 
    604a:	c3                   	retq   

000000000000604b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    604b:	f3 0f 1e fa          	endbr64 
    604f:	55                   	push   %rbp
    6050:	48 89 e5             	mov    %rsp,%rbp
    6053:	48 83 ec 10          	sub    $0x10,%rsp
    6057:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    605b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    605f:	eb 0a                	jmp    606b <strcmp+0x20>
    p++, q++;
    6061:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    6066:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    606b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    606f:	0f b6 00             	movzbl (%rax),%eax
    6072:	84 c0                	test   %al,%al
    6074:	74 12                	je     6088 <strcmp+0x3d>
    6076:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    607a:	0f b6 10             	movzbl (%rax),%edx
    607d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6081:	0f b6 00             	movzbl (%rax),%eax
    6084:	38 c2                	cmp    %al,%dl
    6086:	74 d9                	je     6061 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    6088:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    608c:	0f b6 00             	movzbl (%rax),%eax
    608f:	0f b6 d0             	movzbl %al,%edx
    6092:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6096:	0f b6 00             	movzbl (%rax),%eax
    6099:	0f b6 c0             	movzbl %al,%eax
    609c:	29 c2                	sub    %eax,%edx
    609e:	89 d0                	mov    %edx,%eax
}
    60a0:	c9                   	leaveq 
    60a1:	c3                   	retq   

00000000000060a2 <strlen>:

uint
strlen(char *s)
{
    60a2:	f3 0f 1e fa          	endbr64 
    60a6:	55                   	push   %rbp
    60a7:	48 89 e5             	mov    %rsp,%rbp
    60aa:	48 83 ec 18          	sub    $0x18,%rsp
    60ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    60b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    60b9:	eb 04                	jmp    60bf <strlen+0x1d>
    60bb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    60bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
    60c2:	48 63 d0             	movslq %eax,%rdx
    60c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    60c9:	48 01 d0             	add    %rdx,%rax
    60cc:	0f b6 00             	movzbl (%rax),%eax
    60cf:	84 c0                	test   %al,%al
    60d1:	75 e8                	jne    60bb <strlen+0x19>
    ;
  return n;
    60d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    60d6:	c9                   	leaveq 
    60d7:	c3                   	retq   

00000000000060d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    60d8:	f3 0f 1e fa          	endbr64 
    60dc:	55                   	push   %rbp
    60dd:	48 89 e5             	mov    %rsp,%rbp
    60e0:	48 83 ec 10          	sub    $0x10,%rsp
    60e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    60e8:	89 75 f4             	mov    %esi,-0xc(%rbp)
    60eb:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    60ee:	8b 55 f0             	mov    -0x10(%rbp),%edx
    60f1:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    60f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    60f8:	89 ce                	mov    %ecx,%esi
    60fa:	48 89 c7             	mov    %rax,%rdi
    60fd:	48 b8 ca 5f 00 00 00 	movabs $0x5fca,%rax
    6104:	00 00 00 
    6107:	ff d0                	callq  *%rax
  return dst;
    6109:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    610d:	c9                   	leaveq 
    610e:	c3                   	retq   

000000000000610f <strchr>:

char*
strchr(const char *s, char c)
{
    610f:	f3 0f 1e fa          	endbr64 
    6113:	55                   	push   %rbp
    6114:	48 89 e5             	mov    %rsp,%rbp
    6117:	48 83 ec 10          	sub    $0x10,%rsp
    611b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    611f:	89 f0                	mov    %esi,%eax
    6121:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    6124:	eb 17                	jmp    613d <strchr+0x2e>
    if(*s == c)
    6126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    612a:	0f b6 00             	movzbl (%rax),%eax
    612d:	38 45 f4             	cmp    %al,-0xc(%rbp)
    6130:	75 06                	jne    6138 <strchr+0x29>
      return (char*)s;
    6132:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6136:	eb 15                	jmp    614d <strchr+0x3e>
  for(; *s; s++)
    6138:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    613d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6141:	0f b6 00             	movzbl (%rax),%eax
    6144:	84 c0                	test   %al,%al
    6146:	75 de                	jne    6126 <strchr+0x17>
  return 0;
    6148:	b8 00 00 00 00       	mov    $0x0,%eax
}
    614d:	c9                   	leaveq 
    614e:	c3                   	retq   

000000000000614f <gets>:

char*
gets(char *buf, int max)
{
    614f:	f3 0f 1e fa          	endbr64 
    6153:	55                   	push   %rbp
    6154:	48 89 e5             	mov    %rsp,%rbp
    6157:	48 83 ec 20          	sub    $0x20,%rsp
    615b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    615f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    6162:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    6169:	eb 4f                	jmp    61ba <gets+0x6b>
    cc = read(0, &c, 1);
    616b:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    616f:	ba 01 00 00 00       	mov    $0x1,%edx
    6174:	48 89 c6             	mov    %rax,%rsi
    6177:	bf 00 00 00 00       	mov    $0x0,%edi
    617c:	48 b8 34 63 00 00 00 	movabs $0x6334,%rax
    6183:	00 00 00 
    6186:	ff d0                	callq  *%rax
    6188:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    618b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    618f:	7e 36                	jle    61c7 <gets+0x78>
      break;
    buf[i++] = c;
    6191:	8b 45 fc             	mov    -0x4(%rbp),%eax
    6194:	8d 50 01             	lea    0x1(%rax),%edx
    6197:	89 55 fc             	mov    %edx,-0x4(%rbp)
    619a:	48 63 d0             	movslq %eax,%rdx
    619d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    61a1:	48 01 c2             	add    %rax,%rdx
    61a4:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    61a8:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    61aa:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    61ae:	3c 0a                	cmp    $0xa,%al
    61b0:	74 16                	je     61c8 <gets+0x79>
    61b2:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    61b6:	3c 0d                	cmp    $0xd,%al
    61b8:	74 0e                	je     61c8 <gets+0x79>
  for(i=0; i+1 < max; ){
    61ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
    61bd:	83 c0 01             	add    $0x1,%eax
    61c0:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    61c3:	7f a6                	jg     616b <gets+0x1c>
    61c5:	eb 01                	jmp    61c8 <gets+0x79>
      break;
    61c7:	90                   	nop
      break;
  }
  buf[i] = '\0';
    61c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    61cb:	48 63 d0             	movslq %eax,%rdx
    61ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    61d2:	48 01 d0             	add    %rdx,%rax
    61d5:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    61d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    61dc:	c9                   	leaveq 
    61dd:	c3                   	retq   

00000000000061de <stat>:

int
stat(char *n, struct stat *st)
{
    61de:	f3 0f 1e fa          	endbr64 
    61e2:	55                   	push   %rbp
    61e3:	48 89 e5             	mov    %rsp,%rbp
    61e6:	48 83 ec 20          	sub    $0x20,%rsp
    61ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    61ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    61f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    61f6:	be 00 00 00 00       	mov    $0x0,%esi
    61fb:	48 89 c7             	mov    %rax,%rdi
    61fe:	48 b8 75 63 00 00 00 	movabs $0x6375,%rax
    6205:	00 00 00 
    6208:	ff d0                	callq  *%rax
    620a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    620d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    6211:	79 07                	jns    621a <stat+0x3c>
    return -1;
    6213:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    6218:	eb 2f                	jmp    6249 <stat+0x6b>
  r = fstat(fd, st);
    621a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    621e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    6221:	48 89 d6             	mov    %rdx,%rsi
    6224:	89 c7                	mov    %eax,%edi
    6226:	48 b8 9c 63 00 00 00 	movabs $0x639c,%rax
    622d:	00 00 00 
    6230:	ff d0                	callq  *%rax
    6232:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    6235:	8b 45 fc             	mov    -0x4(%rbp),%eax
    6238:	89 c7                	mov    %eax,%edi
    623a:	48 b8 4e 63 00 00 00 	movabs $0x634e,%rax
    6241:	00 00 00 
    6244:	ff d0                	callq  *%rax
  return r;
    6246:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    6249:	c9                   	leaveq 
    624a:	c3                   	retq   

000000000000624b <atoi>:

int
atoi(const char *s)
{
    624b:	f3 0f 1e fa          	endbr64 
    624f:	55                   	push   %rbp
    6250:	48 89 e5             	mov    %rsp,%rbp
    6253:	48 83 ec 18          	sub    $0x18,%rsp
    6257:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    625b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    6262:	eb 28                	jmp    628c <atoi+0x41>
    n = n*10 + *s++ - '0';
    6264:	8b 55 fc             	mov    -0x4(%rbp),%edx
    6267:	89 d0                	mov    %edx,%eax
    6269:	c1 e0 02             	shl    $0x2,%eax
    626c:	01 d0                	add    %edx,%eax
    626e:	01 c0                	add    %eax,%eax
    6270:	89 c1                	mov    %eax,%ecx
    6272:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    6276:	48 8d 50 01          	lea    0x1(%rax),%rdx
    627a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    627e:	0f b6 00             	movzbl (%rax),%eax
    6281:	0f be c0             	movsbl %al,%eax
    6284:	01 c8                	add    %ecx,%eax
    6286:	83 e8 30             	sub    $0x30,%eax
    6289:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    628c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    6290:	0f b6 00             	movzbl (%rax),%eax
    6293:	3c 2f                	cmp    $0x2f,%al
    6295:	7e 0b                	jle    62a2 <atoi+0x57>
    6297:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    629b:	0f b6 00             	movzbl (%rax),%eax
    629e:	3c 39                	cmp    $0x39,%al
    62a0:	7e c2                	jle    6264 <atoi+0x19>
  return n;
    62a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    62a5:	c9                   	leaveq 
    62a6:	c3                   	retq   

00000000000062a7 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    62a7:	f3 0f 1e fa          	endbr64 
    62ab:	55                   	push   %rbp
    62ac:	48 89 e5             	mov    %rsp,%rbp
    62af:	48 83 ec 28          	sub    $0x28,%rsp
    62b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    62b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    62bb:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    62be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    62c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    62c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    62ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    62ce:	eb 1d                	jmp    62ed <memmove+0x46>
    *dst++ = *src++;
    62d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    62d4:	48 8d 42 01          	lea    0x1(%rdx),%rax
    62d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    62dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    62e0:	48 8d 48 01          	lea    0x1(%rax),%rcx
    62e4:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    62e8:	0f b6 12             	movzbl (%rdx),%edx
    62eb:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    62ed:	8b 45 dc             	mov    -0x24(%rbp),%eax
    62f0:	8d 50 ff             	lea    -0x1(%rax),%edx
    62f3:	89 55 dc             	mov    %edx,-0x24(%rbp)
    62f6:	85 c0                	test   %eax,%eax
    62f8:	7f d6                	jg     62d0 <memmove+0x29>
  return vdst;
    62fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    62fe:	c9                   	leaveq 
    62ff:	c3                   	retq   

0000000000006300 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    6300:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    6307:	49 89 ca             	mov    %rcx,%r10
    630a:	0f 05                	syscall 
    630c:	c3                   	retq   

000000000000630d <exit>:
SYSCALL(exit)
    630d:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    6314:	49 89 ca             	mov    %rcx,%r10
    6317:	0f 05                	syscall 
    6319:	c3                   	retq   

000000000000631a <wait>:
SYSCALL(wait)
    631a:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    6321:	49 89 ca             	mov    %rcx,%r10
    6324:	0f 05                	syscall 
    6326:	c3                   	retq   

0000000000006327 <pipe>:
SYSCALL(pipe)
    6327:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    632e:	49 89 ca             	mov    %rcx,%r10
    6331:	0f 05                	syscall 
    6333:	c3                   	retq   

0000000000006334 <read>:
SYSCALL(read)
    6334:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    633b:	49 89 ca             	mov    %rcx,%r10
    633e:	0f 05                	syscall 
    6340:	c3                   	retq   

0000000000006341 <write>:
SYSCALL(write)
    6341:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    6348:	49 89 ca             	mov    %rcx,%r10
    634b:	0f 05                	syscall 
    634d:	c3                   	retq   

000000000000634e <close>:
SYSCALL(close)
    634e:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    6355:	49 89 ca             	mov    %rcx,%r10
    6358:	0f 05                	syscall 
    635a:	c3                   	retq   

000000000000635b <kill>:
SYSCALL(kill)
    635b:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    6362:	49 89 ca             	mov    %rcx,%r10
    6365:	0f 05                	syscall 
    6367:	c3                   	retq   

0000000000006368 <exec>:
SYSCALL(exec)
    6368:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    636f:	49 89 ca             	mov    %rcx,%r10
    6372:	0f 05                	syscall 
    6374:	c3                   	retq   

0000000000006375 <open>:
SYSCALL(open)
    6375:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    637c:	49 89 ca             	mov    %rcx,%r10
    637f:	0f 05                	syscall 
    6381:	c3                   	retq   

0000000000006382 <mknod>:
SYSCALL(mknod)
    6382:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    6389:	49 89 ca             	mov    %rcx,%r10
    638c:	0f 05                	syscall 
    638e:	c3                   	retq   

000000000000638f <unlink>:
SYSCALL(unlink)
    638f:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    6396:	49 89 ca             	mov    %rcx,%r10
    6399:	0f 05                	syscall 
    639b:	c3                   	retq   

000000000000639c <fstat>:
SYSCALL(fstat)
    639c:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    63a3:	49 89 ca             	mov    %rcx,%r10
    63a6:	0f 05                	syscall 
    63a8:	c3                   	retq   

00000000000063a9 <link>:
SYSCALL(link)
    63a9:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    63b0:	49 89 ca             	mov    %rcx,%r10
    63b3:	0f 05                	syscall 
    63b5:	c3                   	retq   

00000000000063b6 <mkdir>:
SYSCALL(mkdir)
    63b6:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    63bd:	49 89 ca             	mov    %rcx,%r10
    63c0:	0f 05                	syscall 
    63c2:	c3                   	retq   

00000000000063c3 <chdir>:
SYSCALL(chdir)
    63c3:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    63ca:	49 89 ca             	mov    %rcx,%r10
    63cd:	0f 05                	syscall 
    63cf:	c3                   	retq   

00000000000063d0 <dup>:
SYSCALL(dup)
    63d0:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    63d7:	49 89 ca             	mov    %rcx,%r10
    63da:	0f 05                	syscall 
    63dc:	c3                   	retq   

00000000000063dd <getpid>:
SYSCALL(getpid)
    63dd:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    63e4:	49 89 ca             	mov    %rcx,%r10
    63e7:	0f 05                	syscall 
    63e9:	c3                   	retq   

00000000000063ea <sbrk>:
SYSCALL(sbrk)
    63ea:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    63f1:	49 89 ca             	mov    %rcx,%r10
    63f4:	0f 05                	syscall 
    63f6:	c3                   	retq   

00000000000063f7 <sleep>:
SYSCALL(sleep)
    63f7:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    63fe:	49 89 ca             	mov    %rcx,%r10
    6401:	0f 05                	syscall 
    6403:	c3                   	retq   

0000000000006404 <uptime>:
SYSCALL(uptime)
    6404:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    640b:	49 89 ca             	mov    %rcx,%r10
    640e:	0f 05                	syscall 
    6410:	c3                   	retq   

0000000000006411 <dedup>:
SYSCALL(dedup)
    6411:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    6418:	49 89 ca             	mov    %rcx,%r10
    641b:	0f 05                	syscall 
    641d:	c3                   	retq   

000000000000641e <freepages>:
SYSCALL(freepages)
    641e:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    6425:	49 89 ca             	mov    %rcx,%r10
    6428:	0f 05                	syscall 
    642a:	c3                   	retq   

000000000000642b <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    642b:	f3 0f 1e fa          	endbr64 
    642f:	55                   	push   %rbp
    6430:	48 89 e5             	mov    %rsp,%rbp
    6433:	48 83 ec 10          	sub    $0x10,%rsp
    6437:	89 7d fc             	mov    %edi,-0x4(%rbp)
    643a:	89 f0                	mov    %esi,%eax
    643c:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    643f:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    6443:	8b 45 fc             	mov    -0x4(%rbp),%eax
    6446:	ba 01 00 00 00       	mov    $0x1,%edx
    644b:	48 89 ce             	mov    %rcx,%rsi
    644e:	89 c7                	mov    %eax,%edi
    6450:	48 b8 41 63 00 00 00 	movabs $0x6341,%rax
    6457:	00 00 00 
    645a:	ff d0                	callq  *%rax
}
    645c:	90                   	nop
    645d:	c9                   	leaveq 
    645e:	c3                   	retq   

000000000000645f <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    645f:	f3 0f 1e fa          	endbr64 
    6463:	55                   	push   %rbp
    6464:	48 89 e5             	mov    %rsp,%rbp
    6467:	48 83 ec 20          	sub    $0x20,%rsp
    646b:	89 7d ec             	mov    %edi,-0x14(%rbp)
    646e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    6472:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    6479:	eb 35                	jmp    64b0 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    647b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    647f:	48 c1 e8 3c          	shr    $0x3c,%rax
    6483:	48 ba f0 8b 00 00 00 	movabs $0x8bf0,%rdx
    648a:	00 00 00 
    648d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    6491:	0f be d0             	movsbl %al,%edx
    6494:	8b 45 ec             	mov    -0x14(%rbp),%eax
    6497:	89 d6                	mov    %edx,%esi
    6499:	89 c7                	mov    %eax,%edi
    649b:	48 b8 2b 64 00 00 00 	movabs $0x642b,%rax
    64a2:	00 00 00 
    64a5:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    64a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    64ab:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    64b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    64b3:	83 f8 0f             	cmp    $0xf,%eax
    64b6:	76 c3                	jbe    647b <print_x64+0x1c>
}
    64b8:	90                   	nop
    64b9:	90                   	nop
    64ba:	c9                   	leaveq 
    64bb:	c3                   	retq   

00000000000064bc <print_x32>:

  static void
print_x32(int fd, uint x)
{
    64bc:	f3 0f 1e fa          	endbr64 
    64c0:	55                   	push   %rbp
    64c1:	48 89 e5             	mov    %rsp,%rbp
    64c4:	48 83 ec 20          	sub    $0x20,%rsp
    64c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
    64cb:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    64ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    64d5:	eb 36                	jmp    650d <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    64d7:	8b 45 e8             	mov    -0x18(%rbp),%eax
    64da:	c1 e8 1c             	shr    $0x1c,%eax
    64dd:	89 c2                	mov    %eax,%edx
    64df:	48 b8 f0 8b 00 00 00 	movabs $0x8bf0,%rax
    64e6:	00 00 00 
    64e9:	89 d2                	mov    %edx,%edx
    64eb:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    64ef:	0f be d0             	movsbl %al,%edx
    64f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
    64f5:	89 d6                	mov    %edx,%esi
    64f7:	89 c7                	mov    %eax,%edi
    64f9:	48 b8 2b 64 00 00 00 	movabs $0x642b,%rax
    6500:	00 00 00 
    6503:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    6505:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    6509:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    650d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    6510:	83 f8 07             	cmp    $0x7,%eax
    6513:	76 c2                	jbe    64d7 <print_x32+0x1b>
}
    6515:	90                   	nop
    6516:	90                   	nop
    6517:	c9                   	leaveq 
    6518:	c3                   	retq   

0000000000006519 <print_d>:

  static void
print_d(int fd, int v)
{
    6519:	f3 0f 1e fa          	endbr64 
    651d:	55                   	push   %rbp
    651e:	48 89 e5             	mov    %rsp,%rbp
    6521:	48 83 ec 30          	sub    $0x30,%rsp
    6525:	89 7d dc             	mov    %edi,-0x24(%rbp)
    6528:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    652b:	8b 45 d8             	mov    -0x28(%rbp),%eax
    652e:	48 98                	cltq   
    6530:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    6534:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    6538:	79 04                	jns    653e <print_d+0x25>
    x = -x;
    653a:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    653e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    6545:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    6549:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    6550:	66 66 66 
    6553:	48 89 c8             	mov    %rcx,%rax
    6556:	48 f7 ea             	imul   %rdx
    6559:	48 c1 fa 02          	sar    $0x2,%rdx
    655d:	48 89 c8             	mov    %rcx,%rax
    6560:	48 c1 f8 3f          	sar    $0x3f,%rax
    6564:	48 29 c2             	sub    %rax,%rdx
    6567:	48 89 d0             	mov    %rdx,%rax
    656a:	48 c1 e0 02          	shl    $0x2,%rax
    656e:	48 01 d0             	add    %rdx,%rax
    6571:	48 01 c0             	add    %rax,%rax
    6574:	48 29 c1             	sub    %rax,%rcx
    6577:	48 89 ca             	mov    %rcx,%rdx
    657a:	8b 45 f4             	mov    -0xc(%rbp),%eax
    657d:	8d 48 01             	lea    0x1(%rax),%ecx
    6580:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    6583:	48 b9 f0 8b 00 00 00 	movabs $0x8bf0,%rcx
    658a:	00 00 00 
    658d:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    6591:	48 98                	cltq   
    6593:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    6597:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    659b:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    65a2:	66 66 66 
    65a5:	48 89 c8             	mov    %rcx,%rax
    65a8:	48 f7 ea             	imul   %rdx
    65ab:	48 c1 fa 02          	sar    $0x2,%rdx
    65af:	48 89 c8             	mov    %rcx,%rax
    65b2:	48 c1 f8 3f          	sar    $0x3f,%rax
    65b6:	48 29 c2             	sub    %rax,%rdx
    65b9:	48 89 d0             	mov    %rdx,%rax
    65bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    65c0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    65c5:	0f 85 7a ff ff ff    	jne    6545 <print_d+0x2c>

  if (v < 0)
    65cb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    65cf:	79 32                	jns    6603 <print_d+0xea>
    buf[i++] = '-';
    65d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
    65d4:	8d 50 01             	lea    0x1(%rax),%edx
    65d7:	89 55 f4             	mov    %edx,-0xc(%rbp)
    65da:	48 98                	cltq   
    65dc:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    65e1:	eb 20                	jmp    6603 <print_d+0xea>
    putc(fd, buf[i]);
    65e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
    65e6:	48 98                	cltq   
    65e8:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    65ed:	0f be d0             	movsbl %al,%edx
    65f0:	8b 45 dc             	mov    -0x24(%rbp),%eax
    65f3:	89 d6                	mov    %edx,%esi
    65f5:	89 c7                	mov    %eax,%edi
    65f7:	48 b8 2b 64 00 00 00 	movabs $0x642b,%rax
    65fe:	00 00 00 
    6601:	ff d0                	callq  *%rax
  while (--i >= 0)
    6603:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    6607:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    660b:	79 d6                	jns    65e3 <print_d+0xca>
}
    660d:	90                   	nop
    660e:	90                   	nop
    660f:	c9                   	leaveq 
    6610:	c3                   	retq   

0000000000006611 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    6611:	f3 0f 1e fa          	endbr64 
    6615:	55                   	push   %rbp
    6616:	48 89 e5             	mov    %rsp,%rbp
    6619:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    6620:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    6626:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    662d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    6634:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    663b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    6642:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    6649:	84 c0                	test   %al,%al
    664b:	74 20                	je     666d <printf+0x5c>
    664d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    6651:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    6655:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    6659:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    665d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    6661:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    6665:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    6669:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    666d:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    6674:	00 00 00 
    6677:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    667e:	00 00 00 
    6681:	48 8d 45 10          	lea    0x10(%rbp),%rax
    6685:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    668c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    6693:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    669a:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    66a1:	00 00 00 
    66a4:	e9 41 03 00 00       	jmpq   69ea <printf+0x3d9>
    if (c != '%') {
    66a9:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    66b0:	74 24                	je     66d6 <printf+0xc5>
      putc(fd, c);
    66b2:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    66b8:	0f be d0             	movsbl %al,%edx
    66bb:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    66c1:	89 d6                	mov    %edx,%esi
    66c3:	89 c7                	mov    %eax,%edi
    66c5:	48 b8 2b 64 00 00 00 	movabs $0x642b,%rax
    66cc:	00 00 00 
    66cf:	ff d0                	callq  *%rax
      continue;
    66d1:	e9 0d 03 00 00       	jmpq   69e3 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    66d6:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    66dd:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    66e3:	48 63 d0             	movslq %eax,%rdx
    66e6:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    66ed:	48 01 d0             	add    %rdx,%rax
    66f0:	0f b6 00             	movzbl (%rax),%eax
    66f3:	0f be c0             	movsbl %al,%eax
    66f6:	25 ff 00 00 00       	and    $0xff,%eax
    66fb:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    6701:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    6708:	0f 84 0f 03 00 00    	je     6a1d <printf+0x40c>
      break;
    switch(c) {
    670e:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    6715:	0f 84 74 02 00 00    	je     698f <printf+0x37e>
    671b:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    6722:	0f 8c 82 02 00 00    	jl     69aa <printf+0x399>
    6728:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    672f:	0f 8f 75 02 00 00    	jg     69aa <printf+0x399>
    6735:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    673c:	0f 8c 68 02 00 00    	jl     69aa <printf+0x399>
    6742:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    6748:	83 e8 63             	sub    $0x63,%eax
    674b:	83 f8 15             	cmp    $0x15,%eax
    674e:	0f 87 56 02 00 00    	ja     69aa <printf+0x399>
    6754:	89 c0                	mov    %eax,%eax
    6756:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    675d:	00 
    675e:	48 b8 b0 83 00 00 00 	movabs $0x83b0,%rax
    6765:	00 00 00 
    6768:	48 01 d0             	add    %rdx,%rax
    676b:	48 8b 00             	mov    (%rax),%rax
    676e:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    6771:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    6777:	83 f8 2f             	cmp    $0x2f,%eax
    677a:	77 23                	ja     679f <printf+0x18e>
    677c:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    6783:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    6789:	89 d2                	mov    %edx,%edx
    678b:	48 01 d0             	add    %rdx,%rax
    678e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    6794:	83 c2 08             	add    $0x8,%edx
    6797:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    679d:	eb 12                	jmp    67b1 <printf+0x1a0>
    679f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    67a6:	48 8d 50 08          	lea    0x8(%rax),%rdx
    67aa:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    67b1:	8b 00                	mov    (%rax),%eax
    67b3:	0f be d0             	movsbl %al,%edx
    67b6:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    67bc:	89 d6                	mov    %edx,%esi
    67be:	89 c7                	mov    %eax,%edi
    67c0:	48 b8 2b 64 00 00 00 	movabs $0x642b,%rax
    67c7:	00 00 00 
    67ca:	ff d0                	callq  *%rax
      break;
    67cc:	e9 12 02 00 00       	jmpq   69e3 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    67d1:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    67d7:	83 f8 2f             	cmp    $0x2f,%eax
    67da:	77 23                	ja     67ff <printf+0x1ee>
    67dc:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    67e3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    67e9:	89 d2                	mov    %edx,%edx
    67eb:	48 01 d0             	add    %rdx,%rax
    67ee:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    67f4:	83 c2 08             	add    $0x8,%edx
    67f7:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    67fd:	eb 12                	jmp    6811 <printf+0x200>
    67ff:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    6806:	48 8d 50 08          	lea    0x8(%rax),%rdx
    680a:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    6811:	8b 10                	mov    (%rax),%edx
    6813:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    6819:	89 d6                	mov    %edx,%esi
    681b:	89 c7                	mov    %eax,%edi
    681d:	48 b8 19 65 00 00 00 	movabs $0x6519,%rax
    6824:	00 00 00 
    6827:	ff d0                	callq  *%rax
      break;
    6829:	e9 b5 01 00 00       	jmpq   69e3 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    682e:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    6834:	83 f8 2f             	cmp    $0x2f,%eax
    6837:	77 23                	ja     685c <printf+0x24b>
    6839:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    6840:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    6846:	89 d2                	mov    %edx,%edx
    6848:	48 01 d0             	add    %rdx,%rax
    684b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    6851:	83 c2 08             	add    $0x8,%edx
    6854:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    685a:	eb 12                	jmp    686e <printf+0x25d>
    685c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    6863:	48 8d 50 08          	lea    0x8(%rax),%rdx
    6867:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    686e:	8b 10                	mov    (%rax),%edx
    6870:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    6876:	89 d6                	mov    %edx,%esi
    6878:	89 c7                	mov    %eax,%edi
    687a:	48 b8 bc 64 00 00 00 	movabs $0x64bc,%rax
    6881:	00 00 00 
    6884:	ff d0                	callq  *%rax
      break;
    6886:	e9 58 01 00 00       	jmpq   69e3 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    688b:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    6891:	83 f8 2f             	cmp    $0x2f,%eax
    6894:	77 23                	ja     68b9 <printf+0x2a8>
    6896:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    689d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    68a3:	89 d2                	mov    %edx,%edx
    68a5:	48 01 d0             	add    %rdx,%rax
    68a8:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    68ae:	83 c2 08             	add    $0x8,%edx
    68b1:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    68b7:	eb 12                	jmp    68cb <printf+0x2ba>
    68b9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    68c0:	48 8d 50 08          	lea    0x8(%rax),%rdx
    68c4:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    68cb:	48 8b 10             	mov    (%rax),%rdx
    68ce:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    68d4:	48 89 d6             	mov    %rdx,%rsi
    68d7:	89 c7                	mov    %eax,%edi
    68d9:	48 b8 5f 64 00 00 00 	movabs $0x645f,%rax
    68e0:	00 00 00 
    68e3:	ff d0                	callq  *%rax
      break;
    68e5:	e9 f9 00 00 00       	jmpq   69e3 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    68ea:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    68f0:	83 f8 2f             	cmp    $0x2f,%eax
    68f3:	77 23                	ja     6918 <printf+0x307>
    68f5:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    68fc:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    6902:	89 d2                	mov    %edx,%edx
    6904:	48 01 d0             	add    %rdx,%rax
    6907:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    690d:	83 c2 08             	add    $0x8,%edx
    6910:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    6916:	eb 12                	jmp    692a <printf+0x319>
    6918:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    691f:	48 8d 50 08          	lea    0x8(%rax),%rdx
    6923:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    692a:	48 8b 00             	mov    (%rax),%rax
    692d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    6934:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    693b:	00 
    693c:	75 41                	jne    697f <printf+0x36e>
        s = "(null)";
    693e:	48 b8 a8 83 00 00 00 	movabs $0x83a8,%rax
    6945:	00 00 00 
    6948:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    694f:	eb 2e                	jmp    697f <printf+0x36e>
        putc(fd, *(s++));
    6951:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    6958:	48 8d 50 01          	lea    0x1(%rax),%rdx
    695c:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    6963:	0f b6 00             	movzbl (%rax),%eax
    6966:	0f be d0             	movsbl %al,%edx
    6969:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    696f:	89 d6                	mov    %edx,%esi
    6971:	89 c7                	mov    %eax,%edi
    6973:	48 b8 2b 64 00 00 00 	movabs $0x642b,%rax
    697a:	00 00 00 
    697d:	ff d0                	callq  *%rax
      while (*s)
    697f:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    6986:	0f b6 00             	movzbl (%rax),%eax
    6989:	84 c0                	test   %al,%al
    698b:	75 c4                	jne    6951 <printf+0x340>
      break;
    698d:	eb 54                	jmp    69e3 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    698f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    6995:	be 25 00 00 00       	mov    $0x25,%esi
    699a:	89 c7                	mov    %eax,%edi
    699c:	48 b8 2b 64 00 00 00 	movabs $0x642b,%rax
    69a3:	00 00 00 
    69a6:	ff d0                	callq  *%rax
      break;
    69a8:	eb 39                	jmp    69e3 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    69aa:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    69b0:	be 25 00 00 00       	mov    $0x25,%esi
    69b5:	89 c7                	mov    %eax,%edi
    69b7:	48 b8 2b 64 00 00 00 	movabs $0x642b,%rax
    69be:	00 00 00 
    69c1:	ff d0                	callq  *%rax
      putc(fd, c);
    69c3:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    69c9:	0f be d0             	movsbl %al,%edx
    69cc:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    69d2:	89 d6                	mov    %edx,%esi
    69d4:	89 c7                	mov    %eax,%edi
    69d6:	48 b8 2b 64 00 00 00 	movabs $0x642b,%rax
    69dd:	00 00 00 
    69e0:	ff d0                	callq  *%rax
      break;
    69e2:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    69e3:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    69ea:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    69f0:	48 63 d0             	movslq %eax,%rdx
    69f3:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    69fa:	48 01 d0             	add    %rdx,%rax
    69fd:	0f b6 00             	movzbl (%rax),%eax
    6a00:	0f be c0             	movsbl %al,%eax
    6a03:	25 ff 00 00 00       	and    $0xff,%eax
    6a08:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    6a0e:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    6a15:	0f 85 8e fc ff ff    	jne    66a9 <printf+0x98>
    }
  }
}
    6a1b:	eb 01                	jmp    6a1e <printf+0x40d>
      break;
    6a1d:	90                   	nop
}
    6a1e:	90                   	nop
    6a1f:	c9                   	leaveq 
    6a20:	c3                   	retq   

0000000000006a21 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    6a21:	f3 0f 1e fa          	endbr64 
    6a25:	55                   	push   %rbp
    6a26:	48 89 e5             	mov    %rsp,%rbp
    6a29:	48 83 ec 18          	sub    $0x18,%rsp
    6a2d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    6a31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    6a35:	48 83 e8 10          	sub    $0x10,%rax
    6a39:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6a3d:	48 b8 70 d4 00 00 00 	movabs $0xd470,%rax
    6a44:	00 00 00 
    6a47:	48 8b 00             	mov    (%rax),%rax
    6a4a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    6a4e:	eb 2f                	jmp    6a7f <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6a50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6a54:	48 8b 00             	mov    (%rax),%rax
    6a57:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    6a5b:	72 17                	jb     6a74 <free+0x53>
    6a5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6a61:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    6a65:	77 2f                	ja     6a96 <free+0x75>
    6a67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6a6b:	48 8b 00             	mov    (%rax),%rax
    6a6e:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    6a72:	72 22                	jb     6a96 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6a74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6a78:	48 8b 00             	mov    (%rax),%rax
    6a7b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    6a7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6a83:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    6a87:	76 c7                	jbe    6a50 <free+0x2f>
    6a89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6a8d:	48 8b 00             	mov    (%rax),%rax
    6a90:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    6a94:	73 ba                	jae    6a50 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    6a96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6a9a:	8b 40 08             	mov    0x8(%rax),%eax
    6a9d:	89 c0                	mov    %eax,%eax
    6a9f:	48 c1 e0 04          	shl    $0x4,%rax
    6aa3:	48 89 c2             	mov    %rax,%rdx
    6aa6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6aaa:	48 01 c2             	add    %rax,%rdx
    6aad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6ab1:	48 8b 00             	mov    (%rax),%rax
    6ab4:	48 39 c2             	cmp    %rax,%rdx
    6ab7:	75 2d                	jne    6ae6 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    6ab9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6abd:	8b 50 08             	mov    0x8(%rax),%edx
    6ac0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6ac4:	48 8b 00             	mov    (%rax),%rax
    6ac7:	8b 40 08             	mov    0x8(%rax),%eax
    6aca:	01 c2                	add    %eax,%edx
    6acc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6ad0:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    6ad3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6ad7:	48 8b 00             	mov    (%rax),%rax
    6ada:	48 8b 10             	mov    (%rax),%rdx
    6add:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6ae1:	48 89 10             	mov    %rdx,(%rax)
    6ae4:	eb 0e                	jmp    6af4 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    6ae6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6aea:	48 8b 10             	mov    (%rax),%rdx
    6aed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6af1:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    6af4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6af8:	8b 40 08             	mov    0x8(%rax),%eax
    6afb:	89 c0                	mov    %eax,%eax
    6afd:	48 c1 e0 04          	shl    $0x4,%rax
    6b01:	48 89 c2             	mov    %rax,%rdx
    6b04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6b08:	48 01 d0             	add    %rdx,%rax
    6b0b:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    6b0f:	75 27                	jne    6b38 <free+0x117>
    p->s.size += bp->s.size;
    6b11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6b15:	8b 50 08             	mov    0x8(%rax),%edx
    6b18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6b1c:	8b 40 08             	mov    0x8(%rax),%eax
    6b1f:	01 c2                	add    %eax,%edx
    6b21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6b25:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    6b28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6b2c:	48 8b 10             	mov    (%rax),%rdx
    6b2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6b33:	48 89 10             	mov    %rdx,(%rax)
    6b36:	eb 0b                	jmp    6b43 <free+0x122>
  } else
    p->s.ptr = bp;
    6b38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6b3c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    6b40:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    6b43:	48 ba 70 d4 00 00 00 	movabs $0xd470,%rdx
    6b4a:	00 00 00 
    6b4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6b51:	48 89 02             	mov    %rax,(%rdx)
}
    6b54:	90                   	nop
    6b55:	c9                   	leaveq 
    6b56:	c3                   	retq   

0000000000006b57 <morecore>:

static Header*
morecore(uint nu)
{
    6b57:	f3 0f 1e fa          	endbr64 
    6b5b:	55                   	push   %rbp
    6b5c:	48 89 e5             	mov    %rsp,%rbp
    6b5f:	48 83 ec 20          	sub    $0x20,%rsp
    6b63:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    6b66:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    6b6d:	77 07                	ja     6b76 <morecore+0x1f>
    nu = 4096;
    6b6f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    6b76:	8b 45 ec             	mov    -0x14(%rbp),%eax
    6b79:	48 c1 e0 04          	shl    $0x4,%rax
    6b7d:	48 89 c7             	mov    %rax,%rdi
    6b80:	48 b8 ea 63 00 00 00 	movabs $0x63ea,%rax
    6b87:	00 00 00 
    6b8a:	ff d0                	callq  *%rax
    6b8c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    6b90:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    6b95:	75 07                	jne    6b9e <morecore+0x47>
    return 0;
    6b97:	b8 00 00 00 00       	mov    $0x0,%eax
    6b9c:	eb 36                	jmp    6bd4 <morecore+0x7d>
  hp = (Header*)p;
    6b9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6ba2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    6ba6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6baa:	8b 55 ec             	mov    -0x14(%rbp),%edx
    6bad:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    6bb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6bb4:	48 83 c0 10          	add    $0x10,%rax
    6bb8:	48 89 c7             	mov    %rax,%rdi
    6bbb:	48 b8 21 6a 00 00 00 	movabs $0x6a21,%rax
    6bc2:	00 00 00 
    6bc5:	ff d0                	callq  *%rax
  return freep;
    6bc7:	48 b8 70 d4 00 00 00 	movabs $0xd470,%rax
    6bce:	00 00 00 
    6bd1:	48 8b 00             	mov    (%rax),%rax
}
    6bd4:	c9                   	leaveq 
    6bd5:	c3                   	retq   

0000000000006bd6 <malloc>:

void*
malloc(uint nbytes)
{
    6bd6:	f3 0f 1e fa          	endbr64 
    6bda:	55                   	push   %rbp
    6bdb:	48 89 e5             	mov    %rsp,%rbp
    6bde:	48 83 ec 30          	sub    $0x30,%rsp
    6be2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    6be5:	8b 45 dc             	mov    -0x24(%rbp),%eax
    6be8:	48 83 c0 0f          	add    $0xf,%rax
    6bec:	48 c1 e8 04          	shr    $0x4,%rax
    6bf0:	83 c0 01             	add    $0x1,%eax
    6bf3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    6bf6:	48 b8 70 d4 00 00 00 	movabs $0xd470,%rax
    6bfd:	00 00 00 
    6c00:	48 8b 00             	mov    (%rax),%rax
    6c03:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    6c07:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    6c0c:	75 4a                	jne    6c58 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    6c0e:	48 b8 60 d4 00 00 00 	movabs $0xd460,%rax
    6c15:	00 00 00 
    6c18:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    6c1c:	48 ba 70 d4 00 00 00 	movabs $0xd470,%rdx
    6c23:	00 00 00 
    6c26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6c2a:	48 89 02             	mov    %rax,(%rdx)
    6c2d:	48 b8 70 d4 00 00 00 	movabs $0xd470,%rax
    6c34:	00 00 00 
    6c37:	48 8b 00             	mov    (%rax),%rax
    6c3a:	48 ba 60 d4 00 00 00 	movabs $0xd460,%rdx
    6c41:	00 00 00 
    6c44:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    6c47:	48 b8 60 d4 00 00 00 	movabs $0xd460,%rax
    6c4e:	00 00 00 
    6c51:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6c58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6c5c:	48 8b 00             	mov    (%rax),%rax
    6c5f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    6c63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6c67:	8b 40 08             	mov    0x8(%rax),%eax
    6c6a:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    6c6d:	77 65                	ja     6cd4 <malloc+0xfe>
      if(p->s.size == nunits)
    6c6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6c73:	8b 40 08             	mov    0x8(%rax),%eax
    6c76:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    6c79:	75 10                	jne    6c8b <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    6c7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6c7f:	48 8b 10             	mov    (%rax),%rdx
    6c82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6c86:	48 89 10             	mov    %rdx,(%rax)
    6c89:	eb 2e                	jmp    6cb9 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    6c8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6c8f:	8b 40 08             	mov    0x8(%rax),%eax
    6c92:	2b 45 ec             	sub    -0x14(%rbp),%eax
    6c95:	89 c2                	mov    %eax,%edx
    6c97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6c9b:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    6c9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6ca2:	8b 40 08             	mov    0x8(%rax),%eax
    6ca5:	89 c0                	mov    %eax,%eax
    6ca7:	48 c1 e0 04          	shl    $0x4,%rax
    6cab:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    6caf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6cb3:	8b 55 ec             	mov    -0x14(%rbp),%edx
    6cb6:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    6cb9:	48 ba 70 d4 00 00 00 	movabs $0xd470,%rdx
    6cc0:	00 00 00 
    6cc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6cc7:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    6cca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6cce:	48 83 c0 10          	add    $0x10,%rax
    6cd2:	eb 4e                	jmp    6d22 <malloc+0x14c>
    }
    if(p == freep)
    6cd4:	48 b8 70 d4 00 00 00 	movabs $0xd470,%rax
    6cdb:	00 00 00 
    6cde:	48 8b 00             	mov    (%rax),%rax
    6ce1:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    6ce5:	75 23                	jne    6d0a <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    6ce7:	8b 45 ec             	mov    -0x14(%rbp),%eax
    6cea:	89 c7                	mov    %eax,%edi
    6cec:	48 b8 57 6b 00 00 00 	movabs $0x6b57,%rax
    6cf3:	00 00 00 
    6cf6:	ff d0                	callq  *%rax
    6cf8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    6cfc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    6d01:	75 07                	jne    6d0a <malloc+0x134>
        return 0;
    6d03:	b8 00 00 00 00       	mov    $0x0,%eax
    6d08:	eb 18                	jmp    6d22 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6d0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6d0e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    6d12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6d16:	48 8b 00             	mov    (%rax),%rax
    6d19:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    6d1d:	e9 41 ff ff ff       	jmpq   6c63 <malloc+0x8d>
  }
}
    6d22:	c9                   	leaveq 
    6d23:	c3                   	retq   
