module Hooks.Grid where

import XMonad
import XMonad.Util.EZConfig 
import XMonad.Layout.GridVariants 
import XMonad.Actions.GridSelect
import qualified XMonad.StackSet as W
import Workspaces
import Config
import Colors.Winter

myColorizer = anyColor color07
   where
    anyColor color _ isFg = do
    return $ if isFg
             then (color,color01)
             else (colorBack,color16)

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
               ("Librewolf", spawn "librewolf")
             , ("Ungoogled Chromium", spawn "chromium")
             , ("RuneLite", spawn "runelite")
             , ("Steam", spawn "steam")
             , ("Ranger", spawn (myTerminal <> " -e ranger"))
             , ("Qutebrowser", spawn "qutebrowser")
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
             , ("qBittorent", spawn "qbittorrent")
             ]
