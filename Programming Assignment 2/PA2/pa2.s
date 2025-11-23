.section .data
input_prompt: .asciz "Please enter a number betwen 1 and 10 \n"
input_spec:   .asciz "%d"
out_fmt:      .asciz "%d\n"
oob_mess:     .asciz "Input is out of bounds \n"

.section .text
.global main

main:
    ADR     X0, input_prompt
    BL      printf                  // "Please enter a number betwen 1 and 10 \n"
    SUB     SP, SP, #16
    ADR     X0, input_spec
    MOV     X1, SP
    BL      scanf                   // "%d"
    LDUR    W9, [SP, #0]
    ADD     SP, SP, #16
    SUBS    WZR, W9, #1
    B.LT    out_of_bounds_mess
    SUBS    WZR, W9, #10
    B.GT    out_of_bounds_mess
    MOV     W0, W9
    BL      fib_function

    // Print the results
    MOV     W1, W0
    ADR     X0, out_fmt
    BL      printf                  // "%d\n"
    B       exit

out_of_bounds_mess:
    ADR     X0, oob_mess
    BL      printf                  // "Input is out of bounds \n"

exit:
    MOV    X0, #0
    MOV    X8, #93
    SVC     0
    RET

fib_function:
    SUB     SP, SP, #32             // allocate 32 bytes on the stack
    STUR    X30, [SP, #8]
    STUR    X0, [SP, #0]
    LDUR    X1, [SP, #0]       
    SUBS    XZR, X1, #1       
    B.EQ    when_n_is_1             // n = 1       
    SUBS    XZR, X1, #2        
    B.EQ    when_n_is_2             // n = 2

    // calls the fib_funtion with n - 1
    SUB     X0, X1, #1         
    BL      fib_function
    STUR    X0, [SP, #16]

    // calls the fib_funtion with n - 2
    LDUR    X1, [SP, #0]      
    SUB     X0, X1, #2         
    BL      fib_function

    // the sum of parts a and b
    LDUR    X2, [SP, #16]
    ADD     X0, X0, X2
    B       end_of_fib_function

    when_n_is_1:
    MOV     X0, #0
    B       end_of_fib_function

    when_n_is_2:
    MOV     X0, #1
    B       end_of_fib_function

end_of_fib_function:
    LDUR    X30, [SP, #8]
    ADD     SP, SP, #32
    RET