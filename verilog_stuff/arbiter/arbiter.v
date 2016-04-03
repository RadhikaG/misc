// Arbiter module

`include "round_robin.v"

module arbiter
#(
    // default params
    parameter NUM_REQUESTERS = 2,
    parameter DATA_WIDTH = 8,
    parameter TRANSACTION_TYPE = 0 // 0 - single transactions, 1 - burst transactions
)
(
    input clk,
    input rst,
    input [NUM_REQUESTERS - 1:0] requesters, // array of signals saying whether requester i has initiated request
    output [NUM_REQUESTERS - 1:0] valid, // array of signals saying whether requester i has been granted request
    output reg ready // next stage circuit ready
);

    parameter BURST_LENGTH = 2;

    // if you need to change the arbitration algorithm,
    // just replace the module below with the same API
    round_robin 
    #(
        .NUM_REQUESTERS(NUM_REQUESTERS)
    )
    rr_arb
    (
        .clk(clk), 
        .rst(rst), 
        .requesters(requesters), 
        .valid(valid),
        .ready(ready)
    );

    integer burst_count;

    always @(posedge clk)
    begin
        ready <= 0; // default state is that next stage circuit is not ready
        if(TRANSACTION_TYPE == 0) // single transaction
        begin
            ready <= 1;
        end
        else // burst transaction
        begin
            if((valid & requesters == valid) && (burst_count < (BURST_LENGTH + 1)))
            begin
                ready <= 0;
                burst_count = burst_count + 1;
            end
            else
            begin
                ready <= 1;
                burst_count = 0;
            end
        end
    end

endmodule
