#ifndef __MEM_H__
#define __MEM_H__

#define MEM_SIZE 4096 
extern int32_t mem[MEM_SIZE];

// ==================== Funções de Leitura e escrita na memória ====================
int32_t lw(uint32_t adress, int32_t kte); //Le uma palavra inteira
int32_t lb(uint32_t address, int32_t kte);  //Le um byte com sinal
int32_t lbu(uint32_t address, int32_t kte); // Le um byte sem sinal
void sw(uint32_t address, int32_t kte, int32_t dado); //Salva uma palavra inteira
void sb(uint32_t address, int32_t kte, int8_t dado); //Salva um byte
void load_mem(); // Le os binarios de code e data
void dump_mem(int start, int end, char format); // Imprime do endereço start até o endereço end
                                                // format = 'h' -> Hexa e 

#endif