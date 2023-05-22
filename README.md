TEAM LOOPHOLE
UWT Capstone Project.
## Intro 
  Phase locked loops are a control system that generates an output signal whose phase is related to the input signal. Historically PLL’s were analog components. The topology used a VCO, phase detector and feedback loop. By increasing and decreasing the voltage the system could modulate the clocks to obtain the desired output. 

  A digital alternating solves these problems by removing the large capacitors and Inductors and having a much broader range of operation. Furthermore, ADPLLs can be integrated on a single integrated circuit making them more compatible with modern electronic devices.

  Texas Instruments has tasked us with designing, simulating and emulating a digital PLL. This specification document is designed for those of a technical background with an emphasis on electrical and computer engineering. It describes the project requirements, system architecture, system design, project bill of materials, ethical considerations and references. The document's primary goal is to facilitate others to understand and implement the process we took in designing and testing an ADPLL.  
  

## Architecture and Design 
![alt text](https://github.com/Enanter/ADPLL/blob/main/pictures/ADPLLFINAL.jpg)
  Our ADPLL design has feed forward design, which is unique design for a PLL. It uses one-shot to trigger the ring oscillator. Even if the input frequency is disconnected, our ADPLL can generate outputs. 
  The design archtecture has 5 different modules written in systemverilog: Top level module, Ring Oscillator with one-shot trigger, Frequency Ratio, Target multiplier, Target Frequency, and Divider. Each modules may have sub-modules.
  
  ### Modules
  Top level module: connectes modules.
  Ring oscillator with one-shot trigger: when the input is high, the ring oscillator is on, so creates pseudo-phase lock. 
  Frequency Ratio: ratio of fast frequency over slow frequency. It measures 100 cycles of 100 slow frequency, so it measures more general frequency.
  (Target) Multiplier Controller, (Target) Frequency Controller: Main ALU to calculate how much the Divider needs to divide the Ring Oscillator frequency based on the Ratio output and the user control signal. This modules are made by continuous assignment. 
  Divider: divide the (ring oscillator) frequency by the calculated value (from Target Multiplier or Target Frequency).
  
  ### User inputs
  Control signal: Our design can generate 2 target frequency outputs at once. 16bits are for an output. So Control signal has 32bits. LSB 7bits of 16bits are for decimal target number , MSB 9bits of 16bits is for whole target number. It can be target multiplier control signal or target frequency control signal dependes on the select bit.
  Input Frequency: a input frequency. We assumed it is 1 bit (HIGH/LOW). We would not get information about this.
  Select Bit: select bit for the user needs the outputs are the input multiplied, or just target frequency regardless of the input.

  ### Simluation Result
  We tested each modules and the top level module. It worked perfect as we designed. We had to implement Number Divider module(long division) to divide numbers.
  ![alt text](https://github.com/Enanter/ADPLL/blob/main/pictures/divider%20some%20decimal%20for3_00.jpg)
  The Divider module generates 3 times faster than the input frequency(F_output). F_input is the Ring Oscillator frequency.
## Hardware Emulation
  We used Terasic Cyclone V GX FPGA and Tektronix MSO 2024 Oscilloscope. Due to physical limitaion(propagation delay), the phase is not always matching.
  ![alt text](https://github.com/Enanter/ADPLL/blob/main/pictures/targetF.png)
  A 99 Kilohertz input being multiplied by a factor of 11. resulting in a period of 955.4 ns, or 1.046 Mhz 
  ![alt text](https://github.com/Enanter/ADPLL/blob/main/pictures/targetM.png)
  We targeted 2.1 Mhz, and were able to generate a clock with a frequency of 2.24 Mhz
  ### Sponsor Feedback
  Our sponsor said "This indicates the team has successfully implemented a fully digital frequency multiplication function that is traditionally performed using an Analog PLL in about 12% of the area, or an 86% savings in silicon real estate." But the limitaion is "A pseudo-phase lock is achieved by periodically resetting the ring oscillator used in the design to re-synchronize it to the input clock. While never truly locked as a function of the architecture, their approach allows a reasonable approximation with an expected phase lag of roughly 20 ps – 40 ps in a 65 nm CMOS process."


