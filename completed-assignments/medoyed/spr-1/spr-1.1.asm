SYS_STATE   EQU 40H     ; System state register

ORG 0000H
    LJMP INIT_MAIN

ORG 0100H
INIT_MAIN:
    LCALL LCD_INIT
    LCALL LCD_CLR

    ; Set initial Safe State (High Impedance/OFF)
    SETB P1.7
    SETB P1.5

    MOV SYS_STATE, #0   ; Initialize state counter

MAIN_EXEC:
    ACALL TOGGLE_OUTPUTS
    
    ; Delay block (256ms)
    MOV A, #0           ; 0 triggers 256 loops in BIOS
    LCALL DELAY_MS

    ; Check for Stop Condition
    ACALL MONITOR_INPUT
    
    SJMP MAIN_EXEC

; --- Control Logic ---

TOGGLE_OUTPUTS:
    ; Invert state logic
    MOV A, SYS_STATE
    XRL A, #01H
    MOV SYS_STATE, A
    
    JNZ STATE_OFF

STATE_ON:
    CLR P1.7            ; Activate LED
    CLR P1.5            ; Activate Buzzer
    RET

STATE_OFF:
    SETB P1.7           ; Deactivate LED
    SETB P1.5           ; Deactivate Buzzer
    RET

MONITOR_INPUT:
    LCALL TEST_ENTER
    JNC DEBOUNCE        ; Carry=0 means Key Pressed

    RET                 ; Key Released, return

DEBOUNCE:
    ; Verify hold for 20ms
    MOV R5, #20

VERIFY_LOOP:
    MOV A, #1
    LCALL DELAY_MS      ; 1ms step
    
    LCALL TEST_ENTER
    JC RETURN_SAFE      ; Key released prematurely
    
    DJNZ R5, VERIFY_LOOP

    ; Confirmed Stop
    SJMP SYSTEM_HALT

RETURN_SAFE:
    RET

SYSTEM_HALT:
    ; Shutdown outputs
    SETB P1.7
    SETB P1.5
    
    LCALL LCD_CLR
    MOV DPTR, #MSG_TERM
    LCALL WRITE_TEXT

HALT_LOOP:
    SJMP HALT_LOOP

MSG_TERM:
    DB 'TO KONIEC.', 0

END
