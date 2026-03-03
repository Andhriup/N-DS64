#include <nds.h>
#include <stdio.h>
#include <calico.h>

static volatile int frame = 0;
void Vblank() {
    frame++;
}
extern "C" {
    int __dsimode       = 1;
    unsigned int __secure_area__ = 0;

    void __libnds_mpu_setup(void) { }
    void __libnds_exit(void) { }
    void initSystem(void) {
      powerOn(POWER_ALL);
      irqEnable(IRQ_VBLANK);
      irqSet(IRQ_VBLANK, Vblank);
    }
}

int main(void) {
  initSystem();
  videoSetMode(MODE_0_2D);
  videoSetModeSub(MODE_0_2D);
  vramDefault();
    consoleDemoInit();
    consoleDebugInit(DebugDevice_CONSOLE);

    while(1) {
        printf("\x1b[2J"); 
        printf("N-DS64 Proyecto DSi\n");
        printf("-------------------\n");
        printf("Hardware: Nintendo DSi\n");
        printf("Estado:   133MHz / 16MB RAM\n");
        printf("Frames:   %d\n\n", frame);
        printf("Presiona START para salir.");

        swiWaitForVBlank();
        scanKeys();
        if (keysDown() & KEY_START) break;
    }

    return 0;
}
