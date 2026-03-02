#include <nds.h>
#include <stdio.h>
#include "main.h"

extern "C" {
    int __dsimode       = 1;
    int __secure_area__ = 0;

    void __libnds_mpu_setup(void) { }
    void __libnds_exit(void) { }
    void initSystem(void) {
        cpuStartTiming(0);
    }
}
static volatile int frame = 0;
irqSet(IRQ_VBLANK, Vblank);
irqEnable(IRQ_VBLANK);
void Vblank() {
    frame++;
}
int main(void) {
    consoleDemoInit();
    printf("N-DS64 Proyecto DSi");
    printf("   -------------------");
    printf("   Hardware: Nintendo DSi");
    printf("   Estado:   133MHz / 16MB RAM");
    printf("Presiona START para salir.");
    while(1) {
        swiWaitForVBlank();
        scanKeys();
        if (keysDown() & KEY_START) break;
    }

    return 0;
}