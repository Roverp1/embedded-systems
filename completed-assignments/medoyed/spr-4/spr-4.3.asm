DVD_H   EQU 20H     ; Dividend
DVD_L   EQU 21H
DVR     EQU 22H     ; Divisor
REM     EQU 23H     ; Remainder
CNT     EQU 24H

ORG 100H
START_PROG:
    LCALL LCD_CLR
    
    ; Input Dividend (Decimal)
    MOV R0, #DVD_H
    LCALL GET_NUM
    LCALL BCD_HEX
    
    MOV A, #'d'
    LCALL WRITE_DATA
    MOV A, #'/'
    LCALL WRITE_DATA
    
    ; Input Divisor (Decimal)
    MOV R0, #DVR
    LCALL GET_NUM
    LCALL BCD_HEX
    
    MOV A, #'d'
    LCALL WRITE_DATA
    MOV A, #'='
    LCALL WRITE_DATA
    
    ; Validate Divisor
    MOV A, DVR
    JZ ERROR_DIV
    
    ; --- 16/8 Bit Division Algorithm ---
    MOV CNT, #16        ; 16 cycles
    MOV REM, #0         ; Clear Remainder
    
BIT_LOOP:
    ; Shift Dividend Left (MSB into Carry)
    CLR C
    MOV A, DVD_L
    RLC A
    MOV DVD_L, A
    
    MOV A, DVD_H
    RLC A
    MOV DVD_H, A
    
    ; Rotate Carry into Remainder LSB
    MOV A, REM
    RLC A
    MOV REM, A
    
    ; Compare Remainder with Divisor
    CLR C
    SUBB A, DVR
    JC NO_SUB
    
    ; If Rem >= Div, subtract and set Quotient bit
    MOV REM, A
    INC DVD_L           ; Set LSB of Quotient (stored in Dividend)
    
NO_SUB:
    DJNZ CNT, BIT_LOOP
    
    ; Result is now in DVD_H:DVD_L (Quotient)
    
    ; --- Display ---
    MOV A, DVD_H
    LCALL WRITE_HEX
    MOV A, DVD_L
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA
    
    ; Show Remainder if Non-Zero
    MOV A, REM
    JZ FINISH
    
    MOV A, #' '
    LCALL WRITE_DATA
    MOV A, #'R'
    LCALL WRITE_DATA
    MOV A, REM
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA

FINISH:
    LCALL WAIT_KEY
    AJMP START_PROG

ERROR_DIV:
    MOV DPTR, #MSG_ERR
    LCALL WRITE_TEXT
    LCALL WAIT_KEY
    AJMP START_PROG

MSG_ERR: DB 'Err', 0
