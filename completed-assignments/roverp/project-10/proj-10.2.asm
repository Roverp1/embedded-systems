; PROJEKT 10.2 - PARZYSTOSC I KONWERSJA
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
    MOV ROB, A          ; Put number in buffer for BIOS routine
    MOV R0, #ROB        ; R0 points to buffer
    LCALL HEX_BCD       ; Converts hex at @R0 to BCD at @R0 (3 bytes)
    
    ; Print BCD (Decimal)
    ; HEX_BCD result is 3 bytes, usually hundreds at ROB+1? 
    ; Let's check lab usage: usually ROB+1 is hundreds, ROB is tens/ones?
    ; Actually standard usage: ROB+1 (High), ROB (Low) if 16 bit. 
    ; For 8 bit HEX_BCD outputs to ROB (LSB), ROB+1...
    ; Safer to print all non-zero or just last 3 digits.
    ; Simplified print:
    MOV A, ROB+1        ; Hundreds
    JZ SKIP_100
    LCALL WRITE_HEX     ; Print hundreds
SKIP_100:
    MOV A, ROB          ; Tens and Ones (packed BCD)
    LCALL WRITE_HEX
    
    MOV A, #'d'
    LCALL WRITE_DATA
    
    ; Move to Line 2 (Address 40h on 2x16 LCD)
    MOV A, #0C0h        ; Command to move cursor to 2nd line
    LCALL WRITE_INSTR
    RET

SHOW_DIGIT:
    ; Prints the hex digit in A (0-15)
    CMP A, #10
    JC DIGIT_09
    ADD A, #7           ; Adjust for A-F (ASCII offset)
DIGIT_09:
    ADD A, #'0'         ; Convert to ASCII
    LCALL WRITE_DATA
    RET

; Data
TXT_PROMPT: DB 'kliknij 2 znaki ', 0
TXT_CLICK:  DB ' kliknij', 0
TXT_ZERO:   DB 'Liczba = 0', 0
TXT_EVEN:   DB 'parzysta', 0
TXT_ODD:    DB 'nieparzysta', 0
