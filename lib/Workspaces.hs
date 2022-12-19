module Workspaces where

import XMonad

www = "\63206"
term = "\61728"
file = "\61564"
doc = "\63256"
misc = "\63277"
irc= "\63111"
tex = "\61489"
kvm = "\62599"
game = "\63381"
--穀禎﬐
xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . map xmobarEscape
              $ [www, term, file, doc, misc, irc, tex, kvm, game]
  where
        clickable l = [ "<action=xdotool key super+" ++ show n ++ ">" ++ ws ++ " </action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]
