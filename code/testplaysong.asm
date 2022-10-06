	la a4, WinSong
	
	call PlaySong
	
	li a7, 10
	ecall

.data
.include "song/mario.data"

.text
.include "playsong.asm"
