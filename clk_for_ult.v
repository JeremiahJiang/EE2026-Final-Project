`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2021 20:52:57
// Design Name: 
// Module Name: clk_for_ult
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clk_for_ult(
    input CLOCK,
    output reg blink = 0
    );
    reg[40:0]SETCOUNT = 50000000;
    wire freq1hz;
    adj_clk_module fa0(CLOCK,SETCOUNT,freq1hz);
    always @ (posedge freq1hz)begin
        blink = ~blink;
    end
endmodule
