#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen ; mouse coordinates relative to the screen

; =========================
; CONFIGURATION
; =========================
; global RATIO := 0.618
global RATIO := 0.382
global ID_SEEN := Object()
global ARRANGEMENT := Object()
global ARRANGEMENT_PATH := A_AppData . "\arrangement.json"
global PADDING := 10
LoadArrangement()
WatchNewWindow()
; =========================
; BINDINGS
; =========================
^Esc:: Send ^{``}
*#q:: !F4
#Esc:: Reload
^BS::
  Send ^a
  Send {BS}
  return
#=::SoundSet, +5
#-::SoundSet, -5
#\::Send {Volume_Mute}
#BS::#l
#f:: ToggleActiveWinMaximum()
^#p::ShowActiveWinGeometry()
#j:: FocusWinByDirection("right")
#k:: FocusWinByDirection("left")
#+j::MoveActiveWinByDirection("right")
#+k::MoveActiveWinByDirection("left")
#+r::reload
#i::IgnoreArrangementForActiveWindow()
#+i::UnignoreArrangementForActiveWindow()
#t::ShowDebug()

; Ctrl + Alt + v : paste as plain text
^!v::
    Clip0 = %ClipBoardAll%
    ClipBoard = %ClipBoard% ; Convert to plain text
    Send ^v
    Sleep 1000
    ClipBoard = %Clip0%
    VarSetCapacity(Clip0, 0) ; Free memory
Return

