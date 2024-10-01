`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2024 16:54:47
// Design Name: 
// Module Name: shift_register
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



module shift_register
(
input clk,
input rst,
input en,
input h_sync,
input [7:0] data_in,
output reg [39:0] data_out
    );
    
    always @ (posedge clk)
    if (rst)
    data_out <= 0;
    else if(en)
    begin
    data_out <={data_in, data_out[39:8]};
    end
endmodule
