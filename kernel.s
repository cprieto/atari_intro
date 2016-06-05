	processor 6502
	include "vcs.h"
	include "macro.h"

	SEG.U vars    ; Variable section, BIATCHES!
	ORG $80 
	Variable ds 1 ; My first variable, Pedro I will call it

	SEG
	ORG $F000

Reset ; this is $F000

; Now let's reset the cpu!
	ldx #0 ; x = 0
	txs    ; sp = 0, because sp = x
	pha    ; 
Clear
	pha
	dex
	bne Clear

; This is where we initialize stuff
	
	lda #$45
	sta COLUPF     ; playfield color

	lda #%00000001 ; reflect playfield
	sta CTRLPF

StartOfFrame ; this is $F009
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
	ldx #0
DoVBlank
	inx
	sta WSYNC
	cpx #37
	bne DoVBlank

; 192 scanlines of picture
	ldx #0         ; Line counter

	lda #%11111111 ; Top wall
	sta PF0
	sta PF1
	sta PF2

Top8Lines
	sta WSYNC
	inx
	cpx #8
	bne Top8Lines

	lda #%00010000
	sta PF0
	lda #0
	sta PF1
	sta PF2

MiddleLines
	sta WSYNC
	inx
	cpx #184
	bne MiddleLines

	lda #%11111111
	sta PF0
	sta PF1
	sta PF2

Bottom8Lines
	sta WSYNC
	inx
	cpx #192
	bne Bottom8Lines

	lda #%01000010
	sta VBLANK ; end of screen

; 30 scanlines of overscan
	ldx #0
DoOverscan
	inx
	sta WSYNC
	cpx #$1E ; 30 in hex
	bne DoOverscan

	jmp StartOfFrame ; jump to beginning, $f000

	; Interrupt section
	ORG $FFFA

	.word Reset ; NMI
	.word Reset ; RESET
	.word Reset ; IRQ

END
