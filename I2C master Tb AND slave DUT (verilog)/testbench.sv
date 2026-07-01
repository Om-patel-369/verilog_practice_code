// Code your testbench here
// or browse Examples
module tb;
  reg scl;
  
  //for SDA control
  reg master_sda;
  reg master_data;
  wire sda;
  reg [7:0] data; //for testcase
  
  assign sda = (master_sda)? master_data:1'bz; //SDA mechasnism
  
  i2c_slave dut (
    .scl(scl),
    .sda(sda)
  );
  
  task i2c_start; begin
    master_sda=1;
    master_data=1;
    $display ("%0t,Master state:I2C_start",$time);
    scl=1;
    #5 master_data=0;
  #5 scl=0;
  
  end
  endtask
  
  task i2c_stop;begin
    //#5 scl = 1;
    scl=0;
    #5 scl =1;
    master_sda=1;
    master_data=0;
    $display ("%0t,Master state:I2C_stop",$time);
    
    #2 master_data=1;
    #3 scl = 0;
    #5;
    
  end
  endtask
  
  task write_bit;
    input bit data;begin
      
      scl=0;
    master_sda=1;
      master_data=data;
      $display ("%0t,Master state:Write_bit",$time);
      #5;
      scl=1; //placed bit when clock is low
      #5;end
  endtask
  
  task read_bit;
    output bit data; begin
      scl=0;
      master_sda=0; //release sda
      $display ("%0t,Master state:Read_bit",$time);
      #5;
      scl=1; //slave drives data
      #5;
       data=sda; //sample bit when clk is high
      $display ("%0t,Master state:Read_bit %0b",$time,data);
    end
  endtask
  
  task write_byte;
    input [7:0] data;
    integer i;
    begin
      $display ("%0t,Master state:Write_byte",$time);
      for (i=7;i>=0;i=i-1)
        write_bit(data[i]);
      
     // master_sda=0;
    end
  endtask
  
  task read_byte;
    output [7:0]data;
    integer i;
   begin 
     $display ("%0t,Master state:Read_byte",$time);
    for (i=7;i>=0;i=i-1)
        read_bit(data[i]);
    end
    $display ("%0t,Master :Read_byte = %0h",$time,data);
  endtask
  
  task read_ack; //read ack/nack bit coming from slave
    reg ack;
    
    begin
      scl=0;
      master_sda=0;
      $display ("%0t,Master state:Read_ACK",$time);
      #5;
      scl=1;
      #1;
      ack = sda;
      
      if (ack==0)
        $display ("%0t,ACK recieved",$time);
      else 
        $display ("%0t,NACK recieved",$time);
      #4 ;
     // scl =0;
     // #5 scl =1;
     // #5 scl =0;
    end
  endtask
  
  task send_ack; //for read, master sends ack/nack
    begin
      $display ("%0t,Master state:Send_ACK",$time);
      write_bit(0);
    end
  endtask
  
  task send_nack;
    begin
      $display ("%0t,Master state:Send_NACK",$time);
      write_bit(1);
    end
  endtask
  
  // TESTCASES
  
  initial
    begin
      $dumpfile("dump.vcd");
    $dumpvars (0,tb);
    end
  
  //simple write testcase (boundary check also)
  
  initial
    begin
      scl=0;
      master_sda=1;
      master_data=1;
      
      #20;
      
      i2c_start();
      write_byte(8'b10100010); //sending address+W bit
      read_ack();
      write_byte(8'h55); //sending write data
      read_ack();   //(write 8'h00 and 8'hFF)
      i2c_stop();
      //#10;
     
  //simple read testcase
    
   
    i2c_start();
      write_byte(8'b10100011);
    read_ack();
    read_byte(data);
    send_nack();
    i2c_stop();
    #100 $finish;
    
     // #20 $finish;
    end
  
endmodule