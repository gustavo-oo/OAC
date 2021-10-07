#include <stdio.h>
#include <stdint.h>
#include "riscv.h"

#define set_bit(word, index, val) ((word & ~(1 << index)) | ((val&1) << index))
#define set_field(word, index, mask, value) (word & ~(mask << index)) | (value << index)

int32_t breg[32];

uint32_t pc = 0,						// contador de programa
        ri = 0,						// registrador de intrucao
        sp = 0x3ffc,						// stack pointer
        gp = 0x1800;						// global pointer

uint32_t	opcode,					// codigo da operacao
            rs1,					// indice registrador rs
            rs2,					// indice registrador rt
            rd,						// indice registrador rd
            shamt,					// deslocamento
            funct3,					// campos auxiliares
            funct7;					// constante instrucao tipo J

int32_t imm;

short end_of_program = 0;

void dump_reg(char format){
    printf("============ REGISTERS ============\n");
    if(format == 'h'){
        printf("PC: %.8X\n", pc);
        printf("RI: %.8X\n", ri);
        printf("GP: %.8X\n", gp);
        printf("SP: %.8X\n\n", sp);

        for(int i = 0; i < 32; i++){
            printf("Registador %d: %.8X\n", i, breg[i]);
        }

    }else{
        if(format = 'd'){
            printf("PC: %d\n", pc);
            printf("RI: %d\n", ri);
            printf("GP: %d\n", gp);
            printf("SP: %d\n\n", sp);
        }

        for(int i = 0; i < 32; i++){
            printf("Registador %d: %d\n", i, breg[i]);
        }
    }
    printf("\n");
}

void fetch(){
    ri = lw(pc, 0);
    pc = pc + 4;
}

void step(){
    fetch();
    decode();
    execute();
}

void decode(){
    opcode = ri & 0x7F; //7 bits
    rd = (ri >> 7) & 0x1F; //5 bits
    rs1 = (ri >> 15) & 0x1F; // 5 bits
    rs2 = (ri >> 20) & 0x1F;// 5 bits
    funct3 = (ri >> 12) & 0x7; // 3 bits
    funct7 = (ri >> 25) & 0x7F; //7 bits
    shamt = (ri >> 20) & 0x1F; //5 bits
    imm = geraImm();
}

