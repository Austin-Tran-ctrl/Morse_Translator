module morse_shift_reg #(
    parameter MAX_SYMS = 5
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       sym_valid,
    input  wire       sym_dash,
    input  wire       char_end,
    input  wire       word_end,
    output reg  [5:0] key,
    output reg        key_valid,
    output reg        key_ovf,
    output reg        space_valid,
    output wire [2:0] sym_count
);

    reg [5:0] sr;
    reg [2:0] cnt;
    reg ovf;
    reg space_pend;

    assign sym_count = cnt;

    always @(posedge clk) begin
        key_valid <= 0;
        space_valid <= space_pend;
        space_pend <= 0;

        if(rst) begin
            space_valid <= 0;
            space_pend <= 0;
            sr <= 6'b000001;
            cnt <= 0;
            ovf <= 0;
            key <= 0;
            key_ovf <= 0;
        end else begin
            if(sym_valid) begin
                if(cnt < MAX_SYMS) begin
                    sr <= {sr[4:0], sym_dash};
                    cnt <= cnt + 1;
                end else begin
                    ovf <= 1;
                end
            end

            if(char_end || word_end) begin
                if(cnt != 0) begin
                    key <= sr;
                    key_ovf <= ovf;
                    key_valid <= 1;
                end
                sr <= 6'b000001;
                cnt <= 0;
                ovf <= 0;
                if(word_end) space_pend <= 1;
            end
        end
    end
endmodule