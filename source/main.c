#include <nds.h>
#include <stdio.h>
#include "main.h"

#ifdef __cplusplus
extern "C" {
#endif

    // Símbolos para modo DSi y enlazador
    int __dsimode = 1;

    void __libnds_mpu_setup(void) {}
    void __libnds_exit(void) {}
    void* __secure_area__ = NULL;

    // --- ¡AQUÍ FALTABAN LAS LLAVES! ---
    void initSystem(void) {
        irqInit();
        irqEnable(IRQ_VBLANK);
        fifoInit();
    }

#ifdef __cplusplus
} // Cerramos el extern "C"
#endif

// --- EL MAIN DEBE IR FUERA DEL BLOQUE EXTERN "C" O BIEN CERRADO ---

int main(void) {
    // Inicializar consola de texto
    consoleDemoInit();
    consoleSelect(consoleGetDefault());

    printf("\n\n   N$DS64 Proyecto DSi\n");
    printf("   -------------------\n");
    printf("   Hola mundo!\n");
    
    // Verificación de hardware
    if (isDSiMode()) {
        printf("   Corriendo en modo DSi\n");
    } else {
        printf("   Corriendo en modo DS\n");
    }

    printf("\n\n   Presiona START para salir.");

    while(1) {
        scanKeys();
        int keys = keysDown();
        
        if (keys & KEY_START) break;
        
        swiWaitForVBlank();
    }

    return 0;
}
