# Reinicia os dados
Reinitialize:
	la t0, countingCycles
	li t1, 0
	sb t1, 0(t0)
	
	la t0, shouldBeRedrawn
	li t1, 0
	sh t1, 0(t0)
	
	la t0, portaoLife
	li t1, 3
	sb t1, 0(t0)
	
	la t0, gateLifeCur
	la t1, gateLife
	lh t1, 0(t1)
	sb t1, 0(t0)

	la t0, fuelCur
	la t1, fuel
	lb t1, 0(t1)
	sb t1, 0(t0)

	la t0, oldEnemy1Pos
	li t1, 304
	sh t1, 0(t0)
	li t1, 224
	sh t1, 2(t0)
	
	la t0, enemy1Pos
	la t1, enemy1StartPos
	lw t1, 0(t1)
	sw t1, 0(t0)
	
	la t0, enemy1Dir
	li t1, 0
	sb t1, 0(t0)
	
	la t0, enemy1Alive
	li t1, 1
	sb t1, 0(t0)
	
	la t0, oldEnemy3Pos
	li t1, 304
	sh t1, 0(t0)
	li t1, 224
	sh t1, 2(t0)
	
	la t0, enemy3Pos
	la t1, enemy3StartPos
	lw t1, 0(t1)
	sw t1, 0(t0)
	
	la t0, enemy3Dir
	li t1, 0
	sb t1, 0(t0)
	
	la t0, enemy3Alive
	li t1, 1
	sb t1, 0(t0)

	
	la t0, oldEnemy2Pos
	li t1, 304
	sh t1, 0(t0)
	li t1, 224
	sh t1, 2(t0)

	la t0, enemy2Pos
	la t1, enemy2StartPos
	lw t1, 0(t1)
	sw t1, 0(t0)
	
	la t0, enemy2Dir
	li t1, 0
	sb t1, 0(t0)
	
	la t0, enemy2Alive
	li t1, 1
	sb t1, 0(t0)
	
	la t0, oldCharPos
	li t1, 304
	sh t1, 0(t0)
	li t1, 224
	sh t1, 2(t0)
	
	la t0, charPos
	li t1, 16
	sh t1, 0(t0)
	li t1, 16
	sh t1, 2(t0)
	
	la t0, charDir
	li t1, 0
	sb t1, 0(t0)
	
	la t0, charDidMove
	li t1, 0
	sb t1, 0(t0)
	
	la t0, decFuel
	li t1, 0
	sb t1, 0(t0)
	
	la t0, decHearts
	li t1, 0
	sb t1, 0(t0)

	la t0, oldShootPos
	li t1, 304
	sh t1, 0(t0)
	li t1, 224
	sh t1, 2(t0)
	
	la t0, shootPos
	li t1, 0
	sh t1, 0(t0)
	li t1, 0
	sh t1, 2(t0)
	
	la t0, shootAlive
	li t1, 0
	sb t1, 0(t0)
	
	la t0, incShoot
	li t1, 0
	sh t1, 0(t0)
	li t1, 0
	sh t1, 2(t0)
	
	la t0, oldShoot2Pos
	li t1, 304
	sh t1, 0(t0)
	li t1, 224
	sh t1, 2(t0)
	
	la t0, shoot2Pos
	li t1, 0
	sh t1, 0(t0)
	li t1, 0
	sh t1, 2(t0)
	
	la t0, shoot2Alive
	li t1, 0
	sb t1, 0(t0)
	
	la t0, incShoot2
	li t1, 0
	sh t1, 0(t0)
	li t1, 0
	sh t1, 2(t0)

	j TrampolimRedraw
