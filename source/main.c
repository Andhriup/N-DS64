#include <nds.h>
#include "main.h"
#include <stdio.h>
#ifdef __cplusplus
extern "C" {
#endif
    int __dsimode = 1;
    void __libnds_mpu_setup() {}
    void __libnds_exit() {}
    void* __secure_area__ = NULL;
    void initSystem(void)
#ifdef __cplusplus
#endif
int main(void) 
    consoleDemoInit();
    consoleSelect(consoleGetDefault());
    printf("\n\n   N$DS64 Proyecto DSi\n");
    printf("   -------------------\n");
    printf("   Hola mundo!\n");
    printf("\n\n   Presiona START para salir.");
    while(1) {
        scanKeys();
        int keys = keysDown();
        if (keys & KEY_START) break;
        swiWaitForVBlank();
    }
    return 0;
}
