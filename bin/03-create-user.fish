#!/usr/bin/env fish

if test -z "$argv"
  echo please provide a user name to proceed
  exit -1
end
useradd -G wheel,docker -m $argv
