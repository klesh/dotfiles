# refer
1. install vaapi vdpau package:
    archlinux
    ```sh
    sudo pacman -S libva-mesa-driver mesa-vdpau xf86-video-ati
    ```
2. enable following flags:
  - chrome://flags/#ignore-gpu-blocklist
  - chrome://flags/#enable-accelerated-video-decode
3. verification
  - chrome://gpu

# references

- [How To Enable Hardware Accelerated Video Decode In Google Chrome, Brave, Vivaldi And Opera Browsers On Debian, Ubuntu Or Linux Mint - Linux Uprising Blog](https://www.linuxuprising.com/2021/01/how-to-enable-hardware-accelerated.html)

```
google-chrome-stable --use-gl=desktop --enable-features=VaapiVideoDecoder
```
