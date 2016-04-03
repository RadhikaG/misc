`include "requester.v"
`include "arbiter.v"

module top_level;

parameter NUM_REQUESTERS = 3;
parameter DATA_WIDTH = 4;

reg clk, rst, ready;

wire [NUM_REQUESTERS - 1:0] request_init_list; // array of signals saying whether requester i has initiated request
wire [NUM_REQUESTERS - 1:0] request_grant_list; // array of signals saying whether requester i has been granted request
wire [NUM_REQUESTERS - 1:0] read_writeBar_list;

wire [DATA_WIDTH - 1:0] req_data[NUM_REQUESTERS - 1:0];
wire [DATA_WIDTH - 1:0] data;

//reg [DATA_WIDTH - 1:0] memory[0:255]; // memory is of 256 rows and word size DATA_WIDTH

requester
#(
    .DATA_WIDTH(DATA_WIDTH)
)
r0
(
    .clk(clk),
    .ready(request_grant_list[0]),
    .valid(request_init_list[0]),
    .data(req_data[0]),
    .read_writeBar(read_writeBar_list[0])
);

requester
#(
    .DATA_WIDTH(DATA_WIDTH)
)
r1
(
    .clk(clk),
    .ready(request_grant_list[1]),
    .valid(request_init_list[1]),
    .data(req_data[1]),
    .read_writeBar(read_writeBar_list[1])
);

requester
#(
    .DATA_WIDTH(DATA_WIDTH)
)
r2
(
    .clk(clk),
    .ready(request_grant_list[2]),
    .valid(request_init_list[2]),
    .data(req_data[2]),
    .read_writeBar(read_writeBar_list[2])
);

arbiter
#(
    .DATA_WIDTH(DATA_WIDTH),
    .NUM_REQUESTERS(NUM_REQUESTERS)
)
arb
(
    .clk(clk),
    .rst(rst),
    .requesters(request_grant_list),
    .valid(request_init_list),
    .ready(ready)
);

endmodule
