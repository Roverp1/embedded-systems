# Lecture 5: Applications, History & Architecture of Embedded Systems

## 1. Types of Computer Systems

The lecture classifies modern computer systems into three main categories:

1. **Personal Systems:** Designed for individual use on PCs or workstations (e.g., word processors, graphic systems, spreadsheets).
2. **Embedded Systems:** Operate on a single processor or a group of processors. They are dedicated to a specific function or a small set of functions, often forming part of a larger system (e.g., Real-Time Systems - RTS).
3. **Distributed Systems:** System software runs on a loosely integrated group of cooperating processors connected by a network (e.g., ATM networks, reservation systems).

- _Future Trend:_ The differences between these systems are expected to blur and potentially disappear.

## 2. Structure & Characteristics of Embedded Systems

### Typical Structure

- **Inputs:** Input circuits (signal registration, data acquisition), Digital inputs (sensors, counters), Analog inputs (comparators, A/D converters), Communication ports.
- **Processing:** Central Unit (Control Algorithm).
- **Outputs:** Output circuits (control), D/A converters, PWM (Pulse-Width Modulation), Digital control outputs, Communication ports, Actuators (motors, relays).

### Key Features

- **High Integration:** Small size, limited resources (I/O, memory, simple displays, often no GUI).
- **Reliability:** Must be failure-free.
- **Real-Time Response:** Critical for control systems.
- **Durability & Robustness:** Mechanical resistance, operation in harsh environments.
- **Low Power Consumption.**
- **Maintenance-Free:** Unsupervised operation.

### Applications

- **Consumer Electronics:** PDAs, mobile phones, cameras, appliances (washing machines, fridges).
- **Automotive:** ABS, engine control.
- **Industrial:** Process automation, robotics, measurement systems.
- **Infrastructure:** Traffic control, telecommunications.
- **Medical:** Tomographs, pacemakers, insulin pumps, artificial hearts.
- **Aerospace/Military:** Drones, satellites, missiles, space stations.
- **HPEC (High-Performance Embedded Computing):** Modular computers for processing signals/images in harsh environments (mostly military).

## 3. History of Embedded Systems

- **Apollo Guidance Computer (1966):** Considered one of the first embedded systems.
- Specs: 2 MHz, 15-bit word + parity, 2KB RAM, 36KB ROM.
- Physical: 32 kg, 55W power.
- _Incident:_ During Apollo 11 landing, Error 1202 (memory overload due to radar data) occurred. Steve Bales (NASA) correctly decided it was safe to proceed.

- **Minuteman I Missile (D17-B):** First widely produced embedded system. Used discrete components (1500 transistors, 6000 diodes).
- **Polish Contribution (1984-87):** A temperature monitoring system for refrigerated ships (Gdansk Shipyard) designed by Lodz University of Technology (8051-based).
- **Traffic Control (Poznań):** Implementation of integrated traffic control on Grunwaldzka street (2005).

## 4. The Design Process

### Workflow

1. **Specifications:** Defining requirements, goals, and limits.
2. **Architecture:** Planning structure and component interactions.
3. **Detailed Design:** Hardware selection, schematic creation, algorithm design.
4. **Implementation:** Hardware assembly and coding.
5. **Testing:** Bug fixing and functional verification.
6. **Deployment:** Installation and support.

### Optimization Goals

A well-designed system minimizes:

- Hardware resources.
- Software complexity.
- Size and Weight.
- Power consumption.
- Cost (prototype vs. mass production).

### Hardware Platforms

- **Development Kits:** For prototyping (easy I/O access, JTAG).
- **Industrial Standards:**
- **PC/104:** Stackable modules for industrial computers.
- **CompactPCI:** Industrial version of the PCI bus.
- **SOM (System on Module):** Small modules, often passively cooled.
- **SoC (System on Chip):** Complete system on a single integrated circuit (CPU + Peripherals + Radio + Analog). Example: **DaVinci DM355** (ARM9 CPU + Video Coprocessor + Peripherals).

## 5. History of Computing

### Pre-Electronic Era

- **Abacus (3000 BC):** First calculation tool.
- **Mechanical Calculators (17th Century):**
- **Wilhelm Schickard:** First mechanical calculator.
- **Blaise Pascal:** "Pascaline" (Adding machine).
- **Gottfried Wilhelm Leibniz:** Calculator for 4 operations + square root; introduced **Binary System**.

- **Logarithmic Slide Rules:** Based on Napier's Bones (1650).
- **Jacquard Loom (1801):** First use of **punched cards** for program control (weaving patterns).
- **Charles Babbage (1822):**
- **Difference Engine:** For differential equations.
- **Analytical Engine:** Revolutionary concept of a programmable general-purpose computer (never built in his time, but inspired Von Neumann).

