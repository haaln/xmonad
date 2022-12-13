module Keybinds where

import XMonad
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import XMonad.Prompt.XMonad
import XMonad.Prompt
import XMonad.Prompt.Pass
import Data.Maybe (isJust)
import XMonad.Prompt.Ssh
import XMonad.Prompt.Man
import XMonad.Prompt.Input
import Control.Arrow
import qualified XMonad.Actions.Search as S
import qualified XMonad.Layout.ToggleLayouts as T 
import XMonad.Layout.MultiToggle.Instances 
import qualified XMonad.Layout.MultiToggle as MT 
import System.Exit (exitSuccess)
import XMonad.Prompt.Shell 
import XMonad.Hooks.ManageHelpers
import XMonad.Actions.CycleWS
import XMonad.Actions.SinkAll
import XMonad.Operations
import XMonad.Actions.FloatKeys
import XMonad.Actions.GridSelect

import XMonad.Layout.Spacing
import XMonad.Layout.LimitWindows
import XMonad.Actions.CopyWindow
import XMonad.Actions.WithAll
import XMonad.Actions.Promote
import XMonad.Hooks.ManageDocks
import XMonad.Layout.WindowArranger
import XMonad.Actions.RotSlaves
import XMonad.Layout.NoBorders

import Hooks.Grid
import Hooks.Swallow
import Hooks.SearchEngine
import Hooks.Scratchpads
import Hooks.Prompt

import Layout
import Workspaces
import Config

promptList :: [(String, XPConfig -> X ())]
promptList = [ ("m", manPrompt)          
             , ("p", passPrompt)        -- requires pass 
             , ("g", passGeneratePrompt)-- requires pass 
             , ("r", passRemovePrompt)  -- requires pass 
             , ("s", sshPrompt)          
             , ("x", xmonadPrompt)       
             ]

-- Custom prompts
promptList' :: [(String, XPConfig -> String -> X (), String)]
promptList' = [ ("c", calcPrompt, "qalc")         -- requires qalculate-gtk
              ]
     


myKeys :: [(String, X ())]
myKeys =
        -- Temporary
        [ ("M-C-[", spawn "nitrogen --random --set-zoom-fill --head=0 &")
        , ("M-C-]", spawn "nitrogen --random --set-zoom-fill --head=1 &")
        , ("M-C-m", swallowToggle ) 

        -- Xmonad
        , ("M-C-r", spawn "xmonad --recompile")      -- Recompiles xmonad
        , ("M-S-r", spawn "xmonad --restart")        -- Restarts xmonad
        , ("M-S-q q", io exitSuccess)                  -- Quits xmonad
        , ("M-S-q r", spawn "/sbin/reboot")                  
        , ("M-S-q s", spawn "/sbin/shutdown")                  

        -- Terminal
        , ("M-<Return>", spawn myTerminal)

        , ("M-b", spawn "ungoogled-chromium")
        , ("M-M1-b", spawn "brave-browser")
        , ("S-M1-f", spawn "thunar")

        -- Run Prompt
        , ("M-d", shellPrompt myXPConfig)   -- Shell Prompt
        
        -- Scratchpads
        , ("M1-<Space>", namedScratchpadAction myScratchPads "terminal")
        , ("M-s t", namedScratchpadAction myScratchPads "tauonmb")
        , ("M-s c", namedScratchpadAction myScratchPads "calculator")
        , ("M-s o", namedScratchpadAction myScratchPads "OBS")
        , ("M-s n", namedScratchpadAction myScratchPads "ncmpcpp")
        , ("M-s b", namedScratchpadAction myScratchPads "newsboat")

        -- Windows
        , ("M-S-c", kill1)                           
        , ("M-S-a", killAll)                         
        , ("M-C-<Right>", nextWS)
        , ("M-C-<Left>", prevWS)
        --, ("M1-<Tab>", moveTo Next nonEmptyNonNSP)
        , ("M1-<Tab>", toggleWS' ["NSP"])
        , ("M1-C-<Tab>", moveTo Prev nonEmptyNonNSP)
        
        -- Go To Workspace
        , ("M1-1",   windows $ W.greedyView $ myWorkspaces !! 0)
        , ("M1-2",   windows $ W.greedyView $ myWorkspaces !! 1)
        , ("M1-3",   windows $ W.greedyView $ myWorkspaces !! 2)
        , ("M1-w f",   windows $ W.greedyView $ myWorkspaces !! 2)
        , ("M1-w d",   windows $ W.greedyView $ myWorkspaces !! 3)
        , ("M1-w a",   windows $ W.greedyView $ myWorkspaces !! 4)
        , ("M1-w c",   windows $ W.greedyView $ myWorkspaces !! 5)
        , ("M1-w x",   windows $ W.greedyView $ myWorkspaces !! 8)

        -- Floating windows
        , ("M-f", sendMessage (T.Toggle "floats"))       -- Toggles my 'floats' layout
        , ("M-<Delete>", withFocused $ windows . W.sink) -- Push floating window back to tile
        , ("M-<XF86WheelButton>", withFocused $ windows . W.sink) -- Push floating window back to tile
        , ("M-S-<Delete>", sinkAll)                      -- Push ALL floating windows to tile
        , ("M-C-h", withFocused (keysMoveWindow (-200,0)))
        , ("M-C-l", withFocused (keysMoveWindow (200,0)))
        , ("M-C-j", withFocused (keysMoveWindow (0,200)))
        , ("M-C-k", withFocused (keysMoveWindow (0,-200)))

        -- Grid Select (CTRL-g followed by a key)
        , ("C-g g", spawnGrid)
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
      --, ("M1-C-<Tab>", rotAllDown)         -- Rotate all the windows in the current stack
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
        , ("M-S-<KP_Add>", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
        , ("M-S-<KP_Subtract>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

        -- Emacs (CTRL-e followed by a key)
        --, ("C-e e", spawn "emacsclient -c -a 'emacs'")                            -- start emacs

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



myXPConfig :: XPConfig
myXPConfig = dtXPConfig 
          { promptKeymap = dtXPKeymap }

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
