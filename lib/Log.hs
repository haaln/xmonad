module Log where

import XMonad
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.WorkspaceHistory

myLogHook :: X ()
myLogHook = 
     workspaceHistoryHook
 <+> fadeInactiveLogHook fadeAmount
      where
       fadeAmount = 1.0
