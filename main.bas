GOTO START

ORIGIN $1000
INCBIN "out_Tubular_Bells_revisited.sid"

ORIGIN $2000
START:
INCLUDE "ext/lib_types.bas"
INCLUDE "ext/lib_color.bas"

INCLUDE "ext/lib_memory.bas"
INCLUDE "ext/lib_random.bas"

INCLUDE "ext/lib_hex.bas"
INCLUDE "ext/lib_joy.bas"

INCLUDE "ext/lib_char.bas"
INCLUDE "ext/lib_scr.bas"
INCLUDE "ext/lib_mc.bas"
INCLUDE "ext/lib_hires.bas"

INCLUDE "ext/lib_irq.bas"
INCLUDE "ext/lib_sid.bas"
INCLUDE "ext/lib_spr.bas"
INCLUDE "ext/lib_spr_shape.bas"
INCLUDE "ext/lib_spr_geom.bas"

INCLUDE "title.bas"

DIM impulse_dx(32) AS BYTE
DIM impulse_dy(32) AS BYTE
FOR ZP_B0 = 7 TO 255 STEP 8
    ZP_B1 = SHR(ZP_B0, 3)
    impulse_dx(ZP_B1) = RotX(ZP_B0) - 11
    impulse_dy(ZP_B1) = RotY(ZP_B0) - 10
NEXT ZP_B0

RANDOMIZE TI()

CALL TitleShow(@TITLE_IMAGE)

'DIM Text AS ScreenText
'CALL Text.Init()
'CALL Text.Clear()
'CALL Text.Activate()

DIM Hires AS ScreenHires
CALL Hires.Init(3, 1, 0)
CALL Hires.Clear(COLOR_BLACK, COLOR_WHITE)
Hires.ScreenColor = COLOR_BLACK
Hires.BorderColor = COLOR_BLACK
CALL Hires.Activate()

CALL SprGeomPrepare(@GeomShip2)
CALL SprInit(8, 3)
'CALL SprInit(8, 0)

CALL SprClearFrame(16)
CALL SprClearFrame(17)

SprFrame(0) = 16
SprColor(0) = COLOR_WHITE
CALL SprGeomInit()
CALL SprEnable(0, TRUE)
CALL SprXY(0, 116, 90)
CALL SprGeomRequestSpriteUpdate(0, @GeomShip2, 96)
CALL SprGeomProcessRequests(1)
CALL SprUpdate(TRUE)

INCLUDE "background.bas"

TYPE PlayerData
    x AS LONG
    y AS LONG
    Direction AS BYTE
    dx AS BYTE
    dy AS BYTE
    AccelerationTime AS BYTE
    CanAccelerate AS BYTE
END TYPE

DIM Player AS PlayerData
    Player.x = 0
    Player.y = 0
    Player.Direction = 0
    Player.dx = 10
    Player.dy = 0
    Player.CanAccelerate = TRUE

DIM GameTime AS BYTE FAST
    GameTime = 0

DO WHILE TRUE
    RegBorderColor = COLOR_MIDDLEGRAY
    IF Player.AccelerationTime = GameTime THEN
        Player.CanAccelerate = TRUE
    END IF

    CALL joy1.Update()
    IF Player.CanAccelerate THEN
        IF Joy1.North() THEN
            ZP_B0 = SHR(Player.direction, 3)
            ZP_B1 = Player.dx + impulse_dx(ZP_B0)
            IF ZP_B1 < 123 OR ZP_B1 > 132 THEN
                Player.dx = ZP_B1
            END IF
            ZP_B1 = Player.dy + impulse_dy(ZP_B0)
            IF ZP_B1 < 123 OR ZP_B1 > 132 THEN
                Player.dy = ZP_B1
            END IF
            Player.CanAccelerate = FALSE
            Player.AccelerationTime = GameTime + 8
        END IF
        IF Joy1.South() THEN
            IF Player.dx <> 0 THEN
                IF Player.dx < 128 THEN 
                    Player.dx = Player.dx - 1
                ELSE
                    Player.dx = Player.dx + 1
                END IF
            END IF
            IF Player.dy <> 0 THEN
                IF Player.dy < 128 THEN 
                    Player.dy = Player.dy - 1
                ELSE
                    Player.dy = Player.dy + 1
                END IF
            END IF
            Player.CanAccelerate = FALSE
            Player.AccelerationTime = GameTime + 8
        END IF
    END IF

    Player.Direction = Player.Direction - Joy1.XAxis()
    ASM
        ldx #$00
        lda {Player}+7
        bpl dx_positive
        dex
dx_positive:
        clc
        adc {Player}+0
        sta {Player}+0

        txa
        adc {Player}+1
        sta {Player}+1

        txa
        adc {Player}+2
        sta {Player}+2

        ldx #$00
        lda {Player}+8
        bpl dy_positive
        dex
dy_positive:
        clc
        adc {Player}+3
        sta {Player}+3

        txa
        adc {Player}+4
        sta {Player}+4

        txa
        adc {Player}+5
        sta {Player}+5
    END ASM

    RegBorderColor = COLOR_PURPLE
    CALL SprGeomRequestSpriteUpdate(0, @GeomShip2, Player.Direction)

    RegBorderColor = COLOR_YELLOW
    CALL SprGeomProcessRequests(1)
    
    RegBorderColor = COLOR_BLUE
    CALL BackgroundUpdate(PEEK(@Player.x + 1), PEEK(@Player.y + 1))

    RegBorderColor = 0
    CALL SprUpdate(TRUE)

    GameTime = GameTime + 1
LOOP

GeomShip2:
DATA AS BYTE 6, 7
DATA AS BYTE 10, 7
DATA AS BYTE 0, 5
DATA AS BYTE 22, 7
DATA AS BYTE 26, 7
DATA AS WORD $0004
DATA AS BYTE 22, 7
DATA AS BYTE 10, 7
DATA AS WORD $0002

TITLE_IMAGE:
incbin "title.bin"
END