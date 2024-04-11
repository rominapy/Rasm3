  //@ Subroutine String_toLowerCase: Provided a pointer to a null terminated
//@		string, String_toLowerCase will return the string with all letters
//@		lowercased
//@ X0: address of input string
//@ X1: address of output string
//@ X4: original output string for length calc
//@	W5: current character being processed
//@ LR: Must contain the return address
//@ All registers are preserved, except X0

	.global String_toLowerCase
	.text

String_toLowerCase:
// Get base address and check for empty string, which also satisfies
// the conditions to enter the while loop
	MOV	X1, #0	// Index counter for byte offset


// while(szIn[i] != 0x00)			- Loop through string until we hit null byte
// if(szIn[i] < 0x41 && szIn[i] > 0x5A)		- Only modify with hex vals 'a' - 'z'
// szIn[i++] += 0x20				- Convert by adding 0x20
// X1 contains the size in bytes
// X0 has the lower-case string
LOOP:
	LDRB	W2, [X0, X1]			// Load szIn[i] and offset by numBytes in X3

						// Use ! to overwrite value with null
// Check hex value for letter-case
	CMP		X2, #'Z'		// Check if greater than 'Z'
	BGT		STORE			// True - Branch to continue
	CMP		X2, #'A'		// Check if less than 'A'
	BLT		STORE			// True - Branch to continue
	ADD		W2, W2, 0x20		// Change to lower-case

STORE:
	STRB	W2, [X0, X1]			// Overwrite szIn[i] with upper-case character
	ADD		X1, X1, #1		// i++
	CMP		W2, 0x00		// Check if we hit the null byte
	BNE		LOOP			// Back to while() if no the null byte

END:
	RET					// Return to the calling function
	.end
	