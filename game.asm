.include "macros.asm"
.include "code/MACROSv21.s"
.data
.include "data.asm"

.text

# Inicia e desenha o sussar no frame 0
	la a0, TelaInicial
	li a1, 0
	li a2, 0
	li a3, 0
	call Print

# Desenha o menu de instrucoes no frame 1
	la a0, MenuDeInstrucoes
	li a1, 0
	li a2, 0
	li a3, 1
	call Print

# Toca a primeira parte de AmogusDrip
	la a4, AmogusDrip
	call PlaySong

# Troca de frame
	li t0, 0xFF200604
	lh s0, 0(t0)
	xori s0, s0, 1
	sw s0, 0(t0)
	
# Toca a segunda parte de AmogusDrip
	la a4, AmogusDrip2
	call PlaySong



# Loop de espera para iniciar o jogo
LoopDeEsperaInicial:
	li t1,0xFF200000			# carrega o endereco de controle do KDMMIO
	lw t0,0(t1)				# Le bit de Controle Teclado
	andi t0,t0,0x0001			# mascara o bit menos significativo
   	beq t0,zero,LoopDeEsperaInicial      	# Se nao ha tecla pressionada espera
  	lw t1,4(t1)  				# le o valor da tecla tecla
	
	li t0, 'j'
	bne t1, t0, LoopDeEsperaInicial

	la a4, DeadBody
	call PlaySong


Redraw:

# Verifica se estamos na fase 1 ou 2 para desenhar o mapa certo

	la t0, Fase
	lh t0, 0(t0)
	li t1, 1
	bne t0, t1, DrawMap2
	
	DrawImageInBothFrames(map, coordsMap)	
	
	j RedrawContinue
	
DrawMap2:
	
	DrawImageInBothFrames(map2, coordsMap)
	
RedrawContinue:
	DrawString(fuelStr, 220, 96)
	DrawString(lifeStr, 220, 16)
	DrawImageInBothFrames(key00,coordsKey0)
	DrawImageInBothFrames(key01,coordsKey1)
	DrawImageInBothFrames(key02,coordsKey2)
	DrawImageInBothFrames(porta,coordsGate)
	DrawImageInBothFrames(charDireita,charPos)
	DrawImageInBothFrames(inimigo1Direita, enemy1Pos)
	DrawImageInBothFrames(inimigo2Direita, enemy2Pos)
	DrawImageInBothFrames(inimigo3Direita, enemy3Pos)
	#DrawImageInBothFrames(inimigo4Direita, enemy4Pos)

GameLoop: 
# Recebe do teclado
	call Tec

# Verifica se o personagem se moveu
	la t0, charDidMove
	lb t1, 0(t0)
	beq t1, zero, NoCharMoving
	sb zero, 0(t0)
# Desenha o personagem
	call DrawChar
# Apaga o rastro do personagem
	DrawImageInBothFrames(tile, oldCharPos)
NoCharMoving:


# Verifica se est� na hora de mover
	la t0, countingCycles
	lb t0, 0(t0)
	bne t0, zero, NoEnemyMoving
	
	
# Atualiza a posi��o do inimigo 1
	call UpdateEnemy1
# Desenha o inimigo 1
	call DrawEnemy1
# Apaga o rastro do inimigo 1
	DrawImageInBothFrames(tile, oldEnemy1Pos)
# Realoca a posi��o anterior do inimigo 1 para fora do mapa
	call HideOldEnemy1Pos


# Atualiza a posi��o do inimigo 2
	call UpdateEnemy2
# Desenha o inimigo 2
	call DrawEnemy2
# Apaga o rastro do inimigo 2
	DrawImageInBothFrames(tile, oldEnemy2Pos)
# Realoca a posi��o anterior do inimigo2 para fora do mapa
	call HideOldEnemy2Pos


	call UpdateEnemy3
# Desenha o inimigo 3
	call DrawEnemy3
# Apaga o rastro do inimigo 3
	DrawImageInBothFrames(tile, oldEnemy3Pos)
# Realoca a posi��o anterior do inimigo3 para fora do mapa
	call HideOldEnemy3Pos
	
	
	#call UpdateEnemy4
# Desenha o inimigo 4
	#call DrawEnemy4
# Apaga o rastro do inimigo 4
	#DrawImageInBothFrames(tile, oldEnemy4Pos)
# Realoca a posi��o anterior do inimigo3 para fora do mapa
	#call HideOldEnemy4Pos

NoEnemyMoving:

# Causa "dano" ao personagem
	call DamageEnemy1
# Causa "dano" ao personagem
	call DamageEnemy2
# Causa "dano" ao personagem
	call DamageEnemy3
