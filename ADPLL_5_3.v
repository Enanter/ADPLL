	
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module ADPLL_5_3(

	//////////// CLOCK //////////
	input 		          		CLOCK_50_B5B,
	//////////// KEY //////////
	input 		          		CPU_RESET_n,
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,

	//////////// GPIO, GPIO connect to GPIO Default //////////
	inout 		    [35:0]		GPIO,
	output Clock1,
	output Clock2

	
);



//=======================================================
//  REG/WIRE declarations
//=======================================================
	wire [31:0] Control_Signal;
	reg input_Clk;
	wire C_INFO;
	reg [31:0] counter = 0;
	localparam CLOCK_DIVIDER = 200; // 
	//no function generator so we have to do this
	
	always @(posedge CLOCK_50_B5B) begin
		if (counter == (CLOCK_DIVIDER)) begin
			input_Clk <= ~input_Clk; // invert the slow clock signal every 50 cycles
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	
	//assign input_Clk = GPIO[10];
	assign C_INFO = SW[4];//Multiply frequency if 1 target if 0
	
//=======================================================
//  Structural coding
//=======================================================
	User_Input Unit2(CLOCK_50_B5B,CPU_RESET_n,KEY,SW,HEX0,HEX1,GPIO,Control_Signal);

	ADPLL Unit1 (SW[0], SW[1], SW[2], ~CPU_RESET_n ,input_Clk,C_INFO,Control_Signal,CLOCK_50_B5B,Clock1,Clock2);
	
	assign GPIO[4] = input_Clk; //orange
	//assign GPIO[19] = (SW[3])? Clock2:Clock1;
	assign GPIO[19] = Clock1; //white
	assign GPIO[21] = Clock2; //yellow
	//assign GPIO[2] = CLOCK_50_B5B;



endmodule
