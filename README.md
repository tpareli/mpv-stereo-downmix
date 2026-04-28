# MPV Stereo Downmix
This is a .lua script for MPV that downmixes surround sound to old school stereo with a customizable mix, utilising MPV's implementation of FFmpeg's lavfi filtering library.

Suitable for typical stereo setups with 2 loudspeakers or headphones.

Current supported surround sound layouts:
  - 2.1
  - 4.0
  - 5.1
  - 7.1

Previous methods I've used relied on profiles to downmix the sound which kept interfering with other shader profiles, so having it separate in a script seemed a cleaner way.


# Installation
Download auto-downmix.lua and place it in your scripts folder. 

Default directory location on linux is 
```
~/.config/mpv/scripts
```

# Channel layout, parameters and coefficients
For 5.1 Surround Sound:
| Channel | Abbreviation | Description | Position |
| --- | --- | --- | --- |
| 1 | FL | Front Left | Left of the listener |
| 2 | FR | Front Right | Right of the listener |
| 3 | FC | Front Center (Dialogue) | Center, in front |
| 4 | LFE | Low-Frequency Effects (Subwoofer) | Typically placed anywhere (non-directional) |
| 5 | SL | Side Left (Surround Left) | Left side of the listener |
| 6 | SR | Side Right (Surround Right) | Right side of the listener |

For 7.1 Surround Sound:
| Channel | Abbreviation | Description | Position |
| --- | --- | --- | --- |
| 1 | FL | Front Left | Left of the listener |
| 2 | FR | Front Right | Right of the listener |
| 3 | FC | Front Center (Dialogue) | Center, in front |
| 4 | LFE | Low-Frequency Effects (Subwoofer) | Typically placed anywhere (non-directional) |
| 5 | SL | Side Left (Surround Left) | Left side of the listener |
| 6 | SR | Side Right (Surround Right) | Right side of the listener |
| 7 | BL | Back Left (Rear Surround Left) | Behind the listener, left |
| 8 | BR | Back Right (Rear Surround Right) | Behind the listener, right |


### Example
If you want to adjust the current parameters you can change the values in the downmix_presets table in auto-downmix.lua.
So if you want more dialogue in your stereo mix you can adjust the Front Center (FC) coefficient.

Example using 5.1 downmix:

Change the default
```
lavfi=[pan=stereo|FL=FL+0.707*FC+0.5*SL+0.3*LFE|FR=FR+0.707*FC+0.5*SR+0.3*LFE]
```

to
```
lavfi=[pan=stereo|FL=FL+0.9*FC+0.5*SL+0.3*LFE|FR=FR+0.9*FC+0.5*SR+0.3*LFE]
```

NB: There is no normalisation of audio after these effects are applied (yet). If you expereience clipping or distortion try enabling audio-normalize-downmix=yes in your mpv.conf file (no guarantee it will work, as downmixing happens outside of the mpv.conf file)

# Troubleshooting
The script have been tested on these setups:
  - Arch Linux, KDE Plasma 6 (Wayland), Pipewire audio, AMD GPU (mesa drivers)
  - Arch Linux, KDE Plasma 6 (Wayland), Pipewire audio, Nvidia GPU (nvidia-580xx-dkms drivers)

I can't guarantee it will work if the audio is manipulated with in other scripts or in your mpv.conf file.

A first step is to comment out anything related to --audio-channels=<auto-safe|auto|layouts> or --ad-lavc-downmix=<yes|no> in your conf file.

Enabling the Playback statistics overview and checking the Audio section should show Channels: 6 -> 2 for 5.1 audio and 8 -> 2 for 7.1, with the appropriate filter applied visible at the bottom of the audio section. 

The current audio channel count detection should work with all common audio codecs.
