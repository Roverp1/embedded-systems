# Laboratory 6: Advanced 16-bit Arithmetic

## 1. Task 4.1: 16-bit Addition (Hex Input)

### Objective

Create a program that adds two 16-bit (2-byte) numbers and displays the 3-byte result.

- **Operation:**
- **Data Range:** Inputs are . The maximum sum is .

### Input Logic

- **Procedure:** Uses a **custom input procedure** (referenced as defined in `lab5_060`, distinct from the standard `GET_NUM`).
- **Format:** Reads exactly **4 characters** from the keypad.
- **Allowed Keys:** .
- **Interpretation:** The inputs are treated directly as 16-bit Hexadecimal numbers.

### Processing Logic

- **Algorithm:** Uses the `ADD_2_2` procedure (referenced from `lab5_02a`).
- **Mechanism:**

1. Add Low Bytes (`ADD`).
2. Add High Bytes with Carry (`ADDC`).
3. Store any final Carry into a third result byte (Overflow handling).

- **Result Storage:** The result requires **3 bytes** to store values up to `1FFFEh`.

### Display Formatting

- **Format:** `Arg1h + Arg2h = Resulth`
- **Style:** All numbers are displayed in Hexadecimal with the letter 'h' appended.
- **Example Output:**
- `FFFFh + FFFFh = 01FFFEh`
- `ACB0h + DB0Ah = 01887Bh` (Note: , check carry logic in display).
- `0000h + 0000h = 000000h`

---

## 2. Task 4.2: 16-bit 8-bit Multiplication (Mixed Input)

### Objective

Create a program that multiplies a 2-byte number by a 1-byte number, handling specific input format constraints.

- **Operation:**
- **Max Calculation:** .

### Input Logic (Mixed Modes)

1. **Argument 1 (Multiplicand):**

- **Method:** `GET_NUM` (Standard BCD input).
- **Range:** (entered as 4 digits).
- **Conversion:** **None.** The program explicitly **skips** `BCD_HEX`.
- **Effect:** The BCD input (e.g., entering "9999") is stored in memory as `99h 99h`. The program treats this raw BCD data as the Hexadecimal value (Decimal 39,321).

2. **Argument 2 (Multiplier):**

- **Method:** `GET_NUM`.
- **Range:** (entered as decimal).
- **Conversion:** **Yes.** The program **uses** `BCD_HEX`.
- **Effect:** The input is converted to standard Hex (e.g., entering "255" becomes ).

### Processing Logic

- **Algorithm:** Uses a 2-byte by 1-byte multiplication algorithm (referenced from `lab6_02`).
- **Result Storage:** The result requires **3 bytes**.

### Display Formatting

- **Format:** `Arg1 * Arg2 = Result`
- **Style:** Numbers are displayed in Hexadecimal **without** the 'h' suffix.
- **Example Output:**
- `9999 * FF = 98FF67`
- `0123 * 78 = 008868`
- `0000 * 00 = 000000`
- `0000 * 20 = 000000`

---

## 3. Key Differences in Data Handling

| Feature          | Task 4.1                   | Task 4.2                     |
| ---------------- | -------------------------- | ---------------------------- |
| **Input Source** | Custom Procedure (4 chars) | `GET_NUM` (Standard)         |
| **Input Radix**  | Hexadecimal [0-F]          | Mixed (Pseudo-Hex & Decimal) |
| **Conversion**   | Raw Hex interpretation     | Arg1: Raw BCD as Hex<br>     |

<br>Arg2: BCD to Hex |
| **Operation** | Addition (16-bit + 16-bit) | Multiplication (16-bit \* 8-bit) |
| **Result Size** | 3 Bytes | 3 Bytes |
| **Display Suffix** | Uses 'h' (e.g., `FFFFh`) | No suffix (e.g., `9999`) |
