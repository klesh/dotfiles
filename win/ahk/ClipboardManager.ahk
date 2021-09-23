; CLIPBOARD

InitClipboardManager() {
}

ConvertClipboardToPlainText() {
    ClipBoard = %ClipBoard%
}

ConvertClipboardToUnixPath() {
    ClipBoard := StrReplace(ClipBoard, "\", "/") ;
}

BorrowClipboard(funcName, params*) {
    Clip0 = %ClipBoardAll%
    result := %funcName%(params*)
    ClipBoard = %Clip0%
    VarSetCapacity(Clip0, 0) ; Free memory
    return result
}

PasteAsPlainText() {
    BorrowClipboard("PasteAs", "ConvertClipboardToPlainText")
}

PasteAsUnixPath() {
    BorrowClipboard("PasteAs", "ConvertClipboardToUnixPath")
}

PasteAs(convertFuncName) {
    %convertFuncName%()
    Paste()
    Sleep 500
}

Copy() {
    if WinActive("ahk_exe WindowsTerminal.exe") {
        Send, ^+c
    } else {
        Send, ^c
    }
}

Paste() {
    if WinActive("ahk_exe WindowsTerminal.exe") {
        Send, ^+v
    } else {
        Send, ^v
    }
}

CopyAndFetch() {
    Clipboard =
    Copy()
    ClipWait, 0, 1 ; wait until clipboard contains data
    selection = %Clipboard% ; save the content of the clipboard
    return selection
}

GetSelectedText() {
    return BorrowClipboard("CopyAndFetch")
}

AlternativeCopy() {
    global ALTERNATIVE_CLIPBOARD
    ALTERNATIVE_CLIPBOARD := GetSelectedText()
}

AlternativePaste() {
    BorrowClipboard("PasteAs", "LoadAlternativeToClipboard")
}

LoadAlternativeToClipboard() {
    global ALTERNATIVE_CLIPBOARD
    Clipboard = %ALTERNATIVE_CLIPBOARD%
}

CopyClipboardToAlternative() {
    global ALTERNATIVE_CLIPBOARD
    ALTERNATIVE_CLIPBOARD = %ClipBoardAll%
}