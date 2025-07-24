// módulo switch crossbar
module switch_crossbar #(
	parameter DATA_W = 14)( 																			// tamanho dos pacotes
	input [DATA_W-1:0] cima_in, baixo_in, esquerda_in, direita_in, core_in,				// saída de cada uma das filas
	input [2:0] sel_cima, sel_baixo, sel_esquerda, sel_direita, sel_core,				// sinal seletor de cada saída do roteador
	output [DATA_W-1:0] cima_out, baixo_out, esquerda_out, direita_out, core_out);	// saídas do roteador
	
	// interpretação dos sinais seletores
	localparam SEL_CIMA = 3'b000;
	localparam SEL_BAIXO = 3'b001;
	localparam SEL_ESQUERDA = 3'b010;
	localparam SEL_DIREITA = 3'b011;
	localparam SEL_CORE = 3'b100;
	
	// comuta a porta da saída de cima
	assign cima_out = (sel_cima == SEL_CIMA) ? cima_in : 
							(sel_baixo == SEL_CIMA) ? baixo_in : 
							(sel_esquerda == SEL_CIMA) ? esquerda_in : 
							(sel_direita == SEL_CIMA) ? direita_in : 
							(sel_core == SEL_CIMA) ? core_in : {DATA_W{1'b0}};
	
	// comuta porta da saída de baixo
	assign baixo_out = (sel_cima == SEL_BAIXO) ? cima_in : 
							 (sel_baixo == SEL_BAIXO) ? baixo_in : 
							 (sel_esquerda == SEL_BAIXO) ? esquerda_in : 
							 (sel_direita == SEL_BAIXO) ? direita_in : 
							 (sel_core == SEL_BAIXO) ? core_in : {DATA_W{1'b0}};
	
	// comuta porta da saída da esquerda
	assign esquerda_out = (sel_cima == SEL_ESQUERDA) ? cima_in : 
								 (sel_baixo == SEL_ESQUERDA) ? baixo_in : 
								 (sel_esquerda == SEL_ESQUERDA) ? esquerda_in : 
								 (sel_direita == SEL_ESQUERDA) ? direita_in : 
								 (sel_core == SEL_ESQUERDA) ? core_in : {DATA_W{1'b0}};
	
	// comuta porta da saída da direita
	assign direita_out = (sel_cima == SEL_DIREITA) ? cima_in : 
								(sel_baixo == SEL_DIREITA) ? baixo_in : 
								(sel_esquerda == SEL_DIREITA) ? esquerda_in : 
								(sel_direita == SEL_DIREITA) ? direita_in : 
								(sel_core == SEL_DIREITA) ? core_in : {DATA_W{1'b0}};
	
	// comuta porta da saída local
	assign core_out = (sel_cima == SEL_CORE) ? cima_in : 
							(sel_baixo == SEL_CORE) ? baixo_in : 
							(sel_esquerda == SEL_CORE) ? esquerda_in : 
							(sel_direita == SEL_CORE) ? direita_in : 
							(sel_core == SEL_CORE) ? core_in : {DATA_W{1'b0}};
	
endmodule