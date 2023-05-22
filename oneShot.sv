`timescale 1ps/1ps

module oneShot(Clk, Q, Q_bar);

input Clk;
output Q, Q_bar;
logic X, Reset  /* synthesis keep */;

parameter propogation_delay = 60ps; //Smallest possible from expected board

not #(propogation_delay)	(X, Q);
not #(propogation_delay)	(Reset, X);

//instantiation of flip flop
//DFF1 (Clk, Reset, D, Q, Q_bar);
DFF1 unit0 (Clk, Reset, 1'b1, Q, Q_bar);


endmodule

`timescale 1ps/1ps

module oneShot_tb;

logic Clk, Q, Q_bar;

oneShot DUT (Clk, Q, Q_bar);


always begin  	
		Clk = 0;  	
		#500ns;  	
		Clk = 1'b1;  	
		#500ns;  
	end 

initial begin

#30000ns;
$stop;

end

endmodule