int32_t geraImm(){
    int32_t temp_imm = 0;
    int16_t imm12 = 0;
    int32_t imm20 = 0;

    switch(opcode){
        //Tipo U
        case LUI:
        case AUIPC:
            return (int32_t) ri >> 12;

        //Tipo I (Exceção dos shifts)
        case JALR:
        case ILType:
        case ILAType:
            return (int32_t) ri >> 20;

        //Tipo B
        case BType:
            temp_imm = ri >> 7;

            imm12 = set_bit(imm12, 11, temp_imm);

            imm12 = set_bit(imm12, 0, 0);

            imm12 = set_bit(imm12, 1, temp_imm >> 1);
            imm12 = set_bit(imm12, 2, temp_imm >> 2);
            imm12 = set_bit(imm12, 3, temp_imm >> 3);
            imm12 = set_bit(imm12, 4, temp_imm >> 4);
            
            temp_imm = temp_imm >> 18;

            imm12 = set_bit(imm12, 5, temp_imm >> 0);
            imm12 = set_bit(imm12, 6, temp_imm >> 1);
            imm12 = set_bit(imm12, 7, temp_imm >> 2);
            imm12 = set_bit(imm12, 8, temp_imm >> 3);
            imm12 = set_bit(imm12, 9, temp_imm >> 4);
            imm12 = set_bit(imm12, 10, temp_imm >> 5);

            imm12 = set_bit(imm12, 12, temp_imm >> 6);
            imm12 = set_bit(imm12, 13, temp_imm >> 6);
            imm12 = set_bit(imm12, 14, temp_imm >> 6);
            imm12 = set_bit(imm12, 15, temp_imm >> 6);
            
            return imm12;

        //Tipo J
        case JAL:
            temp_imm = ri >> 12;
            imm20 = temp_imm;

            imm20 = set_bit(imm20, 0, 0);

            imm20 = set_bit(imm20, 12, temp_imm >> 0);
            imm20 = set_bit(imm20, 13, temp_imm >> 1);
            imm20 = set_bit(imm20, 14, temp_imm >> 2);
            imm20 = set_bit(imm20, 15, temp_imm >> 3);
            imm20 = set_bit(imm20, 16, temp_imm >> 4);
            imm20 = set_bit(imm20, 17, temp_imm >> 5);
            imm20 = set_bit(imm20, 18, temp_imm >> 6);
            imm20 = set_bit(imm20, 19, temp_imm >> 7);

            imm20 = set_bit(imm20, 11, temp_imm >> 8);

            imm20 = set_bit(imm20, 1, temp_imm >> 9);
            imm20 = set_bit(imm20, 2, temp_imm >> 10);
            imm20 = set_bit(imm20, 3, temp_imm >> 11);
            imm20 = set_bit(imm20, 4, temp_imm >> 12);
            imm20 = set_bit(imm20, 5, temp_imm >> 13);
            imm20 = set_bit(imm20, 6, temp_imm >> 14);
            imm20 = set_bit(imm20, 7, temp_imm >> 15);
            imm20 = set_bit(imm20, 8, temp_imm >> 16);
            imm20 = set_bit(imm20, 9, temp_imm >> 17);
            imm20 = set_bit(imm20, 10, temp_imm >> 18);
            imm20 = set_bit(imm20, 20, temp_imm >> 19);
            imm20 = set_bit(imm20, 21, temp_imm >> 19);
            imm20 = set_bit(imm20, 22, temp_imm >> 19);
            imm20 = set_bit(imm20, 23, temp_imm >> 19);
            imm20 = set_bit(imm20, 24, temp_imm >> 19);
            imm20 = set_bit(imm20, 25, temp_imm >> 19);
            imm20 = set_bit(imm20, 26, temp_imm >> 19);
            imm20 = set_bit(imm20, 27, temp_imm >> 19);
            imm20 = set_bit(imm20, 28, temp_imm >> 19);
            imm20 = set_bit(imm20, 29, temp_imm >> 19);
            imm20 = set_bit(imm20, 30, temp_imm >> 19);
            imm20 = set_bit(imm20, 31, temp_imm >> 19);
            return imm20;

        //Tipo S
        case StoreType:
            temp_imm = ri >> 7;

            imm12 = set_bit(imm12, 0, temp_imm >> 0);
            imm12 = set_bit(imm12, 1, temp_imm >> 1);
            imm12 = set_bit(imm12, 2, temp_imm >> 2);
            imm12 = set_bit(imm12, 3, temp_imm >> 3);
            imm12 = set_bit(imm12, 4, temp_imm >> 4);

            temp_imm = ri >> 25;

            imm12 = set_bit(imm12, 5, temp_imm >> 0);
            imm12 = set_bit(imm12, 6, temp_imm >> 1);
            imm12 = set_bit(imm12, 7, temp_imm >> 2);
            imm12 = set_bit(imm12, 8, temp_imm >> 3);
            imm12 = set_bit(imm12, 9, temp_imm >> 4);
            imm12 = set_bit(imm12, 10, temp_imm >> 5);
            imm12 = set_bit(imm12, 11, temp_imm >> 6);
            imm12 = set_bit(imm12, 12, temp_imm >> 6);
            imm12 = set_bit(imm12, 13, temp_imm >> 6);
            imm12 = set_bit(imm12, 14, temp_imm >> 6);
            imm12 = set_bit(imm12, 15, temp_imm >> 6);

            return imm12;     
    }
    return 0;
}

