module clock_timer (
    input [15:0] set_Clock,
    input clk,
    input reset,
    output reg [15:0] cur_time,
    output reg clk_min     //  clock for minutes
);


reg [15:0] clk_ups_count;


always @(posedge clk, posedge reset) begin      // generate clk for minutes
    if (reset)begin
        clk_ups_count <=0;
        clk_min <=0;
    end
    else if (clk_ups_count == 16'hea5f) begin  // 1,000 CLK cycles (per sec) * 60 sec = 60,000 (16'hea5f = 59,999)
        clk_ups_count <= 0;
        clk_min <= ~clk_min;
    end
    else
        clk_ups_count <= clk_ups_count + 16'd1; 
end




wire [3:0] lo_min_cur,hi_min_cur,lo_ho_cur,hi_ho_cur;

assign {hi_ho_cur,lo_ho_cur,hi_min_cur,lo_min_cur} = cur_time;

always @(posedge clk_min,negedge clk_min) begin     // clock counter cycle 
   if (hi_ho_cur == 4'd2) begin
      cur_time <= (lo_min_cur + 4'd1 <= 4'd9) ? {hi_ho_cur, lo_ho_cur, hi_min_cur, lo_min_cur + 4'd1} : 
                  (hi_min_cur + 4'd1 <= 4'd5) ? {hi_ho_cur, lo_ho_cur, hi_min_cur + 4'd1, 4'd0}:
                  (lo_ho_cur  + 4'd1 <= 4'd3) ? {hi_ho_cur, lo_ho_cur + 4'd1, 8'd0}: {16'd0};
   end

   else begin
      cur_time <= (lo_min_cur + 4'd1 <= 4'd9) ? {hi_ho_cur, lo_ho_cur, hi_min_cur,lo_min_cur + 4'd1} : 
                  (hi_min_cur + 4'd1 <= 4'd5) ? {hi_ho_cur, lo_ho_cur, hi_min_cur + 4'd1, 4'd0}:
                  (lo_ho_cur  + 4'd1 <= 4'd9) ? {hi_ho_cur, lo_ho_cur + 4'd1, 8'd0}:{hi_ho_cur + 4'd1, 12'd0};                 
   end
end


always @(posedge clk, posedge reset) begin   // set and reset cur_time block
   if (reset) 
      cur_time <= 16'h0;
    
   else if (|set_Clock) begin
      cur_time <= set_Clock;
      clk_ups_count <= 16'd0;
   end
end
    
endmodule