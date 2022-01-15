`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2021 14:23:49
// Design Name: 
// Module Name: iron_man_oled
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


module iron_man_oled_2(
    input CLOCK,
    input [15:0]sw,
    input [15:0]led,
    input normal_pew, 
    input big_pew, 

    input [12:0]pixel_index,
    input UPBUTTON,
    input CTRBUTTON,
    input LBUTTON,
    input RBUTTON,
    input reset,
    //input [15:0]LED,
    output reg [1:0]hp = 3,
    output reg bulletstate = 0,
    output reg [2:0] kill_count = 0, //kill count for ulti
    output reg game_over = 0,
    output reg win = 0,
    output reg [15:0]pixel_data=0
    
        );
    
     
    wire [10:0]pixel_i;
    wire [10:0]pixel_j;
       

       
    wire R_pulse;
    wire L_pulse;
    reg god_mode = 0; //TURN TO 0 WHEN IMPLEMENTING//CHANGE TO 1 FOR HACKS
    reg [10:0] n_t = 40;
    reg [10:0] k_t = 56;
    
    reg ignore = 0;
    reg [10:0]n=0;
    reg [10:0]k=23; 
    
    reg dronestate = 0;
    reg [10:0] n_drone = 96;
    reg [10:0] k_drone = 23;
    reg [40:0]count_drone_spd = 0;
    reg [40:0] drone_speed = 0;

        
    reg drone2_state = 0;
    reg [10:0] n_drone2 = 96; 
    reg [10:0] k_drone2 = 0;
    reg [40:0] count_drone2_spd = 0;
    reg [40:0] drone2_speed = 0;
        
    reg [40:0]count=0;
    reg [40:0]count1=0;
    
    reg [40:0] bulletspeed = 0;
    reg [10:0] startofbullet_i=0;
    reg [10:0] startofbullet_j=0 ;
    reg [10:0] endofbullet_i=0;
    reg [10:0] endofbullet_j=0;

    reg ultistate = 0;
    reg ultistate2 = 0;
    reg [40:0]ulti_timer=0;
    
    reg [40:0] randomcount = 0;
    reg [40:0] randomnumber = 0;
    reg [10:0] kill_tally = 0; //this is overall kill_count
    
    reg ultronstate = 0;
    reg [40:0]ultron_trigger = 7;    
    reg [10:0]duo_drones_trigger = 5;
    
    //THANOS BOSS FIGHT
    reg [40:0] transition_count = 0;
    reg transition = 0;
    reg [10:0]k_thanos = 23;
    reg [10:0]n_thanos = 96;
    reg thanos_heal = 0;
    reg [10:0] teleport_to = 0;
    reg [5:0] thanos_hp = 40;
    reg [40:0] randomnumber_thanos = 0;
    reg thanos_state = 0;
    reg [40:0]thanos_teleport_count = 0;
    reg [40:0] teleport_freq = 0;
    reg [40:0]teleport_animation = 0;
    reg thanos_pew = 0;

    reg thanos_pew_signal = 0;
    reg [40:0] thanos_pew_speed = 0;
    reg [10:0] startofthanos_pew_i = 0;
    reg [10:0] endofthanos_pew_i = 0;
    reg [10:0] startofthanos_pew_j = 0;
    reg [10:0] endofthanos_pew_j = 0;
    reg thanos_peeew = 0;
    reg thanos_peeew_anim = 0;
    reg [40:0]thanos_movement_count = 0;//along k_thanos only
//COLOURS
    parameter [15:0]sky= {5'b00000,6'b000000,5'b00000}; //{5'b11011,6'b111010,5'b11110};

    parameter [15:0]black = {5'b00000,6'b000000,5'b00000}; 
    
    parameter [15:0]grey = {5'b11010,6'b110011,5'b11001};
    parameter [15:0]dark_grey = {5'b10000,6'b100000,5'b10000};
    parameter [15:0]red = {5'b11111,6'b000000,5'b00000};
    parameter [15:0]dark_red = {5'b11000,6'b000000,5'b00000};
    
    parameter [15:0]green = {5'b00000,6'b111111,5'b00000};
    
    parameter [15:0]yellow = {5'b11111,6'b110000,5'b00000}; //iron man face and hands
    parameter [15:0]dark_yellow = {5'b10111,6'b100011,5'b00000};//shadow for iron man face and hands and thanos shoes
    parameter [15:0]purple = {5'b11000,6'b011010,5'b11101}; // thanos skin
    parameter [15:0]dark_purple = {5'b11100,6'b110000,5'b10100};
    parameter [15:0]blue = {5'b00000,6'b000000,5'b11111};
    parameter [15:0]light_blue = {5'b00000,6'b101100,5'b11110}; // IRON MAN EYES AND FIRE
    parameter [15:0]dark_blue = {5'b00000,6'b111000,5'b11000}; //IRON MAN OUTER FLAMES AND THANOS SUIT
    parameter [15:0]darkest_blue = {5'b0000,6'b100000,5'b11000}; //THANOS SUIT SHADOW
    
    parameter [15:0]white = {5'b11111,6'b111111,5'b11111};

    assign pixel_i = pixel_index /96; //rows
    assign pixel_j = pixel_index %96; //columns
    
    always @(posedge CLOCK) begin

    if (sw[7] == 1)begin
        if (reset == 1)begin
            game_over = 0; win = 0; hp = 3; kill_count = 0; n = 0; k = 23; randomcount = 0;count=0;count1=0;kill_tally = 0;
            dronestate = 0; count_drone_spd = 0; n_drone = 96; k_drone = 23; 
            drone2_state = 0; count_drone2_spd = 0;n_drone2 = 96; k_drone2 = 33; 
            bulletstate = 0; startofbullet_i = 0; endofbullet_i= 0; startofbullet_j = 0; endofbullet_j = 0; kill_tally = 0;
            ultronstate = 0; ultron_trigger = 7; ignore = 0;k_thanos = 23; n_thanos = 96;thanos_pew = 0;thanos_peeew = 0; thanos_peeew_anim = 0;
            thanos_pew_speed = 0; teleport_animation = 0; teleport_to = 0; thanos_movement_count = 0; thanos_teleport_count = 0;
            thanos_hp = 40;thanos_state = 0; 
        end
        if (god_mode == 1)begin
            hp = 3;
        end
        if (hp == 0)begin
            game_over = 1; 
        end
        if (kill_tally == 34)begin
            hp = 3;
        end
        if (kill_tally >= 35)begin
            thanos_state = 1;
            kill_count = 0;
        end
        if (thanos_state == 1)begin
            dronestate = 0;
            drone2_state = 0;
        end
        randomcount = randomcount + 1;
        if (randomcount == 1437767901)begin
            randomcount = 0;
        end
        randomnumber_thanos = ((randomcount % 40) + 1);
        randomnumber = (( randomcount % 45) +2);
        if (kill_tally == ultron_trigger && randomnumber % 13 == 0 && thanos_state == 0)begin
            ultronstate = 1;
        end
      
        //******************************************* DRONE 1 CODE***********************************************

        if(dronestate == 0 && thanos_state == 0)begin
            k_drone = randomnumber;
            dronestate = 1;
        end
        drone_speed = (ultronstate)?100000:(kill_tally >= 15)?250000:300000;
        if (((dronestate == 1 && game_over == 0) || (ultronstate == 1 && game_over == 0)) && thanos_state == 0)begin
            if(count_drone_spd >= drone_speed)begin
                n_drone = n_drone - 1;
                count_drone_spd = 0;
            end
            else begin
                count_drone_spd = count_drone_spd + 1;
            end
            if ((ultistate == 1|| (n_drone == startofbullet_j && startofbullet_i >= k_drone && startofbullet_i <= k_drone + 16))&& thanos_state == 0)begin
                dronestate = 0;                
                bulletstate = 0;
                endofbullet_j = 0;
                startofbullet_j = 0;
                count1 = 0;
                count_drone_spd = 0;
                n_drone = 96; 
                if (ultistate != 1)begin
                    kill_tally = kill_tally + 1;
                end
                if (ultronstate == 1 && ultistate != 1)begin
                    ultron_trigger = ultron_trigger + (randomcount%4+ 3);                   
                    ultronstate = 0;
                end
                if (kill_count<5)begin
                    kill_count = kill_count + 1;
                end
                else if(kill_count == 5)begin
                    kill_count = kill_count;
                end
            end
            else if(((n_drone == 0)||(n == n_drone && k >= k_drone && k <= k_drone + 16) || (n == n_drone && k + 17 >= k_drone && k +17 <= k_drone + 16))&&(thanos_state == 0))begin               
                if (hp > 0)begin
                    hp = hp - 1;
                end
                if (ultronstate == 1)begin
                    ultron_trigger = ultron_trigger + (randomcount%4 + 1);                
                    ultronstate = 0;
                end
                count_drone_spd = 0;
                dronestate = 0;
                n_drone = 96;
            end
        end
        //***********************************DRONE 2 CODE*******************************************
        if(kill_tally>= 5 && thanos_state == 0) begin
            drone2_state=1;
        end
        drone2_speed = (kill_tally >= 15)? 250000:300000;
        if (drone2_state == 1 && game_over == 0 && thanos_state == 0)begin
            if(count_drone2_spd >= drone2_speed)begin
                n_drone2 = n_drone2 - 1;
                count_drone2_spd = 0;
            end
            else begin
                count_drone2_spd = count_drone2_spd + 1;
            end    
            if (((ultistate2 == 1)||(drone2_state==1 && game_over ==0 && n_drone2 == startofbullet_j && startofbullet_i >= k_drone2 && startofbullet_i <= k_drone2 + 16))&&thanos_state == 0)begin
                k_drone2 = randomcount%39 + 4;
                drone2_state = 0; 
                count_drone_spd = 60000;            
                bulletstate = 0;
                endofbullet_j = 0;
                startofbullet_j = 0;
                count1 = 0; 
                count_drone2_spd = 0; 
                n_drone2 = 96; 
                if (kill_count<5)begin
                    kill_count = kill_count + 1;
                end
                if (ultistate2 != 1)begin
                    kill_tally = kill_tally + 1; 
                end
            end
        
            if((drone2_state==1 && game_over ==0 && (n_drone2 == 0)||(n == n_drone2 && k >= k_drone2 && k <= k_drone2 + 16) || (n == n_drone2 && k + 17 >= k_drone2 && k +17 <= k_drone2 + 16))&&thanos_state == 0)begin               
                if (hp > 0)begin
                    hp = hp - 1;
                end
                count_drone2_spd = 0;
                drone2_state = 0;
                k_drone2 = randomcount% 40 + randomcount%6 + 1;
                n_drone2 = 96;
            end
        end
      
//*****************z********************THANOS BEHAVIOUR***********************************************
        if (thanos_state == 1)begin
            if (n_thanos > 71)begin
                if(thanos_movement_count == 300000)begin
                    n_thanos = n_thanos - 1;
                    thanos_movement_count = 0;
                end
                else begin
                    thanos_movement_count = thanos_movement_count + 1;
                end
            end
            //TELEPORT
            else if (n_thanos <= 71)begin
                teleport_freq = 25500000;
                if (thanos_teleport_count == teleport_freq && win == 0)begin
                    teleport_animation = 1;
                    thanos_teleport_count = thanos_teleport_count + 1;
                    teleport_to = k + 1;
                end
                else if(thanos_teleport_count == teleport_freq + 5000000 && win == 0)begin
                    k_thanos = teleport_to;
                    teleport_animation = 0;
                    thanos_peeew = 1;
                    thanos_peeew_anim = 1;
                    thanos_teleport_count = thanos_teleport_count + 1;
                end
                else if(thanos_teleport_count >= teleport_freq + 10000000 && thanos_peeew_anim == 1 && win == 0)begin //big pew from 250000000 to 275000000
                    thanos_peeew_anim = 0;
                    thanos_peeew = 0;
                    thanos_teleport_count = 0;
                end
                else begin
                    thanos_teleport_count = thanos_teleport_count + 1;
                end
                //END OF TELEPORT
                //MOVEMENT   
                if(k > 1 && k_thanos + 10 < k + 11 && thanos_peeew_anim == 0 && thanos_peeew == 0 && win == 0)begin
                    if (thanos_movement_count == 350000)begin
                        k_thanos = k_thanos + 1;
                        thanos_movement_count = 0;
                    end
                    else begin
                        thanos_movement_count = thanos_movement_count + 1;
                    end
                end
                else if(k > 1 && k_thanos + 10 > k + 11 && thanos_peeew == 0 && thanos_peeew_anim == 0 && win == 0 )begin
                    if(thanos_movement_count == 350000)begin
                        k_thanos = k_thanos - 1;
                        thanos_movement_count = 0;
                    end
                    else begin
                        thanos_movement_count = thanos_movement_count + 1;
                    end
                end
                //END OF MOVEMENT
                //********************HIT BY IRON MAN*********************************
                if (endofbullet_i >= k_thanos && endofbullet_i <= k_thanos + 23 && endofbullet_j >= n_thanos + 1 && endofbullet_j <= n_thanos + 24 && win == 0)begin
                    bulletstate = 0;
                    endofbullet_j = 0;startofbullet_j = 0;
                    if(thanos_hp == 0)begin
                        win = 1;
                        thanos_state = 0;
                        thanos_pew = 0;
                        thanos_pew_speed = 0;
                        thanos_peeew = 0;
                    end                
                    else if (thanos_peeew == 1)begin
                        thanos_hp = thanos_hp;
                    end
    
                    else begin
                        thanos_hp = thanos_hp - 1;
                    end
                end
                //*****************THANOS PEW PEW**********************************
                if(((k_thanos + 10 >= k+5 && k_thanos + 10 <= k + 11)|| (k_thanos + 11 >= k+5 && k_thanos + 11 <= k + 11)||(k_thanos + 12 >= k+5 && k_thanos <= k+11)) && thanos_peeew == 0 && thanos_pew == 0 && win == 0)begin
                    thanos_pew_signal = 1;
                end
                if(thanos_pew_signal == 1 && win == 0)begin
                    startofthanos_pew_i = k_thanos + 10;
                    endofthanos_pew_i = k_thanos + 12;
                    startofthanos_pew_j = n_thanos;
                    endofthanos_pew_j = n_thanos + 5;
                    thanos_pew = 1;
                    thanos_pew_signal = 0;
                end
                if (thanos_pew == 1 && win == 0)begin
                    if(thanos_pew_speed == 40000)begin
                        startofthanos_pew_j = startofthanos_pew_j - 1;
                        endofthanos_pew_j = endofthanos_pew_j - 1;
                        thanos_pew_speed = 0;
                    end
                    else begin
                        thanos_pew_speed = thanos_pew_speed + 1;
                    end
                    if (endofthanos_pew_j == 0)begin
                        thanos_pew = 0;
                        thanos_pew_speed = 0;
                        startofthanos_pew_j = 96;
                        endofthanos_pew_j = 96;
                    end
                    
                    if(((n + 10 == startofthanos_pew_j && k <= startofthanos_pew_i && k + 15 >= endofthanos_pew_i)||(n + 10 >= n_thanos && k >= k_thanos && k + 15 <= k_thanos+23)
                    ||n+10 >= n_thanos && k <= k_thanos + 23 && k >= k_thanos)&& win==0)begin
                        if (hp > 0)begin
                            hp = hp - 1;
                        end

                        thanos_pew = 0;
                        thanos_pew_speed = 0;
                        startofthanos_pew_j = 96;
                        endofthanos_pew_j = 96;
                    end
                end
                if(thanos_peeew == 1 && k_thanos + 10 >= k && k_thanos + 12 <= k + 15  && win == 0)begin
                    hp = hp - 1;
                    thanos_peeew = 0;
                end
            end
        end
//**************************************BULLET CODE****************************************************
        bulletspeed = (thanos_state)?50000:60000;
        if(bulletstate == 1 && game_over == 0) begin
            if(count1 == bulletspeed)begin 
                startofbullet_j = startofbullet_j+1;
                endofbullet_j = endofbullet_j+1;
                count1=0;
            end
            else begin
                count1=count1+1;
            end
            if(startofbullet_j==96)begin
                count1=0;
                bulletstate = 0;
                endofbullet_j = 0;
                startofbullet_j = 0;
            end
        end
        if(normal_pew == 1 && bulletstate==0)begin
            bulletstate = 1;
            startofbullet_i = k+7 ;
            startofbullet_j= n+14 ;
            endofbullet_i= k+7;
            endofbullet_j= n+16; 
        end 
//*****************************ULTIMATE ABILITY CODE *****************************************
        if(big_pew == 1 && ultistate == 0 && ultistate2 == 0 && kill_count == 5)begin     
            ultistate = 1;
            ultistate2 = 1;
        end
        
        if(ultistate==1 && ultistate2 == 1)begin
            ulti_timer = ulti_timer+1;
        end
        
        if(ulti_timer==800000)begin
            if (kill_tally >= 7)begin
                ultron_trigger = ultron_trigger + (randomcount%4 + 1);            
                ultronstate = 0;
            end
            kill_count = 0;
            ultistate=0;
            ultistate2=0;
            ulti_timer=0;  
        end
    //********************IRON MAN CODE*****************************************************
        
        if(RBUTTON ==1 && ignore == 0) begin
            if(count==90000 && n<80)begin
                n=n+1;
                count=0;
            end
            else begin
                count=count+1;
            end
            
            if(n>=80)begin
                count=0;
            end
        end
            
        if(LBUTTON ==1 && ignore == 0) begin
            if(count==90000 && n>0)begin 
                n=n-1;
                count=0;
            end
            else begin
                count=count+1;
            end
            if(n<=0)begin
                count=0;
            end
        end
            
        if(CTRBUTTON ==1 && ignore == 0) begin
            if(count==90000 && k<46)begin
                k=k+1;
                count=0;
            end
            else begin
                count=count+1;
            end
                    
            if(k>=46)begin
                count=0;
            end
        end
                    
        if(UPBUTTON ==1 && ignore == 0) begin
            if(count==90000 && k>2)begin 
                k=k-1;
                count=0;
            end
            else begin
                count=count+1;
            end        
            if(k<=2)begin
                count=0;
            end
        end
        
        
//******************************************GAME OVER SCREEN************************************************
        if (game_over == 1)begin
            if(pixel_i==17)begin
                if((pixel_j>=30 && pixel_j <= 34) || (pixel_j>=39 && pixel_j <= 40) || (pixel_j>=45 && pixel_j <= 46) || (pixel_j>=52 && pixel_j <= 53) || (pixel_j>=56 && pixel_j <= 60)  )begin
                    pixel_data = white;
                end
                else begin
                    pixel_data=black;
                end
            end
            else if(pixel_i==18 || pixel_i==19)begin
                if(pixel_j == 30 || pixel_j == 38 || pixel_j == 41 || pixel_j == 45 || pixel_j == 47 || pixel_j == 51 || pixel_j == 53 || pixel_j == 56 )begin
                    pixel_data = white;
                end
                else begin
                    pixel_data=black;
                end
            end         
            else if(pixel_i==20)begin
                if(pixel_j == 30 || pixel_j == 37 || pixel_j == 42 || pixel_j == 45 || pixel_j == 48 || pixel_j == 50 || pixel_j == 53 || pixel_j == 56 )begin
                    pixel_data = white;
                end
                else begin
                    pixel_data=black;
                end
            end
            else if(pixel_i==21)begin
                if(pixel_j == 30 || (pixel_j>=32 && pixel_j <= 34) ||  pixel_j == 37 || pixel_j == 42 || pixel_j == 45 || pixel_j == 49 ||pixel_j == 53 || (pixel_j>=56 && pixel_j <= 60) )begin
                    pixel_data = white;
                end
                else begin
                    pixel_data=black;
                end
            end
            else if(pixel_i==22)begin
                if(pixel_j == 30 ||  pixel_j == 34 || (pixel_j>=37 && pixel_j <= 42)|| pixel_j == 45 || pixel_j == 53 ||pixel_j==56)begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = black;
                end
            end
            else if(pixel_i==23 || pixel_i == 24)begin
                if(pixel_j == 30 ||  pixel_j == 34 ||  pixel_j == 37 || pixel_j == 42 || pixel_j == 45 || pixel_j == 53 ||pixel_j==56)begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = black;
                end         
            end
            else if (pixel_i == 25)begin
                if((pixel_j >= 30 && pixel_j <= 34) ||  pixel_j == 37 || pixel_j == 42 ||pixel_j == 45 || pixel_j == 53 || (pixel_j>=56 && pixel_j <= 60))begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = black;
                end
            end
            else if (pixel_i == 28)begin
                if((pixel_j >= 33 && pixel_j <=37) || pixel_j == 40 || pixel_j == 44 || (pixel_j >= 47 && pixel_j <= 51) || (pixel_j >=54 && pixel_j <= 57))begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = black;
                end
            end
            else if (pixel_i == 29 || pixel_i == 30 || pixel_i == 31)begin
                if(pixel_j == 33 || pixel_j == 37|| pixel_j == 40 || pixel_j == 44 ||pixel_j == 47||pixel_j==54||pixel_j == 58)begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = black;
                end
            end
            else if (pixel_i == 32)begin
                if(pixel_j == 33 || pixel_j == 37|| pixel_j == 40 || pixel_j == 44 ||(pixel_j >= 47 && pixel_j <= 51)||pixel_j>=54&&pixel_j <= 57)begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = black;
                end
            end
            else if (pixel_i == 33 || pixel_i == 34)begin
                if(pixel_j == 33 || pixel_j == 37||pixel_j == 40 || pixel_j == 44||pixel_j == 47||pixel_j == 54||pixel_j == 58)begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = black;
                end
            end
            else if (pixel_i == 35)begin
                if(pixel_j == 33 || pixel_j == 37||pixel_j == 41 || pixel_j == 43||pixel_j == 47||pixel_j == 54||pixel_j == 58)begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = black;
                end 
            end
            else if (pixel_i == 36)begin
                if(pixel_j >= 33 && pixel_j <= 37||pixel_j == 42 ||(pixel_j >= 47 && pixel_j <= 51)||pixel_j == 54||pixel_j == 58)begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = black;
                end
            end
            else begin
                pixel_data = black;
            end               
        end
//************************************************WIN SCREEN***********************************************************
        else if(win == 1)begin
            if(pixel_i == 9)begin
                if(pixel_j == 39 || pixel_j == 43 || (pixel_j >= 46 && pixel_j <= 50) ||pixel_j == 53 || pixel_j == 57)begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = black;
                end
            end
            else if(pixel_i >= 10 && pixel_i <= 12)begin
                if(pixel_j == 39 || pixel_j == 43 ||pixel_j == 46|| pixel_j == 50 ||pixel_j == 53 || pixel_j == 57)begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = black;
                end
            end
            else if(pixel_i == 13)begin
                if((pixel_j >= 39 && pixel_j <= 43)||pixel_j == 46|| pixel_j == 50 ||pixel_j == 53 || pixel_j == 57)begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = black;
                end
            end
            else if(pixel_i >= 14 && pixel_i <= 17)begin
                if(pixel_j == 41||pixel_j == 46|| pixel_j == 50 ||pixel_j == 53 || pixel_j == 57)begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = black;
                end
            end
            else if(pixel_i == 18)begin
                if(pixel_j == 41||(pixel_j >= 46 && pixel_j <= 50)||(pixel_j>= 53 && pixel_j <= 57))begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = black;
                end
            end
            else if(pixel_i == 20)begin
                if(pixel_j == 39||pixel_j == 43 || (pixel_j >= 46 && pixel_j <= 50) || (pixel_j==53)||(pixel_j==54)||(pixel_j==57))begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = black;
                end
            end
            else if(pixel_i >= 21 && pixel_i <= 24)begin
                if(pixel_j == 39 || pixel_j == 43 ||pixel_j == 46|| pixel_j == 50 ||pixel_j == 53 || pixel_j == 55|| pixel_j == 57)begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = black;
                end
            end
            else if(pixel_i >= 25 && pixel_i <=28)begin
                if(pixel_j == 39 || pixel_j == 41|| pixel_j == 43 ||pixel_j == 46|| pixel_j == 50 ||pixel_j == 53 || pixel_j == 55|| pixel_j == 57)begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = black;
                end
            end 
            else if(pixel_i == 29)begin
                if(pixel_j==39||pixel_j==40||pixel_j==42||pixel_j==43||(pixel_j>=46 && pixel_j <= 50)||pixel_j==53||pixel_j==56||pixel_j==57)begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = black;
                end
            end
        end

        //**************************************CODE FOR BULLET**********************************************
        else if (game_over == 0 && win == 0)begin
            if(bulletstate==1 && pixel_i == startofbullet_i && pixel_j>=startofbullet_j && pixel_j <= endofbullet_j)begin
                pixel_data = light_blue;
            end
        //*****************************************Thanos Pew********************************************************
            else if (thanos_pew == 1 && pixel_i >= startofthanos_pew_i && pixel_i <= endofthanos_pew_i && pixel_j <= endofthanos_pew_j  && pixel_j >= startofthanos_pew_j)begin
                pixel_data = dark_purple;
            end
        //****************************************THANOS PEEEW**********************************************************
            else if (thanos_peeew_anim == 1 && pixel_i >= k_thanos + 10 && pixel_i <= k_thanos + 12 && pixel_j >= 0 && pixel_j <= n_thanos)begin
                pixel_data = dark_purple;
            end
        //******************iron man coke **********************
            //1ST ROW OF IRON MAN 
            else if(pixel_i==k && pixel_j>=n+5 && pixel_j <= n+9 )begin
                pixel_data = black;
            end
            //2ND ROW OF IRON MAN
            else if(pixel_i==k+1 && pixel_j>= n+4 && pixel_j<= n+10)begin
                if(pixel_j==n+4 || pixel_j==n+10)begin
                    pixel_data = black;
                end
            
                else if(pixel_j>=n+8 && pixel_j <= n+9)begin
                    pixel_data = dark_red;
                end
            
                else if(pixel_j>=n+5 && pixel_j <= n+7) begin
                    pixel_data=red;
                end
               
            end
            //3RD ROW OF IRON MAN
            else if(pixel_i==k+2 && pixel_j>= n+3 && pixel_j<= n+11)begin
                if(pixel_j==n+3 || pixel_j==n+11)begin
                    pixel_data = black;
                end
                
                else if(pixel_j==n+8 || pixel_j == n+10)begin
                   pixel_data = dark_red;
                end  
                   
                else if(pixel_j==n+9)begin
                    pixel_data = dark_yellow;
                end 
             
                else if(pixel_j==n+7 || pixel_j==n+4)begin
                    pixel_data = red;
                end 
             
                else if(pixel_j>=n+5 && pixel_j <= n+6)begin
                    pixel_data= yellow;
                end        
            end 
            //4TH ROW OF IRON MAN
            else if(pixel_i==k+3 && pixel_j>= n+3 && pixel_j<= n+11)begin
                if(pixel_j==n+3 || pixel_j==n+11)begin
                    pixel_data = black;
                end
                else if(pixel_j==n+4)begin
                    pixel_data= red;
                end
                else if(pixel_j==n+5 || pixel_j==n+7 || pixel_j==n+8  )begin
                    pixel_data = yellow;
                end
                else if(pixel_j ==n+6 || pixel_j==n+9)begin
                    pixel_data = light_blue;
                end
                else if(pixel_j==n+10)begin
                    pixel_data = dark_yellow;
                end
               
            end
            //5TH ROW FOR IRON MAN
            else if(pixel_i==k+4 && pixel_j>= n+3 && pixel_j<= n+11)begin     
                if(pixel_j==n+3 || pixel_j==n+11)begin
                    pixel_data = black;
                end
                else if(pixel_j==n+4)begin
                    pixel_data= red;
                end
                else if(pixel_j>=n+5 && pixel_j <= n+9)begin
                    pixel_data = yellow;
                end
                
                else if(pixel_j==n+10)begin
                    pixel_data = dark_red;
                end
               
            end
                
         //6TH ROW FOR IRON MAN
            else if(pixel_i==k+5 && pixel_j>= n+3 && pixel_j<= n+11)begin
            
                if(pixel_j==n+3 || pixel_j==n+11 || pixel_j==n+4 || pixel_j==n+10)begin
                    pixel_data = black;
                end
                            
                else if(pixel_j==n+5)begin
                pixel_data= red;
                end
                else if(pixel_j==n+6 || pixel_j==n+7 || pixel_j==n+8  )begin
                    pixel_data = yellow;
                end   
                else if(pixel_j==n+9)begin
                    pixel_data = dark_red;
                end
                   
            end
        
        //7TH ROW FOR IRON MAN
            else if(pixel_i==k+6 && pixel_j>= n+3 && pixel_j<= n+13)begin      
                if(pixel_j>=n+3 && pixel_j <= n+13)begin
                    pixel_data = black;
                end
               
            end
        
        //8TH ROW FOR IRON MAN
            else if(pixel_i==k+7 && pixel_j>= n+2 && pixel_j <= n + 13)begin   
                if(pixel_j==n+2 || pixel_j==n+11)begin
                    pixel_data = black;
                end
                else if(pixel_j==n+3 || pixel_j==n+12)begin
                    pixel_data = yellow;
                end  
                else if( (pixel_j>=n+4 && pixel_j <= n+10) || pixel_j==n+13)begin
                    pixel_data = dark_red;
                end   
             
            end
         
         //9TH ROW FOR IRON MAN
            else if(pixel_i==k+8 && pixel_j>= n+2 && pixel_j <= n+13)begin 
                if(pixel_j==n+2 || pixel_j==n+4 || (pixel_j>=n+10 && pixel_j <=n+ 13))begin
                    pixel_data = black;
                end
                        
                else if(pixel_j==n+5 || pixel_j==n+7 || pixel_j==n+9)begin
                    pixel_data= red;
                end
                
                else if(pixel_j==n+3)begin
                    pixel_data = yellow;
                end
                
                else if(pixel_j==n+6)begin
                    pixel_data = dark_red;
                end
                
                else if(pixel_j==n+8)begin
                    pixel_data = light_blue;
                end
                
             
            end
        
        //10TH ROW FOR IRON MAN
            
            else if(pixel_i==k+9 && pixel_j>= n+2 && pixel_j <= n+10)begin
            
                if(pixel_j==n+2 || pixel_j==n+4 || pixel_j==n+10)begin
                    pixel_data = black;
                end
                    
                else if(pixel_j==n+5 || pixel_j == n+6 || pixel_j ==n+9)begin
                   pixel_data = dark_red;
                end  
                     
                 else if(pixel_j==n+3 || pixel_j==n+7 || pixel_j==n+8)begin
                    pixel_data = red;
                 end 
                
            end
            
        //11TH ROW FOR IRON MAN
                
            else if(pixel_i==k+10 && pixel_j>= n+3 && pixel_j <= n+10)begin
            
                if(pixel_j==n+3 || pixel_j==n+4 || pixel_j==n+10)begin
                    pixel_data = black;
                end
                    
                else if(pixel_j==n+5 || pixel_j == n+6 || pixel_j==n+9)begin
                   pixel_data = dark_red;
                end  
        
                else if(pixel_j==n+7 || pixel_j==n+8)begin
                    pixel_data = red;
                end  
              
            end 
                
        //12TH ROW FOR IRON MAN
                    
            else if(pixel_i==k+11 && pixel_j>= n+4 && pixel_j <= n+10)begin  
                if(pixel_j>=n+4 && pixel_j <= n+10)begin
                    pixel_data = black;
                end
             
            end    
        //13TH ROW FOR IRON MAN                  
            else if(pixel_i==k+12 && pixel_j>= n+4 && pixel_j <= n+10)begin   
                if( pixel_j==n+4 || (pixel_j>=n+6 && pixel_j <= n+8) || pixel_j == n+10)begin
                    pixel_data = black;
                end
                else if(pixel_j==n+5 || pixel_j==n+9)begin
                   pixel_data = dark_red;
                end  
                 
                          
            end
        //14TH ROW FOR IRON MAN     
            else if(pixel_i==k+13 && pixel_j>= n+4 && pixel_j <= n+10)begin      
                if((pixel_j>=n+4 && pixel_j <= n+6) || (pixel_j>=n+8 && pixel_j <= n+10))begin
                    pixel_data = black;
                end           
                 
            end
        
        //15TH ROW FOR IRON MAN       
            else if(pixel_i==k+14 && pixel_j>= n+3 && pixel_j <=n+11)begin   
                
                if (pixel_j == n+4||pixel_j == n+6 || pixel_j == n+8 || pixel_j == n+10)begin
                    pixel_data = (UPBUTTON==1 || LBUTTON==1 || RBUTTON==1)? yellow:(CTRBUTTON==1)?dark_blue:dark_blue;
                end
                else if(pixel_j ==n+5 || pixel_j ==n+9)begin
                    pixel_data= (UPBUTTON==1 || LBUTTON==1 || RBUTTON==1)? red:(CTRBUTTON == 1)?light_blue:light_blue;
                end
                else if(pixel_j ==n+3 || pixel_j ==n+7 || pixel_j ==n+11)begin
                    pixel_data= (UPBUTTON==1 || LBUTTON==1 || RBUTTON==1)? red:sky;
                end            
               
            end
        
        //16TH ROW FOR IRON MAN
                
            else if(pixel_i==k+15 && pixel_j>= n+4 && pixel_j<=n+10)begin
                if(pixel_j ==n+5 || pixel_j ==n+9)begin
                    pixel_data = (UPBUTTON==1 || LBUTTON==1 || RBUTTON==1)? yellow:(CTRBUTTON == 1)?sky:dark_blue;
                end
                
                else if(pixel_j ==n+4 || pixel_j ==n+6 || pixel_j ==n+8 || pixel_j ==n+10)begin
                    pixel_data = (UPBUTTON==1 || LBUTTON==1 || RBUTTON==1)? red:sky;
                end        
                
              
            end
                
           //17TH  ROW FOR IRON MAN
            else if(pixel_i==k+16 && pixel_j>= n+5 && pixel_j <= n+9)begin
                if(pixel_j ==n+5 || pixel_j ==n+9)begin
                    pixel_data = (UPBUTTON==1 || LBUTTON==1 || RBUTTON==1)? red:sky;
                end
                else begin
                    pixel_data = sky;
                end
            end
        
    //****************************************************ULTRON DRONE*********************************************************
            //1ST ROW FOR ULTRON DRONE
            else if (pixel_i==k_drone && pixel_j >=n_drone+5 && pixel_j <=n_drone+9 && dronestate == 1 && thanos_state == 0)begin
                pixel_data = black;
            end
            //2nd row
            else if(pixel_i == k_drone+ 1 && pixel_j >= n_drone + 4 && pixel_j <= n_drone + 9 && dronestate == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone+4 || pixel_j == n_drone + 9)begin
                    pixel_data = black;
                end
                else if(pixel_j >= n_drone+5 && pixel_j <= n_drone+7)begin
                    pixel_data = dark_grey;
                end
                else if(pixel_j == n_drone + 8)begin
                    pixel_data = grey;
                end 
            end
            //third row
            else if(pixel_i == k_drone + 2 && pixel_j >= n_drone + 3 && pixel_j <= n_drone + 10 && dronestate == 1 && thanos_state == 0)begin
                if(pixel_j == n_drone + 3 || pixel_j == n_drone + 10)begin
                    pixel_data = black;
                end
                else if(pixel_j >= n_drone + 4 && pixel_j <= n_drone + 6)begin
                    pixel_data = dark_grey;
                end
                else if(pixel_j >= n_drone + 7 && pixel_j <= n_drone + 9)begin
                    pixel_data = grey;
                end
               
            end
            //fourth row
            else if(pixel_i == k_drone + 3 && pixel_j >= n_drone + 3 && pixel_j <= n_drone + 11 && dronestate == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone + 3||pixel_j == n_drone + 11)begin
                    pixel_data = black;
                end
                else if(pixel_j == n_drone + 4||pixel_j == n_drone + 8)begin
                    pixel_data = (ultronstate)?red:light_blue;
                end
                else if(pixel_j == n_drone + 5)begin
                    pixel_data = dark_grey;
                end
                else if(pixel_j == n_drone + 6||pixel_j==n_drone + 7||pixel_j == n_drone + 9||pixel_j == n_drone + 10 && thanos_state == 0)begin
                    pixel_data = grey;
                end
                
            end
            //Fifth Row
            else if(pixel_i == k_drone + 4 && pixel_j >= n_drone + 3 && pixel_j <= n_drone + 10 && dronestate == 1 && thanos_state == 0)begin
                if(pixel_j == n_drone + 3||pixel_j == n_drone + 10) begin
                    pixel_data = black;
                end
                else if(pixel_j == n_drone + 4||pixel_j == n_drone + 5||pixel_j == n_drone +7||pixel_j == n_drone + 8)begin
                    pixel_data = (ultronstate)?red:light_blue;
                end
                else if(pixel_j == n_drone + 6 || pixel_j == n_drone +9)begin
                    pixel_data = grey;
                end
                
            end
            //sixth row
            else if(pixel_i == k_drone + 5 && pixel_j >= n_drone + 3 && pixel_j <= n_drone + 9 && dronestate == 1 && thanos_state == 0)begin
                if(pixel_j == n_drone + 3 || pixel_j == n_drone + 9)begin
                    pixel_data = black;
                end
                else if(pixel_j == n_drone + 4)begin
                    pixel_data = dark_grey;
                end
                else if(pixel_j == n_drone + 5 || pixel_j == n_drone + 7)begin
                    pixel_data = (ultronstate)?red:light_blue;
                end
                else if(pixel_j == n_drone + 6 || pixel_j == n_drone + 8)begin
                    pixel_data = grey;
                end
                
            end
            //seventh row
            else if(pixel_i == k_drone + 6 && pixel_j >= n_drone + 4 && pixel_j <= n_drone + 9 && dronestate == 1 && thanos_state == 0)begin
                if(pixel_j == n_drone + 4||pixel_j == n_drone + 9)begin
                    pixel_data = black;
                end
                else if(pixel_j >= n_drone + 5 && pixel_j <= n_drone + 8)begin
                    pixel_data = grey;
                end   
            end
            //eighth row
            else if (pixel_i == k_drone + 7 && pixel_j >= n_drone + 3 && pixel_j <= n_drone + 11 && dronestate == 1 && thanos_state == 0)begin
                if (pixel_j >= n_drone + 3 && pixel_j <= n_drone + 11)begin
                    pixel_data = black;
                end      
            end
            //ninth row
            else if (pixel_i == k_drone + 8 && pixel_j >= n_drone + 2 && pixel_j <= n_drone + 12 && dronestate == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone + 2 || pixel_j == n_drone + 12)begin
                    pixel_data = black;
                end
                else if (pixel_j >= n_drone + 3 && pixel_j <= n_drone + 10)begin
                    pixel_data = dark_grey;
                end
                else if (pixel_j == n_drone + 11)begin
                    pixel_data = grey;
                end 
            end
            //tenth row
            else if (pixel_i == k_drone + 9 && pixel_j >= n_drone + 2 && pixel_j <= n_drone + 12 && dronestate == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone + 2 || pixel_j == n_drone + 4||pixel_j == n_drone + 10||pixel_j == n_drone + 12)begin
                    pixel_data = black;
                end
                else if(pixel_j == n_drone + 3 || pixel_j == n_drone + 9)begin
                    pixel_data = dark_grey;
                end
                else if(pixel_j == n_drone + 5 || pixel_j == n_drone + 7 || pixel_j == n_drone + 8||pixel_j==n_drone + 11)begin
                    pixel_data = grey;
                end
                else if(pixel_j == n_drone + 6)begin
                    pixel_data = (ultronstate)?red:light_blue;
                end       
            end
            //eleventh row
            else if(pixel_i == k_drone + 10 && pixel_j >= n_drone + 2 && pixel_j <= n_drone + 12 && dronestate == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone + 2 || pixel_j == n_drone + 4||pixel_j == n_drone + 10||pixel_j == n_drone + 12)begin
                    pixel_data = black;
                end
                else if(pixel_j == n_drone + 3 || pixel_j == n_drone + 8||pixel_j == n_drone + 9)begin
                    pixel_data = dark_grey;
                end 
                else if((pixel_j >= n_drone + 5 && pixel_j <= n_drone + 7 )||pixel_j == n_drone + 11)begin
                    pixel_data = grey;
                end      
            end
            //twelfth row
            else if(pixel_i == k_drone + 11 && pixel_j >= n_drone + 3 && pixel_j <= n_drone + 11 && dronestate == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone + 3||pixel_j == n_drone + 4||pixel_j == n_drone + 10|| pixel_j == n_drone + 11)begin
                    pixel_data = black;
                end
                else if(pixel_j == n_drone + 5 || pixel_j == n_drone + 8 || pixel_j == n_drone + 9)begin
                    pixel_data = dark_grey;
                end
                else if(pixel_j == n_drone + 6 || pixel_j == n_drone + 7)begin
                    pixel_data = grey;
                end  
            end
            //13th row
            else if(pixel_i == k_drone + 12 && pixel_j >= n_drone + 3 && pixel_j <= n_drone + 11 && dronestate == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone + 3 || pixel_j == n_drone + 11)begin
                    pixel_data = (ultronstate)?red:light_blue;
                end
                else if (pixel_j >= n_drone +4 && pixel_j <= n_drone +10)begin
                    pixel_data = black;
                end
            end
            //14th row
            else if(pixel_i == k_drone + 13 && pixel_j >= n_drone + 4 && pixel_j <= n_drone + 10 && dronestate == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone + 4 || pixel_j == n_drone + 10 || (pixel_j>=n_drone + 6 && pixel_j <= n_drone + 8))begin
                    pixel_data = black;
                end
                else if(pixel_j == n_drone + 5)begin
                    pixel_data = dark_grey;
                end
                else if(pixel_j == n_drone +9)begin
                    pixel_data = grey;
                end 
            end
            //15th row
            else if(pixel_i == k_drone + 14 && pixel_j >= n_drone + 4 && pixel_j <= n_drone + 10 && dronestate == 1 && thanos_state == 0)begin
                if ((pixel_j >= n_drone + 4 && pixel_j <=n_drone + 6)|| (pixel_j >= n_drone + 8 && pixel_j <= n_drone + 10))begin
                    pixel_data = black;
                end
            end
            //16th row
            else if (pixel_i == k_drone + 15 && pixel_j >= n_drone + 4 && pixel_j <= n_drone + 10 && dronestate == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone + 4 || pixel_j == n_drone + 6 || pixel_j == n_drone + 8 || pixel_j == n_drone + 10) begin
                    pixel_data = (ultronstate)? red:dark_blue;
                end
                else if (pixel_j == n_drone + 5 || pixel_j == n_drone + 9)begin
                    pixel_data = (ultronstate)? yellow:light_blue;
                end
                else begin
                    pixel_data = sky;
                end
            end
            //17th row
            else if(pixel_i == k_drone + 16 && pixel_j >= n_drone + 5 && pixel_j <= n_drone + 9 && dronestate == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone + 5 || pixel_j == n_drone + 9)begin
                    pixel_data = (ultronstate)? red:dark_blue;
                end
                else begin
                    pixel_data = sky;
                end
            end
    
        //****************************************************ULTRON DRONE_2*********************************************************
            //1ST ROW FOR ULTRON DRONE
            else if (pixel_i == k_drone2 && pixel_j >=n_drone2 + 5 && pixel_j <=n_drone2 + 9 && drone2_state == 1 && thanos_state == 0)begin
                pixel_data = black;
            end
            //2nd row
            else if(pixel_i == k_drone2+ 1 && pixel_j >= n_drone2 + 4 && pixel_j <= n_drone2 + 9 && drone2_state == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone2 + 4 || pixel_j == n_drone2 + 9)begin
                    pixel_data = black;
                end
                else if(pixel_j >= n_drone2 + 5 && pixel_j <= n_drone2 + 7)begin
                    pixel_data = dark_grey;
                end
                else if(pixel_j == n_drone2 + 8)begin
                    pixel_data = grey;
                end
            end
            //third row
            else if(pixel_i == k_drone2 + 2 && pixel_j >= n_drone2 + 3 && pixel_j <= n_drone2 + 10 && drone2_state == 1 && thanos_state == 0)begin
                if(pixel_j == n_drone2 + 3 || pixel_j == n_drone2 + 10)begin
                    pixel_data = black;
                end
                else if(pixel_j >= n_drone2 + 4 && pixel_j <= n_drone2 + 6)begin
                    pixel_data = dark_grey;
                end
                else if(pixel_j >= n_drone2 + 7 && pixel_j <= n_drone2 + 9)begin
                    pixel_data = grey;
                end  
            end
            //fourth row
            else if(pixel_i == k_drone2 + 3 && pixel_j >= n_drone2 + 3 && pixel_j <= n_drone2 + 11 && drone2_state == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone2 + 3||pixel_j == n_drone2 + 11)begin
                    pixel_data = black;
                end
                else if(pixel_j == n_drone2 + 4||pixel_j == n_drone2 + 8)begin
                    pixel_data = light_blue;
                end
                else if(pixel_j == n_drone2 + 5)begin
                    pixel_data = dark_grey;
                end
                else if(pixel_j == n_drone2 + 6||pixel_j==n_drone2 + 7||pixel_j == n_drone2 + 9||pixel_j == n_drone2 + 10)begin
                    pixel_data = grey;
                end
            end 
            //Fifth Row
            else if(pixel_i == k_drone2 + 4 && pixel_j >= n_drone2 + 3 && pixel_j <= n_drone2 + 10 && drone2_state == 1 && thanos_state == 0)begin
                if(pixel_j == n_drone2 + 3||pixel_j == n_drone2 + 10) begin
                    pixel_data = black;
                end
                else if(pixel_j == n_drone2 + 4||pixel_j == n_drone2 + 5||pixel_j == n_drone2 +7||pixel_j == n_drone2 + 8)begin
                    pixel_data = light_blue;
                end
                else if(pixel_j == n_drone2 + 6 || pixel_j == n_drone2 +9)begin
                    pixel_data = grey;
                end
            end
            //sixth row
            else if(pixel_i == k_drone2 + 5 && pixel_j >= n_drone2 + 3 && pixel_j <= n_drone2 + 9 && drone2_state == 1 && thanos_state == 0)begin
                if(pixel_j == n_drone2 + 3 || pixel_j == n_drone2 + 9)begin
                    pixel_data = black;
                end
                else if(pixel_j == n_drone2 + 4)begin
                    pixel_data = dark_grey;
                end
                else if(pixel_j == n_drone2 + 5 || pixel_j == n_drone2 + 7)begin
                    pixel_data = light_blue;
                end
                else if(pixel_j == n_drone2 + 6 || pixel_j == n_drone2 + 8)begin
                    pixel_data = grey;
                end
            end
            //seventh row
            else if(pixel_i == k_drone2 + 6 && pixel_j >= n_drone2 + 4 && pixel_j <= n_drone2 + 9 && drone2_state == 1 && thanos_state == 0)begin
                if(pixel_j == n_drone2 + 4||pixel_j == n_drone2 + 9)begin
                    pixel_data = black;
                end
                else if(pixel_j >= n_drone2 + 5 && pixel_j <= n_drone2 + 8)begin
                    pixel_data = grey;
                end
            end
            //eighth row
            else if (pixel_i == k_drone2 + 7 && pixel_j >= n_drone2 + 3 && pixel_j <= n_drone2 + 11 && drone2_state == 1 && thanos_state == 0)begin
                if (pixel_j >= n_drone2 + 3 && pixel_j <= n_drone2 + 11)begin
                    pixel_data = black;
                end     
            end
            //ninth row
            else if (pixel_i == k_drone2 + 8 && pixel_j >= n_drone2 + 2 && pixel_j <= n_drone2 + 12 && drone2_state == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone2 + 2 || pixel_j == n_drone2 + 12)begin
                    pixel_data = black;
                end
                else if (pixel_j >= n_drone2 + 3 && pixel_j <= n_drone2 + 10)begin
                    pixel_data = dark_grey;
                end
                else if (pixel_j == n_drone2 + 11)begin
                    pixel_data = grey;
                end
            end
            //tenth row
            else if (pixel_i == k_drone2 + 9 && pixel_j >= n_drone2 + 2 && pixel_j <= n_drone2 + 12 && drone2_state == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone2 + 2 || pixel_j == n_drone2 + 4||pixel_j == n_drone2 + 10||pixel_j == n_drone2 + 12)begin
                    pixel_data = black;
                end
                else if(pixel_j == n_drone2 + 3 || pixel_j == n_drone2 + 9)begin
                    pixel_data = dark_grey;
                end
                else if(pixel_j == n_drone2 + 5 || pixel_j == n_drone2 + 7 || pixel_j == n_drone2 + 8||pixel_j==n_drone2 + 11)begin
                    pixel_data = grey;
                end
                else if(pixel_j == n_drone2 + 6)begin
                    pixel_data = light_blue;
                end               
            end
            //eleventh row
            else if(pixel_i == k_drone2 + 10 && pixel_j >= n_drone2 + 2 && pixel_j <= n_drone2 + 12 && drone2_state == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone2 + 2 || pixel_j == n_drone2 + 4||pixel_j == n_drone2 + 10||pixel_j == n_drone2 + 12)begin
                    pixel_data = black;
                end
                else if(pixel_j == n_drone2 + 3 || pixel_j == n_drone2 + 8||pixel_j == n_drone2 + 9)begin
                    pixel_data = dark_grey;
                end 
                else if((pixel_j >= n_drone2 + 5 && pixel_j <= n_drone2 + 7 )||pixel_j == n_drone2 + 11)begin
                    pixel_data = grey;
                end    
            end
            //twelfth row
            else if(pixel_i == k_drone2 + 11 && pixel_j >= n_drone2 + 3 && pixel_j <= n_drone2 + 11 && drone2_state == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone2 + 3||pixel_j == n_drone2 + 4||pixel_j == n_drone2 + 10|| pixel_j == n_drone2 + 11)begin
                    pixel_data = black;
                end
                else if(pixel_j == n_drone2 + 5 || pixel_j == n_drone2 + 8 || pixel_j == n_drone2 + 9)begin
                    pixel_data = dark_grey;
                end
                else if(pixel_j == n_drone2 + 6 || pixel_j == n_drone2 + 7)begin
                    pixel_data = grey;
                end 
            end
            //13th row
            else if(pixel_i == k_drone2 + 12 && pixel_j >= n_drone2 + 3 && pixel_j <= n_drone2 + 11 && drone2_state == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone2 + 3 || pixel_j == n_drone2 + 11)begin
                    pixel_data = light_blue;
                end
                else if (pixel_j >= n_drone2 +4 && pixel_j <= n_drone2 +10)begin
                    pixel_data = black;
                end
            end
            //14th row
            else if(pixel_i == k_drone2 + 13 && pixel_j >= n_drone2 + 4 && pixel_j <= n_drone2 + 10 && drone2_state == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone2 + 4 || pixel_j == n_drone2 + 10 || (pixel_j>=n_drone2 + 6 && pixel_j <= n_drone2 + 8))begin
                    pixel_data = black;
                end
                else if(pixel_j == n_drone2 + 5)begin
                    pixel_data = dark_grey;
                end
                else if(pixel_j == n_drone2 +9)begin
                    pixel_data = grey;
                end 
            end
            //15th row
            else if(pixel_i == k_drone2 + 14 && pixel_j >= n_drone2 + 4 && pixel_j <= n_drone2 + 10 && drone2_state == 1 && thanos_state == 0)begin
                if ((pixel_j >= n_drone2 + 4 && pixel_j <= n_drone2 + 6)|| (pixel_j >= n_drone2 + 8 && pixel_j <= n_drone2 + 10))begin
                    pixel_data = black;
                end
            end
            //16th row
            else if (pixel_i == k_drone2 + 15 && pixel_j >= n_drone2 + 4 && pixel_j <= n_drone2 + 10 && drone2_state == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone2 + 4 || pixel_j == n_drone2 + 6 || pixel_j == n_drone2 + 8 || pixel_j == n_drone2 + 10) begin
                    pixel_data = dark_blue;
                end
                else if (pixel_j == n_drone2 + 5 || pixel_j == n_drone2 + 9)begin
                    pixel_data = light_blue;
                end
                else begin
                    pixel_data = sky;
                end
            end
            //17th row
            else if(pixel_i == k_drone2 + 16 && pixel_j >= n_drone2 + 5 && pixel_j <= n_drone2 + 9 && drone2_state == 1 && thanos_state == 0)begin
                if (pixel_j == n_drone2 + 5 || pixel_j == n_drone2 + 9)begin
                    pixel_data = dark_blue;
                end
                else begin
                    pixel_data = sky;
                end
            end
        //***************************************************THANOS BOSS MODEL****************************************************************
            else if (pixel_i == k_thanos && pixel_j >= n_thanos + 12 && pixel_j <= n_thanos + 17 && thanos_state == 1)begin
                pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
            end 
            else if(pixel_i == k_thanos + 1 && pixel_j >= n_thanos + 11 && pixel_j <= n_thanos + 18 && thanos_state == 1)begin
                if(pixel_j == n_thanos + 11 || pixel_j == n_thanos + 18)begin
                pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else if(pixel_j == n_thanos + 12 || pixel_j == n_thanos + 13 || (pixel_j >= n_thanos + 15 && pixel_j <= n_thanos + 17) && thanos_state == 1)begin
                    pixel_data = blue;
                end
                else if(pixel_j == n_thanos + 14)begin
                    pixel_data = yellow;
                end
            end
            else if(pixel_i == k_thanos + 2 && pixel_j >= n_thanos + 10 && pixel_j <= n_thanos + 19 && thanos_state == 1)begin
                if(pixel_j == n_thanos + 10 || pixel_j == n_thanos + 19)begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else if(pixel_j == n_thanos + 11||pixel_j == n_thanos + 12 || (pixel_j >= n_thanos + 14 && pixel_j <= n_thanos + 18))begin
                    pixel_data = blue;
                end
                else if(pixel_j == n_thanos + 13)begin
                    pixel_data = yellow;
                end
            end
            
            else if(pixel_i == k_thanos + 3 && pixel_j >= n_thanos + 10 && pixel_j <= n_thanos + 19 && thanos_state == 1)begin
                if(pixel_j == n_thanos + 10 || pixel_j == n_thanos + 19)begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else if(pixel_j == n_thanos + 13 || pixel_j == n_thanos + 17)begin
                    pixel_data = yellow;
                end
                else if(pixel_j == n_thanos + 11||pixel_j == n_thanos + 12 || pixel_j == n_thanos + 18 ||(pixel_j >= n_thanos + 14 && pixel_j <= n_thanos + 16))begin
                    pixel_data = blue;
                end
            end
            
            else if(pixel_i == k_thanos + 4 && pixel_j >= n_thanos + 10 && pixel_j <= n_thanos + 19 && thanos_state == 1)begin
                if(pixel_j == n_thanos + 10 || pixel_j == n_thanos + 19)begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else if(pixel_j == n_thanos + 11 ||pixel_j == n_thanos + 13 || pixel_j == n_thanos + 16)begin
                    pixel_data = yellow;
                end
                else if(pixel_j == n_thanos + 12||(pixel_j >= n_thanos + 14 && pixel_j <= n_thanos + 15)||(pixel_j >= n_thanos + 17 && pixel_j <= n_thanos + 18))begin
                    pixel_data = blue;
                end
            end
            
            else if(pixel_i == k_thanos + 5 && pixel_j >= n_thanos + 10 && pixel_j <= n_thanos + 19 && thanos_state == 1)begin
                if(pixel_j == n_thanos + 10 || pixel_j == n_thanos + 19)begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else if(pixel_j >= n_thanos + 17 && pixel_j <= n_thanos + 18)begin
                    pixel_data = blue;
                end
                else if(pixel_j >= n_thanos + 12 && pixel_j <= n_thanos + 15)begin
                    pixel_data = yellow;
                end
                else if(pixel_j == 11 || pixel_j == 16)begin
                    pixel_data = purple;
                end
            end
            
            else if(pixel_i == k_thanos + 6 && pixel_j >= n_thanos + 10 && pixel_j <= n_thanos + 19 && thanos_state == 1)begin
                if(pixel_j == n_thanos + 10 || pixel_j == n_thanos + 19)begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else if(pixel_j == n_thanos + 11 || pixel_j == n_thanos + 15)begin
                    pixel_data = teleport_animation?light_blue:red;
                end
                else if(pixel_j == n_thanos + 18)begin
                    pixel_data = blue;
                end
                else begin
                    pixel_data = purple;
                end
            end
            else if(pixel_i == k_thanos + 7 && pixel_j >= n_thanos + 10 && pixel_j <= n_thanos + 19 && thanos_state == 1)begin
                if(pixel_j == n_thanos + 10 || pixel_j == n_thanos + 19)begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else begin
                    pixel_data = purple;
                end
            end
            
            else if(pixel_i == k_thanos + 8 && pixel_j >= n_thanos + 10 && pixel_j <= n_thanos + 22 && thanos_state == 1)begin
                if(pixel_j == n_thanos + 10 || (pixel_j >= n_thanos + 18 && pixel_j <= n_thanos + 22))begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else if(pixel_j >= n_thanos + 12 && pixel_j <= n_thanos + 14)begin
                    pixel_data = white;
                end
                else begin
                    pixel_data = purple;
                end
            end
            else if(pixel_i == k_thanos + 9 && pixel_j >= n_thanos + 2 && pixel_j <= n_thanos + 23 && thanos_state == 1)begin
                if((pixel_j >= n_thanos + 2 && pixel_j <= n_thanos + 5)||(pixel_j >= n_thanos + 8 && pixel_j <= n_thanos + 11)||pixel_j == n_thanos + 18 || pixel_j == n_thanos + 23)begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else if(pixel_j==n_thanos + 19||pixel_j==n_thanos+20)begin
                    pixel_data = yellow;
                end
                else if(pixel_j==n_thanos+13||pixel_j==n_thanos+15)begin
                    pixel_data = dark_purple;
                end
                else if(pixel_j == n_thanos + 6||pixel_j == n_thanos + 7)begin
                    pixel_data = ultistate?light_blue:sky;
                end
                else begin
                    pixel_data = purple;
                end
            end
            else if(pixel_i == k_thanos + 10 && pixel_j >= n_thanos + 1 && pixel_j <= n_thanos + 24 && thanos_state == 1)begin //start of thanos hand
                if(pixel_j==n_thanos + 1||(pixel_j >= n_thanos + 5 && pixel_j<=n_thanos+7)||(pixel_j >= n_thanos + 12 && pixel_j<=n_thanos+17)||pixel_j==n_thanos + 24)begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else if(pixel_j==n_thanos+2||(pixel_j>=n_thanos + 21 && pixel_j<=n_thanos + 23))begin
                    pixel_data = blue;
                end
                else if(pixel_j==n_thanos + 8 || pixel_j == n_thanos +9)begin
                    pixel_data = darkest_blue;
                end
                else if(pixel_j==n_thanos +3||pixel_j==n_thanos+4||pixel_j==n_thanos+10||pixel_j==n_thanos+19||pixel_j==n_thanos+20)begin
                    pixel_data = yellow;
                end
                else begin
                    pixel_data = dark_yellow;
                end
            end
            else if(pixel_i == k_thanos + 11 && pixel_j >= n_thanos + 1 && pixel_j <= n_thanos + 24 && thanos_state == 1)begin //middle of thanos hand
                if(pixel_j==n_thanos + 1||pixel_j==n_thanos + 24)begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else if(pixel_j == n_thanos + 2)begin
                    pixel_data = purple;
                end
                else if (pixel_j == n_thanos + 9)begin
                    pixel_data = darkest_blue;
                end
                else if(pixel_j >= n_thanos + 12 && pixel_j<=n_thanos+17)begin
                    pixel_data = dark_yellow;
                end
                else if((pixel_j>= n_thanos + 6 && pixel_j<= n_thanos + 8)||(pixel_j>= n_thanos + 20 && pixel_j<= n_thanos + 23))begin
                    pixel_data = blue;
                end
                else begin
                    pixel_data = yellow;
                end
            end
            else if(pixel_i == k_thanos + 12 && pixel_j >= n_thanos + 1 && pixel_j <= n_thanos + 24 && thanos_state == 1)begin //end of thanos hand
                if(pixel_j==n_thanos + 1||pixel_j==n_thanos + 24)begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else if(pixel_j >= n_thanos + 20 && pixel_j<=n_thanos+22)begin
                    pixel_data = darkest_blue;
                end
                else if(pixel_j >= n_thanos + 13 && pixel_j<=n_thanos+16)begin
                    pixel_data = dark_yellow;
                end
                else if(pixel_j==n_thanos+11||pixel_j==n_thanos+12||pixel_j==n_thanos+17||pixel_j==n_thanos+18||(pixel_j >= n_thanos + 2 && pixel_j <=n_thanos + 5))begin
                    pixel_data = yellow;
                end
                else begin
                    pixel_data = blue;
                end
            end
            else if(pixel_i == k_thanos + 13 && pixel_j >= n_thanos + 2 && pixel_j <= n_thanos + 24 && thanos_state == 1)begin
                if((pixel_j>=n_thanos + 2 && pixel_j<=n_thanos+9)||(pixel_j==n_thanos+21)||(pixel_j==n_thanos+24))begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else if(pixel_j >= n_thanos + 12 && pixel_j <= n_thanos + 17)begin
                    pixel_data = yellow;
                end
                else if(pixel_j==n_thanos+20||pixel_j==n_thanos+22)begin
                    pixel_data = darkest_blue;
                end
                else begin
                    pixel_data = blue;
                end
            end
            else if(pixel_i == k_thanos + 14 && pixel_j >= n_thanos + 9 && pixel_j <= n_thanos + 24 && thanos_state == 1)begin
                if(pixel_j==n_thanos+9||pixel_j==n_thanos+21||pixel_j==n_thanos+24)begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else if((pixel_j>=n_thanos +10 && pixel_j<=n_thanos+18)||(pixel_j == n_thanos+23))begin
                    pixel_data = blue;
                end
                else begin
                    pixel_data = darkest_blue;
                end
            end
            else if(pixel_i == k_thanos + 15 && pixel_j >= n_thanos + 9 && pixel_j <= n_thanos + 23 && thanos_state == 1)begin
                if(pixel_j == n_thanos + 9||pixel_j == n_thanos + 21||pixel_j == n_thanos + 23)begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else if(pixel_j==n_thanos+13||pixel_j==n_thanos+14||pixel_j==n_thanos+19||pixel_j==n_thanos+22)begin
                    pixel_data = blue;
                end
                else begin
                    pixel_data = darkest_blue;
                end
            end
            else if(pixel_i == k_thanos + 16 && pixel_j >= n_thanos + 10 && pixel_j <= n_thanos + 23 && thanos_state == 1)begin
                if(pixel_j == n_thanos + 10||(pixel_j >= n_thanos + 21 && pixel_j <= n_thanos + 23))begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else if(pixel_j>=n_thanos+11 && pixel_j<=n_thanos+19)begin
                    pixel_data = blue;
                end
                else begin
                    pixel_data = darkest_blue;
                end
            end
            else if(pixel_i == k_thanos + 17 && pixel_j >= n_thanos + 11 && pixel_j <= n_thanos + 21 && thanos_state == 1)begin
                if(pixel_j==n_thanos+11||pixel_j==n_thanos+20||pixel_j==n_thanos+21)begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else if(pixel_j==n_thanos+19)begin
                    pixel_data = darkest_blue;
                end
                else begin
                    pixel_data = blue;
                end
            end
            else if(pixel_i == k_thanos + 18 && pixel_j >= n_thanos + 11 && pixel_j <= n_thanos + 20 && thanos_state == 1)begin
                if(pixel_j==n_thanos+11||pixel_j==n_thanos+20)begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else if(pixel_j==n_thanos+19)begin
                    pixel_data = darkest_blue;
                end
                else begin
                    pixel_data = blue;
                end
            end
            else if(pixel_i==k_thanos+19 && pixel_j >= n_thanos + 11 && pixel_j <= n_thanos + 20 && thanos_state == 1)begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
            end
            else if(pixel_i==k_thanos+20 && pixel_j >= n_thanos + 11 && pixel_j <= n_thanos + 20 && thanos_state == 1)begin 
                if(pixel_j==n_thanos+11||pixel_j==n_thanos+20||(pixel_j>=n_thanos+14 && pixel_j<=n_thanos+16))begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else begin
                    pixel_data = darkest_blue;
                end
            end
            else if(pixel_i==k_thanos+21 && pixel_j >= n_thanos + 11 && pixel_j <= n_thanos + 20 && thanos_state == 1)begin 
                if(pixel_j==n_thanos+11||pixel_j==n_thanos+20||(pixel_j>=n_thanos+14 && pixel_j<=n_thanos+16))begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else begin
                    pixel_data = darkest_blue;
                end
            end
            //left leg row 22
            else if(pixel_i==k_thanos+22 && pixel_j >= n_thanos + 11 && pixel_j <= n_thanos + 20 && thanos_state == 1)begin    
                if(pixel_j == n_thanos + 11||pixel_j==n_thanos+14||pixel_j == n_thanos + 16||pixel_j==n_thanos+20)begin
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else if(pixel_j == n_thanos+12||pixel_j==n_thanos+13||(pixel_j >= n_thanos + 17 && pixel_j <= n_thanos + 19))begin
                    pixel_data = dark_yellow;
                end
                else begin
                    pixel_data = ultistate?light_blue:sky;
                end
            end

            else if(pixel_i==k_thanos+23 && pixel_j >= n_thanos + 11 && pixel_j <= n_thanos + 20 && thanos_state == 1)begin
                if((pixel_j >= n_thanos + 11 && pixel_j <= n_thanos + 14)||(pixel_j >= n_thanos + 16 && pixel_j <= n_thanos + 20))begin    
                    pixel_data = (teleport_animation)?light_blue:(thanos_peeew_anim)?dark_purple:(thanos_heal)?green:black;
                end
                else begin
                    pixel_data = ultistate?light_blue:sky;
                end
            end
            else begin
                pixel_data = ultistate? light_blue: sky;
            end
        end
    end

 
//************************************************************************************************************************
//*******************************************************SUBTASK 1A TO 2B*************************************************
//************************************************************************************************************************
    else begin
        if (reset == 1)begin
            n_t = 40;
            k_t = 56;
            count = 0;
        end
        if(RBUTTON ==1) begin
         if(count==100000 && k_t<95)begin
             n_t=n_t+1;
             k_t=k_t+1;
             count=0;
         end
         else begin
             count=count+1;
         end
 
         if(k_t>=95)begin
             count=0;
         end
     end
 
     if(LBUTTON ==1) begin
         if(count==100000 && n_t>0)begin
             n_t=n_t-1;
             k_t=k_t-1;
             count=0;
         end
         else begin
             count=count+1;
         end
 
         if(n_t<=0)begin
             count=0;
         end
     end
 
 //top red bar
     if(led[15]==1 && sw[14]==0 && sw[15]==0 && sw[13]==0 && pixel_i>=0 && pixel_i <=2 && pixel_j>n_t && pixel_j < k_t)begin
             pixel_data = sw[12]? ~red:red;
         //pixel_data = sw12? ~16'b1111100000000000: 16'b1111100000000000;
         end
     
         else if(led[15]==1 && sw[15]==1 && sw[13]==0 && pixel_i>=1 && pixel_i <=2 && pixel_j>n_t && pixel_j < k_t)begin
             pixel_data = sw[12]? ~red:red;
         end
     
     
     //2nd from top red bar
         else if(led[14]==1 && sw[13]==0 && pixel_i>=4 && pixel_i <=6 && pixel_j>n_t && pixel_j < k_t)begin
             pixel_data = sw[12]? ~red:red;
         end
     
     //3nd from top red bar
         else if(led[13]==1 && sw[13]==0 && pixel_i>=8 && pixel_i <=10 && pixel_j>n_t && pixel_j < k_t)begin
             pixel_data = sw[12]?~red:red;
         end
     
     //4th from top red bar
         else if(led[12]==1 && sw[13]==0 && pixel_i>=12 && pixel_i <=14 && pixel_j>n_t && pixel_j < k_t)begin
             pixel_data = sw[12]?~red: red;
         end
     
     //5th from the top red bar
         else if(led[11]==1 && sw[13]==0 && pixel_i>=16 && pixel_i <=18 && pixel_j>n_t && pixel_j < k_t)begin
             pixel_data = sw[12]?~red: red;
         end
     
     
     //1st from the top yellow bar
         else if(led[10]==1 && sw[13]==0 && pixel_i>=20 && pixel_i <=22 && pixel_j>n_t && pixel_j < k_t)begin
             pixel_data = sw[12]?~yellow:yellow;
         end
         
     //2nd from the top yellow bar
         else if(led[9]==1 &&sw[13]==0 && pixel_i>=24 && pixel_i <=26 && pixel_j>n_t && pixel_j < k_t)begin
             pixel_data = sw[12]?~yellow:yellow ;
         end
         
     //3rd from the top yellow bar
         else if(led[8]==1 && sw[13]==0 && pixel_i>=28 && pixel_i <=30 && pixel_j>n_t && pixel_j < k_t)begin
             pixel_data = sw[12]?~yellow:yellow ;
         end
     
     //4th from the top yellow bar
         else if(led[7]==1 && sw[13]==0 && pixel_i>=32 && pixel_i <=34 && pixel_j>n_t && pixel_j < k_t)begin
             pixel_data = sw[12]?~yellow:yellow ;
         end
     
     //5th from the top yellow bar
         else if(led[6]==1 && sw[13]==0 && pixel_i>=36 && pixel_i <=38 && pixel_j>n_t && pixel_j < k_t)begin
             pixel_data = sw[12]?~yellow:yellow ;
         end
     
     //1st from the top green bar
         else if(led[5]==1 && sw[13]==0 && pixel_i>=40 && pixel_i <=42 && pixel_j>n_t && pixel_j < k_t)begin
             pixel_data = sw[12]? ~green:green ;
         end
     
     //2nd from the top green bar
         else if(led[4]==1 && sw[13]==0 && pixel_i>=44 && pixel_i <=46 && pixel_j>n_t && pixel_j < k_t)begin
             pixel_data = sw[12]? ~green: green ;
         end
         
         //3rd from the top green bar
         else if(led[3]==1 && sw[13]==0 && pixel_i>=48 && pixel_i <=50 && pixel_j>n_t && pixel_j < k_t)begin
             pixel_data = sw[12]? ~green: green ;
         end
     
     //4th from the top green bar
         else if(led[2]==1 && sw[13]==0 && pixel_i>=52 && pixel_i <=54 && pixel_j>n_t && pixel_j < k_t)begin
             pixel_data = sw[12]? ~green: green ;
         end
         
         //5th from the top green bar
         else if(led[1]==1 && sw[13]==0 && pixel_i>=56 && pixel_i <=58 && pixel_j>n_t && pixel_j < k_t)begin
             pixel_data = sw[12]? ~green: green ;
         end
         
         //6th from the top green bar
         else if(led[0]==1 && sw[14]==0 && sw[13]==0 && pixel_i>=60 && pixel_i <=62 && pixel_j>n_t && pixel_j < k_t)begin
             pixel_data = sw[12]? ~green: green ;
         end
     
          else if(sw[14]==1)begin
             if(pixel_i>=60 && pixel_i <=63)begin
                 pixel_data = sw[12]? black :white ;
             end
             else if(pixel_i>=0 && pixel_i <=3)begin
                 pixel_data = sw[12]?  black :white;
             end
         
             else if(pixel_j>=92 && pixel_j <=95) begin
                 pixel_data = sw[12]?  black :white;
             end
             
             else if(pixel_j>=0 && pixel_j <=3)begin
                 pixel_data = sw[12]?  black :white;
             end
             
             else begin
                 pixel_data = sw[12]? ~0:0;
             end
         
         end //end of sw14
         
         
          else if(sw[15]==1)begin
             if(pixel_i==0)begin
                 pixel_data = sw[12]?  black :white;
             end
             else if(pixel_i== 63)begin
                 pixel_data = sw[12]?  black :white ;
             end
             else if(pixel_j==0) begin
                 pixel_data = sw[12]?  black :white;
             end
             else if(pixel_j==95)begin
                 pixel_data = sw[12]?  black :white;
             end
             else begin
                 pixel_data = sw[12]? ~0:0;
             end
         end //end of sw15.
         
         
         else begin
             pixel_data = sw[12]? ~0:0;
         end
         
     end    
 end
endmodule
