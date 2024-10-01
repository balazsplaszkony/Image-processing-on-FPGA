`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2024 23:57:49
// Design Name: 
// Module Name: dsp48e1_mac
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

module dsp48e1_mac 
(input clk,
 input signed [15:0] b, a, 
 input signed [36:0] c,
 output reg signed [36:0] p);

reg signed [15:0] coeff;
reg signed [15:0] data;
reg signed [15:0] dataz;
reg signed [31:0] product;


always @(posedge clk)
begin
coeff <= b;
data <= a;
dataz <=  data;
product <= dataz * coeff;
p <= product + c;
end

endmodule

