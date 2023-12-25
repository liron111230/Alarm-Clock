module Alarm_block (
    input [15:0] set_Alarm,
    input [15:0] cur_time,                   
    input clk,
    input clk_min,    //  clock for minutes
    input reset,
    input off_Alarm,
    input [3:0] dur_Alarm,                          
    output reg Alarm
);

reg [14:0] cur_Alarm;
wire ena;
assign ena = set_Alarm[15];


always @(posedge clk) begin     // set alarm 
    if (ena) 
        cur_Alarm <= set_Alarm[14:0];  
end

always @(posedge clk_min, negedge clk_min) begin          // check if Is it time to turn on the alarm
    //repeat (5) @(posedge clk);
    #5 if (cur_Alarm == cur_time[14:0])begin 
        Alarm <= 1;
    end 
end


reg [19:0] timeleft_Alarm;

always @(posedge Alarm) begin
    timeleft_Alarm <= 20'd1000 * 20'd60 * dur_Alarm;    //1,000 cycles per second * 60 seconds per minute 
end

always @(posedge clk, posedge reset) begin     // Checking if the time for the alarm ended or 'off'  has been pressed 
    if (timeleft_Alarm == 0 | off_Alarm | reset) begin
       Alarm <= 0;
       timeleft_Alarm <= 0;
    end

    else begin
       timeleft_Alarm <= timeleft_Alarm - 20'd1 ;
       Alarm <= 1;
    end
end

endmodule




