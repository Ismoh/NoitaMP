title := A_ScriptFullPath " - AutoHotkey v" A_AhkVersion

SetTitleMatchMode, 2
SetTitleMatchMode, slow
DetectHiddenWindows, On

if WinExist("ahk_exe i)\\noita.exe$") or WinExist("ahk_exe i)\\noita_dev.exe$") ; https://www.autohotkey.com/docs/misc/WinTitle.htm#ahk_exe
{
    WinActivate ; Use the window found by WinExist.
    
    Send, {LAlt}+{F4}
    return
}
else
{

}


WinGet, id, List,,, Program Manager
Loop, %id%
{
    this_id := id%A_Index%
    WinActivate, ahk_id %this_id%
    WinGetClass, this_class, ahk_id %this_id%
    WinGetTitle, this_title, ahk_id %this_id%
    MsgBox, 4, , Visiting All Windows`n%A_Index% of %id%`nahk_id %this_id%`nahk_class %this_class%`n%this_title%`n`nContinue?
    IfMsgBox, NO, break
}