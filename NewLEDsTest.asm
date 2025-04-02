;test
org 0

load clr
out leds
call wait1sec

load cmd0
out leds
call wait1sec 

load cmd1
out leds
call wait1sec

load cmd2
out leds
call wait1sec

load cmd3
out leds
call wait1sec

load cmd4
out leds
call wait1sec

jump 0

load cmd5
out leds
call wait1sec

load cmd6
out leds
call wait1sec

load cmd7
out leds
call wait1sec

load cmd8
out leds
call wait1sec

load cmd9
out leds
call wait1sec

load clr
out leds
call wait1sec

load cmd10
out leds
call wait1sec

load cmd11
out leds
call wait1sec

load cmd12
out leds
call wait1sec

load cmd13
out leds
call wait1sec

load cmd14
out leds
call wait1sec

load cmd15
out leds
call wait1sec





wait1sec:
	out timer
	wait1:
		in timer
		addi -40
		jneg wait1
	return
		
;demo gamma
clr:   dw &B0000001111111111

cmd0:  dw &B0011111010101010
cmd1:  dw &B1100011111111111
cmd2:  dw &B1111111111111111
cmd3:  dw &B0100101010101010
cmd4:  dw &B1011111111111111
cmd5:  dw &B0
cmd6:  dw &B0
cmd7:  dw &B0
cmd8:  dw &B0
cmd9:  dw &B0
cmd10: dw &B0
cmd11: dw &B0
cmd12: dw &B0
cmd13: dw &B0
cmd14: dw &B0
cmd15: dw &B0
;00 is step, 01 is square, 10 is sine, 11 is lin
;demo flashing


;addresses
timer equ 002
leds equ &H020