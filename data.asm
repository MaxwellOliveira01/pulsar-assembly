.data
#Global

corFundo: 	.word 0x0			# cor do tile do fundo
coordsMap: 	.word 0x0			# coordenadas inicias do mapa

fuelStr:	.string "Fuel: "		# string que vai aparecer na tela
lifeStr:	.string "Lifes: "		# string que vai aparecer na tela

countingCycles: .byte 0				# ciclos para movimento de inimigos

# Constantes da fase

coordsKey0:	.half 288, 16			# coordenadas inicias de uma chave
coordsKey1:	.half 16, 176			# coordenadas inicias de outra chave
coordsKey2:	.half 112, 128

#Atualizar de half para word!!!!!!!!!!!!!
coordsGate: 	.half 256, 192			# coordenadas inicias do portao

portaoLife: 	.half 6				# Quantidade de vida que o portão da fase tem
hearts:		.half 5				# quantidade de vidas que o player tem no começo do jogo
gateLife:	.half 6				# quantidade de vidas que o portão tem no começo do jogo
fuel:		.half 225			# quantidade de combustivel no começo

# Variaveis

enemy1StartPos:	.half 16, 96			# Posição do primeiro inimigo
oldEnemy1Pos:	.half 304, 224			# Posição antiga do primeiro inimigo
enemy1Pos:	.half 16, 96			# Posição do primeiro inimigo
enemy1Dir:	.half 0
enemy1Alive:	.half 1				# diz se o inimigo1 está vivo

enemy2StartPos:	.half 192, 64			# Posição do primeiro inimigo
oldEnemy2Pos:	.half 304, 224			# Posição antiga do primeiro inimigo
enemy2Pos:	.half 192, 64			# Posição do primeiro inimigo
enemy2Dir: 	.half 0
enemy2Alive:	.half 1				# diz se o inimigo2 está vivo

enemy3StartPos:	.half 192, 96			# Posição do primeiro inimigo
oldEnemy3Pos:	.half 304, 224			# Posição antiga do primeiro inimigo
enemy3Pos:	.half 192, 96			# Posição do primeiro inimigo
enemy3Dir: 	.half 0
enemy3Alive:	.half 1				# diz se o inimigo2 está vivo

enemy4StartPos:	.half 192, 96			# Posição do primeir
oldEnemy4Pos:	.half 304, 224			# Posição antiga do p
enemy4Pos:	.half 192, 96			# Posição do primeiro ini
enemy4Dir: 	.half 0
enemy4Alive:	.half 1				# diz se o inimigo2 está vivo

oldCharPos:	.half 304, 224			# x, y
charPos:	.half 16, 16			# x, y
charDir: 	.half 0				# direção do char, Dir = 0, Cima = 1, Esq = 2, Baixo = 3
charDidMove:	.half 0				# O personagem se moveu?

gateLifeCur:	.half 6				# vida do portao
fuelCur: 	.half 225			# quantidade de combustivel restante

heartsCur:	.half 5				# quantidade atual de vidas

decFuel:	.half 0x0			# Flag avisando para diminuir combustivel	
decHearts: 	.half 0x0			# Flag avisando para diminuir uma vida

shootPos:	.half 0, 0			# Posição do tiro no mapa
oldShootPos:	.half 304, 224			# Posição antiga do tiro no mapa			
shootAlive:	.half 0				# O tiro tá no mapa?
incShoot:	.half 0, 0			# Incremento em x e y para o tiro seguir a vida

shoot2Pos:	.half 0, 0			# Posição do tiro no mapa
oldShoot2Pos:	.half 304, 224			# Posição antiga do tiro no mapa			
shoot2Alive:	.half 0				# O tiro tá no mapa?
incShoot2:	.half 0, 0			# Incremento em x e y para o tiro seguir a vida

shoot4Pos:	.half 0, 0			# Posição do tiro no mapa
oldShoot4Pos:	.half 304, 224			# Posição antiga do tiro no mapa			
shoot4Alive:	.half 0				# O tiro tá no mapa?
incShoot4:	.half 0, 0			# Incremento em x e y para o tiro seguir a vida

shouldBeRedrawn:	.half 0				# decide se redesenha a fase

Fase:		.half 1					# Guarda o numero da fase que está renderizada
winFlag: 	.half 0	
