; Zadanie 4.3 - Dzielenie 16/8
; Indeks: 121546
; Test: 5048d / 172d = 001Dh R3Ch

DIV_HI  EQU 20H     
DIV_LO  EQU 21H     
DIVISOR EQU 22H     
QUOT_HI EQU 30H
QUOT_LO EQU 31H
REM     EQU 32H
BUF     EQU 40H

ORG 100H
RUN:
    LCALL LCD_CLR
    
    
    MOV R0, #DIV_HI
    LCALL GET_NUM
    LCALL BCD_HEX   
    
    MOV A, #'d'
    LCALL WRITE_DATA
    MOV A, #'/'
    LCALL WRITE_DATA
    
    
    MOV R0, #DIVISOR
    LCALL GET_NUM
    LCALL BCD_HEX
    
    MOV A, #'d'
    LCALL WRITE_DATA
    MOV A, #'='
    LCALL WRITE_DATA
    
    
    MOV A, DIVISOR
    JZ DEATH
    
    
    
    
    MOV R7, #16
    CLR A
    MOV REM, A      
    MOV QUOT_HI, A
    MOV QUOT_LO, A
    
LOOP_DIV:
    
    CLR C
    
    
    MOV A, DIV_LO
    RLC A
    MOV DIV_LO, A
    
    
    MOV A, DIV_HI
    RLC A
    MOV DIV_HI, A
    
    
    MOV A, REM
    RLC A
    MOV REM, A
    
    
    CLR C
    SUBB A, DIVISOR
    JC SKIP_SUB     
    
    
    MOV REM, A
    
    
    
    INC DIV_LO      
    
SKIP_SUB:
    DJNZ R7, LOOP_DIV
    
    
    
    
    MOV A, DIV_HI
    LCALL WRITE_HEX
    MOV A, DIV_LO
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA
    
    ; Check Remainder
    MOV A, REM
    JZ WAIT_REL
    
    MOV A, #' '
    LCALL WRITE_DATA
    MOV A, #'R'
    LCALL WRITE_DATA
    MOV A, REM
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA

WAIT_REL:
    LCALL WAIT_KEY
    AJMP RUN

DEATH:
    MOV DPTR, #TXT_ERR
    LCALL WRITE_TEXT
    LCALL WAIT_KEY
    AJMP RUN

TXT_ERR: DB 'ERR', 0
