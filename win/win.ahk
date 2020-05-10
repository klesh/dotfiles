^Esc:: Send ^{``}
*#q:: Send {LAlt down}{F4}{LAlt up}


^BS::
  Send ^a
  Send {BS}
  return


#=::SoundSet,+5
#-::SoundSet,-5


; Ctrl + Shift + v : paste as plain text
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


#IfWinActive ahk_class ConsoleWindowClass
  ^+v:: MouseClick, Right
  ^+c:: MouseClick, Right
#IfWinActive


#IfWinActive ahk_class mintty
  ^+v::Send +{Ins}
  ^+c::Send ^{Ins}
#IfWinActive


#f:: WinMaximize, A
#+f:: WinRestore, A
#+l:: Send {LWinDown}{Right}{LWinUp}
#+h:: Send {LWinDown}{Left}{LWinUp}


Capslock & h:: Send {Left}
Capslock & j:: Send {Down}
Capslock & k:: Send {Up}
Capslock & l:: Send {Right}
Capslock & -:: Send {Volume_Down}
Capslock & =:: Send {Volume_Up}
Capslock & \:: Send {Media_Play_Pause}
Capslock & y:: Send {Browser_Back}
Capslock & u:: Send ^{PgUp}
Capslock & i:: Send ^{PgDn}
Capslock & o:: Send {Browser_Forward}
Capslock & BackSpace:: Send {Del}

Capslock & n:: Send {Home}
Capslock & m:: Send {PgUp}
Capslock & ,:: Send {PgDn}
Capslock & .:: Send {End}

Capslock & Space:: SetCapsLockState % !GetKeyState("CapsLock", "T") 
+CapsLock::
  Send {~}
  SetCapsLockState % !GetKeyState("CapsLock", "T")
Return
Capslock::return
