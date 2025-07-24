// módulo injetor
module injetor_imagem #(
	parameter DATA_W = 14)( 				// tamanho do pacote
	input clk, rst,							// sinal de clock e reset
	input ready,								// habilitador de leitura
	output reg wr_en,							// habilitador de escrita
	output reg [DATA_W-1:0] data_out);	// saída de dados
	
	reg [0:0] rom [0:4095]; // memória onde é armazenada a imagem
	
	// carrega a imagem na memória
	initial begin
		$readmemb("chessboard_64x64_clean_flat.txt", rom);
	end
	
	// registrador para endereço da memória
	reg [11:0] addr;
	
	// pixel é lido da memória
	wire pixel;
	assign pixel = rom[addr];
	
	// sempre na subida de clock
	always @(posedge clk) begin
		// habilita escrita
		wr_en <= 1;
		// reset está ativado
		if (rst) begin
			// zera saída
			data_out <= 0;
			// zera endereço da memória
			addr <= 0;
			// desabilita escrita
			wr_en <= 0;
		// reset não está ativado
		end else begin
			// habilitador de leitura está ativado e endereço é válido
			if (ready && (addr < 4096)) begin
				// monta o pacote e joga na saída
				data_out <= {1'b0, addr, pixel};
				// passa para o próximo endereço da memória
				addr <= addr + 1;
				// habilita escrita
				wr_en <= 1;
			// do contrário
			end else begin
				// zera saída
				data_out <= 0;
				// desabilita escrita
				wr_en <= 0;
			end
		end
	end

endmodule