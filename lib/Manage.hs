module Manage where

import XMonad

import qualified XMonad.StackSet as W
import XMonad.Actions.WindowGo (liftX)
import Data.List (isInfixOf)
import Control.Monad (liftM2)
import XMonad.Hooks.ManageHelpers 
import XMonad.Hooks.ManageDocks 
import XMonad.Layout.Fullscreen
import XMonad.Actions.SpawnOn

import Workspaces
import Hooks.Scratchpads
import Hooks.ForceFloat

myManageHook :: ManageHook
myManageHook = 
     manageRules
 <+> manageDocks
 <+> namedScratchpadManageHook myScratchPads
 <+> fullscreenManageHook
 <+> manageSpawn
 where
  manageRules = composeAll . concat $
   [ [transience']
   , [isDialog --> doCenterFloat]
   , [isFullscreen --> doFullFloat]
   , [matchAny x <&&> title /=? x --> doFloat    | x <- myTFloats]
   , [matchAny x --> forceBigFloat               | x <- myBFloats]
   , [matchAny x --> forceMediumFloat            | x <- myMFloats]
   , [matchAny x --> forceSmallFloat             | x <- mySFloats]
   , [matchAny x --> doFloat                     | x <- myFloats]
   , [matchAny x --> doFloat                     | x <- myInfixOf]
   , [matchAny x --> doIgnore                    | x <- myIgnores]
   , [matchAny x --> doShift (myWorkspaces !! 0) | x <- www]
   , [matchAny x --> doShift (myWorkspaces !! 1) | x <- term]
   , [matchAny x --> doShift (myWorkspaces !! 2) | x <- file]
   , [matchAny x --> doShift (myWorkspaces !! 3) | x <- dev]
   , [matchAny x --> doShift (myWorkspaces !! 4) | x <- misc]
   , [matchAny x --> doShift (myWorkspaces !! 5) | x <- win]
   , [matchAny x --> doShift (myWorkspaces !! 7) | x <- tex]
   , [matchAny x --> doShift (myWorkspaces !! 6) | x <- kvm]
   , [matchAny x --> doShift (myWorkspaces !! 8) | x <- game]
   , [namedScratchpadManageHook myScratchPads]
   ]
   where
    matchAny :: String -> Query Bool
    matchAny s = appName =? s <||> className =? s <||> resource =? s <||> title =? s 
     <||> stringProperty "WM_WINDOW_ROLE" =? s 
     <||> stringProperty "_NET_WM_WINDOW_ROLE" =? s 
     <||> stringProperty "WM_WINDOW_TYPE" =? s
     <||> stringProperty "_NET_WM_WINDOW_TYPE" =? s 
     <||> stringProperty "_OL_DECOR_DEL" =? s 
     <||> stringProperty "WM_ICON_NAME" =? s
     <||> stringProperty "_NET_WM_ICON_NAME" =? s

    q ~? x = fmap (x `isInfixOf`) q

    --doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift
    unfloat = ask >>= doF . W.sink

    myBFloats = [ "eog"]
    myMFloats = [ "org.gnome.DejaDup", "nsxiv", "pavucontrol" ]
    mySFloats = [ "Virtual Machine Manager" ]
    myInfixOf = [ "Edge Webview2", "wine", "Wine" ]
    myTFloats = [ "Steam"]
    myIgnores = [ "conky", "desktop_window", "kdesktop", "Picture in Picture", "Picture-in-Picture"]
    www       = [ "Brave-browser", "Chromium", "qutebrowser", "chromium-browser", "firefox", "LibreWolf" ]
    term      = [ ]
    file      = [ "Thunar","Org.gnome.Nautilus","PCManFM","Ranger","lf"]
    dev       = [ "Code","Emacs","org.remmina.Remmina", "jetbrains-idea-ce" ]
    misc      = [ "megasync", "qBittorrent","transmission"]
    win       = [ ]
    tex       = [ ]
    kvm       = [ ]
    game      = [ "Steam", "VirtualBox", "Wine", "net-runelite-client-RuneLite", "net-runelite-client-Launcher", "m64py" ]
    myFloats  = [ "pop-up", "floating", "dialog", "Places", "File Operation Progress", "Gcr-Prompter", "All Files", "xdg-desktop-portal-gnome", "menu", "center", "GtkFileChooserDialog", "_NET_WM_WINDOW_TYPE_SPLASH", "_OL_DECOR_CLOSE", "_NET_WM_WINDOW_TYPE_DIALOG", "VirtualBox Machine", "VirtualBox Manager", "Zoom", "Virtual Machine Manager", "nsxiv", "sxiv", "megasync", "mpv", "m64py", "RuneLite Launcher", "Picture in Picture", "org.gnome.DejaDup", "page-info"]


-- , [matchAny "no-focus" --> doF W.focusDown]
-- , [matchAny "floating" --> doCenterFloat <+> doF W.focusDown]

