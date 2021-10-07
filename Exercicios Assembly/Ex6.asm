.text
	#Le o int
	li a7, 5
	ecall
	
	li t1, 0 #Contador das ocorrencias do numero 1
	li t2, 32 #Contador do numero de bits percorridos do numero
loop:
	#Verifica se chegou no fim do numero
	beqz t2, fim
	
	#Verifica se o bit é 1 ou 0
	andi a1, a0, 1
	beqz a1, valor_zero
	
valor_um:
	addi t1, t1, 1 #Soma 1 ao contador
valor_zero:
	srli a0, a0, 1 #Gira o numero pra direita
	
	addi t2, t2, -1 #Subtrai 1 do contador de bits
	j loop
	
fim:	
	#print do numero de ocorrencias
	mv a0, t1
	li a7, 1
	ecall
	
	li a7, 10
	ecall