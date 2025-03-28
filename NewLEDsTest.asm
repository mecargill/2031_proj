; An empty ASM program ...

ORG 0
LOAD AllOff
OUT NewLEDs
Call wait1sec

LOAD AllMed
OUT NewLEDs
call wait1sec

LOAD AllOn
OUT NewLEDs
call wait1sec

LOAD LeftMed
OUT NewLEDs
call wait1sec

Jump 0

wait1sec:
	out timer
	wait:
		IN Timer
		ADDI -10
		JNEG wait
	return
	
; IO address constants
Switches:  EQU 000
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
NewLEDs:   EQU &H020
AllOn:  dw &B1111111111111111
AllMed: dw &B0000101111111111
AllOff: dw &B0000001111111111
LeftMed: dw &B0000101111100000
