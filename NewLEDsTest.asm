; An empty ASM program ...

ORG 0
	LOAD Test
	OUT NewLEDs
	OUT Timer
wait:
	
	IN Timer
	ADDI -50
	JNEG wait
LOAD Test2
OUT NewLEDs
Out Timer
wait2:
	
	IN Timer
	ADDI -50
	JNEG wait2
jump 0
	

	
; IO address constants
Switches:  EQU 000
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
NewLEDs:   EQU &H020
Test:  dw &B1111111111100000
Test2: dw &B1111111111100001
