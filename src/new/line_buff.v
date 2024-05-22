`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2024 22:07:48
// Design Name: 
// Module Name: line_buff
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


module line_buff(
    input clk,
    input [7:0] data_in,
    input [10:0] address,
    input write_enable,
    input h_sync,
    input rst,
    output [7:0] data_out
    );
    
    reg [7:0] ram [1599:0];
    reg [7:0] data_out_r;

    integer i;
    always @ (posedge clk)
    begin
    /*
    if (rst)
        begin
            ram <= 0;
        end   */     
        if(write_enable)
            ram[address] <= data_in;
    end
    always @ (negedge clk)
        data_out_r <= ram[address];
        
    assign data_out=data_out_r;
endmodule
