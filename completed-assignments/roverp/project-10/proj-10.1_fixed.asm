; PROJEKT 10.1 - DZIELENIE HEX (FIXED)
; Fixes: Added LCD_INIT, Stack Safety

; --- Memory Map ---
ARG1    EQU 20h     ; Dividend (2 bytes: 20h, 21h)
ARG2    EQU 22h     ; Divisor storage (2 bytes: 22h, 23h)
RES_R   EQU 24h     ; Remainder storage (1 byte)
STACK   EQU 30h     ; Stack start address (moved away from variables)

LJMP START
ORG 100h

START:
    ; 0. System Safety Setup
    MOV SP, #STACK      ; Move Stack Pointer to 30h to avoid overwriting ARG1/ARG2
    LCALL LCD_INIT      ; [CRITICAL FIX] Initialize LCD before use
    
    ; 1. Clear Screen
    LCALL LCD_CLR

    ; 2. Input Dividend (4 digits max)
    MOV R0, #ARG1       ; R0 points to ARG1
    LCALL GET_NUM       ; Input stores here. ex: 1234 -> 20h=34, 21h=12
    
    ; Display "h/"
    MOV A, #'h'
    LCALL WRITE_DATA
    MOV A, #'/'
    LCALL WRITE_DATA

    ; 3. Input Divisor (2 digits max)
    MOV R0, #ARG2       ; R0 points to ARG2
    LCALL GET_NUM       ; ex: 20 -> 22h=20h
    
    ; Display "h"
    MOV A, #'h'
    LCALL WRITE_DATA

    ; Display " klik"
    MOV DPTR, #TXT_KLIK
    LCALL WRITE_TEXT

    ; 4. Wait for user confirmation
    LCALL WAIT_KEY
    LCALL LCD_CLR

    ; 5. Prepare for Division (DIV_2_1)
    ; Inputs: @R0 = Dividend, B = Divisor
    ; Outputs: @R0 = Quotient, A = Remainder
    
    MOV A, ARG2         ; Load divisor from ARG2 (Low byte)
    JZ DIV_ZERO         ; Error check: If divisor is 0, jump to error

    MOV B, A            ; Move divisor to B
    MOV R0, #ARG1       ; Point R0 to Dividend
    LCALL DIV_2_1       ; Execute Division

    MOV RES_R, A        ; Save Remainder from A

    ; 6. Display Result
    ; Format: ARG1h/ARG2h = RESh r REMh
    ; Note: ARG1 now holds the Quotient!
    
    ; Print Quotient (High Byte)
    MOV A, ARG1+1
    JZ SKIP_HI_Q        ; Skip leading zero if high byte is 0
    LCALL WRITE_HEX
SKIP_HI_Q:
    MOV A, ARG1         ; Print Quotient (Low Byte)
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA

    ; Print " r "
    MOV DPTR, #TXT_REM
    LCALL WRITE_TEXT

    ; Print Remainder
    MOV A, RES_R
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA

    ; Wait and Restart
    LCALL WAIT_KEY
    LJMP START

DIV_ZERO:
    MOV DPTR, #TXT_ERR
    LCALL WRITE_TEXT
    LCALL WAIT_KEY
    LJMP START

; Data
TXT_KLIK: DB ' klik', 0
TXT_REM:  DB ' r ', 0
TXT_ERR:  DB 'Error 0', 0