; Ctrl + Alt + Shift + v : paste as plain test a replace \ with /
^+!v::
    Clip0 = %ClipBoardAll%
    ClipBoard := StrReplace(ClipBoard, "\", "/") ; Convert to plain text
    Send ^v
    Sleep 1000
    ClipBoard = %Clip0%
    VarSetCapacity(Clip0, 0) ; Free memory
Return

; move cursor to center of window after switching
~#1 Up::
~#2 Up::
~#3 Up::
~#4 Up::
~#5 Up::
~#6 Up::
~#7 Up::
~#8 Up::
~#9 Up::
  Sleep 100
  SetCursorToCenterOfActiveWin()
  return
~!Tab Up::
  while (GetKeyState("Alt") != 0 or GetKeyState("Tab") != 0) {
    Sleep 50
  }
  Sleep 100
  WinGetPos, x, y, w, h, A
  SetCursorToCenterOfActiveWin()
  return

; =========================
; CAPSLOCK AS HYBRID KEY
; =========================

; Capslock & h:: Send {Left}
; Capslock & j:: Send {Down}
; Capslock & k:: Send {Up}
; Capslock & l:: Send {Right}
; Capslock & y:: Send {Browser_Back}
; Capslock & u:: Send ^{PgUp}
; Capslock & i:: Send ^{PgDn}
; Capslock & o:: Send {Browser_Forward}
; Capslock & BackSpace:: Send {Del}

; Capslock & n:: Send {Home}
; Capslock & m:: Send {PgUp}
; Capslock & ,:: Send {PgDn}
; Capslock & .:: Send {End}

; Capslock & Space:: SetCapsLockState % !GetKeyState("CapsLock", "T")
; +CapsLock::
;   Send {~}
;   SetCapsLockState % !GetKeyState("CapsLock", "T")
; Return
; Capslock::return

; =========================
; FUNCTIONS
; =========================

#Include, WinGetPosEx.ahk
#Include, JSON.ahk

ShowGeometry(x, y, w, h) {
  MsgBox, , Geometry,% Format("x:{}, y:{}, w: {}, h: {}", x, y, w, h)
}

ShowActiveWinGeometry() {
  WinGetPos x, y, w, h, A
  ShowGeometry(x, y, w, h)
}

SetCursorPos(x, y) {
  DllCall("SetCursorPos", "int", x, "int", y)
}

FocusWinUnderCursor() {
  MouseGetPos, MouseX, MouseY, WinId
  WinActivate, ahk_id %WinId%
}

SetCursorToCenterOfActiveWin() {
  WinGetPos x, y, w, h, A
  SetCursorPos(x + w / 2,  y + h / 2)
}

FocusWinByPos(x, y) {
  SetCursorPos(x, y)
  FocusWinUnderCursor()
  SetCursorToCenterOfActiveWin()
}

GetCursorMonGeometry(ByRef x, ByRef y, ByRef w, ByRef h) {
  MouseGetPos, MouseX, MouseY
  SysGet, mc, MonitorCount
  ; find current monitor
  mi := 0
  loop {
    SysGet, mon, MonitorWorkArea, %mi%
    if (monLeft < MouseX and monRight > MouseX) {
      x := monLeft
      y := monTop
      w := monRight - monLeft
      h := monBottom - monTop
      return
    }
  }
}

FocusWinByDirection(direction) {
  global RATIO
  GetCursorMonGeometry(x, y, w, h)
  wf := RATIO / 2
  hf := 0.5
  if (direction = "right")
    wf := RATIO + (1 - RATIO) / 2
  FocusWinByPos(x + w * wf, y + h * hf)
}

MoveActiveWinByDirection(direction) {
  WinGet, isMax, MinMax, A
  if (isMax) {
    WinRestore, A
  }
  global RATIO
  global PADDING
  GetCursorMonGeometry(x, y, w, h)
  activeWinId := WinExist("A")
  WinGetPosEx(activeWinId, wx, wy, ww, wh, l, t, r, b)
  wx := x
  wy := y
  ww := floor(w * RATIO)
  wh := h
  if (direction = "right") {
    wx := ww + floor(PADDING / 2)
    ww := w - ww
  } else {
    wx := wx + PADDING
  }
  ww := ww - floor(PADDING * 1.5)
  wy := wy + PADDING
  wh := wh - PADDING * 2
  WinMove, A,, wx - l, wy - t, ww + l + r, wh + t + b
  SaveActiveWindowDirection(direction)
}


SaveArrangement() {
  global ARRANGEMENT
  global ARRANGEMENT_PATH
  file := FileOpen(ARRANGEMENT_PATH, "w")
  file.Write(JSON.Dump(ARRANGEMENT,, 2))
  file.Close()
}

LoadArrangement() {
  global ARRANGEMENT
  global ARRANGEMENT_PATH
  try {
    FileRead, temp, %ARRANGEMENT_PATH%
    ARRANGEMENT := JSON.Load(temp)
  } catch {
    ARRANGEMENT := Object()
  }
  if not IsObject(ARRANGEMENT) {
    ARRANGEMENT := Object()
  }
  if not IsObject(ARRANGEMENT["windows"]) {
    ARRANGEMENT["windows"] := Object()
  }
  if not IsObject(ARRANGEMENT["ignore"]) {
    ARRANGEMENT["ignore"] := Object()
  }
}

GetActiveWindowClassPath() {
  WinGet processPath, ProcessPath, A
  WinGetClass windowClass, A
  return processPath . ":" . windowClass
}

IsActiveWindowSeen() {
  global ID_SEEN
  WinGet winId, ID, A
  seen := ID_SEEN.HasKey(winId)
  ID_SEEN[winId] := true
  return seen
}

IgnoreArrangementForActiveWindow() {
  global ARRANGEMENT
  ARRANGEMENT["ignore"][GetActiveWindowClassPath()] := true
  SaveArrangement()
}

UnignoreArrangementForActiveWindow() {
  global ARRANGEMENT
  ARRANGEMENT["ignore"].Delete(GetActiveWindowClassPath())
  SaveArrangement()
}

IsActiveWindowIgnore() {
  global ARRANGEMENT
  if (ARRANGEMENT["ignore"].HasKey(GetActiveWindowClassPath())) {
    return true
  }
  ; WinGetTitle, title, A
  ; if (title = "") {
  ;   return true
  ; }
  WinGet s, Style, A
  if (not s & +0xC00000) {
    return true
  }
  return false
}

SaveActiveWindowDirection(direction) {
  global ARRANGEMENT
  key := GetActiveWindowClassPath()
  ARRANGEMENT["windows"][key] := direction
  SaveArrangement()
}

WatchNewWindow() {
  global ARRANGEMENT
  Loop {
      WinWaitActive A        ; makes the active window to be the Last Found
      if not IsActiveWindowSeen() and not IsActiveWindowIgnore() {
        classPath := GetActiveWindowClassPath()
        if ARRANGEMENT["windows"].HasKey(classPath) {
          MoveActiveWinByDirection(ARRANGEMENT["windows"][classPath])
        }
      }
      WinWaitNotActive       ; waits until the active window changes
  }
}


ToggleActiveWinMaximum() {
  WinGet, isMax, MinMax, A
  if (isMax) {
    WinRestore, A
  } else {
    WinMaximize, A
  }
}

GetSelectedText() {
  tmp = %ClipboardAll% ; save clipboard
  Clipboard := "" ; clear clipboard
  Send, ^c ; simulate Ctrl+C (=selection in clipboard)
  ClipWait, 0, 1 ; wait until clipboard contains data
  selection = %Clipboard% ; save the content of the clipboard
  Clipboard = %tmp% ; restore old content of the clipboard
  return selection
}

ShowDebug() {
  WinGet, s, Style, A
  if (s & +0xC00000) {
    SoundBeep, 750, 200
  }
}

ShowObject(obj) {
  msg := JSON.Dump(obj)
  MsgBox, %msg%
}