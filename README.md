# MPV Stereo Downmix
This is a .lua script for MPV that automatically downmixes surround sound to old school stereo with a customizable mix.

Current supported surround sound layouts:
  - 2.1
  - 4.0
  - 5.1
  - 7.1

If you want to adjust the current parameters you can change the values in the downmix_presets table in auto-downmix.lua to suit your needs.
Previous methods I've used have relied on profiles to downmix the sound which kept interfering with other profiles used to apply shaders, so having it separate in a script seemed a better way.


# Installation
Download auto-downmix.lua and place it in your scripts folder. (~/.config/mpv/scripts on Linux)


# Channel layout and parameters
For 5.1 Surround Sound:
| Channel | Abbreviation | Description | Position |
| --- | --- | --- | --- |
| 1 | FL | Front Left | Left of the listener |
| 2 | FR | Front Right | Right of the listener |
| 3 | FC | Front Center (Dialogue) | Center, in front |
| 4 | LFE | Low-Frequency Effects (Subwoofer) | Typically placed anywhere (non-directional) |
| 5 | SL | Side Left (Surround Left) | Left side of the listener |
| 6 | SR | Side Right (Surround Right) | Right side of the listener |


# Troubleshooting
The script have been tested on these setups:
  - Arch Linux, KDE Plasma 6 Wayland, Pipewire, AMD GPU (mesa drivers)
  - Arch Linux, KDE Plasma 6 Wayland, Pipewire, Nvidia GPU (580xx-dkms drivers)

I can't guarantee it will work if the audio is manipulated with in other scripts or in your mpv.conf file.
A first step is to comment out anything related to --audio-channels=<auto-safe|auto|layouts> or --ad-lavc-downmix=<yes|no> in your conf file.
