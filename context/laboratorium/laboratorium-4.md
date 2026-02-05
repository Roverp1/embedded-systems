# Laboratory 4: Subtraction & Division (DSM-51)

## 1. Standard BIOS Subroutines (Reference)

The document lists standard subroutines available in the DSM-51 EPROM.

### Input/Output & Timing

| Subroutine             | Description                                                                   |
| ---------------------- | ----------------------------------------------------------------------------- |
| **WRITE_TEXT**         | Prints text pointed to by **DPTR** (null-terminated).                         |
| **WRITE_DATA**         | Prints character in **A**.                                                    |
| **WRITE_HEX**          | Prints byte in **A** as 2 Hex digits.                                         |
| **LCD_INIT / LCD_CLR** | Initializes / Clears the LCD.                                                 |
| **DELAY_MS**           | Delays **A** milliseconds (approx).                                           |
| **WAIT_KEY**           | Waits for keypad input. Returns key code in **A**.                            |
| **GET_NUM**            | Reads up to 4 BCD digits from keypad to memory at **@R0**. Ends on Enter/Esc. |

### Mathematical Operations

| Subroutine  | Description                                     | Inputs                                       | Outputs                             |
| ----------- | ----------------------------------------------- | -------------------------------------------- | ----------------------------------- |
| **BCD_HEX** | Converts packed BCD (2 bytes) to Hex (2 bytes). | **@R0**                                      | **@R0**                             |
| **HEX_BCD** | Converts Hex (2 bytes) to packed BCD (3 bytes). | **@R0**                                      | **@R0**                             |
| **MUL_2_2** | Multiplies 2 bytes 2 bytes.                     | **@R0** (Multiplicand), **B:A** (Multiplier) | **@R0** (4 bytes Result)            |
| **MUL_3_1** | Multiplies 3 bytes 1 byte.                      | **@R0**, **A**                               | **@R0**                             |
| **DIV_2_1** | Divides 2 bytes by 1 byte.                      | **@R0** (Dividend), **B** (Divisor)          | **@R0** (Quotient), **A** (Rem)     |
| **DIV_4_2** | Divides 4 bytes by 2 bytes.                     | **@R0**, **B:A**                             | **@R0** (Quot), **@(R0+4/5)** (Rem) |

---

## 2. Exercise 1: Signed Subtraction (`lab4d_z1`)

### Objective

Subtract two 1-byte numbers stored in memory and display the signed result.

- **Formula:** `Result = ARG1 - ARG2`
- **Data Types:** Signed 8-bit integers (U2 format).
- **Constraints:** Input values must be ( to ) to ensure they are treated as positive signed numbers initially. The result can range from to .

### Memory Map

- `ARG1` (20h): First number.
- `ARG2` (21h): Second number.
- `SUB` (25h): Difference.

### Algorithm & Code Logic

1. **Validation (Manual Check):** The code checks if the inputs are valid positive signed integers (Bit 7 must be 0).

- Load `ARG1` to A. Rotate Left through Carry (`RLC A`). If Carry is set (`JC`), the number was (negative/invalid). Display error "arg.1 > 127".
- Repeat for `ARG2`.

2. **Subtraction:**

- `CLR C` (Clear borrow flag).
- `MOV A, ARG1`
- `SUBB A, ARG2` (A = A - ARG2 - C).
- `MOV SUB, A` (Store raw result).

3. **Result Sign Analysis:**

- Check Bit 7 (MSB) of the result.
- **If Bit 7 = 0 (Positive):** Print `ARG1` - `ARG2` = `SUB`h.
- **If Bit 7 = 1 (Negative):**
- The result is in Two's Complement (U2) format (e.g., -1 is `FFh`).
- To display it human-readably:

1. Print minus sign `'-'`.
2. Convert U2 to Absolute Value: Invert bits (`CPL A`) and Add 1 (`ADD A, #1`).
3. Print the absolute value.

### Example Calculations

- **Case 1 (Positive Result):** .
- Display: `7Ch - 70h = 0Ch`.

- **Case 2 (Negative Result):** .
- Calc: `70h - 7Ch = F4h` (in U2).
- MSB of `F4h` is 1.
- Absolute Value: `CPL F4` = `0B`, `ADD 1` = `0C`.
- Display: `70h - 7Ch = -0Ch`.

---

## 3. Exercise 1a: Interactive Signed Subtraction (`lab4d_z1a`)

### Objective

Same logic as Exercise 1, but arguments are input via the keypad using `GET_NUM`.

### Input Logic & Validation

1. **Input:** User enters up to 3 digits. `GET_NUM` stores this BCD at `ARG1`.
2. **Conversion:** `BCD_HEX` converts the input to binary/hex.
3. **Two-Step Validation:**

- **Step 1 (Size < 255):** Check if the High Byte of the converted number (`ARG1+1`) is non-zero. If it is, the number > 255. Error.
- **Step 2 (Sign < 128):** Check the MSB of the Low Byte (`ARG1`). If set, number > 127. Error.
- _Note:_ This strict validation ensures the user doesn't enter a number that would be interpreted as negative in 8-bit signed arithmetic (e.g., 200 is `C8h`, which is -56 in U2).

### Display Formatting

- Uses a `SPACES` subroutine to clear the line before printing new results.
- **Output Format:**
- Line 1: `ARG1 - ARG2` (Raw input echo).
- Line 2: `XXh - YYh = ZZh` (or `-ZZh`).

---

## 4. Exercise 2: Integer Division (`lab4d_z2`)

### Objective

Divide two 1-byte numbers stored in memory and display the Quotient and Remainder.

- **Formula:** `ARG1 / ARG2 = Quotient (Rem)`
- **Data Types:** Unsigned 8-bit integers (0-255).

### Memory Map

- `ARG1` (20h): Dividend.
- `ARG2` (21h): Divisor.
- `DIV` (25h): Quotient.
- `DIV+1` (26h): Remainder.

### Algorithm & Code Logic

1. **Load Data:**

- Move `ARG1` to Accumulator **A**.
- Move `ARG2` to Register **B**.

2. **Execution:**

- `DIV AB` (Divides A by B).
- Result: **A** = Quotient, **B** = Remainder.
- Store A to `DIV` and B to `DIV+1`.

3. **Conditional Display:**

- Print: `ARG1h / ARG2h = `
- Print Quotient (`DIV`).
- **Remainder Check:** Check if `DIV+1` (Remainder) is 0.
- **If 0:** Stop printing. (Output: `A0h / 7Ah = 01h`).
- **If > 0:** Print space, then Remainder. (Output: `C8h / 0Ah = 14h 00h` - _Note: The slide example actually shows `14h` quotient and `00` rem, logic implies printing remainder if it exists_).

### Lab 4.05 Reference (Division with Validation)

The document mentions a modification (likely for homework or advanced lab):

- Input via Keypad.
- **Validation:** Divisor (`ARG2`) must be and **not zero**.
- Division by zero using `DIV AB` sets the Overflow (OV) flag, but manual checking is safer before execution.
