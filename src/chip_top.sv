// SPDX-FileCopyrightText: © 2025 Luca "Tholin" H.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module chip_top #(
    parameter NUM_BIDIR = 54
    )(
    `ifdef USE_POWER_PINS
    inout wire VDD,
    inout wire VSS,
    `endif

    inout  wire       clk_PAD,
    inout  wire       rst_n_PAD,
    
    inout  wire [NUM_BIDIR-1:0] bidir_PAD
);

    wire clk_PAD2CORE;
    wire rst_n_PAD2CORE;

    wire [NUM_BIDIR-1:0] bidir_PAD2CORE;
    wire [NUM_BIDIR-1:0] bidir_CORE2PAD;
    wire [NUM_BIDIR-1:0] bidir_CORE2PAD_OE;
    wire [NUM_BIDIR-1:0] bidir_CORE2PAD_CS;
    wire [NUM_BIDIR-1:0] bidir_CORE2PAD_SL;
    wire [NUM_BIDIR-1:0] bidir_CORE2PAD_IE;
    wire [NUM_BIDIR-1:0] bidir_CORE2PAD_PU;
    wire [NUM_BIDIR-1:0] bidir_CORE2PAD_PD;

    // Power / ground IO pad instances

    // South
    (* keep *)
    gf180mcu_fd_io__dvss dvss_south_0 (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VDD    (VDD)
        `endif
    );

    // East
    (* keep *)
    gf180mcu_ws_io__dvss dvss_east_0 (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VDD    (VDD)
        `endif
    );
    
    (* keep *)
    gf180mcu_ws_io__dvdd dvdd_east_0 (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VSS    (VSS)
        `endif
    );

    (* keep *)
    gf180mcu_ws_io__dvss dvss_east_1 (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VDD    (VDD)
        `endif
    );

    (* keep *)
    gf180mcu_ws_io__dvdd dvdd_east_1 (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VSS    (VSS)
        `endif
    );
    
   (* keep *)
    gf180mcu_ws_io__dvss dvss_east_2 (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VDD    (VDD)
        `endif
    );

    (* keep *)
    gf180mcu_ws_io__dvdd dvdd_east_2 (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VSS    (VSS)
        `endif
    );
    
    (* keep *)
    gf180mcu_ws_io__dvss dvss_east_3 (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VDD    (VDD)
        `endif
    );

    (* keep *)
    gf180mcu_ws_io__dvdd dvdd_east_3 (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VSS    (VSS)
        `endif
    );
    
    // North
    (* keep *)
    gf180mcu_fd_io__dvss dvss_north_0 (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VDD    (VDD)
        `endif
    );
    
    // West
    (* keep *)
    gf180mcu_ws_io__dvdd dvdd_west_0 (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VSS    (VSS)
        `endif
    );

    (* keep *)
    gf180mcu_ws_io__dvss dvss_west_0 (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VDD    (VDD)
        `endif
    );

    (* keep *)
    gf180mcu_ws_io__dvdd dvdd_west_1 (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VSS    (VSS)
        `endif
    );

    (* keep *)
    gf180mcu_ws_io__dvss dvss_west_1 (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VDD    (VDD)
        `endif
    );

    (* keep *)
    gf180mcu_ws_io__dvss dvss_west_2 (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VDD    (VDD)
        `endif
    );

    (* keep *)
    gf180mcu_ws_io__dvdd dvdd_west_2 (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VSS    (VSS)
        `endif
    );
    
    (* keep *)
    gf180mcu_ws_io__dvss dvss_west_3 (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VDD    (VDD)
        `endif
    );

    (* keep *)
    gf180mcu_ws_io__dvdd dvdd_west_3 (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VSS    (VSS)
        `endif
    );

    // Signal IO pad instances
    wire [3:0] const_zero;
    
    // Schmitt trigger
    gf180mcu_fd_io__in_s clk_pad (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VDD    (VDD),
        .VSS    (VSS),
        `endif
    
        .Y      (clk_PAD2CORE),
        .PAD    (clk_PAD),
        
        .PU     (const_zero[2]),
        .PD     (const_zero[3])
    );
    
    // Normal input
    gf180mcu_fd_io__in_c rst_n_pad (
        `ifdef USE_POWER_PINS
        .DVDD   (VDD),
        .DVSS   (VSS),
        .VDD    (VDD),
        .VSS    (VSS),
        `endif
    
        .Y      (rst_n_PAD2CORE),
        .PAD    (rst_n_PAD),
        
        .PU     (const_zero[0]),
        .PD     (const_zero[1])
    );

    generate
    for (genvar i=0; i<NUM_BIDIR; i++) begin : bidir
        gf180mcu_fd_io__bi_24t pad (
            `ifdef USE_POWER_PINS
            .DVDD   (VDD),
            .DVSS   (VSS),
            .VDD    (VDD),
            .VSS    (VSS),
            `endif
        
            .A      (bidir_CORE2PAD[i]),
            .OE     (bidir_CORE2PAD_OE[i]),
            .Y      (bidir_PAD2CORE[i]),
            .PAD    (bidir_PAD[i]),
            
            .CS     (bidir_CORE2PAD_CS[i]),
            .SL     (bidir_CORE2PAD_SL[i]),
            .IE     (bidir_CORE2PAD_IE[i]),

            .PU     (bidir_CORE2PAD_PU[i]),
            .PD     (bidir_CORE2PAD_PD[i])
        );
    end
    endgenerate

    // Core design
    wire reset;
    wire irq0;
    wire irq1;
    wire irq2;
    wire irq3;
    wire irq5;
    wire irq6;
    wire irq7;
    wire [7:0] bus_data_out;
    wire [7:0] bus_data_gpios;
    wire bus_cyc;
    wire [5:0] bus_addr;
    wire bus_we_gpios;
    wire [7:0] bus_data_timers;
    wire bus_we_timers;
    wire [7:0] bus_data_serial_ports;
    wire bus_we_serial_ports;
    wire [7:0] bus_data_sid;
    wire bus_we_sid;
    wire WEb_ram;
    wire le_lo_act;
    wire le_hi_act;
    wire boot_rom_en;
    wire [7:0] rom_bus_out;
    wire [7:0] rom_bus_in;
    wire [7:0] ram_bus_in;
    wire ram_enabled;
    wire [15:0] last_addr;
    wire [15:0] requested_addr;
    wrapped_as2650 wrapped_as2650 (
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif
        .clk_i(clk_PAD2CORE),
        .rst_n(rst_n_PAD2CORE),
        
        .io_in(bidir_PAD2CORE[18:0]),
        .io_out(bidir_CORE2PAD[18:0]),
        .io_oe(bidir_CORE2PAD_OE[18:0]),
        .io_ie(bidir_CORE2PAD_IE[18:0]),
        .io_sl(bidir_CORE2PAD_SL[18:0]),
        .io_pu(bidir_CORE2PAD_PU[18:0]),
        .io_pd(bidir_CORE2PAD_PD[18:0]),
        .io_cs(bidir_CORE2PAD_CS[18:0]),
        .const_zero(const_zero),

        .reset_out(reset),
        .irqs({irq7, irq6, irq5, irq3, irq2, irq1, irq0}),
        .bus_data_out(bus_data_out),
        .bus_cyc(bus_cyc),
        .bus_addr(bus_addr),
        .bus_we_gpios(bus_we_gpios),
        .bus_in_gpios(bus_data_gpios),
        .bus_in_timers(bus_data_timers),
        .bus_we_timers(bus_we_timers),
        .bus_in_serial_ports(bus_data_serial_ports),
        .bus_we_serial_ports(bus_we_serial_ports),
        .bus_in_sid(bus_data_sid),
        .bus_we_sid(bus_we_sid),
        .WEb_ram(WEb_ram),
        .le_lo_act(le_lo_act),
        .le_hi_act(le_hi_act),
        .boot_rom_en(boot_rom_en),
        .rom_bus_out(rom_bus_out),
        .rom_bus_in(rom_bus_in),
        .ram_bus_in(ram_bus_in),
        .ram_enabled(ram_enabled),
        .last_addr(last_addr),
        .requested_addr(requested_addr)
    );

    wire tmr0_o;
    wire tmr1_o;
    wire pwm0;
    wire pwm1;
    wire pwm2;
    wire TXD;
    wire RXD;
    wire tmr0_clk;
    wire tmr1_clk;
    wire DAC_clk;
    wire DAC_le;
    wire DAC_d1;
    wire DAC_d2;

    gpios gpios(
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif
        .io_in(bidir_PAD2CORE[34:19]),
        .io_out(bidir_CORE2PAD[34:19]),
        .io_oe(bidir_CORE2PAD_OE[34:19]),
        .io_ie(bidir_CORE2PAD_IE[34:19]),
        .io_cs(bidir_CORE2PAD_CS[34:19]),
        .io_sl(bidir_CORE2PAD_SL[34:19]),
        .io_pu(bidir_CORE2PAD_PU[34:19]),
        .io_pd(bidir_CORE2PAD_PD[34:19]),
        
        .clk_i(clk_PAD2CORE),
        .rst(reset),
        .addr(bus_addr[3:0]),
        .data_in(bus_data_out),
        .data_out(bus_data_gpios),
        .bus_cyc(bus_cyc),
        .bus_we(bus_we_gpios),
        .irq0(irq0),
        .irq6(irq6),
        .irq7(irq7),
        
        .tmr0_o(tmr0_o),
        .tmr1_o(tmr1_o),
        .pwm0(pwm0),
        .pwm1(pwm1),
        .pwm2(pwm2),
        .tmr0_clk(tmr0_clk),
        .tmr1_clk(tmr1_clk),
        .TXD(TXD),
        .RXD(RXD),
        .DAC_clk(DAC_clk),
        .DAC_le(DAC_le),
        .DAC_d1(DAC_d1),
        .DAC_d2(DAC_d2)
    );

    timers timers(
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif
        .clk_i(clk_PAD2CORE),
        .rst(reset),
        .addr(bus_addr),
        .data_in(bus_data_out),
        .data_out(bus_data_timers),
        .bus_cyc(bus_cyc),
        .bus_we(bus_we_timers),
        .irq1(irq1),
        .irq2(irq2),
        .irq5(irq5),
        .tmr0_o(tmr0_o),
        .tmr1_o(tmr1_o),
        .pwm0(pwm0),
        .pwm1(pwm1),
        .pwm2(pwm2),
        .tmr0_clk(tmr0_clk),
        .tmr1_clk(tmr1_clk)
    );

    serial_ports serial_ports(
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif
        .clk_i(clk_PAD2CORE),
        .rst(reset),
        .addr(bus_addr[2:0]),
        .data_in(bus_data_out),
        .data_out(bus_data_serial_ports),
        .bus_cyc(bus_cyc),
        .bus_we(bus_we_serial_ports),
        .irq3(irq3),
        .TXD(TXD),
        .RXD(RXD),
        .io_in(bidir_PAD2CORE[37]),
        .io_out(bidir_CORE2PAD[37:35]),
        .io_oe(bidir_CORE2PAD_OE[37:35]),
        .io_ie(bidir_CORE2PAD_IE[37:35]),
        .io_cs(bidir_CORE2PAD_CS[37:35]),
        .io_sl(bidir_CORE2PAD_SL[37:35]),
        .io_pu(bidir_CORE2PAD_PU[37:35]),
        .io_pd(bidir_CORE2PAD_PD[37:35])
    );

    unused unused(
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif
        .clk_i(clk_PAD2CORE),
        .rst(reset),
        .io_in(bidir_PAD2CORE[53:38]),
        .io_out(bidir_CORE2PAD[53:38]),
        .io_oe(bidir_CORE2PAD_OE[53:38]),
        .io_ie(bidir_CORE2PAD_IE[53:38]),
        .io_cs(bidir_CORE2PAD_CS[53:38]),
        .io_sl(bidir_CORE2PAD_SL[53:38]),
        .io_pu(bidir_CORE2PAD_PU[53:38]),
        .io_pd(bidir_CORE2PAD_PD[53:38])
    );

    boot_rom boot_rom(
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif
        .clk_i(clk_PAD2CORE),
        .rst(reset),
        .last_addr(last_addr[7:0]),
        .bus_out(rom_bus_in)
    );

    sid sid(
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif
        .clk(clk_PAD2CORE),
        .rst(reset),
        .DAC_clk(DAC_clk),
        .DAC_le(DAC_le),
        .DAC_dat_1(DAC_d1),
        .DAC_dat_2(DAC_d2),
        .addr(bus_addr),
        .bus_in(bus_data_out),
        .bus_out(bus_data_sid),
        .bus_cyc(bus_cyc),
        .bus_we(bus_we_sid)
    );

    wire CEN_all;
    wire [7:0] WEN_all;
    wire [8:0] A_all;
    wire [7:0] D_all;
    wire GWEN_0;
    wire GWEN_1;
    wire GWEN_2;
    wire GWEN_3;
    wire GWEN_4;
    wire GWEN_5;
    wire GWEN_6;
    wire GWEN_7;
    wire [7:0] Q0;
    wire [7:0] Q1;
    wire [7:0] Q2;
    wire [7:0] Q3;
    wire [7:0] Q4;
    wire [7:0] Q5;
    wire [7:0] Q6;
    wire [7:0] Q7;
    ram_controller ram_controller(
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif
        .clk_i(clk_PAD2CORE),
        .rst(reset),
        .WEb_ram(WEb_ram),
        .requested_addr(requested_addr),
        .bus_in(rom_bus_out),
        .bus_out(ram_bus_in),
        .ram_enabled(ram_enabled),
        .CEN_all(CEN_all),
        .WEN_all(WEN_all),
        .A_all(A_all),
        .D_all(D_all),
        .GWEN_0(GWEN_0),
        .GWEN_1(GWEN_1),
        .GWEN_2(GWEN_2),
        .GWEN_3(GWEN_3),
        .GWEN_4(GWEN_4),
        .GWEN_5(GWEN_5),
        .GWEN_6(GWEN_6),
        .GWEN_7(GWEN_7),
        .Q0(Q0),
        .Q1(Q1),
        .Q2(Q2),
        .Q3(Q3),
        .Q4(Q4),
        .Q5(Q5),
        .Q6(Q6),
        .Q7(Q7)
    );

    gf180mcu_fd_ip_sram__sram512x8m8wm1 sram0(
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif
        .CLK(clk_PAD2CORE),
        .CEN(CEN_all),
        .WEN(WEN_all),
        .A(A_all),
        .D(D_all),
        .GWEN(GWEN_0),
        .Q(Q0)
    );

    gf180mcu_fd_ip_sram__sram512x8m8wm1 sram1(
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif
        .CLK(clk_PAD2CORE),
        .CEN(CEN_all),
        .WEN(WEN_all),
        .A(A_all),
        .D(D_all),
        .GWEN(GWEN_1),
        .Q(Q1)
    );

    gf180mcu_fd_ip_sram__sram512x8m8wm1 sram2(
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif
        .CLK(clk_PAD2CORE),
        .CEN(CEN_all),
        .WEN(WEN_all),
        .A(A_all),
        .D(D_all),
        .GWEN(GWEN_2),
        .Q(Q2)
    );

    gf180mcu_fd_ip_sram__sram512x8m8wm1 sram3(
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif
        .CLK(clk_PAD2CORE),
        .CEN(CEN_all),
        .WEN(WEN_all),
        .A(A_all),
        .D(D_all),
        .GWEN(GWEN_3),
        .Q(Q3)
    );

    gf180mcu_fd_ip_sram__sram512x8m8wm1 sram4(
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif
        .CLK(clk_PAD2CORE),
        .CEN(CEN_all),
        .WEN(WEN_all),
        .A(A_all),
        .D(D_all),
        .GWEN(GWEN_4),
        .Q(Q4)
    );

    gf180mcu_fd_ip_sram__sram512x8m8wm1 sram5(
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif
        .CLK(clk_PAD2CORE),
        .CEN(CEN_all),
        .WEN(WEN_all),
        .A(A_all),
        .D(D_all),
        .GWEN(GWEN_5),
        .Q(Q5)
    );

    gf180mcu_fd_ip_sram__sram512x8m8wm1 sram6(
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif
        .CLK(clk_PAD2CORE),
        .CEN(CEN_all),
        .WEN(WEN_all),
        .A(A_all),
        .D(D_all),
        .GWEN(GWEN_6),
        .Q(Q6)
    );

    gf180mcu_fd_ip_sram__sram512x8m8wm1 sram7(
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif
        .CLK(clk_PAD2CORE),
        .CEN(CEN_all),
        .WEN(WEN_all),
        .A(A_all),
        .D(D_all),
        .GWEN(GWEN_7),
        .Q(Q7)
    );
    
    (* keep *)
    avali_logo avali_logo();
    
    // Chip ID - do not remove, necessary for tapeout
    (* keep *)
    gf180mcu_ws_ip__id chip_id ();
    
    // wafer.space logo - can be removed
    (* keep *)
    gf180mcu_ws_ip__logo wafer_space_logo ();

endmodule

`default_nettype wire
