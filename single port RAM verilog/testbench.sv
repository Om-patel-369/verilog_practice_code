// Code your testbench here
// or browse Examples
module tb;

  parameter ADDR_WIDTH=4, DATA_WIDTH=32,DATA_DEPTH=(2**ADDR_WIDTH);
  
  reg clk,cs,we,oe;
  reg [ADDR_WIDTH-1:0] addr;
  reg [DATA_WIDTH-1:0] data_in;
  wire [DATA_WIDTH-1:0] data_out;
  
  integer i;
  integer errorcount;
  
  reg [DATA_WIDTH-1:0] exp_mem [DATA_DEPTH-1:0];//for comparison
  
  single_port_sync_ram  #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) dut(
    .clk(clk),
    .addr(addr),
    .data_in(data_in),
    .data_out(data_out),
    .cs(cs),
    .we(we),
    .oe(oe)
  );
  
  initial  clk=0; //clock generation
  always #5  clk=~clk; 
  
  initial 
    begin
      cs=0;we=0;oe=0;addr=0;data_in=0;errorcount=0;//initial values
      
       //write check
      
      for (i=0; i<DATA_DEPTH; i=i+1)
          begin
          @(posedge clk);
            cs=1;we=1;oe=0;addr<=i;data_in=$random;
            exp_mem[i]=data_in;//stores exp value
          end
      
      @(posedge clk);we=0;cs=0;
      
      //read check
      for (i=0; i<DATA_DEPTH; i=i+1)
        begin
          @(posedge clk);
           cs<=1; we<=0; oe<=1;addr<=i;
          
          @(posedge clk);
 
            if (data_out !== exp_mem[i])
              begin
        $display("ERROR at addr %0d: Expected = %h, Got = %h",
                  i, exp_mem[i], data_out);
        errorcount = errorcount + 1;
      end
      else begin
        $display("PASS  at addr %0d: Data = %h",
                  i, data_out);
      end
    end
      
      if (errorcount == 0)
      $display("\nALL TESTS PASSED ");
    else
      $display("\nTEST FAILED  Errors = %0d", errorcount);

      
       #50 $finish;
      end
endmodule
  
  
            
            
              
    