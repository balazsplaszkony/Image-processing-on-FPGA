`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.05.2024 01:08:59
// Design Name: 
// Module Name: tb_pixel_window
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


module tb_pixel_window(

    );

    reg clk=0;
    reg rst=1;
    reg [7:0] incoming_pixel = 8'b0;
    wire [199:0] out_pixel;
    
    always #5 clk<= ~clk;
    initial
     #10 rst<=0;
     
     reg [10:0] cntr=11'b0;
     always @ (negedge clk)
     if(cntr==20)
     begin
     cntr<=11'b0;
     rst<=1;
     end
     else
      begin
     cntr<=cntr+1;
     rst<=0;
     end
     
     pixel_window uut(.clk(clk), .rst(rst), .incoming_pixel(incoming_pixel), .out_pixel(out_pixel));
     
     always @(negedge clk)
        incoming_pixel<=incoming_pixel+8'b1;
        
endmodule
