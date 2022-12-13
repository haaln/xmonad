module Hooks.ForceFloat where

import XMonad
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageHelpers 

forceSmallFloat :: ManageHook
forceSmallFloat = doFloatDep move
  where
    move :: W.RationalRect -> W.RationalRect
    move _ = W.RationalRect x y w h

    w, h, x, y :: Rational
    w = 1/3
    h = 1/2
    x = (1-w)/2
    y = (1-h)/2

forceMediumFloat :: ManageHook
forceMediumFloat = doFloatDep move
  where
    move :: W.RationalRect -> W.RationalRect
    move _ = W.RationalRect x y w h

    w, h, x, y :: Rational
    w = 3/4
    h = 3/4
    x = (1-w)/2
    y = (1-h)/2

forceBigFloat :: ManageHook
forceBigFloat = doFloatDep move
  where
    move :: W.RationalRect -> W.RationalRect
    move _ = W.RationalRect x y w h

    w, h, x, y :: Rational
    w = 0.9
    h = 0.9
    x = 0.95 -h
    y = 0.95 -w

forceTinyFloat :: ManageHook
forceTinyFloat = doFloatDep move
  where
    move :: W.RationalRect -> W.RationalRect
    move _ = W.RationalRect x y w h

    w, h, x, y :: Rational
    w = 0.5
    h = 0.4
    x = 0.75 -h
    y = 0.70 -w
