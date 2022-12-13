module Hooks.Grid where

import XMonad
import XMonad.Util.EZConfig 
import XMonad.Layout.GridVariants 
import XMonad.Actions.GridSelect
import Config


myColorizer = anyColor "#82AAFF"
   where
    anyColor color _ isFg = do
    return $ if isFg
             then (color,"#000000")
             else ("#282c34","#FFFFFF")

mygridConfig :: p -> GSConfig Window
mygridConfig x = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }


spawnGrid = runSelectedAction (myGridConfig myColorizer) myAppGrid

myGridConfig x = (buildDefaultGSConfig x)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

myAppGrid = [("Qutebrowser", spawn "qutebrowser")
             , ("Firefox", spawn "firefox")
             , ("RuneLite", spawn "runelite")
             , ("qBittorent", spawn "qbittorrent")
             , ("Mupen64Plus Emulator", spawn "m64py")
             , ("Steam", spawn "steam")
             , ("Thunderbird", spawn "thunderbird")
             , ("OBS", spawn "obs")
             , ("Emacs", spawn "emacsclient -c -a emacs")
             , ("LibreOffice Writer", spawn "lowriter")
             , ("Virt Manager", spawn "virt-manager")
             , ("Web Browser", spawn myBrowser)
             , ("Thunar", spawn "thunar")
             , ("IntelliJ IDEA", spawn "idea")
             , ("Visual Studio Code", spawn "code")
             , ("KeePassXC", spawn "keepassxc")
             , ("Kate Text Editor", spawn "kate")
             , ("Tauon Music Box", spawn "tauon")
             , ("Newsboat RSS", spawn "alacritty -e newsboat")
             , ("Remmina", spawn "remmina")
             , ("Deja-Dup Backup", spawn "deja-dup")
             , ("PavuControl Volume", spawn "pavucontrol")
             , ("ncmpcpp Music player", spawn "alacritty -e ncmpcpp")
             ]
