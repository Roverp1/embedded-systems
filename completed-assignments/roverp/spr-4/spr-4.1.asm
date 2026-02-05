; Zadanie 4.1 - Dodawanie 16-bit (Fixed)
; Indeks: 121546 (X=4, Y=6)
; Test 1: 2086h + 1204h = 00328Ah
; Test 2: 2536h + 29D3h = 004F09h

ARG1_LO EQU 20H
ARG1_HI EQU 21H
ARG2_LO EQU 22H
ARG2_HI EQU 23H
RES_LO  EQU 30H
RES_MID EQU 31H
RES_HI  EQU 32H

ORG 100H
START:
    LCALL LCD_CLR
    
    
    MOV R0, #ARG1_HI 
    ACALL GET_WORD
    
    MOV A, #'+'
    LCALL WRITE_DATA
    
    
    MOV R0, #ARG2_HI
    ACALL GET_WORD
    
    MOV A, #'='
    LCALL WRITE_DATA
    
    
    
    
    MOV A, ARG1_LO
    ADD A, ARG2_LO
    MOV RES_LO, A
    
    
    MOV A, ARG1_HI
    ADDC A, ARG2_HI
    MOV RES_MID, A
    
    
    MOV A, #0
    ADDC A, #0
    MOV RES_HI, A
    
    
    MOV A, #0C0H
    LCALL WRITE_INSTR
    
    MOV A, RES_HI
    LCALL WRITE_HEX
    MOV A, RES_MID
    LCALL WRITE_HEX
    MOV A, RES_LO
    LCALL WRITE_HEX
    
    MOV A, #'h'
    LCALL WRITE_DATA
    
    MOV DPTR, #TXT_CLICK
    LCALL WRITE_TEXT
    
    LCALL WAIT_KEY
    AJMP START



GET_WORD:
    
    
    
    
    
    ACALL GET_HEX_DIGIT
    SWAP A
    MOV R1, A
    
    
    ACALL GET_HEX_DIGIT
    ORL A, R1
    MOV @R0, A      
    
    
    DEC R0          
    
    
    ACALL GET_HEX_DIGIT
    SWAP A
    MOV R1, A
    
    
    ACALL GET_HEX_DIGIT
    ORL A, R1
    MOV @R0, A      
    
    MOV A, #'h'
    LCALL WRITE_DATA
    RET

GET_HEX_DIGIT:
    LCALL WAIT_KEY
    MOV R2, A       
    
    
    CJNE A, #10, CHECK_NUM
CHECK_NUM:
    JC IS_DIGIT     
    ADD A, #7       
IS_DIGIT:
    ADD A, #'0'
    LCALL WRITE_DATA
    
    MOV A, R2       ; Przywroc wartosc surowa do obliczen
    RET

TXT_CLICK: DB ' klik', 0
