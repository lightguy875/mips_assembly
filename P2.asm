.data
vetor: .word 1 2 3 4 5 6 7 8 9 
tam: .word 9

.text 
	jal 	pr_vet	# chamada da função pr_vet
	li 	$v0, 10	# colocando 10 em v0 e chamando # syscall encerra o programa
	syscall

pr_vet: 
	la 	$t1,vetor	# endereço o vetor
	li	$t2,0		#inicializa contador
	la	$t3,tam		#endereça o end de tam
	lw	$t4,0($t3) 	#salva em t4 o valor '9'
	
	
imprime:
	lw 	$t0,0($t1)	#salva em t0 o valor '1', primeiro valor do vetor
	li 	$v0,1
	move 	$a0,$t0
	syscall
	addi	$t1,$t1,4		# incrementa a posiçao do vetor
	addi 	$t2,$t2,1		# incrementa o contador
	bne 	$t4,$t2,imprime		# compara o tamanho ao contador
	jal	end
end:
	li	$v0,10
	syscall 
	
