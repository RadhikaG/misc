// Round-robin algorithm module

module round_robin
#(
    // default params
    parameter NUM_REQUESTERS = 2
)
(
    input clk,
    input rst,
    input ready,
    input [NUM_REQUESTERS - 1:0] requesters, // array of signals saying whether requester i has initiated request
    output [NUM_REQUESTERS - 1:0] valid // array of signals saying whether requester i has been granted request
);

    reg [NUM_REQUESTERS - 1:0] grant_req;
    reg [NUM_REQUESTERS - 1:0] previous_request;

    wire [NUM_REQUESTERS - 1:0] mask_previous;
    wire [NUM_REQUESTERS - 1:0] select_grant;
    wire [NUM_REQUESTERS - 1:0] isolate_lsb;
    wire [NUM_REQUESTERS - 1:0] win;
    
    assign valid = grant_req;

    assign mask_previous = requesters & ~((previous_request - 1) | previous_request); // mask off previous requester which was granted
    assign select_grant = mask_previous & (~mask_previous + 1); // select new requester
    assign isolate_lsb = requesters & (~requesters + 1); // isolating least significant bit
    assign win = mask_previous != 0 ? select_grant : isolate_lsb; // selecting new requester to be granted

    always @(posedge clk or posedge rst)
    begin
        if(rst == 1)
        begin
            previous_request <= 0;
            grant_req <= 0;
        end
        else if(ready == 1)
        begin
            if(win != 0)
            begin
                previous_request <= win;
            end
            else
            begin
                previous_request <= previous_request;
            end
            grant_req <= win;
        end
        else if(ready == 0)
        begin
            previous_request <= previous_request;
            grant_req <= grant_req;
            grant_req <= win;
        end
    end

endmodule
