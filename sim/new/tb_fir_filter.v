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
    
    reg rst = 1;
    reg clk = 0;
    wire pixel_data_valid = 1;
    reg [39:0] pixel_data;
    wire  convolved_data_valid = 1;
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
            for (i = 0; i < 5; i = i + 1) 
        begin
            pixel_data[8*i +: 8] = 8'b00000000;
        end
    end
    
    initial
    begin 
    #8 rst <= 0;
    end 
    
    integer idx = 0;
    always @(posedge clk)
    begin
        for (i = 0; i < 5; i = i + 1)
        //if (pixel_data[8*i +: 8] != 255)
          if ( idx == 3)
            pixel_data[8*i +: 8] <= (pixel_data[8*i +: 8] + 10);
          else 
            pixel_data <= 0;
          idx = idx + 1;
    end
    
    fir_filter uut(.clk(clk), .rst(rst), .pixel_data(pixel_data), .dv_i(pixel_data_valid), 
                   .convolved_data(convolved_data), .dv_o(convolved_data_valid));
    
endmodule
