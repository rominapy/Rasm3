// ----------- String_copy() ----------
//————————————————————————————————————————
// Programmer: Melina Pouya
// CS3B - Fall 2024
// String_copy allocates memory in heap to create a copy of a provided null-terminated string
// Returns the address of the new string.
//
// Prereq: x0 must contain a null-terminated string
//         LR must contain the return address
//         All AAPCS mandated registers are preserved.
// Return: x0 contains the address of the new string
// ————————————————————————————————————————

	.global String_copy	// set starting point of subroutine

	.text
String_copy:
	STR x19, [SP, #-16]!	// Push
	STR x20, [SP, #-16]!	// Push
	STR x21, [SP, #-16]!	// Push
	STR x30, [SP, #-16]!	// Push LR

	MOV x19, x0		// x19 = Original String
	BL String_length	// calculates string_length
	ADD x0,x0,#1		// add 1 to length to account for null
	BL malloc		// creates pointer to allocated memory in heap

	MOV x21, x0		// x21 = ptr to memory in heap
copy:
	LDRB w20, [x19], #1	// w20 = char str[i]
	STRB w20, [x0], #1	// store str[i] in new string

	CMP w20, #0x00		// check for null character
	B.NE copy		// loop back if not found

	MOV x0, x21		// x0 = ptr to new string

	LDR x30, [SP], #16	// POP LR
	LDR x21, [SP], #16	// POP
	LDR x20, [SP], #16	// POP
	LDR x19, [SP], #16	// POP
	RET LR			// Return

.end

