.include "constants.inc"
.include "header.inc"

.segment "ZEROPAGE"
pointer_x:          .res 1
pointer_y:          .res 1
ppuctrl_settings:   .res 1
pad1:               .res 1
.exportzp pointer_x, pointer_y, pad1

.segment "CODE"
.proc irq_handler
    RTI
.endproc

.import read_controller1

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

.import reset_handler
.import draw_background ;TODO

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler