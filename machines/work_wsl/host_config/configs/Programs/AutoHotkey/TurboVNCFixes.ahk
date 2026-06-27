#Requires AutoHotkey v2.0
#SingleInstance Force

; Tell AHK to match partial titles (1 = Match anywhere)
SetTitleMatchMode 1 

#HotIf WinActive("TurboVNC")

; Remap Alt+Space to F12 
!Space::Send "^+{F12}"

; Remap RAlt + Shift to temporary disable keyboard grabbing
~RAlt & Shift::Send "^!+g"

#HotIf