#include <iostream>

#ifdef __cplusplus
extern "C" {
#endif

void __glang_print(int n);
int __glang_scan();
void __glang_init_window(unsigned width, unsigned height);
void __glang_put_pixel(int x, int y, int state);
void __glang_flush();
int __glang_rand();

#ifdef __cplusplus
}
#endif
