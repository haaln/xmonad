module Workspaces where

import XMonad

www = "\63206"
term = "\xf120"
file = "\61564"
dev = "\xf15c"
misc = "\xf2d2"
win = "\61818"
tex = "\xf02d"
kvm = "\62599"
game = "\63381"

myWorkspace = [www, term, file, dev, misc, tex, win, kvm, game]
-- windows logo "\61818"
-- mail logo "\64239" or "\63213"
-- git arrow "\61556" or branch "\62488"
-- shell "\61729"
--穀禎﬐
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
