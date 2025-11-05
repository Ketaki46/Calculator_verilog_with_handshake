`timescale 1ns / 1ps



module calc5(
  input clk,
    input rst,
    input wire [1:0] ctrl,
    input wire [31:0] a,
    input wire [31:0] b,
    input wire din_valid,
    output reg stall_out,
    input stall_in,
    output reg [31:0] out,
    output reg dout_valid );
    
    
    
       parameter
        IDLE      = 2'b00,
        EXEC      = 2'b01,
        WRITE     = 2'b10;
        
   reg [1:0] current_state,next_state;
   
        reg [31:0] regA, regB,data_reg;
        reg [1:0]  regCtrl;
        reg [31:0] result;
        reg data_captured;
        reg flag1=0,flag2=0;
        integer count=0;
    
    
     always @(posedge clk or posedge rst) begin
        if (rst)
            begin
            regA <= 32'b0;
            regB <= 32'b0;
            regCtrl <= 2'b0;
            stall_out <= 1'b1;  // Ready to accept data after reset
            data_captured <= 1'b0;
            dout_valid <=0;
            current_state <= IDLE;
            end
        else
            case(current_state)
                IDLE:  if (flag1==1)
                        begin
                        regA <= a;
                        regB <= b;
                        regCtrl<= ctrl;
                        data_captured <= 1'b1;
                        flag1=0;
                       // flag2=0;
                        stall_out =0;
                        current_state <= EXEC;
                      end
                      else
                      
                        current_state <= IDLE;
                EXEC :
                    begin
                   
                    case (regCtrl)
                        2'b00: result <= regA + regB;       // Addition
                        2'b01: result <= regA - regB;       // Subtraction
                        2'b10: result <= regA * regB;       // Multiplication
                        2'b11: result <= (regB != 0) ? regA / regB : 32'hdead; // Division (check for zero)
                        default: result <= 32'hdead;
                        
                    endcase
                   dout_valid <= 1'b1;
                    current_state <= WRITE;
                 // 
                end
                      
                WRITE:
                begin
                   
                       // dout_valid = 1'b1;
                        out<= result; // 'result' was latched in EXEC
                        stall_out =1;
                        //flag2=0;

                        if(dout_valid==0) //_________
                            current_state <= IDLE;                   
                     end
                     
//                    
                     
                  endcase 
            
    end
    
    
    always @(posedge clk)
        if(din_valid && stall_out)
            flag1<=1;
//#####################################################################################   


  always @(posedge clk)
    begin
            if (dout_valid && stall_in) 
               flag2 <= 1'b1;
    
    end    
    
    always @(posedge clk)
    begin 
    if(flag2 == 1 || dout_valid==1 )
        count=count+1;
    end 
    
    always @(posedge clk)
    begin
        if (count == 2)
            begin
                dout_valid = 1'b0;
                count =0;
                flag2=0;
                
                end
             
    end
    
endmodule