void execute(){
    switch(opcode){
        case AUIPC:
            breg[rd] = (pc - 4) + (imm << 12);
            break;

        case LUI:
            breg[rd] = imm << 12;
            break;

        case JAL:
            breg[rd] = (pc - 4) + 4;
            pc += imm - 4;
            break;
        
        case JALR: ;
            uint32_t temp_pc = (pc - 4) + 4;
            pc = (breg[rs1] + imm) & ~1;
            breg[rd] = temp_pc;
            break;

        // Tipo R
        case RegType:
            switch(funct3){
                case ADDSUB3:
                    switch(funct7){
                        case ADD7:
                            breg[rd] = breg[rs1] + breg[rs2];
                            break;

                        case SUB7:
                            breg[rd] = breg[rs1] - breg[rs2];
                            break;
                    }
                break;

                case AND3:
                    breg[rd] = breg[rs1] & breg[rs2];
                    break;
                
                case OR3:
                    breg[rd] = breg[rs1] | breg[rs2];
                    break;

                case SLTU3:
                    breg[rd] = ((uint32_t) breg[rs1]) < ((uint32_t) breg[rs2]);
                    break;

                case SLT3:
                    breg[rd] = breg[rs1] < breg[rs2];
                    break;

                case XOR3:
                    breg[rd] = breg[rs1] ^ breg[rs2];
                    break;
                
            }
        break;

        // Tipo I Aritmetica
        case ILAType:
            switch(funct3){
                case ADDI3:
                    breg[rd] = breg[rs1] + imm;
                    break;

                case ANDI3:
                    breg[rd] = breg[rs1] & imm;
                    break;

                case ORI3:
                    breg[rd] = breg[rs1] | imm;
                    break;

                case SLLI3:
                    breg[rd] = breg[rs1] << shamt;
                    break;

                case SR3:
                    switch(funct7){
                        case SRAI7:
                            breg[rd] = breg[rs1] >> shamt;
                            break;

                        case SRLI7:
                            breg[rd] = (uint32_t) breg[rs1] >> shamt;
                            break;
                    }
                    break;

            }
            break;

        // Tipo B
        case BType:
            switch(funct3){
                case BEQ3:
                    if (breg[rs1] == breg[rs2]){
                        pc += imm - 4;
                    }
                    break;

                case BNE3:
                    if (breg[rs1] != breg[rs2]){
                            pc += imm - 4;
                        }
                    break;

                case BGE3:
                    if (breg[rs1] >= breg[rs2]){
                            pc += imm - 4;
                        }
                    break;

                case BGEU3:
                    if ( ((uint32_t) breg[rs1]) >= ((uint32_t) breg[rs2]) ){
                            pc += imm - 4;
                        }
                    break;

                case BLT3:
                    if (breg[rs1] < breg[rs2]){
                        pc += imm - 4;
                    }
                    break;

                case BLTU3:
                    if ( ((uint32_t) breg[rs1]) < ((uint32_t) breg[rs2]) ){
                            pc += imm - 4;
                        }
                    break;
            }

            break;
        
        // Tipo I com leitura
        case ILType:
            switch(funct3){
                case LB3:
                    breg[rd] = lb(breg[rs1], imm);
                    break;

                case LBU3:
                    breg[rd] = lbu(breg[rs1], imm);
                    break;

                case LW3:
                    breg[rd] = lw(breg[rs1], imm);
                    break;
            }
            break;

        // Tipo S
        case StoreType:
            switch(funct3){
                case SB3:
                    sb(breg[rs1], imm, breg[rs2] & 0xFF);
                    break;

                case SW3:
                    sw(breg[rs1], imm, breg[rs2]);
                    break;
            }
            break;


        // Syscall
        case ECALL:
            switch(breg[A7]){
                case PRINTINT:
                    printf("%d", breg[A0]);
                    break;

                case PRINTSTRING: ;
                    char * string = (char *) mem;
                    printf("%s", &string[breg[A0]]);
                    break;

                case EXIT:
                    end_of_program = 1;
                    break;
            }
        
    }
    breg[0] = 0;
}