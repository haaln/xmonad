module Workspaces where

import XMonad

www = " web"
term = " term"
file = " file"
doc = " doc"
misc = " misc"
irc= " irc"
tex = " tex"
kvm = " kvm"
game = " steam"

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
