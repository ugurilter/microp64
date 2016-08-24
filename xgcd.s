# Author: 		Ahmet Ugur Ilter - 13070006026
# Subject:		Extended Euclidean GCD Algorithm in AMD64 Assembly
# Date:			12.03.16

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# README:                                                                                                  	#
# Given as + bt = gcd(a,b);                                                                                 	#
#                                                                                                          	#
# Once the program terminates                                                                              	#
#   + The GCD of (a,b) tuple is in %rax,                                                                    	#
#   + The coefficient of a, which is s in this case, is in %r8,                                            	#
#   + The coefficient of b, which is t in this case, is in %r10.                                            	#
#                                                                                                           	#
#	 Simply change "mov  %r14, %rax" (last line), write related register instead of %r14 to get it's value. #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


	.section .data
mystring:
	.asciz "GCD(a,b) is: %d\n"

	.section .text
main:
	.globl main
	push %rbx
	push %r12
	push %r13
	push %r14
	push %r15

	#########################################################################
	xor %rax, %rax								#
	mov $6583228714790865438, %r14						# variable a
	mov $82359677546373573, %r15						# variable b
										#
	mov $0, %r8								# variable S
	mov $1, %r9								# variable s
	mov $1, %r10								# variable T
	mov $0, %r11								# variable t
	mov $0, %r12								# variable q
	mov $0, %r13								# variable z
										#
										#
b_notzero:									#
	cmp  $0, %r15								# b == 0 ?
	je   endloop								# if b = 0 terminate loop, else continue
										#
	mov  %r14, %rax								# rdx:rax is now 0:a
	CQO									# sign extension of %rax to %rdx:%rax
	idiv %r15								# signed integer division ( a / b ) ; remainder is in %rdx, quotient is in %rax now
	mov  %rax, %r12								# set q := a div b
										#
	mov  %r14, %r13								# z := a
	mov  %r15, %r14								# a := b
	imul %r12, %r15								# q * b
	sub  %r13, %r15								# b := z - (q * b)
	neg  %r15								#
										#
	mov  %r8, %r13								# z := S	
	imul %r12, %r8								# q * S
	sub  %r9, %r8								# S := s - (q * S)
	neg  %r8								#
										#
	mov  %r13, %r9								# s := z
	mov  %r10, %r13								# z := T
	imul %r12, %r10								# q * T
	sub  %r11, %r10								# T := t - (q * T)
	neg  %r10								#
										#
	mov  %r13, %r11								# t := z
										#
	jmp b_notzero								# jump back to b_notzero
										#
endloop:									#
	mov  %r14, %rax								# move result to %rax for printing
	#########################################################################
	
	pop %r15
	pop %r14
	pop %r13
	pop %r12
	pop %rbx

	// Whatever is left in %rax will be printed on the screen now.
	// Do not alter the below code.

	finish:
		movq $mystring, %rdi 						# set 1st parameter (format)
		movq %rax, %rsi							# set 2nd parameter (current_number)
		xorq %rax, %rax							# the number of the syscall has to be passed in register %rax.
		call printf							# printf(format, current_number)
	ret
