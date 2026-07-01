// Code your design here
module i2c_slave(
  
  input wire scl,
  inout wire sda
);
  
  localparam SLAVE_ADDR=  7'b1010001;

  //open drain SDA
  
  reg sda_drive_low,drive_value;
  
  //assign sda= (sda_drive_low ) ? 1'b0 : 1'bz;
  assign sda= (sda_drive_low ) ? drive_value : 1'bz;
  
  //registers
  
  reg [7:0] shift_reg;
  reg rw_bit;
  reg [7:0] tx_data = 8'h3c;
  reg [3:0] bit_counter;
  reg address_match;
  reg sda_prev;
  reg start_detected, stop_detected;
  
  //start/stop detect.
  
  always@(posedge scl)
    sda_prev<=sda;
  
wire start_condition = (scl == 1 && sda_prev == 1 && sda == 0);
wire stop_condition  = (scl == 1 && sda_prev == 0 && sda == 1);
  
  
  //FSM states
  
  localparam IDLE      =0;
  localparam ADDR      =1;
  localparam ACK_ADDR  =2;
  localparam WRITE     =3;
  localparam READ      =4;
  localparam WAIT_ACK  =5;
  localparam ACK_WRITE =6;
  
  reg [2:0]state;
  
  initial begin
  state = IDLE;
  bit_counter = 0;
  shift_reg = 0;
  address_match = 0;
  rw_bit = 0;
  sda_drive_low = 0;
  end
  
  
  
  //main state transitions
  
  always@(*)begin
    if(start_condition) begin
      start_detected = 1'b1;
    end
    if(stop_condition) begin
      $display("---------STOP CONDITION--------------");
       stop_detected = 1'b1;
    end
  end
  
  always @(posedge scl,start_detected,stop_detected) begin
    
    if (stop_detected)begin
      state<=IDLE;
      $display("STop detect thayuuuuuuu");
      sda_drive_low<=0;
      bit_counter<=0;
      stop_detected = 0;
    end
    else begin
      
  $display("T=%0t STATE=%0d BIT=%0d SDA=%b", $time, state, bit_counter, sda);

      
    case (state)
      
      IDLE: begin             // wait for START
        sda_drive_low<=0;
        if (start_detected) begin
          $display("START detected at %0t", $time);
          state<=ADDR;
          bit_counter<=0;
          start_detected = 0;
        end
      end
      
      ADDR: begin              //recieve add.+R/W
        
        shift_reg<={shift_reg[6:0],sda};
        bit_counter<=bit_counter+1;
        
        if (bit_counter==6) begin //after 7 bit check add.
          if ({shift_reg[5:0],sda}==SLAVE_ADDR) 
            address_match=1;
          else 
            address_match=0;
        end
        
        if (bit_counter==7) begin  //8th bit R/W
          rw_bit=sda;
          state=ACK_ADDR;end
      end
      
      ACK_ADDR: begin              //send ACK for address
        
        if (address_match) 
          begin
          sda_drive_low<=1;
            drive_value = 0;
          bit_counter<=0;
          if (rw_bit==0)
           state<=WRITE;
          else 
          state<=READ;
        end
        else begin
          state<=IDLE;
        end
        
      end  
      
      WRITE: begin             // master to slave
        
        sda_drive_low<=0;
        shift_reg<={shift_reg[6:0],sda};
        bit_counter<=bit_counter+1;
        
        if (bit_counter==7)
          state<=ACK_WRITE;
      end
      
      ACK_WRITE: begin       //ACK for write
        
        sda_drive_low<=1;
        drive_value = 0;
        bit_counter<=0;
        state<=WRITE;
      end
      
      
      READ: begin             // slave to master
        	
        sda_drive_low = 1;
        drive_value = tx_data[7-bit_counter];
        //sda_drive_low<= ~tx_data[7-bit_counter];
        bit_counter<=bit_counter+1;
        
        if (bit_counter==7) begin
         
          bit_counter<=0;
          @(negedge scl);
          sda_drive_low<=0;
          state<=WAIT_ACK;end
      end
      
      WAIT_ACK: begin
        if (sda==0)
          state<=READ;
        else
          state<=IDLE;
      end  
    endcase
    end
  end
endmodule
   
  