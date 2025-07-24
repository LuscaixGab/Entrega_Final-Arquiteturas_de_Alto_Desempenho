// módulo processador
module processador #(
    parameter FLIT_W = 14 // tamanho do pacote
)(
    input  wire            clk, rst,	// sinal de clock e reset
    input  wire            wr_en_in,	// sinal para habilitar leiturta
    input  wire [FLIT_W-1:0] data_in,	// entrada de pacotes
    output reg             wr_en_out,	// sinal para habilitar escrita
    output reg [FLIT_W-1:0] data_out	// saída de pacotes
);

	// sempre na borda positiva de clock
	always @(posedge clk) begin
		// reset está ativado
		if (rst) begin
			// zera saída e desabilita escrita
			data_out  <= 0;
			wr_en_out <= 0;

		end
		// reset não está ativado
		else begin
			// leitura está habilitada
			if (wr_en_in) begin
				// gera pacote com bit invertido
				data_out  <= {1'b1, data_in[12:1], ~data_in[0]};
				// habilita escrita
				wr_en_out <= 1;
			end
			// leitura está desabilitada
			else begin
				// desabilita escrita
				wr_en_out <= 0;
			end
		end
	end

endmodule