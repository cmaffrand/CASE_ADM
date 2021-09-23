#pragma once

#include <stdint.h>


extern uint32_t asm_sum (uint32_t firstOperand, uint32_t secondOperand);
extern uint64_t asm_sum64 (uint64_t firstOperand, uint64_t secondOperand);
extern void asm_zeros (uint32_t * vector, uint32_t longitud);
extern void asm_pe32 (uint32_t * vectorA, uint32_t * vectorB, uint32_t longitud, uint32_t escalar);
extern void asm_svc (void);