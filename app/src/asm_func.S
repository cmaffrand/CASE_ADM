.syntax unified
.thumb
.text

@ Simbolos exportados
.global asm_sum
.global asm_sum64
.global asm_zeros
.global asm_pe32
.global asm_pe16
.global asm_pe16_sat12
.global asm_pe16_usat12
.global asm_filtroVentana10
.global asm_pack32to16
.global asm_max
.global asm_invertir
.global asm_svc

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   uint32_t asm_sum (uint32_t firstOperand, uint32_t secondOperand)
@
@ Parametros recibidos:
@   r0: firstOperand
@   r1: secondOperand
@ Valor de retorno:
@   r0: resultado de la suma de firstOperand y secondOperand
@
.thumb_func
asm_sum:
    add r0, r1  @ r0 = r0 + r1
    bx lr       @ vuelve adonde fue llamado

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   uint64_t asm_sum64 (uint64_t firstOperand, uint64_t secondOperand)
@
@ Parametros recibidos:
@   r0: firstOperand parte baja
@   r1: firstOperand parte alta
@   r2: secondOperand parte baja
@   r3: secondOperand parte alta
@ Valor de retorno:
@   r0: resultado de la suma parte baja
@   r1: resultado de la suma parte alta
@
.thumb_func
asm_sum64:
    adds r0, r2 @ r0 = r0 + r1
    adc r1, r3  @ r1 = r1 + r3 + carry
    bx lr       @ vuelve adonde fue llamada

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_zeros (uint32_t * vector, uint32_t longitud)
@
@ Parametros recibidos:
@   r0: * vector
@   r1: longitud
@ Parametros de función
@   r2: Numero cero
@
.thumb_func
asm_zeros:
    mov r2, 0           @ Usa r2 como 0
    .loop_zeros:
        str r2, [r0],4  @ Carga r2 en la dir apuntada por r0 e incr r0 en 4.
        subs r1, 1      @ Decrementa el contador
        bne .loop_zeros @ Vuelve a .loop_zeros cuando Z es ditinto de cero
    bx lr               @ Vuelve adonde fue llamada
        
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_pe32 (uint32_t * vectorIn,  uint32_t * vectorOut, uint32_t longitud, 
@   uint32_t escalar)
@
@ Parametros recibidos:
@   r0: * vectorIn
@   r1: * vectorOut
@   r2: longitud
@   r3: escalar
@ Parametros de función
@   r4: Variable intermedia para cargar el valor de vectorIn y multiplicar
@
.thumb_func
asm_pe32:
    push {r4}           @ Guarda el contexto de R4
    .loop_pe32:
        ldr r4, [r0],4  @ Toma el valor del vector de entrada
        mul r4, r3, r4  @ Multiplica el escalar por el vector de entrada iesimo
        str r4, [r1],4  @ Alamacena en el vector de salida
        subs r2, 1      @ Decrementa el contador 
        bne .loop_pe32  @ Vuelve a .loop_pe32 cuando Z es ditinto de cero
    pop	{r4}            @ Devuelve el contexto
    bx lr               @ Vuelve adonde fue llamada

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_pe16 (uint16_t * vectorIn,  uint16_t * vectorOut, uint32_t longitud, 
@   uint16_t escalar)
@
@ Parametros recibidos:
@   r0: * vectorIn
@   r1: * vectorOut
@   r2: longitud
@   r3: escalar
@ Parametros de función
@   r4: Variable intermedia para cargar el valor de vectorIn y multiplicar
@
.thumb_func
asm_pe16:
    push {r4}           @ Guarda el contexto de R4
    .loop_pe16:
        ldrh r4, [r0],2 @ Toma el valor del vector de entrada
        mul r4, r3, r4  @ Multiplica el escalar por el vector de entrada iesimo
        strh r4, [r1],2 @ Alamacena en el vector de salida
        subs r2, 1      @ Decrementa el contador 
        bne .loop_pe16  @ Vuelve a .loop_pe16 cuando Z es ditinto de cero
    pop	{r4}            @ Devuelve el contexto
    bx lr               @ Vuelve adonde fue llamada
    
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_pe16_sat12 (uint16_t * vectorIn,  uint16_t * vectorOut, uint32_t longitud, 
@   uint16_t escalar)
@
@ Parametros recibidos:
@   r0: * vectorIn
@   r1: * vectorOut
@   r2: longitud
@   r3: escalar
@ Parametros de función
@   r4: Variable intermedia para cargar el valor de vectorIn y multiplicar
@   r5: Variable intermedia para calcular el and y obtener información sobre saturacion
@
.thumb_func
asm_pe16_sat12:
    push {r4-r5}                @ Guarda el contexto
    .loop_pe16_sat12:
        ldrh r4, [r0],2         @ Toma el valor del vector de entrada
        mul r4, r3, r4          @ Multiplica el escalar por el vector de entrada iesimo
        ands r5, r4, #0xF000
        beq .loop_pe16_load
        movw r4, 0xFFF 
        .loop_pe16_load:
        strh r4, [r1],2         @ Alamacena en el vector de salida
        subs r2, 1              @ Decrementa el contador 
        bne .loop_pe16_sat12    @ Vuelve a .loop_pe16 cuando Z es ditinto de cero
    pop	{r4-r5}                 @ Devuelve el contexto
    bx lr                       @ Vuelve adonde fue llamada
    
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_pe16_sat12 (uint16_t * vectorIn,  uint16_t * vectorOut, uint32_t longitud, 
@   uint16_t escalar)
@
@ Parametros recibidos:
@   r0: * vectorIn
@   r1: * vectorOut
@   r2: longitud
@   r3: escalar
@ Parametros de función
@   r4: Variable intermedia para cargar el valor de vectorIn y multiplicar
@
.thumb_func
asm_pe16_usat12:
    push {r4}                @ Guarda el contexto
    .loop_pe16_usat12:
        ldrh r4, [r0],2         @ Toma el valor del vector de entrada
        mul r4, r3, r4          @ Multiplica el escalar por el vector de entrada iesimo
        usat r4, 12, r4
        strh r4, [r1],2         @ Alamacena en el vector de salida
        subs r2, 1              @ Decrementa el contador 
        bne .loop_pe16_usat12    @ Vuelve a .loop_pe16 cuando Z es ditinto de cero
    pop	{r4}                 @ Devuelve el contexto
    bx lr                       @ Vuelve adonde fue llamada
    
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
asm_filtroVentana10:
    push {r4-r6}                @ Guarda el contexto
    mov r3, 0                   @ r3 va a ser el accumulador se pone en cero
    mov r5, 10                  @ contador de muestras para parte inical
    mov r6, 10                  @ constante 10
    .initFiltro:
        ldrh r4, [r0],2         @ Toma el valor del vector de entrada
        add r3, r4              @ Suma acumulador
        udiv r4, r3, r6         @ Divide por 10
        strh r4, [r1],2         @ Alamacena en el vector de salida
        subs r5, 1              @ Decrementa el contador 
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
        subs r2, 1              @ Decrementa el contador 
        bne .finishFiltro
    pop	{r4-r6}                 @ Devuelve el contexto
    bx lr                       @ Vuelve adonde fue llamada
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_pack32to16(int32_t* vectorIn, int16_t * vectorOut, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: * vectorIn
@   r1: * vectorOut
@   r2: longitud
@ Parametros de función
@   r3: Variable intermedia para cargar el valor de vectorIn y shift
@
.thumb_func
asm_pack32to16:
    add r0, 2
    .loop_pack32to16:       
        ldrh r3, [r0],4         @ Toma el valor del vector de entrada
        strh r3, [r1],2         @ Alamacena en el vector de salida
        subs r2, 1              @ Decrementa el contador 
        bne .loop_pack32to16    @ Vuelve a .loop_pack32to16 cuando Z es ditinto de cero
    bx lr                       @ Vuelve adonde fue llamada

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   int32_t asm_max(int32_t* vectorIn, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: * vectorIn
@   r1: longitud
@ Parametros de función
@   r2: variable intermedia maximo
@   r3: variable intermedia posicion maximo
@ Parametros de Salida
@   r0: posicion del valor maximo en el vector de entada.
@
.thumb_func
asm_max:
    push {r4-r5}                @ Guarda el contexto
    mov r5, r1                  @ constante del largo del vector
    mov r3, r1                  @ posicion del maximo
    ldr r4, [r0],4              @ valor minimo representado
    sub r1, 1                   @ Decrementa el contador 
    .loop_max:       
        ldr r2, [r0],4          @ Toma el valor del vector de entrada
        cmp r4, r2              @ Compara r4 con r2 
        bge .no_max             @ Signed Greater Than or Equal
        mov r3, r1              @ guarda la posicion invertida del maximo
        mov r4, r2              @ guarda el maximo
        .no_max:
        subs r1, 1              @ Decrementa el contador 
        bne .loop_max           @ Vuelve a .loop_max cuando Z es ditinto de cero
    sub r0, r5, r3              @ Asigna en r0 la posicion
    pop	{r4-r5}                 @ Devuelve el contexto
    bx lr                       @ Vuelve adonde fue llamada

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_invertir(uint16_t *vectorIn, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: * vectorIn
@   r1: longitud
@ Parametros de función
@   r2: direccion a intercambiar
@
.thumb_func
asm_invertir:
    push {r4}                   @ Guarda el contexto
    mov r2, 2                   @ asigno largo de palabra "2"
    mul r2, r1                  @ largo en bytes del vector
    add r2, r0                  @ calcula la direccion final del vector
    sub r2, 2                   @ calcula direccion del ultimo elemento del vector
    lsr r1, 1                   @ divide por 2
    .loop_invertir:       
        ldrh r3, [r0]           @ Toma el valor del vector de entrada bajo
        ldrh r4, [r2]           @ Toma el valor del vector de entrada alto
        strh r4, [r0],2         @ Alamacena en el vector de salida bajo
        strh r3, [r2],-2        @ Alamacena en el vector de salida alto
        subs r1, 1              @ Decrementa el contador 
        bne .loop_invertir      @ Vuelve a .loop_invertir cuando Z es ditinto de cero
    pop	{r4}                    @ Devuelve el contexto
    bx lr                       @ Vuelve adonde fue llamada

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_echo(int16_t* dato);
@
@ Parametros recibidos:
@   r0: * dato
@ Parametros de función
@   r2: direccion a intercambiar
@
.thumb_func
asm_echo:
    mov r1, #8192               @ asigno largo del vector en bytes
    add r0, r0, r1              @ calcula la direccion final del vector
    sub r0, 2                   @ calcula direccion del ultimo elemento del vector
    sub r1, #1764               @ resta antes de iterar los 882 palabras
    .loop_echo:       
        ldrh r1, [r0]           @ Toma el valor del vector de entrada
        ldrh r2, [r0,-882]      @ Toma el valor del vector de entrada alto
        lsr r2, 1               @ divide por dos
        add r3, r2, r1          @ Suma
        strh r3, [r0],-2        @ Alamacena en el vector de salida
        subs r1, 2              @ Decrementa el contador 
        bne .loop_echo          @ Vuelve a .loop_invertir cuando Z es ditinto de cero
    bx lr                       @ Vuelve adonde fue llamada

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_echo_sind(int16_t* dato);
@
@ Parametros recibidos:
@   r0: * dato
@ Parametros de función
@   r2: direccion a intercambiar
@
.thumb_func
asm_echo:
    mov r1, #8192               @ asigno largo del vector en bytes
    add r0, r0, r1              @ calcula la direccion final del vector
    sub r0, 4                   @ calcula direccion del ultimo elemento del vector
    sub r1, #1764               @ resta antes de iterar los 882 palabras
    mov r4, 0
    .loop_echo:       
        ldr r2, [r0]            @ Toma el valor del vector de entrada
        ldr r3, [r0,-882]       @ Toma el valor del vector de entrada alto
        shadd16 r3, r4          @ divide por dos r3
        shadd16 r5, r3, r2      @ Suma con promedio
        str r5, [r0],-2         @ Alamacena en el vector de salida
        subs r1, 2              @ Decrementa el contador 
        bne .loop_echo          @ Vuelve a .loop_invertir cuando Z es ditinto de cero
    bx lr  
    
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_svc (void)
@
.thumb_func
asm_svc:
    svc 0
    bx lr
