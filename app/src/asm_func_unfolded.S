.syntax unified
.thumb
.text

@ Simbolos exportados
.global asm_filtroVentana10_unfolded

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_filtroVentana10(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t 
@   longitudVectorIn);
@   
@ Parametros recibidos:
@   r0: * vectorIn
@   r1: * vectorOut
@   r2: longitud
@ Parametros de función
@   r3: Acumulador
@   r4: Variable intermedia para cargar el valor de vectorIn[i] y dividr
@   r5: Variable intermedia indice en initFiltro y el valor de vectorIn[i] en finishFiltro
@   r6: constante 10 para dividir
@
.thumb_func
asm_filtroVentana10_unfolded:
    push {r4-r6}                @ Guarda el contexto
    mov r3, 0                   @ r3 va a ser el accumulador se pone en cero
    mov r5, 10                  @ contador de muestras para parte inical
    mov r6, 10                  @ constante 10
    .initFiltro:
        ldrh r4, [r0],2         @ Toma el valor del vector de entrada
        add r3, r4              @ Suma acumulador
        udiv r4, r3, r6         @ Divide por 10
        strh r4, [r1],2         @ Alamacena en el vector de salida
        ldrh r4, [r0],2         @ Toma el valor del vector de entrada
        add r3, r4              @ Suma acumulador
        udiv r4, r3, r6         @ Divide por 10
        strh r4, [r1],2         @ Alamacena en el vector de salida
        subs r5, 2              @ Decrementa el contador 
        bne .initFiltro
    sub r2, 10                  @ Decrementa contador de largo en 10
    sub r0, 20                  @ resta la direccion 20
    .finishFiltro:
        ldrh r4, [r0,20]        @ Toma el valor del vector de entrada [i]
        ldrh r5, [r0],2         @ Toma el valor del vector de entrada [i-10] e incrementa
        add r3, r4              @ suma al acc el valor de entrada i
        sub r3, r5              @ Resta al acc el valor i-10
        udiv r4, r3, r6         @ Divide por 10
        strh r4, [r1],2         @ Alamacena en el vector de salida
        ldrh r4, [r0,20]        @ Toma el valor del vector de entrada [i]
        ldrh r5, [r0],2         @ Toma el valor del vector de entrada [i-10] e incrementa
        add r3, r4              @ suma al acc el valor de entrada i
        sub r3, r5              @ Resta al acc el valor i-10
        udiv r4, r3, r6         @ Divide por 10
        strh r4, [r1],2         @ Alamacena en el vector de salida
        subs r2, 2              @ Decrementa el contador 
        bne .finishFiltro
    pop	{r4-r6}                 @ Devuelve el contexto
    bx lr                       @ Vuelve adonde fue llamada
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@