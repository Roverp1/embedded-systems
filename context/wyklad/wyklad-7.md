# Lecture 7: Advanced Arithmetic & Algorithms (DSM-51)

## 1. 8051 Instruction Set Reference

_Note: This section reiterates the standard instruction set provided in previous lectures, serving as a reference for the exercises below._

### Arithmetic Operations

| Instruction     | Description                                                 | Flags Affected       |
| --------------- | ----------------------------------------------------------- | -------------------- |
| **ADD A, src**  | Add source to Accumulator.                                  | C, AC, OV            |
| **ADDC A, src** | Add source to Accumulator with Carry (A + src + C).         | C, AC, OV            |
| **SUBB A, src** | Subtract source from Accumulator with Borrow (A - src - C). | C, AC, OV            |
| **INC dest**    | Increment operand by 1.                                     | None                 |
| **DEC dest**    | Decrement operand by 1.                                     | None                 |
| **MUL AB**      | Multiply A by B. Result: A (Low), B (High).                 | OV (if result > 255) |
| **DIV AB**      | Divide A by B. Result: A (Quotient), B (Remainder).         | OV (if div by 0)     |
| **DA A**        | Decimal Adjust Accumulator (for BCD).                       | C                    |

### Logic & Bit Operations

- **ANL, ORL, XRL:** Logical AND, OR, XOR.
- **CLR, CPL:** Clear or Complement (Invert) A, C, or Bit.
- **RL, RR:** Rotate Accumulator Left/Right.
- **RLC, RRC:** Rotate Accumulator through Carry.
- **SWAP A:** Swap upper and lower nibbles of A.

### Data Transfer & Branching

- **MOV:** Copy data.
- **MOVC:** Move code byte (from ROM).
- **MOVX:** Move external data (RAM).
- **PUSH/POP:** Stack operations.
- **Jumps:** `LJMP`, `AJMP`, `SJMP` (Unconditional), `JZ`/`JNZ` (Accumulator zero/not zero), `JC`/`JNC` (Carry), `CJNE` (Compare and Jump if Not Equal), `DJNZ` (Decrement and Jump if Not Zero).

---

## 2. DSM-51 BIOS Subroutine Reference

The system provides standard subroutines in EPROM.

- **Display:** `WRITE_TEXT` (Print string at DPTR), `WRITE_DATA` (Print char in A), `WRITE_HEX` (Print hex byte in A), `LCD_CLR` (Clear screen), `LCD_INIT` (Init LCD).
- **Input:**
- `WAIT_KEY`: Returns key code in A.
- `GET_NUM`: Reads up to 4 digits BCD to address `@R0`.

- **Math:**
- `BCD_HEX`: Converts packed BCD (at `@R0`) to Hex.
- `HEX_BCD`: Converts Hex (at `@R0`) to packed BCD.
- `MUL_2_2`: Multiplies 2 bytes by 2 bytes. **(Note: Has bugs, see Lab 5.06a)**.
- `DIV_2_1`: Divides 2 bytes by 1 byte.

- **Timing:** `DELAY_MS` (Wait A \* 100ms).

---

## 3. Lab 5: Advanced Multiplication & Addition

### Lab 5.01: 16-bit Addition

**Goal:** Add two 16-bit numbers.

- **Inputs:**
- Number 1: `R1` (High Byte), `R0` (Low Byte).
- Number 2: `R3` (High Byte), `R2` (Low Byte).

- **Output:** `R6` (Highest), `R5`, `R4` (Lowest) -> 3-byte result.
- **Algorithm:**

1. Clear Carry (`CLR C`).
2. Add low bytes: `MOV A, R0` -> `ADD A, R2` -> `MOV R4, A`.
3. Add high bytes with Carry: `MOV A, R1` -> `ADDC A, R3` -> `MOV R5, A`.
4. Handle final Carry (Overflow):

- If `C=0`, set `R6 = 0`.
- If `C=1`, set `R6 = 1`.

- **Example:** `FFFFh + FFFFh = 01FFFEh`.

