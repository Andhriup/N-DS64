#include <nds.h>
#include <stdio.h>
#include <calico.h>

static volatile int frame = 0;
void Vblank() {
    frame++;
}
extern "C" {
    int __dsimode       = 0;
    unsigned int __secure_area__ = 0;

    void __libnds_mpu_setup(void) { }
    void __libnds_exit(void) { }
    void initSystem(void) {
      irqEnable(IRQ_VBLANK);
      irqSet(IRQ_VBLANK, Vblank);
    }
}

int main(void) {
  initSystem();
    consoleDemoInit();

    while(1) {
        // Limpiar pantalla y mover el cursor al inicio (evita que el texto se acumule)
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
