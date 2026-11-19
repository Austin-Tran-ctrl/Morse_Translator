module seg7_driver #(
    parameter CLK_HZ = 100000000,
    parameter ACTIVE_LOW = 1
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       ascii_valid,
    input  wire [7:0] ascii,
    input  wire       err,
    output wire [6:0] seg,
    output wire [3:0] an,
    output wire       dp
);

    localparam DIV = CLK_HZ / 4000;

    reg [7:0] ch0;
    reg [7:0] ch1;
    reg [7:0] ch2;
    reg [7:0] ch3;
    reg bad0, bad1, bad2, bad3;

    reg [31:0] tick;
    reg [1:0] sel;

    reg [7:0] cur;
    reg curbad;
    reg [3:0] an_hi;
    wire [6:0] seg_hi;

    always @(posedge clk) begin
        if(rst) begin
            ch0 <= 8'h20;
            ch1 <= 8'h20;
            ch2 <= 8'h20;
            ch3 <= 8'h20;
            bad0 <= 0;
            bad1 <= 0;
            bad2 <= 0;
            bad3 <= 0;
        end else if(ascii_valid) begin
            ch3 <= ch2;
            ch2 <= ch1;
            ch1 <= ch0;
            ch0 <= ascii;
            bad3 <= bad2;
            bad2 <= bad1;
            bad1 <= bad0;
            bad0 <= err;
        end
    end

    always @(posedge clk) begin
        if(rst) begin
            tick <= 0;
            sel <= 0;
        end else if(tick == DIV - 1) begin
            tick <= 0;
            sel <= sel + 1;
        end else begin
            tick <= tick + 1;
        end
    end

    always @(*) begin
        case(sel)
            0: begin
                cur = ch0;
                curbad = bad0;
                an_hi = 4'b0001;
            end
            1: begin
                cur = ch1;
                curbad = bad1;
                an_hi = 4'b0010;
            end
            2: begin
                cur = ch2;
                curbad = bad2;
                an_hi = 4'b0100;
            end
            default: begin
                cur = ch3;
                curbad = bad3;
                an_hi = 4'b1000;
            end
        endcase
    end

    ascii_to_7seg font(.ascii(cur), .err(curbad), .seg(seg_hi));

    assign seg = ACTIVE_LOW ? ~seg_hi : seg_hi;
    assign an = ACTIVE_LOW ? ~an_hi : an_hi;
    assign dp = ACTIVE_LOW ? 1'b1 : 1'b0;
endmodule