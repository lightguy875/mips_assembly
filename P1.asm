.data 

X: 		.word 33
TAB:		.asciiz "\t"
NL:		.asciiz "\n"

.text

MAIN:
	la 	$t1,X
	lw	$t0,0($t1)
		 
	li	$v0,1
	move	$a0,$t0
	syscall
	
	sll	$t0,$t0,1
	sw	$t0,0($t1)
	
	li 	$v0,4
	la	$a0,TAB
	syscall
			
	li	$v0,1
	move	$a0,$t0
	syscall
	
	li	$v0,10 			#retorna para o sistema operacional
	syscall