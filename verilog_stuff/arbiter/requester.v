// Requester module

module requester
#(
    parameter DATA_WIDTH = 8
)
(
    input clk,
    input ready,
    output valid,
    output read_writeBar,
    output [7:0] addr, // supports a memory of upto 256 rows
    inout [DATA_WIDTH - 1:0] data
);


endmodule
