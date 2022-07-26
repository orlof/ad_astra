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
'INCLUDE "ext/lib_spr_geom.bas"

INCLUDE "title.bas"

RANDOMIZE TI()

'CALL TitleShow(@TITLE_IMAGE)

'DIM Text AS TextScreen
'CALL Text.Init()
'CALL Text.Clear()
'CALL Text.Activate()

DIM Hires AS ScreenHires
CALL Hires.Init(3, 1, 0)
CALL Hires.Clear(COLOR_BLACK, COLOR_WHITE)
Hires.ScreenColor = COLOR_BLACK
Hires.BorderColor = COLOR_BLACK
CALL Hires.Activate()

INCLUDE "background.bas"

DIM x AS BYTE
x = 100    
DIM y AS BYTE
y = 100
DO WHILE TRUE
    POKE 53280,5
    x = x + 1
    y = y + 1
    CALL BackgroundUpdate(x, y)
'    FOR ZP_B1 = 0 TO 23
'        CALL Stars(ZP_B1).Update(x, y)
'    NEXT ZP_B1
    POKE 53280,0
    CALL WaitRasterLine256()
LOOP


TITLE_IMAGE:
incbin "title.bin"
END