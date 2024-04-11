  //*****************************************************************
//Name: 	Romina Pouya
//Program:	String_replace.s
//Class:	CS 3B
//Lab:		RASM-3
//Purpose:
//	It returns the new update string after changing all the occurrences
// of oldChar with newChar
// 
//Input:
//@ X0: Must point to a null terminated string
//@ X1: Must point to oldChar
//@ X2: Must point to newChar
//@ X3: Must contains number of bytes needed for string
//@ LR: Must contain the return address
//@ All registers are preserved, except X0
//
//Output:
//@ X0: Returns the new updated string 
//*****************************************************************
	.global String_replace	// set starting point for subroutine

	.text

String_replace:
	STR x20, [SP, #-16]!	// PUSH
	STR x21, [SP, #-16]!	// PUSH
	STR x30, [SP, #-16]!	// PUSH

	MOV x19, #0		// i = 0
compare:
	LDRB w20, [x0, x19]	// load string[i]

	CMP  x20, #0x00		// check for null
	B.EQ finished		// branch if found

	CMP  w20, w1		// check for match
	B.EQ change		// branch back if not

	ADD x19, x19, #1	// i++
	B    compare		// branch back

change:
	STRB w2, [x0, x19]	// store new letter
	ADD  x19, x19, #1	// i++
	B    compare		// brnach back

finished:
	LDR x30, [SP], #16	// POP LR
	LDR x21, [SP], #16	// POP
	LDR x20, [SP], #16	// POP

	RET			// return
	.end
  