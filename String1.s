// ----------- String_length() --------------------------------
//—————————————————————————————————————---------------------———
// Programmer: Melina Pouya
// CS3B - Fall 2024
// String_length function to calculate the length of a null-terminated string
//
// Prereq: x0 should point to the beginning of the string
// Return: x0 now contains the length of the string
// ———————————————————————————————————————-----------------------—

	.text
	.global String_length	// Declares the function globally accessible

String_length:
	// Copies the data from x0 to x7
	mov	x7,x0		// x7 = x0 (copy the data)

	// Initializes x2 to 0 to count the length
	mov	x2, #0		// x2 = 0 (initialize length counter)

topLoop:
	// Loads only 1 byte from the memory address in x7 and increments x7 by 1
	ldrb	w1, [x7], #1	// Load 1 byte from [x7] and increment x7

	// Compares if the loaded byte is the null terminator
	cmp 	w1, #0		// Compare the loaded byte with null terminator

	// If the loaded byte is the null terminator, branch to bottomLoop
	beq	bottomLoop	// If equal to 0, jump to bottomLoop

	// Adds 1 to the length counter (x2)
	add	x2,x2,#1	// Increment length counter

	// Branches back to the topLoop to continue processing
	b	topLoop		// Branch to topLoop

bottomLoop:
	// Puts the length result (x2) back into x0 register
	mov	x0, x2		// Store length result in x0

	// Return: x0 now contains the length of the string

	// Returns to the calling function
	RET	LR		// Return to the link register

	.end	// End of function




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

	.global String_EqualsIgnoreCase

	.text
