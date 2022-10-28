`timescale 1ns / 1ps

module ALU_control(ALUop,funct,out);
    input wire[2:0] ALUop;
    input wire[5:0] funct;
    output wire[4:0] out;

    reg [4:0] controls;
    assign out = controls;
    always@*
        casex({ALUop,funct})
            9'b000xxxxxx : #5 controls <= 5'b00000; // Non arithmetic op
            9'b001xxxxxx : #5 controls <= 5'b00011; // shift left logical
            9'b010xxxxxx : #5 controls <= 5'b00111; // shift right logical
            9'b011xxxxxx : #5 controls <= 5'b01111; // shift right arithmetic
            9'b100xxxxxx : #5 controls <= 5'b01100; // complement immidiate
            9'b111000001 : #5 controls <= 5'b00000; // add rs,rt
            9'b111000010 : #5 controls <= 5'b01100; // comp rs,rt
            9'b111000011 : #5 controls <= 5'b00001; // and rs,rt
            9'b111000100 : #5 controls <= 5'b00010; // xor rs,rt
            9'b111000101 : #5 controls <= 5'b10000; // diff rs,rt
            9'b111000110 : #5 controls <= 5'b00011; // shllv rs,rt
            9'b111000111 : #5 controls <= 5'b00111; // shrl rs,rt
            9'b111001000 : #5 controls <= 5'b01111; // shrav rs,rt
            default: #5 controls <= 5'b00000; // any other op
        endcase

endmodule