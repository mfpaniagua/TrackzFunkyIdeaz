#-- Name of Radio Station - Funky
set streamname "iTrackZ Radio - Killa Cutz - FunkyIdeaz -" 
set streamip "trackz.funkyideaz.org" 
set streamport "9696" 
set streamadmin "admin"
set streampass "xxxxx

set radiochan "#funkyideaz" 
set djchan "#funkyideazdjs"
set otherchan "#tbd" 
set admin "Funky"

set streamurl "http://trackz.funkyideaz.org:9696/stream.ogg"

#How often the bot checks the stream when it knows it is down in minutes. Recommend 1 minute. 
set offlinetimer "1" 

#How often the bot checks the stream when it knows it is online in seconds. Recommend 15 seconds. 
set onlinetimer "15" 

#Default interval for how often the bot advertises (in minutes). You want to set it to something that isn't 
# pure spammage. 
set adtimer "15" 

#Enables advertising set to the above frequency. 1 for ON and 0 for OFF. This reminds people that the stream 
# is online. 
set enableadvertise "0" 

#Enables Special Announcement, 1 for ON and 0 for OFF. Special announcements are displayed every 720 minutes. 
# This feature of the script is very undeveloped and I don't recommend using it. 
set specialannounce "0" 

#Special Announcement Message 
set announcemsg "SPECIAL ANNOUNCEMENT! On Novemeber 26th @ Midnight GMT, JA Radio will be ON-AIR with a show featuring some exclusive live tracks from some of our favorite bands! Click here for more info: http://www.thejediacademy.net/forums_detail_page.php?f_id=13532"

################################################################ 
#  Don't edit past this stuff unless you're Tido or Henkes :P  # 
################################################################ 


# Binds 

bind pub - "!ichoon" choon 
bind pub - "!icheese" cheese 
bind pub - "!icmds" showcommands 
bind pub - "!ihelp" showcommands 
bind pub - "!istatus" status 
bind pub - "!ilisteners" listenercheck 

bind pub - "!idjon" dj_on 
bind pub - "!idjoff" dj_off 
bind pub - "!iadvertise" toggle_advertise 
bind pub D "!iforceadvertise" forceadvertise 
#Forces an advertising message to be sent 

bind msg D "djforceoff" dj_force_off 
#Force-remove a DJ with !djforceoff <nick>, must have D flag 

bind pub - "!idj" dj 
bind pub - "!istream" stream
bind pub - "!irequest" request 
bind msg - "request" msg_request 
bind pub - "!iversion" iceversion 
bind pub - "!inewdj" newdj 

# Varible Resets 
set ice2version "1.0 (development) - 04-01-2013 - Funky @ irc.funkyideaz.org" 
set streamstatus "0" 
set djnickname "" 
set dj "" 
set oldsong "" 
set newsong "" 
set newlistener "" 
set oldlistener "0" 
set forceadsent "0" 
set sessionpeak "0" 

# Check to make sure StatusCheck timer isn't running when bot rehashes. 
if {![info exists statuscheck_running]} { 
  timer $offlinetimer [list statuscheck] 
  set statuscheck_running 1 
} 

# Check to make sure Special Announce timer isn't running when bot rehashes. 
if {![info exists specialannounce_running]} { 
  if {$specialannounce == "1"} { 
    timer 720 [list specialmessage] 
    set specialannounce_running 1 
  } 
} 


# Check to make sure Advertise timer isn't running when bot rehashes. 
if {![info exists adtimer_running]} { 
  if {$enableadvertise == "1"} { 
    timer $adtimer [list advertise] 
    set adtimer_running 1 
  } 
} 

proc stream {nick uhost hand chan arg} {
  global radiochan djchan
  putserv "privmsg $chan : IceCast Stream: http://trackz.funkyideaz.org:9696/trackz.ogg"
}

