//Author: Dylan


//Takes a control signal Target_Freq. This is a 32 bit number representing two 16 bit numbers with 7 of those bits representing the decimal places.
//Target Freq should be in Mhz so you can currently target anywhere from 511.99 Mhz to 0.01 Mhz (or 10 kilohertz)
//Requires Ratio of how many times faster that the Crystal oscillator is from the input. If crystal is 2.5 times faster Ratio_Crystal should equal 250.
//Crystal frequecy has been hardcoded in as 50 Mhz on line 18, if needed this value can be changed. 
//Will calculate a multiplier to be sent to Divider module this number again can range from 511.99 to 0.01

//modified: Jisu
//similar thing to Controller.

`timescale 1ps/1ps
module TargetController (En, Reset, C_RX, C_N, C_N1,C_N2);

	input En, Reset;
	input reg [31:0] C_RX;//Ratio_Crystal
	input reg [31:0] C_N;//target frequency
	output reg [31:0] C_N1,C_N2;
	reg [31:0] fltDvs1,fltF1;	//floating number divisor, floating number final
	reg [31:0] fltDvs2,fltF2;	//floating number divisor, floating number final
	reg [31:0] intDvs1,intF1;	//integer number divisor,integer number final
	reg [31:0] intDvs2,intF2;	//integer number divisor,integer number final
	
	reg [31:0] dvs1,dvs2;	//final divisor=(intDvs*100+fltDvs*100)
	reg [31:0] rmn1,rmn2;// reminder = C_ratio-(intF*Dvs)
	
	reg[31:0] ringSpd;//ring speed =C_Targ*50, 50: crystal oscillator speed

	parameter xtalSpd = 6'd45; //50 MHz
	//ringSpd=C_RX*7'd50*100;
	assign ringSpd = C_RX*xtalSpd;
	assign intDvs1 = C_N[15:7];
	assign intDvs2 = C_N[31:23];
	assign fltDvs1 = C_N[6:0];
	assign fltDvs2 = C_N[22:16];
	
	//dvs = intDvs*7'd100+fltDvs;
	assign dvs1 = intDvs1*7'd100+fltDvs1;
	assign dvs2 = intDvs2*7'd100+fltDvs2;
	//ringSpd/dvs=intF;
	//module Number_Division(Dividend,Divisor,Result);
	Number_Division intFinalOne (ringSpd,dvs1,intF1);
	Number_Division intFinalTwo (ringSpd,dvs2,intF2);	
	//	rmn = (ringSpd-(intF*dvs))*7'd100;
	assign rmn1 = (ringSpd - (intF1*dvs1))*7'd100;
	assign rmn2 = (ringSpd - (intF2*dvs2))*7'd100;
	//rmn/dvs=fltF;
	Number_Division fltFinalOne (rmn1,dvs1,fltF1);
	Number_Division fltFinalTwo (rmn2,dvs2,fltF2);
	
	assign C_N1[31:7] = intF1[25:0];
	assign C_N1[6:0] = fltF1[6:0];
	assign C_N2[31:7] = intF2[25:0];
	assign C_N2[6:0] = fltF2[6:0];

endmodule


`timescale 1ps/1ps
module TargetCont_Tb;
	logic En, Reset;
	logic [31:0] C_RX;//Ratio_Crystal
	logic [31:0] C_N;//target frequency
	logic [31:0] C_N1,C_N2;
	//module TargetController (En, Reset, C_RX, C_N, C_N1,C_N2);
	TargetController DUT (En, Reset, C_RX, C_N, C_N1,C_N2);


initial begin
		
		Reset=1'b0;
		C_RX = 16'd250; //Crystal is 2.5 times faster than input (input = 20 Mhz)
		C_N = 32'b00001100101111110000100010110010;//25.63 and 17.50
		#20;
		#200;
		/*Ratio_Crystal = 16'd200; //Crystal is 2 times faster than input (input = 25 Mhz)
		Target_Freq = 32'b00001100101111110000100010110010;//25.63 and 17.50
		#200;
		Reset =1'b0;
		Ratio_Crystal = 16'd112; //Crystal is 1.12 times faster than input (input = 44.64 Mhz)
		Target_Freq = 32'b00001100101111110000100010110010;//25.63 and 17.50
		#200;
		*/

		//C_RX = 32'd250;	//  0000 0000
		//C_N = 32'b00110010000000000001100100110010;//100 and 50.50
		//#10000;

	
	$stop;
end
endmodule 