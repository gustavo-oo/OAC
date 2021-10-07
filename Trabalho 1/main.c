/*  TRABALHO 1 - MEMÓRIA DO RISC-V
    Nome: Gustavo Pereira Chaves
    Matrícula: 19/0014113
    Disciplina: Organização e Arquitetura de Computadores - Turma C
    Plataforma Utilizada:
        Linguagem: C
        Compilador: GCC
        Sistema Operacional: Ubuntu 20.04
        IDE: Visual Studio Code (Editor de Texto)
    Resumo:
        Neste trabalho foram desenvolvidas funções que simulam instruções de acesso à memória
        em um RISC-V com palavras de tamanho 32 bits. Dentre essas funções, encontram-se escrita
        de memória em byte (sb) ou word (sw), além de métodos de leitura de byte sem sinal (lbu),
        byte com sinal (lb) e word (lw). Também foi desenvolvido testes que mostrem o funciomento
        de cada uma.
*/
#include <stdio.h>
#include <stdint.h>

#define MEM_SIZE 4096 
int32_t mem[MEM_SIZE]; 

//Declaração das funções

// ==================== Funções de Leitura e escrita na memória ====================
int32_t lw(uint32_t adress, int32_t kte); //Le uma palavra inteira
int32_t lb(uint32_t address, int32_t kte);  //Le um byte com sinal
int32_t lbu(uint32_t address, int32_t kte); // Le um byte sem sinal
void sw(uint32_t address, int32_t kte, int32_t dado); //Salva uma palavra inteira
void sb(uint32_t address, int32_t kte, int8_t dado); //Salva um byte

// ==================== Funções auxiliares para o printf dos testes ====================
void print_mem(int start, int end); //Imprime o vetor memoria do endereco "start" ate "end"
void lb_mem(int start, int end); //Imprime os bytes com sinal do vetor memoria do endereco "start" até "end"
void lbu_mem(int start, int end);//Imprime os bytes sem sinal do vetor memoria do endereco "start" até "end"
void lw_mem(int start, int end);//Imprime as palavras do endereco "start" ate "end"

int main(){
    //Iniciar a memória
    printf("======== INITIALIZING MEMORY ========\n\n");
    sb(0, 0, 0x04); 
    sb(0, 1, 0x03); 
    sb(0, 2, 0x02); 
    sb(0, 3, 0x01);
    sb(4, 0, 0xFF); 
    sb(4, 1, 0xFE); 
    sb(4, 2, 0xFD); 
    sb(4, 3, 0xFC);

    sw(12, 0, 0xFF); 
    sw(16, 0, 0xFFFF);
    sw(20, 0, 0xFFFFFFFF);
    sw(24, 0, 0x80000000);

    sw(28, 0, 0x98765432);
    sw(32, 0, 0x98765432);
    sb(32, 1, 0xFF);
    sw(32, 1, 0xFFF00000);
    sw(32, 2, 0xFFF00000);
    sw(32, 3, 0XFFF00000);
    sw(32, 4, 0XFFF00000);
    
    printf("\n");

    //Imprimir conteúdo da memória em formato hexadecimal
    print_mem(0, 9);

    //Ler dados e imprimir em hexadecimal
    lb_mem(0, 39);
    lbu_mem(0, 39);
    lw_mem(0, 36);

    return 0;
}

// ==================== Funções de Leitura e escrita na memória ====================

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


// ==================== Funções auxiliares para o printf dos testes ====================
void print_mem(int start, int end){
    printf("============ PRINTING FROM MEMORY ============\n\n");
    for (int i = start; i <= end; i++){
        printf(" mem[%d] = %.8X\n", i, mem[i]);
    }
    printf("\n");
}

void lb_mem(int start, int end){
    int address;
    int kte;
        
    printf("======== LOAD SIGNED BYTE FROM MEMORY ========\n\n");
    printf(" Adress  Content\n");
    for (int i = start; i <= end; i++){
        kte = i % 4;
        address = i - kte;

        printf(" %.4d    %.8X\n", i, lb(address, kte));
    }
    printf("\n");
}

void lbu_mem(int start, int end){
    int address;
    int kte;
        
    printf("======== LOAD UNSIGNED BYTE FROM MEMORY ========\n\n");
    printf(" Adress  Content\n");
    for (int i = start; i <= end; i++){
        kte = i % 4;
        address = i - kte;

        printf(" %.4d    %.8X\n", i, lbu(address, kte));
    }
    printf("\n");
}

void lw_mem(int start, int end){
    int address;
    int kte;

    printf("======== LOAD WORD FROM MEMORY ========\n\n");
    for (int i = start; i <= end; i++){
        kte = i % 4;
        address = i - kte;

        printf(" Address: %d\n", i);
        printf(" Content: %.8X\n", lw(address, kte));
        printf("\n");
    }
    printf("\n");
}