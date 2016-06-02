	processor 6502
	include "vcs.h"
	include "macro.h"

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
	ldx #0
Picture
	inx
	stx COLUBK
	sta WSYNC
	cpx #$C0 ; 192 in hex
	bne DoScanlines

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
