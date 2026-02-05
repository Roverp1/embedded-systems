# Lecture 3: 8051 Hardware Structure & Operation

## 1. Clock and Timing

The 8051 microcontroller requires a clock source to operate.

- **Oscillator:** It features an internal oscillator that generates system clock signals. It typically uses an external quartz crystal connected to pins XTAL1 and XTAL2, along with two capacitors (typically 30pF) to stabilize the frequency.
- **Machine Cycle:** The fundamental unit of CPU operation.
- One machine cycle consists of **12 oscillator periods**.
- This is divided into 6 states (S1-S6), with 2 phases per state.
- **ALE (Address Latch Enable):** This signal is generated twice per machine cycle (S1P2 and S4P2). It allows external latching of the low byte of the address during external memory access.

## 2. Reset Sequence

A reset initializes the microcontroller to a known state.

- **Mechanism:** A high level (logic "1") on the **RST** pin for at least **2 machine cycles** triggers a reset.
- **Power-On Reset:** The external reset circuit usually consists of a capacitor (e.g., 10µF) connected to VCC and a resistor (e.g., 8.2kΩ) to GND. This ensures the RST pin stays high long enough for the oscillator to stabilize and the internal reset to complete upon power-up.
- **Register States after Reset:**
- **PC (Program Counter):** `0000H` (Execution starts at address 0).
- **SP (Stack Pointer):** `07H`.
- **PSW:** `00H`.
- **Ports (P0-P3):** `FFH` (All pins set to high/input mode).
- **Internal RAM:** The content is indeterminate (random) after power-up.

## 3. I/O Ports Structure

The 8051 has four I/O ports (P0, P1, P2, P3). Their internal structures differ slightly based on their dual functions (I/O vs. Bus/Control).

### Port 0 (P0)

- **Structure:** It has an input buffer and two output FETs. It functions as a multiplexed Address/Data bus (AD0-AD7) during external memory access.
- **I/O Mode:** It is a true **open-drain** port. To use it as a general-purpose I/O output driving a high logic level, external pull-up resistors are required.
- **Writing 1:** Turns off the pull-down FET, leaving the pin floating (high impedance) unless an external pull-up is present.

### Port 1 (P1)

- **Structure:** Designed purely for general-purpose I/O.
- **Internal Pull-up:** It has an internal pull-up resistor (FET load), making it a **quasi-bidirectional** port.
- **Writing 1:** Connects the pin to VCC through the internal pull-up. It can be pulled low externally to be read as an input.

### Port 2 (P2)

- **Structure:** Similar to Port 1 but includes logic for emitting the High Address Byte (A8-A15) during external memory access.
- **Internal Pull-up:** Yes, it has internal pull-ups.

### Port 3 (P3)

- **Structure:** Similar to Port 1 but with "Alternative Function" logic.
- **Internal Pull-up:** Yes.
- **Alternate Functions:** Pins on P3 have specific specialized roles:
- **P3.0:** RXD (Serial Input).
- **P3.1:** TXD (Serial Output).
- **P3.2:** INT0 (External Interrupt 0).
- **P3.3:** INT1 (External Interrupt 1).
- **P3.4:** T0 (Timer 0 Input).
- **P3.5:** T1 (Timer 1 Input).
- **P3.6:** WR (External Memory Write Strobe).
- **P3.7:** RD (External Memory Read Strobe).

## 4. Port Operations

### Writing to Ports

- Instructions like `MOV P1, A` write data to the port latch.
- Writing a **0** turns on the internal FET, pulling the pin to ground (Strong Low).
- Writing a **1** turns off the strong pull-down FET. The pin is pulled high by the internal weak pull-up (for P1, P2, P3), allowing it to function as an input or output high.

### Reading Ports

There are two distinct ways to "read" a port:

1. **Reading the Pin:** Instructions like `MOV A, P1` read the actual voltage level at the physical pin. If the latch is 1 (weak high), an external device can pull the pin low, and the CPU will read a 0.
2. **Reading the Latch (Read-Modify-Write):** Certain instructions read the value stored in the output latch, modify it, and write it back. They do _not_ read the external pin state. This prevents misinterpretation of voltage levels (e.g., if a pin driving a base of a transistor is pulled down to 0.7V, reading the pin might see 0, but reading the latch correctly sees 1).

- **RMW Instructions:** `ANL`, `ORL`, `XRL`, `JBC`, `CPL`, `INC`, `DEC`, `DJNZ`, `MOV Px.y, C`, `CLR Px.y`, `SETB Px.y`.

### Electrical Characteristics

- **Sink Current (Output Low):** Ports can sink relatively high current (e.g., **1.6 mA** at 0.45V for standard TTL loads). This is generally sufficient to drive an LED (connected to VCC) or standard logic gates (LS TTL).
- **Source Current (Output High):** Ports (P1, P2, P3) can source very little current (microamps) because of the weak internal pull-up. It is usually insufficient to drive an LED connected to GND.
- **P0 Note:** As an open-drain port, P0 cannot source _any_ current in I/O mode unless external pull-ups are added.

## 5. Power Saving Modes

The 8051 (CMOS versions) includes power reduction modes controlled by the **PCON** register (Address 87H).

### Idle Mode

- **Activation:** Set bit **IDL** (PCON.0) to 1.
- **Effect:** The clock signal to the CPU is gated off. The CPU stops executing instructions. However, the **interrupt system, serial port, and timers continue to function**.
- **Wake-up:**
- Hardware Reset.
- Any enabled Interrupt.

- **State:** Internal RAM and registers are preserved.

### Power Down Mode

- **Activation:** Set bit **PD** (PCON.1) to 1.
- **Effect:** The on-chip **oscillator is stopped**. All functions (CPU, timers, serial) cease operation. This offers the lowest power consumption.
- **Wake-up:**
- Hardware Reset ONLY (in standard 8051).

- **State:** Internal RAM and SFRs retain their values (as long as VCC is maintained, typically down to 2V).

## 6. Bus Structure

- **Non-multiplexed:** Address and Data lines are separate.
- **Multiplexed (8051 style):**
- **Low Address / Data:** The lower byte of the address (A0-A7) and the Data byte (D0-D7) share the same lines (Port 0).
- **Separation:** The **ALE** signal is used to latch the address byte into an external latch (e.g., 74HC373) at the beginning of a cycle so the lines can subsequently carry data.
- **High Address:** The upper address byte (A8-A15) is output on Port 2.
