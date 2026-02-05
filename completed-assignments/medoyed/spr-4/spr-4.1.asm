VAR1_L  EQU 20H
VAR1_H  EQU 21H
VAR2_L  EQU 22H
VAR2_H  EQU 23H
SUM_L   EQU 30H
SUM_M   EQU 31H
SUM_H   EQU 32H

ORG 100H
MAIN:
    LCALL LCD_CLR
    
    ; Input First 16-bit Number
    MOV R0, #VAR1_H
    ACALL READ_HEX_WORD
    
    MOV A, #'+'
    LCALL WRITE_DATA
    
    ; Input Second 16-bit Number
    MOV R0, #VAR2_H
    ACALL READ_HEX_WORD
    
    MOV A, #'='
    LCALL WRITE_DATA
    
    ; Calculate Sum
    ; Low Byte
    MOV A, VAR1_L
    ADD A, VAR2_L
    MOV SUM_L, A
    
    ; Middle Byte (with Carry)
    MOV A, VAR1_H
    ADDC A, VAR2_H
    MOV SUM_M, A
    
    ; High Byte (Carry only)
    MOV A, #0
    ADDC A, #0
    MOV SUM_H, A
    
    ; Display Result on Line 2
    MOV A, #0C0H
    LCALL WRITE_INSTR
    
    MOV A, SUM_H
    LCALL WRITE_HEX
    MOV A, SUM_M
    LCALL WRITE_HEX
    MOV A, SUM_L
    LCALL WRITE_HEX
    
    MOV A, #'h'
    LCALL WRITE_DATA
    
    MOV DPTR, #MSG_WAIT
    LCALL WRITE_TEXT
    
    LCALL WAIT_KEY
    AJMP MAIN

; --- Subroutines ---

READ_HEX_WORD:
    ; Manually reads 4 hex digits to form 2 bytes
    ; Digit 1 (Hi-Hi)
    ACALL INPUT_NIBBLE
    SWAP A
    MOV R2, A
    
    ; Digit 2 (Hi-Lo)
    ACALL INPUT_NIBBLE
    ORL A, R2
    MOV @R0, A      ; Store High Byte
    
    ; Digit 3 (Lo-Hi)
    ACALL INPUT_NIBBLE
    SWAP A
    MOV R2, A
    
    ; Digit 4 (Lo-Lo)
    ACALL INPUT_NIBBLE
    ORL A, R2
    DEC R0
    MOV @R0, A      ; Store Low Byte
    
    MOV A, #'h'
    LCALL WRITE_DATA
    RET

INPUT_NIBBLE:
    LCALL WAIT_KEY
    MOV R3, A       ; Backup value
    ; Print Digit
    CJNE A, #10, CHECK_NUM
CHECK_NUM:
    JC PRINT_NUM
    ADD A, #7
PRINT_NUM:
    ADD A, #30H
    LCALL WRITE_DATA
    MOV A, R3       ; Restore value
    RET

MSG_WAIT: DB ' klik', 0
