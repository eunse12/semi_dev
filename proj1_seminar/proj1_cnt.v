//`define DATABIT 7

module proj1_cnt#(
  parameter integer DATABIT = 7	// (default value = 7)
) (
  input                   clk,
  input                   reset_n,
  input  [DATABIT-1:0]    i_num_cnt,
  input                   i_run,
  output                  o_idle,
  output                  o_running,
  output                  o_done,
  output [DATABIT-1:0]    o_data
);

//-----------------------------------------------------------------
// Description : FSM
//-----------------------------------------------------------------
 
  localparam  IDLE    = 3'b001;
  localparam  RUN     = 3'b010;
  localparam  DONE    = 3'b100;

  reg [2:0] n_state;
  reg [2:0] c_state;

  wire is_done;

  always @(*)begin
    case(c_state)
      IDLE    : begin
                  if(s_ready)begin
                    n_state = RUN;
                  end
                end
      RUN     : begin
                  if(is_done)begin
                    n_state = DONE;
                  end
                end 
      DONE    : begin
                  n_state = IDLE;
                end
      default : n_state = c_state;    
    endcase
  end

  always @(posedge clk or negedge reset_n)begin
    if(!reset_n)begin
      c_state <=  IDLE;
    end else begin
      c_state <=  n_state;
    end
  end

  assign o_idle     = (c_state == IDLE);
  assign o_running  = (c_state == RUN);
  assign o_done     = (c_state == DONE);
  

//-----------------------------------------------------------------
// Description : CORE
//-----------------------------------------------------------------

  reg [DATABIT-1:0] r_data;
  reg [DATABIT-1:0] c_r_data;

  always @(posedge clk or negedge reset_n)begin
    if(!reset_n)begin
      c_r_data  <=  0;
    end else if(i_run)begin
      c_r_data  <=  i_num_cnt;
    end else begin
      if(o_done)begin
        c_r_data  <=  0;
      end
    end
  end

  always @(posedge clk or negedge reset_n)begin
    if(!reset_n)begin
        r_data  <=  0;
    end else if(o_running)begin
        r_data  <=  r_data + 1;
    end else begin
      if(is_done)begin
        r_data  <=  0;
      end
    end
  end


  assign is_done  = (o_running) && (r_data != c_r_data-1);
  assign o_data   = r_data;

endmodule