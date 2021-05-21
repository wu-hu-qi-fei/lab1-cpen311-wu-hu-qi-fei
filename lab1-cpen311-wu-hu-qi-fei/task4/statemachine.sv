module statemachine(input logic slow_clock, input logic resetb,
                    input logic [3:0] dscore, input logic [3:0] pscore, input logic [3:0] pcard3,
                    output logic load_pcard1, output logic load_pcard2, output logic load_pcard3,
                    output logic load_dcard1, output logic load_dcard2, output logic load_dcard3,
                    output logic player_win_light, output logic dealer_win_light);

// The code describing your state machine will go here.  Remember that
// a state machine consists of next state logic, output logic, and the 
// registers that hold the state.  You will want to review your notes from
// CPEN 211 or equivalent if you have forgotten how to write a state machine.
  
  

    reg [3:0] state, next_state; // present state and next state
    reg [5:0] load;

    parameter 
    // beginning states: two cards dealt and hands computed
    state1 = 4'b0001, state2 = 4'b0010, state3 = 4'b0011, 
    state4 = 4'b0100, state5 = 4'b0101, 
    // depending on the score of the hands, the game branches
    state6 = 4'b0110, state7 = 4'b0111, 
    finish = 4'b1000; // compute the final scores for the game and show the winner


    parameter [5:0] yes = 6'b000001, no = 6'b0; // for simplifying code

    always_comb begin
        case(state)
            state1 : next_state = state2;
            state2 : next_state = state3;
            state3 : next_state = state4;
            state4 : if ( (pscore == 8 ^ pscore == 9) || (dscore == 8 ^ dscore == 9) ) begin
                        next_state = finish;
                     end else if (pscore >= 0 && pscore <= 5) begin // if pscore in [0:5]
                        next_state = state5;
                     end else if (pscore == 6 ^ pscore == 7) begin 
                        next_state = state7;
                     end else begin
                        next_state = state4;
                     end
            state5 : next_state = state6;  // load pcard3 before entering state6
            state6, state7 : next_state = finish;
            finish : next_state = (resetb == 1'b0)? state1 : finish; // stay at the finish state until reset is asserted
            default: next_state = state1;// default to state1
        endcase
    end

 
    // note that resetb is asynchronous. 
    // always_ff because syncronous with slow_clock 
    always_ff @ (negedge slow_clock or negedge resetb) begin // change state at assertion of slow_clock or reset
        if(resetb == 1'b0)  // resetb is active low
            state <= state1; // go back to the initial state
    	else
            state <= next_state; // go to the next state
    end


   assign {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3} = load;
    always_comb begin // when state changes, update output immediately
        {player_win_light, dealer_win_light} = 2'b00;
        case (state)
            state1: load = 6'b100000; // load pcard1
            state2: load = 6'b000100; // load dcard1
            state3: load = 6'b010000; // load pcard2
            state4: load = 6'b000010; // load dcard2
            state5: load = 6'b001000; // load pcard3
            state6: if (dscore == 7) begin
                        load = no;   
                    end else if (dscore == 6) begin                
                        load = (pcard3 == 6 ^ pcard3 ==7)? yes : no;   // pcard3 in {6,7}
                    end else if (dscore == 5) begin               
                        load = (pcard3 >= 4 && pcard3 <= 7)? yes : no; // pcard3 in [4:7]
                    end else if (dscore == 4) begin               
                        load = (pcard3 >= 2 && pcard3 <= 7)? yes : no; // pcard3 in [2:7]
                    end else if (dscore == 3) begin                
                        load = (pcard3 != 8)? yes : no; 
                    end else if (dscore >= 0 && dscore <= 2) begin // if dscore in [0,2]
                        load = yes; 
                    end else begin
                        load = no;
                    end
            state7: load = (dscore >= 0 && dscore <= 5 )? yes : no; // player does not get third card, check if dealer does
            finish: begin 
                        load = no; //ensure that no new cards are loaded
                        if(pscore > dscore) begin
                            player_win_light = 1'b1; 
                        end else if (pscore < dscore) begin
                            dealer_win_light = 1'b1; 
                        end else if (pscore == dscore) begin
                            {player_win_light,dealer_win_light} = 2'b11; 
                        end 
                    end
            default: load = no;
        endcase
    end

endmodule

