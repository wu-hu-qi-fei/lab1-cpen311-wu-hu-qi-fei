module scorehand(input logic [3:0] card1, input logic [3:0] card2, input logic [3:0] card3, output logic [3:0] total);

// The code describing scorehand will go here.  Remember this is a combinational
// block. The function is described in the handout. Be sure to review Verilog
// notes on bitwidth mismatches and signed/unsigned numbers.
   reg [3:0] Value1, Value2, Value3; // individual card score values

    always_comb begin
        if (card1 >= 1 && card1 <= 9) begin
            Value1 = card1;
        end else begin
            Value1 = 0;
        end

        if (card2 >= 1 && card2 <= 9) begin
            Value2 = card2;
        end else begin
            Value2 = 0;
        end

        if (card3 >= 1 && card3 <= 9) begin
            Value3 = card3;
        end else begin
            Value3 = 0;
        end

        total = (Value1 + Value2 + Value3) % 10;
    end


endmodule

