CONST STAR_ORIGIN_X = 120
CONST STAR_ORIGIN_Y = 33
CONST NUM_STARS = 8

TYPE Star
    x AS INT
    y AS INT
    dx AS INT
    dy AS INT
END TYPE
DIM StarField(NUM_STARS) AS Star

DIM Image AS TypeMCBitmap
Image.BorderColor = COLOR_BLACK
Image.ScreenColor = COLOR_BLACK

DIM sid AS SidInfo
'CALL sid.Import(@SID_START, @SID_END)
sid.Init = $1000
sid.Play = $1003

SUB TitleShow(TitleImage AS WORD) STATIC SHARED
    REM -- INIT GRAPHICS AND MUSIC
    CALL Image.Init(3, 1, 0)
    CALL Image.Import(TitleImage, TitleImage + 8000, TitleImage + 9000)
    CALL Image.Centre(11, "Press Fire", COLOR_YELLOW, COLOR_BLACK, 1)
    CALL Image.Activate()

    CALL sid.play(0)

    CALL MemoryVicBank(3)
    CALL SprInit(SPR_MODE_8)
    CALL SprShapeImport(@SPR_STAR, 16)

    REM -- INIT STARFIELD
    FOR ZP_B0 = 0 TO NUM_STARS
        StarField(ZP_B0).x = STAR_ORIGIN_X
        StarField(ZP_B0).y = STAR_ORIGIN_Y

        DO
            ZP_B1 = RNDB()
            StarField(ZP_B0).dx = CINT(SHR(ZP_B1 AND %00001111, 1)) - 3
            StarField(ZP_B0).dy = CINT(SHR(ZP_B1, 5)) - 3
        LOOP WHILE StarField(ZP_B0).dx = 0 AND StarField(ZP_B0).dy = 0
        
        CALL SprEnable(ZP_B0, TRUE)
        CALL SprXY(ZP_B0, STAR_ORIGIN_X, STAR_ORIGIN_Y)
        SprColor(ZP_B0) = COLOR_YELLOW
        SprFrame(ZP_B0) = 16
    NEXT ZP_B0
    CALL SprPriorityAll(FALSE)

    DO
        FOR ZP_B0 = 0 TO NUM_STARS
            StarField(ZP_B0).x = StarField(ZP_B0).x + StarField(ZP_B0).dx
            StarField(ZP_B0).y = StarField(ZP_B0).y + StarField(ZP_B0).dy
            IF StarField(ZP_B0).x < 0 OR StarField(ZP_B0).x > 320 OR StarField(ZP_B0).y < 0 OR StarField(ZP_B0).y > 200 THEN
                StarField(ZP_B0).x = STAR_ORIGIN_X
                StarField(ZP_B0).y = STAR_ORIGIN_Y
                DO
                    ZP_B1 = RNDB()
                    StarField(ZP_B0).dx = CINT(SHR(ZP_B1 AND %00001111, 1)) - 3
                    StarField(ZP_B0).dy = CINT(SHR(ZP_B1, 5)) - 3
                LOOP WHILE StarField(ZP_B0).dx = 0 AND StarField(ZP_B0).dy = 0
            END IF
            CALL SprXY(ZP_B0, StarField(ZP_B0).x, CBYTE(StarField(ZP_B0).y))
        NEXT ZP_B0
        CALL SprUpdate(TRUE)
        CALL WaitRasterLine256()
        CALL Joy1.Update()
    LOOP UNTIL Joy1.ButtonOn()

    REM -- RUN DOWN
    FOR ZP_B0 = 0 TO 7
        CALL SprEnable(ZP_B0, FALSE)
    NEXT
    CALL SprUpdate(TRUE)
    CALL SprStop()
    CALL Sid.Stop()
END SUB

SPR_STAR:
DATA AS BYTE %10000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
DATA AS BYTE %00000000, %00000000, %00000000
