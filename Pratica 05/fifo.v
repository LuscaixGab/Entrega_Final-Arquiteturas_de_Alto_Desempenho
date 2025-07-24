// módulo fila FIFO (first-in, first-out)
module fifo #(
	parameter DATA_W = 14, 					// largura dos dados
	parameter DEPTH = 4)( 					// número de posições da fila
	input clk, rst, 							// sinal de clock e reset
	input wr_en, rd_en, 						// sinal para habilitar escrita e habilitar leitura
	input [DATA_W-1: 0] data_in, 			// entrada de dados
	output full, empty, 						// sinal de fila cheia e fila vazia
	output reg [DATA_W-1: 0] data_out); // saída dos dados
	
	reg [DATA_W-1:0] mem [0:DEPTH-1];		// fila de fato / memória
	reg [$clog2(DEPTH)-1:0] w_ptr, r_ptr;	// ponteiro de escrita e leitura
	reg [$clog2(DEPTH):0] count;				// contador
	assign empty = (count == 0);				// define o sinal de fila vazia
	assign full = (count == DEPTH);			// define o sinal de fila cheia
	
	// sempre na borda positiva do clock ou reset
	always @(posedge clk or posedge rst) begin
		// reset está ativado
		if (rst) begin
			// zera ponteiros de escrita e leitura
			w_ptr <= 0;
			r_ptr <= 0;
			// zera contador
			count <= 0;
			// zera saída
			data_out <= 0;
		end
		// reset não está ativado
		else begin
			// se leitura foi solicitada e fila não está vazia
			if (rd_en && !empty) begin
				// joga informação na saída
				data_out <= mem[r_ptr];
				// atualiza contador e ponteiro de leitura
				r_ptr <= r_ptr + 1;
				count <= count - 1;
			end
			// se escrita foi solicitada e fila não está cheia
			if (wr_en && !full) begin
				// grava novos dados na fila
				mem[w_ptr] <= data_in;
				// atualiza contador e ponteiro de escrita
				count <= count + 1;
				w_ptr <= w_ptr + 1;
			end
		end
	end
	
endmodule