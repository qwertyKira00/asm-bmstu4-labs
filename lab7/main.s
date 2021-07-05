	.file	"main.c"
	.intel_syntax noprefix
	.text
	.globl	asm_strlen
	.type	asm_strlen, @function
asm_strlen:
.LFB6:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR -24[rbp], rdi
	mov	DWORD PTR -4[rbp], 0
	mov	rdx, QWORD PTR -24[rbp]
#APP
# 17 "main.c" 1
	.intel_syntax noprefix
	mov ecx, 0xFFFF
	lea rdi, [rdx]
	mov al, 0
	repne scasb
	mov eax, 0xFFFF
	sub eax, ecx
	dec eax
	mov edx, eax
	
# 0 "" 2
#NO_APP
	mov	DWORD PTR -4[rbp], edx
	mov	eax, DWORD PTR -4[rbp]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	asm_strlen, .-asm_strlen
	.section	.rodata
	.align 8
.LC0:
	.string	"String length:\nC (strlen() function): %ld\nASM: %d\n"
	.align 8
.LC1:
	.string	"First string = %s\nSecond string (copy) = %s"
	.text
	.globl	main
	.type	main, @function
main:
.LFB7:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 48
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	movabs	rax, 7598524149084024385
	mov	QWORD PTR -34[rbp], rax
	mov	WORD PTR -26[rbp], 24937
	mov	BYTE PTR -24[rbp], 0
	lea	rax, -34[rbp]
	mov	rdi, rax
	call	asm_strlen
	mov	DWORD PTR -40[rbp], eax
	lea	rax, -34[rbp]
	mov	rdi, rax
	call	strlen@PLT
	mov	rcx, rax
	mov	eax, DWORD PTR -40[rbp]
	mov	edx, eax
	mov	rsi, rcx
	lea	rdi, .LC0[rip]
	mov	eax, 0
	call	printf@PLT
	lea	rdx, -23[rbp]
	lea	rcx, -34[rbp]
	mov	eax, DWORD PTR -40[rbp]
	mov	rsi, rcx
	mov	edi, eax
	mov	eax, 0
	call	str_copy@PLT
	lea	rdx, -23[rbp]
	lea	rax, -34[rbp]
	mov	rsi, rax
	lea	rdi, .LC1[rip]
	mov	eax, 0
	call	printf@PLT
	mov	eax, 0
	mov	rsi, QWORD PTR -8[rbp]
	xor	rsi, QWORD PTR fs:40
	je	.L5
	call	__stack_chk_fail@PLT
.L5:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.3.0-10ubuntu2) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
