module morse_decoder #(
    parameter CLK_HZ = 100000000
)(
    input  wire        clk,
    input  wire        rst,
    input  wire        sym_valid,
    input  wire        sym_dash,
    input  wire        char_end,
    input  wire        word_end,
    output wire [7:0]  ascii,
    output wire        ascii_valid,
    output wire        err,
    output wire [6:0]  seg,
    output wire [3:0]  an,
    output wire        dp,
    output wire [15:0] led
);

    wire [5:0] key;
    wire key_valid;
    wire key_ovf;
    wire space_valid;
    wire [2:0] sym_count;

    reg [7:0] last_ascii;
    reg last_err;
    reg [27:0] act;

    morse_shift_reg sr1 (
        .clk(clk),
        .rst(rst),
        .sym_valid(sym_valid),
        .sym_dash(sym_dash),
        .char_end(char_end),
        .word_end(word_end),
        .key(key),
        .key_valid(key_valid),
        .key_ovf(key_ovf),
        .space_valid(space_valid),
        .sym_count(sym_count)
    );

    morse_lut lut1 (
        .clk(clk),
        .rst(rst),
        .key_valid(key_valid),
        .key(key),
        .key_ovf(key_ovf),
        .space_valid(space_valid),
        .ascii(ascii),
        .ascii_valid(ascii_valid),
        .err(err)
    );

    seg7_driver #(.CLK_HZ(CLK_HZ)) disp1 (
        .clk(clk),
        .rst(rst),
        .ascii_valid(ascii_valid),
        .ascii(ascii),
        .err(err),
        .seg(seg),
        .an(an),
        .dp(dp)
    );

    always @(posedge clk) begin
        if(rst) begin
            last_ascii <= 0;
            last_err <= 0;
            act <= 0;
        end else begin
            if(ascii_valid) begin
                last_ascii <= ascii;
                last_err <= err;
                act <= CLK_HZ / 10;
            end else if(act != 0) begin
                act <= act - 1;
            end
        end
    end

    assign led = {3'b000, (act != 0), last_err, sym_count, last_ascii};
endmodule