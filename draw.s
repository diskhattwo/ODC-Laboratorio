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

	.include "config.s"

.ifndef draw
.equ draw, 0x000000
fondo:
	cielo:

		movz x10, 0x87, lsl 16
		movk x10, 0xCEEB, lsl 00

		mov x5, x0

		mov x2, SCREEN_HEIGH         // Y Size
	loop1:
		mov x1, SCREEN_WIDTH         // X Size
	loop0:
		str w10, [x5]
		add x5,x5,4    // Siguiente pixel
		sub x1,x1,1    // Decrementar contador X
		cbnz x1,loop0  // Si no terminó la fila, salto
		sub x2,x2,1    // Decrementar contador Y
		CMP x2, 150    //comparo si x2 es 400
		B.NE loop1	   // si son diferentes vuelve al loop 
ret

// ------- FORMAS -------
dibujarRectangulo:
	sub sp, sp, 48
	str x1, [sp]
	str x2, [sp, 8]
	str x3, [sp, 16]
	str x4, [sp, 24]
	str x10, [sp, 32]
	STR X30, [SP, 40]

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
	
	LDR X30, [SP, 40]
	ldr x10, [sp, 32]
	ldr x4, [sp, 24]
	ldr x3, [sp, 16]
	ldr x2, [sp, 8]
	ldr x1, [sp]
	add sp, sp, 48
ret
.endif
