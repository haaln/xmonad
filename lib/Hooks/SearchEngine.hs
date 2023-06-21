module Hooks.SearchEngine where

import XMonad
import qualified XMonad.Actions.Search as S

archwiki :: S.SearchEngine
archwiki = S.searchEngine "archwiki" "https://wiki.archlinux.org/index.php?search="

aur :: S.SearchEngine
aur = S.searchEngine "aur" "https://aur.archlinux.org/packages?O=0&K="

archpackage :: S.SearchEngine
archpackage = S.searchEngine "arch packages" "https://archlinux.org/packages/?sort=&q="

searchList :: [(String, S.SearchEngine)]
searchList = [ ("a", archwiki)
             , ("p", archpackage)
             , ("r", aur)
             , ("d", S.duckduckgo)
             , ("i", S.images)
             , ("s", S.stackage)
             , ("w", S.wikipedia)
             , ("g", S.github)
             ]
