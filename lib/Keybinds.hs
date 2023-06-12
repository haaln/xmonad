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

import XMonad.Hooks.UrgencyHook

import Layout
import Workspaces
import Config

promptList :: [(String, XPConfig -> X ())]
promptList = [ ("m", manPrompt)          
             , ("p", passPrompt)        
             , ("g", passGeneratePrompt)
             , ("r", passRemovePrompt)  
             , ("s", sshPrompt)          
             , ("x", xmonadPrompt)       
             ]

promptList' :: [(String, XPConfig -> String -> X (), String)]
promptList' = [ ("c", calcPrompt, "qalc")         
              ]
     


myKeys :: [(String, X ())]
myKeys =
        -- temp
        [ ("M-C-[", spawn "nitrogen --random --set-zoom-fill --head=0 &")
        , ("M-C-]", spawn "nitrogen --random --set-zoom-fill --head=1 &")
        , ("M-C-m", swallowToggle ) 

        , ("M-C-r", spawn "xmonad --recompile")      
        , ("M-S-r", spawn "xmonad --restart")        
        , ("M-S-q q", io exitSuccess)                
        , ("M-S-q r", spawn "reboot")                  
        , ("M-S-q s", spawn "poweroff")                  

        , ("M-<Return>", spawn myTerminal)

        , ("M-b", spawn "ungoogled-chromium")
        , ("M-M1-b", spawn "brave-browser")
        , ("S-M1-f", spawn "thunar")

        , ("M-d", shellPrompt myXPConfig)
        
        , ("M1-<Space>", namedScratchpadAction myScratchPads "terminal")
        , ("M-s t", namedScratchpadAction myScratchPads "tauonmb")
        , ("M-s c", namedScratchpadAction myScratchPads "calculator")
        , ("M-s o", namedScratchpadAction myScratchPads "OBS")
        , ("M-s n", namedScratchpadAction myScratchPads "ncmpcpp")
        , ("M-s b", namedScratchpadAction myScratchPads "newsboat")
        , ("M-s x", namedScratchpadAction myScratchPads "keepassxc")

        , ("M-<Backspace>", focusUrgent)

        , ("M-S-c", kill1)                           
        , ("M-S-a", killAll)                         
        , ("M-C-<Right>", nextWS)
        , ("M-C-<Left>", prevWS)

        , ("M1-<Tab>", toggleWS' ["NSP"])
        , ("M1-C-<Tab>", moveTo Prev nonEmptyNonNSP)
        
        , ("M1-1", windows $ W.greedyView $ myWorkspaces !! 0)
        , ("M1-2", windows $ W.greedyView $ myWorkspaces !! 1)
        , ("M1-3", windows $ W.greedyView $ myWorkspaces !! 2)
      --, ("M1-w w", windows $ W.greedyView $ myWorkspaces !! 0)
      --, ("M1-w f", windows $ W.greedyView $ myWorkspaces !! 2)
        , ("M1-w d", windows $ W.greedyView $ myWorkspaces !! 3)
        , ("M1-w a", windows $ W.greedyView $ myWorkspaces !! 4)
        , ("M1-w c", windows $ W.greedyView $ myWorkspaces !! 5)
        , ("M1-w t", windows $ W.greedyView $ myWorkspaces !! 6)
        , ("M1-w q", windows $ W.greedyView $ myWorkspaces !! 7)
        , ("M1-w v", windows $ W.greedyView $ myWorkspaces !! 7)
        , ("M1-w x", windows $ W.greedyView $ myWorkspaces !! 8)

        , ("M-f", sendMessage (T.Toggle "floats"))       
        , ("M-<Delete>", withFocused $ windows . W.sink) 
        , ("M-<XF86WheelButton>", withFocused $ windows . W.sink) 
        , ("M-S-<Delete>", sinkAll)                     
        , ("M-C-h", withFocused (keysMoveWindow (-200,0)))
        , ("M-C-l", withFocused (keysMoveWindow (200,0)))
        , ("M-C-j", withFocused (keysMoveWindow (0,200)))
        , ("M-C-k", withFocused (keysMoveWindow (0,-200)))

        , ("C-g g", spawnGrid)
        , ("C-g t", goToGrid)
        , ("C-g b", goBringGrid)

        , ("M-m", windows W.focusMaster)     
        , ("M-j", windows W.focusDown)       
        , ("M-k", windows W.focusUp)         
        , ("M-S-j", windows W.swapDown)      
        , ("M-S-k", windows W.swapUp)        
        , ("M-<Pageup>", promote)         
        , ("M1-S-<Tab>", rotSlavesDown)      
      --, ("M-S-m", windows W.swapMaster)    
      --, ("M1-C-<Tab>", rotAllDown)         
      --, ("M-S-s", windows copyToAll)
        , ("M-C-s", killAllOtherCopies)

        , ("M-<Tab>", sendMessage NextLayout)               
        , ("M-C-M1-<Up>", sendMessage Arrange)
        , ("M-C-M1-<Down>", sendMessage DeArrange)
        , ("M-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) 
        , ("M-S-<Space>", sendMessage ToggleStruts)         
        , ("M-S-n", sendMessage $ MT.Toggle NOBORDERS)      
        , ("M-<KP_Multiply>", sendMessage (IncMasterN 1))   
        , ("M-<KP_Divide>", sendMessage (IncMasterN (-1)))  
        , ("M-S-<KP_Multiply>", increaseLimit)              
        , ("M-S-<KP_Divide>", decreaseLimit)                

        , ("M-h", sendMessage Shrink)                       -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                       -- Expand horiz window width
        , ("C-M1-j", decWindowSpacing 4)                    -- Decrease window spacing
        , ("C-M1-k", incWindowSpacing 4)                    -- Increase window spacing
        , ("C-M1-M-h", decScreenSpacing 4)                  -- Decrease screen spacing
        , ("C-M1-M-l", incScreenSpacing 4)                  -- Increase screen spacing

        , ("M-S-<KP_Add>", shiftTo Next nonNSP >> moveTo Next nonNSP)       
        , ("M-S-<KP_Subtract>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  
        ]
        ++ [("M-s " ++ k, S.promptSearch dtXPConfig' f) | (k,f) <- searchList ]
        ++ [("M-S-s " ++ k, S.selectSearch f) | (k,f) <- searchList ]
        ++ [("M-p " ++ k, f dtXPConfig') | (k,f) <- promptList ]
        ++ [("M-p " ++ k, f dtXPConfig' g) | (k,f,g) <- promptList' ]

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
