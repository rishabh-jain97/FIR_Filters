`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2019 09:49:58 PM
// Design Name: 
// Module Name: fir_tb
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


module fir_tb();

reg clk; 
reg  [7:0] x_in; 
reg signed [7:0] coefficientss [3:0];
reg rst;
reg [7:0] multiplier;
wire signed [15:0] x_out ;

fir_filter_top #(4) furby_the_fir(clk,rst, x_in, x_out,multiplier );

always begin #1 clk= ~clk; end 


initial begin 
rst = 1;
clk =0; 
x_in = 9; 
multiplier = 1;
coefficientss [0] = 1; 
coefficientss [1] = 1; 
coefficientss [2] = -2;
coefficientss [3] = 5;
#10
rst=0;
#100
rst=1;
#100
multiplier =2; 
#10
multiplier =1;
x_in = 2;
coefficientss [2] = 2;
#20
coefficientss [2] = -2; 
coefficientss [3] =-3;
#20
rst =0;
#10
rst=1;
x_in = 9;
#20
coefficientss [1] = 4;
$finish;
end

endmodule

