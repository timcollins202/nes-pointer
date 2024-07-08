;/////INCLUDES
.include "constants.inc"
.include "header.inc"

;/////ZEROPAGE VARIABLES
.segment "ZEROPAGE"
pointer_x:          .res 1
pointer_y:          .res 1
ppuctrl_settings:   .res 1
pad1:               .res 1
.exportzp pointer_x, pointer_y, pad1

.segment "CODE"

;/////IMPORTS
.import read_controller1    ;controllers.asm
.import reset_handler       ;reset.asm
.import draw_background     ;backgrounds.asm

;/////VECTOR HANDLERS
.proc irq_handler
    RTI             ;intentionally doing nothing here
.endproc

.proc nmi_handler
;     LDA #$00        ;update sprite data
;     STA OAMADDR
;     LDA #$02
;     STA OAMDMA
;     LDA #$00

; ;read controller
;     JSR read_controller1

;update pointer position and draw tiles
   ; JSR update_pointer  ;TODO
    ;JSR draw_pointer    ;TODO

    RTI
.endproc

.export main
.proc main
    ;write a palette
    LDX PPUSTATUS
    LDX #$3f            ;palettes start at $3f00
    STX PPUADDR
    LDX #$00
    STX PPUADDR
load_palettes:
    LDA palettes, X
    STA PPUDATA
    INX
    CPX #$20
    BNE load_palettes

    JSR draw_background

vblankwait:                 ; wait for another vblank before continuing
    BIT PPUSTATUS
    BPL vblankwait

    LDA #%10010000          ; turn on NMIs, sprites use first pattern table
    STA ppuctrl_settings
    STA PPUCTRL
    LDA #%00011110          ; turn on screen
    STA PPUMASK

forever:
  JMP forever

.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

;TODO: add RODATA segment and palette data
.segment "RODATA"
palettes:
    .byte $0f, $00, $10, $30        ;background palettes
    .byte $0f, $0c, $21, $32
    .byte $0f, $05, $16, $27
    .byte $0f, $0b, $1a, $29

    .byte $0f, $00, $10, $30        ;sprite palettes
    .byte $0f, $0c, $21, $32        ;for now these mirror background palettes
    .byte $0f, $05, $16, $27        ;but this will change
    .byte $0f, $0b, $1a, $29

.segment "CHR"
.incbin "pointer.chr"