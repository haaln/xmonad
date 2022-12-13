module Hooks.SearchEngine where

import XMonad
import qualified XMonad.Actions.Search as S

-- XMonad.Actions.Search. Additionally, you can add other search engines.

archwiki :: S.SearchEngine
archwiki = S.searchEngine "archwiki" "https://wiki.archlinux.org/index.php?search="

aur :: S.SearchEngine
aur = S.searchEngine "aur" "https://aur.archlinux.org/packages?O=0&K="

archpackage :: S.SearchEngine
archpackage = S.searchEngine "arch packages" "https://archlinux.org/packages/?sort=&q="

-- This is the list of search engines that I want to use. Some are from
-- XMonad.Actions.Search, and some are the ones that I added above.
searchList :: [(String, S.SearchEngine)]
searchList = [ ("a", archwiki)
             , ("p", archpackage)
             , ("d", S.duckduckgo)
             , ("r", aur)
             , ("i", S.images)
             , ("s", S.stackage)
             , ("w", S.wikipedia)
             , ("g", S.github)
             , ("t", S.alpha)
             ]
