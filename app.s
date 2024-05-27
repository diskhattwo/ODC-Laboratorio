	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32

	.equ COLOR_1,        0xFF
	.equ COLOR_2,        0xFFFF
	.equ COLOR_NEGRO,    0x00

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34

	.globl main
	.include "draw.s"
	.include "config.s"
	.include "colour.s"
main:
	
	// x0 contiene la direccion base del framebuffer
	// 32 bits per pixel (4 bytes)

	// registros reservaados
	// x10 = colour
	// x1 = x1
	// x2 = y1
	// x3 = x2
	// x4 = y2
	//
	//

	bl fondo

	// esto ubica el rectangulo
	mov x1, 150			// posición x
	mov x2, 150			// posición y
	mov x3, 500			// ancho
	mov x4, 350			// largo
	ldr x10, =AMARILLO
	// esto lo dibuja
	bl dibujarRectangulo

	// esto ubica el rectangulo
	mov x1, 170			// posición x
	mov x2, 170			// posición y
	mov x3, 480			// ancho
	mov x4, 330			// largo
	ldr x10, =BLANCO
	// esto lo dibuja
	bl dibujarRectangulo
	// hiiiii heyyyyy omg :3
InfLoop:
	b InfLoop


