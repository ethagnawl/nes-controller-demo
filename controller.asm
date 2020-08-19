.include "constants.inc"

.segment "HEADER"
.byte "NES"
.byte $1a
.byte $02 ; 2 * 16KB PRG ROM
.byte $01 ; 1 * 8KB CHR ROM
.byte %00000000 ; mapper and mirroring
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00, $00, $00, $00, $00 ; filler bytes
.segment "ZEROPAGE" ; LSB 0 - FF
background_counter: .res 2
.segment "STARTUP"
Reset:
    SEI ; Disables all interrupts
    CLD ; disable decimal mode

    ; Disable sound IRQ
    LDX #$40
    STX $4017

    ; Initialize the stack register
    LDX #$FF
    TXS

    INX ; #$FF + 1 => #$00

    ; Zero out the PPU registers
    STX PPUCTRL
    STX PPUMASK

    STX $4010

:
    BIT PPUSTATUS
    BPL :-

    TXA

CLEARMEM:
    STA $0000, X ; $0000 => $00FF
    STA $0100, X ; $0100 => $01FF
    STA $0300, X
    STA $0400, X
    STA $0500, X
    STA $0600, X
    STA $0700, X
    LDA #$FF
    STA $0200, X ; $0200 => $02FF
    LDA #$00
    INX
    BNE CLEARMEM
; wait for vblank
:
    BIT PPUSTATUS
    BPL :-

    LDA #$02
    STA OAMDMA
    NOP

    ; $3F00
    LDA #$3F
    STA PPUADDR
    LDA #$00
    STA PPUADDR

    LDX #$00

LoadPalettes:
    LDA PaletteData, X
    STA PPUDATA ; $3F00, $3F01, $3F02 => $3F1F
    INX
    CPX #$20
    BNE LoadPalettes

    ; Initialize background_counter to point to world data
    LDA #<BackgroundData
    STA background_counter
    LDA #>BackgroundData
    STA background_counter+1

    ; setup address in PPU for nametable data
    BIT PPUSTATUS
    LDA #$20
    STA PPUADDR
    LDA #$00
    STA PPUADDR

    LDX #$00
    LDY #$00
LoadBackground:
    LDA (background_counter), Y
    STA $2007
    INY
    CPX #$03
    BNE :+
    CPY #$C0
    BEQ DoneLoadingBackground
:
    CPY #$00
    BNE LoadBackground
    INX
    INC background_counter+1
    JMP LoadBackground

DoneLoadingBackground:
    LDX #$00

SetAttributes:
    LDA #$55
    STA PPUDATA
    INX
    CPX #$40
    BNE SetAttributes

    LDX #$00
    LDY #$00

LoadSprites:
    LDA SpriteData, X
    STA $0200, X
    INX
    CPX #$28
    BNE LoadSprites

; Enable interrupts
    CLI

    LDA #%10010000 ; enable NMI change background to use second chr set of tiles ($1000)
    STA PPUCTRL
    ; Enabling sprites and background for left-most 8 pixels
    ; Enable sprites and background
    LDA #%00011110
    STA PPUMASK

Loop:
    JMP Loop

NMI:
  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA

  ;; reset button palettes
  LDA #$00
  STA B_BUTTON
  STA A_BUTTON
  STA UP_BUTTON
  STA DOWN_BUTTON
  STA LEFT_BUTTON
  STA RIGHT_BUTTON
  STA SELECT_BUTTON
  STA START_BUTTON

  LDA #%10000000
  STA DOWN_BUTTON

  LDA #%01000000
  STA RIGHT_BUTTON

LatchController:
  LDA #$01
  STA CONTROLLER_A
  LDA #$00
  STA CONTROLLER_A

ReadB:
  LDA CONTROLLER_A
  AND #CONTROLLER_MASK
  BEQ ReadBDone

  LDA #$01
  STA B_BUTTON
ReadBDone:

ReadA:
  LDA CONTROLLER_A
  AND #CONTROLLER_MASK
  BEQ ReadADone

  LDA #$01
  STA A_BUTTON
ReadADone:

ReadSelect:
  LDA CONTROLLER_A
  AND #CONTROLLER_MASK
  BEQ ReadSelectDone

  LDA #$01
  STA SELECT_BUTTON
ReadSelectDone:

ReadStart:
  LDA CONTROLLER_A
  AND #CONTROLLER_MASK
  BEQ ReadStartDone

  LDA #$01
  STA START_BUTTON
ReadStartDone:

ReadUp:
  LDA CONTROLLER_A
  AND #CONTROLLER_MASK
  BEQ ReadUpDone

  LDA #$01
  STA UP_BUTTON
ReadUpDone:

ReadDown:
  LDA CONTROLLER_A
  AND #CONTROLLER_MASK
  BEQ ReadDownDone

  LDA #%10000001
  STA DOWN_BUTTON
ReadDownDone:

ReadLeft:
  LDA CONTROLLER_A
  AND #CONTROLLER_MASK
  BEQ ReadLeftDone

  LDA #$01
  STA LEFT_BUTTON
ReadLeftDone:

ReadRight:
  LDA CONTROLLER_A
  AND #CONTROLLER_MASK
  BEQ ReadRightDone

  LDA #%01000001
  STA RIGHT_BUTTON
ReadRightDone:
  RTI

PaletteData:
  .byte $0f,$00,$10,$30, $0f,$00,$10,$30, $0f,$00,$10,$30, $0f,$00,$10,$30
  .byte $0f,$00,$10,$30, $0f,$0a,$05,$0a, $0f,$0a,$0a,$0a, $0f,$0a,$0a,$0a

BackgroundData:
  .incbin "controller.nam"

SpriteData:
  .byte $45, $16, $00, $74 ;; b button
  .byte $45, $16, $00, $84 ;; a button

  .byte $35, $0e, $00, $28        ;; up
  .byte $46, $0e, %10000000, $28  ;; down
  .byte $3e, $14, $00, $1e        ;; left
  .byte $3e, $14, %01000000, $32  ;; right

  .byte $45, $18, $00, $49  ;; select
  .byte $45, $18, $00, $59  ;; start

.segment "VECTORS"
    .word NMI
    .word Reset
    ;
.segment "CHARS"
    .incbin "controller.chr"
