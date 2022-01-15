`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2021 14:04:30
// Design Name: 
// Module Name: single_pulse_debounce
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


module single_pulse_debounce(
input PUSHBUTTON,
input CLOCK,
output single_pulse

    );
    
        
        reg [30:0]SET_COUNT=16666666;
        wire f3_0;
        wire Q_device1;
        wire Q_device2;
        
        adj_clk_module dev1(CLOCK,SET_COUNT,f3_0);
        d_flipflop dev2(f3_0,PUSHBUTTON,Q_device1);
        d_flipflop dev3(f3_0,Q_device1,Q_device2);
        
        assign single_pulse = (Q_device1 & ~Q_device2);
endmodule
