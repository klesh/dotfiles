
Spotlight() {
    global

    SPOTLIGHT_FONT_NAME := "Sarasa Mono SC"
    SPOTLIGHT_ITEM_FONT_STYLE := "s14 ceeeeee"
    SPOTLIGHT_SELECTED_ITEM_FONT_STYLE := "s14 c007acc"

    SPOTLIGHT_ITEMS := 10
    SPOTLIGHT_SELECTED_INDEX := 1
    SPOTLIGHT_SELECTED_ITEM := null

    ; window position
    GetCursorMonGeometry(x, y, w, h)
    ww := w * 0.5
    wh := h * 0.3
    wx := x + w / 2 - ww / 2
    wy := y + h / 2 - wh / 2

    Gui, New, +Theme -Border +AlwaysOnTop -0xc00000, Spotlight
    Gui, Font, %SPOTLIGHT_ITEM_FONT_STYLE%, %SPOTLIGHT_FONT_NAME%
    Gui, Color, 252526

    ; search box
    userInputX := 10
    userInputY := 10
    userInputW := ww - 20
    userInputH := 30
    Gui, Add, Edit, x%userInputX% y%userInputY% w%userInputW% h%userInputH% c252525 gOnChange vUserInputEdit

    ; ok button
    Gui, Add, Button, Default Hidden gOnEnter, Ok

    ; result items
    Loop %SPOTLIGHT_ITEMS% {
        ItemEdit%A_Index% := null
        Gui, Add, Text, w%userInputW% vItemEdit%A_Index%
    }

    ; parse keyword
    SpotlightProcessUserInput()

    ; show window on center
    Gui, Show, X %wx% Y %wy% W %ww% H %wh%
    Return

    OnChange:
        local userInput := ""
        GuiControlGet, userInput, , UserInputEdit
        SpotlightProcessUserInput(userInput)
    Return

    OnEnter:
        SpotlightProcessUserInput(userInput, 1)
        Gui, Destroy
    Return

    GuiEscape:
        Gui, Destroy
    Return
}

SpotlightProcessUserInput(userInput := "", stage := 0) {
    global SPOTLIGHT_SELECTED_INDEX := 1
    mode := ""
    idx := 0

    ; extract "<mode-sign> " as mode, current only '>' as command mode
    idx := RegExMatch(userInput, ">")
    if (idx) {
        mode := SubStr(userInput, 1, 1)
        userInput := SubStr(userInput, 2)
    }

    ; extract " <number>" as selected index
    idx := RegExMatch(userInput, " \d")
    if (idx) {
        SPOTLIGHT_SELECTED_INDEX := SubStr(userInput, idx+1)
        userInput := SubStr(userInput, 1, idx-1)
    }

    LogDebug("SPOTLIGHT >>> mode {1} input {2} stage {3}", mode, userInput, stage)
    ; enter mode subroutine
    if (mode = ">") {
        SpotlightRunCommand(userInput, stage)
    } else {
        SpotlightSwitchWindow(userInput, stage)
    }
}

SpotlightUpdateItems(items) {
    global
    LogDebug("SPOTLIGHT >>> update ui items, count {1}, first text {2}", items.Length(), items[1][1])

    ; make sure items within limit
    while (items.Length() > SPOTLIGHT_ITEMS) {
        items.Pop()
    }
    ; update first n lines
    for itemIndex, item in items {
        itemText := item[1]
        if (itemIndex = SPOTLIGHT_SELECTED_INDEX) {
            Gui, Font, %SPOTLIGHT_SELECTED_ITEM_FONT_STYLE%, %SPOTLIGHT_FONT_NAME%
            itemText := itemText . " <<< "
            SPOTLIGHT_SELECTED_ITEM := item
        } else {
            Gui, Font, %SPOTLIGHT_ITEM_FONT_STYLE%, %SPOTLIGHT_FONT_NAME%
        }
        lineText := Format("{1} {2}", itemIndex, itemText)
        LogDebug("SPOTLIGHT >>> line {1}", lineText)
        GuiControl, Font, ItemEdit%itemIndex%
        GuiControl, , ItemEdit%itemIndex%, %lineText%
    }
    ; clear contents of rest lines
    While itemIndex <= SPOTLIGHT_ITEMS {
        itemIndex := itemIndex + 1
        GuiControl, , ItemEdit%itemIndex%
    }
}

SpotlightRunCommand(command, stage) {
    funcName := Format("cmd_{1}", command)
    if (IsFunc(funcName)) {
        %funcName%()
    }
}

SpotlightSwitchWindow(keyword, stage) {
    global SPOTLIGHT_SELECTED_ITEM
    LogDebug("SPOTLIGHT >>> switch window mode, keyword {1}, stage {2}", keyword, stage)
    if (stage = 1) {
        winId := SPOTLIGHT_SELECTED_ITEM[2]
        LogDebug("SPOTLIGHT >>> switch to window {1} item length {2}", winId, SPOTLIGHT_SELECTED_ITEM.Length())
        WinActivate, ahk_id %winId%
        SetCursorToCenterOfActiveWin()
        return
    }

    items := Array()
    WinGet windows, List
    Loop %windows% {
        winId := windows%A_Index%
        if (A_DefaultGui = winId) {
            LogDebug("SPOTLIGHT >>> skip default gui: {2}", winId, A_DefaultGui)
            Continue
        }
        WinGetTitle winTitle, ahk_id %winId%
        if (!winTitle) {
            Continue
        }
        WinGet procName, ProcessName, ahk_id %winId%
        itemText := Format("{1:-20} {2}", procName, winTitle)
        if (itemText and !InStr(itemText, keyword)) {
            Continue
        }
        items.Push(Array(itemText, winId))
    }
    SpotlightUpdateItems(items)
}

cmd_wt() {
    TIMEZONES := { "North American": -3, "Hezheng Yin": -7, "Camille": +2 }

    items := Array()
    for zone, offset in TIMEZONES {
        dt = %A_NowUTC%
        dt += offset, Hours
        FormatTime, timeText, %dt%, dd ddd HH:mm
        items.Push(Array(Format("{1:-20} {2}", zone, timeText)))
    }
    SpotlightUpdateItems(items)
}