// módulo multiplexador
module mux(
	// entradas e saídas
	input a,
	input b,
	input sel,
	output s);
	
	// true implida s=a
	// false implica s=b
	assign s = sel ? a : b;
	
endmodule