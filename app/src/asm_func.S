.syntax unified
.thumb
.text

@ Simbolos exportados
.global asm_sum
.global asm_sum64
.global asm_zeros
.global asm_pe32
.global asm_pe16
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
@   void asm_svc (void)
@
.thumb_func
asm_svc:
    svc 0
    bx lr
