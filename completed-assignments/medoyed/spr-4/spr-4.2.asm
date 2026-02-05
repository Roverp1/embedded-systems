FACTOR_H EQU 20H
FACTOR_L EQU 21H
FACTOR_2 EQU 22H
PROD_L   EQU 30H
PROD_M   EQU 31H
PROD_H   EQU 32H

ORG 100H
MAIN_LOOP:
    LCALL LCD_CLR
    
    ; Read Arg1 (Hex format via Decimal keys, no conversion)
    MOV R0, #FACTOR_H
    LCALL GET_NUM
    
    MOV A, #'*'
    LCALL WRITE_DATA
    
    ; Read Arg2 (Decimal format, converted to binary)
    MOV R0, #FACTOR_2
    LCALL GET_NUM
    LCALL BCD_HEX
    
    MOV A, #'='
    LCALL WRITE_DATA
    
    ; --- Multiplication Routine ---
    ; Step 1: Low Byte * Factor2
    MOV A, FACTOR_L
    MOV B, FACTOR_2
    MUL AB
    MOV PROD_L, A
    MOV PROD_M, B
    
    ; Step 2: High Byte * Factor2
    MOV A, FACTOR_H
    MOV B, FACTOR_2
    MUL AB
    
    ; Accumulate Results
    ADD A, PROD_M
    MOV PROD_M, A
    
    MOV A, B
    ADDC A, #0
    MOV PROD_H, A
    
    ; --- Output Display ---
    MOV A, PROD_H
    LCALL WRITE_HEX
    MOV A, PROD_M
    LCALL WRITE_HEX
    MOV A, PROD_L
    LCALL WRITE_HEX
    
    MOV DPTR, #MSG_CLICK
    LCALL WRITE_TEXT
    
    LCALL WAIT_KEY
    AJMP MAIN_LOOP

MSG_CLICK: DB ' klik', 0
