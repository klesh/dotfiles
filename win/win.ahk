^Esc:: Send ^{``}
*#q:: !F4
#Esc:: Reload


^BS::
  Send ^a
  Send {BS}
  return


#=::SoundSet,+5
#-::SoundSet,-5
#BS::#l


; Ctrl + Alt + v : paste as plain text
^!v::
    Clip0 = %ClipBoardAll%
    ClipBoard = %ClipBoard% ; Convert to plain text
    Send ^v
    Sleep 1000
    ClipBoard = %Clip0%
    VarSetCapacity(Clip0, 0) ; Free memory
Return

^+!v::
    Clip0 = %ClipBoardAll%
    ClipBoard := StrReplace(ClipBoard, "\", "/") ; Convert to plain text
    Send ^v
    Sleep 1000
    ClipBoard = %Clip0%
    VarSetCapacity(Clip0, 0) ; Free memory
Return

#IfWinActive ahk_class mintty
  ^+v::Send +{Ins}
  ^+c::Send ^{Ins}
#IfWinActive


#f:: WinMaximize, A
#+f:: WinRestore, A
#+h:: #+Left
#+l:: #+Right
#,:: #Left
#.:: #Right


; Capslock & h:: Send {Left}
; Capslock & j:: Send {Down}
; Capslock & k:: Send {Up}
; Capslock & l:: Send {Right}
; Capslock & -:: Send {Volume_Down}
; Capslock & =:: Send {Volume_Up}
; Capslock & \:: Send {Media_Play_Pause}
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

MoveCursorMon(toRight) {
  CoordMode, Mouse, Screen ; mouse coordinates relative to the screen
  MouseGetPos, MouseX, MouseY
  ; MsgBox % Format("x: {:d}, y: {:d}, wid: {:d}, sw: {:d}, sh: {:d}", MouseX, MouseY, WinId, A_ScreenWidth, A_ScreenHeight)
  ; if (MouseX > A_ScreenWidth) {
  ;   MouseMove, -A_ScreenWidth, 0, 0, R
  ; } else {
  ;   MouseMove, A_ScreenWidth, 0, 0, R
  ; }
  SysGet, mc, MonitorCount
  mi := 0
  x := -10000
  if (toRight)
    x:= 10000
  y := MouseY
  loop {
    SysGet, mon, Monitor, %mi%
    monX := Floor((monLeft + monRight) / 2)
    monY := Floor((monTop + monBottom) / 2)
    if (toRight and monLeft > MouseX and monX < x) Or (!toRight and monRight < MouseX and monX > x) {
      x := monX
      y := monY
    }
    if (++mi >= mc)
      break
  }
  ; MouseMove, x, y
  DllCall("SetCursorPos", "int", x, "int", y)
  MouseGetPos, MouseX, MouseY, WinId
  WinActivate, ahk_id %WinId%
}

#u:: MoveCursorMon(False)
#i:: MoveCursorMon(True)

~#1 Up::
~#2 Up::
~#3 Up::
~#4 Up::
~#5 Up::
~#6 Up::
~#7 Up::
~#8 Up::
~#9 Up::
  Sleep 0.5
  WinGetPos, x, y, w, h, A
  DllCall("SetCursorPos", "int", x + w / 2, "int", y + h / 2)
  return