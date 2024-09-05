module Hooks.Prompt where

import XMonad
import XMonad.Prompt.Input
import XMonad.Util.Run
import Data.Char (isSpace)
import Data.Maybe (isJust)

calcPrompt c ans =
    inputPrompt c (trim ans) ?+ \input ->
        liftIO(runProcessWithInput "qalc" [input] "") >>= calcPrompt c
    where
        trim  = f . f
            where f = reverse . dropWhile isSpace
