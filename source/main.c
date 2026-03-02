#include <nds.h>
#include <stdio.h>
#include "main.h"
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
