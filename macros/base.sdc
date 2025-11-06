set clock_port __VIRTUAL_CLK__
if { [info exists ::env(CLOCK_PORT)] } {
    set port_count [llength $::env(CLOCK_PORT)]

    if { $port_count == "0" } {
        puts "\[WARNING] No CLOCK_PORT found. A dummy clock will be used."
    } elseif { $port_count != "1" } {
        puts "\[WARNING] Multi-clock files are not currently supported by the base SDC file. Only the first clock will be constrained."
    }

    if { $port_count > "0" } {
        set ::clock_port [lindex $::env(CLOCK_PORT) 0]
    }
}
set port_args [get_ports $clock_port]
puts "\[INFO] Using clock $clock_port…"
create_clock {*}$port_args -name $clock_port -period $::env(CLOCK_PERIOD)

set input_delay_value [expr $::env(CLOCK_PERIOD) * $::env(IO_DELAY_CONSTRAINT) / 100]
set output_delay_value [expr $::env(CLOCK_PERIOD) * $::env(IO_DELAY_CONSTRAINT) / 100]
puts "\[INFO] Setting output delay to: $output_delay_value"
puts "\[INFO] Setting input delay to: $input_delay_value"

set_max_fanout $::env(MAX_FANOUT_CONSTRAINT) [current_design]
if { [info exists ::env(MAX_TRANSITION_CONSTRAINT)] } {
    set_max_transition $::env(MAX_TRANSITION_CONSTRAINT) [current_design]
}
if { [info exists ::env(MAX_CAPACITANCE_CONSTRAINT)] } {
    set_max_capacitance $::env(MAX_CAPACITANCE_CONSTRAINT) [current_design]
} 

set clk_input [get_port $clock_port]
set clk_indx [lsearch [all_inputs] $clk_input]
set all_inputs_wo_clk [lreplace [all_inputs] $clk_indx $clk_indx ""]

set all_inputs_wo_clk_rst $all_inputs_wo_clk

# correct resetn
set clocks [get_clocks $clock_port]

set_input_delay $input_delay_value -clock $clocks $all_inputs_wo_clk_rst
set_output_delay $output_delay_value -clock $clocks [all_outputs]

if { ![info exists ::env(SYNTH_CLK_DRIVING_CELL)] } {
    set ::env(SYNTH_CLK_DRIVING_CELL) $::env(SYNTH_DRIVING_CELL)
}

set_driving_cell \
    -lib_cell gf180mcu_fd_io__bi_24t \
    -pin PAD \
    $all_inputs_wo_clk_rst

set_driving_cell \
    -lib_cell gf180mcu_fd_io__in_s \
    -pin PAD \
    $clk_input

set cap_load [expr $::env(OUTPUT_CAP_LOAD) / 1000.0]
puts "\[INFO] Setting load to: $cap_load"
set_load $cap_load [all_outputs]

puts "\[INFO] Setting clock uncertainty to: $::env(CLOCK_UNCERTAINTY_CONSTRAINT)"
set_clock_uncertainty $::env(CLOCK_UNCERTAINTY_CONSTRAINT) $clocks

puts "\[INFO] Setting timing derate to: $::env(TIME_DERATING_CONSTRAINT)%"
set_timing_derate -early [expr 1-[expr $::env(TIME_DERATING_CONSTRAINT) / 100]]
set_timing_derate -late [expr 1+[expr $::env(TIME_DERATING_CONSTRAINT) / 100]]

if { [info exists ::env(OPENLANE_SDC_IDEAL_CLOCKS)] && $::env(OPENLANE_SDC_IDEAL_CLOCKS) } {
    unset_propagated_clock [all_clocks]
} else {
    set_propagated_clock [all_clocks]
}

# Clock source latency
# set clk_max_latency 2.5
# set clk_min_latency 0.6
# set_clock_latency -source -max $clk_max_latency $clocks
# set_clock_latency -source -min $clk_min_latency $clocks
# puts "\[INFO\]: Setting clock latency range: $clk_min_latency : $clk_max_latency"

# Clock input Transition
# set clk_tran 0.7
# set_input_transition $clk_tran [get_ports $clk_input]
# puts "\[INFO\]: Setting clock transition: $clk_tran"
# puts "\[INFO] Setting clock transition to: $clk_tran"
# set_clock_transition $clk_tran $clocks

# Input Transition
# set_input_transition -max 1.6  [get_ports {io_in[*]}]
# set_input_transition -min 0.56  [get_ports {io_in[*]}]
# set_input_transition -max 0.55  [get_ports {rst_n}]
# set_input_transition -min 0.2  [get_ports {rst_n}]
set_input_transition -max 0.55  [get_ports {rst}]
set_input_transition -min 0.2  [get_ports {rst}]

set_output_delay -min 8 -clock $clocks [get_ports {GWEN_*}]

set_input_delay 1 -clock $clocks [get_port rst_n]
set_input_delay 1 -clock $clocks [get_port rst]
# set_input_delay 2.3 -clock $clocks [get_ports {io_in[*]}]

# AS2650v2 internal bus lines
set bus_max_latency 5
set bus_min_latency 3
set_input_delay -min $bus_min_latency -clock $clocks [get_ports {addr[*]}]
set_input_delay -min $bus_min_latency -clock $clocks [get_ports {bus_in[*]}]
set_input_delay -min $bus_min_latency -clock $clocks [get_port bus_cyc]
set_input_delay -min $bus_min_latency -clock $clocks [get_port bus_we]
set_input_delay -max $bus_max_latency -clock $clocks [get_ports {addr[*]}]
set_input_delay -max $bus_max_latency -clock $clocks [get_ports {bus_in[*]}]
set_input_delay -max $bus_max_latency -clock $clocks [get_port bus_cyc]
set_input_delay -max $bus_max_latency -clock $clocks [get_port bus_we]
