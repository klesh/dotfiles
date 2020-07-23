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

MoveMouseAct(x, y) {
  DllCall("SetCursorPos", "int", x, "int", y)
  MouseGetPos, MouseX, MouseY, WinId
  WinActivate, ahk_id %WinId%
}

MoveCursorMon(toRight) {
  CoordMode, Mouse, Screen ; mouse coordinates relative to the screen
  MouseGetPos, MouseX, MouseY
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
  MoveMouseAct(x, y)
}

MoveCursorWin(toRight) {
  CoordMode, Mouse, Screen ; mouse coordinates relative to the screen
  MouseGetPos, MouseX, MouseY
  ; find current monitor
  SysGet, mc, MonitorCount
  mi := 0
  loop {
    SysGet, mon, Monitor, %mi%
    if (monLeft < MouseX and monRight > MouseX) {
      x := monLeft + (monRight - monLeft) * (toRight ? 0.75 : 0.25)
      y := monTop + monBottom / 2
      DllCall("SetCursorPos", "int", x, "int", y)
      MoveMouseAct(x, y)
      break
    }
    if (++mi >= mc)
      break
  }
}


#f:: WinMaximize, A
#+f:: WinRestore, A
#,:: #Left
#.:: #Right
#+u:: #+Left
#+i:: #+Right
#u:: MoveCursorMon(False)
#i:: MoveCursorMon(True)
#k:: MoveCursorWin(False)
#j:: MoveCursorWin(True)

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