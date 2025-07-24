/*module big_pixel(
	input [3299:0] pixels_in,
	input clk,
	output out);
	
	integer x = 0;
	integer y = 0;
	integer contador_x = 0;
	integer contador_y = 0;
	
	
	always@(posedge clk) begin
		if((x == 63) & (y == 47)) begin
			x = 0;
			y = 0;
			contador_x = 0;
			contador_y = 0;
		end
		else begin
			contador_x = (contador_x == 9) ? 0 : (contador_x + 1);
			x = (contador_x == 9) ? ((x == 63) ? 0 : (x+1)) : x;
			contador_y = (x == 63) ? ((contador_y == 9) ? 0 : (contador_y+1)) : contador_y;
			y = (contador_y == 9)  ? ((y == 47) ? 0 : (y+1)) : y;
		end
		
	end
	
	assign out = pixels_in[y*64 + x];
	
endmodule
*/

/*module big_pixel (
    input [3299:0] pixels_in,  // imagem 66 x 50 = 3300 bits
    input clk,
    output reg out             // pixel atual ampliado
);

    integer contador_x = 0;
    integer contador_y = 0;
    integer x = 1;  // percorre de 1 a 64
    integer y = 1;  // percorre de 1 a 48

    always @(posedge clk) begin
        // Calcula índice e atualiza saída
        out <= pixels_in[y * 66 + x];

        // Avança bloco horizontal (pixel 10x no eixo X)
        contador_x = contador_x + 1;
        if (contador_x == 10) begin
            contador_x = 0;
            x = x + 1;

            // Terminou linha útil?
            if (x == 65) begin  // de 1 até 64
                x = 1;

                // Avança bloco vertical (pixel 10x no eixo Y)
                contador_y = contador_y + 1;
                if (contador_y == 10) begin
                    contador_y = 0;
                    y = y + 1;

                    // Terminou coluna útil?
                    if (y == 49) begin  // de 1 até 48
                        y = 1;
                    end
                end
            end
        end
    end

endmodule*/

// módulo ampliador de pixels
module big_pixel (
    input [3299:0] pixels_in,  // imagem original: 66 x 50 = 3300 bits
    input [9:0] hcount,        // contador horizontal do VGA (0 a 639)
    input [9:0] vcount,        // contador vertical do VGA (0 a 479)
    output out                 // pixel de saída sincronizado com VGA
);

    // converte posição atual do VGA para coordenadas de pixel original
    wire [6:0] x_pixel = (hcount / 10) + 1;  // de 1 até 64
    wire [6:0] y_pixel = (vcount / 10) + 1;  // de 1 até 48

    // índice linear no vetor pixels_in (66 colunas por linha)
    wire [12:0] idx = y_pixel * 66 + x_pixel;

    // proteção contra estouro fora da imagem (bordas visuais, etc)
    assign out = (x_pixel < 65 && y_pixel < 49) ? pixels_in[idx] : 1'b0;

endmodule
