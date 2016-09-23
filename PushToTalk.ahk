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
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#persistent

Menu, Tray, NoStandard
Menu, Tray, Add, M&ute Mic,ExitSub
Menu, Tray, ToggleEnable, M&ute Mic
Menu, Tray, Add
Menu, Tray, Add, E&xit, ExitSub
Menu, Tray, Icon, imageres.dll, 233, 1
Menu, Tray, Tip, Mic Muted

OnExit, ExitSub
SoundSet, 1, , MUTE, myMic
Return

$Capslock:: ;Change this for the button you want to use
	;THIS IS WHAT IT DOES WHEN YOU PUSH BUTTON
    SoundSet, 0, , MUTE, myMic
    SoundBeep, 300
    Menu, Tray, Icon, imageres.dll, 228, 1
	Menu, Tray, Tip, Mic Active
	
	;THIS IS WHAT IT DOES WHEN YOU RELEASE BUTTON
    KeyWait, Capslock   ;MAKE SURE IF YOU CHANGE THE KEYBINDING BUTTON TO CHANGE THIS
    SoundSet, 1, , MUTE, myMic
    SoundBeep, 200
	Menu, Tray, Icon, imageres.dll, 233, 1
	Menu, Tray, Tip, Mic Muted
    Return

ExitSub:
    SoundSet, 0, , MUTE, myMic
    ExitApp



