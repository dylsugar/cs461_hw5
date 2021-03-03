
kernel:     file format elf64-x86-64


Disassembly of section .text:

ffff800000100000 <begin>:
ffff800000100000:	02 b0 ad 1b 00 00    	add    0x1bad(%rax),%dh
ffff800000100006:	01 00                	add    %eax,(%rax)
ffff800000100008:	fe 4f 51             	decb   0x51(%rdi)
ffff80000010000b:	e4 00                	in     $0x0,%al
ffff80000010000d:	00 10                	add    %dl,(%rax)
ffff80000010000f:	00 00                	add    %al,(%rax)
ffff800000100011:	00 10                	add    %dl,(%rax)
ffff800000100013:	00 00                	add    %al,(%rax)
ffff800000100015:	e0 10                	loopne ffff800000100027 <mboot_entry+0x7>
ffff800000100017:	00 00                	add    %al,(%rax)
ffff800000100019:	b0 1f                	mov    $0x1f,%al
ffff80000010001b:	00 20                	add    %ah,(%rax)
ffff80000010001d:	00 10                	add    %dl,(%rax)
	...

ffff800000100020 <mboot_entry>:
  .long mboot_entry_addr

.code32
mboot_entry:
# zero 2 pages for our bootstrap page tables
  xor     %eax, %eax    # value=0
ffff800000100020:	31 c0                	xor    %eax,%eax
  mov     $0x1000, %edi # starting at 4096
ffff800000100022:	bf 00 10 00 00       	mov    $0x1000,%edi
  mov     $0x2000, %ecx # size=8192
ffff800000100027:	b9 00 20 00 00       	mov    $0x2000,%ecx
  rep     stosb         # memset(4096, 0, 8192)
ffff80000010002c:	f3 aa                	rep stos %al,%es:(%rdi)

# map both virtual address 0 and KERNBASE to the same PDPT
# PML4T[0] -> 0x2000 (PDPT)
# PML4T[256] -> 0x2000 (PDPT)
  mov     $(0x2000 | PTE_P | PTE_W), %eax
ffff80000010002e:	b8 03 20 00 00       	mov    $0x2003,%eax
  mov     %eax, 0x1000  # PML4T[0]
ffff800000100033:	a3 00 10 00 00 a3 00 	movabs %eax,0x1800a300001000
ffff80000010003a:	18 00 
  mov     %eax, 0x1800  # PML4T[512]
ffff80000010003c:	00 b8 83 00 00 00    	add    %bh,0x83(%rax)

# PDPT[0] -> 0x0 (1 GB flat map page)
  mov     $(0x0 | PTE_P | PTE_PS | PTE_W), %eax
  mov     %eax, 0x2000  # PDPT[0]
ffff800000100042:	a3                   	.byte 0xa3
ffff800000100043:	00 20                	add    %ah,(%rax)
ffff800000100045:	00 00                	add    %al,(%rax)

# Clear ebx for initial processor boot.
# When secondary processors boot, they'll call through
# entry32mp (from entryother), but with a nonzero ebx.
# We'll reuse these bootstrap pagetables and GDT.
  xor     %ebx, %ebx
ffff800000100047:	31 db                	xor    %ebx,%ebx

ffff800000100049 <entry32mp>:

.global entry32mp
entry32mp:
# CR3 -> 0x1000 (PML4T)
  mov     $0x1000, %eax
ffff800000100049:	b8 00 10 00 00       	mov    $0x1000,%eax
  mov     %eax, %cr3
ffff80000010004e:	0f 22 d8             	mov    %rax,%cr3

  lgdt    (gdtr64 - mboot_header + mboot_load_addr)
ffff800000100051:	0f 01 15 90 00 10 00 	lgdt   0x100090(%rip)        # ffff8000002000e8 <end+0x50e8>

# PAE is required for 64-bit paging: CR4.PAE=1
  mov     %cr4, %eax
ffff800000100058:	0f 20 e0             	mov    %cr4,%rax
  bts     $5, %eax
ffff80000010005b:	0f ba e8 05          	bts    $0x5,%eax
  mov     %eax, %cr4
ffff80000010005f:	0f 22 e0             	mov    %rax,%cr4

# access EFER Model specific register
  mov     $MSR_EFER, %ecx
ffff800000100062:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
  rdmsr
ffff800000100067:	0f 32                	rdmsr  
  bts     $0, %eax #enable system call extentions
ffff800000100069:	0f ba e8 00          	bts    $0x0,%eax
  bts     $8, %eax #enable long mode
ffff80000010006d:	0f ba e8 08          	bts    $0x8,%eax
  wrmsr
ffff800000100071:	0f 30                	wrmsr  

# enable paging
  mov     %cr0, %eax
ffff800000100073:	0f 20 c0             	mov    %cr0,%rax
  orl     $(CR0_PG | CR0_WP | CR0_MP), %eax
ffff800000100076:	0d 02 00 01 80       	or     $0x80010002,%eax
  mov     %eax, %cr0
ffff80000010007b:	0f 22 c0             	mov    %rax,%cr0

# shift to 64bit segment
  ljmp    $8, $(entry64low - mboot_header + mboot_load_addr)
ffff80000010007e:	ea                   	(bad)  
ffff80000010007f:	c0 00 10             	rolb   $0x10,(%rax)
ffff800000100082:	00 08                	add    %cl,(%rax)
ffff800000100084:	00 66 66             	add    %ah,0x66(%rsi)
ffff800000100087:	2e 0f 1f 84 00 00 00 	nopl   %cs:0x0(%rax,%rax,1)
ffff80000010008e:	00 00 

ffff800000100090 <gdtr64>:
ffff800000100090:	17                   	(bad)  
ffff800000100091:	00 a0 00 10 00 00    	add    %ah,0x1000(%rax)
ffff800000100097:	00 00                	add    %al,(%rax)
ffff800000100099:	00 66 0f             	add    %ah,0xf(%rsi)
ffff80000010009c:	1f                   	(bad)  
ffff80000010009d:	44 00 00             	add    %r8b,(%rax)

ffff8000001000a0 <gdt64_begin>:
	...
ffff8000001000ac:	00 98 20 00 00 00    	add    %bl,0x20(%rax)
ffff8000001000b2:	00 00                	add    %al,(%rax)
ffff8000001000b4:	00                   	.byte 0x0
ffff8000001000b5:	90                   	nop
	...

ffff8000001000b8 <gdt64_end>:
ffff8000001000b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
ffff8000001000bf:	00 

ffff8000001000c0 <entry64low>:
gdt64_end:

.align 16
.code64
entry64low:
  movabs  $entry64high, %rax
ffff8000001000c0:	48 b8 cc 00 10 00 00 	movabs $0xffff8000001000cc,%rax
ffff8000001000c7:	80 ff ff 
  jmp     *%rax
ffff8000001000ca:	ff e0                	jmpq   *%rax

ffff8000001000cc <_start>:
.global _start
_start:
entry64high:

# ensure data segment registers are sane
  xor     %rax, %rax
ffff8000001000cc:	48 31 c0             	xor    %rax,%rax
  mov     %ax, %ss
ffff8000001000cf:	8e d0                	mov    %eax,%ss
  mov     %ax, %ds
ffff8000001000d1:	8e d8                	mov    %eax,%ds
  mov     %ax, %es
ffff8000001000d3:	8e c0                	mov    %eax,%es
  mov     %ax, %fs
ffff8000001000d5:	8e e0                	mov    %eax,%fs
  mov     %ax, %gs
ffff8000001000d7:	8e e8                	mov    %eax,%gs
  # mov     %cr4, %rax
  # or      $(CR4_PAE | CR4_OSXFSR | CR4_OSXMMEXCPT) , %rax
  # mov     %rax, %cr4

# check to see if we're booting a secondary core
  test    %ebx, %ebx
ffff8000001000d9:	85 db                	test   %ebx,%ebx
  jnz     entry64mp  # jump if booting a secondary code
ffff8000001000db:	75 14                	jne    ffff8000001000f1 <entry64mp>
# setup initial stack
  movabs  $0xFFFF800000010000, %rax
ffff8000001000dd:	48 b8 00 00 01 00 00 	movabs $0xffff800000010000,%rax
ffff8000001000e4:	80 ff ff 
  mov     %rax, %rsp
ffff8000001000e7:	48 89 c4             	mov    %rax,%rsp

# enter main()
  jmp     main  # end of initial (the first) core ASM
ffff8000001000ea:	e9 d7 56 00 00       	jmpq   ffff8000001057c6 <main>

ffff8000001000ef <__deadloop>:

.global __deadloop
__deadloop:
# we should never return here...
  jmp     .
ffff8000001000ef:	eb fe                	jmp    ffff8000001000ef <__deadloop>

ffff8000001000f1 <entry64mp>:

entry64mp:
# obtain kstack from data block before entryother
  mov     $0x7000, %rax
ffff8000001000f1:	48 c7 c0 00 70 00 00 	mov    $0x7000,%rax
  mov     -16(%rax), %rsp
ffff8000001000f8:	48 8b 60 f0          	mov    -0x10(%rax),%rsp
  jmp     mpenter  # end of secondary code ASM
ffff8000001000fc:	e9 f6 57 00 00       	jmpq   ffff8000001058f7 <mpenter>

ffff800000100101 <wrmsr>:

.global wrmsr
wrmsr:
  mov     %rdi, %rcx     # arg0 -> msrnum
ffff800000100101:	48 89 f9             	mov    %rdi,%rcx
  mov     %rsi, %rax     # val.low -> eax
ffff800000100104:	48 89 f0             	mov    %rsi,%rax
  shr     $32, %rsi
ffff800000100107:	48 c1 ee 20          	shr    $0x20,%rsi
  mov     %rsi, %rdx     # val.high -> edx
ffff80000010010b:	48 89 f2             	mov    %rsi,%rdx
  wrmsr
ffff80000010010e:	0f 30                	wrmsr  
  retq
ffff800000100110:	c3                   	retq   

ffff800000100111 <ignore_sysret>:

.global ignore_sysret
ignore_sysret: #return error code 38, meaning function unimplemented
  mov     $-38, %rax
ffff800000100111:	48 c7 c0 da ff ff ff 	mov    $0xffffffffffffffda,%rax
  sysret
ffff800000100118:	0f 07                	sysret 

ffff80000010011a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
ffff80000010011a:	f3 0f 1e fa          	endbr64 
ffff80000010011e:	55                   	push   %rbp
ffff80000010011f:	48 89 e5             	mov    %rsp,%rbp
ffff800000100122:	48 83 ec 10          	sub    $0x10,%rsp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
ffff800000100126:	48 be b8 c4 10 00 00 	movabs $0xffff80000010c4b8,%rsi
ffff80000010012d:	80 ff ff 
ffff800000100130:	48 bf 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdi
ffff800000100137:	80 ff ff 
ffff80000010013a:	48 b8 24 78 10 00 00 	movabs $0xffff800000107824,%rax
ffff800000100141:	80 ff ff 
ffff800000100144:	ff d0                	callq  *%rax
//PAGEBREAK!

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
ffff800000100146:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff80000010014d:	80 ff ff 
ffff800000100150:	48 b9 08 31 11 00 00 	movabs $0xffff800000113108,%rcx
ffff800000100157:	80 ff ff 
ffff80000010015a:	48 89 88 a0 51 00 00 	mov    %rcx,0x51a0(%rax)
  bcache.head.next = &bcache.head;
ffff800000100161:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff800000100168:	80 ff ff 
ffff80000010016b:	48 89 88 a8 51 00 00 	mov    %rcx,0x51a8(%rax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
ffff800000100172:	48 b8 68 e0 10 00 00 	movabs $0xffff80000010e068,%rax
ffff800000100179:	80 ff ff 
ffff80000010017c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000100180:	e9 8b 00 00 00       	jmpq   ffff800000100210 <binit+0xf6>
    b->next = bcache.head.next;
ffff800000100185:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff80000010018c:	80 ff ff 
ffff80000010018f:	48 8b 90 a8 51 00 00 	mov    0x51a8(%rax),%rdx
ffff800000100196:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010019a:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    b->prev = &bcache.head;
ffff8000001001a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001001a5:	48 be 08 31 11 00 00 	movabs $0xffff800000113108,%rsi
ffff8000001001ac:	80 ff ff 
ffff8000001001af:	48 89 b0 98 00 00 00 	mov    %rsi,0x98(%rax)
    initsleeplock(&b->lock, "buffer");
ffff8000001001b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001001ba:	48 83 c0 10          	add    $0x10,%rax
ffff8000001001be:	48 be bf c4 10 00 00 	movabs $0xffff80000010c4bf,%rsi
ffff8000001001c5:	80 ff ff 
ffff8000001001c8:	48 89 c7             	mov    %rax,%rdi
ffff8000001001cb:	48 b8 31 76 10 00 00 	movabs $0xffff800000107631,%rax
ffff8000001001d2:	80 ff ff 
ffff8000001001d5:	ff d0                	callq  *%rax
    bcache.head.next->prev = b;
ffff8000001001d7:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff8000001001de:	80 ff ff 
ffff8000001001e1:	48 8b 80 a8 51 00 00 	mov    0x51a8(%rax),%rax
ffff8000001001e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001001ec:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
    bcache.head.next = b;
ffff8000001001f3:	48 ba 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdx
ffff8000001001fa:	80 ff ff 
ffff8000001001fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100201:	48 89 82 a8 51 00 00 	mov    %rax,0x51a8(%rdx)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
ffff800000100208:	48 81 45 f8 b0 02 00 	addq   $0x2b0,-0x8(%rbp)
ffff80000010020f:	00 
ffff800000100210:	48 b8 08 31 11 00 00 	movabs $0xffff800000113108,%rax
ffff800000100217:	80 ff ff 
ffff80000010021a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff80000010021e:	0f 82 61 ff ff ff    	jb     ffff800000100185 <binit+0x6b>
  }
}
ffff800000100224:	90                   	nop
ffff800000100225:	90                   	nop
ffff800000100226:	c9                   	leaveq 
ffff800000100227:	c3                   	retq   

ffff800000100228 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
ffff800000100228:	f3 0f 1e fa          	endbr64 
ffff80000010022c:	55                   	push   %rbp
ffff80000010022d:	48 89 e5             	mov    %rsp,%rbp
ffff800000100230:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000100234:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000100237:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct buf *b;

  acquire(&bcache.lock);
ffff80000010023a:	48 bf 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdi
ffff800000100241:	80 ff ff 
ffff800000100244:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff80000010024b:	80 ff ff 
ffff80000010024e:	ff d0                	callq  *%rax

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
ffff800000100250:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff800000100257:	80 ff ff 
ffff80000010025a:	48 8b 80 a8 51 00 00 	mov    0x51a8(%rax),%rax
ffff800000100261:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000100265:	eb 74                	jmp    ffff8000001002db <bget+0xb3>
    if(b->dev == dev && b->blockno == blockno){
ffff800000100267:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010026b:	8b 40 04             	mov    0x4(%rax),%eax
ffff80000010026e:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff800000100271:	75 59                	jne    ffff8000001002cc <bget+0xa4>
ffff800000100273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100277:	8b 40 08             	mov    0x8(%rax),%eax
ffff80000010027a:	39 45 e8             	cmp    %eax,-0x18(%rbp)
ffff80000010027d:	75 4d                	jne    ffff8000001002cc <bget+0xa4>
      b->refcnt++;
ffff80000010027f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100283:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000100289:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010028c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100290:	89 90 90 00 00 00    	mov    %edx,0x90(%rax)
      release(&bcache.lock);
ffff800000100296:	48 bf 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdi
ffff80000010029d:	80 ff ff 
ffff8000001002a0:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001002a7:	80 ff ff 
ffff8000001002aa:	ff d0                	callq  *%rax
      acquiresleep(&b->lock);
ffff8000001002ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001002b0:	48 83 c0 10          	add    $0x10,%rax
ffff8000001002b4:	48 89 c7             	mov    %rax,%rdi
ffff8000001002b7:	48 b8 8a 76 10 00 00 	movabs $0xffff80000010768a,%rax
ffff8000001002be:	80 ff ff 
ffff8000001002c1:	ff d0                	callq  *%rax
      return b;
ffff8000001002c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001002c7:	e9 f0 00 00 00       	jmpq   ffff8000001003bc <bget+0x194>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
ffff8000001002cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001002d0:	48 8b 80 a0 00 00 00 	mov    0xa0(%rax),%rax
ffff8000001002d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001002db:	48 b8 08 31 11 00 00 	movabs $0xffff800000113108,%rax
ffff8000001002e2:	80 ff ff 
ffff8000001002e5:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001002e9:	0f 85 78 ff ff ff    	jne    ffff800000100267 <bget+0x3f>
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
ffff8000001002ef:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff8000001002f6:	80 ff ff 
ffff8000001002f9:	48 8b 80 a0 51 00 00 	mov    0x51a0(%rax),%rax
ffff800000100300:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000100304:	e9 89 00 00 00       	jmpq   ffff800000100392 <bget+0x16a>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
ffff800000100309:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010030d:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000100313:	85 c0                	test   %eax,%eax
ffff800000100315:	75 6c                	jne    ffff800000100383 <bget+0x15b>
ffff800000100317:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010031b:	8b 00                	mov    (%rax),%eax
ffff80000010031d:	83 e0 04             	and    $0x4,%eax
ffff800000100320:	85 c0                	test   %eax,%eax
ffff800000100322:	75 5f                	jne    ffff800000100383 <bget+0x15b>
      b->dev = dev;
ffff800000100324:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100328:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff80000010032b:	89 50 04             	mov    %edx,0x4(%rax)
      b->blockno = blockno;
ffff80000010032e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100332:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff800000100335:	89 50 08             	mov    %edx,0x8(%rax)
      b->flags = 0;
ffff800000100338:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010033c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
      b->refcnt = 1;
ffff800000100342:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100346:	c7 80 90 00 00 00 01 	movl   $0x1,0x90(%rax)
ffff80000010034d:	00 00 00 
      release(&bcache.lock);
ffff800000100350:	48 bf 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdi
ffff800000100357:	80 ff ff 
ffff80000010035a:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000100361:	80 ff ff 
ffff800000100364:	ff d0                	callq  *%rax
      acquiresleep(&b->lock);
ffff800000100366:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010036a:	48 83 c0 10          	add    $0x10,%rax
ffff80000010036e:	48 89 c7             	mov    %rax,%rdi
ffff800000100371:	48 b8 8a 76 10 00 00 	movabs $0xffff80000010768a,%rax
ffff800000100378:	80 ff ff 
ffff80000010037b:	ff d0                	callq  *%rax
      return b;
ffff80000010037d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100381:	eb 39                	jmp    ffff8000001003bc <bget+0x194>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
ffff800000100383:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100387:	48 8b 80 98 00 00 00 	mov    0x98(%rax),%rax
ffff80000010038e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000100392:	48 b8 08 31 11 00 00 	movabs $0xffff800000113108,%rax
ffff800000100399:	80 ff ff 
ffff80000010039c:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001003a0:	0f 85 63 ff ff ff    	jne    ffff800000100309 <bget+0xe1>
    }
  }
  panic("bget: no buffers");
ffff8000001003a6:	48 bf c6 c4 10 00 00 	movabs $0xffff80000010c4c6,%rdi
ffff8000001003ad:	80 ff ff 
ffff8000001003b0:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001003b7:	80 ff ff 
ffff8000001003ba:	ff d0                	callq  *%rax
}
ffff8000001003bc:	c9                   	leaveq 
ffff8000001003bd:	c3                   	retq   

ffff8000001003be <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
ffff8000001003be:	f3 0f 1e fa          	endbr64 
ffff8000001003c2:	55                   	push   %rbp
ffff8000001003c3:	48 89 e5             	mov    %rsp,%rbp
ffff8000001003c6:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001003ca:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff8000001003cd:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct buf *b;

  b = bget(dev, blockno);
ffff8000001003d0:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff8000001003d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001003d6:	89 d6                	mov    %edx,%esi
ffff8000001003d8:	89 c7                	mov    %eax,%edi
ffff8000001003da:	48 b8 28 02 10 00 00 	movabs $0xffff800000100228,%rax
ffff8000001003e1:	80 ff ff 
ffff8000001003e4:	ff d0                	callq  *%rax
ffff8000001003e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(!(b->flags & B_VALID)) {
ffff8000001003ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001003ee:	8b 00                	mov    (%rax),%eax
ffff8000001003f0:	83 e0 02             	and    $0x2,%eax
ffff8000001003f3:	85 c0                	test   %eax,%eax
ffff8000001003f5:	75 13                	jne    ffff80000010040a <bread+0x4c>
    iderw(b);
ffff8000001003f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001003fb:	48 89 c7             	mov    %rax,%rdi
ffff8000001003fe:	48 b8 37 3d 10 00 00 	movabs $0xffff800000103d37,%rax
ffff800000100405:	80 ff ff 
ffff800000100408:	ff d0                	callq  *%rax
  }
  return b;
ffff80000010040a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff80000010040e:	c9                   	leaveq 
ffff80000010040f:	c3                   	retq   

ffff800000100410 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
ffff800000100410:	f3 0f 1e fa          	endbr64 
ffff800000100414:	55                   	push   %rbp
ffff800000100415:	48 89 e5             	mov    %rsp,%rbp
ffff800000100418:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010041c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(!holdingsleep(&b->lock))
ffff800000100420:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100424:	48 83 c0 10          	add    $0x10,%rax
ffff800000100428:	48 89 c7             	mov    %rax,%rdi
ffff80000010042b:	48 b8 7d 77 10 00 00 	movabs $0xffff80000010777d,%rax
ffff800000100432:	80 ff ff 
ffff800000100435:	ff d0                	callq  *%rax
ffff800000100437:	85 c0                	test   %eax,%eax
ffff800000100439:	75 16                	jne    ffff800000100451 <bwrite+0x41>
    panic("bwrite");
ffff80000010043b:	48 bf d7 c4 10 00 00 	movabs $0xffff80000010c4d7,%rdi
ffff800000100442:	80 ff ff 
ffff800000100445:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010044c:	80 ff ff 
ffff80000010044f:	ff d0                	callq  *%rax
  b->flags |= B_DIRTY;
ffff800000100451:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100455:	8b 00                	mov    (%rax),%eax
ffff800000100457:	83 c8 04             	or     $0x4,%eax
ffff80000010045a:	89 c2                	mov    %eax,%edx
ffff80000010045c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100460:	89 10                	mov    %edx,(%rax)
  iderw(b);
ffff800000100462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100466:	48 89 c7             	mov    %rax,%rdi
ffff800000100469:	48 b8 37 3d 10 00 00 	movabs $0xffff800000103d37,%rax
ffff800000100470:	80 ff ff 
ffff800000100473:	ff d0                	callq  *%rax
}
ffff800000100475:	90                   	nop
ffff800000100476:	c9                   	leaveq 
ffff800000100477:	c3                   	retq   

ffff800000100478 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
ffff800000100478:	f3 0f 1e fa          	endbr64 
ffff80000010047c:	55                   	push   %rbp
ffff80000010047d:	48 89 e5             	mov    %rsp,%rbp
ffff800000100480:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000100484:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(!holdingsleep(&b->lock))
ffff800000100488:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010048c:	48 83 c0 10          	add    $0x10,%rax
ffff800000100490:	48 89 c7             	mov    %rax,%rdi
ffff800000100493:	48 b8 7d 77 10 00 00 	movabs $0xffff80000010777d,%rax
ffff80000010049a:	80 ff ff 
ffff80000010049d:	ff d0                	callq  *%rax
ffff80000010049f:	85 c0                	test   %eax,%eax
ffff8000001004a1:	75 16                	jne    ffff8000001004b9 <brelse+0x41>
    panic("brelse");
ffff8000001004a3:	48 bf de c4 10 00 00 	movabs $0xffff80000010c4de,%rdi
ffff8000001004aa:	80 ff ff 
ffff8000001004ad:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001004b4:	80 ff ff 
ffff8000001004b7:	ff d0                	callq  *%rax

  releasesleep(&b->lock);
ffff8000001004b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001004bd:	48 83 c0 10          	add    $0x10,%rax
ffff8000001004c1:	48 89 c7             	mov    %rax,%rdi
ffff8000001004c4:	48 b8 14 77 10 00 00 	movabs $0xffff800000107714,%rax
ffff8000001004cb:	80 ff ff 
ffff8000001004ce:	ff d0                	callq  *%rax

  acquire(&bcache.lock);
ffff8000001004d0:	48 bf 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdi
ffff8000001004d7:	80 ff ff 
ffff8000001004da:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff8000001004e1:	80 ff ff 
ffff8000001004e4:	ff d0                	callq  *%rax
  b->refcnt--;
ffff8000001004e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001004ea:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff8000001004f0:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff8000001004f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001004f7:	89 90 90 00 00 00    	mov    %edx,0x90(%rax)
  if (b->refcnt == 0) {
ffff8000001004fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100501:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000100507:	85 c0                	test   %eax,%eax
ffff800000100509:	0f 85 9c 00 00 00    	jne    ffff8000001005ab <brelse+0x133>
    // no one is waiting for it.
    b->next->prev = b->prev;
ffff80000010050f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100513:	48 8b 80 a0 00 00 00 	mov    0xa0(%rax),%rax
ffff80000010051a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010051e:	48 8b 92 98 00 00 00 	mov    0x98(%rdx),%rdx
ffff800000100525:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
    b->prev->next = b->next;
ffff80000010052c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100530:	48 8b 80 98 00 00 00 	mov    0x98(%rax),%rax
ffff800000100537:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010053b:	48 8b 92 a0 00 00 00 	mov    0xa0(%rdx),%rdx
ffff800000100542:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    b->next = bcache.head.next;
ffff800000100549:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff800000100550:	80 ff ff 
ffff800000100553:	48 8b 90 a8 51 00 00 	mov    0x51a8(%rax),%rdx
ffff80000010055a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010055e:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    b->prev = &bcache.head;
ffff800000100565:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100569:	48 b9 08 31 11 00 00 	movabs $0xffff800000113108,%rcx
ffff800000100570:	80 ff ff 
ffff800000100573:	48 89 88 98 00 00 00 	mov    %rcx,0x98(%rax)
    bcache.head.next->prev = b;
ffff80000010057a:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff800000100581:	80 ff ff 
ffff800000100584:	48 8b 80 a8 51 00 00 	mov    0x51a8(%rax),%rax
ffff80000010058b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010058f:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
    bcache.head.next = b;
ffff800000100596:	48 ba 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdx
ffff80000010059d:	80 ff ff 
ffff8000001005a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001005a4:	48 89 82 a8 51 00 00 	mov    %rax,0x51a8(%rdx)
  }

  release(&bcache.lock);
ffff8000001005ab:	48 bf 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdi
ffff8000001005b2:	80 ff ff 
ffff8000001005b5:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001005bc:	80 ff ff 
ffff8000001005bf:	ff d0                	callq  *%rax
}
ffff8000001005c1:	90                   	nop
ffff8000001005c2:	c9                   	leaveq 
ffff8000001005c3:	c3                   	retq   

ffff8000001005c4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
ffff8000001005c4:	f3 0f 1e fa          	endbr64 
ffff8000001005c8:	55                   	push   %rbp
ffff8000001005c9:	48 89 e5             	mov    %rsp,%rbp
ffff8000001005cc:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001005d0:	89 f8                	mov    %edi,%eax
ffff8000001005d2:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff8000001005d6:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff8000001005da:	89 c2                	mov    %eax,%edx
ffff8000001005dc:	ec                   	in     (%dx),%al
ffff8000001005dd:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff8000001005e0:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff8000001005e4:	c9                   	leaveq 
ffff8000001005e5:	c3                   	retq   

ffff8000001005e6 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
ffff8000001005e6:	f3 0f 1e fa          	endbr64 
ffff8000001005ea:	55                   	push   %rbp
ffff8000001005eb:	48 89 e5             	mov    %rsp,%rbp
ffff8000001005ee:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001005f2:	89 f8                	mov    %edi,%eax
ffff8000001005f4:	89 f2                	mov    %esi,%edx
ffff8000001005f6:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
ffff8000001005fa:	89 d0                	mov    %edx,%eax
ffff8000001005fc:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff8000001005ff:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff800000100603:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff800000100607:	ee                   	out    %al,(%dx)
}
ffff800000100608:	90                   	nop
ffff800000100609:	c9                   	leaveq 
ffff80000010060a:	c3                   	retq   

ffff80000010060b <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
ffff80000010060b:	f3 0f 1e fa          	endbr64 
ffff80000010060f:	55                   	push   %rbp
ffff800000100610:	48 89 e5             	mov    %rsp,%rbp
ffff800000100613:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000100617:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010061b:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  volatile ushort pd[5];
  addr_t addr = (addr_t)p;
ffff80000010061e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000100622:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  pd[0] = size-1;
ffff800000100626:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000100629:	83 e8 01             	sub    $0x1,%eax
ffff80000010062c:	66 89 45 ee          	mov    %ax,-0x12(%rbp)
  pd[1] = addr;
ffff800000100630:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100634:	66 89 45 f0          	mov    %ax,-0x10(%rbp)
  pd[2] = addr >> 16;
ffff800000100638:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010063c:	48 c1 e8 10          	shr    $0x10,%rax
ffff800000100640:	66 89 45 f2          	mov    %ax,-0xe(%rbp)
  pd[3] = addr >> 32;
ffff800000100644:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100648:	48 c1 e8 20          	shr    $0x20,%rax
ffff80000010064c:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
  pd[4] = addr >> 48;
ffff800000100650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100654:	48 c1 e8 30          	shr    $0x30,%rax
ffff800000100658:	66 89 45 f6          	mov    %ax,-0xa(%rbp)

  asm volatile("lidt (%0)" : : "r" (pd));
ffff80000010065c:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
ffff800000100660:	0f 01 18             	lidt   (%rax)
}
ffff800000100663:	90                   	nop
ffff800000100664:	c9                   	leaveq 
ffff800000100665:	c3                   	retq   

ffff800000100666 <cli>:
  return eflags;
}

static inline void
cli(void)
{
ffff800000100666:	f3 0f 1e fa          	endbr64 
ffff80000010066a:	55                   	push   %rbp
ffff80000010066b:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("cli");
ffff80000010066e:	fa                   	cli    
}
ffff80000010066f:	90                   	nop
ffff800000100670:	5d                   	pop    %rbp
ffff800000100671:	c3                   	retq   

ffff800000100672 <hlt>:
  asm volatile("sti");
}

static inline void
hlt(void)
{
ffff800000100672:	f3 0f 1e fa          	endbr64 
ffff800000100676:	55                   	push   %rbp
ffff800000100677:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("hlt");
ffff80000010067a:	f4                   	hlt    
}
ffff80000010067b:	90                   	nop
ffff80000010067c:	5d                   	pop    %rbp
ffff80000010067d:	c3                   	retq   

ffff80000010067e <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(addr_t x)
{
ffff80000010067e:	f3 0f 1e fa          	endbr64 
ffff800000100682:	55                   	push   %rbp
ffff800000100683:	48 89 e5             	mov    %rsp,%rbp
ffff800000100686:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010068a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
ffff80000010068e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000100695:	eb 30                	jmp    ffff8000001006c7 <print_x64+0x49>
    consputc(digits[x >> (sizeof(addr_t) * 8 - 4)]);
ffff800000100697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010069b:	48 c1 e8 3c          	shr    $0x3c,%rax
ffff80000010069f:	48 ba 00 d0 10 00 00 	movabs $0xffff80000010d000,%rdx
ffff8000001006a6:	80 ff ff 
ffff8000001006a9:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff8000001006ad:	0f be c0             	movsbl %al,%eax
ffff8000001006b0:	89 c7                	mov    %eax,%edi
ffff8000001006b2:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff8000001006b9:	80 ff ff 
ffff8000001006bc:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
ffff8000001006be:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001006c2:	48 c1 65 e8 04       	shlq   $0x4,-0x18(%rbp)
ffff8000001006c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001006ca:	83 f8 0f             	cmp    $0xf,%eax
ffff8000001006cd:	76 c8                	jbe    ffff800000100697 <print_x64+0x19>
}
ffff8000001006cf:	90                   	nop
ffff8000001006d0:	90                   	nop
ffff8000001006d1:	c9                   	leaveq 
ffff8000001006d2:	c3                   	retq   

ffff8000001006d3 <print_x32>:

  static void
print_x32(uint x)
{
ffff8000001006d3:	f3 0f 1e fa          	endbr64 
ffff8000001006d7:	55                   	push   %rbp
ffff8000001006d8:	48 89 e5             	mov    %rsp,%rbp
ffff8000001006db:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001006df:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
ffff8000001006e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001006e9:	eb 31                	jmp    ffff80000010071c <print_x32+0x49>
    consputc(digits[x >> (sizeof(uint) * 8 - 4)]);
ffff8000001006eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001006ee:	c1 e8 1c             	shr    $0x1c,%eax
ffff8000001006f1:	89 c2                	mov    %eax,%edx
ffff8000001006f3:	48 b8 00 d0 10 00 00 	movabs $0xffff80000010d000,%rax
ffff8000001006fa:	80 ff ff 
ffff8000001006fd:	89 d2                	mov    %edx,%edx
ffff8000001006ff:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
ffff800000100703:	0f be c0             	movsbl %al,%eax
ffff800000100706:	89 c7                	mov    %eax,%edi
ffff800000100708:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff80000010070f:	80 ff ff 
ffff800000100712:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
ffff800000100714:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000100718:	c1 65 ec 04          	shll   $0x4,-0x14(%rbp)
ffff80000010071c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010071f:	83 f8 07             	cmp    $0x7,%eax
ffff800000100722:	76 c7                	jbe    ffff8000001006eb <print_x32+0x18>
}
ffff800000100724:	90                   	nop
ffff800000100725:	90                   	nop
ffff800000100726:	c9                   	leaveq 
ffff800000100727:	c3                   	retq   

ffff800000100728 <print_d>:

  static void
print_d(int v)
{
ffff800000100728:	f3 0f 1e fa          	endbr64 
ffff80000010072c:	55                   	push   %rbp
ffff80000010072d:	48 89 e5             	mov    %rsp,%rbp
ffff800000100730:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000100734:	89 7d dc             	mov    %edi,-0x24(%rbp)
  char buf[16];
  int64 x = v;
ffff800000100737:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff80000010073a:	48 98                	cltq   
ffff80000010073c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
ffff800000100740:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff800000100744:	79 04                	jns    ffff80000010074a <print_d+0x22>
    x = -x;
ffff800000100746:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
ffff80000010074a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
ffff800000100751:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000100755:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
ffff80000010075c:	66 66 66 
ffff80000010075f:	48 89 c8             	mov    %rcx,%rax
ffff800000100762:	48 f7 ea             	imul   %rdx
ffff800000100765:	48 c1 fa 02          	sar    $0x2,%rdx
ffff800000100769:	48 89 c8             	mov    %rcx,%rax
ffff80000010076c:	48 c1 f8 3f          	sar    $0x3f,%rax
ffff800000100770:	48 29 c2             	sub    %rax,%rdx
ffff800000100773:	48 89 d0             	mov    %rdx,%rax
ffff800000100776:	48 c1 e0 02          	shl    $0x2,%rax
ffff80000010077a:	48 01 d0             	add    %rdx,%rax
ffff80000010077d:	48 01 c0             	add    %rax,%rax
ffff800000100780:	48 29 c1             	sub    %rax,%rcx
ffff800000100783:	48 89 ca             	mov    %rcx,%rdx
ffff800000100786:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000100789:	8d 48 01             	lea    0x1(%rax),%ecx
ffff80000010078c:	89 4d f4             	mov    %ecx,-0xc(%rbp)
ffff80000010078f:	48 b9 00 d0 10 00 00 	movabs $0xffff80000010d000,%rcx
ffff800000100796:	80 ff ff 
ffff800000100799:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
ffff80000010079d:	48 98                	cltq   
ffff80000010079f:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
ffff8000001007a3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff8000001007a7:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
ffff8000001007ae:	66 66 66 
ffff8000001007b1:	48 89 c8             	mov    %rcx,%rax
ffff8000001007b4:	48 f7 ea             	imul   %rdx
ffff8000001007b7:	48 c1 fa 02          	sar    $0x2,%rdx
ffff8000001007bb:	48 89 c8             	mov    %rcx,%rax
ffff8000001007be:	48 c1 f8 3f          	sar    $0x3f,%rax
ffff8000001007c2:	48 29 c2             	sub    %rax,%rdx
ffff8000001007c5:	48 89 d0             	mov    %rdx,%rax
ffff8000001007c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
ffff8000001007cc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001007d1:	0f 85 7a ff ff ff    	jne    ffff800000100751 <print_d+0x29>

  if (v < 0)
ffff8000001007d7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff8000001007db:	79 2d                	jns    ffff80000010080a <print_d+0xe2>
    buf[i++] = '-';
ffff8000001007dd:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001007e0:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001007e3:	89 55 f4             	mov    %edx,-0xc(%rbp)
ffff8000001007e6:	48 98                	cltq   
ffff8000001007e8:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
ffff8000001007ed:	eb 1b                	jmp    ffff80000010080a <print_d+0xe2>
    consputc(buf[i]);
ffff8000001007ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001007f2:	48 98                	cltq   
ffff8000001007f4:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
ffff8000001007f9:	0f be c0             	movsbl %al,%eax
ffff8000001007fc:	89 c7                	mov    %eax,%edi
ffff8000001007fe:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff800000100805:	80 ff ff 
ffff800000100808:	ff d0                	callq  *%rax
  while (--i >= 0)
ffff80000010080a:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
ffff80000010080e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff800000100812:	79 db                	jns    ffff8000001007ef <print_d+0xc7>
}
ffff800000100814:	90                   	nop
ffff800000100815:	90                   	nop
ffff800000100816:	c9                   	leaveq 
ffff800000100817:	c3                   	retq   

ffff800000100818 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
  void
cprintf(char *fmt, ...)
{
ffff800000100818:	f3 0f 1e fa          	endbr64 
ffff80000010081c:	55                   	push   %rbp
ffff80000010081d:	48 89 e5             	mov    %rsp,%rbp
ffff800000100820:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
ffff800000100827:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
ffff80000010082e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
ffff800000100835:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
ffff80000010083c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
ffff800000100843:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
ffff80000010084a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
ffff800000100851:	84 c0                	test   %al,%al
ffff800000100853:	74 20                	je     ffff800000100875 <cprintf+0x5d>
ffff800000100855:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
ffff800000100859:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
ffff80000010085d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
ffff800000100861:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
ffff800000100865:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
ffff800000100869:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
ffff80000010086d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
ffff800000100871:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c, locking;
  char *s;

  va_start(ap, fmt);
ffff800000100875:	c7 85 20 ff ff ff 08 	movl   $0x8,-0xe0(%rbp)
ffff80000010087c:	00 00 00 
ffff80000010087f:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
ffff800000100886:	00 00 00 
ffff800000100889:	48 8d 45 10          	lea    0x10(%rbp),%rax
ffff80000010088d:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
ffff800000100894:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
ffff80000010089b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)

  locking = cons.locking;
ffff8000001008a2:	48 b8 c0 34 11 00 00 	movabs $0xffff8000001134c0,%rax
ffff8000001008a9:	80 ff ff 
ffff8000001008ac:	8b 40 68             	mov    0x68(%rax),%eax
ffff8000001008af:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
  if (locking)
ffff8000001008b5:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
ffff8000001008bc:	74 16                	je     ffff8000001008d4 <cprintf+0xbc>
    acquire(&cons.lock);
ffff8000001008be:	48 bf c0 34 11 00 00 	movabs $0xffff8000001134c0,%rdi
ffff8000001008c5:	80 ff ff 
ffff8000001008c8:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff8000001008cf:	80 ff ff 
ffff8000001008d2:	ff d0                	callq  *%rax

  if (fmt == 0)
ffff8000001008d4:	48 83 bd 18 ff ff ff 	cmpq   $0x0,-0xe8(%rbp)
ffff8000001008db:	00 
ffff8000001008dc:	75 16                	jne    ffff8000001008f4 <cprintf+0xdc>
    panic("null fmt");
ffff8000001008de:	48 bf e5 c4 10 00 00 	movabs $0xffff80000010c4e5,%rdi
ffff8000001008e5:	80 ff ff 
ffff8000001008e8:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001008ef:	80 ff ff 
ffff8000001008f2:	ff d0                	callq  *%rax

  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
ffff8000001008f4:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
ffff8000001008fb:	00 00 00 
ffff8000001008fe:	e9 a0 02 00 00       	jmpq   ffff800000100ba3 <cprintf+0x38b>
    if (c != '%') {
ffff800000100903:	83 bd 38 ff ff ff 25 	cmpl   $0x25,-0xc8(%rbp)
ffff80000010090a:	74 19                	je     ffff800000100925 <cprintf+0x10d>
      consputc(c);
ffff80000010090c:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
ffff800000100912:	89 c7                	mov    %eax,%edi
ffff800000100914:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff80000010091b:	80 ff ff 
ffff80000010091e:	ff d0                	callq  *%rax
      continue;
ffff800000100920:	e9 77 02 00 00       	jmpq   ffff800000100b9c <cprintf+0x384>
    }
    c = fmt[++i] & 0xff;
ffff800000100925:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
ffff80000010092c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
ffff800000100932:	48 63 d0             	movslq %eax,%rdx
ffff800000100935:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
ffff80000010093c:	48 01 d0             	add    %rdx,%rax
ffff80000010093f:	0f b6 00             	movzbl (%rax),%eax
ffff800000100942:	0f be c0             	movsbl %al,%eax
ffff800000100945:	25 ff 00 00 00       	and    $0xff,%eax
ffff80000010094a:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%rbp)
    if (c == 0)
ffff800000100950:	83 bd 38 ff ff ff 00 	cmpl   $0x0,-0xc8(%rbp)
ffff800000100957:	0f 84 79 02 00 00    	je     ffff800000100bd6 <cprintf+0x3be>
      break;
    switch(c) {
ffff80000010095d:	83 bd 38 ff ff ff 78 	cmpl   $0x78,-0xc8(%rbp)
ffff800000100964:	0f 84 b0 00 00 00    	je     ffff800000100a1a <cprintf+0x202>
ffff80000010096a:	83 bd 38 ff ff ff 78 	cmpl   $0x78,-0xc8(%rbp)
ffff800000100971:	0f 8f ff 01 00 00    	jg     ffff800000100b76 <cprintf+0x35e>
ffff800000100977:	83 bd 38 ff ff ff 73 	cmpl   $0x73,-0xc8(%rbp)
ffff80000010097e:	0f 84 42 01 00 00    	je     ffff800000100ac6 <cprintf+0x2ae>
ffff800000100984:	83 bd 38 ff ff ff 73 	cmpl   $0x73,-0xc8(%rbp)
ffff80000010098b:	0f 8f e5 01 00 00    	jg     ffff800000100b76 <cprintf+0x35e>
ffff800000100991:	83 bd 38 ff ff ff 70 	cmpl   $0x70,-0xc8(%rbp)
ffff800000100998:	0f 84 d1 00 00 00    	je     ffff800000100a6f <cprintf+0x257>
ffff80000010099e:	83 bd 38 ff ff ff 70 	cmpl   $0x70,-0xc8(%rbp)
ffff8000001009a5:	0f 8f cb 01 00 00    	jg     ffff800000100b76 <cprintf+0x35e>
ffff8000001009ab:	83 bd 38 ff ff ff 25 	cmpl   $0x25,-0xc8(%rbp)
ffff8000001009b2:	0f 84 ab 01 00 00    	je     ffff800000100b63 <cprintf+0x34b>
ffff8000001009b8:	83 bd 38 ff ff ff 64 	cmpl   $0x64,-0xc8(%rbp)
ffff8000001009bf:	0f 85 b1 01 00 00    	jne    ffff800000100b76 <cprintf+0x35e>
    case 'd':
      print_d(va_arg(ap, int));
ffff8000001009c5:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff8000001009cb:	83 f8 2f             	cmp    $0x2f,%eax
ffff8000001009ce:	77 23                	ja     ffff8000001009f3 <cprintf+0x1db>
ffff8000001009d0:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff8000001009d7:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff8000001009dd:	89 d2                	mov    %edx,%edx
ffff8000001009df:	48 01 d0             	add    %rdx,%rax
ffff8000001009e2:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff8000001009e8:	83 c2 08             	add    $0x8,%edx
ffff8000001009eb:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff8000001009f1:	eb 12                	jmp    ffff800000100a05 <cprintf+0x1ed>
ffff8000001009f3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff8000001009fa:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff8000001009fe:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff800000100a05:	8b 00                	mov    (%rax),%eax
ffff800000100a07:	89 c7                	mov    %eax,%edi
ffff800000100a09:	48 b8 28 07 10 00 00 	movabs $0xffff800000100728,%rax
ffff800000100a10:	80 ff ff 
ffff800000100a13:	ff d0                	callq  *%rax
      break;
ffff800000100a15:	e9 82 01 00 00       	jmpq   ffff800000100b9c <cprintf+0x384>
    case 'x':
      print_x32(va_arg(ap, uint));
ffff800000100a1a:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff800000100a20:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000100a23:	77 23                	ja     ffff800000100a48 <cprintf+0x230>
ffff800000100a25:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff800000100a2c:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a32:	89 d2                	mov    %edx,%edx
ffff800000100a34:	48 01 d0             	add    %rdx,%rax
ffff800000100a37:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a3d:	83 c2 08             	add    $0x8,%edx
ffff800000100a40:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff800000100a46:	eb 12                	jmp    ffff800000100a5a <cprintf+0x242>
ffff800000100a48:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff800000100a4f:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000100a53:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff800000100a5a:	8b 00                	mov    (%rax),%eax
ffff800000100a5c:	89 c7                	mov    %eax,%edi
ffff800000100a5e:	48 b8 d3 06 10 00 00 	movabs $0xffff8000001006d3,%rax
ffff800000100a65:	80 ff ff 
ffff800000100a68:	ff d0                	callq  *%rax
      break;
ffff800000100a6a:	e9 2d 01 00 00       	jmpq   ffff800000100b9c <cprintf+0x384>
    case 'p':
      print_x64(va_arg(ap, addr_t));
ffff800000100a6f:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff800000100a75:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000100a78:	77 23                	ja     ffff800000100a9d <cprintf+0x285>
ffff800000100a7a:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff800000100a81:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a87:	89 d2                	mov    %edx,%edx
ffff800000100a89:	48 01 d0             	add    %rdx,%rax
ffff800000100a8c:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a92:	83 c2 08             	add    $0x8,%edx
ffff800000100a95:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff800000100a9b:	eb 12                	jmp    ffff800000100aaf <cprintf+0x297>
ffff800000100a9d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff800000100aa4:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000100aa8:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff800000100aaf:	48 8b 00             	mov    (%rax),%rax
ffff800000100ab2:	48 89 c7             	mov    %rax,%rdi
ffff800000100ab5:	48 b8 7e 06 10 00 00 	movabs $0xffff80000010067e,%rax
ffff800000100abc:	80 ff ff 
ffff800000100abf:	ff d0                	callq  *%rax
      break;
ffff800000100ac1:	e9 d6 00 00 00       	jmpq   ffff800000100b9c <cprintf+0x384>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
ffff800000100ac6:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff800000100acc:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000100acf:	77 23                	ja     ffff800000100af4 <cprintf+0x2dc>
ffff800000100ad1:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff800000100ad8:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100ade:	89 d2                	mov    %edx,%edx
ffff800000100ae0:	48 01 d0             	add    %rdx,%rax
ffff800000100ae3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100ae9:	83 c2 08             	add    $0x8,%edx
ffff800000100aec:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff800000100af2:	eb 12                	jmp    ffff800000100b06 <cprintf+0x2ee>
ffff800000100af4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff800000100afb:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000100aff:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff800000100b06:	48 8b 00             	mov    (%rax),%rax
ffff800000100b09:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
ffff800000100b10:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
ffff800000100b17:	00 
ffff800000100b18:	75 39                	jne    ffff800000100b53 <cprintf+0x33b>
        s = "(null)";
ffff800000100b1a:	48 b8 ee c4 10 00 00 	movabs $0xffff80000010c4ee,%rax
ffff800000100b21:	80 ff ff 
ffff800000100b24:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
ffff800000100b2b:	eb 26                	jmp    ffff800000100b53 <cprintf+0x33b>
        consputc(*(s++));
ffff800000100b2d:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
ffff800000100b34:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000100b38:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
ffff800000100b3f:	0f b6 00             	movzbl (%rax),%eax
ffff800000100b42:	0f be c0             	movsbl %al,%eax
ffff800000100b45:	89 c7                	mov    %eax,%edi
ffff800000100b47:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff800000100b4e:	80 ff ff 
ffff800000100b51:	ff d0                	callq  *%rax
      while (*s)
ffff800000100b53:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
ffff800000100b5a:	0f b6 00             	movzbl (%rax),%eax
ffff800000100b5d:	84 c0                	test   %al,%al
ffff800000100b5f:	75 cc                	jne    ffff800000100b2d <cprintf+0x315>
      break;
ffff800000100b61:	eb 39                	jmp    ffff800000100b9c <cprintf+0x384>
    case '%':
      consputc('%');
ffff800000100b63:	bf 25 00 00 00       	mov    $0x25,%edi
ffff800000100b68:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff800000100b6f:	80 ff ff 
ffff800000100b72:	ff d0                	callq  *%rax
      break;
ffff800000100b74:	eb 26                	jmp    ffff800000100b9c <cprintf+0x384>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
ffff800000100b76:	bf 25 00 00 00       	mov    $0x25,%edi
ffff800000100b7b:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff800000100b82:	80 ff ff 
ffff800000100b85:	ff d0                	callq  *%rax
      consputc(c);
ffff800000100b87:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
ffff800000100b8d:	89 c7                	mov    %eax,%edi
ffff800000100b8f:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff800000100b96:	80 ff ff 
ffff800000100b99:	ff d0                	callq  *%rax
      break;
ffff800000100b9b:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
ffff800000100b9c:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
ffff800000100ba3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
ffff800000100ba9:	48 63 d0             	movslq %eax,%rdx
ffff800000100bac:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
ffff800000100bb3:	48 01 d0             	add    %rdx,%rax
ffff800000100bb6:	0f b6 00             	movzbl (%rax),%eax
ffff800000100bb9:	0f be c0             	movsbl %al,%eax
ffff800000100bbc:	25 ff 00 00 00       	and    $0xff,%eax
ffff800000100bc1:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%rbp)
ffff800000100bc7:	83 bd 38 ff ff ff 00 	cmpl   $0x0,-0xc8(%rbp)
ffff800000100bce:	0f 85 2f fd ff ff    	jne    ffff800000100903 <cprintf+0xeb>
ffff800000100bd4:	eb 01                	jmp    ffff800000100bd7 <cprintf+0x3bf>
      break;
ffff800000100bd6:	90                   	nop
    }
  }

  if (locking)
ffff800000100bd7:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
ffff800000100bde:	74 16                	je     ffff800000100bf6 <cprintf+0x3de>
    release(&cons.lock);
ffff800000100be0:	48 bf c0 34 11 00 00 	movabs $0xffff8000001134c0,%rdi
ffff800000100be7:	80 ff ff 
ffff800000100bea:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000100bf1:	80 ff ff 
ffff800000100bf4:	ff d0                	callq  *%rax
}
ffff800000100bf6:	90                   	nop
ffff800000100bf7:	c9                   	leaveq 
ffff800000100bf8:	c3                   	retq   

ffff800000100bf9 <panic>:

__attribute__((noreturn))
  void
panic(char *s)
{
ffff800000100bf9:	f3 0f 1e fa          	endbr64 
ffff800000100bfd:	55                   	push   %rbp
ffff800000100bfe:	48 89 e5             	mov    %rsp,%rbp
ffff800000100c01:	48 83 ec 70          	sub    $0x70,%rsp
ffff800000100c05:	48 89 7d 98          	mov    %rdi,-0x68(%rbp)
  int i;
  addr_t pcs[10];

  cli();
ffff800000100c09:	48 b8 66 06 10 00 00 	movabs $0xffff800000100666,%rax
ffff800000100c10:	80 ff ff 
ffff800000100c13:	ff d0                	callq  *%rax
  cons.locking = 0;
ffff800000100c15:	48 b8 c0 34 11 00 00 	movabs $0xffff8000001134c0,%rax
ffff800000100c1c:	80 ff ff 
ffff800000100c1f:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%rax)
  cprintf("cpu%d: panic: ", cpu->id);
ffff800000100c26:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000100c2d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000100c31:	0f b6 00             	movzbl (%rax),%eax
ffff800000100c34:	0f b6 c0             	movzbl %al,%eax
ffff800000100c37:	89 c6                	mov    %eax,%esi
ffff800000100c39:	48 bf f5 c4 10 00 00 	movabs $0xffff80000010c4f5,%rdi
ffff800000100c40:	80 ff ff 
ffff800000100c43:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100c48:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000100c4f:	80 ff ff 
ffff800000100c52:	ff d2                	callq  *%rdx
  cprintf(s);
ffff800000100c54:	48 8b 45 98          	mov    -0x68(%rbp),%rax
ffff800000100c58:	48 89 c7             	mov    %rax,%rdi
ffff800000100c5b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100c60:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000100c67:	80 ff ff 
ffff800000100c6a:	ff d2                	callq  *%rdx
  cprintf("\n");
ffff800000100c6c:	48 bf 04 c5 10 00 00 	movabs $0xffff80000010c504,%rdi
ffff800000100c73:	80 ff ff 
ffff800000100c76:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100c7b:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000100c82:	80 ff ff 
ffff800000100c85:	ff d2                	callq  *%rdx
  getcallerpcs(&s, pcs);
ffff800000100c87:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
ffff800000100c8b:	48 8d 45 98          	lea    -0x68(%rbp),%rax
ffff800000100c8f:	48 89 d6             	mov    %rdx,%rsi
ffff800000100c92:	48 89 c7             	mov    %rax,%rdi
ffff800000100c95:	48 b8 6f 79 10 00 00 	movabs $0xffff80000010796f,%rax
ffff800000100c9c:	80 ff ff 
ffff800000100c9f:	ff d0                	callq  *%rax
  for (i=0; i<10; i++)
ffff800000100ca1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000100ca8:	eb 2c                	jmp    ffff800000100cd6 <panic+0xdd>
    cprintf(" %p\n", pcs[i]);
ffff800000100caa:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100cad:	48 98                	cltq   
ffff800000100caf:	48 8b 44 c5 a0       	mov    -0x60(%rbp,%rax,8),%rax
ffff800000100cb4:	48 89 c6             	mov    %rax,%rsi
ffff800000100cb7:	48 bf 06 c5 10 00 00 	movabs $0xffff80000010c506,%rdi
ffff800000100cbe:	80 ff ff 
ffff800000100cc1:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100cc6:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000100ccd:	80 ff ff 
ffff800000100cd0:	ff d2                	callq  *%rdx
  for (i=0; i<10; i++)
ffff800000100cd2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000100cd6:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff800000100cda:	7e ce                	jle    ffff800000100caa <panic+0xb1>
  panicked = 1; // freeze other CPU
ffff800000100cdc:	48 b8 b8 34 11 00 00 	movabs $0xffff8000001134b8,%rax
ffff800000100ce3:	80 ff ff 
ffff800000100ce6:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  for (;;)
    hlt();
ffff800000100cec:	48 b8 72 06 10 00 00 	movabs $0xffff800000100672,%rax
ffff800000100cf3:	80 ff ff 
ffff800000100cf6:	ff d0                	callq  *%rax
ffff800000100cf8:	eb f2                	jmp    ffff800000100cec <panic+0xf3>

ffff800000100cfa <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

  static void
cgaputc(int c)
{
ffff800000100cfa:	f3 0f 1e fa          	endbr64 
ffff800000100cfe:	55                   	push   %rbp
ffff800000100cff:	48 89 e5             	mov    %rsp,%rbp
ffff800000100d02:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000100d06:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
ffff800000100d09:	be 0e 00 00 00       	mov    $0xe,%esi
ffff800000100d0e:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100d13:	48 b8 e6 05 10 00 00 	movabs $0xffff8000001005e6,%rax
ffff800000100d1a:	80 ff ff 
ffff800000100d1d:	ff d0                	callq  *%rax
  pos = inb(CRTPORT+1) << 8;
ffff800000100d1f:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100d24:	48 b8 c4 05 10 00 00 	movabs $0xffff8000001005c4,%rax
ffff800000100d2b:	80 ff ff 
ffff800000100d2e:	ff d0                	callq  *%rax
ffff800000100d30:	0f b6 c0             	movzbl %al,%eax
ffff800000100d33:	c1 e0 08             	shl    $0x8,%eax
ffff800000100d36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  outb(CRTPORT, 15);
ffff800000100d39:	be 0f 00 00 00       	mov    $0xf,%esi
ffff800000100d3e:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100d43:	48 b8 e6 05 10 00 00 	movabs $0xffff8000001005e6,%rax
ffff800000100d4a:	80 ff ff 
ffff800000100d4d:	ff d0                	callq  *%rax
  pos |= inb(CRTPORT+1);
ffff800000100d4f:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100d54:	48 b8 c4 05 10 00 00 	movabs $0xffff8000001005c4,%rax
ffff800000100d5b:	80 ff ff 
ffff800000100d5e:	ff d0                	callq  *%rax
ffff800000100d60:	0f b6 c0             	movzbl %al,%eax
ffff800000100d63:	09 45 fc             	or     %eax,-0x4(%rbp)

  if (c == '\n')
ffff800000100d66:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
ffff800000100d6a:	75 37                	jne    ffff800000100da3 <cgaputc+0xa9>
    pos += 80 - pos%80;
ffff800000100d6c:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffff800000100d6f:	48 63 c1             	movslq %ecx,%rax
ffff800000100d72:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
ffff800000100d79:	48 c1 e8 20          	shr    $0x20,%rax
ffff800000100d7d:	89 c2                	mov    %eax,%edx
ffff800000100d7f:	c1 fa 05             	sar    $0x5,%edx
ffff800000100d82:	89 c8                	mov    %ecx,%eax
ffff800000100d84:	c1 f8 1f             	sar    $0x1f,%eax
ffff800000100d87:	29 c2                	sub    %eax,%edx
ffff800000100d89:	89 d0                	mov    %edx,%eax
ffff800000100d8b:	c1 e0 02             	shl    $0x2,%eax
ffff800000100d8e:	01 d0                	add    %edx,%eax
ffff800000100d90:	c1 e0 04             	shl    $0x4,%eax
ffff800000100d93:	29 c1                	sub    %eax,%ecx
ffff800000100d95:	89 ca                	mov    %ecx,%edx
ffff800000100d97:	b8 50 00 00 00       	mov    $0x50,%eax
ffff800000100d9c:	29 d0                	sub    %edx,%eax
ffff800000100d9e:	01 45 fc             	add    %eax,-0x4(%rbp)
ffff800000100da1:	eb 43                	jmp    ffff800000100de6 <cgaputc+0xec>
  else if (c == BACKSPACE) {
ffff800000100da3:	81 7d ec 00 01 00 00 	cmpl   $0x100,-0x14(%rbp)
ffff800000100daa:	75 0c                	jne    ffff800000100db8 <cgaputc+0xbe>
    if (pos > 0) --pos;
ffff800000100dac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000100db0:	7e 34                	jle    ffff800000100de6 <cgaputc+0xec>
ffff800000100db2:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
ffff800000100db6:	eb 2e                	jmp    ffff800000100de6 <cgaputc+0xec>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
ffff800000100db8:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000100dbb:	0f b6 c0             	movzbl %al,%eax
ffff800000100dbe:	80 cc 07             	or     $0x7,%ah
ffff800000100dc1:	89 c6                	mov    %eax,%esi
ffff800000100dc3:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100dca:	80 ff ff 
ffff800000100dcd:	48 8b 08             	mov    (%rax),%rcx
ffff800000100dd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100dd3:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000100dd6:	89 55 fc             	mov    %edx,-0x4(%rbp)
ffff800000100dd9:	48 98                	cltq   
ffff800000100ddb:	48 01 c0             	add    %rax,%rax
ffff800000100dde:	48 01 c8             	add    %rcx,%rax
ffff800000100de1:	89 f2                	mov    %esi,%edx
ffff800000100de3:	66 89 10             	mov    %dx,(%rax)

  if ((pos/80) >= 24){  // Scroll up.
ffff800000100de6:	81 7d fc 7f 07 00 00 	cmpl   $0x77f,-0x4(%rbp)
ffff800000100ded:	7e 76                	jle    ffff800000100e65 <cgaputc+0x16b>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
ffff800000100def:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100df6:	80 ff ff 
ffff800000100df9:	48 8b 00             	mov    (%rax),%rax
ffff800000100dfc:	48 8d 88 a0 00 00 00 	lea    0xa0(%rax),%rcx
ffff800000100e03:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100e0a:	80 ff ff 
ffff800000100e0d:	48 8b 00             	mov    (%rax),%rax
ffff800000100e10:	ba 60 0e 00 00       	mov    $0xe60,%edx
ffff800000100e15:	48 89 ce             	mov    %rcx,%rsi
ffff800000100e18:	48 89 c7             	mov    %rax,%rdi
ffff800000100e1b:	48 b8 10 7d 10 00 00 	movabs $0xffff800000107d10,%rax
ffff800000100e22:	80 ff ff 
ffff800000100e25:	ff d0                	callq  *%rax
    pos -= 80;
ffff800000100e27:	83 6d fc 50          	subl   $0x50,-0x4(%rbp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
ffff800000100e2b:	b8 80 07 00 00       	mov    $0x780,%eax
ffff800000100e30:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff800000100e33:	48 98                	cltq   
ffff800000100e35:	8d 14 00             	lea    (%rax,%rax,1),%edx
ffff800000100e38:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100e3f:	80 ff ff 
ffff800000100e42:	48 8b 00             	mov    (%rax),%rax
ffff800000100e45:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffff800000100e48:	48 63 c9             	movslq %ecx,%rcx
ffff800000100e4b:	48 01 c9             	add    %rcx,%rcx
ffff800000100e4e:	48 01 c8             	add    %rcx,%rax
ffff800000100e51:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000100e56:	48 89 c7             	mov    %rax,%rdi
ffff800000100e59:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff800000100e60:	80 ff ff 
ffff800000100e63:	ff d0                	callq  *%rax
  }

  outb(CRTPORT, 14);
ffff800000100e65:	be 0e 00 00 00       	mov    $0xe,%esi
ffff800000100e6a:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100e6f:	48 b8 e6 05 10 00 00 	movabs $0xffff8000001005e6,%rax
ffff800000100e76:	80 ff ff 
ffff800000100e79:	ff d0                	callq  *%rax
  outb(CRTPORT+1, pos>>8);
ffff800000100e7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100e7e:	c1 f8 08             	sar    $0x8,%eax
ffff800000100e81:	0f b6 c0             	movzbl %al,%eax
ffff800000100e84:	89 c6                	mov    %eax,%esi
ffff800000100e86:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100e8b:	48 b8 e6 05 10 00 00 	movabs $0xffff8000001005e6,%rax
ffff800000100e92:	80 ff ff 
ffff800000100e95:	ff d0                	callq  *%rax
  outb(CRTPORT, 15);
ffff800000100e97:	be 0f 00 00 00       	mov    $0xf,%esi
ffff800000100e9c:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100ea1:	48 b8 e6 05 10 00 00 	movabs $0xffff8000001005e6,%rax
ffff800000100ea8:	80 ff ff 
ffff800000100eab:	ff d0                	callq  *%rax
  outb(CRTPORT+1, pos);
ffff800000100ead:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100eb0:	0f b6 c0             	movzbl %al,%eax
ffff800000100eb3:	89 c6                	mov    %eax,%esi
ffff800000100eb5:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100eba:	48 b8 e6 05 10 00 00 	movabs $0xffff8000001005e6,%rax
ffff800000100ec1:	80 ff ff 
ffff800000100ec4:	ff d0                	callq  *%rax
  crt[pos] = ' ' | 0x0700;
ffff800000100ec6:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100ecd:	80 ff ff 
ffff800000100ed0:	48 8b 00             	mov    (%rax),%rax
ffff800000100ed3:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000100ed6:	48 63 d2             	movslq %edx,%rdx
ffff800000100ed9:	48 01 d2             	add    %rdx,%rdx
ffff800000100edc:	48 01 d0             	add    %rdx,%rax
ffff800000100edf:	66 c7 00 20 07       	movw   $0x720,(%rax)
}
ffff800000100ee4:	90                   	nop
ffff800000100ee5:	c9                   	leaveq 
ffff800000100ee6:	c3                   	retq   

ffff800000100ee7 <consputc>:

  void
consputc(int c)
{
ffff800000100ee7:	f3 0f 1e fa          	endbr64 
ffff800000100eeb:	55                   	push   %rbp
ffff800000100eec:	48 89 e5             	mov    %rsp,%rbp
ffff800000100eef:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000100ef3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  if (panicked) {
ffff800000100ef6:	48 b8 b8 34 11 00 00 	movabs $0xffff8000001134b8,%rax
ffff800000100efd:	80 ff ff 
ffff800000100f00:	8b 00                	mov    (%rax),%eax
ffff800000100f02:	85 c0                	test   %eax,%eax
ffff800000100f04:	74 1a                	je     ffff800000100f20 <consputc+0x39>
    cli();
ffff800000100f06:	48 b8 66 06 10 00 00 	movabs $0xffff800000100666,%rax
ffff800000100f0d:	80 ff ff 
ffff800000100f10:	ff d0                	callq  *%rax
    for(;;)
      hlt();
ffff800000100f12:	48 b8 72 06 10 00 00 	movabs $0xffff800000100672,%rax
ffff800000100f19:	80 ff ff 
ffff800000100f1c:	ff d0                	callq  *%rax
ffff800000100f1e:	eb f2                	jmp    ffff800000100f12 <consputc+0x2b>
  }

  if (c == BACKSPACE) {
ffff800000100f20:	81 7d fc 00 01 00 00 	cmpl   $0x100,-0x4(%rbp)
ffff800000100f27:	75 35                	jne    ffff800000100f5e <consputc+0x77>
    uartputc('\b'); uartputc(' '); uartputc('\b');
ffff800000100f29:	bf 08 00 00 00       	mov    $0x8,%edi
ffff800000100f2e:	48 b8 5a a1 10 00 00 	movabs $0xffff80000010a15a,%rax
ffff800000100f35:	80 ff ff 
ffff800000100f38:	ff d0                	callq  *%rax
ffff800000100f3a:	bf 20 00 00 00       	mov    $0x20,%edi
ffff800000100f3f:	48 b8 5a a1 10 00 00 	movabs $0xffff80000010a15a,%rax
ffff800000100f46:	80 ff ff 
ffff800000100f49:	ff d0                	callq  *%rax
ffff800000100f4b:	bf 08 00 00 00       	mov    $0x8,%edi
ffff800000100f50:	48 b8 5a a1 10 00 00 	movabs $0xffff80000010a15a,%rax
ffff800000100f57:	80 ff ff 
ffff800000100f5a:	ff d0                	callq  *%rax
ffff800000100f5c:	eb 11                	jmp    ffff800000100f6f <consputc+0x88>
  } else
    uartputc(c);
ffff800000100f5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100f61:	89 c7                	mov    %eax,%edi
ffff800000100f63:	48 b8 5a a1 10 00 00 	movabs $0xffff80000010a15a,%rax
ffff800000100f6a:	80 ff ff 
ffff800000100f6d:	ff d0                	callq  *%rax
  cgaputc(c);
ffff800000100f6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100f72:	89 c7                	mov    %eax,%edi
ffff800000100f74:	48 b8 fa 0c 10 00 00 	movabs $0xffff800000100cfa,%rax
ffff800000100f7b:	80 ff ff 
ffff800000100f7e:	ff d0                	callq  *%rax
}
ffff800000100f80:	90                   	nop
ffff800000100f81:	c9                   	leaveq 
ffff800000100f82:	c3                   	retq   

ffff800000100f83 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

  void
consoleintr(int (*getc)(void))
{
ffff800000100f83:	f3 0f 1e fa          	endbr64 
ffff800000100f87:	55                   	push   %rbp
ffff800000100f88:	48 89 e5             	mov    %rsp,%rbp
ffff800000100f8b:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000100f8f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int c;

  acquire(&input.lock);
ffff800000100f93:	48 bf c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdi
ffff800000100f9a:	80 ff ff 
ffff800000100f9d:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000100fa4:	80 ff ff 
ffff800000100fa7:	ff d0                	callq  *%rax
  while((c = getc()) >= 0){
ffff800000100fa9:	e9 6a 02 00 00       	jmpq   ffff800000101218 <consoleintr+0x295>
    switch(c){
ffff800000100fae:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
ffff800000100fb2:	0f 84 fd 00 00 00    	je     ffff8000001010b5 <consoleintr+0x132>
ffff800000100fb8:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
ffff800000100fbc:	0f 8f 54 01 00 00    	jg     ffff800000101116 <consoleintr+0x193>
ffff800000100fc2:	83 7d fc 1a          	cmpl   $0x1a,-0x4(%rbp)
ffff800000100fc6:	74 2f                	je     ffff800000100ff7 <consoleintr+0x74>
ffff800000100fc8:	83 7d fc 1a          	cmpl   $0x1a,-0x4(%rbp)
ffff800000100fcc:	0f 8f 44 01 00 00    	jg     ffff800000101116 <consoleintr+0x193>
ffff800000100fd2:	83 7d fc 15          	cmpl   $0x15,-0x4(%rbp)
ffff800000100fd6:	74 7f                	je     ffff800000101057 <consoleintr+0xd4>
ffff800000100fd8:	83 7d fc 15          	cmpl   $0x15,-0x4(%rbp)
ffff800000100fdc:	0f 8f 34 01 00 00    	jg     ffff800000101116 <consoleintr+0x193>
ffff800000100fe2:	83 7d fc 08          	cmpl   $0x8,-0x4(%rbp)
ffff800000100fe6:	0f 84 c9 00 00 00    	je     ffff8000001010b5 <consoleintr+0x132>
ffff800000100fec:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
ffff800000100ff0:	74 20                	je     ffff800000101012 <consoleintr+0x8f>
ffff800000100ff2:	e9 1f 01 00 00       	jmpq   ffff800000101116 <consoleintr+0x193>
    case C('Z'): // reboot
      lidt(0,0);
ffff800000100ff7:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000100ffc:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000101001:	48 b8 0b 06 10 00 00 	movabs $0xffff80000010060b,%rax
ffff800000101008:	80 ff ff 
ffff80000010100b:	ff d0                	callq  *%rax
      break;
ffff80000010100d:	e9 06 02 00 00       	jmpq   ffff800000101218 <consoleintr+0x295>
    case C('P'):  // Process listing.
      procdump();
ffff800000101012:	48 b8 bf 74 10 00 00 	movabs $0xffff8000001074bf,%rax
ffff800000101019:	80 ff ff 
ffff80000010101c:	ff d0                	callq  *%rax
      break;
ffff80000010101e:	e9 f5 01 00 00       	jmpq   ffff800000101218 <consoleintr+0x295>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
          input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
ffff800000101023:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010102a:	80 ff ff 
ffff80000010102d:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff800000101033:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000101036:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010103d:	80 ff ff 
ffff800000101040:	89 90 f0 00 00 00    	mov    %edx,0xf0(%rax)
        consputc(BACKSPACE);
ffff800000101046:	bf 00 01 00 00       	mov    $0x100,%edi
ffff80000010104b:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff800000101052:	80 ff ff 
ffff800000101055:	ff d0                	callq  *%rax
      while(input.e != input.w &&
ffff800000101057:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010105e:	80 ff ff 
ffff800000101061:	8b 90 f0 00 00 00    	mov    0xf0(%rax),%edx
ffff800000101067:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010106e:	80 ff ff 
ffff800000101071:	8b 80 ec 00 00 00    	mov    0xec(%rax),%eax
ffff800000101077:	39 c2                	cmp    %eax,%edx
ffff800000101079:	0f 84 99 01 00 00    	je     ffff800000101218 <consoleintr+0x295>
          input.buf[(input.e-1) % INPUT_BUF] != '\n'){
ffff80000010107f:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101086:	80 ff ff 
ffff800000101089:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff80000010108f:	83 e8 01             	sub    $0x1,%eax
ffff800000101092:	83 e0 7f             	and    $0x7f,%eax
ffff800000101095:	89 c2                	mov    %eax,%edx
ffff800000101097:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010109e:	80 ff ff 
ffff8000001010a1:	89 d2                	mov    %edx,%edx
ffff8000001010a3:	0f b6 44 10 68       	movzbl 0x68(%rax,%rdx,1),%eax
      while(input.e != input.w &&
ffff8000001010a8:	3c 0a                	cmp    $0xa,%al
ffff8000001010aa:	0f 85 73 ff ff ff    	jne    ffff800000101023 <consoleintr+0xa0>
      }
      break;
ffff8000001010b0:	e9 63 01 00 00       	jmpq   ffff800000101218 <consoleintr+0x295>
    case C('H'): case '\x7f':  // Backspace
      if (input.e != input.w) {
ffff8000001010b5:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001010bc:	80 ff ff 
ffff8000001010bf:	8b 90 f0 00 00 00    	mov    0xf0(%rax),%edx
ffff8000001010c5:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001010cc:	80 ff ff 
ffff8000001010cf:	8b 80 ec 00 00 00    	mov    0xec(%rax),%eax
ffff8000001010d5:	39 c2                	cmp    %eax,%edx
ffff8000001010d7:	0f 84 3b 01 00 00    	je     ffff800000101218 <consoleintr+0x295>
        input.e--;
ffff8000001010dd:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001010e4:	80 ff ff 
ffff8000001010e7:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff8000001010ed:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff8000001010f0:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001010f7:	80 ff ff 
ffff8000001010fa:	89 90 f0 00 00 00    	mov    %edx,0xf0(%rax)
        consputc(BACKSPACE);
ffff800000101100:	bf 00 01 00 00       	mov    $0x100,%edi
ffff800000101105:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff80000010110c:	80 ff ff 
ffff80000010110f:	ff d0                	callq  *%rax
      }
      break;
ffff800000101111:	e9 02 01 00 00       	jmpq   ffff800000101218 <consoleintr+0x295>
    default:
      if (c != 0 && input.e-input.r < INPUT_BUF) {
ffff800000101116:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff80000010111a:	0f 84 f7 00 00 00    	je     ffff800000101217 <consoleintr+0x294>
ffff800000101120:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101127:	80 ff ff 
ffff80000010112a:	8b 90 f0 00 00 00    	mov    0xf0(%rax),%edx
ffff800000101130:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101137:	80 ff ff 
ffff80000010113a:	8b 80 e8 00 00 00    	mov    0xe8(%rax),%eax
ffff800000101140:	29 c2                	sub    %eax,%edx
ffff800000101142:	89 d0                	mov    %edx,%eax
ffff800000101144:	83 f8 7f             	cmp    $0x7f,%eax
ffff800000101147:	0f 87 ca 00 00 00    	ja     ffff800000101217 <consoleintr+0x294>
        c = (c == '\r') ? '\n' : c;
ffff80000010114d:	83 7d fc 0d          	cmpl   $0xd,-0x4(%rbp)
ffff800000101151:	74 05                	je     ffff800000101158 <consoleintr+0x1d5>
ffff800000101153:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101156:	eb 05                	jmp    ffff80000010115d <consoleintr+0x1da>
ffff800000101158:	b8 0a 00 00 00       	mov    $0xa,%eax
ffff80000010115d:	89 45 fc             	mov    %eax,-0x4(%rbp)
        input.buf[input.e++ % INPUT_BUF] = c;
ffff800000101160:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101167:	80 ff ff 
ffff80000010116a:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff800000101170:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000101173:	48 b9 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rcx
ffff80000010117a:	80 ff ff 
ffff80000010117d:	89 91 f0 00 00 00    	mov    %edx,0xf0(%rcx)
ffff800000101183:	83 e0 7f             	and    $0x7f,%eax
ffff800000101186:	89 c2                	mov    %eax,%edx
ffff800000101188:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010118b:	89 c1                	mov    %eax,%ecx
ffff80000010118d:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101194:	80 ff ff 
ffff800000101197:	89 d2                	mov    %edx,%edx
ffff800000101199:	88 4c 10 68          	mov    %cl,0x68(%rax,%rdx,1)
        consputc(c);
ffff80000010119d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001011a0:	89 c7                	mov    %eax,%edi
ffff8000001011a2:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff8000001011a9:	80 ff ff 
ffff8000001011ac:	ff d0                	callq  *%rax
        if (c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF) {
ffff8000001011ae:	83 7d fc 0a          	cmpl   $0xa,-0x4(%rbp)
ffff8000001011b2:	74 2d                	je     ffff8000001011e1 <consoleintr+0x25e>
ffff8000001011b4:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
ffff8000001011b8:	74 27                	je     ffff8000001011e1 <consoleintr+0x25e>
ffff8000001011ba:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001011c1:	80 ff ff 
ffff8000001011c4:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff8000001011ca:	48 ba c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdx
ffff8000001011d1:	80 ff ff 
ffff8000001011d4:	8b 92 e8 00 00 00    	mov    0xe8(%rdx),%edx
ffff8000001011da:	83 ea 80             	sub    $0xffffff80,%edx
ffff8000001011dd:	39 d0                	cmp    %edx,%eax
ffff8000001011df:	75 36                	jne    ffff800000101217 <consoleintr+0x294>
          input.w = input.e;
ffff8000001011e1:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001011e8:	80 ff ff 
ffff8000001011eb:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff8000001011f1:	48 ba c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdx
ffff8000001011f8:	80 ff ff 
ffff8000001011fb:	89 82 ec 00 00 00    	mov    %eax,0xec(%rdx)
          wakeup(&input.r);
ffff800000101201:	48 bf a8 34 11 00 00 	movabs $0xffff8000001134a8,%rdi
ffff800000101208:	80 ff ff 
ffff80000010120b:	48 b8 b8 73 10 00 00 	movabs $0xffff8000001073b8,%rax
ffff800000101212:	80 ff ff 
ffff800000101215:	ff d0                	callq  *%rax
        }
      }
      break;
ffff800000101217:	90                   	nop
  while((c = getc()) >= 0){
ffff800000101218:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010121c:	ff d0                	callq  *%rax
ffff80000010121e:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000101221:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000101225:	0f 89 83 fd ff ff    	jns    ffff800000100fae <consoleintr+0x2b>
    }
  }
  release(&input.lock);
ffff80000010122b:	48 bf c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdi
ffff800000101232:	80 ff ff 
ffff800000101235:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff80000010123c:	80 ff ff 
ffff80000010123f:	ff d0                	callq  *%rax
}
ffff800000101241:	90                   	nop
ffff800000101242:	c9                   	leaveq 
ffff800000101243:	c3                   	retq   

ffff800000101244 <consoleread>:

  int
consoleread(struct inode *ip, uint off, char *dst, int n)
{
ffff800000101244:	f3 0f 1e fa          	endbr64 
ffff800000101248:	55                   	push   %rbp
ffff800000101249:	48 89 e5             	mov    %rsp,%rbp
ffff80000010124c:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000101250:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000101254:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff800000101257:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff80000010125b:	89 4d e0             	mov    %ecx,-0x20(%rbp)
  uint target;
  int c;

  iunlock(ip);
ffff80000010125e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101262:	48 89 c7             	mov    %rax,%rdi
ffff800000101265:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff80000010126c:	80 ff ff 
ffff80000010126f:	ff d0                	callq  *%rax
  target = n;
ffff800000101271:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000101274:	89 45 fc             	mov    %eax,-0x4(%rbp)
  acquire(&input.lock);
ffff800000101277:	48 bf c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdi
ffff80000010127e:	80 ff ff 
ffff800000101281:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000101288:	80 ff ff 
ffff80000010128b:	ff d0                	callq  *%rax
  while(n > 0){
ffff80000010128d:	e9 1a 01 00 00       	jmpq   ffff8000001013ac <consoleread+0x168>
    while(input.r == input.w){
      if (proc->killed) {
ffff800000101292:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101299:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010129d:	8b 40 40             	mov    0x40(%rax),%eax
ffff8000001012a0:	85 c0                	test   %eax,%eax
ffff8000001012a2:	74 33                	je     ffff8000001012d7 <consoleread+0x93>
        release(&input.lock);
ffff8000001012a4:	48 bf c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdi
ffff8000001012ab:	80 ff ff 
ffff8000001012ae:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001012b5:	80 ff ff 
ffff8000001012b8:	ff d0                	callq  *%rax
        ilock(ip);
ffff8000001012ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001012be:	48 89 c7             	mov    %rax,%rdi
ffff8000001012c1:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff8000001012c8:	80 ff ff 
ffff8000001012cb:	ff d0                	callq  *%rax
        return -1;
ffff8000001012cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001012d2:	e9 18 01 00 00       	jmpq   ffff8000001013ef <consoleread+0x1ab>
      }
      sleep(&input.r, &input.lock);
ffff8000001012d7:	48 be c0 33 11 00 00 	movabs $0xffff8000001133c0,%rsi
ffff8000001012de:	80 ff ff 
ffff8000001012e1:	48 bf a8 34 11 00 00 	movabs $0xffff8000001134a8,%rdi
ffff8000001012e8:	80 ff ff 
ffff8000001012eb:	48 b8 47 72 10 00 00 	movabs $0xffff800000107247,%rax
ffff8000001012f2:	80 ff ff 
ffff8000001012f5:	ff d0                	callq  *%rax
    while(input.r == input.w){
ffff8000001012f7:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001012fe:	80 ff ff 
ffff800000101301:	8b 90 e8 00 00 00    	mov    0xe8(%rax),%edx
ffff800000101307:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010130e:	80 ff ff 
ffff800000101311:	8b 80 ec 00 00 00    	mov    0xec(%rax),%eax
ffff800000101317:	39 c2                	cmp    %eax,%edx
ffff800000101319:	0f 84 73 ff ff ff    	je     ffff800000101292 <consoleread+0x4e>
    }
    c = input.buf[input.r++ % INPUT_BUF];
ffff80000010131f:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101326:	80 ff ff 
ffff800000101329:	8b 80 e8 00 00 00    	mov    0xe8(%rax),%eax
ffff80000010132f:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000101332:	48 b9 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rcx
ffff800000101339:	80 ff ff 
ffff80000010133c:	89 91 e8 00 00 00    	mov    %edx,0xe8(%rcx)
ffff800000101342:	83 e0 7f             	and    $0x7f,%eax
ffff800000101345:	89 c2                	mov    %eax,%edx
ffff800000101347:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010134e:	80 ff ff 
ffff800000101351:	89 d2                	mov    %edx,%edx
ffff800000101353:	0f b6 44 10 68       	movzbl 0x68(%rax,%rdx,1),%eax
ffff800000101358:	0f be c0             	movsbl %al,%eax
ffff80000010135b:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if (c == C('D')) {  // EOF
ffff80000010135e:	83 7d f8 04          	cmpl   $0x4,-0x8(%rbp)
ffff800000101362:	75 2d                	jne    ffff800000101391 <consoleread+0x14d>
      if (n < target) {
ffff800000101364:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000101367:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff80000010136a:	76 4c                	jbe    ffff8000001013b8 <consoleread+0x174>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
ffff80000010136c:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101373:	80 ff ff 
ffff800000101376:	8b 80 e8 00 00 00    	mov    0xe8(%rax),%eax
ffff80000010137c:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff80000010137f:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101386:	80 ff ff 
ffff800000101389:	89 90 e8 00 00 00    	mov    %edx,0xe8(%rax)
      }
      break;
ffff80000010138f:	eb 27                	jmp    ffff8000001013b8 <consoleread+0x174>
    }
    *dst++ = c;
ffff800000101391:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000101395:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000101399:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff80000010139d:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff8000001013a0:	88 10                	mov    %dl,(%rax)
    --n;
ffff8000001013a2:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
    if (c == '\n')
ffff8000001013a6:	83 7d f8 0a          	cmpl   $0xa,-0x8(%rbp)
ffff8000001013aa:	74 0f                	je     ffff8000001013bb <consoleread+0x177>
  while(n > 0){
ffff8000001013ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
ffff8000001013b0:	0f 8f 41 ff ff ff    	jg     ffff8000001012f7 <consoleread+0xb3>
ffff8000001013b6:	eb 04                	jmp    ffff8000001013bc <consoleread+0x178>
      break;
ffff8000001013b8:	90                   	nop
ffff8000001013b9:	eb 01                	jmp    ffff8000001013bc <consoleread+0x178>
      break;
ffff8000001013bb:	90                   	nop
  }
  release(&input.lock);
ffff8000001013bc:	48 bf c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdi
ffff8000001013c3:	80 ff ff 
ffff8000001013c6:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001013cd:	80 ff ff 
ffff8000001013d0:	ff d0                	callq  *%rax
  ilock(ip);
ffff8000001013d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001013d6:	48 89 c7             	mov    %rax,%rdi
ffff8000001013d9:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff8000001013e0:	80 ff ff 
ffff8000001013e3:	ff d0                	callq  *%rax

  return target - n;
ffff8000001013e5:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff8000001013e8:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001013eb:	29 c2                	sub    %eax,%edx
ffff8000001013ed:	89 d0                	mov    %edx,%eax
}
ffff8000001013ef:	c9                   	leaveq 
ffff8000001013f0:	c3                   	retq   

ffff8000001013f1 <consolewrite>:

  int
consolewrite(struct inode *ip, uint off, char *buf, int n)
{
ffff8000001013f1:	f3 0f 1e fa          	endbr64 
ffff8000001013f5:	55                   	push   %rbp
ffff8000001013f6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001013f9:	48 83 ec 30          	sub    $0x30,%rsp
ffff8000001013fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000101401:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff800000101404:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff800000101408:	89 4d e0             	mov    %ecx,-0x20(%rbp)
  int i;

  iunlock(ip);
ffff80000010140b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010140f:	48 89 c7             	mov    %rax,%rdi
ffff800000101412:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000101419:	80 ff ff 
ffff80000010141c:	ff d0                	callq  *%rax
  acquire(&cons.lock);
ffff80000010141e:	48 bf c0 34 11 00 00 	movabs $0xffff8000001134c0,%rdi
ffff800000101425:	80 ff ff 
ffff800000101428:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff80000010142f:	80 ff ff 
ffff800000101432:	ff d0                	callq  *%rax
  for(i = 0; i < n; i++)
ffff800000101434:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010143b:	eb 28                	jmp    ffff800000101465 <consolewrite+0x74>
    consputc(buf[i] & 0xff);
ffff80000010143d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101440:	48 63 d0             	movslq %eax,%rdx
ffff800000101443:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000101447:	48 01 d0             	add    %rdx,%rax
ffff80000010144a:	0f b6 00             	movzbl (%rax),%eax
ffff80000010144d:	0f be c0             	movsbl %al,%eax
ffff800000101450:	0f b6 c0             	movzbl %al,%eax
ffff800000101453:	89 c7                	mov    %eax,%edi
ffff800000101455:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff80000010145c:	80 ff ff 
ffff80000010145f:	ff d0                	callq  *%rax
  for(i = 0; i < n; i++)
ffff800000101461:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000101465:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101468:	3b 45 e0             	cmp    -0x20(%rbp),%eax
ffff80000010146b:	7c d0                	jl     ffff80000010143d <consolewrite+0x4c>
  release(&cons.lock);
ffff80000010146d:	48 bf c0 34 11 00 00 	movabs $0xffff8000001134c0,%rdi
ffff800000101474:	80 ff ff 
ffff800000101477:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff80000010147e:	80 ff ff 
ffff800000101481:	ff d0                	callq  *%rax
  ilock(ip);
ffff800000101483:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101487:	48 89 c7             	mov    %rax,%rdi
ffff80000010148a:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000101491:	80 ff ff 
ffff800000101494:	ff d0                	callq  *%rax

  return n;
ffff800000101496:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
ffff800000101499:	c9                   	leaveq 
ffff80000010149a:	c3                   	retq   

ffff80000010149b <consoleinit>:

  void
consoleinit(void)
{
ffff80000010149b:	f3 0f 1e fa          	endbr64 
ffff80000010149f:	55                   	push   %rbp
ffff8000001014a0:	48 89 e5             	mov    %rsp,%rbp
  initlock(&cons.lock, "console");
ffff8000001014a3:	48 be 0b c5 10 00 00 	movabs $0xffff80000010c50b,%rsi
ffff8000001014aa:	80 ff ff 
ffff8000001014ad:	48 bf c0 34 11 00 00 	movabs $0xffff8000001134c0,%rdi
ffff8000001014b4:	80 ff ff 
ffff8000001014b7:	48 b8 24 78 10 00 00 	movabs $0xffff800000107824,%rax
ffff8000001014be:	80 ff ff 
ffff8000001014c1:	ff d0                	callq  *%rax
  initlock(&input.lock, "input");
ffff8000001014c3:	48 be 13 c5 10 00 00 	movabs $0xffff80000010c513,%rsi
ffff8000001014ca:	80 ff ff 
ffff8000001014cd:	48 bf c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdi
ffff8000001014d4:	80 ff ff 
ffff8000001014d7:	48 b8 24 78 10 00 00 	movabs $0xffff800000107824,%rax
ffff8000001014de:	80 ff ff 
ffff8000001014e1:	ff d0                	callq  *%rax

  devsw[CONSOLE].write = consolewrite;
ffff8000001014e3:	48 b8 40 35 11 00 00 	movabs $0xffff800000113540,%rax
ffff8000001014ea:	80 ff ff 
ffff8000001014ed:	48 ba f1 13 10 00 00 	movabs $0xffff8000001013f1,%rdx
ffff8000001014f4:	80 ff ff 
ffff8000001014f7:	48 89 50 18          	mov    %rdx,0x18(%rax)
  devsw[CONSOLE].read = consoleread;
ffff8000001014fb:	48 b8 40 35 11 00 00 	movabs $0xffff800000113540,%rax
ffff800000101502:	80 ff ff 
ffff800000101505:	48 b9 44 12 10 00 00 	movabs $0xffff800000101244,%rcx
ffff80000010150c:	80 ff ff 
ffff80000010150f:	48 89 48 10          	mov    %rcx,0x10(%rax)
  cons.locking = 1;
ffff800000101513:	48 b8 c0 34 11 00 00 	movabs $0xffff8000001134c0,%rax
ffff80000010151a:	80 ff ff 
ffff80000010151d:	c7 40 68 01 00 00 00 	movl   $0x1,0x68(%rax)

  ioapicenable(IRQ_KBD, 0);
ffff800000101524:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000101529:	bf 01 00 00 00       	mov    $0x1,%edi
ffff80000010152e:	48 b8 e5 3f 10 00 00 	movabs $0xffff800000103fe5,%rax
ffff800000101535:	80 ff ff 
ffff800000101538:	ff d0                	callq  *%rax
}
ffff80000010153a:	90                   	nop
ffff80000010153b:	5d                   	pop    %rbp
ffff80000010153c:	c3                   	retq   

ffff80000010153d <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
ffff80000010153d:	f3 0f 1e fa          	endbr64 
ffff800000101541:	55                   	push   %rbp
ffff800000101542:	48 89 e5             	mov    %rsp,%rbp
ffff800000101545:	48 81 ec 00 02 00 00 	sub    $0x200,%rsp
ffff80000010154c:	48 89 bd 08 fe ff ff 	mov    %rdi,-0x1f8(%rbp)
ffff800000101553:	48 89 b5 00 fe ff ff 	mov    %rsi,-0x200(%rbp)
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  oldpgdir = proc->pgdir;
ffff80000010155a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101561:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101565:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000101569:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

  begin_op();
ffff80000010156d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101572:	48 ba ab 52 10 00 00 	movabs $0xffff8000001052ab,%rdx
ffff800000101579:	80 ff ff 
ffff80000010157c:	ff d2                	callq  *%rdx

  if((ip = namei(path)) == 0){
ffff80000010157e:	48 8b 85 08 fe ff ff 	mov    -0x1f8(%rbp),%rax
ffff800000101585:	48 89 c7             	mov    %rax,%rdi
ffff800000101588:	48 b8 ff 37 10 00 00 	movabs $0xffff8000001037ff,%rax
ffff80000010158f:	80 ff ff 
ffff800000101592:	ff d0                	callq  *%rax
ffff800000101594:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
ffff800000101598:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff80000010159d:	75 1b                	jne    ffff8000001015ba <exec+0x7d>
    end_op();
ffff80000010159f:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001015a4:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff8000001015ab:	80 ff ff 
ffff8000001015ae:	ff d2                	callq  *%rdx
    return -1;
ffff8000001015b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001015b5:	e9 9d 05 00 00       	jmpq   ffff800000101b57 <exec+0x61a>
  }
  ilock(ip);
ffff8000001015ba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001015be:	48 89 c7             	mov    %rax,%rdi
ffff8000001015c1:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff8000001015c8:	80 ff ff 
ffff8000001015cb:	ff d0                	callq  *%rax
  pgdir = 0;
ffff8000001015cd:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
ffff8000001015d4:	00 

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
ffff8000001015d5:	48 8d b5 50 fe ff ff 	lea    -0x1b0(%rbp),%rsi
ffff8000001015dc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001015e0:	b9 40 00 00 00       	mov    $0x40,%ecx
ffff8000001015e5:	ba 00 00 00 00       	mov    $0x0,%edx
ffff8000001015ea:	48 89 c7             	mov    %rax,%rdi
ffff8000001015ed:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff8000001015f4:	80 ff ff 
ffff8000001015f7:	ff d0                	callq  *%rax
ffff8000001015f9:	83 f8 40             	cmp    $0x40,%eax
ffff8000001015fc:	0f 85 e6 04 00 00    	jne    ffff800000101ae8 <exec+0x5ab>
    goto bad;
  if(elf.magic != ELF_MAGIC)
ffff800000101602:	8b 85 50 fe ff ff    	mov    -0x1b0(%rbp),%eax
ffff800000101608:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
ffff80000010160d:	0f 85 d8 04 00 00    	jne    ffff800000101aeb <exec+0x5ae>
    goto bad;

  if((pgdir = setupkvm()) == 0)
ffff800000101613:	48 b8 42 b2 10 00 00 	movabs $0xffff80000010b242,%rax
ffff80000010161a:	80 ff ff 
ffff80000010161d:	ff d0                	callq  *%rax
ffff80000010161f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
ffff800000101623:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
ffff800000101628:	0f 84 c0 04 00 00    	je     ffff800000101aee <exec+0x5b1>
    goto bad;

  // Load program into memory.
  sz = PGSIZE; // skip the first page
ffff80000010162e:	48 c7 45 d8 00 10 00 	movq   $0x1000,-0x28(%rbp)
ffff800000101635:	00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
ffff800000101636:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
ffff80000010163d:	48 8b 85 70 fe ff ff 	mov    -0x190(%rbp),%rax
ffff800000101644:	89 45 e8             	mov    %eax,-0x18(%rbp)
ffff800000101647:	e9 0f 01 00 00       	jmpq   ffff80000010175b <exec+0x21e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
ffff80000010164c:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff80000010164f:	48 8d b5 10 fe ff ff 	lea    -0x1f0(%rbp),%rsi
ffff800000101656:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010165a:	b9 38 00 00 00       	mov    $0x38,%ecx
ffff80000010165f:	48 89 c7             	mov    %rax,%rdi
ffff800000101662:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff800000101669:	80 ff ff 
ffff80000010166c:	ff d0                	callq  *%rax
ffff80000010166e:	83 f8 38             	cmp    $0x38,%eax
ffff800000101671:	0f 85 7a 04 00 00    	jne    ffff800000101af1 <exec+0x5b4>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
ffff800000101677:	8b 85 10 fe ff ff    	mov    -0x1f0(%rbp),%eax
ffff80000010167d:	83 f8 01             	cmp    $0x1,%eax
ffff800000101680:	0f 85 c7 00 00 00    	jne    ffff80000010174d <exec+0x210>
      continue;
    if(ph.memsz < ph.filesz)
ffff800000101686:	48 8b 95 38 fe ff ff 	mov    -0x1c8(%rbp),%rdx
ffff80000010168d:	48 8b 85 30 fe ff ff 	mov    -0x1d0(%rbp),%rax
ffff800000101694:	48 39 c2             	cmp    %rax,%rdx
ffff800000101697:	0f 82 57 04 00 00    	jb     ffff800000101af4 <exec+0x5b7>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
ffff80000010169d:	48 8b 95 20 fe ff ff 	mov    -0x1e0(%rbp),%rdx
ffff8000001016a4:	48 8b 85 38 fe ff ff 	mov    -0x1c8(%rbp),%rax
ffff8000001016ab:	48 01 c2             	add    %rax,%rdx
ffff8000001016ae:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
ffff8000001016b5:	48 39 c2             	cmp    %rax,%rdx
ffff8000001016b8:	0f 82 39 04 00 00    	jb     ffff800000101af7 <exec+0x5ba>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
ffff8000001016be:	48 8b 95 20 fe ff ff 	mov    -0x1e0(%rbp),%rdx
ffff8000001016c5:	48 8b 85 38 fe ff ff 	mov    -0x1c8(%rbp),%rax
ffff8000001016cc:	48 01 c2             	add    %rax,%rdx
ffff8000001016cf:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff8000001016d3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001016d7:	48 89 ce             	mov    %rcx,%rsi
ffff8000001016da:	48 89 c7             	mov    %rax,%rdi
ffff8000001016dd:	48 b8 aa b9 10 00 00 	movabs $0xffff80000010b9aa,%rax
ffff8000001016e4:	80 ff ff 
ffff8000001016e7:	ff d0                	callq  *%rax
ffff8000001016e9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
ffff8000001016ed:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffff8000001016f2:	0f 84 02 04 00 00    	je     ffff800000101afa <exec+0x5bd>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
ffff8000001016f8:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
ffff8000001016ff:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff800000101704:	48 85 c0             	test   %rax,%rax
ffff800000101707:	0f 85 f0 03 00 00    	jne    ffff800000101afd <exec+0x5c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
ffff80000010170d:	48 8b 85 30 fe ff ff 	mov    -0x1d0(%rbp),%rax
ffff800000101714:	89 c7                	mov    %eax,%edi
ffff800000101716:	48 8b 85 18 fe ff ff 	mov    -0x1e8(%rbp),%rax
ffff80000010171d:	89 c1                	mov    %eax,%ecx
ffff80000010171f:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
ffff800000101726:	48 89 c6             	mov    %rax,%rsi
ffff800000101729:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
ffff80000010172d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff800000101731:	41 89 f8             	mov    %edi,%r8d
ffff800000101734:	48 89 c7             	mov    %rax,%rdi
ffff800000101737:	48 b8 84 b8 10 00 00 	movabs $0xffff80000010b884,%rax
ffff80000010173e:	80 ff ff 
ffff800000101741:	ff d0                	callq  *%rax
ffff800000101743:	85 c0                	test   %eax,%eax
ffff800000101745:	0f 88 b5 03 00 00    	js     ffff800000101b00 <exec+0x5c3>
ffff80000010174b:	eb 01                	jmp    ffff80000010174e <exec+0x211>
      continue;
ffff80000010174d:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
ffff80000010174e:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
ffff800000101752:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000101755:	83 c0 38             	add    $0x38,%eax
ffff800000101758:	89 45 e8             	mov    %eax,-0x18(%rbp)
ffff80000010175b:	0f b7 85 88 fe ff ff 	movzwl -0x178(%rbp),%eax
ffff800000101762:	0f b7 c0             	movzwl %ax,%eax
ffff800000101765:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff800000101768:	0f 8c de fe ff ff    	jl     ffff80000010164c <exec+0x10f>
      goto bad;
  }
  iunlockput(ip);
ffff80000010176e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000101772:	48 89 c7             	mov    %rax,%rdi
ffff800000101775:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff80000010177c:	80 ff ff 
ffff80000010177f:	ff d0                	callq  *%rax
  end_op();
ffff800000101781:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101786:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff80000010178d:	80 ff ff 
ffff800000101790:	ff d2                	callq  *%rdx
  ip = 0;
ffff800000101792:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
ffff800000101799:	00 

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
ffff80000010179a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010179e:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff8000001017a4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff8000001017aa:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
ffff8000001017ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001017b2:	48 8d 90 00 20 00 00 	lea    0x2000(%rax),%rdx
ffff8000001017b9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff8000001017bd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001017c1:	48 89 ce             	mov    %rcx,%rsi
ffff8000001017c4:	48 89 c7             	mov    %rax,%rdi
ffff8000001017c7:	48 b8 aa b9 10 00 00 	movabs $0xffff80000010b9aa,%rax
ffff8000001017ce:	80 ff ff 
ffff8000001017d1:	ff d0                	callq  *%rax
ffff8000001017d3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
ffff8000001017d7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffff8000001017dc:	0f 84 21 03 00 00    	je     ffff800000101b03 <exec+0x5c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
ffff8000001017e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001017e6:	48 2d 00 20 00 00    	sub    $0x2000,%rax
ffff8000001017ec:	48 89 c2             	mov    %rax,%rdx
ffff8000001017ef:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001017f3:	48 89 d6             	mov    %rdx,%rsi
ffff8000001017f6:	48 89 c7             	mov    %rax,%rdi
ffff8000001017f9:	48 b8 24 be 10 00 00 	movabs $0xffff80000010be24,%rax
ffff800000101800:	80 ff ff 
ffff800000101803:	ff d0                	callq  *%rax
  sp = sz;
ffff800000101805:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000101809:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
ffff80000010180d:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
ffff800000101814:	00 
ffff800000101815:	e9 c9 00 00 00       	jmpq   ffff8000001018e3 <exec+0x3a6>
    if(argc >= MAXARG)
ffff80000010181a:	48 83 7d e0 1f       	cmpq   $0x1f,-0x20(%rbp)
ffff80000010181f:	0f 87 e1 02 00 00    	ja     ffff800000101b06 <exec+0x5c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~(sizeof(addr_t)-1);
ffff800000101825:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101829:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff800000101830:	00 
ffff800000101831:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff800000101838:	48 01 d0             	add    %rdx,%rax
ffff80000010183b:	48 8b 00             	mov    (%rax),%rax
ffff80000010183e:	48 89 c7             	mov    %rax,%rdi
ffff800000101841:	48 b8 39 7f 10 00 00 	movabs $0xffff800000107f39,%rax
ffff800000101848:	80 ff ff 
ffff80000010184b:	ff d0                	callq  *%rax
ffff80000010184d:	83 c0 01             	add    $0x1,%eax
ffff800000101850:	48 98                	cltq   
ffff800000101852:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000101856:	48 29 c2             	sub    %rax,%rdx
ffff800000101859:	48 89 d0             	mov    %rdx,%rax
ffff80000010185c:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
ffff800000101860:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
ffff800000101864:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101868:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010186f:	00 
ffff800000101870:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff800000101877:	48 01 d0             	add    %rdx,%rax
ffff80000010187a:	48 8b 00             	mov    (%rax),%rax
ffff80000010187d:	48 89 c7             	mov    %rax,%rdi
ffff800000101880:	48 b8 39 7f 10 00 00 	movabs $0xffff800000107f39,%rax
ffff800000101887:	80 ff ff 
ffff80000010188a:	ff d0                	callq  *%rax
ffff80000010188c:	83 c0 01             	add    $0x1,%eax
ffff80000010188f:	48 63 c8             	movslq %eax,%rcx
ffff800000101892:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101896:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010189d:	00 
ffff80000010189e:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff8000001018a5:	48 01 d0             	add    %rdx,%rax
ffff8000001018a8:	48 8b 10             	mov    (%rax),%rdx
ffff8000001018ab:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
ffff8000001018af:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001018b3:	48 89 c7             	mov    %rax,%rdi
ffff8000001018b6:	48 b8 99 c0 10 00 00 	movabs $0xffff80000010c099,%rax
ffff8000001018bd:	80 ff ff 
ffff8000001018c0:	ff d0                	callq  *%rax
ffff8000001018c2:	85 c0                	test   %eax,%eax
ffff8000001018c4:	0f 88 3f 02 00 00    	js     ffff800000101b09 <exec+0x5cc>
      goto bad;
    ustack[3+argc] = sp;
ffff8000001018ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001018ce:	48 8d 50 03          	lea    0x3(%rax),%rdx
ffff8000001018d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff8000001018d6:	48 89 84 d5 90 fe ff 	mov    %rax,-0x170(%rbp,%rdx,8)
ffff8000001018dd:	ff 
  for(argc = 0; argv[argc]; argc++) {
ffff8000001018de:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
ffff8000001018e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001018e7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff8000001018ee:	00 
ffff8000001018ef:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff8000001018f6:	48 01 d0             	add    %rdx,%rax
ffff8000001018f9:	48 8b 00             	mov    (%rax),%rax
ffff8000001018fc:	48 85 c0             	test   %rax,%rax
ffff8000001018ff:	0f 85 15 ff ff ff    	jne    ffff80000010181a <exec+0x2dd>
  }
  ustack[3+argc] = 0;
ffff800000101905:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101909:	48 83 c0 03          	add    $0x3,%rax
ffff80000010190d:	48 c7 84 c5 90 fe ff 	movq   $0x0,-0x170(%rbp,%rax,8)
ffff800000101914:	ff 00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
ffff800000101919:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010191e:	48 89 85 90 fe ff ff 	mov    %rax,-0x170(%rbp)
  ustack[1] = argc;
ffff800000101925:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101929:	48 89 85 98 fe ff ff 	mov    %rax,-0x168(%rbp)
  ustack[2] = sp - (argc+1)*sizeof(addr_t);  // argv pointer
ffff800000101930:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101934:	48 83 c0 01          	add    $0x1,%rax
ffff800000101938:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010193f:	00 
ffff800000101940:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000101944:	48 29 d0             	sub    %rdx,%rax
ffff800000101947:	48 89 85 a0 fe ff ff 	mov    %rax,-0x160(%rbp)

  proc->tf->rdi = argc;
ffff80000010194e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101955:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101959:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff80000010195d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000101961:	48 89 50 30          	mov    %rdx,0x30(%rax)
  proc->tf->rsi = sp - (argc+1)*sizeof(addr_t);
ffff800000101965:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101969:	48 83 c0 01          	add    $0x1,%rax
ffff80000010196d:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
ffff800000101974:	00 
ffff800000101975:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010197c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101980:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101984:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000101988:	48 29 ca             	sub    %rcx,%rdx
ffff80000010198b:	48 89 50 28          	mov    %rdx,0x28(%rax)


  sp -= (3+argc+1) * sizeof(addr_t);
ffff80000010198f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101993:	48 83 c0 04          	add    $0x4,%rax
ffff800000101997:	48 c1 e0 03          	shl    $0x3,%rax
ffff80000010199b:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*sizeof(addr_t)) < 0)
ffff80000010199f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001019a3:	48 83 c0 04          	add    $0x4,%rax
ffff8000001019a7:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
ffff8000001019ae:	00 
ffff8000001019af:	48 8d 95 90 fe ff ff 	lea    -0x170(%rbp),%rdx
ffff8000001019b6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
ffff8000001019ba:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001019be:	48 89 c7             	mov    %rax,%rdi
ffff8000001019c1:	48 b8 99 c0 10 00 00 	movabs $0xffff80000010c099,%rax
ffff8000001019c8:	80 ff ff 
ffff8000001019cb:	ff d0                	callq  *%rax
ffff8000001019cd:	85 c0                	test   %eax,%eax
ffff8000001019cf:	0f 88 37 01 00 00    	js     ffff800000101b0c <exec+0x5cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
ffff8000001019d5:	48 8b 85 08 fe ff ff 	mov    -0x1f8(%rbp),%rax
ffff8000001019dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001019e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001019e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff8000001019e8:	eb 1c                	jmp    ffff800000101a06 <exec+0x4c9>
    if(*s == '/')
ffff8000001019ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001019ee:	0f b6 00             	movzbl (%rax),%eax
ffff8000001019f1:	3c 2f                	cmp    $0x2f,%al
ffff8000001019f3:	75 0c                	jne    ffff800000101a01 <exec+0x4c4>
      last = s+1;
ffff8000001019f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001019f9:	48 83 c0 01          	add    $0x1,%rax
ffff8000001019fd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(last=s=path; *s; s++)
ffff800000101a01:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff800000101a06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101a0a:	0f b6 00             	movzbl (%rax),%eax
ffff800000101a0d:	84 c0                	test   %al,%al
ffff800000101a0f:	75 d9                	jne    ffff8000001019ea <exec+0x4ad>
  safestrcpy(proc->name, last, sizeof(proc->name));
ffff800000101a11:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a18:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a1c:	48 8d 88 d0 00 00 00 	lea    0xd0(%rax),%rcx
ffff800000101a23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000101a27:	ba 10 00 00 00       	mov    $0x10,%edx
ffff800000101a2c:	48 89 c6             	mov    %rax,%rsi
ffff800000101a2f:	48 89 cf             	mov    %rcx,%rdi
ffff800000101a32:	48 b8 d3 7e 10 00 00 	movabs $0xffff800000107ed3,%rax
ffff800000101a39:	80 ff ff 
ffff800000101a3c:	ff d0                	callq  *%rax

  // Commit to the user image.
  proc->pgdir = pgdir;
ffff800000101a3e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a45:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a49:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
ffff800000101a4d:	48 89 50 08          	mov    %rdx,0x8(%rax)
  proc->sz = sz;
ffff800000101a51:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a58:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a5c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000101a60:	48 89 10             	mov    %rdx,(%rax)
  proc->tf->rip = elf.entry;  // main
ffff800000101a63:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a6a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a6e:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101a72:	48 8b 95 68 fe ff ff 	mov    -0x198(%rbp),%rdx
ffff800000101a79:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
  proc->tf->rcx = elf.entry;
ffff800000101a80:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a87:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a8b:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101a8f:	48 8b 95 68 fe ff ff 	mov    -0x198(%rbp),%rdx
ffff800000101a96:	48 89 50 10          	mov    %rdx,0x10(%rax)
  proc->tf->rsp = sp;
ffff800000101a9a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101aa1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101aa5:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101aa9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000101aad:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
  switchuvm(proc);
ffff800000101ab4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101abb:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101abf:	48 89 c7             	mov    %rax,%rdi
ffff800000101ac2:	48 b8 a8 b3 10 00 00 	movabs $0xffff80000010b3a8,%rax
ffff800000101ac9:	80 ff ff 
ffff800000101acc:	ff d0                	callq  *%rax
  freevm(oldpgdir);
ffff800000101ace:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101ad2:	48 89 c7             	mov    %rax,%rdi
ffff800000101ad5:	48 b8 ec bb 10 00 00 	movabs $0xffff80000010bbec,%rax
ffff800000101adc:	80 ff ff 
ffff800000101adf:	ff d0                	callq  *%rax
  return 0;
ffff800000101ae1:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101ae6:	eb 6f                	jmp    ffff800000101b57 <exec+0x61a>
    goto bad;
ffff800000101ae8:	90                   	nop
ffff800000101ae9:	eb 22                	jmp    ffff800000101b0d <exec+0x5d0>
    goto bad;
ffff800000101aeb:	90                   	nop
ffff800000101aec:	eb 1f                	jmp    ffff800000101b0d <exec+0x5d0>
    goto bad;
ffff800000101aee:	90                   	nop
ffff800000101aef:	eb 1c                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101af1:	90                   	nop
ffff800000101af2:	eb 19                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101af4:	90                   	nop
ffff800000101af5:	eb 16                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101af7:	90                   	nop
ffff800000101af8:	eb 13                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101afa:	90                   	nop
ffff800000101afb:	eb 10                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101afd:	90                   	nop
ffff800000101afe:	eb 0d                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101b00:	90                   	nop
ffff800000101b01:	eb 0a                	jmp    ffff800000101b0d <exec+0x5d0>
    goto bad;
ffff800000101b03:	90                   	nop
ffff800000101b04:	eb 07                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101b06:	90                   	nop
ffff800000101b07:	eb 04                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101b09:	90                   	nop
ffff800000101b0a:	eb 01                	jmp    ffff800000101b0d <exec+0x5d0>
    goto bad;
ffff800000101b0c:	90                   	nop

 bad:
  if(pgdir)
ffff800000101b0d:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
ffff800000101b12:	74 13                	je     ffff800000101b27 <exec+0x5ea>
    freevm(pgdir);
ffff800000101b14:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff800000101b18:	48 89 c7             	mov    %rax,%rdi
ffff800000101b1b:	48 b8 ec bb 10 00 00 	movabs $0xffff80000010bbec,%rax
ffff800000101b22:	80 ff ff 
ffff800000101b25:	ff d0                	callq  *%rax
  if(ip){
ffff800000101b27:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff800000101b2c:	74 24                	je     ffff800000101b52 <exec+0x615>
    iunlockput(ip);
ffff800000101b2e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000101b32:	48 89 c7             	mov    %rax,%rdi
ffff800000101b35:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000101b3c:	80 ff ff 
ffff800000101b3f:	ff d0                	callq  *%rax
    end_op();
ffff800000101b41:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101b46:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff800000101b4d:	80 ff ff 
ffff800000101b50:	ff d2                	callq  *%rdx
  }
  return -1;
ffff800000101b52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000101b57:	c9                   	leaveq 
ffff800000101b58:	c3                   	retq   

ffff800000101b59 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
ffff800000101b59:	f3 0f 1e fa          	endbr64 
ffff800000101b5d:	55                   	push   %rbp
ffff800000101b5e:	48 89 e5             	mov    %rsp,%rbp
  initlock(&ftable.lock, "ftable");
ffff800000101b61:	48 be 19 c5 10 00 00 	movabs $0xffff80000010c519,%rsi
ffff800000101b68:	80 ff ff 
ffff800000101b6b:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101b72:	80 ff ff 
ffff800000101b75:	48 b8 24 78 10 00 00 	movabs $0xffff800000107824,%rax
ffff800000101b7c:	80 ff ff 
ffff800000101b7f:	ff d0                	callq  *%rax
}
ffff800000101b81:	90                   	nop
ffff800000101b82:	5d                   	pop    %rbp
ffff800000101b83:	c3                   	retq   

ffff800000101b84 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
ffff800000101b84:	f3 0f 1e fa          	endbr64 
ffff800000101b88:	55                   	push   %rbp
ffff800000101b89:	48 89 e5             	mov    %rsp,%rbp
ffff800000101b8c:	48 83 ec 10          	sub    $0x10,%rsp
  struct file *f;

  acquire(&ftable.lock);
ffff800000101b90:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101b97:	80 ff ff 
ffff800000101b9a:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000101ba1:	80 ff ff 
ffff800000101ba4:	ff d0                	callq  *%rax
  for(f = ftable.file; f < ftable.file + NFILE; f++){
ffff800000101ba6:	48 b8 48 36 11 00 00 	movabs $0xffff800000113648,%rax
ffff800000101bad:	80 ff ff 
ffff800000101bb0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000101bb4:	eb 37                	jmp    ffff800000101bed <filealloc+0x69>
    if(f->ref == 0){
ffff800000101bb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101bba:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101bbd:	85 c0                	test   %eax,%eax
ffff800000101bbf:	75 27                	jne    ffff800000101be8 <filealloc+0x64>
      f->ref = 1;
ffff800000101bc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101bc5:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%rax)
      release(&ftable.lock);
ffff800000101bcc:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101bd3:	80 ff ff 
ffff800000101bd6:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000101bdd:	80 ff ff 
ffff800000101be0:	ff d0                	callq  *%rax
      return f;
ffff800000101be2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101be6:	eb 30                	jmp    ffff800000101c18 <filealloc+0x94>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
ffff800000101be8:	48 83 45 f8 28       	addq   $0x28,-0x8(%rbp)
ffff800000101bed:	48 b8 e8 45 11 00 00 	movabs $0xffff8000001145e8,%rax
ffff800000101bf4:	80 ff ff 
ffff800000101bf7:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000101bfb:	72 b9                	jb     ffff800000101bb6 <filealloc+0x32>
    }
  }
  release(&ftable.lock);
ffff800000101bfd:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101c04:	80 ff ff 
ffff800000101c07:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000101c0e:	80 ff ff 
ffff800000101c11:	ff d0                	callq  *%rax
  return 0;
ffff800000101c13:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000101c18:	c9                   	leaveq 
ffff800000101c19:	c3                   	retq   

ffff800000101c1a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
ffff800000101c1a:	f3 0f 1e fa          	endbr64 
ffff800000101c1e:	55                   	push   %rbp
ffff800000101c1f:	48 89 e5             	mov    %rsp,%rbp
ffff800000101c22:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000101c26:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&ftable.lock);
ffff800000101c2a:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101c31:	80 ff ff 
ffff800000101c34:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000101c3b:	80 ff ff 
ffff800000101c3e:	ff d0                	callq  *%rax
  if(f->ref < 1)
ffff800000101c40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101c44:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101c47:	85 c0                	test   %eax,%eax
ffff800000101c49:	7f 16                	jg     ffff800000101c61 <filedup+0x47>
    panic("filedup");
ffff800000101c4b:	48 bf 20 c5 10 00 00 	movabs $0xffff80000010c520,%rdi
ffff800000101c52:	80 ff ff 
ffff800000101c55:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000101c5c:	80 ff ff 
ffff800000101c5f:	ff d0                	callq  *%rax
  f->ref++;
ffff800000101c61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101c65:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101c68:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000101c6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101c6f:	89 50 04             	mov    %edx,0x4(%rax)
  release(&ftable.lock);
ffff800000101c72:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101c79:	80 ff ff 
ffff800000101c7c:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000101c83:	80 ff ff 
ffff800000101c86:	ff d0                	callq  *%rax
  return f;
ffff800000101c88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000101c8c:	c9                   	leaveq 
ffff800000101c8d:	c3                   	retq   

ffff800000101c8e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
ffff800000101c8e:	f3 0f 1e fa          	endbr64 
ffff800000101c92:	55                   	push   %rbp
ffff800000101c93:	48 89 e5             	mov    %rsp,%rbp
ffff800000101c96:	53                   	push   %rbx
ffff800000101c97:	48 83 ec 48          	sub    $0x48,%rsp
ffff800000101c9b:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  struct file ff;

  acquire(&ftable.lock);
ffff800000101c9f:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101ca6:	80 ff ff 
ffff800000101ca9:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000101cb0:	80 ff ff 
ffff800000101cb3:	ff d0                	callq  *%rax
  if(f->ref < 1)
ffff800000101cb5:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101cb9:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101cbc:	85 c0                	test   %eax,%eax
ffff800000101cbe:	7f 16                	jg     ffff800000101cd6 <fileclose+0x48>
    panic("fileclose");
ffff800000101cc0:	48 bf 28 c5 10 00 00 	movabs $0xffff80000010c528,%rdi
ffff800000101cc7:	80 ff ff 
ffff800000101cca:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000101cd1:	80 ff ff 
ffff800000101cd4:	ff d0                	callq  *%rax
  if(--f->ref > 0){
ffff800000101cd6:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101cda:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101cdd:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000101ce0:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101ce4:	89 50 04             	mov    %edx,0x4(%rax)
ffff800000101ce7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101ceb:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101cee:	85 c0                	test   %eax,%eax
ffff800000101cf0:	7e 1b                	jle    ffff800000101d0d <fileclose+0x7f>
    release(&ftable.lock);
ffff800000101cf2:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101cf9:	80 ff ff 
ffff800000101cfc:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000101d03:	80 ff ff 
ffff800000101d06:	ff d0                	callq  *%rax
ffff800000101d08:	e9 b9 00 00 00       	jmpq   ffff800000101dc6 <fileclose+0x138>
    return;
  }
  ff = *f;
ffff800000101d0d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101d11:	48 8b 08             	mov    (%rax),%rcx
ffff800000101d14:	48 8b 58 08          	mov    0x8(%rax),%rbx
ffff800000101d18:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
ffff800000101d1c:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
ffff800000101d20:	48 8b 48 10          	mov    0x10(%rax),%rcx
ffff800000101d24:	48 8b 58 18          	mov    0x18(%rax),%rbx
ffff800000101d28:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
ffff800000101d2c:	48 89 5d d8          	mov    %rbx,-0x28(%rbp)
ffff800000101d30:	48 8b 40 20          	mov    0x20(%rax),%rax
ffff800000101d34:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  f->ref = 0;
ffff800000101d38:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101d3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
  f->type = FD_NONE;
ffff800000101d43:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101d47:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  release(&ftable.lock);
ffff800000101d4d:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101d54:	80 ff ff 
ffff800000101d57:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000101d5e:	80 ff ff 
ffff800000101d61:	ff d0                	callq  *%rax

  if(ff.type == FD_PIPE)
ffff800000101d63:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff800000101d66:	83 f8 01             	cmp    $0x1,%eax
ffff800000101d69:	75 1e                	jne    ffff800000101d89 <fileclose+0xfb>
    pipeclose(ff.pipe, ff.writable);
ffff800000101d6b:	0f b6 45 c9          	movzbl -0x37(%rbp),%eax
ffff800000101d6f:	0f be d0             	movsbl %al,%edx
ffff800000101d72:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000101d76:	89 d6                	mov    %edx,%esi
ffff800000101d78:	48 89 c7             	mov    %rax,%rdi
ffff800000101d7b:	48 b8 b7 61 10 00 00 	movabs $0xffff8000001061b7,%rax
ffff800000101d82:	80 ff ff 
ffff800000101d85:	ff d0                	callq  *%rax
ffff800000101d87:	eb 3d                	jmp    ffff800000101dc6 <fileclose+0x138>
  else if(ff.type == FD_INODE){
ffff800000101d89:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff800000101d8c:	83 f8 02             	cmp    $0x2,%eax
ffff800000101d8f:	75 35                	jne    ffff800000101dc6 <fileclose+0x138>
    begin_op();
ffff800000101d91:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101d96:	48 ba ab 52 10 00 00 	movabs $0xffff8000001052ab,%rdx
ffff800000101d9d:	80 ff ff 
ffff800000101da0:	ff d2                	callq  *%rdx
    iput(ff.ip);
ffff800000101da2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000101da6:	48 89 c7             	mov    %rax,%rdi
ffff800000101da9:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff800000101db0:	80 ff ff 
ffff800000101db3:	ff d0                	callq  *%rax
    end_op();
ffff800000101db5:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101dba:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff800000101dc1:	80 ff ff 
ffff800000101dc4:	ff d2                	callq  *%rdx
  }
}
ffff800000101dc6:	48 83 c4 48          	add    $0x48,%rsp
ffff800000101dca:	5b                   	pop    %rbx
ffff800000101dcb:	5d                   	pop    %rbp
ffff800000101dcc:	c3                   	retq   

ffff800000101dcd <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
ffff800000101dcd:	f3 0f 1e fa          	endbr64 
ffff800000101dd1:	55                   	push   %rbp
ffff800000101dd2:	48 89 e5             	mov    %rsp,%rbp
ffff800000101dd5:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000101dd9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000101ddd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(f->type == FD_INODE){
ffff800000101de1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101de5:	8b 00                	mov    (%rax),%eax
ffff800000101de7:	83 f8 02             	cmp    $0x2,%eax
ffff800000101dea:	75 53                	jne    ffff800000101e3f <filestat+0x72>
    ilock(f->ip);
ffff800000101dec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101df0:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101df4:	48 89 c7             	mov    %rax,%rdi
ffff800000101df7:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000101dfe:	80 ff ff 
ffff800000101e01:	ff d0                	callq  *%rax
    stati(f->ip, st);
ffff800000101e03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101e07:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101e0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000101e0f:	48 89 d6             	mov    %rdx,%rsi
ffff800000101e12:	48 89 c7             	mov    %rax,%rdi
ffff800000101e15:	48 b8 e7 2e 10 00 00 	movabs $0xffff800000102ee7,%rax
ffff800000101e1c:	80 ff ff 
ffff800000101e1f:	ff d0                	callq  *%rax
    iunlock(f->ip);
ffff800000101e21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101e25:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101e29:	48 89 c7             	mov    %rax,%rdi
ffff800000101e2c:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000101e33:	80 ff ff 
ffff800000101e36:	ff d0                	callq  *%rax
    return 0;
ffff800000101e38:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101e3d:	eb 05                	jmp    ffff800000101e44 <filestat+0x77>
  }
  return -1;
ffff800000101e3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000101e44:	c9                   	leaveq 
ffff800000101e45:	c3                   	retq   

ffff800000101e46 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
ffff800000101e46:	f3 0f 1e fa          	endbr64 
ffff800000101e4a:	55                   	push   %rbp
ffff800000101e4b:	48 89 e5             	mov    %rsp,%rbp
ffff800000101e4e:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000101e52:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000101e56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000101e5a:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int r;

  if(f->readable == 0)
ffff800000101e5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101e61:	0f b6 40 08          	movzbl 0x8(%rax),%eax
ffff800000101e65:	84 c0                	test   %al,%al
ffff800000101e67:	75 0a                	jne    ffff800000101e73 <fileread+0x2d>
    return -1;
ffff800000101e69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000101e6e:	e9 c6 00 00 00       	jmpq   ffff800000101f39 <fileread+0xf3>
  if(f->type == FD_PIPE)
ffff800000101e73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101e77:	8b 00                	mov    (%rax),%eax
ffff800000101e79:	83 f8 01             	cmp    $0x1,%eax
ffff800000101e7c:	75 26                	jne    ffff800000101ea4 <fileread+0x5e>
    return piperead(f->pipe, addr, n);
ffff800000101e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101e82:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000101e86:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff800000101e89:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff800000101e8d:	48 89 ce             	mov    %rcx,%rsi
ffff800000101e90:	48 89 c7             	mov    %rax,%rdi
ffff800000101e93:	48 b8 d2 63 10 00 00 	movabs $0xffff8000001063d2,%rax
ffff800000101e9a:	80 ff ff 
ffff800000101e9d:	ff d0                	callq  *%rax
ffff800000101e9f:	e9 95 00 00 00       	jmpq   ffff800000101f39 <fileread+0xf3>
  if(f->type == FD_INODE){
ffff800000101ea4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101ea8:	8b 00                	mov    (%rax),%eax
ffff800000101eaa:	83 f8 02             	cmp    $0x2,%eax
ffff800000101ead:	75 74                	jne    ffff800000101f23 <fileread+0xdd>
    ilock(f->ip);
ffff800000101eaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101eb3:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101eb7:	48 89 c7             	mov    %rax,%rdi
ffff800000101eba:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000101ec1:	80 ff ff 
ffff800000101ec4:	ff d0                	callq  *%rax
    if((r = readi(f->ip, addr, f->off, n)) > 0)
ffff800000101ec6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
ffff800000101ec9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101ecd:	8b 50 20             	mov    0x20(%rax),%edx
ffff800000101ed0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101ed4:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101ed8:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
ffff800000101edc:	48 89 c7             	mov    %rax,%rdi
ffff800000101edf:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff800000101ee6:	80 ff ff 
ffff800000101ee9:	ff d0                	callq  *%rax
ffff800000101eeb:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000101eee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000101ef2:	7e 13                	jle    ffff800000101f07 <fileread+0xc1>
      f->off += r;
ffff800000101ef4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101ef8:	8b 50 20             	mov    0x20(%rax),%edx
ffff800000101efb:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101efe:	01 c2                	add    %eax,%edx
ffff800000101f00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f04:	89 50 20             	mov    %edx,0x20(%rax)
    iunlock(f->ip);
ffff800000101f07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f0b:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101f0f:	48 89 c7             	mov    %rax,%rdi
ffff800000101f12:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000101f19:	80 ff ff 
ffff800000101f1c:	ff d0                	callq  *%rax
    return r;
ffff800000101f1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101f21:	eb 16                	jmp    ffff800000101f39 <fileread+0xf3>
  }
  panic("fileread");
ffff800000101f23:	48 bf 32 c5 10 00 00 	movabs $0xffff80000010c532,%rdi
ffff800000101f2a:	80 ff ff 
ffff800000101f2d:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000101f34:	80 ff ff 
ffff800000101f37:	ff d0                	callq  *%rax
}
ffff800000101f39:	c9                   	leaveq 
ffff800000101f3a:	c3                   	retq   

ffff800000101f3b <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
ffff800000101f3b:	f3 0f 1e fa          	endbr64 
ffff800000101f3f:	55                   	push   %rbp
ffff800000101f40:	48 89 e5             	mov    %rsp,%rbp
ffff800000101f43:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000101f47:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000101f4b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000101f4f:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int r;

  if(f->writable == 0)
ffff800000101f52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f56:	0f b6 40 09          	movzbl 0x9(%rax),%eax
ffff800000101f5a:	84 c0                	test   %al,%al
ffff800000101f5c:	75 0a                	jne    ffff800000101f68 <filewrite+0x2d>
    return -1;
ffff800000101f5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000101f63:	e9 67 01 00 00       	jmpq   ffff8000001020cf <filewrite+0x194>
  if(f->type == FD_PIPE)
ffff800000101f68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f6c:	8b 00                	mov    (%rax),%eax
ffff800000101f6e:	83 f8 01             	cmp    $0x1,%eax
ffff800000101f71:	75 26                	jne    ffff800000101f99 <filewrite+0x5e>
    return pipewrite(f->pipe, addr, n);
ffff800000101f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f77:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000101f7b:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff800000101f7e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff800000101f82:	48 89 ce             	mov    %rcx,%rsi
ffff800000101f85:	48 89 c7             	mov    %rax,%rdi
ffff800000101f88:	48 b8 8e 62 10 00 00 	movabs $0xffff80000010628e,%rax
ffff800000101f8f:	80 ff ff 
ffff800000101f92:	ff d0                	callq  *%rax
ffff800000101f94:	e9 36 01 00 00       	jmpq   ffff8000001020cf <filewrite+0x194>
  if(f->type == FD_INODE){
ffff800000101f99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f9d:	8b 00                	mov    (%rax),%eax
ffff800000101f9f:	83 f8 02             	cmp    $0x2,%eax
ffff800000101fa2:	0f 85 11 01 00 00    	jne    ffff8000001020b9 <filewrite+0x17e>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
ffff800000101fa8:	c7 45 f4 00 1a 00 00 	movl   $0x1a00,-0xc(%rbp)
    int i = 0;
ffff800000101faf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    while(i < n){
ffff800000101fb6:	e9 db 00 00 00       	jmpq   ffff800000102096 <filewrite+0x15b>
      int n1 = n - i;
ffff800000101fbb:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000101fbe:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff800000101fc1:	89 45 f8             	mov    %eax,-0x8(%rbp)
      if(n1 > max)
ffff800000101fc4:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000101fc7:	3b 45 f4             	cmp    -0xc(%rbp),%eax
ffff800000101fca:	7e 06                	jle    ffff800000101fd2 <filewrite+0x97>
        n1 = max;
ffff800000101fcc:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000101fcf:	89 45 f8             	mov    %eax,-0x8(%rbp)

      begin_op();
ffff800000101fd2:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101fd7:	48 ba ab 52 10 00 00 	movabs $0xffff8000001052ab,%rdx
ffff800000101fde:	80 ff ff 
ffff800000101fe1:	ff d2                	callq  *%rdx
      ilock(f->ip);
ffff800000101fe3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101fe7:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101feb:	48 89 c7             	mov    %rax,%rdi
ffff800000101fee:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000101ff5:	80 ff ff 
ffff800000101ff8:	ff d0                	callq  *%rax
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
ffff800000101ffa:	8b 4d f8             	mov    -0x8(%rbp),%ecx
ffff800000101ffd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102001:	8b 50 20             	mov    0x20(%rax),%edx
ffff800000102004:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102007:	48 63 f0             	movslq %eax,%rsi
ffff80000010200a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010200e:	48 01 c6             	add    %rax,%rsi
ffff800000102011:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102015:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000102019:	48 89 c7             	mov    %rax,%rdi
ffff80000010201c:	48 b8 22 31 10 00 00 	movabs $0xffff800000103122,%rax
ffff800000102023:	80 ff ff 
ffff800000102026:	ff d0                	callq  *%rax
ffff800000102028:	89 45 f0             	mov    %eax,-0x10(%rbp)
ffff80000010202b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
ffff80000010202f:	7e 13                	jle    ffff800000102044 <filewrite+0x109>
        f->off += r;
ffff800000102031:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102035:	8b 50 20             	mov    0x20(%rax),%edx
ffff800000102038:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff80000010203b:	01 c2                	add    %eax,%edx
ffff80000010203d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102041:	89 50 20             	mov    %edx,0x20(%rax)
      iunlock(f->ip);
ffff800000102044:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102048:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff80000010204c:	48 89 c7             	mov    %rax,%rdi
ffff80000010204f:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000102056:	80 ff ff 
ffff800000102059:	ff d0                	callq  *%rax
      end_op();
ffff80000010205b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000102060:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff800000102067:	80 ff ff 
ffff80000010206a:	ff d2                	callq  *%rdx

      if(r < 0)
ffff80000010206c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
ffff800000102070:	78 32                	js     ffff8000001020a4 <filewrite+0x169>
        break;
      if(r != n1)
ffff800000102072:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000102075:	3b 45 f8             	cmp    -0x8(%rbp),%eax
ffff800000102078:	74 16                	je     ffff800000102090 <filewrite+0x155>
        panic("short filewrite");
ffff80000010207a:	48 bf 3b c5 10 00 00 	movabs $0xffff80000010c53b,%rdi
ffff800000102081:	80 ff ff 
ffff800000102084:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010208b:	80 ff ff 
ffff80000010208e:	ff d0                	callq  *%rax
      i += r;
ffff800000102090:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000102093:	01 45 fc             	add    %eax,-0x4(%rbp)
    while(i < n){
ffff800000102096:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102099:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff80000010209c:	0f 8c 19 ff ff ff    	jl     ffff800000101fbb <filewrite+0x80>
ffff8000001020a2:	eb 01                	jmp    ffff8000001020a5 <filewrite+0x16a>
        break;
ffff8000001020a4:	90                   	nop
    }
    return i == n ? n : -1;
ffff8000001020a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001020a8:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff8000001020ab:	75 05                	jne    ffff8000001020b2 <filewrite+0x177>
ffff8000001020ad:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001020b0:	eb 1d                	jmp    ffff8000001020cf <filewrite+0x194>
ffff8000001020b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001020b7:	eb 16                	jmp    ffff8000001020cf <filewrite+0x194>
  }
  panic("filewrite");
ffff8000001020b9:	48 bf 4b c5 10 00 00 	movabs $0xffff80000010c54b,%rdi
ffff8000001020c0:	80 ff ff 
ffff8000001020c3:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001020ca:	80 ff ff 
ffff8000001020cd:	ff d0                	callq  *%rax
}
ffff8000001020cf:	c9                   	leaveq 
ffff8000001020d0:	c3                   	retq   

ffff8000001020d1 <readsb>:
struct superblock sb;

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
ffff8000001020d1:	f3 0f 1e fa          	endbr64 
ffff8000001020d5:	55                   	push   %rbp
ffff8000001020d6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001020d9:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001020dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff8000001020e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct buf *bp = bread(dev, 1);
ffff8000001020e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001020e7:	be 01 00 00 00       	mov    $0x1,%esi
ffff8000001020ec:	89 c7                	mov    %eax,%edi
ffff8000001020ee:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff8000001020f5:	80 ff ff 
ffff8000001020f8:	ff d0                	callq  *%rax
ffff8000001020fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memmove(sb, bp->data, sizeof(*sb));
ffff8000001020fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102102:	48 8d 88 b0 00 00 00 	lea    0xb0(%rax),%rcx
ffff800000102109:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010210d:	ba 1c 00 00 00       	mov    $0x1c,%edx
ffff800000102112:	48 89 ce             	mov    %rcx,%rsi
ffff800000102115:	48 89 c7             	mov    %rax,%rdi
ffff800000102118:	48 b8 10 7d 10 00 00 	movabs $0xffff800000107d10,%rax
ffff80000010211f:	80 ff ff 
ffff800000102122:	ff d0                	callq  *%rax
  brelse(bp);
ffff800000102124:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102128:	48 89 c7             	mov    %rax,%rdi
ffff80000010212b:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102132:	80 ff ff 
ffff800000102135:	ff d0                	callq  *%rax
}
ffff800000102137:	90                   	nop
ffff800000102138:	c9                   	leaveq 
ffff800000102139:	c3                   	retq   

ffff80000010213a <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
ffff80000010213a:	f3 0f 1e fa          	endbr64 
ffff80000010213e:	55                   	push   %rbp
ffff80000010213f:	48 89 e5             	mov    %rsp,%rbp
ffff800000102142:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000102146:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000102149:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct buf *bp = bread(dev, bno);
ffff80000010214c:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff80000010214f:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000102152:	89 d6                	mov    %edx,%esi
ffff800000102154:	89 c7                	mov    %eax,%edi
ffff800000102156:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff80000010215d:	80 ff ff 
ffff800000102160:	ff d0                	callq  *%rax
ffff800000102162:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(bp->data, 0, BSIZE);
ffff800000102166:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010216a:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000102170:	ba 00 02 00 00       	mov    $0x200,%edx
ffff800000102175:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010217a:	48 89 c7             	mov    %rax,%rdi
ffff80000010217d:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff800000102184:	80 ff ff 
ffff800000102187:	ff d0                	callq  *%rax
  log_write(bp);
ffff800000102189:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010218d:	48 89 c7             	mov    %rax,%rdi
ffff800000102190:	48 b8 21 56 10 00 00 	movabs $0xffff800000105621,%rax
ffff800000102197:	80 ff ff 
ffff80000010219a:	ff d0                	callq  *%rax
  brelse(bp);
ffff80000010219c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001021a0:	48 89 c7             	mov    %rax,%rdi
ffff8000001021a3:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff8000001021aa:	80 ff ff 
ffff8000001021ad:	ff d0                	callq  *%rax
}
ffff8000001021af:	90                   	nop
ffff8000001021b0:	c9                   	leaveq 
ffff8000001021b1:	c3                   	retq   

ffff8000001021b2 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
ffff8000001021b2:	f3 0f 1e fa          	endbr64 
ffff8000001021b6:	55                   	push   %rbp
ffff8000001021b7:	48 89 e5             	mov    %rsp,%rbp
ffff8000001021ba:	48 83 ec 30          	sub    $0x30,%rsp
ffff8000001021be:	89 7d dc             	mov    %edi,-0x24(%rbp)
  int b, bi, m;
  struct buf *bp;
  for(b = 0; b < sb.size; b += BPB){
ffff8000001021c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001021c8:	e9 52 01 00 00       	jmpq   ffff80000010231f <balloc+0x16d>
    bp = bread(dev, BBLOCK(b, sb));
ffff8000001021cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001021d0:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
ffff8000001021d6:	85 c0                	test   %eax,%eax
ffff8000001021d8:	0f 48 c2             	cmovs  %edx,%eax
ffff8000001021db:	c1 f8 0c             	sar    $0xc,%eax
ffff8000001021de:	89 c2                	mov    %eax,%edx
ffff8000001021e0:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff8000001021e7:	80 ff ff 
ffff8000001021ea:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001021ed:	01 c2                	add    %eax,%edx
ffff8000001021ef:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001021f2:	89 d6                	mov    %edx,%esi
ffff8000001021f4:	89 c7                	mov    %eax,%edi
ffff8000001021f6:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff8000001021fd:	80 ff ff 
ffff800000102200:	ff d0                	callq  *%rax
ffff800000102202:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
ffff800000102206:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
ffff80000010220d:	e9 cc 00 00 00       	jmpq   ffff8000001022de <balloc+0x12c>
      m = 1 << (bi % 8);
ffff800000102212:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102215:	99                   	cltd   
ffff800000102216:	c1 ea 1d             	shr    $0x1d,%edx
ffff800000102219:	01 d0                	add    %edx,%eax
ffff80000010221b:	83 e0 07             	and    $0x7,%eax
ffff80000010221e:	29 d0                	sub    %edx,%eax
ffff800000102220:	ba 01 00 00 00       	mov    $0x1,%edx
ffff800000102225:	89 c1                	mov    %eax,%ecx
ffff800000102227:	d3 e2                	shl    %cl,%edx
ffff800000102229:	89 d0                	mov    %edx,%eax
ffff80000010222b:	89 45 ec             	mov    %eax,-0x14(%rbp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
ffff80000010222e:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102231:	8d 50 07             	lea    0x7(%rax),%edx
ffff800000102234:	85 c0                	test   %eax,%eax
ffff800000102236:	0f 48 c2             	cmovs  %edx,%eax
ffff800000102239:	c1 f8 03             	sar    $0x3,%eax
ffff80000010223c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000102240:	48 98                	cltq   
ffff800000102242:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff800000102249:	00 
ffff80000010224a:	0f b6 c0             	movzbl %al,%eax
ffff80000010224d:	23 45 ec             	and    -0x14(%rbp),%eax
ffff800000102250:	85 c0                	test   %eax,%eax
ffff800000102252:	0f 85 82 00 00 00    	jne    ffff8000001022da <balloc+0x128>
        bp->data[bi/8] |= m;  // Mark block in use.
ffff800000102258:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010225b:	8d 50 07             	lea    0x7(%rax),%edx
ffff80000010225e:	85 c0                	test   %eax,%eax
ffff800000102260:	0f 48 c2             	cmovs  %edx,%eax
ffff800000102263:	c1 f8 03             	sar    $0x3,%eax
ffff800000102266:	89 c1                	mov    %eax,%ecx
ffff800000102268:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010226c:	48 63 c1             	movslq %ecx,%rax
ffff80000010226f:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff800000102276:	00 
ffff800000102277:	89 c2                	mov    %eax,%edx
ffff800000102279:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010227c:	09 d0                	or     %edx,%eax
ffff80000010227e:	89 c6                	mov    %eax,%esi
ffff800000102280:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000102284:	48 63 c1             	movslq %ecx,%rax
ffff800000102287:	40 88 b4 02 b0 00 00 	mov    %sil,0xb0(%rdx,%rax,1)
ffff80000010228e:	00 
        log_write(bp);
ffff80000010228f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102293:	48 89 c7             	mov    %rax,%rdi
ffff800000102296:	48 b8 21 56 10 00 00 	movabs $0xffff800000105621,%rax
ffff80000010229d:	80 ff ff 
ffff8000001022a0:	ff d0                	callq  *%rax
        brelse(bp);
ffff8000001022a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001022a6:	48 89 c7             	mov    %rax,%rdi
ffff8000001022a9:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff8000001022b0:	80 ff ff 
ffff8000001022b3:	ff d0                	callq  *%rax
        bzero(dev, b + bi);
ffff8000001022b5:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001022b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001022bb:	01 c2                	add    %eax,%edx
ffff8000001022bd:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001022c0:	89 d6                	mov    %edx,%esi
ffff8000001022c2:	89 c7                	mov    %eax,%edi
ffff8000001022c4:	48 b8 3a 21 10 00 00 	movabs $0xffff80000010213a,%rax
ffff8000001022cb:	80 ff ff 
ffff8000001022ce:	ff d0                	callq  *%rax
        return b + bi;
ffff8000001022d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001022d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001022d6:	01 d0                	add    %edx,%eax
ffff8000001022d8:	eb 72                	jmp    ffff80000010234c <balloc+0x19a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
ffff8000001022da:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
ffff8000001022de:	81 7d f8 ff 0f 00 00 	cmpl   $0xfff,-0x8(%rbp)
ffff8000001022e5:	7f 1e                	jg     ffff800000102305 <balloc+0x153>
ffff8000001022e7:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001022ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001022ed:	01 d0                	add    %edx,%eax
ffff8000001022ef:	89 c2                	mov    %eax,%edx
ffff8000001022f1:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff8000001022f8:	80 ff ff 
ffff8000001022fb:	8b 00                	mov    (%rax),%eax
ffff8000001022fd:	39 c2                	cmp    %eax,%edx
ffff8000001022ff:	0f 82 0d ff ff ff    	jb     ffff800000102212 <balloc+0x60>
      }
    }
    brelse(bp);
ffff800000102305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102309:	48 89 c7             	mov    %rax,%rdi
ffff80000010230c:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102313:	80 ff ff 
ffff800000102316:	ff d0                	callq  *%rax
  for(b = 0; b < sb.size; b += BPB){
ffff800000102318:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
ffff80000010231f:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff800000102326:	80 ff ff 
ffff800000102329:	8b 10                	mov    (%rax),%edx
ffff80000010232b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010232e:	39 c2                	cmp    %eax,%edx
ffff800000102330:	0f 87 97 fe ff ff    	ja     ffff8000001021cd <balloc+0x1b>
  }
  panic("balloc: out of blocks");
ffff800000102336:	48 bf 55 c5 10 00 00 	movabs $0xffff80000010c555,%rdi
ffff80000010233d:	80 ff ff 
ffff800000102340:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102347:	80 ff ff 
ffff80000010234a:	ff d0                	callq  *%rax
}
ffff80000010234c:	c9                   	leaveq 
ffff80000010234d:	c3                   	retq   

ffff80000010234e <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
ffff80000010234e:	f3 0f 1e fa          	endbr64 
ffff800000102352:	55                   	push   %rbp
ffff800000102353:	48 89 e5             	mov    %rsp,%rbp
ffff800000102356:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010235a:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff80000010235d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int bi, m;

  readsb(dev, &sb);
ffff800000102360:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000102363:	48 be 00 46 11 00 00 	movabs $0xffff800000114600,%rsi
ffff80000010236a:	80 ff ff 
ffff80000010236d:	89 c7                	mov    %eax,%edi
ffff80000010236f:	48 b8 d1 20 10 00 00 	movabs $0xffff8000001020d1,%rax
ffff800000102376:	80 ff ff 
ffff800000102379:	ff d0                	callq  *%rax
  struct buf *bp = bread(dev, BBLOCK(b, sb));
ffff80000010237b:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff80000010237e:	c1 e8 0c             	shr    $0xc,%eax
ffff800000102381:	89 c2                	mov    %eax,%edx
ffff800000102383:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff80000010238a:	80 ff ff 
ffff80000010238d:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000102390:	01 c2                	add    %eax,%edx
ffff800000102392:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000102395:	89 d6                	mov    %edx,%esi
ffff800000102397:	89 c7                	mov    %eax,%edi
ffff800000102399:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff8000001023a0:	80 ff ff 
ffff8000001023a3:	ff d0                	callq  *%rax
ffff8000001023a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  bi = b % BPB;
ffff8000001023a9:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff8000001023ac:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff8000001023b1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  m = 1 << (bi % 8);
ffff8000001023b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001023b7:	99                   	cltd   
ffff8000001023b8:	c1 ea 1d             	shr    $0x1d,%edx
ffff8000001023bb:	01 d0                	add    %edx,%eax
ffff8000001023bd:	83 e0 07             	and    $0x7,%eax
ffff8000001023c0:	29 d0                	sub    %edx,%eax
ffff8000001023c2:	ba 01 00 00 00       	mov    $0x1,%edx
ffff8000001023c7:	89 c1                	mov    %eax,%ecx
ffff8000001023c9:	d3 e2                	shl    %cl,%edx
ffff8000001023cb:	89 d0                	mov    %edx,%eax
ffff8000001023cd:	89 45 f0             	mov    %eax,-0x10(%rbp)
  if((bp->data[bi/8] & m) == 0)
ffff8000001023d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001023d3:	8d 50 07             	lea    0x7(%rax),%edx
ffff8000001023d6:	85 c0                	test   %eax,%eax
ffff8000001023d8:	0f 48 c2             	cmovs  %edx,%eax
ffff8000001023db:	c1 f8 03             	sar    $0x3,%eax
ffff8000001023de:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001023e2:	48 98                	cltq   
ffff8000001023e4:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff8000001023eb:	00 
ffff8000001023ec:	0f b6 c0             	movzbl %al,%eax
ffff8000001023ef:	23 45 f0             	and    -0x10(%rbp),%eax
ffff8000001023f2:	85 c0                	test   %eax,%eax
ffff8000001023f4:	75 16                	jne    ffff80000010240c <bfree+0xbe>
    panic("freeing free block");
ffff8000001023f6:	48 bf 6b c5 10 00 00 	movabs $0xffff80000010c56b,%rdi
ffff8000001023fd:	80 ff ff 
ffff800000102400:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102407:	80 ff ff 
ffff80000010240a:	ff d0                	callq  *%rax
  bp->data[bi/8] &= ~m;
ffff80000010240c:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010240f:	8d 50 07             	lea    0x7(%rax),%edx
ffff800000102412:	85 c0                	test   %eax,%eax
ffff800000102414:	0f 48 c2             	cmovs  %edx,%eax
ffff800000102417:	c1 f8 03             	sar    $0x3,%eax
ffff80000010241a:	89 c1                	mov    %eax,%ecx
ffff80000010241c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000102420:	48 63 c1             	movslq %ecx,%rax
ffff800000102423:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff80000010242a:	00 
ffff80000010242b:	89 c2                	mov    %eax,%edx
ffff80000010242d:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000102430:	f7 d0                	not    %eax
ffff800000102432:	21 d0                	and    %edx,%eax
ffff800000102434:	89 c6                	mov    %eax,%esi
ffff800000102436:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010243a:	48 63 c1             	movslq %ecx,%rax
ffff80000010243d:	40 88 b4 02 b0 00 00 	mov    %sil,0xb0(%rdx,%rax,1)
ffff800000102444:	00 
  log_write(bp);
ffff800000102445:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102449:	48 89 c7             	mov    %rax,%rdi
ffff80000010244c:	48 b8 21 56 10 00 00 	movabs $0xffff800000105621,%rax
ffff800000102453:	80 ff ff 
ffff800000102456:	ff d0                	callq  *%rax
  brelse(bp);
ffff800000102458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010245c:	48 89 c7             	mov    %rax,%rdi
ffff80000010245f:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102466:	80 ff ff 
ffff800000102469:	ff d0                	callq  *%rax
}
ffff80000010246b:	90                   	nop
ffff80000010246c:	c9                   	leaveq 
ffff80000010246d:	c3                   	retq   

ffff80000010246e <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
ffff80000010246e:	f3 0f 1e fa          	endbr64 
ffff800000102472:	55                   	push   %rbp
ffff800000102473:	48 89 e5             	mov    %rsp,%rbp
ffff800000102476:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010247a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int i = 0;
ffff80000010247d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

  initlock(&icache.lock, "icache");
ffff800000102484:	48 be 7e c5 10 00 00 	movabs $0xffff80000010c57e,%rsi
ffff80000010248b:	80 ff ff 
ffff80000010248e:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102495:	80 ff ff 
ffff800000102498:	48 b8 24 78 10 00 00 	movabs $0xffff800000107824,%rax
ffff80000010249f:	80 ff ff 
ffff8000001024a2:	ff d0                	callq  *%rax
  for(i = 0; i < NINODE; i++) {
ffff8000001024a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001024ab:	eb 50                	jmp    ffff8000001024fd <iinit+0x8f>
    initsleeplock(&icache.inode[i].lock, "inode");
ffff8000001024ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001024b0:	48 63 d0             	movslq %eax,%rdx
ffff8000001024b3:	48 89 d0             	mov    %rdx,%rax
ffff8000001024b6:	48 01 c0             	add    %rax,%rax
ffff8000001024b9:	48 01 d0             	add    %rdx,%rax
ffff8000001024bc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff8000001024c3:	00 
ffff8000001024c4:	48 01 d0             	add    %rdx,%rax
ffff8000001024c7:	48 c1 e0 03          	shl    $0x3,%rax
ffff8000001024cb:	48 8d 50 70          	lea    0x70(%rax),%rdx
ffff8000001024cf:	48 b8 20 46 11 00 00 	movabs $0xffff800000114620,%rax
ffff8000001024d6:	80 ff ff 
ffff8000001024d9:	48 01 d0             	add    %rdx,%rax
ffff8000001024dc:	48 83 c0 08          	add    $0x8,%rax
ffff8000001024e0:	48 be 85 c5 10 00 00 	movabs $0xffff80000010c585,%rsi
ffff8000001024e7:	80 ff ff 
ffff8000001024ea:	48 89 c7             	mov    %rax,%rdi
ffff8000001024ed:	48 b8 31 76 10 00 00 	movabs $0xffff800000107631,%rax
ffff8000001024f4:	80 ff ff 
ffff8000001024f7:	ff d0                	callq  *%rax
  for(i = 0; i < NINODE; i++) {
ffff8000001024f9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001024fd:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
ffff800000102501:	7e aa                	jle    ffff8000001024ad <iinit+0x3f>
  }

  readsb(dev, &sb);
ffff800000102503:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000102506:	48 be 00 46 11 00 00 	movabs $0xffff800000114600,%rsi
ffff80000010250d:	80 ff ff 
ffff800000102510:	89 c7                	mov    %eax,%edi
ffff800000102512:	48 b8 d1 20 10 00 00 	movabs $0xffff8000001020d1,%rax
ffff800000102519:	80 ff ff 
ffff80000010251c:	ff d0                	callq  *%rax
  /*cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);*/
}
ffff80000010251e:	90                   	nop
ffff80000010251f:	c9                   	leaveq 
ffff800000102520:	c3                   	retq   

ffff800000102521 <ialloc>:

// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
ffff800000102521:	f3 0f 1e fa          	endbr64 
ffff800000102525:	55                   	push   %rbp
ffff800000102526:	48 89 e5             	mov    %rsp,%rbp
ffff800000102529:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010252d:	89 7d dc             	mov    %edi,-0x24(%rbp)
ffff800000102530:	89 f0                	mov    %esi,%eax
ffff800000102532:	66 89 45 d8          	mov    %ax,-0x28(%rbp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
ffff800000102536:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
ffff80000010253d:	e9 d8 00 00 00       	jmpq   ffff80000010261a <ialloc+0xf9>
    bp = bread(dev, IBLOCK(inum, sb));
ffff800000102542:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102545:	48 98                	cltq   
ffff800000102547:	48 c1 e8 03          	shr    $0x3,%rax
ffff80000010254b:	89 c2                	mov    %eax,%edx
ffff80000010254d:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff800000102554:	80 ff ff 
ffff800000102557:	8b 40 14             	mov    0x14(%rax),%eax
ffff80000010255a:	01 c2                	add    %eax,%edx
ffff80000010255c:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff80000010255f:	89 d6                	mov    %edx,%esi
ffff800000102561:	89 c7                	mov    %eax,%edi
ffff800000102563:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff80000010256a:	80 ff ff 
ffff80000010256d:	ff d0                	callq  *%rax
ffff80000010256f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    dip = (struct dinode*)bp->data + inum%IPB;
ffff800000102573:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102577:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff80000010257e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102581:	48 98                	cltq   
ffff800000102583:	83 e0 07             	and    $0x7,%eax
ffff800000102586:	48 c1 e0 06          	shl    $0x6,%rax
ffff80000010258a:	48 01 d0             	add    %rdx,%rax
ffff80000010258d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if(dip->type == 0){  // a free inode
ffff800000102591:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102595:	0f b7 00             	movzwl (%rax),%eax
ffff800000102598:	66 85 c0             	test   %ax,%ax
ffff80000010259b:	75 66                	jne    ffff800000102603 <ialloc+0xe2>
      memset(dip, 0, sizeof(*dip));
ffff80000010259d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001025a1:	ba 40 00 00 00       	mov    $0x40,%edx
ffff8000001025a6:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001025ab:	48 89 c7             	mov    %rax,%rdi
ffff8000001025ae:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff8000001025b5:	80 ff ff 
ffff8000001025b8:	ff d0                	callq  *%rax
      dip->type = type;
ffff8000001025ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001025be:	0f b7 55 d8          	movzwl -0x28(%rbp),%edx
ffff8000001025c2:	66 89 10             	mov    %dx,(%rax)
      log_write(bp);   // mark it allocated on the disk
ffff8000001025c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001025c9:	48 89 c7             	mov    %rax,%rdi
ffff8000001025cc:	48 b8 21 56 10 00 00 	movabs $0xffff800000105621,%rax
ffff8000001025d3:	80 ff ff 
ffff8000001025d6:	ff d0                	callq  *%rax
      brelse(bp);
ffff8000001025d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001025dc:	48 89 c7             	mov    %rax,%rdi
ffff8000001025df:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff8000001025e6:	80 ff ff 
ffff8000001025e9:	ff d0                	callq  *%rax
      return iget(dev, inum);
ffff8000001025eb:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001025ee:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001025f1:	89 d6                	mov    %edx,%esi
ffff8000001025f3:	89 c7                	mov    %eax,%edi
ffff8000001025f5:	48 b8 60 27 10 00 00 	movabs $0xffff800000102760,%rax
ffff8000001025fc:	80 ff ff 
ffff8000001025ff:	ff d0                	callq  *%rax
ffff800000102601:	eb 45                	jmp    ffff800000102648 <ialloc+0x127>
    }
    brelse(bp);
ffff800000102603:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102607:	48 89 c7             	mov    %rax,%rdi
ffff80000010260a:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102611:	80 ff ff 
ffff800000102614:	ff d0                	callq  *%rax
  for(inum = 1; inum < sb.ninodes; inum++){
ffff800000102616:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010261a:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff800000102621:	80 ff ff 
ffff800000102624:	8b 50 08             	mov    0x8(%rax),%edx
ffff800000102627:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010262a:	39 c2                	cmp    %eax,%edx
ffff80000010262c:	0f 87 10 ff ff ff    	ja     ffff800000102542 <ialloc+0x21>
  }
  panic("ialloc: no inodes");
ffff800000102632:	48 bf 8b c5 10 00 00 	movabs $0xffff80000010c58b,%rdi
ffff800000102639:	80 ff ff 
ffff80000010263c:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102643:	80 ff ff 
ffff800000102646:	ff d0                	callq  *%rax
}
ffff800000102648:	c9                   	leaveq 
ffff800000102649:	c3                   	retq   

ffff80000010264a <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
ffff80000010264a:	f3 0f 1e fa          	endbr64 
ffff80000010264e:	55                   	push   %rbp
ffff80000010264f:	48 89 e5             	mov    %rsp,%rbp
ffff800000102652:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000102656:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
ffff80000010265a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010265e:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000102661:	c1 e8 03             	shr    $0x3,%eax
ffff800000102664:	89 c2                	mov    %eax,%edx
ffff800000102666:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff80000010266d:	80 ff ff 
ffff800000102670:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000102673:	01 c2                	add    %eax,%edx
ffff800000102675:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102679:	8b 00                	mov    (%rax),%eax
ffff80000010267b:	89 d6                	mov    %edx,%esi
ffff80000010267d:	89 c7                	mov    %eax,%edi
ffff80000010267f:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000102686:	80 ff ff 
ffff800000102689:	ff d0                	callq  *%rax
ffff80000010268b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
ffff80000010268f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102693:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff80000010269a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010269e:	8b 40 04             	mov    0x4(%rax),%eax
ffff8000001026a1:	89 c0                	mov    %eax,%eax
ffff8000001026a3:	83 e0 07             	and    $0x7,%eax
ffff8000001026a6:	48 c1 e0 06          	shl    $0x6,%rax
ffff8000001026aa:	48 01 d0             	add    %rdx,%rax
ffff8000001026ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  dip->type = ip->type;
ffff8000001026b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001026b5:	0f b7 90 94 00 00 00 	movzwl 0x94(%rax),%edx
ffff8000001026bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001026c0:	66 89 10             	mov    %dx,(%rax)
  dip->major = ip->major;
ffff8000001026c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001026c7:	0f b7 90 96 00 00 00 	movzwl 0x96(%rax),%edx
ffff8000001026ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001026d2:	66 89 50 02          	mov    %dx,0x2(%rax)
  dip->minor = ip->minor;
ffff8000001026d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001026da:	0f b7 90 98 00 00 00 	movzwl 0x98(%rax),%edx
ffff8000001026e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001026e5:	66 89 50 04          	mov    %dx,0x4(%rax)
  dip->nlink = ip->nlink;
ffff8000001026e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001026ed:	0f b7 90 9a 00 00 00 	movzwl 0x9a(%rax),%edx
ffff8000001026f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001026f8:	66 89 50 06          	mov    %dx,0x6(%rax)
  dip->size = ip->size;
ffff8000001026fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102700:	8b 90 9c 00 00 00    	mov    0x9c(%rax),%edx
ffff800000102706:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010270a:	89 50 08             	mov    %edx,0x8(%rax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
ffff80000010270d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102711:	48 8d 88 a0 00 00 00 	lea    0xa0(%rax),%rcx
ffff800000102718:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010271c:	48 83 c0 0c          	add    $0xc,%rax
ffff800000102720:	ba 34 00 00 00       	mov    $0x34,%edx
ffff800000102725:	48 89 ce             	mov    %rcx,%rsi
ffff800000102728:	48 89 c7             	mov    %rax,%rdi
ffff80000010272b:	48 b8 10 7d 10 00 00 	movabs $0xffff800000107d10,%rax
ffff800000102732:	80 ff ff 
ffff800000102735:	ff d0                	callq  *%rax
  log_write(bp);
ffff800000102737:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010273b:	48 89 c7             	mov    %rax,%rdi
ffff80000010273e:	48 b8 21 56 10 00 00 	movabs $0xffff800000105621,%rax
ffff800000102745:	80 ff ff 
ffff800000102748:	ff d0                	callq  *%rax
  brelse(bp);
ffff80000010274a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010274e:	48 89 c7             	mov    %rax,%rdi
ffff800000102751:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102758:	80 ff ff 
ffff80000010275b:	ff d0                	callq  *%rax
}
ffff80000010275d:	90                   	nop
ffff80000010275e:	c9                   	leaveq 
ffff80000010275f:	c3                   	retq   

ffff800000102760 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
ffff800000102760:	f3 0f 1e fa          	endbr64 
ffff800000102764:	55                   	push   %rbp
ffff800000102765:	48 89 e5             	mov    %rsp,%rbp
ffff800000102768:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010276c:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff80000010276f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
ffff800000102772:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102779:	80 ff ff 
ffff80000010277c:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000102783:	80 ff ff 
ffff800000102786:	ff d0                	callq  *%rax

  // Is the inode already cached?
  empty = 0;
ffff800000102788:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
ffff80000010278f:	00 
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
ffff800000102790:	48 b8 88 46 11 00 00 	movabs $0xffff800000114688,%rax
ffff800000102797:	80 ff ff 
ffff80000010279a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010279e:	eb 74                	jmp    ffff800000102814 <iget+0xb4>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
ffff8000001027a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027a4:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001027a7:	85 c0                	test   %eax,%eax
ffff8000001027a9:	7e 47                	jle    ffff8000001027f2 <iget+0x92>
ffff8000001027ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027af:	8b 00                	mov    (%rax),%eax
ffff8000001027b1:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff8000001027b4:	75 3c                	jne    ffff8000001027f2 <iget+0x92>
ffff8000001027b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027ba:	8b 40 04             	mov    0x4(%rax),%eax
ffff8000001027bd:	39 45 e8             	cmp    %eax,-0x18(%rbp)
ffff8000001027c0:	75 30                	jne    ffff8000001027f2 <iget+0x92>
      ip->ref++;
ffff8000001027c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027c6:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001027c9:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001027cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027d0:	89 50 08             	mov    %edx,0x8(%rax)
      release(&icache.lock);
ffff8000001027d3:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff8000001027da:	80 ff ff 
ffff8000001027dd:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001027e4:	80 ff ff 
ffff8000001027e7:	ff d0                	callq  *%rax
      return ip;
ffff8000001027e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027ed:	e9 a1 00 00 00       	jmpq   ffff800000102893 <iget+0x133>
    }
    if(empty == 0 && ip->ref == 0) // Remember empty slot.
ffff8000001027f2:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff8000001027f7:	75 13                	jne    ffff80000010280c <iget+0xac>
ffff8000001027f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027fd:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102800:	85 c0                	test   %eax,%eax
ffff800000102802:	75 08                	jne    ffff80000010280c <iget+0xac>
      empty = ip;
ffff800000102804:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102808:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
ffff80000010280c:	48 81 45 f8 d8 00 00 	addq   $0xd8,-0x8(%rbp)
ffff800000102813:	00 
ffff800000102814:	48 b8 b8 70 11 00 00 	movabs $0xffff8000001170b8,%rax
ffff80000010281b:	80 ff ff 
ffff80000010281e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000102822:	0f 82 78 ff ff ff    	jb     ffff8000001027a0 <iget+0x40>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
ffff800000102828:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010282d:	75 16                	jne    ffff800000102845 <iget+0xe5>
    panic("iget: no inodes");
ffff80000010282f:	48 bf 9d c5 10 00 00 	movabs $0xffff80000010c59d,%rdi
ffff800000102836:	80 ff ff 
ffff800000102839:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102840:	80 ff ff 
ffff800000102843:	ff d0                	callq  *%rax

  ip = empty;
ffff800000102845:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102849:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ip->dev = dev;
ffff80000010284d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102851:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff800000102854:	89 10                	mov    %edx,(%rax)
  ip->inum = inum;
ffff800000102856:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010285a:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff80000010285d:	89 50 04             	mov    %edx,0x4(%rax)
  ip->ref = 1;
ffff800000102860:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102864:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
  ip->flags = 0;
ffff80000010286b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010286f:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%rax)
ffff800000102876:	00 00 00 
  release(&icache.lock);
ffff800000102879:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102880:	80 ff ff 
ffff800000102883:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff80000010288a:	80 ff ff 
ffff80000010288d:	ff d0                	callq  *%rax

  return ip;
ffff80000010288f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000102893:	c9                   	leaveq 
ffff800000102894:	c3                   	retq   

ffff800000102895 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
ffff800000102895:	f3 0f 1e fa          	endbr64 
ffff800000102899:	55                   	push   %rbp
ffff80000010289a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010289d:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001028a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&icache.lock);
ffff8000001028a5:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff8000001028ac:	80 ff ff 
ffff8000001028af:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff8000001028b6:	80 ff ff 
ffff8000001028b9:	ff d0                	callq  *%rax
  ip->ref++;
ffff8000001028bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001028bf:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001028c2:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001028c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001028c9:	89 50 08             	mov    %edx,0x8(%rax)
  release(&icache.lock);
ffff8000001028cc:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff8000001028d3:	80 ff ff 
ffff8000001028d6:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001028dd:	80 ff ff 
ffff8000001028e0:	ff d0                	callq  *%rax
  return ip;
ffff8000001028e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001028e6:	c9                   	leaveq 
ffff8000001028e7:	c3                   	retq   

ffff8000001028e8 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
ffff8000001028e8:	f3 0f 1e fa          	endbr64 
ffff8000001028ec:	55                   	push   %rbp
ffff8000001028ed:	48 89 e5             	mov    %rsp,%rbp
ffff8000001028f0:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001028f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
ffff8000001028f8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff8000001028fd:	74 0b                	je     ffff80000010290a <ilock+0x22>
ffff8000001028ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102903:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102906:	85 c0                	test   %eax,%eax
ffff800000102908:	7f 16                	jg     ffff800000102920 <ilock+0x38>
    panic("ilock");
ffff80000010290a:	48 bf ad c5 10 00 00 	movabs $0xffff80000010c5ad,%rdi
ffff800000102911:	80 ff ff 
ffff800000102914:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010291b:	80 ff ff 
ffff80000010291e:	ff d0                	callq  *%rax

  acquiresleep(&ip->lock);
ffff800000102920:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102924:	48 83 c0 10          	add    $0x10,%rax
ffff800000102928:	48 89 c7             	mov    %rax,%rdi
ffff80000010292b:	48 b8 8a 76 10 00 00 	movabs $0xffff80000010768a,%rax
ffff800000102932:	80 ff ff 
ffff800000102935:	ff d0                	callq  *%rax

  if(!(ip->flags & I_VALID)){
ffff800000102937:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010293b:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000102941:	83 e0 02             	and    $0x2,%eax
ffff800000102944:	85 c0                	test   %eax,%eax
ffff800000102946:	0f 85 2e 01 00 00    	jne    ffff800000102a7a <ilock+0x192>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
ffff80000010294c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102950:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000102953:	c1 e8 03             	shr    $0x3,%eax
ffff800000102956:	89 c2                	mov    %eax,%edx
ffff800000102958:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff80000010295f:	80 ff ff 
ffff800000102962:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000102965:	01 c2                	add    %eax,%edx
ffff800000102967:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010296b:	8b 00                	mov    (%rax),%eax
ffff80000010296d:	89 d6                	mov    %edx,%esi
ffff80000010296f:	89 c7                	mov    %eax,%edi
ffff800000102971:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000102978:	80 ff ff 
ffff80000010297b:	ff d0                	callq  *%rax
ffff80000010297d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
ffff800000102981:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102985:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff80000010298c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102990:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000102993:	89 c0                	mov    %eax,%eax
ffff800000102995:	83 e0 07             	and    $0x7,%eax
ffff800000102998:	48 c1 e0 06          	shl    $0x6,%rax
ffff80000010299c:	48 01 d0             	add    %rdx,%rax
ffff80000010299f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    ip->type = dip->type;
ffff8000001029a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001029a7:	0f b7 10             	movzwl (%rax),%edx
ffff8000001029aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029ae:	66 89 90 94 00 00 00 	mov    %dx,0x94(%rax)
    ip->major = dip->major;
ffff8000001029b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001029b9:	0f b7 50 02          	movzwl 0x2(%rax),%edx
ffff8000001029bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029c1:	66 89 90 96 00 00 00 	mov    %dx,0x96(%rax)
    ip->minor = dip->minor;
ffff8000001029c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001029cc:	0f b7 50 04          	movzwl 0x4(%rax),%edx
ffff8000001029d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029d4:	66 89 90 98 00 00 00 	mov    %dx,0x98(%rax)
    ip->nlink = dip->nlink;
ffff8000001029db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001029df:	0f b7 50 06          	movzwl 0x6(%rax),%edx
ffff8000001029e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029e7:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
    ip->size = dip->size;
ffff8000001029ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001029f2:	8b 50 08             	mov    0x8(%rax),%edx
ffff8000001029f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029f9:	89 90 9c 00 00 00    	mov    %edx,0x9c(%rax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
ffff8000001029ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102a03:	48 8d 48 0c          	lea    0xc(%rax),%rcx
ffff800000102a07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a0b:	48 05 a0 00 00 00    	add    $0xa0,%rax
ffff800000102a11:	ba 34 00 00 00       	mov    $0x34,%edx
ffff800000102a16:	48 89 ce             	mov    %rcx,%rsi
ffff800000102a19:	48 89 c7             	mov    %rax,%rdi
ffff800000102a1c:	48 b8 10 7d 10 00 00 	movabs $0xffff800000107d10,%rax
ffff800000102a23:	80 ff ff 
ffff800000102a26:	ff d0                	callq  *%rax
    brelse(bp);
ffff800000102a28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102a2c:	48 89 c7             	mov    %rax,%rdi
ffff800000102a2f:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102a36:	80 ff ff 
ffff800000102a39:	ff d0                	callq  *%rax
    ip->flags |= I_VALID;
ffff800000102a3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a3f:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000102a45:	83 c8 02             	or     $0x2,%eax
ffff800000102a48:	89 c2                	mov    %eax,%edx
ffff800000102a4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a4e:	89 90 90 00 00 00    	mov    %edx,0x90(%rax)
    if(ip->type == 0)
ffff800000102a54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a58:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000102a5f:	66 85 c0             	test   %ax,%ax
ffff800000102a62:	75 16                	jne    ffff800000102a7a <ilock+0x192>
      panic("ilock: no type");
ffff800000102a64:	48 bf b3 c5 10 00 00 	movabs $0xffff80000010c5b3,%rdi
ffff800000102a6b:	80 ff ff 
ffff800000102a6e:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102a75:	80 ff ff 
ffff800000102a78:	ff d0                	callq  *%rax
  }
}
ffff800000102a7a:	90                   	nop
ffff800000102a7b:	c9                   	leaveq 
ffff800000102a7c:	c3                   	retq   

ffff800000102a7d <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
ffff800000102a7d:	f3 0f 1e fa          	endbr64 
ffff800000102a81:	55                   	push   %rbp
ffff800000102a82:	48 89 e5             	mov    %rsp,%rbp
ffff800000102a85:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102a89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
ffff800000102a8d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000102a92:	74 26                	je     ffff800000102aba <iunlock+0x3d>
ffff800000102a94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102a98:	48 83 c0 10          	add    $0x10,%rax
ffff800000102a9c:	48 89 c7             	mov    %rax,%rdi
ffff800000102a9f:	48 b8 7d 77 10 00 00 	movabs $0xffff80000010777d,%rax
ffff800000102aa6:	80 ff ff 
ffff800000102aa9:	ff d0                	callq  *%rax
ffff800000102aab:	85 c0                	test   %eax,%eax
ffff800000102aad:	74 0b                	je     ffff800000102aba <iunlock+0x3d>
ffff800000102aaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102ab3:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102ab6:	85 c0                	test   %eax,%eax
ffff800000102ab8:	7f 16                	jg     ffff800000102ad0 <iunlock+0x53>
    panic("iunlock");
ffff800000102aba:	48 bf c2 c5 10 00 00 	movabs $0xffff80000010c5c2,%rdi
ffff800000102ac1:	80 ff ff 
ffff800000102ac4:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102acb:	80 ff ff 
ffff800000102ace:	ff d0                	callq  *%rax

  releasesleep(&ip->lock);
ffff800000102ad0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102ad4:	48 83 c0 10          	add    $0x10,%rax
ffff800000102ad8:	48 89 c7             	mov    %rax,%rdi
ffff800000102adb:	48 b8 14 77 10 00 00 	movabs $0xffff800000107714,%rax
ffff800000102ae2:	80 ff ff 
ffff800000102ae5:	ff d0                	callq  *%rax
}
ffff800000102ae7:	90                   	nop
ffff800000102ae8:	c9                   	leaveq 
ffff800000102ae9:	c3                   	retq   

ffff800000102aea <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
ffff800000102aea:	f3 0f 1e fa          	endbr64 
ffff800000102aee:	55                   	push   %rbp
ffff800000102aef:	48 89 e5             	mov    %rsp,%rbp
ffff800000102af2:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102af6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&icache.lock);
ffff800000102afa:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102b01:	80 ff ff 
ffff800000102b04:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000102b0b:	80 ff ff 
ffff800000102b0e:	ff d0                	callq  *%rax
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
ffff800000102b10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b14:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102b17:	83 f8 01             	cmp    $0x1,%eax
ffff800000102b1a:	0f 85 8e 00 00 00    	jne    ffff800000102bae <iput+0xc4>
ffff800000102b20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b24:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000102b2a:	83 e0 02             	and    $0x2,%eax
ffff800000102b2d:	85 c0                	test   %eax,%eax
ffff800000102b2f:	74 7d                	je     ffff800000102bae <iput+0xc4>
ffff800000102b31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b35:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000102b3c:	66 85 c0             	test   %ax,%ax
ffff800000102b3f:	75 6d                	jne    ffff800000102bae <iput+0xc4>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
ffff800000102b41:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102b48:	80 ff ff 
ffff800000102b4b:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000102b52:	80 ff ff 
ffff800000102b55:	ff d0                	callq  *%rax
    itrunc(ip);
ffff800000102b57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b5b:	48 89 c7             	mov    %rax,%rdi
ffff800000102b5e:	48 b8 6f 2d 10 00 00 	movabs $0xffff800000102d6f,%rax
ffff800000102b65:	80 ff ff 
ffff800000102b68:	ff d0                	callq  *%rax
    ip->type = 0;
ffff800000102b6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b6e:	66 c7 80 94 00 00 00 	movw   $0x0,0x94(%rax)
ffff800000102b75:	00 00 
    iupdate(ip);
ffff800000102b77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b7b:	48 89 c7             	mov    %rax,%rdi
ffff800000102b7e:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff800000102b85:	80 ff ff 
ffff800000102b88:	ff d0                	callq  *%rax
    acquire(&icache.lock);
ffff800000102b8a:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102b91:	80 ff ff 
ffff800000102b94:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000102b9b:	80 ff ff 
ffff800000102b9e:	ff d0                	callq  *%rax
    ip->flags = 0;
ffff800000102ba0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102ba4:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%rax)
ffff800000102bab:	00 00 00 
  }
  ip->ref--;
ffff800000102bae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102bb2:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102bb5:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000102bb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102bbc:	89 50 08             	mov    %edx,0x8(%rax)
  release(&icache.lock);
ffff800000102bbf:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102bc6:	80 ff ff 
ffff800000102bc9:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000102bd0:	80 ff ff 
ffff800000102bd3:	ff d0                	callq  *%rax
}
ffff800000102bd5:	90                   	nop
ffff800000102bd6:	c9                   	leaveq 
ffff800000102bd7:	c3                   	retq   

ffff800000102bd8 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
ffff800000102bd8:	f3 0f 1e fa          	endbr64 
ffff800000102bdc:	55                   	push   %rbp
ffff800000102bdd:	48 89 e5             	mov    %rsp,%rbp
ffff800000102be0:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102be4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  iunlock(ip);
ffff800000102be8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102bec:	48 89 c7             	mov    %rax,%rdi
ffff800000102bef:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000102bf6:	80 ff ff 
ffff800000102bf9:	ff d0                	callq  *%rax
  iput(ip);
ffff800000102bfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102bff:	48 89 c7             	mov    %rax,%rdi
ffff800000102c02:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff800000102c09:	80 ff ff 
ffff800000102c0c:	ff d0                	callq  *%rax
}
ffff800000102c0e:	90                   	nop
ffff800000102c0f:	c9                   	leaveq 
ffff800000102c10:	c3                   	retq   

ffff800000102c11 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
ffff800000102c11:	f3 0f 1e fa          	endbr64 
ffff800000102c15:	55                   	push   %rbp
ffff800000102c16:	48 89 e5             	mov    %rsp,%rbp
ffff800000102c19:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000102c1d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000102c21:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
ffff800000102c24:	83 7d d4 0b          	cmpl   $0xb,-0x2c(%rbp)
ffff800000102c28:	77 47                	ja     ffff800000102c71 <bmap+0x60>
    if((addr = ip->addrs[bn]) == 0)
ffff800000102c2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c2e:	8b 55 d4             	mov    -0x2c(%rbp),%edx
ffff800000102c31:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102c35:	8b 04 90             	mov    (%rax,%rdx,4),%eax
ffff800000102c38:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102c3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000102c3f:	75 28                	jne    ffff800000102c69 <bmap+0x58>
      ip->addrs[bn] = addr = balloc(ip->dev);
ffff800000102c41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c45:	8b 00                	mov    (%rax),%eax
ffff800000102c47:	89 c7                	mov    %eax,%edi
ffff800000102c49:	48 b8 b2 21 10 00 00 	movabs $0xffff8000001021b2,%rax
ffff800000102c50:	80 ff ff 
ffff800000102c53:	ff d0                	callq  *%rax
ffff800000102c55:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102c58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c5c:	8b 55 d4             	mov    -0x2c(%rbp),%edx
ffff800000102c5f:	48 8d 4a 28          	lea    0x28(%rdx),%rcx
ffff800000102c63:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102c66:	89 14 88             	mov    %edx,(%rax,%rcx,4)
    return addr;
ffff800000102c69:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102c6c:	e9 fc 00 00 00       	jmpq   ffff800000102d6d <bmap+0x15c>
  }
  bn -= NDIRECT;
ffff800000102c71:	83 6d d4 0c          	subl   $0xc,-0x2c(%rbp)

  if(bn < NINDIRECT){
ffff800000102c75:	83 7d d4 7f          	cmpl   $0x7f,-0x2c(%rbp)
ffff800000102c79:	0f 87 d8 00 00 00    	ja     ffff800000102d57 <bmap+0x146>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
ffff800000102c7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c83:	8b 80 d0 00 00 00    	mov    0xd0(%rax),%eax
ffff800000102c89:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102c8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000102c90:	75 24                	jne    ffff800000102cb6 <bmap+0xa5>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
ffff800000102c92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c96:	8b 00                	mov    (%rax),%eax
ffff800000102c98:	89 c7                	mov    %eax,%edi
ffff800000102c9a:	48 b8 b2 21 10 00 00 	movabs $0xffff8000001021b2,%rax
ffff800000102ca1:	80 ff ff 
ffff800000102ca4:	ff d0                	callq  *%rax
ffff800000102ca6:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102ca9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102cad:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102cb0:	89 90 d0 00 00 00    	mov    %edx,0xd0(%rax)
    bp = bread(ip->dev, addr);
ffff800000102cb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102cba:	8b 00                	mov    (%rax),%eax
ffff800000102cbc:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102cbf:	89 d6                	mov    %edx,%esi
ffff800000102cc1:	89 c7                	mov    %eax,%edi
ffff800000102cc3:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000102cca:	80 ff ff 
ffff800000102ccd:	ff d0                	callq  *%rax
ffff800000102ccf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    a = (uint*)bp->data;
ffff800000102cd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102cd7:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000102cdd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if((addr = a[bn]) == 0){
ffff800000102ce1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000102ce4:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102ceb:	00 
ffff800000102cec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102cf0:	48 01 d0             	add    %rdx,%rax
ffff800000102cf3:	8b 00                	mov    (%rax),%eax
ffff800000102cf5:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102cf8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000102cfc:	75 41                	jne    ffff800000102d3f <bmap+0x12e>
      a[bn] = addr = balloc(ip->dev);
ffff800000102cfe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102d02:	8b 00                	mov    (%rax),%eax
ffff800000102d04:	89 c7                	mov    %eax,%edi
ffff800000102d06:	48 b8 b2 21 10 00 00 	movabs $0xffff8000001021b2,%rax
ffff800000102d0d:	80 ff ff 
ffff800000102d10:	ff d0                	callq  *%rax
ffff800000102d12:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102d15:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000102d18:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102d1f:	00 
ffff800000102d20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102d24:	48 01 c2             	add    %rax,%rdx
ffff800000102d27:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102d2a:	89 02                	mov    %eax,(%rdx)
      log_write(bp);
ffff800000102d2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102d30:	48 89 c7             	mov    %rax,%rdi
ffff800000102d33:	48 b8 21 56 10 00 00 	movabs $0xffff800000105621,%rax
ffff800000102d3a:	80 ff ff 
ffff800000102d3d:	ff d0                	callq  *%rax
    }
    brelse(bp);
ffff800000102d3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102d43:	48 89 c7             	mov    %rax,%rdi
ffff800000102d46:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102d4d:	80 ff ff 
ffff800000102d50:	ff d0                	callq  *%rax
    return addr;
ffff800000102d52:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102d55:	eb 16                	jmp    ffff800000102d6d <bmap+0x15c>
  }

  panic("bmap: out of range");
ffff800000102d57:	48 bf ca c5 10 00 00 	movabs $0xffff80000010c5ca,%rdi
ffff800000102d5e:	80 ff ff 
ffff800000102d61:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102d68:	80 ff ff 
ffff800000102d6b:	ff d0                	callq  *%rax
}
ffff800000102d6d:	c9                   	leaveq 
ffff800000102d6e:	c3                   	retq   

ffff800000102d6f <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
ffff800000102d6f:	f3 0f 1e fa          	endbr64 
ffff800000102d73:	55                   	push   %rbp
ffff800000102d74:	48 89 e5             	mov    %rsp,%rbp
ffff800000102d77:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000102d7b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
ffff800000102d7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000102d86:	eb 55                	jmp    ffff800000102ddd <itrunc+0x6e>
    if(ip->addrs[i]){
ffff800000102d88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102d8c:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102d8f:	48 63 d2             	movslq %edx,%rdx
ffff800000102d92:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102d96:	8b 04 90             	mov    (%rax,%rdx,4),%eax
ffff800000102d99:	85 c0                	test   %eax,%eax
ffff800000102d9b:	74 3c                	je     ffff800000102dd9 <itrunc+0x6a>
      bfree(ip->dev, ip->addrs[i]);
ffff800000102d9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102da1:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102da4:	48 63 d2             	movslq %edx,%rdx
ffff800000102da7:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102dab:	8b 04 90             	mov    (%rax,%rdx,4),%eax
ffff800000102dae:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000102db2:	8b 12                	mov    (%rdx),%edx
ffff800000102db4:	89 c6                	mov    %eax,%esi
ffff800000102db6:	89 d7                	mov    %edx,%edi
ffff800000102db8:	48 b8 4e 23 10 00 00 	movabs $0xffff80000010234e,%rax
ffff800000102dbf:	80 ff ff 
ffff800000102dc2:	ff d0                	callq  *%rax
      ip->addrs[i] = 0;
ffff800000102dc4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102dc8:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102dcb:	48 63 d2             	movslq %edx,%rdx
ffff800000102dce:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102dd2:	c7 04 90 00 00 00 00 	movl   $0x0,(%rax,%rdx,4)
  for(i = 0; i < NDIRECT; i++){
ffff800000102dd9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000102ddd:	83 7d fc 0b          	cmpl   $0xb,-0x4(%rbp)
ffff800000102de1:	7e a5                	jle    ffff800000102d88 <itrunc+0x19>
    }
  }

  if(ip->addrs[NDIRECT]){
ffff800000102de3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102de7:	8b 80 d0 00 00 00    	mov    0xd0(%rax),%eax
ffff800000102ded:	85 c0                	test   %eax,%eax
ffff800000102def:	0f 84 ce 00 00 00    	je     ffff800000102ec3 <itrunc+0x154>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
ffff800000102df5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102df9:	8b 90 d0 00 00 00    	mov    0xd0(%rax),%edx
ffff800000102dff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102e03:	8b 00                	mov    (%rax),%eax
ffff800000102e05:	89 d6                	mov    %edx,%esi
ffff800000102e07:	89 c7                	mov    %eax,%edi
ffff800000102e09:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000102e10:	80 ff ff 
ffff800000102e13:	ff d0                	callq  *%rax
ffff800000102e15:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    a = (uint*)bp->data;
ffff800000102e19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102e1d:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000102e23:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    for(j = 0; j < NINDIRECT; j++){
ffff800000102e27:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
ffff800000102e2e:	eb 4a                	jmp    ffff800000102e7a <itrunc+0x10b>
      if(a[j])
ffff800000102e30:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102e33:	48 98                	cltq   
ffff800000102e35:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102e3c:	00 
ffff800000102e3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102e41:	48 01 d0             	add    %rdx,%rax
ffff800000102e44:	8b 00                	mov    (%rax),%eax
ffff800000102e46:	85 c0                	test   %eax,%eax
ffff800000102e48:	74 2c                	je     ffff800000102e76 <itrunc+0x107>
        bfree(ip->dev, a[j]);
ffff800000102e4a:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102e4d:	48 98                	cltq   
ffff800000102e4f:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102e56:	00 
ffff800000102e57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102e5b:	48 01 d0             	add    %rdx,%rax
ffff800000102e5e:	8b 00                	mov    (%rax),%eax
ffff800000102e60:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000102e64:	8b 12                	mov    (%rdx),%edx
ffff800000102e66:	89 c6                	mov    %eax,%esi
ffff800000102e68:	89 d7                	mov    %edx,%edi
ffff800000102e6a:	48 b8 4e 23 10 00 00 	movabs $0xffff80000010234e,%rax
ffff800000102e71:	80 ff ff 
ffff800000102e74:	ff d0                	callq  *%rax
    for(j = 0; j < NINDIRECT; j++){
ffff800000102e76:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
ffff800000102e7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102e7d:	83 f8 7f             	cmp    $0x7f,%eax
ffff800000102e80:	76 ae                	jbe    ffff800000102e30 <itrunc+0xc1>
    }
    brelse(bp);
ffff800000102e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102e86:	48 89 c7             	mov    %rax,%rdi
ffff800000102e89:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102e90:	80 ff ff 
ffff800000102e93:	ff d0                	callq  *%rax
    bfree(ip->dev, ip->addrs[NDIRECT]);
ffff800000102e95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102e99:	8b 80 d0 00 00 00    	mov    0xd0(%rax),%eax
ffff800000102e9f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000102ea3:	8b 12                	mov    (%rdx),%edx
ffff800000102ea5:	89 c6                	mov    %eax,%esi
ffff800000102ea7:	89 d7                	mov    %edx,%edi
ffff800000102ea9:	48 b8 4e 23 10 00 00 	movabs $0xffff80000010234e,%rax
ffff800000102eb0:	80 ff ff 
ffff800000102eb3:	ff d0                	callq  *%rax
    ip->addrs[NDIRECT] = 0;
ffff800000102eb5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102eb9:	c7 80 d0 00 00 00 00 	movl   $0x0,0xd0(%rax)
ffff800000102ec0:	00 00 00 
  }

  ip->size = 0;
ffff800000102ec3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102ec7:	c7 80 9c 00 00 00 00 	movl   $0x0,0x9c(%rax)
ffff800000102ece:	00 00 00 
  iupdate(ip);
ffff800000102ed1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102ed5:	48 89 c7             	mov    %rax,%rdi
ffff800000102ed8:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff800000102edf:	80 ff ff 
ffff800000102ee2:	ff d0                	callq  *%rax
}
ffff800000102ee4:	90                   	nop
ffff800000102ee5:	c9                   	leaveq 
ffff800000102ee6:	c3                   	retq   

ffff800000102ee7 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
ffff800000102ee7:	f3 0f 1e fa          	endbr64 
ffff800000102eeb:	55                   	push   %rbp
ffff800000102eec:	48 89 e5             	mov    %rsp,%rbp
ffff800000102eef:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102ef3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000102ef7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  st->dev = ip->dev;
ffff800000102efb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102eff:	8b 00                	mov    (%rax),%eax
ffff800000102f01:	89 c2                	mov    %eax,%edx
ffff800000102f03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102f07:	89 50 04             	mov    %edx,0x4(%rax)
  st->ino = ip->inum;
ffff800000102f0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102f0e:	8b 50 04             	mov    0x4(%rax),%edx
ffff800000102f11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102f15:	89 50 08             	mov    %edx,0x8(%rax)
  st->type = ip->type;
ffff800000102f18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102f1c:	0f b7 90 94 00 00 00 	movzwl 0x94(%rax),%edx
ffff800000102f23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102f27:	66 89 10             	mov    %dx,(%rax)
  st->nlink = ip->nlink;
ffff800000102f2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102f2e:	0f b7 90 9a 00 00 00 	movzwl 0x9a(%rax),%edx
ffff800000102f35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102f39:	66 89 50 0c          	mov    %dx,0xc(%rax)
  st->size = ip->size;
ffff800000102f3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102f41:	8b 90 9c 00 00 00    	mov    0x9c(%rax),%edx
ffff800000102f47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102f4b:	89 50 10             	mov    %edx,0x10(%rax)
}
ffff800000102f4e:	90                   	nop
ffff800000102f4f:	c9                   	leaveq 
ffff800000102f50:	c3                   	retq   

ffff800000102f51 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
ffff800000102f51:	f3 0f 1e fa          	endbr64 
ffff800000102f55:	55                   	push   %rbp
ffff800000102f56:	48 89 e5             	mov    %rsp,%rbp
ffff800000102f59:	48 83 ec 40          	sub    $0x40,%rsp
ffff800000102f5d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000102f61:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff800000102f65:	89 55 cc             	mov    %edx,-0x34(%rbp)
ffff800000102f68:	89 4d c8             	mov    %ecx,-0x38(%rbp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
ffff800000102f6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102f6f:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000102f76:	66 83 f8 03          	cmp    $0x3,%ax
ffff800000102f7a:	0f 85 8d 00 00 00    	jne    ffff80000010300d <readi+0xbc>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
ffff800000102f80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102f84:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000102f8b:	66 85 c0             	test   %ax,%ax
ffff800000102f8e:	78 38                	js     ffff800000102fc8 <readi+0x77>
ffff800000102f90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102f94:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000102f9b:	66 83 f8 09          	cmp    $0x9,%ax
ffff800000102f9f:	7f 27                	jg     ffff800000102fc8 <readi+0x77>
ffff800000102fa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102fa5:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000102fac:	98                   	cwtl   
ffff800000102fad:	48 ba 40 35 11 00 00 	movabs $0xffff800000113540,%rdx
ffff800000102fb4:	80 ff ff 
ffff800000102fb7:	48 98                	cltq   
ffff800000102fb9:	48 c1 e0 04          	shl    $0x4,%rax
ffff800000102fbd:	48 01 d0             	add    %rdx,%rax
ffff800000102fc0:	48 8b 00             	mov    (%rax),%rax
ffff800000102fc3:	48 85 c0             	test   %rax,%rax
ffff800000102fc6:	75 0a                	jne    ffff800000102fd2 <readi+0x81>
      return -1;
ffff800000102fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000102fcd:	e9 4e 01 00 00       	jmpq   ffff800000103120 <readi+0x1cf>
    return devsw[ip->major].read(ip, off, dst, n);
ffff800000102fd2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102fd6:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000102fdd:	98                   	cwtl   
ffff800000102fde:	48 ba 40 35 11 00 00 	movabs $0xffff800000113540,%rdx
ffff800000102fe5:	80 ff ff 
ffff800000102fe8:	48 98                	cltq   
ffff800000102fea:	48 c1 e0 04          	shl    $0x4,%rax
ffff800000102fee:	48 01 d0             	add    %rdx,%rax
ffff800000102ff1:	4c 8b 00             	mov    (%rax),%r8
ffff800000102ff4:	8b 4d c8             	mov    -0x38(%rbp),%ecx
ffff800000102ff7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000102ffb:	8b 75 cc             	mov    -0x34(%rbp),%esi
ffff800000102ffe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103002:	48 89 c7             	mov    %rax,%rdi
ffff800000103005:	41 ff d0             	callq  *%r8
ffff800000103008:	e9 13 01 00 00       	jmpq   ffff800000103120 <readi+0x1cf>
  }

  if(off > ip->size || off + n < off)
ffff80000010300d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103011:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff800000103017:	39 45 cc             	cmp    %eax,-0x34(%rbp)
ffff80000010301a:	77 0d                	ja     ffff800000103029 <readi+0xd8>
ffff80000010301c:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff80000010301f:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff800000103022:	01 d0                	add    %edx,%eax
ffff800000103024:	39 45 cc             	cmp    %eax,-0x34(%rbp)
ffff800000103027:	76 0a                	jbe    ffff800000103033 <readi+0xe2>
    return -1;
ffff800000103029:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010302e:	e9 ed 00 00 00       	jmpq   ffff800000103120 <readi+0x1cf>
  if(off + n > ip->size)
ffff800000103033:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff800000103036:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff800000103039:	01 c2                	add    %eax,%edx
ffff80000010303b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010303f:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff800000103045:	39 c2                	cmp    %eax,%edx
ffff800000103047:	76 10                	jbe    ffff800000103059 <readi+0x108>
    n = ip->size - off;
ffff800000103049:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010304d:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff800000103053:	2b 45 cc             	sub    -0x34(%rbp),%eax
ffff800000103056:	89 45 c8             	mov    %eax,-0x38(%rbp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
ffff800000103059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000103060:	e9 ac 00 00 00       	jmpq   ffff800000103111 <readi+0x1c0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
ffff800000103065:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103068:	c1 e8 09             	shr    $0x9,%eax
ffff80000010306b:	89 c2                	mov    %eax,%edx
ffff80000010306d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103071:	89 d6                	mov    %edx,%esi
ffff800000103073:	48 89 c7             	mov    %rax,%rdi
ffff800000103076:	48 b8 11 2c 10 00 00 	movabs $0xffff800000102c11,%rax
ffff80000010307d:	80 ff ff 
ffff800000103080:	ff d0                	callq  *%rax
ffff800000103082:	89 c2                	mov    %eax,%edx
ffff800000103084:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103088:	8b 00                	mov    (%rax),%eax
ffff80000010308a:	89 d6                	mov    %edx,%esi
ffff80000010308c:	89 c7                	mov    %eax,%edi
ffff80000010308e:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000103095:	80 ff ff 
ffff800000103098:	ff d0                	callq  *%rax
ffff80000010309a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    m = min(n - tot, BSIZE - off%BSIZE);
ffff80000010309e:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff8000001030a1:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff8000001030a6:	ba 00 02 00 00       	mov    $0x200,%edx
ffff8000001030ab:	29 c2                	sub    %eax,%edx
ffff8000001030ad:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff8000001030b0:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff8000001030b3:	39 c2                	cmp    %eax,%edx
ffff8000001030b5:	0f 46 c2             	cmovbe %edx,%eax
ffff8000001030b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
    memmove(dst, bp->data + off%BSIZE, m);
ffff8000001030bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001030bf:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff8000001030c6:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff8000001030c9:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff8000001030ce:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff8000001030d2:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff8000001030d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff8000001030d9:	48 89 ce             	mov    %rcx,%rsi
ffff8000001030dc:	48 89 c7             	mov    %rax,%rdi
ffff8000001030df:	48 b8 10 7d 10 00 00 	movabs $0xffff800000107d10,%rax
ffff8000001030e6:	80 ff ff 
ffff8000001030e9:	ff d0                	callq  *%rax
    brelse(bp);
ffff8000001030eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001030ef:	48 89 c7             	mov    %rax,%rdi
ffff8000001030f2:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff8000001030f9:	80 ff ff 
ffff8000001030fc:	ff d0                	callq  *%rax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
ffff8000001030fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000103101:	01 45 fc             	add    %eax,-0x4(%rbp)
ffff800000103104:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000103107:	01 45 cc             	add    %eax,-0x34(%rbp)
ffff80000010310a:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010310d:	48 01 45 d0          	add    %rax,-0x30(%rbp)
ffff800000103111:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103114:	3b 45 c8             	cmp    -0x38(%rbp),%eax
ffff800000103117:	0f 82 48 ff ff ff    	jb     ffff800000103065 <readi+0x114>
  }
  return n;
ffff80000010311d:	8b 45 c8             	mov    -0x38(%rbp),%eax
}
ffff800000103120:	c9                   	leaveq 
ffff800000103121:	c3                   	retq   

ffff800000103122 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
ffff800000103122:	f3 0f 1e fa          	endbr64 
ffff800000103126:	55                   	push   %rbp
ffff800000103127:	48 89 e5             	mov    %rsp,%rbp
ffff80000010312a:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010312e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000103132:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff800000103136:	89 55 cc             	mov    %edx,-0x34(%rbp)
ffff800000103139:	89 4d c8             	mov    %ecx,-0x38(%rbp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
ffff80000010313c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103140:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000103147:	66 83 f8 03          	cmp    $0x3,%ax
ffff80000010314b:	0f 85 95 00 00 00    	jne    ffff8000001031e6 <writei+0xc4>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
ffff800000103151:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103155:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff80000010315c:	66 85 c0             	test   %ax,%ax
ffff80000010315f:	78 3c                	js     ffff80000010319d <writei+0x7b>
ffff800000103161:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103165:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff80000010316c:	66 83 f8 09          	cmp    $0x9,%ax
ffff800000103170:	7f 2b                	jg     ffff80000010319d <writei+0x7b>
ffff800000103172:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103176:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff80000010317d:	98                   	cwtl   
ffff80000010317e:	48 ba 40 35 11 00 00 	movabs $0xffff800000113540,%rdx
ffff800000103185:	80 ff ff 
ffff800000103188:	48 98                	cltq   
ffff80000010318a:	48 c1 e0 04          	shl    $0x4,%rax
ffff80000010318e:	48 01 d0             	add    %rdx,%rax
ffff800000103191:	48 83 c0 08          	add    $0x8,%rax
ffff800000103195:	48 8b 00             	mov    (%rax),%rax
ffff800000103198:	48 85 c0             	test   %rax,%rax
ffff80000010319b:	75 0a                	jne    ffff8000001031a7 <writei+0x85>
      return -1;
ffff80000010319d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001031a2:	e9 8d 01 00 00       	jmpq   ffff800000103334 <writei+0x212>
    return devsw[ip->major].write(ip, off, src, n);
ffff8000001031a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001031ab:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff8000001031b2:	98                   	cwtl   
ffff8000001031b3:	48 ba 40 35 11 00 00 	movabs $0xffff800000113540,%rdx
ffff8000001031ba:	80 ff ff 
ffff8000001031bd:	48 98                	cltq   
ffff8000001031bf:	48 c1 e0 04          	shl    $0x4,%rax
ffff8000001031c3:	48 01 d0             	add    %rdx,%rax
ffff8000001031c6:	48 83 c0 08          	add    $0x8,%rax
ffff8000001031ca:	4c 8b 00             	mov    (%rax),%r8
ffff8000001031cd:	8b 4d c8             	mov    -0x38(%rbp),%ecx
ffff8000001031d0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff8000001031d4:	8b 75 cc             	mov    -0x34(%rbp),%esi
ffff8000001031d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001031db:	48 89 c7             	mov    %rax,%rdi
ffff8000001031de:	41 ff d0             	callq  *%r8
ffff8000001031e1:	e9 4e 01 00 00       	jmpq   ffff800000103334 <writei+0x212>
  }

  if(off > ip->size || off + n < off)
ffff8000001031e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001031ea:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff8000001031f0:	39 45 cc             	cmp    %eax,-0x34(%rbp)
ffff8000001031f3:	77 0d                	ja     ffff800000103202 <writei+0xe0>
ffff8000001031f5:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff8000001031f8:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff8000001031fb:	01 d0                	add    %edx,%eax
ffff8000001031fd:	39 45 cc             	cmp    %eax,-0x34(%rbp)
ffff800000103200:	76 0a                	jbe    ffff80000010320c <writei+0xea>
    return -1;
ffff800000103202:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000103207:	e9 28 01 00 00       	jmpq   ffff800000103334 <writei+0x212>
  if(off + n > MAXFILE*BSIZE)
ffff80000010320c:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff80000010320f:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff800000103212:	01 d0                	add    %edx,%eax
ffff800000103214:	3d 00 18 01 00       	cmp    $0x11800,%eax
ffff800000103219:	76 0a                	jbe    ffff800000103225 <writei+0x103>
    return -1;
ffff80000010321b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000103220:	e9 0f 01 00 00       	jmpq   ffff800000103334 <writei+0x212>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
ffff800000103225:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010322c:	e9 bf 00 00 00       	jmpq   ffff8000001032f0 <writei+0x1ce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
ffff800000103231:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103234:	c1 e8 09             	shr    $0x9,%eax
ffff800000103237:	89 c2                	mov    %eax,%edx
ffff800000103239:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010323d:	89 d6                	mov    %edx,%esi
ffff80000010323f:	48 89 c7             	mov    %rax,%rdi
ffff800000103242:	48 b8 11 2c 10 00 00 	movabs $0xffff800000102c11,%rax
ffff800000103249:	80 ff ff 
ffff80000010324c:	ff d0                	callq  *%rax
ffff80000010324e:	89 c2                	mov    %eax,%edx
ffff800000103250:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103254:	8b 00                	mov    (%rax),%eax
ffff800000103256:	89 d6                	mov    %edx,%esi
ffff800000103258:	89 c7                	mov    %eax,%edi
ffff80000010325a:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000103261:	80 ff ff 
ffff800000103264:	ff d0                	callq  *%rax
ffff800000103266:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    m = min(n - tot, BSIZE - off%BSIZE);
ffff80000010326a:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff80000010326d:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff800000103272:	ba 00 02 00 00       	mov    $0x200,%edx
ffff800000103277:	29 c2                	sub    %eax,%edx
ffff800000103279:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff80000010327c:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff80000010327f:	39 c2                	cmp    %eax,%edx
ffff800000103281:	0f 46 c2             	cmovbe %edx,%eax
ffff800000103284:	89 45 ec             	mov    %eax,-0x14(%rbp)
    memmove(bp->data + off%BSIZE, src, m);
ffff800000103287:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010328b:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff800000103292:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103295:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010329a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff80000010329e:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff8000001032a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff8000001032a5:	48 89 c6             	mov    %rax,%rsi
ffff8000001032a8:	48 89 cf             	mov    %rcx,%rdi
ffff8000001032ab:	48 b8 10 7d 10 00 00 	movabs $0xffff800000107d10,%rax
ffff8000001032b2:	80 ff ff 
ffff8000001032b5:	ff d0                	callq  *%rax
    log_write(bp);
ffff8000001032b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001032bb:	48 89 c7             	mov    %rax,%rdi
ffff8000001032be:	48 b8 21 56 10 00 00 	movabs $0xffff800000105621,%rax
ffff8000001032c5:	80 ff ff 
ffff8000001032c8:	ff d0                	callq  *%rax
    brelse(bp);
ffff8000001032ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001032ce:	48 89 c7             	mov    %rax,%rdi
ffff8000001032d1:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff8000001032d8:	80 ff ff 
ffff8000001032db:	ff d0                	callq  *%rax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
ffff8000001032dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001032e0:	01 45 fc             	add    %eax,-0x4(%rbp)
ffff8000001032e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001032e6:	01 45 cc             	add    %eax,-0x34(%rbp)
ffff8000001032e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001032ec:	48 01 45 d0          	add    %rax,-0x30(%rbp)
ffff8000001032f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001032f3:	3b 45 c8             	cmp    -0x38(%rbp),%eax
ffff8000001032f6:	0f 82 35 ff ff ff    	jb     ffff800000103231 <writei+0x10f>
  }

  if(n > 0 && off > ip->size){
ffff8000001032fc:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
ffff800000103300:	74 2f                	je     ffff800000103331 <writei+0x20f>
ffff800000103302:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103306:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff80000010330c:	39 45 cc             	cmp    %eax,-0x34(%rbp)
ffff80000010330f:	76 20                	jbe    ffff800000103331 <writei+0x20f>
    ip->size = off;
ffff800000103311:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103315:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff800000103318:	89 90 9c 00 00 00    	mov    %edx,0x9c(%rax)
    iupdate(ip);
ffff80000010331e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103322:	48 89 c7             	mov    %rax,%rdi
ffff800000103325:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff80000010332c:	80 ff ff 
ffff80000010332f:	ff d0                	callq  *%rax
  }
  return n;
ffff800000103331:	8b 45 c8             	mov    -0x38(%rbp),%eax
}
ffff800000103334:	c9                   	leaveq 
ffff800000103335:	c3                   	retq   

ffff800000103336 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
ffff800000103336:	f3 0f 1e fa          	endbr64 
ffff80000010333a:	55                   	push   %rbp
ffff80000010333b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010333e:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000103342:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000103346:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  return strncmp(s, t, DIRSIZ);
ffff80000010334a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff80000010334e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103352:	ba 0e 00 00 00       	mov    $0xe,%edx
ffff800000103357:	48 89 ce             	mov    %rcx,%rsi
ffff80000010335a:	48 89 c7             	mov    %rax,%rdi
ffff80000010335d:	48 b8 ed 7d 10 00 00 	movabs $0xffff800000107ded,%rax
ffff800000103364:	80 ff ff 
ffff800000103367:	ff d0                	callq  *%rax
}
ffff800000103369:	c9                   	leaveq 
ffff80000010336a:	c3                   	retq   

ffff80000010336b <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
ffff80000010336b:	f3 0f 1e fa          	endbr64 
ffff80000010336f:	55                   	push   %rbp
ffff800000103370:	48 89 e5             	mov    %rsp,%rbp
ffff800000103373:	48 83 ec 40          	sub    $0x40,%rsp
ffff800000103377:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010337b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010337f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
ffff800000103383:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103387:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff80000010338e:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000103392:	74 16                	je     ffff8000001033aa <dirlookup+0x3f>
    panic("dirlookup not DIR");
ffff800000103394:	48 bf dd c5 10 00 00 	movabs $0xffff80000010c5dd,%rdi
ffff80000010339b:	80 ff ff 
ffff80000010339e:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001033a5:	80 ff ff 
ffff8000001033a8:	ff d0                	callq  *%rax

  for(off = 0; off < dp->size; off += sizeof(de)){
ffff8000001033aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001033b1:	e9 9f 00 00 00       	jmpq   ffff800000103455 <dirlookup+0xea>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff8000001033b6:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001033b9:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff8000001033bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001033c1:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff8000001033c6:	48 89 c7             	mov    %rax,%rdi
ffff8000001033c9:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff8000001033d0:	80 ff ff 
ffff8000001033d3:	ff d0                	callq  *%rax
ffff8000001033d5:	83 f8 10             	cmp    $0x10,%eax
ffff8000001033d8:	74 16                	je     ffff8000001033f0 <dirlookup+0x85>
      panic("dirlookup read");
ffff8000001033da:	48 bf ef c5 10 00 00 	movabs $0xffff80000010c5ef,%rdi
ffff8000001033e1:	80 ff ff 
ffff8000001033e4:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001033eb:	80 ff ff 
ffff8000001033ee:	ff d0                	callq  *%rax
    if(de.inum == 0)
ffff8000001033f0:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff8000001033f4:	66 85 c0             	test   %ax,%ax
ffff8000001033f7:	74 57                	je     ffff800000103450 <dirlookup+0xe5>
      continue;
    if(namecmp(name, de.name) == 0){
ffff8000001033f9:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff8000001033fd:	48 8d 50 02          	lea    0x2(%rax),%rdx
ffff800000103401:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000103405:	48 89 d6             	mov    %rdx,%rsi
ffff800000103408:	48 89 c7             	mov    %rax,%rdi
ffff80000010340b:	48 b8 36 33 10 00 00 	movabs $0xffff800000103336,%rax
ffff800000103412:	80 ff ff 
ffff800000103415:	ff d0                	callq  *%rax
ffff800000103417:	85 c0                	test   %eax,%eax
ffff800000103419:	75 36                	jne    ffff800000103451 <dirlookup+0xe6>
      // entry matches path element
      if(poff)
ffff80000010341b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff800000103420:	74 09                	je     ffff80000010342b <dirlookup+0xc0>
        *poff = off;
ffff800000103422:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000103426:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103429:	89 10                	mov    %edx,(%rax)
      inum = de.inum;
ffff80000010342b:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff80000010342f:	0f b7 c0             	movzwl %ax,%eax
ffff800000103432:	89 45 f8             	mov    %eax,-0x8(%rbp)
      return iget(dp->dev, inum);
ffff800000103435:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103439:	8b 00                	mov    (%rax),%eax
ffff80000010343b:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff80000010343e:	89 d6                	mov    %edx,%esi
ffff800000103440:	89 c7                	mov    %eax,%edi
ffff800000103442:	48 b8 60 27 10 00 00 	movabs $0xffff800000102760,%rax
ffff800000103449:	80 ff ff 
ffff80000010344c:	ff d0                	callq  *%rax
ffff80000010344e:	eb 1d                	jmp    ffff80000010346d <dirlookup+0x102>
      continue;
ffff800000103450:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
ffff800000103451:	83 45 fc 10          	addl   $0x10,-0x4(%rbp)
ffff800000103455:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103459:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff80000010345f:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000103462:	0f 82 4e ff ff ff    	jb     ffff8000001033b6 <dirlookup+0x4b>
    }
  }

  return 0;
ffff800000103468:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010346d:	c9                   	leaveq 
ffff80000010346e:	c3                   	retq   

ffff80000010346f <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
ffff80000010346f:	f3 0f 1e fa          	endbr64 
ffff800000103473:	55                   	push   %rbp
ffff800000103474:	48 89 e5             	mov    %rsp,%rbp
ffff800000103477:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010347b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010347f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff800000103483:	89 55 cc             	mov    %edx,-0x34(%rbp)
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
ffff800000103486:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
ffff80000010348a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010348e:	ba 00 00 00 00       	mov    $0x0,%edx
ffff800000103493:	48 89 ce             	mov    %rcx,%rsi
ffff800000103496:	48 89 c7             	mov    %rax,%rdi
ffff800000103499:	48 b8 6b 33 10 00 00 	movabs $0xffff80000010336b,%rax
ffff8000001034a0:	80 ff ff 
ffff8000001034a3:	ff d0                	callq  *%rax
ffff8000001034a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff8000001034a9:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff8000001034ae:	74 1d                	je     ffff8000001034cd <dirlink+0x5e>
    iput(ip);
ffff8000001034b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001034b4:	48 89 c7             	mov    %rax,%rdi
ffff8000001034b7:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff8000001034be:	80 ff ff 
ffff8000001034c1:	ff d0                	callq  *%rax
    return -1;
ffff8000001034c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001034c8:	e9 d2 00 00 00       	jmpq   ffff80000010359f <dirlink+0x130>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
ffff8000001034cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001034d4:	eb 4c                	jmp    ffff800000103522 <dirlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff8000001034d6:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001034d9:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff8000001034dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001034e1:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff8000001034e6:	48 89 c7             	mov    %rax,%rdi
ffff8000001034e9:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff8000001034f0:	80 ff ff 
ffff8000001034f3:	ff d0                	callq  *%rax
ffff8000001034f5:	83 f8 10             	cmp    $0x10,%eax
ffff8000001034f8:	74 16                	je     ffff800000103510 <dirlink+0xa1>
      panic("dirlink read");
ffff8000001034fa:	48 bf fe c5 10 00 00 	movabs $0xffff80000010c5fe,%rdi
ffff800000103501:	80 ff ff 
ffff800000103504:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010350b:	80 ff ff 
ffff80000010350e:	ff d0                	callq  *%rax
    if(de.inum == 0)
ffff800000103510:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff800000103514:	66 85 c0             	test   %ax,%ax
ffff800000103517:	74 1c                	je     ffff800000103535 <dirlink+0xc6>
  for(off = 0; off < dp->size; off += sizeof(de)){
ffff800000103519:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010351c:	83 c0 10             	add    $0x10,%eax
ffff80000010351f:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000103522:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103526:	8b 90 9c 00 00 00    	mov    0x9c(%rax),%edx
ffff80000010352c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010352f:	39 c2                	cmp    %eax,%edx
ffff800000103531:	77 a3                	ja     ffff8000001034d6 <dirlink+0x67>
ffff800000103533:	eb 01                	jmp    ffff800000103536 <dirlink+0xc7>
      break;
ffff800000103535:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
ffff800000103536:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010353a:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffff80000010353e:	48 8d 4a 02          	lea    0x2(%rdx),%rcx
ffff800000103542:	ba 0e 00 00 00       	mov    $0xe,%edx
ffff800000103547:	48 89 c6             	mov    %rax,%rsi
ffff80000010354a:	48 89 cf             	mov    %rcx,%rdi
ffff80000010354d:	48 b8 5e 7e 10 00 00 	movabs $0xffff800000107e5e,%rax
ffff800000103554:	80 ff ff 
ffff800000103557:	ff d0                	callq  *%rax
  de.inum = inum;
ffff800000103559:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff80000010355c:	66 89 45 e0          	mov    %ax,-0x20(%rbp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff800000103560:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103563:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff800000103567:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010356b:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff800000103570:	48 89 c7             	mov    %rax,%rdi
ffff800000103573:	48 b8 22 31 10 00 00 	movabs $0xffff800000103122,%rax
ffff80000010357a:	80 ff ff 
ffff80000010357d:	ff d0                	callq  *%rax
ffff80000010357f:	83 f8 10             	cmp    $0x10,%eax
ffff800000103582:	74 16                	je     ffff80000010359a <dirlink+0x12b>
    panic("dirlink");
ffff800000103584:	48 bf 0b c6 10 00 00 	movabs $0xffff80000010c60b,%rdi
ffff80000010358b:	80 ff ff 
ffff80000010358e:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103595:	80 ff ff 
ffff800000103598:	ff d0                	callq  *%rax

  return 0;
ffff80000010359a:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010359f:	c9                   	leaveq 
ffff8000001035a0:	c3                   	retq   

ffff8000001035a1 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
ffff8000001035a1:	f3 0f 1e fa          	endbr64 
ffff8000001035a5:	55                   	push   %rbp
ffff8000001035a6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001035a9:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001035ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001035b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *s;
  int len;

  while(*path == '/')
ffff8000001035b5:	eb 05                	jmp    ffff8000001035bc <skipelem+0x1b>
    path++;
ffff8000001035b7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  while(*path == '/')
ffff8000001035bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001035c0:	0f b6 00             	movzbl (%rax),%eax
ffff8000001035c3:	3c 2f                	cmp    $0x2f,%al
ffff8000001035c5:	74 f0                	je     ffff8000001035b7 <skipelem+0x16>
  if(*path == 0)
ffff8000001035c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001035cb:	0f b6 00             	movzbl (%rax),%eax
ffff8000001035ce:	84 c0                	test   %al,%al
ffff8000001035d0:	75 0a                	jne    ffff8000001035dc <skipelem+0x3b>
    return 0;
ffff8000001035d2:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001035d7:	e9 9a 00 00 00       	jmpq   ffff800000103676 <skipelem+0xd5>
  s = path;
ffff8000001035dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001035e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(*path != '/' && *path != 0)
ffff8000001035e4:	eb 05                	jmp    ffff8000001035eb <skipelem+0x4a>
    path++;
ffff8000001035e6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  while(*path != '/' && *path != 0)
ffff8000001035eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001035ef:	0f b6 00             	movzbl (%rax),%eax
ffff8000001035f2:	3c 2f                	cmp    $0x2f,%al
ffff8000001035f4:	74 0b                	je     ffff800000103601 <skipelem+0x60>
ffff8000001035f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001035fa:	0f b6 00             	movzbl (%rax),%eax
ffff8000001035fd:	84 c0                	test   %al,%al
ffff8000001035ff:	75 e5                	jne    ffff8000001035e6 <skipelem+0x45>
  len = path - s;
ffff800000103601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103605:	48 2b 45 f8          	sub    -0x8(%rbp),%rax
ffff800000103609:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(len >= DIRSIZ)
ffff80000010360c:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
ffff800000103610:	7e 21                	jle    ffff800000103633 <skipelem+0x92>
    memmove(name, s, DIRSIZ);
ffff800000103612:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000103616:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010361a:	ba 0e 00 00 00       	mov    $0xe,%edx
ffff80000010361f:	48 89 ce             	mov    %rcx,%rsi
ffff800000103622:	48 89 c7             	mov    %rax,%rdi
ffff800000103625:	48 b8 10 7d 10 00 00 	movabs $0xffff800000107d10,%rax
ffff80000010362c:	80 ff ff 
ffff80000010362f:	ff d0                	callq  *%rax
ffff800000103631:	eb 34                	jmp    ffff800000103667 <skipelem+0xc6>
  else {
    memmove(name, s, len);
ffff800000103633:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000103636:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010363a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010363e:	48 89 ce             	mov    %rcx,%rsi
ffff800000103641:	48 89 c7             	mov    %rax,%rdi
ffff800000103644:	48 b8 10 7d 10 00 00 	movabs $0xffff800000107d10,%rax
ffff80000010364b:	80 ff ff 
ffff80000010364e:	ff d0                	callq  *%rax
    name[len] = 0;
ffff800000103650:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000103653:	48 63 d0             	movslq %eax,%rdx
ffff800000103656:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010365a:	48 01 d0             	add    %rdx,%rax
ffff80000010365d:	c6 00 00             	movb   $0x0,(%rax)
  }
  while(*path == '/')
ffff800000103660:	eb 05                	jmp    ffff800000103667 <skipelem+0xc6>
    path++;
ffff800000103662:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  while(*path == '/')
ffff800000103667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010366b:	0f b6 00             	movzbl (%rax),%eax
ffff80000010366e:	3c 2f                	cmp    $0x2f,%al
ffff800000103670:	74 f0                	je     ffff800000103662 <skipelem+0xc1>
  return path;
ffff800000103672:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
ffff800000103676:	c9                   	leaveq 
ffff800000103677:	c3                   	retq   

ffff800000103678 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
ffff800000103678:	f3 0f 1e fa          	endbr64 
ffff80000010367c:	55                   	push   %rbp
ffff80000010367d:	48 89 e5             	mov    %rsp,%rbp
ffff800000103680:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000103684:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000103688:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff80000010368b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  struct inode *ip, *next;

  if(*path == '/')
ffff80000010368f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103693:	0f b6 00             	movzbl (%rax),%eax
ffff800000103696:	3c 2f                	cmp    $0x2f,%al
ffff800000103698:	75 1f                	jne    ffff8000001036b9 <namex+0x41>
    ip = iget(ROOTDEV, ROOTINO);
ffff80000010369a:	be 01 00 00 00       	mov    $0x1,%esi
ffff80000010369f:	bf 01 00 00 00       	mov    $0x1,%edi
ffff8000001036a4:	48 b8 60 27 10 00 00 	movabs $0xffff800000102760,%rax
ffff8000001036ab:	80 ff ff 
ffff8000001036ae:	ff d0                	callq  *%rax
ffff8000001036b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001036b4:	e9 f7 00 00 00       	jmpq   ffff8000001037b0 <namex+0x138>
  else
    ip = idup(proc->cwd);
ffff8000001036b9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001036c0:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001036c4:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff8000001036cb:	48 89 c7             	mov    %rax,%rdi
ffff8000001036ce:	48 b8 95 28 10 00 00 	movabs $0xffff800000102895,%rax
ffff8000001036d5:	80 ff ff 
ffff8000001036d8:	ff d0                	callq  *%rax
ffff8000001036da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  while((path = skipelem(path, name)) != 0){
ffff8000001036de:	e9 cd 00 00 00       	jmpq   ffff8000001037b0 <namex+0x138>
    ilock(ip);
ffff8000001036e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001036e7:	48 89 c7             	mov    %rax,%rdi
ffff8000001036ea:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff8000001036f1:	80 ff ff 
ffff8000001036f4:	ff d0                	callq  *%rax
    if(ip->type != T_DIR){
ffff8000001036f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001036fa:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000103701:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000103705:	74 1d                	je     ffff800000103724 <namex+0xac>
      iunlockput(ip);
ffff800000103707:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010370b:	48 89 c7             	mov    %rax,%rdi
ffff80000010370e:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000103715:	80 ff ff 
ffff800000103718:	ff d0                	callq  *%rax
      return 0;
ffff80000010371a:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010371f:	e9 d9 00 00 00       	jmpq   ffff8000001037fd <namex+0x185>
    }
    if(nameiparent && *path == '\0'){
ffff800000103724:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
ffff800000103728:	74 27                	je     ffff800000103751 <namex+0xd9>
ffff80000010372a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010372e:	0f b6 00             	movzbl (%rax),%eax
ffff800000103731:	84 c0                	test   %al,%al
ffff800000103733:	75 1c                	jne    ffff800000103751 <namex+0xd9>
      iunlock(ip);  // Stop one level early.
ffff800000103735:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103739:	48 89 c7             	mov    %rax,%rdi
ffff80000010373c:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000103743:	80 ff ff 
ffff800000103746:	ff d0                	callq  *%rax
      return ip;
ffff800000103748:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010374c:	e9 ac 00 00 00       	jmpq   ffff8000001037fd <namex+0x185>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
ffff800000103751:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff800000103755:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103759:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010375e:	48 89 ce             	mov    %rcx,%rsi
ffff800000103761:	48 89 c7             	mov    %rax,%rdi
ffff800000103764:	48 b8 6b 33 10 00 00 	movabs $0xffff80000010336b,%rax
ffff80000010376b:	80 ff ff 
ffff80000010376e:	ff d0                	callq  *%rax
ffff800000103770:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000103774:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000103779:	75 1a                	jne    ffff800000103795 <namex+0x11d>
      iunlockput(ip);
ffff80000010377b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010377f:	48 89 c7             	mov    %rax,%rdi
ffff800000103782:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000103789:	80 ff ff 
ffff80000010378c:	ff d0                	callq  *%rax
      return 0;
ffff80000010378e:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000103793:	eb 68                	jmp    ffff8000001037fd <namex+0x185>
    }
    iunlockput(ip);
ffff800000103795:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103799:	48 89 c7             	mov    %rax,%rdi
ffff80000010379c:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff8000001037a3:	80 ff ff 
ffff8000001037a6:	ff d0                	callq  *%rax
    ip = next;
ffff8000001037a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001037ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((path = skipelem(path, name)) != 0){
ffff8000001037b0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff8000001037b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001037b8:	48 89 d6             	mov    %rdx,%rsi
ffff8000001037bb:	48 89 c7             	mov    %rax,%rdi
ffff8000001037be:	48 b8 a1 35 10 00 00 	movabs $0xffff8000001035a1,%rax
ffff8000001037c5:	80 ff ff 
ffff8000001037c8:	ff d0                	callq  *%rax
ffff8000001037ca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff8000001037ce:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff8000001037d3:	0f 85 0a ff ff ff    	jne    ffff8000001036e3 <namex+0x6b>
  }
  if(nameiparent){
ffff8000001037d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
ffff8000001037dd:	74 1a                	je     ffff8000001037f9 <namex+0x181>
    iput(ip);
ffff8000001037df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001037e3:	48 89 c7             	mov    %rax,%rdi
ffff8000001037e6:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff8000001037ed:	80 ff ff 
ffff8000001037f0:	ff d0                	callq  *%rax
    return 0;
ffff8000001037f2:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001037f7:	eb 04                	jmp    ffff8000001037fd <namex+0x185>
  }
  return ip;
ffff8000001037f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001037fd:	c9                   	leaveq 
ffff8000001037fe:	c3                   	retq   

ffff8000001037ff <namei>:

struct inode*
namei(char *path)
{
ffff8000001037ff:	f3 0f 1e fa          	endbr64 
ffff800000103803:	55                   	push   %rbp
ffff800000103804:	48 89 e5             	mov    %rsp,%rbp
ffff800000103807:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010380b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  char name[DIRSIZ];
  return namex(path, 0, name);
ffff80000010380f:	48 8d 55 f2          	lea    -0xe(%rbp),%rdx
ffff800000103813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103817:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010381c:	48 89 c7             	mov    %rax,%rdi
ffff80000010381f:	48 b8 78 36 10 00 00 	movabs $0xffff800000103678,%rax
ffff800000103826:	80 ff ff 
ffff800000103829:	ff d0                	callq  *%rax
}
ffff80000010382b:	c9                   	leaveq 
ffff80000010382c:	c3                   	retq   

ffff80000010382d <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
ffff80000010382d:	f3 0f 1e fa          	endbr64 
ffff800000103831:	55                   	push   %rbp
ffff800000103832:	48 89 e5             	mov    %rsp,%rbp
ffff800000103835:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000103839:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff80000010383d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  return namex(path, 1, name);
ffff800000103841:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000103845:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103849:	be 01 00 00 00       	mov    $0x1,%esi
ffff80000010384e:	48 89 c7             	mov    %rax,%rdi
ffff800000103851:	48 b8 78 36 10 00 00 	movabs $0xffff800000103678,%rax
ffff800000103858:	80 ff ff 
ffff80000010385b:	ff d0                	callq  *%rax
}
ffff80000010385d:	c9                   	leaveq 
ffff80000010385e:	c3                   	retq   

ffff80000010385f <inb>:
{
ffff80000010385f:	f3 0f 1e fa          	endbr64 
ffff800000103863:	55                   	push   %rbp
ffff800000103864:	48 89 e5             	mov    %rsp,%rbp
ffff800000103867:	48 83 ec 18          	sub    $0x18,%rsp
ffff80000010386b:	89 f8                	mov    %edi,%eax
ffff80000010386d:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff800000103871:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff800000103875:	89 c2                	mov    %eax,%edx
ffff800000103877:	ec                   	in     (%dx),%al
ffff800000103878:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff80000010387b:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff80000010387f:	c9                   	leaveq 
ffff800000103880:	c3                   	retq   

ffff800000103881 <insl>:
{
ffff800000103881:	f3 0f 1e fa          	endbr64 
ffff800000103885:	55                   	push   %rbp
ffff800000103886:	48 89 e5             	mov    %rsp,%rbp
ffff800000103889:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010388d:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000103890:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000103894:	89 55 f8             	mov    %edx,-0x8(%rbp)
  asm volatile("cld; rep insl" :
ffff800000103897:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010389a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff80000010389e:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001038a1:	48 89 ce             	mov    %rcx,%rsi
ffff8000001038a4:	48 89 f7             	mov    %rsi,%rdi
ffff8000001038a7:	89 c1                	mov    %eax,%ecx
ffff8000001038a9:	fc                   	cld    
ffff8000001038aa:	f3 6d                	rep insl (%dx),%es:(%rdi)
ffff8000001038ac:	89 c8                	mov    %ecx,%eax
ffff8000001038ae:	48 89 fe             	mov    %rdi,%rsi
ffff8000001038b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff8000001038b5:	89 45 f8             	mov    %eax,-0x8(%rbp)
}
ffff8000001038b8:	90                   	nop
ffff8000001038b9:	c9                   	leaveq 
ffff8000001038ba:	c3                   	retq   

ffff8000001038bb <outb>:
{
ffff8000001038bb:	f3 0f 1e fa          	endbr64 
ffff8000001038bf:	55                   	push   %rbp
ffff8000001038c0:	48 89 e5             	mov    %rsp,%rbp
ffff8000001038c3:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001038c7:	89 f8                	mov    %edi,%eax
ffff8000001038c9:	89 f2                	mov    %esi,%edx
ffff8000001038cb:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
ffff8000001038cf:	89 d0                	mov    %edx,%eax
ffff8000001038d1:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff8000001038d4:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff8000001038d8:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff8000001038dc:	ee                   	out    %al,(%dx)
}
ffff8000001038dd:	90                   	nop
ffff8000001038de:	c9                   	leaveq 
ffff8000001038df:	c3                   	retq   

ffff8000001038e0 <outsl>:
{
ffff8000001038e0:	f3 0f 1e fa          	endbr64 
ffff8000001038e4:	55                   	push   %rbp
ffff8000001038e5:	48 89 e5             	mov    %rsp,%rbp
ffff8000001038e8:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001038ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff8000001038ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff8000001038f3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  asm volatile("cld; rep outsl" :
ffff8000001038f6:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001038f9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff8000001038fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103900:	48 89 ce             	mov    %rcx,%rsi
ffff800000103903:	89 c1                	mov    %eax,%ecx
ffff800000103905:	fc                   	cld    
ffff800000103906:	f3 6f                	rep outsl %ds:(%rsi),(%dx)
ffff800000103908:	89 c8                	mov    %ecx,%eax
ffff80000010390a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff80000010390e:	89 45 f8             	mov    %eax,-0x8(%rbp)
}
ffff800000103911:	90                   	nop
ffff800000103912:	c9                   	leaveq 
ffff800000103913:	c3                   	retq   

ffff800000103914 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
ffff800000103914:	f3 0f 1e fa          	endbr64 
ffff800000103918:	55                   	push   %rbp
ffff800000103919:	48 89 e5             	mov    %rsp,%rbp
ffff80000010391c:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000103920:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
ffff800000103923:	90                   	nop
ffff800000103924:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff800000103929:	48 b8 5f 38 10 00 00 	movabs $0xffff80000010385f,%rax
ffff800000103930:	80 ff ff 
ffff800000103933:	ff d0                	callq  *%rax
ffff800000103935:	0f b6 c0             	movzbl %al,%eax
ffff800000103938:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff80000010393b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010393e:	25 c0 00 00 00       	and    $0xc0,%eax
ffff800000103943:	83 f8 40             	cmp    $0x40,%eax
ffff800000103946:	75 dc                	jne    ffff800000103924 <idewait+0x10>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
ffff800000103948:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff80000010394c:	74 11                	je     ffff80000010395f <idewait+0x4b>
ffff80000010394e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103951:	83 e0 21             	and    $0x21,%eax
ffff800000103954:	85 c0                	test   %eax,%eax
ffff800000103956:	74 07                	je     ffff80000010395f <idewait+0x4b>
    return -1;
ffff800000103958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010395d:	eb 05                	jmp    ffff800000103964 <idewait+0x50>
  return 0;
ffff80000010395f:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000103964:	c9                   	leaveq 
ffff800000103965:	c3                   	retq   

ffff800000103966 <ideinit>:

void
ideinit(void)
{
ffff800000103966:	f3 0f 1e fa          	endbr64 
ffff80000010396a:	55                   	push   %rbp
ffff80000010396b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010396e:	48 83 ec 10          	sub    $0x10,%rsp
  initlock(&idelock, "ide");
ffff800000103972:	48 be 13 c6 10 00 00 	movabs $0xffff80000010c613,%rsi
ffff800000103979:	80 ff ff 
ffff80000010397c:	48 bf c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdi
ffff800000103983:	80 ff ff 
ffff800000103986:	48 b8 24 78 10 00 00 	movabs $0xffff800000107824,%rax
ffff80000010398d:	80 ff ff 
ffff800000103990:	ff d0                	callq  *%rax
  ioapicenable(IRQ_IDE, ncpu - 1);
ffff800000103992:	48 b8 20 74 1f 00 00 	movabs $0xffff8000001f7420,%rax
ffff800000103999:	80 ff ff 
ffff80000010399c:	8b 00                	mov    (%rax),%eax
ffff80000010399e:	83 e8 01             	sub    $0x1,%eax
ffff8000001039a1:	89 c6                	mov    %eax,%esi
ffff8000001039a3:	bf 0e 00 00 00       	mov    $0xe,%edi
ffff8000001039a8:	48 b8 e5 3f 10 00 00 	movabs $0xffff800000103fe5,%rax
ffff8000001039af:	80 ff ff 
ffff8000001039b2:	ff d0                	callq  *%rax
  idewait(0);
ffff8000001039b4:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001039b9:	48 b8 14 39 10 00 00 	movabs $0xffff800000103914,%rax
ffff8000001039c0:	80 ff ff 
ffff8000001039c3:	ff d0                	callq  *%rax

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
ffff8000001039c5:	be f0 00 00 00       	mov    $0xf0,%esi
ffff8000001039ca:	bf f6 01 00 00       	mov    $0x1f6,%edi
ffff8000001039cf:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff8000001039d6:	80 ff ff 
ffff8000001039d9:	ff d0                	callq  *%rax
  for(int i=0; i<1000; i++){
ffff8000001039db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001039e2:	eb 2b                	jmp    ffff800000103a0f <ideinit+0xa9>
    if(inb(0x1f7) != 0){
ffff8000001039e4:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff8000001039e9:	48 b8 5f 38 10 00 00 	movabs $0xffff80000010385f,%rax
ffff8000001039f0:	80 ff ff 
ffff8000001039f3:	ff d0                	callq  *%rax
ffff8000001039f5:	84 c0                	test   %al,%al
ffff8000001039f7:	74 12                	je     ffff800000103a0b <ideinit+0xa5>
      havedisk1 = 1;
ffff8000001039f9:	48 b8 30 71 11 00 00 	movabs $0xffff800000117130,%rax
ffff800000103a00:	80 ff ff 
ffff800000103a03:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
      break;
ffff800000103a09:	eb 0d                	jmp    ffff800000103a18 <ideinit+0xb2>
  for(int i=0; i<1000; i++){
ffff800000103a0b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000103a0f:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
ffff800000103a16:	7e cc                	jle    ffff8000001039e4 <ideinit+0x7e>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
ffff800000103a18:	be e0 00 00 00       	mov    $0xe0,%esi
ffff800000103a1d:	bf f6 01 00 00       	mov    $0x1f6,%edi
ffff800000103a22:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103a29:	80 ff ff 
ffff800000103a2c:	ff d0                	callq  *%rax
}
ffff800000103a2e:	90                   	nop
ffff800000103a2f:	c9                   	leaveq 
ffff800000103a30:	c3                   	retq   

ffff800000103a31 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
ffff800000103a31:	f3 0f 1e fa          	endbr64 
ffff800000103a35:	55                   	push   %rbp
ffff800000103a36:	48 89 e5             	mov    %rsp,%rbp
ffff800000103a39:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000103a3d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  if(b == 0)
ffff800000103a41:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000103a46:	75 16                	jne    ffff800000103a5e <idestart+0x2d>
    panic("idestart");
ffff800000103a48:	48 bf 17 c6 10 00 00 	movabs $0xffff80000010c617,%rdi
ffff800000103a4f:	80 ff ff 
ffff800000103a52:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103a59:	80 ff ff 
ffff800000103a5c:	ff d0                	callq  *%rax
  if(b->blockno >= FSSIZE)
ffff800000103a5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103a62:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000103a65:	3d e7 03 00 00       	cmp    $0x3e7,%eax
ffff800000103a6a:	76 16                	jbe    ffff800000103a82 <idestart+0x51>
    panic("incorrect blockno");
ffff800000103a6c:	48 bf 20 c6 10 00 00 	movabs $0xffff80000010c620,%rdi
ffff800000103a73:	80 ff ff 
ffff800000103a76:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103a7d:	80 ff ff 
ffff800000103a80:	ff d0                	callq  *%rax
  int sector_per_block =  BSIZE/SECTOR_SIZE;
ffff800000103a82:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  int sector = b->blockno * sector_per_block;
ffff800000103a89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103a8d:	8b 50 08             	mov    0x8(%rax),%edx
ffff800000103a90:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103a93:	0f af c2             	imul   %edx,%eax
ffff800000103a96:	89 45 f8             	mov    %eax,-0x8(%rbp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
ffff800000103a99:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
ffff800000103a9d:	75 07                	jne    ffff800000103aa6 <idestart+0x75>
ffff800000103a9f:	b8 20 00 00 00       	mov    $0x20,%eax
ffff800000103aa4:	eb 05                	jmp    ffff800000103aab <idestart+0x7a>
ffff800000103aa6:	b8 c4 00 00 00       	mov    $0xc4,%eax
ffff800000103aab:	89 45 f4             	mov    %eax,-0xc(%rbp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
ffff800000103aae:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
ffff800000103ab2:	75 07                	jne    ffff800000103abb <idestart+0x8a>
ffff800000103ab4:	b8 30 00 00 00       	mov    $0x30,%eax
ffff800000103ab9:	eb 05                	jmp    ffff800000103ac0 <idestart+0x8f>
ffff800000103abb:	b8 c5 00 00 00       	mov    $0xc5,%eax
ffff800000103ac0:	89 45 f0             	mov    %eax,-0x10(%rbp)

  if (sector_per_block > 7) panic("idestart");
ffff800000103ac3:	83 7d fc 07          	cmpl   $0x7,-0x4(%rbp)
ffff800000103ac7:	7e 16                	jle    ffff800000103adf <idestart+0xae>
ffff800000103ac9:	48 bf 17 c6 10 00 00 	movabs $0xffff80000010c617,%rdi
ffff800000103ad0:	80 ff ff 
ffff800000103ad3:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103ada:	80 ff ff 
ffff800000103add:	ff d0                	callq  *%rax

  idewait(0);
ffff800000103adf:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000103ae4:	48 b8 14 39 10 00 00 	movabs $0xffff800000103914,%rax
ffff800000103aeb:	80 ff ff 
ffff800000103aee:	ff d0                	callq  *%rax
  outb(0x3f6, 0);  // generate interrupt
ffff800000103af0:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000103af5:	bf f6 03 00 00       	mov    $0x3f6,%edi
ffff800000103afa:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103b01:	80 ff ff 
ffff800000103b04:	ff d0                	callq  *%rax
  outb(0x1f2, sector_per_block);  // number of sectors
ffff800000103b06:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103b09:	0f b6 c0             	movzbl %al,%eax
ffff800000103b0c:	89 c6                	mov    %eax,%esi
ffff800000103b0e:	bf f2 01 00 00       	mov    $0x1f2,%edi
ffff800000103b13:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103b1a:	80 ff ff 
ffff800000103b1d:	ff d0                	callq  *%rax
  outb(0x1f3, sector & 0xff);
ffff800000103b1f:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103b22:	0f b6 c0             	movzbl %al,%eax
ffff800000103b25:	89 c6                	mov    %eax,%esi
ffff800000103b27:	bf f3 01 00 00       	mov    $0x1f3,%edi
ffff800000103b2c:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103b33:	80 ff ff 
ffff800000103b36:	ff d0                	callq  *%rax
  outb(0x1f4, (sector >> 8) & 0xff);
ffff800000103b38:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103b3b:	c1 f8 08             	sar    $0x8,%eax
ffff800000103b3e:	0f b6 c0             	movzbl %al,%eax
ffff800000103b41:	89 c6                	mov    %eax,%esi
ffff800000103b43:	bf f4 01 00 00       	mov    $0x1f4,%edi
ffff800000103b48:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103b4f:	80 ff ff 
ffff800000103b52:	ff d0                	callq  *%rax
  outb(0x1f5, (sector >> 16) & 0xff);
ffff800000103b54:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103b57:	c1 f8 10             	sar    $0x10,%eax
ffff800000103b5a:	0f b6 c0             	movzbl %al,%eax
ffff800000103b5d:	89 c6                	mov    %eax,%esi
ffff800000103b5f:	bf f5 01 00 00       	mov    $0x1f5,%edi
ffff800000103b64:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103b6b:	80 ff ff 
ffff800000103b6e:	ff d0                	callq  *%rax
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
ffff800000103b70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103b74:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000103b77:	c1 e0 04             	shl    $0x4,%eax
ffff800000103b7a:	83 e0 10             	and    $0x10,%eax
ffff800000103b7d:	89 c2                	mov    %eax,%edx
ffff800000103b7f:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103b82:	c1 f8 18             	sar    $0x18,%eax
ffff800000103b85:	83 e0 0f             	and    $0xf,%eax
ffff800000103b88:	09 d0                	or     %edx,%eax
ffff800000103b8a:	83 c8 e0             	or     $0xffffffe0,%eax
ffff800000103b8d:	0f b6 c0             	movzbl %al,%eax
ffff800000103b90:	89 c6                	mov    %eax,%esi
ffff800000103b92:	bf f6 01 00 00       	mov    $0x1f6,%edi
ffff800000103b97:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103b9e:	80 ff ff 
ffff800000103ba1:	ff d0                	callq  *%rax
  if(b->flags & B_DIRTY){
ffff800000103ba3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103ba7:	8b 00                	mov    (%rax),%eax
ffff800000103ba9:	83 e0 04             	and    $0x4,%eax
ffff800000103bac:	85 c0                	test   %eax,%eax
ffff800000103bae:	74 3e                	je     ffff800000103bee <idestart+0x1bd>
    outb(0x1f7, write_cmd);
ffff800000103bb0:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000103bb3:	0f b6 c0             	movzbl %al,%eax
ffff800000103bb6:	89 c6                	mov    %eax,%esi
ffff800000103bb8:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff800000103bbd:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103bc4:	80 ff ff 
ffff800000103bc7:	ff d0                	callq  *%rax
    outsl(0x1f0, b->data, BSIZE/4);
ffff800000103bc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103bcd:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000103bd3:	ba 80 00 00 00       	mov    $0x80,%edx
ffff800000103bd8:	48 89 c6             	mov    %rax,%rsi
ffff800000103bdb:	bf f0 01 00 00       	mov    $0x1f0,%edi
ffff800000103be0:	48 b8 e0 38 10 00 00 	movabs $0xffff8000001038e0,%rax
ffff800000103be7:	80 ff ff 
ffff800000103bea:	ff d0                	callq  *%rax
  } else {
    outb(0x1f7, read_cmd);
  }
}
ffff800000103bec:	eb 19                	jmp    ffff800000103c07 <idestart+0x1d6>
    outb(0x1f7, read_cmd);
ffff800000103bee:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000103bf1:	0f b6 c0             	movzbl %al,%eax
ffff800000103bf4:	89 c6                	mov    %eax,%esi
ffff800000103bf6:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff800000103bfb:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103c02:	80 ff ff 
ffff800000103c05:	ff d0                	callq  *%rax
}
ffff800000103c07:	90                   	nop
ffff800000103c08:	c9                   	leaveq 
ffff800000103c09:	c3                   	retq   

ffff800000103c0a <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
ffff800000103c0a:	f3 0f 1e fa          	endbr64 
ffff800000103c0e:	55                   	push   %rbp
ffff800000103c0f:	48 89 e5             	mov    %rsp,%rbp
ffff800000103c12:	48 83 ec 10          	sub    $0x10,%rsp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
ffff800000103c16:	48 bf c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdi
ffff800000103c1d:	80 ff ff 
ffff800000103c20:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000103c27:	80 ff ff 
ffff800000103c2a:	ff d0                	callq  *%rax
  if((b = idequeue) == 0){
ffff800000103c2c:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103c33:	80 ff ff 
ffff800000103c36:	48 8b 00             	mov    (%rax),%rax
ffff800000103c39:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000103c3d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000103c42:	75 1b                	jne    ffff800000103c5f <ideintr+0x55>
    release(&idelock);
ffff800000103c44:	48 bf c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdi
ffff800000103c4b:	80 ff ff 
ffff800000103c4e:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000103c55:	80 ff ff 
ffff800000103c58:	ff d0                	callq  *%rax
    // cprintf("spurious IDE interrupt\n");
    return;
ffff800000103c5a:	e9 d6 00 00 00       	jmpq   ffff800000103d35 <ideintr+0x12b>
  }
  idequeue = b->qnext;
ffff800000103c5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103c63:	48 8b 80 a8 00 00 00 	mov    0xa8(%rax),%rax
ffff800000103c6a:	48 ba 28 71 11 00 00 	movabs $0xffff800000117128,%rdx
ffff800000103c71:	80 ff ff 
ffff800000103c74:	48 89 02             	mov    %rax,(%rdx)

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
ffff800000103c77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103c7b:	8b 00                	mov    (%rax),%eax
ffff800000103c7d:	83 e0 04             	and    $0x4,%eax
ffff800000103c80:	85 c0                	test   %eax,%eax
ffff800000103c82:	75 38                	jne    ffff800000103cbc <ideintr+0xb2>
ffff800000103c84:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000103c89:	48 b8 14 39 10 00 00 	movabs $0xffff800000103914,%rax
ffff800000103c90:	80 ff ff 
ffff800000103c93:	ff d0                	callq  *%rax
ffff800000103c95:	85 c0                	test   %eax,%eax
ffff800000103c97:	78 23                	js     ffff800000103cbc <ideintr+0xb2>
    insl(0x1f0, b->data, BSIZE/4);
ffff800000103c99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103c9d:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000103ca3:	ba 80 00 00 00       	mov    $0x80,%edx
ffff800000103ca8:	48 89 c6             	mov    %rax,%rsi
ffff800000103cab:	bf f0 01 00 00       	mov    $0x1f0,%edi
ffff800000103cb0:	48 b8 81 38 10 00 00 	movabs $0xffff800000103881,%rax
ffff800000103cb7:	80 ff ff 
ffff800000103cba:	ff d0                	callq  *%rax

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
ffff800000103cbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103cc0:	8b 00                	mov    (%rax),%eax
ffff800000103cc2:	83 c8 02             	or     $0x2,%eax
ffff800000103cc5:	89 c2                	mov    %eax,%edx
ffff800000103cc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103ccb:	89 10                	mov    %edx,(%rax)
  b->flags &= ~B_DIRTY;
ffff800000103ccd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103cd1:	8b 00                	mov    (%rax),%eax
ffff800000103cd3:	83 e0 fb             	and    $0xfffffffb,%eax
ffff800000103cd6:	89 c2                	mov    %eax,%edx
ffff800000103cd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103cdc:	89 10                	mov    %edx,(%rax)
  wakeup(b);
ffff800000103cde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103ce2:	48 89 c7             	mov    %rax,%rdi
ffff800000103ce5:	48 b8 b8 73 10 00 00 	movabs $0xffff8000001073b8,%rax
ffff800000103cec:	80 ff ff 
ffff800000103cef:	ff d0                	callq  *%rax

  // Start disk on next buf in queue.
  if(idequeue != 0)
ffff800000103cf1:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103cf8:	80 ff ff 
ffff800000103cfb:	48 8b 00             	mov    (%rax),%rax
ffff800000103cfe:	48 85 c0             	test   %rax,%rax
ffff800000103d01:	74 1c                	je     ffff800000103d1f <ideintr+0x115>
    idestart(idequeue);
ffff800000103d03:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103d0a:	80 ff ff 
ffff800000103d0d:	48 8b 00             	mov    (%rax),%rax
ffff800000103d10:	48 89 c7             	mov    %rax,%rdi
ffff800000103d13:	48 b8 31 3a 10 00 00 	movabs $0xffff800000103a31,%rax
ffff800000103d1a:	80 ff ff 
ffff800000103d1d:	ff d0                	callq  *%rax

  release(&idelock);
ffff800000103d1f:	48 bf c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdi
ffff800000103d26:	80 ff ff 
ffff800000103d29:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000103d30:	80 ff ff 
ffff800000103d33:	ff d0                	callq  *%rax
}
ffff800000103d35:	c9                   	leaveq 
ffff800000103d36:	c3                   	retq   

ffff800000103d37 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
ffff800000103d37:	f3 0f 1e fa          	endbr64 
ffff800000103d3b:	55                   	push   %rbp
ffff800000103d3c:	48 89 e5             	mov    %rsp,%rbp
ffff800000103d3f:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000103d43:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct buf **pp;

  if(!holdingsleep(&b->lock))
ffff800000103d47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103d4b:	48 83 c0 10          	add    $0x10,%rax
ffff800000103d4f:	48 89 c7             	mov    %rax,%rdi
ffff800000103d52:	48 b8 7d 77 10 00 00 	movabs $0xffff80000010777d,%rax
ffff800000103d59:	80 ff ff 
ffff800000103d5c:	ff d0                	callq  *%rax
ffff800000103d5e:	85 c0                	test   %eax,%eax
ffff800000103d60:	75 16                	jne    ffff800000103d78 <iderw+0x41>
    panic("iderw: buf not locked");
ffff800000103d62:	48 bf 32 c6 10 00 00 	movabs $0xffff80000010c632,%rdi
ffff800000103d69:	80 ff ff 
ffff800000103d6c:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103d73:	80 ff ff 
ffff800000103d76:	ff d0                	callq  *%rax
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
ffff800000103d78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103d7c:	8b 00                	mov    (%rax),%eax
ffff800000103d7e:	83 e0 06             	and    $0x6,%eax
ffff800000103d81:	83 f8 02             	cmp    $0x2,%eax
ffff800000103d84:	75 16                	jne    ffff800000103d9c <iderw+0x65>
    panic("iderw: nothing to do");
ffff800000103d86:	48 bf 48 c6 10 00 00 	movabs $0xffff80000010c648,%rdi
ffff800000103d8d:	80 ff ff 
ffff800000103d90:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103d97:	80 ff ff 
ffff800000103d9a:	ff d0                	callq  *%rax
  if(b->dev != 0 && !havedisk1)
ffff800000103d9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103da0:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000103da3:	85 c0                	test   %eax,%eax
ffff800000103da5:	74 26                	je     ffff800000103dcd <iderw+0x96>
ffff800000103da7:	48 b8 30 71 11 00 00 	movabs $0xffff800000117130,%rax
ffff800000103dae:	80 ff ff 
ffff800000103db1:	8b 00                	mov    (%rax),%eax
ffff800000103db3:	85 c0                	test   %eax,%eax
ffff800000103db5:	75 16                	jne    ffff800000103dcd <iderw+0x96>
    panic("iderw: ide disk 1 not present");
ffff800000103db7:	48 bf 5d c6 10 00 00 	movabs $0xffff80000010c65d,%rdi
ffff800000103dbe:	80 ff ff 
ffff800000103dc1:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103dc8:	80 ff ff 
ffff800000103dcb:	ff d0                	callq  *%rax

  acquire(&idelock);  //DOC:acquire-lock
ffff800000103dcd:	48 bf c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdi
ffff800000103dd4:	80 ff ff 
ffff800000103dd7:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000103dde:	80 ff ff 
ffff800000103de1:	ff d0                	callq  *%rax

  // Append b to idequeue.
  b->qnext = 0;
ffff800000103de3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103de7:	48 c7 80 a8 00 00 00 	movq   $0x0,0xa8(%rax)
ffff800000103dee:	00 00 00 00 
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
ffff800000103df2:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103df9:	80 ff ff 
ffff800000103dfc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000103e00:	eb 11                	jmp    ffff800000103e13 <iderw+0xdc>
ffff800000103e02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103e06:	48 8b 00             	mov    (%rax),%rax
ffff800000103e09:	48 05 a8 00 00 00    	add    $0xa8,%rax
ffff800000103e0f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000103e13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103e17:	48 8b 00             	mov    (%rax),%rax
ffff800000103e1a:	48 85 c0             	test   %rax,%rax
ffff800000103e1d:	75 e3                	jne    ffff800000103e02 <iderw+0xcb>
    ;
  *pp = b;
ffff800000103e1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103e23:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000103e27:	48 89 10             	mov    %rdx,(%rax)

  // Start disk if necessary.
  if(idequeue == b)
ffff800000103e2a:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103e31:	80 ff ff 
ffff800000103e34:	48 8b 00             	mov    (%rax),%rax
ffff800000103e37:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff800000103e3b:	75 32                	jne    ffff800000103e6f <iderw+0x138>
    idestart(b);
ffff800000103e3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103e41:	48 89 c7             	mov    %rax,%rdi
ffff800000103e44:	48 b8 31 3a 10 00 00 	movabs $0xffff800000103a31,%rax
ffff800000103e4b:	80 ff ff 
ffff800000103e4e:	ff d0                	callq  *%rax

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
ffff800000103e50:	eb 1d                	jmp    ffff800000103e6f <iderw+0x138>
    sleep(b, &idelock);
ffff800000103e52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103e56:	48 be c0 70 11 00 00 	movabs $0xffff8000001170c0,%rsi
ffff800000103e5d:	80 ff ff 
ffff800000103e60:	48 89 c7             	mov    %rax,%rdi
ffff800000103e63:	48 b8 47 72 10 00 00 	movabs $0xffff800000107247,%rax
ffff800000103e6a:	80 ff ff 
ffff800000103e6d:	ff d0                	callq  *%rax
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
ffff800000103e6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103e73:	8b 00                	mov    (%rax),%eax
ffff800000103e75:	83 e0 06             	and    $0x6,%eax
ffff800000103e78:	83 f8 02             	cmp    $0x2,%eax
ffff800000103e7b:	75 d5                	jne    ffff800000103e52 <iderw+0x11b>
  }

  release(&idelock);
ffff800000103e7d:	48 bf c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdi
ffff800000103e84:	80 ff ff 
ffff800000103e87:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000103e8e:	80 ff ff 
ffff800000103e91:	ff d0                	callq  *%rax
}
ffff800000103e93:	90                   	nop
ffff800000103e94:	c9                   	leaveq 
ffff800000103e95:	c3                   	retq   

ffff800000103e96 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
ffff800000103e96:	f3 0f 1e fa          	endbr64 
ffff800000103e9a:	55                   	push   %rbp
ffff800000103e9b:	48 89 e5             	mov    %rsp,%rbp
ffff800000103e9e:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000103ea2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  ioapic->reg = reg;
ffff800000103ea5:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103eac:	80 ff ff 
ffff800000103eaf:	48 8b 00             	mov    (%rax),%rax
ffff800000103eb2:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103eb5:	89 10                	mov    %edx,(%rax)
  return ioapic->data;
ffff800000103eb7:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103ebe:	80 ff ff 
ffff800000103ec1:	48 8b 00             	mov    (%rax),%rax
ffff800000103ec4:	8b 40 10             	mov    0x10(%rax),%eax
}
ffff800000103ec7:	c9                   	leaveq 
ffff800000103ec8:	c3                   	retq   

ffff800000103ec9 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
ffff800000103ec9:	f3 0f 1e fa          	endbr64 
ffff800000103ecd:	55                   	push   %rbp
ffff800000103ece:	48 89 e5             	mov    %rsp,%rbp
ffff800000103ed1:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000103ed5:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000103ed8:	89 75 f8             	mov    %esi,-0x8(%rbp)
  ioapic->reg = reg;
ffff800000103edb:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103ee2:	80 ff ff 
ffff800000103ee5:	48 8b 00             	mov    (%rax),%rax
ffff800000103ee8:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103eeb:	89 10                	mov    %edx,(%rax)
  ioapic->data = data;
ffff800000103eed:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103ef4:	80 ff ff 
ffff800000103ef7:	48 8b 00             	mov    (%rax),%rax
ffff800000103efa:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff800000103efd:	89 50 10             	mov    %edx,0x10(%rax)
}
ffff800000103f00:	90                   	nop
ffff800000103f01:	c9                   	leaveq 
ffff800000103f02:	c3                   	retq   

ffff800000103f03 <ioapicinit>:

void
ioapicinit(void)
{
ffff800000103f03:	f3 0f 1e fa          	endbr64 
ffff800000103f07:	55                   	push   %rbp
ffff800000103f08:	48 89 e5             	mov    %rsp,%rbp
ffff800000103f0b:	48 83 ec 10          	sub    $0x10,%rsp
  int i, id, maxintr;

  ioapic = P2V((volatile struct ioapic*)IOAPIC);
ffff800000103f0f:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103f16:	80 ff ff 
ffff800000103f19:	48 b9 00 00 c0 fe 00 	movabs $0xffff8000fec00000,%rcx
ffff800000103f20:	80 ff ff 
ffff800000103f23:	48 89 08             	mov    %rcx,(%rax)
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
ffff800000103f26:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000103f2b:	48 b8 96 3e 10 00 00 	movabs $0xffff800000103e96,%rax
ffff800000103f32:	80 ff ff 
ffff800000103f35:	ff d0                	callq  *%rax
ffff800000103f37:	c1 e8 10             	shr    $0x10,%eax
ffff800000103f3a:	25 ff 00 00 00       	and    $0xff,%eax
ffff800000103f3f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  id = ioapicread(REG_ID) >> 24;
ffff800000103f42:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000103f47:	48 b8 96 3e 10 00 00 	movabs $0xffff800000103e96,%rax
ffff800000103f4e:	80 ff ff 
ffff800000103f51:	ff d0                	callq  *%rax
ffff800000103f53:	c1 e8 18             	shr    $0x18,%eax
ffff800000103f56:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(id != ioapicid)
ffff800000103f59:	48 b8 24 74 1f 00 00 	movabs $0xffff8000001f7424,%rax
ffff800000103f60:	80 ff ff 
ffff800000103f63:	0f b6 00             	movzbl (%rax),%eax
ffff800000103f66:	0f b6 c0             	movzbl %al,%eax
ffff800000103f69:	39 45 f4             	cmp    %eax,-0xc(%rbp)
ffff800000103f6c:	74 1b                	je     ffff800000103f89 <ioapicinit+0x86>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
ffff800000103f6e:	48 bf 80 c6 10 00 00 	movabs $0xffff80000010c680,%rdi
ffff800000103f75:	80 ff ff 
ffff800000103f78:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000103f7d:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000103f84:	80 ff ff 
ffff800000103f87:	ff d2                	callq  *%rdx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
ffff800000103f89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000103f90:	eb 47                	jmp    ffff800000103fd9 <ioapicinit+0xd6>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
ffff800000103f92:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103f95:	83 c0 20             	add    $0x20,%eax
ffff800000103f98:	0d 00 00 01 00       	or     $0x10000,%eax
ffff800000103f9d:	89 c2                	mov    %eax,%edx
ffff800000103f9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103fa2:	83 c0 08             	add    $0x8,%eax
ffff800000103fa5:	01 c0                	add    %eax,%eax
ffff800000103fa7:	89 d6                	mov    %edx,%esi
ffff800000103fa9:	89 c7                	mov    %eax,%edi
ffff800000103fab:	48 b8 c9 3e 10 00 00 	movabs $0xffff800000103ec9,%rax
ffff800000103fb2:	80 ff ff 
ffff800000103fb5:	ff d0                	callq  *%rax
    ioapicwrite(REG_TABLE+2*i+1, 0);
ffff800000103fb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103fba:	83 c0 08             	add    $0x8,%eax
ffff800000103fbd:	01 c0                	add    %eax,%eax
ffff800000103fbf:	83 c0 01             	add    $0x1,%eax
ffff800000103fc2:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000103fc7:	89 c7                	mov    %eax,%edi
ffff800000103fc9:	48 b8 c9 3e 10 00 00 	movabs $0xffff800000103ec9,%rax
ffff800000103fd0:	80 ff ff 
ffff800000103fd3:	ff d0                	callq  *%rax
  for(i = 0; i <= maxintr; i++){
ffff800000103fd5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000103fd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103fdc:	3b 45 f8             	cmp    -0x8(%rbp),%eax
ffff800000103fdf:	7e b1                	jle    ffff800000103f92 <ioapicinit+0x8f>
  }
}
ffff800000103fe1:	90                   	nop
ffff800000103fe2:	90                   	nop
ffff800000103fe3:	c9                   	leaveq 
ffff800000103fe4:	c3                   	retq   

ffff800000103fe5 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
ffff800000103fe5:	f3 0f 1e fa          	endbr64 
ffff800000103fe9:	55                   	push   %rbp
ffff800000103fea:	48 89 e5             	mov    %rsp,%rbp
ffff800000103fed:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000103ff1:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000103ff4:	89 75 f8             	mov    %esi,-0x8(%rbp)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
ffff800000103ff7:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103ffa:	83 c0 20             	add    $0x20,%eax
ffff800000103ffd:	89 c2                	mov    %eax,%edx
ffff800000103fff:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104002:	83 c0 08             	add    $0x8,%eax
ffff800000104005:	01 c0                	add    %eax,%eax
ffff800000104007:	89 d6                	mov    %edx,%esi
ffff800000104009:	89 c7                	mov    %eax,%edi
ffff80000010400b:	48 b8 c9 3e 10 00 00 	movabs $0xffff800000103ec9,%rax
ffff800000104012:	80 ff ff 
ffff800000104015:	ff d0                	callq  *%rax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
ffff800000104017:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010401a:	c1 e0 18             	shl    $0x18,%eax
ffff80000010401d:	89 c2                	mov    %eax,%edx
ffff80000010401f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104022:	83 c0 08             	add    $0x8,%eax
ffff800000104025:	01 c0                	add    %eax,%eax
ffff800000104027:	83 c0 01             	add    $0x1,%eax
ffff80000010402a:	89 d6                	mov    %edx,%esi
ffff80000010402c:	89 c7                	mov    %eax,%edi
ffff80000010402e:	48 b8 c9 3e 10 00 00 	movabs $0xffff800000103ec9,%rax
ffff800000104035:	80 ff ff 
ffff800000104038:	ff d0                	callq  *%rax
}
ffff80000010403a:	90                   	nop
ffff80000010403b:	c9                   	leaveq 
ffff80000010403c:	c3                   	retq   

ffff80000010403d <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
ffff80000010403d:	f3 0f 1e fa          	endbr64 
ffff800000104041:	55                   	push   %rbp
ffff800000104042:	48 89 e5             	mov    %rsp,%rbp
ffff800000104045:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000104049:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff80000010404d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  initlock(&kmem.lock, "kmem");
ffff800000104051:	48 be b2 c6 10 00 00 	movabs $0xffff80000010c6b2,%rsi
ffff800000104058:	80 ff ff 
ffff80000010405b:	48 bf 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rdi
ffff800000104062:	80 ff ff 
ffff800000104065:	48 b8 24 78 10 00 00 	movabs $0xffff800000107824,%rax
ffff80000010406c:	80 ff ff 
ffff80000010406f:	ff d0                	callq  *%rax
  memset(frameinfo, 0, sizeof(frameinfo));
ffff800000104071:	ba 00 00 0e 00       	mov    $0xe0000,%edx
ffff800000104076:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010407b:	48 bf 40 71 11 00 00 	movabs $0xffff800000117140,%rdi
ffff800000104082:	80 ff ff 
ffff800000104085:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff80000010408c:	80 ff ff 
ffff80000010408f:	ff d0                	callq  *%rax
  kmem.use_lock = 0;
ffff800000104091:	48 b8 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rax
ffff800000104098:	80 ff ff 
ffff80000010409b:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%rax)
  kmem.freelist = 0;
ffff8000001040a2:	48 b8 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rax
ffff8000001040a9:	80 ff ff 
ffff8000001040ac:	48 c7 40 70 00 00 00 	movq   $0x0,0x70(%rax)
ffff8000001040b3:	00 
  freerange(vstart, vend);
ffff8000001040b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001040b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001040bc:	48 89 d6             	mov    %rdx,%rsi
ffff8000001040bf:	48 89 c7             	mov    %rax,%rdi
ffff8000001040c2:	48 b8 13 41 10 00 00 	movabs $0xffff800000104113,%rax
ffff8000001040c9:	80 ff ff 
ffff8000001040cc:	ff d0                	callq  *%rax
}
ffff8000001040ce:	90                   	nop
ffff8000001040cf:	c9                   	leaveq 
ffff8000001040d0:	c3                   	retq   

ffff8000001040d1 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
ffff8000001040d1:	f3 0f 1e fa          	endbr64 
ffff8000001040d5:	55                   	push   %rbp
ffff8000001040d6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001040d9:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001040dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001040e1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  freerange(vstart, vend);
ffff8000001040e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001040e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001040ed:	48 89 d6             	mov    %rdx,%rsi
ffff8000001040f0:	48 89 c7             	mov    %rax,%rdi
ffff8000001040f3:	48 b8 13 41 10 00 00 	movabs $0xffff800000104113,%rax
ffff8000001040fa:	80 ff ff 
ffff8000001040fd:	ff d0                	callq  *%rax
  kmem.use_lock = 1;
ffff8000001040ff:	48 b8 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rax
ffff800000104106:	80 ff ff 
ffff800000104109:	c7 40 68 01 00 00 00 	movl   $0x1,0x68(%rax)
}
ffff800000104110:	90                   	nop
ffff800000104111:	c9                   	leaveq 
ffff800000104112:	c3                   	retq   

ffff800000104113 <freerange>:

void
freerange(void *vstart, void *vend)
{
ffff800000104113:	f3 0f 1e fa          	endbr64 
ffff800000104117:	55                   	push   %rbp
ffff800000104118:	48 89 e5             	mov    %rsp,%rbp
ffff80000010411b:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010411f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000104123:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *p;
  p = (char*)PGROUNDUP((addr_t)vstart);
ffff800000104127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010412b:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff800000104131:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff800000104137:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
ffff80000010413b:	eb 1b                	jmp    ffff800000104158 <freerange+0x45>
    kfree(p);
ffff80000010413d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104141:	48 89 c7             	mov    %rax,%rdi
ffff800000104144:	48 b8 6c 41 10 00 00 	movabs $0xffff80000010416c,%rax
ffff80000010414b:	80 ff ff 
ffff80000010414e:	ff d0                	callq  *%rax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
ffff800000104150:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff800000104157:	00 
ffff800000104158:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010415c:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff800000104162:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
ffff800000104166:	73 d5                	jae    ffff80000010413d <freerange+0x2a>
}
ffff800000104168:	90                   	nop
ffff800000104169:	90                   	nop
ffff80000010416a:	c9                   	leaveq 
ffff80000010416b:	c3                   	retq   

ffff80000010416c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
ffff80000010416c:	f3 0f 1e fa          	endbr64 
ffff800000104170:	55                   	push   %rbp
ffff800000104171:	48 89 e5             	mov    %rsp,%rbp
ffff800000104174:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000104178:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct run *r;

  if((addr_t)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
ffff80000010417c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104180:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff800000104185:	48 85 c0             	test   %rax,%rax
ffff800000104188:	75 29                	jne    ffff8000001041b3 <kfree+0x47>
ffff80000010418a:	48 b8 00 b0 1f 00 00 	movabs $0xffff8000001fb000,%rax
ffff800000104191:	80 ff ff 
ffff800000104194:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff800000104198:	72 19                	jb     ffff8000001041b3 <kfree+0x47>
ffff80000010419a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010419e:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff8000001041a5:	80 00 00 
ffff8000001041a8:	48 01 d0             	add    %rdx,%rax
ffff8000001041ab:	48 3d ff ff ff 0d    	cmp    $0xdffffff,%rax
ffff8000001041b1:	76 16                	jbe    ffff8000001041c9 <kfree+0x5d>
    panic("kfree");
ffff8000001041b3:	48 bf b7 c6 10 00 00 	movabs $0xffff80000010c6b7,%rdi
ffff8000001041ba:	80 ff ff 
ffff8000001041bd:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001041c4:	80 ff ff 
ffff8000001041c7:	ff d0                	callq  *%rax

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
ffff8000001041c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001041cd:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff8000001041d2:	be 01 00 00 00       	mov    $0x1,%esi
ffff8000001041d7:	48 89 c7             	mov    %rax,%rdi
ffff8000001041da:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff8000001041e1:	80 ff ff 
ffff8000001041e4:	ff d0                	callq  *%rax

  if(kmem.use_lock)
ffff8000001041e6:	48 b8 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rax
ffff8000001041ed:	80 ff ff 
ffff8000001041f0:	8b 40 68             	mov    0x68(%rax),%eax
ffff8000001041f3:	85 c0                	test   %eax,%eax
ffff8000001041f5:	74 16                	je     ffff80000010420d <kfree+0xa1>
    acquire(&kmem.lock);
ffff8000001041f7:	48 bf 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rdi
ffff8000001041fe:	80 ff ff 
ffff800000104201:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000104208:	80 ff ff 
ffff80000010420b:	ff d0                	callq  *%rax
  r = (struct run*)v;
ffff80000010420d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104211:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  r->next = kmem.freelist;
ffff800000104215:	48 b8 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rax
ffff80000010421c:	80 ff ff 
ffff80000010421f:	48 8b 50 70          	mov    0x70(%rax),%rdx
ffff800000104223:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104227:	48 89 10             	mov    %rdx,(%rax)
  kmem.freelist = r;
ffff80000010422a:	48 ba 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rdx
ffff800000104231:	80 ff ff 
ffff800000104234:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104238:	48 89 42 70          	mov    %rax,0x70(%rdx)
  if(kmem.use_lock)
ffff80000010423c:	48 b8 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rax
ffff800000104243:	80 ff ff 
ffff800000104246:	8b 40 68             	mov    0x68(%rax),%eax
ffff800000104249:	85 c0                	test   %eax,%eax
ffff80000010424b:	74 16                	je     ffff800000104263 <kfree+0xf7>
    release(&kmem.lock);
ffff80000010424d:	48 bf 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rdi
ffff800000104254:	80 ff ff 
ffff800000104257:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff80000010425e:	80 ff ff 
ffff800000104261:	ff d0                	callq  *%rax
}
ffff800000104263:	90                   	nop
ffff800000104264:	c9                   	leaveq 
ffff800000104265:	c3                   	retq   

ffff800000104266 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
ffff800000104266:	f3 0f 1e fa          	endbr64 
ffff80000010426a:	55                   	push   %rbp
ffff80000010426b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010426e:	48 83 ec 10          	sub    $0x10,%rsp
  struct run *r;

  if(kmem.use_lock)
ffff800000104272:	48 b8 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rax
ffff800000104279:	80 ff ff 
ffff80000010427c:	8b 40 68             	mov    0x68(%rax),%eax
ffff80000010427f:	85 c0                	test   %eax,%eax
ffff800000104281:	74 16                	je     ffff800000104299 <kalloc+0x33>
    acquire(&kmem.lock);
ffff800000104283:	48 bf 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rdi
ffff80000010428a:	80 ff ff 
ffff80000010428d:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000104294:	80 ff ff 
ffff800000104297:	ff d0                	callq  *%rax
  r = kmem.freelist;
ffff800000104299:	48 b8 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rax
ffff8000001042a0:	80 ff ff 
ffff8000001042a3:	48 8b 40 70          	mov    0x70(%rax),%rax
ffff8000001042a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(r)
ffff8000001042ab:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001042b0:	74 15                	je     ffff8000001042c7 <kalloc+0x61>
    kmem.freelist = r->next;
ffff8000001042b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001042b6:	48 8b 00             	mov    (%rax),%rax
ffff8000001042b9:	48 ba 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rdx
ffff8000001042c0:	80 ff ff 
ffff8000001042c3:	48 89 42 70          	mov    %rax,0x70(%rdx)
  if(kmem.use_lock)
ffff8000001042c7:	48 b8 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rax
ffff8000001042ce:	80 ff ff 
ffff8000001042d1:	8b 40 68             	mov    0x68(%rax),%eax
ffff8000001042d4:	85 c0                	test   %eax,%eax
ffff8000001042d6:	74 16                	je     ffff8000001042ee <kalloc+0x88>
    release(&kmem.lock);
ffff8000001042d8:	48 bf 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rdi
ffff8000001042df:	80 ff ff 
ffff8000001042e2:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001042e9:	80 ff ff 
ffff8000001042ec:	ff d0                	callq  *%rax

  frameinfo[PGINDEX(V2P(r))].refs = 1;
ffff8000001042ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001042f2:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff8000001042f9:	80 00 00 
ffff8000001042fc:	48 01 d0             	add    %rdx,%rax
ffff8000001042ff:	48 c1 e8 0c          	shr    $0xc,%rax
ffff800000104303:	48 ba 40 71 11 00 00 	movabs $0xffff800000117140,%rdx
ffff80000010430a:	80 ff ff 
ffff80000010430d:	48 c1 e0 04          	shl    $0x4,%rax
ffff800000104311:	48 01 d0             	add    %rdx,%rax
ffff800000104314:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  return (char*)r;
ffff80000010431a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff80000010431e:	c9                   	leaveq 
ffff80000010431f:	c3                   	retq   

ffff800000104320 <krelease>:

// release frame with kernel virtual address v
  void
krelease(char *v)
{
ffff800000104320:	f3 0f 1e fa          	endbr64 
ffff800000104324:	55                   	push   %rbp
ffff800000104325:	48 89 e5             	mov    %rsp,%rbp
ffff800000104328:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010432c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  addr_t frame = V2P(v);
ffff800000104330:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104334:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010433b:	80 00 00 
ffff80000010433e:	48 01 d0             	add    %rdx,%rax
ffff800000104341:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  frameinfo[PGINDEX(frame)].refs--;
ffff800000104345:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104349:	48 c1 e8 0c          	shr    $0xc,%rax
ffff80000010434d:	48 b9 40 71 11 00 00 	movabs $0xffff800000117140,%rcx
ffff800000104354:	80 ff ff 
ffff800000104357:	48 89 c2             	mov    %rax,%rdx
ffff80000010435a:	48 c1 e2 04          	shl    $0x4,%rdx
ffff80000010435e:	48 01 ca             	add    %rcx,%rdx
ffff800000104361:	8b 12                	mov    (%rdx),%edx
ffff800000104363:	83 ea 01             	sub    $0x1,%edx
ffff800000104366:	48 b9 40 71 11 00 00 	movabs $0xffff800000117140,%rcx
ffff80000010436d:	80 ff ff 
ffff800000104370:	48 c1 e0 04          	shl    $0x4,%rax
ffff800000104374:	48 01 c8             	add    %rcx,%rax
ffff800000104377:	89 10                	mov    %edx,(%rax)
  if (frameinfo[PGINDEX(frame)].refs == 0)
ffff800000104379:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010437d:	48 c1 e8 0c          	shr    $0xc,%rax
ffff800000104381:	48 ba 40 71 11 00 00 	movabs $0xffff800000117140,%rdx
ffff800000104388:	80 ff ff 
ffff80000010438b:	48 c1 e0 04          	shl    $0x4,%rax
ffff80000010438f:	48 01 d0             	add    %rdx,%rax
ffff800000104392:	8b 00                	mov    (%rax),%eax
ffff800000104394:	85 c0                	test   %eax,%eax
ffff800000104396:	75 20                	jne    ffff8000001043b8 <krelease+0x98>
    kfree(P2V(frame));
ffff800000104398:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff80000010439f:	80 ff ff 
ffff8000001043a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001043a6:	48 01 d0             	add    %rdx,%rax
ffff8000001043a9:	48 89 c7             	mov    %rax,%rdi
ffff8000001043ac:	48 b8 6c 41 10 00 00 	movabs $0xffff80000010416c,%rax
ffff8000001043b3:	80 ff ff 
ffff8000001043b6:	ff d0                	callq  *%rax
}
ffff8000001043b8:	90                   	nop
ffff8000001043b9:	c9                   	leaveq 
ffff8000001043ba:	c3                   	retq   

ffff8000001043bb <kretain>:

  void
kretain(char *v)
{
ffff8000001043bb:	f3 0f 1e fa          	endbr64 
ffff8000001043bf:	55                   	push   %rbp
ffff8000001043c0:	48 89 e5             	mov    %rsp,%rbp
ffff8000001043c3:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001043c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  addr_t frame = V2P(v);
ffff8000001043cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001043cf:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff8000001043d6:	80 00 00 
ffff8000001043d9:	48 01 d0             	add    %rdx,%rax
ffff8000001043dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  frameinfo[PGINDEX(frame)].refs++;
ffff8000001043e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001043e4:	48 c1 e8 0c          	shr    $0xc,%rax
ffff8000001043e8:	48 b9 40 71 11 00 00 	movabs $0xffff800000117140,%rcx
ffff8000001043ef:	80 ff ff 
ffff8000001043f2:	48 89 c2             	mov    %rax,%rdx
ffff8000001043f5:	48 c1 e2 04          	shl    $0x4,%rdx
ffff8000001043f9:	48 01 ca             	add    %rcx,%rdx
ffff8000001043fc:	8b 12                	mov    (%rdx),%edx
ffff8000001043fe:	83 c2 01             	add    $0x1,%edx
ffff800000104401:	48 b9 40 71 11 00 00 	movabs $0xffff800000117140,%rcx
ffff800000104408:	80 ff ff 
ffff80000010440b:	48 c1 e0 04          	shl    $0x4,%rax
ffff80000010440f:	48 01 c8             	add    %rcx,%rax
ffff800000104412:	89 10                	mov    %edx,(%rax)
}
ffff800000104414:	90                   	nop
ffff800000104415:	c9                   	leaveq 
ffff800000104416:	c3                   	retq   

ffff800000104417 <krefcount>:

  int
krefcount(char *v)
{
ffff800000104417:	f3 0f 1e fa          	endbr64 
ffff80000010441b:	55                   	push   %rbp
ffff80000010441c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010441f:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000104423:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  return frameinfo[PGINDEX(V2P(v))].refs;
ffff800000104427:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010442b:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff800000104432:	80 00 00 
ffff800000104435:	48 01 d0             	add    %rdx,%rax
ffff800000104438:	48 c1 e8 0c          	shr    $0xc,%rax
ffff80000010443c:	48 ba 40 71 11 00 00 	movabs $0xffff800000117140,%rdx
ffff800000104443:	80 ff ff 
ffff800000104446:	48 c1 e0 04          	shl    $0x4,%rax
ffff80000010444a:	48 01 d0             	add    %rdx,%rax
ffff80000010444d:	8b 00                	mov    (%rax),%eax
}
ffff80000010444f:	c9                   	leaveq 
ffff800000104450:	c3                   	retq   

ffff800000104451 <update_checksum>:

  void
update_checksum(addr_t frame)
{
ffff800000104451:	f3 0f 1e fa          	endbr64 
ffff800000104455:	55                   	push   %rbp
ffff800000104456:	48 89 e5             	mov    %rsp,%rbp
ffff800000104459:	48 83 ec 28          	sub    $0x28,%rsp
ffff80000010445d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  struct frameinfo *f = &frameinfo[PGINDEX(frame)];
ffff800000104461:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000104465:	48 c1 e8 0c          	shr    $0xc,%rax
ffff800000104469:	48 c1 e0 04          	shl    $0x4,%rax
ffff80000010446d:	48 89 c2             	mov    %rax,%rdx
ffff800000104470:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff800000104477:	80 ff ff 
ffff80000010447a:	48 01 d0             	add    %rdx,%rax
ffff80000010447d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  f->checksum = 0;
ffff800000104481:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104485:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
ffff80000010448c:	00 

  addr_t *v = P2V(frame);
ffff80000010448d:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff800000104494:	80 ff ff 
ffff800000104497:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010449b:	48 01 d0             	add    %rdx,%rax
ffff80000010449e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  for (addr_t *i=v; i<v+PGSIZE/8; i++)
ffff8000001044a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001044a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001044aa:	eb 1f                	jmp    ffff8000001044cb <update_checksum+0x7a>
    f->checksum+=*i;
ffff8000001044ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001044b0:	48 8b 50 08          	mov    0x8(%rax),%rdx
ffff8000001044b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001044b8:	48 8b 00             	mov    (%rax),%rax
ffff8000001044bb:	48 01 c2             	add    %rax,%rdx
ffff8000001044be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001044c2:	48 89 50 08          	mov    %rdx,0x8(%rax)
  for (addr_t *i=v; i<v+PGSIZE/8; i++)
ffff8000001044c6:	48 83 45 f8 08       	addq   $0x8,-0x8(%rbp)
ffff8000001044cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001044cf:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff8000001044d5:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001044d9:	72 d1                	jb     ffff8000001044ac <update_checksum+0x5b>
}
ffff8000001044db:	90                   	nop
ffff8000001044dc:	90                   	nop
ffff8000001044dd:	c9                   	leaveq 
ffff8000001044de:	c3                   	retq   

ffff8000001044df <frames_are_identical>:

// this should only be called after all checksums have been updated
  int
frames_are_identical(addr_t frame1, addr_t frame2)
{
ffff8000001044df:	f3 0f 1e fa          	endbr64 
ffff8000001044e3:	55                   	push   %rbp
ffff8000001044e4:	48 89 e5             	mov    %rsp,%rbp
ffff8000001044e7:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001044eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001044ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  return frameinfo[PGINDEX(frame1)].checksum == frameinfo[PGINDEX(frame2)].checksum &&
ffff8000001044f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001044f7:	48 c1 e8 0c          	shr    $0xc,%rax
ffff8000001044fb:	48 ba 40 71 11 00 00 	movabs $0xffff800000117140,%rdx
ffff800000104502:	80 ff ff 
ffff800000104505:	48 c1 e0 04          	shl    $0x4,%rax
ffff800000104509:	48 01 d0             	add    %rdx,%rax
ffff80000010450c:	48 83 c0 08          	add    $0x8,%rax
ffff800000104510:	48 8b 10             	mov    (%rax),%rdx
ffff800000104513:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104517:	48 c1 e8 0c          	shr    $0xc,%rax
ffff80000010451b:	48 b9 40 71 11 00 00 	movabs $0xffff800000117140,%rcx
ffff800000104522:	80 ff ff 
ffff800000104525:	48 c1 e0 04          	shl    $0x4,%rax
ffff800000104529:	48 01 c8             	add    %rcx,%rax
ffff80000010452c:	48 83 c0 08          	add    $0x8,%rax
ffff800000104530:	48 8b 00             	mov    (%rax),%rax
ffff800000104533:	48 39 c2             	cmp    %rax,%rdx
ffff800000104536:	75 47                	jne    ffff80000010457f <frames_are_identical+0xa0>
    memcmp(P2V(frame1),P2V(frame2),PGSIZE)==0;
ffff800000104538:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff80000010453f:	80 ff ff 
ffff800000104542:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104546:	48 01 d0             	add    %rdx,%rax
ffff800000104549:	48 89 c1             	mov    %rax,%rcx
ffff80000010454c:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff800000104553:	80 ff ff 
ffff800000104556:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010455a:	48 01 d0             	add    %rdx,%rax
ffff80000010455d:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff800000104562:	48 89 ce             	mov    %rcx,%rsi
ffff800000104565:	48 89 c7             	mov    %rax,%rdi
ffff800000104568:	48 b8 9d 7c 10 00 00 	movabs $0xffff800000107c9d,%rax
ffff80000010456f:	80 ff ff 
ffff800000104572:	ff d0                	callq  *%rax
  return frameinfo[PGINDEX(frame1)].checksum == frameinfo[PGINDEX(frame2)].checksum &&
ffff800000104574:	85 c0                	test   %eax,%eax
ffff800000104576:	75 07                	jne    ffff80000010457f <frames_are_identical+0xa0>
ffff800000104578:	b8 01 00 00 00       	mov    $0x1,%eax
ffff80000010457d:	eb 05                	jmp    ffff800000104584 <frames_are_identical+0xa5>
ffff80000010457f:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000104584:	c9                   	leaveq 
ffff800000104585:	c3                   	retq   

ffff800000104586 <kfreepagecount>:

  int
kfreepagecount()
{
ffff800000104586:	f3 0f 1e fa          	endbr64 
ffff80000010458a:	55                   	push   %rbp
ffff80000010458b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010458e:	48 83 ec 10          	sub    $0x10,%rsp
  int i=0;
ffff800000104592:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

  acquire(&kmem.lock);
ffff800000104599:	48 bf 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rdi
ffff8000001045a0:	80 ff ff 
ffff8000001045a3:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff8000001045aa:	80 ff ff 
ffff8000001045ad:	ff d0                	callq  *%rax
  struct run *list = kmem.freelist;
ffff8000001045af:	48 b8 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rax
ffff8000001045b6:	80 ff ff 
ffff8000001045b9:	48 8b 40 70          	mov    0x70(%rax),%rax
ffff8000001045bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(list) {
ffff8000001045c1:	eb 0f                	jmp    ffff8000001045d2 <kfreepagecount+0x4c>
    i++;
ffff8000001045c3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    list=list->next;
ffff8000001045c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001045cb:	48 8b 00             	mov    (%rax),%rax
ffff8000001045ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(list) {
ffff8000001045d2:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff8000001045d7:	75 ea                	jne    ffff8000001045c3 <kfreepagecount+0x3d>
  }
  release(&kmem.lock);
ffff8000001045d9:	48 bf 40 71 1f 00 00 	movabs $0xffff8000001f7140,%rdi
ffff8000001045e0:	80 ff ff 
ffff8000001045e3:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001045ea:	80 ff ff 
ffff8000001045ed:	ff d0                	callq  *%rax
  return i;
ffff8000001045ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff8000001045f2:	c9                   	leaveq 
ffff8000001045f3:	c3                   	retq   

ffff8000001045f4 <inb>:
{
ffff8000001045f4:	f3 0f 1e fa          	endbr64 
ffff8000001045f8:	55                   	push   %rbp
ffff8000001045f9:	48 89 e5             	mov    %rsp,%rbp
ffff8000001045fc:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000104600:	89 f8                	mov    %edi,%eax
ffff800000104602:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff800000104606:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff80000010460a:	89 c2                	mov    %eax,%edx
ffff80000010460c:	ec                   	in     (%dx),%al
ffff80000010460d:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff800000104610:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff800000104614:	c9                   	leaveq 
ffff800000104615:	c3                   	retq   

ffff800000104616 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
ffff800000104616:	f3 0f 1e fa          	endbr64 
ffff80000010461a:	55                   	push   %rbp
ffff80000010461b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010461e:	48 83 ec 10          	sub    $0x10,%rsp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
ffff800000104622:	bf 64 00 00 00       	mov    $0x64,%edi
ffff800000104627:	48 b8 f4 45 10 00 00 	movabs $0xffff8000001045f4,%rax
ffff80000010462e:	80 ff ff 
ffff800000104631:	ff d0                	callq  *%rax
ffff800000104633:	0f b6 c0             	movzbl %al,%eax
ffff800000104636:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if((st & KBS_DIB) == 0)
ffff800000104639:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010463c:	83 e0 01             	and    $0x1,%eax
ffff80000010463f:	85 c0                	test   %eax,%eax
ffff800000104641:	75 0a                	jne    ffff80000010464d <kbdgetc+0x37>
    return -1;
ffff800000104643:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000104648:	e9 ae 01 00 00       	jmpq   ffff8000001047fb <kbdgetc+0x1e5>
  data = inb(KBDATAP);
ffff80000010464d:	bf 60 00 00 00       	mov    $0x60,%edi
ffff800000104652:	48 b8 f4 45 10 00 00 	movabs $0xffff8000001045f4,%rax
ffff800000104659:	80 ff ff 
ffff80000010465c:	ff d0                	callq  *%rax
ffff80000010465e:	0f b6 c0             	movzbl %al,%eax
ffff800000104661:	89 45 fc             	mov    %eax,-0x4(%rbp)

  if(data == 0xE0){
ffff800000104664:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%rbp)
ffff80000010466b:	75 27                	jne    ffff800000104694 <kbdgetc+0x7e>
    shift |= E0ESC;
ffff80000010466d:	48 b8 b8 71 1f 00 00 	movabs $0xffff8000001f71b8,%rax
ffff800000104674:	80 ff ff 
ffff800000104677:	8b 00                	mov    (%rax),%eax
ffff800000104679:	83 c8 40             	or     $0x40,%eax
ffff80000010467c:	89 c2                	mov    %eax,%edx
ffff80000010467e:	48 b8 b8 71 1f 00 00 	movabs $0xffff8000001f71b8,%rax
ffff800000104685:	80 ff ff 
ffff800000104688:	89 10                	mov    %edx,(%rax)
    return 0;
ffff80000010468a:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010468f:	e9 67 01 00 00       	jmpq   ffff8000001047fb <kbdgetc+0x1e5>
  } else if(data & 0x80){
ffff800000104694:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104697:	25 80 00 00 00       	and    $0x80,%eax
ffff80000010469c:	85 c0                	test   %eax,%eax
ffff80000010469e:	74 60                	je     ffff800000104700 <kbdgetc+0xea>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
ffff8000001046a0:	48 b8 b8 71 1f 00 00 	movabs $0xffff8000001f71b8,%rax
ffff8000001046a7:	80 ff ff 
ffff8000001046aa:	8b 00                	mov    (%rax),%eax
ffff8000001046ac:	83 e0 40             	and    $0x40,%eax
ffff8000001046af:	85 c0                	test   %eax,%eax
ffff8000001046b1:	75 08                	jne    ffff8000001046bb <kbdgetc+0xa5>
ffff8000001046b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001046b6:	83 e0 7f             	and    $0x7f,%eax
ffff8000001046b9:	eb 03                	jmp    ffff8000001046be <kbdgetc+0xa8>
ffff8000001046bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001046be:	89 45 fc             	mov    %eax,-0x4(%rbp)
    shift &= ~(shiftcode[data] | E0ESC);
ffff8000001046c1:	48 ba 20 d0 10 00 00 	movabs $0xffff80000010d020,%rdx
ffff8000001046c8:	80 ff ff 
ffff8000001046cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001046ce:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff8000001046d2:	83 c8 40             	or     $0x40,%eax
ffff8000001046d5:	0f b6 c0             	movzbl %al,%eax
ffff8000001046d8:	f7 d0                	not    %eax
ffff8000001046da:	89 c2                	mov    %eax,%edx
ffff8000001046dc:	48 b8 b8 71 1f 00 00 	movabs $0xffff8000001f71b8,%rax
ffff8000001046e3:	80 ff ff 
ffff8000001046e6:	8b 00                	mov    (%rax),%eax
ffff8000001046e8:	21 c2                	and    %eax,%edx
ffff8000001046ea:	48 b8 b8 71 1f 00 00 	movabs $0xffff8000001f71b8,%rax
ffff8000001046f1:	80 ff ff 
ffff8000001046f4:	89 10                	mov    %edx,(%rax)
    return 0;
ffff8000001046f6:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001046fb:	e9 fb 00 00 00       	jmpq   ffff8000001047fb <kbdgetc+0x1e5>
  } else if(shift & E0ESC){
ffff800000104700:	48 b8 b8 71 1f 00 00 	movabs $0xffff8000001f71b8,%rax
ffff800000104707:	80 ff ff 
ffff80000010470a:	8b 00                	mov    (%rax),%eax
ffff80000010470c:	83 e0 40             	and    $0x40,%eax
ffff80000010470f:	85 c0                	test   %eax,%eax
ffff800000104711:	74 24                	je     ffff800000104737 <kbdgetc+0x121>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
ffff800000104713:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%rbp)
    shift &= ~E0ESC;
ffff80000010471a:	48 b8 b8 71 1f 00 00 	movabs $0xffff8000001f71b8,%rax
ffff800000104721:	80 ff ff 
ffff800000104724:	8b 00                	mov    (%rax),%eax
ffff800000104726:	83 e0 bf             	and    $0xffffffbf,%eax
ffff800000104729:	89 c2                	mov    %eax,%edx
ffff80000010472b:	48 b8 b8 71 1f 00 00 	movabs $0xffff8000001f71b8,%rax
ffff800000104732:	80 ff ff 
ffff800000104735:	89 10                	mov    %edx,(%rax)
  }

  shift |= shiftcode[data];
ffff800000104737:	48 ba 20 d0 10 00 00 	movabs $0xffff80000010d020,%rdx
ffff80000010473e:	80 ff ff 
ffff800000104741:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104744:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff800000104748:	0f b6 d0             	movzbl %al,%edx
ffff80000010474b:	48 b8 b8 71 1f 00 00 	movabs $0xffff8000001f71b8,%rax
ffff800000104752:	80 ff ff 
ffff800000104755:	8b 00                	mov    (%rax),%eax
ffff800000104757:	09 c2                	or     %eax,%edx
ffff800000104759:	48 b8 b8 71 1f 00 00 	movabs $0xffff8000001f71b8,%rax
ffff800000104760:	80 ff ff 
ffff800000104763:	89 10                	mov    %edx,(%rax)
  shift ^= togglecode[data];
ffff800000104765:	48 ba 20 d1 10 00 00 	movabs $0xffff80000010d120,%rdx
ffff80000010476c:	80 ff ff 
ffff80000010476f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104772:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff800000104776:	0f b6 d0             	movzbl %al,%edx
ffff800000104779:	48 b8 b8 71 1f 00 00 	movabs $0xffff8000001f71b8,%rax
ffff800000104780:	80 ff ff 
ffff800000104783:	8b 00                	mov    (%rax),%eax
ffff800000104785:	31 c2                	xor    %eax,%edx
ffff800000104787:	48 b8 b8 71 1f 00 00 	movabs $0xffff8000001f71b8,%rax
ffff80000010478e:	80 ff ff 
ffff800000104791:	89 10                	mov    %edx,(%rax)
  c = charcode[shift & (CTL | SHIFT)][data];
ffff800000104793:	48 b8 b8 71 1f 00 00 	movabs $0xffff8000001f71b8,%rax
ffff80000010479a:	80 ff ff 
ffff80000010479d:	8b 00                	mov    (%rax),%eax
ffff80000010479f:	83 e0 03             	and    $0x3,%eax
ffff8000001047a2:	89 c2                	mov    %eax,%edx
ffff8000001047a4:	48 b8 20 d5 10 00 00 	movabs $0xffff80000010d520,%rax
ffff8000001047ab:	80 ff ff 
ffff8000001047ae:	89 d2                	mov    %edx,%edx
ffff8000001047b0:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
ffff8000001047b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001047b7:	48 01 d0             	add    %rdx,%rax
ffff8000001047ba:	0f b6 00             	movzbl (%rax),%eax
ffff8000001047bd:	0f b6 c0             	movzbl %al,%eax
ffff8000001047c0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(shift & CAPSLOCK){
ffff8000001047c3:	48 b8 b8 71 1f 00 00 	movabs $0xffff8000001f71b8,%rax
ffff8000001047ca:	80 ff ff 
ffff8000001047cd:	8b 00                	mov    (%rax),%eax
ffff8000001047cf:	83 e0 08             	and    $0x8,%eax
ffff8000001047d2:	85 c0                	test   %eax,%eax
ffff8000001047d4:	74 22                	je     ffff8000001047f8 <kbdgetc+0x1e2>
    if('a' <= c && c <= 'z')
ffff8000001047d6:	83 7d f8 60          	cmpl   $0x60,-0x8(%rbp)
ffff8000001047da:	76 0c                	jbe    ffff8000001047e8 <kbdgetc+0x1d2>
ffff8000001047dc:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%rbp)
ffff8000001047e0:	77 06                	ja     ffff8000001047e8 <kbdgetc+0x1d2>
      c += 'A' - 'a';
ffff8000001047e2:	83 6d f8 20          	subl   $0x20,-0x8(%rbp)
ffff8000001047e6:	eb 10                	jmp    ffff8000001047f8 <kbdgetc+0x1e2>
    else if('A' <= c && c <= 'Z')
ffff8000001047e8:	83 7d f8 40          	cmpl   $0x40,-0x8(%rbp)
ffff8000001047ec:	76 0a                	jbe    ffff8000001047f8 <kbdgetc+0x1e2>
ffff8000001047ee:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%rbp)
ffff8000001047f2:	77 04                	ja     ffff8000001047f8 <kbdgetc+0x1e2>
      c += 'a' - 'A';
ffff8000001047f4:	83 45 f8 20          	addl   $0x20,-0x8(%rbp)
  }
  return c;
ffff8000001047f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
ffff8000001047fb:	c9                   	leaveq 
ffff8000001047fc:	c3                   	retq   

ffff8000001047fd <kbdintr>:

void
kbdintr(void)
{
ffff8000001047fd:	f3 0f 1e fa          	endbr64 
ffff800000104801:	55                   	push   %rbp
ffff800000104802:	48 89 e5             	mov    %rsp,%rbp
  consoleintr(kbdgetc);
ffff800000104805:	48 bf 16 46 10 00 00 	movabs $0xffff800000104616,%rdi
ffff80000010480c:	80 ff ff 
ffff80000010480f:	48 b8 83 0f 10 00 00 	movabs $0xffff800000100f83,%rax
ffff800000104816:	80 ff ff 
ffff800000104819:	ff d0                	callq  *%rax
}
ffff80000010481b:	90                   	nop
ffff80000010481c:	5d                   	pop    %rbp
ffff80000010481d:	c3                   	retq   

ffff80000010481e <inb>:
{
ffff80000010481e:	f3 0f 1e fa          	endbr64 
ffff800000104822:	55                   	push   %rbp
ffff800000104823:	48 89 e5             	mov    %rsp,%rbp
ffff800000104826:	48 83 ec 18          	sub    $0x18,%rsp
ffff80000010482a:	89 f8                	mov    %edi,%eax
ffff80000010482c:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff800000104830:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff800000104834:	89 c2                	mov    %eax,%edx
ffff800000104836:	ec                   	in     (%dx),%al
ffff800000104837:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff80000010483a:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff80000010483e:	c9                   	leaveq 
ffff80000010483f:	c3                   	retq   

ffff800000104840 <outb>:
{
ffff800000104840:	f3 0f 1e fa          	endbr64 
ffff800000104844:	55                   	push   %rbp
ffff800000104845:	48 89 e5             	mov    %rsp,%rbp
ffff800000104848:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010484c:	89 f8                	mov    %edi,%eax
ffff80000010484e:	89 f2                	mov    %esi,%edx
ffff800000104850:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
ffff800000104854:	89 d0                	mov    %edx,%eax
ffff800000104856:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff800000104859:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff80000010485d:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff800000104861:	ee                   	out    %al,(%dx)
}
ffff800000104862:	90                   	nop
ffff800000104863:	c9                   	leaveq 
ffff800000104864:	c3                   	retq   

ffff800000104865 <readeflags>:
{
ffff800000104865:	f3 0f 1e fa          	endbr64 
ffff800000104869:	55                   	push   %rbp
ffff80000010486a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010486d:	48 83 ec 10          	sub    $0x10,%rsp
  asm volatile("pushf; pop %0" : "=r" (eflags));
ffff800000104871:	9c                   	pushfq 
ffff800000104872:	58                   	pop    %rax
ffff800000104873:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return eflags;
ffff800000104877:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff80000010487b:	c9                   	leaveq 
ffff80000010487c:	c3                   	retq   

ffff80000010487d <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
ffff80000010487d:	f3 0f 1e fa          	endbr64 
ffff800000104881:	55                   	push   %rbp
ffff800000104882:	48 89 e5             	mov    %rsp,%rbp
ffff800000104885:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000104889:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff80000010488c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  lapic[index] = value;
ffff80000010488f:	48 b8 c0 71 1f 00 00 	movabs $0xffff8000001f71c0,%rax
ffff800000104896:	80 ff ff 
ffff800000104899:	48 8b 00             	mov    (%rax),%rax
ffff80000010489c:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010489f:	48 63 d2             	movslq %edx,%rdx
ffff8000001048a2:	48 c1 e2 02          	shl    $0x2,%rdx
ffff8000001048a6:	48 01 c2             	add    %rax,%rdx
ffff8000001048a9:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001048ac:	89 02                	mov    %eax,(%rdx)
  lapic[ID];  // wait for write to finish, by reading
ffff8000001048ae:	48 b8 c0 71 1f 00 00 	movabs $0xffff8000001f71c0,%rax
ffff8000001048b5:	80 ff ff 
ffff8000001048b8:	48 8b 00             	mov    (%rax),%rax
ffff8000001048bb:	48 83 c0 20          	add    $0x20,%rax
ffff8000001048bf:	8b 00                	mov    (%rax),%eax
}
ffff8000001048c1:	90                   	nop
ffff8000001048c2:	c9                   	leaveq 
ffff8000001048c3:	c3                   	retq   

ffff8000001048c4 <lapicinit>:

void
lapicinit(void)
{
ffff8000001048c4:	f3 0f 1e fa          	endbr64 
ffff8000001048c8:	55                   	push   %rbp
ffff8000001048c9:	48 89 e5             	mov    %rsp,%rbp
  if(!lapic)
ffff8000001048cc:	48 b8 c0 71 1f 00 00 	movabs $0xffff8000001f71c0,%rax
ffff8000001048d3:	80 ff ff 
ffff8000001048d6:	48 8b 00             	mov    (%rax),%rax
ffff8000001048d9:	48 85 c0             	test   %rax,%rax
ffff8000001048dc:	0f 84 74 01 00 00    	je     ffff800000104a56 <lapicinit+0x192>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
ffff8000001048e2:	be 3f 01 00 00       	mov    $0x13f,%esi
ffff8000001048e7:	bf 3c 00 00 00       	mov    $0x3c,%edi
ffff8000001048ec:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff8000001048f3:	80 ff ff 
ffff8000001048f6:	ff d0                	callq  *%rax

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
ffff8000001048f8:	be 0b 00 00 00       	mov    $0xb,%esi
ffff8000001048fd:	bf f8 00 00 00       	mov    $0xf8,%edi
ffff800000104902:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff800000104909:	80 ff ff 
ffff80000010490c:	ff d0                	callq  *%rax
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
ffff80000010490e:	be 20 00 02 00       	mov    $0x20020,%esi
ffff800000104913:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff800000104918:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff80000010491f:	80 ff ff 
ffff800000104922:	ff d0                	callq  *%rax
  lapicw(TICR, 10000000);
ffff800000104924:	be 80 96 98 00       	mov    $0x989680,%esi
ffff800000104929:	bf e0 00 00 00       	mov    $0xe0,%edi
ffff80000010492e:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff800000104935:	80 ff ff 
ffff800000104938:	ff d0                	callq  *%rax

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
ffff80000010493a:	be 00 00 01 00       	mov    $0x10000,%esi
ffff80000010493f:	bf d4 00 00 00       	mov    $0xd4,%edi
ffff800000104944:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff80000010494b:	80 ff ff 
ffff80000010494e:	ff d0                	callq  *%rax
  lapicw(LINT1, MASKED);
ffff800000104950:	be 00 00 01 00       	mov    $0x10000,%esi
ffff800000104955:	bf d8 00 00 00       	mov    $0xd8,%edi
ffff80000010495a:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff800000104961:	80 ff ff 
ffff800000104964:	ff d0                	callq  *%rax

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
ffff800000104966:	48 b8 c0 71 1f 00 00 	movabs $0xffff8000001f71c0,%rax
ffff80000010496d:	80 ff ff 
ffff800000104970:	48 8b 00             	mov    (%rax),%rax
ffff800000104973:	48 83 c0 30          	add    $0x30,%rax
ffff800000104977:	8b 00                	mov    (%rax),%eax
ffff800000104979:	c1 e8 10             	shr    $0x10,%eax
ffff80000010497c:	25 fc 00 00 00       	and    $0xfc,%eax
ffff800000104981:	85 c0                	test   %eax,%eax
ffff800000104983:	74 16                	je     ffff80000010499b <lapicinit+0xd7>
    lapicw(PCINT, MASKED);
ffff800000104985:	be 00 00 01 00       	mov    $0x10000,%esi
ffff80000010498a:	bf d0 00 00 00       	mov    $0xd0,%edi
ffff80000010498f:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff800000104996:	80 ff ff 
ffff800000104999:	ff d0                	callq  *%rax

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
ffff80000010499b:	be 33 00 00 00       	mov    $0x33,%esi
ffff8000001049a0:	bf dc 00 00 00       	mov    $0xdc,%edi
ffff8000001049a5:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff8000001049ac:	80 ff ff 
ffff8000001049af:	ff d0                	callq  *%rax

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
ffff8000001049b1:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001049b6:	bf a0 00 00 00       	mov    $0xa0,%edi
ffff8000001049bb:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff8000001049c2:	80 ff ff 
ffff8000001049c5:	ff d0                	callq  *%rax
  lapicw(ESR, 0);
ffff8000001049c7:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001049cc:	bf a0 00 00 00       	mov    $0xa0,%edi
ffff8000001049d1:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff8000001049d8:	80 ff ff 
ffff8000001049db:	ff d0                	callq  *%rax

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
ffff8000001049dd:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001049e2:	bf 2c 00 00 00       	mov    $0x2c,%edi
ffff8000001049e7:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff8000001049ee:	80 ff ff 
ffff8000001049f1:	ff d0                	callq  *%rax

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
ffff8000001049f3:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001049f8:	bf c4 00 00 00       	mov    $0xc4,%edi
ffff8000001049fd:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff800000104a04:	80 ff ff 
ffff800000104a07:	ff d0                	callq  *%rax
  lapicw(ICRLO, BCAST | INIT | LEVEL);
ffff800000104a09:	be 00 85 08 00       	mov    $0x88500,%esi
ffff800000104a0e:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff800000104a13:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff800000104a1a:	80 ff ff 
ffff800000104a1d:	ff d0                	callq  *%rax
  while(lapic[ICRLO] & DELIVS)
ffff800000104a1f:	90                   	nop
ffff800000104a20:	48 b8 c0 71 1f 00 00 	movabs $0xffff8000001f71c0,%rax
ffff800000104a27:	80 ff ff 
ffff800000104a2a:	48 8b 00             	mov    (%rax),%rax
ffff800000104a2d:	48 05 00 03 00 00    	add    $0x300,%rax
ffff800000104a33:	8b 00                	mov    (%rax),%eax
ffff800000104a35:	25 00 10 00 00       	and    $0x1000,%eax
ffff800000104a3a:	85 c0                	test   %eax,%eax
ffff800000104a3c:	75 e2                	jne    ffff800000104a20 <lapicinit+0x15c>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
ffff800000104a3e:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000104a43:	bf 20 00 00 00       	mov    $0x20,%edi
ffff800000104a48:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff800000104a4f:	80 ff ff 
ffff800000104a52:	ff d0                	callq  *%rax
ffff800000104a54:	eb 01                	jmp    ffff800000104a57 <lapicinit+0x193>
    return;
ffff800000104a56:	90                   	nop
}
ffff800000104a57:	5d                   	pop    %rbp
ffff800000104a58:	c3                   	retq   

ffff800000104a59 <cpunum>:

int
cpunum(void)
{
ffff800000104a59:	f3 0f 1e fa          	endbr64 
ffff800000104a5d:	55                   	push   %rbp
ffff800000104a5e:	48 89 e5             	mov    %rsp,%rbp
ffff800000104a61:	48 83 ec 10          	sub    $0x10,%rsp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
ffff800000104a65:	48 b8 65 48 10 00 00 	movabs $0xffff800000104865,%rax
ffff800000104a6c:	80 ff ff 
ffff800000104a6f:	ff d0                	callq  *%rax
ffff800000104a71:	25 00 02 00 00       	and    $0x200,%eax
ffff800000104a76:	48 85 c0             	test   %rax,%rax
ffff800000104a79:	74 41                	je     ffff800000104abc <cpunum+0x63>
    static int n;
    if(n++ == 0)
ffff800000104a7b:	48 b8 c8 71 1f 00 00 	movabs $0xffff8000001f71c8,%rax
ffff800000104a82:	80 ff ff 
ffff800000104a85:	8b 00                	mov    (%rax),%eax
ffff800000104a87:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000104a8a:	48 b9 c8 71 1f 00 00 	movabs $0xffff8000001f71c8,%rcx
ffff800000104a91:	80 ff ff 
ffff800000104a94:	89 11                	mov    %edx,(%rcx)
ffff800000104a96:	85 c0                	test   %eax,%eax
ffff800000104a98:	75 22                	jne    ffff800000104abc <cpunum+0x63>
      cprintf("cpu called from %x with interrupts enabled\n",
ffff800000104a9a:	48 8b 45 08          	mov    0x8(%rbp),%rax
ffff800000104a9e:	48 89 c6             	mov    %rax,%rsi
ffff800000104aa1:	48 bf c0 c6 10 00 00 	movabs $0xffff80000010c6c0,%rdi
ffff800000104aa8:	80 ff ff 
ffff800000104aab:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000104ab0:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000104ab7:	80 ff ff 
ffff800000104aba:	ff d2                	callq  *%rdx
        __builtin_return_address(0));
  }

  if (!lapic)
ffff800000104abc:	48 b8 c0 71 1f 00 00 	movabs $0xffff8000001f71c0,%rax
ffff800000104ac3:	80 ff ff 
ffff800000104ac6:	48 8b 00             	mov    (%rax),%rax
ffff800000104ac9:	48 85 c0             	test   %rax,%rax
ffff800000104acc:	75 0a                	jne    ffff800000104ad8 <cpunum+0x7f>
    return 0;
ffff800000104ace:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000104ad3:	e9 82 00 00 00       	jmpq   ffff800000104b5a <cpunum+0x101>

  apicid = lapic[ID] >> 24;
ffff800000104ad8:	48 b8 c0 71 1f 00 00 	movabs $0xffff8000001f71c0,%rax
ffff800000104adf:	80 ff ff 
ffff800000104ae2:	48 8b 00             	mov    (%rax),%rax
ffff800000104ae5:	48 83 c0 20          	add    $0x20,%rax
ffff800000104ae9:	8b 00                	mov    (%rax),%eax
ffff800000104aeb:	c1 e8 18             	shr    $0x18,%eax
ffff800000104aee:	89 45 f8             	mov    %eax,-0x8(%rbp)
  for (i = 0; i < ncpu; ++i) {
ffff800000104af1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104af8:	eb 39                	jmp    ffff800000104b33 <cpunum+0xda>
    if (cpus[i].apicid == apicid)
ffff800000104afa:	48 b9 e0 72 1f 00 00 	movabs $0xffff8000001f72e0,%rcx
ffff800000104b01:	80 ff ff 
ffff800000104b04:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104b07:	48 63 d0             	movslq %eax,%rdx
ffff800000104b0a:	48 89 d0             	mov    %rdx,%rax
ffff800000104b0d:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000104b11:	48 01 d0             	add    %rdx,%rax
ffff800000104b14:	48 c1 e0 03          	shl    $0x3,%rax
ffff800000104b18:	48 01 c8             	add    %rcx,%rax
ffff800000104b1b:	48 83 c0 01          	add    $0x1,%rax
ffff800000104b1f:	0f b6 00             	movzbl (%rax),%eax
ffff800000104b22:	0f b6 c0             	movzbl %al,%eax
ffff800000104b25:	39 45 f8             	cmp    %eax,-0x8(%rbp)
ffff800000104b28:	75 05                	jne    ffff800000104b2f <cpunum+0xd6>
      return i;
ffff800000104b2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104b2d:	eb 2b                	jmp    ffff800000104b5a <cpunum+0x101>
  for (i = 0; i < ncpu; ++i) {
ffff800000104b2f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104b33:	48 b8 20 74 1f 00 00 	movabs $0xffff8000001f7420,%rax
ffff800000104b3a:	80 ff ff 
ffff800000104b3d:	8b 00                	mov    (%rax),%eax
ffff800000104b3f:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000104b42:	7c b6                	jl     ffff800000104afa <cpunum+0xa1>
  }
  panic("unknown apicid\n");
ffff800000104b44:	48 bf ec c6 10 00 00 	movabs $0xffff80000010c6ec,%rdi
ffff800000104b4b:	80 ff ff 
ffff800000104b4e:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000104b55:	80 ff ff 
ffff800000104b58:	ff d0                	callq  *%rax
}
ffff800000104b5a:	c9                   	leaveq 
ffff800000104b5b:	c3                   	retq   

ffff800000104b5c <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
ffff800000104b5c:	f3 0f 1e fa          	endbr64 
ffff800000104b60:	55                   	push   %rbp
ffff800000104b61:	48 89 e5             	mov    %rsp,%rbp
  if(lapic)
ffff800000104b64:	48 b8 c0 71 1f 00 00 	movabs $0xffff8000001f71c0,%rax
ffff800000104b6b:	80 ff ff 
ffff800000104b6e:	48 8b 00             	mov    (%rax),%rax
ffff800000104b71:	48 85 c0             	test   %rax,%rax
ffff800000104b74:	74 16                	je     ffff800000104b8c <lapiceoi+0x30>
    lapicw(EOI, 0);
ffff800000104b76:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000104b7b:	bf 2c 00 00 00       	mov    $0x2c,%edi
ffff800000104b80:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff800000104b87:	80 ff ff 
ffff800000104b8a:	ff d0                	callq  *%rax
}
ffff800000104b8c:	90                   	nop
ffff800000104b8d:	5d                   	pop    %rbp
ffff800000104b8e:	c3                   	retq   

ffff800000104b8f <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
ffff800000104b8f:	f3 0f 1e fa          	endbr64 
ffff800000104b93:	55                   	push   %rbp
ffff800000104b94:	48 89 e5             	mov    %rsp,%rbp
ffff800000104b97:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000104b9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
}
ffff800000104b9e:	90                   	nop
ffff800000104b9f:	c9                   	leaveq 
ffff800000104ba0:	c3                   	retq   

ffff800000104ba1 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
ffff800000104ba1:	f3 0f 1e fa          	endbr64 
ffff800000104ba5:	55                   	push   %rbp
ffff800000104ba6:	48 89 e5             	mov    %rsp,%rbp
ffff800000104ba9:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000104bad:	89 f8                	mov    %edi,%eax
ffff800000104baf:	89 75 e8             	mov    %esi,-0x18(%rbp)
ffff800000104bb2:	88 45 ec             	mov    %al,-0x14(%rbp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
ffff800000104bb5:	be 0f 00 00 00       	mov    $0xf,%esi
ffff800000104bba:	bf 70 00 00 00       	mov    $0x70,%edi
ffff800000104bbf:	48 b8 40 48 10 00 00 	movabs $0xffff800000104840,%rax
ffff800000104bc6:	80 ff ff 
ffff800000104bc9:	ff d0                	callq  *%rax
  outb(CMOS_PORT+1, 0x0A);
ffff800000104bcb:	be 0a 00 00 00       	mov    $0xa,%esi
ffff800000104bd0:	bf 71 00 00 00       	mov    $0x71,%edi
ffff800000104bd5:	48 b8 40 48 10 00 00 	movabs $0xffff800000104840,%rax
ffff800000104bdc:	80 ff ff 
ffff800000104bdf:	ff d0                	callq  *%rax
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
ffff800000104be1:	48 b8 67 04 00 00 00 	movabs $0xffff800000000467,%rax
ffff800000104be8:	80 ff ff 
ffff800000104beb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  wrv[0] = 0;
ffff800000104bef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104bf3:	66 c7 00 00 00       	movw   $0x0,(%rax)
  wrv[1] = addr >> 4;
ffff800000104bf8:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104bfb:	c1 e8 04             	shr    $0x4,%eax
ffff800000104bfe:	89 c2                	mov    %eax,%edx
ffff800000104c00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104c04:	48 83 c0 02          	add    $0x2,%rax
ffff800000104c08:	66 89 10             	mov    %dx,(%rax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
ffff800000104c0b:	0f b6 45 ec          	movzbl -0x14(%rbp),%eax
ffff800000104c0f:	c1 e0 18             	shl    $0x18,%eax
ffff800000104c12:	89 c6                	mov    %eax,%esi
ffff800000104c14:	bf c4 00 00 00       	mov    $0xc4,%edi
ffff800000104c19:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff800000104c20:	80 ff ff 
ffff800000104c23:	ff d0                	callq  *%rax
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
ffff800000104c25:	be 00 c5 00 00       	mov    $0xc500,%esi
ffff800000104c2a:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff800000104c2f:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff800000104c36:	80 ff ff 
ffff800000104c39:	ff d0                	callq  *%rax
  microdelay(200);
ffff800000104c3b:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff800000104c40:	48 b8 8f 4b 10 00 00 	movabs $0xffff800000104b8f,%rax
ffff800000104c47:	80 ff ff 
ffff800000104c4a:	ff d0                	callq  *%rax
  lapicw(ICRLO, INIT | LEVEL);
ffff800000104c4c:	be 00 85 00 00       	mov    $0x8500,%esi
ffff800000104c51:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff800000104c56:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff800000104c5d:	80 ff ff 
ffff800000104c60:	ff d0                	callq  *%rax
  microdelay(100);    // should be 10ms, but too slow in Bochs!
ffff800000104c62:	bf 64 00 00 00       	mov    $0x64,%edi
ffff800000104c67:	48 b8 8f 4b 10 00 00 	movabs $0xffff800000104b8f,%rax
ffff800000104c6e:	80 ff ff 
ffff800000104c71:	ff d0                	callq  *%rax
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
ffff800000104c73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104c7a:	eb 4b                	jmp    ffff800000104cc7 <lapicstartap+0x126>
    lapicw(ICRHI, apicid<<24);
ffff800000104c7c:	0f b6 45 ec          	movzbl -0x14(%rbp),%eax
ffff800000104c80:	c1 e0 18             	shl    $0x18,%eax
ffff800000104c83:	89 c6                	mov    %eax,%esi
ffff800000104c85:	bf c4 00 00 00       	mov    $0xc4,%edi
ffff800000104c8a:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff800000104c91:	80 ff ff 
ffff800000104c94:	ff d0                	callq  *%rax
    lapicw(ICRLO, STARTUP | (addr>>12));
ffff800000104c96:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104c99:	c1 e8 0c             	shr    $0xc,%eax
ffff800000104c9c:	80 cc 06             	or     $0x6,%ah
ffff800000104c9f:	89 c6                	mov    %eax,%esi
ffff800000104ca1:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff800000104ca6:	48 b8 7d 48 10 00 00 	movabs $0xffff80000010487d,%rax
ffff800000104cad:	80 ff ff 
ffff800000104cb0:	ff d0                	callq  *%rax
    microdelay(200);
ffff800000104cb2:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff800000104cb7:	48 b8 8f 4b 10 00 00 	movabs $0xffff800000104b8f,%rax
ffff800000104cbe:	80 ff ff 
ffff800000104cc1:	ff d0                	callq  *%rax
  for(i = 0; i < 2; i++){
ffff800000104cc3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104cc7:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
ffff800000104ccb:	7e af                	jle    ffff800000104c7c <lapicstartap+0xdb>
  }
}
ffff800000104ccd:	90                   	nop
ffff800000104cce:	90                   	nop
ffff800000104ccf:	c9                   	leaveq 
ffff800000104cd0:	c3                   	retq   

ffff800000104cd1 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
ffff800000104cd1:	f3 0f 1e fa          	endbr64 
ffff800000104cd5:	55                   	push   %rbp
ffff800000104cd6:	48 89 e5             	mov    %rsp,%rbp
ffff800000104cd9:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000104cdd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  outb(CMOS_PORT,  reg);
ffff800000104ce0:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104ce3:	0f b6 c0             	movzbl %al,%eax
ffff800000104ce6:	89 c6                	mov    %eax,%esi
ffff800000104ce8:	bf 70 00 00 00       	mov    $0x70,%edi
ffff800000104ced:	48 b8 40 48 10 00 00 	movabs $0xffff800000104840,%rax
ffff800000104cf4:	80 ff ff 
ffff800000104cf7:	ff d0                	callq  *%rax
  microdelay(200);
ffff800000104cf9:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff800000104cfe:	48 b8 8f 4b 10 00 00 	movabs $0xffff800000104b8f,%rax
ffff800000104d05:	80 ff ff 
ffff800000104d08:	ff d0                	callq  *%rax

  return inb(CMOS_RETURN);
ffff800000104d0a:	bf 71 00 00 00       	mov    $0x71,%edi
ffff800000104d0f:	48 b8 1e 48 10 00 00 	movabs $0xffff80000010481e,%rax
ffff800000104d16:	80 ff ff 
ffff800000104d19:	ff d0                	callq  *%rax
ffff800000104d1b:	0f b6 c0             	movzbl %al,%eax
}
ffff800000104d1e:	c9                   	leaveq 
ffff800000104d1f:	c3                   	retq   

ffff800000104d20 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
ffff800000104d20:	f3 0f 1e fa          	endbr64 
ffff800000104d24:	55                   	push   %rbp
ffff800000104d25:	48 89 e5             	mov    %rsp,%rbp
ffff800000104d28:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000104d2c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  r->second = cmos_read(SECS);
ffff800000104d30:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000104d35:	48 b8 d1 4c 10 00 00 	movabs $0xffff800000104cd1,%rax
ffff800000104d3c:	80 ff ff 
ffff800000104d3f:	ff d0                	callq  *%rax
ffff800000104d41:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104d45:	89 02                	mov    %eax,(%rdx)
  r->minute = cmos_read(MINS);
ffff800000104d47:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000104d4c:	48 b8 d1 4c 10 00 00 	movabs $0xffff800000104cd1,%rax
ffff800000104d53:	80 ff ff 
ffff800000104d56:	ff d0                	callq  *%rax
ffff800000104d58:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104d5c:	89 42 04             	mov    %eax,0x4(%rdx)
  r->hour   = cmos_read(HOURS);
ffff800000104d5f:	bf 04 00 00 00       	mov    $0x4,%edi
ffff800000104d64:	48 b8 d1 4c 10 00 00 	movabs $0xffff800000104cd1,%rax
ffff800000104d6b:	80 ff ff 
ffff800000104d6e:	ff d0                	callq  *%rax
ffff800000104d70:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104d74:	89 42 08             	mov    %eax,0x8(%rdx)
  r->day    = cmos_read(DAY);
ffff800000104d77:	bf 07 00 00 00       	mov    $0x7,%edi
ffff800000104d7c:	48 b8 d1 4c 10 00 00 	movabs $0xffff800000104cd1,%rax
ffff800000104d83:	80 ff ff 
ffff800000104d86:	ff d0                	callq  *%rax
ffff800000104d88:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104d8c:	89 42 0c             	mov    %eax,0xc(%rdx)
  r->month  = cmos_read(MONTH);
ffff800000104d8f:	bf 08 00 00 00       	mov    $0x8,%edi
ffff800000104d94:	48 b8 d1 4c 10 00 00 	movabs $0xffff800000104cd1,%rax
ffff800000104d9b:	80 ff ff 
ffff800000104d9e:	ff d0                	callq  *%rax
ffff800000104da0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104da4:	89 42 10             	mov    %eax,0x10(%rdx)
  r->year   = cmos_read(YEAR);
ffff800000104da7:	bf 09 00 00 00       	mov    $0x9,%edi
ffff800000104dac:	48 b8 d1 4c 10 00 00 	movabs $0xffff800000104cd1,%rax
ffff800000104db3:	80 ff ff 
ffff800000104db6:	ff d0                	callq  *%rax
ffff800000104db8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104dbc:	89 42 14             	mov    %eax,0x14(%rdx)
}
ffff800000104dbf:	90                   	nop
ffff800000104dc0:	c9                   	leaveq 
ffff800000104dc1:	c3                   	retq   

ffff800000104dc2 <cmostime>:
//PAGEBREAK!

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
ffff800000104dc2:	f3 0f 1e fa          	endbr64 
ffff800000104dc6:	55                   	push   %rbp
ffff800000104dc7:	48 89 e5             	mov    %rsp,%rbp
ffff800000104dca:	48 83 ec 50          	sub    $0x50,%rsp
ffff800000104dce:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
ffff800000104dd2:	bf 0b 00 00 00       	mov    $0xb,%edi
ffff800000104dd7:	48 b8 d1 4c 10 00 00 	movabs $0xffff800000104cd1,%rax
ffff800000104dde:	80 ff ff 
ffff800000104de1:	ff d0                	callq  *%rax
ffff800000104de3:	89 45 fc             	mov    %eax,-0x4(%rbp)

  bcd = (sb & (1 << 2)) == 0;
ffff800000104de6:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104de9:	83 e0 04             	and    $0x4,%eax
ffff800000104dec:	85 c0                	test   %eax,%eax
ffff800000104dee:	0f 94 c0             	sete   %al
ffff800000104df1:	0f b6 c0             	movzbl %al,%eax
ffff800000104df4:	89 45 f8             	mov    %eax,-0x8(%rbp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
ffff800000104df7:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000104dfb:	48 89 c7             	mov    %rax,%rdi
ffff800000104dfe:	48 b8 20 4d 10 00 00 	movabs $0xffff800000104d20,%rax
ffff800000104e05:	80 ff ff 
ffff800000104e08:	ff d0                	callq  *%rax
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
ffff800000104e0a:	bf 0a 00 00 00       	mov    $0xa,%edi
ffff800000104e0f:	48 b8 d1 4c 10 00 00 	movabs $0xffff800000104cd1,%rax
ffff800000104e16:	80 ff ff 
ffff800000104e19:	ff d0                	callq  *%rax
ffff800000104e1b:	25 80 00 00 00       	and    $0x80,%eax
ffff800000104e20:	85 c0                	test   %eax,%eax
ffff800000104e22:	75 38                	jne    ffff800000104e5c <cmostime+0x9a>
        continue;
    fill_rtcdate(&t2);
ffff800000104e24:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
ffff800000104e28:	48 89 c7             	mov    %rax,%rdi
ffff800000104e2b:	48 b8 20 4d 10 00 00 	movabs $0xffff800000104d20,%rax
ffff800000104e32:	80 ff ff 
ffff800000104e35:	ff d0                	callq  *%rax
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
ffff800000104e37:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
ffff800000104e3b:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000104e3f:	ba 18 00 00 00       	mov    $0x18,%edx
ffff800000104e44:	48 89 ce             	mov    %rcx,%rsi
ffff800000104e47:	48 89 c7             	mov    %rax,%rdi
ffff800000104e4a:	48 b8 9d 7c 10 00 00 	movabs $0xffff800000107c9d,%rax
ffff800000104e51:	80 ff ff 
ffff800000104e54:	ff d0                	callq  *%rax
ffff800000104e56:	85 c0                	test   %eax,%eax
ffff800000104e58:	74 05                	je     ffff800000104e5f <cmostime+0x9d>
ffff800000104e5a:	eb 9b                	jmp    ffff800000104df7 <cmostime+0x35>
        continue;
ffff800000104e5c:	90                   	nop
    fill_rtcdate(&t1);
ffff800000104e5d:	eb 98                	jmp    ffff800000104df7 <cmostime+0x35>
      break;
ffff800000104e5f:	90                   	nop
  }

  // convert
  if(bcd) {
ffff800000104e60:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
ffff800000104e64:	0f 84 b4 00 00 00    	je     ffff800000104f1e <cmostime+0x15c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
ffff800000104e6a:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000104e6d:	c1 e8 04             	shr    $0x4,%eax
ffff800000104e70:	89 c2                	mov    %eax,%edx
ffff800000104e72:	89 d0                	mov    %edx,%eax
ffff800000104e74:	c1 e0 02             	shl    $0x2,%eax
ffff800000104e77:	01 d0                	add    %edx,%eax
ffff800000104e79:	01 c0                	add    %eax,%eax
ffff800000104e7b:	89 c2                	mov    %eax,%edx
ffff800000104e7d:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000104e80:	83 e0 0f             	and    $0xf,%eax
ffff800000104e83:	01 d0                	add    %edx,%eax
ffff800000104e85:	89 45 e0             	mov    %eax,-0x20(%rbp)
    CONV(minute);
ffff800000104e88:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000104e8b:	c1 e8 04             	shr    $0x4,%eax
ffff800000104e8e:	89 c2                	mov    %eax,%edx
ffff800000104e90:	89 d0                	mov    %edx,%eax
ffff800000104e92:	c1 e0 02             	shl    $0x2,%eax
ffff800000104e95:	01 d0                	add    %edx,%eax
ffff800000104e97:	01 c0                	add    %eax,%eax
ffff800000104e99:	89 c2                	mov    %eax,%edx
ffff800000104e9b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000104e9e:	83 e0 0f             	and    $0xf,%eax
ffff800000104ea1:	01 d0                	add    %edx,%eax
ffff800000104ea3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    CONV(hour  );
ffff800000104ea6:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104ea9:	c1 e8 04             	shr    $0x4,%eax
ffff800000104eac:	89 c2                	mov    %eax,%edx
ffff800000104eae:	89 d0                	mov    %edx,%eax
ffff800000104eb0:	c1 e0 02             	shl    $0x2,%eax
ffff800000104eb3:	01 d0                	add    %edx,%eax
ffff800000104eb5:	01 c0                	add    %eax,%eax
ffff800000104eb7:	89 c2                	mov    %eax,%edx
ffff800000104eb9:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104ebc:	83 e0 0f             	and    $0xf,%eax
ffff800000104ebf:	01 d0                	add    %edx,%eax
ffff800000104ec1:	89 45 e8             	mov    %eax,-0x18(%rbp)
    CONV(day   );
ffff800000104ec4:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104ec7:	c1 e8 04             	shr    $0x4,%eax
ffff800000104eca:	89 c2                	mov    %eax,%edx
ffff800000104ecc:	89 d0                	mov    %edx,%eax
ffff800000104ece:	c1 e0 02             	shl    $0x2,%eax
ffff800000104ed1:	01 d0                	add    %edx,%eax
ffff800000104ed3:	01 c0                	add    %eax,%eax
ffff800000104ed5:	89 c2                	mov    %eax,%edx
ffff800000104ed7:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104eda:	83 e0 0f             	and    $0xf,%eax
ffff800000104edd:	01 d0                	add    %edx,%eax
ffff800000104edf:	89 45 ec             	mov    %eax,-0x14(%rbp)
    CONV(month );
ffff800000104ee2:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000104ee5:	c1 e8 04             	shr    $0x4,%eax
ffff800000104ee8:	89 c2                	mov    %eax,%edx
ffff800000104eea:	89 d0                	mov    %edx,%eax
ffff800000104eec:	c1 e0 02             	shl    $0x2,%eax
ffff800000104eef:	01 d0                	add    %edx,%eax
ffff800000104ef1:	01 c0                	add    %eax,%eax
ffff800000104ef3:	89 c2                	mov    %eax,%edx
ffff800000104ef5:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000104ef8:	83 e0 0f             	and    $0xf,%eax
ffff800000104efb:	01 d0                	add    %edx,%eax
ffff800000104efd:	89 45 f0             	mov    %eax,-0x10(%rbp)
    CONV(year  );
ffff800000104f00:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000104f03:	c1 e8 04             	shr    $0x4,%eax
ffff800000104f06:	89 c2                	mov    %eax,%edx
ffff800000104f08:	89 d0                	mov    %edx,%eax
ffff800000104f0a:	c1 e0 02             	shl    $0x2,%eax
ffff800000104f0d:	01 d0                	add    %edx,%eax
ffff800000104f0f:	01 c0                	add    %eax,%eax
ffff800000104f11:	89 c2                	mov    %eax,%edx
ffff800000104f13:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000104f16:	83 e0 0f             	and    $0xf,%eax
ffff800000104f19:	01 d0                	add    %edx,%eax
ffff800000104f1b:	89 45 f4             	mov    %eax,-0xc(%rbp)
#undef     CONV
  }

  *r = t1;
ffff800000104f1e:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
ffff800000104f22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000104f26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000104f2a:	48 89 01             	mov    %rax,(%rcx)
ffff800000104f2d:	48 89 51 08          	mov    %rdx,0x8(%rcx)
ffff800000104f31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104f35:	48 89 41 10          	mov    %rax,0x10(%rcx)
  r->year += 2000;
ffff800000104f39:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000104f3d:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000104f40:	8d 90 d0 07 00 00    	lea    0x7d0(%rax),%edx
ffff800000104f46:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000104f4a:	89 50 14             	mov    %edx,0x14(%rax)
}
ffff800000104f4d:	90                   	nop
ffff800000104f4e:	c9                   	leaveq 
ffff800000104f4f:	c3                   	retq   

ffff800000104f50 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
ffff800000104f50:	f3 0f 1e fa          	endbr64 
ffff800000104f54:	55                   	push   %rbp
ffff800000104f55:	48 89 e5             	mov    %rsp,%rbp
ffff800000104f58:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000104f5c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
ffff800000104f5f:	48 be fc c6 10 00 00 	movabs $0xffff80000010c6fc,%rsi
ffff800000104f66:	80 ff ff 
ffff800000104f69:	48 bf e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rdi
ffff800000104f70:	80 ff ff 
ffff800000104f73:	48 b8 24 78 10 00 00 	movabs $0xffff800000107824,%rax
ffff800000104f7a:	80 ff ff 
ffff800000104f7d:	ff d0                	callq  *%rax
  readsb(dev, &sb);
ffff800000104f7f:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffff800000104f83:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000104f86:	48 89 d6             	mov    %rdx,%rsi
ffff800000104f89:	89 c7                	mov    %eax,%edi
ffff800000104f8b:	48 b8 d1 20 10 00 00 	movabs $0xffff8000001020d1,%rax
ffff800000104f92:	80 ff ff 
ffff800000104f95:	ff d0                	callq  *%rax
  log.start = sb.logstart;
ffff800000104f97:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000104f9a:	89 c2                	mov    %eax,%edx
ffff800000104f9c:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000104fa3:	80 ff ff 
ffff800000104fa6:	89 50 68             	mov    %edx,0x68(%rax)
  log.size = sb.nlog;
ffff800000104fa9:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104fac:	89 c2                	mov    %eax,%edx
ffff800000104fae:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000104fb5:	80 ff ff 
ffff800000104fb8:	89 50 6c             	mov    %edx,0x6c(%rax)
  log.dev = dev;
ffff800000104fbb:	48 ba e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rdx
ffff800000104fc2:	80 ff ff 
ffff800000104fc5:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000104fc8:	89 42 78             	mov    %eax,0x78(%rdx)
  recover_from_log();
ffff800000104fcb:	48 b8 6b 52 10 00 00 	movabs $0xffff80000010526b,%rax
ffff800000104fd2:	80 ff ff 
ffff800000104fd5:	ff d0                	callq  *%rax
}
ffff800000104fd7:	90                   	nop
ffff800000104fd8:	c9                   	leaveq 
ffff800000104fd9:	c3                   	retq   

ffff800000104fda <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
ffff800000104fda:	f3 0f 1e fa          	endbr64 
ffff800000104fde:	55                   	push   %rbp
ffff800000104fdf:	48 89 e5             	mov    %rsp,%rbp
ffff800000104fe2:	48 83 ec 20          	sub    $0x20,%rsp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
ffff800000104fe6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104fed:	e9 dc 00 00 00       	jmpq   ffff8000001050ce <install_trans+0xf4>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
ffff800000104ff2:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000104ff9:	80 ff ff 
ffff800000104ffc:	8b 50 68             	mov    0x68(%rax),%edx
ffff800000104fff:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000105002:	01 d0                	add    %edx,%eax
ffff800000105004:	83 c0 01             	add    $0x1,%eax
ffff800000105007:	89 c2                	mov    %eax,%edx
ffff800000105009:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000105010:	80 ff ff 
ffff800000105013:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000105016:	89 d6                	mov    %edx,%esi
ffff800000105018:	89 c7                	mov    %eax,%edi
ffff80000010501a:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000105021:	80 ff ff 
ffff800000105024:	ff d0                	callq  *%rax
ffff800000105026:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
ffff80000010502a:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000105031:	80 ff ff 
ffff800000105034:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000105037:	48 63 d2             	movslq %edx,%rdx
ffff80000010503a:	48 83 c2 1c          	add    $0x1c,%rdx
ffff80000010503e:	8b 44 90 10          	mov    0x10(%rax,%rdx,4),%eax
ffff800000105042:	89 c2                	mov    %eax,%edx
ffff800000105044:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff80000010504b:	80 ff ff 
ffff80000010504e:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000105051:	89 d6                	mov    %edx,%esi
ffff800000105053:	89 c7                	mov    %eax,%edi
ffff800000105055:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff80000010505c:	80 ff ff 
ffff80000010505f:	ff d0                	callq  *%rax
ffff800000105061:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
ffff800000105065:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105069:	48 8d 88 b0 00 00 00 	lea    0xb0(%rax),%rcx
ffff800000105070:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105074:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff80000010507a:	ba 00 02 00 00       	mov    $0x200,%edx
ffff80000010507f:	48 89 ce             	mov    %rcx,%rsi
ffff800000105082:	48 89 c7             	mov    %rax,%rdi
ffff800000105085:	48 b8 10 7d 10 00 00 	movabs $0xffff800000107d10,%rax
ffff80000010508c:	80 ff ff 
ffff80000010508f:	ff d0                	callq  *%rax
    bwrite(dbuf);  // write dst to disk
ffff800000105091:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105095:	48 89 c7             	mov    %rax,%rdi
ffff800000105098:	48 b8 10 04 10 00 00 	movabs $0xffff800000100410,%rax
ffff80000010509f:	80 ff ff 
ffff8000001050a2:	ff d0                	callq  *%rax
    brelse(lbuf);
ffff8000001050a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001050a8:	48 89 c7             	mov    %rax,%rdi
ffff8000001050ab:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff8000001050b2:	80 ff ff 
ffff8000001050b5:	ff d0                	callq  *%rax
    brelse(dbuf);
ffff8000001050b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001050bb:	48 89 c7             	mov    %rax,%rdi
ffff8000001050be:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff8000001050c5:	80 ff ff 
ffff8000001050c8:	ff d0                	callq  *%rax
  for (tail = 0; tail < log.lh.n; tail++) {
ffff8000001050ca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001050ce:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff8000001050d5:	80 ff ff 
ffff8000001050d8:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff8000001050db:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff8000001050de:	0f 8c 0e ff ff ff    	jl     ffff800000104ff2 <install_trans+0x18>
  }
}
ffff8000001050e4:	90                   	nop
ffff8000001050e5:	90                   	nop
ffff8000001050e6:	c9                   	leaveq 
ffff8000001050e7:	c3                   	retq   

ffff8000001050e8 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
ffff8000001050e8:	f3 0f 1e fa          	endbr64 
ffff8000001050ec:	55                   	push   %rbp
ffff8000001050ed:	48 89 e5             	mov    %rsp,%rbp
ffff8000001050f0:	48 83 ec 20          	sub    $0x20,%rsp
  struct buf *buf = bread(log.dev, log.start);
ffff8000001050f4:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff8000001050fb:	80 ff ff 
ffff8000001050fe:	8b 40 68             	mov    0x68(%rax),%eax
ffff800000105101:	89 c2                	mov    %eax,%edx
ffff800000105103:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff80000010510a:	80 ff ff 
ffff80000010510d:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000105110:	89 d6                	mov    %edx,%esi
ffff800000105112:	89 c7                	mov    %eax,%edi
ffff800000105114:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff80000010511b:	80 ff ff 
ffff80000010511e:	ff d0                	callq  *%rax
ffff800000105120:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  struct logheader *lh = (struct logheader *) (buf->data);
ffff800000105124:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105128:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff80000010512e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  int i;
  log.lh.n = lh->n;
ffff800000105132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105136:	8b 00                	mov    (%rax),%eax
ffff800000105138:	48 ba e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rdx
ffff80000010513f:	80 ff ff 
ffff800000105142:	89 42 7c             	mov    %eax,0x7c(%rdx)
  for (i = 0; i < log.lh.n; i++) {
ffff800000105145:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010514c:	eb 2a                	jmp    ffff800000105178 <read_head+0x90>
    log.lh.block[i] = lh->block[i];
ffff80000010514e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105152:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000105155:	48 63 d2             	movslq %edx,%rdx
ffff800000105158:	8b 44 90 04          	mov    0x4(%rax,%rdx,4),%eax
ffff80000010515c:	48 ba e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rdx
ffff800000105163:	80 ff ff 
ffff800000105166:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffff800000105169:	48 63 c9             	movslq %ecx,%rcx
ffff80000010516c:	48 83 c1 1c          	add    $0x1c,%rcx
ffff800000105170:	89 44 8a 10          	mov    %eax,0x10(%rdx,%rcx,4)
  for (i = 0; i < log.lh.n; i++) {
ffff800000105174:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000105178:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff80000010517f:	80 ff ff 
ffff800000105182:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000105185:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000105188:	7c c4                	jl     ffff80000010514e <read_head+0x66>
  }
  brelse(buf);
ffff80000010518a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010518e:	48 89 c7             	mov    %rax,%rdi
ffff800000105191:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000105198:	80 ff ff 
ffff80000010519b:	ff d0                	callq  *%rax
}
ffff80000010519d:	90                   	nop
ffff80000010519e:	c9                   	leaveq 
ffff80000010519f:	c3                   	retq   

ffff8000001051a0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
ffff8000001051a0:	f3 0f 1e fa          	endbr64 
ffff8000001051a4:	55                   	push   %rbp
ffff8000001051a5:	48 89 e5             	mov    %rsp,%rbp
ffff8000001051a8:	48 83 ec 20          	sub    $0x20,%rsp
  struct buf *buf = bread(log.dev, log.start);
ffff8000001051ac:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff8000001051b3:	80 ff ff 
ffff8000001051b6:	8b 40 68             	mov    0x68(%rax),%eax
ffff8000001051b9:	89 c2                	mov    %eax,%edx
ffff8000001051bb:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff8000001051c2:	80 ff ff 
ffff8000001051c5:	8b 40 78             	mov    0x78(%rax),%eax
ffff8000001051c8:	89 d6                	mov    %edx,%esi
ffff8000001051ca:	89 c7                	mov    %eax,%edi
ffff8000001051cc:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff8000001051d3:	80 ff ff 
ffff8000001051d6:	ff d0                	callq  *%rax
ffff8000001051d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  struct logheader *hb = (struct logheader *) (buf->data);
ffff8000001051dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001051e0:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff8000001051e6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  int i;
  hb->n = log.lh.n;
ffff8000001051ea:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff8000001051f1:	80 ff ff 
ffff8000001051f4:	8b 50 7c             	mov    0x7c(%rax),%edx
ffff8000001051f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001051fb:	89 10                	mov    %edx,(%rax)
  for (i = 0; i < log.lh.n; i++) {
ffff8000001051fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000105204:	eb 2a                	jmp    ffff800000105230 <write_head+0x90>
    hb->block[i] = log.lh.block[i];
ffff800000105206:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff80000010520d:	80 ff ff 
ffff800000105210:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000105213:	48 63 d2             	movslq %edx,%rdx
ffff800000105216:	48 83 c2 1c          	add    $0x1c,%rdx
ffff80000010521a:	8b 4c 90 10          	mov    0x10(%rax,%rdx,4),%ecx
ffff80000010521e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105222:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000105225:	48 63 d2             	movslq %edx,%rdx
ffff800000105228:	89 4c 90 04          	mov    %ecx,0x4(%rax,%rdx,4)
  for (i = 0; i < log.lh.n; i++) {
ffff80000010522c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000105230:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000105237:	80 ff ff 
ffff80000010523a:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff80000010523d:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000105240:	7c c4                	jl     ffff800000105206 <write_head+0x66>
  }
  bwrite(buf);
ffff800000105242:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105246:	48 89 c7             	mov    %rax,%rdi
ffff800000105249:	48 b8 10 04 10 00 00 	movabs $0xffff800000100410,%rax
ffff800000105250:	80 ff ff 
ffff800000105253:	ff d0                	callq  *%rax
  brelse(buf);
ffff800000105255:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105259:	48 89 c7             	mov    %rax,%rdi
ffff80000010525c:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000105263:	80 ff ff 
ffff800000105266:	ff d0                	callq  *%rax
}
ffff800000105268:	90                   	nop
ffff800000105269:	c9                   	leaveq 
ffff80000010526a:	c3                   	retq   

ffff80000010526b <recover_from_log>:

static void
recover_from_log(void)
{
ffff80000010526b:	f3 0f 1e fa          	endbr64 
ffff80000010526f:	55                   	push   %rbp
ffff800000105270:	48 89 e5             	mov    %rsp,%rbp
  read_head();
ffff800000105273:	48 b8 e8 50 10 00 00 	movabs $0xffff8000001050e8,%rax
ffff80000010527a:	80 ff ff 
ffff80000010527d:	ff d0                	callq  *%rax
  install_trans(); // if committed, copy from log to disk
ffff80000010527f:	48 b8 da 4f 10 00 00 	movabs $0xffff800000104fda,%rax
ffff800000105286:	80 ff ff 
ffff800000105289:	ff d0                	callq  *%rax
  log.lh.n = 0;
ffff80000010528b:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000105292:	80 ff ff 
ffff800000105295:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%rax)
  write_head(); // clear the log
ffff80000010529c:	48 b8 a0 51 10 00 00 	movabs $0xffff8000001051a0,%rax
ffff8000001052a3:	80 ff ff 
ffff8000001052a6:	ff d0                	callq  *%rax
}
ffff8000001052a8:	90                   	nop
ffff8000001052a9:	5d                   	pop    %rbp
ffff8000001052aa:	c3                   	retq   

ffff8000001052ab <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
ffff8000001052ab:	f3 0f 1e fa          	endbr64 
ffff8000001052af:	55                   	push   %rbp
ffff8000001052b0:	48 89 e5             	mov    %rsp,%rbp
  acquire(&log.lock);
ffff8000001052b3:	48 bf e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rdi
ffff8000001052ba:	80 ff ff 
ffff8000001052bd:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff8000001052c4:	80 ff ff 
ffff8000001052c7:	ff d0                	callq  *%rax
  while(1){
    if(log.committing){
ffff8000001052c9:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff8000001052d0:	80 ff ff 
ffff8000001052d3:	8b 40 74             	mov    0x74(%rax),%eax
ffff8000001052d6:	85 c0                	test   %eax,%eax
ffff8000001052d8:	74 22                	je     ffff8000001052fc <begin_op+0x51>
      sleep(&log, &log.lock);
ffff8000001052da:	48 be e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rsi
ffff8000001052e1:	80 ff ff 
ffff8000001052e4:	48 bf e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rdi
ffff8000001052eb:	80 ff ff 
ffff8000001052ee:	48 b8 47 72 10 00 00 	movabs $0xffff800000107247,%rax
ffff8000001052f5:	80 ff ff 
ffff8000001052f8:	ff d0                	callq  *%rax
ffff8000001052fa:	eb cd                	jmp    ffff8000001052c9 <begin_op+0x1e>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
ffff8000001052fc:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000105303:	80 ff ff 
ffff800000105306:	8b 48 7c             	mov    0x7c(%rax),%ecx
ffff800000105309:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000105310:	80 ff ff 
ffff800000105313:	8b 40 70             	mov    0x70(%rax),%eax
ffff800000105316:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000105319:	89 d0                	mov    %edx,%eax
ffff80000010531b:	c1 e0 02             	shl    $0x2,%eax
ffff80000010531e:	01 d0                	add    %edx,%eax
ffff800000105320:	01 c0                	add    %eax,%eax
ffff800000105322:	01 c8                	add    %ecx,%eax
ffff800000105324:	83 f8 1e             	cmp    $0x1e,%eax
ffff800000105327:	7e 25                	jle    ffff80000010534e <begin_op+0xa3>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
ffff800000105329:	48 be e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rsi
ffff800000105330:	80 ff ff 
ffff800000105333:	48 bf e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rdi
ffff80000010533a:	80 ff ff 
ffff80000010533d:	48 b8 47 72 10 00 00 	movabs $0xffff800000107247,%rax
ffff800000105344:	80 ff ff 
ffff800000105347:	ff d0                	callq  *%rax
ffff800000105349:	e9 7b ff ff ff       	jmpq   ffff8000001052c9 <begin_op+0x1e>
    } else {
      log.outstanding += 1;
ffff80000010534e:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000105355:	80 ff ff 
ffff800000105358:	8b 40 70             	mov    0x70(%rax),%eax
ffff80000010535b:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010535e:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000105365:	80 ff ff 
ffff800000105368:	89 50 70             	mov    %edx,0x70(%rax)
      release(&log.lock);
ffff80000010536b:	48 bf e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rdi
ffff800000105372:	80 ff ff 
ffff800000105375:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff80000010537c:	80 ff ff 
ffff80000010537f:	ff d0                	callq  *%rax
      break;
ffff800000105381:	90                   	nop
    }
  }
}
ffff800000105382:	90                   	nop
ffff800000105383:	5d                   	pop    %rbp
ffff800000105384:	c3                   	retq   

ffff800000105385 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
ffff800000105385:	f3 0f 1e fa          	endbr64 
ffff800000105389:	55                   	push   %rbp
ffff80000010538a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010538d:	48 83 ec 10          	sub    $0x10,%rsp
  int do_commit = 0;
ffff800000105391:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

  acquire(&log.lock);
ffff800000105398:	48 bf e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rdi
ffff80000010539f:	80 ff ff 
ffff8000001053a2:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff8000001053a9:	80 ff ff 
ffff8000001053ac:	ff d0                	callq  *%rax
  log.outstanding -= 1;
ffff8000001053ae:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff8000001053b5:	80 ff ff 
ffff8000001053b8:	8b 40 70             	mov    0x70(%rax),%eax
ffff8000001053bb:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff8000001053be:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff8000001053c5:	80 ff ff 
ffff8000001053c8:	89 50 70             	mov    %edx,0x70(%rax)
  if(log.committing)
ffff8000001053cb:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff8000001053d2:	80 ff ff 
ffff8000001053d5:	8b 40 74             	mov    0x74(%rax),%eax
ffff8000001053d8:	85 c0                	test   %eax,%eax
ffff8000001053da:	74 16                	je     ffff8000001053f2 <end_op+0x6d>
    panic("log.committing");
ffff8000001053dc:	48 bf 00 c7 10 00 00 	movabs $0xffff80000010c700,%rdi
ffff8000001053e3:	80 ff ff 
ffff8000001053e6:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001053ed:	80 ff ff 
ffff8000001053f0:	ff d0                	callq  *%rax
  if(log.outstanding == 0){
ffff8000001053f2:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff8000001053f9:	80 ff ff 
ffff8000001053fc:	8b 40 70             	mov    0x70(%rax),%eax
ffff8000001053ff:	85 c0                	test   %eax,%eax
ffff800000105401:	75 1a                	jne    ffff80000010541d <end_op+0x98>
    do_commit = 1;
ffff800000105403:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    log.committing = 1;
ffff80000010540a:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000105411:	80 ff ff 
ffff800000105414:	c7 40 74 01 00 00 00 	movl   $0x1,0x74(%rax)
ffff80000010541b:	eb 16                	jmp    ffff800000105433 <end_op+0xae>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
ffff80000010541d:	48 bf e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rdi
ffff800000105424:	80 ff ff 
ffff800000105427:	48 b8 b8 73 10 00 00 	movabs $0xffff8000001073b8,%rax
ffff80000010542e:	80 ff ff 
ffff800000105431:	ff d0                	callq  *%rax
  }
  release(&log.lock);
ffff800000105433:	48 bf e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rdi
ffff80000010543a:	80 ff ff 
ffff80000010543d:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000105444:	80 ff ff 
ffff800000105447:	ff d0                	callq  *%rax

  if(do_commit){
ffff800000105449:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff80000010544d:	74 64                	je     ffff8000001054b3 <end_op+0x12e>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
ffff80000010544f:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105454:	48 ba c4 55 10 00 00 	movabs $0xffff8000001055c4,%rdx
ffff80000010545b:	80 ff ff 
ffff80000010545e:	ff d2                	callq  *%rdx
    acquire(&log.lock);
ffff800000105460:	48 bf e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rdi
ffff800000105467:	80 ff ff 
ffff80000010546a:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000105471:	80 ff ff 
ffff800000105474:	ff d0                	callq  *%rax
    log.committing = 0;
ffff800000105476:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff80000010547d:	80 ff ff 
ffff800000105480:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%rax)
    wakeup(&log);
ffff800000105487:	48 bf e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rdi
ffff80000010548e:	80 ff ff 
ffff800000105491:	48 b8 b8 73 10 00 00 	movabs $0xffff8000001073b8,%rax
ffff800000105498:	80 ff ff 
ffff80000010549b:	ff d0                	callq  *%rax
    release(&log.lock);
ffff80000010549d:	48 bf e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rdi
ffff8000001054a4:	80 ff ff 
ffff8000001054a7:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001054ae:	80 ff ff 
ffff8000001054b1:	ff d0                	callq  *%rax
  }
}
ffff8000001054b3:	90                   	nop
ffff8000001054b4:	c9                   	leaveq 
ffff8000001054b5:	c3                   	retq   

ffff8000001054b6 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
ffff8000001054b6:	f3 0f 1e fa          	endbr64 
ffff8000001054ba:	55                   	push   %rbp
ffff8000001054bb:	48 89 e5             	mov    %rsp,%rbp
ffff8000001054be:	48 83 ec 20          	sub    $0x20,%rsp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
ffff8000001054c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001054c9:	e9 dc 00 00 00       	jmpq   ffff8000001055aa <write_log+0xf4>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
ffff8000001054ce:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff8000001054d5:	80 ff ff 
ffff8000001054d8:	8b 50 68             	mov    0x68(%rax),%edx
ffff8000001054db:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001054de:	01 d0                	add    %edx,%eax
ffff8000001054e0:	83 c0 01             	add    $0x1,%eax
ffff8000001054e3:	89 c2                	mov    %eax,%edx
ffff8000001054e5:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff8000001054ec:	80 ff ff 
ffff8000001054ef:	8b 40 78             	mov    0x78(%rax),%eax
ffff8000001054f2:	89 d6                	mov    %edx,%esi
ffff8000001054f4:	89 c7                	mov    %eax,%edi
ffff8000001054f6:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff8000001054fd:	80 ff ff 
ffff800000105500:	ff d0                	callq  *%rax
ffff800000105502:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
ffff800000105506:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff80000010550d:	80 ff ff 
ffff800000105510:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000105513:	48 63 d2             	movslq %edx,%rdx
ffff800000105516:	48 83 c2 1c          	add    $0x1c,%rdx
ffff80000010551a:	8b 44 90 10          	mov    0x10(%rax,%rdx,4),%eax
ffff80000010551e:	89 c2                	mov    %eax,%edx
ffff800000105520:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000105527:	80 ff ff 
ffff80000010552a:	8b 40 78             	mov    0x78(%rax),%eax
ffff80000010552d:	89 d6                	mov    %edx,%esi
ffff80000010552f:	89 c7                	mov    %eax,%edi
ffff800000105531:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000105538:	80 ff ff 
ffff80000010553b:	ff d0                	callq  *%rax
ffff80000010553d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    memmove(to->data, from->data, BSIZE);
ffff800000105541:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105545:	48 8d 88 b0 00 00 00 	lea    0xb0(%rax),%rcx
ffff80000010554c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105550:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000105556:	ba 00 02 00 00       	mov    $0x200,%edx
ffff80000010555b:	48 89 ce             	mov    %rcx,%rsi
ffff80000010555e:	48 89 c7             	mov    %rax,%rdi
ffff800000105561:	48 b8 10 7d 10 00 00 	movabs $0xffff800000107d10,%rax
ffff800000105568:	80 ff ff 
ffff80000010556b:	ff d0                	callq  *%rax
    bwrite(to);  // write the log
ffff80000010556d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105571:	48 89 c7             	mov    %rax,%rdi
ffff800000105574:	48 b8 10 04 10 00 00 	movabs $0xffff800000100410,%rax
ffff80000010557b:	80 ff ff 
ffff80000010557e:	ff d0                	callq  *%rax
    brelse(from);
ffff800000105580:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105584:	48 89 c7             	mov    %rax,%rdi
ffff800000105587:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff80000010558e:	80 ff ff 
ffff800000105591:	ff d0                	callq  *%rax
    brelse(to);
ffff800000105593:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105597:	48 89 c7             	mov    %rax,%rdi
ffff80000010559a:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff8000001055a1:	80 ff ff 
ffff8000001055a4:	ff d0                	callq  *%rax
  for (tail = 0; tail < log.lh.n; tail++) {
ffff8000001055a6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001055aa:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff8000001055b1:	80 ff ff 
ffff8000001055b4:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff8000001055b7:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff8000001055ba:	0f 8c 0e ff ff ff    	jl     ffff8000001054ce <write_log+0x18>
  }
}
ffff8000001055c0:	90                   	nop
ffff8000001055c1:	90                   	nop
ffff8000001055c2:	c9                   	leaveq 
ffff8000001055c3:	c3                   	retq   

ffff8000001055c4 <commit>:

static void
commit()
{
ffff8000001055c4:	f3 0f 1e fa          	endbr64 
ffff8000001055c8:	55                   	push   %rbp
ffff8000001055c9:	48 89 e5             	mov    %rsp,%rbp
  if (log.lh.n > 0) {
ffff8000001055cc:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff8000001055d3:	80 ff ff 
ffff8000001055d6:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff8000001055d9:	85 c0                	test   %eax,%eax
ffff8000001055db:	7e 41                	jle    ffff80000010561e <commit+0x5a>
    write_log();     // Write modified blocks from cache to log
ffff8000001055dd:	48 b8 b6 54 10 00 00 	movabs $0xffff8000001054b6,%rax
ffff8000001055e4:	80 ff ff 
ffff8000001055e7:	ff d0                	callq  *%rax
    write_head();    // Write header to disk -- the real commit
ffff8000001055e9:	48 b8 a0 51 10 00 00 	movabs $0xffff8000001051a0,%rax
ffff8000001055f0:	80 ff ff 
ffff8000001055f3:	ff d0                	callq  *%rax
    install_trans(); // Now install writes to home locations
ffff8000001055f5:	48 b8 da 4f 10 00 00 	movabs $0xffff800000104fda,%rax
ffff8000001055fc:	80 ff ff 
ffff8000001055ff:	ff d0                	callq  *%rax
    log.lh.n = 0;
ffff800000105601:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000105608:	80 ff ff 
ffff80000010560b:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%rax)
    write_head();    // Erase the transaction from the log
ffff800000105612:	48 b8 a0 51 10 00 00 	movabs $0xffff8000001051a0,%rax
ffff800000105619:	80 ff ff 
ffff80000010561c:	ff d0                	callq  *%rax
  }
}
ffff80000010561e:	90                   	nop
ffff80000010561f:	5d                   	pop    %rbp
ffff800000105620:	c3                   	retq   

ffff800000105621 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
ffff800000105621:	f3 0f 1e fa          	endbr64 
ffff800000105625:	55                   	push   %rbp
ffff800000105626:	48 89 e5             	mov    %rsp,%rbp
ffff800000105629:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010562d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
ffff800000105631:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000105638:	80 ff ff 
ffff80000010563b:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff80000010563e:	83 f8 1d             	cmp    $0x1d,%eax
ffff800000105641:	7f 21                	jg     ffff800000105664 <log_write+0x43>
ffff800000105643:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff80000010564a:	80 ff ff 
ffff80000010564d:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000105650:	48 ba e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rdx
ffff800000105657:	80 ff ff 
ffff80000010565a:	8b 52 6c             	mov    0x6c(%rdx),%edx
ffff80000010565d:	83 ea 01             	sub    $0x1,%edx
ffff800000105660:	39 d0                	cmp    %edx,%eax
ffff800000105662:	7c 16                	jl     ffff80000010567a <log_write+0x59>
    panic("too big a transaction");
ffff800000105664:	48 bf 0f c7 10 00 00 	movabs $0xffff80000010c70f,%rdi
ffff80000010566b:	80 ff ff 
ffff80000010566e:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000105675:	80 ff ff 
ffff800000105678:	ff d0                	callq  *%rax
  if (log.outstanding < 1)
ffff80000010567a:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000105681:	80 ff ff 
ffff800000105684:	8b 40 70             	mov    0x70(%rax),%eax
ffff800000105687:	85 c0                	test   %eax,%eax
ffff800000105689:	7f 16                	jg     ffff8000001056a1 <log_write+0x80>
    panic("log_write outside of trans");
ffff80000010568b:	48 bf 25 c7 10 00 00 	movabs $0xffff80000010c725,%rdi
ffff800000105692:	80 ff ff 
ffff800000105695:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010569c:	80 ff ff 
ffff80000010569f:	ff d0                	callq  *%rax

  acquire(&log.lock);
ffff8000001056a1:	48 bf e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rdi
ffff8000001056a8:	80 ff ff 
ffff8000001056ab:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff8000001056b2:	80 ff ff 
ffff8000001056b5:	ff d0                	callq  *%rax
  for (i = 0; i < log.lh.n; i++) {
ffff8000001056b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001056be:	eb 29                	jmp    ffff8000001056e9 <log_write+0xc8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
ffff8000001056c0:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff8000001056c7:	80 ff ff 
ffff8000001056ca:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001056cd:	48 63 d2             	movslq %edx,%rdx
ffff8000001056d0:	48 83 c2 1c          	add    $0x1c,%rdx
ffff8000001056d4:	8b 44 90 10          	mov    0x10(%rax,%rdx,4),%eax
ffff8000001056d8:	89 c2                	mov    %eax,%edx
ffff8000001056da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001056de:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001056e1:	39 c2                	cmp    %eax,%edx
ffff8000001056e3:	74 18                	je     ffff8000001056fd <log_write+0xdc>
  for (i = 0; i < log.lh.n; i++) {
ffff8000001056e5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001056e9:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff8000001056f0:	80 ff ff 
ffff8000001056f3:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff8000001056f6:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff8000001056f9:	7c c5                	jl     ffff8000001056c0 <log_write+0x9f>
ffff8000001056fb:	eb 01                	jmp    ffff8000001056fe <log_write+0xdd>
      break;
ffff8000001056fd:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
ffff8000001056fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105702:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000105705:	89 c1                	mov    %eax,%ecx
ffff800000105707:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff80000010570e:	80 ff ff 
ffff800000105711:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000105714:	48 63 d2             	movslq %edx,%rdx
ffff800000105717:	48 83 c2 1c          	add    $0x1c,%rdx
ffff80000010571b:	89 4c 90 10          	mov    %ecx,0x10(%rax,%rdx,4)
  if (i == log.lh.n)
ffff80000010571f:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000105726:	80 ff ff 
ffff800000105729:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff80000010572c:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff80000010572f:	75 1d                	jne    ffff80000010574e <log_write+0x12d>
    log.lh.n++;
ffff800000105731:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000105738:	80 ff ff 
ffff80000010573b:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff80000010573e:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000105741:	48 b8 e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rax
ffff800000105748:	80 ff ff 
ffff80000010574b:	89 50 7c             	mov    %edx,0x7c(%rax)
  b->flags |= B_DIRTY; // prevent eviction
ffff80000010574e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105752:	8b 00                	mov    (%rax),%eax
ffff800000105754:	83 c8 04             	or     $0x4,%eax
ffff800000105757:	89 c2                	mov    %eax,%edx
ffff800000105759:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010575d:	89 10                	mov    %edx,(%rax)
  release(&log.lock);
ffff80000010575f:	48 bf e0 71 1f 00 00 	movabs $0xffff8000001f71e0,%rdi
ffff800000105766:	80 ff ff 
ffff800000105769:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000105770:	80 ff ff 
ffff800000105773:	ff d0                	callq  *%rax
}
ffff800000105775:	90                   	nop
ffff800000105776:	c9                   	leaveq 
ffff800000105777:	c3                   	retq   

ffff800000105778 <v2p>:
#define KERNBASE 0xFFFF800000000000 // First kernel virtual address

#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__
static inline addr_t v2p(void *a) {
ffff800000105778:	f3 0f 1e fa          	endbr64 
ffff80000010577c:	55                   	push   %rbp
ffff80000010577d:	48 89 e5             	mov    %rsp,%rbp
ffff800000105780:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000105784:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  return ((addr_t) (a)) - ((addr_t)KERNBASE);
ffff800000105788:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010578c:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff800000105793:	80 00 00 
ffff800000105796:	48 01 d0             	add    %rdx,%rax
}
ffff800000105799:	c9                   	leaveq 
ffff80000010579a:	c3                   	retq   

ffff80000010579b <xchg>:

static inline uint
xchg(volatile uint *addr, addr_t newval)
{
ffff80000010579b:	f3 0f 1e fa          	endbr64 
ffff80000010579f:	55                   	push   %rbp
ffff8000001057a0:	48 89 e5             	mov    %rsp,%rbp
ffff8000001057a3:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001057a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001057ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
ffff8000001057af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001057b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001057b7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff8000001057bb:	f0 87 02             	lock xchg %eax,(%rdx)
ffff8000001057be:	89 45 fc             	mov    %eax,-0x4(%rbp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
ffff8000001057c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff8000001057c4:	c9                   	leaveq 
ffff8000001057c5:	c3                   	retq   

ffff8000001057c6 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
ffff8000001057c6:	f3 0f 1e fa          	endbr64 
ffff8000001057ca:	55                   	push   %rbp
ffff8000001057cb:	48 89 e5             	mov    %rsp,%rbp
  uartearlyinit();
ffff8000001057ce:	48 b8 fd 9f 10 00 00 	movabs $0xffff800000109ffd,%rax
ffff8000001057d5:	80 ff ff 
ffff8000001057d8:	ff d0                	callq  *%rax
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
ffff8000001057da:	48 be 00 00 40 00 00 	movabs $0xffff800000400000,%rsi
ffff8000001057e1:	80 ff ff 
ffff8000001057e4:	48 bf 00 b0 1f 00 00 	movabs $0xffff8000001fb000,%rdi
ffff8000001057eb:	80 ff ff 
ffff8000001057ee:	48 b8 3d 40 10 00 00 	movabs $0xffff80000010403d,%rax
ffff8000001057f5:	80 ff ff 
ffff8000001057f8:	ff d0                	callq  *%rax
  kvmalloc();      // kernel page table
ffff8000001057fa:	48 b8 af b2 10 00 00 	movabs $0xffff80000010b2af,%rax
ffff800000105801:	80 ff ff 
ffff800000105804:	ff d0                	callq  *%rax
  mpinit();        // detect other processors
ffff800000105806:	48 b8 e9 5d 10 00 00 	movabs $0xffff800000105de9,%rax
ffff80000010580d:	80 ff ff 
ffff800000105810:	ff d0                	callq  *%rax
  lapicinit();     // interrupt controller
ffff800000105812:	48 b8 c4 48 10 00 00 	movabs $0xffff8000001048c4,%rax
ffff800000105819:	80 ff ff 
ffff80000010581c:	ff d0                	callq  *%rax
  tvinit();        // trap vectors
ffff80000010581e:	48 b8 38 9b 10 00 00 	movabs $0xffff800000109b38,%rax
ffff800000105825:	80 ff ff 
ffff800000105828:	ff d0                	callq  *%rax
  seginit();       // segment descriptors
ffff80000010582a:	48 b8 ec ad 10 00 00 	movabs $0xffff80000010adec,%rax
ffff800000105831:	80 ff ff 
ffff800000105834:	ff d0                	callq  *%rax
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
ffff800000105836:	48 b8 59 4a 10 00 00 	movabs $0xffff800000104a59,%rax
ffff80000010583d:	80 ff ff 
ffff800000105840:	ff d0                	callq  *%rax
ffff800000105842:	89 c6                	mov    %eax,%esi
ffff800000105844:	48 bf 40 c7 10 00 00 	movabs $0xffff80000010c740,%rdi
ffff80000010584b:	80 ff ff 
ffff80000010584e:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105853:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff80000010585a:	80 ff ff 
ffff80000010585d:	ff d2                	callq  *%rdx
  ioapicinit();    // another interrupt controller
ffff80000010585f:	48 b8 03 3f 10 00 00 	movabs $0xffff800000103f03,%rax
ffff800000105866:	80 ff ff 
ffff800000105869:	ff d0                	callq  *%rax
  consoleinit();   // console hardware
ffff80000010586b:	48 b8 9b 14 10 00 00 	movabs $0xffff80000010149b,%rax
ffff800000105872:	80 ff ff 
ffff800000105875:	ff d0                	callq  *%rax
  uartinit();      // serial port
ffff800000105877:	48 b8 05 a1 10 00 00 	movabs $0xffff80000010a105,%rax
ffff80000010587e:	80 ff ff 
ffff800000105881:	ff d0                	callq  *%rax
  pinit();         // process table
ffff800000105883:	48 b8 3d 65 10 00 00 	movabs $0xffff80000010653d,%rax
ffff80000010588a:	80 ff ff 
ffff80000010588d:	ff d0                	callq  *%rax
  binit();         // buffer cache
ffff80000010588f:	48 b8 1a 01 10 00 00 	movabs $0xffff80000010011a,%rax
ffff800000105896:	80 ff ff 
ffff800000105899:	ff d0                	callq  *%rax
  fileinit();      // file table
ffff80000010589b:	48 b8 59 1b 10 00 00 	movabs $0xffff800000101b59,%rax
ffff8000001058a2:	80 ff ff 
ffff8000001058a5:	ff d0                	callq  *%rax
  ideinit();       // disk
ffff8000001058a7:	48 b8 66 39 10 00 00 	movabs $0xffff800000103966,%rax
ffff8000001058ae:	80 ff ff 
ffff8000001058b1:	ff d0                	callq  *%rax
  startothers();   // start other processors
ffff8000001058b3:	48 b8 a7 59 10 00 00 	movabs $0xffff8000001059a7,%rax
ffff8000001058ba:	80 ff ff 
ffff8000001058bd:	ff d0                	callq  *%rax
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
ffff8000001058bf:	48 be 00 00 00 0e 00 	movabs $0xffff80000e000000,%rsi
ffff8000001058c6:	80 ff ff 
ffff8000001058c9:	48 bf 00 00 40 00 00 	movabs $0xffff800000400000,%rdi
ffff8000001058d0:	80 ff ff 
ffff8000001058d3:	48 b8 d1 40 10 00 00 	movabs $0xffff8000001040d1,%rax
ffff8000001058da:	80 ff ff 
ffff8000001058dd:	ff d0                	callq  *%rax
  userinit();      // first user process
ffff8000001058df:	48 b8 e5 66 10 00 00 	movabs $0xffff8000001066e5,%rax
ffff8000001058e6:	80 ff ff 
ffff8000001058e9:	ff d0                	callq  *%rax
  mpmain();        // finish this processor's setup
ffff8000001058eb:	48 b8 2f 59 10 00 00 	movabs $0xffff80000010592f,%rax
ffff8000001058f2:	80 ff ff 
ffff8000001058f5:	ff d0                	callq  *%rax

ffff8000001058f7 <mpenter>:
}

// Other CPUs jump here from entryother.S.
void
mpenter(void)
{
ffff8000001058f7:	f3 0f 1e fa          	endbr64 
ffff8000001058fb:	55                   	push   %rbp
ffff8000001058fc:	48 89 e5             	mov    %rsp,%rbp
  switchkvm();
ffff8000001058ff:	48 b8 b9 b6 10 00 00 	movabs $0xffff80000010b6b9,%rax
ffff800000105906:	80 ff ff 
ffff800000105909:	ff d0                	callq  *%rax
  seginit();
ffff80000010590b:	48 b8 ec ad 10 00 00 	movabs $0xffff80000010adec,%rax
ffff800000105912:	80 ff ff 
ffff800000105915:	ff d0                	callq  *%rax
  lapicinit();
ffff800000105917:	48 b8 c4 48 10 00 00 	movabs $0xffff8000001048c4,%rax
ffff80000010591e:	80 ff ff 
ffff800000105921:	ff d0                	callq  *%rax
  mpmain();
ffff800000105923:	48 b8 2f 59 10 00 00 	movabs $0xffff80000010592f,%rax
ffff80000010592a:	80 ff ff 
ffff80000010592d:	ff d0                	callq  *%rax

ffff80000010592f <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
ffff80000010592f:	f3 0f 1e fa          	endbr64 
ffff800000105933:	55                   	push   %rbp
ffff800000105934:	48 89 e5             	mov    %rsp,%rbp
  cprintf("cpu%d: starting\n", cpunum());
ffff800000105937:	48 b8 59 4a 10 00 00 	movabs $0xffff800000104a59,%rax
ffff80000010593e:	80 ff ff 
ffff800000105941:	ff d0                	callq  *%rax
ffff800000105943:	89 c6                	mov    %eax,%esi
ffff800000105945:	48 bf 57 c7 10 00 00 	movabs $0xffff80000010c757,%rdi
ffff80000010594c:	80 ff ff 
ffff80000010594f:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105954:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff80000010595b:	80 ff ff 
ffff80000010595e:	ff d2                	callq  *%rdx
  idtinit();       // load idt register
ffff800000105960:	48 b8 0c 9b 10 00 00 	movabs $0xffff800000109b0c,%rax
ffff800000105967:	80 ff ff 
ffff80000010596a:	ff d0                	callq  *%rax
  syscallinit();   // syscall set up
ffff80000010596c:	48 b8 74 ad 10 00 00 	movabs $0xffff80000010ad74,%rax
ffff800000105973:	80 ff ff 
ffff800000105976:	ff d0                	callq  *%rax
  xchg(&cpu->started, 1); // tell startothers() we're up
ffff800000105978:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff80000010597f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000105983:	48 83 c0 10          	add    $0x10,%rax
ffff800000105987:	be 01 00 00 00       	mov    $0x1,%esi
ffff80000010598c:	48 89 c7             	mov    %rax,%rdi
ffff80000010598f:	48 b8 9b 57 10 00 00 	movabs $0xffff80000010579b,%rax
ffff800000105996:	80 ff ff 
ffff800000105999:	ff d0                	callq  *%rax
  scheduler();     // start running processes
ffff80000010599b:	48 b8 4c 6f 10 00 00 	movabs $0xffff800000106f4c,%rax
ffff8000001059a2:	80 ff ff 
ffff8000001059a5:	ff d0                	callq  *%rax

ffff8000001059a7 <startothers>:
void entry32mp(void);

// Start the non-boot (AP) processors.
static void
startothers(void)
{
ffff8000001059a7:	f3 0f 1e fa          	endbr64 
ffff8000001059ab:	55                   	push   %rbp
ffff8000001059ac:	48 89 e5             	mov    %rsp,%rbp
ffff8000001059af:	48 83 ec 20          	sub    $0x20,%rsp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
ffff8000001059b3:	48 b8 00 70 00 00 00 	movabs $0xffff800000007000,%rax
ffff8000001059ba:	80 ff ff 
ffff8000001059bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  memmove(code, _binary_entryother_start,
ffff8000001059c1:	48 b8 72 00 00 00 00 	movabs $0x72,%rax
ffff8000001059c8:	00 00 00 
ffff8000001059cb:	89 c2                	mov    %eax,%edx
ffff8000001059cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001059d1:	48 be 9c de 10 00 00 	movabs $0xffff80000010de9c,%rsi
ffff8000001059d8:	80 ff ff 
ffff8000001059db:	48 89 c7             	mov    %rax,%rdi
ffff8000001059de:	48 b8 10 7d 10 00 00 	movabs $0xffff800000107d10,%rax
ffff8000001059e5:	80 ff ff 
ffff8000001059e8:	ff d0                	callq  *%rax
          (addr_t)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
ffff8000001059ea:	48 b8 e0 72 1f 00 00 	movabs $0xffff8000001f72e0,%rax
ffff8000001059f1:	80 ff ff 
ffff8000001059f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001059f8:	e9 c0 00 00 00       	jmpq   ffff800000105abd <startothers+0x116>
    if(c == cpus+cpunum())  // We've started already.
ffff8000001059fd:	48 b8 59 4a 10 00 00 	movabs $0xffff800000104a59,%rax
ffff800000105a04:	80 ff ff 
ffff800000105a07:	ff d0                	callq  *%rax
ffff800000105a09:	48 63 d0             	movslq %eax,%rdx
ffff800000105a0c:	48 89 d0             	mov    %rdx,%rax
ffff800000105a0f:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000105a13:	48 01 d0             	add    %rdx,%rax
ffff800000105a16:	48 c1 e0 03          	shl    $0x3,%rax
ffff800000105a1a:	48 89 c2             	mov    %rax,%rdx
ffff800000105a1d:	48 b8 e0 72 1f 00 00 	movabs $0xffff8000001f72e0,%rax
ffff800000105a24:	80 ff ff 
ffff800000105a27:	48 01 d0             	add    %rdx,%rax
ffff800000105a2a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000105a2e:	0f 84 83 00 00 00    	je     ffff800000105ab7 <startothers+0x110>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
ffff800000105a34:	48 b8 66 42 10 00 00 	movabs $0xffff800000104266,%rax
ffff800000105a3b:	80 ff ff 
ffff800000105a3e:	ff d0                	callq  *%rax
ffff800000105a40:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    *(uint32*)(code-4) = 0x8000; // enough stack to get us to entry64mp
ffff800000105a44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105a48:	48 83 e8 04          	sub    $0x4,%rax
ffff800000105a4c:	c7 00 00 80 00 00    	movl   $0x8000,(%rax)
    *(uint32*)(code-8) = v2p(entry32mp);
ffff800000105a52:	48 bf 49 00 10 00 00 	movabs $0xffff800000100049,%rdi
ffff800000105a59:	80 ff ff 
ffff800000105a5c:	48 b8 78 57 10 00 00 	movabs $0xffff800000105778,%rax
ffff800000105a63:	80 ff ff 
ffff800000105a66:	ff d0                	callq  *%rax
ffff800000105a68:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000105a6c:	48 83 ea 08          	sub    $0x8,%rdx
ffff800000105a70:	89 02                	mov    %eax,(%rdx)
    *(uint64*)(code-16) = (uint64) (stack + KSTACKSIZE);
ffff800000105a72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105a76:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
ffff800000105a7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105a81:	48 83 e8 10          	sub    $0x10,%rax
ffff800000105a85:	48 89 10             	mov    %rdx,(%rax)

    lapicstartap(c->apicid, V2P(code));
ffff800000105a88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105a8c:	89 c2                	mov    %eax,%edx
ffff800000105a8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105a92:	0f b6 40 01          	movzbl 0x1(%rax),%eax
ffff800000105a96:	0f b6 c0             	movzbl %al,%eax
ffff800000105a99:	89 d6                	mov    %edx,%esi
ffff800000105a9b:	89 c7                	mov    %eax,%edi
ffff800000105a9d:	48 b8 a1 4b 10 00 00 	movabs $0xffff800000104ba1,%rax
ffff800000105aa4:	80 ff ff 
ffff800000105aa7:	ff d0                	callq  *%rax

    // wait for cpu to finish mpmain()
    while(c->started == 0)
ffff800000105aa9:	90                   	nop
ffff800000105aaa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105aae:	8b 40 10             	mov    0x10(%rax),%eax
ffff800000105ab1:	85 c0                	test   %eax,%eax
ffff800000105ab3:	74 f5                	je     ffff800000105aaa <startothers+0x103>
ffff800000105ab5:	eb 01                	jmp    ffff800000105ab8 <startothers+0x111>
      continue;
ffff800000105ab7:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
ffff800000105ab8:	48 83 45 f8 28       	addq   $0x28,-0x8(%rbp)
ffff800000105abd:	48 b8 20 74 1f 00 00 	movabs $0xffff8000001f7420,%rax
ffff800000105ac4:	80 ff ff 
ffff800000105ac7:	8b 00                	mov    (%rax),%eax
ffff800000105ac9:	48 63 d0             	movslq %eax,%rdx
ffff800000105acc:	48 89 d0             	mov    %rdx,%rax
ffff800000105acf:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000105ad3:	48 01 d0             	add    %rdx,%rax
ffff800000105ad6:	48 c1 e0 03          	shl    $0x3,%rax
ffff800000105ada:	48 89 c2             	mov    %rax,%rdx
ffff800000105add:	48 b8 e0 72 1f 00 00 	movabs $0xffff8000001f72e0,%rax
ffff800000105ae4:	80 ff ff 
ffff800000105ae7:	48 01 d0             	add    %rdx,%rax
ffff800000105aea:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000105aee:	0f 82 09 ff ff ff    	jb     ffff8000001059fd <startothers+0x56>
      ;
  }
}
ffff800000105af4:	90                   	nop
ffff800000105af5:	90                   	nop
ffff800000105af6:	c9                   	leaveq 
ffff800000105af7:	c3                   	retq   

ffff800000105af8 <inb>:
{
ffff800000105af8:	f3 0f 1e fa          	endbr64 
ffff800000105afc:	55                   	push   %rbp
ffff800000105afd:	48 89 e5             	mov    %rsp,%rbp
ffff800000105b00:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000105b04:	89 f8                	mov    %edi,%eax
ffff800000105b06:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff800000105b0a:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff800000105b0e:	89 c2                	mov    %eax,%edx
ffff800000105b10:	ec                   	in     (%dx),%al
ffff800000105b11:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff800000105b14:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff800000105b18:	c9                   	leaveq 
ffff800000105b19:	c3                   	retq   

ffff800000105b1a <outb>:
{
ffff800000105b1a:	f3 0f 1e fa          	endbr64 
ffff800000105b1e:	55                   	push   %rbp
ffff800000105b1f:	48 89 e5             	mov    %rsp,%rbp
ffff800000105b22:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000105b26:	89 f8                	mov    %edi,%eax
ffff800000105b28:	89 f2                	mov    %esi,%edx
ffff800000105b2a:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
ffff800000105b2e:	89 d0                	mov    %edx,%eax
ffff800000105b30:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff800000105b33:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff800000105b37:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff800000105b3b:	ee                   	out    %al,(%dx)
}
ffff800000105b3c:	90                   	nop
ffff800000105b3d:	c9                   	leaveq 
ffff800000105b3e:	c3                   	retq   

ffff800000105b3f <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
ffff800000105b3f:	f3 0f 1e fa          	endbr64 
ffff800000105b43:	55                   	push   %rbp
ffff800000105b44:	48 89 e5             	mov    %rsp,%rbp
ffff800000105b47:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000105b4b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000105b4f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, sum;

  sum = 0;
ffff800000105b52:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  for(i=0; i<len; i++)
ffff800000105b59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000105b60:	eb 1a                	jmp    ffff800000105b7c <sum+0x3d>
    sum += addr[i];
ffff800000105b62:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000105b65:	48 63 d0             	movslq %eax,%rdx
ffff800000105b68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105b6c:	48 01 d0             	add    %rdx,%rax
ffff800000105b6f:	0f b6 00             	movzbl (%rax),%eax
ffff800000105b72:	0f b6 c0             	movzbl %al,%eax
ffff800000105b75:	01 45 f8             	add    %eax,-0x8(%rbp)
  for(i=0; i<len; i++)
ffff800000105b78:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000105b7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000105b7f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
ffff800000105b82:	7c de                	jl     ffff800000105b62 <sum+0x23>
  return sum;
ffff800000105b84:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
ffff800000105b87:	c9                   	leaveq 
ffff800000105b88:	c3                   	retq   

ffff800000105b89 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(addr_t a, int len)
{
ffff800000105b89:	f3 0f 1e fa          	endbr64 
ffff800000105b8d:	55                   	push   %rbp
ffff800000105b8e:	48 89 e5             	mov    %rsp,%rbp
ffff800000105b91:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000105b95:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000105b99:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  uchar *e, *p, *addr;
  addr = P2V(a);
ffff800000105b9c:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff800000105ba3:	80 ff ff 
ffff800000105ba6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000105baa:	48 01 d0             	add    %rdx,%rax
ffff800000105bad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  e = addr+len;
ffff800000105bb1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000105bb4:	48 63 d0             	movslq %eax,%rdx
ffff800000105bb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105bbb:	48 01 d0             	add    %rdx,%rax
ffff800000105bbe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  for(p = addr; p < e; p += sizeof(struct mp))
ffff800000105bc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105bc6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105bca:	eb 4d                	jmp    ffff800000105c19 <mpsearch1+0x90>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
ffff800000105bcc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105bd0:	ba 04 00 00 00       	mov    $0x4,%edx
ffff800000105bd5:	48 be 68 c7 10 00 00 	movabs $0xffff80000010c768,%rsi
ffff800000105bdc:	80 ff ff 
ffff800000105bdf:	48 89 c7             	mov    %rax,%rdi
ffff800000105be2:	48 b8 9d 7c 10 00 00 	movabs $0xffff800000107c9d,%rax
ffff800000105be9:	80 ff ff 
ffff800000105bec:	ff d0                	callq  *%rax
ffff800000105bee:	85 c0                	test   %eax,%eax
ffff800000105bf0:	75 22                	jne    ffff800000105c14 <mpsearch1+0x8b>
ffff800000105bf2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105bf6:	be 10 00 00 00       	mov    $0x10,%esi
ffff800000105bfb:	48 89 c7             	mov    %rax,%rdi
ffff800000105bfe:	48 b8 3f 5b 10 00 00 	movabs $0xffff800000105b3f,%rax
ffff800000105c05:	80 ff ff 
ffff800000105c08:	ff d0                	callq  *%rax
ffff800000105c0a:	84 c0                	test   %al,%al
ffff800000105c0c:	75 06                	jne    ffff800000105c14 <mpsearch1+0x8b>
      return (struct mp*)p;
ffff800000105c0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105c12:	eb 14                	jmp    ffff800000105c28 <mpsearch1+0x9f>
  for(p = addr; p < e; p += sizeof(struct mp))
ffff800000105c14:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)
ffff800000105c19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105c1d:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffff800000105c21:	72 a9                	jb     ffff800000105bcc <mpsearch1+0x43>
  return 0;
ffff800000105c23:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000105c28:	c9                   	leaveq 
ffff800000105c29:	c3                   	retq   

ffff800000105c2a <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
ffff800000105c2a:	f3 0f 1e fa          	endbr64 
ffff800000105c2e:	55                   	push   %rbp
ffff800000105c2f:	48 89 e5             	mov    %rsp,%rbp
ffff800000105c32:	48 83 ec 20          	sub    $0x20,%rsp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
ffff800000105c36:	48 b8 00 04 00 00 00 	movabs $0xffff800000000400,%rax
ffff800000105c3d:	80 ff ff 
ffff800000105c40:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
ffff800000105c44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105c48:	48 83 c0 0f          	add    $0xf,%rax
ffff800000105c4c:	0f b6 00             	movzbl (%rax),%eax
ffff800000105c4f:	0f b6 c0             	movzbl %al,%eax
ffff800000105c52:	c1 e0 08             	shl    $0x8,%eax
ffff800000105c55:	89 c2                	mov    %eax,%edx
ffff800000105c57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105c5b:	48 83 c0 0e          	add    $0xe,%rax
ffff800000105c5f:	0f b6 00             	movzbl (%rax),%eax
ffff800000105c62:	0f b6 c0             	movzbl %al,%eax
ffff800000105c65:	09 d0                	or     %edx,%eax
ffff800000105c67:	c1 e0 04             	shl    $0x4,%eax
ffff800000105c6a:	89 45 f4             	mov    %eax,-0xc(%rbp)
ffff800000105c6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff800000105c71:	74 28                	je     ffff800000105c9b <mpsearch+0x71>
    if((mp = mpsearch1(p, 1024)))
ffff800000105c73:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000105c76:	be 00 04 00 00       	mov    $0x400,%esi
ffff800000105c7b:	48 89 c7             	mov    %rax,%rdi
ffff800000105c7e:	48 b8 89 5b 10 00 00 	movabs $0xffff800000105b89,%rax
ffff800000105c85:	80 ff ff 
ffff800000105c88:	ff d0                	callq  *%rax
ffff800000105c8a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff800000105c8e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000105c93:	74 5e                	je     ffff800000105cf3 <mpsearch+0xc9>
      return mp;
ffff800000105c95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105c99:	eb 6e                	jmp    ffff800000105d09 <mpsearch+0xdf>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
ffff800000105c9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105c9f:	48 83 c0 14          	add    $0x14,%rax
ffff800000105ca3:	0f b6 00             	movzbl (%rax),%eax
ffff800000105ca6:	0f b6 c0             	movzbl %al,%eax
ffff800000105ca9:	c1 e0 08             	shl    $0x8,%eax
ffff800000105cac:	89 c2                	mov    %eax,%edx
ffff800000105cae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105cb2:	48 83 c0 13          	add    $0x13,%rax
ffff800000105cb6:	0f b6 00             	movzbl (%rax),%eax
ffff800000105cb9:	0f b6 c0             	movzbl %al,%eax
ffff800000105cbc:	09 d0                	or     %edx,%eax
ffff800000105cbe:	c1 e0 0a             	shl    $0xa,%eax
ffff800000105cc1:	89 45 f4             	mov    %eax,-0xc(%rbp)
    if((mp = mpsearch1(p-1024, 1024)))
ffff800000105cc4:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000105cc7:	2d 00 04 00 00       	sub    $0x400,%eax
ffff800000105ccc:	89 c0                	mov    %eax,%eax
ffff800000105cce:	be 00 04 00 00       	mov    $0x400,%esi
ffff800000105cd3:	48 89 c7             	mov    %rax,%rdi
ffff800000105cd6:	48 b8 89 5b 10 00 00 	movabs $0xffff800000105b89,%rax
ffff800000105cdd:	80 ff ff 
ffff800000105ce0:	ff d0                	callq  *%rax
ffff800000105ce2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff800000105ce6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000105ceb:	74 06                	je     ffff800000105cf3 <mpsearch+0xc9>
      return mp;
ffff800000105ced:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105cf1:	eb 16                	jmp    ffff800000105d09 <mpsearch+0xdf>
  }
  return mpsearch1(0xF0000, 0x10000);
ffff800000105cf3:	be 00 00 01 00       	mov    $0x10000,%esi
ffff800000105cf8:	bf 00 00 0f 00       	mov    $0xf0000,%edi
ffff800000105cfd:	48 b8 89 5b 10 00 00 	movabs $0xffff800000105b89,%rax
ffff800000105d04:	80 ff ff 
ffff800000105d07:	ff d0                	callq  *%rax
}
ffff800000105d09:	c9                   	leaveq 
ffff800000105d0a:	c3                   	retq   

ffff800000105d0b <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
ffff800000105d0b:	f3 0f 1e fa          	endbr64 
ffff800000105d0f:	55                   	push   %rbp
ffff800000105d10:	48 89 e5             	mov    %rsp,%rbp
ffff800000105d13:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000105d17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
ffff800000105d1b:	48 b8 2a 5c 10 00 00 	movabs $0xffff800000105c2a,%rax
ffff800000105d22:	80 ff ff 
ffff800000105d25:	ff d0                	callq  *%rax
ffff800000105d27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105d2b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000105d30:	74 0b                	je     ffff800000105d3d <mpconfig+0x32>
ffff800000105d32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105d36:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000105d39:	85 c0                	test   %eax,%eax
ffff800000105d3b:	75 0a                	jne    ffff800000105d47 <mpconfig+0x3c>
    return 0;
ffff800000105d3d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105d42:	e9 a0 00 00 00       	jmpq   ffff800000105de7 <mpconfig+0xdc>
  conf = (struct mpconf*) P2V((addr_t) mp->physaddr);
ffff800000105d47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105d4b:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000105d4e:	89 c2                	mov    %eax,%edx
ffff800000105d50:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff800000105d57:	80 ff ff 
ffff800000105d5a:	48 01 d0             	add    %rdx,%rax
ffff800000105d5d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if(memcmp(conf, "PCMP", 4) != 0)
ffff800000105d61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105d65:	ba 04 00 00 00       	mov    $0x4,%edx
ffff800000105d6a:	48 be 6d c7 10 00 00 	movabs $0xffff80000010c76d,%rsi
ffff800000105d71:	80 ff ff 
ffff800000105d74:	48 89 c7             	mov    %rax,%rdi
ffff800000105d77:	48 b8 9d 7c 10 00 00 	movabs $0xffff800000107c9d,%rax
ffff800000105d7e:	80 ff ff 
ffff800000105d81:	ff d0                	callq  *%rax
ffff800000105d83:	85 c0                	test   %eax,%eax
ffff800000105d85:	74 07                	je     ffff800000105d8e <mpconfig+0x83>
    return 0;
ffff800000105d87:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105d8c:	eb 59                	jmp    ffff800000105de7 <mpconfig+0xdc>
  if(conf->version != 1 && conf->version != 4)
ffff800000105d8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105d92:	0f b6 40 06          	movzbl 0x6(%rax),%eax
ffff800000105d96:	3c 01                	cmp    $0x1,%al
ffff800000105d98:	74 13                	je     ffff800000105dad <mpconfig+0xa2>
ffff800000105d9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105d9e:	0f b6 40 06          	movzbl 0x6(%rax),%eax
ffff800000105da2:	3c 04                	cmp    $0x4,%al
ffff800000105da4:	74 07                	je     ffff800000105dad <mpconfig+0xa2>
    return 0;
ffff800000105da6:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105dab:	eb 3a                	jmp    ffff800000105de7 <mpconfig+0xdc>
  if(sum((uchar*)conf, conf->length) != 0)
ffff800000105dad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105db1:	0f b7 40 04          	movzwl 0x4(%rax),%eax
ffff800000105db5:	0f b7 d0             	movzwl %ax,%edx
ffff800000105db8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105dbc:	89 d6                	mov    %edx,%esi
ffff800000105dbe:	48 89 c7             	mov    %rax,%rdi
ffff800000105dc1:	48 b8 3f 5b 10 00 00 	movabs $0xffff800000105b3f,%rax
ffff800000105dc8:	80 ff ff 
ffff800000105dcb:	ff d0                	callq  *%rax
ffff800000105dcd:	84 c0                	test   %al,%al
ffff800000105dcf:	74 07                	je     ffff800000105dd8 <mpconfig+0xcd>
    return 0;
ffff800000105dd1:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105dd6:	eb 0f                	jmp    ffff800000105de7 <mpconfig+0xdc>
  *pmp = mp;
ffff800000105dd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105ddc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000105de0:	48 89 10             	mov    %rdx,(%rax)
  return conf;
ffff800000105de3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
ffff800000105de7:	c9                   	leaveq 
ffff800000105de8:	c3                   	retq   

ffff800000105de9 <mpinit>:

void
mpinit(void)
{
ffff800000105de9:	f3 0f 1e fa          	endbr64 
ffff800000105ded:	55                   	push   %rbp
ffff800000105dee:	48 89 e5             	mov    %rsp,%rbp
ffff800000105df1:	48 83 ec 30          	sub    $0x30,%rsp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0) {
ffff800000105df5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
ffff800000105df9:	48 89 c7             	mov    %rax,%rdi
ffff800000105dfc:	48 b8 0b 5d 10 00 00 	movabs $0xffff800000105d0b,%rax
ffff800000105e03:	80 ff ff 
ffff800000105e06:	ff d0                	callq  *%rax
ffff800000105e08:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000105e0c:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000105e11:	75 20                	jne    ffff800000105e33 <mpinit+0x4a>
    cprintf("No other CPUs found.\n");
ffff800000105e13:	48 bf 72 c7 10 00 00 	movabs $0xffff80000010c772,%rdi
ffff800000105e1a:	80 ff ff 
ffff800000105e1d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105e22:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000105e29:	80 ff ff 
ffff800000105e2c:	ff d2                	callq  *%rdx
ffff800000105e2e:	e9 c3 01 00 00       	jmpq   ffff800000105ff6 <mpinit+0x20d>
    return;
  }
  lapic = P2V((addr_t)conf->lapicaddr_p);
ffff800000105e33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105e37:	8b 40 24             	mov    0x24(%rax),%eax
ffff800000105e3a:	89 c2                	mov    %eax,%edx
ffff800000105e3c:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff800000105e43:	80 ff ff 
ffff800000105e46:	48 01 d0             	add    %rdx,%rax
ffff800000105e49:	48 89 c2             	mov    %rax,%rdx
ffff800000105e4c:	48 b8 c0 71 1f 00 00 	movabs $0xffff8000001f71c0,%rax
ffff800000105e53:	80 ff ff 
ffff800000105e56:	48 89 10             	mov    %rdx,(%rax)
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
ffff800000105e59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105e5d:	48 83 c0 2c          	add    $0x2c,%rax
ffff800000105e61:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105e65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105e69:	0f b7 40 04          	movzwl 0x4(%rax),%eax
ffff800000105e6d:	0f b7 d0             	movzwl %ax,%edx
ffff800000105e70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105e74:	48 01 d0             	add    %rdx,%rax
ffff800000105e77:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff800000105e7b:	e9 f3 00 00 00       	jmpq   ffff800000105f73 <mpinit+0x18a>
    switch(*p){
ffff800000105e80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105e84:	0f b6 00             	movzbl (%rax),%eax
ffff800000105e87:	0f b6 c0             	movzbl %al,%eax
ffff800000105e8a:	83 f8 04             	cmp    $0x4,%eax
ffff800000105e8d:	0f 8f ca 00 00 00    	jg     ffff800000105f5d <mpinit+0x174>
ffff800000105e93:	83 f8 03             	cmp    $0x3,%eax
ffff800000105e96:	0f 8d ba 00 00 00    	jge    ffff800000105f56 <mpinit+0x16d>
ffff800000105e9c:	83 f8 02             	cmp    $0x2,%eax
ffff800000105e9f:	0f 84 8e 00 00 00    	je     ffff800000105f33 <mpinit+0x14a>
ffff800000105ea5:	83 f8 02             	cmp    $0x2,%eax
ffff800000105ea8:	0f 8f af 00 00 00    	jg     ffff800000105f5d <mpinit+0x174>
ffff800000105eae:	85 c0                	test   %eax,%eax
ffff800000105eb0:	74 0e                	je     ffff800000105ec0 <mpinit+0xd7>
ffff800000105eb2:	83 f8 01             	cmp    $0x1,%eax
ffff800000105eb5:	0f 84 9b 00 00 00    	je     ffff800000105f56 <mpinit+0x16d>
ffff800000105ebb:	e9 9d 00 00 00       	jmpq   ffff800000105f5d <mpinit+0x174>
    case MPPROC:
      proc = (struct mpproc*)p;
ffff800000105ec0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105ec4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
      if(ncpu < NCPU) {
ffff800000105ec8:	48 b8 20 74 1f 00 00 	movabs $0xffff8000001f7420,%rax
ffff800000105ecf:	80 ff ff 
ffff800000105ed2:	8b 00                	mov    (%rax),%eax
ffff800000105ed4:	83 f8 07             	cmp    $0x7,%eax
ffff800000105ed7:	7f 53                	jg     ffff800000105f2c <mpinit+0x143>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
ffff800000105ed9:	48 b8 20 74 1f 00 00 	movabs $0xffff8000001f7420,%rax
ffff800000105ee0:	80 ff ff 
ffff800000105ee3:	8b 10                	mov    (%rax),%edx
ffff800000105ee5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000105ee9:	0f b6 48 01          	movzbl 0x1(%rax),%ecx
ffff800000105eed:	48 be e0 72 1f 00 00 	movabs $0xffff8000001f72e0,%rsi
ffff800000105ef4:	80 ff ff 
ffff800000105ef7:	48 63 d2             	movslq %edx,%rdx
ffff800000105efa:	48 89 d0             	mov    %rdx,%rax
ffff800000105efd:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000105f01:	48 01 d0             	add    %rdx,%rax
ffff800000105f04:	48 c1 e0 03          	shl    $0x3,%rax
ffff800000105f08:	48 01 f0             	add    %rsi,%rax
ffff800000105f0b:	48 83 c0 01          	add    $0x1,%rax
ffff800000105f0f:	88 08                	mov    %cl,(%rax)
        ncpu++;
ffff800000105f11:	48 b8 20 74 1f 00 00 	movabs $0xffff8000001f7420,%rax
ffff800000105f18:	80 ff ff 
ffff800000105f1b:	8b 00                	mov    (%rax),%eax
ffff800000105f1d:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000105f20:	48 b8 20 74 1f 00 00 	movabs $0xffff8000001f7420,%rax
ffff800000105f27:	80 ff ff 
ffff800000105f2a:	89 10                	mov    %edx,(%rax)
      }
      p += sizeof(struct mpproc);
ffff800000105f2c:	48 83 45 f8 14       	addq   $0x14,-0x8(%rbp)
      continue;
ffff800000105f31:	eb 40                	jmp    ffff800000105f73 <mpinit+0x18a>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
ffff800000105f33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105f37:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
      ioapicid = ioapic->apicno;
ffff800000105f3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105f3f:	0f b6 40 01          	movzbl 0x1(%rax),%eax
ffff800000105f43:	48 ba 24 74 1f 00 00 	movabs $0xffff8000001f7424,%rdx
ffff800000105f4a:	80 ff ff 
ffff800000105f4d:	88 02                	mov    %al,(%rdx)
      p += sizeof(struct mpioapic);
ffff800000105f4f:	48 83 45 f8 08       	addq   $0x8,-0x8(%rbp)
      continue;
ffff800000105f54:	eb 1d                	jmp    ffff800000105f73 <mpinit+0x18a>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
ffff800000105f56:	48 83 45 f8 08       	addq   $0x8,-0x8(%rbp)
      continue;
ffff800000105f5b:	eb 16                	jmp    ffff800000105f73 <mpinit+0x18a>
    default:
      panic("Major problem parsing mp config.");
ffff800000105f5d:	48 bf 88 c7 10 00 00 	movabs $0xffff80000010c788,%rdi
ffff800000105f64:	80 ff ff 
ffff800000105f67:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000105f6e:	80 ff ff 
ffff800000105f71:	ff d0                	callq  *%rax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
ffff800000105f73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105f77:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffff800000105f7b:	0f 82 ff fe ff ff    	jb     ffff800000105e80 <mpinit+0x97>
      break;
    }
  }
  cprintf("Seems we are SMP, ncpu = %d\n",ncpu);
ffff800000105f81:	48 b8 20 74 1f 00 00 	movabs $0xffff8000001f7420,%rax
ffff800000105f88:	80 ff ff 
ffff800000105f8b:	8b 00                	mov    (%rax),%eax
ffff800000105f8d:	89 c6                	mov    %eax,%esi
ffff800000105f8f:	48 bf a9 c7 10 00 00 	movabs $0xffff80000010c7a9,%rdi
ffff800000105f96:	80 ff ff 
ffff800000105f99:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105f9e:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000105fa5:	80 ff ff 
ffff800000105fa8:	ff d2                	callq  *%rdx
  if(mp->imcrp){
ffff800000105faa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000105fae:	0f b6 40 0c          	movzbl 0xc(%rax),%eax
ffff800000105fb2:	84 c0                	test   %al,%al
ffff800000105fb4:	74 40                	je     ffff800000105ff6 <mpinit+0x20d>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
ffff800000105fb6:	be 70 00 00 00       	mov    $0x70,%esi
ffff800000105fbb:	bf 22 00 00 00       	mov    $0x22,%edi
ffff800000105fc0:	48 b8 1a 5b 10 00 00 	movabs $0xffff800000105b1a,%rax
ffff800000105fc7:	80 ff ff 
ffff800000105fca:	ff d0                	callq  *%rax
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
ffff800000105fcc:	bf 23 00 00 00       	mov    $0x23,%edi
ffff800000105fd1:	48 b8 f8 5a 10 00 00 	movabs $0xffff800000105af8,%rax
ffff800000105fd8:	80 ff ff 
ffff800000105fdb:	ff d0                	callq  *%rax
ffff800000105fdd:	83 c8 01             	or     $0x1,%eax
ffff800000105fe0:	0f b6 c0             	movzbl %al,%eax
ffff800000105fe3:	89 c6                	mov    %eax,%esi
ffff800000105fe5:	bf 23 00 00 00       	mov    $0x23,%edi
ffff800000105fea:	48 b8 1a 5b 10 00 00 	movabs $0xffff800000105b1a,%rax
ffff800000105ff1:	80 ff ff 
ffff800000105ff4:	ff d0                	callq  *%rax
  }
}
ffff800000105ff6:	c9                   	leaveq 
ffff800000105ff7:	c3                   	retq   

ffff800000105ff8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
ffff800000105ff8:	f3 0f 1e fa          	endbr64 
ffff800000105ffc:	55                   	push   %rbp
ffff800000105ffd:	48 89 e5             	mov    %rsp,%rbp
ffff800000106000:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000106004:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000106008:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct pipe *p;

  p = 0;
ffff80000010600c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
ffff800000106013:	00 
  *f0 = *f1 = 0;
ffff800000106014:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106018:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
ffff80000010601f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106023:	48 8b 10             	mov    (%rax),%rdx
ffff800000106026:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010602a:	48 89 10             	mov    %rdx,(%rax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
ffff80000010602d:	48 b8 84 1b 10 00 00 	movabs $0xffff800000101b84,%rax
ffff800000106034:	80 ff ff 
ffff800000106037:	ff d0                	callq  *%rax
ffff800000106039:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff80000010603d:	48 89 02             	mov    %rax,(%rdx)
ffff800000106040:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106044:	48 8b 00             	mov    (%rax),%rax
ffff800000106047:	48 85 c0             	test   %rax,%rax
ffff80000010604a:	0f 84 fe 00 00 00    	je     ffff80000010614e <pipealloc+0x156>
ffff800000106050:	48 b8 84 1b 10 00 00 	movabs $0xffff800000101b84,%rax
ffff800000106057:	80 ff ff 
ffff80000010605a:	ff d0                	callq  *%rax
ffff80000010605c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000106060:	48 89 02             	mov    %rax,(%rdx)
ffff800000106063:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106067:	48 8b 00             	mov    (%rax),%rax
ffff80000010606a:	48 85 c0             	test   %rax,%rax
ffff80000010606d:	0f 84 db 00 00 00    	je     ffff80000010614e <pipealloc+0x156>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
ffff800000106073:	48 b8 66 42 10 00 00 	movabs $0xffff800000104266,%rax
ffff80000010607a:	80 ff ff 
ffff80000010607d:	ff d0                	callq  *%rax
ffff80000010607f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000106083:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000106088:	0f 84 c3 00 00 00    	je     ffff800000106151 <pipealloc+0x159>
    goto bad;
  p->readopen = 1;
ffff80000010608e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106092:	c7 80 70 02 00 00 01 	movl   $0x1,0x270(%rax)
ffff800000106099:	00 00 00 
  p->writeopen = 1;
ffff80000010609c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001060a0:	c7 80 74 02 00 00 01 	movl   $0x1,0x274(%rax)
ffff8000001060a7:	00 00 00 
  p->nwrite = 0;
ffff8000001060aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001060ae:	c7 80 6c 02 00 00 00 	movl   $0x0,0x26c(%rax)
ffff8000001060b5:	00 00 00 
  p->nread = 0;
ffff8000001060b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001060bc:	c7 80 68 02 00 00 00 	movl   $0x0,0x268(%rax)
ffff8000001060c3:	00 00 00 
  initlock(&p->lock, "pipe");
ffff8000001060c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001060ca:	48 be c6 c7 10 00 00 	movabs $0xffff80000010c7c6,%rsi
ffff8000001060d1:	80 ff ff 
ffff8000001060d4:	48 89 c7             	mov    %rax,%rdi
ffff8000001060d7:	48 b8 24 78 10 00 00 	movabs $0xffff800000107824,%rax
ffff8000001060de:	80 ff ff 
ffff8000001060e1:	ff d0                	callq  *%rax
  (*f0)->type = FD_PIPE;
ffff8000001060e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001060e7:	48 8b 00             	mov    (%rax),%rax
ffff8000001060ea:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  (*f0)->readable = 1;
ffff8000001060f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001060f4:	48 8b 00             	mov    (%rax),%rax
ffff8000001060f7:	c6 40 08 01          	movb   $0x1,0x8(%rax)
  (*f0)->writable = 0;
ffff8000001060fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001060ff:	48 8b 00             	mov    (%rax),%rax
ffff800000106102:	c6 40 09 00          	movb   $0x0,0x9(%rax)
  (*f0)->pipe = p;
ffff800000106106:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010610a:	48 8b 00             	mov    (%rax),%rax
ffff80000010610d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000106111:	48 89 50 10          	mov    %rdx,0x10(%rax)
  (*f1)->type = FD_PIPE;
ffff800000106115:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106119:	48 8b 00             	mov    (%rax),%rax
ffff80000010611c:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  (*f1)->readable = 0;
ffff800000106122:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106126:	48 8b 00             	mov    (%rax),%rax
ffff800000106129:	c6 40 08 00          	movb   $0x0,0x8(%rax)
  (*f1)->writable = 1;
ffff80000010612d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106131:	48 8b 00             	mov    (%rax),%rax
ffff800000106134:	c6 40 09 01          	movb   $0x1,0x9(%rax)
  (*f1)->pipe = p;
ffff800000106138:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010613c:	48 8b 00             	mov    (%rax),%rax
ffff80000010613f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000106143:	48 89 50 10          	mov    %rdx,0x10(%rax)
  return 0;
ffff800000106147:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010614c:	eb 67                	jmp    ffff8000001061b5 <pipealloc+0x1bd>
    goto bad;
ffff80000010614e:	90                   	nop
ffff80000010614f:	eb 01                	jmp    ffff800000106152 <pipealloc+0x15a>
    goto bad;
ffff800000106151:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
ffff800000106152:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000106157:	74 13                	je     ffff80000010616c <pipealloc+0x174>
    krelease((char*)p);
ffff800000106159:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010615d:	48 89 c7             	mov    %rax,%rdi
ffff800000106160:	48 b8 20 43 10 00 00 	movabs $0xffff800000104320,%rax
ffff800000106167:	80 ff ff 
ffff80000010616a:	ff d0                	callq  *%rax
  if(*f0)
ffff80000010616c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106170:	48 8b 00             	mov    (%rax),%rax
ffff800000106173:	48 85 c0             	test   %rax,%rax
ffff800000106176:	74 16                	je     ffff80000010618e <pipealloc+0x196>
    fileclose(*f0);
ffff800000106178:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010617c:	48 8b 00             	mov    (%rax),%rax
ffff80000010617f:	48 89 c7             	mov    %rax,%rdi
ffff800000106182:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff800000106189:	80 ff ff 
ffff80000010618c:	ff d0                	callq  *%rax
  if(*f1)
ffff80000010618e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106192:	48 8b 00             	mov    (%rax),%rax
ffff800000106195:	48 85 c0             	test   %rax,%rax
ffff800000106198:	74 16                	je     ffff8000001061b0 <pipealloc+0x1b8>
    fileclose(*f1);
ffff80000010619a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010619e:	48 8b 00             	mov    (%rax),%rax
ffff8000001061a1:	48 89 c7             	mov    %rax,%rdi
ffff8000001061a4:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff8000001061ab:	80 ff ff 
ffff8000001061ae:	ff d0                	callq  *%rax
  return -1;
ffff8000001061b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff8000001061b5:	c9                   	leaveq 
ffff8000001061b6:	c3                   	retq   

ffff8000001061b7 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
ffff8000001061b7:	f3 0f 1e fa          	endbr64 
ffff8000001061bb:	55                   	push   %rbp
ffff8000001061bc:	48 89 e5             	mov    %rsp,%rbp
ffff8000001061bf:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001061c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001061c7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  acquire(&p->lock);
ffff8000001061ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001061ce:	48 89 c7             	mov    %rax,%rdi
ffff8000001061d1:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff8000001061d8:	80 ff ff 
ffff8000001061db:	ff d0                	callq  *%rax
  if(writable){
ffff8000001061dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff8000001061e1:	74 29                	je     ffff80000010620c <pipeclose+0x55>
    p->writeopen = 0;
ffff8000001061e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001061e7:	c7 80 74 02 00 00 00 	movl   $0x0,0x274(%rax)
ffff8000001061ee:	00 00 00 
    wakeup(&p->nread);
ffff8000001061f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001061f5:	48 05 68 02 00 00    	add    $0x268,%rax
ffff8000001061fb:	48 89 c7             	mov    %rax,%rdi
ffff8000001061fe:	48 b8 b8 73 10 00 00 	movabs $0xffff8000001073b8,%rax
ffff800000106205:	80 ff ff 
ffff800000106208:	ff d0                	callq  *%rax
ffff80000010620a:	eb 27                	jmp    ffff800000106233 <pipeclose+0x7c>
  } else {
    p->readopen = 0;
ffff80000010620c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106210:	c7 80 70 02 00 00 00 	movl   $0x0,0x270(%rax)
ffff800000106217:	00 00 00 
    wakeup(&p->nwrite);
ffff80000010621a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010621e:	48 05 6c 02 00 00    	add    $0x26c,%rax
ffff800000106224:	48 89 c7             	mov    %rax,%rdi
ffff800000106227:	48 b8 b8 73 10 00 00 	movabs $0xffff8000001073b8,%rax
ffff80000010622e:	80 ff ff 
ffff800000106231:	ff d0                	callq  *%rax
  }
  if(p->readopen == 0 && p->writeopen == 0){
ffff800000106233:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106237:	8b 80 70 02 00 00    	mov    0x270(%rax),%eax
ffff80000010623d:	85 c0                	test   %eax,%eax
ffff80000010623f:	75 36                	jne    ffff800000106277 <pipeclose+0xc0>
ffff800000106241:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106245:	8b 80 74 02 00 00    	mov    0x274(%rax),%eax
ffff80000010624b:	85 c0                	test   %eax,%eax
ffff80000010624d:	75 28                	jne    ffff800000106277 <pipeclose+0xc0>
    release(&p->lock);
ffff80000010624f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106253:	48 89 c7             	mov    %rax,%rdi
ffff800000106256:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff80000010625d:	80 ff ff 
ffff800000106260:	ff d0                	callq  *%rax
    krelease((char*)p);
ffff800000106262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106266:	48 89 c7             	mov    %rax,%rdi
ffff800000106269:	48 b8 20 43 10 00 00 	movabs $0xffff800000104320,%rax
ffff800000106270:	80 ff ff 
ffff800000106273:	ff d0                	callq  *%rax
ffff800000106275:	eb 14                	jmp    ffff80000010628b <pipeclose+0xd4>
  } else
    release(&p->lock);
ffff800000106277:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010627b:	48 89 c7             	mov    %rax,%rdi
ffff80000010627e:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000106285:	80 ff ff 
ffff800000106288:	ff d0                	callq  *%rax
}
ffff80000010628a:	90                   	nop
ffff80000010628b:	90                   	nop
ffff80000010628c:	c9                   	leaveq 
ffff80000010628d:	c3                   	retq   

ffff80000010628e <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
ffff80000010628e:	f3 0f 1e fa          	endbr64 
ffff800000106292:	55                   	push   %rbp
ffff800000106293:	48 89 e5             	mov    %rsp,%rbp
ffff800000106296:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010629a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010629e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff8000001062a2:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int i;

  acquire(&p->lock);
ffff8000001062a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001062a9:	48 89 c7             	mov    %rax,%rdi
ffff8000001062ac:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff8000001062b3:	80 ff ff 
ffff8000001062b6:	ff d0                	callq  *%rax
  for(i = 0; i < n; i++){
ffff8000001062b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001062bf:	e9 d5 00 00 00       	jmpq   ffff800000106399 <pipewrite+0x10b>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
ffff8000001062c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001062c8:	8b 80 70 02 00 00    	mov    0x270(%rax),%eax
ffff8000001062ce:	85 c0                	test   %eax,%eax
ffff8000001062d0:	74 12                	je     ffff8000001062e4 <pipewrite+0x56>
ffff8000001062d2:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001062d9:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001062dd:	8b 40 40             	mov    0x40(%rax),%eax
ffff8000001062e0:	85 c0                	test   %eax,%eax
ffff8000001062e2:	74 1d                	je     ffff800000106301 <pipewrite+0x73>
        release(&p->lock);
ffff8000001062e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001062e8:	48 89 c7             	mov    %rax,%rdi
ffff8000001062eb:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001062f2:	80 ff ff 
ffff8000001062f5:	ff d0                	callq  *%rax
        return -1;
ffff8000001062f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001062fc:	e9 cf 00 00 00       	jmpq   ffff8000001063d0 <pipewrite+0x142>
      }
      wakeup(&p->nread);
ffff800000106301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106305:	48 05 68 02 00 00    	add    $0x268,%rax
ffff80000010630b:	48 89 c7             	mov    %rax,%rdi
ffff80000010630e:	48 b8 b8 73 10 00 00 	movabs $0xffff8000001073b8,%rax
ffff800000106315:	80 ff ff 
ffff800000106318:	ff d0                	callq  *%rax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
ffff80000010631a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010631e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000106322:	48 81 c2 6c 02 00 00 	add    $0x26c,%rdx
ffff800000106329:	48 89 c6             	mov    %rax,%rsi
ffff80000010632c:	48 89 d7             	mov    %rdx,%rdi
ffff80000010632f:	48 b8 47 72 10 00 00 	movabs $0xffff800000107247,%rax
ffff800000106336:	80 ff ff 
ffff800000106339:	ff d0                	callq  *%rax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
ffff80000010633b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010633f:	8b 90 6c 02 00 00    	mov    0x26c(%rax),%edx
ffff800000106345:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106349:	8b 80 68 02 00 00    	mov    0x268(%rax),%eax
ffff80000010634f:	05 00 02 00 00       	add    $0x200,%eax
ffff800000106354:	39 c2                	cmp    %eax,%edx
ffff800000106356:	0f 84 68 ff ff ff    	je     ffff8000001062c4 <pipewrite+0x36>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
ffff80000010635c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010635f:	48 63 d0             	movslq %eax,%rdx
ffff800000106362:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106366:	48 8d 34 02          	lea    (%rdx,%rax,1),%rsi
ffff80000010636a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010636e:	8b 80 6c 02 00 00    	mov    0x26c(%rax),%eax
ffff800000106374:	8d 48 01             	lea    0x1(%rax),%ecx
ffff800000106377:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff80000010637b:	89 8a 6c 02 00 00    	mov    %ecx,0x26c(%rdx)
ffff800000106381:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff800000106386:	89 c1                	mov    %eax,%ecx
ffff800000106388:	0f b6 16             	movzbl (%rsi),%edx
ffff80000010638b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010638f:	89 c9                	mov    %ecx,%ecx
ffff800000106391:	88 54 08 68          	mov    %dl,0x68(%rax,%rcx,1)
  for(i = 0; i < n; i++){
ffff800000106395:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000106399:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010639c:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff80000010639f:	7c 9a                	jl     ffff80000010633b <pipewrite+0xad>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
ffff8000001063a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001063a5:	48 05 68 02 00 00    	add    $0x268,%rax
ffff8000001063ab:	48 89 c7             	mov    %rax,%rdi
ffff8000001063ae:	48 b8 b8 73 10 00 00 	movabs $0xffff8000001073b8,%rax
ffff8000001063b5:	80 ff ff 
ffff8000001063b8:	ff d0                	callq  *%rax
  release(&p->lock);
ffff8000001063ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001063be:	48 89 c7             	mov    %rax,%rdi
ffff8000001063c1:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001063c8:	80 ff ff 
ffff8000001063cb:	ff d0                	callq  *%rax
  return n;
ffff8000001063cd:	8b 45 dc             	mov    -0x24(%rbp),%eax
}
ffff8000001063d0:	c9                   	leaveq 
ffff8000001063d1:	c3                   	retq   

ffff8000001063d2 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
ffff8000001063d2:	f3 0f 1e fa          	endbr64 
ffff8000001063d6:	55                   	push   %rbp
ffff8000001063d7:	48 89 e5             	mov    %rsp,%rbp
ffff8000001063da:	48 83 ec 30          	sub    $0x30,%rsp
ffff8000001063de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001063e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff8000001063e6:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int i;

  acquire(&p->lock);
ffff8000001063e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001063ed:	48 89 c7             	mov    %rax,%rdi
ffff8000001063f0:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff8000001063f7:	80 ff ff 
ffff8000001063fa:	ff d0                	callq  *%rax
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
ffff8000001063fc:	eb 50                	jmp    ffff80000010644e <piperead+0x7c>
    if(proc->killed){
ffff8000001063fe:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106405:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106409:	8b 40 40             	mov    0x40(%rax),%eax
ffff80000010640c:	85 c0                	test   %eax,%eax
ffff80000010640e:	74 1d                	je     ffff80000010642d <piperead+0x5b>
      release(&p->lock);
ffff800000106410:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106414:	48 89 c7             	mov    %rax,%rdi
ffff800000106417:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff80000010641e:	80 ff ff 
ffff800000106421:	ff d0                	callq  *%rax
      return -1;
ffff800000106423:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000106428:	e9 de 00 00 00       	jmpq   ffff80000010650b <piperead+0x139>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
ffff80000010642d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106431:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000106435:	48 81 c2 68 02 00 00 	add    $0x268,%rdx
ffff80000010643c:	48 89 c6             	mov    %rax,%rsi
ffff80000010643f:	48 89 d7             	mov    %rdx,%rdi
ffff800000106442:	48 b8 47 72 10 00 00 	movabs $0xffff800000107247,%rax
ffff800000106449:	80 ff ff 
ffff80000010644c:	ff d0                	callq  *%rax
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
ffff80000010644e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106452:	8b 90 68 02 00 00    	mov    0x268(%rax),%edx
ffff800000106458:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010645c:	8b 80 6c 02 00 00    	mov    0x26c(%rax),%eax
ffff800000106462:	39 c2                	cmp    %eax,%edx
ffff800000106464:	75 0e                	jne    ffff800000106474 <piperead+0xa2>
ffff800000106466:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010646a:	8b 80 74 02 00 00    	mov    0x274(%rax),%eax
ffff800000106470:	85 c0                	test   %eax,%eax
ffff800000106472:	75 8a                	jne    ffff8000001063fe <piperead+0x2c>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
ffff800000106474:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010647b:	eb 54                	jmp    ffff8000001064d1 <piperead+0xff>
    if(p->nread == p->nwrite)
ffff80000010647d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106481:	8b 90 68 02 00 00    	mov    0x268(%rax),%edx
ffff800000106487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010648b:	8b 80 6c 02 00 00    	mov    0x26c(%rax),%eax
ffff800000106491:	39 c2                	cmp    %eax,%edx
ffff800000106493:	74 46                	je     ffff8000001064db <piperead+0x109>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
ffff800000106495:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106499:	8b 80 68 02 00 00    	mov    0x268(%rax),%eax
ffff80000010649f:	8d 48 01             	lea    0x1(%rax),%ecx
ffff8000001064a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001064a6:	89 8a 68 02 00 00    	mov    %ecx,0x268(%rdx)
ffff8000001064ac:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff8000001064b1:	89 c1                	mov    %eax,%ecx
ffff8000001064b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001064b6:	48 63 d0             	movslq %eax,%rdx
ffff8000001064b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001064bd:	48 01 c2             	add    %rax,%rdx
ffff8000001064c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001064c4:	89 c9                	mov    %ecx,%ecx
ffff8000001064c6:	0f b6 44 08 68       	movzbl 0x68(%rax,%rcx,1),%eax
ffff8000001064cb:	88 02                	mov    %al,(%rdx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
ffff8000001064cd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001064d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001064d4:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff8000001064d7:	7c a4                	jl     ffff80000010647d <piperead+0xab>
ffff8000001064d9:	eb 01                	jmp    ffff8000001064dc <piperead+0x10a>
      break;
ffff8000001064db:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
ffff8000001064dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001064e0:	48 05 6c 02 00 00    	add    $0x26c,%rax
ffff8000001064e6:	48 89 c7             	mov    %rax,%rdi
ffff8000001064e9:	48 b8 b8 73 10 00 00 	movabs $0xffff8000001073b8,%rax
ffff8000001064f0:	80 ff ff 
ffff8000001064f3:	ff d0                	callq  *%rax
  release(&p->lock);
ffff8000001064f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001064f9:	48 89 c7             	mov    %rax,%rdi
ffff8000001064fc:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000106503:	80 ff ff 
ffff800000106506:	ff d0                	callq  *%rax
  return i;
ffff800000106508:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff80000010650b:	c9                   	leaveq 
ffff80000010650c:	c3                   	retq   

ffff80000010650d <readeflags>:
{
ffff80000010650d:	f3 0f 1e fa          	endbr64 
ffff800000106511:	55                   	push   %rbp
ffff800000106512:	48 89 e5             	mov    %rsp,%rbp
ffff800000106515:	48 83 ec 10          	sub    $0x10,%rsp
  asm volatile("pushf; pop %0" : "=r" (eflags));
ffff800000106519:	9c                   	pushfq 
ffff80000010651a:	58                   	pop    %rax
ffff80000010651b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return eflags;
ffff80000010651f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000106523:	c9                   	leaveq 
ffff800000106524:	c3                   	retq   

ffff800000106525 <sti>:
{
ffff800000106525:	f3 0f 1e fa          	endbr64 
ffff800000106529:	55                   	push   %rbp
ffff80000010652a:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("sti");
ffff80000010652d:	fb                   	sti    
}
ffff80000010652e:	90                   	nop
ffff80000010652f:	5d                   	pop    %rbp
ffff800000106530:	c3                   	retq   

ffff800000106531 <hlt>:
{
ffff800000106531:	f3 0f 1e fa          	endbr64 
ffff800000106535:	55                   	push   %rbp
ffff800000106536:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("hlt");
ffff800000106539:	f4                   	hlt    
}
ffff80000010653a:	90                   	nop
ffff80000010653b:	5d                   	pop    %rbp
ffff80000010653c:	c3                   	retq   

ffff80000010653d <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
ffff80000010653d:	f3 0f 1e fa          	endbr64 
ffff800000106541:	55                   	push   %rbp
ffff800000106542:	48 89 e5             	mov    %rsp,%rbp
  initlock(&ptable.lock, "ptable");
ffff800000106545:	48 be cb c7 10 00 00 	movabs $0xffff80000010c7cb,%rsi
ffff80000010654c:	80 ff ff 
ffff80000010654f:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff800000106556:	80 ff ff 
ffff800000106559:	48 b8 24 78 10 00 00 	movabs $0xffff800000107824,%rax
ffff800000106560:	80 ff ff 
ffff800000106563:	ff d0                	callq  *%rax
}
ffff800000106565:	90                   	nop
ffff800000106566:	5d                   	pop    %rbp
ffff800000106567:	c3                   	retq   

ffff800000106568 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
ffff800000106568:	f3 0f 1e fa          	endbr64 
ffff80000010656c:	55                   	push   %rbp
ffff80000010656d:	48 89 e5             	mov    %rsp,%rbp
ffff800000106570:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
ffff800000106574:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff80000010657b:	80 ff ff 
ffff80000010657e:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000106585:	80 ff ff 
ffff800000106588:	ff d0                	callq  *%rax

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff80000010658a:	48 b8 a8 74 1f 00 00 	movabs $0xffff8000001f74a8,%rax
ffff800000106591:	80 ff ff 
ffff800000106594:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000106598:	eb 13                	jmp    ffff8000001065ad <allocproc+0x45>
    if(p->state == UNUSED)
ffff80000010659a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010659e:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001065a1:	85 c0                	test   %eax,%eax
ffff8000001065a3:	74 38                	je     ffff8000001065dd <allocproc+0x75>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff8000001065a5:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffff8000001065ac:	00 
ffff8000001065ad:	48 b8 a8 ac 1f 00 00 	movabs $0xffff8000001faca8,%rax
ffff8000001065b4:	80 ff ff 
ffff8000001065b7:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001065bb:	72 dd                	jb     ffff80000010659a <allocproc+0x32>
      goto found;

  release(&ptable.lock);
ffff8000001065bd:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff8000001065c4:	80 ff ff 
ffff8000001065c7:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001065ce:	80 ff ff 
ffff8000001065d1:	ff d0                	callq  *%rax
  return 0;
ffff8000001065d3:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001065d8:	e9 06 01 00 00       	jmpq   ffff8000001066e3 <allocproc+0x17b>
      goto found;
ffff8000001065dd:	90                   	nop
ffff8000001065de:	f3 0f 1e fa          	endbr64 

found:
  p->state = EMBRYO;
ffff8000001065e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001065e6:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%rax)
  p->pid = nextpid++;
ffff8000001065ed:	48 b8 40 d5 10 00 00 	movabs $0xffff80000010d540,%rax
ffff8000001065f4:	80 ff ff 
ffff8000001065f7:	8b 00                	mov    (%rax),%eax
ffff8000001065f9:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001065fc:	48 b9 40 d5 10 00 00 	movabs $0xffff80000010d540,%rcx
ffff800000106603:	80 ff ff 
ffff800000106606:	89 11                	mov    %edx,(%rcx)
ffff800000106608:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010660c:	89 42 1c             	mov    %eax,0x1c(%rdx)

  release(&ptable.lock);
ffff80000010660f:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff800000106616:	80 ff ff 
ffff800000106619:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000106620:	80 ff ff 
ffff800000106623:	ff d0                	callq  *%rax

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
ffff800000106625:	48 b8 66 42 10 00 00 	movabs $0xffff800000104266,%rax
ffff80000010662c:	80 ff ff 
ffff80000010662f:	ff d0                	callq  *%rax
ffff800000106631:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000106635:	48 89 42 10          	mov    %rax,0x10(%rdx)
ffff800000106639:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010663d:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000106641:	48 85 c0             	test   %rax,%rax
ffff800000106644:	75 15                	jne    ffff80000010665b <allocproc+0xf3>
    p->state = UNUSED;
ffff800000106646:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010664a:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
    return 0;
ffff800000106651:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106656:	e9 88 00 00 00       	jmpq   ffff8000001066e3 <allocproc+0x17b>
  }
  sp = p->kstack + KSTACKSIZE;
ffff80000010665b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010665f:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000106663:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff800000106669:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
ffff80000010666d:	48 81 6d f0 b0 00 00 	subq   $0xb0,-0x10(%rbp)
ffff800000106674:	00 
  p->tf = (struct trapframe*)sp;
ffff800000106675:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106679:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010667d:	48 89 50 28          	mov    %rdx,0x28(%rax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= sizeof(addr_t);
ffff800000106681:	48 83 6d f0 08       	subq   $0x8,-0x10(%rbp)
  *(addr_t*)sp = (addr_t)syscall_trapret;
ffff800000106686:	48 ba b7 99 10 00 00 	movabs $0xffff8000001099b7,%rdx
ffff80000010668d:	80 ff ff 
ffff800000106690:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106694:	48 89 10             	mov    %rdx,(%rax)

  sp -= sizeof *p->context;
ffff800000106697:	48 83 6d f0 38       	subq   $0x38,-0x10(%rbp)
  p->context = (struct context*)sp;
ffff80000010669c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001066a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001066a4:	48 89 50 30          	mov    %rdx,0x30(%rax)
  memset(p->context, 0, sizeof *p->context);
ffff8000001066a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001066ac:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff8000001066b0:	ba 38 00 00 00       	mov    $0x38,%edx
ffff8000001066b5:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001066ba:	48 89 c7             	mov    %rax,%rdi
ffff8000001066bd:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff8000001066c4:	80 ff ff 
ffff8000001066c7:	ff d0                	callq  *%rax
  p->context->rip = (addr_t)forkret;
ffff8000001066c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001066cd:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff8000001066d1:	48 ba e4 71 10 00 00 	movabs $0xffff8000001071e4,%rdx
ffff8000001066d8:	80 ff ff 
ffff8000001066db:	48 89 50 30          	mov    %rdx,0x30(%rax)

  return p;
ffff8000001066df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001066e3:	c9                   	leaveq 
ffff8000001066e4:	c3                   	retq   

ffff8000001066e5 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
ffff8000001066e5:	f3 0f 1e fa          	endbr64 
ffff8000001066e9:	55                   	push   %rbp
ffff8000001066ea:	48 89 e5             	mov    %rsp,%rbp
ffff8000001066ed:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  p = allocproc();
ffff8000001066f1:	48 b8 68 65 10 00 00 	movabs $0xffff800000106568,%rax
ffff8000001066f8:	80 ff ff 
ffff8000001066fb:	ff d0                	callq  *%rax
ffff8000001066fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  initproc = p;
ffff800000106701:	48 ba a8 ac 1f 00 00 	movabs $0xffff8000001faca8,%rdx
ffff800000106708:	80 ff ff 
ffff80000010670b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010670f:	48 89 02             	mov    %rax,(%rdx)
  if((p->pgdir = setupkvm()) == 0)
ffff800000106712:	48 b8 42 b2 10 00 00 	movabs $0xffff80000010b242,%rax
ffff800000106719:	80 ff ff 
ffff80000010671c:	ff d0                	callq  *%rax
ffff80000010671e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000106722:	48 89 42 08          	mov    %rax,0x8(%rdx)
ffff800000106726:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010672a:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010672e:	48 85 c0             	test   %rax,%rax
ffff800000106731:	75 16                	jne    ffff800000106749 <userinit+0x64>
    panic("userinit: out of memory?");
ffff800000106733:	48 bf d2 c7 10 00 00 	movabs $0xffff80000010c7d2,%rdi
ffff80000010673a:	80 ff ff 
ffff80000010673d:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000106744:	80 ff ff 
ffff800000106747:	ff d0                	callq  *%rax

  inituvm(p->pgdir, _binary_initcode_start,
ffff800000106749:	48 b8 3c 00 00 00 00 	movabs $0x3c,%rax
ffff800000106750:	00 00 00 
ffff800000106753:	89 c2                	mov    %eax,%edx
ffff800000106755:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106759:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010675d:	48 be 60 de 10 00 00 	movabs $0xffff80000010de60,%rsi
ffff800000106764:	80 ff ff 
ffff800000106767:	48 89 c7             	mov    %rax,%rdi
ffff80000010676a:	48 b8 ca b7 10 00 00 	movabs $0xffff80000010b7ca,%rax
ffff800000106771:	80 ff ff 
ffff800000106774:	ff d0                	callq  *%rax
          (addr_t)_binary_initcode_size);
  p->sz = PGSIZE * 2;
ffff800000106776:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010677a:	48 c7 00 00 20 00 00 	movq   $0x2000,(%rax)
  memset(p->tf, 0, sizeof(*p->tf));
ffff800000106781:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106785:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000106789:	ba b0 00 00 00       	mov    $0xb0,%edx
ffff80000010678e:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000106793:	48 89 c7             	mov    %rax,%rdi
ffff800000106796:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff80000010679d:	80 ff ff 
ffff8000001067a0:	ff d0                	callq  *%rax

  p->tf->r11 = FL_IF;  // with SYSRET, EFLAGS is in R11
ffff8000001067a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001067a6:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001067aa:	48 c7 40 50 00 02 00 	movq   $0x200,0x50(%rax)
ffff8000001067b1:	00 
  p->tf->rsp = p->sz;
ffff8000001067b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001067b6:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001067ba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001067be:	48 8b 12             	mov    (%rdx),%rdx
ffff8000001067c1:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
  p->tf->rcx = PGSIZE;  // with SYSRET, RIP is in RCX
ffff8000001067c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001067cc:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001067d0:	48 c7 40 10 00 10 00 	movq   $0x1000,0x10(%rax)
ffff8000001067d7:	00 

  safestrcpy(p->name, "initcode", sizeof(p->name));
ffff8000001067d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001067dc:	48 05 d0 00 00 00    	add    $0xd0,%rax
ffff8000001067e2:	ba 10 00 00 00       	mov    $0x10,%edx
ffff8000001067e7:	48 be eb c7 10 00 00 	movabs $0xffff80000010c7eb,%rsi
ffff8000001067ee:	80 ff ff 
ffff8000001067f1:	48 89 c7             	mov    %rax,%rdi
ffff8000001067f4:	48 b8 d3 7e 10 00 00 	movabs $0xffff800000107ed3,%rax
ffff8000001067fb:	80 ff ff 
ffff8000001067fe:	ff d0                	callq  *%rax
  p->cwd = namei("/");
ffff800000106800:	48 bf f4 c7 10 00 00 	movabs $0xffff80000010c7f4,%rdi
ffff800000106807:	80 ff ff 
ffff80000010680a:	48 b8 ff 37 10 00 00 	movabs $0xffff8000001037ff,%rax
ffff800000106811:	80 ff ff 
ffff800000106814:	ff d0                	callq  *%rax
ffff800000106816:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010681a:	48 89 82 c8 00 00 00 	mov    %rax,0xc8(%rdx)

  __sync_synchronize();
ffff800000106821:	0f ae f0             	mfence 
  p->state = RUNNABLE;
ffff800000106824:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106828:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
}
ffff80000010682f:	90                   	nop
ffff800000106830:	c9                   	leaveq 
ffff800000106831:	c3                   	retq   

ffff800000106832 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int64 n)
{
ffff800000106832:	f3 0f 1e fa          	endbr64 
ffff800000106836:	55                   	push   %rbp
ffff800000106837:	48 89 e5             	mov    %rsp,%rbp
ffff80000010683a:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010683e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  addr_t sz;

  sz = proc->sz;
ffff800000106842:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106849:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010684d:	48 8b 00             	mov    (%rax),%rax
ffff800000106850:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(n > 0){
ffff800000106854:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000106859:	7e 42                	jle    ffff80000010689d <growproc+0x6b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
ffff80000010685b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff80000010685f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106863:	48 01 c2             	add    %rax,%rdx
ffff800000106866:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010686d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106871:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000106875:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000106879:	48 89 ce             	mov    %rcx,%rsi
ffff80000010687c:	48 89 c7             	mov    %rax,%rdi
ffff80000010687f:	48 b8 aa b9 10 00 00 	movabs $0xffff80000010b9aa,%rax
ffff800000106886:	80 ff ff 
ffff800000106889:	ff d0                	callq  *%rax
ffff80000010688b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010688f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000106894:	75 50                	jne    ffff8000001068e6 <growproc+0xb4>
      return -1;
ffff800000106896:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010689b:	eb 7a                	jmp    ffff800000106917 <growproc+0xe5>
  } else if(n < 0){
ffff80000010689d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff8000001068a2:	79 42                	jns    ffff8000001068e6 <growproc+0xb4>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
ffff8000001068a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001068a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001068ac:	48 01 c2             	add    %rax,%rdx
ffff8000001068af:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001068b6:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001068ba:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff8000001068be:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff8000001068c2:	48 89 ce             	mov    %rcx,%rsi
ffff8000001068c5:	48 89 c7             	mov    %rax,%rdi
ffff8000001068c8:	48 b8 f2 ba 10 00 00 	movabs $0xffff80000010baf2,%rax
ffff8000001068cf:	80 ff ff 
ffff8000001068d2:	ff d0                	callq  *%rax
ffff8000001068d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001068d8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001068dd:	75 07                	jne    ffff8000001068e6 <growproc+0xb4>
      return -1;
ffff8000001068df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001068e4:	eb 31                	jmp    ffff800000106917 <growproc+0xe5>
  }
  proc->sz = sz;
ffff8000001068e6:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001068ed:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001068f1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001068f5:	48 89 10             	mov    %rdx,(%rax)
  switchuvm(proc);
ffff8000001068f8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001068ff:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106903:	48 89 c7             	mov    %rax,%rdi
ffff800000106906:	48 b8 a8 b3 10 00 00 	movabs $0xffff80000010b3a8,%rax
ffff80000010690d:	80 ff ff 
ffff800000106910:	ff d0                	callq  *%rax
  return 0;
ffff800000106912:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000106917:	c9                   	leaveq 
ffff800000106918:	c3                   	retq   

ffff800000106919 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
ffff800000106919:	f3 0f 1e fa          	endbr64 
ffff80000010691d:	55                   	push   %rbp
ffff80000010691e:	48 89 e5             	mov    %rsp,%rbp
ffff800000106921:	53                   	push   %rbx
ffff800000106922:	48 83 ec 28          	sub    $0x28,%rsp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
ffff800000106926:	48 b8 68 65 10 00 00 	movabs $0xffff800000106568,%rax
ffff80000010692d:	80 ff ff 
ffff800000106930:	ff d0                	callq  *%rax
ffff800000106932:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
ffff800000106936:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffff80000010693b:	75 0a                	jne    ffff800000106947 <fork+0x2e>
    return -1;
ffff80000010693d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000106942:	e9 85 02 00 00       	jmpq   ffff800000106bcc <fork+0x2b3>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
ffff800000106947:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010694e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106952:	48 8b 00             	mov    (%rax),%rax
ffff800000106955:	89 c2                	mov    %eax,%edx
ffff800000106957:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010695e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106962:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000106966:	89 d6                	mov    %edx,%esi
ffff800000106968:	48 89 c7             	mov    %rax,%rdi
ffff80000010696b:	48 b8 90 be 10 00 00 	movabs $0xffff80000010be90,%rax
ffff800000106972:	80 ff ff 
ffff800000106975:	ff d0                	callq  *%rax
ffff800000106977:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010697b:	48 89 42 08          	mov    %rax,0x8(%rdx)
ffff80000010697f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106983:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000106987:	48 85 c0             	test   %rax,%rax
ffff80000010698a:	75 38                	jne    ffff8000001069c4 <fork+0xab>
    krelease(np->kstack);
ffff80000010698c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106990:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000106994:	48 89 c7             	mov    %rax,%rdi
ffff800000106997:	48 b8 20 43 10 00 00 	movabs $0xffff800000104320,%rax
ffff80000010699e:	80 ff ff 
ffff8000001069a1:	ff d0                	callq  *%rax
    np->kstack = 0;
ffff8000001069a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001069a7:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff8000001069ae:	00 
    np->state = UNUSED;
ffff8000001069af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001069b3:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
    return -1;
ffff8000001069ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001069bf:	e9 08 02 00 00       	jmpq   ffff800000106bcc <fork+0x2b3>
  }
  np->sz = proc->sz;
ffff8000001069c4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001069cb:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001069cf:	48 8b 10             	mov    (%rax),%rdx
ffff8000001069d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001069d6:	48 89 10             	mov    %rdx,(%rax)
  np->parent = proc;
ffff8000001069d9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001069e0:	64 48 8b 10          	mov    %fs:(%rax),%rdx
ffff8000001069e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001069e8:	48 89 50 20          	mov    %rdx,0x20(%rax)
  *np->tf = *proc->tf;
ffff8000001069ec:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001069f3:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001069f7:	48 8b 50 28          	mov    0x28(%rax),%rdx
ffff8000001069fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001069ff:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000106a03:	48 8b 0a             	mov    (%rdx),%rcx
ffff800000106a06:	48 8b 5a 08          	mov    0x8(%rdx),%rbx
ffff800000106a0a:	48 89 08             	mov    %rcx,(%rax)
ffff800000106a0d:	48 89 58 08          	mov    %rbx,0x8(%rax)
ffff800000106a11:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
ffff800000106a15:	48 8b 5a 18          	mov    0x18(%rdx),%rbx
ffff800000106a19:	48 89 48 10          	mov    %rcx,0x10(%rax)
ffff800000106a1d:	48 89 58 18          	mov    %rbx,0x18(%rax)
ffff800000106a21:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
ffff800000106a25:	48 8b 5a 28          	mov    0x28(%rdx),%rbx
ffff800000106a29:	48 89 48 20          	mov    %rcx,0x20(%rax)
ffff800000106a2d:	48 89 58 28          	mov    %rbx,0x28(%rax)
ffff800000106a31:	48 8b 4a 30          	mov    0x30(%rdx),%rcx
ffff800000106a35:	48 8b 5a 38          	mov    0x38(%rdx),%rbx
ffff800000106a39:	48 89 48 30          	mov    %rcx,0x30(%rax)
ffff800000106a3d:	48 89 58 38          	mov    %rbx,0x38(%rax)
ffff800000106a41:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
ffff800000106a45:	48 8b 5a 48          	mov    0x48(%rdx),%rbx
ffff800000106a49:	48 89 48 40          	mov    %rcx,0x40(%rax)
ffff800000106a4d:	48 89 58 48          	mov    %rbx,0x48(%rax)
ffff800000106a51:	48 8b 4a 50          	mov    0x50(%rdx),%rcx
ffff800000106a55:	48 8b 5a 58          	mov    0x58(%rdx),%rbx
ffff800000106a59:	48 89 48 50          	mov    %rcx,0x50(%rax)
ffff800000106a5d:	48 89 58 58          	mov    %rbx,0x58(%rax)
ffff800000106a61:	48 8b 4a 60          	mov    0x60(%rdx),%rcx
ffff800000106a65:	48 8b 5a 68          	mov    0x68(%rdx),%rbx
ffff800000106a69:	48 89 48 60          	mov    %rcx,0x60(%rax)
ffff800000106a6d:	48 89 58 68          	mov    %rbx,0x68(%rax)
ffff800000106a71:	48 8b 4a 70          	mov    0x70(%rdx),%rcx
ffff800000106a75:	48 8b 5a 78          	mov    0x78(%rdx),%rbx
ffff800000106a79:	48 89 48 70          	mov    %rcx,0x70(%rax)
ffff800000106a7d:	48 89 58 78          	mov    %rbx,0x78(%rax)
ffff800000106a81:	48 8b 8a 80 00 00 00 	mov    0x80(%rdx),%rcx
ffff800000106a88:	48 8b 9a 88 00 00 00 	mov    0x88(%rdx),%rbx
ffff800000106a8f:	48 89 88 80 00 00 00 	mov    %rcx,0x80(%rax)
ffff800000106a96:	48 89 98 88 00 00 00 	mov    %rbx,0x88(%rax)
ffff800000106a9d:	48 8b 8a 90 00 00 00 	mov    0x90(%rdx),%rcx
ffff800000106aa4:	48 8b 9a 98 00 00 00 	mov    0x98(%rdx),%rbx
ffff800000106aab:	48 89 88 90 00 00 00 	mov    %rcx,0x90(%rax)
ffff800000106ab2:	48 89 98 98 00 00 00 	mov    %rbx,0x98(%rax)
ffff800000106ab9:	48 8b 8a a0 00 00 00 	mov    0xa0(%rdx),%rcx
ffff800000106ac0:	48 8b 9a a8 00 00 00 	mov    0xa8(%rdx),%rbx
ffff800000106ac7:	48 89 88 a0 00 00 00 	mov    %rcx,0xa0(%rax)
ffff800000106ace:	48 89 98 a8 00 00 00 	mov    %rbx,0xa8(%rax)

  // Clear %rax so that fork returns 0 in the child.
  np->tf->rax = 0;
ffff800000106ad5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106ad9:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000106add:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

  for(i = 0; i < NOFILE; i++)
ffff800000106ae4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
ffff800000106aeb:	eb 5f                	jmp    ffff800000106b4c <fork+0x233>
    if(proc->ofile[i])
ffff800000106aed:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106af4:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106af8:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff800000106afb:	48 63 d2             	movslq %edx,%rdx
ffff800000106afe:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106b02:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff800000106b07:	48 85 c0             	test   %rax,%rax
ffff800000106b0a:	74 3c                	je     ffff800000106b48 <fork+0x22f>
      np->ofile[i] = filedup(proc->ofile[i]);
ffff800000106b0c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106b13:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106b17:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff800000106b1a:	48 63 d2             	movslq %edx,%rdx
ffff800000106b1d:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106b21:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff800000106b26:	48 89 c7             	mov    %rax,%rdi
ffff800000106b29:	48 b8 1a 1c 10 00 00 	movabs $0xffff800000101c1a,%rax
ffff800000106b30:	80 ff ff 
ffff800000106b33:	ff d0                	callq  *%rax
ffff800000106b35:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000106b39:	8b 4d ec             	mov    -0x14(%rbp),%ecx
ffff800000106b3c:	48 63 c9             	movslq %ecx,%rcx
ffff800000106b3f:	48 83 c1 08          	add    $0x8,%rcx
ffff800000106b43:	48 89 44 ca 08       	mov    %rax,0x8(%rdx,%rcx,8)
  for(i = 0; i < NOFILE; i++)
ffff800000106b48:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
ffff800000106b4c:	83 7d ec 0f          	cmpl   $0xf,-0x14(%rbp)
ffff800000106b50:	7e 9b                	jle    ffff800000106aed <fork+0x1d4>
  np->cwd = idup(proc->cwd);
ffff800000106b52:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106b59:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106b5d:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff800000106b64:	48 89 c7             	mov    %rax,%rdi
ffff800000106b67:	48 b8 95 28 10 00 00 	movabs $0xffff800000102895,%rax
ffff800000106b6e:	80 ff ff 
ffff800000106b71:	ff d0                	callq  *%rax
ffff800000106b73:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000106b77:	48 89 82 c8 00 00 00 	mov    %rax,0xc8(%rdx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
ffff800000106b7e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106b85:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106b89:	48 8d 88 d0 00 00 00 	lea    0xd0(%rax),%rcx
ffff800000106b90:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106b94:	48 05 d0 00 00 00    	add    $0xd0,%rax
ffff800000106b9a:	ba 10 00 00 00       	mov    $0x10,%edx
ffff800000106b9f:	48 89 ce             	mov    %rcx,%rsi
ffff800000106ba2:	48 89 c7             	mov    %rax,%rdi
ffff800000106ba5:	48 b8 d3 7e 10 00 00 	movabs $0xffff800000107ed3,%rax
ffff800000106bac:	80 ff ff 
ffff800000106baf:	ff d0                	callq  *%rax

  pid = np->pid;
ffff800000106bb1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106bb5:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000106bb8:	89 45 dc             	mov    %eax,-0x24(%rbp)

  __sync_synchronize();
ffff800000106bbb:	0f ae f0             	mfence 
  np->state = RUNNABLE;
ffff800000106bbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106bc2:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)

  return pid;
ffff800000106bc9:	8b 45 dc             	mov    -0x24(%rbp),%eax
}
ffff800000106bcc:	48 83 c4 28          	add    $0x28,%rsp
ffff800000106bd0:	5b                   	pop    %rbx
ffff800000106bd1:	5d                   	pop    %rbp
ffff800000106bd2:	c3                   	retq   

ffff800000106bd3 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
ffff800000106bd3:	f3 0f 1e fa          	endbr64 
ffff800000106bd7:	55                   	push   %rbp
ffff800000106bd8:	48 89 e5             	mov    %rsp,%rbp
ffff800000106bdb:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  int fd;

  if(proc == initproc)
ffff800000106bdf:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106be6:	64 48 8b 10          	mov    %fs:(%rax),%rdx
ffff800000106bea:	48 b8 a8 ac 1f 00 00 	movabs $0xffff8000001faca8,%rax
ffff800000106bf1:	80 ff ff 
ffff800000106bf4:	48 8b 00             	mov    (%rax),%rax
ffff800000106bf7:	48 39 c2             	cmp    %rax,%rdx
ffff800000106bfa:	75 16                	jne    ffff800000106c12 <exit+0x3f>
    panic("init exiting");
ffff800000106bfc:	48 bf f6 c7 10 00 00 	movabs $0xffff80000010c7f6,%rdi
ffff800000106c03:	80 ff ff 
ffff800000106c06:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000106c0d:	80 ff ff 
ffff800000106c10:	ff d0                	callq  *%rax

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
ffff800000106c12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
ffff800000106c19:	eb 6a                	jmp    ffff800000106c85 <exit+0xb2>
    if(proc->ofile[fd]){
ffff800000106c1b:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106c22:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106c26:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000106c29:	48 63 d2             	movslq %edx,%rdx
ffff800000106c2c:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106c30:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff800000106c35:	48 85 c0             	test   %rax,%rax
ffff800000106c38:	74 47                	je     ffff800000106c81 <exit+0xae>
      fileclose(proc->ofile[fd]);
ffff800000106c3a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106c41:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106c45:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000106c48:	48 63 d2             	movslq %edx,%rdx
ffff800000106c4b:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106c4f:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff800000106c54:	48 89 c7             	mov    %rax,%rdi
ffff800000106c57:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff800000106c5e:	80 ff ff 
ffff800000106c61:	ff d0                	callq  *%rax
      proc->ofile[fd] = 0;
ffff800000106c63:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106c6a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106c6e:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000106c71:	48 63 d2             	movslq %edx,%rdx
ffff800000106c74:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106c78:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
ffff800000106c7f:	00 00 
  for(fd = 0; fd < NOFILE; fd++){
ffff800000106c81:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
ffff800000106c85:	83 7d f4 0f          	cmpl   $0xf,-0xc(%rbp)
ffff800000106c89:	7e 90                	jle    ffff800000106c1b <exit+0x48>
    }
  }

  begin_op();
ffff800000106c8b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106c90:	48 ba ab 52 10 00 00 	movabs $0xffff8000001052ab,%rdx
ffff800000106c97:	80 ff ff 
ffff800000106c9a:	ff d2                	callq  *%rdx
  iput(proc->cwd);
ffff800000106c9c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106ca3:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106ca7:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff800000106cae:	48 89 c7             	mov    %rax,%rdi
ffff800000106cb1:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff800000106cb8:	80 ff ff 
ffff800000106cbb:	ff d0                	callq  *%rax
  end_op();
ffff800000106cbd:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106cc2:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff800000106cc9:	80 ff ff 
ffff800000106ccc:	ff d2                	callq  *%rdx
  proc->cwd = 0;
ffff800000106cce:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106cd5:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106cd9:	48 c7 80 c8 00 00 00 	movq   $0x0,0xc8(%rax)
ffff800000106ce0:	00 00 00 00 

  acquire(&ptable.lock);
ffff800000106ce4:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff800000106ceb:	80 ff ff 
ffff800000106cee:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000106cf5:	80 ff ff 
ffff800000106cf8:	ff d0                	callq  *%rax

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
ffff800000106cfa:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106d01:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106d05:	48 8b 40 20          	mov    0x20(%rax),%rax
ffff800000106d09:	48 89 c7             	mov    %rax,%rdi
ffff800000106d0c:	48 b8 57 73 10 00 00 	movabs $0xffff800000107357,%rax
ffff800000106d13:	80 ff ff 
ffff800000106d16:	ff d0                	callq  *%rax

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106d18:	48 b8 a8 74 1f 00 00 	movabs $0xffff8000001f74a8,%rax
ffff800000106d1f:	80 ff ff 
ffff800000106d22:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000106d26:	eb 5d                	jmp    ffff800000106d85 <exit+0x1b2>
    if(p->parent == proc){
ffff800000106d28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106d2c:	48 8b 50 20          	mov    0x20(%rax),%rdx
ffff800000106d30:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106d37:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106d3b:	48 39 c2             	cmp    %rax,%rdx
ffff800000106d3e:	75 3d                	jne    ffff800000106d7d <exit+0x1aa>
      p->parent = initproc;
ffff800000106d40:	48 b8 a8 ac 1f 00 00 	movabs $0xffff8000001faca8,%rax
ffff800000106d47:	80 ff ff 
ffff800000106d4a:	48 8b 10             	mov    (%rax),%rdx
ffff800000106d4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106d51:	48 89 50 20          	mov    %rdx,0x20(%rax)
      if(p->state == ZOMBIE)
ffff800000106d55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106d59:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106d5c:	83 f8 05             	cmp    $0x5,%eax
ffff800000106d5f:	75 1c                	jne    ffff800000106d7d <exit+0x1aa>
        wakeup1(initproc);
ffff800000106d61:	48 b8 a8 ac 1f 00 00 	movabs $0xffff8000001faca8,%rax
ffff800000106d68:	80 ff ff 
ffff800000106d6b:	48 8b 00             	mov    (%rax),%rax
ffff800000106d6e:	48 89 c7             	mov    %rax,%rdi
ffff800000106d71:	48 b8 57 73 10 00 00 	movabs $0xffff800000107357,%rax
ffff800000106d78:	80 ff ff 
ffff800000106d7b:	ff d0                	callq  *%rax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106d7d:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffff800000106d84:	00 
ffff800000106d85:	48 b8 a8 ac 1f 00 00 	movabs $0xffff8000001faca8,%rax
ffff800000106d8c:	80 ff ff 
ffff800000106d8f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000106d93:	72 93                	jb     ffff800000106d28 <exit+0x155>
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
ffff800000106d95:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106d9c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106da0:	c7 40 18 05 00 00 00 	movl   $0x5,0x18(%rax)
  sched();
ffff800000106da7:	48 b8 80 70 10 00 00 	movabs $0xffff800000107080,%rax
ffff800000106dae:	80 ff ff 
ffff800000106db1:	ff d0                	callq  *%rax
  panic("zombie exit");
ffff800000106db3:	48 bf 03 c8 10 00 00 	movabs $0xffff80000010c803,%rdi
ffff800000106dba:	80 ff ff 
ffff800000106dbd:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000106dc4:	80 ff ff 
ffff800000106dc7:	ff d0                	callq  *%rax

ffff800000106dc9 <wait>:
//PAGEBREAK!
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
ffff800000106dc9:	f3 0f 1e fa          	endbr64 
ffff800000106dcd:	55                   	push   %rbp
ffff800000106dce:	48 89 e5             	mov    %rsp,%rbp
ffff800000106dd1:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
ffff800000106dd5:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff800000106ddc:	80 ff ff 
ffff800000106ddf:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000106de6:	80 ff ff 
ffff800000106de9:	ff d0                	callq  *%rax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
ffff800000106deb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106df2:	48 b8 a8 74 1f 00 00 	movabs $0xffff8000001f74a8,%rax
ffff800000106df9:	80 ff ff 
ffff800000106dfc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000106e00:	e9 d3 00 00 00       	jmpq   ffff800000106ed8 <wait+0x10f>
      if(p->parent != proc)
ffff800000106e05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106e09:	48 8b 50 20          	mov    0x20(%rax),%rdx
ffff800000106e0d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106e14:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106e18:	48 39 c2             	cmp    %rax,%rdx
ffff800000106e1b:	0f 85 ae 00 00 00    	jne    ffff800000106ecf <wait+0x106>
        continue;
      havekids = 1;
ffff800000106e21:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)
      if(p->state == ZOMBIE){
ffff800000106e28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106e2c:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106e2f:	83 f8 05             	cmp    $0x5,%eax
ffff800000106e32:	0f 85 98 00 00 00    	jne    ffff800000106ed0 <wait+0x107>
        // Found one.
        pid = p->pid;
ffff800000106e38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106e3c:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000106e3f:	89 45 f0             	mov    %eax,-0x10(%rbp)
        krelease(p->kstack);
ffff800000106e42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106e46:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000106e4a:	48 89 c7             	mov    %rax,%rdi
ffff800000106e4d:	48 b8 20 43 10 00 00 	movabs $0xffff800000104320,%rax
ffff800000106e54:	80 ff ff 
ffff800000106e57:	ff d0                	callq  *%rax
        p->kstack = 0;
ffff800000106e59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106e5d:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff800000106e64:	00 
        freevm(p->pgdir);
ffff800000106e65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106e69:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000106e6d:	48 89 c7             	mov    %rax,%rdi
ffff800000106e70:	48 b8 ec bb 10 00 00 	movabs $0xffff80000010bbec,%rax
ffff800000106e77:	80 ff ff 
ffff800000106e7a:	ff d0                	callq  *%rax
        p->pid = 0;
ffff800000106e7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106e80:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%rax)
        p->parent = 0;
ffff800000106e87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106e8b:	48 c7 40 20 00 00 00 	movq   $0x0,0x20(%rax)
ffff800000106e92:	00 
        p->name[0] = 0;
ffff800000106e93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106e97:	c6 80 d0 00 00 00 00 	movb   $0x0,0xd0(%rax)
        p->killed = 0;
ffff800000106e9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106ea2:	c7 40 40 00 00 00 00 	movl   $0x0,0x40(%rax)
        p->state = UNUSED;
ffff800000106ea9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106ead:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
        release(&ptable.lock);
ffff800000106eb4:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff800000106ebb:	80 ff ff 
ffff800000106ebe:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000106ec5:	80 ff ff 
ffff800000106ec8:	ff d0                	callq  *%rax
        return pid;
ffff800000106eca:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000106ecd:	eb 7b                	jmp    ffff800000106f4a <wait+0x181>
        continue;
ffff800000106ecf:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106ed0:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffff800000106ed7:	00 
ffff800000106ed8:	48 b8 a8 ac 1f 00 00 	movabs $0xffff8000001faca8,%rax
ffff800000106edf:	80 ff ff 
ffff800000106ee2:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000106ee6:	0f 82 19 ff ff ff    	jb     ffff800000106e05 <wait+0x3c>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
ffff800000106eec:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff800000106ef0:	74 12                	je     ffff800000106f04 <wait+0x13b>
ffff800000106ef2:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106ef9:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106efd:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000106f00:	85 c0                	test   %eax,%eax
ffff800000106f02:	74 1d                	je     ffff800000106f21 <wait+0x158>
      release(&ptable.lock);
ffff800000106f04:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff800000106f0b:	80 ff ff 
ffff800000106f0e:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000106f15:	80 ff ff 
ffff800000106f18:	ff d0                	callq  *%rax
      return -1;
ffff800000106f1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000106f1f:	eb 29                	jmp    ffff800000106f4a <wait+0x181>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
ffff800000106f21:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106f28:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106f2c:	48 be 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rsi
ffff800000106f33:	80 ff ff 
ffff800000106f36:	48 89 c7             	mov    %rax,%rdi
ffff800000106f39:	48 b8 47 72 10 00 00 	movabs $0xffff800000107247,%rax
ffff800000106f40:	80 ff ff 
ffff800000106f43:	ff d0                	callq  *%rax
    havekids = 0;
ffff800000106f45:	e9 a1 fe ff ff       	jmpq   ffff800000106deb <wait+0x22>
  }
}
ffff800000106f4a:	c9                   	leaveq 
ffff800000106f4b:	c3                   	retq   

ffff800000106f4c <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
ffff800000106f4c:	f3 0f 1e fa          	endbr64 
ffff800000106f50:	55                   	push   %rbp
ffff800000106f51:	48 89 e5             	mov    %rsp,%rbp
ffff800000106f54:	48 83 ec 20          	sub    $0x20,%rsp
  int i = 0;
ffff800000106f58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  struct proc *p;
  int skipped = 0;
ffff800000106f5f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  for(;;){
    ++i;
ffff800000106f66:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    // Enable interrupts on this processor.
    sti();
ffff800000106f6a:	48 b8 25 65 10 00 00 	movabs $0xffff800000106525,%rax
ffff800000106f71:	80 ff ff 
ffff800000106f74:	ff d0                	callq  *%rax
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
ffff800000106f76:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff800000106f7d:	80 ff ff 
ffff800000106f80:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000106f87:	80 ff ff 
ffff800000106f8a:	ff d0                	callq  *%rax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106f8c:	48 b8 a8 74 1f 00 00 	movabs $0xffff8000001f74a8,%rax
ffff800000106f93:	80 ff ff 
ffff800000106f96:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000106f9a:	e9 92 00 00 00       	jmpq   ffff800000107031 <scheduler+0xe5>
      if(p->state != RUNNABLE) {
ffff800000106f9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106fa3:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106fa6:	83 f8 03             	cmp    $0x3,%eax
ffff800000106fa9:	74 06                	je     ffff800000106fb1 <scheduler+0x65>
        skipped++;
ffff800000106fab:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
        continue;
ffff800000106faf:	eb 78                	jmp    ffff800000107029 <scheduler+0xdd>
      }
      skipped = 0;
ffff800000106fb1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
ffff800000106fb8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106fbf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000106fc3:	64 48 89 10          	mov    %rdx,%fs:(%rax)
      switchuvm(p);
ffff800000106fc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106fcb:	48 89 c7             	mov    %rax,%rdi
ffff800000106fce:	48 b8 a8 b3 10 00 00 	movabs $0xffff80000010b3a8,%rax
ffff800000106fd5:	80 ff ff 
ffff800000106fd8:	ff d0                	callq  *%rax
      p->state = RUNNING;
ffff800000106fda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106fde:	c7 40 18 04 00 00 00 	movl   $0x4,0x18(%rax)
      swtch(&cpu->scheduler, p->context);
ffff800000106fe5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106fe9:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff800000106fed:	48 c7 c2 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rdx
ffff800000106ff4:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffff800000106ff8:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106ffc:	48 89 c6             	mov    %rax,%rsi
ffff800000106fff:	48 89 d7             	mov    %rdx,%rdi
ffff800000107002:	48 b8 6f 7f 10 00 00 	movabs $0xffff800000107f6f,%rax
ffff800000107009:	80 ff ff 
ffff80000010700c:	ff d0                	callq  *%rax
      switchkvm();
ffff80000010700e:	48 b8 b9 b6 10 00 00 	movabs $0xffff80000010b6b9,%rax
ffff800000107015:	80 ff ff 
ffff800000107018:	ff d0                	callq  *%rax

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
ffff80000010701a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107021:	64 48 c7 00 00 00 00 	movq   $0x0,%fs:(%rax)
ffff800000107028:	00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000107029:	48 81 45 f0 e0 00 00 	addq   $0xe0,-0x10(%rbp)
ffff800000107030:	00 
ffff800000107031:	48 b8 a8 ac 1f 00 00 	movabs $0xffff8000001faca8,%rax
ffff800000107038:	80 ff ff 
ffff80000010703b:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff80000010703f:	0f 82 5a ff ff ff    	jb     ffff800000106f9f <scheduler+0x53>
    }
    release(&ptable.lock);
ffff800000107045:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff80000010704c:	80 ff ff 
ffff80000010704f:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000107056:	80 ff ff 
ffff800000107059:	ff d0                	callq  *%rax
    if (skipped > (2*NPROC)) {
ffff80000010705b:	81 7d ec 80 00 00 00 	cmpl   $0x80,-0x14(%rbp)
ffff800000107062:	0f 8e fe fe ff ff    	jle    ffff800000106f66 <scheduler+0x1a>
      hlt();
ffff800000107068:	48 b8 31 65 10 00 00 	movabs $0xffff800000106531,%rax
ffff80000010706f:	80 ff ff 
ffff800000107072:	ff d0                	callq  *%rax
      skipped = 0;
ffff800000107074:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    ++i;
ffff80000010707b:	e9 e6 fe ff ff       	jmpq   ffff800000106f66 <scheduler+0x1a>

ffff800000107080 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
ffff800000107080:	f3 0f 1e fa          	endbr64 
ffff800000107084:	55                   	push   %rbp
ffff800000107085:	48 89 e5             	mov    %rsp,%rbp
ffff800000107088:	48 83 ec 10          	sub    $0x10,%rsp
  int intena;


  if(!holding(&ptable.lock))
ffff80000010708c:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff800000107093:	80 ff ff 
ffff800000107096:	48 b8 45 7a 10 00 00 	movabs $0xffff800000107a45,%rax
ffff80000010709d:	80 ff ff 
ffff8000001070a0:	ff d0                	callq  *%rax
ffff8000001070a2:	85 c0                	test   %eax,%eax
ffff8000001070a4:	75 16                	jne    ffff8000001070bc <sched+0x3c>
    panic("sched ptable.lock");
ffff8000001070a6:	48 bf 0f c8 10 00 00 	movabs $0xffff80000010c80f,%rdi
ffff8000001070ad:	80 ff ff 
ffff8000001070b0:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001070b7:	80 ff ff 
ffff8000001070ba:	ff d0                	callq  *%rax
  if(cpu->ncli != 1)
ffff8000001070bc:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff8000001070c3:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001070c7:	8b 40 14             	mov    0x14(%rax),%eax
ffff8000001070ca:	83 f8 01             	cmp    $0x1,%eax
ffff8000001070cd:	74 16                	je     ffff8000001070e5 <sched+0x65>
    panic("sched locks");
ffff8000001070cf:	48 bf 21 c8 10 00 00 	movabs $0xffff80000010c821,%rdi
ffff8000001070d6:	80 ff ff 
ffff8000001070d9:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001070e0:	80 ff ff 
ffff8000001070e3:	ff d0                	callq  *%rax
  if(proc->state == RUNNING)
ffff8000001070e5:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001070ec:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001070f0:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001070f3:	83 f8 04             	cmp    $0x4,%eax
ffff8000001070f6:	75 16                	jne    ffff80000010710e <sched+0x8e>
    panic("sched running");
ffff8000001070f8:	48 bf 2d c8 10 00 00 	movabs $0xffff80000010c82d,%rdi
ffff8000001070ff:	80 ff ff 
ffff800000107102:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000107109:	80 ff ff 
ffff80000010710c:	ff d0                	callq  *%rax
  if(readeflags()&FL_IF)
ffff80000010710e:	48 b8 0d 65 10 00 00 	movabs $0xffff80000010650d,%rax
ffff800000107115:	80 ff ff 
ffff800000107118:	ff d0                	callq  *%rax
ffff80000010711a:	25 00 02 00 00       	and    $0x200,%eax
ffff80000010711f:	48 85 c0             	test   %rax,%rax
ffff800000107122:	74 16                	je     ffff80000010713a <sched+0xba>
    panic("sched interruptible");
ffff800000107124:	48 bf 3b c8 10 00 00 	movabs $0xffff80000010c83b,%rdi
ffff80000010712b:	80 ff ff 
ffff80000010712e:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000107135:	80 ff ff 
ffff800000107138:	ff d0                	callq  *%rax
  intena = cpu->intena;
ffff80000010713a:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107141:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107145:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000107148:	89 45 fc             	mov    %eax,-0x4(%rbp)

  swtch(&proc->context, cpu->scheduler);
ffff80000010714b:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107152:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107156:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010715a:	48 c7 c2 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rdx
ffff800000107161:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffff800000107165:	48 83 c2 30          	add    $0x30,%rdx
ffff800000107169:	48 89 c6             	mov    %rax,%rsi
ffff80000010716c:	48 89 d7             	mov    %rdx,%rdi
ffff80000010716f:	48 b8 6f 7f 10 00 00 	movabs $0xffff800000107f6f,%rax
ffff800000107176:	80 ff ff 
ffff800000107179:	ff d0                	callq  *%rax
  cpu->intena = intena;
ffff80000010717b:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107182:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107186:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000107189:	89 50 18             	mov    %edx,0x18(%rax)
}
ffff80000010718c:	90                   	nop
ffff80000010718d:	c9                   	leaveq 
ffff80000010718e:	c3                   	retq   

ffff80000010718f <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
ffff80000010718f:	f3 0f 1e fa          	endbr64 
ffff800000107193:	55                   	push   %rbp
ffff800000107194:	48 89 e5             	mov    %rsp,%rbp
  acquire(&ptable.lock);  //DOC: yieldlock
ffff800000107197:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff80000010719e:	80 ff ff 
ffff8000001071a1:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff8000001071a8:	80 ff ff 
ffff8000001071ab:	ff d0                	callq  *%rax
  proc->state = RUNNABLE;
ffff8000001071ad:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001071b4:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001071b8:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
  sched();
ffff8000001071bf:	48 b8 80 70 10 00 00 	movabs $0xffff800000107080,%rax
ffff8000001071c6:	80 ff ff 
ffff8000001071c9:	ff d0                	callq  *%rax
  release(&ptable.lock);
ffff8000001071cb:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff8000001071d2:	80 ff ff 
ffff8000001071d5:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001071dc:	80 ff ff 
ffff8000001071df:	ff d0                	callq  *%rax
}
ffff8000001071e1:	90                   	nop
ffff8000001071e2:	5d                   	pop    %rbp
ffff8000001071e3:	c3                   	retq   

ffff8000001071e4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
ffff8000001071e4:	f3 0f 1e fa          	endbr64 
ffff8000001071e8:	55                   	push   %rbp
ffff8000001071e9:	48 89 e5             	mov    %rsp,%rbp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
ffff8000001071ec:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff8000001071f3:	80 ff ff 
ffff8000001071f6:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001071fd:	80 ff ff 
ffff800000107200:	ff d0                	callq  *%rax

  if (first) {
ffff800000107202:	48 b8 44 d5 10 00 00 	movabs $0xffff80000010d544,%rax
ffff800000107209:	80 ff ff 
ffff80000010720c:	8b 00                	mov    (%rax),%eax
ffff80000010720e:	85 c0                	test   %eax,%eax
ffff800000107210:	74 32                	je     ffff800000107244 <forkret+0x60>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
ffff800000107212:	48 b8 44 d5 10 00 00 	movabs $0xffff80000010d544,%rax
ffff800000107219:	80 ff ff 
ffff80000010721c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    iinit(ROOTDEV);
ffff800000107222:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000107227:	48 b8 6e 24 10 00 00 	movabs $0xffff80000010246e,%rax
ffff80000010722e:	80 ff ff 
ffff800000107231:	ff d0                	callq  *%rax
    initlog(ROOTDEV);
ffff800000107233:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000107238:	48 b8 50 4f 10 00 00 	movabs $0xffff800000104f50,%rax
ffff80000010723f:	80 ff ff 
ffff800000107242:	ff d0                	callq  *%rax
  }

  // Return to "caller", actually trapret (see allocproc).
}
ffff800000107244:	90                   	nop
ffff800000107245:	5d                   	pop    %rbp
ffff800000107246:	c3                   	retq   

ffff800000107247 <sleep>:
//PAGEBREAK!
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
ffff800000107247:	f3 0f 1e fa          	endbr64 
ffff80000010724b:	55                   	push   %rbp
ffff80000010724c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010724f:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107253:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107257:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(proc == 0)
ffff80000010725b:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107262:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107266:	48 85 c0             	test   %rax,%rax
ffff800000107269:	75 16                	jne    ffff800000107281 <sleep+0x3a>
    panic("sleep");
ffff80000010726b:	48 bf 4f c8 10 00 00 	movabs $0xffff80000010c84f,%rdi
ffff800000107272:	80 ff ff 
ffff800000107275:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010727c:	80 ff ff 
ffff80000010727f:	ff d0                	callq  *%rax

  if(lk == 0)
ffff800000107281:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000107286:	75 16                	jne    ffff80000010729e <sleep+0x57>
    panic("sleep without lk");
ffff800000107288:	48 bf 55 c8 10 00 00 	movabs $0xffff80000010c855,%rdi
ffff80000010728f:	80 ff ff 
ffff800000107292:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000107299:	80 ff ff 
ffff80000010729c:	ff d0                	callq  *%rax
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
ffff80000010729e:	48 b8 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rax
ffff8000001072a5:	80 ff ff 
ffff8000001072a8:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff8000001072ac:	74 29                	je     ffff8000001072d7 <sleep+0x90>
    acquire(&ptable.lock);  //DOC: sleeplock1
ffff8000001072ae:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff8000001072b5:	80 ff ff 
ffff8000001072b8:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff8000001072bf:	80 ff ff 
ffff8000001072c2:	ff d0                	callq  *%rax
    release(lk);
ffff8000001072c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001072c8:	48 89 c7             	mov    %rax,%rdi
ffff8000001072cb:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001072d2:	80 ff ff 
ffff8000001072d5:	ff d0                	callq  *%rax
  }

  // Go to sleep.
  proc->chan = chan;
ffff8000001072d7:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001072de:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001072e2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001072e6:	48 89 50 38          	mov    %rdx,0x38(%rax)
  proc->state = SLEEPING;
ffff8000001072ea:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001072f1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001072f5:	c7 40 18 02 00 00 00 	movl   $0x2,0x18(%rax)
  sched();
ffff8000001072fc:	48 b8 80 70 10 00 00 	movabs $0xffff800000107080,%rax
ffff800000107303:	80 ff ff 
ffff800000107306:	ff d0                	callq  *%rax

  // Tidy up.
  proc->chan = 0;
ffff800000107308:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010730f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107313:	48 c7 40 38 00 00 00 	movq   $0x0,0x38(%rax)
ffff80000010731a:	00 

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
ffff80000010731b:	48 b8 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rax
ffff800000107322:	80 ff ff 
ffff800000107325:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff800000107329:	74 29                	je     ffff800000107354 <sleep+0x10d>
    release(&ptable.lock);
ffff80000010732b:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff800000107332:	80 ff ff 
ffff800000107335:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff80000010733c:	80 ff ff 
ffff80000010733f:	ff d0                	callq  *%rax
    acquire(lk);
ffff800000107341:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107345:	48 89 c7             	mov    %rax,%rdi
ffff800000107348:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff80000010734f:	80 ff ff 
ffff800000107352:	ff d0                	callq  *%rax
  }
}
ffff800000107354:	90                   	nop
ffff800000107355:	c9                   	leaveq 
ffff800000107356:	c3                   	retq   

ffff800000107357 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
ffff800000107357:	f3 0f 1e fa          	endbr64 
ffff80000010735b:	55                   	push   %rbp
ffff80000010735c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010735f:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000107363:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff800000107367:	48 b8 a8 74 1f 00 00 	movabs $0xffff8000001f74a8,%rax
ffff80000010736e:	80 ff ff 
ffff800000107371:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000107375:	eb 2d                	jmp    ffff8000001073a4 <wakeup1+0x4d>
    if(p->state == SLEEPING && p->chan == chan)
ffff800000107377:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010737b:	8b 40 18             	mov    0x18(%rax),%eax
ffff80000010737e:	83 f8 02             	cmp    $0x2,%eax
ffff800000107381:	75 19                	jne    ffff80000010739c <wakeup1+0x45>
ffff800000107383:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107387:	48 8b 40 38          	mov    0x38(%rax),%rax
ffff80000010738b:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff80000010738f:	75 0b                	jne    ffff80000010739c <wakeup1+0x45>
      p->state = RUNNABLE;
ffff800000107391:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107395:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff80000010739c:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffff8000001073a3:	00 
ffff8000001073a4:	48 b8 a8 ac 1f 00 00 	movabs $0xffff8000001faca8,%rax
ffff8000001073ab:	80 ff ff 
ffff8000001073ae:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001073b2:	72 c3                	jb     ffff800000107377 <wakeup1+0x20>
}
ffff8000001073b4:	90                   	nop
ffff8000001073b5:	90                   	nop
ffff8000001073b6:	c9                   	leaveq 
ffff8000001073b7:	c3                   	retq   

ffff8000001073b8 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
ffff8000001073b8:	f3 0f 1e fa          	endbr64 
ffff8000001073bc:	55                   	push   %rbp
ffff8000001073bd:	48 89 e5             	mov    %rsp,%rbp
ffff8000001073c0:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001073c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&ptable.lock);
ffff8000001073c8:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff8000001073cf:	80 ff ff 
ffff8000001073d2:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff8000001073d9:	80 ff ff 
ffff8000001073dc:	ff d0                	callq  *%rax
  wakeup1(chan);
ffff8000001073de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001073e2:	48 89 c7             	mov    %rax,%rdi
ffff8000001073e5:	48 b8 57 73 10 00 00 	movabs $0xffff800000107357,%rax
ffff8000001073ec:	80 ff ff 
ffff8000001073ef:	ff d0                	callq  *%rax
  release(&ptable.lock);
ffff8000001073f1:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff8000001073f8:	80 ff ff 
ffff8000001073fb:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000107402:	80 ff ff 
ffff800000107405:	ff d0                	callq  *%rax
}
ffff800000107407:	90                   	nop
ffff800000107408:	c9                   	leaveq 
ffff800000107409:	c3                   	retq   

ffff80000010740a <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
ffff80000010740a:	f3 0f 1e fa          	endbr64 
ffff80000010740e:	55                   	push   %rbp
ffff80000010740f:	48 89 e5             	mov    %rsp,%rbp
ffff800000107412:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107416:	89 7d ec             	mov    %edi,-0x14(%rbp)
  struct proc *p;

  acquire(&ptable.lock);
ffff800000107419:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff800000107420:	80 ff ff 
ffff800000107423:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff80000010742a:	80 ff ff 
ffff80000010742d:	ff d0                	callq  *%rax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff80000010742f:	48 b8 a8 74 1f 00 00 	movabs $0xffff8000001f74a8,%rax
ffff800000107436:	80 ff ff 
ffff800000107439:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010743d:	eb 53                	jmp    ffff800000107492 <kill+0x88>
    if(p->pid == pid){
ffff80000010743f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107443:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000107446:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff800000107449:	75 3f                	jne    ffff80000010748a <kill+0x80>
      p->killed = 1;
ffff80000010744b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010744f:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%rax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
ffff800000107456:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010745a:	8b 40 18             	mov    0x18(%rax),%eax
ffff80000010745d:	83 f8 02             	cmp    $0x2,%eax
ffff800000107460:	75 0b                	jne    ffff80000010746d <kill+0x63>
        p->state = RUNNABLE;
ffff800000107462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107466:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
      release(&ptable.lock);
ffff80000010746d:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff800000107474:	80 ff ff 
ffff800000107477:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff80000010747e:	80 ff ff 
ffff800000107481:	ff d0                	callq  *%rax
      return 0;
ffff800000107483:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107488:	eb 33                	jmp    ffff8000001074bd <kill+0xb3>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff80000010748a:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffff800000107491:	00 
ffff800000107492:	48 b8 a8 ac 1f 00 00 	movabs $0xffff8000001faca8,%rax
ffff800000107499:	80 ff ff 
ffff80000010749c:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001074a0:	72 9d                	jb     ffff80000010743f <kill+0x35>
    }
  }
  release(&ptable.lock);
ffff8000001074a2:	48 bf 40 74 1f 00 00 	movabs $0xffff8000001f7440,%rdi
ffff8000001074a9:	80 ff ff 
ffff8000001074ac:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001074b3:	80 ff ff 
ffff8000001074b6:	ff d0                	callq  *%rax
  return -1;
ffff8000001074b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff8000001074bd:	c9                   	leaveq 
ffff8000001074be:	c3                   	retq   

ffff8000001074bf <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
ffff8000001074bf:	f3 0f 1e fa          	endbr64 
ffff8000001074c3:	55                   	push   %rbp
ffff8000001074c4:	48 89 e5             	mov    %rsp,%rbp
ffff8000001074c7:	48 83 ec 70          	sub    $0x70,%rsp
  int i;
  struct proc *p;
  char *state;
  addr_t pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff8000001074cb:	48 b8 a8 74 1f 00 00 	movabs $0xffff8000001f74a8,%rax
ffff8000001074d2:	80 ff ff 
ffff8000001074d5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff8000001074d9:	e9 3b 01 00 00       	jmpq   ffff800000107619 <procdump+0x15a>
    if(p->state == UNUSED)
ffff8000001074de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001074e2:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001074e5:	85 c0                	test   %eax,%eax
ffff8000001074e7:	0f 84 23 01 00 00    	je     ffff800000107610 <procdump+0x151>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
ffff8000001074ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001074f1:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001074f4:	83 f8 05             	cmp    $0x5,%eax
ffff8000001074f7:	77 39                	ja     ffff800000107532 <procdump+0x73>
ffff8000001074f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001074fd:	8b 50 18             	mov    0x18(%rax),%edx
ffff800000107500:	48 b8 60 d5 10 00 00 	movabs $0xffff80000010d560,%rax
ffff800000107507:	80 ff ff 
ffff80000010750a:	89 d2                	mov    %edx,%edx
ffff80000010750c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
ffff800000107510:	48 85 c0             	test   %rax,%rax
ffff800000107513:	74 1d                	je     ffff800000107532 <procdump+0x73>
      state = states[p->state];
ffff800000107515:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107519:	8b 50 18             	mov    0x18(%rax),%edx
ffff80000010751c:	48 b8 60 d5 10 00 00 	movabs $0xffff80000010d560,%rax
ffff800000107523:	80 ff ff 
ffff800000107526:	89 d2                	mov    %edx,%edx
ffff800000107528:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
ffff80000010752c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff800000107530:	eb 0e                	jmp    ffff800000107540 <procdump+0x81>
    else
      state = "???";
ffff800000107532:	48 b8 66 c8 10 00 00 	movabs $0xffff80000010c866,%rax
ffff800000107539:	80 ff ff 
ffff80000010753c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    cprintf("%d %s %s", p->pid, state, p->name);
ffff800000107540:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107544:	48 8d 88 d0 00 00 00 	lea    0xd0(%rax),%rcx
ffff80000010754b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010754f:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000107552:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000107556:	89 c6                	mov    %eax,%esi
ffff800000107558:	48 bf 6a c8 10 00 00 	movabs $0xffff80000010c86a,%rdi
ffff80000010755f:	80 ff ff 
ffff800000107562:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107567:	49 b8 18 08 10 00 00 	movabs $0xffff800000100818,%r8
ffff80000010756e:	80 ff ff 
ffff800000107571:	41 ff d0             	callq  *%r8
    if(p->state == SLEEPING){
ffff800000107574:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107578:	8b 40 18             	mov    0x18(%rax),%eax
ffff80000010757b:	83 f8 02             	cmp    $0x2,%eax
ffff80000010757e:	75 73                	jne    ffff8000001075f3 <procdump+0x134>
      getstackpcs((addr_t*)p->context->rbp+2, pc);
ffff800000107580:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107584:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff800000107588:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff80000010758c:	48 83 c0 10          	add    $0x10,%rax
ffff800000107590:	48 89 c2             	mov    %rax,%rdx
ffff800000107593:	48 8d 45 90          	lea    -0x70(%rbp),%rax
ffff800000107597:	48 89 c6             	mov    %rax,%rsi
ffff80000010759a:	48 89 d7             	mov    %rdx,%rdi
ffff80000010759d:	48 b8 a7 79 10 00 00 	movabs $0xffff8000001079a7,%rax
ffff8000001075a4:	80 ff ff 
ffff8000001075a7:	ff d0                	callq  *%rax
      for(i=0; i<10 && pc[i] != 0; i++)
ffff8000001075a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001075b0:	eb 2c                	jmp    ffff8000001075de <procdump+0x11f>
        cprintf(" %p", pc[i]);
ffff8000001075b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001075b5:	48 98                	cltq   
ffff8000001075b7:	48 8b 44 c5 90       	mov    -0x70(%rbp,%rax,8),%rax
ffff8000001075bc:	48 89 c6             	mov    %rax,%rsi
ffff8000001075bf:	48 bf 73 c8 10 00 00 	movabs $0xffff80000010c873,%rdi
ffff8000001075c6:	80 ff ff 
ffff8000001075c9:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001075ce:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff8000001075d5:	80 ff ff 
ffff8000001075d8:	ff d2                	callq  *%rdx
      for(i=0; i<10 && pc[i] != 0; i++)
ffff8000001075da:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001075de:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff8000001075e2:	7f 0f                	jg     ffff8000001075f3 <procdump+0x134>
ffff8000001075e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001075e7:	48 98                	cltq   
ffff8000001075e9:	48 8b 44 c5 90       	mov    -0x70(%rbp,%rax,8),%rax
ffff8000001075ee:	48 85 c0             	test   %rax,%rax
ffff8000001075f1:	75 bf                	jne    ffff8000001075b2 <procdump+0xf3>
    }
    cprintf("\n");
ffff8000001075f3:	48 bf 77 c8 10 00 00 	movabs $0xffff80000010c877,%rdi
ffff8000001075fa:	80 ff ff 
ffff8000001075fd:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107602:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000107609:	80 ff ff 
ffff80000010760c:	ff d2                	callq  *%rdx
ffff80000010760e:	eb 01                	jmp    ffff800000107611 <procdump+0x152>
      continue;
ffff800000107610:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000107611:	48 81 45 f0 e0 00 00 	addq   $0xe0,-0x10(%rbp)
ffff800000107618:	00 
ffff800000107619:	48 b8 a8 ac 1f 00 00 	movabs $0xffff8000001faca8,%rax
ffff800000107620:	80 ff ff 
ffff800000107623:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff800000107627:	0f 82 b1 fe ff ff    	jb     ffff8000001074de <procdump+0x1f>
  }
}
ffff80000010762d:	90                   	nop
ffff80000010762e:	90                   	nop
ffff80000010762f:	c9                   	leaveq 
ffff800000107630:	c3                   	retq   

ffff800000107631 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
ffff800000107631:	f3 0f 1e fa          	endbr64 
ffff800000107635:	55                   	push   %rbp
ffff800000107636:	48 89 e5             	mov    %rsp,%rbp
ffff800000107639:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010763d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107641:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  initlock(&lk->lk, "sleep lock");
ffff800000107645:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107649:	48 83 c0 08          	add    $0x8,%rax
ffff80000010764d:	48 be a3 c8 10 00 00 	movabs $0xffff80000010c8a3,%rsi
ffff800000107654:	80 ff ff 
ffff800000107657:	48 89 c7             	mov    %rax,%rdi
ffff80000010765a:	48 b8 24 78 10 00 00 	movabs $0xffff800000107824,%rax
ffff800000107661:	80 ff ff 
ffff800000107664:	ff d0                	callq  *%rax
  lk->name = name;
ffff800000107666:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010766a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010766e:	48 89 50 70          	mov    %rdx,0x70(%rax)
  lk->locked = 0;
ffff800000107672:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107676:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  lk->pid = 0;
ffff80000010767c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107680:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%rax)
}
ffff800000107687:	90                   	nop
ffff800000107688:	c9                   	leaveq 
ffff800000107689:	c3                   	retq   

ffff80000010768a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
ffff80000010768a:	f3 0f 1e fa          	endbr64 
ffff80000010768e:	55                   	push   %rbp
ffff80000010768f:	48 89 e5             	mov    %rsp,%rbp
ffff800000107692:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107696:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&lk->lk);
ffff80000010769a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010769e:	48 83 c0 08          	add    $0x8,%rax
ffff8000001076a2:	48 89 c7             	mov    %rax,%rdi
ffff8000001076a5:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff8000001076ac:	80 ff ff 
ffff8000001076af:	ff d0                	callq  *%rax
  while (lk->locked)
ffff8000001076b1:	eb 1e                	jmp    ffff8000001076d1 <acquiresleep+0x47>
    sleep(lk, &lk->lk);
ffff8000001076b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001076b7:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff8000001076bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001076bf:	48 89 d6             	mov    %rdx,%rsi
ffff8000001076c2:	48 89 c7             	mov    %rax,%rdi
ffff8000001076c5:	48 b8 47 72 10 00 00 	movabs $0xffff800000107247,%rax
ffff8000001076cc:	80 ff ff 
ffff8000001076cf:	ff d0                	callq  *%rax
  while (lk->locked)
ffff8000001076d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001076d5:	8b 00                	mov    (%rax),%eax
ffff8000001076d7:	85 c0                	test   %eax,%eax
ffff8000001076d9:	75 d8                	jne    ffff8000001076b3 <acquiresleep+0x29>
  lk->locked = 1;
ffff8000001076db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001076df:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  lk->pid = proc->pid;
ffff8000001076e5:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001076ec:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001076f0:	8b 50 1c             	mov    0x1c(%rax),%edx
ffff8000001076f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001076f7:	89 50 78             	mov    %edx,0x78(%rax)
  release(&lk->lk);
ffff8000001076fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001076fe:	48 83 c0 08          	add    $0x8,%rax
ffff800000107702:	48 89 c7             	mov    %rax,%rdi
ffff800000107705:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff80000010770c:	80 ff ff 
ffff80000010770f:	ff d0                	callq  *%rax
}
ffff800000107711:	90                   	nop
ffff800000107712:	c9                   	leaveq 
ffff800000107713:	c3                   	retq   

ffff800000107714 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
ffff800000107714:	f3 0f 1e fa          	endbr64 
ffff800000107718:	55                   	push   %rbp
ffff800000107719:	48 89 e5             	mov    %rsp,%rbp
ffff80000010771c:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107720:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&lk->lk);
ffff800000107724:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107728:	48 83 c0 08          	add    $0x8,%rax
ffff80000010772c:	48 89 c7             	mov    %rax,%rdi
ffff80000010772f:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000107736:	80 ff ff 
ffff800000107739:	ff d0                	callq  *%rax
  lk->locked = 0;
ffff80000010773b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010773f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  lk->pid = 0;
ffff800000107745:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107749:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%rax)
  wakeup(lk);
ffff800000107750:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107754:	48 89 c7             	mov    %rax,%rdi
ffff800000107757:	48 b8 b8 73 10 00 00 	movabs $0xffff8000001073b8,%rax
ffff80000010775e:	80 ff ff 
ffff800000107761:	ff d0                	callq  *%rax
  release(&lk->lk);
ffff800000107763:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107767:	48 83 c0 08          	add    $0x8,%rax
ffff80000010776b:	48 89 c7             	mov    %rax,%rdi
ffff80000010776e:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000107775:	80 ff ff 
ffff800000107778:	ff d0                	callq  *%rax
}
ffff80000010777a:	90                   	nop
ffff80000010777b:	c9                   	leaveq 
ffff80000010777c:	c3                   	retq   

ffff80000010777d <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
ffff80000010777d:	f3 0f 1e fa          	endbr64 
ffff800000107781:	55                   	push   %rbp
ffff800000107782:	48 89 e5             	mov    %rsp,%rbp
ffff800000107785:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107789:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  acquire(&lk->lk);
ffff80000010778d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107791:	48 83 c0 08          	add    $0x8,%rax
ffff800000107795:	48 89 c7             	mov    %rax,%rdi
ffff800000107798:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff80000010779f:	80 ff ff 
ffff8000001077a2:	ff d0                	callq  *%rax
  int r = lk->locked;
ffff8000001077a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001077a8:	8b 00                	mov    (%rax),%eax
ffff8000001077aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  release(&lk->lk);
ffff8000001077ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001077b1:	48 83 c0 08          	add    $0x8,%rax
ffff8000001077b5:	48 89 c7             	mov    %rax,%rdi
ffff8000001077b8:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001077bf:	80 ff ff 
ffff8000001077c2:	ff d0                	callq  *%rax
  return r;
ffff8000001077c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff8000001077c7:	c9                   	leaveq 
ffff8000001077c8:	c3                   	retq   

ffff8000001077c9 <readeflags>:
{
ffff8000001077c9:	f3 0f 1e fa          	endbr64 
ffff8000001077cd:	55                   	push   %rbp
ffff8000001077ce:	48 89 e5             	mov    %rsp,%rbp
ffff8000001077d1:	48 83 ec 10          	sub    $0x10,%rsp
  asm volatile("pushf; pop %0" : "=r" (eflags));
ffff8000001077d5:	9c                   	pushfq 
ffff8000001077d6:	58                   	pop    %rax
ffff8000001077d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return eflags;
ffff8000001077db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001077df:	c9                   	leaveq 
ffff8000001077e0:	c3                   	retq   

ffff8000001077e1 <cli>:
{
ffff8000001077e1:	f3 0f 1e fa          	endbr64 
ffff8000001077e5:	55                   	push   %rbp
ffff8000001077e6:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("cli");
ffff8000001077e9:	fa                   	cli    
}
ffff8000001077ea:	90                   	nop
ffff8000001077eb:	5d                   	pop    %rbp
ffff8000001077ec:	c3                   	retq   

ffff8000001077ed <sti>:
{
ffff8000001077ed:	f3 0f 1e fa          	endbr64 
ffff8000001077f1:	55                   	push   %rbp
ffff8000001077f2:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("sti");
ffff8000001077f5:	fb                   	sti    
}
ffff8000001077f6:	90                   	nop
ffff8000001077f7:	5d                   	pop    %rbp
ffff8000001077f8:	c3                   	retq   

ffff8000001077f9 <xchg>:
{
ffff8000001077f9:	f3 0f 1e fa          	endbr64 
ffff8000001077fd:	55                   	push   %rbp
ffff8000001077fe:	48 89 e5             	mov    %rsp,%rbp
ffff800000107801:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107805:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107809:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  asm volatile("lock; xchgl %0, %1" :
ffff80000010780d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000107811:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107815:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff800000107819:	f0 87 02             	lock xchg %eax,(%rdx)
ffff80000010781c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  return result;
ffff80000010781f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000107822:	c9                   	leaveq 
ffff800000107823:	c3                   	retq   

ffff800000107824 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
ffff800000107824:	f3 0f 1e fa          	endbr64 
ffff800000107828:	55                   	push   %rbp
ffff800000107829:	48 89 e5             	mov    %rsp,%rbp
ffff80000010782c:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107830:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107834:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  lk->name = name;
ffff800000107838:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010783c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000107840:	48 89 50 08          	mov    %rdx,0x8(%rax)
  lk->locked = 0;
ffff800000107844:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107848:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  lk->cpu = 0;
ffff80000010784e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107852:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff800000107859:	00 
}
ffff80000010785a:	90                   	nop
ffff80000010785b:	c9                   	leaveq 
ffff80000010785c:	c3                   	retq   

ffff80000010785d <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
ffff80000010785d:	f3 0f 1e fa          	endbr64 
ffff800000107861:	55                   	push   %rbp
ffff800000107862:	48 89 e5             	mov    %rsp,%rbp
ffff800000107865:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107869:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  pushcli(); // disable interrupts to avoid deadlock.
ffff80000010786d:	48 b8 85 7a 10 00 00 	movabs $0xffff800000107a85,%rax
ffff800000107874:	80 ff ff 
ffff800000107877:	ff d0                	callq  *%rax
  if(holding(lk))
ffff800000107879:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010787d:	48 89 c7             	mov    %rax,%rdi
ffff800000107880:	48 b8 45 7a 10 00 00 	movabs $0xffff800000107a45,%rax
ffff800000107887:	80 ff ff 
ffff80000010788a:	ff d0                	callq  *%rax
ffff80000010788c:	85 c0                	test   %eax,%eax
ffff80000010788e:	74 16                	je     ffff8000001078a6 <acquire+0x49>
    panic("acquire");
ffff800000107890:	48 bf ae c8 10 00 00 	movabs $0xffff80000010c8ae,%rdi
ffff800000107897:	80 ff ff 
ffff80000010789a:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001078a1:	80 ff ff 
ffff8000001078a4:	ff d0                	callq  *%rax

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
ffff8000001078a6:	90                   	nop
ffff8000001078a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001078ab:	be 01 00 00 00       	mov    $0x1,%esi
ffff8000001078b0:	48 89 c7             	mov    %rax,%rdi
ffff8000001078b3:	48 b8 f9 77 10 00 00 	movabs $0xffff8000001077f9,%rax
ffff8000001078ba:	80 ff ff 
ffff8000001078bd:	ff d0                	callq  *%rax
ffff8000001078bf:	85 c0                	test   %eax,%eax
ffff8000001078c1:	75 e4                	jne    ffff8000001078a7 <acquire+0x4a>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
ffff8000001078c3:	0f ae f0             	mfence 

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
ffff8000001078c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001078ca:	48 c7 c2 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rdx
ffff8000001078d1:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffff8000001078d5:	48 89 50 10          	mov    %rdx,0x10(%rax)
  getcallerpcs(&lk, lk->pcs);
ffff8000001078d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001078dd:	48 8d 50 18          	lea    0x18(%rax),%rdx
ffff8000001078e1:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff8000001078e5:	48 89 d6             	mov    %rdx,%rsi
ffff8000001078e8:	48 89 c7             	mov    %rax,%rdi
ffff8000001078eb:	48 b8 6f 79 10 00 00 	movabs $0xffff80000010796f,%rax
ffff8000001078f2:	80 ff ff 
ffff8000001078f5:	ff d0                	callq  *%rax
}
ffff8000001078f7:	90                   	nop
ffff8000001078f8:	c9                   	leaveq 
ffff8000001078f9:	c3                   	retq   

ffff8000001078fa <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
ffff8000001078fa:	f3 0f 1e fa          	endbr64 
ffff8000001078fe:	55                   	push   %rbp
ffff8000001078ff:	48 89 e5             	mov    %rsp,%rbp
ffff800000107902:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107906:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(!holding(lk))
ffff80000010790a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010790e:	48 89 c7             	mov    %rax,%rdi
ffff800000107911:	48 b8 45 7a 10 00 00 	movabs $0xffff800000107a45,%rax
ffff800000107918:	80 ff ff 
ffff80000010791b:	ff d0                	callq  *%rax
ffff80000010791d:	85 c0                	test   %eax,%eax
ffff80000010791f:	75 16                	jne    ffff800000107937 <release+0x3d>
    panic("release");
ffff800000107921:	48 bf b6 c8 10 00 00 	movabs $0xffff80000010c8b6,%rdi
ffff800000107928:	80 ff ff 
ffff80000010792b:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000107932:	80 ff ff 
ffff800000107935:	ff d0                	callq  *%rax

  lk->pcs[0] = 0;
ffff800000107937:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010793b:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
ffff800000107942:	00 
  lk->cpu = 0;
ffff800000107943:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107947:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff80000010794e:	00 
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
ffff80000010794f:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
ffff800000107952:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107956:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010795a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)

  popcli();
ffff800000107960:	48 b8 f7 7a 10 00 00 	movabs $0xffff800000107af7,%rax
ffff800000107967:	80 ff ff 
ffff80000010796a:	ff d0                	callq  *%rax
}
ffff80000010796c:	90                   	nop
ffff80000010796d:	c9                   	leaveq 
ffff80000010796e:	c3                   	retq   

ffff80000010796f <getcallerpcs>:

// Record the current call stack in pcs[] by following the %rbp chain.
void
getcallerpcs(void *v, addr_t pcs[])
{
ffff80000010796f:	f3 0f 1e fa          	endbr64 
ffff800000107973:	55                   	push   %rbp
ffff800000107974:	48 89 e5             	mov    %rsp,%rbp
ffff800000107977:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010797b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010797f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  addr_t *rbp;

  asm volatile("mov %%rbp, %0" : "=r" (rbp));
ffff800000107983:	48 89 e8             	mov    %rbp,%rax
ffff800000107986:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  getstackpcs(rbp, pcs);
ffff80000010798a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010798e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107992:	48 89 d6             	mov    %rdx,%rsi
ffff800000107995:	48 89 c7             	mov    %rax,%rdi
ffff800000107998:	48 b8 a7 79 10 00 00 	movabs $0xffff8000001079a7,%rax
ffff80000010799f:	80 ff ff 
ffff8000001079a2:	ff d0                	callq  *%rax
}
ffff8000001079a4:	90                   	nop
ffff8000001079a5:	c9                   	leaveq 
ffff8000001079a6:	c3                   	retq   

ffff8000001079a7 <getstackpcs>:

void
getstackpcs(addr_t *rbp, addr_t pcs[])
{
ffff8000001079a7:	f3 0f 1e fa          	endbr64 
ffff8000001079ab:	55                   	push   %rbp
ffff8000001079ac:	48 89 e5             	mov    %rsp,%rbp
ffff8000001079af:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001079b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001079b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;

  for(i = 0; i < 10; i++){
ffff8000001079bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001079c2:	eb 50                	jmp    ffff800000107a14 <getstackpcs+0x6d>
    if(rbp == 0 || rbp < (addr_t*)KERNBASE || rbp == (addr_t*)0xffffffff)
ffff8000001079c4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff8000001079c9:	74 70                	je     ffff800000107a3b <getstackpcs+0x94>
ffff8000001079cb:	48 b8 ff ff ff ff ff 	movabs $0xffff7fffffffffff,%rax
ffff8000001079d2:	7f ff ff 
ffff8000001079d5:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff8000001079d9:	76 60                	jbe    ffff800000107a3b <getstackpcs+0x94>
ffff8000001079db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001079e0:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff8000001079e4:	74 55                	je     ffff800000107a3b <getstackpcs+0x94>
      break;
    pcs[i] = rbp[1];     // saved %rip
ffff8000001079e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001079e9:	48 98                	cltq   
ffff8000001079eb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff8000001079f2:	00 
ffff8000001079f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001079f7:	48 01 c2             	add    %rax,%rdx
ffff8000001079fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001079fe:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000107a02:	48 89 02             	mov    %rax,(%rdx)
    rbp = (addr_t*)rbp[0]; // saved %rbp
ffff800000107a05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107a09:	48 8b 00             	mov    (%rax),%rax
ffff800000107a0c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  for(i = 0; i < 10; i++){
ffff800000107a10:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000107a14:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff800000107a18:	7e aa                	jle    ffff8000001079c4 <getstackpcs+0x1d>
  }
  for(; i < 10; i++)
ffff800000107a1a:	eb 1f                	jmp    ffff800000107a3b <getstackpcs+0x94>
    pcs[i] = 0;
ffff800000107a1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107a1f:	48 98                	cltq   
ffff800000107a21:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff800000107a28:	00 
ffff800000107a29:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107a2d:	48 01 d0             	add    %rdx,%rax
ffff800000107a30:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  for(; i < 10; i++)
ffff800000107a37:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000107a3b:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff800000107a3f:	7e db                	jle    ffff800000107a1c <getstackpcs+0x75>
}
ffff800000107a41:	90                   	nop
ffff800000107a42:	90                   	nop
ffff800000107a43:	c9                   	leaveq 
ffff800000107a44:	c3                   	retq   

ffff800000107a45 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
ffff800000107a45:	f3 0f 1e fa          	endbr64 
ffff800000107a49:	55                   	push   %rbp
ffff800000107a4a:	48 89 e5             	mov    %rsp,%rbp
ffff800000107a4d:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000107a51:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  return lock->locked && lock->cpu == cpu;
ffff800000107a55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107a59:	8b 00                	mov    (%rax),%eax
ffff800000107a5b:	85 c0                	test   %eax,%eax
ffff800000107a5d:	74 1f                	je     ffff800000107a7e <holding+0x39>
ffff800000107a5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107a63:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff800000107a67:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107a6e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107a72:	48 39 c2             	cmp    %rax,%rdx
ffff800000107a75:	75 07                	jne    ffff800000107a7e <holding+0x39>
ffff800000107a77:	b8 01 00 00 00       	mov    $0x1,%eax
ffff800000107a7c:	eb 05                	jmp    ffff800000107a83 <holding+0x3e>
ffff800000107a7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000107a83:	c9                   	leaveq 
ffff800000107a84:	c3                   	retq   

ffff800000107a85 <pushcli>:
// Pushcli/popcli are like cli/sti except that they are matched:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.
void
pushcli(void)
{
ffff800000107a85:	f3 0f 1e fa          	endbr64 
ffff800000107a89:	55                   	push   %rbp
ffff800000107a8a:	48 89 e5             	mov    %rsp,%rbp
ffff800000107a8d:	48 83 ec 10          	sub    $0x10,%rsp
  int eflags;

  eflags = readeflags();
ffff800000107a91:	48 b8 c9 77 10 00 00 	movabs $0xffff8000001077c9,%rax
ffff800000107a98:	80 ff ff 
ffff800000107a9b:	ff d0                	callq  *%rax
ffff800000107a9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  cli();
ffff800000107aa0:	48 b8 e1 77 10 00 00 	movabs $0xffff8000001077e1,%rax
ffff800000107aa7:	80 ff ff 
ffff800000107aaa:	ff d0                	callq  *%rax
  if(cpu->ncli == 0)
ffff800000107aac:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107ab3:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107ab7:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000107aba:	85 c0                	test   %eax,%eax
ffff800000107abc:	75 17                	jne    ffff800000107ad5 <pushcli+0x50>
    cpu->intena = eflags & FL_IF;
ffff800000107abe:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107ac5:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107ac9:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000107acc:	81 e2 00 02 00 00    	and    $0x200,%edx
ffff800000107ad2:	89 50 18             	mov    %edx,0x18(%rax)
  cpu->ncli += 1;
ffff800000107ad5:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107adc:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107ae0:	8b 50 14             	mov    0x14(%rax),%edx
ffff800000107ae3:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107aea:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107aee:	83 c2 01             	add    $0x1,%edx
ffff800000107af1:	89 50 14             	mov    %edx,0x14(%rax)
}
ffff800000107af4:	90                   	nop
ffff800000107af5:	c9                   	leaveq 
ffff800000107af6:	c3                   	retq   

ffff800000107af7 <popcli>:

void
popcli(void)
{
ffff800000107af7:	f3 0f 1e fa          	endbr64 
ffff800000107afb:	55                   	push   %rbp
ffff800000107afc:	48 89 e5             	mov    %rsp,%rbp
  if(readeflags()&FL_IF)
ffff800000107aff:	48 b8 c9 77 10 00 00 	movabs $0xffff8000001077c9,%rax
ffff800000107b06:	80 ff ff 
ffff800000107b09:	ff d0                	callq  *%rax
ffff800000107b0b:	25 00 02 00 00       	and    $0x200,%eax
ffff800000107b10:	48 85 c0             	test   %rax,%rax
ffff800000107b13:	74 16                	je     ffff800000107b2b <popcli+0x34>
    panic("popcli - interruptible");
ffff800000107b15:	48 bf be c8 10 00 00 	movabs $0xffff80000010c8be,%rdi
ffff800000107b1c:	80 ff ff 
ffff800000107b1f:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000107b26:	80 ff ff 
ffff800000107b29:	ff d0                	callq  *%rax
  if(--cpu->ncli < 0)
ffff800000107b2b:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107b32:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107b36:	8b 50 14             	mov    0x14(%rax),%edx
ffff800000107b39:	83 ea 01             	sub    $0x1,%edx
ffff800000107b3c:	89 50 14             	mov    %edx,0x14(%rax)
ffff800000107b3f:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000107b42:	85 c0                	test   %eax,%eax
ffff800000107b44:	79 16                	jns    ffff800000107b5c <popcli+0x65>
    panic("popcli");
ffff800000107b46:	48 bf d5 c8 10 00 00 	movabs $0xffff80000010c8d5,%rdi
ffff800000107b4d:	80 ff ff 
ffff800000107b50:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000107b57:	80 ff ff 
ffff800000107b5a:	ff d0                	callq  *%rax
  if(cpu->ncli == 0 && cpu->intena)
ffff800000107b5c:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107b63:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107b67:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000107b6a:	85 c0                	test   %eax,%eax
ffff800000107b6c:	75 1e                	jne    ffff800000107b8c <popcli+0x95>
ffff800000107b6e:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107b75:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107b79:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000107b7c:	85 c0                	test   %eax,%eax
ffff800000107b7e:	74 0c                	je     ffff800000107b8c <popcli+0x95>
    sti();
ffff800000107b80:	48 b8 ed 77 10 00 00 	movabs $0xffff8000001077ed,%rax
ffff800000107b87:	80 ff ff 
ffff800000107b8a:	ff d0                	callq  *%rax
}
ffff800000107b8c:	90                   	nop
ffff800000107b8d:	5d                   	pop    %rbp
ffff800000107b8e:	c3                   	retq   

ffff800000107b8f <stosb>:
{
ffff800000107b8f:	f3 0f 1e fa          	endbr64 
ffff800000107b93:	55                   	push   %rbp
ffff800000107b94:	48 89 e5             	mov    %rsp,%rbp
ffff800000107b97:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107b9b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107b9f:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffff800000107ba2:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
ffff800000107ba5:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000107ba9:	8b 55 f0             	mov    -0x10(%rbp),%edx
ffff800000107bac:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000107baf:	48 89 ce             	mov    %rcx,%rsi
ffff800000107bb2:	48 89 f7             	mov    %rsi,%rdi
ffff800000107bb5:	89 d1                	mov    %edx,%ecx
ffff800000107bb7:	fc                   	cld    
ffff800000107bb8:	f3 aa                	rep stos %al,%es:(%rdi)
ffff800000107bba:	89 ca                	mov    %ecx,%edx
ffff800000107bbc:	48 89 fe             	mov    %rdi,%rsi
ffff800000107bbf:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
ffff800000107bc3:	89 55 f0             	mov    %edx,-0x10(%rbp)
}
ffff800000107bc6:	90                   	nop
ffff800000107bc7:	c9                   	leaveq 
ffff800000107bc8:	c3                   	retq   

ffff800000107bc9 <stosl>:
{
ffff800000107bc9:	f3 0f 1e fa          	endbr64 
ffff800000107bcd:	55                   	push   %rbp
ffff800000107bce:	48 89 e5             	mov    %rsp,%rbp
ffff800000107bd1:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107bd5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107bd9:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffff800000107bdc:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosl" :
ffff800000107bdf:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000107be3:	8b 55 f0             	mov    -0x10(%rbp),%edx
ffff800000107be6:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000107be9:	48 89 ce             	mov    %rcx,%rsi
ffff800000107bec:	48 89 f7             	mov    %rsi,%rdi
ffff800000107bef:	89 d1                	mov    %edx,%ecx
ffff800000107bf1:	fc                   	cld    
ffff800000107bf2:	f3 ab                	rep stos %eax,%es:(%rdi)
ffff800000107bf4:	89 ca                	mov    %ecx,%edx
ffff800000107bf6:	48 89 fe             	mov    %rdi,%rsi
ffff800000107bf9:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
ffff800000107bfd:	89 55 f0             	mov    %edx,-0x10(%rbp)
}
ffff800000107c00:	90                   	nop
ffff800000107c01:	c9                   	leaveq 
ffff800000107c02:	c3                   	retq   

ffff800000107c03 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint64 n)
{
ffff800000107c03:	f3 0f 1e fa          	endbr64 
ffff800000107c07:	55                   	push   %rbp
ffff800000107c08:	48 89 e5             	mov    %rsp,%rbp
ffff800000107c0b:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000107c0f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107c13:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffff800000107c16:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  if ((addr_t)dst%4 == 0 && n%4 == 0){
ffff800000107c1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107c1e:	83 e0 03             	and    $0x3,%eax
ffff800000107c21:	48 85 c0             	test   %rax,%rax
ffff800000107c24:	75 53                	jne    ffff800000107c79 <memset+0x76>
ffff800000107c26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107c2a:	83 e0 03             	and    $0x3,%eax
ffff800000107c2d:	48 85 c0             	test   %rax,%rax
ffff800000107c30:	75 47                	jne    ffff800000107c79 <memset+0x76>
    c &= 0xFF;
ffff800000107c32:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
ffff800000107c39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107c3d:	48 c1 e8 02          	shr    $0x2,%rax
ffff800000107c41:	89 c6                	mov    %eax,%esi
ffff800000107c43:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000107c46:	c1 e0 18             	shl    $0x18,%eax
ffff800000107c49:	89 c2                	mov    %eax,%edx
ffff800000107c4b:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000107c4e:	c1 e0 10             	shl    $0x10,%eax
ffff800000107c51:	09 c2                	or     %eax,%edx
ffff800000107c53:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000107c56:	c1 e0 08             	shl    $0x8,%eax
ffff800000107c59:	09 d0                	or     %edx,%eax
ffff800000107c5b:	0b 45 f4             	or     -0xc(%rbp),%eax
ffff800000107c5e:	89 c1                	mov    %eax,%ecx
ffff800000107c60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107c64:	89 f2                	mov    %esi,%edx
ffff800000107c66:	89 ce                	mov    %ecx,%esi
ffff800000107c68:	48 89 c7             	mov    %rax,%rdi
ffff800000107c6b:	48 b8 c9 7b 10 00 00 	movabs $0xffff800000107bc9,%rax
ffff800000107c72:	80 ff ff 
ffff800000107c75:	ff d0                	callq  *%rax
ffff800000107c77:	eb 1e                	jmp    ffff800000107c97 <memset+0x94>
  } else
    stosb(dst, c, n);
ffff800000107c79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107c7d:	89 c2                	mov    %eax,%edx
ffff800000107c7f:	8b 4d f4             	mov    -0xc(%rbp),%ecx
ffff800000107c82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107c86:	89 ce                	mov    %ecx,%esi
ffff800000107c88:	48 89 c7             	mov    %rax,%rdi
ffff800000107c8b:	48 b8 8f 7b 10 00 00 	movabs $0xffff800000107b8f,%rax
ffff800000107c92:	80 ff ff 
ffff800000107c95:	ff d0                	callq  *%rax
  return dst;
ffff800000107c97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000107c9b:	c9                   	leaveq 
ffff800000107c9c:	c3                   	retq   

ffff800000107c9d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
ffff800000107c9d:	f3 0f 1e fa          	endbr64 
ffff800000107ca1:	55                   	push   %rbp
ffff800000107ca2:	48 89 e5             	mov    %rsp,%rbp
ffff800000107ca5:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000107ca9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107cad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000107cb1:	89 55 dc             	mov    %edx,-0x24(%rbp)
  const uchar *s1, *s2;

  s1 = v1;
ffff800000107cb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107cb8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  s2 = v2;
ffff800000107cbc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107cc0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0){
ffff800000107cc4:	eb 36                	jmp    ffff800000107cfc <memcmp+0x5f>
    if(*s1 != *s2)
ffff800000107cc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107cca:	0f b6 10             	movzbl (%rax),%edx
ffff800000107ccd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107cd1:	0f b6 00             	movzbl (%rax),%eax
ffff800000107cd4:	38 c2                	cmp    %al,%dl
ffff800000107cd6:	74 1a                	je     ffff800000107cf2 <memcmp+0x55>
      return *s1 - *s2;
ffff800000107cd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107cdc:	0f b6 00             	movzbl (%rax),%eax
ffff800000107cdf:	0f b6 d0             	movzbl %al,%edx
ffff800000107ce2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107ce6:	0f b6 00             	movzbl (%rax),%eax
ffff800000107ce9:	0f b6 c0             	movzbl %al,%eax
ffff800000107cec:	29 c2                	sub    %eax,%edx
ffff800000107cee:	89 d0                	mov    %edx,%eax
ffff800000107cf0:	eb 1c                	jmp    ffff800000107d0e <memcmp+0x71>
    s1++, s2++;
ffff800000107cf2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff800000107cf7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(n-- > 0){
ffff800000107cfc:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107cff:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000107d02:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000107d05:	85 c0                	test   %eax,%eax
ffff800000107d07:	75 bd                	jne    ffff800000107cc6 <memcmp+0x29>
  }

  return 0;
ffff800000107d09:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000107d0e:	c9                   	leaveq 
ffff800000107d0f:	c3                   	retq   

ffff800000107d10 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
ffff800000107d10:	f3 0f 1e fa          	endbr64 
ffff800000107d14:	55                   	push   %rbp
ffff800000107d15:	48 89 e5             	mov    %rsp,%rbp
ffff800000107d18:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000107d1c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107d20:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000107d24:	89 55 dc             	mov    %edx,-0x24(%rbp)
  const char *s;
  char *d;

  s = src;
ffff800000107d27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107d2b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  d = dst;
ffff800000107d2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107d33:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if(s < d && s + n > d){
ffff800000107d37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d3b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffff800000107d3f:	73 63                	jae    ffff800000107da4 <memmove+0x94>
ffff800000107d41:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff800000107d44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d48:	48 01 d0             	add    %rdx,%rax
ffff800000107d4b:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff800000107d4f:	73 53                	jae    ffff800000107da4 <memmove+0x94>
    s += n;
ffff800000107d51:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107d54:	48 01 45 f8          	add    %rax,-0x8(%rbp)
    d += n;
ffff800000107d58:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107d5b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
    while(n-- > 0)
ffff800000107d5f:	eb 17                	jmp    ffff800000107d78 <memmove+0x68>
      *--d = *--s;
ffff800000107d61:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
ffff800000107d66:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
ffff800000107d6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d6f:	0f b6 10             	movzbl (%rax),%edx
ffff800000107d72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107d76:	88 10                	mov    %dl,(%rax)
    while(n-- > 0)
ffff800000107d78:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107d7b:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000107d7e:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000107d81:	85 c0                	test   %eax,%eax
ffff800000107d83:	75 dc                	jne    ffff800000107d61 <memmove+0x51>
  if(s < d && s + n > d){
ffff800000107d85:	eb 2a                	jmp    ffff800000107db1 <memmove+0xa1>
  } else
    while(n-- > 0)
      *d++ = *s++;
ffff800000107d87:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000107d8b:	48 8d 42 01          	lea    0x1(%rdx),%rax
ffff800000107d8f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000107d93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107d97:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff800000107d9b:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
ffff800000107d9f:	0f b6 12             	movzbl (%rdx),%edx
ffff800000107da2:	88 10                	mov    %dl,(%rax)
    while(n-- > 0)
ffff800000107da4:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107da7:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000107daa:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000107dad:	85 c0                	test   %eax,%eax
ffff800000107daf:	75 d6                	jne    ffff800000107d87 <memmove+0x77>

  return dst;
ffff800000107db1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
ffff800000107db5:	c9                   	leaveq 
ffff800000107db6:	c3                   	retq   

ffff800000107db7 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
ffff800000107db7:	f3 0f 1e fa          	endbr64 
ffff800000107dbb:	55                   	push   %rbp
ffff800000107dbc:	48 89 e5             	mov    %rsp,%rbp
ffff800000107dbf:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000107dc3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107dc7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000107dcb:	89 55 ec             	mov    %edx,-0x14(%rbp)
  return memmove(dst, src, n);
ffff800000107dce:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff800000107dd1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff800000107dd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107dd9:	48 89 ce             	mov    %rcx,%rsi
ffff800000107ddc:	48 89 c7             	mov    %rax,%rdi
ffff800000107ddf:	48 b8 10 7d 10 00 00 	movabs $0xffff800000107d10,%rax
ffff800000107de6:	80 ff ff 
ffff800000107de9:	ff d0                	callq  *%rax
}
ffff800000107deb:	c9                   	leaveq 
ffff800000107dec:	c3                   	retq   

ffff800000107ded <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
ffff800000107ded:	f3 0f 1e fa          	endbr64 
ffff800000107df1:	55                   	push   %rbp
ffff800000107df2:	48 89 e5             	mov    %rsp,%rbp
ffff800000107df5:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000107df9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107dfd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000107e01:	89 55 ec             	mov    %edx,-0x14(%rbp)
  while(n > 0 && *p && *p == *q)
ffff800000107e04:	eb 0e                	jmp    ffff800000107e14 <strncmp+0x27>
    n--, p++, q++;
ffff800000107e06:	83 6d ec 01          	subl   $0x1,-0x14(%rbp)
ffff800000107e0a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff800000107e0f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(n > 0 && *p && *p == *q)
ffff800000107e14:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff800000107e18:	74 1d                	je     ffff800000107e37 <strncmp+0x4a>
ffff800000107e1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107e1e:	0f b6 00             	movzbl (%rax),%eax
ffff800000107e21:	84 c0                	test   %al,%al
ffff800000107e23:	74 12                	je     ffff800000107e37 <strncmp+0x4a>
ffff800000107e25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107e29:	0f b6 10             	movzbl (%rax),%edx
ffff800000107e2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107e30:	0f b6 00             	movzbl (%rax),%eax
ffff800000107e33:	38 c2                	cmp    %al,%dl
ffff800000107e35:	74 cf                	je     ffff800000107e06 <strncmp+0x19>
  if(n == 0)
ffff800000107e37:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff800000107e3b:	75 07                	jne    ffff800000107e44 <strncmp+0x57>
    return 0;
ffff800000107e3d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107e42:	eb 18                	jmp    ffff800000107e5c <strncmp+0x6f>
  return (uchar)*p - (uchar)*q;
ffff800000107e44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107e48:	0f b6 00             	movzbl (%rax),%eax
ffff800000107e4b:	0f b6 d0             	movzbl %al,%edx
ffff800000107e4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107e52:	0f b6 00             	movzbl (%rax),%eax
ffff800000107e55:	0f b6 c0             	movzbl %al,%eax
ffff800000107e58:	29 c2                	sub    %eax,%edx
ffff800000107e5a:	89 d0                	mov    %edx,%eax
}
ffff800000107e5c:	c9                   	leaveq 
ffff800000107e5d:	c3                   	retq   

ffff800000107e5e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
ffff800000107e5e:	f3 0f 1e fa          	endbr64 
ffff800000107e62:	55                   	push   %rbp
ffff800000107e63:	48 89 e5             	mov    %rsp,%rbp
ffff800000107e66:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000107e6a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107e6e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000107e72:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *os = s;
ffff800000107e75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107e79:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(n-- > 0 && (*s++ = *t++) != 0)
ffff800000107e7d:	90                   	nop
ffff800000107e7e:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107e81:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000107e84:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000107e87:	85 c0                	test   %eax,%eax
ffff800000107e89:	7e 35                	jle    ffff800000107ec0 <strncpy+0x62>
ffff800000107e8b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000107e8f:	48 8d 42 01          	lea    0x1(%rdx),%rax
ffff800000107e93:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
ffff800000107e97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107e9b:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff800000107e9f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
ffff800000107ea3:	0f b6 12             	movzbl (%rdx),%edx
ffff800000107ea6:	88 10                	mov    %dl,(%rax)
ffff800000107ea8:	0f b6 00             	movzbl (%rax),%eax
ffff800000107eab:	84 c0                	test   %al,%al
ffff800000107ead:	75 cf                	jne    ffff800000107e7e <strncpy+0x20>
    ;
  while(n-- > 0)
ffff800000107eaf:	eb 0f                	jmp    ffff800000107ec0 <strncpy+0x62>
    *s++ = 0;
ffff800000107eb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107eb5:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000107eb9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
ffff800000107ebd:	c6 00 00             	movb   $0x0,(%rax)
  while(n-- > 0)
ffff800000107ec0:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107ec3:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000107ec6:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000107ec9:	85 c0                	test   %eax,%eax
ffff800000107ecb:	7f e4                	jg     ffff800000107eb1 <strncpy+0x53>
  return os;
ffff800000107ecd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000107ed1:	c9                   	leaveq 
ffff800000107ed2:	c3                   	retq   

ffff800000107ed3 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
ffff800000107ed3:	f3 0f 1e fa          	endbr64 
ffff800000107ed7:	55                   	push   %rbp
ffff800000107ed8:	48 89 e5             	mov    %rsp,%rbp
ffff800000107edb:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000107edf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107ee3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000107ee7:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *os = s;
ffff800000107eea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107eee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(n <= 0)
ffff800000107ef2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff800000107ef6:	7f 06                	jg     ffff800000107efe <safestrcpy+0x2b>
    return os;
ffff800000107ef8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107efc:	eb 39                	jmp    ffff800000107f37 <safestrcpy+0x64>
  while(--n > 0 && (*s++ = *t++) != 0)
ffff800000107efe:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
ffff800000107f02:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff800000107f06:	7e 24                	jle    ffff800000107f2c <safestrcpy+0x59>
ffff800000107f08:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000107f0c:	48 8d 42 01          	lea    0x1(%rdx),%rax
ffff800000107f10:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
ffff800000107f14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107f18:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff800000107f1c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
ffff800000107f20:	0f b6 12             	movzbl (%rdx),%edx
ffff800000107f23:	88 10                	mov    %dl,(%rax)
ffff800000107f25:	0f b6 00             	movzbl (%rax),%eax
ffff800000107f28:	84 c0                	test   %al,%al
ffff800000107f2a:	75 d2                	jne    ffff800000107efe <safestrcpy+0x2b>
    ;
  *s = 0;
ffff800000107f2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107f30:	c6 00 00             	movb   $0x0,(%rax)
  return os;
ffff800000107f33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000107f37:	c9                   	leaveq 
ffff800000107f38:	c3                   	retq   

ffff800000107f39 <strlen>:

int
strlen(const char *s)
{
ffff800000107f39:	f3 0f 1e fa          	endbr64 
ffff800000107f3d:	55                   	push   %rbp
ffff800000107f3e:	48 89 e5             	mov    %rsp,%rbp
ffff800000107f41:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000107f45:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
ffff800000107f49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000107f50:	eb 04                	jmp    ffff800000107f56 <strlen+0x1d>
ffff800000107f52:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000107f56:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107f59:	48 63 d0             	movslq %eax,%rdx
ffff800000107f5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107f60:	48 01 d0             	add    %rdx,%rax
ffff800000107f63:	0f b6 00             	movzbl (%rax),%eax
ffff800000107f66:	84 c0                	test   %al,%al
ffff800000107f68:	75 e8                	jne    ffff800000107f52 <strlen+0x19>
    ;
  return n;
ffff800000107f6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000107f6d:	c9                   	leaveq 
ffff800000107f6e:	c3                   	retq   

ffff800000107f6f <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
ffff800000107f6f:	55                   	push   %rbp
  pushq   %rbx
ffff800000107f70:	53                   	push   %rbx
  pushq   %r12
ffff800000107f71:	41 54                	push   %r12
  pushq   %r13
ffff800000107f73:	41 55                	push   %r13
  pushq   %r14
ffff800000107f75:	41 56                	push   %r14
  pushq   %r15
ffff800000107f77:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
ffff800000107f79:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
ffff800000107f7c:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
ffff800000107f7f:	41 5f                	pop    %r15
  popq    %r14
ffff800000107f81:	41 5e                	pop    %r14
  popq    %r13
ffff800000107f83:	41 5d                	pop    %r13
  popq    %r12
ffff800000107f85:	41 5c                	pop    %r12
  popq    %rbx
ffff800000107f87:	5b                   	pop    %rbx
  popq    %rbp
ffff800000107f88:	5d                   	pop    %rbp

  retq #??
ffff800000107f89:	c3                   	retq   

ffff800000107f8a <fetchint>:
#include "syscall.h"

// Fetch the int at addr from the current process.
int
fetchint(addr_t addr, int *ip)
{
ffff800000107f8a:	f3 0f 1e fa          	endbr64 
ffff800000107f8e:	55                   	push   %rbp
ffff800000107f8f:	48 89 e5             	mov    %rsp,%rbp
ffff800000107f92:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107f96:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107f9a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(addr >= proc->sz || addr+sizeof(int) > proc->sz)
ffff800000107f9e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107fa5:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107fa9:	48 8b 00             	mov    (%rax),%rax
ffff800000107fac:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000107fb0:	73 1b                	jae    ffff800000107fcd <fetchint+0x43>
ffff800000107fb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107fb6:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff800000107fba:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107fc1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107fc5:	48 8b 00             	mov    (%rax),%rax
ffff800000107fc8:	48 39 c2             	cmp    %rax,%rdx
ffff800000107fcb:	76 07                	jbe    ffff800000107fd4 <fetchint+0x4a>
    return -1;
ffff800000107fcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000107fd2:	eb 11                	jmp    ffff800000107fe5 <fetchint+0x5b>
  *ip = *(int*)(addr);
ffff800000107fd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107fd8:	8b 10                	mov    (%rax),%edx
ffff800000107fda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107fde:	89 10                	mov    %edx,(%rax)
  return 0;
ffff800000107fe0:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000107fe5:	c9                   	leaveq 
ffff800000107fe6:	c3                   	retq   

ffff800000107fe7 <fetchaddr>:

int
fetchaddr(addr_t addr, addr_t *ip)
{
ffff800000107fe7:	f3 0f 1e fa          	endbr64 
ffff800000107feb:	55                   	push   %rbp
ffff800000107fec:	48 89 e5             	mov    %rsp,%rbp
ffff800000107fef:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107ff3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107ff7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(addr >= proc->sz || addr+sizeof(addr_t) > proc->sz)
ffff800000107ffb:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108002:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108006:	48 8b 00             	mov    (%rax),%rax
ffff800000108009:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff80000010800d:	73 1b                	jae    ffff80000010802a <fetchaddr+0x43>
ffff80000010800f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108013:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000108017:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010801e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108022:	48 8b 00             	mov    (%rax),%rax
ffff800000108025:	48 39 c2             	cmp    %rax,%rdx
ffff800000108028:	76 07                	jbe    ffff800000108031 <fetchaddr+0x4a>
    return -1;
ffff80000010802a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010802f:	eb 13                	jmp    ffff800000108044 <fetchaddr+0x5d>
  *ip = *(addr_t*)(addr);
ffff800000108031:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108035:	48 8b 10             	mov    (%rax),%rdx
ffff800000108038:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010803c:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffff80000010803f:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000108044:	c9                   	leaveq 
ffff800000108045:	c3                   	retq   

ffff800000108046 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(addr_t addr, char **pp)
{
ffff800000108046:	f3 0f 1e fa          	endbr64 
ffff80000010804a:	55                   	push   %rbp
ffff80000010804b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010804e:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000108052:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000108056:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *s, *ep;

  if(addr >= proc->sz)
ffff80000010805a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108061:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108065:	48 8b 00             	mov    (%rax),%rax
ffff800000108068:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff80000010806c:	72 07                	jb     ffff800000108075 <fetchstr+0x2f>
    return -1;
ffff80000010806e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108073:	eb 5c                	jmp    ffff8000001080d1 <fetchstr+0x8b>
  *pp = (char*)addr;
ffff800000108075:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000108079:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010807d:	48 89 10             	mov    %rdx,(%rax)
  ep = (char*)proc->sz;
ffff800000108080:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108087:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010808b:	48 8b 00             	mov    (%rax),%rax
ffff80000010808e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(s = *pp; s < ep; s++)
ffff800000108092:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000108096:	48 8b 00             	mov    (%rax),%rax
ffff800000108099:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010809d:	eb 23                	jmp    ffff8000001080c2 <fetchstr+0x7c>
    if(*s == 0)
ffff80000010809f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001080a3:	0f b6 00             	movzbl (%rax),%eax
ffff8000001080a6:	84 c0                	test   %al,%al
ffff8000001080a8:	75 13                	jne    ffff8000001080bd <fetchstr+0x77>
      return s - *pp;
ffff8000001080aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001080ae:	48 8b 00             	mov    (%rax),%rax
ffff8000001080b1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001080b5:	48 29 c2             	sub    %rax,%rdx
ffff8000001080b8:	48 89 d0             	mov    %rdx,%rax
ffff8000001080bb:	eb 14                	jmp    ffff8000001080d1 <fetchstr+0x8b>
  for(s = *pp; s < ep; s++)
ffff8000001080bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff8000001080c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001080c6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffff8000001080ca:	72 d3                	jb     ffff80000010809f <fetchstr+0x59>
  return -1;
ffff8000001080cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff8000001080d1:	c9                   	leaveq 
ffff8000001080d2:	c3                   	retq   

ffff8000001080d3 <fetcharg>:

static addr_t
fetcharg(int n)
{
ffff8000001080d3:	f3 0f 1e fa          	endbr64 
ffff8000001080d7:	55                   	push   %rbp
ffff8000001080d8:	48 89 e5             	mov    %rsp,%rbp
ffff8000001080db:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001080df:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff8000001080e2:	83 7d fc 05          	cmpl   $0x5,-0x4(%rbp)
ffff8000001080e6:	0f 87 9c 00 00 00    	ja     ffff800000108188 <fetcharg+0xb5>
ffff8000001080ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001080ef:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff8000001080f6:	00 
ffff8000001080f7:	48 b8 f0 c8 10 00 00 	movabs $0xffff80000010c8f0,%rax
ffff8000001080fe:	80 ff ff 
ffff800000108101:	48 01 d0             	add    %rdx,%rax
ffff800000108104:	48 8b 00             	mov    (%rax),%rax
ffff800000108107:	3e ff e0             	notrack jmpq *%rax
  switch (n) {
  case 0: return proc->tf->rdi;
ffff80000010810a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108111:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108115:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000108119:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff80000010811d:	eb 7f                	jmp    ffff80000010819e <fetcharg+0xcb>
  case 1: return proc->tf->rsi;
ffff80000010811f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108126:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010812a:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff80000010812e:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000108132:	eb 6a                	jmp    ffff80000010819e <fetcharg+0xcb>
  case 2: return proc->tf->rdx;
ffff800000108134:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010813b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010813f:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000108143:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000108147:	eb 55                	jmp    ffff80000010819e <fetcharg+0xcb>
  case 3: return proc->tf->r10;
ffff800000108149:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108150:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108154:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000108158:	48 8b 40 48          	mov    0x48(%rax),%rax
ffff80000010815c:	eb 40                	jmp    ffff80000010819e <fetcharg+0xcb>
  case 4: return proc->tf->r8;
ffff80000010815e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108165:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108169:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff80000010816d:	48 8b 40 38          	mov    0x38(%rax),%rax
ffff800000108171:	eb 2b                	jmp    ffff80000010819e <fetcharg+0xcb>
  case 5: return proc->tf->r9;
ffff800000108173:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010817a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010817e:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000108182:	48 8b 40 40          	mov    0x40(%rax),%rax
ffff800000108186:	eb 16                	jmp    ffff80000010819e <fetcharg+0xcb>
  }
  panic("failed fetch");
ffff800000108188:	48 bf e0 c8 10 00 00 	movabs $0xffff80000010c8e0,%rdi
ffff80000010818f:	80 ff ff 
ffff800000108192:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000108199:	80 ff ff 
ffff80000010819c:	ff d0                	callq  *%rax
}
ffff80000010819e:	c9                   	leaveq 
ffff80000010819f:	c3                   	retq   

ffff8000001081a0 <argint>:

int
argint(int n, int *ip)
{
ffff8000001081a0:	f3 0f 1e fa          	endbr64 
ffff8000001081a4:	55                   	push   %rbp
ffff8000001081a5:	48 89 e5             	mov    %rsp,%rbp
ffff8000001081a8:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001081ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff8000001081af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  *ip = fetcharg(n);
ffff8000001081b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001081b6:	89 c7                	mov    %eax,%edi
ffff8000001081b8:	48 b8 d3 80 10 00 00 	movabs $0xffff8000001080d3,%rax
ffff8000001081bf:	80 ff ff 
ffff8000001081c2:	ff d0                	callq  *%rax
ffff8000001081c4:	89 c2                	mov    %eax,%edx
ffff8000001081c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001081ca:	89 10                	mov    %edx,(%rax)
  return 0;
ffff8000001081cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001081d1:	c9                   	leaveq 
ffff8000001081d2:	c3                   	retq   

ffff8000001081d3 <argaddr>:

int
argaddr(int n, addr_t *ip)
{
ffff8000001081d3:	f3 0f 1e fa          	endbr64 
ffff8000001081d7:	55                   	push   %rbp
ffff8000001081d8:	48 89 e5             	mov    %rsp,%rbp
ffff8000001081db:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001081df:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff8000001081e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  *ip = fetcharg(n);
ffff8000001081e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001081e9:	89 c7                	mov    %eax,%edi
ffff8000001081eb:	48 b8 d3 80 10 00 00 	movabs $0xffff8000001080d3,%rax
ffff8000001081f2:	80 ff ff 
ffff8000001081f5:	ff d0                	callq  *%rax
ffff8000001081f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001081fb:	48 89 02             	mov    %rax,(%rdx)
  return 0;
ffff8000001081fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000108203:	c9                   	leaveq 
ffff800000108204:	c3                   	retq   

ffff800000108205 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
ffff800000108205:	f3 0f 1e fa          	endbr64 
ffff800000108209:	55                   	push   %rbp
ffff80000010820a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010820d:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000108211:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000108214:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000108218:	89 55 e8             	mov    %edx,-0x18(%rbp)
  addr_t i;

  if(argaddr(n, &i) < 0)
ffff80000010821b:	48 8d 55 f8          	lea    -0x8(%rbp),%rdx
ffff80000010821f:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000108222:	48 89 d6             	mov    %rdx,%rsi
ffff800000108225:	89 c7                	mov    %eax,%edi
ffff800000108227:	48 b8 d3 81 10 00 00 	movabs $0xffff8000001081d3,%rax
ffff80000010822e:	80 ff ff 
ffff800000108231:	ff d0                	callq  *%rax
ffff800000108233:	85 c0                	test   %eax,%eax
ffff800000108235:	79 07                	jns    ffff80000010823e <argptr+0x39>
    return -1;
ffff800000108237:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010823c:	eb 59                	jmp    ffff800000108297 <argptr+0x92>
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
ffff80000010823e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
ffff800000108242:	78 39                	js     ffff80000010827d <argptr+0x78>
ffff800000108244:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108248:	89 c2                	mov    %eax,%edx
ffff80000010824a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108251:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108255:	48 8b 00             	mov    (%rax),%rax
ffff800000108258:	48 39 c2             	cmp    %rax,%rdx
ffff80000010825b:	73 20                	jae    ffff80000010827d <argptr+0x78>
ffff80000010825d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108261:	89 c2                	mov    %eax,%edx
ffff800000108263:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000108266:	01 d0                	add    %edx,%eax
ffff800000108268:	89 c2                	mov    %eax,%edx
ffff80000010826a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108271:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108275:	48 8b 00             	mov    (%rax),%rax
ffff800000108278:	48 39 c2             	cmp    %rax,%rdx
ffff80000010827b:	76 07                	jbe    ffff800000108284 <argptr+0x7f>
    return -1;
ffff80000010827d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108282:	eb 13                	jmp    ffff800000108297 <argptr+0x92>
  *pp = (char*)i;
ffff800000108284:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108288:	48 89 c2             	mov    %rax,%rdx
ffff80000010828b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010828f:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffff800000108292:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000108297:	c9                   	leaveq 
ffff800000108298:	c3                   	retq   

ffff800000108299 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
ffff800000108299:	f3 0f 1e fa          	endbr64 
ffff80000010829d:	55                   	push   %rbp
ffff80000010829e:	48 89 e5             	mov    %rsp,%rbp
ffff8000001082a1:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001082a5:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff8000001082a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int addr;
  if(argint(n, &addr) < 0)
ffff8000001082ac:	48 8d 55 fc          	lea    -0x4(%rbp),%rdx
ffff8000001082b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001082b3:	48 89 d6             	mov    %rdx,%rsi
ffff8000001082b6:	89 c7                	mov    %eax,%edi
ffff8000001082b8:	48 b8 a0 81 10 00 00 	movabs $0xffff8000001081a0,%rax
ffff8000001082bf:	80 ff ff 
ffff8000001082c2:	ff d0                	callq  *%rax
ffff8000001082c4:	85 c0                	test   %eax,%eax
ffff8000001082c6:	79 07                	jns    ffff8000001082cf <argstr+0x36>
    return -1;
ffff8000001082c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001082cd:	eb 1b                	jmp    ffff8000001082ea <argstr+0x51>
  return fetchstr(addr, pp);
ffff8000001082cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001082d2:	48 98                	cltq   
ffff8000001082d4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff8000001082d8:	48 89 d6             	mov    %rdx,%rsi
ffff8000001082db:	48 89 c7             	mov    %rax,%rdi
ffff8000001082de:	48 b8 46 80 10 00 00 	movabs $0xffff800000108046,%rax
ffff8000001082e5:	80 ff ff 
ffff8000001082e8:	ff d0                	callq  *%rax
}
ffff8000001082ea:	c9                   	leaveq 
ffff8000001082eb:	c3                   	retq   

ffff8000001082ec <syscall>:
[SYS_freepages] sys_freepages,
};

void
syscall(struct trapframe *tf)
{
ffff8000001082ec:	f3 0f 1e fa          	endbr64 
ffff8000001082f0:	55                   	push   %rbp
ffff8000001082f1:	48 89 e5             	mov    %rsp,%rbp
ffff8000001082f4:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001082f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  if (proc->killed)
ffff8000001082fc:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108303:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108307:	8b 40 40             	mov    0x40(%rax),%eax
ffff80000010830a:	85 c0                	test   %eax,%eax
ffff80000010830c:	74 0c                	je     ffff80000010831a <syscall+0x2e>
    exit();
ffff80000010830e:	48 b8 d3 6b 10 00 00 	movabs $0xffff800000106bd3,%rax
ffff800000108315:	80 ff ff 
ffff800000108318:	ff d0                	callq  *%rax
  proc->tf = tf;
ffff80000010831a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108321:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108325:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000108329:	48 89 50 28          	mov    %rdx,0x28(%rax)
  uint64 num = proc->tf->rax;
ffff80000010832d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108334:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108338:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff80000010833c:	48 8b 00             	mov    (%rax),%rax
ffff80000010833f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
ffff800000108343:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108348:	74 3b                	je     ffff800000108385 <syscall+0x99>
ffff80000010834a:	48 83 7d f8 17       	cmpq   $0x17,-0x8(%rbp)
ffff80000010834f:	77 34                	ja     ffff800000108385 <syscall+0x99>
ffff800000108351:	48 ba a0 d5 10 00 00 	movabs $0xffff80000010d5a0,%rdx
ffff800000108358:	80 ff ff 
ffff80000010835b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010835f:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
ffff800000108363:	48 85 c0             	test   %rax,%rax
ffff800000108366:	74 1d                	je     ffff800000108385 <syscall+0x99>
    tf->rax = syscalls[num]();
ffff800000108368:	48 ba a0 d5 10 00 00 	movabs $0xffff80000010d5a0,%rdx
ffff80000010836f:	80 ff ff 
ffff800000108372:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108376:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
ffff80000010837a:	ff d0                	callq  *%rax
ffff80000010837c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000108380:	48 89 02             	mov    %rax,(%rdx)
ffff800000108383:	eb 53                	jmp    ffff8000001083d8 <syscall+0xec>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
ffff800000108385:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010838c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108390:	48 8d b0 d0 00 00 00 	lea    0xd0(%rax),%rsi
ffff800000108397:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010839e:	64 48 8b 00          	mov    %fs:(%rax),%rax
    cprintf("%d %s: unknown sys call %d\n",
ffff8000001083a2:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff8000001083a5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001083a9:	48 89 d1             	mov    %rdx,%rcx
ffff8000001083ac:	48 89 f2             	mov    %rsi,%rdx
ffff8000001083af:	89 c6                	mov    %eax,%esi
ffff8000001083b1:	48 bf 20 c9 10 00 00 	movabs $0xffff80000010c920,%rdi
ffff8000001083b8:	80 ff ff 
ffff8000001083bb:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001083c0:	49 b8 18 08 10 00 00 	movabs $0xffff800000100818,%r8
ffff8000001083c7:	80 ff ff 
ffff8000001083ca:	41 ff d0             	callq  *%r8
    tf->rax = -1;
ffff8000001083cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001083d1:	48 c7 00 ff ff ff ff 	movq   $0xffffffffffffffff,(%rax)
  }
  if (proc->killed)
ffff8000001083d8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001083df:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001083e3:	8b 40 40             	mov    0x40(%rax),%eax
ffff8000001083e6:	85 c0                	test   %eax,%eax
ffff8000001083e8:	74 0c                	je     ffff8000001083f6 <syscall+0x10a>
    exit();
ffff8000001083ea:	48 b8 d3 6b 10 00 00 	movabs $0xffff800000106bd3,%rax
ffff8000001083f1:	80 ff ff 
ffff8000001083f4:	ff d0                	callq  *%rax
}
ffff8000001083f6:	90                   	nop
ffff8000001083f7:	c9                   	leaveq 
ffff8000001083f8:	c3                   	retq   

ffff8000001083f9 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
ffff8000001083f9:	f3 0f 1e fa          	endbr64 
ffff8000001083fd:	55                   	push   %rbp
ffff8000001083fe:	48 89 e5             	mov    %rsp,%rbp
ffff800000108401:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000108405:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000108408:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010840c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
ffff800000108410:	48 8d 55 f4          	lea    -0xc(%rbp),%rdx
ffff800000108414:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000108417:	48 89 d6             	mov    %rdx,%rsi
ffff80000010841a:	89 c7                	mov    %eax,%edi
ffff80000010841c:	48 b8 a0 81 10 00 00 	movabs $0xffff8000001081a0,%rax
ffff800000108423:	80 ff ff 
ffff800000108426:	ff d0                	callq  *%rax
ffff800000108428:	85 c0                	test   %eax,%eax
ffff80000010842a:	79 07                	jns    ffff800000108433 <argfd+0x3a>
    return -1;
ffff80000010842c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108431:	eb 62                	jmp    ffff800000108495 <argfd+0x9c>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
ffff800000108433:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000108436:	85 c0                	test   %eax,%eax
ffff800000108438:	78 2d                	js     ffff800000108467 <argfd+0x6e>
ffff80000010843a:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010843d:	83 f8 0f             	cmp    $0xf,%eax
ffff800000108440:	7f 25                	jg     ffff800000108467 <argfd+0x6e>
ffff800000108442:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108449:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010844d:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000108450:	48 63 d2             	movslq %edx,%rdx
ffff800000108453:	48 83 c2 08          	add    $0x8,%rdx
ffff800000108457:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff80000010845c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108460:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108465:	75 07                	jne    ffff80000010846e <argfd+0x75>
    return -1;
ffff800000108467:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010846c:	eb 27                	jmp    ffff800000108495 <argfd+0x9c>
  if(pfd)
ffff80000010846e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffff800000108473:	74 09                	je     ffff80000010847e <argfd+0x85>
    *pfd = fd;
ffff800000108475:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000108478:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010847c:	89 10                	mov    %edx,(%rax)
  if(pf)
ffff80000010847e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffff800000108483:	74 0b                	je     ffff800000108490 <argfd+0x97>
    *pf = f;
ffff800000108485:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000108489:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010848d:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffff800000108490:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000108495:	c9                   	leaveq 
ffff800000108496:	c3                   	retq   

ffff800000108497 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
ffff800000108497:	f3 0f 1e fa          	endbr64 
ffff80000010849b:	55                   	push   %rbp
ffff80000010849c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010849f:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001084a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
ffff8000001084a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001084ae:	eb 46                	jmp    ffff8000001084f6 <fdalloc+0x5f>
    if(proc->ofile[fd] == 0){
ffff8000001084b0:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001084b7:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001084bb:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001084be:	48 63 d2             	movslq %edx,%rdx
ffff8000001084c1:	48 83 c2 08          	add    $0x8,%rdx
ffff8000001084c5:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff8000001084ca:	48 85 c0             	test   %rax,%rax
ffff8000001084cd:	75 23                	jne    ffff8000001084f2 <fdalloc+0x5b>
      proc->ofile[fd] = f;
ffff8000001084cf:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001084d6:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001084da:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001084dd:	48 63 d2             	movslq %edx,%rdx
ffff8000001084e0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
ffff8000001084e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001084e8:	48 89 54 c8 08       	mov    %rdx,0x8(%rax,%rcx,8)
      return fd;
ffff8000001084ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001084f0:	eb 0f                	jmp    ffff800000108501 <fdalloc+0x6a>
  for(fd = 0; fd < NOFILE; fd++){
ffff8000001084f2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001084f6:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
ffff8000001084fa:	7e b4                	jle    ffff8000001084b0 <fdalloc+0x19>
    }
  }
  return -1;
ffff8000001084fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000108501:	c9                   	leaveq 
ffff800000108502:	c3                   	retq   

ffff800000108503 <sys_dup>:

int
sys_dup(void)
{
ffff800000108503:	f3 0f 1e fa          	endbr64 
ffff800000108507:	55                   	push   %rbp
ffff800000108508:	48 89 e5             	mov    %rsp,%rbp
ffff80000010850b:	48 83 ec 10          	sub    $0x10,%rsp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
ffff80000010850f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000108513:	48 89 c2             	mov    %rax,%rdx
ffff800000108516:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010851b:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108520:	48 b8 f9 83 10 00 00 	movabs $0xffff8000001083f9,%rax
ffff800000108527:	80 ff ff 
ffff80000010852a:	ff d0                	callq  *%rax
ffff80000010852c:	85 c0                	test   %eax,%eax
ffff80000010852e:	79 07                	jns    ffff800000108537 <sys_dup+0x34>
    return -1;
ffff800000108530:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108535:	eb 39                	jmp    ffff800000108570 <sys_dup+0x6d>
  if((fd=fdalloc(f)) < 0)
ffff800000108537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010853b:	48 89 c7             	mov    %rax,%rdi
ffff80000010853e:	48 b8 97 84 10 00 00 	movabs $0xffff800000108497,%rax
ffff800000108545:	80 ff ff 
ffff800000108548:	ff d0                	callq  *%rax
ffff80000010854a:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff80000010854d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000108551:	79 07                	jns    ffff80000010855a <sys_dup+0x57>
    return -1;
ffff800000108553:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108558:	eb 16                	jmp    ffff800000108570 <sys_dup+0x6d>
  filedup(f);
ffff80000010855a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010855e:	48 89 c7             	mov    %rax,%rdi
ffff800000108561:	48 b8 1a 1c 10 00 00 	movabs $0xffff800000101c1a,%rax
ffff800000108568:	80 ff ff 
ffff80000010856b:	ff d0                	callq  *%rax
  return fd;
ffff80000010856d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000108570:	c9                   	leaveq 
ffff800000108571:	c3                   	retq   

ffff800000108572 <sys_read>:

int
sys_read(void)
{
ffff800000108572:	f3 0f 1e fa          	endbr64 
ffff800000108576:	55                   	push   %rbp
ffff800000108577:	48 89 e5             	mov    %rsp,%rbp
ffff80000010857a:	48 83 ec 20          	sub    $0x20,%rsp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
ffff80000010857e:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff800000108582:	48 89 c2             	mov    %rax,%rdx
ffff800000108585:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010858a:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010858f:	48 b8 f9 83 10 00 00 	movabs $0xffff8000001083f9,%rax
ffff800000108596:	80 ff ff 
ffff800000108599:	ff d0                	callq  *%rax
ffff80000010859b:	85 c0                	test   %eax,%eax
ffff80000010859d:	78 3b                	js     ffff8000001085da <sys_read+0x68>
ffff80000010859f:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
ffff8000001085a3:	48 89 c6             	mov    %rax,%rsi
ffff8000001085a6:	bf 02 00 00 00       	mov    $0x2,%edi
ffff8000001085ab:	48 b8 a0 81 10 00 00 	movabs $0xffff8000001081a0,%rax
ffff8000001085b2:	80 ff ff 
ffff8000001085b5:	ff d0                	callq  *%rax
ffff8000001085b7:	85 c0                	test   %eax,%eax
ffff8000001085b9:	78 1f                	js     ffff8000001085da <sys_read+0x68>
ffff8000001085bb:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff8000001085be:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff8000001085c2:	48 89 c6             	mov    %rax,%rsi
ffff8000001085c5:	bf 01 00 00 00       	mov    $0x1,%edi
ffff8000001085ca:	48 b8 05 82 10 00 00 	movabs $0xffff800000108205,%rax
ffff8000001085d1:	80 ff ff 
ffff8000001085d4:	ff d0                	callq  *%rax
ffff8000001085d6:	85 c0                	test   %eax,%eax
ffff8000001085d8:	79 07                	jns    ffff8000001085e1 <sys_read+0x6f>
    return -1;
ffff8000001085da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001085df:	eb 1d                	jmp    ffff8000001085fe <sys_read+0x8c>
  return fileread(f, p, n);
ffff8000001085e1:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff8000001085e4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff8000001085e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001085ec:	48 89 ce             	mov    %rcx,%rsi
ffff8000001085ef:	48 89 c7             	mov    %rax,%rdi
ffff8000001085f2:	48 b8 46 1e 10 00 00 	movabs $0xffff800000101e46,%rax
ffff8000001085f9:	80 ff ff 
ffff8000001085fc:	ff d0                	callq  *%rax
}
ffff8000001085fe:	c9                   	leaveq 
ffff8000001085ff:	c3                   	retq   

ffff800000108600 <sys_write>:

int
sys_write(void)
{
ffff800000108600:	f3 0f 1e fa          	endbr64 
ffff800000108604:	55                   	push   %rbp
ffff800000108605:	48 89 e5             	mov    %rsp,%rbp
ffff800000108608:	48 83 ec 20          	sub    $0x20,%rsp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
ffff80000010860c:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff800000108610:	48 89 c2             	mov    %rax,%rdx
ffff800000108613:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000108618:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010861d:	48 b8 f9 83 10 00 00 	movabs $0xffff8000001083f9,%rax
ffff800000108624:	80 ff ff 
ffff800000108627:	ff d0                	callq  *%rax
ffff800000108629:	85 c0                	test   %eax,%eax
ffff80000010862b:	78 3b                	js     ffff800000108668 <sys_write+0x68>
ffff80000010862d:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
ffff800000108631:	48 89 c6             	mov    %rax,%rsi
ffff800000108634:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000108639:	48 b8 a0 81 10 00 00 	movabs $0xffff8000001081a0,%rax
ffff800000108640:	80 ff ff 
ffff800000108643:	ff d0                	callq  *%rax
ffff800000108645:	85 c0                	test   %eax,%eax
ffff800000108647:	78 1f                	js     ffff800000108668 <sys_write+0x68>
ffff800000108649:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff80000010864c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff800000108650:	48 89 c6             	mov    %rax,%rsi
ffff800000108653:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000108658:	48 b8 05 82 10 00 00 	movabs $0xffff800000108205,%rax
ffff80000010865f:	80 ff ff 
ffff800000108662:	ff d0                	callq  *%rax
ffff800000108664:	85 c0                	test   %eax,%eax
ffff800000108666:	79 07                	jns    ffff80000010866f <sys_write+0x6f>
    return -1;
ffff800000108668:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010866d:	eb 1d                	jmp    ffff80000010868c <sys_write+0x8c>
  return filewrite(f, p, n);
ffff80000010866f:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000108672:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff800000108676:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010867a:	48 89 ce             	mov    %rcx,%rsi
ffff80000010867d:	48 89 c7             	mov    %rax,%rdi
ffff800000108680:	48 b8 3b 1f 10 00 00 	movabs $0xffff800000101f3b,%rax
ffff800000108687:	80 ff ff 
ffff80000010868a:	ff d0                	callq  *%rax
}
ffff80000010868c:	c9                   	leaveq 
ffff80000010868d:	c3                   	retq   

ffff80000010868e <sys_close>:

int
sys_close(void)
{
ffff80000010868e:	f3 0f 1e fa          	endbr64 
ffff800000108692:	55                   	push   %rbp
ffff800000108693:	48 89 e5             	mov    %rsp,%rbp
ffff800000108696:	48 83 ec 10          	sub    $0x10,%rsp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
ffff80000010869a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
ffff80000010869e:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
ffff8000001086a2:	48 89 c6             	mov    %rax,%rsi
ffff8000001086a5:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001086aa:	48 b8 f9 83 10 00 00 	movabs $0xffff8000001083f9,%rax
ffff8000001086b1:	80 ff ff 
ffff8000001086b4:	ff d0                	callq  *%rax
ffff8000001086b6:	85 c0                	test   %eax,%eax
ffff8000001086b8:	79 07                	jns    ffff8000001086c1 <sys_close+0x33>
    return -1;
ffff8000001086ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001086bf:	eb 36                	jmp    ffff8000001086f7 <sys_close+0x69>
  proc->ofile[fd] = 0;
ffff8000001086c1:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001086c8:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001086cc:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001086cf:	48 63 d2             	movslq %edx,%rdx
ffff8000001086d2:	48 83 c2 08          	add    $0x8,%rdx
ffff8000001086d6:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
ffff8000001086dd:	00 00 
  fileclose(f);
ffff8000001086df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001086e3:	48 89 c7             	mov    %rax,%rdi
ffff8000001086e6:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff8000001086ed:	80 ff ff 
ffff8000001086f0:	ff d0                	callq  *%rax
  return 0;
ffff8000001086f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001086f7:	c9                   	leaveq 
ffff8000001086f8:	c3                   	retq   

ffff8000001086f9 <sys_fstat>:

int
sys_fstat(void)
{
ffff8000001086f9:	f3 0f 1e fa          	endbr64 
ffff8000001086fd:	55                   	push   %rbp
ffff8000001086fe:	48 89 e5             	mov    %rsp,%rbp
ffff800000108701:	48 83 ec 10          	sub    $0x10,%rsp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
ffff800000108705:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff800000108709:	48 89 c2             	mov    %rax,%rdx
ffff80000010870c:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000108711:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108716:	48 b8 f9 83 10 00 00 	movabs $0xffff8000001083f9,%rax
ffff80000010871d:	80 ff ff 
ffff800000108720:	ff d0                	callq  *%rax
ffff800000108722:	85 c0                	test   %eax,%eax
ffff800000108724:	78 21                	js     ffff800000108747 <sys_fstat+0x4e>
ffff800000108726:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff80000010872a:	ba 14 00 00 00       	mov    $0x14,%edx
ffff80000010872f:	48 89 c6             	mov    %rax,%rsi
ffff800000108732:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000108737:	48 b8 05 82 10 00 00 	movabs $0xffff800000108205,%rax
ffff80000010873e:	80 ff ff 
ffff800000108741:	ff d0                	callq  *%rax
ffff800000108743:	85 c0                	test   %eax,%eax
ffff800000108745:	79 07                	jns    ffff80000010874e <sys_fstat+0x55>
    return -1;
ffff800000108747:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010874c:	eb 1a                	jmp    ffff800000108768 <sys_fstat+0x6f>
  return filestat(f, st);
ffff80000010874e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000108752:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108756:	48 89 d6             	mov    %rdx,%rsi
ffff800000108759:	48 89 c7             	mov    %rax,%rdi
ffff80000010875c:	48 b8 cd 1d 10 00 00 	movabs $0xffff800000101dcd,%rax
ffff800000108763:	80 ff ff 
ffff800000108766:	ff d0                	callq  *%rax
}
ffff800000108768:	c9                   	leaveq 
ffff800000108769:	c3                   	retq   

ffff80000010876a <isdirempty>:

static int
isdirempty(struct inode *dp)
{
ffff80000010876a:	f3 0f 1e fa          	endbr64 
ffff80000010876e:	55                   	push   %rbp
ffff80000010876f:	48 89 e5             	mov    %rsp,%rbp
ffff800000108772:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000108776:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  int off;
  struct dirent de;
  // Is the directory dp empty except for "." and ".." ?
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
ffff80000010877a:	c7 45 fc 20 00 00 00 	movl   $0x20,-0x4(%rbp)
ffff800000108781:	eb 53                	jmp    ffff8000001087d6 <isdirempty+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff800000108783:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000108786:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff80000010878a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010878e:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff800000108793:	48 89 c7             	mov    %rax,%rdi
ffff800000108796:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff80000010879d:	80 ff ff 
ffff8000001087a0:	ff d0                	callq  *%rax
ffff8000001087a2:	83 f8 10             	cmp    $0x10,%eax
ffff8000001087a5:	74 16                	je     ffff8000001087bd <isdirempty+0x53>
      panic("isdirempty: readi");
ffff8000001087a7:	48 bf 3c c9 10 00 00 	movabs $0xffff80000010c93c,%rdi
ffff8000001087ae:	80 ff ff 
ffff8000001087b1:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001087b8:	80 ff ff 
ffff8000001087bb:	ff d0                	callq  *%rax
    if(de.inum != 0)
ffff8000001087bd:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff8000001087c1:	66 85 c0             	test   %ax,%ax
ffff8000001087c4:	74 07                	je     ffff8000001087cd <isdirempty+0x63>
      return 0;
ffff8000001087c6:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001087cb:	eb 1f                	jmp    ffff8000001087ec <isdirempty+0x82>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
ffff8000001087cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001087d0:	83 c0 10             	add    $0x10,%eax
ffff8000001087d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff8000001087d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001087da:	8b 90 9c 00 00 00    	mov    0x9c(%rax),%edx
ffff8000001087e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001087e3:	39 c2                	cmp    %eax,%edx
ffff8000001087e5:	77 9c                	ja     ffff800000108783 <isdirempty+0x19>
  }
  return 1;
ffff8000001087e7:	b8 01 00 00 00       	mov    $0x1,%eax
}
ffff8000001087ec:	c9                   	leaveq 
ffff8000001087ed:	c3                   	retq   

ffff8000001087ee <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
ffff8000001087ee:	f3 0f 1e fa          	endbr64 
ffff8000001087f2:	55                   	push   %rbp
ffff8000001087f3:	48 89 e5             	mov    %rsp,%rbp
ffff8000001087f6:	48 83 ec 30          	sub    $0x30,%rsp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
ffff8000001087fa:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
ffff8000001087fe:	48 89 c6             	mov    %rax,%rsi
ffff800000108801:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108806:	48 b8 99 82 10 00 00 	movabs $0xffff800000108299,%rax
ffff80000010880d:	80 ff ff 
ffff800000108810:	ff d0                	callq  *%rax
ffff800000108812:	85 c0                	test   %eax,%eax
ffff800000108814:	78 1c                	js     ffff800000108832 <sys_link+0x44>
ffff800000108816:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
ffff80000010881a:	48 89 c6             	mov    %rax,%rsi
ffff80000010881d:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000108822:	48 b8 99 82 10 00 00 	movabs $0xffff800000108299,%rax
ffff800000108829:	80 ff ff 
ffff80000010882c:	ff d0                	callq  *%rax
ffff80000010882e:	85 c0                	test   %eax,%eax
ffff800000108830:	79 0a                	jns    ffff80000010883c <sys_link+0x4e>
    return -1;
ffff800000108832:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108837:	e9 0c 02 00 00       	jmpq   ffff800000108a48 <sys_link+0x25a>

  begin_op();
ffff80000010883c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108841:	48 ba ab 52 10 00 00 	movabs $0xffff8000001052ab,%rdx
ffff800000108848:	80 ff ff 
ffff80000010884b:	ff d2                	callq  *%rdx
  if((ip = namei(old)) == 0){
ffff80000010884d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000108851:	48 89 c7             	mov    %rax,%rdi
ffff800000108854:	48 b8 ff 37 10 00 00 	movabs $0xffff8000001037ff,%rax
ffff80000010885b:	80 ff ff 
ffff80000010885e:	ff d0                	callq  *%rax
ffff800000108860:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108864:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108869:	75 1b                	jne    ffff800000108886 <sys_link+0x98>
    end_op();
ffff80000010886b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108870:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff800000108877:	80 ff ff 
ffff80000010887a:	ff d2                	callq  *%rdx
    return -1;
ffff80000010887c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108881:	e9 c2 01 00 00       	jmpq   ffff800000108a48 <sys_link+0x25a>
  }

  ilock(ip);
ffff800000108886:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010888a:	48 89 c7             	mov    %rax,%rdi
ffff80000010888d:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000108894:	80 ff ff 
ffff800000108897:	ff d0                	callq  *%rax
  if(ip->type == T_DIR){
ffff800000108899:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010889d:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff8000001088a4:	66 83 f8 01          	cmp    $0x1,%ax
ffff8000001088a8:	75 2e                	jne    ffff8000001088d8 <sys_link+0xea>
    iunlockput(ip);
ffff8000001088aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001088ae:	48 89 c7             	mov    %rax,%rdi
ffff8000001088b1:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff8000001088b8:	80 ff ff 
ffff8000001088bb:	ff d0                	callq  *%rax
    end_op();
ffff8000001088bd:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001088c2:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff8000001088c9:	80 ff ff 
ffff8000001088cc:	ff d2                	callq  *%rdx
    return -1;
ffff8000001088ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001088d3:	e9 70 01 00 00       	jmpq   ffff800000108a48 <sys_link+0x25a>
  }

  ip->nlink++;
ffff8000001088d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001088dc:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff8000001088e3:	83 c0 01             	add    $0x1,%eax
ffff8000001088e6:	89 c2                	mov    %eax,%edx
ffff8000001088e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001088ec:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
  iupdate(ip);
ffff8000001088f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001088f7:	48 89 c7             	mov    %rax,%rdi
ffff8000001088fa:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff800000108901:	80 ff ff 
ffff800000108904:	ff d0                	callq  *%rax
  iunlock(ip);
ffff800000108906:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010890a:	48 89 c7             	mov    %rax,%rdi
ffff80000010890d:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000108914:	80 ff ff 
ffff800000108917:	ff d0                	callq  *%rax

  if((dp = nameiparent(new, name)) == 0)
ffff800000108919:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010891d:	48 8d 55 e2          	lea    -0x1e(%rbp),%rdx
ffff800000108921:	48 89 d6             	mov    %rdx,%rsi
ffff800000108924:	48 89 c7             	mov    %rax,%rdi
ffff800000108927:	48 b8 2d 38 10 00 00 	movabs $0xffff80000010382d,%rax
ffff80000010892e:	80 ff ff 
ffff800000108931:	ff d0                	callq  *%rax
ffff800000108933:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000108937:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010893c:	0f 84 9b 00 00 00    	je     ffff8000001089dd <sys_link+0x1ef>
    goto bad;
  ilock(dp);
ffff800000108942:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108946:	48 89 c7             	mov    %rax,%rdi
ffff800000108949:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000108950:	80 ff ff 
ffff800000108953:	ff d0                	callq  *%rax
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
ffff800000108955:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108959:	8b 10                	mov    (%rax),%edx
ffff80000010895b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010895f:	8b 00                	mov    (%rax),%eax
ffff800000108961:	39 c2                	cmp    %eax,%edx
ffff800000108963:	75 25                	jne    ffff80000010898a <sys_link+0x19c>
ffff800000108965:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108969:	8b 50 04             	mov    0x4(%rax),%edx
ffff80000010896c:	48 8d 4d e2          	lea    -0x1e(%rbp),%rcx
ffff800000108970:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108974:	48 89 ce             	mov    %rcx,%rsi
ffff800000108977:	48 89 c7             	mov    %rax,%rdi
ffff80000010897a:	48 b8 6f 34 10 00 00 	movabs $0xffff80000010346f,%rax
ffff800000108981:	80 ff ff 
ffff800000108984:	ff d0                	callq  *%rax
ffff800000108986:	85 c0                	test   %eax,%eax
ffff800000108988:	79 15                	jns    ffff80000010899f <sys_link+0x1b1>
    iunlockput(dp);
ffff80000010898a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010898e:	48 89 c7             	mov    %rax,%rdi
ffff800000108991:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108998:	80 ff ff 
ffff80000010899b:	ff d0                	callq  *%rax
    goto bad;
ffff80000010899d:	eb 3f                	jmp    ffff8000001089de <sys_link+0x1f0>
  }
  iunlockput(dp);
ffff80000010899f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001089a3:	48 89 c7             	mov    %rax,%rdi
ffff8000001089a6:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff8000001089ad:	80 ff ff 
ffff8000001089b0:	ff d0                	callq  *%rax
  iput(ip);
ffff8000001089b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001089b6:	48 89 c7             	mov    %rax,%rdi
ffff8000001089b9:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff8000001089c0:	80 ff ff 
ffff8000001089c3:	ff d0                	callq  *%rax

  end_op();
ffff8000001089c5:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001089ca:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff8000001089d1:	80 ff ff 
ffff8000001089d4:	ff d2                	callq  *%rdx

  return 0;
ffff8000001089d6:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001089db:	eb 6b                	jmp    ffff800000108a48 <sys_link+0x25a>
    goto bad;
ffff8000001089dd:	90                   	nop

bad:
  ilock(ip);
ffff8000001089de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001089e2:	48 89 c7             	mov    %rax,%rdi
ffff8000001089e5:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff8000001089ec:	80 ff ff 
ffff8000001089ef:	ff d0                	callq  *%rax
  ip->nlink--;
ffff8000001089f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001089f5:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff8000001089fc:	83 e8 01             	sub    $0x1,%eax
ffff8000001089ff:	89 c2                	mov    %eax,%edx
ffff800000108a01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108a05:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
  iupdate(ip);
ffff800000108a0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108a10:	48 89 c7             	mov    %rax,%rdi
ffff800000108a13:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff800000108a1a:	80 ff ff 
ffff800000108a1d:	ff d0                	callq  *%rax
  iunlockput(ip);
ffff800000108a1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108a23:	48 89 c7             	mov    %rax,%rdi
ffff800000108a26:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108a2d:	80 ff ff 
ffff800000108a30:	ff d0                	callq  *%rax
  end_op();
ffff800000108a32:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108a37:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff800000108a3e:	80 ff ff 
ffff800000108a41:	ff d2                	callq  *%rdx
  return -1;
ffff800000108a43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000108a48:	c9                   	leaveq 
ffff800000108a49:	c3                   	retq   

ffff800000108a4a <sys_unlink>:
//PAGEBREAK!

int
sys_unlink(void)
{
ffff800000108a4a:	f3 0f 1e fa          	endbr64 
ffff800000108a4e:	55                   	push   %rbp
ffff800000108a4f:	48 89 e5             	mov    %rsp,%rbp
ffff800000108a52:	48 83 ec 40          	sub    $0x40,%rsp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
ffff800000108a56:	48 8d 45 c8          	lea    -0x38(%rbp),%rax
ffff800000108a5a:	48 89 c6             	mov    %rax,%rsi
ffff800000108a5d:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108a62:	48 b8 99 82 10 00 00 	movabs $0xffff800000108299,%rax
ffff800000108a69:	80 ff ff 
ffff800000108a6c:	ff d0                	callq  *%rax
ffff800000108a6e:	85 c0                	test   %eax,%eax
ffff800000108a70:	79 0a                	jns    ffff800000108a7c <sys_unlink+0x32>
    return -1;
ffff800000108a72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108a77:	e9 83 02 00 00       	jmpq   ffff800000108cff <sys_unlink+0x2b5>

  begin_op();
ffff800000108a7c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108a81:	48 ba ab 52 10 00 00 	movabs $0xffff8000001052ab,%rdx
ffff800000108a88:	80 ff ff 
ffff800000108a8b:	ff d2                	callq  *%rdx
  if((dp = nameiparent(path, name)) == 0){
ffff800000108a8d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000108a91:	48 8d 55 d2          	lea    -0x2e(%rbp),%rdx
ffff800000108a95:	48 89 d6             	mov    %rdx,%rsi
ffff800000108a98:	48 89 c7             	mov    %rax,%rdi
ffff800000108a9b:	48 b8 2d 38 10 00 00 	movabs $0xffff80000010382d,%rax
ffff800000108aa2:	80 ff ff 
ffff800000108aa5:	ff d0                	callq  *%rax
ffff800000108aa7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108aab:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108ab0:	75 1b                	jne    ffff800000108acd <sys_unlink+0x83>
    end_op();
ffff800000108ab2:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108ab7:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff800000108abe:	80 ff ff 
ffff800000108ac1:	ff d2                	callq  *%rdx
    return -1;
ffff800000108ac3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108ac8:	e9 32 02 00 00       	jmpq   ffff800000108cff <sys_unlink+0x2b5>
  }

  ilock(dp);
ffff800000108acd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108ad1:	48 89 c7             	mov    %rax,%rdi
ffff800000108ad4:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000108adb:	80 ff ff 
ffff800000108ade:	ff d0                	callq  *%rax

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
ffff800000108ae0:	48 8d 45 d2          	lea    -0x2e(%rbp),%rax
ffff800000108ae4:	48 be 4e c9 10 00 00 	movabs $0xffff80000010c94e,%rsi
ffff800000108aeb:	80 ff ff 
ffff800000108aee:	48 89 c7             	mov    %rax,%rdi
ffff800000108af1:	48 b8 36 33 10 00 00 	movabs $0xffff800000103336,%rax
ffff800000108af8:	80 ff ff 
ffff800000108afb:	ff d0                	callq  *%rax
ffff800000108afd:	85 c0                	test   %eax,%eax
ffff800000108aff:	0f 84 cd 01 00 00    	je     ffff800000108cd2 <sys_unlink+0x288>
ffff800000108b05:	48 8d 45 d2          	lea    -0x2e(%rbp),%rax
ffff800000108b09:	48 be 50 c9 10 00 00 	movabs $0xffff80000010c950,%rsi
ffff800000108b10:	80 ff ff 
ffff800000108b13:	48 89 c7             	mov    %rax,%rdi
ffff800000108b16:	48 b8 36 33 10 00 00 	movabs $0xffff800000103336,%rax
ffff800000108b1d:	80 ff ff 
ffff800000108b20:	ff d0                	callq  *%rax
ffff800000108b22:	85 c0                	test   %eax,%eax
ffff800000108b24:	0f 84 a8 01 00 00    	je     ffff800000108cd2 <sys_unlink+0x288>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
ffff800000108b2a:	48 8d 55 c4          	lea    -0x3c(%rbp),%rdx
ffff800000108b2e:	48 8d 4d d2          	lea    -0x2e(%rbp),%rcx
ffff800000108b32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108b36:	48 89 ce             	mov    %rcx,%rsi
ffff800000108b39:	48 89 c7             	mov    %rax,%rdi
ffff800000108b3c:	48 b8 6b 33 10 00 00 	movabs $0xffff80000010336b,%rax
ffff800000108b43:	80 ff ff 
ffff800000108b46:	ff d0                	callq  *%rax
ffff800000108b48:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000108b4c:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000108b51:	0f 84 7e 01 00 00    	je     ffff800000108cd5 <sys_unlink+0x28b>
    goto bad;
  ilock(ip);
ffff800000108b57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108b5b:	48 89 c7             	mov    %rax,%rdi
ffff800000108b5e:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000108b65:	80 ff ff 
ffff800000108b68:	ff d0                	callq  *%rax

  if(ip->nlink < 1)
ffff800000108b6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108b6e:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000108b75:	66 85 c0             	test   %ax,%ax
ffff800000108b78:	7f 16                	jg     ffff800000108b90 <sys_unlink+0x146>
    panic("unlink: nlink < 1");
ffff800000108b7a:	48 bf 53 c9 10 00 00 	movabs $0xffff80000010c953,%rdi
ffff800000108b81:	80 ff ff 
ffff800000108b84:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000108b8b:	80 ff ff 
ffff800000108b8e:	ff d0                	callq  *%rax
  if(ip->type == T_DIR && !isdirempty(ip)){
ffff800000108b90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108b94:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000108b9b:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000108b9f:	75 2f                	jne    ffff800000108bd0 <sys_unlink+0x186>
ffff800000108ba1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108ba5:	48 89 c7             	mov    %rax,%rdi
ffff800000108ba8:	48 b8 6a 87 10 00 00 	movabs $0xffff80000010876a,%rax
ffff800000108baf:	80 ff ff 
ffff800000108bb2:	ff d0                	callq  *%rax
ffff800000108bb4:	85 c0                	test   %eax,%eax
ffff800000108bb6:	75 18                	jne    ffff800000108bd0 <sys_unlink+0x186>
    iunlockput(ip);
ffff800000108bb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108bbc:	48 89 c7             	mov    %rax,%rdi
ffff800000108bbf:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108bc6:	80 ff ff 
ffff800000108bc9:	ff d0                	callq  *%rax
    goto bad;
ffff800000108bcb:	e9 06 01 00 00       	jmpq   ffff800000108cd6 <sys_unlink+0x28c>
  }

  memset(&de, 0, sizeof(de));
ffff800000108bd0:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000108bd4:	ba 10 00 00 00       	mov    $0x10,%edx
ffff800000108bd9:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000108bde:	48 89 c7             	mov    %rax,%rdi
ffff800000108be1:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff800000108be8:	80 ff ff 
ffff800000108beb:	ff d0                	callq  *%rax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff800000108bed:	8b 55 c4             	mov    -0x3c(%rbp),%edx
ffff800000108bf0:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff800000108bf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108bf8:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff800000108bfd:	48 89 c7             	mov    %rax,%rdi
ffff800000108c00:	48 b8 22 31 10 00 00 	movabs $0xffff800000103122,%rax
ffff800000108c07:	80 ff ff 
ffff800000108c0a:	ff d0                	callq  *%rax
ffff800000108c0c:	83 f8 10             	cmp    $0x10,%eax
ffff800000108c0f:	74 16                	je     ffff800000108c27 <sys_unlink+0x1dd>
    panic("unlink: writei");
ffff800000108c11:	48 bf 65 c9 10 00 00 	movabs $0xffff80000010c965,%rdi
ffff800000108c18:	80 ff ff 
ffff800000108c1b:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000108c22:	80 ff ff 
ffff800000108c25:	ff d0                	callq  *%rax
  if(ip->type == T_DIR){
ffff800000108c27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108c2b:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000108c32:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000108c36:	75 2e                	jne    ffff800000108c66 <sys_unlink+0x21c>
    dp->nlink--;
ffff800000108c38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108c3c:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000108c43:	83 e8 01             	sub    $0x1,%eax
ffff800000108c46:	89 c2                	mov    %eax,%edx
ffff800000108c48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108c4c:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
    iupdate(dp);
ffff800000108c53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108c57:	48 89 c7             	mov    %rax,%rdi
ffff800000108c5a:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff800000108c61:	80 ff ff 
ffff800000108c64:	ff d0                	callq  *%rax
  }
  iunlockput(dp);
ffff800000108c66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108c6a:	48 89 c7             	mov    %rax,%rdi
ffff800000108c6d:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108c74:	80 ff ff 
ffff800000108c77:	ff d0                	callq  *%rax

  ip->nlink--;
ffff800000108c79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108c7d:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000108c84:	83 e8 01             	sub    $0x1,%eax
ffff800000108c87:	89 c2                	mov    %eax,%edx
ffff800000108c89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108c8d:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
  iupdate(ip);
ffff800000108c94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108c98:	48 89 c7             	mov    %rax,%rdi
ffff800000108c9b:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff800000108ca2:	80 ff ff 
ffff800000108ca5:	ff d0                	callq  *%rax
  iunlockput(ip);
ffff800000108ca7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108cab:	48 89 c7             	mov    %rax,%rdi
ffff800000108cae:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108cb5:	80 ff ff 
ffff800000108cb8:	ff d0                	callq  *%rax

  end_op();
ffff800000108cba:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108cbf:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff800000108cc6:	80 ff ff 
ffff800000108cc9:	ff d2                	callq  *%rdx

  return 0;
ffff800000108ccb:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108cd0:	eb 2d                	jmp    ffff800000108cff <sys_unlink+0x2b5>
    goto bad;
ffff800000108cd2:	90                   	nop
ffff800000108cd3:	eb 01                	jmp    ffff800000108cd6 <sys_unlink+0x28c>
    goto bad;
ffff800000108cd5:	90                   	nop

bad:
  iunlockput(dp);
ffff800000108cd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108cda:	48 89 c7             	mov    %rax,%rdi
ffff800000108cdd:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108ce4:	80 ff ff 
ffff800000108ce7:	ff d0                	callq  *%rax
  end_op();
ffff800000108ce9:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108cee:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff800000108cf5:	80 ff ff 
ffff800000108cf8:	ff d2                	callq  *%rdx
  return -1;
ffff800000108cfa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000108cff:	c9                   	leaveq 
ffff800000108d00:	c3                   	retq   

ffff800000108d01 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
ffff800000108d01:	f3 0f 1e fa          	endbr64 
ffff800000108d05:	55                   	push   %rbp
ffff800000108d06:	48 89 e5             	mov    %rsp,%rbp
ffff800000108d09:	48 83 ec 50          	sub    $0x50,%rsp
ffff800000108d0d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
ffff800000108d11:	89 c8                	mov    %ecx,%eax
ffff800000108d13:	89 f1                	mov    %esi,%ecx
ffff800000108d15:	66 89 4d c4          	mov    %cx,-0x3c(%rbp)
ffff800000108d19:	66 89 55 c0          	mov    %dx,-0x40(%rbp)
ffff800000108d1d:	66 89 45 bc          	mov    %ax,-0x44(%rbp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
ffff800000108d21:	48 8d 55 de          	lea    -0x22(%rbp),%rdx
ffff800000108d25:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000108d29:	48 89 d6             	mov    %rdx,%rsi
ffff800000108d2c:	48 89 c7             	mov    %rax,%rdi
ffff800000108d2f:	48 b8 2d 38 10 00 00 	movabs $0xffff80000010382d,%rax
ffff800000108d36:	80 ff ff 
ffff800000108d39:	ff d0                	callq  *%rax
ffff800000108d3b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108d3f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108d44:	75 0a                	jne    ffff800000108d50 <create+0x4f>
    return 0;
ffff800000108d46:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108d4b:	e9 1d 02 00 00       	jmpq   ffff800000108f6d <create+0x26c>
  ilock(dp);
ffff800000108d50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108d54:	48 89 c7             	mov    %rax,%rdi
ffff800000108d57:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000108d5e:	80 ff ff 
ffff800000108d61:	ff d0                	callq  *%rax

  if((ip = dirlookup(dp, name, &off)) != 0){
ffff800000108d63:	48 8d 55 ec          	lea    -0x14(%rbp),%rdx
ffff800000108d67:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
ffff800000108d6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108d6f:	48 89 ce             	mov    %rcx,%rsi
ffff800000108d72:	48 89 c7             	mov    %rax,%rdi
ffff800000108d75:	48 b8 6b 33 10 00 00 	movabs $0xffff80000010336b,%rax
ffff800000108d7c:	80 ff ff 
ffff800000108d7f:	ff d0                	callq  *%rax
ffff800000108d81:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000108d85:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000108d8a:	74 64                	je     ffff800000108df0 <create+0xef>
    iunlockput(dp);
ffff800000108d8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108d90:	48 89 c7             	mov    %rax,%rdi
ffff800000108d93:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108d9a:	80 ff ff 
ffff800000108d9d:	ff d0                	callq  *%rax
    ilock(ip);
ffff800000108d9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108da3:	48 89 c7             	mov    %rax,%rdi
ffff800000108da6:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000108dad:	80 ff ff 
ffff800000108db0:	ff d0                	callq  *%rax
    if(type == T_FILE && ip->type == T_FILE)
ffff800000108db2:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%rbp)
ffff800000108db7:	75 1a                	jne    ffff800000108dd3 <create+0xd2>
ffff800000108db9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108dbd:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000108dc4:	66 83 f8 02          	cmp    $0x2,%ax
ffff800000108dc8:	75 09                	jne    ffff800000108dd3 <create+0xd2>
      return ip;
ffff800000108dca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108dce:	e9 9a 01 00 00       	jmpq   ffff800000108f6d <create+0x26c>
    iunlockput(ip);
ffff800000108dd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108dd7:	48 89 c7             	mov    %rax,%rdi
ffff800000108dda:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108de1:	80 ff ff 
ffff800000108de4:	ff d0                	callq  *%rax
    return 0;
ffff800000108de6:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108deb:	e9 7d 01 00 00       	jmpq   ffff800000108f6d <create+0x26c>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
ffff800000108df0:	0f bf 55 c4          	movswl -0x3c(%rbp),%edx
ffff800000108df4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108df8:	8b 00                	mov    (%rax),%eax
ffff800000108dfa:	89 d6                	mov    %edx,%esi
ffff800000108dfc:	89 c7                	mov    %eax,%edi
ffff800000108dfe:	48 b8 21 25 10 00 00 	movabs $0xffff800000102521,%rax
ffff800000108e05:	80 ff ff 
ffff800000108e08:	ff d0                	callq  *%rax
ffff800000108e0a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000108e0e:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000108e13:	75 16                	jne    ffff800000108e2b <create+0x12a>
    panic("create: ialloc");
ffff800000108e15:	48 bf 74 c9 10 00 00 	movabs $0xffff80000010c974,%rdi
ffff800000108e1c:	80 ff ff 
ffff800000108e1f:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000108e26:	80 ff ff 
ffff800000108e29:	ff d0                	callq  *%rax

  ilock(ip);
ffff800000108e2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108e2f:	48 89 c7             	mov    %rax,%rdi
ffff800000108e32:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000108e39:	80 ff ff 
ffff800000108e3c:	ff d0                	callq  *%rax
  ip->major = major;
ffff800000108e3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108e42:	0f b7 55 c0          	movzwl -0x40(%rbp),%edx
ffff800000108e46:	66 89 90 96 00 00 00 	mov    %dx,0x96(%rax)
  ip->minor = minor;
ffff800000108e4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108e51:	0f b7 55 bc          	movzwl -0x44(%rbp),%edx
ffff800000108e55:	66 89 90 98 00 00 00 	mov    %dx,0x98(%rax)
  ip->nlink = 1;
ffff800000108e5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108e60:	66 c7 80 9a 00 00 00 	movw   $0x1,0x9a(%rax)
ffff800000108e67:	01 00 
  iupdate(ip);
ffff800000108e69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108e6d:	48 89 c7             	mov    %rax,%rdi
ffff800000108e70:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff800000108e77:	80 ff ff 
ffff800000108e7a:	ff d0                	callq  *%rax

  if(type == T_DIR){  // Create . and .. entries.
ffff800000108e7c:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%rbp)
ffff800000108e81:	0f 85 94 00 00 00    	jne    ffff800000108f1b <create+0x21a>
    dp->nlink++;  // for ".."
ffff800000108e87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108e8b:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000108e92:	83 c0 01             	add    $0x1,%eax
ffff800000108e95:	89 c2                	mov    %eax,%edx
ffff800000108e97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108e9b:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
    iupdate(dp);
ffff800000108ea2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108ea6:	48 89 c7             	mov    %rax,%rdi
ffff800000108ea9:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff800000108eb0:	80 ff ff 
ffff800000108eb3:	ff d0                	callq  *%rax
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
ffff800000108eb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108eb9:	8b 50 04             	mov    0x4(%rax),%edx
ffff800000108ebc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108ec0:	48 be 4e c9 10 00 00 	movabs $0xffff80000010c94e,%rsi
ffff800000108ec7:	80 ff ff 
ffff800000108eca:	48 89 c7             	mov    %rax,%rdi
ffff800000108ecd:	48 b8 6f 34 10 00 00 	movabs $0xffff80000010346f,%rax
ffff800000108ed4:	80 ff ff 
ffff800000108ed7:	ff d0                	callq  *%rax
ffff800000108ed9:	85 c0                	test   %eax,%eax
ffff800000108edb:	78 28                	js     ffff800000108f05 <create+0x204>
ffff800000108edd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108ee1:	8b 50 04             	mov    0x4(%rax),%edx
ffff800000108ee4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108ee8:	48 be 50 c9 10 00 00 	movabs $0xffff80000010c950,%rsi
ffff800000108eef:	80 ff ff 
ffff800000108ef2:	48 89 c7             	mov    %rax,%rdi
ffff800000108ef5:	48 b8 6f 34 10 00 00 	movabs $0xffff80000010346f,%rax
ffff800000108efc:	80 ff ff 
ffff800000108eff:	ff d0                	callq  *%rax
ffff800000108f01:	85 c0                	test   %eax,%eax
ffff800000108f03:	79 16                	jns    ffff800000108f1b <create+0x21a>
      panic("create dots");
ffff800000108f05:	48 bf 83 c9 10 00 00 	movabs $0xffff80000010c983,%rdi
ffff800000108f0c:	80 ff ff 
ffff800000108f0f:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000108f16:	80 ff ff 
ffff800000108f19:	ff d0                	callq  *%rax
  }

  if(dirlink(dp, name, ip->inum) < 0)
ffff800000108f1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108f1f:	8b 50 04             	mov    0x4(%rax),%edx
ffff800000108f22:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
ffff800000108f26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108f2a:	48 89 ce             	mov    %rcx,%rsi
ffff800000108f2d:	48 89 c7             	mov    %rax,%rdi
ffff800000108f30:	48 b8 6f 34 10 00 00 	movabs $0xffff80000010346f,%rax
ffff800000108f37:	80 ff ff 
ffff800000108f3a:	ff d0                	callq  *%rax
ffff800000108f3c:	85 c0                	test   %eax,%eax
ffff800000108f3e:	79 16                	jns    ffff800000108f56 <create+0x255>
    panic("create: dirlink");
ffff800000108f40:	48 bf 8f c9 10 00 00 	movabs $0xffff80000010c98f,%rdi
ffff800000108f47:	80 ff ff 
ffff800000108f4a:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000108f51:	80 ff ff 
ffff800000108f54:	ff d0                	callq  *%rax

  iunlockput(dp);
ffff800000108f56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108f5a:	48 89 c7             	mov    %rax,%rdi
ffff800000108f5d:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108f64:	80 ff ff 
ffff800000108f67:	ff d0                	callq  *%rax

  return ip;
ffff800000108f69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
ffff800000108f6d:	c9                   	leaveq 
ffff800000108f6e:	c3                   	retq   

ffff800000108f6f <sys_open>:

int
sys_open(void)
{
ffff800000108f6f:	f3 0f 1e fa          	endbr64 
ffff800000108f73:	55                   	push   %rbp
ffff800000108f74:	48 89 e5             	mov    %rsp,%rbp
ffff800000108f77:	48 83 ec 30          	sub    $0x30,%rsp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
ffff800000108f7b:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000108f7f:	48 89 c6             	mov    %rax,%rsi
ffff800000108f82:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108f87:	48 b8 99 82 10 00 00 	movabs $0xffff800000108299,%rax
ffff800000108f8e:	80 ff ff 
ffff800000108f91:	ff d0                	callq  *%rax
ffff800000108f93:	85 c0                	test   %eax,%eax
ffff800000108f95:	78 1c                	js     ffff800000108fb3 <sys_open+0x44>
ffff800000108f97:	48 8d 45 dc          	lea    -0x24(%rbp),%rax
ffff800000108f9b:	48 89 c6             	mov    %rax,%rsi
ffff800000108f9e:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000108fa3:	48 b8 a0 81 10 00 00 	movabs $0xffff8000001081a0,%rax
ffff800000108faa:	80 ff ff 
ffff800000108fad:	ff d0                	callq  *%rax
ffff800000108faf:	85 c0                	test   %eax,%eax
ffff800000108fb1:	79 0a                	jns    ffff800000108fbd <sys_open+0x4e>
    return -1;
ffff800000108fb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108fb8:	e9 fb 01 00 00       	jmpq   ffff8000001091b8 <sys_open+0x249>

  begin_op();
ffff800000108fbd:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108fc2:	48 ba ab 52 10 00 00 	movabs $0xffff8000001052ab,%rdx
ffff800000108fc9:	80 ff ff 
ffff800000108fcc:	ff d2                	callq  *%rdx

  if(omode & O_CREATE){
ffff800000108fce:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000108fd1:	25 00 02 00 00       	and    $0x200,%eax
ffff800000108fd6:	85 c0                	test   %eax,%eax
ffff800000108fd8:	74 4c                	je     ffff800000109026 <sys_open+0xb7>
    ip = create(path, T_FILE, 0, 0);
ffff800000108fda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000108fde:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff800000108fe3:	ba 00 00 00 00       	mov    $0x0,%edx
ffff800000108fe8:	be 02 00 00 00       	mov    $0x2,%esi
ffff800000108fed:	48 89 c7             	mov    %rax,%rdi
ffff800000108ff0:	48 b8 01 8d 10 00 00 	movabs $0xffff800000108d01,%rax
ffff800000108ff7:	80 ff ff 
ffff800000108ffa:	ff d0                	callq  *%rax
ffff800000108ffc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(ip == 0){
ffff800000109000:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000109005:	0f 85 ad 00 00 00    	jne    ffff8000001090b8 <sys_open+0x149>
      end_op();
ffff80000010900b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109010:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff800000109017:	80 ff ff 
ffff80000010901a:	ff d2                	callq  *%rdx
      return -1;
ffff80000010901c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109021:	e9 92 01 00 00       	jmpq   ffff8000001091b8 <sys_open+0x249>
    }
  } else {
    if((ip = namei(path)) == 0){
ffff800000109026:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010902a:	48 89 c7             	mov    %rax,%rdi
ffff80000010902d:	48 b8 ff 37 10 00 00 	movabs $0xffff8000001037ff,%rax
ffff800000109034:	80 ff ff 
ffff800000109037:	ff d0                	callq  *%rax
ffff800000109039:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010903d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000109042:	75 1b                	jne    ffff80000010905f <sys_open+0xf0>
      end_op();
ffff800000109044:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109049:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff800000109050:	80 ff ff 
ffff800000109053:	ff d2                	callq  *%rdx
      return -1;
ffff800000109055:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010905a:	e9 59 01 00 00       	jmpq   ffff8000001091b8 <sys_open+0x249>
    }
    ilock(ip);
ffff80000010905f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109063:	48 89 c7             	mov    %rax,%rdi
ffff800000109066:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff80000010906d:	80 ff ff 
ffff800000109070:	ff d0                	callq  *%rax
    if(ip->type == T_DIR && omode != O_RDONLY){
ffff800000109072:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109076:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff80000010907d:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000109081:	75 35                	jne    ffff8000001090b8 <sys_open+0x149>
ffff800000109083:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000109086:	85 c0                	test   %eax,%eax
ffff800000109088:	74 2e                	je     ffff8000001090b8 <sys_open+0x149>
      iunlockput(ip);
ffff80000010908a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010908e:	48 89 c7             	mov    %rax,%rdi
ffff800000109091:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000109098:	80 ff ff 
ffff80000010909b:	ff d0                	callq  *%rax
      end_op();
ffff80000010909d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001090a2:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff8000001090a9:	80 ff ff 
ffff8000001090ac:	ff d2                	callq  *%rdx
      return -1;
ffff8000001090ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001090b3:	e9 00 01 00 00       	jmpq   ffff8000001091b8 <sys_open+0x249>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
ffff8000001090b8:	48 b8 84 1b 10 00 00 	movabs $0xffff800000101b84,%rax
ffff8000001090bf:	80 ff ff 
ffff8000001090c2:	ff d0                	callq  *%rax
ffff8000001090c4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff8000001090c8:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff8000001090cd:	74 1c                	je     ffff8000001090eb <sys_open+0x17c>
ffff8000001090cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001090d3:	48 89 c7             	mov    %rax,%rdi
ffff8000001090d6:	48 b8 97 84 10 00 00 	movabs $0xffff800000108497,%rax
ffff8000001090dd:	80 ff ff 
ffff8000001090e0:	ff d0                	callq  *%rax
ffff8000001090e2:	89 45 ec             	mov    %eax,-0x14(%rbp)
ffff8000001090e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff8000001090e9:	79 48                	jns    ffff800000109133 <sys_open+0x1c4>
    if(f)
ffff8000001090eb:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff8000001090f0:	74 13                	je     ffff800000109105 <sys_open+0x196>
      fileclose(f);
ffff8000001090f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001090f6:	48 89 c7             	mov    %rax,%rdi
ffff8000001090f9:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff800000109100:	80 ff ff 
ffff800000109103:	ff d0                	callq  *%rax
    iunlockput(ip);
ffff800000109105:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109109:	48 89 c7             	mov    %rax,%rdi
ffff80000010910c:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000109113:	80 ff ff 
ffff800000109116:	ff d0                	callq  *%rax
    end_op();
ffff800000109118:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010911d:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff800000109124:	80 ff ff 
ffff800000109127:	ff d2                	callq  *%rdx
    return -1;
ffff800000109129:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010912e:	e9 85 00 00 00       	jmpq   ffff8000001091b8 <sys_open+0x249>
  }
  iunlock(ip);
ffff800000109133:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109137:	48 89 c7             	mov    %rax,%rdi
ffff80000010913a:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000109141:	80 ff ff 
ffff800000109144:	ff d0                	callq  *%rax
  end_op();
ffff800000109146:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010914b:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff800000109152:	80 ff ff 
ffff800000109155:	ff d2                	callq  *%rdx

  f->type = FD_INODE;
ffff800000109157:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010915b:	c7 00 02 00 00 00    	movl   $0x2,(%rax)
  f->ip = ip;
ffff800000109161:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109165:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000109169:	48 89 50 18          	mov    %rdx,0x18(%rax)
  f->off = 0;
ffff80000010916d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109171:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%rax)
  f->readable = !(omode & O_WRONLY);
ffff800000109178:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff80000010917b:	83 e0 01             	and    $0x1,%eax
ffff80000010917e:	85 c0                	test   %eax,%eax
ffff800000109180:	0f 94 c0             	sete   %al
ffff800000109183:	89 c2                	mov    %eax,%edx
ffff800000109185:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109189:	88 50 08             	mov    %dl,0x8(%rax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
ffff80000010918c:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff80000010918f:	83 e0 01             	and    $0x1,%eax
ffff800000109192:	85 c0                	test   %eax,%eax
ffff800000109194:	75 0a                	jne    ffff8000001091a0 <sys_open+0x231>
ffff800000109196:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000109199:	83 e0 02             	and    $0x2,%eax
ffff80000010919c:	85 c0                	test   %eax,%eax
ffff80000010919e:	74 07                	je     ffff8000001091a7 <sys_open+0x238>
ffff8000001091a0:	b8 01 00 00 00       	mov    $0x1,%eax
ffff8000001091a5:	eb 05                	jmp    ffff8000001091ac <sys_open+0x23d>
ffff8000001091a7:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001091ac:	89 c2                	mov    %eax,%edx
ffff8000001091ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001091b2:	88 50 09             	mov    %dl,0x9(%rax)
  return fd;
ffff8000001091b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
ffff8000001091b8:	c9                   	leaveq 
ffff8000001091b9:	c3                   	retq   

ffff8000001091ba <sys_mkdir>:

int
sys_mkdir(void)
{
ffff8000001091ba:	f3 0f 1e fa          	endbr64 
ffff8000001091be:	55                   	push   %rbp
ffff8000001091bf:	48 89 e5             	mov    %rsp,%rbp
ffff8000001091c2:	48 83 ec 10          	sub    $0x10,%rsp
  char *path;
  struct inode *ip;

  begin_op();
ffff8000001091c6:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001091cb:	48 ba ab 52 10 00 00 	movabs $0xffff8000001052ab,%rdx
ffff8000001091d2:	80 ff ff 
ffff8000001091d5:	ff d2                	callq  *%rdx
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
ffff8000001091d7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff8000001091db:	48 89 c6             	mov    %rax,%rsi
ffff8000001091de:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001091e3:	48 b8 99 82 10 00 00 	movabs $0xffff800000108299,%rax
ffff8000001091ea:	80 ff ff 
ffff8000001091ed:	ff d0                	callq  *%rax
ffff8000001091ef:	85 c0                	test   %eax,%eax
ffff8000001091f1:	78 2d                	js     ffff800000109220 <sys_mkdir+0x66>
ffff8000001091f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001091f7:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff8000001091fc:	ba 00 00 00 00       	mov    $0x0,%edx
ffff800000109201:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000109206:	48 89 c7             	mov    %rax,%rdi
ffff800000109209:	48 b8 01 8d 10 00 00 	movabs $0xffff800000108d01,%rax
ffff800000109210:	80 ff ff 
ffff800000109213:	ff d0                	callq  *%rax
ffff800000109215:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000109219:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010921e:	75 18                	jne    ffff800000109238 <sys_mkdir+0x7e>
    end_op();
ffff800000109220:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109225:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff80000010922c:	80 ff ff 
ffff80000010922f:	ff d2                	callq  *%rdx
    return -1;
ffff800000109231:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109236:	eb 29                	jmp    ffff800000109261 <sys_mkdir+0xa7>
  }
  iunlockput(ip);
ffff800000109238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010923c:	48 89 c7             	mov    %rax,%rdi
ffff80000010923f:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000109246:	80 ff ff 
ffff800000109249:	ff d0                	callq  *%rax
  end_op();
ffff80000010924b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109250:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff800000109257:	80 ff ff 
ffff80000010925a:	ff d2                	callq  *%rdx
  return 0;
ffff80000010925c:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109261:	c9                   	leaveq 
ffff800000109262:	c3                   	retq   

ffff800000109263 <sys_mknod>:

int
sys_mknod(void)
{
ffff800000109263:	f3 0f 1e fa          	endbr64 
ffff800000109267:	55                   	push   %rbp
ffff800000109268:	48 89 e5             	mov    %rsp,%rbp
ffff80000010926b:	48 83 ec 20          	sub    $0x20,%rsp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
ffff80000010926f:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109274:	48 ba ab 52 10 00 00 	movabs $0xffff8000001052ab,%rdx
ffff80000010927b:	80 ff ff 
ffff80000010927e:	ff d2                	callq  *%rdx
  if((argstr(0, &path)) < 0 ||
ffff800000109280:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000109284:	48 89 c6             	mov    %rax,%rsi
ffff800000109287:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010928c:	48 b8 99 82 10 00 00 	movabs $0xffff800000108299,%rax
ffff800000109293:	80 ff ff 
ffff800000109296:	ff d0                	callq  *%rax
ffff800000109298:	85 c0                	test   %eax,%eax
ffff80000010929a:	78 67                	js     ffff800000109303 <sys_mknod+0xa0>
     argint(1, &major) < 0 ||
ffff80000010929c:	48 8d 45 ec          	lea    -0x14(%rbp),%rax
ffff8000001092a0:	48 89 c6             	mov    %rax,%rsi
ffff8000001092a3:	bf 01 00 00 00       	mov    $0x1,%edi
ffff8000001092a8:	48 b8 a0 81 10 00 00 	movabs $0xffff8000001081a0,%rax
ffff8000001092af:	80 ff ff 
ffff8000001092b2:	ff d0                	callq  *%rax
  if((argstr(0, &path)) < 0 ||
ffff8000001092b4:	85 c0                	test   %eax,%eax
ffff8000001092b6:	78 4b                	js     ffff800000109303 <sys_mknod+0xa0>
     argint(2, &minor) < 0 ||
ffff8000001092b8:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff8000001092bc:	48 89 c6             	mov    %rax,%rsi
ffff8000001092bf:	bf 02 00 00 00       	mov    $0x2,%edi
ffff8000001092c4:	48 b8 a0 81 10 00 00 	movabs $0xffff8000001081a0,%rax
ffff8000001092cb:	80 ff ff 
ffff8000001092ce:	ff d0                	callq  *%rax
     argint(1, &major) < 0 ||
ffff8000001092d0:	85 c0                	test   %eax,%eax
ffff8000001092d2:	78 2f                	js     ffff800000109303 <sys_mknod+0xa0>
     (ip = create(path, T_DEV, major, minor)) == 0){
ffff8000001092d4:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff8000001092d7:	0f bf c8             	movswl %ax,%ecx
ffff8000001092da:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001092dd:	0f bf d0             	movswl %ax,%edx
ffff8000001092e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001092e4:	be 03 00 00 00       	mov    $0x3,%esi
ffff8000001092e9:	48 89 c7             	mov    %rax,%rdi
ffff8000001092ec:	48 b8 01 8d 10 00 00 	movabs $0xffff800000108d01,%rax
ffff8000001092f3:	80 ff ff 
ffff8000001092f6:	ff d0                	callq  *%rax
ffff8000001092f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
     argint(2, &minor) < 0 ||
ffff8000001092fc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000109301:	75 18                	jne    ffff80000010931b <sys_mknod+0xb8>
    end_op();
ffff800000109303:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109308:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff80000010930f:	80 ff ff 
ffff800000109312:	ff d2                	callq  *%rdx
    return -1;
ffff800000109314:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109319:	eb 29                	jmp    ffff800000109344 <sys_mknod+0xe1>
  }
  iunlockput(ip);
ffff80000010931b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010931f:	48 89 c7             	mov    %rax,%rdi
ffff800000109322:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000109329:	80 ff ff 
ffff80000010932c:	ff d0                	callq  *%rax
  end_op();
ffff80000010932e:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109333:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff80000010933a:	80 ff ff 
ffff80000010933d:	ff d2                	callq  *%rdx
  return 0;
ffff80000010933f:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109344:	c9                   	leaveq 
ffff800000109345:	c3                   	retq   

ffff800000109346 <sys_chdir>:

int
sys_chdir(void)
{
ffff800000109346:	f3 0f 1e fa          	endbr64 
ffff80000010934a:	55                   	push   %rbp
ffff80000010934b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010934e:	48 83 ec 10          	sub    $0x10,%rsp
  char *path;
  struct inode *ip;

  begin_op();
ffff800000109352:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109357:	48 ba ab 52 10 00 00 	movabs $0xffff8000001052ab,%rdx
ffff80000010935e:	80 ff ff 
ffff800000109361:	ff d2                	callq  *%rdx
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
ffff800000109363:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000109367:	48 89 c6             	mov    %rax,%rsi
ffff80000010936a:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010936f:	48 b8 99 82 10 00 00 	movabs $0xffff800000108299,%rax
ffff800000109376:	80 ff ff 
ffff800000109379:	ff d0                	callq  *%rax
ffff80000010937b:	85 c0                	test   %eax,%eax
ffff80000010937d:	78 1e                	js     ffff80000010939d <sys_chdir+0x57>
ffff80000010937f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109383:	48 89 c7             	mov    %rax,%rdi
ffff800000109386:	48 b8 ff 37 10 00 00 	movabs $0xffff8000001037ff,%rax
ffff80000010938d:	80 ff ff 
ffff800000109390:	ff d0                	callq  *%rax
ffff800000109392:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000109396:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010939b:	75 1b                	jne    ffff8000001093b8 <sys_chdir+0x72>
    end_op();
ffff80000010939d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001093a2:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff8000001093a9:	80 ff ff 
ffff8000001093ac:	ff d2                	callq  *%rdx
    return -1;
ffff8000001093ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001093b3:	e9 af 00 00 00       	jmpq   ffff800000109467 <sys_chdir+0x121>
  }
  ilock(ip);
ffff8000001093b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001093bc:	48 89 c7             	mov    %rax,%rdi
ffff8000001093bf:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff8000001093c6:	80 ff ff 
ffff8000001093c9:	ff d0                	callq  *%rax
  if(ip->type != T_DIR){
ffff8000001093cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001093cf:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff8000001093d6:	66 83 f8 01          	cmp    $0x1,%ax
ffff8000001093da:	74 2b                	je     ffff800000109407 <sys_chdir+0xc1>
    iunlockput(ip);
ffff8000001093dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001093e0:	48 89 c7             	mov    %rax,%rdi
ffff8000001093e3:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff8000001093ea:	80 ff ff 
ffff8000001093ed:	ff d0                	callq  *%rax
    end_op();
ffff8000001093ef:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001093f4:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff8000001093fb:	80 ff ff 
ffff8000001093fe:	ff d2                	callq  *%rdx
    return -1;
ffff800000109400:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109405:	eb 60                	jmp    ffff800000109467 <sys_chdir+0x121>
  }
  iunlock(ip);
ffff800000109407:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010940b:	48 89 c7             	mov    %rax,%rdi
ffff80000010940e:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000109415:	80 ff ff 
ffff800000109418:	ff d0                	callq  *%rax
  iput(proc->cwd);
ffff80000010941a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109421:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109425:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff80000010942c:	48 89 c7             	mov    %rax,%rdi
ffff80000010942f:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff800000109436:	80 ff ff 
ffff800000109439:	ff d0                	callq  *%rax
  end_op();
ffff80000010943b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109440:	48 ba 85 53 10 00 00 	movabs $0xffff800000105385,%rdx
ffff800000109447:	80 ff ff 
ffff80000010944a:	ff d2                	callq  *%rdx
  proc->cwd = ip;
ffff80000010944c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109453:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109457:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010945b:	48 89 90 c8 00 00 00 	mov    %rdx,0xc8(%rax)
  return 0;
ffff800000109462:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109467:	c9                   	leaveq 
ffff800000109468:	c3                   	retq   

ffff800000109469 <sys_exec>:

int
sys_exec(void)
{
ffff800000109469:	f3 0f 1e fa          	endbr64 
ffff80000010946d:	55                   	push   %rbp
ffff80000010946e:	48 89 e5             	mov    %rsp,%rbp
ffff800000109471:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  char *path, *argv[MAXARG];
  int i;
  addr_t uargv, uarg;

  if(argstr(0, &path) < 0 || argaddr(1, &uargv) < 0){
ffff800000109478:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff80000010947c:	48 89 c6             	mov    %rax,%rsi
ffff80000010947f:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109484:	48 b8 99 82 10 00 00 	movabs $0xffff800000108299,%rax
ffff80000010948b:	80 ff ff 
ffff80000010948e:	ff d0                	callq  *%rax
ffff800000109490:	85 c0                	test   %eax,%eax
ffff800000109492:	78 1f                	js     ffff8000001094b3 <sys_exec+0x4a>
ffff800000109494:	48 8d 85 e8 fe ff ff 	lea    -0x118(%rbp),%rax
ffff80000010949b:	48 89 c6             	mov    %rax,%rsi
ffff80000010949e:	bf 01 00 00 00       	mov    $0x1,%edi
ffff8000001094a3:	48 b8 d3 81 10 00 00 	movabs $0xffff8000001081d3,%rax
ffff8000001094aa:	80 ff ff 
ffff8000001094ad:	ff d0                	callq  *%rax
ffff8000001094af:	85 c0                	test   %eax,%eax
ffff8000001094b1:	79 0a                	jns    ffff8000001094bd <sys_exec+0x54>
    return -1;
ffff8000001094b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001094b8:	e9 f2 00 00 00       	jmpq   ffff8000001095af <sys_exec+0x146>
  }
  memset(argv, 0, sizeof(argv));
ffff8000001094bd:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
ffff8000001094c4:	ba 00 01 00 00       	mov    $0x100,%edx
ffff8000001094c9:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001094ce:	48 89 c7             	mov    %rax,%rdi
ffff8000001094d1:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff8000001094d8:	80 ff ff 
ffff8000001094db:	ff d0                	callq  *%rax
  for(i=0;; i++){
ffff8000001094dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    if(i >= NELEM(argv))
ffff8000001094e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001094e7:	83 f8 1f             	cmp    $0x1f,%eax
ffff8000001094ea:	76 0a                	jbe    ffff8000001094f6 <sys_exec+0x8d>
      return -1;
ffff8000001094ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001094f1:	e9 b9 00 00 00       	jmpq   ffff8000001095af <sys_exec+0x146>
    if(fetchaddr(uargv+(sizeof(addr_t))*i, (addr_t*)&uarg) < 0)
ffff8000001094f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001094f9:	48 98                	cltq   
ffff8000001094fb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff800000109502:	00 
ffff800000109503:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
ffff80000010950a:	48 01 c2             	add    %rax,%rdx
ffff80000010950d:	48 8d 85 e0 fe ff ff 	lea    -0x120(%rbp),%rax
ffff800000109514:	48 89 c6             	mov    %rax,%rsi
ffff800000109517:	48 89 d7             	mov    %rdx,%rdi
ffff80000010951a:	48 b8 e7 7f 10 00 00 	movabs $0xffff800000107fe7,%rax
ffff800000109521:	80 ff ff 
ffff800000109524:	ff d0                	callq  *%rax
ffff800000109526:	85 c0                	test   %eax,%eax
ffff800000109528:	79 07                	jns    ffff800000109531 <sys_exec+0xc8>
      return -1;
ffff80000010952a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010952f:	eb 7e                	jmp    ffff8000001095af <sys_exec+0x146>
    if(uarg == 0){
ffff800000109531:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
ffff800000109538:	48 85 c0             	test   %rax,%rax
ffff80000010953b:	75 31                	jne    ffff80000010956e <sys_exec+0x105>
      argv[i] = 0;
ffff80000010953d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000109540:	48 98                	cltq   
ffff800000109542:	48 c7 84 c5 f0 fe ff 	movq   $0x0,-0x110(%rbp,%rax,8)
ffff800000109549:	ff 00 00 00 00 
      break;
ffff80000010954e:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
ffff80000010954f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109553:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
ffff80000010955a:	48 89 d6             	mov    %rdx,%rsi
ffff80000010955d:	48 89 c7             	mov    %rax,%rdi
ffff800000109560:	48 b8 3d 15 10 00 00 	movabs $0xffff80000010153d,%rax
ffff800000109567:	80 ff ff 
ffff80000010956a:	ff d0                	callq  *%rax
ffff80000010956c:	eb 41                	jmp    ffff8000001095af <sys_exec+0x146>
    if(fetchstr(uarg, &argv[i]) < 0)
ffff80000010956e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
ffff800000109575:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000109578:	48 63 d2             	movslq %edx,%rdx
ffff80000010957b:	48 c1 e2 03          	shl    $0x3,%rdx
ffff80000010957f:	48 01 c2             	add    %rax,%rdx
ffff800000109582:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
ffff800000109589:	48 89 d6             	mov    %rdx,%rsi
ffff80000010958c:	48 89 c7             	mov    %rax,%rdi
ffff80000010958f:	48 b8 46 80 10 00 00 	movabs $0xffff800000108046,%rax
ffff800000109596:	80 ff ff 
ffff800000109599:	ff d0                	callq  *%rax
ffff80000010959b:	85 c0                	test   %eax,%eax
ffff80000010959d:	79 07                	jns    ffff8000001095a6 <sys_exec+0x13d>
      return -1;
ffff80000010959f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001095a4:	eb 09                	jmp    ffff8000001095af <sys_exec+0x146>
  for(i=0;; i++){
ffff8000001095a6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    if(i >= NELEM(argv))
ffff8000001095aa:	e9 35 ff ff ff       	jmpq   ffff8000001094e4 <sys_exec+0x7b>
}
ffff8000001095af:	c9                   	leaveq 
ffff8000001095b0:	c3                   	retq   

ffff8000001095b1 <sys_pipe>:

int
sys_pipe(void)
{
ffff8000001095b1:	f3 0f 1e fa          	endbr64 
ffff8000001095b5:	55                   	push   %rbp
ffff8000001095b6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001095b9:	48 83 ec 20          	sub    $0x20,%rsp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
ffff8000001095bd:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff8000001095c1:	ba 08 00 00 00       	mov    $0x8,%edx
ffff8000001095c6:	48 89 c6             	mov    %rax,%rsi
ffff8000001095c9:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001095ce:	48 b8 05 82 10 00 00 	movabs $0xffff800000108205,%rax
ffff8000001095d5:	80 ff ff 
ffff8000001095d8:	ff d0                	callq  *%rax
ffff8000001095da:	85 c0                	test   %eax,%eax
ffff8000001095dc:	79 0a                	jns    ffff8000001095e8 <sys_pipe+0x37>
    return -1;
ffff8000001095de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001095e3:	e9 d3 00 00 00       	jmpq   ffff8000001096bb <sys_pipe+0x10a>
  if(pipealloc(&rf, &wf) < 0)
ffff8000001095e8:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffff8000001095ec:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff8000001095f0:	48 89 d6             	mov    %rdx,%rsi
ffff8000001095f3:	48 89 c7             	mov    %rax,%rdi
ffff8000001095f6:	48 b8 f8 5f 10 00 00 	movabs $0xffff800000105ff8,%rax
ffff8000001095fd:	80 ff ff 
ffff800000109600:	ff d0                	callq  *%rax
ffff800000109602:	85 c0                	test   %eax,%eax
ffff800000109604:	79 0a                	jns    ffff800000109610 <sys_pipe+0x5f>
    return -1;
ffff800000109606:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010960b:	e9 ab 00 00 00       	jmpq   ffff8000001096bb <sys_pipe+0x10a>
  fd0 = -1;
ffff800000109610:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
ffff800000109617:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010961b:	48 89 c7             	mov    %rax,%rdi
ffff80000010961e:	48 b8 97 84 10 00 00 	movabs $0xffff800000108497,%rax
ffff800000109625:	80 ff ff 
ffff800000109628:	ff d0                	callq  *%rax
ffff80000010962a:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff80000010962d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000109631:	78 1c                	js     ffff80000010964f <sys_pipe+0x9e>
ffff800000109633:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000109637:	48 89 c7             	mov    %rax,%rdi
ffff80000010963a:	48 b8 97 84 10 00 00 	movabs $0xffff800000108497,%rax
ffff800000109641:	80 ff ff 
ffff800000109644:	ff d0                	callq  *%rax
ffff800000109646:	89 45 f8             	mov    %eax,-0x8(%rbp)
ffff800000109649:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
ffff80000010964d:	79 51                	jns    ffff8000001096a0 <sys_pipe+0xef>
    if(fd0 >= 0)
ffff80000010964f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000109653:	78 1e                	js     ffff800000109673 <sys_pipe+0xc2>
      proc->ofile[fd0] = 0;
ffff800000109655:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010965c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109660:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000109663:	48 63 d2             	movslq %edx,%rdx
ffff800000109666:	48 83 c2 08          	add    $0x8,%rdx
ffff80000010966a:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
ffff800000109671:	00 00 
    fileclose(rf);
ffff800000109673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109677:	48 89 c7             	mov    %rax,%rdi
ffff80000010967a:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff800000109681:	80 ff ff 
ffff800000109684:	ff d0                	callq  *%rax
    fileclose(wf);
ffff800000109686:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010968a:	48 89 c7             	mov    %rax,%rdi
ffff80000010968d:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff800000109694:	80 ff ff 
ffff800000109697:	ff d0                	callq  *%rax
    return -1;
ffff800000109699:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010969e:	eb 1b                	jmp    ffff8000001096bb <sys_pipe+0x10a>
  }
  fd[0] = fd0;
ffff8000001096a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001096a4:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001096a7:	89 10                	mov    %edx,(%rax)
  fd[1] = fd1;
ffff8000001096a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001096ad:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff8000001096b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001096b4:	89 02                	mov    %eax,(%rdx)
  return 0;
ffff8000001096b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001096bb:	c9                   	leaveq 
ffff8000001096bc:	c3                   	retq   

ffff8000001096bd <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
ffff8000001096bd:	f3 0f 1e fa          	endbr64 
ffff8000001096c1:	55                   	push   %rbp
ffff8000001096c2:	48 89 e5             	mov    %rsp,%rbp
  return fork();
ffff8000001096c5:	48 b8 19 69 10 00 00 	movabs $0xffff800000106919,%rax
ffff8000001096cc:	80 ff ff 
ffff8000001096cf:	ff d0                	callq  *%rax
}
ffff8000001096d1:	5d                   	pop    %rbp
ffff8000001096d2:	c3                   	retq   

ffff8000001096d3 <sys_exit>:

int
sys_exit(void)
{
ffff8000001096d3:	f3 0f 1e fa          	endbr64 
ffff8000001096d7:	55                   	push   %rbp
ffff8000001096d8:	48 89 e5             	mov    %rsp,%rbp
  exit();
ffff8000001096db:	48 b8 d3 6b 10 00 00 	movabs $0xffff800000106bd3,%rax
ffff8000001096e2:	80 ff ff 
ffff8000001096e5:	ff d0                	callq  *%rax
  return 0;  // not reached
ffff8000001096e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001096ec:	5d                   	pop    %rbp
ffff8000001096ed:	c3                   	retq   

ffff8000001096ee <sys_wait>:

int
sys_wait(void)
{
ffff8000001096ee:	f3 0f 1e fa          	endbr64 
ffff8000001096f2:	55                   	push   %rbp
ffff8000001096f3:	48 89 e5             	mov    %rsp,%rbp
  return wait();
ffff8000001096f6:	48 b8 c9 6d 10 00 00 	movabs $0xffff800000106dc9,%rax
ffff8000001096fd:	80 ff ff 
ffff800000109700:	ff d0                	callq  *%rax
}
ffff800000109702:	5d                   	pop    %rbp
ffff800000109703:	c3                   	retq   

ffff800000109704 <sys_kill>:

int
sys_kill(void)
{
ffff800000109704:	f3 0f 1e fa          	endbr64 
ffff800000109708:	55                   	push   %rbp
ffff800000109709:	48 89 e5             	mov    %rsp,%rbp
ffff80000010970c:	48 83 ec 10          	sub    $0x10,%rsp
  int pid;

  if(argint(0, &pid) < 0)
ffff800000109710:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
ffff800000109714:	48 89 c6             	mov    %rax,%rsi
ffff800000109717:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010971c:	48 b8 a0 81 10 00 00 	movabs $0xffff8000001081a0,%rax
ffff800000109723:	80 ff ff 
ffff800000109726:	ff d0                	callq  *%rax
ffff800000109728:	85 c0                	test   %eax,%eax
ffff80000010972a:	79 07                	jns    ffff800000109733 <sys_kill+0x2f>
    return -1;
ffff80000010972c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109731:	eb 11                	jmp    ffff800000109744 <sys_kill+0x40>
  return kill(pid);
ffff800000109733:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000109736:	89 c7                	mov    %eax,%edi
ffff800000109738:	48 b8 0a 74 10 00 00 	movabs $0xffff80000010740a,%rax
ffff80000010973f:	80 ff ff 
ffff800000109742:	ff d0                	callq  *%rax
}
ffff800000109744:	c9                   	leaveq 
ffff800000109745:	c3                   	retq   

ffff800000109746 <sys_getpid>:

int
sys_getpid(void)
{
ffff800000109746:	f3 0f 1e fa          	endbr64 
ffff80000010974a:	55                   	push   %rbp
ffff80000010974b:	48 89 e5             	mov    %rsp,%rbp
  return proc->pid;
ffff80000010974e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109755:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109759:	8b 40 1c             	mov    0x1c(%rax),%eax
}
ffff80000010975c:	5d                   	pop    %rbp
ffff80000010975d:	c3                   	retq   

ffff80000010975e <sys_sbrk>:

addr_t
sys_sbrk(void)
{
ffff80000010975e:	f3 0f 1e fa          	endbr64 
ffff800000109762:	55                   	push   %rbp
ffff800000109763:	48 89 e5             	mov    %rsp,%rbp
ffff800000109766:	48 83 ec 10          	sub    $0x10,%rsp
  addr_t addr;
  addr_t n;

  argaddr(0, &n);
ffff80000010976a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff80000010976e:	48 89 c6             	mov    %rax,%rsi
ffff800000109771:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109776:	48 b8 d3 81 10 00 00 	movabs $0xffff8000001081d3,%rax
ffff80000010977d:	80 ff ff 
ffff800000109780:	ff d0                	callq  *%rax
  addr = proc->sz;
ffff800000109782:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109789:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010978d:	48 8b 00             	mov    (%rax),%rax
ffff800000109790:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(growproc(n) < 0)
ffff800000109794:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109798:	48 89 c7             	mov    %rax,%rdi
ffff80000010979b:	48 b8 32 68 10 00 00 	movabs $0xffff800000106832,%rax
ffff8000001097a2:	80 ff ff 
ffff8000001097a5:	ff d0                	callq  *%rax
ffff8000001097a7:	85 c0                	test   %eax,%eax
ffff8000001097a9:	79 09                	jns    ffff8000001097b4 <sys_sbrk+0x56>
    return -1;
ffff8000001097ab:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
ffff8000001097b2:	eb 04                	jmp    ffff8000001097b8 <sys_sbrk+0x5a>
  return addr;
ffff8000001097b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001097b8:	c9                   	leaveq 
ffff8000001097b9:	c3                   	retq   

ffff8000001097ba <sys_sleep>:

int
sys_sleep(void)
{
ffff8000001097ba:	f3 0f 1e fa          	endbr64 
ffff8000001097be:	55                   	push   %rbp
ffff8000001097bf:	48 89 e5             	mov    %rsp,%rbp
ffff8000001097c2:	48 83 ec 10          	sub    $0x10,%rsp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
ffff8000001097c6:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff8000001097ca:	48 89 c6             	mov    %rax,%rsi
ffff8000001097cd:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001097d2:	48 b8 a0 81 10 00 00 	movabs $0xffff8000001081a0,%rax
ffff8000001097d9:	80 ff ff 
ffff8000001097dc:	ff d0                	callq  *%rax
ffff8000001097de:	85 c0                	test   %eax,%eax
ffff8000001097e0:	79 0a                	jns    ffff8000001097ec <sys_sleep+0x32>
    return -1;
ffff8000001097e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001097e7:	e9 a7 00 00 00       	jmpq   ffff800000109893 <sys_sleep+0xd9>
  acquire(&tickslock);
ffff8000001097ec:	48 bf e0 ac 1f 00 00 	movabs $0xffff8000001face0,%rdi
ffff8000001097f3:	80 ff ff 
ffff8000001097f6:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff8000001097fd:	80 ff ff 
ffff800000109800:	ff d0                	callq  *%rax
  ticks0 = ticks;
ffff800000109802:	48 b8 48 ad 1f 00 00 	movabs $0xffff8000001fad48,%rax
ffff800000109809:	80 ff ff 
ffff80000010980c:	8b 00                	mov    (%rax),%eax
ffff80000010980e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while(ticks - ticks0 < n){
ffff800000109811:	eb 4f                	jmp    ffff800000109862 <sys_sleep+0xa8>
    if(proc->killed){
ffff800000109813:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010981a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010981e:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000109821:	85 c0                	test   %eax,%eax
ffff800000109823:	74 1d                	je     ffff800000109842 <sys_sleep+0x88>
      release(&tickslock);
ffff800000109825:	48 bf e0 ac 1f 00 00 	movabs $0xffff8000001face0,%rdi
ffff80000010982c:	80 ff ff 
ffff80000010982f:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000109836:	80 ff ff 
ffff800000109839:	ff d0                	callq  *%rax
      return -1;
ffff80000010983b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109840:	eb 51                	jmp    ffff800000109893 <sys_sleep+0xd9>
    }
    sleep(&ticks, &tickslock);
ffff800000109842:	48 be e0 ac 1f 00 00 	movabs $0xffff8000001face0,%rsi
ffff800000109849:	80 ff ff 
ffff80000010984c:	48 bf 48 ad 1f 00 00 	movabs $0xffff8000001fad48,%rdi
ffff800000109853:	80 ff ff 
ffff800000109856:	48 b8 47 72 10 00 00 	movabs $0xffff800000107247,%rax
ffff80000010985d:	80 ff ff 
ffff800000109860:	ff d0                	callq  *%rax
  while(ticks - ticks0 < n){
ffff800000109862:	48 b8 48 ad 1f 00 00 	movabs $0xffff8000001fad48,%rax
ffff800000109869:	80 ff ff 
ffff80000010986c:	8b 00                	mov    (%rax),%eax
ffff80000010986e:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff800000109871:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff800000109874:	39 d0                	cmp    %edx,%eax
ffff800000109876:	72 9b                	jb     ffff800000109813 <sys_sleep+0x59>
  }
  release(&tickslock);
ffff800000109878:	48 bf e0 ac 1f 00 00 	movabs $0xffff8000001face0,%rdi
ffff80000010987f:	80 ff ff 
ffff800000109882:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000109889:	80 ff ff 
ffff80000010988c:	ff d0                	callq  *%rax
  return 0;
ffff80000010988e:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109893:	c9                   	leaveq 
ffff800000109894:	c3                   	retq   

ffff800000109895 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
ffff800000109895:	f3 0f 1e fa          	endbr64 
ffff800000109899:	55                   	push   %rbp
ffff80000010989a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010989d:	48 83 ec 10          	sub    $0x10,%rsp
  uint xticks;

  acquire(&tickslock);
ffff8000001098a1:	48 bf e0 ac 1f 00 00 	movabs $0xffff8000001face0,%rdi
ffff8000001098a8:	80 ff ff 
ffff8000001098ab:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff8000001098b2:	80 ff ff 
ffff8000001098b5:	ff d0                	callq  *%rax
  xticks = ticks;
ffff8000001098b7:	48 b8 48 ad 1f 00 00 	movabs $0xffff8000001fad48,%rax
ffff8000001098be:	80 ff ff 
ffff8000001098c1:	8b 00                	mov    (%rax),%eax
ffff8000001098c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  release(&tickslock);
ffff8000001098c6:	48 bf e0 ac 1f 00 00 	movabs $0xffff8000001face0,%rdi
ffff8000001098cd:	80 ff ff 
ffff8000001098d0:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff8000001098d7:	80 ff ff 
ffff8000001098da:	ff d0                	callq  *%rax
  return xticks;
ffff8000001098dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff8000001098df:	c9                   	leaveq 
ffff8000001098e0:	c3                   	retq   

ffff8000001098e1 <sys_dedup>:

int
sys_dedup(void)
{
ffff8000001098e1:	f3 0f 1e fa          	endbr64 
ffff8000001098e5:	55                   	push   %rbp
ffff8000001098e6:	48 89 e5             	mov    %rsp,%rbp
  dedup(0, (void*)proc->sz);
ffff8000001098e9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001098f0:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001098f4:	48 8b 00             	mov    (%rax),%rax
ffff8000001098f7:	48 89 c6             	mov    %rax,%rsi
ffff8000001098fa:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001098ff:	48 b8 84 c1 10 00 00 	movabs $0xffff80000010c184,%rax
ffff800000109906:	80 ff ff 
ffff800000109909:	ff d0                	callq  *%rax
  return 0;
ffff80000010990b:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109910:	5d                   	pop    %rbp
ffff800000109911:	c3                   	retq   

ffff800000109912 <sys_freepages>:

int
sys_freepages(void)
{
ffff800000109912:	f3 0f 1e fa          	endbr64 
ffff800000109916:	55                   	push   %rbp
ffff800000109917:	48 89 e5             	mov    %rsp,%rbp
  return kfreepagecount();
ffff80000010991a:	48 b8 86 45 10 00 00 	movabs $0xffff800000104586,%rax
ffff800000109921:	80 ff ff 
ffff800000109924:	ff d0                	callq  *%rax
}
ffff800000109926:	5d                   	pop    %rbp
ffff800000109927:	c3                   	retq   

ffff800000109928 <alltraps>:
# vectors.S sends all traps here.
.global alltraps
alltraps:
  # Build trap frame.
  pushq   %r15
ffff800000109928:	41 57                	push   %r15
  pushq   %r14
ffff80000010992a:	41 56                	push   %r14
  pushq   %r13
ffff80000010992c:	41 55                	push   %r13
  pushq   %r12
ffff80000010992e:	41 54                	push   %r12
  pushq   %r11
ffff800000109930:	41 53                	push   %r11
  pushq   %r10
ffff800000109932:	41 52                	push   %r10
  pushq   %r9
ffff800000109934:	41 51                	push   %r9
  pushq   %r8
ffff800000109936:	41 50                	push   %r8
  pushq   %rdi
ffff800000109938:	57                   	push   %rdi
  pushq   %rsi
ffff800000109939:	56                   	push   %rsi
  pushq   %rbp
ffff80000010993a:	55                   	push   %rbp
  pushq   %rdx
ffff80000010993b:	52                   	push   %rdx
  pushq   %rcx
ffff80000010993c:	51                   	push   %rcx
  pushq   %rbx
ffff80000010993d:	53                   	push   %rbx
  pushq   %rax
ffff80000010993e:	50                   	push   %rax

  movq    %rsp, %rdi  # frame in arg1
ffff80000010993f:	48 89 e7             	mov    %rsp,%rdi
  callq   trap
ffff800000109942:	e8 8d 02 00 00       	callq  ffff800000109bd4 <trap>

ffff800000109947 <trapret>:
# Return falls through to trapret...

.global trapret
trapret:
  popq    %rax
ffff800000109947:	58                   	pop    %rax
  popq    %rbx
ffff800000109948:	5b                   	pop    %rbx
  popq    %rcx
ffff800000109949:	59                   	pop    %rcx
  popq    %rdx
ffff80000010994a:	5a                   	pop    %rdx
  popq    %rbp
ffff80000010994b:	5d                   	pop    %rbp
  popq    %rsi
ffff80000010994c:	5e                   	pop    %rsi
  popq    %rdi
ffff80000010994d:	5f                   	pop    %rdi
  popq    %r8
ffff80000010994e:	41 58                	pop    %r8
  popq    %r9
ffff800000109950:	41 59                	pop    %r9
  popq    %r10
ffff800000109952:	41 5a                	pop    %r10
  popq    %r11
ffff800000109954:	41 5b                	pop    %r11
  popq    %r12
ffff800000109956:	41 5c                	pop    %r12
  popq    %r13
ffff800000109958:	41 5d                	pop    %r13
  popq    %r14
ffff80000010995a:	41 5e                	pop    %r14
  popq    %r15
ffff80000010995c:	41 5f                	pop    %r15

  addq    $16, %rsp  # discard trapnum and errorcode
ffff80000010995e:	48 83 c4 10          	add    $0x10,%rsp
  iretq
ffff800000109962:	48 cf                	iretq  

ffff800000109964 <syscall_entry>:
.global syscall_entry
syscall_entry:
  # switch to kernel stack. With the syscall instruction,
  # this is a kernel resposibility
  # store %rsp on the top of proc->kstack,
  movq    %rax, %fs:(0)      # save %rax above __thread vars
ffff800000109964:	64 48 89 04 25 00 00 	mov    %rax,%fs:0x0
ffff80000010996b:	00 00 
  movq    %fs:(-8), %rax     # %fs:(-8) is proc (the last __thread)
ffff80000010996d:	64 48 8b 04 25 f8 ff 	mov    %fs:0xfffffffffffffff8,%rax
ffff800000109974:	ff ff 
  movq    0x10(%rax), %rax   # get proc->kstack (see struct proc)
ffff800000109976:	48 8b 40 10          	mov    0x10(%rax),%rax
  addq    $(4096-16), %rax   # %rax points to tf->rsp
ffff80000010997a:	48 05 f0 0f 00 00    	add    $0xff0,%rax
  movq    %rsp, (%rax)       # save user rsp to tf->rsp
ffff800000109980:	48 89 20             	mov    %rsp,(%rax)
  movq    %rax, %rsp         # switch to the kstack
ffff800000109983:	48 89 c4             	mov    %rax,%rsp
  movq    %fs:(0), %rax      # restore %rax
ffff800000109986:	64 48 8b 04 25 00 00 	mov    %fs:0x0,%rax
ffff80000010998d:	00 00 

  pushq   %r11         # rflags
ffff80000010998f:	41 53                	push   %r11
  pushq   $0           # cs is ignored
ffff800000109991:	6a 00                	pushq  $0x0
  pushq   %rcx         # rip (next user insn)
ffff800000109993:	51                   	push   %rcx

  pushq   $0           # err
ffff800000109994:	6a 00                	pushq  $0x0
  pushq   $0           # trapno ignored
ffff800000109996:	6a 00                	pushq  $0x0

  pushq   %r15
ffff800000109998:	41 57                	push   %r15
  pushq   %r14
ffff80000010999a:	41 56                	push   %r14
  pushq   %r13
ffff80000010999c:	41 55                	push   %r13
  pushq   %r12
ffff80000010999e:	41 54                	push   %r12
  pushq   %r11
ffff8000001099a0:	41 53                	push   %r11
  pushq   %r10
ffff8000001099a2:	41 52                	push   %r10
  pushq   %r9
ffff8000001099a4:	41 51                	push   %r9
  pushq   %r8
ffff8000001099a6:	41 50                	push   %r8
  pushq   %rdi
ffff8000001099a8:	57                   	push   %rdi
  pushq   %rsi
ffff8000001099a9:	56                   	push   %rsi
  pushq   %rbp
ffff8000001099aa:	55                   	push   %rbp
  pushq   %rdx
ffff8000001099ab:	52                   	push   %rdx
  pushq   %rcx
ffff8000001099ac:	51                   	push   %rcx
  pushq   %rbx
ffff8000001099ad:	53                   	push   %rbx
  pushq   %rax
ffff8000001099ae:	50                   	push   %rax

  movq    %rsp, %rdi  # frame in arg1
ffff8000001099af:	48 89 e7             	mov    %rsp,%rdi
  callq   syscall
ffff8000001099b2:	e8 35 e9 ff ff       	callq  ffff8000001082ec <syscall>

ffff8000001099b7 <syscall_trapret>:
# Return falls through to syscall_trapret...
#PAGEBREAK!

.global syscall_trapret
syscall_trapret:
  popq    %rax
ffff8000001099b7:	58                   	pop    %rax
  popq    %rbx
ffff8000001099b8:	5b                   	pop    %rbx
  popq    %rcx
ffff8000001099b9:	59                   	pop    %rcx
  popq    %rdx
ffff8000001099ba:	5a                   	pop    %rdx
  popq    %rbp
ffff8000001099bb:	5d                   	pop    %rbp
  popq    %rsi
ffff8000001099bc:	5e                   	pop    %rsi
  popq    %rdi
ffff8000001099bd:	5f                   	pop    %rdi
  popq    %r8
ffff8000001099be:	41 58                	pop    %r8
  popq    %r9
ffff8000001099c0:	41 59                	pop    %r9
  popq    %r10
ffff8000001099c2:	41 5a                	pop    %r10
  popq    %r11
ffff8000001099c4:	41 5b                	pop    %r11
  popq    %r12
ffff8000001099c6:	41 5c                	pop    %r12
  popq    %r13
ffff8000001099c8:	41 5d                	pop    %r13
  popq    %r14
ffff8000001099ca:	41 5e                	pop    %r14
  popq    %r15
ffff8000001099cc:	41 5f                	pop    %r15

  addq    $40, %rsp  # discard trapnum, errorcode, rip, cs and rflags
ffff8000001099ce:	48 83 c4 28          	add    $0x28,%rsp

  # to make sure we don't get any interrupts on the user stack while in
  # supervisor mode. this is actually slightly unsafe still,
  # since some interrupts are nonmaskable.
  # See https://www.felixcloutier.com/x86/sysret
  cli
ffff8000001099d2:	fa                   	cli    
  movq    (%rsp), %rsp  # restore the user stack
ffff8000001099d3:	48 8b 24 24          	mov    (%rsp),%rsp
  sysretq
ffff8000001099d7:	48 0f 07             	sysretq 

ffff8000001099da <lidt>:
{
ffff8000001099da:	f3 0f 1e fa          	endbr64 
ffff8000001099de:	55                   	push   %rbp
ffff8000001099df:	48 89 e5             	mov    %rsp,%rbp
ffff8000001099e2:	48 83 ec 30          	sub    $0x30,%rsp
ffff8000001099e6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff8000001099ea:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  addr_t addr = (addr_t)p;
ffff8000001099ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001099f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  pd[0] = size-1;
ffff8000001099f5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff8000001099f8:	83 e8 01             	sub    $0x1,%eax
ffff8000001099fb:	66 89 45 ee          	mov    %ax,-0x12(%rbp)
  pd[1] = addr;
ffff8000001099ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109a03:	66 89 45 f0          	mov    %ax,-0x10(%rbp)
  pd[2] = addr >> 16;
ffff800000109a07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109a0b:	48 c1 e8 10          	shr    $0x10,%rax
ffff800000109a0f:	66 89 45 f2          	mov    %ax,-0xe(%rbp)
  pd[3] = addr >> 32;
ffff800000109a13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109a17:	48 c1 e8 20          	shr    $0x20,%rax
ffff800000109a1b:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
  pd[4] = addr >> 48;
ffff800000109a1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109a23:	48 c1 e8 30          	shr    $0x30,%rax
ffff800000109a27:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
  asm volatile("lidt (%0)" : : "r" (pd));
ffff800000109a2b:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
ffff800000109a2f:	0f 01 18             	lidt   (%rax)
}
ffff800000109a32:	90                   	nop
ffff800000109a33:	c9                   	leaveq 
ffff800000109a34:	c3                   	retq   

ffff800000109a35 <rcr2>:

static inline addr_t
rcr2(void)
{
ffff800000109a35:	f3 0f 1e fa          	endbr64 
ffff800000109a39:	55                   	push   %rbp
ffff800000109a3a:	48 89 e5             	mov    %rsp,%rbp
ffff800000109a3d:	48 83 ec 10          	sub    $0x10,%rsp
  addr_t val;
  asm volatile("mov %%cr2,%0" : "=r" (val));
ffff800000109a41:	0f 20 d0             	mov    %cr2,%rax
ffff800000109a44:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return val;
ffff800000109a48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000109a4c:	c9                   	leaveq 
ffff800000109a4d:	c3                   	retq   

ffff800000109a4e <mkgate>:
struct spinlock tickslock;
uint ticks;

static void
mkgate(uint *idt, uint n, addr_t kva, uint pl)
{
ffff800000109a4e:	f3 0f 1e fa          	endbr64 
ffff800000109a52:	55                   	push   %rbp
ffff800000109a53:	48 89 e5             	mov    %rsp,%rbp
ffff800000109a56:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000109a5a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000109a5e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff800000109a61:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff800000109a65:	89 4d e0             	mov    %ecx,-0x20(%rbp)
  uint64 addr = (uint64) kva;
ffff800000109a68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000109a6c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  n *= 4;
ffff800000109a70:	c1 65 e4 02          	shll   $0x2,-0x1c(%rbp)
  idt[n+0] = (addr & 0xFFFF) | (KERNEL_CS << 16);
ffff800000109a74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109a78:	0f b7 d0             	movzwl %ax,%edx
ffff800000109a7b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000109a7e:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
ffff800000109a85:	00 
ffff800000109a86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109a8a:	48 01 c8             	add    %rcx,%rax
ffff800000109a8d:	81 ca 00 00 08 00    	or     $0x80000,%edx
ffff800000109a93:	89 10                	mov    %edx,(%rax)
  idt[n+1] = (addr & 0xFFFF0000) | 0x8E00 | ((pl & 3) << 13);
ffff800000109a95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109a99:	66 b8 00 00          	mov    $0x0,%ax
ffff800000109a9d:	89 c2                	mov    %eax,%edx
ffff800000109a9f:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000109aa2:	c1 e0 0d             	shl    $0xd,%eax
ffff800000109aa5:	25 00 60 00 00       	and    $0x6000,%eax
ffff800000109aaa:	09 c2                	or     %eax,%edx
ffff800000109aac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000109aaf:	83 c0 01             	add    $0x1,%eax
ffff800000109ab2:	89 c0                	mov    %eax,%eax
ffff800000109ab4:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
ffff800000109abb:	00 
ffff800000109abc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109ac0:	48 01 c8             	add    %rcx,%rax
ffff800000109ac3:	80 ce 8e             	or     $0x8e,%dh
ffff800000109ac6:	89 10                	mov    %edx,(%rax)
  idt[n+2] = addr >> 32;
ffff800000109ac8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109acc:	48 c1 e8 20          	shr    $0x20,%rax
ffff800000109ad0:	48 89 c2             	mov    %rax,%rdx
ffff800000109ad3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000109ad6:	83 c0 02             	add    $0x2,%eax
ffff800000109ad9:	89 c0                	mov    %eax,%eax
ffff800000109adb:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
ffff800000109ae2:	00 
ffff800000109ae3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109ae7:	48 01 c8             	add    %rcx,%rax
ffff800000109aea:	89 10                	mov    %edx,(%rax)
  idt[n+3] = 0;
ffff800000109aec:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000109aef:	83 c0 03             	add    $0x3,%eax
ffff800000109af2:	89 c0                	mov    %eax,%eax
ffff800000109af4:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000109afb:	00 
ffff800000109afc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109b00:	48 01 d0             	add    %rdx,%rax
ffff800000109b03:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
ffff800000109b09:	90                   	nop
ffff800000109b0a:	c9                   	leaveq 
ffff800000109b0b:	c3                   	retq   

ffff800000109b0c <idtinit>:

void idtinit(void)
{
ffff800000109b0c:	f3 0f 1e fa          	endbr64 
ffff800000109b10:	55                   	push   %rbp
ffff800000109b11:	48 89 e5             	mov    %rsp,%rbp
  lidt((void*) idt, PGSIZE);
ffff800000109b14:	48 b8 c0 ac 1f 00 00 	movabs $0xffff8000001facc0,%rax
ffff800000109b1b:	80 ff ff 
ffff800000109b1e:	48 8b 00             	mov    (%rax),%rax
ffff800000109b21:	be 00 10 00 00       	mov    $0x1000,%esi
ffff800000109b26:	48 89 c7             	mov    %rax,%rdi
ffff800000109b29:	48 b8 da 99 10 00 00 	movabs $0xffff8000001099da,%rax
ffff800000109b30:	80 ff ff 
ffff800000109b33:	ff d0                	callq  *%rax
}
ffff800000109b35:	90                   	nop
ffff800000109b36:	5d                   	pop    %rbp
ffff800000109b37:	c3                   	retq   

ffff800000109b38 <tvinit>:

void tvinit(void)
{
ffff800000109b38:	f3 0f 1e fa          	endbr64 
ffff800000109b3c:	55                   	push   %rbp
ffff800000109b3d:	48 89 e5             	mov    %rsp,%rbp
ffff800000109b40:	48 83 ec 10          	sub    $0x10,%rsp
  int n;
  idt = (uint*) kalloc();
ffff800000109b44:	48 b8 66 42 10 00 00 	movabs $0xffff800000104266,%rax
ffff800000109b4b:	80 ff ff 
ffff800000109b4e:	ff d0                	callq  *%rax
ffff800000109b50:	48 ba c0 ac 1f 00 00 	movabs $0xffff8000001facc0,%rdx
ffff800000109b57:	80 ff ff 
ffff800000109b5a:	48 89 02             	mov    %rax,(%rdx)
  memset(idt, 0, PGSIZE);
ffff800000109b5d:	48 b8 c0 ac 1f 00 00 	movabs $0xffff8000001facc0,%rax
ffff800000109b64:	80 ff ff 
ffff800000109b67:	48 8b 00             	mov    (%rax),%rax
ffff800000109b6a:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff800000109b6f:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000109b74:	48 89 c7             	mov    %rax,%rdi
ffff800000109b77:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff800000109b7e:	80 ff ff 
ffff800000109b81:	ff d0                	callq  *%rax

  for (n = 0; n < 256; n++)
ffff800000109b83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000109b8a:	eb 3b                	jmp    ffff800000109bc7 <tvinit+0x8f>
    mkgate(idt, n, vectors[n], 0);
ffff800000109b8c:	48 ba 60 d6 10 00 00 	movabs $0xffff80000010d660,%rdx
ffff800000109b93:	80 ff ff 
ffff800000109b96:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000109b99:	48 98                	cltq   
ffff800000109b9b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
ffff800000109b9f:	8b 75 fc             	mov    -0x4(%rbp),%esi
ffff800000109ba2:	48 b8 c0 ac 1f 00 00 	movabs $0xffff8000001facc0,%rax
ffff800000109ba9:	80 ff ff 
ffff800000109bac:	48 8b 00             	mov    (%rax),%rax
ffff800000109baf:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff800000109bb4:	48 89 c7             	mov    %rax,%rdi
ffff800000109bb7:	48 b8 4e 9a 10 00 00 	movabs $0xffff800000109a4e,%rax
ffff800000109bbe:	80 ff ff 
ffff800000109bc1:	ff d0                	callq  *%rax
  for (n = 0; n < 256; n++)
ffff800000109bc3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000109bc7:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
ffff800000109bce:	7e bc                	jle    ffff800000109b8c <tvinit+0x54>
}
ffff800000109bd0:	90                   	nop
ffff800000109bd1:	90                   	nop
ffff800000109bd2:	c9                   	leaveq 
ffff800000109bd3:	c3                   	retq   

ffff800000109bd4 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
ffff800000109bd4:	f3 0f 1e fa          	endbr64 
ffff800000109bd8:	55                   	push   %rbp
ffff800000109bd9:	48 89 e5             	mov    %rsp,%rbp
ffff800000109bdc:	41 54                	push   %r12
ffff800000109bde:	53                   	push   %rbx
ffff800000109bdf:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000109be3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  switch(tf->trapno){
ffff800000109be7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109beb:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff800000109bef:	48 83 e8 0e          	sub    $0xe,%rax
ffff800000109bf3:	48 83 f8 31          	cmp    $0x31,%rax
ffff800000109bf7:	0f 87 7d 01 00 00    	ja     ffff800000109d7a <trap+0x1a6>
ffff800000109bfd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff800000109c04:	00 
ffff800000109c05:	48 b8 58 ca 10 00 00 	movabs $0xffff80000010ca58,%rax
ffff800000109c0c:	80 ff ff 
ffff800000109c0f:	48 01 d0             	add    %rdx,%rax
ffff800000109c12:	48 8b 00             	mov    (%rax),%rax
ffff800000109c15:	3e ff e0             	notrack jmpq *%rax
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
ffff800000109c18:	48 b8 59 4a 10 00 00 	movabs $0xffff800000104a59,%rax
ffff800000109c1f:	80 ff ff 
ffff800000109c22:	ff d0                	callq  *%rax
ffff800000109c24:	85 c0                	test   %eax,%eax
ffff800000109c26:	75 5d                	jne    ffff800000109c85 <trap+0xb1>
      acquire(&tickslock);
ffff800000109c28:	48 bf e0 ac 1f 00 00 	movabs $0xffff8000001face0,%rdi
ffff800000109c2f:	80 ff ff 
ffff800000109c32:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000109c39:	80 ff ff 
ffff800000109c3c:	ff d0                	callq  *%rax
      ticks++;
ffff800000109c3e:	48 b8 48 ad 1f 00 00 	movabs $0xffff8000001fad48,%rax
ffff800000109c45:	80 ff ff 
ffff800000109c48:	8b 00                	mov    (%rax),%eax
ffff800000109c4a:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000109c4d:	48 b8 48 ad 1f 00 00 	movabs $0xffff8000001fad48,%rax
ffff800000109c54:	80 ff ff 
ffff800000109c57:	89 10                	mov    %edx,(%rax)
      wakeup(&ticks);
ffff800000109c59:	48 bf 48 ad 1f 00 00 	movabs $0xffff8000001fad48,%rdi
ffff800000109c60:	80 ff ff 
ffff800000109c63:	48 b8 b8 73 10 00 00 	movabs $0xffff8000001073b8,%rax
ffff800000109c6a:	80 ff ff 
ffff800000109c6d:	ff d0                	callq  *%rax
      release(&tickslock);
ffff800000109c6f:	48 bf e0 ac 1f 00 00 	movabs $0xffff8000001face0,%rdi
ffff800000109c76:	80 ff ff 
ffff800000109c79:	48 b8 fa 78 10 00 00 	movabs $0xffff8000001078fa,%rax
ffff800000109c80:	80 ff ff 
ffff800000109c83:	ff d0                	callq  *%rax
    }
    lapiceoi();
ffff800000109c85:	48 b8 5c 4b 10 00 00 	movabs $0xffff800000104b5c,%rax
ffff800000109c8c:	80 ff ff 
ffff800000109c8f:	ff d0                	callq  *%rax
    break;
ffff800000109c91:	e9 55 02 00 00       	jmpq   ffff800000109eeb <trap+0x317>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
ffff800000109c96:	48 b8 0a 3c 10 00 00 	movabs $0xffff800000103c0a,%rax
ffff800000109c9d:	80 ff ff 
ffff800000109ca0:	ff d0                	callq  *%rax
    lapiceoi();
ffff800000109ca2:	48 b8 5c 4b 10 00 00 	movabs $0xffff800000104b5c,%rax
ffff800000109ca9:	80 ff ff 
ffff800000109cac:	ff d0                	callq  *%rax
    break;
ffff800000109cae:	e9 38 02 00 00       	jmpq   ffff800000109eeb <trap+0x317>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
ffff800000109cb3:	48 b8 fd 47 10 00 00 	movabs $0xffff8000001047fd,%rax
ffff800000109cba:	80 ff ff 
ffff800000109cbd:	ff d0                	callq  *%rax
    lapiceoi();
ffff800000109cbf:	48 b8 5c 4b 10 00 00 	movabs $0xffff800000104b5c,%rax
ffff800000109cc6:	80 ff ff 
ffff800000109cc9:	ff d0                	callq  *%rax
    break;
ffff800000109ccb:	e9 1b 02 00 00       	jmpq   ffff800000109eeb <trap+0x317>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
ffff800000109cd0:	48 b8 2d a2 10 00 00 	movabs $0xffff80000010a22d,%rax
ffff800000109cd7:	80 ff ff 
ffff800000109cda:	ff d0                	callq  *%rax
    lapiceoi();
ffff800000109cdc:	48 b8 5c 4b 10 00 00 	movabs $0xffff800000104b5c,%rax
ffff800000109ce3:	80 ff ff 
ffff800000109ce6:	ff d0                	callq  *%rax
    break;
ffff800000109ce8:	e9 fe 01 00 00       	jmpq   ffff800000109eeb <trap+0x317>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %p:%p\n",
ffff800000109ced:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109cf1:	4c 8b a0 88 00 00 00 	mov    0x88(%rax),%r12
ffff800000109cf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109cfc:	48 8b 98 90 00 00 00 	mov    0x90(%rax),%rbx
ffff800000109d03:	48 b8 59 4a 10 00 00 	movabs $0xffff800000104a59,%rax
ffff800000109d0a:	80 ff ff 
ffff800000109d0d:	ff d0                	callq  *%rax
ffff800000109d0f:	4c 89 e1             	mov    %r12,%rcx
ffff800000109d12:	48 89 da             	mov    %rbx,%rdx
ffff800000109d15:	89 c6                	mov    %eax,%esi
ffff800000109d17:	48 bf a0 c9 10 00 00 	movabs $0xffff80000010c9a0,%rdi
ffff800000109d1e:	80 ff ff 
ffff800000109d21:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109d26:	49 b8 18 08 10 00 00 	movabs $0xffff800000100818,%r8
ffff800000109d2d:	80 ff ff 
ffff800000109d30:	41 ff d0             	callq  *%r8
            cpunum(), tf->cs, tf->rip);
    lapiceoi();
ffff800000109d33:	48 b8 5c 4b 10 00 00 	movabs $0xffff800000104b5c,%rax
ffff800000109d3a:	80 ff ff 
ffff800000109d3d:	ff d0                	callq  *%rax
    break;
ffff800000109d3f:	e9 a7 01 00 00       	jmpq   ffff800000109eeb <trap+0x317>

  case T_PGFLT: // at least a write: copyonwrite may copy the page
    if ((tf->err & 2) && copyonwrite((char *)rcr2()))
ffff800000109d44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109d48:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
ffff800000109d4f:	83 e0 02             	and    $0x2,%eax
ffff800000109d52:	48 85 c0             	test   %rax,%rax
ffff800000109d55:	74 23                	je     ffff800000109d7a <trap+0x1a6>
ffff800000109d57:	48 b8 35 9a 10 00 00 	movabs $0xffff800000109a35,%rax
ffff800000109d5e:	80 ff ff 
ffff800000109d61:	ff d0                	callq  *%rax
ffff800000109d63:	48 89 c7             	mov    %rax,%rdi
ffff800000109d66:	48 b8 c2 c3 10 00 00 	movabs $0xffff80000010c3c2,%rax
ffff800000109d6d:	80 ff ff 
ffff800000109d70:	ff d0                	callq  *%rax
ffff800000109d72:	85 c0                	test   %eax,%eax
ffff800000109d74:	0f 85 70 01 00 00    	jne    ffff800000109eea <trap+0x316>
      break;
    // else fall-through to default:
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
ffff800000109d7a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109d81:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109d85:	48 85 c0             	test   %rax,%rax
ffff800000109d88:	74 17                	je     ffff800000109da1 <trap+0x1cd>
ffff800000109d8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109d8e:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
ffff800000109d95:	83 e0 03             	and    $0x3,%eax
ffff800000109d98:	48 85 c0             	test   %rax,%rax
ffff800000109d9b:	0f 85 a6 00 00 00    	jne    ffff800000109e47 <trap+0x273>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d rip %p (cr2=0x%p)\n",
ffff800000109da1:	48 b8 35 9a 10 00 00 	movabs $0xffff800000109a35,%rax
ffff800000109da8:	80 ff ff 
ffff800000109dab:	ff d0                	callq  *%rax
ffff800000109dad:	49 89 c4             	mov    %rax,%r12
ffff800000109db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109db4:	48 8b 98 88 00 00 00 	mov    0x88(%rax),%rbx
ffff800000109dbb:	48 b8 59 4a 10 00 00 	movabs $0xffff800000104a59,%rax
ffff800000109dc2:	80 ff ff 
ffff800000109dc5:	ff d0                	callq  *%rax
ffff800000109dc7:	89 c2                	mov    %eax,%edx
ffff800000109dc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109dcd:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff800000109dd1:	4d 89 e0             	mov    %r12,%r8
ffff800000109dd4:	48 89 d9             	mov    %rbx,%rcx
ffff800000109dd7:	48 89 c6             	mov    %rax,%rsi
ffff800000109dda:	48 bf c8 c9 10 00 00 	movabs $0xffff80000010c9c8,%rdi
ffff800000109de1:	80 ff ff 
ffff800000109de4:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109de9:	49 b9 18 08 10 00 00 	movabs $0xffff800000100818,%r9
ffff800000109df0:	80 ff ff 
ffff800000109df3:	41 ff d1             	callq  *%r9
              tf->trapno, cpunum(), tf->rip, rcr2());
      if (proc)
ffff800000109df6:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109dfd:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109e01:	48 85 c0             	test   %rax,%rax
ffff800000109e04:	74 2b                	je     ffff800000109e31 <trap+0x25d>
        cprintf("proc id: %d\n", proc->pid);
ffff800000109e06:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109e0d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109e11:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000109e14:	89 c6                	mov    %eax,%esi
ffff800000109e16:	48 bf fa c9 10 00 00 	movabs $0xffff80000010c9fa,%rdi
ffff800000109e1d:	80 ff ff 
ffff800000109e20:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109e25:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000109e2c:	80 ff ff 
ffff800000109e2f:	ff d2                	callq  *%rdx
      panic("trap");
ffff800000109e31:	48 bf 07 ca 10 00 00 	movabs $0xffff80000010ca07,%rdi
ffff800000109e38:	80 ff ff 
ffff800000109e3b:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000109e42:	80 ff ff 
ffff800000109e45:	ff d0                	callq  *%rax
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
ffff800000109e47:	48 b8 35 9a 10 00 00 	movabs $0xffff800000109a35,%rax
ffff800000109e4e:	80 ff ff 
ffff800000109e51:	ff d0                	callq  *%rax
ffff800000109e53:	48 89 c3             	mov    %rax,%rbx
ffff800000109e56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109e5a:	4c 8b a0 88 00 00 00 	mov    0x88(%rax),%r12
ffff800000109e61:	48 b8 59 4a 10 00 00 	movabs $0xffff800000104a59,%rax
ffff800000109e68:	80 ff ff 
ffff800000109e6b:	ff d0                	callq  *%rax
ffff800000109e6d:	89 c1                	mov    %eax,%ecx
ffff800000109e6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109e73:	48 8b b8 80 00 00 00 	mov    0x80(%rax),%rdi
ffff800000109e7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109e7e:	48 8b 50 78          	mov    0x78(%rax),%rdx
            "rip 0x%p addr 0x%p--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->rip,
ffff800000109e82:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109e89:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109e8d:	48 8d b0 d0 00 00 00 	lea    0xd0(%rax),%rsi
ffff800000109e94:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109e9b:	64 48 8b 00          	mov    %fs:(%rax),%rax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
ffff800000109e9f:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000109ea2:	53                   	push   %rbx
ffff800000109ea3:	41 54                	push   %r12
ffff800000109ea5:	41 89 c9             	mov    %ecx,%r9d
ffff800000109ea8:	49 89 f8             	mov    %rdi,%r8
ffff800000109eab:	48 89 d1             	mov    %rdx,%rcx
ffff800000109eae:	48 89 f2             	mov    %rsi,%rdx
ffff800000109eb1:	89 c6                	mov    %eax,%esi
ffff800000109eb3:	48 bf 10 ca 10 00 00 	movabs $0xffff80000010ca10,%rdi
ffff800000109eba:	80 ff ff 
ffff800000109ebd:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109ec2:	49 ba 18 08 10 00 00 	movabs $0xffff800000100818,%r10
ffff800000109ec9:	80 ff ff 
ffff800000109ecc:	41 ff d2             	callq  *%r10
ffff800000109ecf:	48 83 c4 10          	add    $0x10,%rsp
            rcr2());
    proc->killed = 1;
ffff800000109ed3:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109eda:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109ede:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%rax)
ffff800000109ee5:	eb 04                	jmp    ffff800000109eeb <trap+0x317>
    break;
ffff800000109ee7:	90                   	nop
ffff800000109ee8:	eb 01                	jmp    ffff800000109eeb <trap+0x317>
      break;
ffff800000109eea:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
ffff800000109eeb:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109ef2:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109ef6:	48 85 c0             	test   %rax,%rax
ffff800000109ef9:	74 32                	je     ffff800000109f2d <trap+0x359>
ffff800000109efb:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109f02:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109f06:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000109f09:	85 c0                	test   %eax,%eax
ffff800000109f0b:	74 20                	je     ffff800000109f2d <trap+0x359>
ffff800000109f0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109f11:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
ffff800000109f18:	83 e0 03             	and    $0x3,%eax
ffff800000109f1b:	48 83 f8 03          	cmp    $0x3,%rax
ffff800000109f1f:	75 0c                	jne    ffff800000109f2d <trap+0x359>
    exit();
ffff800000109f21:	48 b8 d3 6b 10 00 00 	movabs $0xffff800000106bd3,%rax
ffff800000109f28:	80 ff ff 
ffff800000109f2b:	ff d0                	callq  *%rax

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
ffff800000109f2d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109f34:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109f38:	48 85 c0             	test   %rax,%rax
ffff800000109f3b:	74 2d                	je     ffff800000109f6a <trap+0x396>
ffff800000109f3d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109f44:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109f48:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000109f4b:	83 f8 04             	cmp    $0x4,%eax
ffff800000109f4e:	75 1a                	jne    ffff800000109f6a <trap+0x396>
ffff800000109f50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109f54:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff800000109f58:	48 83 f8 20          	cmp    $0x20,%rax
ffff800000109f5c:	75 0c                	jne    ffff800000109f6a <trap+0x396>
    yield();
ffff800000109f5e:	48 b8 8f 71 10 00 00 	movabs $0xffff80000010718f,%rax
ffff800000109f65:	80 ff ff 
ffff800000109f68:	ff d0                	callq  *%rax

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
ffff800000109f6a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109f71:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109f75:	48 85 c0             	test   %rax,%rax
ffff800000109f78:	74 32                	je     ffff800000109fac <trap+0x3d8>
ffff800000109f7a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109f81:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109f85:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000109f88:	85 c0                	test   %eax,%eax
ffff800000109f8a:	74 20                	je     ffff800000109fac <trap+0x3d8>
ffff800000109f8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109f90:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
ffff800000109f97:	83 e0 03             	and    $0x3,%eax
ffff800000109f9a:	48 83 f8 03          	cmp    $0x3,%rax
ffff800000109f9e:	75 0c                	jne    ffff800000109fac <trap+0x3d8>
    exit();
ffff800000109fa0:	48 b8 d3 6b 10 00 00 	movabs $0xffff800000106bd3,%rax
ffff800000109fa7:	80 ff ff 
ffff800000109faa:	ff d0                	callq  *%rax
}
ffff800000109fac:	90                   	nop
ffff800000109fad:	48 8d 65 f0          	lea    -0x10(%rbp),%rsp
ffff800000109fb1:	5b                   	pop    %rbx
ffff800000109fb2:	41 5c                	pop    %r12
ffff800000109fb4:	5d                   	pop    %rbp
ffff800000109fb5:	c3                   	retq   

ffff800000109fb6 <inb>:
{
ffff800000109fb6:	f3 0f 1e fa          	endbr64 
ffff800000109fba:	55                   	push   %rbp
ffff800000109fbb:	48 89 e5             	mov    %rsp,%rbp
ffff800000109fbe:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000109fc2:	89 f8                	mov    %edi,%eax
ffff800000109fc4:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff800000109fc8:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff800000109fcc:	89 c2                	mov    %eax,%edx
ffff800000109fce:	ec                   	in     (%dx),%al
ffff800000109fcf:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff800000109fd2:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff800000109fd6:	c9                   	leaveq 
ffff800000109fd7:	c3                   	retq   

ffff800000109fd8 <outb>:
{
ffff800000109fd8:	f3 0f 1e fa          	endbr64 
ffff800000109fdc:	55                   	push   %rbp
ffff800000109fdd:	48 89 e5             	mov    %rsp,%rbp
ffff800000109fe0:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000109fe4:	89 f8                	mov    %edi,%eax
ffff800000109fe6:	89 f2                	mov    %esi,%edx
ffff800000109fe8:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
ffff800000109fec:	89 d0                	mov    %edx,%eax
ffff800000109fee:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff800000109ff1:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff800000109ff5:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff800000109ff9:	ee                   	out    %al,(%dx)
}
ffff800000109ffa:	90                   	nop
ffff800000109ffb:	c9                   	leaveq 
ffff800000109ffc:	c3                   	retq   

ffff800000109ffd <uartearlyinit>:

static int uart;    // is there a uart?

void
uartearlyinit(void)
{
ffff800000109ffd:	f3 0f 1e fa          	endbr64 
ffff80000010a001:	55                   	push   %rbp
ffff80000010a002:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a005:	48 83 ec 10          	sub    $0x10,%rsp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
ffff80000010a009:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a00e:	bf fa 03 00 00       	mov    $0x3fa,%edi
ffff80000010a013:	48 b8 d8 9f 10 00 00 	movabs $0xffff800000109fd8,%rax
ffff80000010a01a:	80 ff ff 
ffff80000010a01d:	ff d0                	callq  *%rax

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
ffff80000010a01f:	be 80 00 00 00       	mov    $0x80,%esi
ffff80000010a024:	bf fb 03 00 00       	mov    $0x3fb,%edi
ffff80000010a029:	48 b8 d8 9f 10 00 00 	movabs $0xffff800000109fd8,%rax
ffff80000010a030:	80 ff ff 
ffff80000010a033:	ff d0                	callq  *%rax
  outb(COM1+0, 115200/9600);
ffff80000010a035:	be 0c 00 00 00       	mov    $0xc,%esi
ffff80000010a03a:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff80000010a03f:	48 b8 d8 9f 10 00 00 	movabs $0xffff800000109fd8,%rax
ffff80000010a046:	80 ff ff 
ffff80000010a049:	ff d0                	callq  *%rax
  outb(COM1+1, 0);
ffff80000010a04b:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a050:	bf f9 03 00 00       	mov    $0x3f9,%edi
ffff80000010a055:	48 b8 d8 9f 10 00 00 	movabs $0xffff800000109fd8,%rax
ffff80000010a05c:	80 ff ff 
ffff80000010a05f:	ff d0                	callq  *%rax
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
ffff80000010a061:	be 03 00 00 00       	mov    $0x3,%esi
ffff80000010a066:	bf fb 03 00 00       	mov    $0x3fb,%edi
ffff80000010a06b:	48 b8 d8 9f 10 00 00 	movabs $0xffff800000109fd8,%rax
ffff80000010a072:	80 ff ff 
ffff80000010a075:	ff d0                	callq  *%rax
  outb(COM1+4, 0);
ffff80000010a077:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a07c:	bf fc 03 00 00       	mov    $0x3fc,%edi
ffff80000010a081:	48 b8 d8 9f 10 00 00 	movabs $0xffff800000109fd8,%rax
ffff80000010a088:	80 ff ff 
ffff80000010a08b:	ff d0                	callq  *%rax
  outb(COM1+1, 0x01);    // Enable receive interrupts.
ffff80000010a08d:	be 01 00 00 00       	mov    $0x1,%esi
ffff80000010a092:	bf f9 03 00 00       	mov    $0x3f9,%edi
ffff80000010a097:	48 b8 d8 9f 10 00 00 	movabs $0xffff800000109fd8,%rax
ffff80000010a09e:	80 ff ff 
ffff80000010a0a1:	ff d0                	callq  *%rax

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
ffff80000010a0a3:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffff80000010a0a8:	48 b8 b6 9f 10 00 00 	movabs $0xffff800000109fb6,%rax
ffff80000010a0af:	80 ff ff 
ffff80000010a0b2:	ff d0                	callq  *%rax
ffff80000010a0b4:	3c ff                	cmp    $0xff,%al
ffff80000010a0b6:	74 4a                	je     ffff80000010a102 <uartearlyinit+0x105>
    return;
  uart = 1;
ffff80000010a0b8:	48 b8 4c ad 1f 00 00 	movabs $0xffff8000001fad4c,%rax
ffff80000010a0bf:	80 ff ff 
ffff80000010a0c2:	c7 00 01 00 00 00    	movl   $0x1,(%rax)



  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
ffff80000010a0c8:	48 b8 e8 cb 10 00 00 	movabs $0xffff80000010cbe8,%rax
ffff80000010a0cf:	80 ff ff 
ffff80000010a0d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010a0d6:	eb 1d                	jmp    ffff80000010a0f5 <uartearlyinit+0xf8>
    uartputc(*p);
ffff80000010a0d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a0dc:	0f b6 00             	movzbl (%rax),%eax
ffff80000010a0df:	0f be c0             	movsbl %al,%eax
ffff80000010a0e2:	89 c7                	mov    %eax,%edi
ffff80000010a0e4:	48 b8 5a a1 10 00 00 	movabs $0xffff80000010a15a,%rax
ffff80000010a0eb:	80 ff ff 
ffff80000010a0ee:	ff d0                	callq  *%rax
  for(p="xv6...\n"; *p; p++)
ffff80000010a0f0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff80000010a0f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a0f9:	0f b6 00             	movzbl (%rax),%eax
ffff80000010a0fc:	84 c0                	test   %al,%al
ffff80000010a0fe:	75 d8                	jne    ffff80000010a0d8 <uartearlyinit+0xdb>
ffff80000010a100:	eb 01                	jmp    ffff80000010a103 <uartearlyinit+0x106>
    return;
ffff80000010a102:	90                   	nop
}
ffff80000010a103:	c9                   	leaveq 
ffff80000010a104:	c3                   	retq   

ffff80000010a105 <uartinit>:

void
uartinit(void)
{
ffff80000010a105:	f3 0f 1e fa          	endbr64 
ffff80000010a109:	55                   	push   %rbp
ffff80000010a10a:	48 89 e5             	mov    %rsp,%rbp
  if(!uart)
ffff80000010a10d:	48 b8 4c ad 1f 00 00 	movabs $0xffff8000001fad4c,%rax
ffff80000010a114:	80 ff ff 
ffff80000010a117:	8b 00                	mov    (%rax),%eax
ffff80000010a119:	85 c0                	test   %eax,%eax
ffff80000010a11b:	74 3a                	je     ffff80000010a157 <uartinit+0x52>
    return;

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
ffff80000010a11d:	bf fa 03 00 00       	mov    $0x3fa,%edi
ffff80000010a122:	48 b8 b6 9f 10 00 00 	movabs $0xffff800000109fb6,%rax
ffff80000010a129:	80 ff ff 
ffff80000010a12c:	ff d0                	callq  *%rax
  inb(COM1+0);
ffff80000010a12e:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff80000010a133:	48 b8 b6 9f 10 00 00 	movabs $0xffff800000109fb6,%rax
ffff80000010a13a:	80 ff ff 
ffff80000010a13d:	ff d0                	callq  *%rax
  ioapicenable(IRQ_COM1, 0);
ffff80000010a13f:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a144:	bf 04 00 00 00       	mov    $0x4,%edi
ffff80000010a149:	48 b8 e5 3f 10 00 00 	movabs $0xffff800000103fe5,%rax
ffff80000010a150:	80 ff ff 
ffff80000010a153:	ff d0                	callq  *%rax
ffff80000010a155:	eb 01                	jmp    ffff80000010a158 <uartinit+0x53>
    return;
ffff80000010a157:	90                   	nop

}
ffff80000010a158:	5d                   	pop    %rbp
ffff80000010a159:	c3                   	retq   

ffff80000010a15a <uartputc>:
void
uartputc(int c)
{
ffff80000010a15a:	f3 0f 1e fa          	endbr64 
ffff80000010a15e:	55                   	push   %rbp
ffff80000010a15f:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a162:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010a166:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int i;

  if(!uart)
ffff80000010a169:	48 b8 4c ad 1f 00 00 	movabs $0xffff8000001fad4c,%rax
ffff80000010a170:	80 ff ff 
ffff80000010a173:	8b 00                	mov    (%rax),%eax
ffff80000010a175:	85 c0                	test   %eax,%eax
ffff80000010a177:	74 5a                	je     ffff80000010a1d3 <uartputc+0x79>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
ffff80000010a179:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010a180:	eb 15                	jmp    ffff80000010a197 <uartputc+0x3d>
    microdelay(10);
ffff80000010a182:	bf 0a 00 00 00       	mov    $0xa,%edi
ffff80000010a187:	48 b8 8f 4b 10 00 00 	movabs $0xffff800000104b8f,%rax
ffff80000010a18e:	80 ff ff 
ffff80000010a191:	ff d0                	callq  *%rax
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
ffff80000010a193:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010a197:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
ffff80000010a19b:	7f 1b                	jg     ffff80000010a1b8 <uartputc+0x5e>
ffff80000010a19d:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffff80000010a1a2:	48 b8 b6 9f 10 00 00 	movabs $0xffff800000109fb6,%rax
ffff80000010a1a9:	80 ff ff 
ffff80000010a1ac:	ff d0                	callq  *%rax
ffff80000010a1ae:	0f b6 c0             	movzbl %al,%eax
ffff80000010a1b1:	83 e0 20             	and    $0x20,%eax
ffff80000010a1b4:	85 c0                	test   %eax,%eax
ffff80000010a1b6:	74 ca                	je     ffff80000010a182 <uartputc+0x28>
  outb(COM1+0, c);
ffff80000010a1b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010a1bb:	0f b6 c0             	movzbl %al,%eax
ffff80000010a1be:	89 c6                	mov    %eax,%esi
ffff80000010a1c0:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff80000010a1c5:	48 b8 d8 9f 10 00 00 	movabs $0xffff800000109fd8,%rax
ffff80000010a1cc:	80 ff ff 
ffff80000010a1cf:	ff d0                	callq  *%rax
ffff80000010a1d1:	eb 01                	jmp    ffff80000010a1d4 <uartputc+0x7a>
    return;
ffff80000010a1d3:	90                   	nop
}
ffff80000010a1d4:	c9                   	leaveq 
ffff80000010a1d5:	c3                   	retq   

ffff80000010a1d6 <uartgetc>:

static int
uartgetc(void)
{
ffff80000010a1d6:	f3 0f 1e fa          	endbr64 
ffff80000010a1da:	55                   	push   %rbp
ffff80000010a1db:	48 89 e5             	mov    %rsp,%rbp
  if(!uart)
ffff80000010a1de:	48 b8 4c ad 1f 00 00 	movabs $0xffff8000001fad4c,%rax
ffff80000010a1e5:	80 ff ff 
ffff80000010a1e8:	8b 00                	mov    (%rax),%eax
ffff80000010a1ea:	85 c0                	test   %eax,%eax
ffff80000010a1ec:	75 07                	jne    ffff80000010a1f5 <uartgetc+0x1f>
    return -1;
ffff80000010a1ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010a1f3:	eb 36                	jmp    ffff80000010a22b <uartgetc+0x55>
  if(!(inb(COM1+5) & 0x01))
ffff80000010a1f5:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffff80000010a1fa:	48 b8 b6 9f 10 00 00 	movabs $0xffff800000109fb6,%rax
ffff80000010a201:	80 ff ff 
ffff80000010a204:	ff d0                	callq  *%rax
ffff80000010a206:	0f b6 c0             	movzbl %al,%eax
ffff80000010a209:	83 e0 01             	and    $0x1,%eax
ffff80000010a20c:	85 c0                	test   %eax,%eax
ffff80000010a20e:	75 07                	jne    ffff80000010a217 <uartgetc+0x41>
    return -1;
ffff80000010a210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010a215:	eb 14                	jmp    ffff80000010a22b <uartgetc+0x55>
  return inb(COM1+0);
ffff80000010a217:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff80000010a21c:	48 b8 b6 9f 10 00 00 	movabs $0xffff800000109fb6,%rax
ffff80000010a223:	80 ff ff 
ffff80000010a226:	ff d0                	callq  *%rax
ffff80000010a228:	0f b6 c0             	movzbl %al,%eax
}
ffff80000010a22b:	5d                   	pop    %rbp
ffff80000010a22c:	c3                   	retq   

ffff80000010a22d <uartintr>:

void
uartintr(void)
{
ffff80000010a22d:	f3 0f 1e fa          	endbr64 
ffff80000010a231:	55                   	push   %rbp
ffff80000010a232:	48 89 e5             	mov    %rsp,%rbp
  consoleintr(uartgetc);
ffff80000010a235:	48 bf d6 a1 10 00 00 	movabs $0xffff80000010a1d6,%rdi
ffff80000010a23c:	80 ff ff 
ffff80000010a23f:	48 b8 83 0f 10 00 00 	movabs $0xffff800000100f83,%rax
ffff80000010a246:	80 ff ff 
ffff80000010a249:	ff d0                	callq  *%rax
}
ffff80000010a24b:	90                   	nop
ffff80000010a24c:	5d                   	pop    %rbp
ffff80000010a24d:	c3                   	retq   

ffff80000010a24e <vector0>:
# generated by vectors.pl - do not edit
# handlers
.global alltraps
vector0:
  push $0
ffff80000010a24e:	6a 00                	pushq  $0x0
  push $0
ffff80000010a250:	6a 00                	pushq  $0x0
  jmp alltraps
ffff80000010a252:	e9 d1 f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a257 <vector1>:
vector1:
  push $0
ffff80000010a257:	6a 00                	pushq  $0x0
  push $1
ffff80000010a259:	6a 01                	pushq  $0x1
  jmp alltraps
ffff80000010a25b:	e9 c8 f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a260 <vector2>:
vector2:
  push $0
ffff80000010a260:	6a 00                	pushq  $0x0
  push $2
ffff80000010a262:	6a 02                	pushq  $0x2
  jmp alltraps
ffff80000010a264:	e9 bf f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a269 <vector3>:
vector3:
  push $0
ffff80000010a269:	6a 00                	pushq  $0x0
  push $3
ffff80000010a26b:	6a 03                	pushq  $0x3
  jmp alltraps
ffff80000010a26d:	e9 b6 f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a272 <vector4>:
vector4:
  push $0
ffff80000010a272:	6a 00                	pushq  $0x0
  push $4
ffff80000010a274:	6a 04                	pushq  $0x4
  jmp alltraps
ffff80000010a276:	e9 ad f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a27b <vector5>:
vector5:
  push $0
ffff80000010a27b:	6a 00                	pushq  $0x0
  push $5
ffff80000010a27d:	6a 05                	pushq  $0x5
  jmp alltraps
ffff80000010a27f:	e9 a4 f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a284 <vector6>:
vector6:
  push $0
ffff80000010a284:	6a 00                	pushq  $0x0
  push $6
ffff80000010a286:	6a 06                	pushq  $0x6
  jmp alltraps
ffff80000010a288:	e9 9b f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a28d <vector7>:
vector7:
  push $0
ffff80000010a28d:	6a 00                	pushq  $0x0
  push $7
ffff80000010a28f:	6a 07                	pushq  $0x7
  jmp alltraps
ffff80000010a291:	e9 92 f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a296 <vector8>:
vector8:
  push $8
ffff80000010a296:	6a 08                	pushq  $0x8
  jmp alltraps
ffff80000010a298:	e9 8b f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a29d <vector9>:
vector9:
  push $0
ffff80000010a29d:	6a 00                	pushq  $0x0
  push $9
ffff80000010a29f:	6a 09                	pushq  $0x9
  jmp alltraps
ffff80000010a2a1:	e9 82 f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a2a6 <vector10>:
vector10:
  push $10
ffff80000010a2a6:	6a 0a                	pushq  $0xa
  jmp alltraps
ffff80000010a2a8:	e9 7b f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a2ad <vector11>:
vector11:
  push $11
ffff80000010a2ad:	6a 0b                	pushq  $0xb
  jmp alltraps
ffff80000010a2af:	e9 74 f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a2b4 <vector12>:
vector12:
  push $12
ffff80000010a2b4:	6a 0c                	pushq  $0xc
  jmp alltraps
ffff80000010a2b6:	e9 6d f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a2bb <vector13>:
vector13:
  push $13
ffff80000010a2bb:	6a 0d                	pushq  $0xd
  jmp alltraps
ffff80000010a2bd:	e9 66 f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a2c2 <vector14>:
vector14:
  push $14
ffff80000010a2c2:	6a 0e                	pushq  $0xe
  jmp alltraps
ffff80000010a2c4:	e9 5f f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a2c9 <vector15>:
vector15:
  push $0
ffff80000010a2c9:	6a 00                	pushq  $0x0
  push $15
ffff80000010a2cb:	6a 0f                	pushq  $0xf
  jmp alltraps
ffff80000010a2cd:	e9 56 f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a2d2 <vector16>:
vector16:
  push $0
ffff80000010a2d2:	6a 00                	pushq  $0x0
  push $16
ffff80000010a2d4:	6a 10                	pushq  $0x10
  jmp alltraps
ffff80000010a2d6:	e9 4d f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a2db <vector17>:
vector17:
  push $17
ffff80000010a2db:	6a 11                	pushq  $0x11
  jmp alltraps
ffff80000010a2dd:	e9 46 f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a2e2 <vector18>:
vector18:
  push $0
ffff80000010a2e2:	6a 00                	pushq  $0x0
  push $18
ffff80000010a2e4:	6a 12                	pushq  $0x12
  jmp alltraps
ffff80000010a2e6:	e9 3d f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a2eb <vector19>:
vector19:
  push $0
ffff80000010a2eb:	6a 00                	pushq  $0x0
  push $19
ffff80000010a2ed:	6a 13                	pushq  $0x13
  jmp alltraps
ffff80000010a2ef:	e9 34 f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a2f4 <vector20>:
vector20:
  push $0
ffff80000010a2f4:	6a 00                	pushq  $0x0
  push $20
ffff80000010a2f6:	6a 14                	pushq  $0x14
  jmp alltraps
ffff80000010a2f8:	e9 2b f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a2fd <vector21>:
vector21:
  push $0
ffff80000010a2fd:	6a 00                	pushq  $0x0
  push $21
ffff80000010a2ff:	6a 15                	pushq  $0x15
  jmp alltraps
ffff80000010a301:	e9 22 f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a306 <vector22>:
vector22:
  push $0
ffff80000010a306:	6a 00                	pushq  $0x0
  push $22
ffff80000010a308:	6a 16                	pushq  $0x16
  jmp alltraps
ffff80000010a30a:	e9 19 f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a30f <vector23>:
vector23:
  push $0
ffff80000010a30f:	6a 00                	pushq  $0x0
  push $23
ffff80000010a311:	6a 17                	pushq  $0x17
  jmp alltraps
ffff80000010a313:	e9 10 f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a318 <vector24>:
vector24:
  push $0
ffff80000010a318:	6a 00                	pushq  $0x0
  push $24
ffff80000010a31a:	6a 18                	pushq  $0x18
  jmp alltraps
ffff80000010a31c:	e9 07 f6 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a321 <vector25>:
vector25:
  push $0
ffff80000010a321:	6a 00                	pushq  $0x0
  push $25
ffff80000010a323:	6a 19                	pushq  $0x19
  jmp alltraps
ffff80000010a325:	e9 fe f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a32a <vector26>:
vector26:
  push $0
ffff80000010a32a:	6a 00                	pushq  $0x0
  push $26
ffff80000010a32c:	6a 1a                	pushq  $0x1a
  jmp alltraps
ffff80000010a32e:	e9 f5 f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a333 <vector27>:
vector27:
  push $0
ffff80000010a333:	6a 00                	pushq  $0x0
  push $27
ffff80000010a335:	6a 1b                	pushq  $0x1b
  jmp alltraps
ffff80000010a337:	e9 ec f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a33c <vector28>:
vector28:
  push $0
ffff80000010a33c:	6a 00                	pushq  $0x0
  push $28
ffff80000010a33e:	6a 1c                	pushq  $0x1c
  jmp alltraps
ffff80000010a340:	e9 e3 f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a345 <vector29>:
vector29:
  push $0
ffff80000010a345:	6a 00                	pushq  $0x0
  push $29
ffff80000010a347:	6a 1d                	pushq  $0x1d
  jmp alltraps
ffff80000010a349:	e9 da f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a34e <vector30>:
vector30:
  push $0
ffff80000010a34e:	6a 00                	pushq  $0x0
  push $30
ffff80000010a350:	6a 1e                	pushq  $0x1e
  jmp alltraps
ffff80000010a352:	e9 d1 f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a357 <vector31>:
vector31:
  push $0
ffff80000010a357:	6a 00                	pushq  $0x0
  push $31
ffff80000010a359:	6a 1f                	pushq  $0x1f
  jmp alltraps
ffff80000010a35b:	e9 c8 f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a360 <vector32>:
vector32:
  push $0
ffff80000010a360:	6a 00                	pushq  $0x0
  push $32
ffff80000010a362:	6a 20                	pushq  $0x20
  jmp alltraps
ffff80000010a364:	e9 bf f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a369 <vector33>:
vector33:
  push $0
ffff80000010a369:	6a 00                	pushq  $0x0
  push $33
ffff80000010a36b:	6a 21                	pushq  $0x21
  jmp alltraps
ffff80000010a36d:	e9 b6 f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a372 <vector34>:
vector34:
  push $0
ffff80000010a372:	6a 00                	pushq  $0x0
  push $34
ffff80000010a374:	6a 22                	pushq  $0x22
  jmp alltraps
ffff80000010a376:	e9 ad f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a37b <vector35>:
vector35:
  push $0
ffff80000010a37b:	6a 00                	pushq  $0x0
  push $35
ffff80000010a37d:	6a 23                	pushq  $0x23
  jmp alltraps
ffff80000010a37f:	e9 a4 f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a384 <vector36>:
vector36:
  push $0
ffff80000010a384:	6a 00                	pushq  $0x0
  push $36
ffff80000010a386:	6a 24                	pushq  $0x24
  jmp alltraps
ffff80000010a388:	e9 9b f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a38d <vector37>:
vector37:
  push $0
ffff80000010a38d:	6a 00                	pushq  $0x0
  push $37
ffff80000010a38f:	6a 25                	pushq  $0x25
  jmp alltraps
ffff80000010a391:	e9 92 f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a396 <vector38>:
vector38:
  push $0
ffff80000010a396:	6a 00                	pushq  $0x0
  push $38
ffff80000010a398:	6a 26                	pushq  $0x26
  jmp alltraps
ffff80000010a39a:	e9 89 f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a39f <vector39>:
vector39:
  push $0
ffff80000010a39f:	6a 00                	pushq  $0x0
  push $39
ffff80000010a3a1:	6a 27                	pushq  $0x27
  jmp alltraps
ffff80000010a3a3:	e9 80 f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a3a8 <vector40>:
vector40:
  push $0
ffff80000010a3a8:	6a 00                	pushq  $0x0
  push $40
ffff80000010a3aa:	6a 28                	pushq  $0x28
  jmp alltraps
ffff80000010a3ac:	e9 77 f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a3b1 <vector41>:
vector41:
  push $0
ffff80000010a3b1:	6a 00                	pushq  $0x0
  push $41
ffff80000010a3b3:	6a 29                	pushq  $0x29
  jmp alltraps
ffff80000010a3b5:	e9 6e f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a3ba <vector42>:
vector42:
  push $0
ffff80000010a3ba:	6a 00                	pushq  $0x0
  push $42
ffff80000010a3bc:	6a 2a                	pushq  $0x2a
  jmp alltraps
ffff80000010a3be:	e9 65 f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a3c3 <vector43>:
vector43:
  push $0
ffff80000010a3c3:	6a 00                	pushq  $0x0
  push $43
ffff80000010a3c5:	6a 2b                	pushq  $0x2b
  jmp alltraps
ffff80000010a3c7:	e9 5c f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a3cc <vector44>:
vector44:
  push $0
ffff80000010a3cc:	6a 00                	pushq  $0x0
  push $44
ffff80000010a3ce:	6a 2c                	pushq  $0x2c
  jmp alltraps
ffff80000010a3d0:	e9 53 f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a3d5 <vector45>:
vector45:
  push $0
ffff80000010a3d5:	6a 00                	pushq  $0x0
  push $45
ffff80000010a3d7:	6a 2d                	pushq  $0x2d
  jmp alltraps
ffff80000010a3d9:	e9 4a f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a3de <vector46>:
vector46:
  push $0
ffff80000010a3de:	6a 00                	pushq  $0x0
  push $46
ffff80000010a3e0:	6a 2e                	pushq  $0x2e
  jmp alltraps
ffff80000010a3e2:	e9 41 f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a3e7 <vector47>:
vector47:
  push $0
ffff80000010a3e7:	6a 00                	pushq  $0x0
  push $47
ffff80000010a3e9:	6a 2f                	pushq  $0x2f
  jmp alltraps
ffff80000010a3eb:	e9 38 f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a3f0 <vector48>:
vector48:
  push $0
ffff80000010a3f0:	6a 00                	pushq  $0x0
  push $48
ffff80000010a3f2:	6a 30                	pushq  $0x30
  jmp alltraps
ffff80000010a3f4:	e9 2f f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a3f9 <vector49>:
vector49:
  push $0
ffff80000010a3f9:	6a 00                	pushq  $0x0
  push $49
ffff80000010a3fb:	6a 31                	pushq  $0x31
  jmp alltraps
ffff80000010a3fd:	e9 26 f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a402 <vector50>:
vector50:
  push $0
ffff80000010a402:	6a 00                	pushq  $0x0
  push $50
ffff80000010a404:	6a 32                	pushq  $0x32
  jmp alltraps
ffff80000010a406:	e9 1d f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a40b <vector51>:
vector51:
  push $0
ffff80000010a40b:	6a 00                	pushq  $0x0
  push $51
ffff80000010a40d:	6a 33                	pushq  $0x33
  jmp alltraps
ffff80000010a40f:	e9 14 f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a414 <vector52>:
vector52:
  push $0
ffff80000010a414:	6a 00                	pushq  $0x0
  push $52
ffff80000010a416:	6a 34                	pushq  $0x34
  jmp alltraps
ffff80000010a418:	e9 0b f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a41d <vector53>:
vector53:
  push $0
ffff80000010a41d:	6a 00                	pushq  $0x0
  push $53
ffff80000010a41f:	6a 35                	pushq  $0x35
  jmp alltraps
ffff80000010a421:	e9 02 f5 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a426 <vector54>:
vector54:
  push $0
ffff80000010a426:	6a 00                	pushq  $0x0
  push $54
ffff80000010a428:	6a 36                	pushq  $0x36
  jmp alltraps
ffff80000010a42a:	e9 f9 f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a42f <vector55>:
vector55:
  push $0
ffff80000010a42f:	6a 00                	pushq  $0x0
  push $55
ffff80000010a431:	6a 37                	pushq  $0x37
  jmp alltraps
ffff80000010a433:	e9 f0 f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a438 <vector56>:
vector56:
  push $0
ffff80000010a438:	6a 00                	pushq  $0x0
  push $56
ffff80000010a43a:	6a 38                	pushq  $0x38
  jmp alltraps
ffff80000010a43c:	e9 e7 f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a441 <vector57>:
vector57:
  push $0
ffff80000010a441:	6a 00                	pushq  $0x0
  push $57
ffff80000010a443:	6a 39                	pushq  $0x39
  jmp alltraps
ffff80000010a445:	e9 de f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a44a <vector58>:
vector58:
  push $0
ffff80000010a44a:	6a 00                	pushq  $0x0
  push $58
ffff80000010a44c:	6a 3a                	pushq  $0x3a
  jmp alltraps
ffff80000010a44e:	e9 d5 f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a453 <vector59>:
vector59:
  push $0
ffff80000010a453:	6a 00                	pushq  $0x0
  push $59
ffff80000010a455:	6a 3b                	pushq  $0x3b
  jmp alltraps
ffff80000010a457:	e9 cc f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a45c <vector60>:
vector60:
  push $0
ffff80000010a45c:	6a 00                	pushq  $0x0
  push $60
ffff80000010a45e:	6a 3c                	pushq  $0x3c
  jmp alltraps
ffff80000010a460:	e9 c3 f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a465 <vector61>:
vector61:
  push $0
ffff80000010a465:	6a 00                	pushq  $0x0
  push $61
ffff80000010a467:	6a 3d                	pushq  $0x3d
  jmp alltraps
ffff80000010a469:	e9 ba f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a46e <vector62>:
vector62:
  push $0
ffff80000010a46e:	6a 00                	pushq  $0x0
  push $62
ffff80000010a470:	6a 3e                	pushq  $0x3e
  jmp alltraps
ffff80000010a472:	e9 b1 f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a477 <vector63>:
vector63:
  push $0
ffff80000010a477:	6a 00                	pushq  $0x0
  push $63
ffff80000010a479:	6a 3f                	pushq  $0x3f
  jmp alltraps
ffff80000010a47b:	e9 a8 f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a480 <vector64>:
vector64:
  push $0
ffff80000010a480:	6a 00                	pushq  $0x0
  push $64
ffff80000010a482:	6a 40                	pushq  $0x40
  jmp alltraps
ffff80000010a484:	e9 9f f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a489 <vector65>:
vector65:
  push $0
ffff80000010a489:	6a 00                	pushq  $0x0
  push $65
ffff80000010a48b:	6a 41                	pushq  $0x41
  jmp alltraps
ffff80000010a48d:	e9 96 f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a492 <vector66>:
vector66:
  push $0
ffff80000010a492:	6a 00                	pushq  $0x0
  push $66
ffff80000010a494:	6a 42                	pushq  $0x42
  jmp alltraps
ffff80000010a496:	e9 8d f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a49b <vector67>:
vector67:
  push $0
ffff80000010a49b:	6a 00                	pushq  $0x0
  push $67
ffff80000010a49d:	6a 43                	pushq  $0x43
  jmp alltraps
ffff80000010a49f:	e9 84 f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a4a4 <vector68>:
vector68:
  push $0
ffff80000010a4a4:	6a 00                	pushq  $0x0
  push $68
ffff80000010a4a6:	6a 44                	pushq  $0x44
  jmp alltraps
ffff80000010a4a8:	e9 7b f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a4ad <vector69>:
vector69:
  push $0
ffff80000010a4ad:	6a 00                	pushq  $0x0
  push $69
ffff80000010a4af:	6a 45                	pushq  $0x45
  jmp alltraps
ffff80000010a4b1:	e9 72 f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a4b6 <vector70>:
vector70:
  push $0
ffff80000010a4b6:	6a 00                	pushq  $0x0
  push $70
ffff80000010a4b8:	6a 46                	pushq  $0x46
  jmp alltraps
ffff80000010a4ba:	e9 69 f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a4bf <vector71>:
vector71:
  push $0
ffff80000010a4bf:	6a 00                	pushq  $0x0
  push $71
ffff80000010a4c1:	6a 47                	pushq  $0x47
  jmp alltraps
ffff80000010a4c3:	e9 60 f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a4c8 <vector72>:
vector72:
  push $0
ffff80000010a4c8:	6a 00                	pushq  $0x0
  push $72
ffff80000010a4ca:	6a 48                	pushq  $0x48
  jmp alltraps
ffff80000010a4cc:	e9 57 f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a4d1 <vector73>:
vector73:
  push $0
ffff80000010a4d1:	6a 00                	pushq  $0x0
  push $73
ffff80000010a4d3:	6a 49                	pushq  $0x49
  jmp alltraps
ffff80000010a4d5:	e9 4e f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a4da <vector74>:
vector74:
  push $0
ffff80000010a4da:	6a 00                	pushq  $0x0
  push $74
ffff80000010a4dc:	6a 4a                	pushq  $0x4a
  jmp alltraps
ffff80000010a4de:	e9 45 f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a4e3 <vector75>:
vector75:
  push $0
ffff80000010a4e3:	6a 00                	pushq  $0x0
  push $75
ffff80000010a4e5:	6a 4b                	pushq  $0x4b
  jmp alltraps
ffff80000010a4e7:	e9 3c f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a4ec <vector76>:
vector76:
  push $0
ffff80000010a4ec:	6a 00                	pushq  $0x0
  push $76
ffff80000010a4ee:	6a 4c                	pushq  $0x4c
  jmp alltraps
ffff80000010a4f0:	e9 33 f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a4f5 <vector77>:
vector77:
  push $0
ffff80000010a4f5:	6a 00                	pushq  $0x0
  push $77
ffff80000010a4f7:	6a 4d                	pushq  $0x4d
  jmp alltraps
ffff80000010a4f9:	e9 2a f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a4fe <vector78>:
vector78:
  push $0
ffff80000010a4fe:	6a 00                	pushq  $0x0
  push $78
ffff80000010a500:	6a 4e                	pushq  $0x4e
  jmp alltraps
ffff80000010a502:	e9 21 f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a507 <vector79>:
vector79:
  push $0
ffff80000010a507:	6a 00                	pushq  $0x0
  push $79
ffff80000010a509:	6a 4f                	pushq  $0x4f
  jmp alltraps
ffff80000010a50b:	e9 18 f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a510 <vector80>:
vector80:
  push $0
ffff80000010a510:	6a 00                	pushq  $0x0
  push $80
ffff80000010a512:	6a 50                	pushq  $0x50
  jmp alltraps
ffff80000010a514:	e9 0f f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a519 <vector81>:
vector81:
  push $0
ffff80000010a519:	6a 00                	pushq  $0x0
  push $81
ffff80000010a51b:	6a 51                	pushq  $0x51
  jmp alltraps
ffff80000010a51d:	e9 06 f4 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a522 <vector82>:
vector82:
  push $0
ffff80000010a522:	6a 00                	pushq  $0x0
  push $82
ffff80000010a524:	6a 52                	pushq  $0x52
  jmp alltraps
ffff80000010a526:	e9 fd f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a52b <vector83>:
vector83:
  push $0
ffff80000010a52b:	6a 00                	pushq  $0x0
  push $83
ffff80000010a52d:	6a 53                	pushq  $0x53
  jmp alltraps
ffff80000010a52f:	e9 f4 f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a534 <vector84>:
vector84:
  push $0
ffff80000010a534:	6a 00                	pushq  $0x0
  push $84
ffff80000010a536:	6a 54                	pushq  $0x54
  jmp alltraps
ffff80000010a538:	e9 eb f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a53d <vector85>:
vector85:
  push $0
ffff80000010a53d:	6a 00                	pushq  $0x0
  push $85
ffff80000010a53f:	6a 55                	pushq  $0x55
  jmp alltraps
ffff80000010a541:	e9 e2 f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a546 <vector86>:
vector86:
  push $0
ffff80000010a546:	6a 00                	pushq  $0x0
  push $86
ffff80000010a548:	6a 56                	pushq  $0x56
  jmp alltraps
ffff80000010a54a:	e9 d9 f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a54f <vector87>:
vector87:
  push $0
ffff80000010a54f:	6a 00                	pushq  $0x0
  push $87
ffff80000010a551:	6a 57                	pushq  $0x57
  jmp alltraps
ffff80000010a553:	e9 d0 f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a558 <vector88>:
vector88:
  push $0
ffff80000010a558:	6a 00                	pushq  $0x0
  push $88
ffff80000010a55a:	6a 58                	pushq  $0x58
  jmp alltraps
ffff80000010a55c:	e9 c7 f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a561 <vector89>:
vector89:
  push $0
ffff80000010a561:	6a 00                	pushq  $0x0
  push $89
ffff80000010a563:	6a 59                	pushq  $0x59
  jmp alltraps
ffff80000010a565:	e9 be f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a56a <vector90>:
vector90:
  push $0
ffff80000010a56a:	6a 00                	pushq  $0x0
  push $90
ffff80000010a56c:	6a 5a                	pushq  $0x5a
  jmp alltraps
ffff80000010a56e:	e9 b5 f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a573 <vector91>:
vector91:
  push $0
ffff80000010a573:	6a 00                	pushq  $0x0
  push $91
ffff80000010a575:	6a 5b                	pushq  $0x5b
  jmp alltraps
ffff80000010a577:	e9 ac f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a57c <vector92>:
vector92:
  push $0
ffff80000010a57c:	6a 00                	pushq  $0x0
  push $92
ffff80000010a57e:	6a 5c                	pushq  $0x5c
  jmp alltraps
ffff80000010a580:	e9 a3 f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a585 <vector93>:
vector93:
  push $0
ffff80000010a585:	6a 00                	pushq  $0x0
  push $93
ffff80000010a587:	6a 5d                	pushq  $0x5d
  jmp alltraps
ffff80000010a589:	e9 9a f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a58e <vector94>:
vector94:
  push $0
ffff80000010a58e:	6a 00                	pushq  $0x0
  push $94
ffff80000010a590:	6a 5e                	pushq  $0x5e
  jmp alltraps
ffff80000010a592:	e9 91 f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a597 <vector95>:
vector95:
  push $0
ffff80000010a597:	6a 00                	pushq  $0x0
  push $95
ffff80000010a599:	6a 5f                	pushq  $0x5f
  jmp alltraps
ffff80000010a59b:	e9 88 f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a5a0 <vector96>:
vector96:
  push $0
ffff80000010a5a0:	6a 00                	pushq  $0x0
  push $96
ffff80000010a5a2:	6a 60                	pushq  $0x60
  jmp alltraps
ffff80000010a5a4:	e9 7f f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a5a9 <vector97>:
vector97:
  push $0
ffff80000010a5a9:	6a 00                	pushq  $0x0
  push $97
ffff80000010a5ab:	6a 61                	pushq  $0x61
  jmp alltraps
ffff80000010a5ad:	e9 76 f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a5b2 <vector98>:
vector98:
  push $0
ffff80000010a5b2:	6a 00                	pushq  $0x0
  push $98
ffff80000010a5b4:	6a 62                	pushq  $0x62
  jmp alltraps
ffff80000010a5b6:	e9 6d f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a5bb <vector99>:
vector99:
  push $0
ffff80000010a5bb:	6a 00                	pushq  $0x0
  push $99
ffff80000010a5bd:	6a 63                	pushq  $0x63
  jmp alltraps
ffff80000010a5bf:	e9 64 f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a5c4 <vector100>:
vector100:
  push $0
ffff80000010a5c4:	6a 00                	pushq  $0x0
  push $100
ffff80000010a5c6:	6a 64                	pushq  $0x64
  jmp alltraps
ffff80000010a5c8:	e9 5b f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a5cd <vector101>:
vector101:
  push $0
ffff80000010a5cd:	6a 00                	pushq  $0x0
  push $101
ffff80000010a5cf:	6a 65                	pushq  $0x65
  jmp alltraps
ffff80000010a5d1:	e9 52 f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a5d6 <vector102>:
vector102:
  push $0
ffff80000010a5d6:	6a 00                	pushq  $0x0
  push $102
ffff80000010a5d8:	6a 66                	pushq  $0x66
  jmp alltraps
ffff80000010a5da:	e9 49 f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a5df <vector103>:
vector103:
  push $0
ffff80000010a5df:	6a 00                	pushq  $0x0
  push $103
ffff80000010a5e1:	6a 67                	pushq  $0x67
  jmp alltraps
ffff80000010a5e3:	e9 40 f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a5e8 <vector104>:
vector104:
  push $0
ffff80000010a5e8:	6a 00                	pushq  $0x0
  push $104
ffff80000010a5ea:	6a 68                	pushq  $0x68
  jmp alltraps
ffff80000010a5ec:	e9 37 f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a5f1 <vector105>:
vector105:
  push $0
ffff80000010a5f1:	6a 00                	pushq  $0x0
  push $105
ffff80000010a5f3:	6a 69                	pushq  $0x69
  jmp alltraps
ffff80000010a5f5:	e9 2e f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a5fa <vector106>:
vector106:
  push $0
ffff80000010a5fa:	6a 00                	pushq  $0x0
  push $106
ffff80000010a5fc:	6a 6a                	pushq  $0x6a
  jmp alltraps
ffff80000010a5fe:	e9 25 f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a603 <vector107>:
vector107:
  push $0
ffff80000010a603:	6a 00                	pushq  $0x0
  push $107
ffff80000010a605:	6a 6b                	pushq  $0x6b
  jmp alltraps
ffff80000010a607:	e9 1c f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a60c <vector108>:
vector108:
  push $0
ffff80000010a60c:	6a 00                	pushq  $0x0
  push $108
ffff80000010a60e:	6a 6c                	pushq  $0x6c
  jmp alltraps
ffff80000010a610:	e9 13 f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a615 <vector109>:
vector109:
  push $0
ffff80000010a615:	6a 00                	pushq  $0x0
  push $109
ffff80000010a617:	6a 6d                	pushq  $0x6d
  jmp alltraps
ffff80000010a619:	e9 0a f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a61e <vector110>:
vector110:
  push $0
ffff80000010a61e:	6a 00                	pushq  $0x0
  push $110
ffff80000010a620:	6a 6e                	pushq  $0x6e
  jmp alltraps
ffff80000010a622:	e9 01 f3 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a627 <vector111>:
vector111:
  push $0
ffff80000010a627:	6a 00                	pushq  $0x0
  push $111
ffff80000010a629:	6a 6f                	pushq  $0x6f
  jmp alltraps
ffff80000010a62b:	e9 f8 f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a630 <vector112>:
vector112:
  push $0
ffff80000010a630:	6a 00                	pushq  $0x0
  push $112
ffff80000010a632:	6a 70                	pushq  $0x70
  jmp alltraps
ffff80000010a634:	e9 ef f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a639 <vector113>:
vector113:
  push $0
ffff80000010a639:	6a 00                	pushq  $0x0
  push $113
ffff80000010a63b:	6a 71                	pushq  $0x71
  jmp alltraps
ffff80000010a63d:	e9 e6 f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a642 <vector114>:
vector114:
  push $0
ffff80000010a642:	6a 00                	pushq  $0x0
  push $114
ffff80000010a644:	6a 72                	pushq  $0x72
  jmp alltraps
ffff80000010a646:	e9 dd f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a64b <vector115>:
vector115:
  push $0
ffff80000010a64b:	6a 00                	pushq  $0x0
  push $115
ffff80000010a64d:	6a 73                	pushq  $0x73
  jmp alltraps
ffff80000010a64f:	e9 d4 f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a654 <vector116>:
vector116:
  push $0
ffff80000010a654:	6a 00                	pushq  $0x0
  push $116
ffff80000010a656:	6a 74                	pushq  $0x74
  jmp alltraps
ffff80000010a658:	e9 cb f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a65d <vector117>:
vector117:
  push $0
ffff80000010a65d:	6a 00                	pushq  $0x0
  push $117
ffff80000010a65f:	6a 75                	pushq  $0x75
  jmp alltraps
ffff80000010a661:	e9 c2 f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a666 <vector118>:
vector118:
  push $0
ffff80000010a666:	6a 00                	pushq  $0x0
  push $118
ffff80000010a668:	6a 76                	pushq  $0x76
  jmp alltraps
ffff80000010a66a:	e9 b9 f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a66f <vector119>:
vector119:
  push $0
ffff80000010a66f:	6a 00                	pushq  $0x0
  push $119
ffff80000010a671:	6a 77                	pushq  $0x77
  jmp alltraps
ffff80000010a673:	e9 b0 f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a678 <vector120>:
vector120:
  push $0
ffff80000010a678:	6a 00                	pushq  $0x0
  push $120
ffff80000010a67a:	6a 78                	pushq  $0x78
  jmp alltraps
ffff80000010a67c:	e9 a7 f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a681 <vector121>:
vector121:
  push $0
ffff80000010a681:	6a 00                	pushq  $0x0
  push $121
ffff80000010a683:	6a 79                	pushq  $0x79
  jmp alltraps
ffff80000010a685:	e9 9e f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a68a <vector122>:
vector122:
  push $0
ffff80000010a68a:	6a 00                	pushq  $0x0
  push $122
ffff80000010a68c:	6a 7a                	pushq  $0x7a
  jmp alltraps
ffff80000010a68e:	e9 95 f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a693 <vector123>:
vector123:
  push $0
ffff80000010a693:	6a 00                	pushq  $0x0
  push $123
ffff80000010a695:	6a 7b                	pushq  $0x7b
  jmp alltraps
ffff80000010a697:	e9 8c f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a69c <vector124>:
vector124:
  push $0
ffff80000010a69c:	6a 00                	pushq  $0x0
  push $124
ffff80000010a69e:	6a 7c                	pushq  $0x7c
  jmp alltraps
ffff80000010a6a0:	e9 83 f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a6a5 <vector125>:
vector125:
  push $0
ffff80000010a6a5:	6a 00                	pushq  $0x0
  push $125
ffff80000010a6a7:	6a 7d                	pushq  $0x7d
  jmp alltraps
ffff80000010a6a9:	e9 7a f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a6ae <vector126>:
vector126:
  push $0
ffff80000010a6ae:	6a 00                	pushq  $0x0
  push $126
ffff80000010a6b0:	6a 7e                	pushq  $0x7e
  jmp alltraps
ffff80000010a6b2:	e9 71 f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a6b7 <vector127>:
vector127:
  push $0
ffff80000010a6b7:	6a 00                	pushq  $0x0
  push $127
ffff80000010a6b9:	6a 7f                	pushq  $0x7f
  jmp alltraps
ffff80000010a6bb:	e9 68 f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a6c0 <vector128>:
vector128:
  push $0
ffff80000010a6c0:	6a 00                	pushq  $0x0
  push $128
ffff80000010a6c2:	68 80 00 00 00       	pushq  $0x80
  jmp alltraps
ffff80000010a6c7:	e9 5c f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a6cc <vector129>:
vector129:
  push $0
ffff80000010a6cc:	6a 00                	pushq  $0x0
  push $129
ffff80000010a6ce:	68 81 00 00 00       	pushq  $0x81
  jmp alltraps
ffff80000010a6d3:	e9 50 f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a6d8 <vector130>:
vector130:
  push $0
ffff80000010a6d8:	6a 00                	pushq  $0x0
  push $130
ffff80000010a6da:	68 82 00 00 00       	pushq  $0x82
  jmp alltraps
ffff80000010a6df:	e9 44 f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a6e4 <vector131>:
vector131:
  push $0
ffff80000010a6e4:	6a 00                	pushq  $0x0
  push $131
ffff80000010a6e6:	68 83 00 00 00       	pushq  $0x83
  jmp alltraps
ffff80000010a6eb:	e9 38 f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a6f0 <vector132>:
vector132:
  push $0
ffff80000010a6f0:	6a 00                	pushq  $0x0
  push $132
ffff80000010a6f2:	68 84 00 00 00       	pushq  $0x84
  jmp alltraps
ffff80000010a6f7:	e9 2c f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a6fc <vector133>:
vector133:
  push $0
ffff80000010a6fc:	6a 00                	pushq  $0x0
  push $133
ffff80000010a6fe:	68 85 00 00 00       	pushq  $0x85
  jmp alltraps
ffff80000010a703:	e9 20 f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a708 <vector134>:
vector134:
  push $0
ffff80000010a708:	6a 00                	pushq  $0x0
  push $134
ffff80000010a70a:	68 86 00 00 00       	pushq  $0x86
  jmp alltraps
ffff80000010a70f:	e9 14 f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a714 <vector135>:
vector135:
  push $0
ffff80000010a714:	6a 00                	pushq  $0x0
  push $135
ffff80000010a716:	68 87 00 00 00       	pushq  $0x87
  jmp alltraps
ffff80000010a71b:	e9 08 f2 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a720 <vector136>:
vector136:
  push $0
ffff80000010a720:	6a 00                	pushq  $0x0
  push $136
ffff80000010a722:	68 88 00 00 00       	pushq  $0x88
  jmp alltraps
ffff80000010a727:	e9 fc f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a72c <vector137>:
vector137:
  push $0
ffff80000010a72c:	6a 00                	pushq  $0x0
  push $137
ffff80000010a72e:	68 89 00 00 00       	pushq  $0x89
  jmp alltraps
ffff80000010a733:	e9 f0 f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a738 <vector138>:
vector138:
  push $0
ffff80000010a738:	6a 00                	pushq  $0x0
  push $138
ffff80000010a73a:	68 8a 00 00 00       	pushq  $0x8a
  jmp alltraps
ffff80000010a73f:	e9 e4 f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a744 <vector139>:
vector139:
  push $0
ffff80000010a744:	6a 00                	pushq  $0x0
  push $139
ffff80000010a746:	68 8b 00 00 00       	pushq  $0x8b
  jmp alltraps
ffff80000010a74b:	e9 d8 f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a750 <vector140>:
vector140:
  push $0
ffff80000010a750:	6a 00                	pushq  $0x0
  push $140
ffff80000010a752:	68 8c 00 00 00       	pushq  $0x8c
  jmp alltraps
ffff80000010a757:	e9 cc f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a75c <vector141>:
vector141:
  push $0
ffff80000010a75c:	6a 00                	pushq  $0x0
  push $141
ffff80000010a75e:	68 8d 00 00 00       	pushq  $0x8d
  jmp alltraps
ffff80000010a763:	e9 c0 f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a768 <vector142>:
vector142:
  push $0
ffff80000010a768:	6a 00                	pushq  $0x0
  push $142
ffff80000010a76a:	68 8e 00 00 00       	pushq  $0x8e
  jmp alltraps
ffff80000010a76f:	e9 b4 f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a774 <vector143>:
vector143:
  push $0
ffff80000010a774:	6a 00                	pushq  $0x0
  push $143
ffff80000010a776:	68 8f 00 00 00       	pushq  $0x8f
  jmp alltraps
ffff80000010a77b:	e9 a8 f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a780 <vector144>:
vector144:
  push $0
ffff80000010a780:	6a 00                	pushq  $0x0
  push $144
ffff80000010a782:	68 90 00 00 00       	pushq  $0x90
  jmp alltraps
ffff80000010a787:	e9 9c f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a78c <vector145>:
vector145:
  push $0
ffff80000010a78c:	6a 00                	pushq  $0x0
  push $145
ffff80000010a78e:	68 91 00 00 00       	pushq  $0x91
  jmp alltraps
ffff80000010a793:	e9 90 f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a798 <vector146>:
vector146:
  push $0
ffff80000010a798:	6a 00                	pushq  $0x0
  push $146
ffff80000010a79a:	68 92 00 00 00       	pushq  $0x92
  jmp alltraps
ffff80000010a79f:	e9 84 f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a7a4 <vector147>:
vector147:
  push $0
ffff80000010a7a4:	6a 00                	pushq  $0x0
  push $147
ffff80000010a7a6:	68 93 00 00 00       	pushq  $0x93
  jmp alltraps
ffff80000010a7ab:	e9 78 f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a7b0 <vector148>:
vector148:
  push $0
ffff80000010a7b0:	6a 00                	pushq  $0x0
  push $148
ffff80000010a7b2:	68 94 00 00 00       	pushq  $0x94
  jmp alltraps
ffff80000010a7b7:	e9 6c f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a7bc <vector149>:
vector149:
  push $0
ffff80000010a7bc:	6a 00                	pushq  $0x0
  push $149
ffff80000010a7be:	68 95 00 00 00       	pushq  $0x95
  jmp alltraps
ffff80000010a7c3:	e9 60 f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a7c8 <vector150>:
vector150:
  push $0
ffff80000010a7c8:	6a 00                	pushq  $0x0
  push $150
ffff80000010a7ca:	68 96 00 00 00       	pushq  $0x96
  jmp alltraps
ffff80000010a7cf:	e9 54 f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a7d4 <vector151>:
vector151:
  push $0
ffff80000010a7d4:	6a 00                	pushq  $0x0
  push $151
ffff80000010a7d6:	68 97 00 00 00       	pushq  $0x97
  jmp alltraps
ffff80000010a7db:	e9 48 f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a7e0 <vector152>:
vector152:
  push $0
ffff80000010a7e0:	6a 00                	pushq  $0x0
  push $152
ffff80000010a7e2:	68 98 00 00 00       	pushq  $0x98
  jmp alltraps
ffff80000010a7e7:	e9 3c f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a7ec <vector153>:
vector153:
  push $0
ffff80000010a7ec:	6a 00                	pushq  $0x0
  push $153
ffff80000010a7ee:	68 99 00 00 00       	pushq  $0x99
  jmp alltraps
ffff80000010a7f3:	e9 30 f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a7f8 <vector154>:
vector154:
  push $0
ffff80000010a7f8:	6a 00                	pushq  $0x0
  push $154
ffff80000010a7fa:	68 9a 00 00 00       	pushq  $0x9a
  jmp alltraps
ffff80000010a7ff:	e9 24 f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a804 <vector155>:
vector155:
  push $0
ffff80000010a804:	6a 00                	pushq  $0x0
  push $155
ffff80000010a806:	68 9b 00 00 00       	pushq  $0x9b
  jmp alltraps
ffff80000010a80b:	e9 18 f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a810 <vector156>:
vector156:
  push $0
ffff80000010a810:	6a 00                	pushq  $0x0
  push $156
ffff80000010a812:	68 9c 00 00 00       	pushq  $0x9c
  jmp alltraps
ffff80000010a817:	e9 0c f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a81c <vector157>:
vector157:
  push $0
ffff80000010a81c:	6a 00                	pushq  $0x0
  push $157
ffff80000010a81e:	68 9d 00 00 00       	pushq  $0x9d
  jmp alltraps
ffff80000010a823:	e9 00 f1 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a828 <vector158>:
vector158:
  push $0
ffff80000010a828:	6a 00                	pushq  $0x0
  push $158
ffff80000010a82a:	68 9e 00 00 00       	pushq  $0x9e
  jmp alltraps
ffff80000010a82f:	e9 f4 f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a834 <vector159>:
vector159:
  push $0
ffff80000010a834:	6a 00                	pushq  $0x0
  push $159
ffff80000010a836:	68 9f 00 00 00       	pushq  $0x9f
  jmp alltraps
ffff80000010a83b:	e9 e8 f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a840 <vector160>:
vector160:
  push $0
ffff80000010a840:	6a 00                	pushq  $0x0
  push $160
ffff80000010a842:	68 a0 00 00 00       	pushq  $0xa0
  jmp alltraps
ffff80000010a847:	e9 dc f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a84c <vector161>:
vector161:
  push $0
ffff80000010a84c:	6a 00                	pushq  $0x0
  push $161
ffff80000010a84e:	68 a1 00 00 00       	pushq  $0xa1
  jmp alltraps
ffff80000010a853:	e9 d0 f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a858 <vector162>:
vector162:
  push $0
ffff80000010a858:	6a 00                	pushq  $0x0
  push $162
ffff80000010a85a:	68 a2 00 00 00       	pushq  $0xa2
  jmp alltraps
ffff80000010a85f:	e9 c4 f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a864 <vector163>:
vector163:
  push $0
ffff80000010a864:	6a 00                	pushq  $0x0
  push $163
ffff80000010a866:	68 a3 00 00 00       	pushq  $0xa3
  jmp alltraps
ffff80000010a86b:	e9 b8 f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a870 <vector164>:
vector164:
  push $0
ffff80000010a870:	6a 00                	pushq  $0x0
  push $164
ffff80000010a872:	68 a4 00 00 00       	pushq  $0xa4
  jmp alltraps
ffff80000010a877:	e9 ac f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a87c <vector165>:
vector165:
  push $0
ffff80000010a87c:	6a 00                	pushq  $0x0
  push $165
ffff80000010a87e:	68 a5 00 00 00       	pushq  $0xa5
  jmp alltraps
ffff80000010a883:	e9 a0 f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a888 <vector166>:
vector166:
  push $0
ffff80000010a888:	6a 00                	pushq  $0x0
  push $166
ffff80000010a88a:	68 a6 00 00 00       	pushq  $0xa6
  jmp alltraps
ffff80000010a88f:	e9 94 f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a894 <vector167>:
vector167:
  push $0
ffff80000010a894:	6a 00                	pushq  $0x0
  push $167
ffff80000010a896:	68 a7 00 00 00       	pushq  $0xa7
  jmp alltraps
ffff80000010a89b:	e9 88 f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a8a0 <vector168>:
vector168:
  push $0
ffff80000010a8a0:	6a 00                	pushq  $0x0
  push $168
ffff80000010a8a2:	68 a8 00 00 00       	pushq  $0xa8
  jmp alltraps
ffff80000010a8a7:	e9 7c f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a8ac <vector169>:
vector169:
  push $0
ffff80000010a8ac:	6a 00                	pushq  $0x0
  push $169
ffff80000010a8ae:	68 a9 00 00 00       	pushq  $0xa9
  jmp alltraps
ffff80000010a8b3:	e9 70 f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a8b8 <vector170>:
vector170:
  push $0
ffff80000010a8b8:	6a 00                	pushq  $0x0
  push $170
ffff80000010a8ba:	68 aa 00 00 00       	pushq  $0xaa
  jmp alltraps
ffff80000010a8bf:	e9 64 f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a8c4 <vector171>:
vector171:
  push $0
ffff80000010a8c4:	6a 00                	pushq  $0x0
  push $171
ffff80000010a8c6:	68 ab 00 00 00       	pushq  $0xab
  jmp alltraps
ffff80000010a8cb:	e9 58 f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a8d0 <vector172>:
vector172:
  push $0
ffff80000010a8d0:	6a 00                	pushq  $0x0
  push $172
ffff80000010a8d2:	68 ac 00 00 00       	pushq  $0xac
  jmp alltraps
ffff80000010a8d7:	e9 4c f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a8dc <vector173>:
vector173:
  push $0
ffff80000010a8dc:	6a 00                	pushq  $0x0
  push $173
ffff80000010a8de:	68 ad 00 00 00       	pushq  $0xad
  jmp alltraps
ffff80000010a8e3:	e9 40 f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a8e8 <vector174>:
vector174:
  push $0
ffff80000010a8e8:	6a 00                	pushq  $0x0
  push $174
ffff80000010a8ea:	68 ae 00 00 00       	pushq  $0xae
  jmp alltraps
ffff80000010a8ef:	e9 34 f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a8f4 <vector175>:
vector175:
  push $0
ffff80000010a8f4:	6a 00                	pushq  $0x0
  push $175
ffff80000010a8f6:	68 af 00 00 00       	pushq  $0xaf
  jmp alltraps
ffff80000010a8fb:	e9 28 f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a900 <vector176>:
vector176:
  push $0
ffff80000010a900:	6a 00                	pushq  $0x0
  push $176
ffff80000010a902:	68 b0 00 00 00       	pushq  $0xb0
  jmp alltraps
ffff80000010a907:	e9 1c f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a90c <vector177>:
vector177:
  push $0
ffff80000010a90c:	6a 00                	pushq  $0x0
  push $177
ffff80000010a90e:	68 b1 00 00 00       	pushq  $0xb1
  jmp alltraps
ffff80000010a913:	e9 10 f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a918 <vector178>:
vector178:
  push $0
ffff80000010a918:	6a 00                	pushq  $0x0
  push $178
ffff80000010a91a:	68 b2 00 00 00       	pushq  $0xb2
  jmp alltraps
ffff80000010a91f:	e9 04 f0 ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a924 <vector179>:
vector179:
  push $0
ffff80000010a924:	6a 00                	pushq  $0x0
  push $179
ffff80000010a926:	68 b3 00 00 00       	pushq  $0xb3
  jmp alltraps
ffff80000010a92b:	e9 f8 ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a930 <vector180>:
vector180:
  push $0
ffff80000010a930:	6a 00                	pushq  $0x0
  push $180
ffff80000010a932:	68 b4 00 00 00       	pushq  $0xb4
  jmp alltraps
ffff80000010a937:	e9 ec ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a93c <vector181>:
vector181:
  push $0
ffff80000010a93c:	6a 00                	pushq  $0x0
  push $181
ffff80000010a93e:	68 b5 00 00 00       	pushq  $0xb5
  jmp alltraps
ffff80000010a943:	e9 e0 ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a948 <vector182>:
vector182:
  push $0
ffff80000010a948:	6a 00                	pushq  $0x0
  push $182
ffff80000010a94a:	68 b6 00 00 00       	pushq  $0xb6
  jmp alltraps
ffff80000010a94f:	e9 d4 ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a954 <vector183>:
vector183:
  push $0
ffff80000010a954:	6a 00                	pushq  $0x0
  push $183
ffff80000010a956:	68 b7 00 00 00       	pushq  $0xb7
  jmp alltraps
ffff80000010a95b:	e9 c8 ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a960 <vector184>:
vector184:
  push $0
ffff80000010a960:	6a 00                	pushq  $0x0
  push $184
ffff80000010a962:	68 b8 00 00 00       	pushq  $0xb8
  jmp alltraps
ffff80000010a967:	e9 bc ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a96c <vector185>:
vector185:
  push $0
ffff80000010a96c:	6a 00                	pushq  $0x0
  push $185
ffff80000010a96e:	68 b9 00 00 00       	pushq  $0xb9
  jmp alltraps
ffff80000010a973:	e9 b0 ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a978 <vector186>:
vector186:
  push $0
ffff80000010a978:	6a 00                	pushq  $0x0
  push $186
ffff80000010a97a:	68 ba 00 00 00       	pushq  $0xba
  jmp alltraps
ffff80000010a97f:	e9 a4 ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a984 <vector187>:
vector187:
  push $0
ffff80000010a984:	6a 00                	pushq  $0x0
  push $187
ffff80000010a986:	68 bb 00 00 00       	pushq  $0xbb
  jmp alltraps
ffff80000010a98b:	e9 98 ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a990 <vector188>:
vector188:
  push $0
ffff80000010a990:	6a 00                	pushq  $0x0
  push $188
ffff80000010a992:	68 bc 00 00 00       	pushq  $0xbc
  jmp alltraps
ffff80000010a997:	e9 8c ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a99c <vector189>:
vector189:
  push $0
ffff80000010a99c:	6a 00                	pushq  $0x0
  push $189
ffff80000010a99e:	68 bd 00 00 00       	pushq  $0xbd
  jmp alltraps
ffff80000010a9a3:	e9 80 ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a9a8 <vector190>:
vector190:
  push $0
ffff80000010a9a8:	6a 00                	pushq  $0x0
  push $190
ffff80000010a9aa:	68 be 00 00 00       	pushq  $0xbe
  jmp alltraps
ffff80000010a9af:	e9 74 ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a9b4 <vector191>:
vector191:
  push $0
ffff80000010a9b4:	6a 00                	pushq  $0x0
  push $191
ffff80000010a9b6:	68 bf 00 00 00       	pushq  $0xbf
  jmp alltraps
ffff80000010a9bb:	e9 68 ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a9c0 <vector192>:
vector192:
  push $0
ffff80000010a9c0:	6a 00                	pushq  $0x0
  push $192
ffff80000010a9c2:	68 c0 00 00 00       	pushq  $0xc0
  jmp alltraps
ffff80000010a9c7:	e9 5c ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a9cc <vector193>:
vector193:
  push $0
ffff80000010a9cc:	6a 00                	pushq  $0x0
  push $193
ffff80000010a9ce:	68 c1 00 00 00       	pushq  $0xc1
  jmp alltraps
ffff80000010a9d3:	e9 50 ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a9d8 <vector194>:
vector194:
  push $0
ffff80000010a9d8:	6a 00                	pushq  $0x0
  push $194
ffff80000010a9da:	68 c2 00 00 00       	pushq  $0xc2
  jmp alltraps
ffff80000010a9df:	e9 44 ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a9e4 <vector195>:
vector195:
  push $0
ffff80000010a9e4:	6a 00                	pushq  $0x0
  push $195
ffff80000010a9e6:	68 c3 00 00 00       	pushq  $0xc3
  jmp alltraps
ffff80000010a9eb:	e9 38 ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a9f0 <vector196>:
vector196:
  push $0
ffff80000010a9f0:	6a 00                	pushq  $0x0
  push $196
ffff80000010a9f2:	68 c4 00 00 00       	pushq  $0xc4
  jmp alltraps
ffff80000010a9f7:	e9 2c ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010a9fc <vector197>:
vector197:
  push $0
ffff80000010a9fc:	6a 00                	pushq  $0x0
  push $197
ffff80000010a9fe:	68 c5 00 00 00       	pushq  $0xc5
  jmp alltraps
ffff80000010aa03:	e9 20 ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aa08 <vector198>:
vector198:
  push $0
ffff80000010aa08:	6a 00                	pushq  $0x0
  push $198
ffff80000010aa0a:	68 c6 00 00 00       	pushq  $0xc6
  jmp alltraps
ffff80000010aa0f:	e9 14 ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aa14 <vector199>:
vector199:
  push $0
ffff80000010aa14:	6a 00                	pushq  $0x0
  push $199
ffff80000010aa16:	68 c7 00 00 00       	pushq  $0xc7
  jmp alltraps
ffff80000010aa1b:	e9 08 ef ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aa20 <vector200>:
vector200:
  push $0
ffff80000010aa20:	6a 00                	pushq  $0x0
  push $200
ffff80000010aa22:	68 c8 00 00 00       	pushq  $0xc8
  jmp alltraps
ffff80000010aa27:	e9 fc ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aa2c <vector201>:
vector201:
  push $0
ffff80000010aa2c:	6a 00                	pushq  $0x0
  push $201
ffff80000010aa2e:	68 c9 00 00 00       	pushq  $0xc9
  jmp alltraps
ffff80000010aa33:	e9 f0 ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aa38 <vector202>:
vector202:
  push $0
ffff80000010aa38:	6a 00                	pushq  $0x0
  push $202
ffff80000010aa3a:	68 ca 00 00 00       	pushq  $0xca
  jmp alltraps
ffff80000010aa3f:	e9 e4 ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aa44 <vector203>:
vector203:
  push $0
ffff80000010aa44:	6a 00                	pushq  $0x0
  push $203
ffff80000010aa46:	68 cb 00 00 00       	pushq  $0xcb
  jmp alltraps
ffff80000010aa4b:	e9 d8 ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aa50 <vector204>:
vector204:
  push $0
ffff80000010aa50:	6a 00                	pushq  $0x0
  push $204
ffff80000010aa52:	68 cc 00 00 00       	pushq  $0xcc
  jmp alltraps
ffff80000010aa57:	e9 cc ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aa5c <vector205>:
vector205:
  push $0
ffff80000010aa5c:	6a 00                	pushq  $0x0
  push $205
ffff80000010aa5e:	68 cd 00 00 00       	pushq  $0xcd
  jmp alltraps
ffff80000010aa63:	e9 c0 ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aa68 <vector206>:
vector206:
  push $0
ffff80000010aa68:	6a 00                	pushq  $0x0
  push $206
ffff80000010aa6a:	68 ce 00 00 00       	pushq  $0xce
  jmp alltraps
ffff80000010aa6f:	e9 b4 ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aa74 <vector207>:
vector207:
  push $0
ffff80000010aa74:	6a 00                	pushq  $0x0
  push $207
ffff80000010aa76:	68 cf 00 00 00       	pushq  $0xcf
  jmp alltraps
ffff80000010aa7b:	e9 a8 ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aa80 <vector208>:
vector208:
  push $0
ffff80000010aa80:	6a 00                	pushq  $0x0
  push $208
ffff80000010aa82:	68 d0 00 00 00       	pushq  $0xd0
  jmp alltraps
ffff80000010aa87:	e9 9c ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aa8c <vector209>:
vector209:
  push $0
ffff80000010aa8c:	6a 00                	pushq  $0x0
  push $209
ffff80000010aa8e:	68 d1 00 00 00       	pushq  $0xd1
  jmp alltraps
ffff80000010aa93:	e9 90 ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aa98 <vector210>:
vector210:
  push $0
ffff80000010aa98:	6a 00                	pushq  $0x0
  push $210
ffff80000010aa9a:	68 d2 00 00 00       	pushq  $0xd2
  jmp alltraps
ffff80000010aa9f:	e9 84 ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aaa4 <vector211>:
vector211:
  push $0
ffff80000010aaa4:	6a 00                	pushq  $0x0
  push $211
ffff80000010aaa6:	68 d3 00 00 00       	pushq  $0xd3
  jmp alltraps
ffff80000010aaab:	e9 78 ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aab0 <vector212>:
vector212:
  push $0
ffff80000010aab0:	6a 00                	pushq  $0x0
  push $212
ffff80000010aab2:	68 d4 00 00 00       	pushq  $0xd4
  jmp alltraps
ffff80000010aab7:	e9 6c ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aabc <vector213>:
vector213:
  push $0
ffff80000010aabc:	6a 00                	pushq  $0x0
  push $213
ffff80000010aabe:	68 d5 00 00 00       	pushq  $0xd5
  jmp alltraps
ffff80000010aac3:	e9 60 ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aac8 <vector214>:
vector214:
  push $0
ffff80000010aac8:	6a 00                	pushq  $0x0
  push $214
ffff80000010aaca:	68 d6 00 00 00       	pushq  $0xd6
  jmp alltraps
ffff80000010aacf:	e9 54 ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aad4 <vector215>:
vector215:
  push $0
ffff80000010aad4:	6a 00                	pushq  $0x0
  push $215
ffff80000010aad6:	68 d7 00 00 00       	pushq  $0xd7
  jmp alltraps
ffff80000010aadb:	e9 48 ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aae0 <vector216>:
vector216:
  push $0
ffff80000010aae0:	6a 00                	pushq  $0x0
  push $216
ffff80000010aae2:	68 d8 00 00 00       	pushq  $0xd8
  jmp alltraps
ffff80000010aae7:	e9 3c ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aaec <vector217>:
vector217:
  push $0
ffff80000010aaec:	6a 00                	pushq  $0x0
  push $217
ffff80000010aaee:	68 d9 00 00 00       	pushq  $0xd9
  jmp alltraps
ffff80000010aaf3:	e9 30 ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aaf8 <vector218>:
vector218:
  push $0
ffff80000010aaf8:	6a 00                	pushq  $0x0
  push $218
ffff80000010aafa:	68 da 00 00 00       	pushq  $0xda
  jmp alltraps
ffff80000010aaff:	e9 24 ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ab04 <vector219>:
vector219:
  push $0
ffff80000010ab04:	6a 00                	pushq  $0x0
  push $219
ffff80000010ab06:	68 db 00 00 00       	pushq  $0xdb
  jmp alltraps
ffff80000010ab0b:	e9 18 ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ab10 <vector220>:
vector220:
  push $0
ffff80000010ab10:	6a 00                	pushq  $0x0
  push $220
ffff80000010ab12:	68 dc 00 00 00       	pushq  $0xdc
  jmp alltraps
ffff80000010ab17:	e9 0c ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ab1c <vector221>:
vector221:
  push $0
ffff80000010ab1c:	6a 00                	pushq  $0x0
  push $221
ffff80000010ab1e:	68 dd 00 00 00       	pushq  $0xdd
  jmp alltraps
ffff80000010ab23:	e9 00 ee ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ab28 <vector222>:
vector222:
  push $0
ffff80000010ab28:	6a 00                	pushq  $0x0
  push $222
ffff80000010ab2a:	68 de 00 00 00       	pushq  $0xde
  jmp alltraps
ffff80000010ab2f:	e9 f4 ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ab34 <vector223>:
vector223:
  push $0
ffff80000010ab34:	6a 00                	pushq  $0x0
  push $223
ffff80000010ab36:	68 df 00 00 00       	pushq  $0xdf
  jmp alltraps
ffff80000010ab3b:	e9 e8 ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ab40 <vector224>:
vector224:
  push $0
ffff80000010ab40:	6a 00                	pushq  $0x0
  push $224
ffff80000010ab42:	68 e0 00 00 00       	pushq  $0xe0
  jmp alltraps
ffff80000010ab47:	e9 dc ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ab4c <vector225>:
vector225:
  push $0
ffff80000010ab4c:	6a 00                	pushq  $0x0
  push $225
ffff80000010ab4e:	68 e1 00 00 00       	pushq  $0xe1
  jmp alltraps
ffff80000010ab53:	e9 d0 ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ab58 <vector226>:
vector226:
  push $0
ffff80000010ab58:	6a 00                	pushq  $0x0
  push $226
ffff80000010ab5a:	68 e2 00 00 00       	pushq  $0xe2
  jmp alltraps
ffff80000010ab5f:	e9 c4 ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ab64 <vector227>:
vector227:
  push $0
ffff80000010ab64:	6a 00                	pushq  $0x0
  push $227
ffff80000010ab66:	68 e3 00 00 00       	pushq  $0xe3
  jmp alltraps
ffff80000010ab6b:	e9 b8 ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ab70 <vector228>:
vector228:
  push $0
ffff80000010ab70:	6a 00                	pushq  $0x0
  push $228
ffff80000010ab72:	68 e4 00 00 00       	pushq  $0xe4
  jmp alltraps
ffff80000010ab77:	e9 ac ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ab7c <vector229>:
vector229:
  push $0
ffff80000010ab7c:	6a 00                	pushq  $0x0
  push $229
ffff80000010ab7e:	68 e5 00 00 00       	pushq  $0xe5
  jmp alltraps
ffff80000010ab83:	e9 a0 ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ab88 <vector230>:
vector230:
  push $0
ffff80000010ab88:	6a 00                	pushq  $0x0
  push $230
ffff80000010ab8a:	68 e6 00 00 00       	pushq  $0xe6
  jmp alltraps
ffff80000010ab8f:	e9 94 ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ab94 <vector231>:
vector231:
  push $0
ffff80000010ab94:	6a 00                	pushq  $0x0
  push $231
ffff80000010ab96:	68 e7 00 00 00       	pushq  $0xe7
  jmp alltraps
ffff80000010ab9b:	e9 88 ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aba0 <vector232>:
vector232:
  push $0
ffff80000010aba0:	6a 00                	pushq  $0x0
  push $232
ffff80000010aba2:	68 e8 00 00 00       	pushq  $0xe8
  jmp alltraps
ffff80000010aba7:	e9 7c ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010abac <vector233>:
vector233:
  push $0
ffff80000010abac:	6a 00                	pushq  $0x0
  push $233
ffff80000010abae:	68 e9 00 00 00       	pushq  $0xe9
  jmp alltraps
ffff80000010abb3:	e9 70 ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010abb8 <vector234>:
vector234:
  push $0
ffff80000010abb8:	6a 00                	pushq  $0x0
  push $234
ffff80000010abba:	68 ea 00 00 00       	pushq  $0xea
  jmp alltraps
ffff80000010abbf:	e9 64 ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010abc4 <vector235>:
vector235:
  push $0
ffff80000010abc4:	6a 00                	pushq  $0x0
  push $235
ffff80000010abc6:	68 eb 00 00 00       	pushq  $0xeb
  jmp alltraps
ffff80000010abcb:	e9 58 ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010abd0 <vector236>:
vector236:
  push $0
ffff80000010abd0:	6a 00                	pushq  $0x0
  push $236
ffff80000010abd2:	68 ec 00 00 00       	pushq  $0xec
  jmp alltraps
ffff80000010abd7:	e9 4c ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010abdc <vector237>:
vector237:
  push $0
ffff80000010abdc:	6a 00                	pushq  $0x0
  push $237
ffff80000010abde:	68 ed 00 00 00       	pushq  $0xed
  jmp alltraps
ffff80000010abe3:	e9 40 ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010abe8 <vector238>:
vector238:
  push $0
ffff80000010abe8:	6a 00                	pushq  $0x0
  push $238
ffff80000010abea:	68 ee 00 00 00       	pushq  $0xee
  jmp alltraps
ffff80000010abef:	e9 34 ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010abf4 <vector239>:
vector239:
  push $0
ffff80000010abf4:	6a 00                	pushq  $0x0
  push $239
ffff80000010abf6:	68 ef 00 00 00       	pushq  $0xef
  jmp alltraps
ffff80000010abfb:	e9 28 ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ac00 <vector240>:
vector240:
  push $0
ffff80000010ac00:	6a 00                	pushq  $0x0
  push $240
ffff80000010ac02:	68 f0 00 00 00       	pushq  $0xf0
  jmp alltraps
ffff80000010ac07:	e9 1c ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ac0c <vector241>:
vector241:
  push $0
ffff80000010ac0c:	6a 00                	pushq  $0x0
  push $241
ffff80000010ac0e:	68 f1 00 00 00       	pushq  $0xf1
  jmp alltraps
ffff80000010ac13:	e9 10 ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ac18 <vector242>:
vector242:
  push $0
ffff80000010ac18:	6a 00                	pushq  $0x0
  push $242
ffff80000010ac1a:	68 f2 00 00 00       	pushq  $0xf2
  jmp alltraps
ffff80000010ac1f:	e9 04 ed ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ac24 <vector243>:
vector243:
  push $0
ffff80000010ac24:	6a 00                	pushq  $0x0
  push $243
ffff80000010ac26:	68 f3 00 00 00       	pushq  $0xf3
  jmp alltraps
ffff80000010ac2b:	e9 f8 ec ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ac30 <vector244>:
vector244:
  push $0
ffff80000010ac30:	6a 00                	pushq  $0x0
  push $244
ffff80000010ac32:	68 f4 00 00 00       	pushq  $0xf4
  jmp alltraps
ffff80000010ac37:	e9 ec ec ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ac3c <vector245>:
vector245:
  push $0
ffff80000010ac3c:	6a 00                	pushq  $0x0
  push $245
ffff80000010ac3e:	68 f5 00 00 00       	pushq  $0xf5
  jmp alltraps
ffff80000010ac43:	e9 e0 ec ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ac48 <vector246>:
vector246:
  push $0
ffff80000010ac48:	6a 00                	pushq  $0x0
  push $246
ffff80000010ac4a:	68 f6 00 00 00       	pushq  $0xf6
  jmp alltraps
ffff80000010ac4f:	e9 d4 ec ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ac54 <vector247>:
vector247:
  push $0
ffff80000010ac54:	6a 00                	pushq  $0x0
  push $247
ffff80000010ac56:	68 f7 00 00 00       	pushq  $0xf7
  jmp alltraps
ffff80000010ac5b:	e9 c8 ec ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ac60 <vector248>:
vector248:
  push $0
ffff80000010ac60:	6a 00                	pushq  $0x0
  push $248
ffff80000010ac62:	68 f8 00 00 00       	pushq  $0xf8
  jmp alltraps
ffff80000010ac67:	e9 bc ec ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ac6c <vector249>:
vector249:
  push $0
ffff80000010ac6c:	6a 00                	pushq  $0x0
  push $249
ffff80000010ac6e:	68 f9 00 00 00       	pushq  $0xf9
  jmp alltraps
ffff80000010ac73:	e9 b0 ec ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ac78 <vector250>:
vector250:
  push $0
ffff80000010ac78:	6a 00                	pushq  $0x0
  push $250
ffff80000010ac7a:	68 fa 00 00 00       	pushq  $0xfa
  jmp alltraps
ffff80000010ac7f:	e9 a4 ec ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ac84 <vector251>:
vector251:
  push $0
ffff80000010ac84:	6a 00                	pushq  $0x0
  push $251
ffff80000010ac86:	68 fb 00 00 00       	pushq  $0xfb
  jmp alltraps
ffff80000010ac8b:	e9 98 ec ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ac90 <vector252>:
vector252:
  push $0
ffff80000010ac90:	6a 00                	pushq  $0x0
  push $252
ffff80000010ac92:	68 fc 00 00 00       	pushq  $0xfc
  jmp alltraps
ffff80000010ac97:	e9 8c ec ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010ac9c <vector253>:
vector253:
  push $0
ffff80000010ac9c:	6a 00                	pushq  $0x0
  push $253
ffff80000010ac9e:	68 fd 00 00 00       	pushq  $0xfd
  jmp alltraps
ffff80000010aca3:	e9 80 ec ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010aca8 <vector254>:
vector254:
  push $0
ffff80000010aca8:	6a 00                	pushq  $0x0
  push $254
ffff80000010acaa:	68 fe 00 00 00       	pushq  $0xfe
  jmp alltraps
ffff80000010acaf:	e9 74 ec ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010acb4 <vector255>:
vector255:
  push $0
ffff80000010acb4:	6a 00                	pushq  $0x0
  push $255
ffff80000010acb6:	68 ff 00 00 00       	pushq  $0xff
  jmp alltraps
ffff80000010acbb:	e9 68 ec ff ff       	jmpq   ffff800000109928 <alltraps>

ffff80000010acc0 <lgdt>:
{
ffff80000010acc0:	f3 0f 1e fa          	endbr64 
ffff80000010acc4:	55                   	push   %rbp
ffff80000010acc5:	48 89 e5             	mov    %rsp,%rbp
ffff80000010acc8:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010accc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010acd0:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  addr_t addr = (addr_t)p;
ffff80000010acd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010acd7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  pd[0] = size-1;
ffff80000010acdb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff80000010acde:	83 e8 01             	sub    $0x1,%eax
ffff80000010ace1:	66 89 45 ee          	mov    %ax,-0x12(%rbp)
  pd[1] = addr;
ffff80000010ace5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010ace9:	66 89 45 f0          	mov    %ax,-0x10(%rbp)
  pd[2] = addr >> 16;
ffff80000010aced:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010acf1:	48 c1 e8 10          	shr    $0x10,%rax
ffff80000010acf5:	66 89 45 f2          	mov    %ax,-0xe(%rbp)
  pd[3] = addr >> 32;
ffff80000010acf9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010acfd:	48 c1 e8 20          	shr    $0x20,%rax
ffff80000010ad01:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
  pd[4] = addr >> 48;
ffff80000010ad05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010ad09:	48 c1 e8 30          	shr    $0x30,%rax
ffff80000010ad0d:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
  asm volatile("lgdt (%0)" : : "r" (pd));
ffff80000010ad11:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
ffff80000010ad15:	0f 01 10             	lgdt   (%rax)
}
ffff80000010ad18:	90                   	nop
ffff80000010ad19:	c9                   	leaveq 
ffff80000010ad1a:	c3                   	retq   

ffff80000010ad1b <ltr>:
{
ffff80000010ad1b:	f3 0f 1e fa          	endbr64 
ffff80000010ad1f:	55                   	push   %rbp
ffff80000010ad20:	48 89 e5             	mov    %rsp,%rbp
ffff80000010ad23:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010ad27:	89 f8                	mov    %edi,%eax
ffff80000010ad29:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  asm volatile("ltr %0" : : "r" (sel));
ffff80000010ad2d:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
ffff80000010ad31:	0f 00 d8             	ltr    %ax
}
ffff80000010ad34:	90                   	nop
ffff80000010ad35:	c9                   	leaveq 
ffff80000010ad36:	c3                   	retq   

ffff80000010ad37 <lcr3>:

static inline void
lcr3(addr_t val)
{
ffff80000010ad37:	f3 0f 1e fa          	endbr64 
ffff80000010ad3b:	55                   	push   %rbp
ffff80000010ad3c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010ad3f:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010ad43:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  asm volatile("mov %0,%%cr3" : : "r" (val));
ffff80000010ad47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010ad4b:	0f 22 d8             	mov    %rax,%cr3
}
ffff80000010ad4e:	90                   	nop
ffff80000010ad4f:	c9                   	leaveq 
ffff80000010ad50:	c3                   	retq   

ffff80000010ad51 <v2p>:
static inline addr_t v2p(void *a) {
ffff80000010ad51:	f3 0f 1e fa          	endbr64 
ffff80000010ad55:	55                   	push   %rbp
ffff80000010ad56:	48 89 e5             	mov    %rsp,%rbp
ffff80000010ad59:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010ad5d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  return ((addr_t) (a)) - ((addr_t)KERNBASE);
ffff80000010ad61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010ad65:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010ad6c:	80 00 00 
ffff80000010ad6f:	48 01 d0             	add    %rdx,%rax
}
ffff80000010ad72:	c9                   	leaveq 
ffff80000010ad73:	c3                   	retq   

ffff80000010ad74 <syscallinit>:
static pde_t *kpml4;
static pde_t *kpdpt;

void
syscallinit(void)
{
ffff80000010ad74:	f3 0f 1e fa          	endbr64 
ffff80000010ad78:	55                   	push   %rbp
ffff80000010ad79:	48 89 e5             	mov    %rsp,%rbp
  // the MSR/SYSRET wants the segment for 32-bit user data
  // next up is 64-bit user data, then code
  // This is simply the way the sysret instruction
  // is designed to work (it assumes they follow).
  wrmsr(MSR_STAR,
ffff80000010ad7c:	48 be 00 00 00 00 08 	movabs $0x1b000800000000,%rsi
ffff80000010ad83:	00 1b 00 
ffff80000010ad86:	bf 81 00 00 c0       	mov    $0xc0000081,%edi
ffff80000010ad8b:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010ad92:	80 ff ff 
ffff80000010ad95:	ff d0                	callq  *%rax
    ((((uint64)USER32_CS) << 48) | ((uint64)KERNEL_CS << 32)));
  wrmsr(MSR_LSTAR, (addr_t)syscall_entry);
ffff80000010ad97:	48 b8 64 99 10 00 00 	movabs $0xffff800000109964,%rax
ffff80000010ad9e:	80 ff ff 
ffff80000010ada1:	48 89 c6             	mov    %rax,%rsi
ffff80000010ada4:	bf 82 00 00 c0       	mov    $0xc0000082,%edi
ffff80000010ada9:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010adb0:	80 ff ff 
ffff80000010adb3:	ff d0                	callq  *%rax
  wrmsr(MSR_CSTAR, (addr_t)ignore_sysret);
ffff80000010adb5:	48 b8 11 01 10 00 00 	movabs $0xffff800000100111,%rax
ffff80000010adbc:	80 ff ff 
ffff80000010adbf:	48 89 c6             	mov    %rax,%rsi
ffff80000010adc2:	bf 83 00 00 c0       	mov    $0xc0000083,%edi
ffff80000010adc7:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010adce:	80 ff ff 
ffff80000010add1:	ff d0                	callq  *%rax

  wrmsr(MSR_SFMASK, FL_TF|FL_DF|FL_IF|FL_IOPL_3|FL_AC|FL_NT);
ffff80000010add3:	be 00 77 04 00       	mov    $0x47700,%esi
ffff80000010add8:	bf 84 00 00 c0       	mov    $0xc0000084,%edi
ffff80000010addd:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010ade4:	80 ff ff 
ffff80000010ade7:	ff d0                	callq  *%rax
}
ffff80000010ade9:	90                   	nop
ffff80000010adea:	5d                   	pop    %rbp
ffff80000010adeb:	c3                   	retq   

ffff80000010adec <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
ffff80000010adec:	f3 0f 1e fa          	endbr64 
ffff80000010adf0:	55                   	push   %rbp
ffff80000010adf1:	48 89 e5             	mov    %rsp,%rbp
ffff80000010adf4:	48 83 ec 30          	sub    $0x30,%rsp
  uint64 addr;
  void *local;
  struct cpu *c;

  // create a page for cpu local storage
  local = kalloc();
ffff80000010adf8:	48 b8 66 42 10 00 00 	movabs $0xffff800000104266,%rax
ffff80000010adff:	80 ff ff 
ffff80000010ae02:	ff d0                	callq  *%rax
ffff80000010ae04:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(local, 0, PGSIZE);
ffff80000010ae08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010ae0c:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010ae11:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010ae16:	48 89 c7             	mov    %rax,%rdi
ffff80000010ae19:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff80000010ae20:	80 ff ff 
ffff80000010ae23:	ff d0                	callq  *%rax

  gdt = (struct segdesc*) local;
ffff80000010ae25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010ae29:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  tss = (uint*) (((char*) local) + 1024);
ffff80000010ae2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010ae31:	48 05 00 04 00 00    	add    $0x400,%rax
ffff80000010ae37:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  tss[16] = 0x00680000; // IO Map Base = End of TSS
ffff80000010ae3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010ae3f:	48 83 c0 40          	add    $0x40,%rax
ffff80000010ae43:	c7 00 00 00 68 00    	movl   $0x680000,(%rax)

  // point FS smack in the middle of our local storage page
  wrmsr(0xC0000100, ((uint64) local) + 2048);
ffff80000010ae49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010ae4d:	48 05 00 08 00 00    	add    $0x800,%rax
ffff80000010ae53:	48 89 c6             	mov    %rax,%rsi
ffff80000010ae56:	bf 00 01 00 c0       	mov    $0xc0000100,%edi
ffff80000010ae5b:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010ae62:	80 ff ff 
ffff80000010ae65:	ff d0                	callq  *%rax

  c = &cpus[cpunum()];
ffff80000010ae67:	48 b8 59 4a 10 00 00 	movabs $0xffff800000104a59,%rax
ffff80000010ae6e:	80 ff ff 
ffff80000010ae71:	ff d0                	callq  *%rax
ffff80000010ae73:	48 63 d0             	movslq %eax,%rdx
ffff80000010ae76:	48 89 d0             	mov    %rdx,%rax
ffff80000010ae79:	48 c1 e0 02          	shl    $0x2,%rax
ffff80000010ae7d:	48 01 d0             	add    %rdx,%rax
ffff80000010ae80:	48 c1 e0 03          	shl    $0x3,%rax
ffff80000010ae84:	48 ba e0 72 1f 00 00 	movabs $0xffff8000001f72e0,%rdx
ffff80000010ae8b:	80 ff ff 
ffff80000010ae8e:	48 01 d0             	add    %rdx,%rax
ffff80000010ae91:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  c->local = local;
ffff80000010ae95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010ae99:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010ae9d:	48 89 50 20          	mov    %rdx,0x20(%rax)

  cpu = c;
ffff80000010aea1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010aea5:	64 48 89 04 25 f0 ff 	mov    %rax,%fs:0xfffffffffffffff0
ffff80000010aeac:	ff ff 
  proc = 0;
ffff80000010aeae:	64 48 c7 04 25 f8 ff 	movq   $0x0,%fs:0xfffffffffffffff8
ffff80000010aeb5:	ff ff 00 00 00 00 

  addr = (uint64) tss;
ffff80000010aebb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010aebf:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  gdt[0] =  (struct segdesc) {};
ffff80000010aec3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010aec7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

  gdt[SEG_KCODE] = SEG((STA_X|STA_R), 0, 0, APP_SEG, !DPL_USER, 1);
ffff80000010aece:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010aed2:	48 83 c0 08          	add    $0x8,%rax
ffff80000010aed6:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010aedb:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010aee1:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010aee5:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010aee9:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010aeec:	83 ca 0a             	or     $0xa,%edx
ffff80000010aeef:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010aef2:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010aef6:	83 ca 10             	or     $0x10,%edx
ffff80000010aef9:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010aefc:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010af00:	83 e2 9f             	and    $0xffffff9f,%edx
ffff80000010af03:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010af06:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010af0a:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010af0d:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010af10:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010af14:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010af17:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010af1a:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010af1e:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010af21:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010af24:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010af28:	83 ca 20             	or     $0x20,%edx
ffff80000010af2b:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010af2e:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010af32:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010af35:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010af38:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010af3c:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010af3f:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010af42:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_KDATA] = SEG(STA_W, 0, 0, APP_SEG, !DPL_USER, 0);
ffff80000010af46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010af4a:	48 83 c0 10          	add    $0x10,%rax
ffff80000010af4e:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010af53:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010af59:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010af5d:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010af61:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010af64:	83 ca 02             	or     $0x2,%edx
ffff80000010af67:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010af6a:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010af6e:	83 ca 10             	or     $0x10,%edx
ffff80000010af71:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010af74:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010af78:	83 e2 9f             	and    $0xffffff9f,%edx
ffff80000010af7b:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010af7e:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010af82:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010af85:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010af88:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010af8c:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010af8f:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010af92:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010af96:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010af99:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010af9c:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010afa0:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010afa3:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010afa6:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010afaa:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010afad:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010afb0:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010afb4:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010afb7:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010afba:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_UCODE32] = (struct segdesc) {}; // required by syscall/sysret
ffff80000010afbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010afc2:	48 83 c0 18          	add    $0x18,%rax
ffff80000010afc6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  gdt[SEG_UDATA] = SEG(STA_W, 0, 0, APP_SEG, DPL_USER, 0);
ffff80000010afcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010afd1:	48 83 c0 20          	add    $0x20,%rax
ffff80000010afd5:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010afda:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010afe0:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010afe4:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010afe8:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010afeb:	83 ca 02             	or     $0x2,%edx
ffff80000010afee:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010aff1:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010aff5:	83 ca 10             	or     $0x10,%edx
ffff80000010aff8:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010affb:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010afff:	83 ca 60             	or     $0x60,%edx
ffff80000010b002:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b005:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b009:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b00c:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b00f:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b013:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b016:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b019:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b01d:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b020:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b023:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b027:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010b02a:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b02d:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b031:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b034:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b037:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b03b:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b03e:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b041:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_UCODE] = SEG((STA_X|STA_R), 0, 0, APP_SEG, DPL_USER, 1);
ffff80000010b045:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b049:	48 83 c0 28          	add    $0x28,%rax
ffff80000010b04d:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010b052:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010b058:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010b05c:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b060:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b063:	83 ca 0a             	or     $0xa,%edx
ffff80000010b066:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b069:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b06d:	83 ca 10             	or     $0x10,%edx
ffff80000010b070:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b073:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b077:	83 ca 60             	or     $0x60,%edx
ffff80000010b07a:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b07d:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b081:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b084:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b087:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b08b:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b08e:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b091:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b095:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b098:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b09b:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b09f:	83 ca 20             	or     $0x20,%edx
ffff80000010b0a2:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b0a5:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b0a9:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b0ac:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b0af:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b0b3:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b0b6:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b0b9:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_KCPU]  = (struct segdesc) {};
ffff80000010b0bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b0c1:	48 83 c0 30          	add    $0x30,%rax
ffff80000010b0c5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  // TSS: See IA32 SDM Figure 7-4
  gdt[SEG_TSS]   = SEG(STS_T64A, 0xb, addr, !APP_SEG, DPL_USER, 0);
ffff80000010b0cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b0d0:	48 83 c0 38          	add    $0x38,%rax
ffff80000010b0d4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b0d8:	89 d7                	mov    %edx,%edi
ffff80000010b0da:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b0de:	48 c1 ea 10          	shr    $0x10,%rdx
ffff80000010b0e2:	89 d6                	mov    %edx,%esi
ffff80000010b0e4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b0e8:	48 c1 ea 18          	shr    $0x18,%rdx
ffff80000010b0ec:	89 d1                	mov    %edx,%ecx
ffff80000010b0ee:	66 c7 00 0b 00       	movw   $0xb,(%rax)
ffff80000010b0f3:	66 89 78 02          	mov    %di,0x2(%rax)
ffff80000010b0f7:	40 88 70 04          	mov    %sil,0x4(%rax)
ffff80000010b0fb:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b0ff:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b102:	83 ca 09             	or     $0x9,%edx
ffff80000010b105:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b108:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b10c:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b10f:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b112:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b116:	83 ca 60             	or     $0x60,%edx
ffff80000010b119:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b11c:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b120:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b123:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b126:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b12a:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b12d:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b130:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b134:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b137:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b13a:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b13e:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010b141:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b144:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b148:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b14b:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b14e:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b152:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b155:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b158:	88 48 07             	mov    %cl,0x7(%rax)
  gdt[SEG_TSS+1] = SEG(0, addr >> 32, addr >> 48, 0, 0, 0);
ffff80000010b15b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b15f:	48 83 c0 40          	add    $0x40,%rax
ffff80000010b163:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b167:	48 c1 ea 20          	shr    $0x20,%rdx
ffff80000010b16b:	41 89 d1             	mov    %edx,%r9d
ffff80000010b16e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b172:	48 c1 ea 30          	shr    $0x30,%rdx
ffff80000010b176:	41 89 d0             	mov    %edx,%r8d
ffff80000010b179:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b17d:	48 c1 ea 30          	shr    $0x30,%rdx
ffff80000010b181:	48 c1 ea 10          	shr    $0x10,%rdx
ffff80000010b185:	89 d7                	mov    %edx,%edi
ffff80000010b187:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b18b:	48 c1 ea 20          	shr    $0x20,%rdx
ffff80000010b18f:	48 c1 ea 3c          	shr    $0x3c,%rdx
ffff80000010b193:	83 e2 0f             	and    $0xf,%edx
ffff80000010b196:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff80000010b19a:	48 c1 e9 30          	shr    $0x30,%rcx
ffff80000010b19e:	48 c1 e9 18          	shr    $0x18,%rcx
ffff80000010b1a2:	89 ce                	mov    %ecx,%esi
ffff80000010b1a4:	66 44 89 08          	mov    %r9w,(%rax)
ffff80000010b1a8:	66 44 89 40 02       	mov    %r8w,0x2(%rax)
ffff80000010b1ad:	40 88 78 04          	mov    %dil,0x4(%rax)
ffff80000010b1b1:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010b1b5:	83 e1 f0             	and    $0xfffffff0,%ecx
ffff80000010b1b8:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010b1bb:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010b1bf:	83 e1 ef             	and    $0xffffffef,%ecx
ffff80000010b1c2:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010b1c5:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010b1c9:	83 e1 9f             	and    $0xffffff9f,%ecx
ffff80000010b1cc:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010b1cf:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010b1d3:	83 c9 80             	or     $0xffffff80,%ecx
ffff80000010b1d6:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010b1d9:	89 d1                	mov    %edx,%ecx
ffff80000010b1db:	83 e1 0f             	and    $0xf,%ecx
ffff80000010b1de:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b1e2:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b1e5:	09 ca                	or     %ecx,%edx
ffff80000010b1e7:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b1ea:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b1ee:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b1f1:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b1f4:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b1f8:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010b1fb:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b1fe:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b202:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b205:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b208:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b20c:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b20f:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b212:	40 88 70 07          	mov    %sil,0x7(%rax)

  lgdt((void*) gdt, (NSEGS+1) * sizeof(struct segdesc));
ffff80000010b216:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b21a:	be 48 00 00 00       	mov    $0x48,%esi
ffff80000010b21f:	48 89 c7             	mov    %rax,%rdi
ffff80000010b222:	48 b8 c0 ac 10 00 00 	movabs $0xffff80000010acc0,%rax
ffff80000010b229:	80 ff ff 
ffff80000010b22c:	ff d0                	callq  *%rax

  ltr(SEG_TSS << 3);
ffff80000010b22e:	bf 38 00 00 00       	mov    $0x38,%edi
ffff80000010b233:	48 b8 1b ad 10 00 00 	movabs $0xffff80000010ad1b,%rax
ffff80000010b23a:	80 ff ff 
ffff80000010b23d:	ff d0                	callq  *%rax
};
ffff80000010b23f:	90                   	nop
ffff80000010b240:	c9                   	leaveq 
ffff80000010b241:	c3                   	retq   

ffff80000010b242 <setupkvm>:
// (directly addressable from end..P2V(PHYSTOP)).


pde_t*
setupkvm(void)
{
ffff80000010b242:	f3 0f 1e fa          	endbr64 
ffff80000010b246:	55                   	push   %rbp
ffff80000010b247:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b24a:	48 83 ec 10          	sub    $0x10,%rsp
  pde_t *pml4 = (pde_t*) kalloc();
ffff80000010b24e:	48 b8 66 42 10 00 00 	movabs $0xffff800000104266,%rax
ffff80000010b255:	80 ff ff 
ffff80000010b258:	ff d0                	callq  *%rax
ffff80000010b25a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(pml4, 0, PGSIZE);
ffff80000010b25e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b262:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b267:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b26c:	48 89 c7             	mov    %rax,%rdi
ffff80000010b26f:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff80000010b276:	80 ff ff 
ffff80000010b279:	ff d0                	callq  *%rax
  pml4[256] = v2p(kpdpt) | PTE_P | PTE_W;
ffff80000010b27b:	48 b8 60 ad 1f 00 00 	movabs $0xffff8000001fad60,%rax
ffff80000010b282:	80 ff ff 
ffff80000010b285:	48 8b 00             	mov    (%rax),%rax
ffff80000010b288:	48 89 c7             	mov    %rax,%rdi
ffff80000010b28b:	48 b8 51 ad 10 00 00 	movabs $0xffff80000010ad51,%rax
ffff80000010b292:	80 ff ff 
ffff80000010b295:	ff d0                	callq  *%rax
ffff80000010b297:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010b29b:	48 81 c2 00 08 00 00 	add    $0x800,%rdx
ffff80000010b2a2:	48 83 c8 03          	or     $0x3,%rax
ffff80000010b2a6:	48 89 02             	mov    %rax,(%rdx)
  return pml4;
ffff80000010b2a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
};
ffff80000010b2ad:	c9                   	leaveq 
ffff80000010b2ae:	c3                   	retq   

ffff80000010b2af <kvmalloc>:
//
// linear map the first 4GB of physical memory starting
// at 0xFFFF800000000000
void
kvmalloc(void)
{
ffff80000010b2af:	f3 0f 1e fa          	endbr64 
ffff80000010b2b3:	55                   	push   %rbp
ffff80000010b2b4:	48 89 e5             	mov    %rsp,%rbp
  kpml4 = (pde_t*) kalloc();
ffff80000010b2b7:	48 b8 66 42 10 00 00 	movabs $0xffff800000104266,%rax
ffff80000010b2be:	80 ff ff 
ffff80000010b2c1:	ff d0                	callq  *%rax
ffff80000010b2c3:	48 ba 58 ad 1f 00 00 	movabs $0xffff8000001fad58,%rdx
ffff80000010b2ca:	80 ff ff 
ffff80000010b2cd:	48 89 02             	mov    %rax,(%rdx)
  memset(kpml4, 0, PGSIZE);
ffff80000010b2d0:	48 b8 58 ad 1f 00 00 	movabs $0xffff8000001fad58,%rax
ffff80000010b2d7:	80 ff ff 
ffff80000010b2da:	48 8b 00             	mov    (%rax),%rax
ffff80000010b2dd:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b2e2:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b2e7:	48 89 c7             	mov    %rax,%rdi
ffff80000010b2ea:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff80000010b2f1:	80 ff ff 
ffff80000010b2f4:	ff d0                	callq  *%rax

  // the kernel memory region starts at KERNBASE and up
  // allocate one PDPT at the bottom of that range.
  kpdpt = (pde_t*) kalloc();
ffff80000010b2f6:	48 b8 66 42 10 00 00 	movabs $0xffff800000104266,%rax
ffff80000010b2fd:	80 ff ff 
ffff80000010b300:	ff d0                	callq  *%rax
ffff80000010b302:	48 ba 60 ad 1f 00 00 	movabs $0xffff8000001fad60,%rdx
ffff80000010b309:	80 ff ff 
ffff80000010b30c:	48 89 02             	mov    %rax,(%rdx)
  memset(kpdpt, 0, PGSIZE);
ffff80000010b30f:	48 b8 60 ad 1f 00 00 	movabs $0xffff8000001fad60,%rax
ffff80000010b316:	80 ff ff 
ffff80000010b319:	48 8b 00             	mov    (%rax),%rax
ffff80000010b31c:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b321:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b326:	48 89 c7             	mov    %rax,%rdi
ffff80000010b329:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff80000010b330:	80 ff ff 
ffff80000010b333:	ff d0                	callq  *%rax
  kpml4[PMX(KERNBASE)] = v2p(kpdpt) | PTE_P | PTE_W;
ffff80000010b335:	48 b8 60 ad 1f 00 00 	movabs $0xffff8000001fad60,%rax
ffff80000010b33c:	80 ff ff 
ffff80000010b33f:	48 8b 00             	mov    (%rax),%rax
ffff80000010b342:	48 89 c7             	mov    %rax,%rdi
ffff80000010b345:	48 b8 51 ad 10 00 00 	movabs $0xffff80000010ad51,%rax
ffff80000010b34c:	80 ff ff 
ffff80000010b34f:	ff d0                	callq  *%rax
ffff80000010b351:	48 ba 58 ad 1f 00 00 	movabs $0xffff8000001fad58,%rdx
ffff80000010b358:	80 ff ff 
ffff80000010b35b:	48 8b 12             	mov    (%rdx),%rdx
ffff80000010b35e:	48 81 c2 00 08 00 00 	add    $0x800,%rdx
ffff80000010b365:	48 83 c8 03          	or     $0x3,%rax
ffff80000010b369:	48 89 02             	mov    %rax,(%rdx)

  // direct map first GB of physical addresses to KERNBASE
  kpdpt[0] = 0 | PTE_PS | PTE_P | PTE_W;
ffff80000010b36c:	48 b8 60 ad 1f 00 00 	movabs $0xffff8000001fad60,%rax
ffff80000010b373:	80 ff ff 
ffff80000010b376:	48 8b 00             	mov    (%rax),%rax
ffff80000010b379:	48 c7 00 83 00 00 00 	movq   $0x83,(%rax)

  // direct map 4th GB of physical addresses to KERNBASE+3GB
  // this is a very lazy way to map IO memory (for lapic and ioapic)
  // PTE_PWT and PTE_PCD for memory mapped I/O correctness.
  kpdpt[3] = 0xC0000000 | PTE_PS | PTE_P | PTE_W | PTE_PWT | PTE_PCD;
ffff80000010b380:	48 b8 60 ad 1f 00 00 	movabs $0xffff8000001fad60,%rax
ffff80000010b387:	80 ff ff 
ffff80000010b38a:	48 8b 00             	mov    (%rax),%rax
ffff80000010b38d:	48 83 c0 18          	add    $0x18,%rax
ffff80000010b391:	b9 9b 00 00 c0       	mov    $0xc000009b,%ecx
ffff80000010b396:	48 89 08             	mov    %rcx,(%rax)

  switchkvm();
ffff80000010b399:	48 b8 b9 b6 10 00 00 	movabs $0xffff80000010b6b9,%rax
ffff80000010b3a0:	80 ff ff 
ffff80000010b3a3:	ff d0                	callq  *%rax
}
ffff80000010b3a5:	90                   	nop
ffff80000010b3a6:	5d                   	pop    %rbp
ffff80000010b3a7:	c3                   	retq   

ffff80000010b3a8 <switchuvm>:

void
switchuvm(struct proc *p)
{
ffff80000010b3a8:	f3 0f 1e fa          	endbr64 
ffff80000010b3ac:	55                   	push   %rbp
ffff80000010b3ad:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b3b0:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010b3b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  pushcli();
ffff80000010b3b8:	48 b8 85 7a 10 00 00 	movabs $0xffff800000107a85,%rax
ffff80000010b3bf:	80 ff ff 
ffff80000010b3c2:	ff d0                	callq  *%rax
  if(p->pgdir == 0)
ffff80000010b3c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b3c8:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010b3cc:	48 85 c0             	test   %rax,%rax
ffff80000010b3cf:	75 16                	jne    ffff80000010b3e7 <switchuvm+0x3f>
    panic("switchuvm: no pgdir");
ffff80000010b3d1:	48 bf f0 cb 10 00 00 	movabs $0xffff80000010cbf0,%rdi
ffff80000010b3d8:	80 ff ff 
ffff80000010b3db:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010b3e2:	80 ff ff 
ffff80000010b3e5:	ff d0                	callq  *%rax
  uint *tss = (uint*) (((char*) cpu->local) + 1024);
ffff80000010b3e7:	64 48 8b 04 25 f0 ff 	mov    %fs:0xfffffffffffffff0,%rax
ffff80000010b3ee:	ff ff 
ffff80000010b3f0:	48 8b 40 20          	mov    0x20(%rax),%rax
ffff80000010b3f4:	48 05 00 04 00 00    	add    $0x400,%rax
ffff80000010b3fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  const addr_t stktop = (addr_t)p->kstack + KSTACKSIZE;
ffff80000010b3fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b402:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff80000010b406:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010b40c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  tss[1] = (uint)stktop; // https://wiki.osdev.org/Task_State_Segment
ffff80000010b410:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b414:	48 83 c0 04          	add    $0x4,%rax
ffff80000010b418:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010b41c:	89 10                	mov    %edx,(%rax)
  tss[2] = (uint)(stktop >> 32);
ffff80000010b41e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b422:	48 c1 e8 20          	shr    $0x20,%rax
ffff80000010b426:	48 89 c2             	mov    %rax,%rdx
ffff80000010b429:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b42d:	48 83 c0 08          	add    $0x8,%rax
ffff80000010b431:	89 10                	mov    %edx,(%rax)
  lcr3(v2p(p->pgdir));
ffff80000010b433:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b437:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010b43b:	48 89 c7             	mov    %rax,%rdi
ffff80000010b43e:	48 b8 51 ad 10 00 00 	movabs $0xffff80000010ad51,%rax
ffff80000010b445:	80 ff ff 
ffff80000010b448:	ff d0                	callq  *%rax
ffff80000010b44a:	48 89 c7             	mov    %rax,%rdi
ffff80000010b44d:	48 b8 37 ad 10 00 00 	movabs $0xffff80000010ad37,%rax
ffff80000010b454:	80 ff ff 
ffff80000010b457:	ff d0                	callq  *%rax
  popcli();
ffff80000010b459:	48 b8 f7 7a 10 00 00 	movabs $0xffff800000107af7,%rax
ffff80000010b460:	80 ff ff 
ffff80000010b463:	ff d0                	callq  *%rax
}
ffff80000010b465:	90                   	nop
ffff80000010b466:	c9                   	leaveq 
ffff80000010b467:	c3                   	retq   

ffff80000010b468 <walkpgdir>:
// In 64-bit mode, the page table has four levels: PML4, PDPT, PD and PT
// For each level, we dereference the correct entry, or allocate and
// initialize entry if the PTE_P bit is not set
static pte_t *
walkpgdir(pde_t *pml4, const void *va, int alloc)
{
ffff80000010b468:	f3 0f 1e fa          	endbr64 
ffff80000010b46c:	55                   	push   %rbp
ffff80000010b46d:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b470:	48 83 ec 50          	sub    $0x50,%rsp
ffff80000010b474:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
ffff80000010b478:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
ffff80000010b47c:	89 55 bc             	mov    %edx,-0x44(%rbp)
  pml4e_t *pml4e;
  pdpe_t *pdp, *pdpe;
  pde_t *pde, *pd, *pgtab;

  // from the PML4, find or allocate the appropriate PDP table
  pml4e = &pml4[PMX(va)];
ffff80000010b47f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010b483:	48 c1 e8 27          	shr    $0x27,%rax
ffff80000010b487:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010b48c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b493:	00 
ffff80000010b494:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010b498:	48 01 d0             	add    %rdx,%rax
ffff80000010b49b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  if(*pml4e & PTE_P)
ffff80000010b49f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b4a3:	48 8b 00             	mov    (%rax),%rax
ffff80000010b4a6:	83 e0 01             	and    $0x1,%eax
ffff80000010b4a9:	48 85 c0             	test   %rax,%rax
ffff80000010b4ac:	74 23                	je     ffff80000010b4d1 <walkpgdir+0x69>
    pdp = (pdpe_t*)P2V(PTE_ADDR(*pml4e));
ffff80000010b4ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b4b2:	48 8b 00             	mov    (%rax),%rax
ffff80000010b4b5:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b4bb:	48 89 c2             	mov    %rax,%rdx
ffff80000010b4be:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010b4c5:	80 ff ff 
ffff80000010b4c8:	48 01 d0             	add    %rdx,%rax
ffff80000010b4cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010b4cf:	eb 63                	jmp    ffff80000010b534 <walkpgdir+0xcc>
  else {
    if(!alloc || (pdp = (pdpe_t*)kalloc()) == 0)
ffff80000010b4d1:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
ffff80000010b4d5:	74 17                	je     ffff80000010b4ee <walkpgdir+0x86>
ffff80000010b4d7:	48 b8 66 42 10 00 00 	movabs $0xffff800000104266,%rax
ffff80000010b4de:	80 ff ff 
ffff80000010b4e1:	ff d0                	callq  *%rax
ffff80000010b4e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010b4e7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010b4ec:	75 0a                	jne    ffff80000010b4f8 <walkpgdir+0x90>
      return 0;
ffff80000010b4ee:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010b4f3:	e9 bf 01 00 00       	jmpq   ffff80000010b6b7 <walkpgdir+0x24f>
    memset(pdp, 0, PGSIZE);
ffff80000010b4f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b4fc:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b501:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b506:	48 89 c7             	mov    %rax,%rdi
ffff80000010b509:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff80000010b510:	80 ff ff 
ffff80000010b513:	ff d0                	callq  *%rax
    *pml4e = V2P(pdp) | PTE_P | PTE_W | PTE_U;
ffff80000010b515:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b519:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010b520:	80 00 00 
ffff80000010b523:	48 01 d0             	add    %rdx,%rax
ffff80000010b526:	48 83 c8 07          	or     $0x7,%rax
ffff80000010b52a:	48 89 c2             	mov    %rax,%rdx
ffff80000010b52d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b531:	48 89 10             	mov    %rdx,(%rax)
  }

  //from the PDP, find or allocate the appropriate PD (page directory)
  pdpe = &pdp[PDPX(va)];
ffff80000010b534:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010b538:	48 c1 e8 1e          	shr    $0x1e,%rax
ffff80000010b53c:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010b541:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b548:	00 
ffff80000010b549:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b54d:	48 01 d0             	add    %rdx,%rax
ffff80000010b550:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if(*pdpe & PTE_P)
ffff80000010b554:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b558:	48 8b 00             	mov    (%rax),%rax
ffff80000010b55b:	83 e0 01             	and    $0x1,%eax
ffff80000010b55e:	48 85 c0             	test   %rax,%rax
ffff80000010b561:	74 23                	je     ffff80000010b586 <walkpgdir+0x11e>
    pd = (pde_t*)P2V(PTE_ADDR(*pdpe));
ffff80000010b563:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b567:	48 8b 00             	mov    (%rax),%rax
ffff80000010b56a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b570:	48 89 c2             	mov    %rax,%rdx
ffff80000010b573:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010b57a:	80 ff ff 
ffff80000010b57d:	48 01 d0             	add    %rdx,%rax
ffff80000010b580:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010b584:	eb 63                	jmp    ffff80000010b5e9 <walkpgdir+0x181>
  else {
    if(!alloc || (pd = (pde_t*)kalloc()) == 0)//allocate page table
ffff80000010b586:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
ffff80000010b58a:	74 17                	je     ffff80000010b5a3 <walkpgdir+0x13b>
ffff80000010b58c:	48 b8 66 42 10 00 00 	movabs $0xffff800000104266,%rax
ffff80000010b593:	80 ff ff 
ffff80000010b596:	ff d0                	callq  *%rax
ffff80000010b598:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010b59c:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010b5a1:	75 0a                	jne    ffff80000010b5ad <walkpgdir+0x145>
      return 0;
ffff80000010b5a3:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010b5a8:	e9 0a 01 00 00       	jmpq   ffff80000010b6b7 <walkpgdir+0x24f>
    memset(pd, 0, PGSIZE);
ffff80000010b5ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b5b1:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b5b6:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b5bb:	48 89 c7             	mov    %rax,%rdi
ffff80000010b5be:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff80000010b5c5:	80 ff ff 
ffff80000010b5c8:	ff d0                	callq  *%rax
    *pdpe = V2P(pd) | PTE_P | PTE_W | PTE_U;
ffff80000010b5ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b5ce:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010b5d5:	80 00 00 
ffff80000010b5d8:	48 01 d0             	add    %rdx,%rax
ffff80000010b5db:	48 83 c8 07          	or     $0x7,%rax
ffff80000010b5df:	48 89 c2             	mov    %rax,%rdx
ffff80000010b5e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b5e6:	48 89 10             	mov    %rdx,(%rax)
  }

  // from the PD, find or allocate the appropriate page table
  pde = &pd[PDX(va)];
ffff80000010b5e9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010b5ed:	48 c1 e8 15          	shr    $0x15,%rax
ffff80000010b5f1:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010b5f6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b5fd:	00 
ffff80000010b5fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b602:	48 01 d0             	add    %rdx,%rax
ffff80000010b605:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  if(*pde & PTE_P)
ffff80000010b609:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b60d:	48 8b 00             	mov    (%rax),%rax
ffff80000010b610:	83 e0 01             	and    $0x1,%eax
ffff80000010b613:	48 85 c0             	test   %rax,%rax
ffff80000010b616:	74 23                	je     ffff80000010b63b <walkpgdir+0x1d3>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
ffff80000010b618:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b61c:	48 8b 00             	mov    (%rax),%rax
ffff80000010b61f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b625:	48 89 c2             	mov    %rax,%rdx
ffff80000010b628:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010b62f:	80 ff ff 
ffff80000010b632:	48 01 d0             	add    %rdx,%rax
ffff80000010b635:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010b639:	eb 60                	jmp    ffff80000010b69b <walkpgdir+0x233>
  else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)//allocate page table
ffff80000010b63b:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
ffff80000010b63f:	74 17                	je     ffff80000010b658 <walkpgdir+0x1f0>
ffff80000010b641:	48 b8 66 42 10 00 00 	movabs $0xffff800000104266,%rax
ffff80000010b648:	80 ff ff 
ffff80000010b64b:	ff d0                	callq  *%rax
ffff80000010b64d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010b651:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010b656:	75 07                	jne    ffff80000010b65f <walkpgdir+0x1f7>
      return 0;
ffff80000010b658:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010b65d:	eb 58                	jmp    ffff80000010b6b7 <walkpgdir+0x24f>
    memset(pgtab, 0, PGSIZE);
ffff80000010b65f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b663:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b668:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b66d:	48 89 c7             	mov    %rax,%rdi
ffff80000010b670:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff80000010b677:	80 ff ff 
ffff80000010b67a:	ff d0                	callq  *%rax
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
ffff80000010b67c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b680:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010b687:	80 00 00 
ffff80000010b68a:	48 01 d0             	add    %rdx,%rax
ffff80000010b68d:	48 83 c8 07          	or     $0x7,%rax
ffff80000010b691:	48 89 c2             	mov    %rax,%rdx
ffff80000010b694:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b698:	48 89 10             	mov    %rdx,(%rax)
  }

  return &pgtab[PTX(va)];
ffff80000010b69b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010b69f:	48 c1 e8 0c          	shr    $0xc,%rax
ffff80000010b6a3:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010b6a8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b6af:	00 
ffff80000010b6b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b6b4:	48 01 d0             	add    %rdx,%rax
}
ffff80000010b6b7:	c9                   	leaveq 
ffff80000010b6b8:	c3                   	retq   

ffff80000010b6b9 <switchkvm>:

void
switchkvm(void)
{
ffff80000010b6b9:	f3 0f 1e fa          	endbr64 
ffff80000010b6bd:	55                   	push   %rbp
ffff80000010b6be:	48 89 e5             	mov    %rsp,%rbp
  lcr3(v2p(kpml4));
ffff80000010b6c1:	48 b8 58 ad 1f 00 00 	movabs $0xffff8000001fad58,%rax
ffff80000010b6c8:	80 ff ff 
ffff80000010b6cb:	48 8b 00             	mov    (%rax),%rax
ffff80000010b6ce:	48 89 c7             	mov    %rax,%rdi
ffff80000010b6d1:	48 b8 51 ad 10 00 00 	movabs $0xffff80000010ad51,%rax
ffff80000010b6d8:	80 ff ff 
ffff80000010b6db:	ff d0                	callq  *%rax
ffff80000010b6dd:	48 89 c7             	mov    %rax,%rdi
ffff80000010b6e0:	48 b8 37 ad 10 00 00 	movabs $0xffff80000010ad37,%rax
ffff80000010b6e7:	80 ff ff 
ffff80000010b6ea:	ff d0                	callq  *%rax
}
ffff80000010b6ec:	90                   	nop
ffff80000010b6ed:	5d                   	pop    %rbp
ffff80000010b6ee:	c3                   	retq   

ffff80000010b6ef <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, addr_t size, addr_t pa, int perm)
{
ffff80000010b6ef:	f3 0f 1e fa          	endbr64 
ffff80000010b6f3:	55                   	push   %rbp
ffff80000010b6f4:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b6f7:	48 83 ec 50          	sub    $0x50,%rsp
ffff80000010b6fb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010b6ff:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010b703:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
ffff80000010b707:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
ffff80000010b70b:	44 89 45 bc          	mov    %r8d,-0x44(%rbp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((addr_t)va);
ffff80000010b70f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b713:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b719:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  last = (char*)PGROUNDDOWN(((addr_t)va) + size - 1);
ffff80000010b71d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff80000010b721:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010b725:	48 01 d0             	add    %rdx,%rax
ffff80000010b728:	48 83 e8 01          	sub    $0x1,%rax
ffff80000010b72c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b732:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
ffff80000010b736:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010b73a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b73e:	ba 01 00 00 00       	mov    $0x1,%edx
ffff80000010b743:	48 89 ce             	mov    %rcx,%rsi
ffff80000010b746:	48 89 c7             	mov    %rax,%rdi
ffff80000010b749:	48 b8 68 b4 10 00 00 	movabs $0xffff80000010b468,%rax
ffff80000010b750:	80 ff ff 
ffff80000010b753:	ff d0                	callq  *%rax
ffff80000010b755:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010b759:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010b75e:	75 07                	jne    ffff80000010b767 <mappages+0x78>
      return -1;
ffff80000010b760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010b765:	eb 61                	jmp    ffff80000010b7c8 <mappages+0xd9>
    if(*pte & PTE_P)
ffff80000010b767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b76b:	48 8b 00             	mov    (%rax),%rax
ffff80000010b76e:	83 e0 01             	and    $0x1,%eax
ffff80000010b771:	48 85 c0             	test   %rax,%rax
ffff80000010b774:	74 16                	je     ffff80000010b78c <mappages+0x9d>
      panic("remap");
ffff80000010b776:	48 bf 04 cc 10 00 00 	movabs $0xffff80000010cc04,%rdi
ffff80000010b77d:	80 ff ff 
ffff80000010b780:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010b787:	80 ff ff 
ffff80000010b78a:	ff d0                	callq  *%rax
    *pte = pa | perm | PTE_P;
ffff80000010b78c:	8b 45 bc             	mov    -0x44(%rbp),%eax
ffff80000010b78f:	48 98                	cltq   
ffff80000010b791:	48 0b 45 c0          	or     -0x40(%rbp),%rax
ffff80000010b795:	48 83 c8 01          	or     $0x1,%rax
ffff80000010b799:	48 89 c2             	mov    %rax,%rdx
ffff80000010b79c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b7a0:	48 89 10             	mov    %rdx,(%rax)
    if(a == last)
ffff80000010b7a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b7a7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffff80000010b7ab:	74 15                	je     ffff80000010b7c2 <mappages+0xd3>
      break;
    a += PGSIZE;
ffff80000010b7ad:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010b7b4:	00 
    pa += PGSIZE;
ffff80000010b7b5:	48 81 45 c0 00 10 00 	addq   $0x1000,-0x40(%rbp)
ffff80000010b7bc:	00 
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
ffff80000010b7bd:	e9 74 ff ff ff       	jmpq   ffff80000010b736 <mappages+0x47>
      break;
ffff80000010b7c2:	90                   	nop
  }
  return 0;
ffff80000010b7c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010b7c8:	c9                   	leaveq 
ffff80000010b7c9:	c3                   	retq   

ffff80000010b7ca <inituvm>:

// Load the initcode into address 0x1000 (4KB) of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
ffff80000010b7ca:	f3 0f 1e fa          	endbr64 
ffff80000010b7ce:	55                   	push   %rbp
ffff80000010b7cf:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b7d2:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010b7d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010b7da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010b7de:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *mem;

  if(sz >= PGSIZE)
ffff80000010b7e1:	81 7d dc ff 0f 00 00 	cmpl   $0xfff,-0x24(%rbp)
ffff80000010b7e8:	76 16                	jbe    ffff80000010b800 <inituvm+0x36>
    panic("inituvm: more than a page");
ffff80000010b7ea:	48 bf 0a cc 10 00 00 	movabs $0xffff80000010cc0a,%rdi
ffff80000010b7f1:	80 ff ff 
ffff80000010b7f4:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010b7fb:	80 ff ff 
ffff80000010b7fe:	ff d0                	callq  *%rax

  mem = kalloc();
ffff80000010b800:	48 b8 66 42 10 00 00 	movabs $0xffff800000104266,%rax
ffff80000010b807:	80 ff ff 
ffff80000010b80a:	ff d0                	callq  *%rax
ffff80000010b80c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(mem, 0, PGSIZE);
ffff80000010b810:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b814:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b819:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b81e:	48 89 c7             	mov    %rax,%rdi
ffff80000010b821:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff80000010b828:	80 ff ff 
ffff80000010b82b:	ff d0                	callq  *%rax
  mappages(pgdir, (void *)PGSIZE, PGSIZE, V2P(mem), PTE_W|PTE_U);
ffff80000010b82d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b831:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010b838:	80 00 00 
ffff80000010b83b:	48 01 c2             	add    %rax,%rdx
ffff80000010b83e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b842:	41 b8 06 00 00 00    	mov    $0x6,%r8d
ffff80000010b848:	48 89 d1             	mov    %rdx,%rcx
ffff80000010b84b:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b850:	be 00 10 00 00       	mov    $0x1000,%esi
ffff80000010b855:	48 89 c7             	mov    %rax,%rdi
ffff80000010b858:	48 b8 ef b6 10 00 00 	movabs $0xffff80000010b6ef,%rax
ffff80000010b85f:	80 ff ff 
ffff80000010b862:	ff d0                	callq  *%rax

  memmove(mem, init, sz);
ffff80000010b864:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff80000010b867:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff80000010b86b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b86f:	48 89 ce             	mov    %rcx,%rsi
ffff80000010b872:	48 89 c7             	mov    %rax,%rdi
ffff80000010b875:	48 b8 10 7d 10 00 00 	movabs $0xffff800000107d10,%rax
ffff80000010b87c:	80 ff ff 
ffff80000010b87f:	ff d0                	callq  *%rax
}
ffff80000010b881:	90                   	nop
ffff80000010b882:	c9                   	leaveq 
ffff80000010b883:	c3                   	retq   

ffff80000010b884 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
ffff80000010b884:	f3 0f 1e fa          	endbr64 
ffff80000010b888:	55                   	push   %rbp
ffff80000010b889:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b88c:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010b890:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010b894:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010b898:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
ffff80000010b89c:	89 4d c4             	mov    %ecx,-0x3c(%rbp)
ffff80000010b89f:	44 89 45 c0          	mov    %r8d,-0x40(%rbp)
  uint i, n;
  addr_t pa;
  pte_t *pte;

  if((addr_t) addr % PGSIZE != 0)
ffff80000010b8a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b8a7:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff80000010b8ac:	48 85 c0             	test   %rax,%rax
ffff80000010b8af:	74 16                	je     ffff80000010b8c7 <loaduvm+0x43>
    panic("loaduvm: addr must be page aligned");
ffff80000010b8b1:	48 bf 28 cc 10 00 00 	movabs $0xffff80000010cc28,%rdi
ffff80000010b8b8:	80 ff ff 
ffff80000010b8bb:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010b8c2:	80 ff ff 
ffff80000010b8c5:	ff d0                	callq  *%rax
  for(i = 0; i < sz; i += PGSIZE){
ffff80000010b8c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010b8ce:	e9 c4 00 00 00       	jmpq   ffff80000010b997 <loaduvm+0x113>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
ffff80000010b8d3:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010b8d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b8da:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff80000010b8de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b8e2:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010b8e7:	48 89 ce             	mov    %rcx,%rsi
ffff80000010b8ea:	48 89 c7             	mov    %rax,%rdi
ffff80000010b8ed:	48 b8 68 b4 10 00 00 	movabs $0xffff80000010b468,%rax
ffff80000010b8f4:	80 ff ff 
ffff80000010b8f7:	ff d0                	callq  *%rax
ffff80000010b8f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010b8fd:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010b902:	75 16                	jne    ffff80000010b91a <loaduvm+0x96>
      panic("loaduvm: address should exist");
ffff80000010b904:	48 bf 4b cc 10 00 00 	movabs $0xffff80000010cc4b,%rdi
ffff80000010b90b:	80 ff ff 
ffff80000010b90e:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010b915:	80 ff ff 
ffff80000010b918:	ff d0                	callq  *%rax
    pa = PTE_ADDR(*pte);
ffff80000010b91a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b91e:	48 8b 00             	mov    (%rax),%rax
ffff80000010b921:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b927:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if(sz - i < PGSIZE)
ffff80000010b92b:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff80000010b92e:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff80000010b931:	3d ff 0f 00 00       	cmp    $0xfff,%eax
ffff80000010b936:	77 0b                	ja     ffff80000010b943 <loaduvm+0xbf>
      n = sz - i;
ffff80000010b938:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff80000010b93b:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff80000010b93e:	89 45 f8             	mov    %eax,-0x8(%rbp)
ffff80000010b941:	eb 07                	jmp    ffff80000010b94a <loaduvm+0xc6>
    else
      n = PGSIZE;
ffff80000010b943:	c7 45 f8 00 10 00 00 	movl   $0x1000,-0x8(%rbp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
ffff80000010b94a:	8b 55 c4             	mov    -0x3c(%rbp),%edx
ffff80000010b94d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010b950:	8d 34 02             	lea    (%rdx,%rax,1),%esi
ffff80000010b953:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff80000010b95a:	80 ff ff 
ffff80000010b95d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b961:	48 01 d0             	add    %rdx,%rax
ffff80000010b964:	48 89 c7             	mov    %rax,%rdi
ffff80000010b967:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff80000010b96a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010b96e:	89 d1                	mov    %edx,%ecx
ffff80000010b970:	89 f2                	mov    %esi,%edx
ffff80000010b972:	48 89 fe             	mov    %rdi,%rsi
ffff80000010b975:	48 89 c7             	mov    %rax,%rdi
ffff80000010b978:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff80000010b97f:	80 ff ff 
ffff80000010b982:	ff d0                	callq  *%rax
ffff80000010b984:	39 45 f8             	cmp    %eax,-0x8(%rbp)
ffff80000010b987:	74 07                	je     ffff80000010b990 <loaduvm+0x10c>
      return -1;
ffff80000010b989:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010b98e:	eb 18                	jmp    ffff80000010b9a8 <loaduvm+0x124>
  for(i = 0; i < sz; i += PGSIZE){
ffff80000010b990:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
ffff80000010b997:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010b99a:	3b 45 c0             	cmp    -0x40(%rbp),%eax
ffff80000010b99d:	0f 82 30 ff ff ff    	jb     ffff80000010b8d3 <loaduvm+0x4f>
  }
  return 0;
ffff80000010b9a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010b9a8:	c9                   	leaveq 
ffff80000010b9a9:	c3                   	retq   

ffff80000010b9aa <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
uint64
allocuvm(pde_t *pgdir, uint64 oldsz, uint64 newsz)
{
ffff80000010b9aa:	f3 0f 1e fa          	endbr64 
ffff80000010b9ae:	55                   	push   %rbp
ffff80000010b9af:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b9b2:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010b9b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010b9ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010b9be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  char *mem;
  addr_t a;

  if(newsz >= KERNBASE)
ffff80000010b9c2:	48 b8 ff ff ff ff ff 	movabs $0xffff7fffffffffff,%rax
ffff80000010b9c9:	7f ff ff 
ffff80000010b9cc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
ffff80000010b9d0:	76 0a                	jbe    ffff80000010b9dc <allocuvm+0x32>
    return 0;
ffff80000010b9d2:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010b9d7:	e9 14 01 00 00       	jmpq   ffff80000010baf0 <allocuvm+0x146>
  if(newsz < oldsz)
ffff80000010b9dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b9e0:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
ffff80000010b9e4:	73 09                	jae    ffff80000010b9ef <allocuvm+0x45>
    return oldsz;
ffff80000010b9e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b9ea:	e9 01 01 00 00       	jmpq   ffff80000010baf0 <allocuvm+0x146>

  a = PGROUNDUP(oldsz);
ffff80000010b9ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b9f3:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff80000010b9f9:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b9ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(; a < newsz; a += PGSIZE){
ffff80000010ba03:	e9 d6 00 00 00       	jmpq   ffff80000010bade <allocuvm+0x134>
    mem = kalloc();
ffff80000010ba08:	48 b8 66 42 10 00 00 	movabs $0xffff800000104266,%rax
ffff80000010ba0f:	80 ff ff 
ffff80000010ba12:	ff d0                	callq  *%rax
ffff80000010ba14:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(mem == 0){
ffff80000010ba18:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010ba1d:	75 28                	jne    ffff80000010ba47 <allocuvm+0x9d>
      //cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
ffff80000010ba1f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010ba23:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff80000010ba27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010ba2b:	48 89 ce             	mov    %rcx,%rsi
ffff80000010ba2e:	48 89 c7             	mov    %rax,%rdi
ffff80000010ba31:	48 b8 f2 ba 10 00 00 	movabs $0xffff80000010baf2,%rax
ffff80000010ba38:	80 ff ff 
ffff80000010ba3b:	ff d0                	callq  *%rax
      return 0;
ffff80000010ba3d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010ba42:	e9 a9 00 00 00       	jmpq   ffff80000010baf0 <allocuvm+0x146>
    }
    memset(mem, 0, PGSIZE);
ffff80000010ba47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010ba4b:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010ba50:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010ba55:	48 89 c7             	mov    %rax,%rdi
ffff80000010ba58:	48 b8 03 7c 10 00 00 	movabs $0xffff800000107c03,%rax
ffff80000010ba5f:	80 ff ff 
ffff80000010ba62:	ff d0                	callq  *%rax
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
ffff80000010ba64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010ba68:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010ba6f:	80 00 00 
ffff80000010ba72:	48 01 c2             	add    %rax,%rdx
ffff80000010ba75:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
ffff80000010ba79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010ba7d:	41 b8 06 00 00 00    	mov    $0x6,%r8d
ffff80000010ba83:	48 89 d1             	mov    %rdx,%rcx
ffff80000010ba86:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010ba8b:	48 89 c7             	mov    %rax,%rdi
ffff80000010ba8e:	48 b8 ef b6 10 00 00 	movabs $0xffff80000010b6ef,%rax
ffff80000010ba95:	80 ff ff 
ffff80000010ba98:	ff d0                	callq  *%rax
ffff80000010ba9a:	85 c0                	test   %eax,%eax
ffff80000010ba9c:	79 38                	jns    ffff80000010bad6 <allocuvm+0x12c>
      //cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
ffff80000010ba9e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010baa2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff80000010baa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010baaa:	48 89 ce             	mov    %rcx,%rsi
ffff80000010baad:	48 89 c7             	mov    %rax,%rdi
ffff80000010bab0:	48 b8 f2 ba 10 00 00 	movabs $0xffff80000010baf2,%rax
ffff80000010bab7:	80 ff ff 
ffff80000010baba:	ff d0                	callq  *%rax
      krelease(mem);
ffff80000010babc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bac0:	48 89 c7             	mov    %rax,%rdi
ffff80000010bac3:	48 b8 20 43 10 00 00 	movabs $0xffff800000104320,%rax
ffff80000010baca:	80 ff ff 
ffff80000010bacd:	ff d0                	callq  *%rax
      return 0;
ffff80000010bacf:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010bad4:	eb 1a                	jmp    ffff80000010baf0 <allocuvm+0x146>
  for(; a < newsz; a += PGSIZE){
ffff80000010bad6:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010badd:	00 
ffff80000010bade:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bae2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
ffff80000010bae6:	0f 82 1c ff ff ff    	jb     ffff80000010ba08 <allocuvm+0x5e>
    }
  }
  return newsz;
ffff80000010baec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
}
ffff80000010baf0:	c9                   	leaveq 
ffff80000010baf1:	c3                   	retq   

ffff80000010baf2 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
deallocuvm(pde_t *pgdir, uint64 oldsz, uint64 newsz)
{
ffff80000010baf2:	f3 0f 1e fa          	endbr64 
ffff80000010baf6:	55                   	push   %rbp
ffff80000010baf7:	48 89 e5             	mov    %rsp,%rbp
ffff80000010bafa:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010bafe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010bb02:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010bb06:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  pte_t *pte;
  addr_t a, pa;

  if(newsz >= oldsz)
ffff80000010bb0a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010bb0e:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
ffff80000010bb12:	72 09                	jb     ffff80000010bb1d <deallocuvm+0x2b>
    return oldsz;
ffff80000010bb14:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bb18:	e9 cd 00 00 00       	jmpq   ffff80000010bbea <deallocuvm+0xf8>

  a = PGROUNDUP(newsz);
ffff80000010bb1d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010bb21:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff80000010bb27:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bb2d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(; a  < oldsz; a += PGSIZE){
ffff80000010bb31:	e9 a2 00 00 00       	jmpq   ffff80000010bbd8 <deallocuvm+0xe6>
    pte = walkpgdir(pgdir, (char*)a, 0);
ffff80000010bb36:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010bb3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bb3e:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010bb43:	48 89 ce             	mov    %rcx,%rsi
ffff80000010bb46:	48 89 c7             	mov    %rax,%rdi
ffff80000010bb49:	48 b8 68 b4 10 00 00 	movabs $0xffff80000010b468,%rax
ffff80000010bb50:	80 ff ff 
ffff80000010bb53:	ff d0                	callq  *%rax
ffff80000010bb55:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(pte && (*pte & PTE_P) != 0){
ffff80000010bb59:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010bb5e:	74 70                	je     ffff80000010bbd0 <deallocuvm+0xde>
ffff80000010bb60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bb64:	48 8b 00             	mov    (%rax),%rax
ffff80000010bb67:	83 e0 01             	and    $0x1,%eax
ffff80000010bb6a:	48 85 c0             	test   %rax,%rax
ffff80000010bb6d:	74 61                	je     ffff80000010bbd0 <deallocuvm+0xde>
      pa = PTE_ADDR(*pte);
ffff80000010bb6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bb73:	48 8b 00             	mov    (%rax),%rax
ffff80000010bb76:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bb7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      if(pa == 0)
ffff80000010bb80:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010bb85:	75 16                	jne    ffff80000010bb9d <deallocuvm+0xab>
        panic("dallocuvm");
ffff80000010bb87:	48 bf 69 cc 10 00 00 	movabs $0xffff80000010cc69,%rdi
ffff80000010bb8e:	80 ff ff 
ffff80000010bb91:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010bb98:	80 ff ff 
ffff80000010bb9b:	ff d0                	callq  *%rax
      char *v = P2V(pa);
ffff80000010bb9d:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff80000010bba4:	80 ff ff 
ffff80000010bba7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bbab:	48 01 d0             	add    %rdx,%rax
ffff80000010bbae:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
      krelease(v);
ffff80000010bbb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010bbb6:	48 89 c7             	mov    %rax,%rdi
ffff80000010bbb9:	48 b8 20 43 10 00 00 	movabs $0xffff800000104320,%rax
ffff80000010bbc0:	80 ff ff 
ffff80000010bbc3:	ff d0                	callq  *%rax
      *pte = 0;
ffff80000010bbc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bbc9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  for(; a  < oldsz; a += PGSIZE){
ffff80000010bbd0:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010bbd7:	00 
ffff80000010bbd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bbdc:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
ffff80000010bbe0:	0f 82 50 ff ff ff    	jb     ffff80000010bb36 <deallocuvm+0x44>
    }
  }
  return newsz;
ffff80000010bbe6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
}
ffff80000010bbea:	c9                   	leaveq 
ffff80000010bbeb:	c3                   	retq   

ffff80000010bbec <freevm>:

// Free all the pages mapped by, and all the memory used for,
// this page table
void
freevm(pde_t *pml4)
{
ffff80000010bbec:	f3 0f 1e fa          	endbr64 
ffff80000010bbf0:	55                   	push   %rbp
ffff80000010bbf1:	48 89 e5             	mov    %rsp,%rbp
ffff80000010bbf4:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010bbf8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  uint i, j, k, l;
  pde_t *pdp, *pd, *pt;

  if(pml4 == 0)
ffff80000010bbfc:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff80000010bc01:	75 16                	jne    ffff80000010bc19 <freevm+0x2d>
    panic("freevm: no pgdir");
ffff80000010bc03:	48 bf 73 cc 10 00 00 	movabs $0xffff80000010cc73,%rdi
ffff80000010bc0a:	80 ff ff 
ffff80000010bc0d:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010bc14:	80 ff ff 
ffff80000010bc17:	ff d0                	callq  *%rax

  // then need to loop through pml4 entry
  for(i = 0; i < (NPDENTRIES/2); i++){
ffff80000010bc19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010bc20:	e9 dc 01 00 00       	jmpq   ffff80000010be01 <freevm+0x215>
    if(pml4[i] & PTE_P){
ffff80000010bc25:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010bc28:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bc2f:	00 
ffff80000010bc30:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010bc34:	48 01 d0             	add    %rdx,%rax
ffff80000010bc37:	48 8b 00             	mov    (%rax),%rax
ffff80000010bc3a:	83 e0 01             	and    $0x1,%eax
ffff80000010bc3d:	48 85 c0             	test   %rax,%rax
ffff80000010bc40:	0f 84 b7 01 00 00    	je     ffff80000010bdfd <freevm+0x211>
      pdp = (pdpe_t*)P2V(PTE_ADDR(pml4[i]));
ffff80000010bc46:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010bc49:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bc50:	00 
ffff80000010bc51:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010bc55:	48 01 d0             	add    %rdx,%rax
ffff80000010bc58:	48 8b 00             	mov    (%rax),%rax
ffff80000010bc5b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bc61:	48 89 c2             	mov    %rax,%rdx
ffff80000010bc64:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010bc6b:	80 ff ff 
ffff80000010bc6e:	48 01 d0             	add    %rdx,%rax
ffff80000010bc71:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

      // and every entry in the corresponding pdpt
      for(j = 0; j < NPDENTRIES; j++){
ffff80000010bc75:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
ffff80000010bc7c:	e9 5c 01 00 00       	jmpq   ffff80000010bddd <freevm+0x1f1>
        if(pdp[j] & PTE_P){
ffff80000010bc81:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010bc84:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bc8b:	00 
ffff80000010bc8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bc90:	48 01 d0             	add    %rdx,%rax
ffff80000010bc93:	48 8b 00             	mov    (%rax),%rax
ffff80000010bc96:	83 e0 01             	and    $0x1,%eax
ffff80000010bc99:	48 85 c0             	test   %rax,%rax
ffff80000010bc9c:	0f 84 37 01 00 00    	je     ffff80000010bdd9 <freevm+0x1ed>
          pd = (pde_t*)P2V(PTE_ADDR(pdp[j]));
ffff80000010bca2:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010bca5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bcac:	00 
ffff80000010bcad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bcb1:	48 01 d0             	add    %rdx,%rax
ffff80000010bcb4:	48 8b 00             	mov    (%rax),%rax
ffff80000010bcb7:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bcbd:	48 89 c2             	mov    %rax,%rdx
ffff80000010bcc0:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010bcc7:	80 ff ff 
ffff80000010bcca:	48 01 d0             	add    %rdx,%rax
ffff80000010bccd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

          // and every entry in the corresponding page directory
          for(k = 0; k < (NPDENTRIES); k++){
ffff80000010bcd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
ffff80000010bcd8:	e9 dc 00 00 00       	jmpq   ffff80000010bdb9 <freevm+0x1cd>
            if(pd[k] & PTE_P) {
ffff80000010bcdd:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010bce0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bce7:	00 
ffff80000010bce8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010bcec:	48 01 d0             	add    %rdx,%rax
ffff80000010bcef:	48 8b 00             	mov    (%rax),%rax
ffff80000010bcf2:	83 e0 01             	and    $0x1,%eax
ffff80000010bcf5:	48 85 c0             	test   %rax,%rax
ffff80000010bcf8:	0f 84 b7 00 00 00    	je     ffff80000010bdb5 <freevm+0x1c9>
              pt = (pde_t*)P2V(PTE_ADDR(pd[k]));
ffff80000010bcfe:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010bd01:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bd08:	00 
ffff80000010bd09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010bd0d:	48 01 d0             	add    %rdx,%rax
ffff80000010bd10:	48 8b 00             	mov    (%rax),%rax
ffff80000010bd13:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bd19:	48 89 c2             	mov    %rax,%rdx
ffff80000010bd1c:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010bd23:	80 ff ff 
ffff80000010bd26:	48 01 d0             	add    %rdx,%rax
ffff80000010bd29:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

              // and every entry in the corresponding page table
              for(l = 0; l < (NPDENTRIES); l++){
ffff80000010bd2d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
ffff80000010bd34:	eb 63                	jmp    ffff80000010bd99 <freevm+0x1ad>
                if(pt[l] & PTE_P) {
ffff80000010bd36:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff80000010bd39:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bd40:	00 
ffff80000010bd41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bd45:	48 01 d0             	add    %rdx,%rax
ffff80000010bd48:	48 8b 00             	mov    (%rax),%rax
ffff80000010bd4b:	83 e0 01             	and    $0x1,%eax
ffff80000010bd4e:	48 85 c0             	test   %rax,%rax
ffff80000010bd51:	74 42                	je     ffff80000010bd95 <freevm+0x1a9>
                  char * v = P2V(PTE_ADDR(pt[l]));
ffff80000010bd53:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff80000010bd56:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bd5d:	00 
ffff80000010bd5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bd62:	48 01 d0             	add    %rdx,%rax
ffff80000010bd65:	48 8b 00             	mov    (%rax),%rax
ffff80000010bd68:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bd6e:	48 89 c2             	mov    %rax,%rdx
ffff80000010bd71:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010bd78:	80 ff ff 
ffff80000010bd7b:	48 01 d0             	add    %rdx,%rax
ffff80000010bd7e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

                  krelease((char*)v);
ffff80000010bd82:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bd86:	48 89 c7             	mov    %rax,%rdi
ffff80000010bd89:	48 b8 20 43 10 00 00 	movabs $0xffff800000104320,%rax
ffff80000010bd90:	80 ff ff 
ffff80000010bd93:	ff d0                	callq  *%rax
              for(l = 0; l < (NPDENTRIES); l++){
ffff80000010bd95:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
ffff80000010bd99:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
ffff80000010bda0:	76 94                	jbe    ffff80000010bd36 <freevm+0x14a>
                }
              }
              //freeing every page table
              krelease((char*)pt);
ffff80000010bda2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bda6:	48 89 c7             	mov    %rax,%rdi
ffff80000010bda9:	48 b8 20 43 10 00 00 	movabs $0xffff800000104320,%rax
ffff80000010bdb0:	80 ff ff 
ffff80000010bdb3:	ff d0                	callq  *%rax
          for(k = 0; k < (NPDENTRIES); k++){
ffff80000010bdb5:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
ffff80000010bdb9:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
ffff80000010bdc0:	0f 86 17 ff ff ff    	jbe    ffff80000010bcdd <freevm+0xf1>
            }
          }
          // freeing every page directory
          krelease((char*)pd);
ffff80000010bdc6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010bdca:	48 89 c7             	mov    %rax,%rdi
ffff80000010bdcd:	48 b8 20 43 10 00 00 	movabs $0xffff800000104320,%rax
ffff80000010bdd4:	80 ff ff 
ffff80000010bdd7:	ff d0                	callq  *%rax
      for(j = 0; j < NPDENTRIES; j++){
ffff80000010bdd9:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
ffff80000010bddd:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
ffff80000010bde4:	0f 86 97 fe ff ff    	jbe    ffff80000010bc81 <freevm+0x95>
        }
      }
      // freeing every page directory pointer table
      krelease((char*)pdp);
ffff80000010bdea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bdee:	48 89 c7             	mov    %rax,%rdi
ffff80000010bdf1:	48 b8 20 43 10 00 00 	movabs $0xffff800000104320,%rax
ffff80000010bdf8:	80 ff ff 
ffff80000010bdfb:	ff d0                	callq  *%rax
  for(i = 0; i < (NPDENTRIES/2); i++){
ffff80000010bdfd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010be01:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
ffff80000010be08:	0f 86 17 fe ff ff    	jbe    ffff80000010bc25 <freevm+0x39>
    }
  }
  // freeing the pml4
  krelease((char*)pml4);
ffff80000010be0e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010be12:	48 89 c7             	mov    %rax,%rdi
ffff80000010be15:	48 b8 20 43 10 00 00 	movabs $0xffff800000104320,%rax
ffff80000010be1c:	80 ff ff 
ffff80000010be1f:	ff d0                	callq  *%rax
}
ffff80000010be21:	90                   	nop
ffff80000010be22:	c9                   	leaveq 
ffff80000010be23:	c3                   	retq   

ffff80000010be24 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
ffff80000010be24:	f3 0f 1e fa          	endbr64 
ffff80000010be28:	55                   	push   %rbp
ffff80000010be29:	48 89 e5             	mov    %rsp,%rbp
ffff80000010be2c:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010be30:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010be34:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
ffff80000010be38:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff80000010be3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010be40:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010be45:	48 89 ce             	mov    %rcx,%rsi
ffff80000010be48:	48 89 c7             	mov    %rax,%rdi
ffff80000010be4b:	48 b8 68 b4 10 00 00 	movabs $0xffff80000010b468,%rax
ffff80000010be52:	80 ff ff 
ffff80000010be55:	ff d0                	callq  *%rax
ffff80000010be57:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(pte == 0)
ffff80000010be5b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010be60:	75 16                	jne    ffff80000010be78 <clearpteu+0x54>
    panic("clearpteu");
ffff80000010be62:	48 bf 84 cc 10 00 00 	movabs $0xffff80000010cc84,%rdi
ffff80000010be69:	80 ff ff 
ffff80000010be6c:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010be73:	80 ff ff 
ffff80000010be76:	ff d0                	callq  *%rax
  *pte &= ~PTE_U;
ffff80000010be78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010be7c:	48 8b 00             	mov    (%rax),%rax
ffff80000010be7f:	48 83 e0 fb          	and    $0xfffffffffffffffb,%rax
ffff80000010be83:	48 89 c2             	mov    %rax,%rdx
ffff80000010be86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010be8a:	48 89 10             	mov    %rdx,(%rax)
}
ffff80000010be8d:	90                   	nop
ffff80000010be8e:	c9                   	leaveq 
ffff80000010be8f:	c3                   	retq   

ffff80000010be90 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
ffff80000010be90:	f3 0f 1e fa          	endbr64 
ffff80000010be94:	55                   	push   %rbp
ffff80000010be95:	48 89 e5             	mov    %rsp,%rbp
ffff80000010be98:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010be9c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
ffff80000010bea0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  pde_t *d;
  pte_t *pte;
  addr_t pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
ffff80000010bea3:	48 b8 42 b2 10 00 00 	movabs $0xffff80000010b242,%rax
ffff80000010beaa:	80 ff ff 
ffff80000010bead:	ff d0                	callq  *%rax
ffff80000010beaf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010beb3:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010beb8:	75 0a                	jne    ffff80000010bec4 <copyuvm+0x34>
    return 0;
ffff80000010beba:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010bebf:	e9 51 01 00 00       	jmpq   ffff80000010c015 <copyuvm+0x185>
  for(i = PGSIZE; i < sz; i += PGSIZE){
ffff80000010bec4:	48 c7 45 f8 00 10 00 	movq   $0x1000,-0x8(%rbp)
ffff80000010becb:	00 
ffff80000010becc:	e9 15 01 00 00       	jmpq   ffff80000010bfe6 <copyuvm+0x156>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
ffff80000010bed1:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010bed5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010bed9:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010bede:	48 89 ce             	mov    %rcx,%rsi
ffff80000010bee1:	48 89 c7             	mov    %rax,%rdi
ffff80000010bee4:	48 b8 68 b4 10 00 00 	movabs $0xffff80000010b468,%rax
ffff80000010beeb:	80 ff ff 
ffff80000010beee:	ff d0                	callq  *%rax
ffff80000010bef0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010bef4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010bef9:	75 16                	jne    ffff80000010bf11 <copyuvm+0x81>
      panic("copyuvm: pte should exist");
ffff80000010befb:	48 bf 8e cc 10 00 00 	movabs $0xffff80000010cc8e,%rdi
ffff80000010bf02:	80 ff ff 
ffff80000010bf05:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010bf0c:	80 ff ff 
ffff80000010bf0f:	ff d0                	callq  *%rax
    if(!(*pte & PTE_P))
ffff80000010bf11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bf15:	48 8b 00             	mov    (%rax),%rax
ffff80000010bf18:	83 e0 01             	and    $0x1,%eax
ffff80000010bf1b:	48 85 c0             	test   %rax,%rax
ffff80000010bf1e:	75 16                	jne    ffff80000010bf36 <copyuvm+0xa6>
      panic("copyuvm: page not present");
ffff80000010bf20:	48 bf a8 cc 10 00 00 	movabs $0xffff80000010cca8,%rdi
ffff80000010bf27:	80 ff ff 
ffff80000010bf2a:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010bf31:	80 ff ff 
ffff80000010bf34:	ff d0                	callq  *%rax
    pa = PTE_ADDR(*pte);
ffff80000010bf36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bf3a:	48 8b 00             	mov    (%rax),%rax
ffff80000010bf3d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bf43:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    flags = PTE_FLAGS(*pte);
ffff80000010bf47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bf4b:	48 8b 00             	mov    (%rax),%rax
ffff80000010bf4e:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff80000010bf53:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    if((mem = kalloc()) == 0)
ffff80000010bf57:	48 b8 66 42 10 00 00 	movabs $0xffff800000104266,%rax
ffff80000010bf5e:	80 ff ff 
ffff80000010bf61:	ff d0                	callq  *%rax
ffff80000010bf63:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
ffff80000010bf67:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
ffff80000010bf6c:	0f 84 87 00 00 00    	je     ffff80000010bff9 <copyuvm+0x169>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
ffff80000010bf72:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff80000010bf79:	80 ff ff 
ffff80000010bf7c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010bf80:	48 01 d0             	add    %rdx,%rax
ffff80000010bf83:	48 89 c1             	mov    %rax,%rcx
ffff80000010bf86:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bf8a:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010bf8f:	48 89 ce             	mov    %rcx,%rsi
ffff80000010bf92:	48 89 c7             	mov    %rax,%rdi
ffff80000010bf95:	48 b8 10 7d 10 00 00 	movabs $0xffff800000107d10,%rax
ffff80000010bf9c:	80 ff ff 
ffff80000010bf9f:	ff d0                	callq  *%rax
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
ffff80000010bfa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bfa5:	89 c1                	mov    %eax,%ecx
ffff80000010bfa7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bfab:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010bfb2:	80 00 00 
ffff80000010bfb5:	48 01 c2             	add    %rax,%rdx
ffff80000010bfb8:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
ffff80000010bfbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bfc0:	41 89 c8             	mov    %ecx,%r8d
ffff80000010bfc3:	48 89 d1             	mov    %rdx,%rcx
ffff80000010bfc6:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010bfcb:	48 89 c7             	mov    %rax,%rdi
ffff80000010bfce:	48 b8 ef b6 10 00 00 	movabs $0xffff80000010b6ef,%rax
ffff80000010bfd5:	80 ff ff 
ffff80000010bfd8:	ff d0                	callq  *%rax
ffff80000010bfda:	85 c0                	test   %eax,%eax
ffff80000010bfdc:	78 1e                	js     ffff80000010bffc <copyuvm+0x16c>
  for(i = PGSIZE; i < sz; i += PGSIZE){
ffff80000010bfde:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010bfe5:	00 
ffff80000010bfe6:	8b 45 c4             	mov    -0x3c(%rbp),%eax
ffff80000010bfe9:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff80000010bfed:	0f 82 de fe ff ff    	jb     ffff80000010bed1 <copyuvm+0x41>
      goto bad;
  }
  return d;
ffff80000010bff3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bff7:	eb 1c                	jmp    ffff80000010c015 <copyuvm+0x185>
      goto bad;
ffff80000010bff9:	90                   	nop
ffff80000010bffa:	eb 01                	jmp    ffff80000010bffd <copyuvm+0x16d>
      goto bad;
ffff80000010bffc:	90                   	nop

bad:
  freevm(d);
ffff80000010bffd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c001:	48 89 c7             	mov    %rax,%rdi
ffff80000010c004:	48 b8 ec bb 10 00 00 	movabs $0xffff80000010bbec,%rax
ffff80000010c00b:	80 ff ff 
ffff80000010c00e:	ff d0                	callq  *%rax
  return 0;
ffff80000010c010:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010c015:	c9                   	leaveq 
ffff80000010c016:	c3                   	retq   

ffff80000010c017 <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
ffff80000010c017:	f3 0f 1e fa          	endbr64 
ffff80000010c01b:	55                   	push   %rbp
ffff80000010c01c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c01f:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010c023:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010c027:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
ffff80000010c02b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff80000010c02f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c033:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010c038:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c03b:	48 89 c7             	mov    %rax,%rdi
ffff80000010c03e:	48 b8 68 b4 10 00 00 	movabs $0xffff80000010b468,%rax
ffff80000010c045:	80 ff ff 
ffff80000010c048:	ff d0                	callq  *%rax
ffff80000010c04a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if((*pte & PTE_P) == 0)
ffff80000010c04e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c052:	48 8b 00             	mov    (%rax),%rax
ffff80000010c055:	83 e0 01             	and    $0x1,%eax
ffff80000010c058:	48 85 c0             	test   %rax,%rax
ffff80000010c05b:	75 07                	jne    ffff80000010c064 <uva2ka+0x4d>
    return 0;
ffff80000010c05d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010c062:	eb 33                	jmp    ffff80000010c097 <uva2ka+0x80>
  if((*pte & PTE_U) == 0)
ffff80000010c064:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c068:	48 8b 00             	mov    (%rax),%rax
ffff80000010c06b:	83 e0 04             	and    $0x4,%eax
ffff80000010c06e:	48 85 c0             	test   %rax,%rax
ffff80000010c071:	75 07                	jne    ffff80000010c07a <uva2ka+0x63>
    return 0;
ffff80000010c073:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010c078:	eb 1d                	jmp    ffff80000010c097 <uva2ka+0x80>
  return (char*)P2V(PTE_ADDR(*pte));
ffff80000010c07a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c07e:	48 8b 00             	mov    (%rax),%rax
ffff80000010c081:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c087:	48 89 c2             	mov    %rax,%rdx
ffff80000010c08a:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010c091:	80 ff ff 
ffff80000010c094:	48 01 d0             	add    %rdx,%rax
}
ffff80000010c097:	c9                   	leaveq 
ffff80000010c098:	c3                   	retq   

ffff80000010c099 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, addr_t va, void *p, uint64 len)
{
ffff80000010c099:	f3 0f 1e fa          	endbr64 
ffff80000010c09d:	55                   	push   %rbp
ffff80000010c09e:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c0a1:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010c0a5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010c0a9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010c0ad:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
ffff80000010c0b1:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
  char *buf, *pa0;
  addr_t n, va0;

  buf = (char*)p;
ffff80000010c0b5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010c0b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(len > 0){
ffff80000010c0bd:	e9 b0 00 00 00       	jmpq   ffff80000010c172 <copyout+0xd9>
    va0 = PGROUNDDOWN(va);
ffff80000010c0c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c0c6:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c0cc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    pa0 = uva2ka(pgdir, (char*)va0);
ffff80000010c0d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff80000010c0d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c0d8:	48 89 d6             	mov    %rdx,%rsi
ffff80000010c0db:	48 89 c7             	mov    %rax,%rdi
ffff80000010c0de:	48 b8 17 c0 10 00 00 	movabs $0xffff80000010c017,%rax
ffff80000010c0e5:	80 ff ff 
ffff80000010c0e8:	ff d0                	callq  *%rax
ffff80000010c0ea:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    if(pa0 == 0)
ffff80000010c0ee:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffff80000010c0f3:	75 0a                	jne    ffff80000010c0ff <copyout+0x66>
      return -1;
ffff80000010c0f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010c0fa:	e9 83 00 00 00       	jmpq   ffff80000010c182 <copyout+0xe9>
    n = PGSIZE - (va - va0);
ffff80000010c0ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c103:	48 2b 45 d0          	sub    -0x30(%rbp),%rax
ffff80000010c107:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010c10d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(n > len)
ffff80000010c111:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c115:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
ffff80000010c119:	76 08                	jbe    ffff80000010c123 <copyout+0x8a>
      n = len;
ffff80000010c11b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010c11f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    memmove(pa0 + (va - va0), buf, n);
ffff80000010c123:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c127:	89 c6                	mov    %eax,%esi
ffff80000010c129:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c12d:	48 2b 45 e8          	sub    -0x18(%rbp),%rax
ffff80000010c131:	48 89 c2             	mov    %rax,%rdx
ffff80000010c134:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c138:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff80000010c13c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c140:	89 f2                	mov    %esi,%edx
ffff80000010c142:	48 89 c6             	mov    %rax,%rsi
ffff80000010c145:	48 89 cf             	mov    %rcx,%rdi
ffff80000010c148:	48 b8 10 7d 10 00 00 	movabs $0xffff800000107d10,%rax
ffff80000010c14f:	80 ff ff 
ffff80000010c152:	ff d0                	callq  *%rax
    len -= n;
ffff80000010c154:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c158:	48 29 45 c0          	sub    %rax,-0x40(%rbp)
    buf += n;
ffff80000010c15c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c160:	48 01 45 f8          	add    %rax,-0x8(%rbp)
    va = va0 + PGSIZE;
ffff80000010c164:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c168:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010c16e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  while(len > 0){
ffff80000010c172:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
ffff80000010c177:	0f 85 45 ff ff ff    	jne    ffff80000010c0c2 <copyout+0x29>
  }
  return 0;
ffff80000010c17d:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010c182:	c9                   	leaveq 
ffff80000010c183:	c3                   	retq   

ffff80000010c184 <dedup>:
/* deduplicate pages between process virtual address vstart and virtual address vend */
//reduces number of physical page frames being used.Make page read only. 1. Copy page 2. change one page 
//table entry to point to copy...
void
dedup(void *vstart, void *vend)
{
ffff80000010c184:	f3 0f 1e fa          	endbr64 
ffff80000010c188:	55                   	push   %rbp
ffff80000010c189:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c18c:	48 83 ec 60          	sub    $0x60,%rsp
ffff80000010c190:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
ffff80000010c194:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)

  char* addr = (char*)PGROUNDDOWN((addr_t)vstart);
ffff80000010c198:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
ffff80000010c19c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c1a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  char* addr2 = (char*)PGROUNDDOWN((addr_t)vstart)+PGSIZE;
ffff80000010c1a6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
ffff80000010c1aa:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c1b0:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010c1b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  char* addr_end = (char*)PGROUNDUP((addr_t)vend);
ffff80000010c1ba:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
ffff80000010c1be:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff80000010c1c4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c1ca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  for(; addr < addr_end; addr+=PGSIZE){
ffff80000010c1ce:	e9 dd 01 00 00       	jmpq   ffff80000010c3b0 <dedup+0x22c>
  	char* kernel_va = uva2ka(proc->pgdir,addr);
ffff80000010c1d3:	64 48 8b 04 25 f8 ff 	mov    %fs:0xfffffffffffffff8,%rax
ffff80000010c1da:	ff ff 
ffff80000010c1dc:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010c1e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010c1e4:	48 89 d6             	mov    %rdx,%rsi
ffff80000010c1e7:	48 89 c7             	mov    %rax,%rdi
ffff80000010c1ea:	48 b8 17 c0 10 00 00 	movabs $0xffff80000010c017,%rax
ffff80000010c1f1:	80 ff ff 
ffff80000010c1f4:	ff d0                	callq  *%rax
ffff80000010c1f6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if(kernel_va != 0){
ffff80000010c1fa:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffff80000010c1ff:	0f 84 a3 01 00 00    	je     ffff80000010c3a8 <dedup+0x224>
		update_checksum(V2P((addr_t)kernel_va));
ffff80000010c205:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c209:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010c210:	80 00 00 
ffff80000010c213:	48 01 d0             	add    %rdx,%rax
ffff80000010c216:	48 89 c7             	mov    %rax,%rdi
ffff80000010c219:	48 b8 51 44 10 00 00 	movabs $0xffff800000104451,%rax
ffff80000010c220:	80 ff ff 
ffff80000010c223:	ff d0                	callq  *%rax
		if(addr > addr2){//if there's enough space to map previous page
ffff80000010c225:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c229:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffff80000010c22d:	0f 86 75 01 00 00    	jbe    ffff80000010c3a8 <dedup+0x224>
			char* kernel_off = uva2ka(proc->pgdir,addr-PGSIZE);
ffff80000010c233:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c237:	48 8d 90 00 f0 ff ff 	lea    -0x1000(%rax),%rdx
ffff80000010c23e:	64 48 8b 04 25 f8 ff 	mov    %fs:0xfffffffffffffff8,%rax
ffff80000010c245:	ff ff 
ffff80000010c247:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010c24b:	48 89 d6             	mov    %rdx,%rsi
ffff80000010c24e:	48 89 c7             	mov    %rax,%rdi
ffff80000010c251:	48 b8 17 c0 10 00 00 	movabs $0xffff80000010c017,%rax
ffff80000010c258:	80 ff ff 
ffff80000010c25b:	ff d0                	callq  *%rax
ffff80000010c25d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			if(kernel_off != 0){
ffff80000010c261:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffff80000010c266:	0f 84 3c 01 00 00    	je     ffff80000010c3a8 <dedup+0x224>
				char* previous = V2P((addr_t)kernel_off);
ffff80000010c26c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c270:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010c277:	80 00 00 
ffff80000010c27a:	48 01 d0             	add    %rdx,%rax
ffff80000010c27d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
				char* current = V2P((addr_t)kernel_va);
ffff80000010c281:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c285:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010c28c:	80 00 00 
ffff80000010c28f:	48 01 d0             	add    %rdx,%rax
ffff80000010c292:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
				if(frames_are_identical(previous,current)){
ffff80000010c296:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
ffff80000010c29a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c29e:	48 89 d6             	mov    %rdx,%rsi
ffff80000010c2a1:	48 89 c7             	mov    %rax,%rdi
ffff80000010c2a4:	48 b8 df 44 10 00 00 	movabs $0xffff8000001044df,%rax
ffff80000010c2ab:	80 ff ff 
ffff80000010c2ae:	ff d0                	callq  *%rax
ffff80000010c2b0:	85 c0                	test   %eax,%eax
ffff80000010c2b2:	0f 84 f0 00 00 00    	je     ffff80000010c3a8 <dedup+0x224>
					pte_t* pte1 = walkpgdir(proc->pgdir,addr-PGSIZE,0);//previous
ffff80000010c2b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c2bc:	48 8d 88 00 f0 ff ff 	lea    -0x1000(%rax),%rcx
ffff80000010c2c3:	64 48 8b 04 25 f8 ff 	mov    %fs:0xfffffffffffffff8,%rax
ffff80000010c2ca:	ff ff 
ffff80000010c2cc:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010c2d0:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010c2d5:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c2d8:	48 89 c7             	mov    %rax,%rdi
ffff80000010c2db:	48 b8 68 b4 10 00 00 	movabs $0xffff80000010b468,%rax
ffff80000010c2e2:	80 ff ff 
ffff80000010c2e5:	ff d0                	callq  *%rax
ffff80000010c2e7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
					pte_t* pte2 = walkpgdir(proc->pgdir,addr,0);//current
ffff80000010c2eb:	64 48 8b 04 25 f8 ff 	mov    %fs:0xfffffffffffffff8,%rax
ffff80000010c2f2:	ff ff 
ffff80000010c2f4:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010c2f8:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010c2fc:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010c301:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c304:	48 89 c7             	mov    %rax,%rdi
ffff80000010c307:	48 b8 68 b4 10 00 00 	movabs $0xffff80000010b468,%rax
ffff80000010c30e:	80 ff ff 
ffff80000010c311:	ff d0                	callq  *%rax
ffff80000010c313:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
					*pte1 = *pte1|PTE_COW;
ffff80000010c317:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010c31b:	48 8b 00             	mov    (%rax),%rax
ffff80000010c31e:	80 cc 02             	or     $0x2,%ah
ffff80000010c321:	48 89 c2             	mov    %rax,%rdx
ffff80000010c324:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010c328:	48 89 10             	mov    %rdx,(%rax)
					//2nd frame
					if(pte2 != 0){
ffff80000010c32b:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
ffff80000010c330:	74 2c                	je     ffff80000010c35e <dedup+0x1da>
						*pte2 = *pte1|PTE_P|PTE_U|PTE_COW;
ffff80000010c332:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010c336:	48 8b 00             	mov    (%rax),%rax
ffff80000010c339:	48 0d 05 02 00 00    	or     $0x205,%rax
ffff80000010c33f:	48 89 c2             	mov    %rax,%rdx
ffff80000010c342:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff80000010c346:	48 89 10             	mov    %rdx,(%rax)
						*pte2 &= ~PTE_W;
ffff80000010c349:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff80000010c34d:	48 8b 00             	mov    (%rax),%rax
ffff80000010c350:	48 83 e0 fd          	and    $0xfffffffffffffffd,%rax
ffff80000010c354:	48 89 c2             	mov    %rax,%rdx
ffff80000010c357:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff80000010c35b:	48 89 10             	mov    %rdx,(%rax)
					}
					krelease(kernel_va);
ffff80000010c35e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c362:	48 89 c7             	mov    %rax,%rdi
ffff80000010c365:	48 b8 20 43 10 00 00 	movabs $0xffff800000104320,%rax
ffff80000010c36c:	80 ff ff 
ffff80000010c36f:	ff d0                	callq  *%rax
					//1st frame
					if(*pte1 & PTE_W)
ffff80000010c371:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010c375:	48 8b 00             	mov    (%rax),%rax
ffff80000010c378:	83 e0 02             	and    $0x2,%eax
ffff80000010c37b:	48 85 c0             	test   %rax,%rax
ffff80000010c37e:	74 15                	je     ffff80000010c395 <dedup+0x211>
					{
						*pte1 &= ~PTE_W;
ffff80000010c380:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010c384:	48 8b 00             	mov    (%rax),%rax
ffff80000010c387:	48 83 e0 fd          	and    $0xfffffffffffffffd,%rax
ffff80000010c38b:	48 89 c2             	mov    %rax,%rdx
ffff80000010c38e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010c392:	48 89 10             	mov    %rdx,(%rax)
					}
					kretain(kernel_off);
ffff80000010c395:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c399:	48 89 c7             	mov    %rax,%rdi
ffff80000010c39c:	48 b8 bb 43 10 00 00 	movabs $0xffff8000001043bb,%rax
ffff80000010c3a3:	80 ff ff 
ffff80000010c3a6:	ff d0                	callq  *%rax
  for(; addr < addr_end; addr+=PGSIZE){
ffff80000010c3a8:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010c3af:	00 
ffff80000010c3b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c3b4:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffff80000010c3b8:	0f 82 15 fe ff ff    	jb     ffff80000010c1d3 <dedup+0x4f>
				}
			}
		}
  	}
  }
}
ffff80000010c3be:	90                   	nop
ffff80000010c3bf:	90                   	nop
ffff80000010c3c0:	c9                   	leaveq 
ffff80000010c3c1:	c3                   	retq   

ffff80000010c3c2 <copyonwrite>:
/* maybe perform copy-on-write on the page that contains virtual address v.
   returns 1 if copy-on-write was performed, 0 otherwise. */
int
copyonwrite(char* v)
{
ffff80000010c3c2:	f3 0f 1e fa          	endbr64 
ffff80000010c3c6:	55                   	push   %rbp
ffff80000010c3c7:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c3ca:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010c3ce:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  // TODO: Your code here
  char* round = (char*)PGROUNDDOWN((addr_t)v);
ffff80000010c3d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c3d6:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c3dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  char* kernel_va = uva2ka(proc->pgdir,round);
ffff80000010c3e0:	64 48 8b 04 25 f8 ff 	mov    %fs:0xfffffffffffffff8,%rax
ffff80000010c3e7:	ff ff 
ffff80000010c3e9:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010c3ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010c3f1:	48 89 d6             	mov    %rdx,%rsi
ffff80000010c3f4:	48 89 c7             	mov    %rax,%rdi
ffff80000010c3f7:	48 b8 17 c0 10 00 00 	movabs $0xffff80000010c017,%rax
ffff80000010c3fe:	80 ff ff 
ffff80000010c401:	ff d0                	callq  *%rax
ffff80000010c403:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if(kernel_va != 0){
ffff80000010c407:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010c40c:	0f 84 9e 00 00 00    	je     ffff80000010c4b0 <copyonwrite+0xee>
	pte_t* pte = walkpgdir(proc->pgdir,round,0);
ffff80000010c412:	64 48 8b 04 25 f8 ff 	mov    %fs:0xfffffffffffffff8,%rax
ffff80000010c419:	ff ff 
ffff80000010c41b:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010c41f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010c423:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010c428:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c42b:	48 89 c7             	mov    %rax,%rdi
ffff80000010c42e:	48 b8 68 b4 10 00 00 	movabs $0xffff80000010b468,%rax
ffff80000010c435:	80 ff ff 
ffff80000010c438:	ff d0                	callq  *%rax
ffff80000010c43a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//if cow pte
	if(*pte & PTE_COW ){
ffff80000010c43e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c442:	48 8b 00             	mov    (%rax),%rax
ffff80000010c445:	25 00 02 00 00       	and    $0x200,%eax
ffff80000010c44a:	48 85 c0             	test   %rax,%rax
ffff80000010c44d:	74 4e                	je     ffff80000010c49d <copyonwrite+0xdb>
		char* tmp_mem = kalloc();
ffff80000010c44f:	48 b8 66 42 10 00 00 	movabs $0xffff800000104266,%rax
ffff80000010c456:	80 ff ff 
ffff80000010c459:	ff d0                	callq  *%rax
ffff80000010c45b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(tmp_mem,kernel_va,PGSIZE);
ffff80000010c45f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff80000010c463:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c467:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010c46c:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c46f:	48 89 c7             	mov    %rax,%rdi
ffff80000010c472:	48 b8 10 7d 10 00 00 	movabs $0xffff800000107d10,%rax
ffff80000010c479:	80 ff ff 
ffff80000010c47c:	ff d0                	callq  *%rax
		//PTE point to new address
		*pte = V2P(tmp_mem)|PTE_P|PTE_U|PTE_W;
ffff80000010c47e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c482:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010c489:	80 00 00 
ffff80000010c48c:	48 01 d0             	add    %rdx,%rax
ffff80000010c48f:	48 83 c8 07          	or     $0x7,%rax
ffff80000010c493:	48 89 c2             	mov    %rax,%rdx
ffff80000010c496:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c49a:	48 89 10             	mov    %rdx,(%rax)
	}
	krelease((char*)kernel_va);
ffff80000010c49d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c4a1:	48 89 c7             	mov    %rax,%rdi
ffff80000010c4a4:	48 b8 20 43 10 00 00 	movabs $0xffff800000104320,%rax
ffff80000010c4ab:	80 ff ff 
ffff80000010c4ae:	ff d0                	callq  *%rax
  }
  return 1;
ffff80000010c4b0:	b8 01 00 00 00       	mov    $0x1,%eax
}
ffff80000010c4b5:	c9                   	leaveq 
ffff80000010c4b6:	c3                   	retq   
