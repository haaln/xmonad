module Hooks.Swallow where

import XMonad
import XMonad.Hooks.WindowSwallowing
import Data.Monoid (All)
import qualified XMonad.Util.ExtensibleState as XS

import Config

data SwallowState = Swallow | NoSwallow
  deriving (Eq, Show, Read, Typeable)

instance ExtensionClass SwallowState where
  initialValue = Swallow
  extensionType = PersistentExtension

flipSwallow :: SwallowState -> SwallowState
flipSwallow Swallow   = NoSwallow
flipSwallow NoSwallow = Swallow

swallowHook :: Event -> X All
swallowHook e = do
  shouldSwallow <- XS.get
  case shouldSwallow of
    Swallow   -> swallowEventHook (className =? myTerminalClass) (return True) e
    NoSwallow -> return mempty

swallowToggle :: X ()
swallowToggle = XS.modify flipSwallow
