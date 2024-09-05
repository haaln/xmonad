module Hooks.Startup where

import XMonad
import XMonad.Util.SpawnOnce
import XMonad.Util.Cursor
--import XMonad.Hooks.SetWMName

myStartupHook :: X ()
myStartupHook = do
          spawnOnce "$HOME/.config/picom/picom.sh &"
          spawnOnce "xfce4-power-manager &"
          spawnOnce "nitrogen --restore &"
          spawnOnce "nm-applet &"
--        spawnOnce "keepassxc &"

          setDefaultCursor xC_left_ptr
          --setWMName "LG3D"
