module card7seg(input logic [3:0] card, output logic [6:0] seg7);

   `define card      4
  `define c_blank   4'b0000 //blank
  `define c_a       4'b0001 //Ace
  `define c_2       4'b0010 //2
  `define c_3       4'b0011 //3
  `define c_4       4'b0100 //4
  `define c_5       4'b0101 //5
  `define c_6       4'b0110 //6
  `define c_7       4'b0111 //7
  `define c_8       4'b1000 //8
  `define c_9       4'b1001 //9
  `define c_0       4'b1010 //0
  `define c_j       4'b1011 //Jack
  `define c_q       4'b1100 //Queen
  `define c_k       4'b1101 //King


always_comb begin
    case (card)                     //        Segments low (on)
        `c_blank: seg7 = {7{1'b1}};  //blank     none
        `c_a    : seg7 = 7'b0001000; //Ace       1,2,4,5,0      
        `c_2    : seg7 = 7'b0100100; //2         0,1,3,4,6      
        `c_3    : seg7 = 7'b0110000; //3         0,1,2,3,6       
        `c_4    : seg7 = 7'b0011001; //4         1,2,5,6       
        `c_5    : seg7 = 7'b0010010; //5         0,2,3,5,6       
        `c_6    : seg7 = 7'b0000010; //6         0,2,3,4,5,6       
        `c_7    : seg7 = 7'b1111000; //7         0,1,2;       
        `c_8    : seg7 = {7{1'b0}};  //8         all      
        `c_9    : seg7 = 7'b0010000; //9         0,1,2,3,5,6       
        `c_0    : seg7 = 7'b1000000; //0         0,1,2,3,4,5
        `c_j    : seg7 = 7'b1100001; //Jack      1,2,3,4      
        `c_q    : seg7 = 7'b0011000; //Queen     0,1,2,5,6       
        `c_k    : seg7 = 7'b0001001; //King      1,2,4,5,6      
        default : seg7 = {7{1'b1}};  //blank     all
    endcase
  end

endmodule

