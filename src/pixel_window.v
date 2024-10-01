`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2024 22:56:58
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
    input clk,                    
    input rst,                      
    input h_sync_i,
    input v_sync_i,
    input [7:0] incoming_pixel,     
    input pixel_valid_input,
    output [39:0] out_pixel,
    output pixel_valid_output,
    output h_sync_o,
    output v_sync_o
);

reg [2:0] state;
initial begin state <= 0; end

wire [7:0] bram_out_tmp [4:0];
assign bram_out_tmp[0] = incoming_pixel;

reg [10:0] addr_cntr;

always @ (posedge clk)
begin
    if (rst)
        state <= 3'b000;
    else
    if (h_sync_i && (state == 3'b000 || state == 3'b010))
    begin
        state[2:1] <= state[2:1] + 1;
        state[0] <= 1;
    end
    else if (h_sync_i == 0)
        state[0] <= 0;   
end  
  
//assign pixel_valid_output = pixel_valid_input && (state == 2'b10);

always @ (posedge clk)
if (rst || h_sync_i)
begin
    addr_cntr<=11'b0;
end
else 
    addr_cntr<=addr_cntr+1;

genvar i;
genvar j;
generate
for(i=0; i<5; i=i+1)
begin: shift_register_instance
    shift_register shift_register_inst(.clk(clk), .rst(rst), .en(pixel_valid_input), .h_sync(h_sync), .data_in(bram_out_tmp[i]), .data_out(out_pixel[i*8 +:8]));
end


for(j=1; j<5; j=j+1)
begin: line_buff_instance
    line_buff line_buff_inst(.clk(clk), .data_in(bram_out_tmp[j-1]), .write_enable(pixel_valid_input),.h_sync(h_sync), .rst(rst), .data_out(bram_out_tmp[j]), .address(addr_cntr));
end
endgenerate


reg[10:0] row_cntr;
always @ (posedge clk)
begin
if (rst)
    row_cntr <= 0;
else if (state != 3'b100)
    row_cntr = row_cntr +1;
end

integer shr_idx;
reg [2:0] cntrl_dl[3599:0];
always @ (posedge clk)
if (rst)
begin
    for (shr_idx=0; shr_idx<3599; shr_idx=shr_idx+1)
    cntrl_dl[shr_idx] <= 3'b000;
end
else
begin
for (shr_idx=0; shr_idx<3599; shr_idx=shr_idx+1)
    cntrl_dl[shr_idx] <= (shr_idx==0) ? {pixel_valid_input, h_sync_i, v_sync_i} : cntrl_dl[shr_idx-1];
end

assign pixel_valid_output = cntrl_dl[row_cntr][2];
assign h_sync_o = cntrl_dl[row_cntr][1];
assign v_sync_o = cntrl_dl[row_cntr][0];

endmodule
