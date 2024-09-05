module Hooks.SearchEngine where

import XMonad
import qualified XMonad.Actions.Search as S

archwiki :: S.SearchEngine
archwiki = S.searchEngine "archwiki" "https://wiki.archlinux.org/index.php?search="

searchList :: [(String, S.SearchEngine)]
searchList = [ ("a", archwiki)
             , ("d", S.duckduckgo)
             , ("i", S.images)
             , ("s", S.stackage)
             , ("w", S.wikipedia)
             , ("g", S.github)
             , ("t", S.alpha)
             ]
