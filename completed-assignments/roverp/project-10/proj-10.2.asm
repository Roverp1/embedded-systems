; PROJEKT 10.2 - PARZYSTOSC I KONWERSJA (POPRAWIONY)
; Autor: Gemini

NUM     EQU 30h     ; Number storage
ROB     EQU 32h     ; Buffer for BCD conversion

LJMP START
ORG 100h

START:
    LCALL LCD_CLR
    
    ; 1. Display Prompt "kliknij 2 znaki "
    MOV DPTR, #TXT_PROMPT
    LCALL WRITE_TEXT

    ; 2. Read First Character (High Nibble)
    LCALL WAIT_KEY      ; Returns 0-15 in A
    MOV R1, A           ; Save temporarily
    
    ; Display digit (0-9 or A-F)
    ACALL SHOW_DIGIT
    
    ; Shift to upper nibble (A * 16)
    MOV A, R1
    SWAP A              ; Swaps low/high nibbles (equivalent to x16)
    MOV NUM, A          ; Store partial result (e.g., A0h)

    ; 3. Read Second Character (Low Nibble)
    LCALL WAIT_KEY
    MOV R1, A
    
    ; Display digit
    ACALL SHOW_DIGIT
    
    ; Combine
    MOV A, NUM
    ORL A, R1           ; Combine A0h | 0Bh -> ABh
    MOV NUM, A          ; NUM now holds final byte

    ; 4. Display "h kliknij"
    MOV A, #'h'
    LCALL WRITE_DATA
    MOV DPTR, #TXT_CLICK
    LCALL WRITE_TEXT

    ; 5. Wait for confirm
    LCALL WAIT_KEY
    LCALL LCD_CLR

    ; 6. Check for Zero
    MOV A, NUM
    JZ IS_ZERO

    ; 7. Check Parity
    ; Bit 0 determines parity (0=Even, 1=Odd)
    JB ACC.0, IS_ODD    ; Jump if Bit 0 is Set (1)

IS_EVEN:
    ; Even Logic
    ACALL SHOW_RESULTS
    MOV DPTR, #TXT_EVEN
    LCALL WRITE_TEXT
    SJMP FINISH

IS_ODD:
    ; Odd Logic
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

; --- Subroutines ---

SHOW_RESULTS:
    ; Line 1: XXh = YYd
    MOV A, NUM
    LCALL WRITE_HEX
    MOV A, #'h'
    LCALL WRITE_DATA
    MOV A, #'='
    LCALL WRITE_DATA
    
    ; Convert Hex to BCD (Decimal)
    MOV A, NUM
    MOV ROB, A          ; Put number in buffer (Low byte)
    MOV ROB+1, #0       ; CLEAR High byte (Critical for correct conversion)
    MOV R0, #ROB        ; R0 points to buffer
    LCALL HEX_BCD       ; Converts hex at @R0 to BCD at @R0 (3 bytes)
    
    ; Print BCD (Decimal)
    ; Print Hundreds (ROB+1)
    MOV A, ROB+1        
    JZ SKIP_100         ; If zero, don't print
    LCALL WRITE_HEX
SKIP_100:
    ; Print Tens/Ones (ROB)
    MOV A, ROB          
    LCALL WRITE_HEX
    
    MOV A, #'d'
    LCALL WRITE_DATA
    
    ; Move to Line 2 (Address 40h on 2x16 LCD)
    MOV A, #0C0h        ; Command to move cursor to 2nd line
    LCALL WRITE_INSTR
    RET

SHOW_DIGIT:
    ; Prints the hex digit in A (0-15)
    ; 8051 Logic: Compare A with 10. 
    ; If A < 10, Carry Flag is SET.
    CJNE A, #10, CHECK_DIGIT
CHECK_DIGIT:
    JC IS_NUM           ; If Carry=1, it is 0-9
    ADD A, #7           ; Adjust for A-F (ASCII offset)
IS_NUM:
    ADD A, #'0'         ; Convert to ASCII
    LCALL WRITE_DATA
    RET

; Data
TXT_PROMPT: DB 'kliknij 2 znaki ', 0
TXT_CLICK:  DB ' kliknij', 0
TXT_ZERO:   DB 'Liczba = 0', 0
TXT_EVEN:   DB 'parzysta', 0
TXT_ODD:    DB 'nieparzysta', 0
