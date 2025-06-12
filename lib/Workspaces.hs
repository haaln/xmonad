module Workspaces where

import XMonad

www = "\63206"
term = "\xf120"
file = "\61564"
dev = "\xf15c"
misc = "\xf2d2"

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
