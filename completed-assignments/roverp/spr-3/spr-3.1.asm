; Zadanie 3.1 - Odejmowanie ze znakiem
; Indeks: 121546
; Test Negative: 28 - 55 = -27

VAL1    EQU 20H
VAL2    EQU 22H
RES     EQU 25H
BUF     EQU 30H

ORG 100H
START:
    LCALL LCD_CLR
    MOV DPTR, #TXT_REQ
    LCALL WRITE_TEXT

    ; --- INPUT 1 ---
    MOV R0, #VAL1
    LCALL GET_NUM
    LCALL BCD_HEX
    ; Limit check: Must be <= 127 (7Fh)
    MOV A, VAL1
    JB ACC.7, DIE_SCUM    ; If bit 7 is set, it's > 127. Die.
    
    MOV A, #'-'
    LCALL WRITE_DATA

    ; --- INPUT 2 ---
    MOV R0, #VAL2
    LCALL GET_NUM
    LCALL BCD_HEX
    ; Limit check
    MOV A, VAL2
    JB ACC.7, DIE_SCUM

    AJMP DO_MATH

DIE_SCUM:
    MOV DPTR, #TXT_ERR
    LCALL WRITE_TEXT
    LCALL WAIT_KEY
    AJMP START

DO_MATH:
    MOV DPTR, #TXT_GO
    LCALL WRITE_TEXT
    LCALL WAIT_KEY
    LCALL LCD_CLR

    ; --- HEX LINE ---
    MOV A, VAL1
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA
    
    MOV A, #'-'
    LCALL WRITE_DATA
    
    MOV A, VAL2
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA
    
    MOV A, #'='
    LCALL WRITE_DATA

    ; Calc Subtraction
    MOV A, VAL1
    CLR C
    SUBB A, VAL2
    MOV RES, A          ; Store raw result (U2 format)

    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA

    ; --- DEC LINE ---
    MOV A, #0C0H        ; Next Line
    LCALL WRITE_INSTR

    ; Print VAL1 Dec
    MOV A, VAL1
    ACALL DUMP_DEC
    MOV A, #'d'
    LCALL WRITE_DATA
    
    MOV A, #'-'
    LCALL WRITE_DATA

    ; Print VAL2 Dec
    MOV A, VAL2
    ACALL DUMP_DEC
    MOV A, #'d'
    LCALL WRITE_DATA
    
    MOV A, #'='
    LCALL WRITE_DATA

    ; --- SIGN LOGIC ---
    MOV A, RES
    JB ACC.7, IS_NEG    ; If Bit 7 is 1, it's negative
    
    ; Positive? Just print.
    ACALL DUMP_DEC
    SJMP FINISH

IS_NEG:
    ; Negative? Print '-' then fix the number
    MOV A, #'-'
    LCALL WRITE_DATA
    
    MOV A, RES
    CPL A               ; Invert bits
    INC A               ; Add 1 (2's Complement -> Absolute)
    ACALL DUMP_DEC

FINISH:
    MOV A, #'d'
    LCALL WRITE_DATA
    LCALL WAIT_KEY
    AJMP START

DUMP_DEC:
    MOV BUF, A
    MOV BUF+1, #0
    MOV BUF+2, #0
    MOV R0, #BUF
    LCALL HEX_BCD
    
    ; Skip leading zeros or look stupid
    MOV A, BUF+1
    JZ SKIP_TENS
    ACALL PUT_HEX
    MOV A, BUF
    ACALL PUT_HEX
    RET
SKIP_TENS:
    MOV A, BUF
    ACALL PUT_HEX
    RET

PUT_HEX:
    MOV R2, A
    SWAP A
    ANL A, #0FH
    ADD A, #'0'
    LCALL WRITE_DATA
    MOV A, R2
    ANL A, #0FH
    ADD A, #'0'
    LCALL WRITE_DATA
    RET

TXT_REQ: DB 'Arg <= 127', 0
TXT_GO:  DB ' klik', 0
TXT_ERR: DB ' ERROR', 0
