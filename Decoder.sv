/* Zachary Weiss 4/22/2022
TCES 330
This is the Q1 portion of HW 3 
Here we describe a 7 seg display for hexidecimal
the digits are on the left 0-15 
corresponding 7 seg assignment is on the right
for the 7 seg : 0 is on, 1 is off */

module Decoder(SW, HEX);

  	input [3:0] SW; //4 switchs 
	output logic [0:6] HEX; // 7 seg outputs

		always @(SW) begin
			case (SW)  
//input switch is left output is on right
			4'b0000: HEX = 7'b1000000; //0
			4'b0001: HEX = 7'b1111001; //1 
			4'b0010: HEX = 7'b0100100; //2
 			4'b0011: HEX = 7'b0110000; //3
			4'b0100: HEX = 7'b0011001; //4
			4'b0101: HEX = 7'b0010010; //5
			4'b0110: HEX = 7'b0000010; //6
			4'b0111: HEX = 7'b1111000; //7
			4'b1000: HEX = 7'b0000000; //8
			4'b1001: HEX = 7'b0010000; //9
			default: HEX = 7'b1111111; //off
			
			endcase
		end

endmodule 
