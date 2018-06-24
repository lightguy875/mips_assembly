.data
m1:	.word 1 1 7 11 
m2:	.word 1 3 42 0
m3:	.word 0 0 0 0
tam:	.word 4
tam2:	.word 4
TAB:	.asciiz "\t"
NL:	.asciiz "\n"
.text
Inicializacao_dados:
	la	$t0,m1		#incializa t0 com o endereço da matri1
	la	$t1,m2		#incializa t1 com o endereço da matriz 2
	la	$t2,m3		#inicializa t2 com o endereco da matriz m3
	la	$s0,tam2	#colocar em s0 pois é preservado após o call
	li	$a0,0		#incializa contador
	lw	$s1,0($s0)	#coloca o tamanho do vetor2 em s1
	jal	Soma_vetor
	jal	pr_vet

Soma_vetor:
	addi	$sp, $sp,-8	#Prepara o endereço da pilha para receber dois elementos
	sw	$ra,4($sp)	#empilha endereço de retorno
	sw	$a0,0($sp)	#empilha soma da posicao do vetor
	slt	$t3,$a0,$s1	#se $a0 (i) < $s0 (tam2) então t3 <- 1, se não 0.
	bne	$t3,$zero,L1	#se t3 != 0, então pular pra L1
	add	$v0,$zero,$zero	#valor de retorno é zero (ultimo loop)
	addi	$sp,$sp,8	#remove 2 posiçoes da pilha
	jr	$ra		#retorna para finalizar o programa

L1:
	addi	$a0,$a0,1	#argumento passa a ser n+1 (inc na posicao do vetor)
	jal	Soma_vetor
	lw	$a0,0($sp)	#restaura o valor do contador
	lw	$ra,4($sp)	#restaura o valor da soma do vetor
	addi	$sp,$sp,8	#retira 2 itens da pilha
	lw	$t5,0($t2)
	lw	$t6,0($t0)	#salva a palavra em t6 correspondente a esse endereco
	lw	$t7,0($t1)	#salva a palavra em t6 correspondente a esse endereco
	add	$t5,$t6,$t7	# realiza a soma m3[i][j] = m1[i][j] + m2[i][j]
	sw	$t5,0($t2)	# salva o resultado na posicao em questao da matriz 3
	addi	$t0,$t0,4	#incrementa o ponteiro para a proxima posicao
	addi	$t1,$t1,4	#incrementa o ponteiro para a proxima posicao
	addi	$t2,$t2,4	#incrementa o ponteiro para a proxima posicao
	jr	$ra

pr_vet: 
	la 	$t1,m3		# endereço o vetor
	li	$t2,1		#inicializa contador
	la	$t3,tam		#endereça o end de tam linha
	lw	$t4,0($t3) 	#salva em t4 o valor de t3
	li	$t5,0		#inicializa t5, que vai decidir quantas linhas a matriz tem
	add	$t5,$t5,$t4	#Coloca em t4 o valor de t5
	div	$t5,$t5,2	#divide o tam do vetor por 2 para ter o tam da matriz
	jal	imprime
	li	$v0,10
	syscall
			
imprime:
	lw 	$t0,0($t1)		#salva em t0 o primeiro valor do vetor
	li 	$v0,1			#coloca o argumento necessario para imprimir um inteiro
	move 	$a0,$t0			#move $t0 para $a0
	syscall
	li 	$v0,4			#coloca o argumento necessario para imprimir uma string
	la	$a0,TAB			#move o conteudo do label TAB para $a0 ==> '\t'
	syscall
	addi	$sp,$sp,-4		#abre um espaço na pilha
	beq	$t2,$t5,pula_linha	#faz a comparacao pra chamar outra subrotina		
	addi	$sp,$sp,4
	addi	$t1,$t1,4		# incrementa a posiçao do vetor
	addi 	$t2,$t2,1		# incrementa o contador
	ble 	$t2,$t4,imprime		# compara o tamanho ao contador com o tamanho da coluna da matriz
	jr	$ra
	
pula_linha:
	li 	$v0,4			#coloca o argumento necessario para imprimir uma string
	la	$a0,NL			#move o conteudo do label NL para $a0 ==> '\n'
	syscall
	addi	$sp,$sp,4
	addi	$t1,$t1,4		# incrementa a posiçao do vetor
	addi 	$t2,$t2,1		# incrementa o contador
	bne 	$t4,$t2,imprime		# compara o tamanho ao contador
	jr	$ra