# Output for !help or !showcommands
proc showcommands {nick uhost hand chan arg} {
  global ice2version streamname botnick
  global radiochan djchan
  if { $chan == $radiochan } {
    putserv "notice $nick :>>> $botnick Commands - Script: $ice2version<<<"
#    putserv "notice $nick :!istatus >>> Displays the stream's extended stats."
    putserv "notice $nick :!idj >>> Shows current DJ."
    putserv "notice $nick :!ilisteners >>> Shows the current number of listeners tuned into $streamname."
    putserv "notice $nick :!irequest (artist+track) >>> Sends a request to the DJ's queue. Example: !request Oasis - Wonderwall"
    putserv "notice $nick :!ichoon >>> Message to the $radiochan channel if you like the current tune played"
    putserv "notice $nick :!icheese >>> Message to the $radiochan channel if you dislike the current tune played"
    putserv "notice $nick :!iversion >>> Diplays the version of the tcl script loaded."
    putserv "notice $nick :/msg $botnick request (artist+track) >>> Another way to send a request that isn't visable to everyone in the channel."
  } elseif { $chan == $djchan } {
    putserv "notice $nick :>>> $botnick Commands - Script: $ice2version <<<"
    putserv "notice $nick :----------------------------------------------------------------------------"
    putserv "notice $nick :>>> Some commands will only work in $djchan and some are only for admins <<<"
    putserv "notice $nick :----------------------------------------------------------------------------"
    putserv "notice $nick :!istatus >>> Displays the stream's extended stats."
    putserv "notice $nick :!idj >>> Shows current DJ."
    putserv "notice $nick :!ilisteners >>> Shows the current number of listeners tuned into $streamname."
    putserv "notice $nick :!irequest (artist+track) >>> Sends a request to the DJ's queue. Example: !request Oasis - Wonderwall"
    putserv "notice $nick :!ichoon >>> Message to the $radiochan channel if you like the current tune played"
    putserv "notice $nick :!icheese >>> Message to the $radiochan channel if you dislike the current tune played"
    putserv "notice $nick :!iversion >>> Diplays the version of the tcl script loaded."
    putserv "notice $nick :/msg $botnick request (artist+track) >>> Another way to send a request that isn't visable to everyone in the channel."
    putserv "notice $nick :!idjon >>> !djon (nick) - enables DJ status for someone with bot D tag"
    putserv "notice $nick :!idjoff >>> Disables DJ status"
    putserv "notice $nick :!iadvertise mins >>> Turns on and off Advertising. Also lets you set the interval: !advertise X"
    putserv "notice $nick :!iforceadvertise >>> Forces the advertising messages to appear"
    putserv "notice $nick :!idjforceoff >>> \/msg $botnick djforceoff \[nick\] - Forces off a DJ from having DJ status"
    putserv "notice $nick :!inewdj >>> !inewdj \[nick\] \[handle\] \[host\] - Adds a new user to the bot and gives them the DJ flag (D)"
  }
}


# Turns on and off Advertising. Also lets you set the interval: !advertise X 
proc toggle_advertise {nick uhost hand chan arg} { 
  global radiochan enableadvertise adtimer djchan admin
  putlog "toggle_advertise proc triggered"
  if { $nick != $admin && $chan == $djchan } {
    putserv "privmsg $chan : Nope, you're not an admin"
    return 0
  } else {
    if {$enableadvertise == "1"} { 
      set enableadvertise "0" 
      set timerinfo [gettimerid] 
      killtimer $timerinfo 
      putserv "PRIVMSG $chan :Advertising OFF" 
    } else { 
      set enableadvertise "1" 
      if {$arg == ""} { 
        putserv "PRIVMSG $chan :Advertising ON. Frequency set to $adtimer minutes." 
      } else { 
        set adtimer $arg 
        putserv "privmsg $chan :Advertising ON. Frequency changed to $adtimer minutes." 
        timer $adtimer [list advertise] 
      }
    } 
  } 
} 

# Function that finds out the ID of the advertising timer. 
proc gettimerid {} { 
    set adtimerinfo [timers] 
    set loc1 [string first "advertise" $adtimerinfo] 
    set loc1 [expr $loc1 + 10] 
    set str1 [string range $adtimerinfo $loc1 999] 
    set endloc [string first "\}" $str1] 
    set endloc [expr $endloc -1] 
    set timerinfo [string range $str1 0 $endloc] 
    return $timerinfo 
} 