# Causa "dano" ao personagem
	#call DamageEnemy4


# Processa o tiro do personagem
	call ShootProcess
# Desenha o tiro se necess�rio
	call DrawShoot
# Apaga o rastro do tiro se necess�rio
	DrawImageInBothFrames(tile, oldShootPos)
# Realoca a posi��o anterior do tiro para fora do mapa
	call HideOldShootPos


# Inicia o processo do tiro2
	call SetupShoot2
# Processa o tiro2
	call Shoot2Process
# Desenha o tiro se necess�rio
	call DrawShoot2
# Apaga o rastro do tiro se necess�rio
	DrawImageInBothFrames(tile, oldShoot2Pos)
# Realoca a posi��o anterior do tiro para fora do mapa
	call HideOldShoot2Pos


# Inicia o processo do tiro4
	#call SetupShoot4
# Processa o tiro4
	#call Shoot4Process
# Desenha o tiro se necess�rio
	#call DrawShoot4
# Apaga o rastro do tiro se necess�rio
	#DrawImageInBothFrames(tile, oldShoot4Pos)
# Realoca a posi��o anterior do tiro para fora do mapa
	#call HideOldShoot4Pos



# Verifica se pode abrir o portao
	call OpenGate


# Verifica a flag de combustivel
	call DecreaseFuel
# Verifica a flag de vida
	call DecreaseHearts
# Recarrega o contador de combustivel na tela
	call UpdateVisualFuel 
# Recarrega o contador de vida na tela
	call UpdateVisualHearts

# Verifica se o jogador conseguiu passar de fase
	call NextMap
	
# Verifica se o jogador ganhou o jogo
	call GameWin

# Inverte o frame
	li t0, 0xFF200604
	lh s0, 0(t0)
	xori s0, s0, 1
	sw s0, 0(t0)


# Conta os ciclos
	la t0, countingCycles
	lb t0, 0(t0)
	addi t0, t0, 1
	li t1, 8
	rem t0, t0, t1
	la t1, countingCycles
	sb t0, 0(t1)

# Redesenha se necess�rio
	la t0, shouldBeRedrawn
	lb t0, 0(t0)
	bne t0, zero, TrampolimReinitialize

# Volta pro loop do jogo
	j GameLoop

	
.include "code/CharPrincipal.asm"
.include "code/enemy1.asm"
.include "code/enemy2.asm"
.include "code/enemy3.asm"
#.include "enemy4.asm"

.include "code/openGate.asm"
.include "code/gameover.asm"
.include "code/hearts.asm"

TrampolimReinitialize: j Reinitialize
TrampolimRedraw: j Redraw

.include "code/fuel.asm"
.include "code/teclado.asm"
.include "code/print.asm"
.include "code/shoot.asm"
.include "code/shoot2.asm"
#.include "shoot4.asm"
.include "code/nextMap.asm"
.include "code/gameWin.asm"
.include "code/reinitialize.asm"
.include "code/playsong.asm"
.include "code/useCheat.asm"

.data
.include "sprites/tile.s"
.include "sprites/key00.s"
.include "sprites/key01.s"
.include "sprites/key02.s"
.include "sprites/amogusRedTras.data"
.include "sprites/amogusRedFrente.data"
.include "sprites/amogusRedEsquerda.data"
.include "sprites/amogusRedDireita.data"
.include "sprites/porta.s"

.include "sprites/amogusGreenTras.data"
.include "sprites/amogusGreenFrente.data"
.include "sprites/amogusGreenEsquerda.data"
.include "sprites/amogusGreenDireita.data"

.include "sprites/amogusWhiteTras.data"
.include "sprites/amogusWhiteFrente.data"
.include "sprites/amogusWhiteEsquerda.data"
.include "sprites/amogusWhiteDireita.data"

#.include "sprites/amogusBlueTras.data"
#.include "sprites/amogusBlueFrente.data"
#.include "sprites/amogusBlueEsquerda.data"
#.include "sprites/amogusBlueDireita.data"

.include "sprites/amogusYellowTras.data"
.include "sprites/amogusYellowFrente.data"
.include "sprites/amogusYellowEsquerda.data"
.include "sprites/amogusYellowDireita.data"

.include "sprites/mapData.s"
.include "sprites/mapData2.s"
.include "sprites/shot.s"

.include "sprites/gameover.data"
.include "sprites/sussar.data"
.include "sprites/instrucoes.data"
.include "sprites/win.data"

.include "song/amogusdrip.data"
.include "song/amogusdrip2.data"
.include "song/deadbody.data"
.include "song/mario.data"

.text
.include "code/SYSTEMv21.s"
