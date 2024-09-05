module Config where

import XMonad
import XMonad.Prompt
import XMonad.Prompt.FuzzyMatch
import XMonad.Layout.Tabbed
import XMonad.Hooks.DynamicLog

import Colors.DoomOne

myFont :: String
myFont = "xft:JetBrainsMono NF:size=11:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask       

myTerminal :: String
myTerminal = "alacritty" 
myTerminalClass = "Alacritty" --lazy swallow fix

myBrowser :: String
myBrowser = "qutebrowser"

myEditor :: String
myEditor = "vim"

myBorderWidth :: Dimension
myBorderWidth = 1

mySpacingWidth :: Integer
mySpacingWidth = 6

myNormColor :: String
myNormColor   = colorBack

myFocusColor :: String
myFocusColor  = color17  

altMask :: KeyMask
altMask = mod1Mask         

dtXPConfig :: XPConfig
dtXPConfig = def
      { font                = myFont
      , bgColor             = "#282c34"
      , fgColor             = "#bbc2cf"
      , bgHLight            = "#82AAFF"
      , fgHLight            = "#000000"
      , borderColor         = "#535974"
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
      { autoComplete = Nothing }

myTabTheme = def { fontName            = myFont
                 , activeColor         = color15
                 , inactiveColor       = color08
                 , activeBorderColor   = color15
                 , inactiveBorderColor = colorBack
                 , activeTextColor     = colorBack
                 , inactiveTextColor   = "#b3afc2" -- color16
                 }

myTabConfig = def { fontName            = myFont
                  , activeColor         = "#282c34"
                  , inactiveColor       = "#3e445e"
                  , activeBorderColor   = "#282c34"
                  , inactiveBorderColor = "#282c34"
                  , activeTextColor     = "#ffffff"
                  , inactiveTextColor   = "#d0d0d0"
                  }

myXmobarPP =  def
          { ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]" 
          , ppVisible = xmobarColor "#98be65" ""
          , ppHidden = xmobarColor "#82AAFF" "" . wrap "" ""
          , ppHiddenNoWindows = xmobarColor "#0C4E7C" ""
          , ppTitle = xmobarColor "#b3afc2" "" . shorten 30
          , ppSep =  " | "
          , ppUrgent = xmobarColor "C45500" "" . wrap "!" "!"  
          , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
          }
