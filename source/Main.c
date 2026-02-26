#include <nds.h>
#include <stdio.h>

int main(void) {
    // Inicializar las consolas de texto en ambas pantallas
    // Esto configura el motor 2D para mostrar texto simple
    consoleDemoInit();

    // Seleccionar la pantalla superior para escribir
    consoleSelect(consoleGetDefault());
    printf("\n\n   N$DS64 Proyecto DSi\n");
    printf("   -------------------\n");
    printf("   Hola desde GitHub Actions!\n");

    // Imprimir en la pantalla inferior (opcional)
    printf("\n\n   Presiona START para salir.");

    while(1) {
        // Escuchar la entrada de botones
        scanKeys();
        int keys = keysDown();

        if (keys & KEY_START) break;

        // Esperar al refresco de pantalla (VBlank) para ahorrar batería
        swiWaitForVBlank();
    }

    return 0;
}