# Messages that are displayed when Advertising is enabled. 
proc advertise {} { 
  global radiochan streamstatus otherchan enableadvertise adtimer forceadsent streamurl streamname 
  if {$streamstatus != "0" && $enableadvertise == "1"} { 
    putserv "PRIVMSG $radiochan :$streamname is currently broadcasting live! Listen in @ $streamurl" 
    putserv "PRIVMSG $otherchan :$streamname is currently broadcasting live! Listen in @ $streamurl" 
    if {$forceadsent == "0"} {timer $adtimer [list advertise]} else {set forceadsent "0"} 
    return 1 
  } 
  return 0 
} 

# Forces the advertising messages to appear 
proc forceadvertise {nick uhost hand chan arg} { 
  global streamstatus enableadvertise forceadsent 
  if {$streamstatus == "0"} { 
    putserv "notice $nick :The stream isn't on-air. Unable to advertise." 
    return 0 
  } else { 
    if {$enableadvertise == "0"} { 
      putserv "notice $nick :Advertising isn't enabled." 
      return 0 
    } else { 
      set forceadsent "1" 
      set forceadvertised [advertise] 
      if {$forceadvertised == "1"} { 
        putserv "notice $nick :Done!" 
      } else { 
        putserv "notice $nick :Advertising message was not sent!" 
      } 
    } 
  } 
} 

# Special Announcement Message. 
proc specialmessage {} { 
  global radiochan specialannounce announcemsg 
  putserv "PRIVMSG $radiochan : $announcemsg" 
  timer 720 [list specialmessage] 
  return 0 
} 

# StatusCheck 
# Function that takes the information from Icecast_Online and creates the proper responses. 
proc statuscheck {} { 
  global radiochan streamstatus newsong oldsong newlistener oldlistener sessionpeak dj enableadvertise otherchan onlinetimer offlinetimer streamurl streamname 
  global contenttype streamtitle streamdescription mountstarted peaklisteners
  global streamgenre streamurl mountpoint bitrate
  putlog "statuscheck proc triggered"

  if {$streamstatus == "0"} { 
    set oldstatus "0" 
  } else { 
    set oldstatus "1" 
  } 
  set newstatus "[icecast_online]" 
  if {$newstatus =="0" && $oldstatus == "0"} { 
    timer $offlinetimer [list statuscheck] 
  } 
  if {$newstatus == "1" && $oldstatus == "0"} { 
    putserv "PRIVMSG $radiochan :$streamname is now ON-AIR!! Click to listen: $streamurl" 
    putlog "(RADIO) On-Air detected." 
    utimer $onlinetimer [list statuscheck] 
    if {$enableadvertise == "1"} { 
      putserv "PRIVMSG $otherchan :$streamname is now ON-AIR!! Click to listen: $streamurl" 

    } 
  } 
  if {$newstatus == "0" && $oldstatus == "1"} { 
    putserv "PRIVMSG $radiochan :$streamname is now off-air." 
    set oldlistener "0" 
    set sessionpeak "0" 
    if {$enableadvertise == "1"} { 
      putserv "PRIVMSG $otherchan :$streamname is now off-air." 
    } 
    putlog "(RADIO) Off-Air detected." 
    timer $offlinetimer [list statuscheck] 
  } 
  if {$newstatus == "1" && $oldstatus == "1"} { 
    utimer $onlinetimer [list statuscheck] 
    if {$newlistener != $oldlistener} { 
      putserv "notice $dj :$newlistener listeners." 
#      if {$newlistener > $sessionpeak} { 
         if { $newlistener == 0 } {
           putserv "PRIVMSG $radiochan :$streamname currently has no listeners"
         } elseif { $newlistener == 1 } {
           putserv "PRIVMSG $radiochan :$streamname currently has $newlistener listener" 
         } else {
           putserv "PRIVMSG $radiochan :$streamname currently has $newlistener listeners" 
         }
         set sessionpeak $newlistener 
#      } 
      set oldlistener "$newlistener" 
    } 
    if {$newsong != $oldsong} { 
      putserv "PRIVMSG $radiochan : IceCast - New song: \002 \0038 $newsong" 
      set oldsong "$newsong" 
    } 
  } 
} 
  
