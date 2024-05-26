	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32

    .equ CUBE_W,         50
    .equ CUBE_H,         50

	.equ COLOR_1,        0xFF
	.equ COLOR_2,        0xFFFF
	.equ COLOR_NEGRO,    0x00

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34

.globl dibujarRectangulo
dibujarRectangulo:
	cmp x1, x3				// compara x1 <= x2
	
	b.LE noSwapx			// si se cumple, no hace swap en x
	mov x16, x1
	mov x1, x3
	mov x3, x16				// si no, lo hace

noSwapx:
	cmp x2, x4				
	
	b.LE noSwapy
	mov x16, x2
	mov x2, x4
	mov x4, x16				// mismo code pero para y

noSwapy:

	mov x9, x1				// guardo x1 en x9

dibujarRectanguloPxP:
	cmp x2, x4				// comparo y1 con y2
	b.GT noPintar			// si y1 > y2, deja de pintar
	cmp x1, x3				// compara x1 con x2
	b.GT cambiaFila			// si x1 > x2, cambia de fila
	bl dibujarPixel			// sino, dibuja pixel
	add x1, x1, 1			// va al siguiente pixel
	b dibujarRectanguloPxP	// repite

cambiaFila:					
	mov x1, x9				// x1 vuelve a su valor original
	add x2, x2, 1			// aumento y1 en 1
	b dibujarRectanguloPxP	// repite

noPintar:
