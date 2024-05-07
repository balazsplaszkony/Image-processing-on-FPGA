`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2024 22:56:58
// Design Name: 
// Module Name: pixel_window
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


module pixel_window(
    input clk,                      // Clock
    input rst,                      // Reset
    input [7:0] incoming_pixel,     // Incoming pixel data (8-bit)
    input pixel_valid,
    output[199:0] out_pixel// Output pixel data (8-bit), 25 elements
);


wire [7:0] bram_out_tmp [4:0];
assign bram_out_tmp[0] = incoming_pixel;

reg [10:0] addr_cntr;

always @ (posedge clk)
if (rst)
    addr_cntr<=11'b0;
else 
    addr_cntr<=addr_cntr+1;


genvar i;
generate
for(i=0; i<5; i=i+1)
begin: shift_register_instance
    shift_register shift_register_inst(.clk(clk), .rst(rst), .en(1), .data_in(bram_out_tmp[i]), .data_out(out_pixel[(i+1)*40-1+40])); // [VRFC 10-3236] concurrent assignment to a non-net 'out_pixel' is not permitted ["C:/Users/plasz/Downloads/fpga_gyak4_mo/gyak4_mo/hdmi_loopback.srcs/sources_1/new/pixel_window.v":47]

end


for(i=1; i<5; i=i+1)
begin: line_buff_instance
    line_buff line_buff_inst(.clk(clk), .data_in(bram_out_tmp[i-1]), .write_enable(1), .data_out(bram_out_tmp[i]), .address(addr_cntr));
end
endgenerate

endmodule
