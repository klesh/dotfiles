#!/bin/env fontforge
# Usage: fontforge -script ttc2ttf.pe /path/to/font.ttc

fonts = FontsInFile($1)
n = SizeOf(fonts)
i = 0
while (i < n)
    Open($1 + "(" + fonts[i] + ")", 1)

    index = ToString(i + 1)
    if (i < 9)
        index = "0" + index
    endif

    ext = ".ttf"
    if ($order == 3)
        ext = ".otf"
    endif

    filename = $fontname + ext
    Generate(filename)
    Print(filename)
    Close()
    ++i
endloop
