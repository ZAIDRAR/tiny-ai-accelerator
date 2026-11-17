// Signed 8x8 multiply-accumulate block with 24-bit wrapping accumulator.
// Starter RTL — do not claim it has been physically implemented or verified.
module mac (
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire                 clear,
    input  wire                 enable,
    input  wire signed [7:0]    a,
    input  wire signed [7:0]    b,
    output reg  signed [23:0]   acc
);
    wire signed [15:0] product = a * b;
    wire signed [23:0] product_extended = {{8{product[15]}}, product};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            acc <= 24'sd0;
        else if (clear)
            acc <= 24'sd0;
        else if (enable)
            acc <= acc + product_extended;
    end
endmodule
