VAR_A       EQU 20H
VAR_B       EQU 22H
PRODUCT     EQU 25H
CONV_BUF    EQU 30H

ORG 100H
MAIN_LOOP:
    LCALL LCD_CLR

    ; Input A
    MOV R0, #VAR_A
    ACALL INPUT_VALIDATE
    
    MOV A, #'*'
    LCALL WRITE_DATA
    
    ; Input B
    MOV R0, #VAR_B
    ACALL INPUT_VALIDATE
    
    ; Wait for confirmation
    LCALL WAIT_KEY
    LCALL LCD_CLR
    
    ; Math: A * B
    MOV A, VAR_A
    MOV B, VAR_B
    MUL AB
    MOV PRODUCT, A
    MOV PRODUCT+1, B
    
    ; Display Routine
    ; Print A
    MOV A, VAR_A
    ACALL SHOW_DECIMAL
    
    MOV A, #'*'
    LCALL WRITE_DATA
    
    ; Print B
    MOV A, VAR_B
    ACALL SHOW_DECIMAL
    
    MOV A, #'='
    LCALL WRITE_DATA
    
    ; Print Product (16-bit source)
    ACALL RESET_BUF
    MOV A, PRODUCT
    MOV CONV_BUF, A
    MOV A, PRODUCT+1
    MOV CONV_BUF+1, A
    
    MOV R0, #CONV_BUF
    LCALL HEX_BCD
    ACALL RENDER_BCD
    
    LCALL WAIT_KEY
    AJMP MAIN_LOOP

; --- Subroutines ---

INPUT_VALIDATE:
    LCALL GET_NUM
    LCALL BCD_HEX
    ; Check High Byte (must be 0)
    INC R0
    MOV A, @R0
    DEC R0
    JNZ MAIN_LOOP   ; Restart if overflow
    RET

SHOW_DECIMAL:
    ; 8-bit source to Decimal
    ACALL RESET_BUF
    MOV CONV_BUF, A
    MOV R0, #CONV_BUF
    LCALL HEX_BCD
    ACALL RENDER_BCD
    RET

RENDER_BCD:
    ; Standard hex printing of BCD digits
    MOV A, CONV_BUF+1
    LCALL WRITE_HEX
    MOV A, CONV_BUF+2
    LCALL WRITE_HEX
    MOV A, CONV_BUF
    LCALL WRITE_HEX
    RET

RESET_BUF:
    CLR A
    MOV CONV_BUF, A
    MOV CONV_BUF+1, A
    MOV CONV_BUF+2, A
    RET
