#NoEnv		;Recommended for performance and compatibility with future AutoHotkey releases.
#Warn		;Recommended for catching common errors.
SendMode Input	;Recommended for new scripts due to its superior speed and reliability.

#SingleInstance force
gui, font, cRed s28 w1000, Verdana 
Gui, Add, Text, ,I am a msgbox that will not stop your current thread.
Gui,+AlwaysOnTop -Caption
Gui, Margin, 0, 0
Gui, +LastFound
Gui, Color, D1DFEC, Red 
WinSet, TransColor, D1DFEC
Gui, show,
Sleep 3000
Gui, Destroy
Return
