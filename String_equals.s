// ----------- String_equals() -------------------
//————————————————————————————————————————
// Programmer: Melina Pouya
// CS3B - Fall 20224
// String_equals method to compare two strings character by character
// and return true (1) if they are identical, false (0) otherwise.
// The comparison is case-sensitive.
//
// Prereq: x0 should point to the beginning of the first string
//         x1 should point to the beginning of the second string
// Return: x0 contains 1 if strings are equal, 0 otherwise
// ————————————————————————————————————————

	.global String_equals

	.text
String_equals:
	STR x19, [SP, #-16]!	// Push
	STR x20, [SP, #-16]!	// Push
	STR x21, [SP, #-16]!	// Push
	STR x22, [SP, #-16]!	// Push

	STR x30, [SP, #-16]! 	// preserving register

	MOV x19,x0		// x19 = Str1
	MOV x20,x1		// x20 = Str2

	BL String_length	// calculates string length
	MOV x21, x0		// x21 = Str1.length

	MOV x0,x20		// x0 = str2
	BL String_length	// caculates string length
	MOV x22, x0		// x22 = Str2.length

	CMP x21,x22		// compare lengths
	B.NE false		// if not equal return false

	MOV w2,#0		// counter i = 0
check:
	CMP w2,w21		// i == str1.length()
	B.EQ true		// branch if true

	LDRB w0,[x19], #1	// load char str1[i]
	LDRB w1,[x20], #1	// load char str2[i]

	ADD w2,w2,#1		// i++

	CMP w0,w1		// compare str1[i] and str2[i]
	B.EQ check		// loop back if equals
false:
	MOV x0,#0		// x0 = 0 (false)
	B   finish

true:
	MOV x0,#1		// x0 = 1 (true)

finish:
	LDR x30, [SP], #16	// POP register

	LDR x22, [SP], #16	// Pop
	LDR x21, [SP], #16	// POP
	LDR x20, [SP], #16	// Pop
	LDR x19, [SP], #16	// Pop

	RET LR			// return

.end


// ----------- String_EqualsIgnoreCase() ----------
//————————————————————————————————————————
// Programmer: Melina Pouya
// CS3B - Fall 2024
// String_EqualsIgnoreCase method to compare two strings character by character
// and return true (1) if they are identical (ignoring case), false (0) otherwise.
//
// Prereq: x0 should point to the beginning of the first string
//         x1 should point to the beginning of the second string
// Return: x0 contains 1 if strings are equal (ignoring case), 0 otherwise
// ————————————————————————————————————————
