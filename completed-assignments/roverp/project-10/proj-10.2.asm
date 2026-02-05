NUM     EQU 30h     
ROB     EQU 32h     

LJMP START
ORG 100h

START:
    LCALL LCD_CLR
    
    
    MOV DPTR, #TXT_PROMPT
    LCALL WRITE_TEXT

    
    LCALL WAIT_KEY      
    MOV R1, A           
    
    
    ACALL SHOW_DIGIT
    
    
    MOV A, R1
    SWAP A              
    MOV NUM, A          

    
    LCALL WAIT_KEY
    MOV R1, A
    
    
    ACALL SHOW_DIGIT
    
    
    MOV A, NUM
    ORL A, R1           
    MOV NUM, A          

    
    MOV A, #'h'
    LCALL WRITE_DATA
    MOV DPTR, #TXT_CLICK
    LCALL WRITE_TEXT

    
    LCALL WAIT_KEY
    LCALL LCD_CLR

    
    MOV A, NUM
    JZ IS_ZERO

    
    
    JB ACC.0, IS_ODD    

IS_EVEN:
    
    ACALL SHOW_RESULTS
    MOV DPTR, #TXT_EVEN
    LCALL WRITE_TEXT
    SJMP FINISH

IS_ODD:
    
    ACALL SHOW_RESULTS
    MOV DPTR, #TXT_ODD
    LCALL WRITE_TEXT
    SJMP FINISH

IS_ZERO:
    MOV DPTR, #TXT_ZERO
    LCALL WRITE_TEXT
    SJMP FINISH

FINISH:
    LCALL WAIT_KEY
    LJMP START



SHOW_RESULTS:
    
    MOV A, NUM
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA
    MOV A, #'='
    LCALL WRITE_DATA
    
    
    MOV A, NUM
    MOV ROB, A          
    MOV ROB+1, #0       
    MOV R0, #ROB        
    LCALL HEX_BCD       
    
    
    
    MOV A, ROB+1        
    JZ SKIP_100         
    LCALL WRITE_HEX
SKIP_100:
    
    MOV A, ROB          
    LCALL WRITE_HEX
    
    MOV A, #'d'
    LCALL WRITE_DATA
    
    
    MOV A, #0C0h        
    LCALL WRITE_INSTR
    RET

SHOW_DIGIT:
    
    
    
    CJNE A, #10, CHECK_DIGIT
CHECK_DIGIT:
    JC IS_NUM           
    ADD A, #7           
IS_NUM:
    ADD A, #'0'         
    LCALL WRITE_DATA
    RET


TXT_PROMPT: DB 'kliknij 2 znaki ', 0
TXT_CLICK:  DB ' kliknij', 0
TXT_ZERO:   DB 'Liczba = 0', 0
TXT_EVEN:   DB 'parzysta', 0
TXT_ODD:    DB 'nieparzysta', 0
