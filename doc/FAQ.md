# FAQ

## Linux sleep crashes for amd cpu
1. Edit  `/etc/default/grub`: add `amd_iommu=off` to `GRUB_CMDLINE_LINUX_DEFAULT` 
2. Save, and run `sudo grub-mkconfig -o /boot/grub/grub.cfg`
3. Reboot
