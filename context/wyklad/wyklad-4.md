# Lecture 4: Advanced Arithmetic & LCD Formatting (DSM-51)

## 1. 8051 Instruction Set Review (Tables)

The lecture provides reference tables for the standard 8051 instruction set.

### Arithmetic Operations

- **ADD / ADDC:** Addition (without/with Carry).
- **SUBB:** Subtraction with Borrow.
- **INC / DEC:** Increment / Decrement.
- **MUL AB:** Multiply A by B.
- Result: Low byte in **A**, High byte in **B**.
- Flags: OV is set if result > 255 (B is not zero).

- **DIV AB:** Divide A by B.
- Result: Quotient in **A**, Remainder in **B**.
- Flags: OV is set if division by zero.

- **DA A:** Decimal Adjust Accumulator (used after addition of BCD numbers).

### Logic Operations

- **ANL / ORL / XRL:** Bitwise AND, OR, XOR.
- **CLR / CPL:** Clear / Complement (Invert).
- **RL / RR:** Rotate A Left / Right (8-bit rotation).
- **RLC / RRC:** Rotate A Left / Right through Carry (9-bit rotation including C flag).
- **SWAP A:** Swap upper and lower nibbles of A.

### Data Transfer

- **MOV:** Copy data (Between A, Registers, Direct addresses, Immediate values).
- **MOVC:** Move Code (Read from Program Memory, e.g., `MOVC A, @A+DPTR`).
- **MOVX:** Move External (Read/Write External RAM).
- **PUSH / POP:** Stack operations (Direct addressing only).
- **XCH:** Exchange Accumulator with byte.
- **XCHD:** Exchange lower digit (nibble).

### Branching (Jumps)

- **LJMP / AJMP / SJMP:** Unconditional jumps.
- **JZ / JNZ:** Jump if A is Zero / Not Zero.
- **JC / JNC:** Jump if Carry is Set / Not Set.
- **JB / JNB / JBC:** Jump if Bit Set / Not Set / Bit Set then Clear.
- **CJNE:** Compare and Jump if Not Equal.
- **DJNZ:** Decrement and Jump if Not Zero.

---

## 2. DSM-51 System Subroutines (BIOS Reference)

A detailed reference for the built-in subroutines in the DSM-51 EPROM.

| Subroutine     | Description                              | Arguments / Inputs                                       | Stack Usage |
| -------------- | ---------------------------------------- | -------------------------------------------------------- | ----------- |
| **WRITE_TEXT** | Prints text to LCD ending with 0-byte.   | **DPTR**: Address of text.                               | 2 Bytes     |
| **WRITE_DATA** | Prints single char (ASCII) to LCD.       | **A**: Character code.                                   | 2 Bytes     |
| **WRITE_HEX**  | Prints byte as 2 Hex digits to LCD.      | **A**: Byte to print.                                    | 3 Bytes     |
| **LCD_INIT**   | Initializes LCD (Required).              | None.                                                    | 2 Bytes     |
| **LCD_CLR**    | Clears LCD, cursor to home.              | None.                                                    | 1 Byte      |
| **DELAY_MS**   | Wait loop.                               | **A**: Time (ms). s.                                     | 1 Byte      |
| **WAIT_KEY**   | Waits for matrix keypad.                 | Returns Key Code in **A**.                               | 2 Bytes     |
| **WAIT_ENTER** | Displays "PRESS ENTER", waits.           | None.                                                    | 4 Bytes     |
| **TEST_ENTER** | Checks if Enter is pressed.              | **C=0**: Pressed, **C=1**: Not pressed.                  | 1 Byte      |
| **GET_NUM**    | Reads 4-digit BCD from keypad to memory. | **@R0**: Dest address. Ends on Enter (C=0) or Esc (C=1). | 4 Bytes     |
| **BCD_HEX**    | Converts BCD (3 bytes) to Hex (2 bytes). | **@R0**: Source/Dest Address.                            | 0 Bytes     |
| **HEX_BCD**    | Converts Hex (2 bytes) to BCD (3 bytes). | **@R0**: Source/Dest Address.                            | 4 Bytes     |

### Arithmetic Helper Procedures

- **MUL_2_2:** Multiplies 2 bytes (@R0) by 2 bytes (B:A). Result (4 bytes) stored at @R0.
- _Warning:_ The slides note that `MUL_2_2` has bugs for specific values (e.g., `9E9A * 9E9F`). A corrected version is discussed in Lecture 5.

- **DIV_2_1:** Divides 2 bytes (@R0) by 1 byte (B). Quotient at @R0, Remainder in A.

---

## 3. Lab Exercises: Multiplication & Division

### Lab 3.01: Multiplication (Hex Display)