- **Herman Hollerith (19th Century):** Tabulating machine for US Census using punched cards. Founded the company that became **IBM**.
- **Electromechanical:**
- **Konrad Zuse (Germany):** Z1, Z2, Z3, Z4.
- **Mark I (USA, 1944):** Electromechanical, 10-digit multiplication in 10s.

### Electronic Era (Generations)

1. **1st Generation (1943-1957): Vacuum Tubes.**

- **ENIAC (1943-45):** First general-purpose electronic computer. 18k tubes, 30 tons, programmed by rewiring cables. Mean time between failures: ~30 mins.
- **Von Neumann Architecture (EDVAC):** Introduced the concept of **stored program** (program and data in same memory) and the ALU.

2. **2nd Generation (1958-1975): Transistors.**

- IBM 1401, CDC 6600 (First Supercomputer, Seymour Cray).
- Introduction of assembly and high-level languages.

3. **3rd Generation (1976-1989): Integrated Circuits (IC).**

- IBM 360, DEC PDP-8 (First Minicomputer).

4. **4th Generation (1990+): VLSI / CMOS.**

- Personal Computers, Microprocessors.

5. **Future:** Optical, Neural, Quantum computers.

### Polish Computing History

- **XYZ (1958):** First Polish digital computer (Warsaw).
- **ZAM-2:** Production version of XYZ.
- **Odra 1204:** Notable Polish transistor-based computer.

### Processor History

- **1947:** Invention of Transistor (Bell Labs: Shockley, Bardeen, Brattain).
- **1958:** First Integrated Circuit (Jack Kilby, TI).
- **1971:** **Intel 4004** - First 4-bit Microprocessor (designed by Faggin).
- **1972:** Intel 8008 (8-bit).
- **1974:** Intel 8080.
- **1978:** Intel 8086 (16-bit).

## 6. Computer Architecture Concepts

### Levels of Abstraction

1. **Architecture:** User's view (Instruction set, registers).
2. **Implementation:** Structure (ALU, Buses).
3. **Realization:** Physical components.

### Definitions

- **Processor (CPU):** Digital unit that fetches, interprets, and executes instructions.
- **Microprocessor:** CPU on a single VLSI chip (e.g., x86).
- **Microcontroller:** CPU + Memory + Peripherals on one chip (for control).
- **ALU:** Arithmetic Logic Unit (Add, Logic, Shifts). Outputs Flags (Zero, Carry, Overflow).

### Buses

- **Address Bus:** Carries memory addresses (Unidirectional).
- **Data Bus:** Carries data (Bidirectional).
- **Control Bus:** Control signals (Read/Write, Interrupts).
- **FSB (Front Side Bus):** Connects CPU to main memory/peripherals.
- **BSB (Back Side Bus):** Connects CPU to Cache.

### Architectures

1. **Von Neumann:**

- **Unified Memory:** Data and Instructions share the same memory space and buses.
- Cannot fetch code and data simultaneously.
- Used in general-purpose PCs.

2. **Harvard:**

- **Separate Memory:** Distinct memories and buses for Program (Code) and Data.
- Allows simultaneous fetch of instruction and data (faster).
- Common in DSPs and Microcontrollers (like 8051).

### Instruction Sets

1. **CISC (Complex Instruction Set Computer):**

- Many complex instructions, multiple addressing modes.
- Slower clock, complex decoder.
- Ex: x86, 68000.

2. **RISC (Reduced Instruction Set Computer):**

- Few simple instructions, few addressing modes.
- Load/Store architecture.
- Pipelining allows 1 cycle per instruction.
- Ex: ARM, MIPS, AVR, PowerPC.
- _Note:_ Modern Intel CPUs are CISC externally but translate instructions to RISC micro-ops internally.

### Performance Metrics

- **MIPS:** Million Instructions Per Second.
- **FLOPS:** Floating Point Operations Per Second (Mega, Giga, Tera, Peta).
- **Prefixes:**
- Physics (decimal): Kilo (), Mega ().
- Computing (binary): Kilo (), Mega ().

### Binary System

Used in electronics because:

- Easy electrical implementation (Transistor ON/OFF).
- High noise immunity (Voltage levels for 0 and 1 are distinct, e.g., +5V vs -5V or 0V vs 3.3V).
- Maps logic (True/False) to arithmetic.
- _Trivia:_ The **Setun** (USSR, 1959) was a **ternary** (base-3) computer using magnetic cores.
