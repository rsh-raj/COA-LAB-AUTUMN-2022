`timescale 1ns / 1ps
// regfile worlking fine

module data_memory(address_in, data_out, write_data, MemWrite, MemRead, clk);
    
    input wire[31:0] address_in, write_data;
    output wire[31:0] data_out;
    input wire MemWrite, MemRead, clk;
    reg[31:0] buffer;
    reg[31:0] register[1024:0];

    // initial begin
    //     $readmemh("memory.txt", register, 0);
    // end

    always@(posedge clk or posedge MemRead)
    begin
        
        if(MemWrite)
            begin
                register[address_in] = write_data;
            end

        // else
        //     begin
        //         if(MemRead)
        //             begin 
        //                 buffer = register[address_in];
        //             end
        //         else
        //             begin
        //                 buffer = 32'b0;
        //             end
        //     end
    end

    assign data_out = MemRead ? register[address_in] : 32'b0;
endmodule

// Do not use assign statement inside of an always block, can only be done for reg type variable, not for wire type variable

// For reading an input, the write signal and the reset signal must be off

// reset is not really needed