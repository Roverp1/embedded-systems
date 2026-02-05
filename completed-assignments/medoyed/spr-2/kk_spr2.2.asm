ARG1    EQU 20h
ARG2    EQU 22h
RES     EQU 25h
ROB     EQU 30h

        LJMP    MAIN
        ORG     100h

MAIN:
        LCALL   LCD_CLR

        MOV     R0,#ARG1
        ACALL   READ1B
        MOV     A,#'*'
        LCALL   WRITE_DATA

        MOV     R0,#ARG2
        ACALL   READ1B

        LCALL   WAIT_KEY
        LCALL   LCD_CLR

        MOV     A,ARG1
        MOV     B,A
        MOV     A,ARG2
        MUL     AB              ; A=lo, B=hi

        MOV     RES,A
        MOV     RES+1,B


        ; WYPIS HEX: ARG1h*ARG2h= (wynik)h
        MOV     A,ARG1
        ACALL   PUT_HEX_H
        MOV     A,#'*'
        LCALL   WRITE_DATA
        MOV     A,ARG2
        ACALL   PUT_HEX_H
        MOV     A,#'='
        LCALL   WRITE_DATA

        MOV     A,RES+1
        JZ      HX_SKIP_HI
        LCALL   WRITE_HEX
HX_SKIP_HI:
        MOV     A,RES
        ACALL   PUT_HEX_H

        MOV     A,RES+1
        JNZ     WIDE
        MOV     R2,#5
        SJMP    DO_SP
WIDE:   MOV     R2,#3
DO_SP:  ACALL   SPACES

        ; WYPIS BCD: ARG1*ARG2=wynik (BCD)
        ACALL   CLR_ROB
        MOV     A,ARG1
        MOV     ROB,A
        MOV     R0,#ROB
        LCALL   HEX_BCD
        ACALL   PUT_BCD

        MOV     A,#'*'
        LCALL   WRITE_DATA

        ACALL   CLR_ROB
        MOV     A,ARG2
        MOV     ROB,A
        MOV     R0,#ROB
        LCALL   HEX_BCD
        ACALL   PUT_BCD

        MOV     A,#'='
        LCALL   WRITE_DATA

        ACALL   CLR_ROB
        MOV     A,RES
        MOV     ROB,A
        MOV     A,RES+1
        MOV     ROB+1,A
        MOV     R0,#ROB
        LCALL   HEX_BCD

        MOV     A,RES
        ACALL   PUT_BCD

        LCALL   WAIT_KEY
        LCALL   LCD_CLR
        AJMP    MAIN

READ1B:
        LCALL   GET_NUM
        LCALL   BCD_HEX
        MOV     A,@R0
        INC     R0
        MOV     A,@R0
        DEC     R0
        JNZ     MAIN
        RET

; PUT_HEX_H: wypisz A w HEX i dopisz 'h'
PUT_HEX_H:
        LCALL   WRITE_HEX
        MOV     A,#'h'
        LCALL   WRITE_DATA
        RET

; PUT_BCD: wypisz ROB (BCD) bez wiodących zer 
PUT_BCD:
        MOV     A,ROB+2
        JZ      BCD_NO2
        LCALL   WRITE_HEX
        MOV     A,ROB+1
BCD_P1: LCALL   WRITE_HEX
        MOV     A,ROB
        LCALL   WRITE_HEX
        RET
BCD_NO2:
        MOV     A,ROB+1
        JNZ     BCD_P1
        MOV     A,ROB
        LCALL   WRITE_HEX
        RET
SPACES:
        MOV     A,#20h
        LCALL   WRITE_DATA
        DJNZ    R2,SPACES
        RET

CLR_ROB:
        CLR     A
        MOV     ROB,A
        MOV     ROB+1,A
        MOV     ROB+2,A
        RET

        END
