  //*****************************************************************
//Name: 	Romina Pouya
//Program:	String_lastIndexOf_3.s
//Class:	CS 3B
//Lab:		RASM-3
//Purpose:
//	Returns the index of last occurrence of string str
// 
//Input:
//@ X0: Must point to a null terminated string
//@ X1: Must point to the string that is comparing
//@ LR: Must contain the return address
//@ All registers are preserved, except X0
//
//Output:
//@ X0: Contains the index of where the character was found
//		(If not found X0 = -1)
//*****************************************************************

	.text
	.global String_lastIndexOf_3

String_lastIndexOf_3:
	STR		X19, [SP, #-16]!	// Push X19
	STR		X20, [SP, #-16]!	// Push X20
	STR		X21, [SP, #-16]!	// Push X21
	STR		X22, [SP, #-16]!	// Push X22
	STR		X23, [SP, #-16]!	// Push X23
	STR		X24, [SP, #-16]!	// Push X24
	STR		LR, [SP, #-16]!		// Push LR

	MOV		X19, X0			// Copy string
	MOV		X20, X1			// Copy substring
	MOV		X21, #0			// init i = 0
	MOV		X22, #0			// init j = 0

// Check for matching char, starting at last index of string
// minus the length of substring (it cannot match before then)
	BL		String_length		// String length of string
	MOV		X23, X0			// Save string length to X23

	MOV		X0, X1			// Move substring to X0
	BL		String_length		// String length of substr in X0
	SUB		X21, X23, X0		// i = string_length - substring_length
						// string can't equal substring before until this index number
	LDRB		W2, [X20]		// Get base address of substring

Loop:
	LDRB		W1, [X19, X21]		// W1 = char of string[i]
	CMP		W1, 0x00		// Check if hit null term
	BEQ		NOT_FOUND		// Branch to NOT_FOUND

	MOV		X24, X21
	CMP		X21, #-1		// Check if we passed front of string
	BEQ		NOT_FOUND		// Branch to NOT_FOUND

	SUB		X21, X21, #1		// i --
	CMP		W1, W2			// string[i] == substring[0]
	BNE		Loop			// Branch back to LOOP

COMPARE:
	LDRB		W1, [X19, X24]		// Load string[k]
	LDRB		W2, [X20, X22]		// Load substring[j]

	CMP		W2, 0x00		// Check for null term
	BEQ		FOUND			// Branch if found

	ADD		X24, X24, #1		// k++
	ADD		X22, X22, #1		// j++

	CMP		W1, W2			// string[k] == string[j]
	BEQ		COMPARE			// Branch back to COMPARE

	LDRB		W2, [X20]		// Load substring base address
	MOV		X22, #0			// init j = 0
	BNE		Loop			// Branch back to loop

NOT_FOUND:
	MOV		X0, #-1			// Return -1 if not found
	B		END			// Branch to end

FOUND:
	SUB		X0, X24,X22		// k - j = starting index

END:
	LDR		LR, [SP], #16		// Pop LR
	LDR		X24, [SP], #16		// Pop X24
	LDR		X23, [SP], #16		// Pop X23
	LDR		X22, [SP], #16		// Pop X22
	LDR		X21, [SP], #16		// Pop X21
	LDR		X20, [SP], #16		// Pop X20
	LDR		X19, [SP], #16		// Pop X19
	RET

	.end
    
