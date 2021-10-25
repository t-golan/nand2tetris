// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

@24576
D=A
@screenEnd
M=D

(Check)
// Check if the keyborad is pressed and set "color" in accordance
	// save the keyboard value into D
	@KBD
	D=M
	// jump to White if no key is pressed
	@White
	D;JEQ
	// else, jump to Black
	@Black
	0;JMP

(Loop)
// Go over the SCREEN memory and set it to "color", at the end jump to Check
	@SCREEN
	D=A
	@screenCounter
	M=D
	(InnerLoop)
		@color
		D=M
		@screenCounter
		A=M
		M=D
		@screenCounter
		M=M+1
		D=M
		@screenEnd
		D=M-D
		@InnerLoop
		D;JGT
		@Check
		0;JMP	
		
(Black)
// change "color" to -1 and jump to Loop
	@color
	M=-1
	@Loop
	0;JMP
	
(White)
// change "color" to 0 and jump to Loop
	@color
	M=0
	@Loop
	0;JMP
	
	
