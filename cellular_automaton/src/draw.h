
#pragma once

typedef int STATE;

#ifdef __cplusplus
extern "C" {
#endif    
    void dr_init_window(unsigned width, unsigned height);
    void dr_put_pixel(int x, int y, STATE state);
    void dr_flush();
    int dr_rand();
#ifdef __cplusplus
}
#endif 