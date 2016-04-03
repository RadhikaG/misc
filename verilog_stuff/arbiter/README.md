# arbiter

This contains a simple round-robin arbiter, parameterized and split into different modules for flexible usage.

Before you run any of the given commands, first install iverilog and gtkwave.

Run `iverilog -o build/rr_tb round_robin_tb.v` and `vvp build/rr_tb` to run the test bench for the `round_robin` module.

To view the waveforms, just do `gtkwave round_robin_tb.vcd`.
