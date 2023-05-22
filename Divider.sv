`timescale 1ps/1ps
module Divider(En,Reset,C_N,F_input,F_output);

input En, Reset;
input [31:0] C_N;
input F_input;
output reg F_output;

reg [31:0] Natural, Decimal, Half_point1, Half_point2;
reg[15:0] count_1 = 16'd0; 
reg [15:0] count_p = 16'd0;
reg [15:0] Divisor;

always@(posedge F_input)begin

//calculate Natural Decimal and Halfway
	Natural = C_N[31:7];
	Decimal = C_N[6:0];
	Half_point1 = (Natural + 16'd1) >> 1; //Greater half point
	Half_point2 = Natural >> 1; //Lesser half point
	count_1 <= count_1 + 16'd1;
//if count_p < Decimal than Natural+1 else Natural
//This if statement is for first x/100 cycles where x is the decimal number. The frequency of these cycles will 
//be 1 greater than the whole number.
	if(Decimal>count_p)begin
		Divisor = Natural + 16'd1; //Set our Divisor to one greater than natural. 
		if(Half_point1 >= count_1)begin
			F_output = 1;
		end	
	
		else if(count_1 > (Half_point1))begin
			F_output = 0;
		end

		if(count_1 >= Divisor)begin //We have gone through one full cycle of Clk_1
			count_p <= count_p + 16'd1; 
			count_1 <= 16'd1;
		end
	end
//This statement is for the last (100-x)/100 cycles with a frequency == to the whole number. if number is whole, this is the
//only cycle that will run.
	else begin
		Divisor = Natural;
		if(Half_point2 >= count_1)begin
			F_output = 1;
		end	
	
		else if(count_1 > (Half_point2))begin
			F_output = 0;
		end

		if(count_1 >= (Divisor))begin
			count_p <= count_p + 16'd1;
			count_1 <= 16'd1;
		end
		if(count_p >= 16'd100)begin
			count_p <= 16'd0;
		end
	end
end

endmodule


module Divider_With_Decimal_tb;
reg En,Reset,F_input;
reg [31:0] C_N;
wire F_output;
Divider DUT(En,Reset,C_N,F_input,F_output);

always begin  	
	F_input = 1;
	#200;
	F_input = 0;
	#200; 
	end 

initial begin
		En = 1;
		Reset = 0;
		#10;
		C_N = 32'b000000000100000000;//Divide by 2
		#100000;
	
	$stop;
end
endmodule