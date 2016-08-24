	.global main
	.text

main:

	mov	$2444032104475519272, %rax	# number A
	mov	$5073466108144884417, %rdx	# number B

	mov	%rax, %r8			# variable U
	mov	%rdx, %r9			# variable V
	mov	$0, %cl				# variable C
	mov	$0, %r11			# variable T

	or	%rax, %rdx			# logical OR
	
L1:
	shr	$1, %rdx			# shift LSB to CF
	jc	E1				# CF = 1 -> end loop
	shr	$1, %r8				# u = u / 2
	shr	$1, %r9				# v = v / 2
	add	$1, %cl				# c = c + 1
	jmp	L1				# jump back to L1


E1:
	mov	%r8, %rax			# put U back to RAX
	mov	%r9, %rdx			# put V back to RCX

L2:	
	shr	$1, %rdx			# isEven(v)
	jnc	L2				# CF = 1 -> end loop
	shl	$1, %rdx			# v = v * 2
	add	$1, %rdx			# v = v + 1


L3:	
	cmp	$0, %r8				# U != 0
	je	E2				# if U = 0 end loop

	L4:			
		shr	$1, %r8			# isEven(u)
		jnc	L4			# CF = 0 -> jump back to L4
		shl	$1, %r8			# u = u * 2
		add	$1, %r8			# u = u + 1

	cmp	%r9, %r8			# if (v > u) set CF=1
	cmovc	%r8, %r11			# CF = 1 -> t = u
	cmovc	%r9, %r8			# CF = 1 -> u = v
	cmovc	%r11, %r9			# CF = 1 -> v = t

	sub	%r9, %r8			# u = u - v
	jmp 	L3

E2:	
	shl	%cl, %r9			# v = 2^c * v
	mov	%r9, %rax			# move V to RAX for printf





###########  PRINTF  #############

	push	%rbx
	mov		$format, %rdi
	mov	 	%rax, %rsi
	xor		%rax, %rax
	call	printf
	pop		%rbx

ret

format:
	.asciz	"%lu\n"
