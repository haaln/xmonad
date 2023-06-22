module Hooks.Startup where

import XMonad
import XMonad.Util.SpawnOnce
import XMonad.Util.Cursor
import XMonad.Hooks.SetWMName

myStartupHook :: X ()
myStartupHook = do
--        spawnOnce "conky &"
          spawnOnce "$HOME/.config/layout.sh &"
          spawnOnce "picom --config $HOME/.config/picom/picom.conf &"
--        spawnOnce "imwheel &"
--        spawnOnce "xfce4-power-manager &"
--        spawnOnce "nitrogen --restore &"
--        spawnOnce "keepassxc &"

          setDefaultCursor xC_left_ptr
--        setWMName "LG3D"
