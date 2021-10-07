.text
	#Le o int
	li a7, 5
	ecall
	
	mv a1, a0
	
	#Le o int
	li a7, 5
	ecall
	
	mv a2, a0
	
	#Le o int
	li a7, 5
	ecall
	
	mul a0, a2, a0
	add a0, a0, a1
	
	#Print resultado
	li a7, 1
	ecall
	
	li a7, 10
	ecall