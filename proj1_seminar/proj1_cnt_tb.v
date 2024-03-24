module tb_top();

reg                   clk;
reg                   reset_n;
reg   [DATABIT-1:0]   i_num_cnt;
reg                   i_run;
wire                  o_idle;
wire                  o_running;
wire                  o_done;
wire  [DATABIT-1:0]   o_data;


always @begin
  #5 clk = ~clk;
end

initial begin
  $display("Initialize value[%d]", $time);
    clk       <= 0;
    reset_n   <= 1;
    i_num_cnt <= 0;
    i_run     <= 0;  

  $display("RESET[%d]", $time);
  @posedge(clk);
    reset_n   <= 0;  
  @posedge(clk);
    reset_n   <= 1;
  @posedge(clk);

  $display("Wait IDLE[%d]",$time);
  wait(o_idle);

  $display("START![%d]", $time);
    i_num_cnt <= 100;
    i_run     <=  1;
  @posedge(clk);
    i_run     <=  0;
  repeat(100)begin
    @posedge(clk);
  end

  $display("DONE![%d]", $time);
  wait(o_done);

  #200
  $display("FINISH[%d]", $time);
  $finish;
end



proj1_cnt U_svproj1_cnt(
.clk            (clk),
.reset_n        (reset_n),
.i_num_cnt      (i_num_cnt),
.i_run          (i_run),
.o_idle         (o_idle),
.o_running      (o_running),
.o_done         (o_done),
.o_data         (o_data)
);




endmodule