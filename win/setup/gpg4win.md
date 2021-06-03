
# download

[gpg4win](https://www.gpg4win.org/)
[browserpass native client](https://github.com/browserpass/browserpass-native/releases/latest)

# restore keys

```
gpg --import path\to\publickey.asc
gpg --import path\to\privatekey.asc
```

# auto start gpg-agent

1. `win+r`, input `shell:start`
2. create shortcut to `"C:\Program Files (x86)\GnuPG\bin\gpgconf.exe" --launch gpg-agent` with run type `minimized`