# Icecast_Online 
# This is the HTTP Parser that gathers the various data from the status.xsl file. 
proc icecast_online { } { 
  global streamip streamport streamstatus newsong newlistener streamadmin streampass
  global contenttype streamtitle streamdescription mountstarted peaklisteners
  global streamgenre streamurl mountpoint bitrate
  set pagedata "" 
  set chan "#itrackz.radio"
  if {[catch {set sock [socket $streamip $streamport] } sockerror]} { 
    putlog "error: $sockerror" 
    return 0 
  } else { 
    puts $sock "GET /status.xsl HTTP/1.1" 
    puts $sock "User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.9)" 
    puts $sock "Host: $streamip"
    puts $sock "Connection: close" 
    puts $sock "" 
    flush $sock 
    while {![eof $sock]} { append pagedata "[read $sock]" } 
  }
  if {[string match *streamdata* $pagedata] == 1} { 
    set streamstatus "1" 
    set songlocation [string first "Current Song:" $pagedata] 
    set songdata1 [string range $pagedata $songlocation 99999] 
    set location2 [string first "</tr>" $songdata1] 
    set songdata2 [string range $songdata1 0 $location2] 
    set songdata3 [string range $songdata2 42 9999] 
    set location3 [string first " - </td>" $songdata3] 
    set location3 [expr $location3 - 1] 
    set newsong [string range $songdata3 0 $location3] 

    set llocation [string first "Current Listeners:" $pagedata] 
    set countdata1 [string range $pagedata $llocation 99999] 
    set llocation2 [string first "</tr>" $countdata1] 
    set countdata2 [string range $countdata1 0 $llocation2] 
    set countdata3 [string range $countdata2 47 9999] 
    set llocation3 [string first "</td>" $countdata3] 
    set llocation3 [expr $llocation3 - 1] 
    set newlistener [string range $countdata3 0 $llocation3] 

    set ctypeloc [ string first "Content Type:" $pagedata ]
    set ctypedat [ string range $pagedata $ctypeloc 99999 ]
    set ctypeloc2 [ string first "</tr>" $ctypedat ]
    set ctypedat2 [ string range $ctypedat 0 $ctypeloc2 ]
    set ctypedat3 [ string range $ctypedat2 42 9999 ]
    set ctypeloc3 [ string first "</td>" $ctypedat3 ]
    set ctypeloc3 [ expr $ctypeloc3 - 1 ]
    set contenttype [ string range $ctypedat3 0 $ctypeloc3 ]

    set stloc [ string first "Stream Title:" $pagedata ]
    set stdat [ string range $pagedata $stloc 99999 ]
    set stloc2 [ string first "</tr>" $stdat ]
    set stdat2 [ string range $stdat 0 $stloc2 ]
    set stdat3 [ string range $stdat2 42 9999 ]
    set stloc3 [ string first "</td>" $stdat3 ]
    set stloc3 [ expr $stloc3 - 1 ]
    set streamtitle [ string range $stdat3 0 $stloc3 ]

    set sdloc [ string first "Stream Description:" $pagedata ]
    set sddat [ string range $pagedata $sdloc 99999 ]
    set sdloc2 [ string first "</tr>" $sddat ]
    set sddat2 [ string range $sddat 0 $sdloc2 ]
    set sddat3 [ string range $sddat2 48 9999 ]
    set sdloc3 [ string first "</td>" $sddat3 ]
    set sdloc3 [ expr $sdloc3 - 1 ]
    set streamdescription [ string range $sddat3 0 $sdloc3 ]

    set msloc [ string first "Mount started:" $pagedata ]
    set msdat [ string range $pagedata $msloc 99999 ]
    set msloc2 [ string first "</tr>" $msdat ]
    set msdat2 [ string range $msdat 0 $msloc2 ]
    set msdat3 [ string range $msdat2 48 9999 ]
    set msloc3 [ string first "</td>" $msdat3 ]
    set msloc3 [ expr $msloc3 - 1 ]
    set mountstarted [ string range $msdat3 0 $msloc3 ]

    set plloc [ string first "Peak Listeners:" $pagedata ]
    set pldat [ string range $pagedata $plloc 99999 ]
    set plloc2 [ string first "</tr>" $pldat ]
    set pldat2 [ string range $pldat 0 $plloc2 ]
    set pldat3 [ string range $pldat2 44 9999 ]
    set plloc3 [ string first "</td>" $pldat3 ]
    set plloc3 [ expr $plloc3 - 1 ]
    set peaklisteners [ string range $pldat3 0 $plloc3 ]

    set sgloc [ string first "Stream Genre:" $pagedata ]
    set sgdat [ string range $pagedata $sgloc 99999 ]
    set sgloc2 [ string first "</tr>" $sgdat ]
    set sgdat2 [ string range $sgdat 0 $sgloc2 ]
    set sgdat3 [ string range $sgdat2 42 9999 ]
    set sgloc3 [ string first "</td>" $sgdat3 ]
    set sgloc3 [ expr $sgloc3 - 1 ]
    set streamgenre [ string range $sgdat3 0 $sgloc3 ]

    set suloc [ string first "Stream URL:" $pagedata ]
    set sudat [ string range $pagedata $suloc 99999 ]
    set suloc2 [ string first "</tr>" $sudat ]
    set sudat2 [ string range $sudat 0 $suloc2 ]
    set sudat3 [ string range $sudat2 100 9999 ]
    set suloc3 [ string first "</a>" $sudat3 ]
    set suloc3 [ expr $suloc3 - 1 ]
    set streamurl [ string range $sudat3 0 $suloc3 ]

    set mploc [ string first "Mount Point" $pagedata ]
    set mpdat [ string range $pagedata $mploc 99999 ]
    set mploc2 [ string first "</tr>" $mpdat ]
    set mpdat2 [ string range $mpdat 0 $mploc2 ]
    set mpdat3 [ string range $mpdat2 62 9999 ]
    set mploc3 [ string first "\.m3u" $mpdat3 ]
    set mploc3 [ expr $mploc3 - 1 ]
    set mountpoint [ string range $mpdat3 0 $mploc3 ]

    set brloc [ string first "Bitrate:" $pagedata ]
    set brdat [ string range $pagedata $brloc 99999 ]
    set brloc2 [ string first "</tr>" $brdat ]
    set brdat2 [ string range $brdat 0 $brloc2 ]
    set brdat3 [ string range $brdat2 37 9999 ]
    set brloc3 [ string first "</td>" $brdat3 ]
    set brloc3 [ expr $brloc3 - 1 ]
    set bitrate [ string range $brdat3 0 $brloc3 ]

#putlog "$newsong"
#putlog "$newlistener"
#putlog "$contenttype"
#putlog "$streamtitle"
#putlog "$streamdescription"
#putlog "$mountstarted"
#putlog "$peaklisteners"
#putlog "$streamgenre"
#putlog "$streamurl"
#putlog "$mountpoint"
#putlog "$bitrate"

    close $sock 
    return 1 
    
  } else { 
    set streamstatus "0" 
    close $sock 
    return 0 
  } 
} 

