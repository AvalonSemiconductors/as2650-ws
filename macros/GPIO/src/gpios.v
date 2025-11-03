`default_nettype none

module gpios(
`ifdef USE_POWER_PINS
	inout VDD,
	inout VSS,
`endif
	input [15:0] io_in,
	output [15:0] io_out,
	output [15:0] io_oe,
	output [15:0] io_ie,
	output [15:0] io_pu,
	output [15:0] io_pd,
	output [15:0] io_sl,
	output [15:0] io_cs,
	input clk_i,
	input rst,
	
	input [3:0] addr,
	input [7:0] data_in,
	output reg [7:0] data_out,
	input bus_cyc,
	input bus_we,
	output reg irq0,
	output reg irq6,
	output reg irq7,
	
	input tmr0_o,
	input tmr1_o,
	input pwm0,
	input pwm1,
	input pwm2,
	
	output tmr0_clk,
	output tmr1_clk,
	
	input TXD,
	output RXD,
	
	input DAC_clk,
	input DAC_le,
	input DAC_d1,
	input DAC_d2
);
assign io_ie = ~io_oe;
assign io_sl = 0;

reg [7:0] DDRA;
reg [7:0] DDRB;
reg [7:0] PORTA;
reg [7:0] PORTB;
reg [7:0] SPA;
reg [7:0] SPB;
//New in wafer.space version
reg [7:0] CSA;
reg [7:0] CSB;
reg [7:0] PUA;
reg [7:0] PUB;
reg [7:0] PDA;
reg [7:0] PDB;

/*
 * PA0 - IRQ0
 * PA1 - TXD
 * PA2 - RXD
 * PA3 - TMR0
 * PA4 - TMR1
 * PA5 - PWM0
 * PA6 - PWM1
 * PA7 - IRQ7
 */
 
 /*
  * PB0 - IRQ6
  * PB1 - PWM2
  * PB2 - TMR0 CLK
  * PB3 - TMR1 CLK
  * PB4 - DAC DAT1
  * PB5 - DAC DAT0
  * PB6 - DAC LE
  * PB7 - DAC CLK
  */

assign io_out[0] = SPA[0] ? 1'b0 : PORTA[0];
assign io_out[1] = SPA[1] ? TXD : PORTA[1];
assign io_out[2] = SPA[2] ? 1'b0 : PORTA[2];
assign io_out[3] = SPA[3] ? tmr0_o : PORTA[3];
assign io_out[4] = SPA[4] ? tmr1_o : PORTA[4];
assign io_out[5] = SPA[5] ? pwm0 : PORTA[5];
assign io_out[6] = SPA[6] ? pwm1 : PORTA[6];
assign io_out[7] = SPA[7] ? 1'b0 : PORTA[7];
assign io_oe[0] = SPA[0] ? 1'b0 : DDRA[0];
assign io_oe[1] = SPA[1] ? 1'b1 : DDRA[1];
assign io_oe[2] = SPA[2] ? 1'b0 : DDRA[2];
assign io_oe[3] = SPA[3] ? 1'b1 : DDRA[3];
assign io_oe[4] = SPA[4] ? 1'b1 : DDRA[4];
assign io_oe[5] = SPA[5] ? 1'b1 : DDRA[5];
assign io_oe[6] = SPA[6] ? 1'b1 : DDRA[6];
assign io_oe[7] = SPA[7] ? 1'b0 : DDRA[7];
assign RXD = SPA[2] ? io_in[2] : 1'b1;

assign io_out[8] = SPB[0] ? 1'b0 : PORTB[0];
assign io_out[9] = SPB[1] ? pwm2 : PORTB[1];
assign io_out[10] = SPB[2] ? 1'b0 : PORTB[2];
assign io_out[11] = SPB[3] ? 1'b0 : PORTB[3];
assign io_out[12] = SPB[4] ? DAC_d2 : PORTB[4];
assign io_out[13] = SPB[5] ? DAC_d1 : PORTB[5];
assign io_out[14] = SPB[6] ? DAC_le : PORTB[6];
assign io_out[15] = SPB[7] ? DAC_clk : PORTB[7];
assign io_oe[8] = SPB[0] ? 1'b0 : DDRB[0];
assign io_oe[9] = SPB[1] ? 1'b1 : DDRB[1];
assign io_oe[10] = SPB[2] ? 1'b0 : DDRB[2];
assign io_oe[11] = SPB[3] ? 1'b0 : DDRB[3];
assign io_oe[12] = SPB[4] ? 1'b1 : DDRB[4];
assign io_oe[13] = SPB[5] ? 1'b1 : DDRB[5];
assign io_oe[14] = SPB[6] ? 1'b1 : DDRB[6];
assign io_oe[15] = SPB[7] ? 1'b1 : DDRB[7];

//New in wafer.space version
//Special function behavior: enable Schmitt-Trigger for IRQs and UART RXD
assign io_cs[0] = SPA[0] ? 1'b1 : CSA[0];
assign io_cs[1] = SPA[1] ? 1'b0 : CSA[1];
assign io_cs[2] = SPA[2] ? 1'b1 : CSA[2];
assign io_cs[3] = SPA[3] ? 1'b0 : CSA[3];
assign io_cs[4] = SPA[4] ? 1'b0 : CSA[4];
assign io_cs[5] = SPA[5] ? 1'b0 : CSA[5];
assign io_cs[6] = SPA[6] ? 1'b0 : CSA[6];
assign io_cs[7] = SPA[7] ? 1'b1 : CSA[7];
assign io_cs[8] = SPB[0] ? 1'b1 : CSB[0];
assign io_cs[9] = SPB[1] ? 1'b0 : CSB[1];
assign io_cs[10] = SPB[2] ? 1'b0 : CSB[2];
assign io_cs[11] = SPB[3] ? 1'b0 : CSB[3];
assign io_cs[12] = SPB[4] ? 1'b0 : CSB[4];
assign io_cs[13] = SPB[5] ? 1'b0 : CSB[5];
assign io_cs[14] = SPB[6] ? 1'b0 : CSB[6];
assign io_cs[15] = SPB[7] ? 1'b0 : CSB[7];
//Special function behavior: enable pull-up for UART RXD
assign io_pu[0] = SPA[0] ? 1'b0 : PUA[0];
assign io_pu[1] = SPA[1] ? 1'b0 : PUA[1];
assign io_pu[2] = SPA[2] ? 1'b1 : PUA[2];
assign io_pu[3] = SPA[3] ? 1'b0 : PUA[3];
assign io_pu[4] = SPA[4] ? 1'b0 : PUA[4];
assign io_pu[5] = SPA[5] ? 1'b0 : PUA[5];
assign io_pu[6] = SPA[6] ? 1'b0 : PUA[6];
assign io_pu[7] = SPA[7] ? 1'b0 : PUA[7];
assign io_pu[15:8] = ~SPB & PUB;
//Special function behavior: enable pull-down for IRQs for easy wired-OR
assign io_pd[0] = SPA[0] ? 1'b1 : PDA[0];
assign io_pd[1] = SPA[1] ? 1'b0 : PDA[1];
assign io_pd[2] = SPA[2] ? 1'b0 : PDA[2];
assign io_pd[3] = SPA[3] ? 1'b0 : PDA[3];
assign io_pd[4] = SPA[4] ? 1'b0 : PDA[4];
assign io_pd[5] = SPA[5] ? 1'b0 : PDA[5];
assign io_pd[6] = SPA[6] ? 1'b0 : PDA[6];
assign io_pd[7] = SPA[7] ? 1'b1 : PDA[7];
assign io_pd[8] = SPB[0] ? 1'b1 : PDB[0];
assign io_pd[9] = SPB[1] ? 1'b0 : PDB[1];
assign io_pd[10] = SPB[2] ? 1'b0 : PDB[2];
assign io_pd[11] = SPB[3] ? 1'b0 : PDB[3];
assign io_pd[12] = SPB[4] ? 1'b0 : PDB[4];
assign io_pd[13] = SPB[5] ? 1'b0 : PDB[5];
assign io_pd[14] = SPB[6] ? 1'b0 : PDB[6];
assign io_pd[15] = SPB[7] ? 1'b0 : PDB[7];

reg last_irq0_trigger;
reg last_irg6_trigger;
reg last_irq7_trigger;
wire irq0_trigger = SPA[0] ? io_in[0] : 1'b0;
wire irq6_trigger = SPB[0] ? io_in[8] : 1'b0;
wire irq7_trigger = SPA[7] ? io_in[7] : 1'b0;
assign tmr0_clk = SPB[2] ? io_in[10] : 1'b0;
assign tmr1_clk = SPB[3] ? io_in[11] : 1'b0;

always @(posedge clk_i) begin
	if(rst) begin
		data_out <= 8'h00;
		DDRA <= 8'h00;
		DDRB <= 8'h00;
		PORTA <= 8'h00;
		PORTB <= 8'h00;
		SPA <= 8'h00;
		SPB <= 8'h00;
		irq0 <= 1'b0;
		irq6 <= 1'b0;
		irq7 <= 1'b0;
		PUA <= 8'h00;
		PUB <= 8'h00;
		PDA <= 8'h00;
		PDB <= 8'h00;
		CSA <= 8'h00;
		CSB <= 8'h00;
		last_irq0_trigger <= 1'b0;
		last_irg6_trigger <= 1'b0;
		last_irq7_trigger <= 1'b0;
	end else begin
		if(bus_cyc) begin
			case(addr)
				0: begin
					if(bus_we) DDRA <= data_in;
					data_out <= DDRA;
				end
				1: begin
					if(bus_we) DDRB <= data_in;
					data_out <= DDRB;
				end
				2: begin
					if(bus_we) PORTA <= data_in;
					data_out <= PORTA;
				end
				3: begin
					if(bus_we) PORTB <= data_in;
					data_out <= PORTB;
				end
				4: begin
					if(bus_we) SPA <= data_in;
					data_out <= SPA;
				end
				5: data_out <= io_in[7:0];
				6: data_out <= io_in[15:8];
				7: begin
					if(bus_we) begin
						if(data_in[0]) irq0 <= 1'b0;
						if(data_in[6]) irq6 <= 1'b0;
						if(data_in[7]) irq7 <= 1'b0;
					end
					data_out <= {irq7, irq6, 5'h00, irq0};
				end
				8: begin
					if(bus_we) SPB <= data_in;
					data_out <= SPB;
				end
				9: begin
					if(bus_we) CSA <= data_in;
					data_out <= CSA;
				end
				10: begin
					if(bus_we) CSB <= data_in;
					data_out <= CSB;
				end
				11: begin
					if(bus_we) PUA <= data_in;
					data_out <= PUA;
				end
				12: begin
					if(bus_we) PUB <= data_in;
					data_out <= PUB;
				end
				13: begin
					if(bus_we) PDA <= data_in;
					data_out <= PDA;
				end
				14: begin
					if(bus_we) PDB <= data_in;
					data_out <= PDB;
				end
				default: data_out <= 8'hAA;
			endcase
		end
		if(irq0_trigger && !last_irq0_trigger) irq0 <= 1'b1;
		if(irq6_trigger && !last_irg6_trigger) irq6 <= 1'b1;
		if(irq7_trigger && !last_irq7_trigger) irq7 <= 1'b1;
		last_irq0_trigger <= irq0_trigger;
		last_irg6_trigger <= irq6_trigger;
		last_irq7_trigger <= irq7_trigger;
	end
end

endmodule
