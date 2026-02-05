; Refactor: to samo dzialanie (naprzemiennie LED i BUZZER co 256 ms,
; STOP po ~20 ms ciaglego trzymania ENTER, po STOP napis na LCD),
; ale inna organizacja petli i detekcji hold.

HOLD    EQU 30H        ; odliczanie "hold" w ms (20..1..0)
MODE    EQU 31H        ; 0 => LED ON / BUZZER OFF, 1 => LED OFF / BUZZER ON

ORG 0000H
        LJMP    START

ORG 0100H
START:
        LCALL   LCD_INIT
        LCALL   LCD_CLR

        ; stan bezpieczny
        SETB    P1.7
        SETB    P1.5

        MOV     HOLD,#0
        MOV     MODE,#0

MAIN:
        ACALL   APPLY_MODE
        LCALL   WAIT_256MS_STOP
        XRL     MODE,#01H
        SJMP    MAIN

; Ustawia wyjscia zgodnie z MODE
APPLY_MODE:
        MOV     A,MODE
        JZ      AM_LED

        ; MODE=1 => LED OFF, BUZZER ON
        SETB    P1.7
        CLR     P1.5
        RET

AM_LED:
        ; MODE=0 => LED ON, BUZZER OFF
        CLR     P1.7
        SETB    P1.5
        RET

; 256 ms = 256 * 1 ms, z detekcja STOP w trakcie oczekiwania
; TEST_ENTER: C=0 pressed, C=1 released
WAIT_256MS_STOP:
        MOV     R7,#0           ; 256 iteracji (DJNZ z 0 daje 256)

W256_LOOP:
        MOV     A,#1
        LCALL   DELAY_MS

        LCALL   TEST_ENTER
        JC      W256_REL

        ; ENTER wcisniety: startuj lub kontynuuj odliczanie 20 ms
        MOV     A,HOLD
        JNZ     W256_COUNT
        MOV     HOLD,#20

W256_COUNT:
        DJNZ    HOLD,W256_NEXT  ; po 20 ms HOLD spadnie do 0
        SJMP    STOP_NOW

W256_REL:
        MOV     HOLD,#0

W256_NEXT:
        DJNZ    R7,W256_LOOP
        RET

STOP_NOW:
        SETB    P1.7
        SETB    P1.5

        LCALL   LCD_CLR
        MOV     DPTR,#MSG_END
        LCALL   WRITE_TEXT

HALT:
        SJMP    HALT

MSG_END:
        DB      'TO KONIEC.',0

END
