module Workspaces where

import XMonad

www = "1"
term = "2"
file = "3"
dev = "4"
misc = "5"

myWorkspace = [www, term, file, dev, misc]

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . map xmobarEscape
              $ myWorkspace
  where
        clickable l = [ "<action=xdotool key super+" ++ show n ++ ">" ++ ws ++ " </action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]
