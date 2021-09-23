#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen ; mouse coordinates relative to the screen

; =========================
; DEBUGGING
; =========================
global DEBUGGING := False

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

SetDisableLockWorkstationRegKeyValue(value) {
    RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation, %value%
}


LockWorkStation() {
    SetDisableLockWorkstationRegKeyValue( 0 )
    ; Lock
    DllCall( "User32\LockWorkStation" )
    ; Disable locking again
    SetDisableLockWorkstationRegKeyValue( 1 )
}

; =========================
; LIBS
; =========================
InitWindowManager()
InitClipboardManager()
; SetDisableLockWorkstationRegKeyValue(1)  ; in order to remap win+l
#Include, ahk\JSON.ahk
#Include, ahk\WindowManager.ahk
#Include, ahk\ClipboardManager.ahk
#Include, ahk\Spotlight.ahk


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
#BS::LockWorkStation()

; WINDOW MANAGER

; Win + j                       => Focus right window
#j:: FocusWinByDirection("right")
; Win + k                       => Focus left window
#k:: FocusWinByDirection("left")
; Win + f                       => Move active window as monocle
#f::ArrangeActiveWindow("monocle")
; Win + Shift + j               => Move active window to right side
#+j::ArrangeActiveWindow("right")
; Win + Shift + k               => Move active window to left side
#+k::ArrangeActiveWindow("left")
; Win + Shift + b               => Blacklist active window so it won't be arranged when launched
#+b::BlacklistArrangementForActiveWindow()
; Win + Shift + b               => Whitelist active window so it always be arranged when launched
#+w::WhitelistArrangementForActiveWindow()
; Win + Shift + g               => Remove active window from Blacklist/Whitelist
#+g::IgnoreArrangementForActiveWindow()
; Win + Shift + d               => Toggle debug logging
#+d::ToggleDebugging()
#u::MoveCursorToMonitor("left")
#i::MoveCursorToMonitor("right")
#+u::MoveWindowToMonitor("left")
#+i::MoveWindowToMonitor("right")


; SPOTLIGHT
#p::Spotlight()

; CLIPBOARD MANAGER
#c::AlternativeCopy()
#+c::CopyClipboardToAlternative()
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