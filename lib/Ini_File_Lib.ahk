iniSecToMap(iniFile,iniSec)
{
    SecContents:=IniRead(iniFile,iniSec)
    ArrSecContents:=StrSplit(SecContents,"`n","`r")
    KeyValueMap:=Map()
    loop ArrSecContents.Length
    {
        ThisPair:=ArrSecContents[A_Index]
        EqualPos:=InStr(ThisPair,"=")
        ThisKey:=Trim(SubStr(ThisPair,1,EqualPos-1))
        ThisValue:=Trim(SubStr(ThisPair,EqualPos+1))
        KeyValueMap[ThisKey]:=ThisValue
        ; MsgBox ThisKey
    }
    return KeyValueMap
}