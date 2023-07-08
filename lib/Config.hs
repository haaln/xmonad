module Config where

import XMonad
import XMonad.Prompt
import XMonad.Prompt.FuzzyMatch
import XMonad.Layout.Tabbed
import XMonad.Hooks.DynamicLog


import Colors.Winter

myFont :: String
myFont = "xft:JetBrains Mono:size=14:antialias=true:hinting=true"
myTabFont = "xft:JetBrains Mono:size=12:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask       

myTerminal :: String
myTerminal = "alacritty" 
myTerminalClass = "Alacritty"

myBrowser :: String
myBrowser = "librefox"

myEditor :: String
myEditor = "vim"

myBorderWidth :: Dimension
myBorderWidth = 1

mySpacingWidth :: Integer
mySpacingWidth = 4

myNormColor :: String
myNormColor   = colorBack

myFocusColor :: String
myFocusColor  = color08

altMask :: KeyMask
altMask = mod1Mask         

dtXPConfig :: XPConfig
dtXPConfig = def
      { font                = myFont
      , bgColor             = colorBack
      , fgColor             = colorFore
      , bgHLight            = color07 
      , fgHLight            = color01 
      , borderColor         = color15
      , promptBorderWidth   = 0
      , position            = Top
      , height              = 20
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , autoComplete        = Just 100000
      , showCompletionOnTab = False
      , searchPredicate     = fuzzyMatch
      , alwaysHighlight     = True
      , maxComplRows        = Nothing      
      }

dtXPConfig' :: XPConfig
dtXPConfig' = dtXPConfig
      { autoComplete        = Nothing
      }

myTabTheme = def { fontName            = myTabFont
                 , activeColor         = color01
                 , inactiveColor       = colorBack
                 , activeBorderColor   = color01
                 , inactiveBorderColor = colorBack
                 , activeTextColor     = color16
                 , inactiveTextColor   = color09
                 }

myXmobarPP =  def
          { ppCurrent = xmobarColor color03 "" . wrap "[" "]" 
          , ppVisible = xmobarColor color03 ""
          , ppHidden = xmobarColor color07 "" . wrap "" ""
          , ppHiddenNoWindows = xmobarColor color13 ""
          , ppTitle = xmobarColor colorFore "" . shorten 120
          , ppSep = "<fc=#666666> <fn=2>|</fn> </fc>"
          , ppUrgent = xmobarColor color10 "" . wrap "!" "!"  
          , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
          }
