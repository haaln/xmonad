module Hooks.Grid where

import XMonad
import XMonad.Util.EZConfig 
import XMonad.Layout.GridVariants 
import XMonad.Actions.GridSelect
import Config

    
getColor color _ isFg = do
    return $ if isFg
              then (color,"#000000")
              else ("#282c34","#FFFFFF")

myColorizer = getColor "#82AAFF"

myGridConfig x = (buildDefaultGSConfig x)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

--goToGrid = goToSelected (myGridConfig myAppGrid)
--goBringGrid = bringSelected (myGridConfig myColorizer) myAppGrid
--spawnGrid = runSelectedAction (myGridConfig myAppGrid) myAppGrid
spawnGrid = runSelectedAction (myGridConfig myColorizer) myAppGrid

myAppGrid = [
               ("Ungoogled Chromium", spawn "chromium")
             , ("Qutebrowser", spawn "qutebrowser")
             , ("Thunderbird", spawn "thunderbird")
             , ("Emacs", spawn "emacsclient -c -a emacs")
             , ("Ranger", spawn "alacritty --class Ranger -e ranger")
             , ("LibreOffice Writer", spawn "lowriter")
             , ("Thunar", spawn "thunar")
             , ("KeePassXC", spawn "keepassxc")
             , ("Gedit", spawn "gedit")
             , ("Newsboat RSS", spawn (myTerminal <> " --class 'newsboat' newsboat"))
             , ("Remmina", spawn "remmina")
             , ("Deja-Dup Backup", spawn "deja-dup")
             , ("PavuControl Volume", spawn "pavucontrol")
             , ("ncmpcpp Music player", spawn (myTerminal <> " --class 'ncmpcpp'  ncmpcpp"))
             ]
