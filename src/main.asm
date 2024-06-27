.include "constants.inc"
.include "header.inc"

.segment "ZEROPAGE"
pointer_x:          .res 1
pointer_y:          .res 1
ppuctrl_settings:   .res 1
pad1:               .res 1
.exportzp pointer_x, pointer_y, pad1

.segment "CODE"


.import read_controller1    ;controllers.asm
.import reset_handler       ;reset.asm
.import draw_background     ;backgrounds.asm

.proc irq_handler
    RTI
.endproc

.proc nmi_handler
    LDA #$00        ;update sprite data
    STA OAMADDR
    LDA #$02
    STA OAMDMA
    LDA #$00

;read controller
    JSR read_controller1

;update pointer position and draw tiles
    JSR update_pointer  ;TODO
    JSR draw_pointer    ;TODO

    RTI
.endproc



.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler