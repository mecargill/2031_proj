; An empty ASM program ...

ORG 0
LOAD pulse
OUT fnsel
load allOn
out newleds

here:
jump here


wait1sec:
	out timer
	wait:
		IN Timer
		ADDI -30
		JNEG wait
	return
	
; IO address constants
Switches:  EQU 000
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
NewLEDs:   EQU &H020
fnsel: EQU &H021
AllOn:  dw &B1111111111111111
AllMed: dw &B0000101111111111
AllOff: dw &B0000001111111111
LeftMed: dw &B0000101111100000
pulse: dw &B0111111111111111
