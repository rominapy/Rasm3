  //*****************************************************************
//Name: 	Romina Pouya
//Program:	String_indexOf_3
//Class:	CS 3B
//Lab:		RASM-3
//Purpose:
//	This method returns the index of first occurrence of specified
// substring str.
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
	.global String_indexOf_3

String_indexOf_3:
	STR	X19, [SP, #-16]!	// Push X19
	STR	X20, [SP, #-16]!	// Push X20
	STR	X21, [SP, #-16]!	// Push X21
	STR	X22, [SP, #-16]!	// Push X22
	STR	X23, [SP, #-16]!	// Push X23
	STR	LR, [SP, #-16]!		// Push LR

	MOV	X19, X0			// Copy string
 	MOV	X20, X1			// Copy substring
 	MOV	X21, #0			// init i = 0
	MOV	X22, #0			// init j = 0

	LDRB	W2, [X20]		// Get base address of substring

Loop:
// Find where a matching character i
	LDRB 	w1, [x19, x21]		// load string[i]
	CMP	w1, #0x00		// compare for null
	BEQ	NOT_FOUND		// branch if found

	CMP	w1, w2			// compare string[i] and sub[i]
	ADD 	x21, x21, #1		// i++
	BNE	Loop			// branch back to loop

compare:
	LDRB	w1, [x19, x21]		// string[i]
	LDRB	w2, [x20, x22]		// sub[j]

	CMP	w2, #0x00		// check for null on substring
	BEQ	FOUND			// branch if found

	ADD 	x21, x21, #1		// i++
	ADD	x22, x22, #1		// j++

	CMP	w1, w2			// compare string[i] and sub[j]
	BEQ	compare			// branch back if equal

	LDRB	w2, [x20]		// w2 = sub[0]
	SUB	x21, x21, x22		// i = i - j
	ADD	x21, x21, #1		// i++
	MOV	x22, #1			// j = 1
	BNE	Loop

NOT_FOUND:
	MOV	X0, #-1			// Return -1 if not found
	B	END			// Branch to end

FOUND:
	SUB	X0, X21, x22		// x0 = i - j

END:
	LDR	LR, [SP], #16		// Pop LR
	LDR	X23, [SP], #16		// Pop X23
	LDR	X22, [SP], #16		// Pop X22
	LDR	X21, [SP], #16		// Pop X21
	LDR	X20, [SP], #16		// Pop X20
	LDR	X19, [SP], #16		// Pop X19
	RET

	.end

