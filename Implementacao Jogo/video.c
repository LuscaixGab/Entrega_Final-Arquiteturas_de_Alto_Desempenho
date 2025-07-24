#include "address_map_arm.h"
#include <stdbool.h>

/* --- Configurações de vídeo --- */
#define SCREEN_WIDTH  320
#define SCREEN_HEIGHT 240
#define PADDLE_WIDTH  5
#define PADDLE_HEIGHT 30
#define BALL_SIZE     5
#define PADDLE_SPEED  3
#define BALL_SPEED    2
#define COLOR_BLACK   0x0000
#define COLOR_WHITE   0xFFFF

/* --- Estruturas --- */
typedef struct {
    int x, y;
} Point;

typedef struct {
    Point pos;
    int width, height;
} Paddle;

typedef struct {
    Point pos;
    int dx, dy;
    int size;
} Ball;

/* --- Prototipagem --- */
void draw_box(int x1, int y1, int x2, int y2, short color);
void clear_box(int x1, int y1, int x2, int y2);
void wait_for_vsync();
void update_controls();

/* --- Ponteiros globais --- */
volatile int *pixel_ctrl_ptr = (int *)PIXEL_BUF_CTRL_BASE;
volatile int *KEY_ptr = (int *)KEY_BASE;

Paddle left_paddle = {{10, 100}, PADDLE_WIDTH, PADDLE_HEIGHT};
Paddle right_paddle = {{SCREEN_WIDTH - 15, 100}, PADDLE_WIDTH, PADDLE_HEIGHT};
Ball ball = {{SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2}, BALL_SPEED, BALL_SPEED, BALL_SIZE};

int main(void) {
    *(pixel_ctrl_ptr + 1) = 0xC0000000; // back buffer em SDRAM
    wait_for_vsync();

    while (1) {
        clear_box(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
        // Entradas
        update_controls();

        // Limpar antigo
        clear_box(left_paddle.pos.x, left_paddle.pos.y,
                  left_paddle.pos.x + left_paddle.width,
                  left_paddle.pos.y + left_paddle.height);
        clear_box(right_paddle.pos.x, right_paddle.pos.y,
                  right_paddle.pos.x + right_paddle.width,
                  right_paddle.pos.y + right_paddle.height);
        clear_box(ball.pos.x, ball.pos.y,
                  ball.pos.x + ball.size, ball.pos.y + ball.size);

        // Atualizar posição da bola
        ball.pos.x += ball.dx;
        ball.pos.y += ball.dy;

        // Colisão com topo/baixo
        if (ball.pos.y <= 0 || ball.pos.y + ball.size >= SCREEN_HEIGHT)
            ball.dy = -ball.dy;

        // Colisão com paddle esquerdo
        if (ball.pos.x <= left_paddle.pos.x + left_paddle.width &&
            ball.pos.y + ball.size >= left_paddle.pos.y &&
            ball.pos.y <= left_paddle.pos.y + left_paddle.height)
            ball.dx = -ball.dx;

        // Colisão com paddle direito
        if (ball.pos.x + ball.size >= right_paddle.pos.x &&
            ball.pos.y + ball.size >= right_paddle.pos.y &&
            ball.pos.y <= right_paddle.pos.y + right_paddle.height)
            ball.dx = -ball.dx;

        // Reinício se sair da tela
        if (ball.pos.x <= 0 || ball.pos.x + ball.size >= SCREEN_WIDTH) {
            ball.pos.x = SCREEN_WIDTH / 2;
            ball.pos.y = SCREEN_HEIGHT / 2;
        }

        // Desenhar elementos atualizados
        draw_box(left_paddle.pos.x, left_paddle.pos.y,
                 left_paddle.pos.x + left_paddle.width,
                 left_paddle.pos.y + left_paddle.height, COLOR_WHITE);
        draw_box(right_paddle.pos.x, right_paddle.pos.y,
                 right_paddle.pos.x + right_paddle.width,
                 right_paddle.pos.y + right_paddle.height, COLOR_WHITE);
        draw_box(ball.pos.x, ball.pos.y,
                 ball.pos.x + ball.size, ball.pos.y + ball.size, COLOR_WHITE);

        wait_for_vsync();
    }
}

/* --- Controles do jogador via KEYs --- */
void update_controls() {
    int keys = *(KEY_ptr);

    // Controle do paddle esquerdo (KEY0, KEY1)
    if ((keys & 0x1) == 0 && left_paddle.pos.y >= PADDLE_SPEED) // KEY0 - movimento para cima
        left_paddle.pos.y -= PADDLE_SPEED;
    if ((keys & 0x2) == 0 && left_paddle.pos.y + PADDLE_HEIGHT <= SCREEN_HEIGHT - PADDLE_SPEED) // KEY1 - movimento para baixo
        left_paddle.pos.y += PADDLE_SPEED;

    // Controle do paddle direito (KEY2, KEY3)
    if ((keys & 0x4) == 0 && right_paddle.pos.y >= PADDLE_SPEED) // KEY2 - movimento para cima
        right_paddle.pos.y -= PADDLE_SPEED;
    if ((keys & 0x8) == 0 && right_paddle.pos.y + PADDLE_HEIGHT <= SCREEN_HEIGHT - PADDLE_SPEED) // KEY3 - movimento para baixo
        right_paddle.pos.y += PADDLE_SPEED;
}

/* --- Funções auxiliares --- */
void draw_box(int x1, int y1, int x2, int y2, short color) {
    int offset, row, col;
    int buffer = *(pixel_ctrl_ptr + 1);
    for (row = y1; row < y2; row++) {
        for (col = x1; col < x2; col++) {
            offset = buffer + (row << 10) + (col << 1);
            *(short *)offset = color;
        }
    }
}

void clear_box(int x1, int y1, int x2, int y2) {
    draw_box(x1, y1, x2, y2, COLOR_BLACK);
}

void wait_for_vsync() {
    *(pixel_ctrl_ptr) = 1;
    while ((*(pixel_ctrl_ptr + 3)&0x01)!=0);
}
