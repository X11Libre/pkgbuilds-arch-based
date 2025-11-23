#!/bin/sh

# Maintainer : artist for XLibre (artist4xlibre at proton dot me)
# Script     : install-xlibre.sh
# Version    : 0.2.3
# Repository : To be used only together with the XLibre binary arch repo:
#                https://x11libre.net/repo/arch_based/x86_64

# Note: this script requires 'sudo' to perform the installation

#############################################
#                                           #
# To run this script:                       #
# - save it as file: install-xlibre.sh      #
# - run command: chmod +x install-xlibre.sh #
# - run command: ./install-xlibre.sh        #
#                                           #
#############################################

if ! pacman-key -f 73580DE2EDDFA6D6  1> /dev/null 2>&1 ; then
  printf '\n'
  printf '%s\n' 'Obtaning, importing and adding pacman key'
  sudo sh -c 'curl -sS https://x11libre.net/repo/arch_based/x86_64/0x73580DE2EDDFA6D6.gpg | gpg --import -'
  sudo pacman-key --recv-keys 73580DE2EDDFA6D6
  sudo pacman-key --finger 73580DE2EDDFA6D6
  sudo pacman-key --lsign-key 73580DE2EDDFA6D6
fi

if ! grep -q '\[xlibre\]' /etc/pacman.conf ; then
  printf '\n'
  printf '%s\n' 'Adding the xlibre repository to file /etc/pacman.conf'
  sudo sh -c "printf '%s\n' '[xlibre]'  >> /etc/pacman.conf"
  sudo sh -c "printf '%s\n' ' Server = https://x11libre.net/repo/arch_based/x86_64/' >> /etc/pacman.conf"
fi 

printf '\n'
printf '%s\n' 'Refreshing pacman database caches'
sudo pacman -Syy

printf '\n'
printf '%s\n' 'Checking which XLibre packages to install to replace Xorg'
xlbpkgs="xlibre-xserver"
xlbxf86pkgs="xlibre-input-libinput"

xorgpkgs=$(pacman -Qq|grep '^xorg-server')
for p in $xorgpkgs ; do
  if [[ "$p" != "xorg-server" ]]; then
    xlbpkgs="$xlbpkgs ${p/xorg-/xlibre-x}"
  fi
done

xf86pkgs=$(pacman -Qq|grep '^xf86-')
for p in $xf86pkgs ; do
  if [[ "$p" != "xf86-input-libinput" ]]; then
    xlbxf86pkgs="$xlbxf86pkgs ${p/xf86-/xlibre-}"
  fi
done

xlballpkgs="$xlbpkgs $xlbxf86pkgs"

printf '\n'
printf '%s\n' 'Running pacman to install all required XLibre packages'
printf '%s\n' 'Enter Y for each package to replace it with the xlibre package'
sudo pacman -S $xlballpkgs

