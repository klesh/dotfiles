Set WshShell = WScript.CreateObject("WScript.Shell")
If wscript.arguments.count <2 then
    WshShell.run "nvim-qt.exe"
Else
    sCmd = "nvim-qt.exe " & """" & wscript.arguments(1) &  """"
    WshShell.run sCmd
End If
