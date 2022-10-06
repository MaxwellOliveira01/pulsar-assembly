GameOver:
# Encerra o programa
	la a0, gameoverimg
	li a1, 0
	li a2, 0
	li a3, 0
	call Print
	
	li a3, 1
	
	call Print
	
	li a7, 10
	ecall
