module roteador(
	input clk, rst,
	input [3:0] coord_x, coord_y,
	input [16:0] cima_in, baixo_in, esquerda_in, direita_in, core_in,
	output reg [16:0] cima_out, baixo_out, esquerda_out, direita_out, core_out);
	
	wire [16:0] pacote;
	assign pacote = cima_in[16] ? cima_in :
							 baixo_in[16] ? baixo_in :
							 esquerda_in[16] ? esquerda_in : 
							 direita_in[16] ? direita_in : 
							 core_in[16] ? core_in : 17'b0;
	wire [3:0] x_destino, y_destino;
	assign x_destino = cima_in[16] ? cima_in[15:12] :
							 baixo_in[16] ? baixo_in[15:12] :
							 esquerda_in[16] ? esquerda_in[15:12] : 
							 direita_in[16] ? direita_in[15:12] : 
							 core_in[16] ? core_in[15:12] : 4'b0;
	assign y_destino = cima_in[16] ? cima_in[11:8] :
							 baixo_in[16] ? baixo_in[11:8] :
							 esquerda_in[16] ? esquerda_in[11:8] : 
							 direita_in[16] ? direita_in[11:8] : 
							 core_in [16] ? core_in[11:8] : 4'b0;
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			cima_out <= 0;
			baixo_out <= 0;
			esquerda_out <= 0;
			direita_out <= 0;
			core_out <= 0;
		end
		
		else begin
			cima_out <= 0;
			baixo_out <= 0;
			esquerda_out <= 0;
			direita_out <= 0;
			core_out <= 0;
			
			if (cima_in[16] || baixo_in[16] || esquerda_in[16] || direita_in[16] || core_in[16]) begin
				if (x_destino > coord_x) direita_out <= pacote;
				else if (x_destino < coord_x) esquerda_out <= pacote;
				else if (y_destino > coord_y) baixo_out <= pacote;
				else if (y_destino < coord_y) cima_out <= pacote;
				else core_out <= pacote;
			end
		end
	end
	
endmodule