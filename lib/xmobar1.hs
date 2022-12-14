Config {         
                 font              = "xft:VictorMono Nerd Font:pixelsize=15:bold:antialias=true:hinting=true"
                 , additionalFonts = [ "xft:VictorMono Nerd Font:weight=regular:pixelsize=15:antialias=true:hinting=true" ]
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
                                     , Run Cpu            [ "--template" , "cpu: <total> %"
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
                                     , Run Memory ["-t", " mem: <used>M (<usedratio> %)"] 20
                                     , Run Memory         [ "--template" ,"<fc=#666666><fn=5>|</fn></fc>mem: <used> MB (<usedratio> %)"
                                                      --  , "--Low"      , "40"        -- units: %
                                                      --  , "--High"     , "80"        -- units: %
                                                      --  , "--Low"      , "100"
                                                      --  , "--normal"   , "darkorange"
                                                      --  , "--high"     , "red"
                                                          ] 10
                                     , Run DiskU [("/", "<fc=#666666><fn=5>|</fn></fc>ssd: <free>")] [] 60
                                     , Run Com "uname" ["-r"] "" 3600
                                     , Run Kbd            [ ("us(dvorak)" , "<fc=#00008B>DV</fc>")
                                                          , ("us"         , "<fc=#8B0000>US</fc>")
                                                          ]
                                     , Run UnsafeStdinReader
                                     ]
                                     , sepChar = "%"
                                     , alignSep = "}{"
                                     , template = " %UnsafeStdinReader% }{%cpu% %memory% %disku% %eth1% %date%"
       }
