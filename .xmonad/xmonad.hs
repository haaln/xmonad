{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleContexts #-}
{-# OPTIONS_GHC -Wno-deprecations #-}

  -- Base
import XMonad
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow 
import XMonad.Actions.GroupNavigation
import XMonad.Actions.CycleWS 
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.SpawnOn
import XMonad.Actions.RotSlaves 
import qualified XMonad.Actions.TreeSelect as TS
import XMonad.Actions.WindowGo 
import XMonad.Actions.WithAll 
import qualified XMonad.Actions.Search as S
import XMonad.Actions.FloatKeys

    -- Data
import Data.Char 
import Data.Monoid (All)
import Data.Maybe 
import Data.Tree
import qualified Data.Map as M

    -- Hooks
import XMonad.Hooks.WindowSwallowing
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops 
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks 
import XMonad.Hooks.ManageHelpers 
import XMonad.Hooks.ServerMode
import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.SetWMName

    -- Layouts
import XMonad.Layout.GridVariants 
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Fullscreen
import XMonad.Layout.LimitWindows 
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle 
import XMonad.Layout.MultiToggle.Instances 
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed 
import XMonad.Layout.ShowWName
import XMonad.Layout.SubLayouts
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.WindowNavigation
import XMonad.Layout.WindowArranger 
import qualified XMonad.Layout.ToggleLayouts as T 
import qualified XMonad.Layout.MultiToggle as MT 

    -- Prompt
import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Man
import XMonad.Prompt.Pass
import XMonad.Prompt.Shell 
import XMonad.Prompt.Ssh
import XMonad.Prompt.XMonad
import Control.Arrow (first)

   -- Utilities
import XMonad.Util.EZConfig 
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run 
import XMonad.Util.SpawnOnce
import XMonad.Util.Cursor
import qualified XMonad.Util.ExtensibleState as XS

   -- ColorScheme module (SET ONLY ONE!)
      -- Possible choice are:
      -- DoomOne
      -- Dracula
      -- GruvboxDark
      -- MonokaiPro
      -- Nord
      -- OceanicNext
      -- Palenight
      -- SolarizedDark
      -- SolarizedLight
      -- TomorrowNight
import Colors.DoomOne


myFont :: String
myFont = "xft:JetBrains Mono:size=14:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask       -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "alacritty"   -- Sets default terminal

myBrowser :: String
--myBrowser = "chromium"               -- Sets browser for tree select
--myBrowser = "flatpak run com.github.Eloston.UngoogledChromium"               -- Sets browser for tree select
myBrowser = "ungoogled-chromium"

myEditor :: String
myEditor = "emacsclient -c -a emacs "  -- Sets editor for tree select

myBorderWidth :: Dimension
myBorderWidth = 1          -- Sets border width for windows

myNormColor :: String
--myNormColor   = colorBack
myNormColor   = "#282c34"  -- Border color of normal windows

myFocusColor :: String
--myFocusColor  = color15
myFocusColor  = "#bbc5ff"  -- Border color of focused windows

 --myMouse x  = [ (0, button4), (\w -> focus w >> kill) ]
 --newMouse x = M.union (mouseBindings def x) (M.fromList (myMouse x))

altMask :: KeyMask
altMask = mod1Mask         -- Setting this for use in xprompts

windowCount :: X (Maybe String)
windowCount = XMonad.gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myStartupHook :: X ()
myStartupHook = do
          spawnOnce "./.config/layout.sh &"
          spawnOnce "~/.config/compton.sh &"
          spawnOnce "imwheel &"
          spawnOnce "xfce4-power-manager &"
          spawnOnce "xinput --set-prop 9 158 1.2 0 0 0 1.2 0 0 0 1 &"
       -- spawnOnce "bash Documents/random/bash/mouse_scroll_speed.sh &"
          spawnOnce "nitrogen --head=0 --random --set-zoom-fill"
          spawnOnce "nitrogen --head=1 --random --set-zoom-fill"

          setDefaultCursor xC_left_ptr
          setWMName "LG3D"
          
myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x28,0x2c,0x34) -- lowest inactive bg
                  (0x28,0x2c,0x34) -- highest inactive bg
                  (0x82,0xAA,0xFF) -- active bg
                  (0xFF,0xFF,0xFF) -- inactive fg
                --(0xc0,0xa7,0x9a) -- inactive fg
                  (0x28,0x2c,0x34) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect gs_conf lst >>= flip whenJust spawn

spawnApp = runSelectedAction (myGSConfig blue) myAppGrid2

myGSConfig colorizer = (buildDefaultGSConfig colorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

-- blue   = anyColor "#41557f"
blue   = anyColor "#82AAFF"

anyColor color _ isFg = do
    return $ if isFg
             then (color,"#000000")
             else ("#282c34","#FFFFFF")

gs_conf = def
           { gs_cellheight   = 40
           , gs_cellwidth    = 200
           , gs_cellpadding  = 6
           , gs_originFractX = 0.5
           , gs_originFractY = 0.5
           , gs_font         = myFont
           , gs_bordercolor  = "#BBC5FF"
           }
myAppGrid2 = [("Qutebrowser", spawn "qutebrowser")
             , ("Firefox", spawn "firefox")
             , ("RuneLite", spawn "RuneLite")
             , ("qBittorent", spawn "qbittorrent")
             , ("Mupen64Plus", spawn "alacritty -e $HOME/Documents/projects/m64p/mupen64plus/mupen64plus-gui")
             , ("Steam", spawn "steam")
             , ("Thunderbird", spawn "thunderbird")
             , ("OBS", spawn "obs")
             , ("Emacs", spawn "emacsclient -c -a emacs")
             , ("LibreOffice Writer", spawn "lowriter")
             , ("Virt Manager", spawn "virt-manager")
             , ("Web Browser", spawn myBrowser)
             , ("Thunar", spawn "thunar")
             , ("IntelliJ IDEA", spawn "intellij-idea-community")
             , ("Visual Studio Code", spawn "code")
             ] 

-- obsolete gotta remove some year
myAppGrid = [ ("Tauonmb", "flatpak run com.github.taiko2k.tauonmb")
             , ("qBittorrent", "qbittorrent")
             , ("Mupen64Plus", "alacritty -e ~/Documents/projects/m64p/mupen64plus/mupen64plus-gui")
             , ("Zoom", "zoom")
             , ("OBS", "obs")
             , ("Emacs", "emacsclient -c -a emacs")
             , ("LibreOffice Writer", "lowriter")
             ]
-- end obsolete

dtXPConfig :: XPConfig
dtXPConfig = def
      { font                = myFont
      , bgColor             = "#282c34"
      , fgColor             = "#bbc2cf"
      , bgHLight            = "#c792ea"
      , fgHLight            = "#000000"
      , borderColor         = "#535974"
      , promptBorderWidth   = 0
      , promptKeymap        = dtXPKeymap
      , position            = Top
--    , position            = CenteredAt { xpCenterY = 0.3, xpWidth = 0.3 }
      , height              = 20
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , autoComplete        = Just 100000  -- set Just 100000 for .1 sec
      , showCompletionOnTab = False
      -- , searchPredicate     = isPrefixOf
      , searchPredicate     = fuzzyMatch
      , alwaysHighlight     = True
      , maxComplRows        = Nothing      -- set to Just 5 for 5 rows
      }

-- The same config above minus the autocomplete feature which is annoying
-- on certain Xprompts, like the search engine prompts.
dtXPConfig' :: XPConfig
dtXPConfig' = dtXPConfig
      { autoComplete        = Nothing
      }

-- A list of all of the standard Xmonad prompts and a key press assigned to them.
-- These are used in conjunction with keybinding I set later in the config.
promptList :: [(String, XPConfig -> X ())]
promptList = [ ("m", manPrompt)          -- manpages prompt
             , ("p", passPrompt)         -- get passwords (requires 'pass')
             , ("g", passGeneratePrompt) -- generate passwords (requires 'pass')
             , ("r", passRemovePrompt)   -- remove passwords (requires 'pass')
             , ("s", sshPrompt)          -- ssh prompt
             , ("x", xmonadPrompt)       -- xmonad prompt
             ]

-- Same as the above list except this is for my custom prompts.
promptList' :: [(String, XPConfig -> String -> X (), String)]
promptList' = [ ("c", calcPrompt, "qalc")         -- requires qalculate-gtk
              ]

calcPrompt c ans =
    inputPrompt c (trim ans) ?+ \input ->
        liftIO(runProcessWithInput "qalc" [input] "") >>= calcPrompt c
    where
        trim  = f . f
            where f = reverse . dropWhile isSpace

dtXPKeymap :: M.Map (KeyMask,KeySym) (XP ())
dtXPKeymap = M.fromList $
     map (first $ (,) controlMask)   -- control + <key>
     [ (xK_z, killBefore)            -- kill line backwards
     , (xK_k, killAfter)             -- kill line forwards
     , (xK_a, startOfLine)           -- move to the beginning of the line
     , (xK_e, endOfLine)             -- move to the end of the line
     , (xK_m, deleteString Next)     -- delete a character foward
     , (xK_b, moveCursor Prev)       -- move cursor forward
     , (xK_f, moveCursor Next)       -- move cursor backward
     , (xK_BackSpace, killWord Prev) -- kill the previous word
     , (xK_y, pasteString)           -- paste a string
     , (xK_g, quit)                  -- quit out of prompt
     , (xK_bracketleft, quit)
     ]
     ++
     map (first $ (,) altMask)       -- meta key + <key>
     [ (xK_BackSpace, killWord Prev) -- kill the prev word
     , (xK_f, moveWord Next)         -- move a word forward
     , (xK_b, moveWord Prev)         -- move a word backward
     , (xK_d, killWord Next)         -- kill the next word
     , (xK_n, moveHistory W.focusUp')   -- move up thru history
     , (xK_p, moveHistory W.focusDown') -- move down thru history
     ]
     ++
     map (first $ (,) 0) -- <key>
     [ (xK_Return, setSuccess True >> setDone True)
     , (xK_KP_Enter, setSuccess True >> setDone True)
     , (xK_BackSpace, deleteString Prev)
     , (xK_Delete, deleteString Next)
     , (xK_Left, moveCursor Prev)
     , (xK_Right, moveCursor Next)
     , (xK_Home, startOfLine)
     , (xK_End, endOfLine)
     , (xK_Down, moveHistory W.focusUp')
     , (xK_Up, moveHistory W.focusDown')
     , (xK_Escape, quit)
     ]

------------------------------------------------------------------------
-- SEARCH ENGINES
-- Xmonad contrib has several search engines available to use, located in
-- XMonad.Actions.Search. Additionally, you can add other search engines.

archwiki :: S.SearchEngine
archwiki = S.searchEngine "archwiki" "https://wiki.archlinux.org/index.php?search="

-- This is the list of search engines that I want to use. Some are from
-- XMonad.Actions.Search, and some are the ones that I added above.
searchList :: [(String, S.SearchEngine)]
searchList = [ ("a", archwiki)
             , ("d", S.duckduckgo)
             , ("h", S.hoogle)
             , ("i", S.images)
             , ("s", S.stackage)
             , ("w", S.wikipedia)
             ]

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "tauonmb" spawnTauon findTauon manageTauon
                , NS "calculator" spawnCalc findCalc manageCalc
                , NS "OBS" spawnOBS findOBS manageOBS
                , NS "Mocp" spawnMocp findMocp manageMocp
                ]
------------------------------------------------------------------------
  where
    spawnTerm  = myTerminal ++ " -t scratchpad"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
                   where
                     h = 0.9
                     w = 0.9
                     t = 0.95 -h
                     l = 0.95 -w

    spawnTauon  = "flatpak run com.github.taiko2k.tauonmb"
    findTauon   = className =? "Tauon Music Box"
    manageTauon = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w

    spawnCalc  = "qalculate-gtk"
    findCalc   = className =? "Qalculate-gtk"
    manageCalc = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.4
                 t = 0.75 -h
                 l = 0.70 -w

    spawnOBS   = "obs"
    findOBS   = className =? "obs"
    manageOBS = customFloating $ W.RationalRect l t w h
                   where
                     h = 0.9
                     w = 0.9
                     t = 0.95 -h
                     l = 0.95 -w

    spawnMocp  = myTerminal ++ "-t mocp" ++ "mocp"
    findMocp   = title =? "mocp"
    manageMocp = customFloating $ W.RationalRect l t w h
                   where
                     h = 0.9
                     w = 0.9
                     t = 0.95 -h
                     l = 0.95 -w

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- somehow deleting $ addTabs $ subLayout $ limitWindows sets the correct theme for tabs
-- Defining a bunch of layouts, many that I don't use.
tall     = renamed [Replace "tall"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 5
           $ ResizableTall 1 (3/100) (1/2) []
magnifyy  = renamed [Replace "magnify"]
         --  $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ magnifier
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
         --  $ windowNavigation
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
          -- $ windowNavigation
          -- $ addTabs shrinkText myTabTheme
          -- $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           -- $ windowNavigation
           -- $ addTabs shrinkText myTabTheme
           -- $ subLayout [] (smartBorders Simplest)
           $ mySpacing' 8
           $ spiral (6/7)
threeCol = renamed [Replace "threeCol"]
           -- $ windowNavigation
           -- $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing 5
           $ ThreeCol 1 (3/100) (1/2)
threeRow = renamed [Replace "threeRow"]
           -- $ windowNavigation
           -- $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing 5
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabConfig

  where
    myTabConfig = def { fontName            = myFont
                      , activeColor         = "#282c34"
                      , inactiveColor       = "#3e445e"
                      , activeBorderColor   = "#282c34"
                      , inactiveBorderColor = "#282c34"
                      , activeTextColor     = "#ffffff"
                      , inactiveTextColor   = "#d0d0d0"
                      }
myTabTheme = def { fontName            = myFont
                 , activeColor         = color15
                 , inactiveColor       = color08
                 , activeBorderColor   = color15
                 , inactiveBorderColor = colorBack
                 , activeTextColor     = colorBack
                 , inactiveTextColor   = "#b3afc2" -- color16
                 }

-- NOT BEING USED
-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Sans:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#000000"
    , swn_color             = "#FFFFFF"
    }
-----------------------------------------------------------------------
-- The layout hook

myLayoutHook = avoidStruts $ smartBorders  $ mouseResize $ windowArrange $ T.toggleLayouts floats $
               mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout 
             where
               -- I've commented out the layouts I don't use.
               myDefaultLayout =     tall
                                 -- ||| magnifyy
                                 ||| noBorders tabs
                                 -- ||| noBorders monocle
                                 -- ||| floats
                                 -- ||| grid
                                 -- ||| spirals
                                 -- ||| threeCol
                                 -- ||| threeRow

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . map xmobarEscape
              -- $ [ "1",      "2",   "3",    "4",   "5",    "6",       "7",      "8",      "9"]
              -- $ ["www",    "dev", "sys",  "doc", "misc", "chat",   "music",  "media",  "game"]
               $ ["\63206", "\61728", "ﱮ", "\63645", "𧻓", "\62074", "\61441", "\61448", "\63381"]
  where
        clickable l = [ "<action=xdotool key super+" ++ show n ++ ">" ++ ws ++ " </action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]

-- myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
-- myManageHook = composeAll 

myManageHook :: ManageHook
myManageHook = 
        manageSpecific
    <+> manageDocks
    <+> namedScratchpadManageHook myScratchPads 
    <+> fullscreenManageHook
    <+> manageSpawn
    where
        manageSpecific = composeAll
         [ resource =? "desktop_window"                    --> doIgnore
         , matchAny "Brave-browser"                        --> doShift ( myWorkspaces !! 0 )
         , matchAny "Chromium"                             --> doShift ( myWorkspaces !! 0 )
         , matchAny "qutebrowser"                          --> doShift ( myWorkspaces !! 0 )
         , matchAny "chromium-browser"                     --> doShift ( myWorkspaces !! 0 )
         , matchAny "firefox"                              --> doShift ( myWorkspaces !! 0 )
         , matchAny "Org.gnome.Nautilus"                   --> doShift ( myWorkspaces !! 2 )
         , matchAny "Ranger"                               --> doShift ( myWorkspaces !! 2 )
         , matchAny "Thunar"                               --> doShift ( myWorkspaces !! 2 )
         , matchAny "qBittorrent"                          --> doShift ( myWorkspaces !! 3 )
         , matchAny "Code"                                 --> doShift ( myWorkspaces !! 4 )
         , matchAny "org.remmina.Remmina"                  --> doShift ( myWorkspaces !! 4 )
         , matchAny "Emacs"                                --> doShift ( myWorkspaces !! 4 )
         , matchAny "megasync"                             --> doShift ( myWorkspaces !! 4 )
         , matchAny "MEGAsync"                             --> doShift ( myWorkspaces !! 4 )
         , matchAny "VirtualBox Manager"                   --> doShift ( myWorkspaces !! 4 )
         , matchAny "VirtualBox Machine"                   --> doShift ( myWorkspaces !! 4 )
         , matchAny "jetbrains-idea-ce"                    --> doShift ( myWorkspaces !! 4 ) 
         , matchAny "thunderbird"                          --> doShift ( myWorkspaces !! 5 )
         , matchAny "Steam"                                --> doShift ( myWorkspaces !! 8 )
         , matchAny "net-runelite-client-RuneLite"         --> doShift ( myWorkspaces !! 8 )
         , matchAny "net-runelite-launcher-Launcher"       --> doShift ( myWorkspaces !! 8 )
         , matchAny "Project Zomboid"                      --> doShift ( myWorkspaces !! 8 )
         , matchAny "All Files"                            --> doCenterFloat
         , matchAny "xdg-desktop-portal-gnome"             --> doCenterFloat
         , matchAny "pop-up"                               --> doCenterFloat
         , matchAny "Gcr-prompter"                         --> doCenterFloat
         , matchAny "GtkFileChooserDialog"                 --> doCenterFloat
         , matchAny "_NET_WM_WINDOW_TYPE_SPLASH"           --> doCenterFloat
         , matchAny "_OL_DECOR_CLOSE"                      --> doCenterFloat
         , matchAny "_NET_WM_WINDOW_TYPE_DIALOG"           --> doCenterFloat
         , matchAny "VirtualBox Manager"                   --> doFloat
         , matchAny "VirtualBox Machine"                   --> doFloat
         , matchAny "megasync"                             --> doFloat
         , matchAny "MEGAsync"                             --> doFloat
         , matchAny "File Operation Progress"              --> doFloat
         , matchAny "Brave"                                --> doFloat 
         , matchAny "Steam Guard - Computer Authorization Required" --> doFloat
         , matchAny "mpv"                                  --> doFloat
         , matchAny "Project Zomboid"                      --> doFullFloat
         , matchAny "no-focus"                             --> doF W.focusDown
         , matchAny "pop-up"                               --> doCenterFloat
         , matchAny "dialog"                               --> doCenterFloat
         , matchAny "menu"                                 --> doCenterFloat
         , matchAny "center"                               --> doCenterFloat
         , matchAny "floating"                             --> doFloat <+> doF W.focusDown
         , isDialog                                        --> doFloat
         , isFullscreen                                    --> doFullFloat
         , transience'
         ] <+> namedScratchpadManageHook myScratchPads

          where
                matchAny :: String -> Query Bool
                matchAny s = className =? s <||> title =? s <||> resource =? s <||> appName =? s 
                  <||> stringProperty "WM_WINDOW_ROLE" =? s 
                  <||> stringProperty "_NET_WM_WINDOW_ROLE" =? s 
                  <||> stringProperty "WM_WINDOW_TYPE" =? s
                  <||> stringProperty "_NET_WM_WINDOW_TYPE" =? s 
                  <||> stringProperty "_OL_DECOR_DEL" =? s 
                  <||> stringProperty "_NET_WM_NAME" =? s
                  <||> stringProperty "WM_ICON_NAME" =? s
                  <||> stringProperty "_NET_WM_ICON_NAME" =? s

                unfloat = ask >>= doF . W.sink

myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
    where
          fadeAmount = 1.0

 -- keybinds
myKeys :: [(String, X ())]
myKeys =
        -- Temporary
        [ ("M-C-[", spawn "nitrogen --random --set-zoom-fill --head=0 &")
        , ("M-C-]", spawn "nitrogen --random --set-zoom-fill --head=1 &")
        , ("M-C-m", swallowToggle ) -- Toggle SwallowState
        , ("M-C-n", rswallowToggle ) -- Toggle SwallowState

        -- Xmonad
        , ("M-C-r", spawn "xmonad --recompile")      -- Recompiles xmonad
        , ("M-S-r", spawn "xmonad --restart")        -- Restarts xmonad
        , ("M-S-q q", io exitSuccess)                  -- Quits xmonad
        , ("M-S-q r", spawn "reboot")                  
        , ("M-S-q s", spawn "poweroff")                  

        -- open preferred terminal
        , ("M-<Return>", spawn myTerminal)
        , ("M-b", spawn "ungoogled-chromium")
        , ("M-M1-b", spawn "brave-browser")
        , ("S-M1-f", spawn "thunar")

        -- Run Prompt
        , ("M-d", shellPrompt dtXPConfig)   -- Shell Prompt
        
    -- KB_GROUP Scratchpads
    -- Toggle show/hide these programs.  They run on a hidden workspace.
    -- When you toggle them to show, it brings them to your current workspace.
    -- Toggle them to hide and it sends them back to hidden workspace (NSP).
        , ("M1-<Space>", namedScratchpadAction myScratchPads "terminal")
        , ("M-s t", namedScratchpadAction myScratchPads "tauonmb")
        , ("M-s c", namedScratchpadAction myScratchPads "calculator")
        , ("M-s o", namedScratchpadAction myScratchPads "OBS")
        , ("M-s m", namedScratchpadAction myScratchPads "mocp")

        -- Windows
        , ("M-S-c", kill1)                           -- Kill the currently focused client
        , ("M-S-a", killAll)                         -- Kill all windows on current workspace
        , ("M-C-<Right>", nextWS)
        , ("M-C-<Left>", prevWS)

        -- Floating windows
        , ("M-f", sendMessage (T.Toggle "floats"))       -- Toggles my 'floats' layout
        , ("M-<Delete>", withFocused $ windows . W.sink) -- Push floating window back to tile
        , ("M-<XF86WheelButton>", withFocused $ windows . W.sink) -- Push floating window back to tile
        , ("M-S-<Delete>", sinkAll)                      -- Push ALL floating windows to tile
        , ("M-C-h", withFocused (keysMoveWindow (-70,0)))
        , ("M-C-l", withFocused (keysMoveWindow (70,0)))
        , ("M-C-j", withFocused (keysMoveWindow (0,70)))
        , ("M-C-k", withFocused (keysMoveWindow (0,-70)))

        -- Grid Select (CTRL-g followed by a key)
        --, ("C-g g", spawnSelected' myAppGrid)
        , ("C-g g", spawnApp)
        , ("C-M1-g", spawnSelected' myAppGrid)                -- grid select favorite apps
        , ("C-g t", goToSelected $ mygridConfig myColorizer)  -- goto selected window
        , ("C-g b", bringSelected $ mygridConfig myColorizer) -- bring selected window

    -- KB_GROUP Other Dmenu Prompts
    -- In Xmonad and many tiling window managers, M-p is the default keybinding to
    -- launch dmenu_run, so I've decided to use M-p plus KEY for these dmenu scripts.
--      , ("M-p h", spawn "dm-hub")           -- allows access to all dmscripts
--      , ("M-p a", spawn "dm-sounds")        -- choose an ambient background
--      , ("M-p b", spawn "dm-setbg")         -- set a background
        , ("M-p c", spawn "dtos-colorscheme") -- choose a colorscheme
--      , ("M-p C", spawn "dm-colpick")       -- pick color from our scheme
--      , ("M-p e", spawn "dm-confedit")      -- edit config files
--      , ("M-p i", spawn "dm-maim")          -- screenshots (images)
--      , ("M-p k", spawn "dm-kill")          -- kill processes
--      , ("M-p m", spawn "dm-man")           -- manpages
--      , ("M-p n", spawn "dm-note")          -- store one-line notes and copy them
--      , ("M-p o", spawn "dm-bookman")       -- qutebrowser bookmarks/history
--      , ("M-p p", spawn "passmenu")         -- passmenu
--      , ("M-p q", spawn "dm-logout")        -- logout menu
--      , ("M-p r", spawn "dm-reddit")        -- reddio (a reddit viewer)
--      , ("M-p s", spawn "dm-websearch")     -- search various search engines
--      , ("M-p t", spawn "dm-translate")     -- translate text (Google Translate)


        -- Windows navigation
        , ("M-m", windows W.focusMaster)     -- Move focus to the master window
        , ("M-j", windows W.focusDown)       -- Move focus to the next window
        , ("M-k", windows W.focusUp)         -- Move focus to the prev window
        --, ("M-S-m", windows W.swapMaster)    -- Swap the focused window and the master window
        , ("M-S-j", windows W.swapDown)      -- Swap focused window with next window
        , ("M-S-k", windows W.swapUp)        -- Swap focused window with prev window
        , ("M-<Backspace>", promote)         -- Moves focused window to master, others maintain order
        , ("M1-S-<Tab>", rotSlavesDown)      -- Rotate all windows except master and keep focus in place
        , ("M1-C-<Tab>", rotAllDown)         -- Rotate all the windows in the current stack
        --, ("M-S-s", windows copyToAll)
        , ("M-C-s", killAllOtherCopies)

        -- Layouts
        , ("M-<Tab>", sendMessage NextLayout)                -- Switch to next layout
        , ("M-C-M1-<Up>", sendMessage Arrange)
        , ("M-C-M1-<Down>", sendMessage DeArrange)
        , ("M-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full
        , ("M-S-<Space>", sendMessage ToggleStruts)       -- Toggles struts
        , ("M-S-n", sendMessage $ MT.Toggle NOBORDERS)      -- Toggles noborder
        , ("M-<KP_Multiply>", sendMessage (IncMasterN 1))   -- Increase number of clients in master pane
        , ("M-<KP_Divide>", sendMessage (IncMasterN (-1)))  -- Decrease number of clients in master pane
        , ("M-S-<KP_Multiply>", increaseLimit)              -- Increase number of windows
        , ("M-S-<KP_Divide>", decreaseLimit)                -- Decrease number of windows

    -- KB_GROUP Increase/decrease spacing (gaps)
        , ("M-h", sendMessage Shrink)                       -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                       -- Expand horiz window width
        , ("C-M1-j", decWindowSpacing 4)                    -- Decrease window spacing
        , ("C-M1-k", incWindowSpacing 4)                    -- Increase window spacing
        , ("C-M1-M-h", decScreenSpacing 4)        -- Decrease screen spacing
        , ("C-M1-M-l", incScreenSpacing 4)             -- Increase screen spacing

        -- Workspaces
        , ("M-.", nextScreen)  -- Switch focus to next monitor
        , ("M-,", prevScreen)  -- Switch focus to prev monitor
        , ("M-S-<KP_Add>", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
        , ("M-S-<KP_Subtract>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

        -- Emacs (CTRL-e followed by a key)
        , ("C-e e", spawn "emacsclient -c -a 'emacs'")                            -- start emacs

        ]
        -- Appending search engine prompts to keybindings list.
        -- Look at "search engines" section of this config for values for "k".
        ++ [("M-s " ++ k, S.promptSearch dtXPConfig' f) | (k,f) <- searchList ]
        ++ [("M-S-s " ++ k, S.selectSearch f) | (k,f) <- searchList ]
        -- Appending some extra xprompts to keybindings list.
        -- Look at "xprompt settings" section this of config for values for "k".
        ++ [("M-p " ++ k, f dtXPConfig') | (k,f) <- promptList ]
        ++ [("M-p " ++ k, f dtXPConfig' g) | (k,f,g) <- promptList' ]
        -- The following lines are needed for named scratchpads.
          where nonNSP          = WSIs (return (\ws -> W.tag ws /= "nsp"))
                nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "nsp"))

-------------------------------------------------------------------------------------------------
---------------------------------------    MAIN    ----------------------------------------------
-------------------------------------------------------------------------------------------------
main :: IO ()
main = do
 -- spawnPipe "bash Documents/random/mouse_scroll_speed.sh &"
    xmproc0 <- spawnPipe "xmobar -x 0 /home/dead/.config/xmobar/xmobarrc0"
    xmproc1 <- spawnPipe "xmobar -x 1 /home/dead/.config/xmobar/xmobarrc2"

    xmonad $ ewmh def
        { manageHook = myManageHook
        ,handleEventHook     = myEventHook <> swallowHook <> rswallowHook  -- <> forceCenterHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = myLayoutHook 
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook = workspaceHistoryHook <+> myLogHook <+> dynamicLogWithPP xmobarPP
                        { ppOutput = \x -> hPutStrLn xmproc0 x  >> hPutStrLn xmproc1 x  
                        , ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]" -- Current workspace in xmobar
                        , ppVisible = xmobarColor "#98be65" ""                -- Visible but not current workspace
                        , ppHidden = xmobarColor "#82AAFF" "" . wrap "" ""   -- Hidden workspaces in xmobar
                        -- #82AAFF purple
                        -- #46d9ff cyan
                        -- #CADDE9 grey
                        -- #51AFEF Blue
                        -- #0C4E7C Dark blue
                        --
                        -- #b3afc2 dim grey
                        , ppHiddenNoWindows = xmobarColor "#0C4E7C" ""        -- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor "#b3afc2" "" -- Title of active window in xmobar
                        , ppSep =  "<fc=#666666> <fn=2>|</fn> </fc>"                     -- Separators in xmobar
                        , ppUrgent = xmobarColor "C45500" "" . wrap "!" "!"  -- Urgent workspace
                        , ppExtras  = [windowCount]                           -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        }
        } `additionalKeysP` myKeys
---------------------------------------------------------------------------
-- myLogHook
---------------------------------------------------------------------------


---------------------------------------------------------------------------
-- X Event Actions
---------------------------------------------------------------------------

-- for reference, the following line is the same as dynamicTitle myDynHook
-- <+> dynamicPropertyChange "WM_NAME" myDynHook

-- I'm not really into full screens without my say so... I often like to
-- fullscreen a window but keep it constrained to a window rect (e.g.
-- for videos, etc. without the UI chrome cluttering things up). I can
-- always do that and then full screen the subsequent window if I want.
-- THUS, to cut a long comment short, no fullscreenEventHook
-- <+> XMonad.Hooks.EwmhDesktops.fullscreenEventHook
-- 
-- alternative:
-- <+> XMonad.Layout.Fullscreen.fullscreenEventHook
ewmhConfig = ewmh def

myEventHook = serverModeEventHookCmd
                               <+> serverModeEventHook
                               <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                               <+> XMonad.Hooks.ManageDocks.docksEventHook
                               <+> handleEventHook def 
                               <+> XMonad.Hooks.EwmhDesktops.fullscreenEventHook
---------------------------------------------------------------------------
-- forceCenterFloatHook
---------------------------------------------------------------------------
data RSwallowState = RSwallow | NoRSwallow
  deriving (Eq, Show, Read, Typeable)

instance ExtensionClass RSwallowState where
  initialValue = RSwallow
  extensionType = PersistentExtension

flipRSwallow :: RSwallowState -> RSwallowState
flipRSwallow RSwallow   = NoRSwallow
flipRSwallow NoRSwallow = RSwallow

rswallowHook :: Event -> X All
rswallowHook e = do
  shouldRSwallow <- XS.get
  case shouldRSwallow of
    RSwallow   -> swallowEventHook (matchAny "Ranger") (return True) e
          where
                matchAny :: String -> Query Bool
                matchAny s = className =? s <||> title =? s <||> resource =? s <||> appName =? s 
                  <||> stringProperty "WM_WINDOW_ROLE" =? s 
                  <||> stringProperty "_NET_WM_WINDOW_ROLE" =? s 
                  <||> stringProperty "WM_WINDOW_TYPE" =? s
                  <||> stringProperty "_NET_WM_WINDOW_TYPE" =? s 
                  <||> stringProperty "_OL_DECOR_DEL" =? s 
                  <||> stringProperty "_NET_WM_NAME" =? s
                  <||> stringProperty "WM_ICON_NAME" =? s
                  <||> stringProperty "_NET_WM_ICON_NAME" =? s
    NoRSwallow -> return mempty

rswallowToggle :: X ()
rswallowToggle = XS.modify flipRSwallow




---------------------------------------------------------------------------
-- SwallowHook
---------------------------------------------------------------------------
data SwallowState = Swallow | NoSwallow
  deriving (Eq, Show, Read, Typeable)

instance ExtensionClass SwallowState where
  initialValue = Swallow
  extensionType = PersistentExtension

flipSwallow :: SwallowState -> SwallowState
flipSwallow Swallow   = NoSwallow
flipSwallow NoSwallow = Swallow

swallowHook :: Event -> X All
swallowHook e = do
  shouldSwallow <- XS.get
  case shouldSwallow of
    Swallow   -> swallowEventHook (className =? "Alacritty") (return True) e
--  Swallow   -> swallowEventHook (className /=? "Alacritty") (return True) e
    NoSwallow -> return mempty 

swallowToggle :: X ()
swallowToggle = XS.modify flipSwallow

-- need festival speech synthesizer for notification 
speak :: Show a => a -> X ()
speak x = spawn ("echo " <> {- escape it -} show (show x) <> " | festival --tts")

---------------------------------------------------------------------------
-- Custom hook helpers
---------------------------------------------------------------------------

-- from:
-- https://github.com/pjones/xmonadrc/blob/master/src/XMonad/Local/Action.hs
--
-- Useful when a floating window requests stupid dimensions.  There
-- was a bug in Handbrake that would pop up the file dialog with
-- almost no height due to one of my rotated monitors.

forceCenterFloat :: ManageHook
forceCenterFloat = doFloatDep move
  where
    move :: W.RationalRect -> W.RationalRect
    move _ = W.RationalRect x y w h

    w, h, x, y :: Rational
    w = 1/3
    h = 1/2
    x = (1-w)/2
    y = (1-h)/2

-- I left this here because I want to explore using tags more
-- ... did I crib this from pjones config?
--
---- | If the given condition is 'True' then add the given tag name to
---- the window being mapped.  Always returns 'Nothing' to continue
---- processing other manage hooks.
--addTagAndContinue :: Query Bool -> String -> MaybeManageHook
--addTagAndContinue p tag = do
--  x <- p
--  when x (liftX . addTag tag =<< ask)
--  return Nothing


-- vim: ft=haskell:foldmethod=marker:expandtab:ts=4:shiftwidth=4


-- Transform layout modifier into a toggle-able
enableTabs x = addTabs shrinkText myTabTheme $ subLayout [] Simplest x
data ENABLETABS = ENABLETABS deriving (Read, Show, Eq, Typeable)
instance Transformer ENABLETABS Window where
--     transform ENABLETABS x k = k (enableTabs x) (const x)
