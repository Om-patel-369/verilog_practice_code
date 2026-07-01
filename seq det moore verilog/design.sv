// Code your design here
module seqdetmoore (
  input reset,
  input clk,
  input din,
  output reg y
);
  
  reg [2:0] state,nstate;
  
  parameter S0=3'b000,S1=3'b001,S2=3'b010, S3=3'b011, S4=3'b100;
  
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
    
    case (state)
      S0:if (din) nstate=S1; 
      S1:if(!din) nstate=S2;
      S2:if (din) nstate=S3;
          else nstate=S0;
          
      S3: if (din) nstate=S4;
          else nstate=S2;
      S4: if (din) nstate=S1;
          else nstate=S2;
    endcase
    end

    //output logic
    
    always@(*) begin
      if (state==S4)
        y=1;
      else 
        y=0;
    end
    
 
endmodule
    
    
      
        
      
  