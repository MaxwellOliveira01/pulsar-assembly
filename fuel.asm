
UpdateVisualFuel:
# Apagar at� 3 digitos do numero anterior
# Podemos substituir esse bloco de codigo por apenas um for, bem mais elegante
# A ideia � desenhar dois tiles pra apapagar os digitos	
	la a0, tile
	li a1, 144
	li a2, 220
	li a3, 0xFF200604
	lh a3, 0(a3)
	xori a3, a3, 1
	
	PRINT()
	
	la a0, tile
	li a1, 160
	li a2, 220
	li a3, 0xFF200604
	lh a3, 0(a3)
	xori a3, a3, 1	
	
	PRINT()	
	
# Numero a ser printado
	la a0, fuelCur
	lh a0, 0(a0)
	
# Coluna e linha
	li a1, 144
	li a2, 220
# Cor do texto
	li a3, 0x0FF
# Frame
	li a4, 0xFF200604
	lh a4, 0(a4)
	xori a4, a4, 1
# Ecall
	li a7, 101
	
	ecall
	
	ret

DecreaseFuel:
	
# Verifica a flag para diminuir
	la t0, decFuel
	lh t1, 0(t0)	
	beqz t1, DecreaseFuelRet
# Seta a flag para zero
	sw zero, 0(t0)
	
# Diminue um do combustivel
	la t0, fuelCur
	lh t1, 0(t0)
	addi t1, t1, -1
	sh t1, 0(t0)
	
	bgt t1, zero, DecreaseFuelRet
# Se o combustivel for 0 -> ativa flag para diminuir uma vida		
	la t0, decHearts
	li t1, 1
	sh t1, 0(t0)
	DecreaseFuelRet: ret
