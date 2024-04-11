  
//*****************************************************************
//Name: 	Romina Pouya
//Program:	String_lastIndexOf_1.s
//Class:	CS 3B
//Lab:		RASM-3
//Purpose:
//	Returns the last occurrence of the character ch in the string
// 
//Input:
//@ X0: Must point to a null terminated string
//@ X1: Must point to the character to find
//@ LR: Must contain the return address
//@ All registers are preserved, except X0
//
//Output:
//@ X0: Contains the index of where the character was found
//		(If not found X0 = -1)
//*****************************************************************

  	.text
	.global String_lastIndexOf_1

String_lastIndexOf_1:
	STR		X21, [SP, #-16]! 	// Push X21
	STR		X22, [SP, #-16]! 	// Push X22
	STR		LR, [SP, #-16]!		// Push LR

	MOV		X21, X0			// Copy string ptr to X21
	MOV		X22, X1			// Copy char to X22
	BL		String_length		// Get string length (i)
	SUB		X1, X0, #1		// Copy strlen - 1 to X1 to start at last char

LOOP:
	MOV		X0, X21			// Copy string ptr back to X0
	BL		charAt			// Get character at end
	CMP		X0, 0x00		// Check for null-terminator
	BEQ		NOT_FOUND		// Branch to NOT_FOUND
	CMP		X0, X22			// Check if X0 == X22
	BEQ		END				// Branch to END
	SUB		X1, X1, #1		// i--
	CMP		X1, #-1			// Check to see if we passed front of string
	BEQ		NOT_FOUND		// Branch to NOT_FOUND
	B		LOOP			// Branch to loop

NOT_FOUND:
	MOV		X0, #-1			// Return error code

END:
	MOV		X0, X1			// Copy index value to X0

	LDR		LR, [SP], #16		// Pop LR
	LDR		X22, [SP], #16  	// Pop X22
	LDR		X21, [SP], #16		// Pop X21

	RET

	.end
	  