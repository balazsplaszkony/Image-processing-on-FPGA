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
     #8 rst<=0;
     
     reg [10:0] cntr=11'b0;
     always @ (posedge clk)
     if(cntr==60)
     begin
     cntr<=11'b0;
     //rst<=1;
     end
     else
      begin
     cntr<=cntr+1;
     rst<=0;
     end
     wire hs_o, vs_o, dv_o;
     reg hs_i, vs_i, dv_i;
     initial 
     begin
     hs_i <= 0;
     vs_i <= 0;
     dv_i <= 1;
     end
     always @ (posedge clk)
     begin
        if (cntr == 20 || cntr == 40)
            hs_i <= 1;
        else
            hs_i <= 0;   
     end

     pixel_window uut(.clk(clk), .rst(rst), .h_sync_i(hs_i), .v_sync_i(vs_i),  .incoming_pixel(incoming_pixel),
                      .pixel_valid_input(1), .out_pixel(out_pixel), .pixel_valid_output(dv_o), .h_sync_o(hs_o), .v_sync_o(vs_o));
     
     always @(posedge clk)
        incoming_pixel<=incoming_pixel+8'b1;
        
endmodule
