

// String_charAt subtroutine: Takes a null terminated string and an index
//  position, and returns the char at the index in hex. If index is outside
//  the string, then a 0 is returned.
//
//  x0 must contain a null terminate string
//  x1 must contain the index of the character requested
//  LR must contain returning address
//
//  ALL AAPCS registers are perserved.
//  Returns results back to x0

	.global charAt		// sets starting point of subroutine

	.text
charAt:
	STR x19, [SP, #-16]!	// PUSH
	STR x30, [SP, #-16]!	// PUSH LR

	MOV x19, x0		// x19 = copy of string
	BL  String_length	// calculates string length

	CMP  x1, x0		// compare index to string length
	B.GT invalid		// branch if greater than

	CMP  x1, #0		// compare index to 0
	B.LT invalid		// branch if less than

// else load char
	LDRB w0,[x19,x1]	// load byte of string[index]
	B    finish		// brnach to finished

invalid:
	MOV x0, #0		// x0 = 0 if invalid index

finish:
	LDR x30, [SP], #16	// POP
	LDR x19, [SP], #16	// POP LR

	RET LR			// return
	.end
    