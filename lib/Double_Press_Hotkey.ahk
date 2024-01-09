; single or double or long press

DoubleHotKey(UserHotKey,UserFunc)
{
    Static presses := 0
    squelch := 300 ;mSec between clicks in a double click -- they used 300

    If(SubStr(UserHotKey,1,1)!="$")
    {
        MsgBox "should not send the hotkey itself"
    }
    hk := StrReplace(UserHotKey, "$")    ; Strip the dollar sign
    hk1:= SubStr(hk, 1, 1)
    hk2:= SubStr(hk, 2, 1)

    If KeyWait(hk1, 'T.5') and KeyWait(hk2, 'T.5')                ; If key was quickly released,
    {
        SetTimer(done, -squelch)
        presses++ ;  then reset timer, and increment counter

    }
    Else
    {
        MsgBox "long press"
        presses := -1
    }

    done()
    {                             ; Key presses have ended
        Switch presses
        {
            Case 1: Send Str2KeyConverter(UserHotKey)           ; Single
            Case 2: UserFunc                                  ; Double
        }

        presses := 0
    }
}
Str2KeyConverter(strInputKeyStroke)
{
    strKeyStroke:=StrReplace(strInputKeyStroke,"$","")
    strKeyStroke:=StrReplace(strKeyStroke,"!","")
    strKeyStroke:=StrReplace(strKeyStroke,"^","")
    strKeyStroke:=StrReplace(strKeyStroke,"+","")
    strKeyStroke:=StrReplace(strKeyStroke,"v","")
    if(StrLen(strKeyStroke)>1)
        return "{" . strKeyStroke . "}"
    else
        return strInputKeyStroke

}