#  Organização e Arquitetura de Computadores - Turma C
#  Aluno: Gustavo Pereira Chaves
#  Matrícula: 190014113

	.data
color: .word 0xFFFF # azul turquesa
dx: .word 64 # linha com 64 pixels
dy: .word 64 # 64 linhas
org: .word 0x10040000 # endereço da origem da imagem (heap)
msg: .asciz "Digite x0, y0, x1 e y1:\n"

	.text
la a0, msg
li a7, 4
ecall

li a7, 5

ecall #lendo x0
mv t0, a0

ecall #lendo y0
mv t1, a0

ecall #lendo x1
mv t2, a0

ecall #lendo y1
mv t3, a0

jal line

#Fim programa
li a7, 10
ecall

line: #(x0 -> t0, y0 -> t1, x1 -> t2, y1 -> t3)

	#dx = x1 - x0
	#dy = y1 = y0
	sub s0, t2, t0 #s0 -> dx
	sub s1, t3, t1 #s1 -> dy
	
	#D = 2*dy - dx
	li t5, 2
	mul s2, s1, t5 #s2 -> D
	sub s2, s2, s0
	
	#ponto(x0, y0)
	mv a1, t0
	mv a2, t1 
	jal point
	
	#y = y0
	mv s3, t1 #s3 -> y
	
	#x = x0 + 1
	addi s4, t0, 1
loop:	#to x = x1
	bgt s4, t2, end_loop
	
if:	blez s2, else

	#y = y + 1
	addi s3, s3, 1
	
	#point(x,y)
	mv a1, s4
	mv a2, s3
	jal point
	
	#D = D + 2*dy - 2*dx
	li t4, 2
	sub t5, s1, s0
	mul t5, t5, t4

	blt s0, s1, dx_maior_dy
	
	add s2, s2, t5
	j end_if

dx_maior_dy:
	sub s2, s2, t5
	j end_if

else:
	#point(x,y)
	mv a1, s4
	mv a2, s3
	jal point
	
	#D = D + 2*dy
	li t4, 2
	mul t5, t4, s1
	add s2, s2, t5
	
end_if:
	addi s4, s4, 1
	j loop
end_loop:
	mv ra, a6
	ret

#Desenha ponto no pixel (a1, a2)
point:
	mv a4, ra
	jal getaddress
	mv ra, a4
	
	la t5, color
	lw t5, 0(t5)
	
	sw t5, 0(a3)
	
	ret

#retorna o endereço correspondente ao pixel(a1, a2) em a3
getaddress:
	li t6, 4
	mul a3, t6, a1
	
	la t5, dx
	lw t5, 0(t5)
	mul t4, a2, t5
	mul t4, t4, t6
	
	add a3, a3, t4

	la t5, org
	lw t5, 0(t5)
	add a3, a3, t5
	ret


	
