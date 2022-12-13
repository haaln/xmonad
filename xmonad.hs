import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig
import XMonad.Util.Run

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
    xmproc0 <- spawnPipe "xmobar $HOME/.config/xmobar/xmobarrc0"
    xmproc1 <- spawnPipe "xmobar $HOME/.config/xmobar/xmobarrc1"

    xmonad $ ewmhFullscreen . docks $ def
     { manageHook         = myManageHook
     ,handleEventHook     = myEventHook
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
