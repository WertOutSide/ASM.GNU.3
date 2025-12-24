.intel_syntax noprefix
.globl main

.data
handle: .octa 0

massiv: .word 1,2,3,4,5,6,7,8

res: .space 128
hexbuf: .space 384
newline: .asciz "\n"
.equ newlen, 1

.text

main:
push rbp
mov rbp, rsp

mov rcx, -11
call GetStdHandle
mov [handle+rip], rax
sub rsp, 32
lea rax, res[rip]
push rax
lea rax, massiv[rip]
push rax
call xmm_and_print

add rsp, 48
pop rbp
ret


xmm_and_print:
push rbp
mov rbp, rsp

mov rsi, [rbp+16]
mov rdi, [rbp+24]

movdqu xmm0, [rsi]
pshuflw xmm0, xmm0, 0x1B
pshufhw xmm0, xmm0, 0x1B
pshufd xmm0, xmm0, 0x4E
movdqu [rdi], xmm0

movdqu xmm1, [rsi]
pshuflw xmm1, xmm1, 0x1B
pshufhw xmm1, xmm1, 0x1B
pshufd xmm1, xmm1, 0x4E
movdqu [rdi+16], xmm1

movdqu xmm2, [rsi]
pshuflw xmm2, xmm2, 0x1B
pshufhw xmm2, xmm2, 0x1B
pshufd xmm2, xmm2, 0x4E
movdqu [rdi+32], xmm2

movdqu xmm3, [rsi]
pshuflw xmm3, xmm3, 0x1B
pshufhw xmm3, xmm3, 0x1B
pshufd xmm3, xmm3, 0x4E
movdqu [rdi+48], xmm3

movdqu xmm4, [rsi]
pshuflw xmm4, xmm4, 0x1B
pshufhw xmm4, xmm4, 0x1B
pshufd xmm4, xmm4, 0x4E
movdqu [rdi+64], xmm4

movdqu xmm5, [rsi]
pshuflw xmm5, xmm5, 0x1B
pshufhw xmm5, xmm5, 0x1B
pshufd xmm5, xmm5, 0x4E
movdqu [rdi+80], xmm5

movdqu xmm6, [rsi]
pshuflw xmm6, xmm6, 0x1B
pshufhw xmm6, xmm6, 0x1B
pshufd xmm6, xmm6, 0x4E
movdqu [rdi+96], xmm6

movdqu xmm7, [rsi]
pshuflw xmm7, xmm7, 0x1B
pshufhw xmm7, xmm7, 0x1B
pshufd xmm7, xmm7, 0x4E
movdqu [rdi+112], xmm7

mov rsi, rdi
lea rdi, hexbuf[rip]

mov rcx, 128
.hex_loop:
movzx ax, byte ptr [rsi]
add rsi, 1
mov ah, al
shr ah, 4
and al, 0x0F
cmp ah, 9
jg .hiL
add ah, '0'
jmp .hiD
.hiL:
add ah, 'A' - 10
.hiD:
cmp al, 9
jg .loL
add al, '0'
jmp .loD
.loL:
add al, 'A' - 10
.loD:
mov [rdi], ah
mov [rdi+1], al
mov byte ptr [rdi+2], ' '
add rdi, 3
loop .hex_loop

sub rsp, 56
mov rcx, [handle+rip]
lea rdx, hexbuf[rip]
mov r8, 384
mov r9, 0
mov qword ptr [rsp+32], r9
call WriteFile
mov rcx, [handle+rip]
lea rdx, newline[rip]
mov r8, newlen
mov r9, 0
mov qword ptr [rsp+32], r9
call WriteFile
add rsp, 56
pop rbp
ret
