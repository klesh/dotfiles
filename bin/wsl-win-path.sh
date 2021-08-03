#!/bin/sh

cmd.exe /c 'echo '$1 2>/dev/null | awk '{sub("C:", "/mnt/c"); gsub("\\\\","/"); gsub("\r$", ""); print}'
