org 0

;call commands here
load step1
out leds
call wait10sec

load step2
out leds
call wait10sec

load step3
out leds
call wait10sec

load gradient1
out leds
load gradient2
out leds
load gradient3
out leds
load gradient4
out leds
load gradient5
out leds
load gradient6
out leds
load gradient7
out leds
load gradient9
out leds
load gradient11
out leds
load gradient15
out leds
call wait10sec

load reset
out leds
load flashMedium
out leds
call wait10sec

load flashHalfHigh
out leds
call wait10sec

load flashHalfLow
out leds
call wait10sec

load sin1
out leds
call wait10sec

load sin2
out leds
call wait10sec

load sin3
out leds
call wait10sec

fadeLoop:

load fade1
out leds
call wait2sec

load fade2
out leds
call wait2sec

load fade3
out leds
call wait2sec

;increment counter
load counter
addi 1
store counter

;after 5th loop through (6 seconds each), move on
load counter
addi -5
jneg fadeLoop

;just start over when finished so we’re not executing random stuff
jump 0

wait10sec:
	out timer
	jump10:
		in timer
		addi -100
		jneg jump10
	return

wait2sec: 
	out timer
	jump2:
		in timer
		addi -20
		jneg jump2
	return

leds equ  &H020
timer equ &H002

; step function
step1: DW &B0011111111111111 ; step to 15 (full) brightness all LEDs
step2: DW &B0010001111111111 ; step to 8 (half) brightness all LEDs
step3: DW &B0011110000011111 ; step to 15 (full) brightness for right 5 LEDs

; GRADIENT
; num indicates brightness
gradient1: DW  &B0000011000000000
gradient2: DW  &B0000100100000000
gradient3: DW  &B0000110010000000
gradient4: DW  &B0001000001000000
gradient5: DW  &B0001010000100000
gradient6: DW  &B0001100000010000
gradient7: DW  &B0001110000001000
gradient9: DW  &B0010010000000100
gradient11: DW &B0010110000000010
gradient15: DW &B0011110000000001


; FLASHING FUNCTION
reset: DW &B0011111111111111 ; Reset all LEDs to target brightness 15
flashMedium: DW   &B0101111111111111 ; flash at brightness 7
flashHalfHigh: DW &B0111111111100000 ; flash at brightness 15
flashHalfLow: DW  &B0100010000011111 ; flash at brightness 1



; SINE OSCILLATION
; Take half of flashing LEDs and set to sine oscillation animation 
; Proves two animations work together simultaneously
sin1: DW &b1011110000011111 ; oscillate right five LEDs between 0 and 15 brightness
; Set other half back to sine oscillation at a diff brightness
sin2: DW &b1001111111100000 ;  oscillate left five LEDs between 0 and 7 brightness
; Set all LEDs to sine oscill at same brightness
sin3: DW &b1001001111111111 ; oscillate all LEDs between 0 and 15 brightness

; FADE FUNCTION:
; Set half LEDs to fade animation at a certain high brightness
FADE1: DW &b1111111111100000 ; (linearly go to full brightness left five LEDs)
; Set other half LEDs to a fade animation at a certain lower brightness
FADE2: DW &b1101000000011111 ; (linearly go to ¼ brightness right five LEDs)
; Set ALL leds to same brightness and fade animation
FADE3: DW &b1110001111111111 ; (linearly go to ½  brightness all LEDs)

;this is a counter for the fade loop
counter: dw 0

