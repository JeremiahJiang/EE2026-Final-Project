`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2021 14:07:53
// Design Name: 
// Module Name: main
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


module main(
    input CLOCK,
    input [15:0]sw,
    input CTRBUTTON,
    input LBUTTON,
    input RBUTTON,
    input UPBUTTON,
    input DOWNBUTTON,
    input  J_MIC3_Pin3,
    output J_MIC3_Pin1,
    output J_MIC3_Pin4, 
    output [7:0]JA,    
    output [15:0]led,
    output [6:0] seg,
    output [3:0] an,
    output dp

    );


    wire bulletstate;
    wire csjiang;
    wire [11:0]sample;
    wire [15:0] secondary_led;
    wire normal_pew;
    wire big_pew;
    wire blink_ult; 
    wire blink_death;  
    wire win; 
    reg [30:0] SETCOUNT_20khz = 2500;
    wire game_over;
    adj_clk_module fa0(CLOCK, SETCOUNT_20khz, csjiang);
    Audio_Capture fa1(CLOCK, csjiang,J_MIC3_Pin3,J_MIC3_Pin1,J_MIC3_Pin4, sample[11:0]);
    //seg_disp fa2(CLOCK, sw[1],sample[11:0], secondary_led[15:0],an[3:0], seg[6:0], dp,normal_pew,big_pew);
    clk_for_ult fa3(CLOCK, blink_ult); 
    clk_for_death fa4(CLOCK, blink_death); 
    seg_disp_save fa2(CLOCK, sw[1],sw[7],sample[11:0], bulletstate,blink_ult,blink_death,game_over,win,hp[1:0],kill_count[2:0], secondary_led[15:0],an[3:0], seg[6:0], dp,normal_pew,big_pew);
    assign led[15:0] = (sw[0]==1)?secondary_led[15:0]: sample[11:0];

    reg [5:0] SET_COUNT = 8;
    
    wire clk;
    wire reset;
    wire frame_begin; 
    wire sending_pixels; 
    wire sample_pixel; 
    wire [12:0]pixel_index; 
    wire teststate;
    
    wire cs ;
    wire sdin;
    wire sclk;
    wire d_cn;
    wire resn;
    wire vccen;
    wire pmoden;

    wire [10:0]backofbullet;
    wire [10:0]frontofbullet;
    wire [15:0]pixel_data;
    
    wire [1:0] hp;
    wire [2:0] kill_count;    
 
    adj_clk_module dev1(CLOCK, SET_COUNT, clk);
    single_pulse_debounce dev2(DOWNBUTTON,CLOCK,reset);

    Oled_Display dev3(clk, reset, frame_begin, sending_pixels, sample_pixel, pixel_index, pixel_data, cs, sdin, sclk, d_cn, resn, vccen,
    pmoden,teststate);
      
    assign JA[0]= cs;
    assign JA[1] =sdin;
    assign JA[3] =sclk;
    assign JA[4] = d_cn;
    assign JA[5] = resn;
    assign JA[6] = vccen;
    assign JA[7]= pmoden;
       
    iron_man_oled_2 dev4(clk,sw[15:0],secondary_led[15:0],normal_pew,big_pew,pixel_index[12:0],UPBUTTON,CTRBUTTON,LBUTTON,RBUTTON,reset,hp[1:0],bulletstate,kill_count[2:0],game_over,win,pixel_data[15:0]);

endmodule
