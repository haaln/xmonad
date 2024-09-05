{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MultiParamTypeClasses #-}
module Event where

import XMonad
import XMonad.Layout.Fullscreen
import XMonad.Layout.MultiToggle
import XMonad.Layout.Tabbed
import XMonad.Layout.SubLayouts
import XMonad.Layout.Simplest
import XMonad.Hooks.ServerMode
import XMonad.Hooks.ManageDocks 
import XMonad.Hooks.EwmhDesktops 

import Hooks.Swallow
import Config

-- for reference, the following line is the same as dynamicTitle myDynHook
-- <+> dynamicPropertyChange "WM_NAME" myDynHook

-- alternatives:
-- ewmhFullscreen on xmonad.hs, newer, same as true fullscreen
-- <+> XMonad.Layout.Fullscreen.fullscreenEventHook  -- contains fullscreen into a window
-- <+> XMonad.Hooks.EwmhDesktops.fullscreenEventHook -- true fullscreen, depreciated

myEventHook = serverModeEventHookCmd
                               <+> serverModeEventHook
                               <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                               <+> handleEventHook def
                               <+> XMonad.Layout.Fullscreen.fullscreenEventHook  -- contains fullscreen into a window
--                               <+> XMonad.Hooks.EwmhDesktops.fullscreenEventHook
--                               <+> XMonad.Layout.Fullscreen.fullscreenEventHook
                               <+> swallowHook

-- Transform layout modifier into a toggle-able
enableTabs x = addTabs shrinkText myTabTheme $ subLayout [] Simplest x
data ENABLETABS = ENABLETABS deriving (Read, Show, Eq, Typeable)
instance Transformer ENABLETABS Window where
