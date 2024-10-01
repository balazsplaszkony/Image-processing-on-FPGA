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

module fir_filter (
    input                clk,
    input                rst,
    input signed [39:0] pixel_data,
    input                dv_i,
    input                hs_i,
    input                vs_i,
    output               dv_o,
    output               hs_o,
    output               vs_o,
    output wire [7:0]    convolved_data
);
integer i;
reg signed [15:0] kernel [24:0];

initial begin
    for (i = 0; i < 25; i = i + 1) begin
        //kernel[i] = (i% 5 == 0) ? 256 : 0;
                kernel[i] = 10;
    end
    /*kernel[2] = 256;
    kernel[8] = 256;
    kernel[11] = 256;
    kernel[15] = 256;
    kernel[23] = 256;*/
end

wire signed [36:0] dsp_output [25:0];
assign dsp_output[0] = 37'd0;

reg [199:0] shr[4:0];
initial 
    begin
        for (i = 0; i < 5; i = i + 1)
            shr[i] <= 200'b0;
    end
    
integer chain_idx = 0;
integer pixel_idx = 0;
always @(posedge clk)
    /*if (rst)
        for(chain_idx = 0; chain_idx < 5; chain_idx = chain_idx +1)
            shr[chain_idx] <= 200'b0;
    else*/
    begin
        for (chain_idx = 0; chain_idx < 5; chain_idx = chain_idx +1)
            shr[chain_idx] <= {pixel_data[chain_idx*8+:8], shr[chain_idx][199:8]};

    end

generate
    genvar outer_idx;
    genvar inner_idx;
    for (outer_idx = 0; outer_idx < 5; outer_idx = outer_idx + 1) begin : gen_outer
        for (inner_idx = 0; inner_idx < 5; inner_idx = inner_idx + 1) begin : gen_inner
            begin                
                dsp48e1_mac  dsp48e1_inst (
                    .clk(clk),
                    .a({8'b0, shr[outer_idx][199 - (outer_idx*40 + inner_idx * 8 ) : 192 - (outer_idx*40 + (inner_idx) * 8 )]}),
                    .b(kernel[outer_idx*5 + inner_idx]),  
                    .c(dsp_output[outer_idx*5 + inner_idx]),
                    .p(dsp_output[outer_idx*5 + inner_idx + 1])
                );
            end
        end
    end
endgenerate

assign convolved_data = (dsp_output[25][36]) ? 8'b0 :
                        (dsp_output[25][35:16] > 0) ? 8'b1111_1111 :
                        dsp_output[25][15:8];
                        
reg [2:0] cntrl_dl[27:0];
integer delay;
always @ (posedge clk)
for (delay=0; delay<28; delay=delay+1)
    cntrl_dl[delay] <= (delay==0) ? {dv_i, hs_i, vs_i} : cntrl_dl[delay-1];

assign dv_o = cntrl_dl[27][2];
assign hs_o = cntrl_dl[27][1];
assign vs_o = cntrl_dl[27][0];

endmodule


