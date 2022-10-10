#include "draw.h"

enum WORLD_PARAMETERS {
    WINDOW_WIDTH = 600,
    WINDOW_HEIGHT = 400,
    COLORS_COUNT = 16,
    THRESHOLD = 1,
};

int current_surf[WINDOW_WIDTH][WINDOW_HEIGHT];
int tmp_surf[WINDOW_WIDTH][WINDOW_HEIGHT];

void init_world() {
    srand(time(NULL));
    for(int x = 0; x < WINDOW_WIDTH; ++x) {
        for(int y = 0; y < WINDOW_HEIGHT; ++y) {
            current_surf[x][y] = rand() % COLORS_COUNT;
        }
    }
}

static int neighbors_count(int x, int y, STATE st) {
    int ret = 0;
    for(int current_x = x - 1; current_x <= x + 1; ++current_x) {
        for(int current_y = y - 1; current_y <= y + 1; ++current_y) {
            if((current_x == x) && (current_y == y)) {
                continue;
            }

            if (current_x < 0 || current_x >= WINDOW_WIDTH ||
                current_y < 0 || current_y >= WINDOW_HEIGHT) {
                continue;
            }

            if (current_surf[current_x][current_y] == st) {
                ++ret;
            }
        }
    }
    return ret;
}

void update() {
    for(int x = 0; x < WINDOW_WIDTH; ++x) {
        for(int y = 0; y < WINDOW_HEIGHT; ++y) {
            STATE current_state = current_surf[x][y];
            STATE successor = (current_state == 0) ? COLORS_COUNT - 1 : current_state - 1;
            int neighbors = neighbors_count(x, y, successor);
            STATE new_st;
            if(neighbors >= THRESHOLD) {
                new_st = successor;
            } else {
                new_st = current_state;
            }
           tmp_surf[x][y] = new_st;
        }
    }
}

void swap() {
    for(int x = 0; x < WINDOW_WIDTH; ++x) {
        for(int y = 0; y < WINDOW_HEIGHT; ++y) {
            int tmp = current_surf[x][y];
            current_surf[x][y] = tmp_surf[x][y];
            tmp_surf[x][y] = tmp;
        }
    }
}

void draw() {
    for(int x = 0; x < WINDOW_WIDTH; ++x) {
        for(int y = 0; y < WINDOW_HEIGHT; ++y) {
            dr_put_pixel(x, y, current_surf[x][y]);
        }
    }
    dr_flush();
}

int main(int argc, char * argv[]) {
    dr_init_window(WINDOW_WIDTH, WINDOW_HEIGHT);

    init_world();
    while(dr_window_is_open()) {
        draw();
        update();
        dr_process_events();
        swap(&current_surf, &tmp_surf);
    }
}