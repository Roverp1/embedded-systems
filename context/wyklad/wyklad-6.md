# Lecture 6: Processor Operation & Data Representation

## 1. Program Execution Cycle

The fundamental operation of a processor involves fetching and executing instructions from memory.

### Basic Cycle

1. **Initialization:** Starts with a **RESET** signal, which loads the initial address into the **Program Counter (PC)**.
2. **Fetch:** The processor retrieves the instruction from the address pointed to by the PC.
3. **Execute:** The instruction is decoded and performed (e.g., arithmetic operation, data move).
4. **Update PC:** The PC is automatically incremented to point to the next instruction.
5. **Control Flow:** Jump/Branch instructions modify the PC directly to change the execution path.

### Execution Modes

- **Non-Critical Tasks:** Run in the main infinite loop.
- **Critical Tasks:** Handled via **Interrupts** or specific "Stop" instructions.

## 2. Processor Components & Data Handling

- **Registers:** Fast, temporary storage within the processor for performing arithmetic and logic operations.
- **PAO (Operational Memory):** Stores larger sets of data.
- **Flags (Status Register):** Indicators set by the ALU after operations (e.g., Zero, Carry, Overflow).

## 3. Interrupts (Przerwania)

An interrupt is a mechanism that halts the main program to execute a high-priority specific routine (Interrupt Service Routine - ISR).

### Characteristics

- **Asynchronous:** Can occur at any time, independent of the main program flow.
- **Context Saving:** The processor must save the address of the next instruction (PC) and the status flags on the **Stack** before jumping to the ISR.
- **Restoration:** Upon completion (`RETI`), the processor pops the saved context from the stack and resumes the main program exactly where it left off.

### Interrupt Sources (8051 Example)

- **External:** Triggered by external pins (e.g., INT0, INT1).
- **Internal:** Triggered by on-chip peripherals (e.g., Timer Overflow, Serial Port data ready).

## 4. Numerical Representation

### Fixed-Point Arithmetic (Stałoprzecinkowa)

- **Definition:** The decimal point is in a fixed position. The programmer must mentally track its location; the processor treats the number as an integer.
- **Unsigned Integers:** range to .
- **Signed Integers (U2 / Two's Complement):**
- **MSB (Most Significant Bit):** Sign bit (0=Positive, 1=Negative).
- **Range:** to .

- **Fractional Numbers (Q Format):**
- **Qm.n:** bits for integer, bits for fraction.
- **U2 Q(n):** Signed fraction where the bit weight is . Range is typically .

### Floating-Point Arithmetic (Zmiennoprzecinkowa)

Based on the IEEE-754 standard, allowing a wide dynamic range.

- **Format:**
- **S (Sign):** 1 bit.
- **M (Mantissa):** Fractional part (normalized).
- **B (Base):** Usually 2.
- **E (Exponent):** Integer power (biased).

#### IEEE-754 Single Precision (32-bit / float)

- **Sign:** 1 bit.
- **Exponent:** 8 bits (Bias +127).
- **Mantissa:** 23 bits (plus implicit leading 1).
- **Range:** to .
- **Precision:** ~7 decimal digits.

#### IEEE-754 Double Precision (64-bit / double)

- **Sign:** 1 bit.
- **Exponent:** 11 bits (Bias +1023).
- **Mantissa:** 52 bits.
- **Range:** to .
- **Precision:** ~15 decimal digits.

### Special Values in IEEE-754

- **Zero:** Exponent = 0, Mantissa = 0.
- **Infinity ():** Exponent = All 1s, Mantissa = 0.
- **NaN (Not a Number):** Exponent = All 1s, Mantissa 0 (Result of invalid operations like or ).
- **Denormalized Numbers:** Exponent = 0, Mantissa 0. Allows representation of numbers smaller than the smallest normalized number, filling the gap near zero ("Zero Maszynowe").

## 5. Endianness (Byte Ordering)

When storing multi-byte data (e.g., 32-bit integers) in memory:

- **Big Endian:** The **most** significant byte (MSB) is stored at the **lowest** memory address. (Used by Motorola 68k, SPARC, Internet protocols).
- **Little Endian:** The **least** significant byte (LSB) is stored at the **lowest** memory address. (Used by Intel x86, 8051).
