#include <stdio.h>
#include <stdint.h>
#include "mem.h"

int32_t mem[MEM_SIZE];

int32_t lw(uint32_t adress, int32_t kte){
    uint32_t word_adress = adress + kte;

    if(word_adress % 4 == 0){
        word_adress /= 4;
        return mem[word_adress];

    }else{
        printf(" Address is not multiple of four!\n");
        return 0;
    }
}

int32_t lb(uint32_t address, int32_t kte){
    uint32_t byte_adress = address + kte;

    int8_t * mem_byte = (int8_t *) mem;
    int32_t byte = mem_byte[byte_adress];

    return byte;
}

int32_t lbu(uint32_t address, int32_t kte){
    uint32_t byte_adress = address + kte;

    uint8_t * mem_byte = (uint8_t *) mem;
    int32_t byte = mem_byte[byte_adress];

    return byte;
}

void sw(uint32_t address, int32_t kte, int32_t dado){
    uint32_t word_adress = address + kte;

    if(word_adress % 4 == 0){
        word_adress /= 4;
        mem[word_adress] = dado;

    }else{
        printf(" Address %d is not multiple of four!\n", word_adress);
    }
}


void sb(uint32_t address, int32_t kte, int8_t dado){
    uint32_t byte_adress = address + kte;

    uint8_t * mem_byte = (uint8_t *) mem;
    mem_byte[byte_adress] = dado;
}

void dump_mem(int start, int end, char format){
    start = start/4;
    end = end/4;

    printf("============ MEMORY ============\n");

    if(format == 'h'){
        for (int i = start; i <= end; i++){
            printf(" mem[%d] = %.8X\n", i, mem[i]);
        }
    }else{
        if(format == 'd'){
            for (int i = start; i <= end; i++){
                printf(" mem[%d] = %d\n", i, mem[i]);
            }
        }
    }
    printf("\n");
}

void load_mem(){
    int start_adress;
    // Reading Code
    FILE * code = fopen("code", "rb");

    start_adress = 0;

    while(!feof(code)){
        fread(mem + start_adress, sizeof(int32_t), 1, code);
        start_adress += 1;
    };

    fclose(code);

    //Reading Data

    FILE * data = fopen("data", "rb");

    start_adress = 0x2000/4;

    while(!feof(code)){
        fread(mem + start_adress, sizeof(int32_t), 1, code);
        start_adress += 1;
    };
    fclose(data);
}