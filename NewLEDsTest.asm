; An empty ASM program ...

ORG 0
	LOAD allon
	OUT NewLEDs
	OUT Timer
wait:
	
	IN Timer
	ADDI -5
	JNEG wait
LOAD rightmed
OUT NewLEDs
Out Timer
wait2:
	
	IN Timer
	ADDI -5
	JNEG wait2
jump 0
	

	
; IO address constants
Switches:  EQU 000
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
NewLEDs:   EQU &H020
AllOn:    dw &B1111111111111111
rightMed: dw &B0000010000011111
