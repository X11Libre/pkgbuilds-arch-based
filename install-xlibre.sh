#!/bin/sh

# Maintainer : artist for XLibre (artist4xlibre at proton dot me)
# Script     : install-xlibre.sh
# Version    : 0.2.3
# Repository : To be used only together with the XLibre binary arch repo:
#                https://x11libre.net/repo/arch_based/x86_64

# Note: this script requires root permissions to perform the installation (if not root, it requires 'sudo' or 'doas' installed)

#############################################
#                                           #
# To run this script:                       #
# - save it as file: install-xlibre.sh      #
# - run command: chmod +x install-xlibre.sh #
# - run command: ./install-xlibre.sh        #
#                                           #
#############################################

PACMAN_CONFIRMATION=${PACMAN_CONFIRMATION:-true}

if [ $EUID -ne 0 ]; then
  if command -v doas 1>/dev/null; then
    runasroot=doas
  elif command -v sudo 1>/dev/null; then
    runasroot=sudo
  else
    printf '\n'
    printf '%s\n' 'ERROR: No root permissions, sudo or doas are not installed, exiting'
    exit 1
  fi
else
  runasroot=""
fi

if ! pacman-key -f 73580DE2EDDFA6D6  1> /dev/null 2>&1 ; then
  printf '\n'
  printf '%s\n' 'Obtaning, importing and adding pacman key'
  $runasroot sh -c 'curl -sS https://x11libre.net/repo/arch_based/x86_64/0x73580DE2EDDFA6D6.gpg | gpg --import -'
  $runasroot pacman-key --recv-keys 73580DE2EDDFA6D6
  $runasroot pacman-key --finger 73580DE2EDDFA6D6
  $runasroot pacman-key --lsign-key 73580DE2EDDFA6D6
fi

if ! grep -q '\[xlibre\]' /etc/pacman.conf ; then
  printf '\n'
  printf '%s\n' 'Adding the xlibre repository to file /etc/pacman.conf'
  $runasroot sh -c "printf '%s\n' '[xlibre]'  >> /etc/pacman.conf"
  $runasroot sh -c "printf '%s\n' ' Server = https://x11libre.net/repo/arch_based/x86_64/' >> /etc/pacman.conf"
fi 

printf '\n'
printf '%s\n' 'Refreshing pacman database caches'
if [ "$PACMAN_CONFIRMATION" = true ]; then
  $runasroot pacman -Syy
else
  $runasroot pacman -Syy --noconfirm
fi

printf '\n'
printf '%s\n' 'Checking which XLibre packages to install to replace Xorg'
xlbpkgs="xlibre-xserver"
xlbxf86pkgs="xlibre-input-libinput"

xorgpkgs=$(pacman -Qq|grep '^xorg-server')
for p in $xorgpkgs ; do
  if [ "$p" != "xorg-server" ]; then
    xlbpkgs="$xlbpkgs ${p/xorg-/xlibre-x}"
  fi
done

xf86pkgs=$(pacman -Qq|grep '^xf86-')
for p in $xf86pkgs ; do
  if [ "$p" != "xf86-input-libinput" ]; then
    xlbxf86pkgs="$xlbxf86pkgs ${p/xf86-/xlibre-}"
  fi
done

xlballpkgs="$xlbpkgs $xlbxf86pkgs"

printf '\n'
printf '%s\n' 'Running pacman to install all required XLibre packages'
if [ "$PACMAN_CONFIRMATION" = true ]; then
  printf '%s\n' 'Enter Y for each package to replace it with the xlibre package'
  $runasroot pacman -S $xlballpkgs
else
  $runasroot pacman -S --noconfirm --ask 4 $xlballpkgs
fi
