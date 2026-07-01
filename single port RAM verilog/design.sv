// Code your design here
module single_port_sync_ram #(
  parameter ADDR_WIDTH=4, DATA_WIDTH=32,DATA_DEPTH=(2**ADDR_WIDTH))(
   input clk,
   input we,
   input oe, 
   input cs,
   input [ADDR_WIDTH-1:0] addr,
   input [DATA_WIDTH-1:0] data_in,//write
   output reg [DATA_WIDTH-1:0] data_out//read
);
  reg [DATA_WIDTH-1:0] memory_data[DATA_DEPTH-1:0];
  
  always @(posedge clk) //write data
    begin
      if (cs)
        begin
          if (we)
            memory_data[addr]<=data_in;
          else if (oe)
        data_out<=memory_data[addr];
        end
    end
endmodule
  
    
  