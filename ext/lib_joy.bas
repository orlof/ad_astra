CONST UP_MASK      = %00000001
CONST DOWN_MASK    = %00000010
CONST LEFT_MASK    = %00000100
CONST RIGHT_MASK   = %00001000
CONST FIRE_MASK    = %00010000
CONST ANY_DIR_MASK = %00001111
CONST ANY_MASK     = %00011111

TYPE Joystick
    Prev AS BYTE
    Value AS BYTE
    Addr AS WORD

    SUB Init(Addr AS WORD) STATIC
        THIS.Addr = Addr
        THIS.Prev = PEEK(THIS.Addr) AND ANY_MASK
        THIS.Value = THIS.Prev
    END SUB

    SUB Update() STATIC
        THIS.Prev = THIS.Value    
        THIS.Value = PEEK(THIS.Addr) AND ANY_MASK
    END SUB

    FUNCTION North AS BYTE() STATIC
        RETURN (THIS.Value AND UP_MASK) = 0
    END FUNCTION

    FUNCTION South AS BYTE() STATIC
        RETURN (THIS.Value AND DOWN_MASK) = 0
    END FUNCTION

    FUNCTION East AS BYTE() STATIC
        RETURN (THIS.Value AND RIGHT_MASK) = 0
    END FUNCTION

    FUNCTION West AS BYTE() STATIC
        RETURN (THIS.Value AND LEFT_MASK) = 0
    END FUNCTION

    FUNCTION Button AS BYTE() STATIC
        RETURN (THIS.Value AND FIRE_MASK) = 0
    END FUNCTION

    FUNCTION ButtonOn AS BYTE() STATIC
        RETURN ((THIS.Value XOR THIS.Prev) AND FIRE_MASK) <> 0 AND THIS.Button()
    END FUNCTION

    FUNCTION ButtonOff AS BYTE() STATIC
        RETURN ((THIS.Value XOR THIS.Prev) AND FIRE_MASK) <> 0 AND NOT THIS.Button()
    END FUNCTION

    SUB WaitClick() STATIC
        CALL THIS.Update()
        DO UNTIL THIS.ButtonOn()
            CALL THIS.Update()
        LOOP
    END SUB

    FUNCTION XAxis AS INT() STATIC
        IF THIS.West() THEN RETURN -1
        IF THIS.East() THEN RETURN 1
        RETURN 0
    END FUNCTION

    FUNCTION YAxis AS INT() STATIC
        IF THIS.North() THEN RETURN -1
        IF THIS.South() THEN RETURN 1
        RETURN 0
    END FUNCTION
END TYPE

DIM Joy1 AS Joystick SHARED
CALL Joy1.Init($dc01)

DIM Joy2 AS Joystick SHARED
CALL Joy2.Init($dc00)
