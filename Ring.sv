`timescale 1ps/1ps

module Ring (Clk, volt_0, volt_1, F_ring);

input Clk, volt_0, volt_1;
output F_ring;
logic Q, Q_bar;

//voltages that enable ring oscillator operation


and (En, volt_0, volt_1);


//oneShot(Clk, Q, Q_bar);

oneShot DUT0 (Clk, Q, Q_bar);

//ringOscillator(En, one_shot, F_ring);

//Sending Q to the Ring Oscillator means the one-shot buffer period is specifiying the amount of time the ring oscillaotr is off
//Sending Q_bar means you are specifiying the length it is on.
ringOscillator DUT1 (En, Q, F_ring);

endmodule

`timescale 1ps/1ps

module Ring_tb;

logic Clk, F_ring, volt_0, volt_1;


Ring DUT (Clk, volt_0, volt_1, F_ring);

always begin  	
		Clk = 0;  	
		#500ns;  	
		Clk = 1'b1;  	
		#500ns;  
	end 

initial begin

	#10;
	volt_0 = 1'b1;
	volt_1 = 1'b1;
	
	#0.01ms;
	
$stop;

end

endmodule