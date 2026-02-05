# Laboratory 2: Modular Programming & LCD Control

## 1. Goal and Environment

The objective of this laboratory is to master the creation and usage of **subroutines (procedures)** in Assembly. This allows for cleaner code, reusability, and better program structure. The environment remains the **DSM-51 "Jagoda"** simulator.

- **Key Concept:** Replacing repetitive code blocks with `LCALL` (Long Call) or `ACALL` (Absolute Call) to a label, and ending those blocks with `RET` (Return).
- **Hardware Used:**
- **LED:** P1.7 (Active Low).
- **Buzzer:** P1.5 (Active Low).
- **LCD Display:** Used for displaying status text.
- **Matrix Keypad:** Used for user input.

## 2. Reference Tables

The document provides the standard 8051 instruction set reference (Arithmetic, Logic, Data Transfer, Branching) identical to previous lectures, emphasizing the tools needed for the exercises.

### Key BIOS Subroutines Used

| Subroutine     | Description                                 | Inputs                                                   |
| -------------- | ------------------------------------------- | -------------------------------------------------------- |
| **WRITE_TEXT** | Prints a null-terminated string to the LCD. | **DPTR**: Address of the string.                         |
| **LCD_CLR**    | Clears the LCD screen.                      | None.                                                    |
| **DELAY_MS**   | Delays execution.                           | **A**: Time unit (approx 100ms per unit, 0 = 256 units). |
| **WAIT_KEY**   | Pauses until a key is pressed.              | Returns key code in **A**.                               |

---

## 3. Lab Exercises: Subroutines & Text Formatting

### Exercise 2.01: Basic Subroutine (Blink Signal)

**Goal:** Create a program that signals a state by blinking the LED and beeping the Buzzer 3 times. This logic must be encapsulated in a subroutine named `SIGNAL`.

**Logic:**

1. **Main Loop:**

- Wait for a key press (`WAIT_KEY`).
- Call the `SIGNAL` subroutine.
- Repeat.

2. **Subroutine `SIGNAL`:**

- Load loop counter (e.g., `R0 = 3`).
- **Loop Label:**
- Turn LED & Buzzer **ON** (`CLR P1.7`, `CLR P1.5`).
- Wait (e.g., `MOV A, #2`, `LCALL DELAY_MS`).
- Turn LED & Buzzer **OFF** (`SETB P1.7`, `SETB P1.5`).
- Wait.
- Decrement counter and jump if not zero (`DJNZ R0, LoopLabel`).

- Return (`RET`).

### Exercise 2.02: Conditional Logic with Subroutines

**Goal:** Perform different actions based on specific key inputs.

- If key **'1'** is pressed: Run `SIGNAL` (3 blinks).
- If key **'2'** is pressed: Run a new subroutine `LONG_SIGNAL` (e.g., 1 long blink or different pattern).
- Any other key: Do nothing or wait again.

**Logic:**

1. Call `WAIT_KEY`.
2. Compare A with key codes:

- `CJNE A, #1, CheckNext` (If not 1, jump to check 2).
- `LCALL SIGNAL`.
- `SJMP Start`.
- `CheckNext`: `CJNE A, #2, Start`.
- `LCALL LONG_SIGNAL`.
- `SJMP Start`.

### Exercise 2.03 / 2.03a: LCD Text Formatting & Padding

**Goal:** Display text on the LCD that is centered or padded correctly, ensuring old text is overwritten without explicitly clearing the whole screen (which causes flickering).

**Problem:** If you print "HELLO" and then later print "HI" at the same position without clearing, you might get "HILLO" (artifacts).
**Solution:** Pad the string with spaces or use a helper routine to print spaces.

**Subroutine `NSPACE`:**

- **Function:** Prints a specific number of spaces to the LCD to clear the remainder of a line.
- **Input:** `R0` = Number of spaces to print.
- **Logic:**

1. Load Space ASCII code (`MOV A, #20h`).
2. `Loop:`
3. `LCALL WRITE_DATA` (Print space).
4. `DJNZ R0, Loop` (Repeat R0 times).
5. `RET`.

**Usage in Main Program (Lab 2.03a):**

1. **Line 1:**

- Point DPTR to Text 1 ("HELLO").
- `LCALL WRITE_TEXT`.
- Calculate remaining space (e.g., 16 chars width - 5 chars text = 11 spaces).
- `MOV R0, #11`.
- `LCALL NSPACE`.

2. **Line 2:**

- Repeat logic for the second line if necessary.

### Exercise 2.04: Custom Delays & Parameters

**Goal:** Create a flexible delay subroutine `WAIT_N_SEC`.

- **Input:** `A` (Accumulator) contains the number of seconds to wait.
- **Logic:**

1. Save `A` (seconds) into a register (e.g., `R1`).
2. **Outer Loop (Seconds):**

- Load `A` with 10 (since `DELAY_MS` takes 100ms units, ).
- **Inner Loop:** Call `DELAY_MS`.
- Decrement `R1`.
- If `R1` != 0, repeat Outer Loop.

3. `RET`.

---

## 4. Practical Programming Tips from Lab 2

1. **Stack Management:** When calling subroutines (`LCALL`), the processor pushes the Return Address onto the Stack. If you forget `RET`, the program will crash (stack overflow or erratic jumps).
2. **Register Preservation:** If your main program uses `R0` and your subroutine also uses `R0`, the subroutine **must** save `R0` (push to stack) at the start and restore it (pop) at the end, OR use a different register to avoid corrupting data.
3. **Modular Design:** Always define your data (strings) at the end of the file or in a specific data block to keep the code readable.

- Example: `TEXT1: DB 'Error Code', 0`

4. **LCD Artifacts:** Always assume the LCD retains previous characters. Either `LCD_CLR` (slow, flickers) or overwrite with spaces (fast, smooth).
