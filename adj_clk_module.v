`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2021 14:02:14
// Design Name: 
// Module Name: adj_clk_module
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


module adj_clk_module(input CLOCK,
input[40:0] SET_COUNT, //number of bits must change accordingly.
output reg set_freq=0

    );
    
    
    reg[40:0] COUNT =0;
    always @(posedge CLOCK) begin
    
    COUNT = COUNT + 1;
    set_freq <= (COUNT == SET_COUNT) ? ~set_freq: set_freq;
    COUNT = (COUNT == SET_COUNT) ? 0:COUNT; 
    end
    
endmodule
