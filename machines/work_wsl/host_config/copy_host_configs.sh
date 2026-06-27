#!/usr/bin/env bash

WIN_USER=$(cmd.exe /c "echo %USERNAME%" | tr -d '\r')

# Copy configs
cp -r configs/* /mnt/c/Users/$WIN_USER/

# Generate Shortcuts in Windows Startup dir.
# Uses Windows PowerShell to build native binary (.lnk) shortcuts.

owershell.exe -Command "
    # 1. Initialize the Windows Script Host COM object for shortcut creation
    \$WshShell = New-Object -ComObject WScript.Shell;
    
    # 2. Grab standard Windows environment paths dynamically
    \$StartupFolder = \"\$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\";
    \$UserDir       = \"C:\Users\\\" + \$env:USERNAME;

    # -------------------------------------------------------------------------
    # SHORTCUT 1: PulseAudio
    # -------------------------------------------------------------------------
    \$PulseLink = \$WshShell.CreateShortcut(\"\$StartupFolder\PulseAudio.lnk\");
    \$PulseLink.TargetPath = \"\$UserDir\Programs\PulseAudio\bin\pulseaudio.exe\";
    
    # We resolve '../config.pa' to an absolute path here to prevent Windows 
    # from losing the file during boot-stage execution. 
    # (The double-quotes ensure paths with spaces don't break the argument)
    \$PulseLink.Arguments = \"-F \"\"\$UserDir\Programs\PulseAudio\config.pa\"\"\";
    
    # Set the working directory to the 'bin' folder for underlying process safety
    \$PulseLink.WorkingDirectory = \"\$UserDir\Programs\PulseAudio\bin\";
    \$PulseLink.Save();


    # -------------------------------------------------------------------------
    # SHORTCUT 2: AutoHotkey - DualFunctionCapsLock
    # -------------------------------------------------------------------------
    \$AhkLink1 = \$WshShell.CreateShortcut(\"\$StartupFolder\DualFunctionCapsLock.lnk\");
    
    # Targetting the .ahk file directly works perfectly as long as AutoHotkey 
    # is set as the default application handler for .ahk files on Windows.
    \$AhkLink1.TargetPath = \"\$UserDir\Programs\Autohotkey\DualFunctionCapsLock.ahk\";
    \$AhkLink1.Save();


    # -------------------------------------------------------------------------
    # SHORTCUT 3: AutoHotkey - TurboVNCFixes
    # -------------------------------------------------------------------------
    \$AhkLink2 = \$WshShell.CreateShortcut(\"\$StartupFolder\TurboVNCFixes.lnk\");
    \$AhkLink2.TargetPath = \"\$UserDir\Programs\Autohotkey\TurboVNCFixes.ahk\";
    \$AhkLink2.Save();
"
