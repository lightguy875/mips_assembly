.data
Q1:	.asciiz	"Qual o tamanho do vetor? "
Q2:	.asciiz "Qual dado deve ser inserido? "
v1:	.word	0 0 0 0
v2:	.word	0 0 0
tam:	.word 	0
tam2:	.word   0
TAB:	.asciiz "\t"
.text
Pede_dados:
	#Etapa de preenchimento do vetor 1
	la	$s2,v1		#inicializo $s2 com um ponteiro para v1
	li	$t0,0		#inicializo contador com 0
	li	$v0,4		#prepara para printar na tela do MARS
	la	$a0,Q1		#recebe endereco de Q1
	syscall
	li	$v0,5		#prepara para receber um inteiro correspondente ao tam do vetor
	syscall
	la	$s0,tam		#carrega o endereço do label tam
	sw	$v0,0($s0)	#escreve o tamanho em $s0
	move	$s3,$v0		#move o conteudo de v0 para s3
	li	$v0,4		#prepara para printar na tela do MARS
	la	$a0,Q2		#recebe endereco de Q2
	syscall
	j	Preenche_vetor1	#pula para a rotina que preenche o vetor1
	
Pede_dados2:
	#Etapa de preenchimento do vetor 2
	la	$s2,v2		#inicializo $s2 com um ponteiro para v2
	li	$t0,0		#inicializo contador com 0
	li	$v0,4		#prepara para printar na tela do MARS
	la	$a0,Q1		#recebe endereco de Q1
	syscall
	li	$v0,5		#prepara para receber um inteiro correspondente ao tam do vetor
	syscall
	la	$s0,tam2	#carrega o endereço do label tam
	sw	$v0,0($s0)	#escreve o tamanho em $s0
	move	$s3,$v0		#move o conteudo de v0 para s3
	li	$v0,4		#prepara para printar na tela do MARS
	la	$a0,Q2		#recebe endereco de Q2
	syscall
	j	Preenche_vetor2
	
Preenche_vetor1:
	li	$v0,5		#prepara para receber um inteiro correspondente ao tam do vetor
	syscall
	sw	$v0,0($s2)	#salva na primeira posiçao de s2, ou seja, primeira posicao de v1
	addi	$s2,$s2,4	#incrementa o ponteiro
	addi	$t0,$t0,1
	bne	$s3,$t0,Preenche_vetor1	#chama a funcao pra posicao seguinte
	j	Pede_dados2

Preenche_vetor2:
	li	$v0,5		#prepara para receber um inteiro correspondente ao tam do vetor
	syscall
	sw	$v0,0($s2)	#salva na primeira posiçao de s2, ou seja, primeira posicao de v2
	addi	$s2,$s2,4	#incrementa o ponteiro
	addi	$t0,$t0,1
	bne	$s3,$t0,Preenche_vetor2	#chama a funcao pra posicao seguinte

Inicializacao_dados:
	la	$t0,v1		#incializa a0 com o endereço do vetor1
	la	$t1,v2		#incializa a1 com o endereço do vetor2
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
