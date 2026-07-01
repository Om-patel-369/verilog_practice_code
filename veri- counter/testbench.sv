// Code your testbench here
// or browse Examples
module tb;
  parameter N=4;
  reg clk;
  reg reset;
  wire [N-1:0] count;
  
  
  reg [N-1:0]exp_count;
  integer error=0;
  integer pass=0;
  
  counter #(.N(N)) dut (
    .clk(clk),
    .reset(reset),
    .count(count)
  );
  
initial
  begin
    clk=0;
    forever #5 clk=~clk;
  end
  
  always@(posedge clk)
    begin
      if (reset)
        exp_count<=0;
      else
        exp_count<=exp_count+1;
    end
  
  always@(posedge clk) begin
    #1;
    if (count!==exp_count) begin
      $display ("ERROR: Time=%0t exp=%0d count=%d",
                $time, exp_count, count);
    error++;
    end
  else 
    pass++;
  end
  
  initial begin
    reset=1;
    exp_count=0;
    
    #12 reset=0;
    #100;
    
    
    $display (" total error=%0d", error);
    $display (" total pass=%0d", pass);
    
    
    $finish;
  end
  endmodule
    
    
  
  
  