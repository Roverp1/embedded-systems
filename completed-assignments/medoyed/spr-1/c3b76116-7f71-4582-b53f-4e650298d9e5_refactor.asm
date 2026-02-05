; Refactor: to samo dzialanie (LED+BUZZER razem ON/OFF co ~256 ms,
; STOP po ~20 ms ciaglego trzymania ENTER), ale inna struktura kodu.

STATE   EQU 32H        ; 0 = ON, 1 = OFF (dla wyjsc aktywnie niskich)

ORG 0000H
        LJMP    BOOT

ORG 0100H
BOOT:
        ; stan bezpieczny
        SETB    P1.7            ; LED OFF
        SETB    P1.5            ; BUZZER OFF

        MOV     STATE,#1        ; zacznij od OFF (pierwsza petla ustawi ON)

RUN:
        XRL     STATE,#01H      ; przelacz faze (0<->1)
        LCALL   APPLY_STATE

        ; odczekaj ~256 ms
        MOV     A,#0            ; A=0 => 256 ms w DELAY_MS
        LCALL   DELAY_MS

        ; sprawdz STOP (ENTER trzymany ~20 ms)
        LCALL   STOP_IF_HELD

        SJMP    RUN

; Ustawia wyjscia zgodnie ze STATE
APPLY_STATE:
        MOV     A,STATE
        JNZ     AS_OFF

        ; STATE=0 => ON (aktywnie niskie)
        CLR     P1.7
        CLR     P1.5
        RET

AS_OFF:
        SETB    P1.7
        SETB    P1.5
        RET

; TEST_ENTER: C=0 pressed, C=1 released
; STOP, jezeli ENTER jest wcisniety bez przerwy przez ok. 20 ms
STOP_IF_HELD:
        LCALL   TEST_ENTER
        JC      SIH_RET         ; puszczony

        MOV     R7,#20
SIH_LOOP:
        MOV     A,#1
        LCALL   DELAY_MS        ; 1 ms
        LCALL   TEST_ENTER
        JC      SIH_RET         ; puscil przed uplywem 20 ms
        DJNZ    R7,SIH_LOOP

        ; STOP: wylacz i zawies program
        SETB    P1.7
        SETB    P1.5
SIH_HANG:
        SJMP    SIH_HANG

SIH_RET:
        RET

END
