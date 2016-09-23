#NoEnv			;Recommended for performance and compatibility with future AutoHotkey releases.
#Warn			;Recommended for catching common errors.
SendMode Input	;Recommended for new scripts due to its superior speed and reliability.

DesiredLevel := 60.0
DeviceNumber := 14

#Persistent
#SingleInstance force
SetFormat, float, 0.1
SoundGet, CurVol,,Vol,DeviceNumber
Menu, Tray, Icon, ddores.dll, 7
TrayTip, SetMic50
SetTimer, SetMic, 10000
return

SetMic:

	SoundGet, CurVol,,Vol,DeviceNumber
	if ErrorLevel 
		MsgBox,48,ForceMicLevel,%ErrorLevel%
	else if ("v" CurVol != "v" DesiredLevel)
		{
		SoundSet, DesiredLevel,,Vol,DeviceNumber
		if ErrorLevel 
			MsgBox,48,ForceMicLevel,%ErrorLevel%
		}
return