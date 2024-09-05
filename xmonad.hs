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

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

main :: IO ()
main = do
    xmproc <- spawnPipe "xmobar $HOME/.config/xmonad/lib/xmobar.hs"

    xmonad $ ewmhFullscreen $ ewmh $ docks $ def
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
     { ppOutput = \x -> hPutStrLn xmproc x }
     } `additionalKeysP` myKeys
