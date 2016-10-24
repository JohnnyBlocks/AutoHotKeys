; Author:		YoYo-Pete 
; Contact:		yoyo.pete (at) gmail
; 				https://github.com/YoYo-Pete
;				http://yoyo-pete.com
;
; AHK version:	v1.1.24.01 (unicode 64-bit)
; Platform:		Win10
; 
;
; Script Function:
;	Toggle Window Bar for VLC




#SingleInstance, force

#NoEnv          ;Recommended for performance and compatibility with future AutoHotkey releases.
#Warn           ;Recommended for catching common errors.
SendMode Input  ;Recommended for new scripts due to its superior speed and reliability.
#Persistent     ;keep the script running

Menu, Tray, NoStandard
Menu, Tray, Add, VLC Borders Hidden, ToggleBorders
Menu, Tray, Default , VLC Borders Hidden
Menu, Tray, Add, --Toggle VLC Controls, ToggleControls
Menu, Tray, Add, --Start VLC, StartVLC
Menu, Tray, Add, --Window Position, GetPos
Menu, Tray, Add, --Outlook List, View1
Menu, Tray, Add, --Outlook Message, View2
Menu, Tray, Add, --Chrome Inspect, View3
Menu, Tray, Add, --Reload This App, ReloadApp
Menu, Tray, Add, E&xit, ExitSub
Menu, Tray, Icon, imageres.dll, 143, 1
Menu, Tray, Tip, CTRL+H Toggles VLC Controls

VLC_exe := "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe"
DetectHiddenWindows, On ;
if !WinExist("ahk_exe %VLC_exe% ")
{
    Run, %VLC_exe%,,VLC_ahk_id
    Sleep, 2000
}
VLC_ahk_id := WinExist("ahk_exe C:\Program Files (x86)\VideoLAN\VLC\vlc.exe")
WinGet VLC_style, Style, ahk_id %VLC_ahk_id%

defaultStyle := 0x96CF0000
Gosub, ToggleBorders


OnExit, ExitSub 
Return

GetPos:
    WinActivate, ahk_id %VLC_ahk_id%
    WinGetActiveStats, Title, Width, Height, X, Y
    MsgBox, ,"VLC Position",%X%.%Y%.%Width%.%Height% 
    Return

    
StartVLC:
    Run, %VLC_exe%,,VLC_ahk_id
    Sleep, 2000
    VLC_ahk_id := WinExist("ahk_exe C:\Program Files (x86)\VideoLAN\VLC\vlc.exe")
    WinGet VLC_style, Style, ahk_id %VLC_ahk_id%
    Return    

ToggleBorders:
    WinGet VLC_style, Style, ahk_id %VLC_ahk_id%
    If (VLC_style = defaultStyle)
      {
        WinSet, Style,  -0xC40000 , ahk_id %VLC_ahk_id%
        WinActivate, ahk_id %VLC_ahk_id%
        Send ^h
        Menu, Tray, Icon, imageres.dll, 8, 1
        Menu, Tray, Check,VLC Borders Hidden
      }
    Else
      {  
        WinSet, Style,  +0xC40000 , ahk_id %VLC_ahk_id%
        Menu, Tray, Icon, imageres.dll, 143, 1
        Menu, Tray, UnCheck,VLC Borders Hidden
      } 
    Return
    
ToggleControls:
    WinActivate, ahk_id %VLC_ahk_id%
    Send ^h
    Return   
    
     
ReloadApp:
    Reload
    Return 
    
View1:
    WinMove,ahk_id %VLC_ahk_id%,,218,729,564,447
    Return

View2:
    WinMove,ahk_id %VLC_ahk_id%,,769,519,1135,628
    Return

View3:
    WinMove,ahk_id %VLC_ahk_id%,,-4,663,1031,509
    Return

ExitSub:
    WinSet, Style,  +0xC40000 , ahk_id %VLC_ahk_id%
    ExitApp



