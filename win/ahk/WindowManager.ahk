; WINDOWS MANAGER

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
    LogDebug("InitWindowManager")
    ; global RATIO := 0.618
    global RATIO := 0.382
    global ID_SEEN := Object()
    global ARRANGEMENT := Object()
    global ARRANGEMENT_PATH := A_AppData . "\arrangement.json"
    global PADDING := 10
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
    GetMonGeometryByPos(MouseX, MouseY, x, y, w, h)
}

GetActiveWindowMonGeometry(ByRef x, ByRef y, ByRef w, ByRef h) {
    WinGetPos, wx, wy, ww, wh, A
    GetMonGeometryByPos(wx + ww / 2, wy + wh / 2, x, y, w, h)
}

GetMonGeometryByPos(px, py, ByRef x, ByRef y, ByRef w, ByRef h) {
    ; find monitor by position
    SysGet, mc, MonitorCount
    mi := 0
    loop {
      if (mi > mc) {
          break
      }
      SysGet, mon, MonitorWorkArea, %mi%
      if (monLeft < px and monRight > px and monTop < py and monBottom > py) {
          x := monLeft
          y := monTop
          w := monRight - monLeft
          h := monBottom - monTop
          return
      }
      mi := mi + 1
    }
    msg := Format("unable to find monitor for pos {1}, {2}", px, py)
    MsgBox, %msg%
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

GetActiveWindowMargins(hwnd, monX, monY, monW, monH, ByRef l, ByRef t, ByRef r, ByRef b) {
    Static Dummy5693
          ,RECTPlus
          ,S_OK:=0x0
          ,DWMWA_EXTENDED_FRAME_BOUNDS:=9

    ;-- Workaround for AutoHotkey Basic
    PtrType:=(A_PtrSize=8) ? "Ptr":"UInt"

    ;-- Get the window's dimensions (excluding shadows)
    ;   Note: Only the first 16 bytes of the RECTPlus structure are used by the
    ;   DwmGetWindowAttribute and GetWindowRect functions.
    VarSetCapacity(RECTPlus,32,0)
    DWMRC:=DllCall("dwmapi\DwmGetWindowAttribute"
        ,PtrType,hwnd                                   ;-- hwnd
        ,"UInt",DWMWA_EXTENDED_FRAME_BOUNDS             ;-- dwAttribute
        ,PtrType,&RECTPlus                              ;-- pvAttribute
        ,"UInt",16)                                     ;-- cbAttribute

    if (DWMRC<>S_OK)
    {
        if ErrorLevel in -3,-4  ;-- Dll or function not found (older than Vista)
        {
            ;-- Do nothing else (for now)
        }
        else
        {
            outputdebug,
               (ltrim join`s
                Function: %A_ThisFunc% -
                Unknown error calling "dwmapi\DwmGetWindowAttribute".
                RC=%DWMRC%,
                ErrorLevel=%ErrorLevel%,
                A_LastError=%A_LastError%.
                "GetWindowRect" used instead.
               )
        }

        ;-- Collect the position and size from "GetWindowRect"
        DllCall("GetWindowRect",PtrType,hWindow,PtrType,&RECTPlus)
    }

    ;-- Populate the output variables
    x1 := NumGet(RECTPlus,0,"Int")
    y1 := NumGet(RECTPlus,4,"Int")
    x2 := NumGet(RECTPlus,8,"Int")
    y2 := NumGet(RECTPlus,12,"Int")

    WinGetPos, winX, winY, winW, winH, A
    ;-- Convert to scaled unit
    scale := Round((x2 - x1) / winW*10)/10
    x1 := (x1 - monX) / scale + monX
    y1 := (y1 - monY) / scale + monY
    x2 := (x2 - monX) / scale + monX
    y2 := (y2 - monY) / scale + monY
    w := (x2 - x1)
    h := (y2 - y1)
    l := x1 - winX
    t := y1 - winY
    r := winX+winW-x2
    b := winY+winH-y2
    LogDebug("active window margins: {1} {2} {3} {4}", l, t, r, b)
}

MoveActiveWinByDirection(direction) {
    WinGet, isMax, MinMax, A
    if (isMax) {
      WinRestore, A
    }
    global RATIO
    global PADDING
    activeWinId := WinExist("A")
    GetActiveWindowMonGeometry(x, y, w, h)
    GetActiveWindowMargins(activeWinId, x, y, w, h, l, t, r, b)
    LogDebug("monitor geometry x: {1}, y: {2}, w: {3}, h: {4}", x, y, w, h)
    ; left
    wx := x
    wy := y
    ww := floor(w * RATIO)
    wh := h
    LogDebug("left geometry: x: {1}, y: {2}, w: {3}, h: {4}", wx, wy, ww, wh)
    ; right
    if (direction = "right") {
      wx := wx + ww + floor(PADDING / 2)
      ww := w - ww
    LogDebug("right geometry: x: {1}, y: {2}, w: {3}, h: {4}", wx, wy, ww, wh)
    } else {
      wx := wx + PADDING
    }
    ; adjust for aero margins
    wx := wx - l
    wy := wy - t
    ww := ww + l + r
    wh := wh + t + b
    ; padding
    ww := ww - floor(PADDING * 1.5)
    wy := wy + PADDING
    wh := wh - PADDING * 2
    WinMove, A,, wx, wy, ww, wh
    LogDebug("move win to x: {1}, y: {2}, w: {3}, h: {4}", wx, wy, ww, wh)
    SaveActiveWindowDirection(direction)
}

SaveArrangement() {
    global ARRANGEMENT
    global ARRANGEMENT_PATH
    LogDebug("SaveArrangement to {1} start", ARRANGEMENT_PATH)
    file := FileOpen(ARRANGEMENT_PATH, "w")
    file.Write(JSON.Dump(ARRANGEMENT,, 2))
    file.Close()
    LogDebug("SaveArrangement end")
}

LoadArrangement() {
    global ARRANGEMENT
    global ARRANGEMENT_PATH
    LogDebug("LoadArrangement start {1}", ARRANGEMENT_PATH)
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
    LogDebug("LoadArrangement end")
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
    global ARRANGEMENT
    seen := IsActiveWindowSeen()
    arrangable := IsActiveWindowArrangable()
    wininfo := ActiveWinInfo()
    if not seen {
      LogDebug("win: {1}, seen: {2}, arrangable: {3}", wininfo, seen, arrangable)
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
