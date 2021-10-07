#Soma dois inteiros e print
.text
	#Le um int
	li a7, 5
	ecall
	
	#Move pra a1
	mv a1, a0
	
	#Le um int
	li a7, 5
	ecall
	
	#Soma os dois
	add a0, a0, a1
	
	#Printa o resultado
	li a7, 1
	ecall
	
	#Exit
	li a7, 10
	ecall