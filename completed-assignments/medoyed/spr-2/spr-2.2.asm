N1_ADDR     EQU 20H
N2_ADDR     EQU 22H
PROD_LO     EQU 25H
PROD_HI     EQU 26H
CONV_MEM    EQU 30H

ORG 100H
MAIN_EXEC:
    LCALL LCD_CLR
    
    
    MOV R0, #N1_ADDR
    ACALL FETCH_BYTE
    
    MOV A, #'*'
    LCALL WRITE_DATA
    
    MOV R0, #N2_ADDR
    ACALL FETCH_BYTE
    
    LCALL WAIT_KEY
    LCALL LCD_CLR
    
    
    MOV A, N1_ADDR
    MOV B, N2_ADDR
    MUL AB
    MOV PROD_LO, A
    MOV PROD_HI, B
    
    ; --- Line 1: Hexadecimal ---
    MOV A, N1_ADDR
    ACALL OUT_HEX_H
    
    MOV A, #'*'
    LCALL WRITE_DATA
    
    MOV A, N2_ADDR
    ACALL OUT_HEX_H
    
    MOV A, #'='
    LCALL WRITE_DATA
    
    MOV A, PROD_HI
    JZ SKIP_HI_HEX
    LCALL WRITE_HEX
SKIP_HI_HEX:
    MOV A, PROD_LO
    ACALL OUT_HEX_H
    
    MOV A, #0C0H
    LCALL WRITE_INSTR
    
    MOV A, N1_ADDR
    ACALL OUT_DEC
    
    MOV A, #'*'
    LCALL WRITE_DATA
    
    MOV A, N2_ADDR
    ACALL OUT_DEC
    
    MOV A, #'='
    LCALL WRITE_DATA
    
    ; Decimal Result (16-bit)
    ACALL CLEAR_MEM
    MOV A, PROD_LO
    MOV CONV_MEM, A
    MOV A, PROD_HI
    MOV CONV_MEM+1, A
    
    MOV R0, #CONV_MEM
    LCALL HEX_BCD
    ACALL RENDER_BCD
    
    LCALL WAIT_KEY
    AJMP MAIN_EXEC

; --- Subroutines ---

FETCH_BYTE:
    LCALL GET_NUM
    LCALL BCD_HEX
    INC R0
    MOV A, @R0
    DEC R0
    JNZ MAIN_EXEC   
    RET

OUT_HEX_H:
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA
    RET

OUT_DEC:
    ACALL CLEAR_MEM
    MOV CONV_MEM, A
    MOV R0, #CONV_MEM
    LCALL HEX_BCD
    ACALL RENDER_BCD
    RET

RENDER_BCD:
    
    MOV A, CONV_MEM+2
    JZ CHECK_MID
    LCALL WRITE_HEX
CHECK_MID:
    MOV A, CONV_MEM+1
    JNZ PRINT_MID
    MOV A, CONV_MEM+2
    JNZ PRINT_MID       
    SJMP PRINT_LOW
PRINT_MID:
    MOV A, CONV_MEM+1
    LCALL WRITE_HEX
PRINT_LOW:
    MOV A, CONV_MEM
    LCALL WRITE_HEX
    RET

CLEAR_MEM:
    CLR A
    MOV CONV_MEM, A
    MOV CONV_MEM+1, A
    MOV CONV_MEM+2, A
    RET
