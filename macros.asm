.macro DrawImageInBothFrames(%imgName, %coordsName)
	la a0, %imgName
	la t0, %coordsName
	lh a1, 0(t0)
	lh a2, 2(t0)
	li a3, 0
	call Print
	li a3, 1
	call Print
.end_macro

.macro Sleep()	
	li a0, 0
	li a7, 32
	ecall
.end_macro

.macro DrawImageInHiddenFrame(%address, %coordsAddress)
	la a0, %address
	la t0, %coordsAddress
	lh a1, 0(t0)
	lh a2, 2(t0)
	li a3, 0xFF200604
	lw a3, 0(a3)
	xori a3, a3, 1
	call Print
.end_macro

.macro DrawString(%address, %x, %y)
	la a0, %address
	li a1, %y
	li a2, %x
	li a3, 0x0FF
	li a4, 0xFF200604
	lh a4, 0(a4)
	li a7, 104
	ecall
	
	la a0, %address
	li a1, %y
	li a2, %x
	li a3, 0x0FF
	li a4, 0xFF200604
	lh a4, 0(a4)
	xori a4, a4, 1
	li a7, 104
	ecall
.end_macro

.macro DebugInt(%msg, %label)

.data
	QUEBRA: .string  "\n"
	MSG: 	.string %msg
.text
	
	li a7, 4
	la a0, MSG
	ecall

	li a7, 1
	la a0, %label
	lh a0, 0(a0)
	ecall
	
	li a7, 4
	la a0, QUEBRA
	ecall
	
.end_macro

.macro DebugInt(%reg)

.data
	QUEBRA: .string  "\n"
.text

	li a7, 1
	mv a0, %reg
	ecall
	
	li a7, 4
	la a0, QUEBRA
	ecall
	
.end_macro

.macro DebugString(%label)

.data
	QUEBRA: .string  "\n"
	MSG: 	.string %msg
.text
	li a7, 4
	la a0, MSG
	ecall
	la a0, QUEBRA
	ecall
.end_macro

#################################################
#	a0 = endereço imagem			#
#	a1 = x					#
#	a2 = y					#
#	a3 = frame (0 ou 1)			#
#################################################
#	t0 = endereco do bitmap display		#
#	t1 = endereco da imagem			#
#	t2 = contador de linha			#
# 	t3 = contador de coluna			#
#	t4 = largura				#
#	t5 = altura				#
#################################################

.macro PRINT()
	li t0,0xFF0			# carrega 0xFF0 em t0
	add t0,t0,a3			# adiciona o frame ao FF0 (se o frame for 1 vira FF1, se for 0 fica FF0)
	slli t0,t0,20			# shift de 20 bits pra esquerda (0xFF0 vira 0xFF000000, 0xFF1 vira 0xFF100000)
	add t0,t0,a1			# adiciona x ao t0
	li t1,320			# t1 = 320
	mul t1,t1,a2			# t1 = 320 * y
	add t0,t0,t1			# adiciona t1 ao t0
	addi t1,a0,8			# t1 = a0 + 8
	mv t2,zero			# zera t2
	mv t3,zero			# zera t3
	lw t4,0(a0)			# carrega a largura em t4
	lw t5,4(a0)			# carrega a altura em t5
PRINT_LINHA:	
	lw t6,0(t1)			# carrega em t6 uma word (4 pixeis) da imagem
	sw t6,0(t0)			# imprime no bitmap a word (4 pixeis) da imagem
	addi t0,t0,4			# incrementa endereco do bitmap
	addi t1,t1,4			# incrementa endereco da imagem
	addi t3,t3,4			# incrementa contador de coluna
	blt t3,t4,PRINT_LINHA		# se contador da coluna < largura, continue imprimindo
	addi t0,t0,320			# t0 += 320
	sub t0,t0,t4			# t0 -= largura da imagem
	# ^ isso serve pra "pular" de linha no bitmap display
	mv t3,zero			# zera t3 (contador de coluna)
	addi t2,t2,1			# incrementa contador de linha
	bgt t5,t2,PRINT_LINHA		# se altura > contador de linha, continue imprimindo
.end_macro
