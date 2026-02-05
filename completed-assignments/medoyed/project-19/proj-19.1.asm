ARG1    EQU 30h     ; First operand (1 byte)
ARG2    EQU 31h     ; Second operand (1 byte)
RES_HI  EQU 32h     ; Multiplication result High
RES_LO  EQU 33h     ; Multiplication result Low / Division Quotient
REM     EQU 34h     ; Division Remainder

LJMP START
ORG 100h

START:
    LCALL LCD_CLR
    
    ; 1. Prompt "Kliknij 4 znaki"
    MOV DPTR, #TXT_PROMPT
    LCALL WRITE_TEXT
    
    ; MOVE CURSOR TO LINE 2 (Fix for display overflow)
    MOV A, #0C0h
    LCALL WRITE_INSTR

    ; 2. Read 4 Keys (Echoing to Line 2)
    
    ; --- Read ARG1 (High Nibble) ---
    LCALL READ_NIBBLE
    SWAP A
    MOV ARG1, A
    
    ; --- Read ARG1 (Low Nibble) ---
    LCALL READ_NIBBLE
    ORL A, ARG1
    MOV ARG1, A
    
    ; --- Read ARG2 (High Nibble) ---
    LCALL READ_NIBBLE
    SWAP A
    MOV ARG2, A
    
    ; --- Read ARG2 (Low Nibble) ---
    LCALL READ_NIBBLE
    ORL A, ARG2
    MOV ARG2, A

    ; 3. Wait slightly so user sees what they typed
    MOV A, #5       ; Short delay
    LCALL DELAY_100MS

    ; 4. Clear Screen and Perform Math
    LCALL LCD_CLR
    
    ; --- LINE 1: Multiplication ---
    ; Print "ARG1*ARG2="
    MOV A, ARG1
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA
    MOV A, #'*'
    LCALL WRITE_DATA
    MOV A, ARG2
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA
    MOV A, #'='
    LCALL WRITE_DATA
    
    ; Calculate ARG1 * ARG2
    MOV A, ARG1
    MOV B, ARG2
    MUL AB          ; Result: B (High), A (Low)
    MOV RES_HI, B
    MOV RES_LO, A
    
    ; Print Result (2 Bytes)
    MOV A, RES_HI
    LCALL WRITE_HEX
    MOV A, RES_LO
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA

    ; --- LINE 2: Division ---
    ; Move cursor to 2nd line
    MOV A, #0C0h
    LCALL WRITE_INSTR
    
    ; Print "ARG1/ARG2="
    MOV A, ARG1
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA
    MOV A, #'/'
    LCALL WRITE_DATA
    MOV A, ARG2
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA
    MOV A, #'='
    LCALL WRITE_DATA
    
    ; Check Zero Division
    MOV A, ARG2
    JZ DIV_BY_ZERO
    
    ; Calculate ARG1 / ARG2
    MOV A, ARG1
    MOV B, ARG2
    DIV AB          ; Result: A (Quotient), B (Remainder)
    MOV RES_LO, A
    MOV REM, B
    
    ; Print Quotient
    MOV A, RES_LO
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA
    
    ; Check Remainder
    MOV A, REM
    JZ WAIT_FINISH  ; If 0, don't print
    
    ; Print Remainder " rXXh"
    MOV A, #' '
    LCALL WRITE_DATA
    MOV A, #'r'
    LCALL WRITE_DATA
    MOV A, REM
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA
    SJMP WAIT_FINISH

DIV_BY_ZERO:
    MOV DPTR, #TXT_ERR
    LCALL WRITE_TEXT

WAIT_FINISH:
    LCALL WAIT_KEY
    LJMP START

; --- Subroutines ---
READ_NIBBLE:
    LCALL WAIT_KEY      ; Get Key Code (0-15)
    PUSH ACC            ; Save Key Code
    ACALL SHOW_DIGIT    ; Echo to LCD
    POP ACC             ; Restore Key Code
    RET

SHOW_DIGIT:
    ; Standard 8051 Check for A-F
    CJNE A, #10, CHECK_DIG
CHECK_DIG:
    JC IS_NUM           ; If Carry=1, it is 0-9
    ADD A, #7           ; Adjust for A-F
IS_NUM:
    ADD A, #'0'         ; Convert to ASCII
    LCALL WRITE_DATA
    RET

; Data
TXT_PROMPT: DB 'Kliknij 4 znaki', 0
TXT_ERR:    DB 'Err', 0
