
module test;

  /* Make a reset that pulses once. */
  reg reset = 0;
  initial begin
     # 1 reset = 1;
     # 1 reset = 0;
	 `include "din.v"
     # 1 $finish();
  end

  /* Make a regular pulsing clock. */
  reg clk = 0;
  always
	  #1 clk = !clk;

  wire [23:0] val;
  reg din = 0;
  cic c1 (reset, clk, din, val);


  initial begin
	  $dumpfile("cic.vcd");
	  $dumpvars(0, c1);
  end


endmodule;
