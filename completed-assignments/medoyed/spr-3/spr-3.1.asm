VAR_1       EQU 20H
VAR_2       EQU 22H
RESULT      EQU 25H
BCD_STOR    EQU 30H

ORG 100H
INIT:
    LCALL LCD_CLR
    MOV DPTR, #MSG_INPUT
    LCALL WRITE_TEXT

    ; Read ARG1
    MOV R0, #VAR_1
    LCALL GET_NUM
    LCALL BCD_HEX
    ; Validate <= 127 (Bit 7 must be 0)
    MOV A, VAR_1
    JB ACC.7, ERROR_HANDLER

    MOV A, #'-'
    LCALL WRITE_DATA

    ; Read ARG2
    MOV R0, #VAR_2
    LCALL GET_NUM
    LCALL BCD_HEX
    ; Validate <= 127
    MOV A, VAR_2
    JB ACC.7, ERROR_HANDLER

    AJMP PROCESS

ERROR_HANDLER:
    MOV DPTR, #MSG_ERR
    LCALL WRITE_TEXT
    LCALL WAIT_KEY
    AJMP INIT

PROCESS:
    MOV DPTR, #MSG_CLICK
    LCALL WRITE_TEXT
    LCALL WAIT_KEY
    LCALL LCD_CLR

    ; --- Display Hex Line ---
    MOV A, VAR_1
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA
    
    MOV A, #'-'
    LCALL WRITE_DATA
    
    MOV A, VAR_2
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA
    
    MOV A, #'='
    LCALL WRITE_DATA

    ; Perform Subtraction
    MOV A, VAR_1
    CLR C
    SUBB A, VAR_2
    MOV RESULT, A       ; Save result

    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA

    ; --- Display Decimal Line ---
    MOV A, #0C0H        ; Move to Line 2
    LCALL WRITE_INSTR

    MOV A, VAR_1
    ACALL SHOW_DEC
    MOV A, #'d'
    LCALL WRITE_DATA
    
    MOV A, #'-'
    LCALL WRITE_DATA

    MOV A, VAR_2
    ACALL SHOW_DEC
    MOV A, #'d'
    LCALL WRITE_DATA
    
    MOV A, #'='
    LCALL WRITE_DATA

    ; Check Sign
    MOV A, RESULT
    JNB ACC.7, IS_POSITIVE

IS_NEGATIVE:
    MOV A, #'-'
    LCALL WRITE_DATA
    
    ; Convert 2's Complement to Absolute Value
    MOV A, RESULT
    CPL A
    INC A
    ACALL SHOW_DEC
    SJMP CLOSE_OP

IS_POSITIVE:
    ACALL SHOW_DEC

CLOSE_OP:
    MOV A, #'d'
    LCALL WRITE_DATA
    LCALL WAIT_KEY
    AJMP INIT

; --- Subroutines ---
SHOW_DEC:
    MOV BCD_STOR, A
    MOV BCD_STOR+1, #0
    MOV BCD_STOR+2, #0
    MOV R0, #BCD_STOR
    LCALL HEX_BCD
    
    ; Print with leading zero suppression
    MOV A, BCD_STOR+1
    JZ PRINT_ONES
    ACALL PRINT_BYTE
PRINT_ONES:
    MOV A, BCD_STOR
    ACALL PRINT_BYTE
    RET

PRINT_BYTE:
    MOV R2, A
    SWAP A
    ANL A, #0FH
    ADD A, #30H
    LCALL WRITE_DATA
    MOV A, R2
    ANL A, #0FH
    ADD A, #30H
    LCALL WRITE_DATA
    RET

MSG_INPUT: DB 'Arg <= 127', 0
MSG_CLICK: DB ' klik', 0
MSG_ERR:   DB ' ERROR', 0
