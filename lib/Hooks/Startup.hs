module Hooks.Startup where

import XMonad
import XMonad.Util.SpawnOnce
import XMonad.Util.Cursor
import XMonad.Hooks.SetWMName

myStartupHook :: X ()
myStartupHook = do
          spawnOnce "$HOME/.config/layout.sh &"
          spawnOnce "picom --config $HOME/.config/picom/picom.conf &"
          spawnOnce "/usr/bin/pipewire &"
          spawnOnce "/usr/bin/pipewire-pulse &"
          spawnOnce "/usr/bin/wireplumber &"
          setDefaultCursor xC_left_ptr
