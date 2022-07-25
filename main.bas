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

INCLUDE "ext/lib_irq.bas"
INCLUDE "ext/lib_sid.bas"
INCLUDE "ext/lib_spr.bas"
INCLUDE "ext/lib_spr_shape.bas"
'INCLUDE "ext/lib_spr_geom.bas"

INCLUDE "title.bas"

RANDOMIZE TI()

CALL TitleShow(@TITLE_IMAGE)

DIM Text AS TextScreen
CALL Text.Init()
CALL Text.Clear()
CALL Text.Activate()

END

TITLE_IMAGE:
incbin "title.bin"
