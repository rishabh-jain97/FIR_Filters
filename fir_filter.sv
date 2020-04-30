
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2019 08:25:37 PM
// Design Name: 
// Module Name: fir_filter
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


module fir_filter #(parameter N =3)(input clk,input rst, input [7:0] x_in, 
input signed [10:0] coefficients [N-1:0],input [7:0] multiplier, output signed [21:0] x_out);

//this fir filter will take N as the variable amount of taps (default is 3) 
//there must be a minimum of 1 tap 
//the coefficients are implemented as a 2D array where the 2nd dimension
//depends on the number of taps (ie if 3 taps there are 3 coefficients to be entered)
//in theory i could have made the widths of the data larger (> 8 bits) 

 
 //integers for the loops 
  integer i;
  integer k;
 
 //the addition registers of the fir filter has one less register than the number of taps 
 //it contains the addition of the multiplied values in ascending order 
  reg  signed [15:0] adds  [N-2:0];  
  
  //this 2d register array will store the result of the multiplications of samples with the coefficients
  reg  signed [15:0] multiples [N-1:0];
  
  //values of the flip-flops (aka the shifted signal with delay) 
  reg signed [7:0]  flip_flop_outs [N-1:0];
  
 //the output will be stored in the final add register
  assign x_out = adds [N-2] * multiplier;
 
 //assign flip_flop_outs[0] = x_in;
 // at every clock edge shift the x_in value to the flip-flops
 
  always @(rst,x_in) begin 
 flip_flop_outs[0] = x_in;
 
 end
 
 always @(posedge clk or negedge rst) begin 
 
    if (!rst) begin 
        for(i=0; i<N; i= i+1) begin
                flip_flop_outs [i] <= 0; 
        end
           
         for(i=0; i<N; i= i+1) begin
             multiples [i] <= 0; 
         end
         
         for(k=0; k<N-1; k= k+1) begin
                 adds [k] <= 0;
         end
        
    end
    //the first flip-flop will directly output the x_in
    
    
  else begin 

    //every other ff takes the output of the ff before it
    for(i=1; i<N; i= i+1) begin
        flip_flop_outs [i] <= flip_flop_outs[i-1]; 
    end
        
 end
end

//my attempt at generate with ff modules didn't work
//I kept it here to demonstrate my first approach
 /*
 generate
    genvar j;
  for (j=0; j<N-1; j=j+1) begin : genbit  
  Flip_Flop instances(
         .FF_Clk(clk)
        ,.D(flip_flop_outs[j])
        ,.Q(flip_flop_outs[j+1])
        );
    end
endgenerate
*/
  
//this is where all the adding and multiplication happens 
 always @(*) begin 
 //each output of the flip-flops (and the first input to the first ff)
 //will get multiplied by the respective coefficient
     for(i=0; i<N; i= i+1) begin
        multiples [i] = flip_flop_outs[i] * coefficients[i]; 
    end

 //the first addition is between the first ff output (multiplied by coefficent1)
 // and the result of the 2nd ff multiplied with coefficient 2
 //I did it in this fasion because the index of the addition register
 //and the multiples registers both start at 0
 
    adds[0] = multiples[0] + multiples[1];
 
 //after taking care of the 0th index, the rest of the additions follow
    for(k=1; k<N-1; k= k+1) begin
        adds [k] = adds[k-1] + multiples[k+1];
    end
 end
 
 
endmodule
