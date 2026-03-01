#include <nds.h>
#include <stdio.h>
#include "main.h"

extern "C" {
    int __dsimode = 1;
    void __libnds_mpu_setup(void) {}
    void __libnds_exit(void) {}
    void* __secure_area__ = NULL;
    void initSystem(void) {}
#endif
}
int main(void) {
    consoleDemoInit();
    printf("\n\n   N-DS64 Proyecto DSi\n");
    printf("   -------------------\n");
    if (isDSiMode()) {
        printf("   Hardware: Nintendo DSi\n");
        printf("   Estado:   133MHz / 16MB RAM\n");
    } else {
        printf("   Hardware: Nintendo DS\n");
        printf("   Estado:   67MHz / 4MB RAM\n");
    }

    printf("\n\n   Presiona START para salir.");

    while(1) {
        swiWaitForVBlank();
        
        scanKeys();
        if (keysDown() & KEY_START) break;
    }

    return 0;
}
