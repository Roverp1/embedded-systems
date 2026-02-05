# Laboratory 1: Introduction to DSM-51 "Jagoda" & Basic I/O

## 1. Simulator Setup & Environment

The laboratory uses the **DSM-51 "Jagoda"** simulator. Due to compatibility issues with modern 64-bit systems, a specific setup is required.

- **Installation:**
- Requires a Virtual Machine (e.g., Oracle VM VirtualBox) running a 32-bit OS (Windows XP or Windows 7).
- The simulator folder (e.g., `Jagoda`) should be placed in the root directory `C:\` of the virtual machine.

- **File Structure:**
- Programs are organized into folders (e.g., `mod1`, `mod2`).
- Source files have the `.asm` extension.
- Associated files generated during compilation: `.hex` (machine code), `.lst` (listing).

- **Operation:**
- Code can be edited in external text editors or the built-in editor.
- **Keypad Interaction:** When using the matrix keypad in the simulator, you must click the specific window to make it active (blue title bar). Mouse clicks on keys should be held for **2-3 seconds**, and intervals between clicks should also be 2-3 seconds to ensure the simulated OS registers the input.

## 2. Reference Tables (Cheat Sheets)

The document provides essential reference tables for programming the 8051.

- **ASCII Table:** provided for conversion between Char, Decimal, and Hex (e.g., Space = 20h, '0' = 30h, 'A' = 41h).
- **Instruction Set:** A summary of standard 8051 instructions (Arithmetic, Logic, Data Transfer, Jumps) matching the lecture notes.
- **DSM-51 BIOS Subroutines:** A list of pre-defined subroutines available in the system EPROM.

### Key BIOS Subroutines (Memory & Register Usage)

| Subroutine     | Stack | Inputs                    | Description                                                                                                                              |
| -------------- | ----- | ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| **WRITE_TEXT** | 2     | **DPTR**: Address of text | Prints text ending in 0-byte to LCD.                                                                                                     |
| **WRITE_DATA** | 2     | **A**: Char Byte          | Prints single character to LCD.                                                                                                          |
| **WRITE_HEX**  | 3     | **A**: Byte               | Prints byte as two Hex digits.                                                                                                           |
| **LCD_CLR**    | 1     | None                      | Clears LCD and resets cursor.                                                                                                            |
| **LCD_INIT**   | 2     | None                      | Initializes LCD.                                                                                                                         |
| **DELAY_MS**   | 1     | **A**: Time               | Delays for ms (ms). _Note: Lab 1 code comments suggest A=0 is 256ms, while lecture notes imply unit multipliers. Always verify context._ |
| **WAIT_KEY**   | 2     | None                      | Waits for keypad input. Returns key code (0-F) in **A**.                                                                                 |
| **WAIT_ENTER** | 4     | None                      | Prompts "PRESS ENTER..." and waits.                                                                                                      |
| **GET_NUM**    | 4     | **@R0**: Dest Addr        | Reads up to 4 BCD digits. Ends on Enter or Esc.                                                                                          |

## 3. Hardware Control Logic

The lab focuses on controlling the specific hardware of the DSM-51:

- **LED:** Connected to **P1.7**.
- **Buzzer (Brzęczyk):** Connected to **P1.5**.
- **Logic Levels (Active Low):**
- **Turn ON:** Write **0** (Instruction `CLR`).
- **Turn OFF:** Write **1** (Instruction `SETB`).

## 4. Lab Exercises

### Exercise 1.01: Basic Blinking LED

**Goal:** Make the LED on P1.7 blink continuously with a fixed delay.

**Code Logic:**

1. **Define Pin:** `LED EQU P1.7`.
2. **Turn ON:** `CLR LED`.
3. **Delay:** Load `A` with 0 (for max delay) and call `DELAY_MS`.
4. **Turn OFF:** `SETB LED`.
5. **Delay:** Call `DELAY_MS` again.
6. **Loop:** Jump back to step 2 (`LJMP LOOP`).

### Exercise 1.01c: Interactive LED & Buzzer Control

**Goal:** Blink the LED and Buzzer alternately. The duration of the blink is determined by a user input digit (ms).

**Logic Flow:**

1. **Input:** Wait for a key press (`LCALL WAIT_KEY`). Result is in `A`.
2. **Validation:**

- If input is **0** (`JZ E1`), treat as error.
- **Error Handling:** Display "ERROR, CYFRA=0", wait for key, clear LCD, and restart.

3. **Storage:** Save the valid input from `A` to `R1`.
4. **Main Loop:**

- **State 1 (LED ON, Buzzer OFF):**
- `CLR LED` (LED On).
- `SETB BUZZ` (Buzzer Off).
- **Variable Delay:** Load (from `R1`) into `R0`. Call custom delay procedure `PROC1`.

- **State 2 (LED OFF, Buzzer ON):**
- `SETB LED` (LED Off).
- `CLR BUZZ` (Buzzer On).
- **Variable Delay:** Load (from `R1`) into `R0`. Call custom delay procedure `PROC1`.

- Repeat loop.

**Custom Delay Procedure (PROC1):**

- This creates a delay of ms.
- **Input:** `R0` contains the multiplier .
- **Loop:**

1. `MOV A, #0` (Set delay unit to 256ms).
2. `LCALL DELAY_MS` (Wait 256ms).
3. `DJNZ R0, PROC1` (Decrement `R0`, if not zero, repeat).
4. `RET` (Return when `R0` reaches 0).

**Source Code Definitions (`lab1_01c.asm`):**

```assembly
LED   EQU P1.7
BUZZ  EQU P1.5
...
TT1:  DB 'ERROR, CYFRA = 0', 0  ; Null-terminated error string

```
