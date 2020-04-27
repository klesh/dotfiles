#!/usr/bin/env fish

if test -z (pidof i3lock)
  if test -e ~/.config/locking.png
    i3lock -i ~/.config/locking.png -t
  else
    i3lock -c 000000
  end
end
