
ARG1    EQU 20h
ARG2    EQU 22h
PROD    EQU 25h
BUF     EQU 30h

        LJMP    MAIN
        ORG     100h

MAIN:
        LCALL   LCD_CLR

        MOV     R0,#ARG1
        ACALL   READ_1B
        MOV     A,#'*'
        LCALL   WRITE_DATA

        MOV     R0,#ARG2
        ACALL   READ_1B

        LCALL   WAIT_KEY
        LCALL   LCD_CLR

        MOV     A,ARG2
        MOV     B,ARG1
        MUL     AB              ; A=low, B=high
        MOV     PROD,A
        MOV     PROD+1,B

        MOV     A,ARG1
        ACALL   PRINT_DEC_8

        MOV     A,#'*'
        LCALL   WRITE_DATA

        MOV     A,ARG2
        ACALL   PRINT_DEC_8

        MOV     A,#'='
        LCALL   WRITE_DATA

        ACALL   ZERO_BUF
        MOV     A,PROD
        MOV     BUF,A
        MOV     A,PROD+1
        MOV     BUF+1,A

        MOV     R0,#BUF
        LCALL   HEX_BCD
        ACALL   PRINT_BCD

        LCALL   WAIT_KEY
        LCALL   LCD_CLR
        AJMP    MAIN

READ_1B:
        LCALL   GET_NUM
        LCALL   BCD_HEX

        MOV     A,@R0
        INC     R0
        MOV     A,@R0           ; starszy bajt po konwersji
        DEC     R0
        JNZ     MAIN            ; jeśli > 255 -> od nowa
        RET


PRINT_DEC_8:
        ACALL   ZERO_BUF
        MOV     BUF,A
        MOV     R0,#BUF
        LCALL   HEX_BCD
        ACALL   PRINT_BCD
        RET

PRINT_BCD:
        MOV     A,BUF+1
        JZ      PB_SKIP_HI
        LCALL   WRITE_HEX
        MOV     A,BUF+2
        LCALL   WRITE_HEX
        SJMP    PB_LAST
PB_SKIP_HI:
        MOV     A,BUF+1
        JNZ     PB_MID
        SJMP    PB_LAST
PB_MID:
        MOV     A,BUF+2
        LCALL   WRITE_HEX
PB_LAST:
        MOV     A,BUF
        LCALL   WRITE_HEX
        RET
		
ZERO_BUF:
        CLR     A
        MOV     BUF,A
        MOV     BUF+1,A
        MOV     BUF+2,A
        RET

        END
