
#pragma once

#include <stdlib.h>
#include <time.h>

typedef int STATE;

#ifdef __cplusplus
extern "C" {
#endif    
    void dr_init_window(unsigned width, unsigned height);
    int dr_window_is_open();
    void dr_put_pixel(int x, int y, STATE state);
    void dr_process_events();
    void dr_flush();
#ifdef __cplusplus    
}
#endif 