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

cielo:

	movz x10, 0x87, lsl 16
	movk x10, 0xCEEB, lsl 00

	mov x20, x0

	mov x2, SCREEN_HEIGH         // Y Size

loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w10,[x20]  // Colorear el pixel N
	add x20,x20,4    // Siguiente pixel
	sub x1,x1,1    // Decrementar contador X
	cbnz x1,loop0  // Si no terminó la fila, salto
	sub x2,x2,1    // Decrementar contador Y
	CMP x2, 150 //comparo si x2 es 400
	B.NE loop1 // si son diferentes vuelve al loop 



	movz x10, COLOR_1, lsl 16
	movk x10, COLOR_2, lsl 0

	// esto ubica el rectangulo
	mov x1, 90
	mov x2, 60
	mov x3, 150
	mov x4, 180

	// esto lo dibuja
	bl dibujarRectangulo

InfLoop:
	b InfLoop


