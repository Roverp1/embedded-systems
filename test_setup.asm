; TEST PROGRAM - ENVIRONMENT CHECK
; Based on Lecture 4 BIOS Subroutines
; Goal: Verify LCD and Keypad are working in Jagoda

LJMP START
ORG 100h

START:
    ; 1. Initialize System
    LCALL LCD_INIT      ; [IMPORTANT] Initialize LCD Driver
    LCALL LCD_CLR       ; Clear screen content

    ; 2. Print Test Message
    MOV DPTR, #MSG_OK   ; Point to message
    LCALL WRITE_TEXT    ; Print "JAGODA OK"

    ; 3. Wait for Interaction
    LCALL WAIT_KEY      ; Wait for user to press any key
    
    ; 4. Feedback
    LCALL LCD_CLR       ; Clear screen
    MOV DPTR, #MSG_END  ; Point to end message
    LCALL WRITE_TEXT    ; Print "DONE"
    
    SJMP $              ; Infinite loop (Stop)

; Data Definitions
MSG_OK:  DB 'JAGODA OK', 0
MSG_END: DB 'DONE', 0
