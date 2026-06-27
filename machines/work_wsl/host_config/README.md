
# Host (Windows) Instructions

1. Install:
    * AHK
    * PulseAudio (`C://Users/$USER/Programs/PulseAudio`)
    * TurboVNC.
2. Run `copy_host_configs.sh`
4. Start TurboVNC and connect to `localhost:5912`

> [!NOTE]: Replaced NSSM with simple shortcut to PulseAudio in autostart to remove NSSM dependancy.
>         If PulseAudio is unstable then consider going back to NSSM.
