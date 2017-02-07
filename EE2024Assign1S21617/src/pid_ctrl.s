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
	PUSH	{R2-R11}
	//R0:en,R1:st,R2:sn,R3:enOld,R4:un
	LDR R2, =sn
	LDR R3, =enOld
	//if (start) sn = enOld = 0.0;
	CMP R1, #0
	ITTT NE
	//e.g. MOV R6, #0
	//e.g. STR [R2], R6
	MOVNE R9, #0
	STRNE R9, [R2]
    STRNE R9, [R3]
	//sn=sn+en
	ADD R2, R2, R0
	//if (sn>9.5) sn=9.5; else if (sn<-9.5) sn=-9.5;

	MOVW R10, #950

	CMP R2, R10
	IT GT
	LDRGT R2, R10

	ADD R10, R2, #950
	MOV R11, #0

	CMP R10, R11
	ITT LT
	LDRLT R2, #0
	SUBLT R11, #950
	//un = Kp*en + Ki*sn + Kd*(en-enOld);

	@Amended because constant operations shouldnt involve constants.

	MOV R9, Kp
	MUL R6, R0, R9

	MOV R9, Ki
	MUL R7, R2, R9

	SUB R8, R2, R3

	MOV R9, Kd
	MUL R8, R8, R9
	ADD R4, R6, R7
	ADD R4, R4, R8
	//enOld = en;
	LDR R3, R0
	//return(un);
	STR R0, R4


@  Write PID controller function in assembly language here
@  Currently, nothing is done and this function returns straightaway

@ POP the registers you modify, e.g. R2, R3, R4 and R5*, from the stack
@ * this is just an example; the actual registers you use may be different
@ (this will be explained in lectures)
	POP	{R2-R5}
 	BX	LR

 Kp:
 	.word 25
 Ki:
 	.word 10
 Kd:
 	.word 80
 @ Store result in SRM (4 bytes)
 	.lcomm enOld 4
 	.lcomm sn 4
	.end
