// módulo para definir se
// pixel pertence a janela
module janela(
	// entradas e saídas
	input [9:0]a,
	input [9:0]b,
	output s);
	
	// se pertencer a janela
	assign s = ((a < 640) & (b < 480));
	
endmodule