# Lecture 1: Embedded Systems & Assembly (DSM-51 / 8051)

## 1. Introduction to Assembly Language

### Definition and Characteristics

- **Definition:** Assembly is a low-level, machine-oriented programming language.
- **Relation to Machine Code:** Each Assembly instruction corresponds to exactly one machine language instruction (1-to-1 mapping), unlike high-level languages.
- **Mnemonics:** It uses symbolic names (mnemonics) for instructions and registers, and symbolic addresses (labels) instead of binary/hex codes.
- **Pros:**
- High execution speed.
- Code compactness (small size).
- Direct and full control over hardware components.
- High efficiency.

- **Cons:**
- Difficult to learn and program compared to high-level languages (e.g., Visual Basic, C).
- Longer development, testing, and modification time.
- Higher risk of hidden errors.
- Low portability (code is processor-specific).

### History

- **First Assembler:** Created by Konrad Zuse in 1945 for the Z4 machine (module "Planfertigungsteil").
- **First Polish Assembler:** SAS (System Adresów Symbolicznych) for the XYZ computer (~1958).
- **Notable Polish Assemblers:** "PLAN" (Odra computers) and "MOTIS" (Mera 300).

## 2. Compilation and Build Process

The process of creating an executable program in Assembly involves several steps:

1. **Source Code (`.asm`):** The text file containing the assembly code.
2. **Assembler:** Converts `.asm` into an Object file (`.obj`) and generates a Listing file (`.lst`).
3. **Linker:** Combines `.obj` files and libraries (`.lib`) to create the executable (`.exe` or `.hex`) and a Map file (`.map`).

### Testing and Debugging

- **Debugger:** A program used to test and trace the execution of the software.
- **Functions:**
- Trace program execution step-by-step.
- Monitor the state of the processor (registers) and memory.
- Modify data in registers or memory during execution.

## 3. Hardware: DSM-51 Educational System

The course utilizes the **DSM-51**, a didactic microprocessor system based on the 8051 microcontroller architecture.

### Specifications

- **Microcontroller:** 80C51 (Clock: 11.059 MHz).
- **Memory:** 32 kB EPROM (program) and 32 kB RAM (data).
- **Display:**
- 6-digit LED display.
- LCD Display ( characters).

- **Input:**
- Matrix Keypad ( buttons).
- Sequentially scanned keypad.

- **I/O and Interfaces:**
- RS232 serial interface (2 channels).
- 24 digital I/O lines.
- LED indicators and a Buzzer.
- A/D and D/A converters (8 input lines, 1 output line).

- **Power:** 9V power supply.

### Operation Modes

1. **With PC:** Allows downloading user programs to RAM, running in continuous mode, or step-by-step debugging via PC monitor.
2. **Standalone:** Allows entering short assembly programs via the built-in keypad and running them.

## 4. Software: "Jagoda" Simulator

"Jagoda" is the simulator used to emulate the DSM-51 system on a PC.

### Installation & Setup

