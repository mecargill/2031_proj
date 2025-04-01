;test of peripheral
start:

load alloff
out newleds
call wait1sec

load all1
out newleds
call wait1sec

load all3
out newleds
call wait1sec

load alt8
out newleds
call wait1sec

load all15
out newleds
call wait1sec

load lsqfull
out newleds
call wait4sec

load rsqdim
out newleds
call wait4sec

jump start


wait4sec:
	out timer
	wait4:
		IN Timer
		ADDI -40
		JNEG wait4
	return
	
wait1sec:
	out timer
	wait1:
		IN Timer
		ADDI -10
		JNEG wait1
	return
	
; IO address constants
Switches:  EQU 000
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
NewLEDs:   EQU &H020

;commands to send
alloff:  dw &B0000001111111111
all1:    dw &B0000011111111111
all3:    dw &B0000111111111111
alt8:    dw &B0010001010101010
all15:   dw &B0011111111111111
lsqfull: dw &B0111111111100000
rsqdim:  dw &B0100010000011111

