#include <nds.h>
#include <stdio.h>
#include "main.h"

#ifdef __cplusplus
extern "C" {
#endif

    // Esto activa los 16MB de RAM en DSi
    int __dsimode = 1;

    // Símbolos mínimos para que el compilador de 2026 esté contento
    void __libnds_mpu_setup(void) {}
    void __libnds_exit(void) {}
    void* __secure_area__ = NULL;

    // Dejamos initSystem vacío para que no interfiera, 
    // libnds ya hace el trabajo pesado por detrás.
    void initSystem(void) {
        // No es necesario llamar a irqInit o fifoInit aquí en versiones nuevas
    }

#ifdef __cplusplus
}
#endif

int main(void) {
    // Inicializar consola de texto en la pantalla inferior (por defecto)
    consoleDemoInit();

    printf("\n\n   N-DS64 Proyecto DSi\n");
    printf("   -------------------\n");
    
    // Comprobamos si el hardware nos da los 16MB
    if (isDSiMode()) {
        printf("   Hardware: Nintendo DSi\n");
        printf("   Estado:   133MHz / 16MB RAM\n");
    } else {
        printf("   Hardware: Nintendo DS\n");
        printf("   Estado:   67MHz / 4MB RAM\n");
    }

    printf("\n\n   Presiona START para salir.");

    while(1) {
        swiWaitForVBlank();
        
        scanKeys();
        if (keysDown() & KEY_START) break;
    }

    return 0;
}
