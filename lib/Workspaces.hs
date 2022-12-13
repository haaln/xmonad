module Workspaces where

import XMonad

www = "\63206"
term = "\61728"
file = "ﱮ"
doc = "\63645"
misc = "𧻓"
irc= "\62074"
music = "\61441"
dead = "?"
game = "\63381"

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . map xmobarEscape
              $ [www, term, file, doc, misc, irc, music, dead, game]
  where
        clickable l = [ "<action=xdotool key super+" ++ show n ++ ">" ++ ws ++ " </action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]
