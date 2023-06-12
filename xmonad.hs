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

import XMonad.Hooks.UrgencyHook
import qualified XMonad.StackSet as W
import XMonad.Util.NamedWindows

data LibNotifyUrgencyHook =
  LibNotifyUrgencyHook
  deriving (Read,Show)
instance UrgencyHook LibNotifyUrgencyHook where
  urgencyHook LibNotifyUrgencyHook w =
    do name <- getName w
       wins <- gets windowset
       whenJust (W.findTag w wins)
                (flash name)
    where flash name index = spawn $
                             "notify-send " ++
                             "'Workspace " ++
                             index ++
                             "' " ++ "'Activity in: " ++ show name ++ "' "
-- alternative 
--
-- data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)
-- instance UrgencyHook LibNotifyUrgencyHook where
--     urgencyHook LibNotifyUrgencyHook w = do
--         name     <- getName w
--         Just idx <- fmap (W.findTag w) $ gets windowset
-- 
--         safeSpawn "notify-send" [show name, "workspace " ++ idx]

myUrgencyHook =
  withUrgencyHook LibNotifyUrgencyHook

main :: IO ()


main = do
    xmproc0 <- spawnPipe "xmobar $HOME/.config/xmonad/lib/xmobar1.hs"
    xmproc1 <- spawnPipe "xmobar $HOME/.config/xmonad/lib/xmobar2.hs"

    xmonad $ ewmh $ ewmhFullscreen $ docks $ myUrgencyHook $ def
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
