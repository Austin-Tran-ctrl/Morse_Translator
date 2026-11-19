module ascii_to_7seg (
    input  wire [7:0] ascii,
    input  wire       err,
    output reg  [6:0] seg
);

    always @(*) begin
        if(err) begin
            seg = 7'b0001000;
        end else begin
            case(ascii)
                "0": seg = 7'b0111111;
                "1": seg = 7'b0000110;
                "2": seg = 7'b1011011;
                "3": seg = 7'b1001111;
                "4": seg = 7'b1100110;
                "5": seg = 7'b1101101;
                "6": seg = 7'b1111101;
                "7": seg = 7'b0000111;
                "8": seg = 7'b1111111;
                "9": seg = 7'b1101111;
                "A": seg = 7'b1110111;
                "B": seg = 7'b1111100;
                "C": seg = 7'b0111001;
                "D": seg = 7'b1011110;
                "E": seg = 7'b1111001;
                "F": seg = 7'b1110001;
                "G": seg = 7'b0111101;
                "H": seg = 7'b1110110;
                "I": seg = 7'b0000110;
                "J": seg = 7'b0001110;
                "K": seg = 7'b1110101;
                "L": seg = 7'b0111000;
                "M": seg = 7'b0110111;
                "N": seg = 7'b1010100;
                "O": seg = 7'b0111111;
                "P": seg = 7'b1110011;
                "Q": seg = 7'b1100111;
                "R": seg = 7'b1010000;
                "S": seg = 7'b1101101;
                "T": seg = 7'b1111000;
                "U": seg = 7'b0111110;
                "V": seg = 7'b0011100;
                "W": seg = 7'b0101010;
                "X": seg = 7'b1001001;
                "Y": seg = 7'b1101110;
                "Z": seg = 7'b1011011;
                default: seg = 7'b0000000;
            endcase
        end
    end
endmodule