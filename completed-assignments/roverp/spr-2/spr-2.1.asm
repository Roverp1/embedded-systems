; Zadanie 2.1 - Mnozenie 1-bajtowe
; Indeks: 121546 (X=4, Y=6)
; Test: 25 * 18 = 450

L_ARG1  EQU 20H
L_ARG2  EQU 22H
ILOCZYN EQU 30H     ; Wynik (2 bajty)
BUF_BCD EQU 40H     ; Bufor konwersji

ORG 100H
START:
    LCALL LCD_CLR
    
    MOV R0, #L_ARG1
    ACALL POBIERZ_BAJT
    
    MOV A, #'*'
    LCALL WRITE_DATA
    
    MOV R0, #L_ARG2
    ACALL POBIERZ_BAJT
    
    LCALL WAIT_KEY
    LCALL LCD_CLR
    
    MOV A, L_ARG1
    MOV B, L_ARG2
    MUL AB          ; Mnozenie A * B
    MOV ILOCZYN, A  ; Mlodszy bajt
    MOV ILOCZYN+1, B ; Starszy bajt

    ; --- Wyswietlanie Wyniku ---
    ; Format: A * B = C
    
    MOV A, L_ARG1
    ACALL PISZ_DEC
    
    MOV A, #'*'
    LCALL WRITE_DATA
    
    MOV A, L_ARG2
    ACALL PISZ_DEC
    
    MOV A, #'='
    LCALL WRITE_DATA
    
    ; 3. Wyswietl Wynik (2 bajty)
    ACALL CZYSC_BUF
    MOV A, ILOCZYN
    MOV BUF_BCD, A
    MOV A, ILOCZYN+1
    MOV BUF_BCD+1, A
    
    MOV R0, #BUF_BCD
    LCALL HEX_BCD
    ACALL PISZ_BCD_CALY
    
    LCALL WAIT_KEY
    AJMP START

; --- Procedury Pomocnicze ---

POBIERZ_BAJT:
    LCALL GET_NUM
    LCALL BCD_HEX
    ; Sprawdz czy miesci sie w 1 bajcie
    MOV A, @R0      ; Mlodszy bajt
    INC R0
    MOV A, @R0      ; Starszy bajt
    DEC R0
    JNZ START       ; Jak nie zero, to > 255 -> Reset
    RET

PISZ_DEC:
    ACALL CZYSC_BUF
    MOV BUF_BCD, A
    MOV R0, #BUF_BCD
    LCALL HEX_BCD
    ACALL PISZ_BCD_CALY
    RET

PISZ_BCD_CALY:
    ; Wyswietla bufor BCD pomijajac zera wiodace
    ; Logika uproszczona pod zadanie
    MOV A, BUF_BCD+1
    LCALL WRITE_HEX
    MOV A, BUF_BCD+2
    LCALL WRITE_HEX
    MOV A, BUF_BCD
    LCALL WRITE_HEX
    RET

CZYSC_BUF:
    CLR A
    MOV BUF_BCD, A
    MOV BUF_BCD+1, A
    MOV BUF_BCD+2, A
    RET
