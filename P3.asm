.data
vetor1: .word 9 8 7 2 5 4 3
vetor2:	.word	
tam: .word 7

.text 
	la	$a0,vetor1		#armazena endereço do vetor
	la	$a1,vetor2
	li	$t0,0			#inicializa contador
	la	$a2,tam			#armazena endereço do tamanho
	lw	$t1,0($a2)		#coloca o tamanho do vetor em t1
	jal	copia_conteudo		#chama a funçao copia_conteudo
	li	$v0,10			
	syscall
	
copia_conteudo:
	lw	$t4,0($a0)		#salva em t4 um elemento do vetor	
	move	$a1,$t4			#copia para a1 o conteúdo de t4
	addi	$a0,$a0,4		#Anda no endereço para a prox posiçao do vetor
	addi	$a1,$a1,4		#Anda no endereço para a prox posiçao do vetor
	addi	$t0,$t0,1		#incrementa contador	
	bne	$t0,$t1,copia_conteudo	#compara o contador com o tamanho do vetor
	jr	$ra