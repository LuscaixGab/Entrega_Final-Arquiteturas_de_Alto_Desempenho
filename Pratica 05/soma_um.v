module soma_um(
	input [1:0] x,
	output [1:0] s);
	
	assign s = x + 3'b001;
	
endmodule