.data
#Global

corFundo: 	.word 0x0			# cor do tile do fundo
coordsMap: 	.word 0x0			# coordenadas inicias do mapa

fuelStr:	.string "Fuel: "		# string que vai aparecer na tela
lifeStr:	.string "Lifes: "		# string que vai aparecer na tela

countingCycles: .byte 0				# ciclos para movimento de inimigos

# Constantes da fase

coordsKey0:	.word 0x00200010		# coordenadas inicias de uma chave
coordsKey1:	.word 0x00b00000		# coordenadas inicias de outra chave

#Atualizar de half para word!!!!!!!!!!!!!
coordsGate: 	.half 256, 192			# coordenadas inicias do portao

portaoLife: 	.half 3				# Quantidade de vida que o portão da fase tem
hearts:		.half 5				# quantidade de vidas que o player tem no começo do jogo
gateLife:	.half 3				# quantidade de vidas que o portão tem no começo do jogo
fuel:		.half 105			# quantidade de combustivel no começo

# Variaveis

oldEnemy1Pos:	.half 64, 64			# Posição antiga do primeiro inimigo
enemy1Pos:	.half 48, 48			# Posição do primeiro inimigo
enemy1Dir:	.half 0

oldEnemy2Pos:	.half 96, 48			# Posição antiga do primeiro inimigo
enemy2Pos:	.half 96, 48			# Posição do primeiro inimigo
enemy2Dir: 	.half 0

oldCharPos:	.half 32, 32 			# x, y
charPos:	.half 16, 16			# x, y
charDir: 	.half 0				# direção do char, Dir = 0, Cima = 1, Esq = 2, Baixo = 3

gateLifeCur:	.half 3				# vida do portao
fuelCur: 	.half 12			# quantidade de combustivel restante

heartsCur:	.half 5				# quantidade atual de vidas

decFuel:	.half 0x0			# Flag avisando para diminuir combustivel	
decHearts: 	.half 0x0			# Flag avisando para diminuir uma vida
