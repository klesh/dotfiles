
# About

OS / Software / Tools setup scripts to my personal taste, might not suit your need but welcome to COPY and Paste.

# Directory

```sh
├── bin             # useful scripts
├── cli             # cli tools setup scripts
├── devel           # development tools setup scripts
├── doc             # setup document for those can't be automated
├── env.sh          # common env detection for cli/gui/devel setup scripts
├── gui             # gui tools setup script
├── README.md
└── win             # setup scripts for windows
```

# bin

- `a2h`
  convert ascii doc to html with asciidocter
- `bm`
  Simple bookmark opener, fuzzy search `~/.config/bookmarks.md` and open with default browser
- `br`
  Replace REGEX with NEWSTR for multiple files listed from stdin
- `charfont`
  Draw specified character with pango-view and see which font were actually used
- `dbe`
  Dbeaver used to have this flicking issue, seems fixed (2021-08-28)
- `decrypt_dbeaver_passwords`
  Just like the file name
- `dl_google_drive`
  Download file with `wget` from google drive so proxy can be used
- `docker_registry_catalog`
  List images on docker registry
- `download-yt-audio.sh`
  Just like the file name
- `download-yt-playlist.sh`
  Just like the file name
- `download-yt-video.sh`
  Just like the file name
- `ffmpeghelper`
  Some video editing operation for ffmpeg
- `font-patcher`
  Modified from nerd font patcher
- `fr`
  Replace REGEX with NEWSTR, show preview when ran with REP=1 EnvVar
- `generate_fontstyle`
  Generate Bold/Italic style from for font who has only Normal style
- `groff_ttf.sh`
  Generate font file from ttf that could be used by groff
- `htpasswd-entry`
  Encode username/password to htpasswd format
- `ls_vsc_cache`
  List vscode cache
- `mediacut`
  Video editing script
- `mergesrt`
  Merge multi language srt files into one
- `pinentry-wsl-ps1.sh`
  Delegate gnupg password prompt to Windows host
- `print_colors`
  Preview colors of console
- `rds`
  Connect to a remote redis server through ssh server
- `s`
  ssh wrapper to auto rename tmux window name
- `sc`
  Screencast recording with ffmpeg
- `ubuntu-ssh-wakes-sleeping-hd.sh`
  Script to fix ssh login waking up sleeping hard-drive on Ubuntu
- `unttc.sh`
  Decompress ttc to ttfs
- `virt-install.sh`
  Create a virtual machine with virsh
- `ws`
  Send websocket request to host for debugging
- `wsl-win-path.sh`
  Convert Windows path to WSL path
- `x-open`
  Like `open` on `macOS` but cross platform
