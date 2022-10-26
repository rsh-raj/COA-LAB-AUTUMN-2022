`timescale 1ns / 1ps

module jump_control(condition, flags, out);
    input wire[2:0] condition, flags;
    output wire out;

    // flags = {carry,zero,sign}

    reg controls;
    assign out = controls;

    always@*
        casex({condition, flags})
            6'b000xxx : #5 controls <= 1'b0; // non branch op
            6'b001xx1 : #5 controls <= 1'b1; // bltz rs,L
            6'b010x1x : #5 controls <= 1'b1; // bz rs,L
            6'b011x0x : #5 controls <= 1'b1; // bnz rs,L
            6'b1001xx : #5 controls <= 1'b1; // bcy L
            6'b1010xx : #5 controls <= 1'b1; // bncy L
            default: #5 controls <= 1'b0;    // any other op
        endcase

endmodule