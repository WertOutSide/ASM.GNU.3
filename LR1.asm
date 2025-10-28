.intel_syntax noprefix
.globl main

.data
.p2align 4
handle: .octa	0
bufer:		.space 192
bufer2:		.space 64
message:	.asciz "rue to it. That is the one thing I have faith in Our good and wo"
.equ	meslen, .-message - 1
enter:	.asciz "\n"
.equ	entlen, .-enter - 1

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
    call	load_regs
    
    call	string_edit
    
    call	save_regs
    
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
    call	load_regs2
    
    call	string_unedit
    
    call	save_regs
    
    sub	rsp, 56
    mov	rcx, [rip + handle]
    lea	rdx, [rip + bufer2]
    mov	r8, meslen
    mov	r9, 0
    mov	[rsp + 32], r9
    call	WriteFile
    add	rsp, 56
    ret

load_regs2:
    mov r8,  [rip + bufer2]
    mov r9,  [rip + bufer2 + 8]
    mov r10, [rip + bufer2 + 16] 
    mov r11, [rip + bufer2 + 24]
    mov r12, [rip + bufer2 + 32]
    mov r13, [rip + bufer2 + 40]
    mov r14, [rip + bufer2 + 48]
    mov r15, [rip + bufer2 + 56]
    ret
load_regs:
    mov r8,  [rip + message]
    mov r9,  [rip + message + 8]
    mov r10, [rip + message + 16] 
    mov r11, [rip + message + 24]
    mov r12, [rip + message + 32]
    mov r13, [rip + message + 40]
    mov r14, [rip + message + 48]
    mov r15, [rip + message + 56]
    ret

save_regs:
    mov [rip + bufer2], r8
    mov [rip + bufer2 + 8], r9
    mov [rip + bufer2 + 16], r10
    mov [rip + bufer2 + 24], r11
    mov [rip + bufer2 + 32], r12
    mov [rip + bufer2 + 40], r13
    mov [rip + bufer2 + 48], r14
    mov [rip + bufer2 + 56], r15
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
    mov	r8, entlen
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
    
    
    
