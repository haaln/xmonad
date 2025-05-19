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
             , ("Emacs", spawn "emacsclient -c -a emacs")
             , ("Steam", spawn "steam")
             , ("Ranger", spawn (myTerminal <> " -e ranger"))
             , ("VS Codium", spawn "vscodium")
             , ("LibreOffice Writer", spawn "lowriter")
             , ("Virt Manager", spawn "virt-manager")
             , ("IntelliJ IDEA", spawn "idea")
             , ("Thunderbird", spawn "thunderbird")
             , ("PavuControl Volume", spawn "pavucontrol")
             , ("Newsboat RSS", spawn (myTerminal <> " --class 'newsboat' -e newsboat"))
             , ("Deja-Dup Backup", spawn "deja-dup")
             , ("Thunar", spawn "thunar")
             ]

myColorizer = anyColor color07
  where
        anyColor color _ isFg = do
              return $ if isFg
              then (color,color01)
              else (colorBack,color16)
