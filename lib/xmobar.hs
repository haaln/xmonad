Config {         
                 font              = "xft:VictorMono Nerd Font:pixelsize=13:bold:antialias=true:hinting=true"
                 , additionalFonts = [ "xft:VictorMono Nerd Font:weight=regular:pixelsize=15:antialias=true:hinting=true" ]
                 , bgColor         = "#282c34"
                 , fgColor         = "#51afef" 
                 , position        = Static { xpos = 0 , ypos = 0, width = 1920, height = 15 }
                 --, lowerOnStart    = True
                 , hideOnStart     = False
                 , allDesktops     = True
                 , persistent      = True
                 , commands        = [ 
                                       Run Date "%a %d %b %Y <fc=#FFA500>[ %H:%M ]</fc>" "date" 50
                                     , Run Network "dead-phone" ["-t","<dev>: <fc=#00FF00>Connected</fc>",  "-x<fc=#FF0000>Disconnected</fc>"  ] 10
                                     , Run Network "wlp2s0" ["-t", "|\xf0ab <rx>kB \xf0aa <tx>kB" 
                                                          , "--Low"      , "1000000"       -- units: B/s
                                                          , "--High"     , "5000000"       -- units: B/s
                                                          , "--high"     , "red"
                                                          ] 10
                                     , Run Cpu            [ "--template" , "| cpu: <total> %"
                                                          , "--Low"      , "50"         -- units: %
                                                          , "--High"     , "85"         -- units: %
                                                          , "--normal"   , "darkorange"
                                                          , "--high"     , "red"
                                                          ] 10
                                     , Run CoreTemp       [ "--template" , "<core0>°C"
                                                          , "--Low"      , "70"        -- units: °C
                                                          , "--High"     , "80"        -- units: °C
                                                       -- , "--low"      , "darkgreen"
                                                          , "--normal"   , "darkorange"
                                                          , "--high"     , "red"
                                                          ] 50
                                             -- battery monitor
                                     --, Volume             "default" "Master" [ "-t", "<volume>% <status>" ] 10
                                     , Run Battery        [ "--template" , "pwr: <acstatus> |"
                                                          , "--Low"      , "20"        -- units: %
                                                        --, "--High"     , "80"        -- units: %
                                                          , "--low"      , "red"
                                                        --, "--normal"   , "orange"
                                                        --, "--high"     , "darkgreen"
                                                          , "--" -- battery specific options
                                                                    -- discharging status
                                                                    , "-o"	, "<left>%"
                                                                    -- AC "on" status
                                                                    , "-O"	, " <left>%"
                                                                    -- charged status
                                                                    , "-i"	, " <left>%"
                                                           ] 50
                                     , Run Memory         [ "--template" ,"| mem: <usedratio> %"
                                                      --  , "--Low"      , "40"        -- units: %
                                                      --  , "--High"     , "80"        -- units: %
                                                      --  , "--Low"      , "100"
                                                      --  , "--normal"   , "darkorange"
                                                      --  , "--high"     , "red"
                                                          ] 10
                                     , Run DiskU [("/", "|ssd: <free>")] [] 60
                                     , Run Com "uname" ["-r"] "" 3600
                                     , Run Kbd            [ ("se"         , "SE")
                                                          , ("gb"         , "GB")
                                                          ]
                                     , Run StdinReader
                                     ]
                                     , sepChar = "%"
                                     , alignSep = "}{"
                                     , template = " %StdinReader% }{ %battery% %dead-phone% %cpu% %memory% %disku% %wlp2s0%| %date%"
       }
