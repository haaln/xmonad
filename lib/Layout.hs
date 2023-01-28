module Layout where

import XMonad
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows 
import XMonad.Layout.Fullscreen
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle 
import XMonad.Layout.MultiToggle.Instances 
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed 
import XMonad.Layout.ShowWName
import XMonad.Layout.SubLayouts
import XMonad.Layout.Simplest
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Spacing
import XMonad.Layout.WindowNavigation
import XMonad.Layout.WindowArranger 
import qualified XMonad.Layout.MultiToggle as MT 
import qualified XMonad.Layout.ToggleLayouts as T 

import XMonad.Actions.MouseResize

import XMonad.Hooks.ManageDocks

import XMonad.Layout.GridVariants 
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.IM

import Config

myLayoutHook = avoidStruts 
             $ smartBorders  
             $ mouseResize 
             $ windowArrange 
             $ T.toggleLayouts floats 
             $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout 
               
             where
               myDefaultLayout =         
                                        tall
                                    ||| noBorders tabs
                                 -- ||| spirals
                                 -- ||| threeCol
                                 -- ||| threeRow
                                 -- ||| noBorders monocle
                                 -- ||| floats
                                 -- ||| monocle
                                 -- ||| grid
                                 -- ||| magnifyy

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

tall     = renamed [Replace "stack"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing mySpacingWidth
           $ ResizableTall 1 (3/100) (1/2) []
tabs     = renamed [Replace "tabs"]
           -- $ tabbed shrinkText myTabConfig
           $ tabbed shrinkText myTabTheme
spirals  = renamed [Replace "spirals"]
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing' mySpacingWidth
           $ spiral (6/7)
magnifyy  = renamed [Replace "magnify"]
           $ subLayout [] (smartBorders Simplest)
           $ magnifier
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing mySpacingWidth
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
threeCol = renamed [Replace "threeCol"]
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing mySpacingWidth
           $ ThreeCol 1 (3/100) (1/2)
threeRow = renamed [Replace "threeRow"]
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing mySpacingWidth
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)


