/*
* Ejercicio mosaico
* Taller de Assembler
* Fredy Espana Capilla carne: 15060 
* Este programa dibuja un mosaico de 3x2 cuadrados de tres distintos colores
*/

.text
.balign 1
.global main

main:	
	/*Cargar el vector de turnos de gallinas*/
	ldr r10,=vectorRandom
fase1:

	ldr r0, =main_menuWidth
	ldr r0, [r0]
	ldr r1, =main_menuHeight
	ldr r1, [r1]
	ldr r2, =main_menu	
	bl draw_image

	ldr r11,=delayButton
	ldr r11,[r11]
	bl delay

	bl GetGpioAddress
	/*Colocar la funcion de los botones*/
	mov r0,#16
	mov r1,#0
	bl SetGpioFunction

	mov r0,#12
	mov r1,#0
	bl SetGpioFunction
	
	mov r0,#20
	mov r1,#0
	bl SetGpioFunction

	mov r0,#21
	mov r1,#0
	bl SetGpioFunction
	
	/*Esperar la reaccion de los botones*/

	/*BtnVerde*/
	mov r0,#12
	bl GetGpio

	cmp r0,#1
	//beq instrct
	
	/*BtnAzul*/
	mov r0,#16
	bl GetGpio

	cmp r0,#1
	beq play
	b fase1
instrct:
	ldr r0, =instructionsWidth
	ldr r0, [r0]
	ldr r1, =instructionsHeight
	ldr r1, [r1]
	ldr r2, =instructions	
	bl draw_image
	
	ldr r11,=delayButton
	ldr r11,[r11]	
	bl delay 
	mov r0,#16
	bl GetGpio
	
	cmp r0,#1
	beq fase1
	b instrct
play:
	/*Dibujar el paisaje de fondo una sola vez*/	
	ldr r0, =game_landscapeWidth
	ldr r0, [r0]
	ldr r1, =game_landscapeHeight
	ldr r1, [r1]
	ldr r2, =game_landscape
	bl draw_image
	/*Luego verificar a que gallina le toca pasar*/
	b verificar

	mov r4, #1

	/*Si le toca a la gallna verde*/
	green_chicken_moving:
	/*step del mask*/
	mov r0,#75

	ldr r1,=green_1Height
	ldr r1,[r1]

	ldr r2,=game_landscape

	bl mask_leftovers
	/* Asignacion de sprite de gallina*/
	cmp r4, #1
	ldreq r2, =green_1
	cmp r4, #2
	ldreq r2, =green_2
	cmp r4, #3
	ldreq r2, =green_3

	ldr r0, =green_1Width
	ldr r0, [r0]
	ldr r1, =green_1Height
	ldr r1, [r1]

	bl draw_chickens
	
	add r4, #1	
	

	cmp r4, #3
	movgt r4, #1
	/*Caminar hasta que llegue a x_limit*/
	ldr r5, =x_checkpoint
	ldr r6, [r5]
	ldr r0,=x_limit
	ldr r0,[r0]
	cmp r6,r0
	/*Si llega al limite, verificar el turno*/
	/*Hacer el masking aqui*/
	bge verificar
	add r6, #10
	str r6, [r5]

	ldr r11,=delayL1
	ldr r11,[r11]
	bl delay

	b green_chicken_moving

	/*r10 contiene el address del siguiente turno*/
	verificar:
	/*Resetear x_checkpoint a 0 para la siguiente*/
	ldr r0,=x_checkpoint
	ldr r11,[r0]
	mov r11,#0
	str r11,[r0]
	/*Comparar el turno y ejecutarlo*/
	ldr r11,[r10],#4
	cmp r11,#1
	beq green_chicken_moving
	//cmp r11,#2
	//beq blue_chicken_moving	
	
	ldr r0, =msg
	bl puts





end:

/* Finaliza el programa */	
mov r7,#1
swi 0 
@----------------------------
@Verificar turno de gallina
@NO input--------------------

@ ---------------------------
@ Delay function
@ Input: r11 delay counter val
@ ---------------------------
delay:
    push {r7}
    mov r7,#0
    b compare
loop:
    add r7,#1     //r7++
compare:
    cmp r7,r11     //test r7 == r11
    bne loop
    pop {r7}
    mov pc, lr


.data
.align 1

/* Coordenadas iniciales del mosaico */
x: .word 0
y: .word 50

/* Constantes */
delayL1:.word 10000000
vectorRandom: .word 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
delayButton:.word 90000000
x_limit: .word 650
.global myloc
myloc: .word 0
msg: .asciz "***************** DEBUG ********************"

