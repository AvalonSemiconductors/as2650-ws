`default_nettype none

module unused(
`ifdef USE_POWER_PINS
	inout VDD,
	inout VSS,
`endif
	input clk_i,
	input rst,
	input [15:0] io_in,
	output [15:0] io_out,
	output [15:0] io_oe,
	output [15:0] io_ie,
	output [15:0] io_cs,
	output [15:0] io_sl,
	output [15:0] io_pu,
	output [15:0] io_pd
);
assign io_cs = 0;
assign io_sl = 0;
assign io_ie = ~io_oe;
assign io_oe = 16'hFFFF;
assign io_pd = 0;
assign io_pu = 0;

reg [3:0] clkdiv;
reg [15:0] spinner;
assign io_out = spinner;

always @(posedge clk_i) begin
	if(rst) begin
		clkdiv <= 0;
		spinner <= 1;
	end else begin
		clkdiv <= clkdiv + 1;
		if(clkdiv == 0) begin
			spinner <= {spinner[14:0], spinner[15]};
		end
	end
end

endmodule
