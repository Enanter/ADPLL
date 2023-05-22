`timescale 1ps/1ps

/*first gate is a NAND w/ Enable
all consecutive NOT gates in series
total number of gates must be odd therefore we generate an even number of NOT gate
We must manually add time delay since simulated inverter has propogation delay of 0*/

//NOTE: RTL shows 3 inverters because synthesis converters NAND into AND in series with inverter


module ringOscillator(En, one_shot, F_ring);

	input one_shot, En;
	output F_ring;
	//number of inverters minimum possible 2
	logic [2:0] inverter /* synthesis keep */; 
	parameter propogation_delay = 30ps;

	nand #(propogation_delay)	(inverter[0], one_shot, inverter[2], En);
	not #(propogation_delay)	(inverter[1], inverter[0]);
	not #(propogation_delay)	(inverter[2], inverter[1]);  

	assign F_ring = inverter[2];

endmodule

`timescale 1ps/1ps

module ringOscillator_tb;

logic En, one_shot, F_ring;
logic [2:0] inverter;

ringOscillator DUT (En, one_shot, F_ring);

initial begin
	
	one_shot = 0; #100;
	one_shot = 1'b1; #1000;
	one_shot = 0; #200; 
	one_shot = 1'b1; #1000;
$stop;

end

endmodule
