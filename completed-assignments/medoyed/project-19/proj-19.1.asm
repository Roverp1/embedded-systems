ARG1    EQU 30h     
ARG2    EQU 31h     
RES_HI  EQU 32h     
RES_LO  EQU 33h     
REM     EQU 34h     

LJMP START
ORG 100h

START:
    LCALL LCD_CLR
    
    
    MOV DPTR, #TXT_PROMPT
    LCALL WRITE_TEXT
    
    
    MOV A, #0C0h
    LCALL WRITE_INSTR

    
    
    
    LCALL READ_NIBBLE
    SWAP A
    MOV ARG1, A
    
    
    LCALL READ_NIBBLE
    ORL A, ARG1
    MOV ARG1, A
    
    
    LCALL READ_NIBBLE
    SWAP A
    MOV ARG2, A
    
    
    LCALL READ_NIBBLE
    ORL A, ARG2
    MOV ARG2, A

    
    MOV A, #5       
    LCALL DELAY_100MS

    
    LCALL LCD_CLR
    
    
    
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
    
    
    MOV A, ARG1
    MOV B, ARG2
    MUL AB          
    MOV RES_HI, B
    MOV RES_LO, A
    
    
    MOV A, RES_HI
    LCALL WRITE_HEX
    MOV A, RES_LO
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA

    
    
    MOV A, #0C0h
    LCALL WRITE_INSTR
    
    
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
    
    
    MOV A, ARG2
    JZ DIV_BY_ZERO
    
    
    MOV A, ARG1
    MOV B, ARG2
    DIV AB          
    MOV RES_LO, A
    MOV REM, B
    
    
    MOV A, RES_LO
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA
    
    
    MOV A, REM
    JZ WAIT_FINISH  
    
    
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


READ_NIBBLE:
    LCALL WAIT_KEY      
    PUSH ACC            
    ACALL SHOW_DIGIT    
    POP ACC             
    RET

SHOW_DIGIT:
    
    CJNE A, #10, CHECK_DIG
CHECK_DIG:
    JC IS_NUM           
    ADD A, #7           
IS_NUM:
    ADD A, #'0'         
    LCALL WRITE_DATA
    RET


TXT_PROMPT: DB 'Kliknij 4 znaki', 0
TXT_ERR:    DB 'Err', 0
