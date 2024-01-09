#Requires AutoHotkey >=2.0
#SingleInstance Force  ; replaces the old instance automatically
#Include .\lib\Mouse_GetCaretPos.ahk
#Include .\lib\PasteFileContentTo.ahk
#Include .\lib\Double_Press_Hotkey.ahk
#Include .\lib\TC_AHK_Lib.ahk
#Include .\lib\Ini_File_Lib.ahk

global TC_Dir,LanguageDir
TC_Dir:=IniRead("setting.ini","config","TC_Dir") 
LanguageDir:=iniSecToMap("setting.ini","LanguageDir")

global WinExe       := TC_Dir . "TotalCMD64.exe"
global WinCMD_ini   := TC_Dir . "WinCMD.ini"
global user_cmd_ini := TC_Dir . "usercmd.ini"
global TC_Class     := "ahk_class TTOTAL_CMD"

F1::
{
    CurWinTitle:=WinGetTitle("A")
    CurWinPrcs:=WinGetProcessName("A")
    CurWinID:=WinGetID("A")
    if(InStr(CurWinPrcs,"code.exe")) ; visual studio code
        FileType:=VSC_CurFileType()
    hwnd := GetCaretPosEx(&x, &y, &w, &h)
    
    tc_hwnd := WinExist(TC_Class)
    if(!tc_hwnd)
    {
        Run WinExe,,"Hide"
        WinWait(TC_Class,,5)
    }
    SendMessage( 1075, 4001, 0, , TC_Class)   ; cm_FocusLeft=4001;Focus on left file list 
    SendMessage( 1075, 207, 0, , TC_Class)    ; cm_RightHideQuickView=207;Right: Quick view panel off
    SendMessage( 1075, 204, 0, , TC_Class)    ; cm_RightQuickView=204;Right: Quick view panel
    try
        ThisLangDir:=LanguageDir[FileType]
    catch as e
        ThisLangDir:=LanguageDir["DefaultDir"]        
    TC_SetLeftPath(ThisLangDir)

    TC_Minimum_Mode(WinCMD_ini)
    WinMove(x,y+20,800,400,TC_Class)
    WinActivate(TC_Class)
    WinWaitActive(TC_Class,,5)
    ; Sleep(100) 
   
    /* wait for Enter in TC or TC lose focus */
    ;TC_SendEnterOrDeactivate
    
    IniWrite(1,"setting.ini","config","SelectionMode")
    SetTimer TC_SendEnterOrDeactivate, 250
    TC_SendEnterOrDeactivate()  
    {
        KeyWait "Enter", "T5"
        if(!WinActive(TC_Class))
        {
            IniWrite(0,"setting.ini","config","SelectionMode")
            SetTimer , 0
        }
    }
}
; F11::Reload   ; for debug
#HotIf WinActive(TC_Class)
$Enter::
$NumpadEnter::
{
    SelectionMode:=IniRead("setting.ini","config","SelectionMode")
    if(!SelectionMode)
    {
        Send "{Enter}"
        return
    }
    TC_Sel:=TC_GetFirstSelectedFile()
    if(TC_Sel)
        PasteFileContentTo(TC_Sel) 

    TC_GetFirstSelectedFile()
    {
        SendMessage( 1075, 2018, 0, , TC_Class)  ;cm_CopyFullNamesToClip
        SelectedFiles:=StrSplit(A_Clipboard,"`n","`r")
        if(SelectedFiles.Length>=1)
            return SelectedFiles[1]
        else
            return 0
    }
}
$Esc::
{
    DoubleHotKey(ThisHotkey,FuncTodo)
}
FuncTodo()
{
    Send "{ALT DOWN}{TAB}{ALT UP}"
}
VSC_CurFileType()
{
    CurWinTitle:=WinGetTitle("A")
    FileName:=StrReplace(CurWinTitle," - Visual Studio Code","")
    LastDotPos:=LastCharPos(FileName, "\." )
    FileExt:=SubStr(FileName,LastDotPos+1)
    return FileExt

}
LastCharPos(InputStr,InChar)
{
    Pos:=RegExMatch(InputStr, InChar , &Match, 1)
    If(Pos>0)
    {
        MatchNumber:=Match.Count
        LastMatchPos:=Match.Pos[MatchNumber]
        return LastMatchPos
    }
    else
        return 0
}









