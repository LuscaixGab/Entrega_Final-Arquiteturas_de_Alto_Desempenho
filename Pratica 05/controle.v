// módulo de controle
module controle #(
	parameter DATA_W = 14)(																							// tamanho do pacote
	input clk, rst,																									// sinal de clock e reset
	input [2:0] direcao_cima, direcao_baixo, direcao_esquerda, direcao_direita, direcao_core,	// sinais recebidos dos módulos de direção de cada fila
	input empty_cima, empty_baixo, empty_esquerda, empty_direita, empty_core,						// sinal de fila vazia de cada fila
	input full_cima, full_baixo, full_esquerda, full_direita, full_core,								// sinal de fila cheia de cada fila
	input [4:0] grant_cima, grant_baixo, grant_esquerda, grant_direita, grant_core,				// sinal de encaminhamento de cada fila
	output reg rd_en_cima, rd_en_baixo, rd_en_esquerda, rd_en_direita, rd_en_core,				// sinal para habilitar leitura de pacotes de roteadores vizinhos e processador
	output reg [4:0] req_cima, req_baixo, req_esquerda, req_direita, req_core,						// sinal de requisição de cada fila
	output reg [2:0] sel_cima, sel_baixo, sel_esquerda, sel_direita, sel_core);					// sinal seletor do switch crossbar
	
	// interpretação dos sinais seletores
	localparam CIMA = 3'b000;
	localparam BAIXO = 3'b001;
	localparam ESQUERDA = 3'b010;
	localparam DIREITA = 3'b011;
	localparam CORE = 3'b100;
	
	// atribuição contínua
	always @(*) begin
		// zera todos os vetores de requisição
		req_cima = 5'b0;
		req_baixo = 5'b0;
		req_esquerda = 5'b0;
		req_direita = 5'b0;
		req_core = 5'b0;
		
		// se a fila de cima não está vazia
		if (!empty_cima) begin
			// identifica a direção que o pacote quer seguir 
			case(direcao_cima)
				// marca a requisição daquela saída se a fila do roteador vizinho não estiver cheia
				CIMA: if (!full_cima) req_cima[4] = 1;
				BAIXO: if (!full_baixo) req_baixo[4] = 1;
				ESQUERDA: if (!full_esquerda) req_esquerda[4] = 1;
				DIREITA: if (!full_direita) req_direita[4] = 1;
				CORE: if (!full_core) req_core[4] = 1;
			endcase
		end
		// se a fila de baixo não está vazia
		if (!empty_baixo) begin
			// identifica a direção que o pacote quer seguir 
			case(direcao_baixo)
				// marca a requisição daquela saída se a fila do roteador vizinho não estiver cheia
				CIMA: if (!full_cima) req_cima[3] = 1;
				BAIXO: if (!full_baixo) req_baixo[3] = 1;
				ESQUERDA: if (!full_esquerda) req_esquerda[3] = 1;
				DIREITA: if (!full_direita) req_direita[3] = 1;
				CORE: if (!full_core) req_core[3] = 1;
			endcase
		end
		// se a fila da esquerda não está vazia
		if (!empty_esquerda) begin
			// identifica a direção que o pacote quer seguir 
			case(direcao_esquerda)
				// marca a requisição daquela saída se a fila do roteador vizinho não estiver cheia
				CIMA: if (!full_cima) req_cima[2] = 1;
				BAIXO: if (!full_baixo) req_baixo[2] = 1;
				ESQUERDA: if (!full_esquerda) req_esquerda[2] = 1;
				DIREITA: if (!full_direita) req_direita[2] = 1;
				CORE: if (!full_core) req_core[2] = 1;
			endcase
		end
		// se a fila da direita não está vazia
		if (!empty_direita) begin
			// identifica a direção que o pacote quer seguir 
			case(direcao_direita)
				// marca a requisição daquela saída se a fila do roteador vizinho não estiver cheia
				CIMA: if (!full_cima) req_cima[1] = 1;
				BAIXO: if (!full_baixo) req_baixo[1] = 1;
				ESQUERDA: if (!full_esquerda) req_esquerda[1] = 1;
				DIREITA: if (!full_direita) req_direita[1] = 1;
				CORE: if (!full_core) req_core[1] = 1;
			endcase
		end
		// se a fila do processador não está vazia
		if (!empty_core) begin
			// identifica a direção que o pacote quer seguir 
			case(direcao_core)
				// marca a requisição daquela saída se a fila do roteador vizinho não estiver cheia
				CIMA: if (!full_cima) req_cima[0] = 1;
				BAIXO: if (!full_baixo) req_baixo[0] = 1;
				ESQUERDA: if (!full_esquerda) req_esquerda[0] = 1;
				DIREITA: if (!full_direita) req_direita[0] = 1;
				CORE: if (!full_core) req_core[0] = 1;
			endcase
		end
		
		// define o seletor de cima
		sel_cima = grant_cima[4] ? CIMA : 
					  grant_cima[3] ? BAIXO : 
					  grant_cima[2] ? ESQUERDA : 
					  grant_cima[1] ? DIREITA : 
					  grant_cima[0] ? CORE : 3'b111;
		// define o seletor de baixo
		sel_baixo = grant_baixo[4] ? CIMA : 
						grant_baixo[3] ? BAIXO : 
						grant_baixo[2] ? ESQUERDA : 
						grant_baixo[1] ? DIREITA : 
						grant_baixo[0] ? CORE : 3'b111;
		// define o seletor da esquerda
		sel_esquerda = grant_esquerda[4] ? CIMA : 
							grant_esquerda[3] ? BAIXO : 
							grant_esquerda[2] ? ESQUERDA : 
							grant_esquerda[1] ? DIREITA : 
							grant_esquerda[0] ? CORE : 3'b111;
		// define o seletor da direita
		sel_direita = grant_direita[4] ? CIMA : 
						  grant_direita[3] ? BAIXO : 
						  grant_direita[2] ? ESQUERDA : 
						  grant_direita[1] ? DIREITA : 
						  grant_direita[0] ? CORE : 3'b111;
		// define o seletor do processador
		sel_core = grant_core[4] ? CIMA : 
					  grant_core[3] ? BAIXO : 
					  grant_core[2] ? ESQUERDA : 
					  grant_core[1] ? DIREITA : 
					  grant_core[0] ? CORE : 3'b111;
		
		// define o sinal para ler de cada fila com base nos vetores de garantias/autorizações
		rd_en_cima = grant_cima[4] || grant_baixo[4] || grant_esquerda[4] || grant_direita[4] || grant_core[4];
		rd_en_baixo = grant_cima[3] || grant_baixo[3] || grant_esquerda[3] || grant_direita[3] || grant_core[3];
		rd_en_esquerda = grant_cima[2] || grant_baixo[2] || grant_esquerda[2] || grant_direita[2] || grant_core[3];
		rd_en_direita = grant_cima[1] || grant_baixo[1] || grant_esquerda[1] || grant_direita[1] || grant_core[1];
		rd_en_core = grant_cima[0] || grant_baixo[0] || grant_esquerda[0] || grant_direita[0] || grant_core[0];
	end
	
endmodule