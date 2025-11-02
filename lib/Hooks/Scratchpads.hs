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
myScratchPads = [ NS "terminal" (myTerminal <> " --class 'scratchpad' --title 'Scratchpad'") (className =? "scratchpad") forceBigFloat
                , NS "calculator" "speedcrunch" (className =? "speedcrunch") forceCalcFloat
                , NS "OBS" "obs" (className =? "obs") doFloat
                , NS "newsboat" (myTerminal <> " --class 'newsboat' -e newsboat") (className =? "newsboat") forceMediumFloat
                , NS "keepassxc" "keepassxc" (className =? "KeePassXC") forceBigFloat
                , NS "thunderbird" "thunderbird" (className =? "thunderbird") forceBigFloat
                , NS "pavucontrol" "pavucontrol" (className =? "pavucontrol") forceMediumFloat
                ]
