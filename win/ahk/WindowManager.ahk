; WINDOWS MANAGER
; global RATIO := 0.618
global RATIO := 0.382
global ID_SEEN := Object()
global ARRANGEMENT := Object()
global ARRANGEMENT_PATH := A_AppData . "\arrangement.json"
global PADDING := 10

; =========================
; KEY BINDING
; =========================
; Send cursor to the center of window while switching
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
; FUNCTION
; =========================

InitWindowManager() {
    LoadArrangement()
    SetTimer, AdjustNewWindow, 1000
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
    if not IsObject(ARRANGEMENT["blacklist"]) {
      ARRANGEMENT["blacklist"] := Object()
    }
    if not IsObject(ARRANGEMENT["whitelist"]) {
      ARRANGEMENT["whitelist"] := Object()
    }
}

GetActiveWindowPath() {
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

BlacklistArrangementForActiveWindow() {
    global ARRANGEMENT
    windowPath := GetActiveWindowPath()
    ARRANGEMENT["blacklist"][windowPath] := true
    ARRANGEMENT["whitelist"].Delete(windowPath)
    SaveArrangement()
}

WhitelistArrangementForActiveWindow() {
    global ARRANGEMENT
    windowPath := GetActiveWindowPath()
    ARRANGEMENT["whitelist"][windowPath] := true
    ARRANGEMENT["blacklist"].Delete(windowPath)
    SaveArrangement()
}

IgnoreArrangementForActiveWindow() {
    global ARRANGEMENT
    windowPath := GetActiveWindowPath()
    ARRANGEMENT["whitelist"].Delete(windowPath)
    ARRANGEMENT["blacklist"].Delete(windowPath)
}

IsActiveWindowBorderless() {
    WinGet s, Style, A
    if (not s & +0xC00000) {
      return true
    }
    return false
}

IsActiveWindowSizeboxed() {
    WinGet, s, Style, A
    return s & 0x40000
}

IsActiveWindowArrangable() {
    global ARRANGEMENT
    if (ARRANGEMENT["blacklist"].HasKey(GetActiveWindowPath())) {
      return false
    }
    if (ARRANGEMENT["whitelist"].HasKey(GetActiveWindowPath())) {
      return true
    }
    if (IsActiveWindowBorderless()) {
      return false
    }
    return true
}

SaveActiveWindowDirection(direction) {
    global ARRANGEMENT
    key := GetActiveWindowPath()
    ARRANGEMENT["windows"][key] := direction
    SaveArrangement()
}

ActiveWinInfo() {
    WinGetTitle, title, A
    WinGetClass, klass, A
    WinGet processPath, ProcessPath, A
    WinGet id, ID, A
    return Format("{1}:{2}[{3}]{4}", processPath, klass, id, title)
}

AdjustNewWindow() {
    seen := IsActiveWindowSeen()
    arrangable := IsActiveWindowArrangable()
    wininfo := ActiveWinInfo()
    if not seen {
      LogDebug(Format("win: {1}, seen: {2}, arrangable: {3}", wininfo, seen, arrangable))
    }
    if not seen and arrangable {
      windowPath := GetActiveWindowPath()
      if ARRANGEMENT["windows"].HasKey(windowPath) {
        MoveActiveWinByDirection(ARRANGEMENT["windows"][windowPath])
      }
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
