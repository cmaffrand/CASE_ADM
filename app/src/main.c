#include "board.h"
#include "c_func.h"
#include "asm_func.h"

#include <stdlib.h>
#include <stdnoreturn.h>
#include <stdio.h>
#include <stdlib.h>

// Variable que se incrementa cada vez que se llama al handler de interrupcion
// del SYSTICK.
static volatile uint32_t s_ticks = 0;

#define DWT_CONTROL             (*((volatile uint32_t*)0xE0001000))
#define DWT_CYCCNT              (*((volatile uint32_t*)0xE0001004))
#define DWT_CYCCNTENA_BIT       (1UL<<0)

#define EnableCycleCounter()    DWT_CONTROL |= DWT_CYCCNTENA_BIT
#define GetCycleCounter()       DWT_CYCCNT
#define ResetCycleCounter()     DWT_CYCCNT = 0
#define DisableCycleCounter()   DWT_CONTROL &= ~DWT_CYCCNTENA_BIT

// Inicia soporte de la placa y periodo de la interrupcion del SYSTICK
// cada 1 milisegundo.
static void Inicio(void)
{
    Board_Init();
    SystemCoreClockUpdate();
    SysTick_Config(SystemCoreClock / 1000);

    //Contadores de ciclos
    uint32_t * H_DWT_DEMCR	 = (uint32_t *)0xE000EDFC;
    uint32_t * H_DWT_CTRL	 = (uint32_t *)0xE0001000;

    // bit24[TRCENA]   = habilita todos los DWT
    *H_DWT_DEMCR |= 1<<24;
    // bit0[CYCCNTENA] =  enable CYCCNT
    *H_DWT_CTRL |= 1;

    Board_Debug_Init();
}

// Segun la configuracion realizada en Inicio(), este handler de interrupcion
// se ejecutara cada 1 milisegundo.
void SysTick_Handler(void)
{
    ++s_ticks;
}

static void Suma(void)
{
    const uint32_t A = 20;
    const uint32_t B = 30;

    const uint32_t SumResult_C = c_sum(A, B);
    const uint32_t SumResult_Asm = asm_sum(A, B);

    // Actividad de debug: SumResult_C y SumResult_Asm deberian contener el
    // mismo valor.
    //__BKPT(0);

    (void)SumResult_C;
    (void)SumResult_Asm;
}

static void Suma64(void)
{
    const uint64_t A = (uint32_t) -1;
    const uint64_t B = (uint32_t) -2;

    const uint64_t SumResult_C = c_sum64(A, B);
    const uint64_t SumResult_Asm = asm_sum64(A, B);

    // Actividad de debug: SumResult_C y SumResult_Asm deberian contener el
    // mismo valor.
    //__BKPT(0);

    (void)SumResult_C;
    (void)SumResult_Asm;
}

static void Zeros(void)
{
    uint32_t vectorc[10];
    uint32_t vectorasm[10];
    uint32_t *pvectorc = vectorc;
    uint32_t *pvectorasm = vectorasm;

    zeros(pvectorc, sizeof(vectorc) / sizeof(uint32_t));
    asm_zeros(pvectorasm, sizeof(vectorasm) / sizeof(uint32_t));
}

static void pe32(void)
{
    uint32_t vectorA[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    uint32_t vectorB[] = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19};
    uint32_t *pvectorA = vectorA;
    uint32_t *pvectorB = vectorB;
    uint32_t escalar = 10;
    uint32_t vectorcA[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    uint32_t vectorcB[] = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19};
    uint32_t *pvectorcA = vectorcA;
    uint32_t *pvectorcB = vectorcB;

    c_pe32(pvectorcA, pvectorcB, sizeof(vectorcA) / sizeof(uint32_t), escalar);
    asm_pe32(pvectorA, pvectorB, sizeof(vectorA) / sizeof(uint32_t), escalar);
}

static void pe16(void)
{
    uint16_t asmA[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    uint16_t asmB[] = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19};
    uint32_t escalar = 10;
    uint16_t cA[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    uint16_t cB[] = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19};
    
    c_pe16(cA, cB, sizeof(cA) / sizeof(uint16_t), escalar);
    asm_pe16(asmA, asmB, sizeof(asmA) / sizeof(uint16_t), escalar);
}

static void pe16_sat12(void)
{
    uint16_t asmA[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    uint16_t asmB[] = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19};
    uint32_t escalar = 0xFFF;
    uint16_t cA[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    uint16_t cB[] = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19};
    uint32_t cycles_c,cycles_asm,cycles_asm_usat;
    char strNumber [10];

    Board_UARTPutSTR("Ejercicio 4: pe16_sat12\r\n");
    // carga el contador de ciclos en 0
    ResetCycleCounter();
    c_pe16_sat12(cA, cB, sizeof(cA) / sizeof(uint16_t), escalar);
    cycles_c = GetCycleCounter();
    itoa(cycles_c,strNumber,10);
    Board_UARTPutSTR("Ciclos en c: ");
    Board_UARTPutSTR(strNumber);
    Board_UARTPutSTR("\r\n");

    ResetCycleCounter();
    asm_pe16_sat12(asmA, asmB, sizeof(asmA) / sizeof(uint16_t), escalar);
    cycles_asm = GetCycleCounter();
    itoa(cycles_asm,strNumber,10);
    Board_UARTPutSTR("Ciclos en asm: ");
    Board_UARTPutSTR(strNumber);
	Board_UARTPutSTR("\r\n");

    ResetCycleCounter();
    asm_pe16_usat12(asmA, asmB, sizeof(asmA) / sizeof(uint16_t), escalar);
    cycles_asm_usat = GetCycleCounter();
    itoa(cycles_asm_usat,strNumber,10);
    Board_UARTPutSTR("Ciclos en asm_sat: ");
    Board_UARTPutSTR(strNumber);
	Board_UARTPutSTR("\r\n");
}

