#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <string.h>
#include <stdio.h>
#include "draw.h"

enum RULES {
    CLASSIC,
    CYCLIC,
};

enum WORLD_PARAMETERS {
    WINDOW_WIDTH = 1000,
    WINDOW_HEIGHT = 800,
    COLORS_COUNT = 8,
    THRESHOLD = 2,
};

struct surface_t {
    STATE* buff;
    unsigned height;
    unsigned width;
};

typedef STATE(*rule_func)(struct surface_t, int, int);

struct surface_t init_surface(unsigned width, unsigned height) {
    STATE* buff = (STATE*)calloc(height * width, sizeof(STATE));
    assert(buff != NULL);
    struct surface_t ret = { buff, height, width };
    return ret;
}

STATE at(struct surface_t surf, int x, int y) {
    return surf.buff[y + x * surf.height];
}

void set(struct surface_t surf, int x, int y, STATE state) {
    surf.buff[y + x * surf.height] = state;
}

void clear(struct surface_t surf) {
    memset(surf.buff, 0, surf.width * surf.height * sizeof(uint8_t));
}

void delete_surface(struct surface_t surf) {
    free(surf.buff);
}

void init_world(struct surface_t surf, enum RULES rule) {
    srand(time(NULL));
    for(int x = 0; x < surf.width; ++x) {
        for(int y = 0; y < surf.height; ++y) {
            STATE st;
            switch (rule) {
                case CLASSIC:
                    st = rand() % 2;
                    break;
                case CYCLIC: 
                    st = rand() % COLORS_COUNT;
                    break;
            }
            set(surf, x, y, st);
        }
    }
}

static int neighbors_count(struct surface_t surf, int x, int y, STATE st) {
    int ret = 0;
    for(int current_x = x - 1; current_x <= x + 1; ++current_x) {
        for(int current_y = y - 1; current_y <= y + 1; ++current_y) {
            if((current_x == x) && (current_y == y)) {
                continue;
            }

            if (current_x < 0 || current_x >= surf.width ||
                current_y < 0 || current_y >= surf.height) {
                continue;
            }

            if (st == at(surf, current_x, current_y)) {
                ++ret;
            }
        }
    }
    return ret;
}

static STATE classic_rule(struct surface_t current, int x, int y) {
    int neighbors = neighbors_count(current, x, y, ALIVE);
    if (DEAD == at(current, x, y)) {
        if (neighbors == 3) {
            return ALIVE;
        }
        } 
    if(ALIVE == at(current, x, y)) {
        if ((neighbors > 3) || (neighbors < 2))  {
            return DEAD;
        } else {
            return ALIVE;
        }
    }
}

static STATE cyclic_rule(struct surface_t current, int x, int y) {
    STATE current_state = at(current, x, y);
    STATE successor = (current_state == 0) ? COLORS_COUNT - 1 : current_state - 1;
    int neighbors = neighbors_count(current, x, y, successor);
    if(neighbors >= THRESHOLD) {
        return successor;
    } else {
        return current_state;
    }
}

void update(struct surface_t current, struct surface_t tmp, enum RULES rule) {
    rule_func func = NULL;
    switch(rule) {
        case CLASSIC: 
            func = classic_rule;
            break;
        case CYCLIC: 
            func = cyclic_rule;
            break;
    };
    for(int x = 0; x < current.width; ++x) {
        for(int y = 0; y < current.height; ++y) {
            STATE st = func(current, x, y);
            set(tmp, x, y, st);
        }
    }
}

void swap(struct surface_t* lhs, struct surface_t* rhs) {
    struct surface_t tmp = *lhs;
    *lhs = *rhs;
    *rhs = tmp;
}

void draw(struct surface_t surf) {
    for(int x = 0; x < surf.width; ++x) {
        for(int y = 0; y < surf.height; ++y) {
            dr_put_pixel(x, y, at(surf, x, y));
        }
    }
    dr_flush();
}

int main(int argc, char * argv[]) {
    dr_init_window(WINDOW_WIDTH, WINDOW_HEIGHT);

    struct surface_t current_surf = init_surface(WINDOW_WIDTH, WINDOW_HEIGHT);
    struct surface_t tmp_surf = init_surface(WINDOW_WIDTH, WINDOW_HEIGHT);

    enum RULES rules = CYCLIC;

    init_world(current_surf, rules);
    while(dr_window_is_open()) {
        dr_clear();
        draw(current_surf);
        update(current_surf, tmp_surf, rules);
        dr_process_events();
        swap(&current_surf, &tmp_surf);
    }

    delete_surface(current_surf);
    delete_surface(tmp_surf);
}