#include <nds.h>
#include <stdio.h>

extern "C" {
    int __dsimode       = 1;
    int __secure_area__ = 0;

    void __libnds_mpu_setup(void) { }
    void __libnds_exit(void) { }
    void initSystem(void) {
        cpuStartTiming(0);
        irqInit();
        irqEnable(IRQ_VBLANK);
    }
}
static volatile int frame = 0;
void Vblank() {
    frame++;
}
int main(void) {
  while{
    irqSet(IRQ_VBLANK, Vblank);
    consoleDemoInit();
    printf("N-DS64 Proyecto DSi");
    printf("   -------------------");
    printf("   Hardware: Nintendo DSi");
    printf("   Estado:   133MHz / 16MB RAM %d", frame);
    printf("Presiona START para salir.");
        swiWaitForVBlank();
        scanKeys();
        if (keysDown() & KEY_START) break;
    }

    return 0;
}