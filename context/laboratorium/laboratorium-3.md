# Laboratory 3: Arithmetic & Display Formatting (DSM-51)

## 1. Standard BIOS Subroutines (Reference)

The DSM-51 system includes a set of pre-defined subroutines stored in EPROM to handle I/O, timing, and mathematics.

### Display & Interface

| Subroutine      | Description                                                             | Stack / Registers          |
| --------------- | ----------------------------------------------------------------------- | -------------------------- |
| **WRITE_TEXT**  | Prints a text string pointed to by **DPTR** (must end with a `0` byte). | Stack: 2, Regs: A, PSW, R0 |
| **WRITE_DATA**  | Prints the character (ASCII) stored in **A** to the LCD.                | Stack: 2, Regs: A, PSW     |
| **WRITE_HEX**   | Prints the byte in **A** as two hexadecimal digits to the LCD.          | Stack: 3, Regs: A, PSW, R0 |
| **WRITE_INSTR** | Sends an instruction/command (in **A**) to the LCD controller.          | Stack: 2, Regs: A, PSW, R0 |
| **LCD_INIT**    | Initializes the LCD display (Required at start).                        | Stack: 2, Regs: A, PSW, R0 |
| **LCD_OFF**     | Turns off the LCD.                                                      | Stack: 1, Regs: A, PSW, R0 |
| **LCD_CLR**     | Clears the LCD content and moves cursor to the beginning.               | Stack: 1, Regs: A, PSW, R0 |

### Timing

| Subroutine      | Description                                                       |
| --------------- | ----------------------------------------------------------------- |
| **DELAY_US**    | Delays execution by .                                             |
| **DELAY_MS**    | Delays execution by **A milliseconds**. (Note: means 256 ms).     |
| **DELAY_100MS** | Delays execution by **A 100 milliseconds**. (Note: means 25.6 s). |

### Input (Keypad)

| Subroutine        | Description                                                                                                   |
| ----------------- | ------------------------------------------------------------------------------------------------------------- |
| **WAIT_ENTER**    | Displays "PRESS ENTER..." and waits for the Enter key.                                                        |
| **WAIT_ENTER_NW** | Waits for Enter key without displaying text.                                                                  |
| **TEST_ENTER**    | Checks Enter key state. **C=0**: Pressed, **C=1**: Released.                                                  |
| **WAIT_KEY**      | Waits for any key press. Returns key number in **A**.                                                         |
| **GET_NUM**       | Reads a BCD number (up to 4 digits) from keypad into address **@R0**. Ends with [Enter] (C=0) or [Esc] (C=1). |

### Mathematical Conversions & Operations

| Subroutine  | Description                                                                            |
| ----------- | -------------------------------------------------------------------------------------- |
| **BCD_HEX** | Converts a packed BCD number (2 bytes at **@R0**) to Hexadecimal (2 bytes at **@R0**). |
| **HEX_BCD** | Converts a Hexadecimal number (2 bytes at **@R0**) to packed BCD (3 bytes at **@R0**). |
| **MUL_2_2** | Multiplies 2 bytes (@R0) by 2 bytes (B:A). Result: 4 bytes at @R0.                     |
| **MUL_3_1** | Multiplies 3 bytes (@R0) by 1 byte (A). Result: 4 bytes at @R0.                        |
| **DIV_2_1** | Divides 2 bytes (@R0) by 1 byte (B). **Quotient**: @R0, **Remainder**: A.              |
| **DIV_4_2** | Divides 4 bytes (@R0) by 2 bytes (B:A). **Quotient**: @R0, **Remainder**: @(R0+4).     |

---

## 2. Exercise 1: Addition of 1-Byte Numbers

### Objective

Write a program to add two 1-byte numbers stored in Internal RAM (IRAM) and display the result in the format:
`ARG1h + ARG2h = sumah`

### Data Structure

- **ARG1** (Address `20h`): First number (00h - FFh).
- **ARG2** (Address `21h`): Second number (00h - FFh).
- **SUM** (Address `25h`): Low byte of the result.
- **SUM+1** (Address `26h`): High byte of the result (Carry).
- _Note:_ The sum of two 8-bit numbers can be up to 9 bits (0h to 1FEh).

