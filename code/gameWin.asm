GameWin:
	
	# Verifica se a flag de vitoria está ligada
	la t0, winFlag
	lh t0, 0(t0)
	beq t0, zero, GameWinRet
	
	DebugString("Vitoria!!!!!!!!")
	DrawImageInBothFrames(TelaDaVitoria,coordsMap)
	
	la a4, WinSong
	
	call PlaySong
	
	li a7, 10
	ecall
	
	GameWinRet: ret
