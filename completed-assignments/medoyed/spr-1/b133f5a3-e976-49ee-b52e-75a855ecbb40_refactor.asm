; Refactor: to samo dzialanie (LED+BUZZER razem ON/OFF,
; kazda faza trwa (Y+2)*256 ms, STOP po ~20 ms trzymania ENTER,
; po STOP komunikat na LCD), ale inna struktura petli.

HOLD    EQU 30H        ; odliczanie "hold" w ms (20..0)
MODE    EQU 31H        ; 0 => ON, 1 => OFF

ORG 0000H
        LJMP    START

ORG 0100H
START:
        LCALL   LCD_INIT
        LCALL   LCD_CLR

        ; Y = ostatnia cyfra indeksu (tu: 7)
        MOV     R3,#7

        ; stan bezpieczny (aktywnie niskie)
        SETB    P1.7
        SETB    P1.5

        MOV     HOLD,#0
        MOV     MODE,#0

LOOP_MAIN:
        ACALL   APPLY_MODE
        LCALL   WAIT_YPLUS2_BLOCKS
        XRL     MODE,#01H
        SJMP    LOOP_MAIN

; Ustawia LED/BUZZER zgodnie z MODE (aktywnie niskie)
APPLY_MODE:
        MOV     A,MODE
        JZ      AM_ON

        ; OFF
        SETB    P1.7
        SETB    P1.5
        RET

AM_ON:
        ; ON
        CLR     P1.7
        CLR     P1.5
        RET

; Opoznienie (Y+2)*256 ms, gdzie Y=R3
WAIT_YPLUS2_BLOCKS:
        MOV     R2,R3
        INC     R2
        INC     R2              ; R2 = Y+2

WB_LOOP:
        LCALL   WAIT_256MS_STOP
        DJNZ    R2,WB_LOOP
        RET

; 256 ms z detekcja STOP
WAIT_256MS_STOP:
        MOV     R7,#0           ; 256 iteracji

W256_LOOP:
        MOV     A,#1
        LCALL   DELAY_MS

        LCALL   TEST_ENTER
        JC      W256_REL

        ; ENTER wcisniety: odliczaj 20 ms
        MOV     A,HOLD
        JNZ     W256_COUNT
        MOV     HOLD,#20

W256_COUNT:
        DJNZ    HOLD,W256_NEXT
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

HANG:
        SJMP    HANG

MSG_END:
        DB      '!TO JUZ KONIEC!',0

END
