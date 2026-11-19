module morse_lut (
    input  wire       clk,
    input  wire       rst,
    input  wire       key_valid,
    input  wire [5:0] key,
    input  wire       key_ovf,
    input  wire       space_valid,
    output reg  [7:0] ascii,
    output reg        ascii_valid,
    output reg        err
);

    always @(posedge clk) begin
        ascii_valid <= 0;
        err <= 0;

        if(rst) begin
            ascii <= 0;
        end else if(key_valid) begin
            ascii_valid <= 1;
            if(key_ovf) begin
                ascii <= 0;
                err <= 1;
            end else begin
                case(key)
                    6'b000101: ascii <= "A";
                    6'b011000: ascii <= "B";
                    6'b011010: ascii <= "C";
                    6'b001100: ascii <= "D";
                    6'b000010: ascii <= "E";
                    6'b010010: ascii <= "F";
                    6'b001110: ascii <= "G";
                    6'b010000: ascii <= "H";
                    6'b000100: ascii <= "I";
                    6'b010111: ascii <= "J";
                    6'b001101: ascii <= "K";
                    6'b010100: ascii <= "L";
                    6'b000111: ascii <= "M";
                    6'b000110: ascii <= "N";
                    6'b001111: ascii <= "O";
                    6'b010110: ascii <= "P";
                    6'b011101: ascii <= "Q";
                    6'b001010: ascii <= "R";
                    6'b001000: ascii <= "S";
                    6'b000011: ascii <= "T";
                    6'b001001: ascii <= "U";
                    6'b010001: ascii <= "V";
                    6'b001011: ascii <= "W";
                    6'b011001: ascii <= "X";
                    6'b011011: ascii <= "Y";
                    6'b011100: ascii <= "Z";
                    6'b111111: ascii <= "0";
                    6'b101111: ascii <= "1";
                    6'b100111: ascii <= "2";
                    6'b100011: ascii <= "3";
                    6'b100001: ascii <= "4";
                    6'b100000: ascii <= "5";
                    6'b110000: ascii <= "6";
                    6'b111000: ascii <= "7";
                    6'b111100: ascii <= "8";
                    6'b111110: ascii <= "9";
                    default: begin
                        ascii <= 0;
                        err <= 1;
                    end
                endcase
            end
        end else if(space_valid) begin
            ascii <= 8'h20;
            ascii_valid <= 1;
        end
    end
endmodule