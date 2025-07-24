// módulo de direção
module direcao_xy #(
	parameter CIMA = 3'b000, 				// sinal que informa CIMA como destino
	parameter BAIXO = 3'b001, 				// sinal que informa BAIXO como destino
	parameter ESQUERDA = 3'b010, 			//sinal que informa ESQUERDA como destino
	parameter DIREITA = 3'b011, 			// sinal que informa DIREITA como destino
	parameter LOCAL = 3'b100)( 			// sinal que informa LOCAL como destino
	input [1:0] meu_x, meu_y, 				// informa coordenada X desse roteador
	input [1:0] x_destino, y_destino,	// informa coordenada Y desse roteador
	input pronto, empty, 					// sinal de pronto (pacote já foi processado) e empty (fila vazia)
	output [2:0] direcao); 					// direção selecionada
	
	// define a direção assumindo que pacote ainda não foi processado
	assign direcao_normal = (x_destino > meu_x) ? DIREITA :
									(x_destino < meu_x) ? ESQUERDA :
									(y_destino > meu_y) ? BAIXO :
									(y_destino < meu_y) ? CIMA : LOCAL;
	
	// define a direção assumindo que pacote já foi processado
	assign direcao_final = (x_destino < 3) ? DIREITA :
								 (y_destino < 3) ? BAIXO : DIREITA;
	
	// escolhe a direção com base no bit de confirmação de processamento
	assign direcao_escolhida = pronto ? direcao_final : direcao_normal;
	
	// se a fila está vazia define joga sinal inválido na saída
	assign direcao = empty ? 3'b111 : direcao_escolhida;
	
endmodule