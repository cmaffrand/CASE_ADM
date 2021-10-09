#include "c_func.h"

uint32_t c_sum(uint32_t firstOperand, uint32_t secondOperand)
{
    return (firstOperand + secondOperand);
}

uint64_t c_sum64(uint64_t firstOperand, uint64_t secondOperand)
{
    return (firstOperand + secondOperand);
}

void zeros(uint32_t *vector, uint32_t longitud)
{
    for (uint32_t i = 0; i < longitud; i++)
    {
        vector[i] = 0;
    }
}

void c_pe32(uint32_t *vectorA, uint32_t *vectorB, uint32_t longitud, uint32_t escalar)
{
    for (uint32_t i = 0; i < longitud; i++)
    {
        vectorB[i] = vectorA[i] * escalar;
    }
}

void c_pe16(uint16_t *vectorA, uint16_t *vectorB, uint32_t longitud, uint16_t escalar)
{
    for (uint32_t i = 0; i < longitud; i++)
    {
        vectorB[i] = vectorA[i] * escalar;
    }
}

void c_pe16_sat12(uint16_t *vectorA, uint16_t *vectorB, uint32_t longitud, uint16_t escalar)
{
    for (uint32_t i = 0; i < longitud; i++)
    {
        vectorB[i] = vectorA[i] * escalar;
        if (vectorB[i] > 0xFFF)
            vectorB[i] = 0xFFF;
    }
}

void c_filtroVentana10(uint16_t *vectorIn, uint16_t *vectorOut, uint32_t longitudVectorIn)
{
    uint32_t acc = 0;
    for (uint32_t i = 0; i < longitudVectorIn; i++)
    {
        if (i < 10)
            acc = acc + vectorIn[i];
        else
            acc = acc - vectorIn[i - 10] + vectorIn[i];
        vectorOut[i] = acc / 10;
    }
}
