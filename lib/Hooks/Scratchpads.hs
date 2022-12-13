module Hooks.Scratchpads
  ( myScratchPads
  , namedScratchpadAction
  , namedScratchpadManageHook
  ) where
    
import XMonad
import XMonad.Util.NamedScratchpad
import Data.List (isInfixOf)

import Hooks.ForceFloat

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" "alacritty -t scratchpad" (title =? "scratchpad") forceBigFloat
                , NS "tauonmb" "tauon" (className =? "Tauon Music Box") forceBigFloat
                , NS "calculator" "qalculate-gtk" (className =? "Qalculate-gtk") forceTinyFloat
                , NS "OBS" "obs" (className =? "obs")  forceBigFloat
                , NS "ncmpcpp" ("alacritty -t ncmpcpp -e ncmpcpp")  findNcmpcpp forceMediumFloat
                , NS "newsboat" "Newsboat.sh" (title =? "Newsboat") forceMediumFloat
                ]
                  where
                   findNcmpcpp   =  fmap ( "ncmpcpp" `isInfixOf`) title <&&> className =? "alacritty"
