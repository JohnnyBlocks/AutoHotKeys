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
Menu, Tray, Add, Toggle VLC Controls, ToggleControls
Menu, Tray, Add, E&xit, ExitSub
Menu, Tray, Icon, imageres.dll, 143, 1
Menu, Tray, Tip, CTRL+H Toggles VLC Controls

VLC_exe := "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe"

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

null:
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
        WinActivate, ahk_id %VLC_ahk_id%
        Send ^h
        Menu, Tray, Icon, imageres.dll, 143, 1
        Menu, Tray, UnCheck,VLC Borders Hidden
      } 
    Return
    
ToggleControls:
    WinActivate, ahk_id %VLC_ahk_id%
    Send ^h
    Return    
    
ExitSub:
    WinSet, Style,  +0xC40000 , ahk_id %VLC_ahk_id%
    ExitApp



