; Zadanie 4.2 - Mnozenie 16x8
; Indeks: 121546
; Test: 2F58h * 187d = 229548h

ARG1_HI EQU 20H
ARG1_LO EQU 21H
ARG2    EQU 22H
RES_LO  EQU 30H
RES_MID EQU 31H
RES_HI  EQU 32H

ORG 100H
START:
    LCALL LCD_CLR
    
    
    
    
    MOV R0, #ARG1_HI
    LCALL GET_NUM
    
    MOV A, #'*'
    LCALL WRITE_DATA
    
    
    
    MOV R0, #ARG2
    LCALL GET_NUM
    LCALL BCD_HEX
    
    MOV A, #'='
    LCALL WRITE_DATA
    
    
    
    
    MOV A, ARG1_LO
    MOV B, ARG2
    MUL AB          
    MOV RES_LO, A
    MOV RES_MID, B  
    
    
    MOV A, ARG1_HI
    MOV B, ARG2
    MUL AB          
    
    
    ADD A, RES_MID
    MOV RES_MID, A
    
    
    MOV A, B
    ADDC A, #0
    MOV RES_HI, A
    
    
    ; Wypisujemy wynik Hex (3 bajty)
    MOV A, RES_HI
    LCALL WRITE_HEX
    MOV A, RES_MID
    LCALL WRITE_HEX
    MOV A, RES_LO
    LCALL WRITE_HEX
    
    MOV DPTR, #TXT_KLIK
    LCALL WRITE_TEXT
    
    LCALL WAIT_KEY
    AJMP START

TXT_KLIK: DB ' klik', 0
