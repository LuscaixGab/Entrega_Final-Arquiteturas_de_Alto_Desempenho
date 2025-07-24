// módulo para reduzir a frequência de clock
module clk_1_seg(
	input clk,				// sinal de clock da placa
	output clk_lento,		// saída de clock mais lento
	output clk_rapido);	// saída de clock mais rápido
	
	// contador
	reg [25:0] contador;
	
	// inicialmente contador é zero
	initial begin
		contador = 0;
	end
	
	// a cada clock da placa
	always@(posedge clk) begin
		//incrementa o contador em 1 unidade
		contador = contador + 1;
	end
	
	// clock lento é bit 25 do contador
	assign clk_lento = contador[24];
	//clock rápido é o bit 24 do contador
	assign clk_rapido = contador[23];
	
endmodule