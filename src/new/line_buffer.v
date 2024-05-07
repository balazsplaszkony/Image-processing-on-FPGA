`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2024 16:56:29
// Design Name: 
// Module Name: line_buffer
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


module line_buffer( //1600
    input clk,
    input [7:0]data_in,
    input [10:0] addr,
    input we,
    
    output [7:0] data_out
    
    );
    
    reg [7:0] ram [1599:0];
    reg [7:0] data_out_r;

    
    always @ (posedge clk)
    begin
    if(we)
    ram[addr] <= data_in;
    data_out_r <= ram[addr];
    end
    
    assign data_out=data_out_r;


endmodule
