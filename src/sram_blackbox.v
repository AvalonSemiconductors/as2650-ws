/// sta-blackbox

(* blackbox *)
module gf180_ram_512x8_wrapper_as2650 (
`ifdef USE_POWER_PINS
	inout VDD,
	inout VSS,
`endif
	input CLK,
	input CEN,
	input GWEN,
	input [7:0] WEN,
	input [8:0] A,
	input [7:0] D,
	output [7:0] Q
);


endmodule
