 

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

  //*****************************************************************
//Name: 	Romina Pouya
//Program:	String_indexOf_1
//Class:	CS 3B
//Lab:		RASM-3
//Purpose:
//	Returns theindex of first occurrence of the specified character ch
// in the string
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
/* 
@ 	.global String_indexOf_1
@ 	.data
@ 	.text
@ String_indexOf_1:
@ 	//Preserve AAPCS registers
@ 	str x19, [SP, #-16]!	//PUSH
@ 	str x20, [SP, #-16]!	//PUSH
@ 	str x21, [SP, #-16]!	//PUSH
@ 	str x30, [SP, #-16]!	//Push LR
	
@ 	//initialize counter for findCharacter
@ 	mov x9, #0
	
@ 	//W2 first byte of string
@ 	ldrb w2, [x0], #1
@ 	//W3 load character wanting to be found
@ 	ldrb w3, [x1], #1
	
@ 	findCharacter:
@ 		//Check if string[i] == "\n"
@ 		cmp w2, #0
@ 		b.eq stopCount	//if true goto stopCount
		
@ 		//Else if (string[i] == x1)
@ 		cmp w2, w3
@ 		b.eq characterFound
		
@ 		//Else
@ 		ldrb w2, [x0], #1	//Check next string[i]
@ 		add x9, x9, #1		//count++
	
@ 		b findCharacter

@ stopCount:
@ 	mov x9, #-1		//x9 = -1 (Used if character not found)
@ characterFound:
	
@ 	//When done move value of x9 to x0
@ 	mov x0, x9
	
@ 	//Popped in reverse order
@ 	ldr x30, [SP], #16		//POP LR
@ 	ldr x21, [SP], #16		//POP
@ 	ldr x20, [SP], #16		//POP
@ 	ldr x19, [SP], #16		//POP
	
@ 	ret
*/



	.text
	.global String_indexOf_1

String_indexOf_1:
	MOV		X5, #0		// Initialize index counter i = 0

// while(szIn[i] != 0x00 &&
//		 szIn[i] != chIn)
// i++

Loop:
	LDRB	W2, [X0, X5]		// Load szIn[i]
	CMP	X2, 0x00		// Check for null-terminator
	BEQ	NOT_FOUND		// Branch to NOT_FOUND
	CMP	X2, X1			// Check X2 == X1
	BEQ	END			// Branch to END
	ADD	X5, X5, #1		// i++
	B	Loop

NOT_FOUND:
	MOV	X5, #-1			// Change return val to -1

END:
	MOV	X0, X5			// Put index val in X0
	RET

//*****************************************************************
//Name: 	Romina Pouya
//Program:	String_indexOf_2
//Class:	CS 3B
//Lab:		RASM-3
//Purpose:
//	Same as indexOf method however it starts searching in the string 
// from the specified fromIndex
// 
//Input:
//@ X0: Must point to a null terminated string
//  X1: Must point to the character to find
//  X2:	Holds value of index to start searching from
// LR: Must contain the return address
// All registers are preserved, except X0
//
//Output:
//  X0: Contains the index of where the character was found
//		(If not found X0 = -1)
//*****************************************************************
	.global String_indexOf_2
	.data
	.text
