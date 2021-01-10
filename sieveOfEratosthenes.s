;Faruk Orak 150180058

LIMIT	EQU		120;
	
				AREA mydata, data, readwrite
				ALIGN
primeNumbers	SPACE	(LIMIT+1) << 2
primeNumbers_end
					
				AREA mydata1, data, readwrite
				ALIGN
isPrimeNumbers	SPACE	(LIMIT+1) << 2
isPrimeNumbers_end
	
		AREA firstcode, code, readonly;
		ENTRY
		ALIGN
__main	FUNCTION
		EXPORT __main
		
		LDR	r5, =primeNumbers		;take the primeNumbers array's initial address
		LDR	r6, =isPrimeNumbers		;take the isPrimeNumbers array's initial address
		LDR r0, =LIMIT				;tahe the limit value
		BL	SieveOfEratosthenes		;call the function
stop	B	stop					;branch stop
		ALIGN
		ENDFUNC
		
SieveOfEratosthenes FUNCTION
					MOVS r1, #0		;i value of the loop1
LOOP1				CMP	r1, r0		;if i > limit
					BEQ	LOOP1END	;then exit loop
					MOVS r2, #0		;load 0 to r2 to store data
					PUSH{r1}		;push r1 to stack 
					LSLS r1, #2		;i*4
					STR r2, [r5,r1]	;primeNumbers[i] = 0
					MOVS r2, #1		;load 1 to r2 to store data
					STR r2, [r6,r1]	;isPrimeNumber[i] = true
					POP{r1}			;pop back to r1
					ADDS r1, #1		;i++
					B	LOOP1		;go loop1
LOOP1END			MOVS r1, #2		;i value of the loop2
LOOP2				MOVS r2, r1		;take the i value to r2
					MOVS r3, r1		;take the i value to r3
					MULS r3, r2, r3	;r3 keeps i*i
					CMP	r3, r0		;if i*i > limit
					BGT LOOP2END	;then go LOOP2END
					PUSH{r1}		;push r1 to stack
					LSLS r1, #2		;i*4
					LDR r2, [r6,r1] ;take isPrimeNumber[i] to r2
					POP{r1}			;pop back to r1
					CMP r2, #1      ;look for if condition
					BNE LABEL1		;if it is not equal go LABEL1
					
					MOVS r7, #0		;r7 is used for i 2i 3i iteration it is x value
LOOP2IN				PUSH{r7}		;push r7 value to stack
					MULS r7, r1, r7 ;calculate i*x
					ADDS r4,r3,r7	;i*i + i*x
					POP{r7}			;pop r7 back
					CMP	r4, r0		;if j > limit
					BGT LABEL1		;then go LABEL1
					MOVS r2,#0      ;load 0 to r2
					PUSH{r4}		;push r4 to stack
					LSLS r4, #2		;r4*4
					STR	r2, [r6,r4] ;isPrimeNumber[j] = false
					POP{r4}			;pop back to r4
					ADDS r7, #1		;x++
					B LOOP2IN		;go LOOP2IN
LABEL1				ADDS r1, #1		;i++
					B	LOOP2		;go LOOP2
					
LOOP2END			MOVS r1, #0		;r1 is index
					MOVS r2, #2     ;r2 is i
LOOP3				CMP	r2,r0		;if i > limit
					BGT	LOOP3END	;then go LOOP3END	
					PUSH{r2}		;push r2 to stack
					LSLS r2, #2		;r2*4
					LDR r3, [r6,r2] ;take isPrimeNumber[i] to r3
					POP{r2}			;pop back to t2
					CMP r3, #1		;if isPrimeNumber[i] is not true
					BNE LABEL2		;go LABEL2
					PUSH{r1}		;push r1 to stack
					LSLS r1, #2		;r1*4
					STR	r2, [r5,r1] ;primeNumbers[index] = i
					POP{r1}			;pop back to r1
					ADDS r1, #1		;index++
LABEL2				ADDS r2, #1		;i++
					B	LOOP3		;go LOOP3
LOOP3END			BX LR			;branch with link register
					ALIGN
					ENDFUNC
		END