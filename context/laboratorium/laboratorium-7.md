# Laboratory 7: Decimal Division with Hexadecimal Result

## 1. Task 4.3: Decimal Input / Hex Output Division

### Objective

Create a program that divides a 2-byte number by a 1-byte number. The unique aspect of this task is the data interpretation:

- **Input:** The user types numbers as **Decimal** values (e.g., "100").
- **Processing:** The system converts these to binary/hex for calculation.
- **Output:** The result is displayed in **Hexadecimal**.

### Input Logic (The "Decimal" Trick)

- **Procedure:**

1. Call `GET_NUM` to read up to 4 digits from the keypad.
2. Immediately call `BCD_HEX`.

- **Mechanism:**
- If the user types `9999`, `GET_NUM` initially stores the BCD digits (9, 9, 9, 9).
- `BCD_HEX` converts this BCD value into its actual binary/hex equivalent.
- **Result:** The memory holds the value `270Fh` (which is ). This differs from previous labs where inputting "9999" might have been treated as the hex value `9999h`.

- **Argument Ranges:**
- **Dividend (Arg1):** Input range . Stored in memory as .
- **Divisor (Arg2):** Input range . Stored in memory as .

### Processing Logic

- **Algorithm:** Uses the standard `DIV_2_1` subroutine.
- **Inputs:** Dividend (2 bytes), Divisor (1 byte).
- **Outputs:** Quotient (2 bytes), Remainder (1 byte).

### Display Formatting

- **Input Echo:** Display the input numbers appended with the letter **'d'** to indicate they were entered as decimals.
- **Result:** Display the Quotient (and Remainder) in Hexadecimal, appended with **'h'**.
- **Format:** `Arg1d / Arg2d = Quoth RRemh`
- **Remainder Rule:** The "R" part is displayed only if the remainder is non-zero.

### Examples from Manual

| Input (Decimal) | Calculation (Internal) | Displayed Output          | Notes                |
| --------------- | ---------------------- | ------------------------- | -------------------- |
| **9999 / 99**   |                        | `9999d/99d = 0065h`       |                      |
| **9876 / 90**   |                        | `9876d/90d = 006Dh R42h`  | Quotient 109, Rem 66 |
| **9999 / 255**  |                        | `9999d/255d = 0027h R36h` |                      |
| **96 / 99**     |                        | `96d/99d = 0000h R60h`    | Dividend < Divisor   |
| **9999 / 4**    |                        | `9999d/4d = 09C3h R03h`   |                      |
