#SingleInstance force
#Persistent
settimer, idleCheck, 1000
CoordMode, Mouse, Screen
keySequence := "w a s d {space}"    ; a space separated list of keys to send
                            ; to send an actual space use {space}
aKeys := StrSplit(keySequence, A_space)
aKeysOpposite := {  w: "s"      ; if you dont want the character to move, 
                ,   s: "w"      ; include the opposite action of a key here - ie if 'w' for forward is sent, an 's' for backward is also sent
                ,   a: "d"
                ,   d: "a"}
return 

idleCheck:
if (A_TimeIdle >= 60000) ; this will randomly send input if there has been no input in the last minute (includes artificial input)
{
    randomKey := aKeys[rand(aKeys.MinIndex(), aKeys.MaxIndex())] 

    send, % randomKey (aKeysOpposite.HasKey(randomKey) ? aKeysOpposite[randomKey] : "") ; Send a random key from keySequence, if an opposite key exists send it too
    MouseGetPos, x, y
    if (x = A_ScreenWidth/2)                                                ; if cursors ist positioned in the middle of the monitor width
        MouseMove, rand(0, A_ScreenWidth) , rand(0, A_ScreenHeight), 3      ; move it to a random location inside the screen
    else 
        MouseMove, A_ScreenWidth/2, A_ScreenHeight/2, 3                     ; otherwise move it back to the centre 
}
return 


rand(l, h)
{
    random, r, l, h 
    return r
}
