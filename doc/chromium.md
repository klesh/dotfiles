1. install vaapi vdpau package:
    archlinux
    ```sh
    sudo pacman -S libva-mesa-driver mesa-vdpau
    ```
2. enable following flags:
  - chrome://flags/#ignore-gpu-blocklist
  - chrome://flags/#enable-accelerated-video-decode
3. verification
  - chrome://gpu
