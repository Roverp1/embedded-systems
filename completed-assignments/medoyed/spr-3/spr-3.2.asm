VAR_N1      EQU 20H     ; Dividend
VAR_N2      EQU 22H     ; Divisor
QUOTIENT    EQU 25H
REMAINDER   EQU 26H
BCD_STORE   EQU 30H     ; Buffer for BCD conversion

ORG 100H
MAIN_LOOP:
    LCALL LCD_CLR
    MOV DPTR, #STR_PROMPT
    LCALL WRITE_TEXT
    
    ; Read Dividend
    MOV R0, #VAR_N1
    LCALL GET_NUM
    LCALL BCD_HEX
    
    ; Validate Limit (Must fit in 1 byte)
    MOV A, 21H          ; High byte of input
    JNZ ERROR_STATE
    
    MOV A, #'/'
    LCALL WRITE_DATA
    
    ; Read Divisor
    MOV R0, #VAR_N2
    LCALL GET_NUM
    LCALL BCD_HEX
    
    MOV A, 23H
    JNZ ERROR_STATE
    
    ; Validate Non-Zero
    MOV A, VAR_N2
    JZ ERROR_STATE
    
    AJMP CALCULATE

ERROR_STATE:
    MOV DPTR, #STR_ERR
    LCALL WRITE_TEXT
    LCALL WAIT_KEY
    AJMP MAIN_LOOP

CALCULATE:
    MOV DPTR, #STR_WAIT
    LCALL WRITE_TEXT
    LCALL WAIT_KEY
    LCALL LCD_CLR

    ; Perform Math
    MOV A, VAR_N1
    MOV B, VAR_N2
    DIV AB
    MOV QUOTIENT, A
    MOV REMAINDER, B

    ; --- Display Section ---
    
    ; Show N1
    MOV A, VAR_N1
    ACALL SHOW_DECIMAL
    
    MOV A, #'/'
    LCALL WRITE_DATA
    
    ; Show N2
    MOV A, VAR_N2
    ACALL SHOW_DECIMAL
    
    MOV A, #'='
    LCALL WRITE_DATA
    
    ; Show Quotient
    MOV A, QUOTIENT
    ACALL SHOW_DECIMAL
    
    ; Show Remainder (Only if > 0)
    MOV A, REMAINDER
    JZ FINISH_CYCLE
    
    MOV A, #' '
    LCALL WRITE_DATA
    MOV A, #'R'
    LCALL WRITE_DATA
    MOV A, #'='
    LCALL WRITE_DATA
    
    MOV A, REMAINDER
    ACALL SHOW_DECIMAL

FINISH_CYCLE:
    MOV DPTR, #STR_RESTART
    LCALL WRITE_TEXT
    LCALL WAIT_KEY
    AJMP MAIN_LOOP

; --- Subroutines ---

SHOW_DECIMAL:
    ; Convert Hex (A) to BCD and print
    ACALL CLEAR_BUFFER
    MOV BCD_STORE, A
    MOV R0, #BCD_STORE
    LCALL HEX_BCD
    ACALL PRINT_BCD_BUFFER
    RET

PRINT_BCD_BUFFER:
    ; Logic to skip leading zeros
    ; Hundreds
    MOV A, BCD_STORE+2
    JZ CHECK_TENS
    ACALL PRINT_BYTE_VAL
CHECK_TENS:
    MOV A, BCD_STORE+1
    CJNE A, #0, FORCE_TENS
    MOV A, BCD_STORE+2      ; Check if hundreds were printed
    JNZ FORCE_TENS
    SJMP PRINT_ONES
FORCE_TENS:
    MOV A, BCD_STORE+1
    ACALL PRINT_BYTE_VAL
PRINT_ONES:
    MOV A, BCD_STORE
    ACALL PRINT_BYTE_VAL
    RET

PRINT_BYTE_VAL:
    ; Print byte in A as ASCII char
    MOV R2, A
    ADD A, #48              ; Offset to '0'
    LCALL WRITE_DATA
    RET

CLEAR_BUFFER:
    MOV A, #0
    MOV BCD_STORE, A
    MOV BCD_STORE+1, A
    MOV BCD_STORE+2, A
    RET

; --- Data Strings ---
STR_PROMPT:  DB 'Wpisz L<=255', 0
STR_WAIT:    DB ' klik', 0
STR_RESTART: DB '  klik', 0
STR_ERR:     DB ' BLAD', 0