### Algorithm & Code Logic (`lab2_05.asm`)

1. **Initialization:** Define addresses using `EQU` and start at `ORG 100H`.
2. **Load Data:** Move test values into `ARG1` (e.g., `FFh`) and `ARG2` (e.g., `FEh`).
3. **Addition:**

- `MOV A, ARG1`
- `ADD A, ARG2` (Add ARG2 to Accumulator)
- `MOV SUM, A` (Store low byte result)

4. **Carry Handling:**

- `JC E1` (Jump if Carry Flag is set).
- If no carry: `MOV SUM+1, #0` then Jump to `E2`.
- If carry (`E1`): `MOV SUM+1, #1`.

5. **Display Routine:**

- Use a helper label `PISZ_HEX` which calls `WRITE_HEX` and then prints the character `'h'`.
- Print `ARG1` -> Print `+` -> Print `ARG2` -> Print `=`.
- **Result Formatting:** Check `SUM+1` (High Byte).
- `MOV A, SUM+1`
- `JZ E3` (If High Byte is 0, skip printing it).
- If High Byte is 1, call `PISZ_HEX` to print it.

- `E3`: Always print `SUM` (Low Byte) via `PISZ_HEX`.

6. **Cleanup:** Print spaces (`SPACES` subroutine) to clear any remaining characters on the LCD line if needed.

### Example Calculations

- **Decimal:**
- **Hex:** (Result: `00AF`)

- **Decimal:**
- **Hex:** (Result: `0113`) -> Carry occurred ().

---

## 3. Exercise 2: Multiplication of 1-Byte Numbers

### Objective

Write a program to multiply two 1-byte numbers stored in IRAM and display the result in the format:
`ARG1h * ARG2h = iloczynh`

### Data Structure

- **ARG1** (Address `20h`): Multiplicand (00h - FFh).
- **ARG2** (Address `21h`): Multiplier (00h - FFh).
- **MUL** (Address `25h`): Low byte of result.
- **MUL+1** (Address `26h`): High byte of result.
- _Note:_ The product of two 8-bit numbers is up to 16 bits (0h to FE01h).

### Algorithm & Code Logic (`lab2_08.asm`)

1. **Load Data:** Move test values into `ARG1` and `ARG2`.
2. **Multiplication:**

- `MOV A, ARG1`
- `MOV B, A` (Move ARG1 to B register). _Note: The snippet shows moving ARG1 to B, then loading ARG2 to A._
- `MOV A, ARG2`
- `MUL AB` (Multiplies A B).

3. **Store Result:**

- `MOV MUL, A` (Low byte from A).
- `MOV MUL+1, B` (High byte from B).

4. **Display Routine:**

- Print `ARG1` -> Print `*` -> Print `ARG2` -> Print `=`.
- **Zero Suppression (High Byte):**
- `MOV A, MUL+1`
- `JZ E4` (If High Byte is 0, jump to print only low byte).
- If not zero, print `MUL+1` using `PISZ_HEX`.

- `E4`: Print `MUL` (Low Byte) using `PISZ_HEX`.
- _Edge Case:_ If the result is e.g., `006E`, it prints `6Eh`. If the result is `F906`, it prints `F906h`.

### Example Calculations

- **Example 1:**
- Inputs: `FFh` (255) `FAh` (250).
- Calculation: ().
- Display: `FFh * FAh = F906h`.

- **Example 2:**
- Inputs: `0Ah` (10) `0Bh` (11).
- Calculation: ().
- Display: `0Ah * 0Bh = 6Eh` (High byte `00` is suppressed).

---

## 4. Helper Subroutines Used in Exercises

To clean up the main code, local subroutines are defined:

- **PISZ_HEX:** Calls standard `WRITE_HEX` to print the byte in A, then prints the character `'h'`.
- **SPACES:** Prints a specified number of space characters (`20h`) to the LCD to erase old text. The number of spaces is passed in register `R2`. Loop uses `DJNZ R2, SPACES`.
