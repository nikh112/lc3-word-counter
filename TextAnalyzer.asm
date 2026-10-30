.ORIG x3000

; ---------------------------------------------------------------------------
; MAIN
; ---------------------------------------------------------------------------
MAIN
    LEA R0, WELCOME_MSG
    PUTS

    JSR READ_INPUT
    JSR ANALYZE_TEXT
    JSR PRINT_RESULTS

    HALT

WELCOME_MSG .STRINGZ "Enter text: "
NEWLINE     .STRINGZ "\n"

; ---------------------------------------------------------------------------
; READ_INPUT: Read characters until enter (x0A or x0D), store in BUFFER
; ---------------------------------------------------------------------------
READ_INPUT
    ST R7, RI_R7        ; Save return address
    LEA R1, BUFFER      ; R1 = Buffer pointer
    AND R2, R2, #0      ; R2 = Character counter (max 99)

RI_LOOP
    GETC                ; Read character into R0
    OUT                 ; Echo character

    ; Check for Enter (x0A)
    ADD R3, R0, #-10
    BRz RI_DONE
    ; Check for Enter (x0D)
    ADD R3, R0, #-13
    BRz RI_DONE

    ; Store character
    STR R0, R1, #0
    ADD R1, R1, #1
    ADD R2, R2, #1

    ; Check if buffer full (99 chars)
    LD R3, NEG_99
    ADD R3, R2, R3
    BRz RI_DONE
    BRnzp RI_LOOP

RI_DONE
    AND R0, R0, #0
    STR R0, R1, #0      ; Null terminate the string
    LD R7, RI_R7
    RET

NEG_99  .FILL #-99
RI_R7   .BLKW #1

; ---------------------------------------------------------------------------
; ANALYZE_TEXT: Compute counts for characters, words, vowels, and spaces
; ---------------------------------------------------------------------------
ANALYZE_TEXT
    ST R7, AT_R7        
    LEA R1, BUFFER
    AND R2, R2, #0      ; Char count
    AND R3, R3, #0      ; Space count
    AND R4, R4, #0      ; Vowel count
    AND R5, R5, #0      ; Word count
    AND R6, R6, #0      ; IN_WORD flag

AT_LOOP
    LDR R0, R1, #0      ; Load next char
    BRz AT_DONE         ; If null terminator, done

    ADD R2, R2, #1      ; Increment char count

    ; Check if Space (ASCII 32)
    ADD R7, R0, #-16
    ADD R7, R7, #-16
    BRnp AT_NOT_SPACE
    
    ; Is Space
    ADD R3, R3, #1      ; Increment space count
    AND R6, R6, #0      ; IN_WORD = 0
    BRnzp AT_NEXT_CHAR

AT_NOT_SPACE
    ADD R6, R6, #0
    BRp AT_CHECK_VOWEL  ; If IN_WORD == 1, continue
    ADD R5, R5, #1      ; Increment word count
    AND R6, R6, #0
    ADD R6, R6, #1      ; IN_WORD = 1

AT_CHECK_VOWEL
    ; Subtract 65 to check for 'A'
    ADD R7, R0, #-15
    ADD R7, R7, #-15
    ADD R7, R7, #-15
    ADD R7, R7, #-15
    ADD R7, R7, #-5
    BRz AT_IS_VOWEL
    
    ; Check 'E' (ASCII 69) so subtract 4
    ADD R7, R7, #-4
    BRz AT_IS_VOWEL
    
    ; Check 'I' (ASCII 73) Subtract 4
    ADD R7, R7, #-4
    BRz AT_IS_VOWEL
    
    ; Check 'O' (ASCII 79) Subtract 6
    ADD R7, R7, #-6
    BRz AT_IS_VOWEL
    
    ; Check 'U' (ASCII 85) Subtract 6
    ADD R7, R7, #-6
    BRz AT_IS_VOWEL
    
    ; Check 'a' (ASCII 97) Subtract 12
    ADD R7, R7, #-12
    BRz AT_IS_VOWEL
    
    ; Check 'e' (ASCII 101) Subtract 4
    ADD R7, R7, #-4
    BRz AT_IS_VOWEL
    
    ; Check 'i' (ASCII 105) Subtract 4
    ADD R7, R7, #-4
    BRz AT_IS_VOWEL
    
    ; Check 'o' (ASCII 111) Subtract 6
    ADD R7, R7, #-6
    BRz AT_IS_VOWEL
    
    ; Check 'u' (ASCII 117) Subtract 6
    ADD R7, R7, #-6
    BRz AT_IS_VOWEL

    ; If it didn't branch on any of the above, it's not a vowel
    BRnzp AT_NEXT_CHAR

