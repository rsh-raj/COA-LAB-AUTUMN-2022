`timescale 1ns / 1ps

module control_unit(
    input wire[5:0] opcode,
    input wire reset,
    output wire DataPCSel, RegSelect, RegWrite, MemRead, MemWrite, MemtoReg, AdSel, unconditional, halt,
    output wire[2:0] conditional, ALUop,
    output wire[1:0] ALUinSel
);

    reg [16:0] controls;
    assign {DataPCSel, RegSelect, ALUinSel, RegWrite, MemRead, MemWrite, MemtoReg, AdSel, unconditional, conditional, ALUop, halt} = controls;

    always@(posedge reset)
    begin
        controls <= 17'b0;
    end
    
    always@*
        case(opcode)
            6'b000000 : #5 controls <= 17'b00001001000001110;  // opcode 0, which means all the r type instructions which have funct in them
            6'b000001 : #5 controls <= 17'b00101001000000000;  // addi rs,imm
            6'b000010 : #5 controls <= 17'b00101001000001000;  // compi rs,imm
            6'b000011 : #5 controls <= 17'b00101001000000010;  // shll rs,sh
            6'b000100 : #5 controls <= 17'b00101001000000100;  // shrl rs,sh
            6'b000101 : #5 controls <= 17'b00101001000000110;  // shra rs,sh
            6'b000110 : #5 controls <= 17'b00101100000000000;  // lw
            6'b000111 : #5 controls <= 17'b00100010000000000;  // sw
            6'b001000 : #5 controls <= 17'b00010000000010000;  // bltz rs,L
            6'b001001 : #5 controls <= 17'b00010000000100000;  // bz rs,L
            6'b001010 : #5 controls <= 17'b00010000000110000;  // bnz rs,L
            6'b001011 : #5 controls <= 17'b00010000110000000;  // br rs
            6'b001100 : #5 controls <= 17'b00000000010000000;  // b L
            6'b001101 : #5 controls <= 17'b00000000001000000;  // bcy L
            6'b001110 : #5 controls <= 17'b00000000001010000;  // bncy L
            6'b001111 : #5 controls <= 17'b11001000010000000;  // bl L
            6'b111111 : #5 controls <= 17'b00000000000000001;  // halt
            6'b111110 : #5 controls <= 17'b00000000000000000;  // NOP instruction
            default: #5 controls <= 17'b0;                     // illegal op
        endcase
  
 
endmodule