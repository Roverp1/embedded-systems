VAL     EQU 30h     
BCD_BUF EQU 32h     

LJMP START
ORG 100h

START:
    LCALL LCD_CLR
    
    MOV DPTR, #TXT_START
    LCALL WRITE_TEXT
    
    
    LCALL WAIT_KEY
    ACALL SHOW_DIGIT
    SWAP A
    MOV VAL, A
    
    
    LCALL WAIT_KEY
    ACALL SHOW_DIGIT
    ORL A, VAL
    MOV VAL, A
    
    
    MOV A, #' '
    LCALL WRITE_DATA
    MOV DPTR, #TXT_CLICK
    LCALL WRITE_TEXT
    LCALL WAIT_KEY
    
    
    LCALL LCD_CLR
    
    
    MOV DPTR, #TXT_HEX_L1
    LCALL WRITE_TEXT
    MOV A, VAL
    LCALL WRITE_HEX
    
    
    MOV A, #0C0h
    LCALL WRITE_INSTR
    
    
    MOV A, VAL
    MOV R2, A           
    ANL A, #0F0h        
    JZ HEX_SKIP_ZERO
    
    MOV A, R2
    SWAP A
    ANL A, #0Fh
    ACALL SHOW_DIGIT
HEX_SKIP_ZERO:
    MOV A, R2
    ANL A, #0Fh
    ACALL SHOW_DIGIT
    MOV A, #'h'
    LCALL WRITE_DATA
    
    LCALL WAIT_KEY
    
    
    LCALL LCD_CLR
    
    
    MOV A, VAL
    MOV BCD_BUF, A
    MOV BCD_BUF+1, #0   
    MOV R0, #BCD_BUF
    LCALL HEX_BCD       
    
    
    MOV DPTR, #TXT_DEC_L1
    LCALL WRITE_TEXT
    
    
    
    
    
    
    MOV A, #'0'         
    LCALL WRITE_DATA
    
    MOV A, BCD_BUF+1    
    LCALL WRITE_HEX     
                        
                        
    
    MOV A, BCD_BUF      
    LCALL WRITE_HEX     
    
    
    MOV A, #0C0h
    LCALL WRITE_INSTR
    
    
    MOV A, BCD_BUF+1
    JZ CHECK_TENS
    ACALL SHOW_DIGIT    
    SJMP PRINT_REST_DEC
    
CHECK_TENS:
    MOV A, BCD_BUF
    ANL A, #0F0h
    JZ PRINT_ONES_DEC   
    
PRINT_REST_DEC:
    MOV A, BCD_BUF
    SWAP A
    ANL A, #0Fh
    ACALL SHOW_DIGIT
    
PRINT_ONES_DEC:
    MOV A, BCD_BUF
    ANL A, #0Fh
    ACALL SHOW_DIGIT
    
    MOV A, #'d'
    LCALL WRITE_DATA
    
    LCALL WAIT_KEY
    
    
    LCALL LCD_CLR
    
    
    MOV DPTR, #TXT_BIN_L1
    LCALL WRITE_TEXT
    MOV R2, #8          
    MOV A, VAL
    MOV R3, A           
BIN_LOOP_FULL:
    MOV A, R3
    RLC A               
    MOV R3, A           
    JC BIN_1
    MOV A, #'0'
    SJMP BIN_PRINT
BIN_1:
    MOV A, #'1'
BIN_PRINT:
    LCALL WRITE_DATA
    DJNZ R2, BIN_LOOP_FULL
    
    
    MOV A, #0C0h
    LCALL WRITE_INSTR
    
    
    MOV A, VAL
    JZ BIN_ZERO_CASE    
    
    MOV R3, A           
    MOV R2, #8          
    MOV R4, #0          
    
BIN_SIG_LOOP:
    MOV A, R3
    RLC A
    MOV R3, A
    JC FOUND_ONE        
    
    
    MOV A, R4           
    JZ SKIP_BIT         
    MOV A, #'0'
    LCALL WRITE_DATA
    SJMP NEXT_BIT

FOUND_ONE:
    MOV R4, #1          
    MOV A, #'1'
    LCALL WRITE_DATA

NEXT_BIT:
    SJMP LOOP_END
SKIP_BIT:
    NOP
LOOP_END:
    DJNZ R2, BIN_SIG_LOOP
    SJMP BIN_SUFFIX

BIN_ZERO_CASE:
    MOV A, #'0'
    LCALL WRITE_DATA

BIN_SUFFIX:
    MOV A, #'b'
    LCALL WRITE_DATA
    
    LCALL WAIT_KEY
    LJMP START


SHOW_DIGIT:
    CJNE A, #10, D_CHK
D_CHK:
    JC D_IS_NUM
    ADD A, #7
D_IS_NUM:
    ADD A, #'0'
    LCALL WRITE_DATA
    RET


TXT_START:  DB 'kliknij 2 znaki ', 0
TXT_CLICK:  DB 'kliknij', 0
TXT_HEX_L1: DB 'hex=', 0
TXT_DEC_L1: DB 'dec=', 0
TXT_BIN_L1: DB 'bin=', 0
