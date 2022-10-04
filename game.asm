.include "macros.asm"
.include "MACROSv21.s"
.data
.include "data.asm"

.text
	DrawImageInBothFrames(map, coordsMap)
	DrawImageInBothFrames(key00,coordsKey0)
	DrawImageInBothFrames(key01,coordsKey1)
	DrawImageInBothFrames(porta,coordsGate)
	DrawImageInBothFrames(charDireita,charPos)
	DrawImageInBothFrames(inimigo1Direita, enemy1Pos)
	DrawImageInBothFrames(inimigo2Direita, enemy2Pos)
	DrawString(fuelStr, 220, 96)
	DrawString(lifeStr, 220, 16)

GameLoop: 
# Recebe do teclado
	call Tec


Sleep()
# Desenha o personagem
	call DrawChar
# Apaga o rastro do personagem
	DrawImageInBothFrames(tile, oldCharPos)




Sleep()
# Verifica se est� na hora de mover
	la t0, countingCycles
	lb t0, 0(t0)
	bne t0, zero, NoEnemyMoving
# Atualiza a posi��o do inimigo 1
	call UpdateEnemy1
NoEnemyMoving:
Sleep()
# Desenha o inimigo 1
	call DrawEnemy1
# Apaga o rastro do inimigo 1
	DrawImageInBothFrames(tile, oldEnemy1Pos)
# Causa "dano" ao personagem
	call DamageEnemy1


Sleep()
# Processa o tiro do personagem
	call ShootProcess
# Desenha o tiro se necess�rio
	call DrawShoot
	
# Apaga o rastro do tiro se necess�rio
	DrawImageInBothFrames(tile, oldShootPos)


Sleep()
# Verifica se pode abrir o portao
	call OpenGate


Sleep()	
# Verifica a flag de combustivel
	call DecreaseFuel
Sleep()
# Verifica a flag de vida
	call DecreaseHearts
Sleep()
# Recarrega o contador de combustivel na tela
	call UpdateVisualFuel 
Sleep()
# Recarrega o contador de vida na tela
	call UpdateVisualHearts





Sleep()
# Inverte o frame
	li t0, 0xFF200604
	lh s0, 0(t0)
	xori s0, s0, 1
	sw s0, 0(t0)




Sleep()
# Sleep pro inimigo1
	la t0, countingCycles
	lb t0, 0(t0)
	addi t0, t0, 1
	li t1, 8
	rem t0, t0, t1
	la t1, countingCycles
	sb t0, 0(t1)




# Volta pro loop do jogo
	j GameLoop


.include "CharPrincipal.asm"
.include "enemy1.asm"
.include "openGate.asm"
.include "gameover.asm"
.include "hearts.asm"
.include "fuel.asm"
.include "teclado.asm"
.include "print.asm"
.include "shoot.asm"

.data
.include "sprites/tile.s"
.include "sprites/map.s"
.include "sprites/key00.s"
.include "sprites/key01.s"
.include "sprites/charCima.s"
.include "sprites/charBaixo.s"
.include "sprites/charEsquerda.s"
.include "sprites/charDireita.s"
.include "sprites/porta.s"

.include "sprites/inimigo1Baixo.s"
.include "sprites/inimigo1Cima.s"
.include "sprites/inimigo1Direita.s"
.include "sprites/inimigo1Esquerda.s"

.include "sprites/inimigo2Baixo.s"
.include "sprites/inimigo2Cima.s"
.include "sprites/inimigo2Direita.s"
.include "sprites/inimigo2Esquerda.s"

.include "sprites/shot.s"

.text
.include "SYSTEMv21.s"
