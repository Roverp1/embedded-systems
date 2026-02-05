# Laboratory 5: Signed Subtraction with BCD Display

## 1. Objective

The goal is to write a program that subtracts two 1-byte numbers entered via the keypad and displays the result in both Hexadecimal and Decimal formats.

- **Formula:** `ARG1 - ARG2 = Difference`
- **Input Constraints:**
- Arguments are entered using `GET_NUM` (BCD input).
- Converted to binary/hex using `BCD_HEX`.
- **Value Range:** . Since the result is treated as a signed number (U2 code), the operands must be positive (Bit 7 = 0) to avoid overflow interpretation issues at the input stage.

- **Result Range:** .

## 2. Memory Map & Definitions

- **ARG1 / ARG1+1** (`20h`): First argument (2 bytes buffer for `GET_NUM`).
- **ARG2 / ARG2+1** (`22h`): Second argument.
- **SUB** (`25h`): Difference (Result).
- **ROB** (`30h`): Working buffer (3 bytes) used for BCD conversions.

---

## 3. Algorithm & Code Logic (`lab3_04.asm`)

### Phase 1: Input & Validation

The program performs a strict two-step validation for both arguments to ensure they fit in a signed 8-bit positive range.

1.  **Input:** Call `GET_NUM` to read digits, then `BCD_HEX` to convert to binary.

2.  **Check 1 (Size 255):** Check if the High Byte (`ARG1+1`) is non-zero. If it is, the number > 255. Jump to `START` (Reset).

3.  **Check 2 (Sign / Size 127):**

- Load Low Byte (`ARG1`) to Accumulator.
- `RLC A` (Rotate Left through Carry).
- If **Carry (C) = 1**, the MSB (Bit 7) was 1, meaning the number is . Jump to `START`.

4. Repeat for `ARG2`.

### Phase 2: Subtraction

1.  **Clear Carry:** `CLR C`.

2.  **Subtract:** `MOV A, ARG1` -> `SUBB A, ARG2`.

3.  **Store:** `MOV SUB, A`.

### Phase 3: Display - Line 1 (Hexadecimal)

- **Format:** `ARG1h - ARG2h = RESULTh`
- **Method:** Use `WRITE_HEX` standard subroutine.
- **Negative Handling:**
- Check MSB of `SUB`. If 0, print as is.
- If 1 (Negative), print `'-'`, then calculate Absolute Value (U2 Logic: `CPL A`, `ADD A, #1`), then print.

### Phase 4: Display - Line 2 (Decimal / BCD)

- **Format:** `ARG1d - ARG2d = RESULTd`
- **Conversion Routine:**
- To display numbers like "123" instead of "7B", the program uses the `HEX_BCD` subroutine.
- **Process:** Copy the value (e.g., `ARG1`) to the `ROB` buffer -> Call `HEX_BCD` (converts binary to 3 packed BCD bytes) -> Call `PISZ_BCD` (custom routine to print BCD).

- **Negative Result:**
- If `SUB` is negative, print `'-'` manually.
- Convert `SUB` to absolute value before passing it to `HEX_BCD` to ensure the printed digits are correct (e.g., prints "5" for "-5", not "251").

---

## 4. Helper Subroutines

### `PISZ_BCD` (Print BCD)

Responsible for printing the decimal digits stored in the `ROB` buffer after `HEX_BCD` conversion.

- **Logic:**

1. Check High Byte (`ROB+1`). If 0, skip printing it (suppress leading zero).
2. If non-zero, call `WRITE_HEX` on `ROB+1`.
3. Always call `WRITE_HEX` on `ROB` (Low Byte).

- _Note:_ `HEX_BCD` output format is usually 3 bytes, but for 8-bit numbers (), 2 bytes are sufficient to hold BCD digits (e.g., 255 is `02 55`).

### `ZERUJ_ROB` (Clear Buffer)

Clears the 3-byte working buffer (`ROB`, `ROB+1`, `ROB+2`) to `0` before starting a new conversion to ensure no garbage data affects `HEX_BCD`.
