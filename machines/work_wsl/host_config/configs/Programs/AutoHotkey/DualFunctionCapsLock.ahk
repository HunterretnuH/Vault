#Requires AutoHotkey v2.0
#SingleInstance Force
A_MenuMaskKey := "vkFF"  ; Prevents the Windows Start Menu from popping up on Ctrl release

; 1. Map physical Escape to toggle CapsLock natively on Windows.
; The '$' prevents an infinite loop when the script programmatically sends Escape.
$Esc::CapsLock

; 2. Map physical CapsLock to Ctrl (hold) and Escape (tap with timeout).
*CapsLock::
{
    StartTime := A_TickCount
    Send "{Blind}{LControl Down}"
    
    ; Wait until the user physically releases the Caps Lock key
    KeyWait "CapsLock"
    
    Send "{Blind}{LControl Up}"
    
    ; Calculate exactly how long the key was held down (in milliseconds)
    ElapsedTime := A_TickCount - StartTime
    
    ; ONLY emit Escape if:
    ; - No other key was pressed during the hold (A_PriorKey == "CapsLock")
    ; - The key was held for LESS than 200 milliseconds
    if (A_PriorKey = "CapsLock" && ElapsedTime < 200)
    {
        Send "{Escape}"
    }
}