# !status function. Diplays the current status of the stream. 
proc status {nick uhost hand chan arg} { 
  global dj radiochan newsong newlistener streamstatus streamurl streamname 
  global contenttype streamtitle streamdescription mountstarted peaklisteners
  global streamgenre streamurl mountpoint bitrate djchan
  putlog "status proc triggered"
  if {$streamstatus == 1} { 
    putserv "PRIVMSG $chan :$streamname is currently broadcasting live @ $streamurl" 
    if {$newsong != "" && $chan == $djchan} {
      if {$newlistener == 0 } {
        putserv "PRIVMSG $chan :The current song is \0038 $newsong \0030 with no listeners."
      } elseif { $newlistener == 1 } {
        putserv "PRIVMSG $chan :Current Song: \0038 $newsong \0030 \| Listeners: \0038 $newlistener"
        putserv "PRIVMSG $chan :Content Type: \0038 $contenttype \0030 \| Stream Title: \0038 $streamtitle"
        putserv "PRIVMSG $chan :Stream Description: \0038 $streamdescription \0030 \| Mount Started: \0038 $mountstarted"
        putserv "PRIVMSG $chan :Peak Listeners: \0038 $peaklisteners \0030 \| Stream Genre: \0038 $streamgenre"
        putserv "PRIVMSG $chan :Stream URL: \0038 $streamurl$mountpoint \0030 \| Bitrate: \0038 $bitrate"
        putserv "PRIVMSG $chan :Server: \0038 icecast v2.3.3 \0030 \| Client: \0038 ices v2.0.2 \0030 \| DJ: \0038 AutoDJ"
      } else {
        putserv "PRIVMSG $chan :Current Song: \0038 $newsong \0030 \| Listeners: \0038 $newlistener"
        putserv "PRIVMSG $chan :Content Type: \0038 $contenttype \0030 \| Stream Title: \0038 $streamtitle"
        putserv "PRIVMSG $chan :Stream Description: \0038 $streamdescription \0030 \| Mount Started: \0038 $mountstarted"
        putserv "PRIVMSG $chan :Peak Listeners: \0038 $peaklisteners \0030 \| Stream Genre: \0038 $streamgenre"
        putserv "PRIVMSG $chan :Stream URL: \0038 $streamurl$mountpoint \0030 \| Bitrate: \0038 $bitrate"
        putserv "PRIVMSG $chan :Server: \0038 icecast v2.3.3 \0030 \| Client: \0038 ices v2.0.2 \0030 \| DJ: \0038 AutoDJ"
      }
    } 
    if {$dj != ""} {putserv "PRIVMSG $chan :The DJ is $dj"} 
  } else { 
    putserv "PRIVMSG $chan :$streamname is currently offline." 
  } 
} 