static void filtroVentana10(void)
{
    uint16_t asmIn[1000];
    uint16_t asmOut[1000];
    uint16_t cIn[1000];
    uint16_t cOut[1000];
    uint32_t cycles_c,cycles_asm;
    char strNumber [10];

    Board_UARTPutSTR("Ejercicio 5: filtroVentana10\r\n");

    // init vectors
    for (uint32_t i = 0; i < sizeof(asmIn) / sizeof(asmIn[0]); i++)
    {
        asmIn[i] = i;
        cIn[i] = i;
    }
    
    // carga el contador de ciclos en 0
    ResetCycleCounter();
    c_filtroVentana10(cIn, cOut, sizeof(cIn) / sizeof(cIn[0]));
    cycles_c = GetCycleCounter();
    itoa(cycles_c,strNumber,10);
    Board_UARTPutSTR("Ciclos en c: ");
    Board_UARTPutSTR(strNumber);
    Board_UARTPutSTR("\r\n");

    // carga el contador de ciclos en 0
    ResetCycleCounter();
    asm_filtroVentana10_unfolded(asmIn, asmOut, sizeof(asmIn) / sizeof(asmIn[0]));
    cycles_asm = GetCycleCounter();
    itoa(cycles_asm,strNumber,10);
    Board_UARTPutSTR("Ciclos en asm unfolded: ");
    Board_UARTPutSTR(strNumber);
    Board_UARTPutSTR("\r\n");

    // carga el contador de ciclos en 0
    ResetCycleCounter();
    asm_filtroVentana10(asmIn, asmOut, sizeof(asmIn) / sizeof(asmIn[0]));
    cycles_asm = GetCycleCounter();
    itoa(cycles_asm,strNumber,10);
    Board_UARTPutSTR("Ciclos en asm: ");
    Board_UARTPutSTR(strNumber);
    Board_UARTPutSTR("\r\n");

}

static void pack32to16(void)
{
    int32_t asmIn[1000];
    int16_t asmOut[1000];
    int32_t cIn[1000];
    int16_t cOut[1000];
    uint32_t cycles_c,cycles_asm;
    char strNumber [10];
    int32_t toggle = 10000;

    Board_UARTPutSTR("Ejercicio 6: pack32to16\r\n");

    // init vectors
    for (uint32_t i = 0; i < sizeof(asmIn) / sizeof(asmIn[0]); i++)
    {
        asmIn[i] = i*toggle;
        cIn[i] = i*toggle;
        toggle = -1*toggle;
    }
    
    // carga el contador de ciclos en 0
    ResetCycleCounter();
    c_pack32to16(cIn, cOut, sizeof(cIn) / sizeof(cIn[0]));
    cycles_c = GetCycleCounter();
    itoa(cycles_c,strNumber,10);
    Board_UARTPutSTR("Ciclos en c: ");
    Board_UARTPutSTR(strNumber);
    Board_UARTPutSTR("\r\n");

    // carga el contador de ciclos en 0
    ResetCycleCounter();
    asm_pack32to16(asmIn, asmOut, sizeof(asmIn) / sizeof(asmIn[0]));
    cycles_asm = GetCycleCounter();
    itoa(cycles_asm,strNumber,10);
    Board_UARTPutSTR("Ciclos en asm: ");
    Board_UARTPutSTR(strNumber);
    Board_UARTPutSTR("\r\n");

}

static void max(void)
{
    int32_t vIn[1000];
    int32_t max;
    uint32_t cycles_c,cycles_asm;
    char strNumber [10];
    int32_t toggle = 10000;

    Board_UARTPutSTR("Ejercicio 7: max\r\n");

    // init vectors
    for (uint32_t i = 0; i < sizeof(vIn) / sizeof(vIn[0]); i++)
    {
        vIn[i] = i*toggle;
        toggle = -1*toggle;
    }
    
    // carga el contador de ciclos en 0
    ResetCycleCounter();
    max = c_max(vIn, sizeof(vIn) / sizeof(vIn[0]));
    cycles_c = GetCycleCounter();
    itoa(cycles_c,strNumber,10);
    Board_UARTPutSTR("Ciclos en c: ");
    Board_UARTPutSTR(strNumber);
    Board_UARTPutSTR("\r\n");

    // carga el contador de ciclos en 0
    ResetCycleCounter();
    max = asm_max(vIn, sizeof(vIn) / sizeof(vIn[0]));
    cycles_asm = GetCycleCounter();
    itoa(cycles_asm,strNumber,10);
    Board_UARTPutSTR("Ciclos en asm: ");
    Board_UARTPutSTR(strNumber);
    Board_UARTPutSTR("\r\n");
}

