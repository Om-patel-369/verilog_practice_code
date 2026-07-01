// Code your design here
module seqdet (
  input reset,
  input clk,
  input din,
  output reg y
);
  
  reg [1:0] state,nstate;
  
  parameter S0=2'b00,S1=2'b01,S2=2'b10, S3=2'b11;
  
  //state register
  
  always@(posedge clk) begin
    if (reset)
      state<=S0;
  else 
    state<=nstate;
  end
  
  //next state logic
  
  always@(*) begin
    nstate=state;
    y=0;
    
    case (state)
      S0: begin
        if (din)
        nstate=S1;
      end
    
      
      S1: begin
        if(!din)
          nstate=S2;
       
      end
        
        S2: begin
          if (din)
            nstate=S3;
          else
            nstate=S0;
        end
          
      S3: begin
        if (din) begin            
          y=1;
        nstate=S1;end
          else
            nstate=S2;
        end
    endcase
  end
endmodule
    
    
      
        
      
  