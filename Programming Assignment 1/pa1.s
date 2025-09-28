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
    ADD     X3, X3, #1				// ++1
    ADD     X2, X2, #1				// next charactor in String
    B       char_count_loop
        
end_of_string:


# add code and other labels here

# branch to this label on program completion
exit:
    mov x0, 0
    mov x8, 93
    svc 0
    ret