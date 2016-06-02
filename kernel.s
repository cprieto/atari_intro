	processor 6502
	include "vcs.h"
	include "macro.h"

	SEG
	ORG $F000

Reset ; this is $F000

; Now let's reset the cpu!
	lda #0
	ldx #0
Clear
	sta $80,x
	sta $0,x
	inx
	cpx #$80
	bne Clear

StartOfFrame ; this is $F000
; start of vertical blank processing
	lda #0
	sta VBLANK
	lda #2
	sta VSYNC
; 3 scanlines of VSYNC signal
	REPEAT 3
		sta WSYNC
	REPEND
	lda #0
	sta VSYNC

; 37 vertical blank
	REPEAT 37
		sta WSYNC
	REPEND

; 192 scanlines of picture
	ldx #0
	REPEAT 192
		inx
		stx COLUBK
		sta WSYNC
	REPEND

	lda #%01000010
	sta VBLANK ; end of screen

; 30 scanlines of overscan
	REPEAT 30
		sta WSYNC
	REPEND

	jmp StartOfFrame ; jump to beginning, $f000

	; Interrupt section
	ORG $FFFA

	.word Reset ; NMI
	.word Reset ; RESET
	.word Reset ; IRQ

END
