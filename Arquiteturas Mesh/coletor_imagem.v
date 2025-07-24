// módulo coletor
module coletor_imagem #(
	parameter DATA_W = 14)(			// tamanho do pacote
	input clk, rst,					// sinais de clock e reset
	input wr_en,						// sinal para habilitar escrita
	input [9:0] row, column,		// recebe do VGA qual pixel ele está exibindo
	input [DATA_W-1:0] data_in,	// entrada de pacotes
	output wire pixel);				// pixel correspondente na memória
	
	reg rom_padrao [0:4095]; // memória para a imagem original
	reg imagem [0:4095];		 // memória para a exibição
	integer i;					 // variável de iteração
	
	// grava a imagem original e copia na memória de exibição
	initial begin
		$readmemb("chessboard_64x64_clean_flat.txt", rom_padrao);
		for (i = 0; i < 4096; i = i + 1)
			imagem[i] = rom_padrao[i];
	end
	
	// registrador para endereço na memória
	wire [11:0] addr;
	assign addr = data_in[12:1]; // extrai endereço do pacote
	
	// a cada bora de subida de clock
	always @(posedge clk) begin
		// reset está ativado
		if (rst) begin
			// copia a imagem original na memória de exibição
			for (i = 0; i < 4096; i = i + 1)
            imagem[i] <= rom_padrao[i];
		end
		// reset não está ativado
		else begin
			// verfifica se escrita está habilitada
			if (wr_en) begin
				// atualiza a memória de exibição com o pixel processado
				imagem[addr] <= data_in[0];
			end
		end
	end
	
	// saída é o pixel correspondente ao endereço na memória
	assign pixel = imagem[{row[5:0], column[5:0]}];
	
endmodule