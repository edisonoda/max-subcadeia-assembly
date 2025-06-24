; Algoritmo para encontrar o tamanho da máxima subcadeia comum entre dois arrays de inteiros com tamanho 5

; Comandos para compilação (em linux 64-bits)
; nasm -felf64 source.asm
; gcc -no-pie source.o -o max-subcadeia
;./max-subcadeia

segment .data
size: dq 5							; Define o tamanho dos arrays
m_size: dq 6						; Define o tamanho da matriz (size + 1)
in: dq 0							; Usada no input
cnt: dq 0
br_str: dq "", 0x0A, 0				; Break line
fmt: dq "%lld ", 5, 0
fmt_in: dq "%lld", 0
fmt_out: dq "The sorted array is: ", 5, 0
nl: db "", 5, 0
msg: dq "Insira 5 números inteiros: ", 5, 0

segment .bss
array resq 5
array2 resq 5
matrix resq 12						; Matrix bidimensional de tamanho 5 com +1 linha e +1 coluna

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

INPUT_ARRAY: 						; Recebe o input - 5 valores
	cmp RCX, [size]					; Verifica se os 5 valores foram dados
	mov RDI, nl
	jz ARRAY2_MSG					; Vá para o DONE depois do 5 valor
	mov [cnt], RCX
	mov RAX, 0
	mov RDI, fmt_in
	mov RSI, in
	call scanf
	mov RAX, [in]
	mov RCX, [cnt]
	mov [array+RCX*8], RAX
	inc RCX
	jmp INPUT_ARRAY

ARRAY2_MSG:
	mov RAX, 0
	mov RCX, 0
	mov RDI, msg
	call printf

INPUT_ARRAY2:
	cmp RCX, [size]
	mov RDI, nl
	jz INPUT_DONE
	mov [cnt], RCX
	mov RAX, 0
	mov RDI, fmt_in
	mov RSI, in
	call scanf
	mov RAX, [in]
	mov RCX, [cnt]
	mov [array2+RCX*8], RAX
	inc RCX
	jmp INPUT_ARRAY2

INPUT_DONE:							; Reinicializa
	mov RAX, 0
	mov RCX, 0

INIT_MATRIX_LINE: 					; Inicializa a primeira linha com 0
	cmp RCX, [m_size]
	jge LINE_DONE
	mov RAX, 0
	mov [matrix+RCX*8], RAX
	inc RCX
	jmp INIT_MATRIX_LINE

LINE_DONE:							; Reinicializa
	mov RAX, 0
	mov RCX, 0

INIT_MATRIX_COL: 					; Inicializa a primeira coluna com 0
	cmp RCX, [m_size]
	jge COL_DONE
	mov RAX, 0
	mov [matrix+RCX*8], RAX
	mov RCX, [m_size]
	jmp INIT_MATRIX_COL

COL_DONE:							; Reinicializa
	mov RAX, 0
	mov RCX, 0
	mov RBX, 0
	mov R8, 0

PRINT_OUTER_MATRIX:					; Print matrix
	cmp RBX, [m_size]
	jge END

PRINT_INNER_MATRIX:
	cmp RCX, [m_size]
	jge END_INNER_MATRIX
	mov RAX, [m_size]				; Recebe o tamanho da matriz
	mul RBX							; Multiplica o tamanho pelo index
	shl RAX, 3						; Multiplica por 8 (shift de 3 bits)
	mov RAX, [matrix+RAX+RCX*8]		; Aritmética da linha (RAX): size*tamanho*8
	inc RCX
	mov [cnt], RCX
	mov RDI, fmt
	mov RSI, RAX
	call printf
	mov RCX, [cnt]
	jmp PRINT_INNER_MATRIX

END_INNER_MATRIX:					; Fim do loop interno, faz uma quebra de linha
	mov RDI, br_str
	call printf
	inc RBX
	jmp PRINT_OUTER_MATRIX

END:
	mov RDI, nl
	call printf
	mov RAX, 0
	mov RBX, 0
	mov RCX, 0
	
	pop RBP
	ret
