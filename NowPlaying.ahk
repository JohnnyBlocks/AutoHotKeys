#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
DetectHiddenWindows, On ;Detect Spotify even if it's minimized
#IfWinExist ahk_class SpotifyMainWindow ;Only do the following if Spotify is running
DetectHiddenText, On
spotify = ahk_class SpotifyMainWindow ;Set variable for Spotify Window Name





;


checkVLC:
    




MonitorNumber = 2



SysGet, Mon1, Monitor, MonitorNumber
ScreenWidth=%Mon1Right%
ScreenHeight=%Mon1Bottom%
ScreenLeft=%Mon1Left%

Menu, Tray, NoStandard
Menu, Tray, Add, Now Playing,  GetMusicInfo
Menu, Tray, Default ,Now Playing
Menu, Tray, Add, E&xit, ExitSub
Menu, Tray, Icon, imageres.dll, 169, 1
Menu, Tray, Tip, "Now Playing"`nCreated by YoYo-Pete

settimer, GetMusicInfo, 5000

lastFile = none;

ListeningOn = none;

GetMusicInfo:
    
    SetTitleMatchMode, 1
	IfWinExist, Spotify
    {
    		ListeningOn = Spotify
    		WinGetTitle, app_playing, %spotify% ;Get the title of Spotify which contains the track-name
			now_playing=%app_playing%
			
	
			notPlaying=Spotify
			notStarted=
			if(app_playing == notStarted) {
				ListeningTo = Spotify is not Started
				artwork =  spotify.png
			} else if(app_playing == notPlaying) {
				ListeningTo = Spotify : Nothing is Playing
				artwork =  spotify.png
			} else  {
				;split name to artist and track title...
				StringReplace, now_playing, now_playing, &, and
				StringReplace, now_playing, now_playing, %A_SPACE%-%A_SPACE%, *
				StringSplit, now_playing, now_playing, *

				; get album name	  
				album:= RegExReplace(LFinfo, ".*<title>(.*)</title>.*","$1")
				StringReplace, album, album, amp;, &
				ListeningTo=%now_playing1% : %now_playing2%
			}	  
    		
	}
    
    SetTitleMatchMode, 2
	IfWinExist, VLC media player
    {
    	ListeningOn = VLC
        WinGetTitle, app_playing, VLC media player 
       
        if (strlen(app_playing) > 16)
        {
            ; Perform your keypresses here. I am showing the currently playing media
            StringReplace, NowPlaying, app_playing,  - VLC media player, , 
            ListeningTo = % NowPlaying
            artwork = vlc.png
        }
    	
    } 
    
		
	 if(lastfile != app_playing) {	
		#SingleInstance force
		Gui, NowPlaying: New,, nowPlaying
		Gui,+AlwaysOnTop -Caption  +ToolWindow  +E0x08000000
		gui, font, cWhite s12, Verdana, 5 
		
		
		Gui, Add, Text, BackgroundTrans x0 y50 RIGHT, %ListeningTo%
		Gui, +LastFound
		ControlGetPos ,,, GuiWidth
		GuiWidth:=GuiWidth + 10
		Gui, Add, Picture, x%GuiWidth% y45, %artwork%
		Gui, Margin, 0, 0
		Gui, +LastFound
		
		Gui, Color, D1DFEC, Red 
		WinSet, TransColor, D1DFEC
		Gui, +LastFound
		ControlGetPos ,,GuiHeight2, GuiWidth2
		SysGet, VirtualWidth, 78
		SysGet, VirtualHeight, 79
		
		Xpos := (ScreenLeft - GuiWidth2 - 120) + (1920 * (MonitorNumber -1))
		Ypos := (ScreenHeight - 72)
		Gui, NowPlaying: show, NoActivate  x%Xpos% y%Ypos%	 
	}
	lastFile = %app_playing%
		
	
	Return
ExitSub:
    Gui, Destroy
    ExitApp