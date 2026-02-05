; Zadanie 4.1 - Dodawanie 16-bit
; Indeks: 121546 (X=4, Y=6)
; Test 1: 2086h + 1204h = 328Ah
; Test 2: 2536h + 29D3h = 4F09h

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
    
    
    MOV A, #0C0H
    LCALL WRITE_INSTR
    
    
    MOV A, ARG1_LO
    ADD A, ARG2_LO
    MOV RES_LO, A
    
    
    MOV A, ARG1_HI
    ADDC A, ARG2_HI
    MOV RES_MID, A
    
    
    MOV A, #0
    ADDC A, #0
    MOV RES_HI, A
    
    
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
    
    ; Uzywa standardowych procedur, ale skleja je recznie
    
    ; High Byte
    LCALL GET_NUM ; Czyta decimal, ale my chcemy hex cyfry...
    ; STOP. PDF mowi: "procedura umożliwia wczytanie dokładnie 4 znaków"
    ; Standardowe GET_NUM/BCD_HEX dziala na decimal.
    ; Musimy napisac wlasne wczytywanie znak po znaku.
    
    ; Znak 1 (Hi Nibble of Hi Byte)
    LCALL GET_HEX_DIGIT
    SWAP A
    MOV R1, A
    
    ; Znak 2 (Lo Nibble of Hi Byte)
    LCALL GET_HEX_DIGIT
    ORL A, R1
    MOV @R0, A ; Zapisz Hi Byte
    
    ; Znak 3 (Hi Nibble of Lo Byte)
    LCALL GET_HEX_DIGIT
    SWAP A
    MOV R1, A
    
    ; Znak 4 (Lo Nibble of Lo Byte)
    LCALL GET_HEX_DIGIT
    ORL A, R1
    DEC R0
    MOV @R0, A 
    
    
    MOV A, #'h'
    LCALL WRITE_DATA
    RET

GET_HEX_DIGIT:
    LCALL WAIT_KEY
    MOV R2, A   
    ; Konwersja na ASCII do wyswietlenia
    CJNE A, #10, CHK_DIG
CHK_DIG:
    JC IS_NUM
    ADD A, #7
IS_NUM:
    ADD A, #'0'
    LCALL WRITE_DATA
    MOV A, R2   ; Restore val
    RET

TXT_CLICK: DB ' klik', 0
