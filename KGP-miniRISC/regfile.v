`timescale 1ns / 1ps
// regfile worlking fine

module regfile(readReg1, readReg2, writeReg, data1, data2, clk, writeData, RegWrite, reset);
    input wire[4:0] readReg1, readReg2, writeReg;
    output wire[31:0] data1, data2;
    input wire[31:0] writeData;
    input wire RegWrite, clk, reset;    // Control Signal for writing on the write register

    reg[31:0][31:0] register;
    assign data1 = register[readReg1];
    assign data2 = register[readReg2];

    always@(posedge clk or posedge reset)
    begin
        if(reset)
            begin
                register[31:0] <= 32'b0;
            end

        if(RegWrite)
            begin
                register[writeReg] = writeData;
            end
    end

endmodule