String_indexOf_2:
    STR X0,[SP,#-16]!       // PUSH init string address for index calculation
    ADD X0,X0,X2            // move pointer to search starting index
    ADD X0,X0,#1            // skip index we are given
loop_indexOf_2:
    LDRB W2,[X0],#1         // load current character and increment string ptr
    CMP  W2,#0              // if current char == null terminator
    B.EQ err_indexOf_2      // error, reached end with char not found
    CMP  W2,W1              // if current char == input char
    B.EQ found_indexOf_2    // we found the correct index
    B    loop_indexOf_2     // else, continue loop
found_indexOf_2:
    LDR X1,[SP],#16         // POP init string address
    SUB X0,X0,X1            // return initAddress - charAddress (index)
    SUB X0,X0,#1            // subtract 1 to account for starting index of 0
    RET                     // return to calling function 
err_indexOf_2:
    ADD SP,SP,#16           // POP init string address (preserve SP)
    MOV X0,#-1              // return -1, no instance of character found
    RET                     // return to calling function


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
    
  //Programmer: Romina Pouya
//Program:		String_length.s
//class:		CS3B
//Purpose:
//	String_length function is a loop that keeps going string == null
//	once it exits out of the loop it will then save the result into x0
//	and return once the function is called again


	.global String_length // program starting address

	.data

	.text

String_length:
	str	x1,	[sp,	#-16]!	// Store x1 on the stack
	str	x2,	[sp,	#-16]!	// Store x2 on the stack
	str	x19,	[sp,	#-16]!	// Store x19 on the stack
	str	x20,	[sp,	#-16]!	// Store x19 on the stack
	str	x21,	[sp,	#-16]!	// Store x19 on the stack
	str	x22,	[sp,	#-16]!	// Store x19 on the stack
	str	x23,	[sp,	#-16]!	// Store x19 on the stack
	str	x24,	[sp,	#-16]!	// Store x19 on the stack
	str	x25,	[sp,	#-16]!	// Store x19 on the stack
	str	x26,	[sp,	#-16]!	// Store x19 on the stack
	str	x27,	[sp,	#-16]!	// Store x19 on the stack
	str	x28,	[sp,	#-16]!	// Store x19 on the stack
	str	x29,	[sp,	#-16]!	// Store x19 on the stack
	str	x30,	[sp,	#-16]!	// Store x19 on the stack
	
	mov	x1,	#0	// Initialize the counter

	loop:
	ldrb	w2,	[x0,	x1]	// load the byte at string address
	cmp	w2,	#0		// compare value to 0
	b.eq	end			// if it is 0, end the program
	add	x1,	x1,	#1	// add to the index
	b	loop

	end:
	mov	x0,	x1		// Return the length of the string
	ldr	x30,	[sp],	#16	// Retrive x30 from stack
	ldr	x29,	[sp],	#16	// Retrive x29 from stack
	ldr	x28,	[sp],	#16	// Retrive x28 from stack
	ldr	x27,	[sp],	#16	// Retrive x27 from stack
	ldr	x26,	[sp],	#16	// Retrive x26 from stack
	ldr	x25,	[sp],	#16	// Retrive x25 from stack
	ldr	x24,	[sp],	#16	// Retrive x24 from stack
	ldr	x23,	[sp],	#16	// Retrive x23 from stack
	ldr	x22,	[sp],	#16	// Retrive x22 from stack
	ldr	x21,	[sp],	#16	// Retrive x21 from stack
	ldr	x20,	[sp],	#16	// Retrive x20 from stack
	ldr	x19,	[sp],	#16	// Retrive x19 from stack
	ldr	x2,	[sp],	#16	// Retrive x2 from stack
	ldr	x1,	[sp],	#16	// Retrive x1 from stack
	ret
	
	.end

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
	/@ Subroutine String_toUpperCase: Provided a pointer to a null terminated
//@		string, String_toUpperCase will return the string with all letters
//@		uppercased
//@ X0: address of input string
//@ X1: address of output string
//@ X4: original output string for length calc
//@	W5: current character being processed
//@ LR: Must contain the return address
//@ All registers are preserved, except X0
	
	.global String_toUpperCase
	.text

String_toUpperCase:
// Get base address and check for empty string, which also satisfies
// the conditions to enter the while loop
	MOV	X1, #0				// Index counter for byte offset


// while(szIn[i] != 0x00)			- Loop through string until we hit null byte
// if(szIn[i] < 0x7B && szIn[i] > 0x60)		- Only modify with hex vals 'a' - 'z'
// szIn[i++] -= 0x20				- Convert by subtracting 0x20
// X1 contains the null-terminated string
// X0 will have an empty array
LOOP:
	LDRB	W2, [X0, X1]			// Load szIn[i] and offset by numBytes in X3
						// Use ! to overwrite value with null

// Check hex value for letter-case
	CMP		X2, #'z'		// Check if greater than 'z'
	BGT		STORE			// True - Branch to continue
	CMP		X2, #'a'		// Check if less than 'a'
	BLT		STORE			// True - Branch to continue
	SUB		W2, W2, 0x20		// Change to upper-case

STORE:
	STRB	W2, [X0, X1]			// Overwrite szIn[i] with upper-case character
	ADD		X1, X1, #1		// i++
	CMP		W2, 0x00		// Check if we hit the null byte
	BNE		LOOP			// Back to while() if no the null byte

END:
	RET					// Return to the calling function
	.end
	

    	.global substring1	// sets starting point of subroutine

	.text
substring1:
	STR x19, [SP, #-16]!	// PUSH
	STR x20, [SP, #-16]!	// PUSH
	STR x21, [SP, #-16]!	// PUSH
	STR x22, [SP, #-16]!	// PUSH
	STR x30, [SP, #-16]!	// PUSH LR

	MOV x19, x0		// copy string address
	SUB x0, x2, x1		// x20 = end - start
	ADD x0, x0, #1		// add 1 for null
	MOV x20, x1		// copy starting index
	MOV x21, x2		// copy ending index

	BL  malloc		// allocate memory
	MOV x22, x0		// x22 copy of address
loop:
	LDRB w1, [x19, x20]	// load w1 with string[i]
	STRB w1, [x0], #1	// store w1 into new string[i]

	ADD  x20, x20, #1	// i++
	CMP  x20, x21		// compare i and length
	B.LT loop		// loop back if (i < lenngth)

	MOV  w2, #0X00		// move a null into w2
	STRB w2, [x0], #1	// add null to end of new string
	MOV  x0, x22		// move starting address of new string

	LDR x30, [SP], #16	// POP LR
	LDR x22, [SP], #16	// POP
	LDR x21, [SP], #16	// POP
	LDR x20, [SP], #16	// POP
	LDR x19, [SP], #16	// POP

	RET LR			// Return
	.end
