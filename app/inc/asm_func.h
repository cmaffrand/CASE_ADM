#pragma once

#include <stdint.h>

extern uint32_t asm_sum(uint32_t firstOperand, uint32_t secondOperand);
extern uint64_t asm_sum64(uint64_t firstOperand, uint64_t secondOperand);
extern void asm_zeros(uint32_t *vector, uint32_t longitud);
extern void asm_pe32(uint32_t *vectorA, uint32_t *vectorB, uint32_t longitud, uint32_t escalar);
extern void asm_pe16(uint16_t *vectorA, uint16_t *vectorB, uint32_t longitud, uint16_t escalar);
extern void asm_pe16_sat12(uint16_t *vectorA, uint16_t *vectorB, uint32_t longitud, uint16_t escalar);
extern void asm_pe16_usat12(uint16_t *vectorA, uint16_t *vectorB, uint32_t longitud, uint16_t escalar);
extern void asm_filtroVentana10(uint16_t *vectorIn, uint16_t *vectorOut, uint32_t longitudVectorIn);
extern void asm_filtroVentana10_unfolded(uint16_t *vectorIn, uint16_t *vectorOut, uint32_t longitudVectorIn);
extern void asm_pack32to16(int32_t* vectorIn, int16_t * vectorOut, uint32_t longitud);
extern int32_t asm_max(int32_t* vectorIn, uint32_t longitud);
extern void asm_invertir(uint16_t *vectorIn, uint32_t longitud);
extern void asm_echo(int16_t *dato);
extern void asm_echo_sind(int16_t *dato);
extern void asm_svc(void);
