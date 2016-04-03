`include "round_robin.v"
`timescale 1 ns / 100 ps

module round_robin_tb();

    parameter NUM_REQUESTERS = 3;

    reg clk, rst, ready;
    reg [NUM_REQUESTERS - 1:0] requesters;
    wire [NUM_REQUESTERS - 1:0] valid;

    // instantiating DUT
    round_robin
    #(
        .NUM_REQUESTERS(NUM_REQUESTERS)
    )
    U0
    (
        .clk(clk),
        .rst(rst),
        .ready(ready),
        .requesters(requesters),
        .valid(valid)
    );

    initial
    begin
        $dumpfile("round_robin_wave.vcd");
        $dumpvars;
    end

    initial
    begin
        clk = 0;
        rst = 1;
        // toggling clock and rst to initialize
        // normal operation.
        repeat(4) #10 clk = ~clk;
        rst = 0;
        forever #10 clk = ~clk;
        // Beginning normal operation
        ready = 1;
        requesters = 3'b000;
    end

    // Actual testing part
    initial
    begin
        ready = 1;
        // uncomment 'ready' lines below to check burst mode functioning
        #40 requesters = 3'b101;
            //ready = 1;
        #20 requesters = 3'b001;
            //ready = 0;
        #20 requesters = 3'b110;
            //ready = 1;
        #20 requesters = 3'b111;
            //ready = 0;
        #20 requesters = 3'b100;
            //ready = 1;
        #20 requesters = 3'b101;
            //ready = 0;
        #20 requesters = 3'b011;
            //ready = 1;
        #20 requesters = 3'b000;
        $finish;
    end

endmodule
