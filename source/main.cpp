#include <nds.h>
#include <stdio.h>
#include "main.h"

// Estos símbolos deben verse como C para el enlazador DSi
extern "C" {
    int __dsimode       = 1;
    int __secure_area__ = 0;

    void __libnds_mpu_setup(void) { }
    void __libnds_exit(void) { }
    void initSystem(void) {
        cpuStartTiming(0);
    }
}

// Contador de frames
static volatile int frame = 0;

void Vblank() {
    frame++;
}

int main(void) {
    // Inicializa el hardware y el modo DSi
    consoleDemoInit();

    // Asocia el handler V‑Blank y lo habilita
    irqSet(IRQ_VBLANK, Vblank);
    irqEnable(IRQ_VBLANK);

    // Muestra texto
    printf("

   N-DS64 Proyecto DSi
");
    printf("   -------------------
");
    printf("   Hardware: Nintendo DSi
");
    printf("   Estado:   133MHz / 16MB RAM
");

    printf("

   Presiona START para salir.");

    while(1) {
        swiWaitForVBlank();   // Espera V‑Blank
        scanKeys();           // Lee teclas
        if (keysDown() & KEY_START) break;
    }

    return 0;
}