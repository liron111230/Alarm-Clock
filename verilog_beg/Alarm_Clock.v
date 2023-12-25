`include "clock_timer.v"
`include "Alarm_block.v"


module Alarm_Clock (
    input [15:0] set_Clock,
    input [15:0] set_Alarm,                   
    input clk,               // 1 KHz Clock 
    input reset,
    input off_Alarm,
    input [3:0] dur_Alarm,                          
    output [15:0] Clock,
    output wire Alarm  
 );



wire [15:0]cur_time_W;
assign Clock = cur_time_W;

wire clk_min_w;

clock_timer clock_timer (.set_Clock(set_Clock),.clk(clk),.reset(reset),.cur_time(cur_time_W),.clk_min(clk_min_w));

Alarm_block Alarm_block (.set_Alarm(set_Alarm),.cur_time(cur_time_W),.clk(clk),.reset(reset),.off_Alarm(off_Alarm),
                    .dur_Alarm(dur_Alarm),.Alarm(Alarm),.clk_min(clk_min_w));



    
endmodule