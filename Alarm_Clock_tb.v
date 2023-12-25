`timescale 1ms/1us
`include "Alarm_Clock.v"

module Alarm_Clock_tb;
reg  [15:0] set_Clock,set_Alarm;                   
reg  clk,reset,off_Alarm;
reg  [3:0] dur_Alarm;                          
wire [15:0] Clock;
wire Alarm;

Alarm_Clock utt (.set_Clock(set_Clock),.set_Alarm(set_Alarm),.clk(clk),.reset(reset),.off_Alarm(off_Alarm),
                 .dur_Alarm(dur_Alarm),.Clock(Clock),.Alarm(Alarm));

initial begin                
    
    clk = 1;
    forever begin
        #0.5 clk = ~clk;       // 1msec cycle
    end
end

initial begin
    $dumpfile("Alarm_Clock_tb.vcd");
    $dumpvars(0, Alarm_Clock_tb);
    

    reset = 0;                     
    set_Clock = 0;
    set_Alarm = 0;
    off_Alarm = 0;
    dur_Alarm = 0;

    @(posedge clk)
    reset <= #0.1 1;

    @(posedge clk)
    #0.1 reset = 0;

    @(posedge clk)
    #0.1 set_Clock = 16'h1232;       // set Clock to 12:32
    set_Alarm = 16'h8000 + 16'h1308; // ena + set Alarm to 13:08 
    dur_Alarm = 4'd8;                // set duration to 8 min

    @(posedge clk)
    #0.1 set_Alarm = 0;              // ena off
    set_Clock = 0;
    @(negedge Alarm)
    repeat (3000) @(posedge clk);


    #0.1 set_Alarm = 16'h8000 + 16'h1320;  // ena + set Alarm to 13:20
    @(posedge clk)
    #0.1 set_Alarm = 0;
    @(posedge Alarm);
    repeat (150000) @(posedge clk);
    //#0.1 off_Alarm = 1;                        // Turn off the alert            
    @(posedge clk)
    //#0.1 off_Alarm = 0;
    repeat (30000) @(posedge clk);
    #0.1 set_Clock = 16'h2358;       // set Clock to 23:58
    @(posedge clk)
    #0.1 set_Clock = 0;
    repeat (200000) @(posedge clk);
    



    $display("Simulation complete");
    $finish;
end

endmodule