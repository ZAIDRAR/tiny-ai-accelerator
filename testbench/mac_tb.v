// Starter self-checking testbench for mac.v.
// Runs only with a compatible Verilog simulator; no results pre-recorded.
`timescale 1ns/1ps

module mac_tb;
    reg clk = 1'b0;
    always #5 clk = ~clk;

    reg rst_n = 1'b0;
    reg clear = 1'b0;
    reg enable = 1'b0;
    reg signed [7:0] a = 8'sd0;
    reg signed [7:0] b = 8'sd0;
    wire signed [23:0] acc;
    integer checks = 0;

    mac dut (
        .clk(clk), .rst_n(rst_n), .clear(clear), .enable(enable),
        .a(a), .b(b), .acc(acc)
    );

    task step;
        input signed [7:0] aa;
        input signed [7:0] bb;
        input en;
        input clr;
        input signed [23:0] expected;
        begin
            @(negedge clk);
            a = aa;
            b = bb;
            enable = en;
            clear = clr;
            @(posedge clk);
            #1;
            if (acc !== expected) begin
                $display("FAIL a=%0d b=%0d enable=%b clear=%b acc=%0d expected=%0d",
                         a, b, enable, clear, acc, expected);
                $fatal(1, "MAC check failed");
            end
            checks = checks + 1;
        end
    endtask

    initial begin
        $dumpfile("build/mac_waveforms.vcd");
        $dumpvars(0, mac_tb);

        // Reset: asynchronous active-low
        repeat (2) @(posedge clk);
        #1;
        if (acc !== 24'sd0)
            $fatal(1, "Reset failed");

        @(negedge clk);
        rst_n = 1'b1;

        step(8'sd3, 8'sd4, 1'b1, 1'b0,  24'sd12);
        step(8'shFE, 8'sd7, 1'b1, 1'b0, -24'sd2);
        step(8'sh7F, 8'sh80, 1'b1, 1'b0, -24'sd16258);
        step(8'sd5, 8'sd9, 1'b0, 1'b0, -24'sd16258); // hold
        step(8'sd5, 8'sd9, 1'b1, 1'b1,  24'sd0);    // clear priority
        step(8'sh80, 8'sh80, 1'b1, 1'b0, 24'sd16384);
        step(8'sd0, 8'sd42, 1'b1, 1'b0, 24'sd16384);

        $display("All %0d starter MAC checks passed.", checks);
        $finish;
    end
endmodule
