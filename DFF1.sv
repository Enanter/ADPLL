`timescale 1ps/1ps

module DFF1 (Clk, Reset, D, Q, Q_bar);  

input D, Clk, Reset;  
output logic Q; 
output Q_bar;
 
always_ff @(negedge Reset, posedge Clk)  

begin

if (!Reset)  

Q <= D;
  
else 
 
Q <= 0;  

end

assign Q_bar = ~Q;

endmodule 


`timescale 1ps/1ps

module DFF1_tb;

logic Clk, Reset, D, Q, Q_bar;


DFF1 DUT (Clk, Reset, D, Q, Q_bar);


always begin  	
		Clk = 0;  	
		#50ns;  	
		Clk = 1'b1;  	
		#50ns;  
	end 

initial begin

	D = 0; Reset = 0; Q = 0; #10ns;
	D = 1'b1; #200ns;
	Reset = 1'b1; #100ns
	Reset = 0; #500ns
$stop;

end

endmodule
