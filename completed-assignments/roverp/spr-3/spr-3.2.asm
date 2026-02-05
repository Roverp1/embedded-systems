; Zadanie 3.2 - Dzielenie 8-bit z reszta
; Indeks: 121546
; Input: Dec, Output: Dec

VAL_A   EQU 20H
VAL_B   EQU 22H
RES_Q   EQU 25H
RES_R   EQU 26H
BUF     EQU 30H

ORG 100H
START:
    LCALL LCD_CLR
    MOV DPTR, #TXT_INPUT
    LCALL WRITE_TEXT

    ; Get First Number
    MOV R0, #VAL_A
    LCALL GET_NUM
    LCALL BCD_HEX
    MOV A, 21H          ; Check high byte
    JNZ FATAL_ERR       ; If > 255, die

    MOV A, #'/'
    LCALL WRITE_DATA

    ; Get Second Number
    MOV R0, #VAL_B
    LCALL GET_NUM
    LCALL BCD_HEX
    MOV A, 23H
    JNZ FATAL_ERR
    
    MOV A, VAL_B
    JZ FATAL_ERR        ; Div by zero is death

    AJMP EXEC_MATH

FATAL_ERR:
    MOV DPTR, #TXT_BAD
    LCALL WRITE_TEXT
    LCALL WAIT_KEY
    AJMP START

EXEC_MATH:
    MOV DPTR, #TXT_CLICK
    LCALL WRITE_TEXT
    LCALL WAIT_KEY
    LCALL LCD_CLR

    ; Division Logic
    MOV A, VAL_A
    MOV B, VAL_B
    DIV AB
    MOV RES_Q, A        ; Quotient
    MOV RES_R, B        ; Remainder

    ; Print Routine
    ; 1. Print A
    MOV A, VAL_A
    ACALL DUMP_DEC
    
    MOV A, #'/'
    LCALL WRITE_DATA

    ; 2. Print B
    MOV A, VAL_B
    ACALL DUMP_DEC

    MOV A, #'='
    LCALL WRITE_DATA

    ; 3. Print Quotient
    MOV A, RES_Q
    ACALL DUMP_DEC

    ; 4. Check Remainder
    MOV A, RES_R
    JZ WAIT_RESET
    
    MOV A, #' '
    LCALL WRITE_DATA
    MOV A, #'R'
    LCALL WRITE_DATA
    MOV A, #'='
    LCALL WRITE_DATA
    
    MOV A, RES_R
    ACALL DUMP_DEC

WAIT_RESET:
    MOV DPTR, #TXT_END
    LCALL WRITE_TEXT
    LCALL WAIT_KEY
    AJMP START

; --- Helpers ---

DUMP_DEC:
    ; Converts A to BCD and prints it
    ACALL CLEAN_BUF
    MOV BUF, A
    MOV R0, #BUF
    LCALL HEX_BCD
    
    ; Print logic
    MOV A, BUF+2
    JZ SKIP_HUNDRED
    ACALL PRINT_BYTE
SKIP_HUNDRED:
    MOV A, BUF+1
    CJNE A, #0, PRINT_TENS
    MOV A, BUF+2        ; If hundreds were printed, force tens
    JNZ PRINT_TENS
    SJMP CHECK_ONES
PRINT_TENS:
    MOV A, BUF+1
    ACALL PRINT_BYTE
CHECK_ONES:
    MOV A, BUF
    ACALL PRINT_BYTE
    RET

PRINT_BYTE:
    ; Prints Hex Nibbles as Ascii
    MOV R1, A
    SWAP A
    ANL A, #0FH
    JZ LOW_NIB
    ACALL TO_ASCII
LOW_NIB:
    MOV A, R1
    ANL A, #0FH
    ACALL TO_ASCII
    RET

TO_ASCII:
    ADD A, #'0'
    LCALL WRITE_DATA
    RET

CLEAN_BUF:
    MOV A, #0
    MOV BUF, A
    MOV BUF+1, A
    MOV BUF+2, A
    RET

TXT_INPUT: DB 'Arg <= 255', 0
TXT_CLICK: DB ' klik', 0
TXT_END:   DB '  klik', 0
TXT_BAD:   DB ' BLAD', 0