### Lab 5.02a: 16-bit Addition with Input

**Goal:** Input two numbers (0-9999, interpreted as Hex) and display the sum.

- **Memory:** `ARG1` (20h), `ARG2` (22h), `SUM` (25h).
- **Input:** Uses `GET_NUM`. Note that inputting "9999" via `GET_NUM` without `BCD_HEX` results in the value `9999h` (which is decimal 39321).
- **Subroutine `ADD_2_2`:**
- Performs the addition logic (Low byte `ADD`, High byte `ADDC`, carry check).

- **Display:** Formats output as `Arg1+Arg2=Sum` in Hex (e.g., `1234+4321=015555`).

### Lab 5.02b: Leading Zero Suppression

**Goal:** Same as 5.02a, but suppress non-significant zeros in the display.

- **Key Procedure: `BEZ_ZER` (Without Zeros)**
- **Input:** Buffer address in `R0`.
- **Algorithm:**

1. Iterates through bytes/nibbles.
2. Uses a flag to track if a non-zero digit has been seen yet.
3. If digit is 0 and flag is not set (leading zero), skip printing.
4. If digit is non-zero, set flag and print.
5. Always print the final digit (LSB) even if 0, to handle the value "0".

- **Visual Result:** Instead of `0012 + 0001 = 000013`, displays `12 + 1 = 13`.

### Lab 5.03: 16-bit by 8-bit Multiplication

**Goal:** Multiply a 2-byte number (`R1:R0`) by a 1-byte number (`R2`).

- **Result:** 3 bytes (`R6:R5:R4`).
- **Algorithm (Decomposition):**

1. **Low Part:** .

- `MOV A, R0`, `MOV B, R2`, `MUL AB`.
- Store Low (A) in `R4`.
- Store High (B) in `R5` (Temporary).

2. **High Part:** .

- `MOV A, R1`, `MOV B, R2`, `MUL AB`.
- Add result to the previous high part: `ADD A, R5` (Add A to temp R5).
- Store result in `R5`.
- Handle Carry: `MOV R6, B` -> `ADDC A, R6` (Add carry to B part).
- Store final High byte in `R6`.

- **Example:** `FFFh * FFh = FEFF01h`.

### Lab 5.04c: 16-bit \* 8-bit with Custom Input

**Goal:** Input a 4-digit Hex number (16-bit) and a 2-digit Hex number (8-bit) and multiply.

- **Custom Procedure `READ_HEX`:**
- Required because `GET_NUM` usually stops at 4 digits or limits keys 0-9.
- **Logic:**

1. Wait for key (`WAIT_KEY`).
2. Display digit.
3. Shift previous value left (Swap nibbles or multiply by 16) and add new digit.
4. Repeat for 4 digits (High Byte then Low Byte).

- **Validation:** Check if the second argument (`ARG2`) fits in 8 bits (High byte must be 0). If not, display "ERROR".

### Lab 5.05: 16-bit by 16-bit Multiplication (Manual Algorithm)

**Goal:** Multiply `ARG1` (2 bytes) by `ARG2` (2 bytes).

- **Result:** 4 bytes stored in `R7:R6:R5:R4`.
- **Algorithm:**
- Decompose `ARG1` into `R1:R0` and `ARG2` into `R3:R2`.
- Sum four partial products:

1.  (Low Low) -> result to R4, carry/high to R5.
2.  (Low High) -> Add to R5, carry to R6.
3.  (High Low) -> Add to R5/R6/R7.
4.  (High High) -> Add to R6/R7.

- _Implementation Detail:_ Careful handling of `ADD` vs `ADDC` is required at every step to propagate carries across the 4 result bytes.

### Lab 5.06a: Standard `MUL_2_2` & Its Bugs

**Goal:** Use the BIOS routine `MUL_2_2`.

