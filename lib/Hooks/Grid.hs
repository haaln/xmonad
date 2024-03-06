module Hooks.Grid where

import XMonad
import XMonad.Util.EZConfig 
import XMonad.Layout.GridVariants 
import XMonad.Actions.GridSelect
import qualified XMonad.StackSet as W
import Workspaces
import Config
import Colors.Winter

import Hooks.Scratchpads

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
--           , ("Librewolf", spawn "librewolf")
             , ("Emacs", spawn "emacsclient -c -a emacs")
             , ("Steam", spawn "steam")
             , ("Qutebrowser", spawn "qutebrowser")
             , ("Ranger", spawn (myTerminal <> " -e ranger"))
             , ("VS Codium", spawn "vscodium")
             , ("OBS", namedScratchpadAction myScratchPads "OBS")
             , ("LibreOffice Writer", spawn "lowriter")
             , ("Virt Manager", spawn "virt-manager")
             , ("qBittorent", spawn "qbittorrent")
             , ("PavuControl Volume", spawn "pavucontrol")
--           , ("Web Browser", spawn myBrowser)
--           , ("Mupen64Plus Emulator", spawn "m64py")
             , ("IntelliJ IDEA", spawn "idea")
             , ("KeePassXC", spawn "keepassxc")
             , ("Thunderbird", spawn "thunderbird")
             , ("Kate Text Editor", spawn "kate")
             , ("Manga Reader", spawn "mangareader")
             , ("Newsboat RSS", spawn (myTerminal <> " --class 'newsboat' -e newsboat"))
             , ("Remmina", spawn "remmina")
             , ("Deja-Dup Backup", spawn "deja-dup")
             , ("Blender", spawn "blender")
             , ("ncmpcpp Music player", spawn (myTerminal <> " --class 'ncmpcpp' -e ncmpcpp"))
             , ("Doplhin Emulator", spawn "dolphin-emu")
--           , ("Brave", spawn "brave")
             , ("Thunar", spawn "thunar")
--           , ("Firefox", spawn "firefox")
             , ("Claws Mail", spawn "claws-mail --alternate-config-dir $XDG_CONFIG_HOME/claws-mail")
             , ("RuneLite", spawn "runelite")
             ]

myColorizer = anyColor color07
  where
        anyColor color _ isFg = do
              return $ if isFg
              then (color,color01)
              else (colorBack,color16)
