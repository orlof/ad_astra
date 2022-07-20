INCLUDE "ext/lib_hex.bas"
INCLUDE "ext/lib_sid.bas"
INCLUDE "ext/lib_joy.bas"

INCLUDE "ext/lib_color.bas"
INCLUDE "ext/lib_memory.bas"
INCLUDE "ext/lib_char.bas"
INCLUDE "ext/lib_mc.bas"

DIM Image AS TypeMCBitmap
Image.BorderColor = COLOR_BLACK
Image.ScreenColor = COLOR_BLACK
CALL Image.Init(3, 1, 0)
CALL Image.Import(@TITLE_IMAGE, @TITLE_IMAGE + 8000, @TITLE_IMAGE + 9000)
CALL Image.Centre(11, "Press Fire", COLOR_YELLOW, COLOR_BLACK, 1)
CALL Image.Activate()

DIM sid AS SidInfo
CALL sid.Import(@SID_START, @SID_END)
CALL sid.play(0)

CALL Joy1.WaitClick()

CALL sid.Stop()

END

TITLE_IMAGE:
incbin "title.bin"

SID_START:
incbin "Tubular_Bells_revisited.sid"
SID_END:
END
