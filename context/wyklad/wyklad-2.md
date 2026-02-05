# Lecture 2: 8051 Microcontroller Architecture & Assembly

## 1. Microprocessor System Architecture

### Block Diagram Overview

A typical microprocessor system based on the Harvard architecture consists of distinct blocks connected by three main buses:

- **Address Bus (Magistrala adresowa):** Carries address information.

- **Data Bus (Magistrala danych):** Carries data between components.

- **Control Bus (Magistrala sterująca):** Carries control signals.

**Key Components:**

- **Microprocessor (CPU):** The central processing unit.

- **Program Memory (ROM):** Stores the program code.

- **Data Memory (RAM):** Stores variable data.

- **I/O Circuits (Układy WE-WY):** Interfaces with external devices.

- **External Devices (Urządzenia zewnętrzne):** The peripheral equipment or environment the system interacts with.

### CPU Internal Structure

The internal structure of the microprocessor includes:

- **Accumulator (A):** Central register for arithmetic/logic operations.

- **ALU (Arithmetic Logic Unit):** Performs calculations.

- **PC (Program Counter):** Holds the address of the next instruction.

- **Instruction Register & Decoder:** Decodes fetched instructions.

- **Stack Pointer:** Points to the current stack top.

- **Control Unit:** Manages internal operations.

- **Registers:** Includes status, data, address, and auxiliary registers.

## 2. 8051 Microcontroller Architecture

The 8051 architecture is characterized by several integrated components:

### Key Characteristics

- **CISC Architecture:** Complex Instruction Set Computer with 111 instructions.

- **Performance:** Approx. 1 MIPS at 12 MHz.

- **Accumulator-based:** Arithmetic operations primarily use the specialized register 'A' (Accumulator).

- **Bit-Addressability:** Capable of operating on single bits within specific memory areas.

- **Harvard Architecture:** Separate address spaces for Program Memory and Data Memory.

### Functional Blocks

- **CPU:** Central unit coordinating with interrupt controller.

- **Memory:** Internal ROM and RAM, plus an external bus controller.

- **Peripherals:**
- **I/O Ports:** 4 bidirectional ports (P0, P1, P2, P3) handling 32 lines.

- **Timers:** Two 16-bit Timer/Counters (Timer 0, Timer 1).

- **Serial Controller:** Full-duplex UART (RS232 standard).

- **Interrupt Controller:** Handles 5 interrupt sources (2 external, 2 timers, 1 serial).

- **Clock Generator:** Requires external crystal; machine cycle equals 12 clock periods.

### Memory Organization

- **Program Memory (ROM):**
- Standard: 4 kB internal ROM (or EPROM in some versions).

- Expandable: Up to 64 kB external.

- **Data Memory (RAM):**
- Internal: 128 bytes (Lower 128).

- Expandable: Up to 64 kB external.

- **Internal RAM Structure (256 bytes total in some models):**
- **Lower 128 (00H-7FH):** "Typical" RAM, accessible directly or indirectly. Includes register banks and bit-addressable area.

- **Upper 128 (80H-FFH):** Reserved for **SFR** (Special Function Registers) accessed via direct addressing. (In 8052-compatible variants, this address range also holds upper RAM accessed indirectly) .

## 3. Assembly Language Basics (Jagoda/A51)

### Line Format

`[Label] Mnemonic [Operands] [;Comment]`

- **Label:** Must start with a letter or underscore. If followed by ':', it defines an address.

- **Mnemonic:** The instruction name (e.g., MOV, ADD).

- **Operands:** Parameters separated by commas.

- **Comment:** Starts with ';', ignored by assembler.

### Numeric Constants

- **Decimal:** `125`.

- **Hex:** `0FAH` or `0FAh` (must start with digit, e.g., `0A5H`).

- **Binary:** `10101B` or `10101b`.

- **Character:** `'A'`.

### Assembler Directives

- **DB:** Define Byte (inserts numeric/text values into code).

- **DW:** Define Word (inserts 16-bit values, high byte first).

- **EQU:** Define Constant (assigns value to symbol).

- **ORG:** Origin (sets the address for the next code block).

- **END:** End of program.

### Operators

- **Arithmetic:** `+`, `-`, `*`, `/` supported in expressions.

- **Bit Selection:** `.n` (e.g., `ACC.7` selects bit 7 of Accumulator).

