// This module takes a control signal that represents two multipliers.
// These Multipliers can range from 00.00 to 511.99.
// This module then takes those multipliers and calculates what number we need to divide our Ring oscillator by to achieve the expected output in later modules.
`timescale 1ps/1ps
module Controller (En, Reset, C_N, C_Freq, C_N1, C_N2);

input En, Reset;
input reg[31:0] C_N, C_Freq; //C_N: target multiplier, C_Freq: control signal of frequency data.
output reg[31:0] C_N2, C_N1;
reg [25:0] Whole_1, Whole_2;
reg [6:0] Dec_1, Dec_2;
reg [31:0] TC1, TC2, T1,T2,T3,Tw1,Tw2, Tw1x,Tw2x; //Temporary intermediate values

assign Dec_1 = C_N[6:0];
assign Whole_1 = C_N[15:7];
assign Dec_2 = C_N[22:16];
assign Whole_2 = C_N[31:23];
assign T3 = C_Freq*100;

assign TC1 = ((8'd100*Whole_1 + Dec_1)); 
assign TC2 = ((8'd100*Whole_2 + Dec_2));

Number_Division DUT1(T3,TC1,T1); 
Number_Division DUT2(T3,TC2,T2);

Number_Division DUT3(T1,32'd100,Tw1);
Number_Division DUT4(T2,32'd100,Tw2);

assign C_N1[31:7] = Tw1;
assign C_N2[31:7] = Tw2;

assign Tw1x = Tw1*7'd100;
assign Tw2x = Tw2*7'd100;

assign C_N1[6:0] = T1-Tw1x;
assign C_N2[6:0] = T2-Tw2x;

	//T2 = C_Freq*100/(100*Whole_2 + Dec_2);
	//Whole_2 = (T2/100);
	//Dec_2 = T2-Whole_2*100;

endmodule


module Controller_TB;
	reg En, Reset;
	reg[31:0] C_N, C_Freq;
	wire[31:0] C_N2, C_N1;
	Controller DUT (En, Reset, C_N, C_Freq, C_N1, C_N2);
initial begin
	Reset = 1;
	En = 0;
	#10;
	En = 1;
	Reset =0;
	C_N = 32'b00000001000000000000000110000000;//2 and 3
	//C_N=32'b000000010 0000000 000000011 0000000
	C_Freq = 32'd500000;
	#100;
	$stop;
end
endmodule
