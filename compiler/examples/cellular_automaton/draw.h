
#pragma once

#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <time.h>
#include <assert.h>
#include <string.h>
#include <stdio.h>

typedef uint8_t STATE;

#define DEAD 0
#define ALIVE 1

#ifdef __cplusplus
extern "C" {
#endif    
    void dr_init_window(unsigned width, unsigned height);
    uint8_t dr_window_is_open();
    void dr_put_pixel(int x, int y, STATE state);
    void dr_process_events();
    void dr_flush();
    void dr_clear();
#ifdef __cplusplus    
}
#endif 