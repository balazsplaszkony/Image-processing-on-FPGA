`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2024 22:04:39
// Design Name: 
// Module Name: tb_fir_filter
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


module tb_fir_filter(

    );
    
    reg clk = 0;
    reg reset = 1;
    wire pixel_data_valid = 1;
    reg [199:0] pixel_data;
    wire  convolved_data_valid = 0;
    wire [7:0] convolved_data;
    integer i;
    
initial
 begin
    clk = 1'b0;
    forever
    begin
        #5 clk = ~clk;
    end
 end
    
    initial 
    begin
    
            for (i = 0; i < 25; i = i + 1) 
        begin
            pixel_data[8*i +: 8] = 8'b00000001;
        end
                reset <= 0;


    end
    
    
    always @(posedge clk)
    begin
        for (i = 0; i < 25; i = i + 1)
        pixel_data[8*i +: 8] <= pixel_data[8*i +: 8] + 1;       
    end
    
    fir_filter uut(.clk(clk), .pixel_data(pixel_data), .pixel_data_valid(pixel_data_valid), 
                   .convolved_data(convolved_data), .convolved_data_valid(convolved_data_valid));
    
endmodule