- **Inputs:** Multiplicand at `@R0`, Multiplier in `B` (High) and `A` (Low).
- **Result:** 4 bytes at `@R0`.
- **Warning:** The document explicitly states **"For certain arguments, procedure `MUL_2_2` works incorrectly."**
- _Example Error 1:_ `9E9A * 9E9F` yields `61458DA6` (Correct: `62458DA6`).
- _Example Error 2:_ `9999 * 9999` yields `5B283D71` (Correct: `5C283D71`).
- _Example Error 3:_ `AAAA * AAAA` yields `70C638E4` (Correct: `71C638E4`).

### Lab 6.04: Corrected `MUL_2_2P`

**Goal:** Implement a patched version of 16-bit multiplication (`MUL_2_2P`) to fix the bugs in the standard BIOS.

- **Code Implementation:**
- Uses 6 working registers (`REG` to `REG+5`) to save `R2-R7` state.
- Clears `R4-R7` (Accumulators).
- Performs the 4-step partial product summation described in Lab 5.05 manually in Assembly.
- Restores registers at the end.

---

## 4. Lab 7: Division

### Lab 7.01: 16-bit / 8-bit Division (Hex Mode)

**Goal:** Divide a 4-digit Hex number by a 2-digit Hex number.

- **Standard Procedure:** `DIV_2_1`.
- **Inputs:**
- Dividend address: `R0` (points to 2 bytes, e.g., 50h, 51h).
- Divisor value: `B`.

- **Outputs:**
- Quotient address: `@R0` (overwrites dividend).
- Remainder: `A`.

- **Process:**

1. Input `AD1` (Dividend) via `GET_NUM` (Treats input as Hex: `10` -> `10h`).
2. Input `AD2` (Divisor).
3. Call `DIV_2_1`.
4. Display Result + 'h' and Remainder + 'h'.

- **Example Output:** `9999h / 99h = 0101h R 00h` (Note: is equivalent to ).

### Lab 7.03: 16-bit / 8-bit Division (Decimal Mode)

**Goal:** Perform division on Decimal inputs and display Decimal results.

- **Logic Change:**
- User inputs "9999". `GET_NUM` reads this as raw digits.
- **Call `BCD_HEX`:** Converts the input "9999" (treated as decimal) into its Hex equivalent (`270Fh`) for the processor.
- Perform `DIV_2_1`.
- **Call `HEX_BCD`:** Converts the Hex result back to BCD for display.

- **Display:** Add suffix 'd'.
- **Example Output:** `9999d / 4d = 2499d R 0003d`.

### Lab 7.05: Division with Validation

**Goal:** Robust division calculator.

- **Requirements:**

1. Inputs: [0-9999] Decimal.
2. Validation 1: Check if Divisor (since `DIV_2_1` only supports 8-bit divisor).

- Check if High Byte of divisor > 0. If yes, Error.

3. Validation 2: Check if Divisor .

- If Divisor = 0, Error.

4. Output: Decimal format, **suppress leading zeros** (using `BEZ_ZER`), suppress Remainder if it is 0.

- **Example Error Handling:**
- Input `9999 / 260` -> "ERROR" (Divisor > 255).
- Input `50 / 0` -> "ERROR".

---

## 5. Summary of Key Algorithms Provided in Code

### `READ_HEX` (Custom Input)

1. Initialize storage.
2. Loop 4 times (for 4 nibbles/2 bytes):

- Get Key (`WAIT_KEY`).
- Print Digit (`PISZ_CYFRA`).
- Shift current 16-bit value left by 4 bits.
- High Byte: `SWAP`, Mask, Add shifted Low Byte upper nibble.
- Low Byte: `SWAP`, Mask, Add new nibble.

- Store updated value.

### `BEZ_ZER` (Zero Suppression)

- Iterate through the buffer bytes.
- Skip printing '0' characters until a non-zero character is found.
- If the very last character is '0' and nothing was printed, print '0'.

### `PISZ_CYFRA` (Print Digit)

- Takes a raw value (0-15) in A.
- If A < 10, add `48` ('0') to get ASCII.
- If A >= 10, add `55` ('A'-10) to get ASCII.
- Call `WRITE_DATA`.
