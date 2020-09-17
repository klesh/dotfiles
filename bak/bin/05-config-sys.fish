#!/usr/bin/env fish

if test (id -u) -ne 0
  set script_name (status --current-filename)
  echo "please run this script as `sudo $script_name`"
  exit -1
end

set DIR (dirname (dirname (readlink -f (status --current-filename))))
set DRYRUN 0

function run-cmd
  if [ "$DRYRUN" = "1" ]
    echo $argv
  else
    eval $argv
  end
end

echo '1. enlarge font size for HiDPI console'
run-cmd "echo 'FONT=ter-u24b' > /etc/vconsole.conf"

echo '2. enlarge font size for HiDPI disk encryption interface'
echo make sure that `keyboard consolefont` hooks are before `encrypt` in /etc/mkinitcpio.conf
read -l -P 'Are you sure that HOOKS were set properly? [y/N]: ' answer
if [ "$answer" != 'y' ]
  echo skip disk decryption interface enhancement...``
else
  run-cmd mkinitcpio -p linux
end

echo '3. enhance font rendering for CJK users'
run-cmd ln -sf /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
run-cmd ln -sf /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
run-cmd ln -sf /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
run-cmd cp $DIR/fonts/freetype2.sh /etc/profile.d/freetype2.sh
run-cmd cp $DIR/fonts/local.conf /etc/fonts/local.conf

echo '4. setting autologin on tty1'
read -l -P 'Please enter autologin username (empty to skip): ' username
if test -z "$username"
  echo skip autologin setup
else
  run-cmd mkdir -p /etc/systemd/system/getty@tty1.service.d
  run-cmd sed -r "s/USERNAME/$username/g" $DIR/systemd/getty1-override.conf > /etc/systemd/system/getty@tty1.service.d/override.conf
end

# install lock-on-suspend
#echo '5. install lock-on-suspend for systemd'
## make sure locking before suspended
#cp $DIR/systemd/lock-on-suspend.service /etc/systemd/system/
#systemctl enable lock-on-suspend

# make Thunar show image size on status bar
xfconf-query --channel thunar --property /misc-image-size-in-statusbar --create --type bool --set true

echo 'FINISHED'
