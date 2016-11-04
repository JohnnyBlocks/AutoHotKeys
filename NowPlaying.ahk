#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
DetectHiddenWindows, On ;Detect Spotify even if it's minimized
#IfWinExist ahk_class SpotifyMainWindow ;Only do the following if Spotify is running
DetectHiddenText, On
spotify = ahk_class SpotifyMainWindow ;Set variable for Spotify Window Name






ScreenWidth=1920
ScreenHeight=1200









Menu, Tray, NoStandard
Menu, Tray, Add, Spotify Now Playing,  GetSpotifyInfo
Menu, Tray, Default ,Spotify Now Playing
Menu, Tray, Add, E&xit, ExitSub
Menu, Tray, Icon, imageres.dll, 169, 1
Menu, Tray, Tip, "Spotify Now Playing"`nCreated by YoYo-Pete

settimer, GetSpotifyInfo, 5000

lastFile = none;

GetSpotifyInfo:
	WinGetTitle, spotify_playing, %spotify% ;Get the title of Spotify which contains the track-name
	now_playing=%spotify_playing%
	notPlaying=Spotify
	notStarted=
	if(spotify_playing == notStarted) {
		ListeningTo = Spotify is not Started
		artwork =  spotify.png
	} else if(spotify_playing == notPlaying) {
		ListeningTo = Spotify : Nothing is Playing
		artwork =  spotify.png
	} else  {
		
		if(lastfile != spotify_playing) {
			;split name to artist and track title...
			StringReplace, now_playing, now_playing, &, and
			StringReplace, now_playing, now_playing, %A_SPACE%-%A_SPACE%, *
			StringSplit, now_playing, now_playing, *

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
			    artwork =  spotify.png    
			}
			else	 
			{	  
				urldownloadtofile, %artURL%, %tempfile%
				artwork = %tempfile%	
			}
			if(artURL = "") {
				 artwork =  spotify.png    
			}
			filedelete, %tempfile%.jpg
		}
	}	  
	
	
	if(lastfile != spotify_playing) {	
		#SingleInstance force
		Gui, NowPlaying: New,, nowPlaying
		Gui,+AlwaysOnTop -Caption  +ToolWindow  +E0x08000000
		gui, font, cWhite s12, Verdana, 5 
		
		
		Gui, Add, Text, BackgroundTrans x0 y50 RIGHT, %ListeningTo%
		Gui, +LastFound
		ControlGetPos ,,, GuiWidth
		GuiWidth:=GuiWidth + 10
		Gui, Add, Picture, BackgroundTrans x%GuiWidth% y0 w70 h70, %artwork%
		Gui, Margin, 0, 0
		Gui, +LastFound
		
		Gui, Color, D1DFEC, Red 
		WinSet, TransColor, D1DFEC
		Gui, +LastFound
		ControlGetPos ,,GuiHeight2, GuiWidth2
		SysGet, VirtualWidth, 78
		SysGet, VirtualHeight, 79
		
		Xpos := (ScreenWidth - GuiWidth2 - 80)
		Ypos := (ScreenHeight - 70)
		Gui, NowPlaying: show, NoActivate  x%Xpos% y%Ypos%	 
		lastFile = %spotify_playing%
	}
	Return


ExitSub:
    Gui, Destroy
    ExitApp