// This file is part of nand2tetris, as taught in The Hebrew University,
// and was written by Aviv Yaish, and is published under the Creative 
// Common Attribution-NonCommercial-ShareAlike 3.0 Unported License 
// https://creativecommons.org/licenses/by-nc-sa/3.0/

// An implementation of a sorting algorithm. 
// An array is given in R14 and R15, where R14 contains the start address of the 
// array, and R15 contains the length of the array. 
// You are not allowed to change R14, R15.
// The program should sort the array in-place and in descending order - 
// the largest number at the head of the array.
// You can assume that each array value x is between -16384 < x < 16384.
// You can assume that the address in R14 is at least >= 2048, and that 
// R14 + R15 <= 16383. 
// No other assumptions can be made about the length of the array.
// You can implement any sorting algorithm as long as its runtime complexity is 
// at most C*O(N^2), like bubble-sort. 


// Put the first address of the array in "startIndex", set the "endIndex", ans set the "isSwapped" to 1 for starting the sort
@R14
D=M
@startIndex
M=D
@R15
D=D+M
@endIndex
M=D
@isSwapped
M=1
 
(firstLoop)
// Check if there is need for another round of switches, and reset the rellevant variables
	// Check if the length of the array is 0 or 1, and jump to END if so
	@R15
	D=M-1
	@END
	D;JLE
	
	// Check if the sort ended, and jump to END if so
	@isSwapped
	D=M
	@END
	D;JEQ
	
	// If there is another round to go, set the "isSwapped" to 0
	@isSwapped
	M=0
	// Set the start to the start of the array
	@R14
	D=M
	@startIndex
	M=D
	// Jump to the second loop
	@secondLoop
	0;JMP

(secondLoop)
	// If startIndex = endIndex go back to firstLoop, otherwise continue 
	@startIndex
	D=M
	@endIndex
	D=M-D
	@firstLoop
	D;JEQ
	
	// Set currentIndex = startIndex
	@startIndex
	D=M
	@currentIndex
	M=D
	@thirdLoop
	0;JMP
		
(thirdLoop)
	// If currentIndex = endIndex-1, jump to GoBackToSec 
	@endIndex
	D=M-1
	@currentIndex
	D=D-M
	@GoBackToSec
	D;JEQ
	
	// If currentIndex < endIndex:
	
	// Put array[currentIndex] in D
	@currentIndex
	A=M
	D=M
	
	// Put [currentIndex+1]-[currentIndex] in D
	@currentIndex
	A=M+1
	D=M-D
		
	// If array[currentIndex] < array[currentIndex + 1], jump to Swap
	@Swap
	D;JGT

	(Continue)
	// Add 1 to currentIndex and jump to the start of thirdLoop
		@currentIndex
		M=M+1
		@thirdLoop
		0;JMP
	
(Swap)
// Swap array[currentIndex] with array[currentIndex + 1], add jump to continue
	// Save array[currentIndex] in temporary
	@currentIndex
	A=M
	D=M
	@temporary
	M=D
	
	//Save array[currentIndex+1] in array[currentIndex]
	@currentIndex
	A=M+1
	D=M
	@currentIndex
	A=M
	M=D
	
	// Save temporary in array[currentIndex+1]
	@temporary
	D=M
	@currentIndex
	A=M+1
	M=D
	
	// Set isSwapped to 1
	@isSwapped
	M=1
	
	@Continue
	0;JMP
		
(GoBackToSec)
	// Add 1 to "startIndex" and go back to secondLoop, otherwise continue
	@startIndex
	M=M+1
	@secondLoop
	0;JMP

(END)
	@END
	0;JMP
