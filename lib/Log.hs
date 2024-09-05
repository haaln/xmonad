module Log where

import XMonad
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.DynamicLog

myLogHook :: X ()
myLogHook = 
     workspaceHistoryHook
 <+> fadeInactiveLogHook fadeAmount
      where
       fadeAmount = 1.0
