//módulo da máquina de estados
module state_machine (
    input wire clk,						  // sinal de clock
    input wire rst,						  // sinal de reset
    input wire [3299:0] data_in,      // entrada: estado atual
    output reg [3299:0] data_out      // saída: próxima geração
);
	 // auxiliares
    integer x, y, idx;
    integer vizinhos;

    // apenas para carregar arquivo inicial e de reset
    reg [0:0] temp_mem [0:3299];

	 // inicialmente
    initial begin
		  // faz a leitura do arquivo contendo o estado inicial
        $readmemb("game_of_life_66x50.txt", temp_mem);
		  // copia esses dados  para a saída
        for (idx = 0; idx < 3300; idx = idx + 1)
            data_out[idx] = temp_mem[idx];
    end

	 // a cada sinal de clock
    always @(posedge clk) begin
		  // se o sinal de reset estiver ativado
        if (rst) begin
				// copia os dados do estado inicial na saída
            for (idx = 0; idx < 3300; idx = idx + 1)
                data_out[idx] <= temp_mem[idx];
		  
        end
		  // não há sinal de reset
		  else begin
				// percorre cada bit do sinal
            for (y = 1; y < 49; y = y + 1) begin
                for (x = 1; x < 65; x = x + 1) begin
                    // posição do bit no vetor
						  idx = y * 66 + x;
						  
						  // identifica quantos pixels ativos há na vizinhança
                    vizinhos = 
                        data_in[(y-1)*66 + (x-1)] +
                        data_in[(y-1)*66 + x]     +
                        data_in[(y-1)*66 + (x+1)] +
                        data_in[y*66     + (x-1)] +
                        data_in[y*66     + (x+1)] +
                        data_in[(y+1)*66 + (x-1)] +
                        data_in[(y+1)*66 + x]     +
                        data_in[(y+1)*66 + (x+1)];
							
						  // se o pixel atual está ativo
                    if (data_in[idx] == 1'b1)
								// se há 2 ou 3 vizinhos, permanece ativo, do contrário desliga
                        data_out[idx] <= (vizinhos == 2 || vizinhos == 3) ? 1'b1 : 1'b0;
                    // se o pixel atual está desligado
						  else
								// se há 3 vizinhos é ativado, do contrário permanece desligado
                        data_out[idx] <= (vizinhos == 3) ? 1'b1 : 1'b0;
                end
            end

            // zera as bordas
            for (y = 0; y < 50; y = y + 1)
                for (x = 0; x < 66; x = x + 1)
                    if (y == 0 || y == 49 || x == 0 || x == 65)
                        data_out[y * 66 + x] <= 1'b0;
        end
    end

endmodule


// VERSÃO QUE FUNCIONA
/*module state_machine (
    input wire clk,
    input wire [3299:0] data_in,
    output reg [3299:0] data_out
);

    integer x, y;
    integer vizinhos;
    integer idx;

    reg [0:0] rom [0:3299];        // estado atual
    reg [0:0] next_rom [0:3299];   // próxima geração

    initial begin
        $readmemb("game_of_life_66x50.txt", rom);
    end

    always @(posedge clk) begin
        for (y = 1; y < 49; y = y + 1) begin
            for (x = 1; x < 65; x = x + 1) begin
                idx = y * 66 + x;

                vizinhos = 
                    rom[(y-1)*66 + (x-1)] +
                    rom[(y-1)*66 + x]     +
                    rom[(y-1)*66 + (x+1)] +
                    rom[y*66     + (x-1)] +
                    rom[y*66     + (x+1)] +
                    rom[(y+1)*66 + (x-1)] +
                    rom[(y+1)*66 + x]     +
                    rom[(y+1)*66 + (x+1)];

                // Regras do jogo da vida
                if (rom[idx] == 1'b1)
                    next_rom[idx] = (vizinhos == 2 || vizinhos == 3) ? 1'b1 : 1'b0;
                else
                    next_rom[idx] = (vizinhos == 3) ? 1'b1 : 1'b0;
            end
        end

        // Atualiza o estado e a saída
        for (idx = 0; idx < 3300; idx = idx + 1) begin
            rom[idx] <= next_rom[idx];
            data_out[idx] <= next_rom[idx];
        end
    end

endmodule*/

/*module state_machine (
    input wire clk,
    input wire [3299:0] data_in,
    output wire [3299:0] data_out
);

	// Define linhas base do padrão xadrez
	wire [65:0] linha_par   = {33{2'b10}};  // 66 bits: 1010...10
	wire [65:0] linha_impar = {33{2'b01}};  // 66 bits: 0101...01

	// Gera 50 linhas alternadas (par, ímpar, par, ...)
	assign data_out = {
		 linha_par, linha_impar, linha_par, linha_impar, linha_par,
		 linha_impar, linha_par, linha_impar, linha_par, linha_impar,
		 linha_par, linha_impar, linha_par, linha_impar, linha_par,
		 linha_impar, linha_par, linha_impar, linha_par, linha_impar,
		 linha_par, linha_impar, linha_par, linha_impar, linha_par,
		 linha_impar, linha_par, linha_impar, linha_par, linha_impar,
		 linha_par, linha_impar, linha_par, linha_impar, linha_par,
		 linha_impar, linha_par, linha_impar, linha_par, linha_impar,
		 linha_par, linha_impar, linha_par, linha_impar, linha_par,
		 linha_impar, linha_par, linha_impar
	}; // 50 linhas × 66 bits = 3300 bits

endmodule*/
