`timescale 1ns/1ps
module mac_vectors_tb;
    reg clk = 0;
    always #5 clk = ~clk;
    reg rst_n = 1, clear = 0, enable = 0;
    reg signed [7:0] a = 0, b = 0;
    wire signed [23:0] acc;
    reg signed [23:0] previous;
    integer fd, fields, rr, cc, ee, aa, bb, expected;
    integer count = 0, reset_checks = 0;
    mac dut(clk, rst_n, clear, enable, a, b, acc);
    initial begin
        fd = $fopen("build/mac_vectors.txt", "r");
        if (!fd) $fatal(1, "Cannot read vector file");
        fields = $fscanf(fd, "%d %d %d %d %d %d\n", rr, cc, ee, aa, bb, expected);
        while (fields == 6) begin
            @(negedge clk);
            previous = acc;
            rst_n = rr; clear = cc; enable = ee; a = aa; b = bb;
            #1; // Between active edges: reset is immediate; clear/enable are not.
            if (!rst_n) begin
                if (acc !== 24'sd0) $fatal(1, "Async reset failed at row %0d", count);
                reset_checks = reset_checks + 1;
            end else if (acc !== previous)
                $fatal(1, "Accumulator changed before active clock at row %0d", count);
            @(posedge clk);
            #1; // Observe after nonblocking assignments settle.
            if ($signed(acc) !== expected)
                $fatal(1, "Row %0d a=%0d b=%0d rst=%0d clear=%0d en=%0d got=%0d expected=%0d",
                       count, aa, bb, rr, cc, ee, $signed(acc), expected);
            count = count + 1;
            fields = $fscanf(fd, "%d %d %d %d %d %d\n", rr, cc, ee, aa, bb, expected);
        end
        if (!$feof(fd)) $fatal(1, "Malformed vector row %0d", count);
        $fclose(fd);
        if (count != 142123) $fatal(1, "Unexpected vector count: %0d", count);
        $display("PASS: %0d Python-reference MAC cycles; %0d between-edge reset checks", count, reset_checks);
        $finish;
    end
endmodule
