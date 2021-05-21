module tb_card7seg();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").
	reg [3:0] card;  
    wire [6:0] HEX0; 

	card7seg hexdisp (.sw(sw), .HEX0(HEX0)); 

    //display output
    initial begin
        card = 0;
        repeat (16) begin
            $display ("card = %b  HEX0 = %b", card, HEX0);
            card += 1; #20; 
        end
        $stop;
    end
						
endmodule

