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
;   Mutes Microphone when Capslock is held down
;   Toggles Microphone Mute when ` is pressed
;   Double Click tray icon to toggle mute as well		


#SingleInstance, force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#persistent

#include VA.ahk

soundDevice := VA_GetDevice( "capture:" . 1 )

Menu, Tray, NoStandard
Menu, Tray, Add, Microphone Mute,toggleMute
Menu, Tray, Default, Microphone Mute
Menu, Tray, Add
Menu, Tray, Add, E&xit, ExitSub
Menu, Tray, Icon, imageres.dll, 233, 1
Menu, Tray, Tip, Mic Live

SetCapsLockState, off

changeMute(soundDevice)
	{
		MuteState :=VA_GetMute(1,soundDevice)
		if MuteState=1
		{
  		SoundBeep, 200
    	Menu, Tray, Icon, imageres.dll, 230, 1   
		Menu, Tray, Tip, Mic Muted	
		Menu, Tray, Check, Microphone Mute														
		}
		else 
		{
		SoundBeep, 300
		Menu, Tray, Icon, imageres.dll, 233, 1
		Menu, Tray, Tip, Mic Live
		Menu, Tray, Uncheck, Microphone Mute	
		}
	}

toggleMute(soundDevice)
{
 	MuteState :=VA_GetMute(1,soundDevice)
	 	if MuteState=1
	 	{
	 		VA_SetMute(FALSE,1,soundDevice)
	 	}
	 	else 
	 	{
	 		VA_SetMute(TRUE,1,soundDevice)
	 	}
	changeMute(soundDevice)
	Return
}

$`::toggleMute(soundDevice)

$Capslock:: ;Change this for the button you want to use
	;THIS IS WHAT IT DOES WHEN YOU PUSH BUTTON 228z
    ;SoundSet, 1, MASTER, MUTE, myMic
    ;
	soundDevice := global soundDevice
	VA_SetMute(TRUE,1,soundDevice)
	changeMute(soundDevice)
	
	;THIS IS WHAT IT DOES WHEN YOU RELEASE BUTTON
    KeyWait, Capslock  ;MAKE SURE IF YOU CHANGE THE KEYBINDING BUTTON TO CHANGE THIS
    ;SoundSet, 0, MASTER, MUTE, myMic
    ;
    VA_SetMute(FALSE,1,soundDevice)
	changeMute(soundDevice)
    Return

ExitSub:
    VA_SetMute(FALSE,1,soundDevice)
	changeMute(soundDevice)
    ExitApp



