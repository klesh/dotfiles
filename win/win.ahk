#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen ; mouse coordinates relative to the screen

; =========================
; DEBUGGING
; =========================
global DEBUGGING := true

ToggleDebugging() {
    global DEBUGGING
    DEBUGGING := not DEBUGGING
}

LogDebug(params*) {
    global DEBUGGING
    if (not DEBUGGING) {
      return
    }
    FormatTIme, now, , MM-dd HH:mm:ss
    log := FileOpen("d:\win.ahk.log", "a")
    log.WriteLine(Format("[{1}] {2}", now, Format(params*)))
    log.Close()
}


; =========================
; LIBS
; =========================
InitWindowManager()
InitClipboardManager()
#Include, ahk\JSON.ahk
#Include, ahk\WinGetPosEx.ahk
#Include, ahk\WindowManager.ahk
#Include, ahk\ClipboardManager.ahk


; =========================
; KEY BINDINGS
; =========================
; Super + Shift + r             => Reload ahk
#+r::Reload
; Ctrl + ESC                    => Ctrl+`
^Esc:: Send ^{``}
; Win + q                     => Close window
#q:: !F4
; Ctrl+ backspace               => Delete all text
^BS::
    Send ^a
    Send {BS}
    return
; Win + =                       => Increase Volume
#=::SoundSet, +5
; Win + -                       => Decrease volume
#-::SoundSet, -5
; Win + \                       => Toggle mute
#\::Send {Volume_Mute}
; Win + backspace               => Lock
#BS::#l

; WINDOW MANAGER

; Win + f                       => Toggle window maximum
#f:: ToggleActiveWinMaximum()
; Win + j                       => Focus right window
#j:: FocusWinByDirection("right")
; Win + k                       => Focus left window
#k:: FocusWinByDirection("left")
; Win + Shift + j               => Move active window to right side
#+j::MoveActiveWinByDirection("right")
; Win + Shift + k               => Move active window to left side
#+k::MoveActiveWinByDirection("left")
; Win + Shift + b               => Blacklist active window so it won't be arranged when launched
#+b::BlacklistArrangementForActiveWindow()
; Win + Shift + b               => Whitelist active window so it always be arranged when launched
#+w::WhitelistArrangementForActiveWindow()
; Win + Shift + i               => Remove active window from Blacklist/Whitelist
#+i::IgnoreArrangementForActiveWindow()
; Win + Shift + d               => Toggle debug logging
#+d::ToggleDebugging()


; CLIPBOARD MANAGER
#c::AlternativeCopy()
#v::AlternativePaste()


; CAPSLOCK AS HYBRID KEY

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
