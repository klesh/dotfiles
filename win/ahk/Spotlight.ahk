
Spotlight() {
    global

    SPOTLIGHT_ITEMS := 10
    SPOTLIGHT_FONT_NAME := "Sarasa Mono SC Nerd"
    SPOTLIGHT_ITEM_FONT_STYLE := "s14 ceeeeee"
    SPOTLIGHT_SELECTED_ITEM_FONT_STYLE := "s14 c007acc"

    spotlightSelectedIndex := 1
    keyword := ""
    windows := GetWindowList()

    ; window position
    GetCursorMonGeometry(x, y, w, h)
    ww := w * 0.5
    wh := h * 0.3
    wx := x + w / 2 - ww / 2
    wy := y + h / 2 - wh / 2

    Gui, New, +Theme -Border +AlwaysOnTop, Spotlight
    Gui, Font, %SPOTLIGHT_ITEM_FONT_STYLE%, %SPOTLIGHT_FONT_NAME%
    Gui, Color, 252526

    ; search box
    keywordX := 10
    keywordY := 10
    keywordW := ww - 20
    keywordH := 30
    Gui, Add, Edit, x%keywordX% y%keywordY% w%keywordW% h%keywordH% c252525 gOnChange vKeywordEdit

    ; ok button
    Gui, Add, Button, Default Hidden gOnEnter, Ok

    ; result items
    Loop %SPOTLIGHT_ITEMS% {
        ItemEdit%A_Index% := null
        Gui, Add, Text, w%keywordW% vItemEdit%A_Index%
    }

    ; load windows
    FilterWindowList()

    ; show window on center
    Gui, Show, X %wx% Y %wy% W %ww% H %wh%
    spotlightSelectedIndex := spotlightSelectedIndex + 1
    FilterWindowList()

    Return

    OnChange:
        GuiControlGet, keyword, , KeywordEdit
        FilterWindowList()
    Return

    OnEnter:
        WinActivate, ahk_id %spotlightSelectedWindowId%
        SetCursorToCenterOfActiveWin()
        Gui, Destroy
    Return

    GuiEscape:
        Gui, Destroy
    Return
}

FilterWindowList() {
    global
    local index := 1

    kw := keyword
    sl := 1
    idx := RegExMatch(keyword, " \d")
    if (idx) {
        kw := SubStr(keyword, 1, idx-1)
        sl := SubStr(keyword, idx+1)
    }
    LogDebug("keyword {1}, selected {2}", kw, sl)
    for winIndex, win in windows {
        name := win[1]
        id := win[2]
        if (name and InStr(name, kw)) {
            suffix := ""
            if (sl = index) {
                Gui, Font, %SPOTLIGHT_SELECTED_ITEM_FONT_STYLE%, %SPOTLIGHT_FONT_NAME%
                spotlightSelectedWindowId := id
                suffix := " <<< "
            } else {
                Gui, Font, %SPOTLIGHT_ITEM_FONT_STYLE%, %SPOTLIGHT_FONT_NAME%
            }
            name := Format("{1} {2} {3}", index, name, suffix)
            GuiControl, Font, ItemEdit%index%
            GuiControl, , ItemEdit%index%, %name%
            index := index + 1
        }
    }
    While index < SPOTLIGHT_ITEMS {
        GuiControl, , ItemEdit%index%
        index := index + 1
    }
}

GetWindowList() {
    WinGet windows, List
    wins := Array()
    LogDebug("A_Gui: {1}", A_Gui)
    Loop %windows% {
        id := windows%A_Index%
        WinGetTitle wt, ahk_id %id%
        if (id = A_Gui or !wt) {
            Continue
        }
        WinGet wp, ProcessName, ahk_id %id%
        name := Format("{1:-20} {2}", wp, wt)
        wins.Push(Array(name, id))
    }
    return wins
}