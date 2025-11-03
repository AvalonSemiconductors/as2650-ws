`default_nettype none

module wrapped_as2650(
`ifdef USE_POWER_PINS
	inout VDD,
	inout VSS,
`endif
	input [18:0] io_in,
	output [18:0] io_out,
	output [18:0] io_oe,
	output [18:0] io_ie,
	output [18:0] io_pu,
	output [18:0] io_pd,
	output [18:0] io_sl,
	output [18:0] io_cs,
	
	input clk_i,
	input rst_n,
	output [3:0] const_zero,
	
	output [7:0] bus_data_out,
	output bus_cyc,
	output [5:0] bus_addr,
	
	output bus_we_gpios,
	input [7:0] bus_in_gpios,
	
	output bus_we_timers,
	input [7:0] bus_in_timers,
	
	output bus_we_serial_ports,
	input [7:0] bus_in_serial_ports,
	
	output bus_we_sid,
	input [7:0] bus_in_sid,
	
	input [6:0] irqs,
	output reset_out,
	
	output WEb_ram,
	output le_lo_act,
	output le_hi_act,
	output boot_rom_en,
	output [7:0] rom_bus_out,
	input [7:0] rom_bus_in,
	input [7:0] ram_bus_in,
	output ram_enabled,
	output [15:0] last_addr,
	output [15:0] requested_addr
);
assign io_ie = ~io_oe;
assign io_sl = (1 << 2);
assign io_cs = (1 << 4) | (1 << 0) | (1 << 3);
assign io_pd = (1 << 4);
assign io_pu = (1 << 0) | (1 << 3); //Boot ROM enable and RAM enable on by default
assign const_zero = 4'h0;

assign boot_rom_en = cpu_hidden_rom_enable_latched && cpu_hidden_rom_enable;

wire le_lo;
wire le_hi;
wire OEb;
wire WEb;
wire bus_dir;
wire [7:0] bus_out;
wire flag;
wire IOC;
wire IOD;
wire cpu_hidden_rom_enable;

assign io_out[0] = 1'b0;
assign io_oe[0] = 1'b0;
assign io_out[1] = bus_dir;
assign io_oe[1] = 1'b1;
assign io_out[12:5] = bus_out;
assign rom_bus_out = bus_out;
assign io_oe[12:5] = {8{!bus_dir}};
assign io_out[13] = le_lo;
assign io_out[14] = le_hi;
assign io_out[15] = OEb;
assign io_out[16] = WEb;
assign io_oe[16:13] = 4'hF;
assign io_out[2] = flag;
assign io_oe[2] = 1'b1;
assign io_out[4] = 1'b0;
assign io_oe[4] = 1'b0;
assign io_out[3] = 1'b1;
assign io_oe[3] = 1'b0;
assign ram_enabled = io_in[3];

assign io_out[18:17] = {IOC, IOD};
assign io_oe[18:17] = 2'b11;

wire the_reset = !rst_n;
assign reset_out = the_reset;

/*
 * Internal IO multiplexing
 */
wire [7:0] full_io_addr;
assign bus_addr = full_io_addr[5:0];
wire io_bus_we;
wire [1:0] device_addr = full_io_addr[7:6];

reg [7:0] bus_in_plexed;
always @(*) begin
	case(device_addr)
		0: bus_in_plexed = bus_in_gpios;
		1: bus_in_plexed = bus_in_timers;
		2: bus_in_plexed = bus_in_serial_ports;
		3: bus_in_plexed = bus_in_sid;
		default: bus_in_plexed = 8'h00;
	endcase
end
assign bus_we_gpios = io_bus_we && device_addr == 0;
assign bus_we_timers = io_bus_we && device_addr == 1;
assign bus_we_serial_ports = io_bus_we && device_addr == 2;
assign bus_we_sid = io_bus_we && device_addr == 3;

wire in_ram_range = ram_enabled && last_addr[15:12] == 0;
wire [7:0] bus_in = boot_rom_en ? rom_bus_in : (in_ram_range ? ram_bus_in : io_in[12:5]);
wire WE_ram_pre;
assign WEb_ram = !(WE_ram_pre && in_ram_range);

reg cpu_hidden_rom_enable_latched;
always @(posedge clk_i) if(!rst_n) cpu_hidden_rom_enable_latched <= io_in[0];

as2650 as2650(
	.clk(clk_i),
	.rst(the_reset),
	.bus_in(bus_in),
	.bus_out(bus_out),
	.le_lo(le_lo),
	.le_hi(le_hi),
	.OEb(OEb),
	.WEb(WEb),
	.bus_dir(bus_dir),
	.irqs(irqs),
	.flag(flag),
	.sense(io_in[4]),
	.IOC(IOC),
	.IOD(IOD),
	
	.ext_io_addr(full_io_addr),
	.io_bus_cyc(bus_cyc),
	.io_bus_we(io_bus_we),
	.io_bus_out(bus_data_out),
	.io_bus_in(bus_in_plexed),
	
	.wb_hidden_rom_enable(cpu_hidden_rom_enable_latched),
	.cpu_hidden_rom_enable(cpu_hidden_rom_enable),
	
	.le_lo_act_o(le_lo_act),
	.le_hi_act_o(le_hi_act),
	.last_addr_o(last_addr),
	.requested_addr_o(requested_addr),
	.WE_ram(WE_ram_pre)
);

endmodule
