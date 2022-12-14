module Hooks.Scratchpads
  ( myScratchPads
  , namedScratchpadAction
  , namedScratchpadManageHook
  ) where
    
import XMonad
import XMonad.Util.NamedScratchpad
import Data.List (isInfixOf)

import Hooks.ForceFloat
import Config

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" (myTerminal <> " --class 'scratchpad'") (className =? "scratchpad") forceBigFloat
                , NS "tauonmb" "tauon" (className =? "Tauon Music Box") forceBigFloat
                , NS "calculator" "qalculate-gtk" (className =? "Qalculate-gtk") forceSmallFloat
                , NS "OBS" "obs" (className =? "obs")  forceBigFloat
                , NS "ncmpcpp" (myTerminal <> " --class 'ncmpcpp' ncmpcpp")  (className =? "ncmpcpp") forceMediumFloat
                , NS "newsboat" (myTerminal <> " --class 'newsboat' newsboat") (className =? "newsboat") forceMediumFloat
                , NS "keepassxc" "keepassxc" (className =? "KeePassXC") forceBigFloat
                ]
