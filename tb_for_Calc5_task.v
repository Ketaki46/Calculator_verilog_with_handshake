`timescale 1ns / 1ps



module tb_for_Calc5_task();

    reg clk;
    reg rst;
    reg  [1:0] ctrl;
    reg [31:0] a;
    reg[31:0] b;
    reg din_valid;
    wire stall_out;
    reg stall_in;
    wire [31:0] out;
    wire dout_valid;
    
    calc5 dut5_1(clk,rst,ctrl,a,b,din_valid,stall_out,stall_in, out,dout_valid);
    
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    task reset_gen;
        begin
            rst=1;
            #15 rst =0;
        end
    endtask
    task control;
        begin
         wait(stall_out);
        @(posedge clk);
            ctrl = $urandom_range(0,3);
            a = 4;
            b = 2;
        din_valid = 1;  // Assert valid when ready is high
        @(posedge clk);
        @(posedge clk);
        din_valid = 0;  // Deassert valid on 2nd cycle after handshake
       wait(dout_valid);
      

        stall_in = 1;
        @(posedge clk); 
       
        stall_in = 0;
        $display("\n=== Test Case 1: randomising control signals and input a,b");    
        $display("Time=%0t | Output handshake complete: a=%d, b=%d, cotrol=%b , output_data=%d\n", $time,a,b,ctrl, out);
        
        #30;
    
        end
    endtask
    
    
    task Add1(output a,b,output [0:1]ctrl);
        begin
           
        wait(stall_out);
        @(posedge clk);
            ctrl = 0;
            a = $urandom_range(0,200);
            b = $urandom_range(0,200);
        din_valid = 1;  // Assert valid when ready is high
        @(posedge clk);
        @(posedge clk);
        din_valid = 0;  // Deassert valid on 2nd cycle after handshake
       wait(dout_valid);
      

        stall_in = 1;
        @(posedge clk); 
       
        stall_in = 0;
        $display("\n=== Test Case 2: prameterised task for addition ");    
        $display("Time=%0t | Output handshake complete: a=%d, b=%d, cotrol=%b ,Add output_data=%d\n", $time,a,b,ctrl, out);
        
        #60;
        end
    endtask
    
    
    
     task Add;
        begin
           
        wait(stall_out);
        @(posedge clk);
            ctrl = 0;
            a = $urandom_range(0,200);
            b = $urandom_range(0,200);
        din_valid = 1;  // Assert valid when ready is high
        @(posedge clk);
        @(posedge clk);
        din_valid = 0;  // Deassert valid on 2nd cycle after handshake
       wait(dout_valid);
      

        stall_in = 1;
        @(posedge clk); 
       
        stall_in = 0;
        $display("\n=== Test Case 4: Non parameterized  task for addition ");    
        $display("Time=%0t | Output handshake complete: a=%d, b=%d, cotrol=%b ,Add output_data=%d\n", $time,a,b,ctrl, out);
        
        #60;
        end
    endtask
    
    
     task Sub;
        begin
           
        wait(stall_out);
        @(posedge clk);
            ctrl = 1;
            a = $urandom_range(200,400);
            b = $urandom_range(0,200);
           
        din_valid = 1;  // Assert valid when ready is high
        @(posedge clk);
        @(posedge clk);
        din_valid = 0;  // Deassert valid on 2nd cycle after handshake
       wait(dout_valid);
      

        stall_in = 1;
        @(posedge clk); 
       
        stall_in = 0;
       // $display("\n=== Test Case 1: Valid and Stall high for 1 cycle ===");  
        $display("Time=%0t | Output handshake complete:  a=%d, b=%d, cotrol=%b ,SUB output_data=%d\n", $time,a,b,ctrl, out);
        
        #60;
        end
    endtask
    
    task Mul;
        begin
           
        wait(stall_out);
        @(posedge clk);
            ctrl = 2;
            a = 5;
            b = 150;
        din_valid = 1;  // Assert valid when ready is high
        @(posedge clk);
        @(posedge clk);
        din_valid = 0;  // Deassert valid on 2nd cycle after handshake
       wait(dout_valid);
      

        stall_in = 1;
        @(posedge clk); 
       
        stall_in = 0;
        $display("\n=== Test Case 3: Hardcoded input value");    
        $display("Time=%0t | Output handshake complete:  a=%d, b=%d, cotrol=%b ,MUL output_data=%d\n", $time,a,b,ctrl, out);
        
        #60;
        end
    endtask
    
    
    task DIv;
        begin
           
        wait(stall_out);
        @(negedge clk);
            ctrl = 3;
            a = 72;
            b = 9;
        din_valid = 1;  // Assert valid when ready is high
        @(posedge clk);
        @(posedge clk);
        din_valid = 0;  // Deassert valid on 2nd cycle after handshake
       wait(dout_valid);
      

        stall_in = 1;
        @(posedge clk); 
       
        stall_in = 0;
            
        $display("Time=%0t | Output handshake complete: a=%d, b=%d, cotrol=%b ,DIV output_data=%d\n", $time,a,b,ctrl, out);
        
        #60;
        end
    endtask
    
    
    
    initial begin
    
        reset_gen;
        #20;
             
//       control;
//       #10;
//       control;
//       #10;
//       control;
//       #10;
        repeat(5)
        begin
            
        //    Add1(a,b,ctrl);
            Add;
            #10;
            Sub;
            #10;
            Mul;
            #10;
            DIv;
            #10;
            end
    end
    

    
endmodule
