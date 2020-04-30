`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2020 10:38:16 PM
// Design Name: 
// Module Name: filter_vtb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module filter_vtb(
    );
    
reg clk; 
    reg   x_in; 
    reg rst;
    reg [7:0] multiplier;
    wire [19:0] x_out ;
    
    firfilter_v3  furby_the_fir(clk,rst, x_in, multiplier, x_out ); 
    
    
always begin #1 clk= ~clk; end 
    
    
    initial begin 
    rst = 0;
    clk =0; 
    x_in = 1; 
    multiplier = 1;
    
    #10
    rst=1;
    x_in =0;
    #100
    rst=1;
    #10
    x_in =1;
    #100
    multiplier =2; 
    #10
    multiplier =1;

    #20
    #20
    #10
    rst=1;
    x_in = 0;
    #100
    $finish;
    end
    
    endmodule
       
    

