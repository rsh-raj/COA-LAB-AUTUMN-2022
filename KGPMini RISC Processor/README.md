# KGPMini RISC Processor
Problem Statement: [KGPMini RISC Processor](Problem_Statement_ISA22.pdf) </br>
Instruction Set Encoding & Datapath: [Instruction Set Encoding & Datapath](isa_encoding.pdf)
# Steps to run

1. Clone the repository
2. Run the following commands to generate the .coe file of your assembly code
        cd assembler
        make file="your_filename"
        cd ..
3. Open the project in Xilinx ISE
4. Load the .coe file in the instruction memory
5. Generate Bit stream and dump on avalable FPGA
