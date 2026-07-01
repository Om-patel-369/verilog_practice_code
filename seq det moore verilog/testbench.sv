// Code your testbench here
// or browse Examples
module tb;
  reg clk;
  reg reset;
  reg din;
  wire y;
  
  integer i;
  integer error=0;
  integer pass=0;
  reg [6:0] stimulus=7'b1011011;
  
  
  seqdetmoore dut (
    .clk(clk),
    .reset(reset),
    .din(din),
    .y (y)
  );
  
  initial clk=0;
    always #5 clk=~clk;
  
  //ref model( golden FSM) 
  
  reg [2:0] tbstate,tbnstate;
  reg exp_y;
  
  parameter S0=3'b000,S1=3'b001,S2=3'b010, S3=3'b011, S4=3'b100;
 
  always@(posedge clk) begin
    if (reset)
      tbstate<=S0;
  else 
    tbstate<=tbnstate;
  end
  
  always@(*) begin
    tbnstate=tbstate;
    
    case (tbstate)
      S0:if (din) tbnstate=S1; 
      S1:if(!din) tbnstate=S2;
      S2:if (din) tbnstate=S3;
          else tbnstate=S0;
          
      S3: if (din) tbnstate=S4;
          else tbnstate=S2;
      S4: if (din) tbnstate=S1;
          else tbnstate=S2;
    endcase
    end
  always@(*) begin
    if (tbstate==S4)
        exp_y=1;
      else 
        exp_y=0;
    end
   
  //checker
  
  always@(posedge clk) begin
    #1;
    
    if (y!==exp_y) begin
   $display("ERROR @%0t | din=%b y=%b exp=%b",
                $time, din, y, exp_y); end
      else begin
        pass++;end
  end
  
  initial begin
    reset=1;
    din=0;
    
    #12 reset=0;
    
    
    for (i=6; i>=0 ; i=i-1) begin
      @(negedge clk);
      din = stimulus[i];
    end
    
    #20;
                
    $display ("total ERRORS=%0d",error);
    $display ("total PASS=%0d",pass);
    
    $finish;
  end
    endmodule
                  
      
      
     
    
  