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


#SingleInstance, force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#persistent

#include VA.ahk

soundDevice := VA_GetDevice( "capture:" . 1 )

Menu, Tray, NoStandard
Menu, Tray, Add, M&ute Mic,ExitSub
Menu, Tray, ToggleEnable, M&ute Mic
Menu, Tray, Add
Menu, Tray, Add, E&xit, ExitSub
Menu, Tray, Icon, imageres.dll, 233, 1
Menu, Tray, Tip, Mic Live





changeMute()
	{
		soundDevice := VA_GetDevice( "capture:" . 1 )
		MuteState :=VA_GetMute(1,soundDevice)
		if MuteState=1
		{
  		SoundBeep, 200
    	Menu, Tray, Icon, imageres.dll, 230, 1   
		Menu, Tray, Tip, Mic Muted																	
		}
		else 
		{
		SoundBeep, 300
		Menu, Tray, Icon, imageres.dll, 233, 1
		Menu, Tray, Tip, Mic Live
		}
	}


$`::
 	soundDevice := VA_GetDevice( "capture:" . 1 )
 	MuteState :=VA_GetMute(1,soundDevice)
	 	if MuteState=1
	 	{
	 		VA_SetMute(FALSE,1,soundDevice)
	 	}
	 	else 
	 	{
	 		VA_SetMute(TRUE,1,soundDevice)
	 	}
	changeMute()
	Return



$Capslock:: ;Change this for the button you want to use
	;THIS IS WHAT IT DOES WHEN YOU PUSH BUTTON 228z
    ;SoundSet, 1, MASTER, MUTE, myMic
    ;
	soundDevice := global soundDevice
	VA_SetMute(TRUE,1,soundDevice)
	changeMute()
	
	;THIS IS WHAT IT DOES WHEN YOU RELEASE BUTTON
    KeyWait, Capslock  ;MAKE SURE IF YOU CHANGE THE KEYBINDING BUTTON TO CHANGE THIS
    ;SoundSet, 0, MASTER, MUTE, myMic
    ;
    VA_SetMute(FALSE,1,soundDevice)
	changeMute()
    Return

ExitSub:
    ;SoundSet, 0, , MUTE, myMic
	;changeMute()
    ExitApp



