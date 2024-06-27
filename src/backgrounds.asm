.include "constants.inc"

.segment "CODE"

.export draw_background
.proc draw_background
    ;/////WRITE NAMETABLES
    ;just putting ABC on the screen for now.
    ;X stores high byte of nametable
    ;Y stores low byte of nametable
    LDX $20
    LDY $2a

    LDA PPUSTATUS
    STX PPUADDR ;write to PPU $202A
    STY PPUADDR
    LDA #$01     ;A
    STA PPUDATA

    LDA PPUSTATUS
    INY
    STX PPUADDR  ;write to $202B
    STY PPUADDR
    LDA #$02     ;B
    STA PPUDATA

    LDA PPUSTATUS
    INY
    STX PPUADDR   ;write to $202C
    STY PPUADDR     
    LDA #$03     ;C
    STA PPUDATA

    ;/////WRITE ATTRIBUTE TABLES
    ;let's just make the C a different color
    LDA PPUSTATUS
    LDA #$2C 
    STA PPUADDR
    LDA #$3C
    STA PPUADDR
    LDA #%00000011
    STA PPUDATA
    
    RTS
.endproc