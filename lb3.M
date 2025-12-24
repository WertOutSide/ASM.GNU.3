.intel_syntax noprefix
.globl main

.data
.p2align 4
handle:     .quad 0
written:    .quad 0
newline:    .byte 0x0A
hex_ASCII:  .ascii "0123456789ABCDEF"

.p2align 4
array: 
         .float 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0

fin:  .space 128
buffer:     .space 384
enter:	.asciz "\n"
.equ	entlen, .-enter - 1
.text
main:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 48

        mov     rcx, -11
        call    GetStdHandle
        mov     [rip + handle], rax

        lea     rax, [rip + array]
        push    rax
        lea     rax, [rip + fin]
        push    rax

        call    function
        
        add     rsp, 16
        call	entr_out

        call    chartohex

        lea     rcx, [rip + buffer]
        mov     rdx, 384
        call    outter
        call	entr_out

        add     rsp, 48
        pop     rbp
        xor     rax, rax
        ret

function:
        push    rbp
        mov     rbp, rsp

        mov     rdx, [rbp + 16]
        mov     rdi, [rbp + 24]

        movss   xmm0, [rdi]
        shufps  xmm0, xmm0, 0x00
        movaps  [rdx], xmm0

        movss   xmm1, [rdi + 4]
        shufps  xmm1, xmm1, 0x00
        movaps  [rdx + 16], xmm1

        movss   xmm2, [rdi + 8]
        shufps  xmm2, xmm2, 0x00
        movaps  [rdx + 32], xmm2

        movss   xmm3, [rdi + 12]
        shufps  xmm3, xmm3, 0x00
        movaps  [rdx + 48], xmm3

        movss   xmm4, [rdi + 16]
        shufps  xmm4, xmm4, 0x00
        movaps  [rdx + 64], xmm4

        movss   xmm5, [rdi + 20]
        shufps  xmm5, xmm5, 0x00
        movaps  [rdx + 80], xmm5

        movss   xmm6, [rdi + 24]
        shufps  xmm6, xmm6, 0x00
        movaps  [rdx + 96], xmm6

        movss   xmm7, [rdi + 28]
        shufps  xmm7, xmm7, 0x00
        movaps  [rdx + 112], xmm7

        pop     rbp
        ret

chartohex:
        push    rbp
        mov     rbp, rsp
        push    rsi
        push    rdi
        push    rbx

        lea     rsi, [rip + fin]
        lea     rdi, [rip + buffer]
        lea     rbx, [rip + hex_ASCII]
        mov     rcx, 32

.loop1:
        mov     r8, 3
byteloop:
        movzx   rax, byte ptr [rsi + r8]
        
        mov     rdx, rax
        shr     rdx, 4
        and     rdx, 0x0F
        mov     dl, [rbx + rdx]
        mov     [rdi], dl

        mov     rdx, rax
        and     rdx, 0x0F
        mov     dl, [rbx + rdx]
        mov     [rdi + 1], dl

        mov     byte ptr [rdi + 2], 0x20

        add     rdi, 3
        dec     r8
        jns     byteloop

        add     rsi, 4
        dec     rcx
        jnz     .loop1

        pop     rbx
        pop     rdi
        pop     rsi
        pop     rbp
        ret

outter:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 48

        mov     r8, rdx
        mov     rdx, rcx
        mov     rcx, [rip + handle]
        lea     r9, [rip + written]
        mov     qword ptr [rsp + 32], 0
        call    WriteFile

        mov     rcx, [rip + handle]
        lea     rdx, [rip + newline]
        mov     r8, 1
        lea     r9, [rip + written]
        mov     qword ptr [rsp + 32], 0
        call    WriteFile

        add     rsp, 48
        pop     rbp
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
    
    
