	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32

	.equ COLOR_1,        0xFF
	.equ COLOR_2,        0xFFFF

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34


	movz x10, COLOR_1, lsl 16
	movk x10, COLOR_2, lsl 0

.ifndef config 
.equ config, 0x000000
dibujarPixel:
	// return: x5, pixel a pintar
	// x2 = y, x1 = x
	mov x5, SCREEN_WIDTH	// x5 = 640
	mul x5, x2, x5			// ( y * 640 )
	add x5, x1, x5			// [ x + ( y * 640 )]
	lsl x5, x5, 2			// 4 * [ x + ( y * 640 )]
	add x5, x0, x5			// x5 = x0 + 4 * [ x + ( y * 640 )]
	str w10, [x5]			// colorea x5, que es x e y, con w10, que es el color en 32 bits
ret

dibujarLinea:          			   //este debería dibujar una linea segun si es h o v
    SUB SP, SP, #40   					        
    STR X1, [SP]           						
    STR X2, [SP, 8]        					
    STR X3, [SP, 16]
    STR X4, [SP, 24]
    STR X30, [SP, 32]

	cmp x1, x3		   
	b.EQ dibujarLineaV 			   // si x1 y x2 son iguales, dibuja vertical
								   
	cmp x2, x4					   
	b.EQ dibujarLineaH 			   // si y1 e y2 son iguales, dibuja horizontal

	LDR X30, [SP, 32]
	LDR X4, [SP, 24]
	LDR X3, [SP, 16]
	LDR X2, [SP, 8]     
    LDR X1, [SP]      
    ADD SP, SP, 40
ret

dibujarLineaV:
	SUB SP, SP, 16								
	STR X2, [SP]								
	STR X30, [SP, 8]

	cmp x2, x4	
	b.LE loopDibujarLineaV     	   // si y1 <= y2, va al loop

	mov x16, x2					   // x16 = aux
	mov x2, x4
	mov x4, x16			      	   // sino, cambia los valores para igual recorrer de arriba a abajo

	loopDibujarLineaV:
		pixelLoopLineaV:
			bl dibujarPixel  	   // dibuja un pixel
			add x2, x2, 1	 	   // va al siguiente pixel
			cmp x2, x4		 	   // compara si sigue siendo y1 <= y2
			b.LE pixelLoopLineaV   // si es, hace lo mismo denuevo

	LDR X30, [SP, 8]
	LDR X2, [SP]
	ADD SP, SP, 16
ret
dibujarLineaH:
	SUB SP, SP, 16								// Guardo el LR en el stack 
	STR X1, [SP]								// push(x1)
	STR X30, [SP, 8]

	cmp x1, x3					   // si x1 <= x2, va al loop
	b.LE loopDibujarLineaH
	
	mov x16, x1					   // x16 = aux
	mov x1, x3
	mov x3, x16					   // sino, cambia los valores para igual recorrer de izq a der

	loopDibujarLineaH:
		pixelLoopLineaH:
			bl dibujarPixel		   // dibuja un pixel
			add x1, x1, 1		   // va al siguiente pixel
			cmp x1, x3			   // compara si sigue siendo x1 <= x2
			b.LE pixelLoopLineaH   // si es, hace lo mismo denuevo

	LDR X30, [SP, 8]
	LDR X1, [SP]
	ADD SP, SP, 16
ret

//dibujarDiag:
//	SUB SP, SP, 40   					        
//    STR X1, [SP]           						
//    STR X2, [SP, 8]        					
//    STR X3, [SP, 16]
//    STR X4, [SP, 24]
//    STR X30, [SP, 32]
//
//	cmp x2, x4
//	b.LE noSwapyDiag
//	bl noSwapy
//
//	noSwapyDiag:
//	cmp x1, x3
//		b.LE noSwapxDiag
//	bl noSwapx
//
//	LDR X30, [SP, 32]
//	LDR X4, [SP, 24]
//	LDR X3, [SP, 16]
//	LDR X2, [SP, 8]     
//    LDR X1, [SP]      
//    ADD SP, SP, 40
//

.endif
