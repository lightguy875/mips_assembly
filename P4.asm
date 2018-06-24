.data
v1:	.word 2 4 7 11 100
v2:	.word 1 3 42
tam:	.word 5
tam2:	.word 3
TAB:	.asciiz "\t"
.text
Inicializacao_dados:
	la	$t0,v1		#incializa a0 com o endereço do vetor1
	la	$t1,v2		#incializa a1 com o endereço do vetor2
	la	$s0,tam2	#colocar em s0 pois é preservado após o call
	li	$a0,0		#incializa contador
	lw	$s1,0($s0)	#coloca o tamanho do vetor2 em s1
	jal	Soma_vetor
	jal	pr_vet

Soma_vetor:
	addi	$sp, $sp,-8	#Prepara o endere�o da pilha para receber dois elementos
	sw	$ra,4($sp)	#empilha endere�o de retorno
	sw	$a0,0($sp)	#empilha soma da posicao do vetor
	slt	$t3,$a0,$s1	#se $a0 (i) < $s0 (tam2) ent�o t3 <- 1, se não 0.
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
	lw	$t6,0($t0)	#salva a palavra em t6 correspondente a esse endereco
	lw	$t7,0($t1)	#salva a palavra em t6 correspondente a esse endereco
	add	$t6,$t6,$t7	# realiza a soma v1[i] += v2[i]
	sw	$t6,0($t0)	# salva o resultado na posicao em questao de v1
	addi	$t0,$t0,4	#incrementa o ponteiro para a proxima posicao
	addi	$t1,$t1,4	#incrementa o ponteiro para a proxima posicao
	jr	$ra

pr_vet: 
	la 	$t1,v1		# endereço o vetor
	li	$t2,0		#inicializa contador
	la	$t3,tam		#endereça o end de tam
	lw	$t4,0($t3) 	#salva em t4 o valor '9'
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
	addi	$t1,$t1,4		# incrementa a posiçao do vetor
	addi 	$t2,$t2,1		# incrementa o contador
	bne 	$t4,$t2,imprime		# compara o tamanho ao contador
	jr	$ra