static void invertir(void)
{
    uint16_t vIn[1000];
    uint32_t cycles_c,cycles_asm;
    char strNumber [10];
    int32_t toggle = 10000;

    Board_UARTPutSTR("Ejercicio 9: invertir\r\n");

    // init vectors
    for (uint32_t i = 0; i < sizeof(vIn) / sizeof(vIn[0]); i++) 
        vIn[i] = i;
    
    // carga el contador de ciclos en 0
    ResetCycleCounter();
    c_invertir(vIn, sizeof(vIn) / sizeof(vIn[0]));
    cycles_c = GetCycleCounter();
    itoa(cycles_c,strNumber,10);
    Board_UARTPutSTR("Ciclos en c: ");
    Board_UARTPutSTR(strNumber);
    Board_UARTPutSTR("\r\n");

    // carga el contador de ciclos en 0
    ResetCycleCounter();
    asm_invertir(vIn, sizeof(vIn) / sizeof(vIn[0]));
    cycles_asm = GetCycleCounter();
    itoa(cycles_asm,strNumber,10);
    Board_UARTPutSTR("Ciclos en asm: ");
    Board_UARTPutSTR(strNumber);
    Board_UARTPutSTR("\r\n");
}

static void LlamandoAMalloc(void)
{
    // De donde saca memoria malloc?
    // (se vera en clase)
    void *ptr = malloc(2048);

    (void)ptr;
}

static void PrivilegiosSVC(void)
{
    // Obtiene valor del registro de 32 bits del procesador llamado "control".
    // El registro guarda los siguientes estados:
    // bit 2: Uso de FPU en el contexto actual. Usado=1, no usado=0.
    // bit 1: Mapeo del stack pointer(sp). MSP=0, PSP=1.
    // bit 0: Modo de ejecucion en Thread. Privilegiado=0, No privilegiado=1.
    //        Recordar que este valor solo se usa en modo Thread. Las
    //        interrupciones siempre se ejecutan en modo Handler con total
    //        privilegio.
    uint32_t x = __get_CONTROL();

    // Actividad de debug: Ver registro "control" y valor de variable "x".
    __BKPT(0);

    x |= 1;
    // bit 0 a modo No privilegiado.
    __set_CONTROL(x);

    // En este punto se estaria ejecutando en modo No privilegiado.
    // Lectura del registro "control" para confirmar.
    x = __get_CONTROL();

    // Actividad de debug: Ver registro "control" y valor de variable "x".
    __BKPT(0);

    x &= ~1u;
    // Se intenta volver a modo Privilegiado (bit 0, valor 0).
    __set_CONTROL(x);

    // Confirma que esta operacion es ignorada por estar ejecutandose en modo
    // Thread no privilegiado.
    x = __get_CONTROL();

    // Actividad de debug: Ver registro "control" y valor de variable "x".
    __BKPT(0);

    // En este punto, ejecutando en modo Thread no privilegiado, la unica forma
    // de volver a modo privilegiado o de realizar cualquier cambio que requiera
    // modo privilegiado, es pidiendo ese servicio a un hipotetico sistema
    // opertivo de tiempo real.
    // Para esto se invoca por software a la interrupcion SVC (Supervisor Call)
    // utilizando la instruccion "svc".
    // No hay intrinsics para realizar esta tarea. Para utilizar la instruccion
    // es necesario implementar una funcion en assembler. Ver el archivo suma.S.
    asm_svc();

    // El sistema operativo (el handler de SVC) deberia haber devuelto el modo
    // de ejecucion de Thread a privilegiado (bit 0 en valor 0).
    x = __get_CONTROL();

    // Fin del ejemplo de SVC
}

// Handler de la interrupcion "SVC" (Supervisor Call).
// Usado por el ejemplo "EjemploPrivilegiosSVC".
void SVC_Handler(void)
{
    // Se obtiene el valor del registro "control". El bit 0 indica el nivel
    // de privilegio en modo "Thread". Deberia ser 1: No privilegiado.
    uint32_t x = __get_CONTROL();

    // Borra el bit 0. Nuevo valor 0: privilegiado.
    x &= ~1u;

    // Asigna el nuevo valor al registro "control". Esta operacion deberia
    // ejecutarse ya que todo manejador de interrupciones se ejecuta en modo
    // "Handler" con total privilegio.
    __set_CONTROL(x);
}

noreturn void LoopInfinito(void)
{
    while (1)
    {
        // Procesador en modo espera hasta que ocurra una interrupcion
        // (Bajo consumo)
        __WFI();
    }
}

int main(void)
{
    Inicio();
    Suma();
    Suma64();
    Zeros();
    pe32();
    pe16();
    pe16_sat12();
    filtroVentana10();
    pack32to16();
    max();
    invertir();

    PrivilegiosSVC();
    LlamandoAMalloc();
    LoopInfinito();
}
