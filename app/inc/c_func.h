#pragma once

#include <stdint.h>

uint32_t c_sum(uint32_t firstOperand, uint32_t secondOperand);
uint64_t c_sum64(uint64_t firstOperand, uint64_t secondOperand);
void zeros(uint32_t *vector, uint32_t longitud);
void c_pe32(uint32_t *vectorA, uint32_t *vectorB, uint32_t longitud, uint32_t escalar);
void c_pe16(uint16_t *vectorA, uint16_t *vectorB, uint32_t longitud, uint16_t escalar);
