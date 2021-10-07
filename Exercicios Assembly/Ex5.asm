############################# Cabeçalho da Resposta ############################
.data

rsp:  .space 30
size: .word 30

.text
	#Le uma string de 30 caracteres
	la a0, rsp
	la t0, size
	lw a1, 0(t0)
	li a7, 8
	ecall
	
	la t0, rsp
	li t3, 97
	li t4, 122
	
loop:	
	#Le uma letra do array
	lb t1, 0(t0)
	#Se for 0 -> fim da string
	beqz t1, fim
	
	#Se for uma letra menor que 'a'
	blt t1, t3, proxima
	#Se for uma letra maior que 'z'
	bgt t1, t4, proxima
	
letra_minuscula:	
	#Subtrair 32 deixa a letra maiuscula
	addi t1, t1, -32
	sb t1, 0(t0)
	
proxima:	
	#Soma 1 no indice do array
	addi t0, t0, 1
	j loop
	
fim:
	#print string
	li a7, 4
	ecall

	li a7, 10
	ecall