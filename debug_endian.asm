; DEBUG DIAGNOSTIC - ENDIANNESS CHECKER
; Goal: Determine how GET_NUM stores bytes in memory

ARG1    EQU 20h
ARG2    EQU 22h

LJMP START
ORG 100h

START:
    LCALL LCD_INIT
    LCALL LCD_CLR

    ; TEST 1: 4 Digits
    ; Display "In:1234"
    MOV DPTR, #TXT_IN1
    LCALL WRITE_TEXT
    
    ; Read to ARG1 (20h)
    MOV R0, #ARG1
    LCALL GET_NUM
    
    ; New Line (Simulated by clearing or spacing? Just Clear for clarity)
    LCALL LCD_CLR
    
    ; Display "20h=[Val] 21h=[Val]"
    MOV A, #20h         ; Print "20="
    LCALL WRITE_HEX
    MOV A, #'='
    LCALL WRITE_DATA
    
    MOV A, ARG1         ; Read First Byte
    LCALL WRITE_HEX
    
    MOV A, #' '
    LCALL WRITE_DATA
    
    MOV A, #21h         ; Print "21="
    LCALL WRITE_HEX
    MOV A, #'='
    LCALL WRITE_DATA
    
    MOV A, ARG1+1       ; Read Second Byte
    LCALL WRITE_HEX
    
    LCALL WAIT_KEY

    ; TEST 2: 2 Digits
    LCALL LCD_CLR
    MOV DPTR, #TXT_IN2
    LCALL WRITE_TEXT    ; "In:10"
    
    MOV R0, #ARG2
    LCALL GET_NUM
    
    LCALL LCD_CLR
    
    ; Display "22h=[Val] 23h=[Val]"
    MOV A, #22h
    LCALL WRITE_HEX
    MOV A, #'='
    LCALL WRITE_DATA
    
    MOV A, ARG2
    LCALL WRITE_HEX
    
    MOV A, #' '
    LCALL WRITE_DATA
    
    MOV A, #23h
    LCALL WRITE_HEX
    MOV A, #'='
    LCALL WRITE_DATA
    
    MOV A, ARG2+1
    LCALL WRITE_HEX
    
    LCALL WAIT_KEY
    LJMP START

TXT_IN1: DB 'Type 1234', 0
TXT_IN2: DB 'Type 10', 0
