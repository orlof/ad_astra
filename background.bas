'INCLUDE "ext/lib_color.bas"
'INCLUDE "ext/lib_types.bas"
'INCLUDE "ext/lib_memory.bas"
'INCLUDE "ext/lib_char.bas"
'INCLUDE "ext/lib_scr.bas"
'INCLUDE "ext/lib_hires.bas"

CONST NUM_BACKGROUND_STARS = 24
DIM last_star AS BYTE
    last_star = NUM_BACKGROUND_STARS - 1

DIM x(NUM_BACKGROUND_STARS) AS BYTE
DIM y(NUM_BACKGROUND_STARS) AS BYTE
DIM addr_y_hi(NUM_BACKGROUND_STARS) AS BYTE
DIM addr_y_lo(NUM_BACKGROUND_STARS) AS BYTE
DIM addr_x(NUM_BACKGROUND_STARS) AS BYTE

FOR ZP_B0 = 0 TO NUM_BACKGROUND_STARS-1
    x(ZP_B0) = RNDB()
    y(ZP_B0) = RNDB()
    addr_y_hi(ZP_B0) = hires_y_tbl_hi(255)
    addr_y_lo(ZP_B0) = hires_y_tbl_lo(255)
    addr_x(ZP_B0) = 0
NEXT ZP_B0

SUB BackgroundUpdate(PlayerX AS BYTE, PlayerY AS BYTE) SHARED STATIC
    ASM
        ldx {last_star}                     ;init loop 23 to 0
        stx {ZP_B0}                 ;loop counter
loop:
        lda {addr_y_lo},x                ;clear old location
        sta {ZP_W0}
        lda {addr_y_hi},x
        sta {ZP_W0}+1
        ldy {addr_x},x
        lda #0
        sta ({ZP_W0}),y

        clc                         ;y = player.y + star.y
        lda {y},x
        adc {PlayerY}
        tay

        lda {hires_y_tbl_lo},y      ;addr by y
        sta {ZP_W0}
        lda {hires_y_tbl_hi},y
        sta {ZP_W0}+1

        clc                         ;x = player.x + star.x
        lda {x},x
        adc {PlayerX}
        sta {ZP_B1}

        and #%11111000
        sta {addr_x},x              ;addr offset by x
        tay

        lda {ZP_B1}
        and #%00000111
        tax

        lda {hires_mask1},x
        sta ({ZP_W0}),y

        ldx {ZP_B0}

        lda {ZP_W0}
        sta {addr_y_lo},x
        lda {ZP_W0}+1
        sta {addr_y_hi},x

        dex
        stx {ZP_B0}
        bpl loop
    END ASM
END SUB
