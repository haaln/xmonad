import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Layout.SimpleFloat

import Hooks.Startup
import Config
import Layout
import Manage
import Workspaces
import Keybinds
import Event
import Log

main :: IO ()
main = do
    xmproc0 <- spawnPipe "xmobar $HOME/.config/xmonad/lib/xmobar1.hs"
    xmproc1 <- spawnPipe "xmobar $HOME/.config/xmonad/lib/xmobar2.hs"

    xmonad $ ewmh $ ewmhFullscreen $ docks $ def
     { manageHook         = myManageHook
     , handleEventHook    = myEventHook
     , modMask            = myModMask
     , terminal           = myTerminal
     , startupHook        = myStartupHook
     , layoutHook         = myLayoutHook 
     , workspaces         = myWorkspaces
     , borderWidth        = myBorderWidth
     , normalBorderColor  = myNormColor
     , focusedBorderColor = myFocusColor
     , logHook            = myLogHook <+> dynamicLogWithPP myXmobarPP
     { ppOutput = \x -> hPutStrLn xmproc0 x  >> hPutStrLn xmproc1 x }
     } `additionalKeysP` myKeys
