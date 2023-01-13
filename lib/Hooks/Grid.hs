module Hooks.Grid where

import XMonad
import XMonad.Util.EZConfig 
import XMonad.Layout.GridVariants 
import XMonad.Actions.GridSelect
import qualified XMonad.StackSet as W
import Workspaces
import Config

myColorizer = anyColor "#82AAFF"
   where
    anyColor color _ isFg = do
    return $ if isFg
             then (color,"#000000")
             else ("#282c34","#FFFFFF")

myGridConfig x = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

goToGrid = goToSelected (myGridConfig myAppGrid)
goBringGrid = bringSelected (myGridConfig myAppGrid)
spawnGrid = runSelectedAction (myGridConfig myAppGrid) myAppGrid

myAppGrid = [
               ("Ungoogled Chromium", spawn "chromium")
             , ("Qutebrowser", spawn "qutebrowser")
             , ("RuneLite", spawn "runelite")
             , ("qBittorent", spawn "qbittorrent")
             , ("Ranger", spawn (myTerminal <> " -e ranger"))
             , ("Steam", spawn "steam")
             , ("Thunderbird", spawn "thunderbird")
             , ("OBS", spawn "obs")
             , ("Emacs", spawn "emacsclient -c -a emacs")
             , ("LibreOffice Writer", spawn "lowriter")
             , ("Virt Manager", spawn "virt-manager")
             , ("Web Browser", spawn myBrowser)
             , ("Mupen64Plus Emulator", spawn "m64py")
             , ("IntelliJ IDEA", spawn "idea")
             , ("Visual Studio Code", spawn "code")
             , ("KeePassXC", spawn "keepassxc")
             , ("Kate Text Editor", spawn "kate")
             , ("Tauon Music Box", spawn "tauon")
             , ("Newsboat RSS", spawn (myTerminal <> " --class 'newsboat' -e newsboat"))
             , ("Remmina", spawn "remmina")
             , ("Deja-Dup Backup", spawn "deja-dup")
             , ("PavuControl Volume", spawn "pavucontrol")
             , ("ncmpcpp Music player", spawn (myTerminal <> " --class 'ncmpcpp' -e ncmpcpp"))
             , ("Brave", spawn "brave")
             , ("Thunar", spawn "thunar")
             , ("Doplhin Emulator", spawn "dolphin-emu")
             , ("Firefox", spawn "firefox")
             , ("Claws Mail", spawn "claws-mail")
             ]
