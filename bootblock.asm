
bootblock.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
    7c00:	fa                   	cli    
    7c01:	31 c0                	xor    %eax,%eax
    7c03:	8e d8                	mov    %eax,%ds
    7c05:	8e c0                	mov    %eax,%es
    7c07:	8e d0                	mov    %eax,%ss

00007c09 <seta20.1>:
    7c09:	e4 64                	in     $0x64,%al
    7c0b:	a8 02                	test   $0x2,%al
    7c0d:	75 fa                	jne    7c09 <seta20.1>
    7c0f:	b0 d1                	mov    $0xd1,%al
    7c11:	e6 64                	out    %al,$0x64

00007c13 <seta20.2>:
    7c13:	e4 64                	in     $0x64,%al
    7c15:	a8 02                	test   $0x2,%al
    7c17:	75 fa                	jne    7c13 <seta20.2>
    7c19:	b0 df                	mov    $0xdf,%al
    7c1b:	e6 60                	out    %al,$0x60
    7c1d:	0f 01 16             	lgdtl  (%esi)
    7c20:	68 7c 0f 20 c0       	push   $0xc0200f7c
    7c25:	66 83 c8 01          	or     $0x1,%ax
    7c29:	0f 22 c0             	mov    %eax,%cr0
    7c2c:	ea                   	.byte 0xea
    7c2d:	31 7c 08 00          	xor    %edi,0x0(%eax,%ecx,1)

00007c31 <start32>:
    7c31:	66 b8 10 00          	mov    $0x10,%ax
    7c35:	8e d8                	mov    %eax,%ds
    7c37:	8e c0                	mov    %eax,%es
    7c39:	8e d0                	mov    %eax,%ss
    7c3b:	66 b8 00 00          	mov    $0x0,%ax
    7c3f:	8e e0                	mov    %eax,%fs
    7c41:	8e e8                	mov    %eax,%gs
    7c43:	bc 00 7c 00 00       	mov    $0x7c00,%esp
    7c48:	e8 e0 00 00 00       	call   7d2d <bootmain>

00007c4d <spin>:
    7c4d:	eb fe                	jmp    7c4d <spin>
    7c4f:	90                   	nop

00007c50 <gdt>:
	...
    7c58:	ff                   	(bad)  
    7c59:	ff 00                	incl   (%eax)
    7c5b:	00 00                	add    %al,(%eax)
    7c5d:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c64:	00                   	.byte 0x0
    7c65:	92                   	xchg   %eax,%edx
    7c66:	cf                   	iret   
	...

00007c68 <gdtdesc>:
    7c68:	17                   	pop    %ss
    7c69:	00 50 7c             	add    %dl,0x7c(%eax)
	...

00007c6e <waitdisk>:
    7c6e:	f3 0f 1e fb          	endbr32 
    7c72:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c77:	ec                   	in     (%dx),%al
    7c78:	83 e0 c0             	and    $0xffffffc0,%eax
    7c7b:	3c 40                	cmp    $0x40,%al
    7c7d:	75 f8                	jne    7c77 <waitdisk+0x9>
    7c7f:	c3                   	ret    

00007c80 <readsect>:
    7c80:	f3 0f 1e fb          	endbr32 
    7c84:	57                   	push   %edi
    7c85:	53                   	push   %ebx
    7c86:	8b 5c 24 10          	mov    0x10(%esp),%ebx
    7c8a:	e8 df ff ff ff       	call   7c6e <waitdisk>
    7c8f:	b8 01 00 00 00       	mov    $0x1,%eax
    7c94:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7c99:	ee                   	out    %al,(%dx)
    7c9a:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7c9f:	89 d8                	mov    %ebx,%eax
    7ca1:	ee                   	out    %al,(%dx)
    7ca2:	89 d8                	mov    %ebx,%eax
    7ca4:	c1 e8 08             	shr    $0x8,%eax
    7ca7:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7cac:	ee                   	out    %al,(%dx)
    7cad:	89 d8                	mov    %ebx,%eax
    7caf:	c1 e8 10             	shr    $0x10,%eax
    7cb2:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7cb7:	ee                   	out    %al,(%dx)
    7cb8:	89 d8                	mov    %ebx,%eax
    7cba:	c1 e8 18             	shr    $0x18,%eax
    7cbd:	83 c8 e0             	or     $0xffffffe0,%eax
    7cc0:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7cc5:	ee                   	out    %al,(%dx)
    7cc6:	b8 20 00 00 00       	mov    $0x20,%eax
    7ccb:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7cd0:	ee                   	out    %al,(%dx)
    7cd1:	e8 98 ff ff ff       	call   7c6e <waitdisk>
    7cd6:	8b 7c 24 0c          	mov    0xc(%esp),%edi
    7cda:	b9 80 00 00 00       	mov    $0x80,%ecx
    7cdf:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7ce4:	fc                   	cld    
    7ce5:	f3 6d                	rep insl (%dx),%es:(%edi)
    7ce7:	5b                   	pop    %ebx
    7ce8:	5f                   	pop    %edi
    7ce9:	c3                   	ret    

