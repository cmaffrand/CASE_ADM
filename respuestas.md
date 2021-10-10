# Preguntas orientadoras

1. Describa brevemente los diferentes perfiles de familias de
microprocesadores/microcontroladores de ARM. Explique alguna de sus diferencias características.

* Familia Cortex:
    * Cortex A: Para aplicaciones de alta performance.
    * Cortex R: Para uso en sistemas de tiempo real.
    * Cortex M: Uso en microcontroladores.
* Familia Clasica: Procesadores antiguos que en los cuales no se distinguia tan claramente la aplicación.

## Cortex M

1. Describa brevemente las diferencias entre las familias de procesadores Cortex M0, M3 y M4.
* M0: Micro de arquitectura Von Neumann de bajo consumo dedicado a diseños de complejidad muy baja.
* M1: Evolución del M0 al que se le agrega una TCM.
* M3: Micro de arquitectura Hardvard dedicado a diseños de complejidad media.
* M4: Micro de arquitectura Hardvard al que se le agrega manejo de DSP y FPU.
* M7: Micro de arquitectura Hardvard  que soporta FPU de Doble presisión.
2. ¿Por qué se dice que el set de instrucciones Thumb permite mayor densidad de código? Explique
* El set de instrucciones Thumb al ser instrucciones de 16-bits las instrucciones ocupan menos espacio en memoria, lo que hace que la cantidad de memoria con código ejecutable suba, por lo que mejora la densidad de código.
3. ¿Qué entiende por arquitectura load-store? ¿Qué tipo de instrucciones no posee este tipo de arquitectura?
* Es una arquitectura donde no se puede operar sobre la memoria, por lo que hay que cargar **load** los valores de la memoria a los registros para operar y luego de obtenido el resutado bajarlos **store** de nuevo a la memoria. 
* Instrucciones de Load: __ldr__ __ldrh__
* Instrucciones de Store: __str__ __strh__ 
4. ¿Cómo es el mapa de memoria de la familia?
* El mapa de memoria está dividio en zonas para la implementación de los datos del sistema, otro para el código, otro de memoria SRAM (donde se implementa bit band), manejo de ram externa, manejo de periféricos internos y externos.
5. ¿Qué ventajas presenta el uso de los “shadowed pointers” del PSP y el MSP?
* Hace que solo la tarea corromple el stack esto no afecta a otras tareas o al sistema operativo.
6. Describa los diferentes modos de privilegio y operación del Cortex M, sus relaciones y como se conmuta de uno al otro. Describa un ejemplo en el que se pasa del modo privilegiado a no priviligiado y nuevamente a privilegiado.
* Modo privilegiado: 
* Modo No privilegiado:
7. ¿Qué se entiende por modelo de registros ortogonal? Dé un ejemplo
*
8. ¿Qué ventajas presenta el uso de intrucciones de ejecución condicional (IT)? Dé un ejemplo
*
9. Describa brevemente las excepciones más prioritarias (reset, NMI, Hardfault).
*
10. Describa las funciones principales de la pila. ¿Cómo resuelve la arquitectura el llamado a funciones y su retorno?
*
11. Describa la secuencia de reset del microprocesador.
*
12. ¿Qué entiende por “core peripherals”? ¿Qué diferencia existe entre estos y el resto de los periféricos?
*
13. ¿Cómo se implementan las prioridades de las interrupciones? Dé un ejemplo
*
14. ¿Qué es el CMSIS? ¿Qué función cumple? ¿Quién lo provee? ¿Qué ventajas aporta?
*
15. Cuando ocurre una interrupción, asumiendo que está habilitada ¿Cómo opera el microprocesador para atender a la subrutina correspondiente? Explique con un ejemplo
*
17. ¿Cómo cambia la operación de stacking al utilizar la unidad de punto flotante?
*
16. Explique las características avanzadas de atención a interrupciones: tail chaining y late arrival.
*
17. ¿Qué es el systick? ¿Por qué puede afirmarse que su implementación favorece la portabilidad de los sistemas operativos embebidos?
*
18. ¿Qué funciones cumple la unidad de protección de memoria (MPU)?
*
19. ¿Cuántas regiones pueden configurarse como máximo? ¿Qué ocurre en caso de haber solapamientos de las regiones? ¿Qué ocurre con las zonas de memoria no cubiertas por las regiones definidas?
*
20. ¿Para qué se suele utilizar la excepción PendSV? ¿Cómo se relaciona su uso con el resto de las excepciones? Dé un ejemplo
*
21. ¿Para qué se suele utilizar la excepción SVC? Expliquelo dentro de un marco de un sistema operativo embebido.
*
## ISA
1. ¿Qué son los sufijos y para qué se los utiliza? Dé un ejemplo
*
2. ¿Para qué se utiliza el sufijo ‘s’? Dé un ejemplo
*
3. ¿Qué utilidad tiene la implementación de instrucciones de aritmética saturada? Dé un ejemplo con operaciones con datos de 8 bits.
*
4. Describa brevemente la interfaz entre assembler y C ¿Cómo se reciben los argumentos de las funciones? ¿Cómo se devuelve el resultado? ¿Qué registros deben guardarse en la pila antes de ser modificados?
*
5. ¿Qué es una instrucción SIMD? ¿En qué se aplican y que ventajas reporta su uso? Dé un ejemplo.
*