#!/bin/bash
chr_ver=6.48.5
cd /tmp
wget --no-check-certificate ...
unzip chr-$chr_ver.img.zip
dd if=chr-$chr_ver.img of=/dev/sda
reboot