/*
* Taller de Assembler
* Fredy Espana Capilla carne: 15060 
* Juan Pablo Cahueque  carne: 15396
* Realizado en una pantalla 1360x768
*/

.global draw_image

/*
* Esta subrutina dibuja una imagen en 8 bits
* INPUTS:
* r0 = Width x, r1 = Height y, r2 = direccion de la matriz 
* OUTPUTS:
* Imprime en pantalla una imagen con los parametros establecidos
*/

draw_image:
        push {lr}
        push {r4-r9}    /* Standrad ABI */  

        /* Se asignan los inputs */
        mov r4, r0  /* Se mueve width a r4 */
        mov r5, r1  /* Se mueve height a r5 */
        mov r6, r2  /* Se mueve la direccion de la matriz a r6 */       
        
        /********* Reset Y **********/
        ldr r2, =y
        mov r7, #0
        str r7, [r2]
        /****************************/

        /* Se obtiene la direccion de pantalla */
        bl getScreenAddr
        ldr r1, =pixelAddr
        str r0, [r1]
                   
        mov r9, #0      /* Contador */

loopy:
        /******** Reset X ********/
        mov r8, #0
        ldr r7, =x_checkpoint    
        ldr r7, [r7]
        ldr r1, =x
        str r7, [r1]
        /**************************/
        cmp r9, r5
        bgt end
        loopx:  
                ldr r0, =pixelAddr
                ldr r0, [r0]

                ldr r1, =x
                ldr r1, [r1]
                
                ldr r2, =y
                ldr r2, [r2]

                
                ldr r3, [r6], #4
          
                bl pixel

                /* Barrido en X */
                ldr r1, =x
                ldr r7, [r1]
                add r7, #1
                str r7, [r1]

                add r8, #1
                cmp r8, r4
                blt loopx

        /* Barrido en Y */
        ldr r2, =y
        ldr r7, [r2]
        add r7, #1
        str r7, [r2]
        add r9, #1
        b loopy

.global mask_leftovers

mask_leftovers:
        push {lr}
        push {r4-r9}    /* Standrad ABI */  

        /* Se asignan los inputs */
        mov r4, r0  /* Se mueve width a r4 */
        mov r5, r1  /* Se mueve height a r5 */
        mov r6, r2  /* Se mueve la direccion de la matriz a r6 */       


        /* Se dibuja la matriz desde las coordenadas deseadas */
        ldr r7, =mask_Offset
        ldr r7, [r7]
        add r6, r7
        ldr r7, =x_checkpoint
        ldr r7, [r7]
        add r6, r7
        add r6, r7
        add r6, r7
        add r6, r7


        /********* Reset Y **********/
        ldr r2, =y_chickens
        mov r7, #600
        str r7, [r2]
        /****************************/

        /* Se obtiene la direccion de pantalla */
        bl getScreenAddr
        ldr r1, =pixelAddr
        str r0, [r1]
                   
        mov r9, #0      /* Contador */

loopy_mask:
        /******** Reset X ********/
        mov r8, #0
        ldr r7, =x_checkpoint    
        ldr r7, [r7]
        sub r7, #10
        ldr r1, =x
        str r7, [r1]
        /**************************/
        cmp r9, r5
        bgt end
        loopx_mask:  
                ldr r0, =pixelAddr
                ldr r0, [r0]

                ldr r1, =x
                ldr r1, [r1]
                
                ldr r2, =y_chickens
                ldr r2, [r2]

                
                ldr r3, [r6], #4
          
                bl pixel

                /* Barrido en X */
                ldr r1, =x
                ldr r7, [r1]
                add r7, #1
                str r7, [r1]

                add r8, #1
                cmp r8, r4
                blt loopx_mask

                /*Salto de coordenadas*/
                ldr r7, =offset_x
                ldr r7, [r7]

                add r6, r7


        /* Barrido en Y */
        ldr r2, =y_chickens
        ldr r7, [r2]
        add r7, #1
        str r7, [r2]
        add r9, #1
        b loopy_mask
        

end:    
        pop {r4-r9}     /* Standard ABI */
        pop {pc}

.global draw_chickens

/*
* Esta subrutina dibuja una imagen en 8 bits
* INPUTS:
* r0 = Width x, r1 = Height y, r2 = direccion de la matriz 
* OUTPUTS:
* Imprime en pantalla una imagen con los parametros establecidos
*/

draw_chickens:
        push {lr}
        push {r4-r9}    /* Standrad ABI */  

        /* Se asignan los inputs */
        mov r4, r0  /* Se mueve width a r4 */
        mov r5, r1  /* Se mueve height a r5 */
        mov r6, r2  /* Se mueve la direccion de la matriz a r6 */       
        
        /********* Reset Y **********/
        ldr r2, =y_chickens
        mov r7, #600
        str r7, [r2]
        /****************************/

        /* Se obtiene la direccion de pantalla */
        bl getScreenAddr
        ldr r1, =pixelAddr
        str r0, [r1]
                   
        mov r9, #0      /* Contador */

loopy_chickens:
        /******** Reset X ********/
        mov r8, #0
        ldr r7, =x_checkpoint    
        ldr r7, [r7]
        ldr r1, =x
        str r7, [r1]
        /**************************/
        cmp r9, r5
        bgt end
        loopx_chickens:  
                ldr r0, =pixelAddr
                ldr r0, [r0]

                ldr r1, =x
                ldr r1, [r1]
                
                ldr r2, =y_chickens
                ldr r2, [r2]

                
                ldr r3, [r6], #4

                cmp r3, #255    /* Se dibuja solo si el pixel no es blanco */
                blne pixel

                /* Barrido en X */
                ldr r1, =x
                ldr r7, [r1]
                add r7, #1
                str r7, [r1]

                add r8, #1
                cmp r8, r4
                blt loopx_chickens

        /* Barrido en Y */
        ldr r2, =y_chickens
        ldr r7, [r2]
        add r7, #1
        str r7, [r2]
        add r9, #1
        b loopy_chickens

.data
.balign 4

/* Variables */
pixelAddr: .word 0
x: .word 0

.global x_checkpoint
x_checkpoint: .word 0

/* Constantes */
.global mask_Offset
mask_Offset: .word 3264000

offset_x: .word 5140
y: .word 0
y_chickens: .word 600


