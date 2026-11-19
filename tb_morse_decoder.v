`timescale 1ns/1ps

module tb_morse_decoder;

reg clk;
reg rst;
reg sym_valid;
reg sym_dash;
reg char_end;
reg word_end;
wire [7:0] ascii;
wire ascii_valid;
wire err;
wire [6:0] seg;
wire [3:0] an;
wire dp;
wire [15:0] led;

integer n;

morse_decoder #(.CLK_HZ(32000)) dut(.clk(clk), .rst(rst), .sym_valid(sym_valid), .sym_dash(sym_dash), .char_end(char_end), .word_end(word_end), .ascii(ascii), .ascii_valid(ascii_valid), .err(err), .seg(seg), .an(an), .dp(dp), .led(led));

initial clk = 0;
always #5 clk = ~clk;

task sym;
input d;
begin
    @(posedge clk);
    sym_valid <= 1;
    sym_dash <= d;
    @(posedge clk);
    sym_valid <= 0;
    repeat (3) @(posedge clk);
end
endtask

task endc;
begin
    @(posedge clk);
    char_end <= 1;
    @(posedge clk);
    char_end <= 0;
    repeat (4) @(posedge clk);
end
endtask

task endw;
begin
    @(posedge clk);
    word_end <= 1;
    @(posedge clk);
    word_end <= 0;
    repeat (4) @(posedge clk);
end
endtask

always @(posedge clk) begin
    if (ascii_valid) begin
        n = n + 1;
        $display("got 0x%h err=%b", ascii, err);
    end
end

initial begin
    n = 0;
    rst = 1;
    sym_valid = 0;
    sym_dash = 0;
    char_end = 0;
    word_end = 0;
    repeat (4) @(posedge clk);
    rst <= 0;
    repeat (2) @(posedge clk);

    sym(0); sym(0); sym(0); endc;
    sym(1); sym(1); sym(1); endc;
    sym(0); sym(0); sym(0); endw;
    sym(0); sym(1); sym(1); sym(1); sym(1); endc;
    sym(1); sym(1); sym(1); sym(1); sym(1); sym(1); endc;
    sym(0); sym(1); endc;
    endc;

    repeat (50) @(posedge clk);
    $display("count = %0d, should be 7", n);
    $finish;
end

endmodule