# !request X: sends requests to the DJ. 
proc request {nick uhost hand chan arg} { 
  global dj radiochan 
  if {$dj == ""} { 
    putserv "notice $nick :There isn't a DJ logged in at the moment to take requests." 
  } else { 
    if {$arg == ""} { 
      putserv "notice $nick :You didn't request anything!" 
    } else { 
      putserv "privmsg $dj :REQUEST($nick)=> $arg" 
      putserv "notice $nick :Request sent to $dj :)" 
    } 
  } 
} 

# /msg $botnick request X: sends the request to the DJ privately. 
proc msg_request {nick uhost hand arg} { 
  global dj radiochan 
  if {$dj == ""} { 
    putserv "notice $nick :There isn't a DJ logged in at the moment to take requests." 
  } else { 
    if {$arg == ""} { 
      putserv "notice $nick :You didn't request anything!" 
    } else { 
      putserv "privmsg $dj :REQUEST($nick)=> $arg" 
      putserv "notice $nick :Request sent to $dj :)" 
    } 
  } 
} 

# !djon (name): enables DJ status for someone with the D tag 
proc dj_on {nick uhost hand chan arg} { 
  global dj radiochan djnickname streamurl streamname 
  if {$dj != "" && $dj != "$nick" && [onchan $djnickname $radiochan] != "0"} { 
    putserv "notice $nick :There is already a DJ active!" 
    return 0 
  } 
  if {$arg == "" } { set djnickname $nick} else {set djnickname $arg} 
  pushmode $radiochan +o $nick 
  putserv "TOPIC $radiochan :$streamname || Click here to Listen: $streamurl || http://dir.xiph.org/search?search=funkyideaz || Current DJ: $djnickname" 
  putserv "PRIVMSG $radiochan :$djnickname is now rocking the turntables, enjoy." 
  set dj "$nick" 
  putlog "(RADIO) DJ-ON: [nick2hand $nick $chan]" 
} 

# !djoff: Disables DJ status. 
proc dj_off {nick uhost hand chan arg} { 
  global dj radiochan djnickname streamurl streamname 
  if {$dj != $nick} { 
    putserv "notice $nick :You are not the current DJ or you changed your nickname since becoming one." 
  } else { 
    set dj "" 
    set djnickname "" 
    pushmode $radiochan -o $nick 
    putserv "TOPIC $radiochan :$streamname || Click here to Listen: $streamurl || http://dir.xiph.org/search?search=funkyideaz || Current DJ: none" 
    putserv "notice $nick :Your DJ'ness has been deactivated" 
    putlog "(RADIO) DJ-OFF: [nick2hand $nick $chan]" 
  } 
} 

