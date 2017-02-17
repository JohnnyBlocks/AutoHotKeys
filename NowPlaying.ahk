#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
DetectHiddenWindows, On ;Detect Spotify even if it's minimized
#IfWinExist ahk_class SpotifyMainWindow ;Only do the following if Spotify is running
DetectHiddenText, On
spotify = ahk_class SpotifyMainWindow ;Set variable for Spotify Window Name
;##################################################################
;###
;###    SET MonitorNumber to the Monitor you want to show the notification on
;###
;##################################################################




MonitorNumber = 2  ;This can be changed via the system tray menu when program is running
ShowArt  = 1       ; 1=Show 0=Hide
ShowIcon = 1	   ; 1=Show 0=Hide
Location = BottomLeft  ; BottomLeft, BottomRight, TopLeft, TopRight


;##################################################################
;###
;###    DO NOT EDIT BELOW THIS LINE
;###
;##################################################################
SysGet, Mon1, Monitor, MonitorNumber
ScreenWidth=%Mon1Right%
ScreenHeight=%Mon1Bottom%
ScreenLeft=%Mon1Left%
NextMonitor = MonitorNumber
SysGet,Monitors,MonitorCount
if(MonitorNumber + 1 > Monitors){
	NextMonitor = 1
} else {
	NextMonitor := NextMonitor +1
}
Menu, Tray, NoStandard
Menu, Tray, Add, Now Playing,  GetMusicInfo
Menu, Tray, Default ,Now Playing
Menu, Tray, Add, Change to &Monitor %NextMonitor%, ChangeMonitor
if(ShowIcon = 1){
	Menu, Tray, Add, Hide Player &Icon, ToggleIcon
} else {
	Menu, Tray, Add, Show Player &Icon, ToggleIcon
}
if(ShowArt = 1){
	Menu, Tray, Add, Hide &AudioScrobbler Art, ToggleArt
} else {
	Menu, Tray, Add, Show &AudioScrobbler Art, ToggleArt
}
Menu, Tray, Add, E&xit, ExitSub
Menu, Tray, Icon, imageres.dll, 169, 1
Menu, Tray, Tip, "Now Playing"`nCreated by YoYo-Pete
settimer, GetMusicInfo, 5000
Refresh:=0
lastFile = none;
ListeningOn = none;
CurrentMonitor = %MonitorNumber%;
Goto, GetMusicInfo




ToggleIcon:
	if(ShowIcon = 1){
		Menu, Tray, Rename, Hide Player &Icon, Show Player &Icon
		ShowIcon = 0
	} else {
		Menu, Tray, Rename, Show Player &Icon, Hide Player &Icon
		ShowIcon = 1
	}
	Refresh:=1
Goto, GetMusicInfo

ToggleArt:
	if(ShowArt = 1){
		Menu, Tray, Rename, Hide &AudioScrobbler Art, Show &AudioScrobbler Art
		ShowArt = 0
	} else {
		Menu, Tray, Rename, Show &AudioScrobbler Art, Hide &AudioScrobbler Art
		ShowArt = 1
	}
	Refresh:=1
Goto, GetMusicInfo




ChangeMonitor:
	Menu, Tray, Rename, Change to &Monitor %NextMonitor%, MonitorChange
	SysGet,Monitors,MonitorCount
	if(MonitorNumber + 1 > Monitors){
		MonitorNumber = 1
	} else {
		MonitorNumber := MonitorNumber +1
	}
	if(MonitorNumber + 1 > Monitors){
		NextMonitor = 1
	} else {
		NextMonitor := NextMonitor +1
	}
	Menu, Tray, Rename, MonitorChange, Change to &Monitor %NextMonitor%
	Refresh:=1
Goto, GetMusicInfo


GetAlbumArt:
if(Refresh = 1 or (ShowArt = 1 and lastfile != app_playing)){
	;download info from last.fm
	tempfile = %temp%\LFinfo
	urldownloadtofile, http://ws.audioscrobbler.com/2.0/?method=track.getinfo&api_key=b25b959554ed76058ac220b7b2e0a026&artist=%now_playing1%&track=%now_playing2%, %tempfile%
	fileRead, LFinfo, %tempfile%
	;MsgBox,%LFinfo%
	FileDelete, %tempfile%
	
	; get album name	  
	album:= RegExReplace(LFinfo, ".*<title>(.*)</title>.*","$1")
	StringReplace, album, album, amp;, &
	ListeningTo=%now_playing1% : %album% : %now_playing2%
	IfInString, album, <?xml
		{
			 ListeningTo=%now_playing1% : %now_playing2%
		} 
		
		
	; get album art...
	artURL:= RegExReplace(LFinfo, ".*<image size=""medium"">(.*)</image>.*","$1")
	artURL:= RegExReplace(artURL, "</image>.*")
	;MsgBox, %artURL%
	IfInString, artURL, <?xml
	{
	    albumArt = ;  
	}
	else	 
	{	  
		urldownloadtofile, %artURL%, %tempfile%
		albumArt = %tempfile%	
	}
	if(artURL = "") {
		 albumArt = ;
	}
	filedelete, %tempfile%.jpg	
}
Return

CheckSpotify:
	SetTitleMatchMode, 1
	IfWinExist, Spotify
    {
    		ListeningOn = Spotify
    		WinGetTitle, app_playing, %spotify% ;Get the title of Spotify which contains the track-name
			now_playing=%app_playing%
			
	
			notPlaying=Spotify
			notStarted=
			artwork =  spotify.png
			
			if(app_playing == "Spotify"){
				ListeningTo = Nothing is Playing
				albumArt =  
			} else  {
				;split name to artist and track title...
				StringReplace, now_playing, now_playing, &, and
				StringReplace, now_playing, now_playing, %A_SPACE%-%A_SPACE%, *
				StringSplit, now_playing, now_playing, *
				ListeningTo=%now_playing1% : %now_playing2%
				ListeningToSpotify = %ListeningTo%
				Player=Spotify

			}	
			
			
			
	}
Return

CheckVLC:
	SetTitleMatchMode, 2
	IfWinExist, VLC media player
    {
    	ListeningOn= VLC
        WinGetTitle, app_playing, VLC media player 
        now_playing=%app_playing%
        notPlaying= VLC
		notStarted=
		artwork =  vlc.png
        if(app_playing = "VLC media player"){
			ListeningTo = Nothing is Playing
			albumArt =  
		} else {
            ; Perform your keypresses here. I am showing the currently playing media
            StringReplace, now_playing, app_playing,  - VLC media player, , 
            StringReplace, now_playing, now_playing, %A_SPACE%-%A_SPACE%, *
			StringSplit, now_playing, now_playing, *
			ListeningTo=%now_playing1% : %now_playing2%
			ListeningToVLC = %ListeningTo%
            artwork = vlc.png
            Player=VLC

            
        }
        
       
    	
    } 
Return

RenderOutput:
	#SingleInstance force
	Gui, NowPlaying: New,, nowPlaying
	Gui,+AlwaysOnTop -Caption  +ToolWindow  +E0x08000000
	gui, font, cWhite s12, Verdana, 5 
	
	
	Gui, Add, Text, BackgroundTrans x0 y50 RIGHT, %ListeningTo%
	Gui, +LastFound
	ControlGetPos ,,, GuiWidth
	GuiWidth:=GuiWidth + 10
	if(ShowArt = 0 or albumArt = ""){
		Gui, Add, Picture, x%GuiWidth% y45, %artwork%
		ArtOffset := 0
	} else {
		Gui, Add, Picture, BackgroundTrans x%GuiWidth% y0 w70 h70, %albumArt%
		ArtOffset := 40
	}
	Gui, Margin, 0, 0
	Gui, +LastFound
	Gui, Color, D1DFEC, Red 
	WinSet, TransColor, D1DFEC
	Gui, +LastFound
	ControlGetPos ,,GuiHeight2, GuiWidth2
	SysGet, VirtualWidth, 78
	SysGet, VirtualHeight, 79
	Xpos := (ScreenLeft - GuiWidth2 - 120 + ArtOffset) + (1920 * (MonitorNumber -1))
	Ypos := (ScreenHeight - 72)
	Gui, NowPlaying: show, NoActivate  x%Xpos% y%Ypos%	 
Return






GetMusicInfo:
	
	Gosub, CheckSpotify
	Gosub, CheckVLC
	
	if(Player="Spotify"){
		ListeningTo = %ListeningToSpotify%
	}
	Msgbox, %ListeningTo%

    if(ShowArt = 1 and ListeningTo != "Nothing is Playing"){	
		Gosub, GetAlbumArt
	}
    
    if(lastfile != app_playing){
    	Refresh:=1
    }
    
    
    if(Refresh = 1){
		Gosub, RenderOutput
	}
	Refresh := 0
	lastFile = %app_playing%
	CurrentMonitor = %MonitorNumber%
Return
	
	
	
	
	
ExitSub:
    Gui, Destroy
    ExitApp