`timescale 1ns / 1ps

module instruction_memory(clk,address_in, instruction_out);
    input wire clk;
    input wire[9:0] address_in;
    output wire[31:0] instruction_out;

<<<<<<< HEAD:KGPMini RISC Processor/instruction_mem.v
    reg[31:0] register[1024:0];
    reg[31:0] buffer;

    initial begin
        $readmemb("assembler/memory.txt", register, 0);
    end

    always@(posedge clk)
    begin
        buffer <= register[address_in];
    end

    assign instruction_out = buffer;
    // assign instruction_out = register[address_in];
=======
brom instructionMemory (
  .clka(clk), // input clka
  .addra(address_in), // input [9 : 0] addra
  .douta(instruction_out) // output [31 : 0] douta
);
>>>>>>> 6d10a3e41f2c3288dac31e8393b84b6678c682d2:instruction_mem.v

endmodule
