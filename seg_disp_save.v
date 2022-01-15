`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2021 14:41:19
// Design Name: 
// Module Name: segment_disp
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


module seg_disp_save(
    input CLOCK,
    input sw1,sw7,
    input [11:0]sample,
    input bulletstate,
    input blink_ult,
    input blink_death,
    input game_over,
    input win,
    input [1:0] hp,
    input [2:0]kill_count,
    output reg [15:0]led = 0,
    output reg [3:0]an = 0, output reg [7:0]seg = 0, output reg dp = 1,
    output reg normal_pew = 0, output reg big_pew = 0
    );
    wire freq30hz;
    wire freqfast;
    reg [11:0] temp = 0;
    reg [15:0] volume = 0;
    reg [30:0] SETCOUNT_30 = 1666666;//1666666
    reg [30:0] SETCOUNT_fast = 50000;
    reg [30:0] count_kill_flicker = 0;
    reg [30:0] countflicker = 0;
    reg[11:0]first = 2075; reg[11:0]second = 2190; reg[11:0]third = 2310; reg[11:0]fourth = 2430; reg[11:0]fifth = 2550;
    reg[11:0]sixth = 2670; reg[11:0]seventh = 2790; reg[11:0]eighth = 2910; reg[11:0]ninth = 3030; reg[11:0]tenth = 3150;
    reg[11:0]eleventh = 3270; reg[11:0]twelfth = 3390; reg[11:0]thirteenth = 3510; reg[11:0] fourteenth= 3630;
    reg[11:0]fifteenth = 3750;reg [11:0]sixteenth = 3870;
    integer count = 0;
    integer countfast = 0;
    parameter [6:0] empty = 7'b1111111;
    parameter [6:0] zero = 7'b1000000;
    parameter [6:0] one = 7'b1001111;
    parameter [6:0] two = 7'b0100100;
    parameter [6:0] three = 7'b0110000;
    parameter [6:0] four = 7'b0011001;
    parameter [6:0] five = 7'b0010010;
    parameter [6:0] six = 7'b0000010;
    parameter [6:0] seven = 7'b1111000;
    parameter [6:0] eight = 7'b0000000;
    parameter [6:0] nine = 7'b0010000;
    parameter [6:0] low = 7'b1000111;
    parameter [6:0] med = 7'b1101010;
    parameter [6:0] high = 7'b0001001;
    
    adj_clk_module fa1(CLOCK, SETCOUNT_30, freq30hz);
    adj_clk_module fa2(CLOCK, SETCOUNT_fast, freqfast);
    always @ (posedge freq30hz) begin
        count = count + 1;
        if (temp < sample)begin
            temp = sample;
        end
        if (count == 10) begin
            count = 0;
            led[0]  = (temp >= first)?1:0; 
            led[1]  = (temp >= second)?1:0; 
            led[2]  = (temp >= third)?1:0;
            led[3]  = (temp >= fourth)?1:0;
            led[4]  = (temp >= fifth)?1:0;
            led[5]  = (temp >= sixth)?1:0;
            led[6]  = (temp >= seventh)?1:0;
            led[7]  = (temp >= eighth)?1:0;            
            led[8]  = (temp >= ninth)?1:0;
            led[9]  = (temp >= tenth)?1:0;
            led[10] = (temp >= eleventh)?1:0;
            led[11] = (temp >= twelfth)?1:0;
            led[12] = (temp >= thirteenth)?1:0;
            led[13] = (temp >= fourteenth)?1:0;
            led[14] = (temp >= fifteenth)?1:0;
            led[15] = (temp >= sixteenth)?1:0; 
            temp = 0;
       end
    end  
    always @(posedge freqfast) begin    
        countfast = countfast + 1;
        case(countfast)
            1:begin
                if (sw7 == 1)begin
                    an[3:0] = 4'b0111;
                    if (game_over == 1)begin
                        seg[6:0] = blink_death?low:empty;
                    end
                    else if(win == 1)begin
                        seg[6:0] = blink_death?7'b0010001: empty;
                    end
                    else begin
                        case(hp)
                            2'b00:begin
                                seg[6:0] = blink_death ? zero:empty;//0hp
                            end
                            2'b01:begin
                                seg[6:0] = 7'b1110111;//1hp
                                
                            end
                            2'b10:begin
                                seg[6:0] = 7'b0110111;//2hp
                            end
                            2'b11:begin
                                seg[6:0] = 7'b0110110;//3hp
                            end
                        endcase
                    end
                end
                else begin
                    an[3:0] = 4'b1111; seg[6:0] = zero;
                end
            end
            2:begin
                if (sw7 == 1)begin
                    an[3:0] = 5'b1011;
                    if (game_over == 1)begin
                        seg[6:0] = blink_death?zero:empty;
                    end
                    else if(win == 1)begin
                        seg[6:0] = blink_death?7'b0001000:empty;
                    end
                    else begin
                        case(kill_count) // change to kill count
                            3'b000:begin
                                seg[6:0] = zero;
                            end
                            3'b001:begin
                                seg[6:0] = one;
                            end
                            3'b010:begin
                                seg[6:0] = two;
                            end
                            3'b011:begin
                                seg[6:0] = three;
                            end
                            3'b100:begin
                                seg[6:0] = four;
                            end
                            3'b101:begin
                                seg[6:0] = blink_ult?five:empty;
                            end
                        endcase
                    end
                end
                else begin
                    an[3:0] = 4'b1111; seg[6:0] = zero;
                end
            end
            3:begin
                if (sw7 == 1)begin
                    an[3:0] = 4'b1101; 
                    if (game_over == 1)begin
                        seg[6:0] = blink_death?five:empty;
                    end
                    else if(win == 1)begin
                        seg[6:0] = blink_death?7'b0010001: empty;
                    end                        
                    else begin
                        seg[6:0] =7'b0111111;//dash
                    end
                end
                else begin
                    an[3:0] = 4'b1101;
                    if (sw1 == 1)begin
                        an[3:0] = 4'b1111;
                    end
                    if (led[9] == 1)begin
                        seg[6:0] = one;//1
                    end
                    else begin
                        seg[6:0] = 7'b1111111;//7'b1000000;//0
                    end
                end
            end
             4:begin
                an[3:0] = 4'b1110;
                if(sw1 == 1 ||sw7 == 1)begin
                    if (game_over == 1 && sw7 == 1)begin
                        seg[6:0] = blink_death?7'b0000110:empty;
                    end
                    else if(win == 1 && sw7 == 1)begin
                        seg[6:0] = blink_death?7'b0010001: empty;
                    end 
                    else begin
                        if (led[15:0]==16'b0000000000000000)begin
                            seg[6:0] = low;
                        end
                        if(((led[5]==1||led[4] == 1 || led[3] == 1 || led[2]==1 || led[1]==1 ||led[0]==1)&& led[15:5] == 10'b0000000000))begin
                            seg[6:0] = low;
                            if (bulletstate == 0)begin
                                normal_pew = 1; big_pew = 0;
                            end
                            else begin
                                normal_pew = 0; big_pew = 0;
                            end
                        end
                        if((led[6] == 1 || led[7] == 1 || led[8] == 1|| led[9] == 1 ||led[10]== 1) && led[15:11] == 5'b00000)begin
                            seg[6:0] = med;
                            normal_pew = 0; big_pew = 1;
                        end
                        if ((led[15]==1||led[14]==1||led[13]==1||led[12]==1||led[11]==1)&&led[10:0] == 11'b11111111111)begin
                            seg[6:0] = high;
                            normal_pew = 0; big_pew = 1;
                        end
                     end
                end
                else if (sw1 == 0 && sw7==0)begin
                    if (led[15:0]== 0)begin
                        seg[6:0] = 7'b1111111;//7'b1000000;//0
                        //normal_pew = 0;
                        //big_pew = 0;
                        end
                    if (led[0] == 1 && led[15:1] == 15'b00000000000000)begin
                        seg[6:0] = one;
                        //normal_pew = 1; big_pew = 0;
                        end
                    if (led[1:0]== 2'b11 && led[15:2]==14'b00000000000000)begin
                        seg[6:0] = two;
                        //normal_pew = 1; big_pew = 0;
                        end
                    if (led[2:0]==3'b111 && led[15:3]==13'b0000000000000)begin
                        seg[6:0] = three;
                        //normal_pew = 1; big_pew = 0;
                        end
                    if (led[3:0]==4'b1111 && led[15:4]==12'b000000000000)begin
                        seg[6:0] = four;
                        //normal_pew = 1; big_pew = 0;
                        end
                    if (led[4:0]==5'b11111 && led[15:5]==11'b00000000000) begin
                        seg[6:0] = five;
                        //normal_pew = 1; big_pew = 0;
                        end
                    if (led[5:0]==6'b111111 && led[15:6]==10'b0000000000)begin                  
                        seg[6:0] = six;
                        //normal_pew = 0; big_pew = 1;
                        end
                    if (led[6:0]==7'b1111111 && led[15:7]==9'b000000000)begin
                        seg[6:0] = seven;
                        //normal_pew = 0;big_pew = 1;
                        end
                    if (led[7:0]==8'b11111111 && led[15:8]==8'b00000000)begin
                        seg[6:0] = eight;
                        //normal_pew = 0;big_pew = 1;
                        end
                    if (led[8:0]==9'b111111111 && led[15:9]==7'b0000000)begin
                        seg[6:0] = nine;
                        //normal_pew = 0;big_pew = 1;
                        end
                    if (led[9:0]==10'b1111111111 && led[15:10]==6'b000000)begin
                        seg[6:0] = zero;
                        //normal_pew = 0;big_pew = 1;
                        end
                    if (led[10:0] == 11'b11111111111 && led[15:11] == 5'b00000) begin
                        seg[6:0] = one;
                        //normal_pew = 0; big_pew = 1; 
                        end
                    if (led[11:0]==12'b111111111111 && led[15:12]==4'b0000)begin
                        seg[6:0] = two;
                        //normal_pew = 0; big_pew = 1;
                        end
                    if (led[12:0]==13'b1111111111111 && led[15:13]==3'b000)begin
                        seg[6:0] = three;
                        //normal_pew = 0; big_pew = 1;
                        end
                    if (led[13:0]==14'b11111111111111 && led[15:14]==2'b00)begin
                        seg[6:0] = four;
                        //normal_pew = 0; big_pew = 1;
                        end              
                    if (led[15:0]==16'b1111111111111111)begin
                        seg[6:0] = five;
                        //normal_pew = 0; big_pew = 1;
                        end                                                                                               
                    end
               end
               5:begin
                    countfast = 0;
                    end
            endcase
        end                 
endmodule


