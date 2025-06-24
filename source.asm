; Algoritmo para encontrar a máxima subcadeia comum entre dois arrays de inteiros com tamanho 5

; Comandos para compilação (em linux 64-bits)
; nasm -felf64 source.asm
; gcc -no-pie source.o -o max-subcadeia
;./max-subcadeia

segment .data
a: dq 0
cnt: dq 0
fmt: dq "%lld ",10, 0
fmt_in: dq "%lld", 0
fmt_out: dq "The sorted array is: ", 10, 0
nl: db "", 10, 0
msg: dq "Enter 10 values (positive/negative): ", 10, 0

segment .bss
array resq 11
array2 resq 11
matrix resq 21

segment .text
global main
extern printf
extern scanf

main:
push RBP

mov RDI, msg
call printf
	
mov RAX, 0
mov RCX, 0
mov RBX, 0

INPUT_ARRAY: 						;Take input as aarray - 10 values
	cmp RCX, 10						; check if 10 input given or not
	mov RDI, nl
	jz DONE							; go to done after complete input
	mov [cnt], RCX
	mov RAX, 0
	mov RDI, fmt_in
	mov RSI, a
	call scanf
	mov RAX, [a]
	mov RCX, [cnt]
	mov [array+RCX*8], RAX
	inc RCX
	jmp INPUT_ARRAY

DONE:								; reinitialize
	mov RAX, 0
	mov RCX, 0
	mov RBX, 0	

OUT_LOOP:							;reordered values from end_loop in output array
	cmp RCX, 10
	jge END_LOOP
	mov [cnt], RCX
	mov RAX, [array+RCX*8]

IN_LOOP:							;sort input arrays
	inc RCX
	cmp RCX, 10
	jz OK 
	cmp RAX, [array+RCX*8]		
	jle IN_LOOP		
	xchg RAX, [array+RCX*8]			; swap position of values in the array -selection sort-
	jmp IN_LOOP

OK:									;End Loop of input -->go to output loop
	mov RCX, [cnt]
	mov [array+RCX*8], RAX
	inc RCX
	jmp OUT_LOOP

END_LOOP:
	mov RAX, 0
	mov RBX, 0
	mov RCX, 0
	mov RDI, fmt_out
	call printf
	mov RAX, 0
	mov RBX, 0
	mov RCX, 0
	mov RDI, nl
	call printf
	mov RAX, 0
	mov RBX, 0
	mov RCX, 0		

PRINT_ARRAY:						;Print array
	cmp RCX, 10
	jz END
	mov RDI, nl
	mov RAX, [array+RCX*8]			;move pointer to next position
	inc RCX	
	mov [cnt], RCX
	mov RDI, fmt
	mov RSI, RAX
	call printf
	mov RCX, [cnt]
	jmp PRINT_ARRAY


END:	
	mov RDI, nl
	call printf
	mov RAX, 0
	mov RBX, 0
	mov RCX, 0
	
	pop RBP
	ret