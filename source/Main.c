#include "main.h" // Importamos nuestra cabecera personalizada
#include <stdio.h>

void inicializarConsola() {
    consoleDemoInit();
    printf("N$DS64 v%s\n", VERSION);
    printf("Cargando sistema...");
}

int main(void) {
    inicializarConsola();

    while(1) {
        swiWaitForVBlank();
    }
    return 0;
}
