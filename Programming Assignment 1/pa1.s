.section .data

input_prompt    :   .asciz  "Input a string: "
input_spec      :   .asciz  "%[^\n]"
length_spec     :   .asciz  "String length: %d\n"
palindrome_spec :   .asciz  "String is a palindrome (T/F): %c\n"

.section .text

.global main

# program execution begins here
main:
    SUB     SP, SP, #16             // allocate 16 bytes on the stack
    ADR     X0, input_prompt
    BL      printf                  // "Input a string:"
    ADR     X0, input_spec
    ADD     X1, SP, #0
    BL      scanf                   // <<<User Input String>>>
    ADD     X1, SP, #0
    MOV     X2, X1      
    MOV     X3, #0                  // X3 = Counter    

char_count_loop:
    LDURB   W4, [X2, #0]
    CBZ     W4, end_of_string       // if True, skip to end_of_string
    ADD     X3, X3, #1
    ADD     X2, X2, #1
    B       char_count_loop         // Restart loop
        
end_of_string:
    MOV     X4, #0
    SUB     X5, X3, #1
    MOV     W6, #'T'

palendrone_loop:
    CMP     X4, X5                  // When indexes meet or cross, we are done
    B.GE    palendrone_complete
    ADD     X7, SP, #0
    ADD     X8, X7, X4
    ADD     X9, X7, X5
    LDURB   W10, [X8, #0]
    LDURB   W11, [X9, #0]

    // uppercase to lowercase conversion
    CMP     W10, #'A'
    BLT	    no_leftcase_conversion
    CMP     W10, #'Z'
    BGT     no_leftcase_conversion
    ADD	    W10, W10, #32

no_leftcase_conversion:
    CMP	    W11, #'A'
    BLT	    no_rightcase_conversion
    CMP	    W11, #'Z'
    BGT     no_rightcase_conversion
    ADD	    W11, W11, #32

no_rightcase_conversion:
    CMP	    W10, W11
    B.NE	is_palendrone_false
    ADD     X4, X4, #1
    SUB     X5, X5, #1
    B       palendrone_loop         // Restart loop

is_palendrone_false:
    MOV     W6, #'F'

palendrone_complete:
    STR     W6, [SP, #8]            // Store T/F result on stack
    ADR	    X0, length_spec         // "String length: %d\n"
    MOV	    X1, X3
    BL	    printf
    ADR	    X0, palindrome_spec     // "String is a palindrome (T/F): %c\n"
    LDR     W1, [SP, #8]
    BL	    printf
    B       exit                    // Exit Program

# add code and other labels here

# branch to this label on program completion
exit:
    mov x0, 0
    mov x8, 93
    svc 0
    ret
