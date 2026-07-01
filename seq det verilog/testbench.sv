// Code your testbench here
// or browse Examples
module tb;
  reg reset;
  reg clk;
  reg din;
  wire y;
  
integer i;
integer error=0;
  
  reg [6:0]stimulus= 7'b1011011;//known i/p
  reg [6:0]exp= 7'b0001001;//known o/p
  
  seqdet dut (
    .clk(clk),
    .reset(reset),
    .din(din),
    .y(y)
  );
  
  initial clk=0;
      always #5 clk=~clk;
  
  initial
    begin
      reset=1;
      din=0;
      
      #12 reset=0;
      
      for (i=6;i>=0;i=i-1) begin
        @(negedge clk);
        din= stimulus [i];
        
        #1;
        
        if (y!==exp[i]) begin
          $display (" ERROR at bit %0d | din=%b y=%b exp=%b",i,din,y,exp[i]);
          error++; end
          else begin
            $display ("PASSat bit %0d | din=%b y=%b exp=%b",i,din,y,exp[i]);
        end
        
        @(posedge clk);
      end
      
      $display ("TOTAL ERROR=%0d",error);
      $finish;
    end
endmodule
          
        
        
        
    
  
  
  
  