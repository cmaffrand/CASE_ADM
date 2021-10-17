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
* Thread Mode y Handler Mode. En el modo Thread, se puede ejecutar código en modo privilegiado o no privilegiado. El modo Handler es siempre modo privilegiado.
* Modo privilegiado: Para pasar a modo privilegiado se debe hacer por una interrupción.
* Modo No privilegiado: Para pasar a ese modo se puede hacer por SW.
7. ¿Qué se entiende por modelo de registros ortogonal? Dé un ejemplo
* Son registros que pueden ser utilizados con todas las intrucciones.
8. ¿Qué ventajas presenta el uso de intrucciones de ejecución condicional (IT)? Dé un ejemplo
* Evita que se destruya el pipeline, con ello aumenta la performance del micro.
9. Describa brevemente las excepciones más prioritarias (reset, NMI, Hardfault).
* RESET: Prioridad máxima (-3)
* NMI: Instrucciones no mascarables, prioirdad (-2), las que se pueden asiganar por el pin del micro.
* Hard Fault: es para cuando el programa hace algo indebido (expeciones), como asignar más memoria de la disponible. Prioridad (-1).
10. Describa las funciones principales de la pila. ¿Cómo resuelve la arquitectura el llamado a funciones y su retorno?
* La pila es el medio que le sirve al micro para cambiar de contexto y poder retornar a la ejecución nominal del programa en el futuro, dado que sirve como espacio de memoria donde se guardan todos los datos criticos.
11. Describa la secuencia de reset del microprocesador.
* Obteter el Main Stack Pointer.
* obtener el vector de reset.
* obtener la primera instrucción del programa.
12. ¿Qué entiende por “core peripherals”? ¿Qué diferencia existe entre estos y el resto de los periféricos?
* Son los periféricos propio de la familia cortex-M. Tienen la particularidad de ser independientes del funcionamiento del micro controlador.
13. ¿Cómo se implementan las prioridades de las interrupciones? Dé un ejemplo
* Utilizando el NVIC, asignado por ejemplo existen prioridades fijas como el reset (-3) y se le puede asignar una prioridad de interrupción aun periferico particular "Timer prioridad 128". La prioridad míniema asignable es 128. El orden de prioridad de es de menor a mayor.
14. ¿Qué es el CMSIS? ¿Qué función cumple? ¿Quién lo provee? ¿Qué ventajas aporta?
* CMSIS es un standar de fabricantes que debe ser cumplido por todos los dispostivos, para asegurar un grado mínimo de portabilidad.
15. Cuando ocurre una interrupción, asumiendo que está habilitada ¿Cómo opera el microprocesador para atender a la subrutina correspondiente? Explique con un ejemplo
* Se guarda el contexto de ejecución actual en la pila. Registros y PC.
* Se obtiene la dirección del handler de interrupción
* Se procede a ejecutar la interrupción
* Una vez finalizada de se reestablece el contexto del programa previo a la ejecución de de la interrupción.
17. ¿Cómo cambia la operación de stacking al utilizar la unidad de punto flotante?
* El stacking (se guardan registros en la FPU) de la FPU es de 12 ciclos, adicionalemnte a los registros tradiconales del procesador se usan los S0-S15.  
16. Explique las características avanzadas de atención a interrupciones: tail chaining y late arrival.
* Tail Chaining es cuando se salta de una interrupción a otra de mayor prioridad.
* Late Arrival es cuando se dispara el majador de interrupciones por una interrupción particular, pero en el proceso de ejecución de la entrada al manejo de esa interupción se genera una de mayor prioridad, lo que hace que todo el guardado de contexto que se estaba realizando ahora sea utiilizado para la interrupción que llego más tarde.
17. ¿Qué es el systick? ¿Por qué puede afirmarse que su implementación favorece la portabilidad de los sistemas operativos embebidos?
* systick es una base de tiempo para sistemas operativos en tiempo real, lo que hace que la portabilidad entre sistemas sea más sencilla.
18. ¿Qué funciones cumple la unidad de protección de memoria (MPU)?
* Establece un mecanismo de acceso a memoria según privilegios. Esto tiene como ventaja la mejor pretección de la memoria y la ejecución de código en lugares indebidos.
19. ¿Cuántas regiones pueden configurarse como máximo? ¿Qué ocurre en caso de haber solapamientos de las regiones? ¿Qué ocurre con las zonas de memoria no cubiertas por las regiones definidas?
* Pueden ser configuradas 8 regiones. Las zonas no asignadas por la MPU se las considera background. Si se quiere acceder a una zona no permita se genera una excepción.
20. ¿Para qué se suele utilizar la excepción PendSV? ¿Cómo se relaciona su uso con el resto de las excepciones? Dé un ejemplo
* Son excepciones que se pueden utilizar en los SO para gestionar cambios de contexto durante el Systick.
21. ¿Para qué se suele utilizar la excepción SVC? Expliquelo dentro de un marco de un sistema operativo embebido.
* Es una interrupción por SW utilizada para generar cambios de contextos, una utilidad sería volver a modo privilegiado, estando en no privilegiado solo por SW.
## ISA
1. ¿Qué son los sufijos y para qué se los utiliza? Dé un ejemplo
* Agregan una post condición a la instrucción como por ejemplo al salto B, se le agrega eq para que el sato tenga una condición de igualdad.
2. ¿Para qué se utiliza el sufijo ‘s’? Dé un ejemplo
* Se utiliza el subfijo s parara que la operación que se está realizando realice la actualizaciones de los flags.
3. ¿Qué utilidad tiene la implementación de instrucciones de aritmética saturada? Dé un ejemplo con operaciones con datos de 8 bits.
* Se utiliza para acotar el rango de los datos que estamos manejando a una cantidad de bits determinada. En saturación de 8 bits podríamos hacer que nuestra registro solo tome valores entre 127 y -128 para saturación signada y entre 0 y 255 para saturación signada. Todos los valores por encima serpan llevados al limite superior 127 o 255 y todos los valores inferiores serán llevados al límite inferior -127 o 0 según corresponda.
4. Describa brevemente la interfaz entre assembler y C ¿Cómo se reciben los argumentos de las funciones? ¿Cómo se devuelve el resultado? ¿Qué registros deben guardarse en la pila antes de ser modificados?
* Se reciben datos en los registros r0, r1, r2 y r3. Siempre y cuando sea necesario ese espació.
* Se devuelve el resgistros r0 como resultado de 32 bits o encaso de tener una palabra de 64 bis se utiliza r1 y r0.
* Se debe guardar el contexto de los registros r4 hasta r12 porque los mismos no son guardaso automaticamente en el cambio de contexto.
5. ¿Qué es una instrucción SIMD? ¿En qué se aplican y que ventajas reporta su uso? Dé un ejemplo.
* Son instrucciones de ejecución paralela en donde el registro de entrada es utilizado en dos partes para las instruccioens SIMD16 o en cuatro partes para las SIMD8. Esto permite ejecuciones de mayore velocidad, como desventaja puede observarse que en las mismas no se pude actualizar las banderas por lo que el uso de las SIMD queda asociado al procesamiento de datos y no al control de ejecución del programa.