- **Goal:** Multiply two 1-byte numbers (). Both inputs .
- **Memory Layout:**
- `ARG1` (Address 20h), `ARG2` (Address 22h).
- `MUL` (Address 25h): Stores 16-bit result (Low byte at 25h, High byte at 26h).

- **Logic:**

1. Read inputs using `GET_NUM`.
2. Check if inputs are (High byte of input buffer must be 0).
3. Load args into A and B.
4. Execute `MUL AB`.
5. Store A (Low) to `MUL` and B (High) to `MUL+1`.
6. Display result in format: `ARG1h * ARG2h = RESULTh`.

### Lab 3.02: Multiplication (Decimal/BCD Display)

- **Goal:** Same as 3.01, but display input and output in Decimal (BCD).
- **Logic:**
- Use `HEX_BCD` to convert the 16-bit result into BCD format before printing.
- Use `PISZ_BCD` (custom subroutine) to print the BCD bytes.

### Lab 4.01: Division

- **Goal:** Divide two 1-byte numbers ().
- **Constraints:** Check if and \*\*\*\*.
- **Logic:**

1. Read inputs. Check ARG2 for zero (`JZ ErrorLabel`).
2. Execute `DIV AB` (A = Dividend, B = Divisor).
3. Result: A = Quotient, B = Remainder.
4. Display format: `ARG1/ARG2 = Quotient` (if Remainder=0) or `ARG1/ARG2 = Quotient R=Remainder`.

---

## 4. Lab Exercises: Signed Arithmetic (U2)

### Two's Complement (U2) Theory

- **Bit 7 (MSB):** Sign bit (0 = Positive, 1 = Negative).
- **Range (8-bit):** -128 to +127.
- **Examples:**
-
-
-

### Converting Negative U2 to Absolute Value

To display a negative number (e.g., -5), you must calculate its absolute value:

1. **CPL A** (Invert all bits).
2. **ADD A, #1** (Add 1).
3. Display a minus sign `'-'` manually, then print the resulting number.

### Lab 3.04 / 3.05: Subtraction

- **Goal:** Subtract two numbers (). Inputs limited to 0-127 so the result fits in signed 8-bit (-127 to +127).
- **Logic:**

1. Check inputs (Bit 7 must be 0).
2. Perform `CLR C` then `SUBB A, ARG2`.
3. Check result sign (Bit 7 of result).
4. If Bit 7 is 1 (Negative):

- Print `'-'`.
- Convert to absolute value (CPL + 1).
- Print value.

5. If Bit 7 is 0 (Positive):

- Print value directly.

---

## 5. Lab Exercises: Binary Input

### Lab 3.07 / 3.08: Reading Binary

- **Goal:** Input a number by typing '0's and '1's. Max 8 bits.
- **Logic (Accumulating Bits):**

1. Initialize result `ARG = 0`.
2. Wait for key.
3. If '0': `CLR C`, `MOV A, ARG`, `RLC A` (Shift Left, 0 enters LSB), Save to ARG.
4. If '1': `SETB C`, `MOV A, ARG`, `RLC A` (Shift Left, 1 enters LSB), Save to ARG.

- _Alternative Logic used in slides:_ `RL A` (Shift left) -> `ADD A, KeyVal` (where KeyVal is 0 or 1).

5. Repeat until 8 bits or Enter pressed.

- **Display:** Show the binary string as it is typed, then show the Hex and Decimal equivalent.

---

## 6. Advanced Display Formatting (Suppressing Zeros)

Standard `WRITE_HEX` always prints 2 characters (e.g., "05", "0A"). To print natural numbers (e.g., "5", "10"), leading zeros must be suppressed.

### Lab 4.03 / 4.03a: Removing Leading Zeros

- **Concept:** Iterate through the bytes (High to Low) and the nibbles (Upper to Lower). Do not print '0' until a non-zero digit has been encountered or it is the very last digit (number 0).
- **Algorithm (BEZ_ZER Procedure):**

1. Start with a "Zero Flag" set (indicating we are currently suppressing zeros).
2. For each digit (Nibble):
3. If Digit is '0' AND Flag is Set: Skip printing.
4. If Digit is NOT '0': Clear Flag (stop suppressing), Print Digit.
5. If Digit is '0' AND Flag is Clear: Print '0' (it's a significant zero, e.g., the 0 in 105).
6. _Edge Case:_ If the entire number is 0, ensure the final '0' is printed.

### Lab 4.05: Clean Division Display

- Combines **Division** (Lab 4.01) with **Zero Suppression**.
- The output `005/002 = 02 R=01` becomes `5/2 = 2 R=1`.
- Uses a buffer `ROB` to store arguments, converts them to BCD, then calls the `BEZ_ZER` routine to print the BCD buffer without leading zeros.