00007cea <readseg>:
    7cea:	f3 0f 1e fb          	endbr32 
    7cee:	57                   	push   %edi
    7cef:	56                   	push   %esi
    7cf0:	53                   	push   %ebx
    7cf1:	8b 5c 24 10          	mov    0x10(%esp),%ebx
    7cf5:	8b 74 24 18          	mov    0x18(%esp),%esi
    7cf9:	89 df                	mov    %ebx,%edi
    7cfb:	03 7c 24 14          	add    0x14(%esp),%edi
    7cff:	89 f0                	mov    %esi,%eax
    7d01:	25 ff 01 00 00       	and    $0x1ff,%eax
    7d06:	29 c3                	sub    %eax,%ebx
    7d08:	c1 ee 09             	shr    $0x9,%esi
    7d0b:	83 c6 01             	add    $0x1,%esi
    7d0e:	39 df                	cmp    %ebx,%edi
    7d10:	76 17                	jbe    7d29 <readseg+0x3f>
    7d12:	56                   	push   %esi
    7d13:	53                   	push   %ebx
    7d14:	e8 67 ff ff ff       	call   7c80 <readsect>
    7d19:	81 c3 00 02 00 00    	add    $0x200,%ebx
    7d1f:	83 c6 01             	add    $0x1,%esi
    7d22:	83 c4 08             	add    $0x8,%esp
    7d25:	39 df                	cmp    %ebx,%edi
    7d27:	77 e9                	ja     7d12 <readseg+0x28>
    7d29:	5b                   	pop    %ebx
    7d2a:	5e                   	pop    %esi
    7d2b:	5f                   	pop    %edi
    7d2c:	c3                   	ret    

00007d2d <bootmain>:
    7d2d:	f3 0f 1e fb          	endbr32 
    7d31:	57                   	push   %edi
    7d32:	56                   	push   %esi
    7d33:	53                   	push   %ebx
    7d34:	6a 00                	push   $0x0
    7d36:	68 00 20 00 00       	push   $0x2000
    7d3b:	68 00 00 01 00       	push   $0x10000
    7d40:	e8 a5 ff ff ff       	call   7cea <readseg>
    7d45:	83 c4 0c             	add    $0xc,%esp
    7d48:	b8 00 00 01 00       	mov    $0x10000,%eax
    7d4d:	eb 0a                	jmp    7d59 <bootmain+0x2c>
    7d4f:	83 c0 04             	add    $0x4,%eax
    7d52:	3d 00 20 01 00       	cmp    $0x12000,%eax
    7d57:	74 35                	je     7d8e <bootmain+0x61>
    7d59:	8d 88 00 00 ff ff    	lea    -0x10000(%eax),%ecx
    7d5f:	89 c3                	mov    %eax,%ebx
    7d61:	81 38 02 b0 ad 1b    	cmpl   $0x1badb002,(%eax)
    7d67:	75 e6                	jne    7d4f <bootmain+0x22>
    7d69:	8b 50 08             	mov    0x8(%eax),%edx
    7d6c:	03 50 04             	add    0x4(%eax),%edx
    7d6f:	81 fa fe 4f 52 e4    	cmp    $0xe4524ffe,%edx
    7d75:	75 d8                	jne    7d4f <bootmain+0x22>
    7d77:	f6 40 06 01          	testb  $0x1,0x6(%eax)
    7d7b:	74 11                	je     7d8e <bootmain+0x61>
    7d7d:	8b 40 10             	mov    0x10(%eax),%eax
    7d80:	8b 53 0c             	mov    0xc(%ebx),%edx
    7d83:	39 d0                	cmp    %edx,%eax
    7d85:	77 07                	ja     7d8e <bootmain+0x61>
    7d87:	8b 73 14             	mov    0x14(%ebx),%esi
    7d8a:	39 f0                	cmp    %esi,%eax
    7d8c:	76 04                	jbe    7d92 <bootmain+0x65>
    7d8e:	5b                   	pop    %ebx
    7d8f:	5e                   	pop    %esi
    7d90:	5f                   	pop    %edi
    7d91:	c3                   	ret    
    7d92:	01 c1                	add    %eax,%ecx
    7d94:	29 d1                	sub    %edx,%ecx
    7d96:	51                   	push   %ecx
    7d97:	29 c6                	sub    %eax,%esi
    7d99:	56                   	push   %esi
    7d9a:	50                   	push   %eax
    7d9b:	e8 4a ff ff ff       	call   7cea <readseg>
    7da0:	8b 4b 18             	mov    0x18(%ebx),%ecx
    7da3:	8b 43 14             	mov    0x14(%ebx),%eax
    7da6:	83 c4 0c             	add    $0xc,%esp
    7da9:	39 c1                	cmp    %eax,%ecx
    7dab:	76 0c                	jbe    7db9 <bootmain+0x8c>
    7dad:	29 c1                	sub    %eax,%ecx
    7daf:	89 c7                	mov    %eax,%edi
    7db1:	b8 00 00 00 00       	mov    $0x0,%eax
    7db6:	fc                   	cld    
    7db7:	f3 aa                	rep stos %al,%es:(%edi)
    7db9:	ff 53 1c             	call   *0x1c(%ebx)
    7dbc:	eb d0                	jmp    7d8e <bootmain+0x61>