- **32-bit Systems:** Directly install/copy to `C:\`.
- **64-bit Systems:** Requires a Virtual Machine (e.g., Oracle VirtualBox) running Windows XP or Windows 7 (32-bit).
- _Performance Note:_ If the simulator runs very slowly on a fast machine, disable Hyper-V (`bcdedit /set hypervisorlaunchtype off`) to allow proper nested virtualization/emulation.

### Interface Overview

- **Code Window:** For editing and viewing `.asm` files.
- **CPU Window:** Displays current Register values (A, B, R0-R7, DPTR, PC, SP, Flags).
- **Memory Windows:**
- **CRAM (Code RAM):** Shows the program memory in Hex.
- **IRAM (Internal RAM):** Shows internal memory (00h-FFh).

- **Peripheral Windows:**
- **LEDs:** Visual representation of Port 1 outputs.
- **LCD:** Visual representation of the character display.
- **Keypad:** Clickable matrix keypad simulation.

- **Control Keys:**
- **F7:** Step Into (execute one instruction).
- **F8:** Step Over (execute a procedure/call at once).
- **F9:** Run continuous.
- **Ctrl+F2:** Stop/Reset.

## 5. 8051 Assembly Language Reference

### Addressing Modes and Notation

- **A / ACC:** Accumulator.
- **B:** B Register (used for multiplication/division).
- **Rr:** Registers R0 through R7.
- **direct:** Direct address (0-127 for RAM, 128-255 for SFRs).
- **@Ri:** Indirect addressing via R0 or R1.
- **#data:** 8-bit immediate constant.
- **#data16:** 16-bit immediate constant.
- **bit:** Direct bit address.
- **rel:** Relative offset (-128 to +127) for jumps.
- **addr11 / addr16:** Absolute addresses for calls/jumps.

### Special Function Registers (SFR) Locations

| Symbol        | Name                        | Address              |
| ------------- | --------------------------- | -------------------- |
| **ACC**       | Accumulator                 | 0E0H                 |
| **B**         | B Register                  | 0F0H                 |
| **PSW**       | Program Status Word (Flags) | 0D0H                 |
| **SP**        | Stack Pointer               | 81H                  |
| **DPTR**      | Data Pointer (DPH + DPL)    | 83H + 82H            |
| **P0 - P3**   | I/O Ports                   | 80H, 90H, 0A0H, 0B0H |
| **TMOD/TCON** | Timer Controls              | 89H, 88H             |
| **SCON/SBUF** | Serial Control/Buffer       | 98H, 99H             |

### Instruction Set Summary

#### 1. Data Transfer (Copying)

- **MOV dest, src:** Copies data from source to destination.
- Ex: `MOV A, #0` (Load 0 into A), `MOV P1, A` (Output A to Port 1).

- **MOVX:** Access external memory.
- **MOVC:** Move code byte (program memory) to Accumulator (e.g., `MOVC A, @A+DPTR` for looking up tables).
- **PUSH / POP:** Stack operations.
- **XCH:** Exchange bytes.

#### 2. Arithmetic Operations

- **ADD A, source:** Add source to A.
- **ADDC A, source:** Add with Carry.
- **SUBB A, source:** Subtract with Borrow.
- **INC / DEC:** Increment / Decrement operand.
- **MUL AB:** Multiply A by B (Result: A=Low, B=High).
- **DIV AB:** Divide A by B (Result: A=Quotient, B=Remainder).

#### 3. Logical Operations

- **ANL:** Bitwise AND.
- **ORL:** Bitwise OR.
- **XRL:** Bitwise XOR.
- **CLR:** Clear (set to 0).
- **CPL:** Complement (invert bits).
- **RL / RR:** Rotate A Left / Right.
- **RLC / RRC:** Rotate A through Carry Flag.
- **SWAP A:** Swap upper and lower nibbles of A.

#### 4. Boolean (Bit) Operations

- **SETB bit:** Set bit to 1.
- **CLR bit:** Clear bit to 0.
- **CPL bit:** Invert bit.
- **JB / JNB:** Jump if Bit Set / Jump if Bit Not Set.

#### 5. Branching (Jumps & Calls)

- **LJMP / AJMP / SJMP:** Unconditional jumps (Long, Absolute, Short).
- **JZ / JNZ:** Jump if Accumulator Zero / Not Zero.
- **CJNE:** Compare and Jump if Not Equal.
- **DJNZ:** Decrement and Jump if Not Zero (crucial for loops).
- **LCALL / ACALL:** Call subroutine.
- **RET / RETI:** Return from subroutine / interrupt.

## 6. DSM-51 System Subroutines (BIOS)

The DSM-51 EPROM contains pre-written subroutines available for user programs. Assignments rely heavily on these.

| Subroutine     | Description                                 | Inputs/Usage                                                                                       |
| -------------- | ------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| **WRITE_TEXT** | Displays text on LCD.                       | **DPTR** points to text address (must end with 0 byte).                                            |
| **WRITE_DATA** | Displays 1 byte (char) from A on LCD.       | **A** = Character ASCII code.                                                                      |
| **WRITE_HEX**  | Displays byte from A as Hex on LCD.         | **A** = Byte to display.                                                                           |
| **LCD_CLR**    | Clears LCD and resets cursor.               | None.                                                                                              |
| **LCD_INIT**   | Initializes LCD (required at start).        | None.                                                                                              |
| **DELAY_MS**   | Delays execution.                           | **A** = time in 100ms units (slides say "A \* 100ms", but example comments say "A=0 means 256ms"). |
| **WAIT_KEY**   | Waits for matrix keypad press.              | Returns Key Code in **A**.                                                                         |
| **WAIT_ENTER** | Displays "PRESS ENTER" and waits.           | None.                                                                                              |
| **TEST_ENTER** | Checks if Enter is pressed without waiting. | **C (Carry Flag):** 0 = Pressed, 1 = Not Pressed.                                                  |

