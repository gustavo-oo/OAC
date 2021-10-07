/*  TRABALHO 2 - SIMULADOR RISC-V
    Nome: Gustavo Pereira Chaves
    Matrícula: 19/0014113
    Disciplina: Organização e Arquitetura de Computadores - Turma C
    Plataforma Utilizada:
        Linguagem: C
        Compilador: GCC
        Sistema Operacional: Ubuntu 20.04
        IDE: Visual Studio Code (Editor de Texto)
        Compilar com o comando: gcc main.c riscv.c mem.c
*/

#include <stdio.h>
#include <stdint.h>
#include "mem.h"
#include "riscv.h"

void run(int verbose){
    while(1){
        //Encerra o programa ao encontrar um exit ou ler 2k words
        if ((pc == 2000*4) || (end_of_program == 1)){
            return;
        }

        step();

        if(verbose){
            dump_reg('h');
            dump_mem(0x2000, 0x2014, 'h');

            printf("Pressione ENTER para continuar...");
            getchar();
        }
    }
}

int main(){
    load_mem();
    run(0); //Não imprime o banco de registradores e nem a memória
    //run(1);

    return 0;
}