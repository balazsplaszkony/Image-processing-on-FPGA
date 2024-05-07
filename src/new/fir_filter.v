`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2024 17:08:48
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


module fir_filter(
    input            clk,
    input signed [199:0]    pixel_data,
    input            pixel_data_valid,
    output reg [29:0] convolved_data,
    output reg       convolved_data_valid
);

integer i;
reg signed [15:0] kernel           [24:0];
wire signed [15:0] pixel_reg        [24:0];
reg signed [32:0] mul_data         [24:0]; 
reg mult_data_valid;
reg signed [36:0] sum_data;
reg sum_data_valid;


initial
begin
    for(i=0;i<25;i=i+1)
    begin
        kernel[i] = 10;
    end
end  

genvar j;
generate
begin
    for ( j = 0; j < 25; j = j + 1)
    begin
       assign  pixel_reg[j] = $signed ({8'b0, pixel_data[8*j +: 8]});
       end
end
endgenerate

always @(posedge clk)
begin
    for(i=0;i<25;i=i+1)
    begin
        mul_data[i] <= kernel[i] * pixel_reg[i]; 
    end
    mult_data_valid <= pixel_data_valid;
end

always @(*)
begin
    sum_data = 0;
    for (i = 0; i < 25; i = i + 1)
    begin
         sum_data = $signed (sum_data) + $signed (mul_data[i]);
    end
    sum_data_valid = mult_data_valid; 
end

always @(posedge clk)
begin
    if (sum_data[36]) 
    begin
        convolved_data <= 8'b0;
    end
    else 
    begin
        if (sum_data[35:16] > 0)
            convolved_data <= 8'b1111_1111;
        else
            convolved_data <= sum_data[15:8];
    end
    convolved_data_valid <= sum_data_valid;
end

endmodule


