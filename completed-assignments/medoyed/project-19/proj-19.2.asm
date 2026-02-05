; PROJEKT 19.2 - KONWERTER LICZB (HEX/DEC/BIN)
; Autor: Gemini

VAL     EQU 30h     ; Input value
BCD_BUF EQU 32h     ; Buffer for BCD (3 bytes)

LJMP START
ORG 100h

START:
    LCALL LCD_CLR
    ; 1. Prompt "kliknij 2 znaki"
    MOV DPTR, #TXT_START
    LCALL WRITE_TEXT
    
    ; Read High Nibble
    LCALL WAIT_KEY
    ACALL SHOW_DIGIT
    SWAP A
    MOV VAL, A
    
    ; Read Low Nibble
    LCALL WAIT_KEY
    ACALL SHOW_DIGIT
    ORL A, VAL
    MOV VAL, A
    
    ; Confirm " kliknij"
    MOV A, #' '
    LCALL WRITE_DATA
    MOV DPTR, #TXT_CLICK
    LCALL WRITE_TEXT
    LCALL WAIT_KEY
    
    ; ================= SCREEN 1: HEX =================
    LCALL LCD_CLR
    
    ; Line 1: "hex=" + Value
    MOV DPTR, #TXT_HEX_L1
    LCALL WRITE_TEXT
    MOV A, VAL
    LCALL WRITE_HEX
    
    ; Line 2: Significant digits + 'h'
    MOV A, #0C0h
    LCALL WRITE_INSTR
    
    ; Suppress leading zero for Hex
    MOV A, VAL
    MOV R2, A           ; Copy to R2
    ANL A, #0F0h        ; Check upper nibble
    JZ HEX_SKIP_ZERO
    ; Print Upper Nibble
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
    
    ; ================= SCREEN 2: DEC =================
    LCALL LCD_CLR
    
    ; Prepare BCD
    MOV A, VAL
    MOV BCD_BUF, A
    MOV BCD_BUF+1, #0   ; Clear High Byte
    MOV R0, #BCD_BUF
    LCALL HEX_BCD       ; Convert @R0 (2 bytes) to BCD @R0 (3 bytes)
    
    ; Line 1: "dec=" + 4 digits (e.g., 0025)
    MOV DPTR, #TXT_DEC_L1
    LCALL WRITE_TEXT
    
    ; Since input is max FF (255), we only need 3 digits, but prompt asks for 4?
    ; "dec=cztery cyfry" (e.g. 0025). 
    ; FF = 255. BCD buffer will be: BCD_BUF (low), BCD_BUF+1 (high).
    ; BCD_BUF+1 holds hundreds (02). BCD_BUF holds tens/ones (55).
    
    MOV A, #'0'         ; Leading thousand is always 0 for 8-bit input
    LCALL WRITE_DATA
    
    MOV A, BCD_BUF+1    ; Hundreds
    LCALL WRITE_HEX     ; Prints 2 digits (e.g. "02"). We only want the '2'.
                        ; Wait, WRITE_HEX prints 2 chars. 
                        ; If BCD_BUF+1 is 02, it prints "02". Total "002". Correct.
    
    MOV A, BCD_BUF      ; Tens/Ones
    LCALL WRITE_HEX     ; e.g. "55"
    
    ; Line 2: Significant digits + 'd'
    MOV A, #0C0h
    LCALL WRITE_INSTR
    
    ; Check Hundreds
    MOV A, BCD_BUF+1
    JZ CHECK_TENS
    ACALL SHOW_DIGIT    ; Print Hundreds digit
    SJMP PRINT_REST_DEC
    
CHECK_TENS:
    MOV A, BCD_BUF
    ANL A, #0F0h
    JZ PRINT_ONES_DEC   ; If Tens is 0, just print ones
    ; Print Tens
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
    
    ; ================= SCREEN 3: BIN =================
    LCALL LCD_CLR
    
    ; Line 1: "bin=" + 8 bits
    MOV DPTR, #TXT_BIN_L1
    LCALL WRITE_TEXT
    MOV R2, #8          ; 8 bits
    MOV A, VAL
    MOV R3, A           ; Save value in R3
BIN_LOOP_FULL:
    MOV A, R3
    RLC A               ; Rotate MSB into Carry
    MOV R3, A           ; Update R3
    JC BIN_1
    MOV A, #'0'
    SJMP BIN_PRINT
BIN_1:
    MOV A, #'1'
BIN_PRINT:
    LCALL WRITE_DATA
    DJNZ R2, BIN_LOOP_FULL
    
    ; Line 2: Significant digits + 'b'
    MOV A, #0C0h
    LCALL WRITE_INSTR
    
    ; Logic: Rotate until we find the first '1', then print everything else
    MOV A, VAL
    JZ BIN_ZERO_CASE    ; If 0, print "0b"
    
    MOV R3, A           ; Restore Value
    MOV R2, #8          ; Counter
    MOV R4, #0          ; Flag: 0=Skipping Zeros, 1=Printing
    
BIN_SIG_LOOP:
    MOV A, R3
    RLC A
    MOV R3, A
    JC FOUND_ONE        ; Carry=1 means we found a 1
    
    ; Carry is 0
    MOV A, R4           ; Check flag
    JZ SKIP_BIT         ; If flag is 0, skip printing this '0'
    MOV A, #'0'
    LCALL WRITE_DATA
    SJMP NEXT_BIT

FOUND_ONE:
    MOV R4, #1          ; Set printing flag
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

; --- Subroutines ---
SHOW_DIGIT:
    CJNE A, #10, D_CHK
D_CHK:
    JC D_IS_NUM
    ADD A, #7
D_IS_NUM:
    ADD A, #'0'
    LCALL WRITE_DATA
    RET

; Data
TXT_START:  DB 'kliknij 2 znaki ', 0
TXT_CLICK:  DB 'kliknij', 0
TXT_HEX_L1: DB 'hex=', 0
TXT_DEC_L1: DB 'dec=', 0
TXT_BIN_L1: DB 'bin=', 0
