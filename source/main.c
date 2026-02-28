#ifndef ARM9
#define ARM9
#endif
#include <main.h>
#include <stdio.h>

int main(void) {
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
