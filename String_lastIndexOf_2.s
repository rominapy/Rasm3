  
//*****************************************************************
//Name: 	Romina Pouya
//Program:	String_lastIndexOf_2.s
//Class:	CS 3B
//Lab:		RASM-3
//Purpose:
//	Same as lastIndexOf_1 method, but it starts reach from fromIndex
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
	.global String_lastIndexOf_2

String_lastIndexOf_2:
	STR		X19, [SP, #-16]!	// Push X19
	STR		X20, [SP, #-16]!	// Push X20
	STR		X21, [SP, #-16]!	// Push X21
	STR		LR, [SP, #-16]!		// Push LR

	MOV		X19, X1			// Copy char to X19
	MOV		X1, #0			// Set beginIndex
						// X2 has endIndex
	BL		substring1		// Create substring with dynamic memory
	MOV		X20, X0			// Copy addreess of dyn alloc string so we don't lose it
	MOV		X1, X19			// Copy char back to X1

	BL		String_lastIndexOf_1	// Get last index of new substring
	MOV		X21, X0			// Copy index to X21 so we don't lose it

	MOV		X0, X20			// Load the dyn allocated string to X0
	BL		free			// Free the dynamically allocated mem

	MOV		X0, X21			// Copy index back to X0 for return

	LDR		LR, [SP], #16		// Pop LR
	LDR		X21, [SP], #16		// Pop X21
	LDR		X20, [SP], #16		// Pop X20
	LDR		X19, [SP], #16		// Pop X19

	RET					// Return to calling fcn

	.end
	