String_EqualsIgnoreCase:
	STR x19,[SP, #-16]!     // Push
	STR x20,[SP, #-16]!	// Push
	STR x21,[SP, #-16]!	// Push
	STR x22,[SP, #-16]!	// Push

	STR x30,[SP, #-16]!	// Push LR

	MOV x19,x0		// x19 = s1
	MOV x20,x1		// x20 = s2

	BL  String_length	// string_leng(s1)
	MOV x21,x0		// x21 = s1.length()

	MOV x0,x20		// x0 = s2
	BL  String_length	// String_length(s2)
	MOV x22,x0		// x22 = s2.length()

	CMP x21, x22		// compare lengths
	B.NE  false		// Not equal Branch to false

	MOV x2,#0		// counter i = 0

// load char si[i] and s2[i]
check:
	CMP w2,w21		// compare i to string length
	B.EQ true		// if i = length branch to true

	LDRB w0,[x19],#1	// load char s1[i]
	LDRB w1,[x20],#1	// load char s2[i]

// check s1[i] for Uppercase
	CMP w0, #0x41		// compare si[i] to 'A'
	B.LT second		// branch if less than

	CMP w0, #0x5A		// compare s1[i] to 'Z'
	B.GT second		// branch if greater than

	ADD w0,w0,#0x20		// w0 = lowercase letter of w0

// check s2[i] for Uppercase
second:
	CMP w1,#0x41		// compare s2[i] to 'A'
	B.LT compare		// branch if less than

	CMP w1,#0x5A		// compare s2[2] to 'Z'
	B.GT compare		// branch if less than

	ADD w1,w1,#0x20		// w1 = lowercase letter of w1

// compare s1[i] and s2[i]
compare:
	ADD w2,w2,#1		// i++
	CMP w0,w1		// compare w0 and w1
	B.EQ check		// loop back if equal

// return false
false:
	MOV x0,#0		// load 0 (false) to x0
	B  finish
// retrun true
true:
	MOV x0,#1		// load 1 (true) to x0

finish:
	LDR x30, [SP], #16	// POP LR

	LDR x22, [SP], #16	// Pop
	LDR x21, [SP], #16	// Pop
	LDR x20, [SP], #16	// Pop
	LDR x19, [SP], #16	// Pop
	RET LR			// return

	.end

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


// ----------- String_substring_1() ----------
//————————————————————————————————————————
// Programmer: Melina Pouya
// CS3B - Fall 2024
// String_substring_1 subroutine creates a new substring from a provided null-terminated string,
// starting at the given index and ending at the specified index.
// Returns the address of the new substring.
//
// Prereq: x0 must contain the address of a null-terminated string
//         x1 must contain the starting index
//         x2 must contain the ending index
//         LR must contain the return address
//         All AAPCS mandated registers are preserved
// Return: x0 contains the address of the new substring
// ————————————————————————————————————————

	.global String_substring_1    // sets starting point of subroutine

	.text
String_substring_1:
    STR x19, [SP, #-16]!    // PUSH
    STR x20, [SP, #-16]!    // PUSH
    STR x21, [SP, #-16]!    // PUSH
    STR x22, [SP, #-16]!    // PUSH
    STR x30, [SP, #-16]!    // PUSH LR

    MOV x19, x0    	// copy string address
    SUB x0, x2, x1   	 // x20 = end - start
    ADD x0, x0, #1   	 // add 1 for null
    MOV x20, x1   	 // copy starting index
    MOV x21, x2   	 // copy ending index

    BL malloc    	// allocate memory
    MOV x22, x0   	 // x22 copy of address
loop:
    LDRB w1, [x19, x20]  // load w1 with string[i]
    STRB w1, [x0], #1    // store w1 into new string[i]

    ADD  x20, x20, #1    // i++
    CMP  x20, x21    	// compare i and length
    B.LT loop   	 // loop back if (i < length)

    MOV  w2, #0X00   	 // move a null into w2
    STRB w2, [x0], #1    // add null to end of new string
    MOV  x0, x22    	// move starting address of new string

    LDR x30, [SP], #16    // POP LR
    LDR x22, [SP], #16    // POP
    LDR x21, [SP], #16    // POP
    LDR x20, [SP], #16    // POP
    LDR x19, [SP], #16    // POP

    RET LR    // Return
	.end


// ----------- String_substring_2() ----------
//————————————————————————————————————————
// Programmer: Melina Pouya
// CS3B - Fall 2024
// substring2 subroutine: Takes a null terminated string and an index to start at. Dynamically
//  creates a new substring starting at the index to the end of the string. Address of new substring
//  is returned to x0.
//
//  Needs malloc/free
//  x0 must contain the address of a null terminated string
//  x1 must contain the index.
//  LR must contain return address
//
//  All AAPCS registers are preserved.
//  Various registers are modified due to malloc.

.global String_substring_2    // sets starting point of subroutine

.text

String_substring_2:
    STR x19, [SP, #-16]!    // push
    STR x20, [SP, #-16]!    // push
    STR x21, [SP, #-16]!    // push
    STR x22, [SP, #-16]!    // push
    STR x30, [SP, #-16]!    // push

    MOV x19, x0    		// copy string address
    MOV x20, x1    		// copy starting index

    BL String_length    	// x0 = string length
    MOV x21, x0    		// copy string length
    SUB x0, x0, x1   		 // x0 = string length - starting index
    ADD x0, x0, #1   		 // add one for null

    CMP x0, #0    		// compare to 0
    B.LT invalid   		 // branch if less than

    BL malloc    		// allocate memory
    MOV x22, x0   		 // copy ptr to memory

loop:
    LDRB w1, [x19, x20]  	  // load one byte starting at index
    STRB w1, [x0], #1   	 // store one byte to ptr

    ADD x20, x20, #1    	// increase index
    CMP x20, x21    		// compare against string length
    B.LT loop    		// if less than loop back

    MOV w1, #0x00    		// load null to x1
    STRB w1, [x0], #1    	// add null to end of new string
    B  finished

invalid:
    MOV x0, #1    		// x0 = 1 byte
    BL  malloc    		// allocate space
    MOV x1, #0x00    		// x1 = null character
    STRB w1, [x0]    		// ensure new string just contains null
    MOV x22, x0    		// copy to x22

finished:
    MOV x0, x22    		// move ptr address to x0

    LDR x30, [SP], #16    // pop LR
    LDR x22, [SP], #16    // pop
    LDR x21, [SP], #16    // pop
    LDR x20, [SP], #16    // pop
    LDR x19, [SP], #16    // pop

    RET LR    // return

.end

// ----------- String_charAt() ----------
//————————————————————————————————————————
// Programmer: Melina Pouya
// CS3B - Fall 2024
// String_charAt subroutine: Takes a null terminated string and an index
//  position, and returns the char at the index in hex. If index is outside
//  the string, then a 0 is returned.
//
//  x0 must contain a null terminate string
//  x1 must contain the index of the character requested
//  LR must contain returning address
//
//  ALL AAPCS registers are preserved.
//  Returns results back to x0

.global String_charAt        // sets starting point of subroutine

.text
String_charAt:
    STR x19, [SP, #-16]!    // PUSH
    STR x20, [SP, #-16]!    // PUSH
    STR x30, [SP, #-16]!    // PUSH LR

    MOV x19, x0    		// x19 = copy of string
    MOV x20, x1    		// x20 = the index
    BL  String_length    // calculates string length

    CMP  x20, x0    	// compare index to string length
    B.GT invalid    	// branch if greater than

    CMP  x20, #0   	 // compare index to 0
    B.LT invalid   	 // branch if less than

// else load char
    LDRB w0,[x19,x20]    // load byte of string[index]
    B    finish    	// branch to finished

invalid:
    MOV x0, #0    	// x0 = 0 if invalid index

finish:
    LDR x30, [SP], #16    // POP
    LDR x20, [SP], #16    // pop
    LDR x19, [SP], #16    // POP LR

    RET LR            	// return
	.end




// ----------- String_startWith_1() ----------
//————————————————————————————————————————
// Programmer: Melina Pouya
// CS3B - Fall 2024
// startsWith subroutine takes a null terminated string and a null terminated
//  substring, starts with index 0, and compares if they match. Returns a boolean
//  to x0.
//   terminated prefix substring and compares for if the match. Returns a boolean
//   value into x0.
//
//   x0 must contain address of null terminated string
//   x1 must contain address of null terminate prefix substring
//   x2 must contain index to start from
//   LR must contain returning address
//   ALL AAPCS registers are preserved, x0 and x1 are modified.
//   Results return to x0

	.global String_startWith_1    // sets starting point of subroutine

	.text

String_startWith_1:


.global String_startWith_1    //sets starting point of subroutine

.text
String_startWith_1:
    STR x19, [SP, #-16]!    // PUSH
    STR x20, [SP, #-16]!    // PUSH

    STR x30, [SP, #-16]!    // PUSH LR

    MOV x19, x0        // copy string
    MOV x20, x1        // copy substring

compare:
    LDRB w0, [x19, x2]    // load string[index]
    LDRB w1, [x20], #1    // load prefix[i]

    CMP w1, #0x00        // compare for prefix[i] = null
    B.EQ true       	 // branch if true

    CMP w0, w1        	// compare string[index] and prefix[i]
    ADD w2, w2, #1       // index ++
    B.EQ compare        // loop back

// not equal -- Returns false
    MOV x0, #0        // x0 = 0 (false)
    B   finished        // branch to finished

// equal -- Returns true
true:
    MOV x0, #1        // x0 = 1 (true)

finished:
    LDR x30, [SP], #16    // POP LR
    LDR x20, [SP], #16    // POP
    LDR x19, [SP], #16    // POP

    RET LR            // Return
.end





// ----------- String_startWith_2() ----------
//————————————————————————————————————————
// Programmer: Melina Pouya
// CS3B - Fall 2024
// startsWith subroutine takes a null terminated string and a null terminated
//  substring, starts with index 0, and compares if they match. Returns a boolean
//  to x0.
//
// x0 must contain the address of a null terminated string
// x1 must contain the address of a null terminated substring
// LR must contain returning address.
// ALL AAPCS registers are preserved.
// Results returned in x0.

.global String_startWith_2    // sets starting point of subroutine

.text

String_startWith_2:
    STR x19, [SP, #-16]!    // PUSH
    STR x20, [SP, #-16]!    // PUSH
    STR x30, [SP, #-16]!    // PUSH LR

    MOV x19, x0        		// x19 = copy of string
    MOV x20, x1        		// x20 = copy of prefix substring

compare:
    LDRB w1, [x19], #1   	 // w1 = string[i]
    LDRB w2, [x20], #1    	// w2 = prefix[i]

    CMP w2, #0x00        	// compare w2 for null
    B.EQ true        		// branch if found

    CMP w1, w2        		// compare string[i] and prefix[i]
    B.EQ compare        	// loop back if match

    MOV x0,#0        		// x0 = 0 (false)
    B  finished        		// branch to finished

true:
    MOV x0, #1        		// x0 = 1 (true)

finished:
    LDR x30, [SP], #16    // POP LR
    LDR x20, [SP], #16    // POP
    LDR x21, [SP], #16    // POP

    RET LR            // Return
.end



// ----------- String_endWith() ----------
//————————————————————————————————————————
// Programmer: Melina Pouya
// CS3B -  Fall 2024
// String_endWith subroutine takes a null terminated string and a null terminated
//  substring, and compares if the string ends with the substring. Returns a boolean
//  to x0.
//
// x0 must contain the address of a null terminated string
// x1 must contain the address of a null terminated substring
// LR must contain returning address.
// ALL AAPCS registers are preserved.
// Results returned in x0.

.global String_endWith    // sets starting point of subroutine

.text

String_endWith:
    STR x19, [SP, #-16]!    // PUSH
    STR x20, [SP, #-16]!    // PUSH
    STR x21, [SP, #-16]!    // PUSH

    STR x30, [SP, #-16]!    // PUSH LR

    MOV x19, x0        // copy string
    MOV x20, x1        // copy substring

    BL String_length    // string.length()

    MOV x21, x0        // x21 = string.length()

    MOV x0, x20        // x0 = suffix
    BL String_length    // suffix.length()

    SUB x21, x21, x0    // x21 = string - suffix

compare:
    LDRB w0, [x19, x21]    // load string[i]
    LDRB w1, [x20], #1    // load suffix[i]

    CMP w1, #0x00        // compare if suffix[i] = null
    B.EQ true        	// branch if true

    CMP w0, w1        	// compare string[i] and suffix[i]
    ADD x21, x21, #1    // x21 += 1
    B.EQ compare        // branch back to compare if match

// false
    MOV x0, #0        // x0 = 0 (false)
    B  finished        // branch to finished

true:
    MOV x0, #1        // x0 = 1 (true)

finished:
    LDR x30, [SP], #16    // POP

    LDR x21, [SP], #16    // POP
    LDR x20, [SP], #16    // POP
    LDR x19, [SP], #16    // POP

    RET LR            // Return
.end
