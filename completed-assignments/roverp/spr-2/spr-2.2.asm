; Zadanie 2.2 - Mnozenie Hex/Dec
; Indeks: 121546
; Test: 170 * 150 = 25500

VAR_A   EQU 20H
VAR_B   EQU 22H
RES_L   EQU 25H
RES_H   EQU 26H
BCD_BUF EQU 30H

ORG 100H
START:
    LCALL LCD_CLR
    
    MOV R0, #VAR_A
    ACALL GET_BYTE
    
    MOV A, #'*'
    LCALL WRITE_DATA
    
    MOV R0, #VAR_B
    ACALL GET_BYTE
    
    LCALL WAIT_KEY
    LCALL LCD_CLR
    
    MOV A, VAR_A
    MOV B, VAR_B
    MUL AB
    MOV RES_L, A
    MOV RES_H, B
    
    MOV A, VAR_A
    ACALL SHOW_HEX_SFX
    
    MOV A, #'*'
    LCALL WRITE_DATA
    
    MOV A, VAR_B
    ACALL SHOW_HEX_SFX
    
    MOV A, #'='
    LCALL WRITE_DATA
    
    
    MOV A, RES_H
    JZ SKIP_ZERO_HI
    LCALL WRITE_HEX
SKIP_ZERO_HI:
    MOV A, RES_L
    ACALL SHOW_HEX_SFX
    
    
    MOV A, #0C0H        
    LCALL WRITE_INSTR
    
    MOV A, VAR_A
    ACALL SHOW_DEC
    
    MOV A, #'*'
    LCALL WRITE_DATA
    
    MOV A, VAR_B
    ACALL SHOW_DEC
    
    MOV A, #'='
    LCALL WRITE_DATA
    
    
    ACALL WIPE_BUF
    MOV A, RES_L
    MOV BCD_BUF, A
    MOV A, RES_H
    MOV BCD_BUF+1, A
    
    MOV R0, #BCD_BUF
    LCALL HEX_BCD
    ACALL PRINT_BCD_STR

    LCALL WAIT_KEY
    AJMP START



GET_BYTE:
    LCALL GET_NUM
    LCALL BCD_HEX
    MOV A, @R0      ; Mlodszy
    INC R0
    MOV A, @R0      ; Starszy
    DEC R0
    JNZ START       ; Blad jak > 255
    RET

SHOW_HEX_SFX:
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA
    RET

SHOW_DEC:
    ACALL WIPE_BUF
    MOV BCD_BUF, A
    MOV R0, #BCD_BUF
    LCALL HEX_BCD
    ACALL PRINT_BCD_STR
    RET

PRINT_BCD_STR:
    ; Wyswietla bufor BCD (3 bajty)
    MOV A, BCD_BUF+2
    JNZ FULL_PRINT
    MOV A, BCD_BUF+1
    JNZ MID_PRINT
    MOV A, BCD_BUF
    LCALL WRITE_HEX
    RET
FULL_PRINT:
    LCALL WRITE_HEX
MID_PRINT:
    MOV A, BCD_BUF+1
    LCALL WRITE_HEX
    MOV A, BCD_BUF
    LCALL WRITE_HEX
    RET

WIPE_BUF:
    CLR A
    MOV BCD_BUF, A
    MOV BCD_BUF+1, A
    MOV BCD_BUF+2, A
    RET
