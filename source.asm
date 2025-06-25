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
tab_str: dq `\t`, 0					; Tab
fmt: dq ` %lld\t`, 5, 0				; Default format
fmt_a: dq `\[%lld\]\t`, 5, 0		; Format of array number print
fmt_m: dq `(%lld)\t`, 5, 0			; Format of match found
fmt_in: dq "%lld", 0
nl: db "", 5, 0
msg_in: dq "Insira 5 números inteiros: ", 5, 0
msg_out: dq "A máxima subcadeia comum tem %lld números.", 5, 0

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

mov RDI, msg_in
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
	mov RDI, msg_in
	call printf

INPUT_ARRAY2:
	cmp RCX, [size]
	mov RDI, nl
	jz PREP_LINE
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

PREP_LINE:							; Reinicializa
	mov RAX, 0
	mov RCX, 0

INIT_MATRIX_LINE: 					; Inicializa a primeira linha com 0
	cmp RCX, [m_size]
	jge PREP_COL
	mov RAX, 0
	mov [matrix+RCX*8], RAX
	inc RCX
	jmp INIT_MATRIX_LINE

PREP_COL:							; Reinicializa
	mov RAX, 0
	mov RCX, 0

INIT_MATRIX_COL: 					; Inicializa a primeira coluna com 0
	cmp RCX, [m_size]
	jge PREP_HEADER
	mov RAX, 0
	mov [matrix+RCX*8], RAX
	mov RCX, [m_size]
	jmp INIT_MATRIX_COL

PREP_HEADER:						; Reinicializa
	mov RDI, br_str
	call printf
	mov RDI, tab_str
	call printf

	mov RAX, 0
	mov RCX, 0
	mov RBX, 0

HEADER: 							; Faz o print do header da matriz
	cmp RCX, [size]
	jge PREP_MATRIX
	mov [cnt], RCX
	mov RDI, fmt_a
	mov RSI, [array2+RCX*8]
	call printf
	mov RCX, [cnt]
	inc RCX
	jmp HEADER

PREP_MATRIX:						; Reinicializa
	mov RDI, br_str
	call printf

	mov RAX, 0
	mov RCX, 1
	mov RBX, 1

OUT_LOOP:							; Loop externo, varre o primeiro array (equivale às linhas)
	cmp RBX, [m_size]
	jge END
	mov [cnt], RCX
	mov R14, RBX
	sub R14, 1
	mov RDI, fmt_a
	mov RSI, [array+R14*8]
	call printf
	mov RCX, [cnt]

IN_LOOP:							; Loop interno, varreo segundo array (equivale às colunas)
	cmp RCX, [m_size]
	jge END_INNER_MATRIX

	mov RAX, [m_size]				; Recebe o tamanho da matriz
	; R12 = i-1
	mov R12, RBX					; Guarda o index da linha em R12
	sub R12, 1						; Subtrai 1
	mul R12							; Multiplica o tamanho pelo index
	shl RAX, 3						; Multiplica por 8 (shift de 3 bits)
	mov R12, RAX
	; R13 = j-1
	mov R13, RCX
	sub R13, 1
	shl R13, 3

	; Se array[rbx - 1] = array[rcx - 1]
	mov R14, RBX
	sub R14, 1
	mov R15, RCX
	sub R15, 1
	mov R14, [array+R14*8]
	mov R15, [array2+R15*8]
	cmp R14, R15
	jz MATCH

	; Se m[i, j-1] > m[i-1, j]
	mov RAX, [m_size]
	mul RBX
	shl RAX, 3
	mov R14, [matrix+RAX+R13]
	mov R15, [matrix+R12+RCX*8]
	cmp R14, R15
	jg LINE_GREATER

	; Senão
	mov [matrix+RAX+RCX*8], R15
	mov R14, R15
	jmp PRINT

MATCH:
	mov RAX, [m_size]
	mul RBX
	shl RAX, 3
	mov R14, [matrix+R12+R13]
	add R14, 1						; Adiciona + 1 pois deu match
	mov [matrix+RAX+RCX*8], R14
	jmp MATCH_PRINT

MATCH_PRINT:
	mov [cnt], RCX
	mov RDI, fmt_m
	mov RSI, R14
	call printf
	mov RCX, [cnt]
	inc RCX
	jmp IN_LOOP

LINE_GREATER:
	mov [matrix+RAX+RCX*8], R14
	jmp PRINT

PRINT:
	mov [cnt], RCX
	mov RDI, fmt
	mov RSI, R14
	call printf
	mov RCX, [cnt]
	inc RCX
	jmp IN_LOOP

END_INNER_MATRIX:					; Fim do loop interno, faz uma quebra de linha
	mov RDI, br_str
	call printf
	inc RBX
	mov RCX, 1
	jmp OUT_LOOP

END:
	mov RDI, br_str
	call printf

	mov RAX, [m_size]
	mul RAX
	sub RAX, 1
	mov RDI, msg_out
	mov RSI, [matrix+RAX*8]
	call printf

	mov RDI, br_str
	call printf
	
	mov RAX, 0
	mov RBX, 0
	mov RCX, 0
	mov RDI, nl
	call printf
	
	pop RBP
	ret


