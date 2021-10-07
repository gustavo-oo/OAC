################# Cabeçalho da Resposta - Não altere ###########################
.data
# segmento de dados
ehpar: 	 .string "Eh par"
ehimpar: .string "Eh impar"

#segmento de codigo
.text
	#Le um numero para verificar se e par ou impar
	li a7, 5
	ecall
	
	#Faz um AND com o número 1, se for par o resultado é 0, se for impar o resultado e 1
	andi a0, a0, 1
	
	beqz a0, par
impar:
	#Copia o endereco de ehimpar pra a0
	la a0, ehimpar
	j fim
par:
	#Copia o endereco de ehpar pra a0
	la a0, ehpar
	
fim:
	#Printa o valor que esta no endereço contido em a0
	li a7, 4
	ecall
	#Exit
	li a7, 10
	ecall