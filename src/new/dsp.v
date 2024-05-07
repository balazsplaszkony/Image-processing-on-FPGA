module dsp
#(
    parameter            USE_PCI = 1
)(
    input                clk,
    input          [7:0] a,
    input          [7:0] d,
    input  signed [17:0] b,
    input  signed [31:0] c,
    input  signed [31:0] pci,
    output signed [31:0] p
);

reg signed [17:0] b_reg[1:0];
always @(posedge clk)
begin
    b_reg[0] <= b;
    b_reg[1] <= b_reg[0];
end 

reg signed [8:0] a_reg, d_reg;
reg signed [9:0] pre_add;
always @(posedge clk)
begin
    a_reg <= {1'b0, a};
    d_reg <= {1'b0, d};
    
    pre_add <= a_reg - d_reg;
end

reg signed [27:0] m_reg;
always @ (posedge clk)
    m_reg <= b_reg[1] * pre_add;

reg signed [31:0] c_reg;
always @(posedge clk)
    c_reg <= c;
    
reg signed [31:0] p_reg;
always @ (posedge clk)
if (USE_PCI==1)
    p_reg <= m_reg + pci;
else
    p_reg <= m_reg + c_reg;

assign p = p_reg;

endmodule
