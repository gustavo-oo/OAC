#Programa que soma os N numeros digitados, sendo q o primeiro numero N indica a quantidade
.text
	#Le a quantidade de inteiros a serem lidos
	li a7, 5
	ecall
	
	#Move o valor lido para o registrador a1
	mv a1, a0
	
	#Zera o registrador a2 -> vai armazenar a soma
	li a2, 0
loop:	
	#Condição para sair do loop a1 == 0
	beqz a1, fim
	
	#Le um numero
	ecall
	
	#Soma o numero
	add a2, a2, a0
	
	#Subtrai 1 de a1
	addi a1, a1, -1
	
	#Volta pro inicio do loop
	j loop
fim:
	#Move a soma para o registrador a0 -> registrador usada na função de print
	mv a0, a2
	
	#Print
	li a7, 1
	ecall
	#Exit
	li a7, 10
	ecall