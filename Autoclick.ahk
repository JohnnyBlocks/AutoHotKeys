#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


~capslock::
if getkeystate("capslock", "T") ; checks if capslock is on or off
settimer, playmygame, 300 ; clicks every 300ms if capslock is on
else
settimer, playmygame, Off ; Turns off the autoclicking if capslock is off
return

playmygame:
SendInput, {Click} ; send a click.
Return