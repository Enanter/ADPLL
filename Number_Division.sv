
// Code created by vipin on https://verilogcodes.blogspot.com/2015/11/synthesisable-verilog-code-for-division.html

module Number_Division(A,B,Res);

    //the size of input and output ports of the division module is generic.
    parameter WIDTH = 32;
    //input and output ports.
    input [WIDTH-1:0] A;
    input [WIDTH-1:0] B;
    output [WIDTH-1:0] Res;
    //internal variables    
    reg [WIDTH-1:0] Res = 0;
    reg [WIDTH-1:0] a1,b1;
    reg [WIDTH:0] p1;   
    integer i;

    always@ (A or B)
    begin
        //initialize the variables.
        a1 = A;
        b1 = B;
        p1= 0;
        for(i=0;i < WIDTH;i=i+1)    begin //start the for loop
            p1 = {p1[WIDTH-2:0],a1[WIDTH-1]};
            a1[WIDTH-1:1] = a1[WIDTH-2:0];
            p1 = p1-b1;
            if(p1[WIDTH-1] == 1)    begin
                a1[0] = 0;
                p1 = p1 + b1;   end
            else
                a1[0] = 1;
        end
        Res = a1;   
    end 

endmodule


module tb_division;
    parameter WIDTH = 8;
    // Inputs
    reg [WIDTH-1:0] A;
    reg [WIDTH-1:0] B;
    // Outputs
    wire [WIDTH-1:0] Res;

    // Instantiate the division module (UUT)
    Number_Division #(WIDTH) uut (
        .A(A), 
        .B(B), 
        .Res(Res)
    );

    initial begin
        // Initialize Inputs and wait for 100 ns
        A = 0;  B = 0;  #100;  //Undefined inputs
        //Apply each set of inputs and wait for 100 ns.
        A = 100;    B = 10; #100;
        A = 200;    B = 40; #100;
        A = 90; B = 9;  #100;
        A = 70; B = 10; #100;
        A = 16; B = 3;  #100;
        A = 255;    B = 5;  #100;
    end
      
endmodule