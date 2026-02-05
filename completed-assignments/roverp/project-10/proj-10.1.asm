ARG1    EQU 20h     
ARG2    EQU 22h     
RES_R   EQU 24h     

LJMP START
ORG 100h

START:
    
    LCALL LCD_CLR

    
    MOV R0, #ARG1       
    LCALL GET_NUM       
    
    
    MOV A, #'h'
    LCALL WRITE_DATA
    MOV A, #'/'
    LCALL WRITE_DATA

    
    MOV R0, #ARG2       
    LCALL GET_NUM       
    
    
    MOV A, #'h'
    LCALL WRITE_DATA

    
    MOV DPTR, #TXT_KLIK
    LCALL WRITE_TEXT

    
    LCALL WAIT_KEY
    LCALL LCD_CLR

    
    
    
    
    MOV A, ARG2         
    JZ DIV_ZERO         

    MOV B, A            
    MOV R0, #ARG1       
    LCALL DIV_2_1       

    MOV RES_R, A        

    
    
    
    
    
    MOV A, ARG1+1
    JZ SKIP_HI_Q        
    LCALL WRITE_HEX
SKIP_HI_Q:
    MOV A, ARG1         
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA

    
    MOV DPTR, #TXT_REM
    LCALL WRITE_TEXT

    
    MOV A, RES_R
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA

    
    LCALL WAIT_KEY
    LJMP START

DIV_ZERO:
    MOV DPTR, #TXT_ERR
    LCALL WRITE_TEXT
    LCALL WAIT_KEY
    LJMP START


TXT_KLIK: DB ' klik', 0
TXT_REM:  DB ' r ', 0
TXT_ERR:  DB 'Error 0', 0
