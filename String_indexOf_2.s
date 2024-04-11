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


