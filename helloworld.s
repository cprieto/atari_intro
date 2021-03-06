;
; hello.asm
;
; A "Hello, World!" which illustrates an Atari 2600 programming
; introduction talk (slides at http://slideshare.net/chesterbr).
;
; This is free software (see license below). Build it with DASM
; (http://dasm-dillon.sourceforge.net/), by running:
;
;   dasm hello.asm -ohello.bin -f3
;

    PROCESSOR 6502
    INCLUDE "vcs.h"

    ORG $F000

Reset:
    ldx #0 ; x = 0
    txs    ; sp = 0, because sp = x
    pha    ;
Clear:
    pha
    dex
    bne Clear

StartFrame:
    lda #%00000010
    sta VSYNC
    REPEAT 3
        sta WSYNC
    REPEND
    lda #0
    sta VSYNC

SetColors:
    lda #$8E
    sta COLUBK
    lda #$40
    sta COLUPF

    ldx #0
DoVBlank:
    inx
    sta WSYNC
    cpx #37
    bne DoVBlank

    lda #0
    sta VBLANK

    ldx #0
DrawHelloWorld:
    cpx #174
    bcs ScanlineEnd
    txa
    lsr
    tay
    lda Pattern,y
    sta PF1

ScanlineEnd:
    sta WSYNC
    inx
    cpx #191
    bne DrawHelloWorld

    lda #%01000010
    sta VBLANK

    ldx #0
DoOverscan:
    sta WSYNC
    inx
    cpx #30
    bne DoOverscan

    jmp StartFrame

Pattern:
    .BYTE %00000000
    .BYTE %01000010
    .BYTE %01111110
    .BYTE %01000010
    .BYTE %01000010
    .BYTE %01000010
    .BYTE %00000000
    .BYTE %00000000
    .BYTE %01111110
    .BYTE %01000000
    .BYTE %01111100
    .BYTE %01000000
    .BYTE %01000000
    .BYTE %01111110
    .BYTE %00000000
    .BYTE %00000000
    .BYTE %01000000
    .BYTE %01000000
    .BYTE %01000000
    .BYTE %01000000
    .BYTE %01000000
    .BYTE %01111110
    .BYTE %00000000
    .BYTE %00000000 ; L
    .BYTE %01000000
    .BYTE %01000000
    .BYTE %01000000
    .BYTE %01000000
    .BYTE %01000000
    .BYTE %01111110
    .BYTE %00000000 ; O
    .BYTE %00000000
    .BYTE %00111100
    .BYTE %01000010
    .BYTE %01000010
    .BYTE %01000010
    .BYTE %01000010
    .BYTE %00111100
    .BYTE %00000000
    .BYTE %00000000 ; white space
    .BYTE %00000000
    .BYTE %00000000
    .BYTE %00000000
    .BYTE %00000000
    .BYTE %00000000
    .BYTE %00000000
    .BYTE %00000000
    .BYTE %00000000 ; W
    .BYTE %01000010
    .BYTE %01000010
    .BYTE %01000010
    .BYTE %01000010
    .BYTE %01011010
    .BYTE %00100100
    .BYTE %00000000
    .BYTE %00000000 ; O
    .BYTE %00111100
    .BYTE %01000010
    .BYTE %01000010
    .BYTE %01000010
    .BYTE %01000010
    .BYTE %00111100
    .BYTE %00000000
    .BYTE %00000000 ; R
    .BYTE %01111100
    .BYTE %01000010
    .BYTE %01000010
    .BYTE %01111100
    .BYTE %01000100
    .BYTE %01000010
    .BYTE %00000000
    .BYTE %00000000 ; L
    .BYTE %01000000
    .BYTE %01000000
    .BYTE %01000000
    .BYTE %01000000
    .BYTE %01000000
    .BYTE %01111110
    .BYTE %00000000
    .BYTE %00000000 ; D
    .BYTE %01111000
    .BYTE %01000100
    .BYTE %01000010
    .BYTE %01000010
    .BYTE %01000100
    .BYTE %01111000
    .BYTE %00000000


    ORG $FFFA

    .WORD StartFrame      ;     NMI
    .WORD StartFrame      ;     RESET
    .WORD StartFrame      ;     IRQ

    END

;
; Copyright 2011-2013 Carlos Duarte do Nascimento (Chester). All rights reserved.
;
; Redistribution and use in source and binary forms, with or without modification, are
; permitted provided that the following conditions are met:
;
;    1. Redistributions of source code must retain the above copyright notice, this list of
;       conditions and the following disclaimer.
;
;    2. Redistributions in binary form must reproduce the above copyright notice, this list
;       of conditions and the following disclaimer in the documentation and/or other materials
;       provided with the distribution.
;
; THIS SOFTWARE IS PROVIDED BY CHESTER ''AS IS'' AND ANY EXPRESS OR IMPLIED
; WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
; FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> OR
; CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
; SERVICES;  LOSS OF USE, DATA, OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
; ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
; ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;
; The views and conclusions contained in the software and documentation are those of the
; authors and should not be interpreted as representing official policies, either expressed
; or implied, of Chester.
;
