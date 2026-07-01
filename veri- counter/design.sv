// Code your design here
module shiftreg #(parameter N=4) (
  input clk,
  input reset,
  input en,
  output reg [N-1:0]count
);
  
  always@(posedge clk) begin
    if (reset)
      count<=0;
  else
    count<=count+1;
  end
endmodule



  