# /msg $botnick djforceoff [nick]: Forces off a DJ from having DJ status. 
proc dj_force_off {nick uhost hand arg} { 
  global djnickname dj radiochan streamurl streamname 
  if {$dj == ""} { 
    putserv "notice $nick :No DJ currently set to boot off." 
    return 0 
  } else { 
    if {$arg == ""} { 
      putserv "notice $nick :You didn't specify a DJ to boot off." 
      return 0 
    } else { 
      set dj "" 
      set djnickname "" 
      pushmode $radiochan -o $arg 
      putserv "TOPIC $radiochan :$streamname || Click here to Listen: $streamurl || Program Schedule: http://www.thejediacademy.net/forums_detail_page.php?f_id=12083 || Current DJ: none" 
      putserv "notice $nick :DJ status removed for $arg." 
      putserv "notice $arg :Your DJ'ness was removed by $nick." 
      putlog "(RADIO) DJ-FORCEOFF: $arg booted by [nick2hand $nick $chan]" 
    } 
  } 
} 

# !dj: displays who the current DJ is. 
proc dj {nick uhost hand chan arg} { 
  global djnickname radiochan streamname 
  if {$djnickname == ""} { 
    putserv "PRIVMSG $chan :There currently are no live DJs logged in at the moment. Auto DJ is on." 
  } else { 
    putserv "PRIVMSG $chan :$djnickname is the current $streamname DJ!" 
  } 
} 

# !listeners: displays how many current listeners there are. 
proc listenercheck {nick uhost hand chan arg} { 
  global newlistener radiochan streamstatus streamname 
  global contenttype streamtitle streamdescription mountstarted peaklisteners
  global streamgenre streamurl mountpoint bitrate
  if {$streamstatus == "1"} { 
    if {$newlistener == "0"} { 
      putserv "PRIVMSG $chan :There aren't any listeners tuned into $streamname :(." 
    } elseif {$newlistener =="1"} { 
      putserv "PRIVMSG $chan :There is 1 listener tuned into $streamname." 
    } else { 
      putserv "PRIVMSG $chan :There are $newlistener listeners tuned into $streamname." 
    } 
  } else { 
    putserv "PRIVMSG $chan :$streamname isn't on-air." 
  } 
} 

# !newdj [nick] [handle] [host]: Adds a new user to the bot and gives them the DJ flag (D). 
proc newdj {nick host hand chan arg} { 
  putlog "newdj proc triggered"
  global radiochan streamname 
putlog "$nick"
  if { $nick != "Funky" } {
    putserv "privmsg $nick :You can not do that!"
    return 0
  }
  set nickname [lindex $arg 0] 
  set newhand [lindex $arg 1] 
  set newhost [lindex $arg 2] 
  if {[validuser $nickname]} { 
    putserv "privmsg $nick :There is already a user existing by that handle!" 
    return 0 
  } 
  if {$nickname == ""} { 
    putserv "privmsg $nick :You must enter their nickname handle and host!" 
    return 0 
  } 
  if {$newhand == ""} { 
    putserv "privmsg $nick :You must enter their nickname handle and host!" 
    return 0 
  } 
  if {$newhost == ""} { 
    putserv "privmsg $nick :You must enter their nickname handle and host!" 
    return 0 
  } 
  if {([onchan $nickname $chan])} { 
    adduser $newhand $newhost 
    chattr $newhand +D 
    putserv "privmsg $radiochan :Added $nickname ($newhand) as a $streamname DJ!" 
  } 
} 

# !version: displays the current version of the Ice2.tcl script. 
proc iceversion {nick host hand chan arg} { 
   global ice2version radiochan botnick 
   if {$chan == $radiochan} { 
     putserv "PRIVMSG $radiochan :I am $botnick running itrackz.radio.dev.tcl Version $ice2version." 
   } 
} 

# !choon function. Diplays if u like the song. 
proc choon {nick uhost hand chan arg} { 
  global dj radiochan newsong newlistener streamstatus streamurl streamname 
  if {$streamstatus == 1} { 
    putserv "PRIVMSG $chan :$nick gets down with $newsong!" 
 } 
} 

# !cheese function. Diplays if u hate the song. 
proc cheese {nick uhost hand chan arg} { 
 global dj radiochan newsong newlistener streamstatus streamurl streamname 
  if {$streamstatus == 1} { 
    putserv "PRIVMSG $chan :$nick thinks this tune is a load of cheese and a waiste!" 
 } 
} 

putlog "*** $ice2version - For IceCast v2.3.3 - By Funky" 
