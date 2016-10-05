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
;	System Tray Icon
;   Audible Response to Capslock push 
;   Mic Muted unless capslock is WheelDown



;This is the mic that is controled
myMic=13


#SingleInstance, force

#NoEnv          ;Recommended for performance and compatibility with future AutoHotkey releases.
#Warn           ;Recommended for catching common errors.
SendMode Input  ;Recommended for new scripts due to its superior speed and reliability.
#Persistent     ;keep the script running



Menu, Tray, NoStandard
Menu, Tray, Add, Always-On-Top,ExitSub
Menu, Tray, ToggleEnable, Always-On-Top
Menu, Tray, Add
Menu, Tray, Add, {Focus on App then CTRL+Space}, FloatToggle
Menu, Tray, ToggleEnable, {Focus on App then CTRL+Space}
Menu, Tray, Add, E&xit, ExitSub
Menu, Tray, Icon, imageres.dll, 143, 1
Menu, Tray, Tip, Focus on App then CTRL+Space

OnExit, ExitSub
Return

UpdateMenu:
    Menu, Tray, DeleteAll
    Menu, Tray, NoStandard
    Menu, Tray, Add, Always-On-Top,ExitSub
    Menu, Tray, ToggleEnable, Always-On-Top
    Menu, Tray, Add
    Menu, Tray, Add, %Title%, FloatToggle 
    Menu, Tray, Check, %Title%
    Menu, Tray, Add, E&xit, ExitSub
    Menu, Tray, Icon, imageres.dll, 8, 1
    Menu, Tray, Tip, Always-On-Top: %Title%
    Return

$^Space:: ;Change this for the button you want to use
    WinGet, winID, ID, A
    WinGetTitle, Title, ahk_id %winID% 
    Winset, Alwaysontop, On, ahk_id %winID%
    Gosub,UpdateMenu
    settimer, UpdateTitle, 300 ;
    Return
    
FloatToggle:    
    oldTitle=%Title%
    Winset, Alwaysontop, Toggle, ahk_id %winID%
    WinGetTitle, Title, ahk_id %winID%   
    Gosub,UpdateTitle
    Return


UpdateTitle:
    IfWinNotExist , ahk_id %WinID%
        Reload
    oldTitle=%Title%
    WinGet, ExStyle, ExStyle, ahk_id %winID%
    If (ExStyle & 0x8)
      {
        ExStyle = Always-On-Top
        Menu, Tray, Icon, imageres.dll, 8, 1
        Menu, Tray, Check, %Title%
      }
    Else
      {    
       ExStyle = Not-On-Top
       Menu, Tray, Icon, imageres.dll, 143, 1
       Menu, Tray, UnCheck, %Title%
      }  
    WinGetTitle, Title, ahk_id %winID%   
    if(oldTitle != Title)
        {
        if(StrLen(Title)=0)
            Title=Focus on App then CTRL+Space    
        Menu, Tray, Rename, %oldTitle%, %Title%
        }
    
    Menu, Tray, Tip, %ExStyle%: '%Title%'
    Return
    
ExitSub:
    settimer, UpdateTitle, Delete
    ExitApp



