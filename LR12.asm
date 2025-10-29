.intel_syntax noprefix
.globl main

.data
.p2align 4
handle: .octa	0
bufer:		.space 192
bufer2:		.space 64
bufer3:		.space 64   
message:	.asciz "rue to it. That is the one thing I have faith in Our good and wo"
.equ	meslen, .-message - 1
enter:	.asciz "\n"
.equ	perlen, .-enter - 1

.text
main:
    push	rbp
    mov	rbp, rsp

    mov	rcx, -11
    call	GetStdHandle
    mov	[rip + handle], rax
    
    call	output_orig
    call	entr_out

    call	prog1
    call	entr_out

    call	unedit_print
    call	entr_out

    pop	rbp
    ret

output_orig:
    sub	rsp, 56
    mov	rcx, [rip + handle]
    lea	rdx, [rip + message]
    mov	r8, meslen
    mov	r9, 0
    mov	[rsp + 32], r9
    call	WriteFile
    add	rsp, 56
    ret

prog1:
  
    lea rax, [rip + message]
    push rax
    call	load_regs
    add rsp, 8
    
    call	string_edit
    
 
    lea rax, [rip + bufer2]
    push rax
    call	save_regs
    add rsp, 8
    
    lea	rsi, [rip + bufer2]
    lea	rdi, [rip + bufer]
    mov	rcx, meslen
    call	chartohex
    
    sub	rsp, 56
    mov	rcx, [rip + handle]
    lea	rdx, [rip + bufer]
    mov	r8, 192
    mov	r9, 0
    mov	[rsp + 32], r9
    call	WriteFile
    add	rsp, 56
    ret

unedit_print:
    lea rax, [rip + bufer2]
    push rax
    call	load_regs
    add rsp, 8
    
    call	string_unedit
    
    lea rax, [rip + bufer3]
    push rax
    call	save_regs
    add rsp, 8
    
    sub	rsp, 56
    mov	rcx, [rip + handle]
    lea	rdx, [rip + bufer3]    
    mov	r8, meslen
    mov	r9, 0
    mov	[rsp + 32], r9
    call	WriteFile
    add	rsp, 56
    ret

load_regs:
    push rbp
    mov rbp, rsp
    mov rax, [rbp + 16]    
    
    mov r8,  [rax]
    mov r9,  [rax + 8]
    mov r10, [rax + 16] 
    mov r11, [rax + 24]
    mov r12, [rax + 32]
    mov r13, [rax + 40]
    mov r14, [rax + 48]
    mov r15, [rax + 56]
    
    pop rbp
    ret

save_regs:
    push rbp
    mov rbp, rsp
    mov rax, [rbp + 16]    
    mov [rax], r8
    mov [rax + 8], r9
    mov [rax + 16], r10
    mov [rax + 24], r11
    mov [rax + 32], r12
    mov [rax + 40], r13
    mov [rax + 48], r14
    mov [rax + 56], r15
    
    pop rbp
    ret

string_edit:
    xchg r8, r15
    xchg r9, r14  
    xchg r10, r13
    xchg r11, r12
    ret

string_unedit:
    xchg r8, r15
    xchg r9, r14  
    xchg r10, r13
    xchg r11, r12
    ret
    
entr_out:
    sub	rsp, 56
    mov	rcx, [rip + handle]
    lea	rdx, [rip + enter]
    mov	r8, perlen
    mov	r9, 0
    mov	[rsp + 32], r9
    call	WriteFile
    add	rsp, 56
    ret

chartohex:
    lodsb
    movzx	ax, al
    shl	ax, 4
    shr	al, 4
    xchg	ah, al
    call	ascill
    stosb
    
    mov	al, ah
    call	ascill
    stosb

    mov	al, ' '
    stosb

    dec	rcx
    cmp	rcx, 0
    jnz	chartohex
    ret

ascill:
    cmp	al, 9
    jbe	cifra
    add	al, 'A'
    sub	al, 10
    ret

cifra:
    add	al, '0'
    ret
