#ifndef MAIN_H   // Guarda para evitar que el archivo se incluya dos veces
#define MAIN_H

#include <"nds.h"> // Incluimos las librerías de la DS aquí para tenerlas en todo el proyecto

// Definición de constantes para N$DS64
#define VERSION "0.1a"
#define SCREEN_WIDTH 256
#define SCREEN_HEIGHT 192

// Prototipos de funciones (declaramos que existen)
void inicializarConsola(void);
void mostrarMenu(void);

#endif
