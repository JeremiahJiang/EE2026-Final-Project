`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2021 22:13:31
// Design Name: 
// Module Name: clk_for_death
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


module clk_for_death(
    input CLOCK,
    output reg blink = 0
    );
    reg[40:0]SETCOUNT = 25000000;
    wire freq2hz;
    adj_clk_module fa0(CLOCK,SETCOUNT,freq2hz);
    always @ (posedge freq2hz)begin
        blink = ~blink;
    end
endmodule
