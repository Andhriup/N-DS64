#include <nds.h>
#include <stdio.h>
#include "main.h"
int __dsimode = 1;
int __secure_area__ = 0;
void __libnds_mpu_setup(void) {}
void __libnds_exit(void) {}
void initSystem(void) {
    cpuStartTiming(0); 
}
int main(void) {
    consoleDemoInit();
    printf("\n\n   N-DS64 Proyecto DSi\n");
    printf("   -------------------\n");
        printf("   Hardware: Nintendo DSi\n");
        printf("   Estado:   133MHz / 16MB RAM\n");

    printf("\n\n   Presiona START para salir.");

    while(1) {
        swiWaitForVBlank();
        
        scanKeys();
        if (keysDown() & KEY_START) break;
    }

    return 0;
}
