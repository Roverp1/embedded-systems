; Zadanie 1.1 - LED+Buzzer 256ms
; Indeks: 121546
; Styl: Szybki, brudny, dziala.

FLAGS   EQU 20H     ; 0=ON, 1=OFF

ORG 0000H
    LJMP START

ORG 0100H
START:
    LCALL LCD_INIT
    LCALL LCD_CLR

    ; Wylacz to cholerstwo na start
    SETB P1.7
    SETB P1.5
    MOV FLAGS, #1   ; Zaczynamy od OFF

LOOP_HELL:
    ACALL SWITCH_IO ; Przelacz stan
    
    ; Czekaj 256ms (A=0 w Biosie to 256)
    MOV A, #0
    LCALL DELAY_MS

    ; Sprawdz czy ktos trzyma Enter
    LCALL CHECK_KILL
    
    SJMP LOOP_HELL

SWITCH_IO:
    ; Negacja stanu
    MOV A, FLAGS
    CPL A
    ANL A, #1
    MOV FLAGS, A
    
    JZ TURN_ON

TURN_OFF:
    SETB P1.7
    SETB P1.5
    RET

TURN_ON:
    CLR P1.7
    CLR P1.5
    RET

CHECK_KILL:
    LCALL TEST_ENTER
    JC EXIT_CHK     ; Puszczony? Spadaj.

    ; Trzymany. Czekaj 20ms zeby miec pewnosc.
    MOV R6, #20
WAIT_KILL:
    MOV A, #1
    LCALL DELAY_MS
    LCALL TEST_ENTER
    JC EXIT_CHK     ; Puscil. Falszywy alarm.
    DJNZ R6, WAIT_KILL

    ; Koniec zabawy.
    SETB P1.7
    SETB P1.5
    
    LCALL LCD_CLR
    MOV DPTR, #TEXT_DEAD
    LCALL WRITE_TEXT

FREEZE:
    SJMP FREEZE

EXIT_CHK:
    RET

TEXT_DEAD:
    DB 'TO KONIEC.', 0

END
