 	.syntax unified
 	.cpu cortex-m3
 	.thumb
 	.align 2
 	.global	pid_ctrl
 	.thumb_func
@  EE2024 Assignment 1: pid_ctrl(int en, int st) assembly language function
@  CK Tham, ECE, NUS, 2017
pid_ctrl:
@ PUSH the registers you modify, e.g. R2, R3, R4 and R5*, to the stack
@ * this is just an example; the actual registers you use may be different
@ (this will be explained in lectures)
	PUSH	{R2-R12}

	//R0:en,R1:st,R2:sn,R3:enOld,R4:un
	LDR R2, =sn
	LDR R3, =enOld
	LDR R9, ZERO

	//if (start) sn = enOld = 0.0;
	CMP R1, 0
	ITT NE
	STRNE R9, [R2]
    STRNE R9, [R3]


	LDR R5, [R2] //R5 contains the value of sn
	LDR R6, [R3] //R12 contains the value of enOld

	//sn=sn+en
	ADD R5, R5, R0

	//if (sn>9.5) sn=9.5; else if (sn<-9.5) sn=-9.5;
	LDR R10, topLimit
	CMP R5, R10
	IT GT
	MOVGT R5, R10

	LDR R10, bottomLimit
	CMP R5, R10
	IT LT
	MOVLT R5, R10

	//storing updated value back to R2
	STR R5, [R2]

	//un = Kp*en + Ki*sn + Kd*(en-enOld);
	LDR R9, Kp
	MUL R12, R9, R0  //R12 = Kp*en

	LDR R9, Ki
	MUL R7, R9, R5		//R7 = Ki*sn

	SUB R8, R0, R6		//R8 = en - enOld

	LDR R9, Kd
	MUL R8, R9, R8		//R8 = Kd*(en-enOld)

	ADD R4, R12, R7
	ADD R4, R4, R8		//R4 = Kp*en + Ki*sn + Kd*(en-enOld);

	//enOld = en;
	STR R0, [R3]	//storing current en value to enOld's memory space

	//return(un);
	MOV R3, R0
	MOV R0, R4


@  Write PID controller function in assembly language here
@  Currently, nothing is done and this function returns straightaway

@ POP the registers you modify, e.g. R2, R3, R4 and R5*, from the stack
@ * this is just an example; the actual registers you use may be different
@ (this will be explained in lectures)
	POP	{R2-R12}
 	BX	LR

 Kp:
 	.word 25
 Ki:
 	.word 10
 Kd:
 	.word 80
topLimit:
 	.word 950
bottomLimit:
	.word -950
ZERO:
	.word 0
 @ Store result in SRAM (4 bytes)
 	.lcomm enOld 4
 	.lcomm sn 4
 	.lcomm un 4
	.end
