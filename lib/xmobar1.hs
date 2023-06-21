Config {         
                 font              = "VictorMono Nerd Font Bold 11"
                 , additionalFonts = ["VictorMono Nerd Font Bold 15"]
                 , bgColor         = "#282c34"
                 , fgColor         = "#51afef" 
                 , position        = Static { xpos = 0 , ypos = 0, width = 1920, height = 19 }
                 , lowerOnStart    = True
                 , hideOnStart     = False
                 , allDesktops     = True
                 , persistent      = True
                 , iconRoot        = "$HOME/.config/xmonad/xpm/"
                 , commands        = [ 
                                       Run Date "<fc=#666666><fn=5>|</fn></fc> %a %d %b %Y <fc=#ff9900>[ %H:%M ]</fc>" "date" 50
                                     , Run Network "eth1" ["-t", "<fc=#666666><fn=5>|</fn></fc>\xf0ab <rx>kB \xf0aa <tx>kB" 
                                                          , "--Low"      , "1000000"       -- units: B/s
                                                          , "--High"     , "5000000"       -- units: B/s
                                                          , "--high"     , "red"
                                                          ] 10
                                     , Run Cpu            [ "--template" , "cpu: <total> % <fc=#666667><fn=5>|</fn></fc>"
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
                                     , Run Memory ["-t", "mem: <usedratio> %<fc=#666666><fn=5> |</fn></fc>"
                                  -- , Run Memory         [ "--template" ,"<fc=#666666><fn=5>|</fn></fc>mem: <used> MB (<usedratio> %)"
                                                          , "--Low"      , "22000"     -- units: MB
                                                          , "--High"     , "28000"     -- units: MB
                                                          , "--low"      , "#51afef"
                                                          , "--normal"   , "darkorange"
                                                          , "--high"     , "red"
                                                          ] 10
                                     , Run DiskU [("/", "ssd: <free>")] [] 60
                                     , Run Com "uname" ["-r"] "" 3600
                                     , Run Kbd            [ ("us(dvorak)" , "<fc=#00008B>DV</fc>")
                                                        , ("us"         , "<fc=#8B0000>US</fc>")
                                                        ]
                                     , Run MPD ["-t", "<state>"] 10
                                     , Run UnsafeStdinReader
                                     ]
                                     , sepChar = "%"
                                     , alignSep = "}{"
                                     , template = " %UnsafeStdinReader% }{%cpu% %memory% %disku% %eth1% %date%"
       }
