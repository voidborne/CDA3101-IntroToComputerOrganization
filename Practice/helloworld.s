// -----------------------------------------
// Simple "Hello World" in LEGv8
// -----------------------------------------

        .data
msg:    .asciz "Hello, World!\n"

        .text
        .global _start

_start:
        // Load address of message
        ADRP    X0, msg
        ADD     X0, X0, :lo12:msg

        // Syscall 4 = print string
        MOV     X8, #4
        SVC     #0

        // Exit program (syscall 10)
        MOV     X8, #10
        SVC     #0