## 4. Instruction Set Reference

Operands often use specific notations: **A** (Accumulator), **Rr** (R0-R7), **direct** (RAM/SFR address), **@Ri** (Indirect via R0/R1), **#data** (Immediate value).

### Arithmetic Operations

- **ADD A, src:** Add source to A.

- **ADDC A, src:** Add with Carry (A + src + C).

- **SUBB A, src:** Subtract with Borrow (A - src - C).

- _Note:_ C must be cleared (`CLR C`) before starting subtraction.

- **INC dest / DEC dest:** Increment / Decrement operand.

- _Note:_ `INC DPTR` exists, but `DEC DPTR` does **not** exist.

- **MUL AB:** A \* B. Result: A=Low byte, B=High byte.

- **DIV AB:** A / B. Result: A=Quotient, B=Remainder.

- **DA A:** Decimal Adjust Accumulator (for BCD arithmetic).

### Logic Operations

- **ANL dest, src:** Bitwise AND.

- **ORL dest, src:** Bitwise OR.

- **XRL dest, src:** Bitwise XOR.

- **CLR A / CPL A:** Clear / Complement (Invert) Accumulator.

- **RL / RR:** Rotate A Left / Right.

- **RLC / RRC:** Rotate A Left / Right through Carry Flag.

- **SWAP A:** Swap nibbles of A.

### Data Transfer

- **MOV dest, src:** Copy data.

- Supported modes include: A to/from Register, Direct, Indirect, Immediate.
- `MOV DPTR, #data16`: Load 16-bit constant.

- **MOVX:** External RAM access.

- `MOVX A, @Ri` (8-bit address) or `MOVX A, @DPTR` (16-bit address).

- **MOVC:** Program Memory access (Code).
- `MOVC A, @A+DPTR` or `MOVC A, @A+PC` (Lookup tables).

- **PUSH / POP:** Stack operations.
- Only `direct` addressing allowed (e.g., `PUSH ACC`, `PUSH 0E0h`).

- `PUSH`: SP increments, then data stored.

- `POP`: Data retrieved, then SP decrements.

- **XCH A, src:** Exchange bytes.

- **XCHD A, @Ri:** Exchange lower nibbles only.

### Boolean (Bit) Operations

Operations on single bits (Carry C or direct bit):

- **CLR / SETB / CPL:** Clear / Set / Complement bit.

- **ANL C, bit / ORL C, bit:** Logical AND / OR between Carry and bit.

- **MOV C, bit / MOV bit, C:** Copy bit to/from Carry.

### Program Control (Jumps & Calls)

- **Unconditional Jumps:**
- `LJMP addr16` (Long, 64k scope).

- `AJMP addr11` (Absolute, 2k page scope).

- `SJMP rel` (Short, -128 to +127 relative).

- `JMP @A+DPTR` (Indirect jump).

- **Conditional Jumps:**
- `JZ / JNZ`: Jump if A is Zero / Not Zero.

- `JC / JNC`: Jump if Carry is Set / Not Set.

- `JB / JNB / JBC`: Jump if Bit Set / Not Set / Set then Clear.

- `CJNE dest, src, rel`: Compare and Jump if Not Equal.

- `DJNZ dest, rel`: Decrement and Jump if Not Zero (Looping).

- **Subroutines:**
- `LCALL addr16` (Long call).

- `ACALL addr11` (Absolute call).

- `RET`: Return from subroutine.

- `RETI`: Return from interrupt (restores interrupt logic).

- **NOP:** No Operation.

## 5. DSM-51 EPROM Subroutines (Reference)

The DSM-51 system provides built-in subroutines at specific addresses:

- **WRITE_TEXT (8100H):** Print text pointed to by DPTR (ends with 0).

- **WRITE_DATA (8102H):** Print char in A.

- **WRITE_HEX (8104H):** Print byte in A as hex.

- **LCD_INIT (8108H):** Initialize LCD.

- **LCD_CLR (810CH):** Clear LCD.

- **DELAY_MS (8110H):** Delay A \* 100ms (or A ms depending on slide context vs previous lecture).

- **WAIT_ENTER (8114H):** Wait for Enter key.

- **WAIT_KEY (811CH):** Wait for any key, return code in A.

- **GET_NUM (811EH):** Read 4-digit BCD number.