### Keypad Mapping

When using `WAIT_KEY`, the Matrix Keypad returns values in the Accumulator:

- Keys **0-9** return values **0-9**.
- **Góra (Up):** A
- **Lewo (Left):** B
- **Prawo (Right):** C
- **Dół (Down):** D
- **Esc:** E
- **Enter:** F

## 7. Lab Exercises & Practical Logic

The PDF details several progressive lab exercises involving LEDs, the Buzzer, and the LCD.

### Lab 1.01: Blinking LED

- **Goal:** Blink the LED on P1.7.
- **Logic:**

1. `CLR LED` (Port logic is usually inverted or current sinking; CLR often turns ON).
2. `LCALL DELAY_MS` (Wait).
3. `SETB LED` (Turn OFF).
4. `LCALL DELAY_MS` (Wait).
5. `LJMP LOOP` (Repeat).

- **Files:** `lab1_01.asm`.

### Lab 1.01a: Custom Timings

- **Goal:** LED ON for ms, OFF for ms.
- **Logic:** Uses a custom loop with `DJNZ`.
- Load loop counter into R0 (e.g., `MOV R0, #5`).
- Call `DELAY_MS`.
- `DJNZ R0, Label` (Decrement R0, jump if not zero).

### Lab 1.01b: User Input (Buzzer & LED)

- **Goal:** Read a digit from the keypad. Turn LED and Buzzer ON for ms, then OFF for same duration.
- **Logic:**

1. `LCALL WAIT_KEY`.
2. If key is 0 (`JZ START`), restart (treat 0 as error).
3. Save input to `R1`.
4. Use `R1` as the counter for the delay loop.

### Lab 1.01c/d/e/f/g: Advanced Input & Display

These exercises refine the previous ones by adding LCD feedback and error checking.

- **ASCII Conversion:** To display a numeric key press (0-9) on the LCD:
- `ADD A, #30h` (Converts raw 0-9 to ASCII '0'-'9').
- `LCALL WRITE_DATA`.

- **Handling Hex Keys (A-F):**
- If the key value > 9, you cannot just add 30h.
- Logic: Subtract 10. If Carry is set (negative), it's 0-9. If not, it's A-F.
- If A-F: `ADD A, #37h` to convert to ASCII 'A'-'F'.

- **Strings:** Use `DB 'My String', 0` to define data. Use `MOV DPTR, #Label` to point to it before calling `WRITE_TEXT`.

### Lab 1.03: Main Loop & Subroutines with Break

- **Goal:** Run a blinking loop continuously, but allow breaking out of the loop by holding 'Enter'.
- **Logic:**
- Inside the blinking loop, call `TEST_ENTER`.
- `JC DIODA` (Jump if Carry=1, meaning Enter NOT pressed, continue loop).
- `RET` (If Carry=0, Enter IS pressed, return from subroutine).
- Main program displays "KONIEC" upon return.

### Practical Tips for Assignments

1. **Definitions:** Always define pins using `EQU` (e.g., `LED EQU P1.7`, `BUZZ EQU P1.5`) for readability.
2. **Stack:** The simulator initializes `SP` (Stack Pointer) to `07`.
3. **Active Low:** The buzzer and LEDs on DSM-51 are often active low (CLR to turn on, SETB to turn off).
4. **Preserving Registers:** If a subroutine uses a register (like R0) that the main program also needs, push it to stack or use a different register.
5. **ASCII Math:**

- Digit (0-9) to ASCII: `+ 30h`
- Hex digit (A-F) to ASCII: `+ 37h`
- Space ASCII: `20h`
