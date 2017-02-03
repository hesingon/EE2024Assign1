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
	PUSH	{R2-R5}
	//R0:en,R1:st,R2:sn,R3:enOld,R4:un
	LDR R2, =sn
	LDR R3, =enOld
	//if (start) sn = enOld = 0.0;
	CMP R1, #0
	ITT NE
	LDRNE [R2], #0
	LDRNE [R3], #0
	//sn=sn+en
	ADD R2, R2, R0
	//if (sn>9.5) sn=9.5; else if (sn<-9.5) sn=-9.5;
	CMP R2, #950
	IT GT
	LDRGT R2, #950
	CMP R2, #-950
	LDRLT R2, #-950
	//un = Kp*en + Ki*sn + Kd*(en-enOld);
	MUL R6, R0, Kp
	MUL R7, R2, Ki
	SUB R8, R2, R3
	MUL R8, R8, Kd
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
