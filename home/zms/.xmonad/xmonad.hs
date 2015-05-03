import XMonad
import XMonad.Actions.CopyWindow
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Minimize
import XMonad.Layout.NoBorders
import XMonad.Layout.WindowNavigation
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.WindowProperties
import Control.Monad
import System.Exit
import System.IO
import qualified XMonad.StackSet as S
import qualified Data.Map as M

import Spacing ( SPACING(SPACING), spacing )

myBaseConfig = defaultConfig
myTerminal = "urxvt +vb +sb"

myBorderWidth = 0
myNormalBorderColor = "#2B2B2B"
myFocusedBorderColor = "#ebebeb"
myFocusFollowsMouse = False

myManageHook = composeAll
  [
  resource =? "trayer" --> doIgnore,
  isFullscreen --> doFullFloat,
  className =? "Xmessage" --> doFloat,
  title =? "cairo-dock-dialog" --> doFloat,
  title =? "Chat" --> doFloat,
  appName =? "crx_eggnbpckecmjlblplehfpjjdhhidfdoj" --> doFloat <+> doF copyToAll,
  stringProperty "WM_WINDOW_ROLE" =? "pop-up" --> doFloat
  ]

myModMask = mod4Mask
altMask = mod1Mask

myKeys conf = M.fromList $
  [
  ((myModMask, xK_Return), spawn $ XMonad.terminal conf),
  ((myModMask, xK_r), spawn "dmenu_run"),
  ((myModMask, xK_w), kill),
  ((myModMask, xK_space), sendMessage NextLayout),
  ((myModMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf),
  ((myModMask, xK_slash), refresh),
  ((myModMask, xK_Tab), windows S.focusDown),
  ((myModMask .|. shiftMask, xK_n), windows S.focusUp),
  ((myModMask, xK_Up), windows S.swapUp),
  ((myModMask, xK_Down), windows S.swapDown),
  ((myModMask, xK_Left), sendMessage Shrink),
  ((myModMask, xK_Right), sendMessage Expand),
  ((myModMask, xK_t), withFocused $ windows . S.sink),
  ((myModMask, xK_r), killAllOtherCopies),
  ((myModMask, xK_z), withFocused minimizeWindow),
  ((myModMask .|. shiftMask, xK_z), sendMessage RestoreNextMinimizedWin),
  ((myModMask, xK_g), goToSelected defaultGSConfig),
  ((myModMask .|. shiftMask, xK_Up), sendMessage (IncMasterN 1)),
  ((myModMask .|. shiftMask, xK_Down), sendMessage (IncMasterN (-1))),
  ((myModMask, xK_q), broadcastMessage ReleaseResources >> spawn "killall tint2 && xmonad --recompile && xmonad --restart"),
  ((myModMask .|. shiftMask, xK_q), io (exitWith ExitSuccess)),
  ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s"),
  ((0, xK_Print), spawn "scrot"),
  ((altMask .|. controlMask, xK_l), spawn "xscreensaver-command -lock"),
  ((altMask .|. controlMask, xK_Left  ), prevWS),
  ((altMask .|. controlMask, xK_Right ), nextWS),
  ((controlMask .|. altMask .|. shiftMask, xK_Left), shiftToPrev >> prevWS),
  ((controlMask .|. altMask .|. shiftMask, xK_Right), shiftToNext >> nextWS),
  ((myModMask .|. controlMask, xK_Up), sendMessage $ SPACING 10),
  ((myModMask .|. controlMask, xK_Down), sendMessage $ SPACING (negate 10))
  ] ++
  [
  ((myModMask, k), windows $ S.greedyView i) |
      (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
  ] ++
  [
  ((myModMask .|. shiftMask, k), (windows $ S.shift i) >> (windows $ S.greedyView i)) |
      (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
  ]

main = do
    xmproc <- spawnPipe "/usr/bin/tint2 ~/.config/tint2/tint2rc"
    xmonad $ ewmh $ myBaseConfig
         {
           terminal = myTerminal,
           manageHook = manageDocks <+> myManageHook <+> manageHook myBaseConfig,
           layoutHook = minimize $ avoidStruts $ smartBorders $ spacing 60 $ layoutHook myBaseConfig,
           handleEventHook = fullscreenEventHook,
           logHook = fadeInactiveLogHook 0.95,
           modMask = mod4Mask,
           borderWidth = myBorderWidth,
           normalBorderColor = myNormalBorderColor,
           focusedBorderColor = myFocusedBorderColor,
           focusFollowsMouse = myFocusFollowsMouse,
           keys = myKeys
         }
