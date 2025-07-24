// módulo arbitrador
module arbitrador(
	input [4:0] req,		// entrada do vetor de requisições
	output [4:0] grant); // saída com vetor de garantia

	assign grant = req[4] ? 5'b10000 : // autorização para entrada de CIMA
						req[3] ? 5'b01000 : // autorização para entrada de BAIXO
						req[2] ? 5'b00100 : // autorização para entrada da ESQUERDA
						req[1] ? 5'b00010 : // autorização para entrada da DIREITA
						req[0] ? 5'b00001 : // autorização para entrada LOCAL
									5'b00000;  // nenhuma autorização concedida
	
endmodule