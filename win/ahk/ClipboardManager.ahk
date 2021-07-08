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
    Send ^v
    Sleep 500
}

CopyAndFetch() {
    Clipboard =
    Send, ^c ; simulate Ctrl+C (=selection in clipboard)
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
