# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #	
#														#
# Author: 		Ahmet Ugur Ilter - 13070006026								#
# Subject:		Squareroot Algorithm in AMD64 Assembly							#																	#
# Date:			12.03.16										#																									#
#                                                                                                           	#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# README:                                                                                                   	#
#                                                                                                           	#
# Given number n, calculates the squareroot of n;                                                           	#
#                                                                                                           	#
# While converting the algorithm to assembly i changed the while loop to a do-while loop.			#				
# In order to do this, i used jrcxz instruction to make a conditional jump according to the %rcx 's value	#
# If %rcx = 1, this means we are still outside the loop therefore we need to skip x = y once			#			
# After that we are in the loop, so we need to start executing x = y every time, therefore we set %rcx = 0	#
#                                                                                                           	#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #	


	.section .data
mystring:
	.asciz "%lu\n"

	.section .text
main:
	.globl main

	movq $12389172314112312, %r12				# variable n

	movq $1, %r8						# variable x (initial value = 1)
	xorq %r9, %r9						# variable y
	xorq %r10, %r10						# temp variable
	xorq %r11, %r11						# log2n

	movq %r12, %r10						# temp := n
	shr %r10						# shift temp right

log_base2:
	shr %r10						# temp := temp / 2 (integer div by 2)
	inc %r11						# log2n := log2n + 1 (increase)
	cmp $0, %r10						# temp == 0 ?
	jne  log_base2						# if false go back to loop start, else continue

	shr %r11						# log2n / 2							
	adc $0, %r11						# if log2n is even result won't change since CF=0, if it's odd result is ceiled

	xorq %rcx, %rcx						# clear content of %rcx
	movq %r11, %rcx						# move %r11 to %rcx ; so we can use %cl for shifting %r8
	shl  %cl, %r8						# x = 2 ^ (%cl)	

	xorq %rcx, %rcx						# clear content of %rcx before entering loop ( %rcx = 0 )

loop:
	jrcxz skip						# if %rcx is  0, skip below line.
	movq %r9, %r8						# x = y

skip:
	movq $1, %rcx						# now we are in the while loop, so set %rcx to 1
	xorq %rdx, %rdx						# %rdx := 00000...
	movq %r12, %rax						# %rax := n   ;   (%rdx:%rax  =  0:n now)
	div %r8							# n / x (integer division)
	movq %r8, %r10						# move x to a temp variable since i'll need it later
	add %rax, %r10						# x + (n / x)
	shr %r10						# [x + (n / x)] / 2
	movq %r10, %r9						# y = ....

	cmp %r8, %r9						# y < x ?
	jc loop							# if true go back to loop start
	
end:
	movq %r8, %rax



finish:
	movq $mystring, %rdi 					# set 1st parameter (format)
	movq %rax, %rsi						# set 2nd parameter (current_number)
	xorq %rax, %rax						# the number of the syscall has to be passed in register %rax.
	call printf						# printf(format, current_number)
	ret
