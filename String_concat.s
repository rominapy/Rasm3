//*****************************************************************
//Name: 	Romina Pouya
//Program:	String_concat.s
//Class:	CS 3B
//Lab:		RASM-3

//	Concatenates the specified string "str" at the end of the string.
// 
//Input:
//@ X0: Must point to a null terminated string
//@ X1: Must point to the string that is concatenating
//@ X2: Must contains number of bytes needed for superstring
//@ LR: Must contain the return address
//@ All registers are preserved, except X0
//
//Output:
//@ X0: Returns the new updated string 
//*****************************************************************
	.global String_concat	// sets the starting point for subroutine

	.text
String_concat:
	STR x19, [SP, #-16]!	// PUSH
	STR x20, [SP, #-16]!	// PUSH
	STR x21, [SP, #-16]!	// PUSH
	STR x22, [SP, #-16]!	// PUSH
	STR x30, [SP, #-16]!	// PUSH LR

	MOV x19, x0		// copy first string address
	MOV x20, x1		// copy second string address

	BL String_length	// String_Length(s1)

	MOV x21, x0		// x21 = length(s1)
	MOV x0, x20		// x0 = s2
	BL String_length	// String_length(s2)

	ADD x21, x21, x0	// x21 = lenght(s1) + length(s2)
	ADD x21, x21, #1	// x21 = +1 (for null)

	MOV x0, x21		// x0 = length needed for memory
	BL  malloc		// allocated memory
	MOV x22, x0		// copy memeory address
concat1:
	LDRB w1, [x19], #1	// load s1[i]

	CMP w1, #0x00		// compare for null character
	B.EQ concat2		// Branch to next part if equal

	STRB w1,[x0], #1	// store char to new_string[i]
	B    concat1		// loop back

concat2:
	LDRB w1,[x20], #1	// load s2[i]
	STRB w1,[x0], #1	// store char to new_string
	CMP w1, #0x00		// compare for null character
	B.NE concat2		// branch back if not found

// finsihed

	MOV x0, x22		// x0 = new string address

	LDR x30, [SP], #16	// POP LR
	LDR x22, [SP], #16	// POP
	LDR x21, [SP], #16	// POP
	LDR x20, [SP], #16	// POP
	LDR x19, [SP], #16	// POP

	RET LR			// Return
	.end