AT_IS_VOWEL
    ADD R4, R4, #1      ; Increment vowel count

AT_NEXT_CHAR
    ADD R1, R1, #1      ; Move buffer pointer
    BRnzp AT_LOOP

AT_DONE
    ; Store results in memory
    ST R2, COUNT_CHAR
    ST R5, COUNT_WORD
    ST R4, COUNT_VOWEL
    ST R3, COUNT_SPACE

    LD R7, AT_R7
    RET

AT_R7 .BLKW #1

; ---------------------------------------------------------------------------
; PRINT_RESULTS: Output labels and counts
; ---------------------------------------------------------------------------
PRINT_RESULTS
    ST R7, PR_R7

    LEA R0, NEWLINE
    PUTS
    LEA R0, RES_MSG
    PUTS

    ; Print Characters
    LEA R0, MSG_CHAR
    PUTS
    LD R1, COUNT_CHAR
    JSR PRINT_NUMBER

    ; Print Words
    LEA R0, MSG_WORD
    PUTS
    LD R1, COUNT_WORD
    JSR PRINT_NUMBER

    ; Print Vowels
    LEA R0, MSG_VOWEL
    PUTS
    LD R1, COUNT_VOWEL
    JSR PRINT_NUMBER

    ; Print Spaces
    LEA R0, MSG_SPACE
    PUTS
    LD R1, COUNT_SPACE
    JSR PRINT_NUMBER

    LEA R0, FINISH_MSG
    PUTS

    LD R7, PR_R7
    RET

PR_R7       .BLKW #1
RES_MSG     .STRINGZ "RESULTS\n"
MSG_CHAR    .STRINGZ "Characters: "
MSG_WORD    .STRINGZ "Words: "
MSG_VOWEL   .STRINGZ "Vowels: "
MSG_SPACE   .STRINGZ "Spaces: "
FINISH_MSG  .STRINGZ "Analysis complete.\n"

COUNT_CHAR  .BLKW #1
COUNT_WORD  .BLKW #1
COUNT_VOWEL .BLKW #1
COUNT_SPACE .BLKW #1

; ---------------------------------------------------------------------------
; PRINT_NUMBER: Print decimal value in R1 
; ---------------------------------------------------------------------------
PRINT_NUMBER
    ST R7, PN_R7
    AND R2, R2, #0      ; R2 = Tens counter

PN_TENS_LOOP
    ADD R3, R1, #-10
    BRn PN_TENS_DONE
    ADD R1, R1, #-10    ; Subtract 10
    ADD R2, R2, #1      ; Increment tens counter
    BRnzp PN_TENS_LOOP

PN_TENS_DONE
    ; Print tens digit if > 0
    ADD R2, R2, #0
    BRz PN_PRINT_ONES
    ADD R0, R2, #15
    ADD R0, R0, #15
    ADD R0, R0, #15
    ADD R0, R0, #3      ; 15 + 15 + 15 + 3 = 48 (ASCII '0')
    OUT

PN_PRINT_ONES
    ADD R0, R1, #15
    ADD R0, R0, #15
    ADD R0, R0, #15
    ADD R0, R0, #3      ; 15 + 15 + 15 + 3 = 48 (ASCII '0')
    OUT

    LEA R0, NEWLINE
    PUTS

    LD R7, PN_R7
    RET

PN_R7  .BLKW #1
BUFFER .BLKW #100
.END