module Log where

import XMonad
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.DynamicLog

import qualified XMonad.StackSet as W
import Workspaces

import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

myLogHook :: X ()
myLogHook = 
     workspaceHistoryHook
 -- <+> switchRes
 <+> fadeInactiveLogHook fadeAmount
      where
       fadeAmount = 1.0

dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
            D.signalBody = [D.toVariant $ UTF8.decodeString str]
        }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/.config/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"

switchRes:: X ()
switchRes = do
  ws <- gets windowset
  let tag = W.tag . W.workspace . W.current $ ws
  spawn ("~/.local/bin/myXrandrScript.sh " ++ show tag )
