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

; This is where we initialize stuff
PATTERN      = $80  ; Using memory!
TIMETOCHANGE = 20   
COLOR        = $1E  ; Color is ugly yellow! 

	lda #0
	sta PATTERN  ; the binary PF pattern
	lda COLOR    ; Set the color
	sta COLUPF   ; playfield color
	ldy #0       ; speed counter

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


; Handle a change in the pattern every 20 frames
; and write the pattern to PF1
	iny
	cpy #TIMETOCHANGE
	bne NotYet
	ldy #0
	inc PATTERN

NotYet
	lda PATTERN
	sta PF1

; 192 scanlines of picture
	ldx #0
Picture
	inx
	stx COLUBK
	sta WSYNC
	cpx #$C0 ; 192 in hex


	bne Picture

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
