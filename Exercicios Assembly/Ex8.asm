######################## Cabeçalho da resposta - não alterar ###################
.data 
str:	.space 32
nl:	    .word 10

.text
	li a7, 8
	la a0, str
	li a1, 30
	ecall
	
	lw  a1, nl
	jal limpa
	
	li a7, 4
	la a0, str
	ecall
	
	li a7, 10
	ecall
	
######################## Escreva a função limpa a seguir #######################	
limpa:
	mv t0, a0 
	li t1, 10
loop:	
	lb t2, 0(t0)
	beq t2, t1, fim 
	
	addi t0, t0, 1
	j loop

fim:
	sb zero, 0(t0)
	ret
	
	
	