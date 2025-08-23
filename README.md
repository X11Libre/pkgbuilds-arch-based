
Arch Derivative PKGBUILDS for Xlibre
====================================

Note: these official Xlibre PKGBUILD files are also being made available in the Arch User Repostory (AUR) by the maintainer named 'xlibre'.

This repository provides PKBUILD files for building Xlibre packages on Arch Linux derivative distributions and Arch Linux itself.\
The procedure to do this is documented here and meant for package users and maintainters.\
Artix Linux users should not use this procedure but use the packages provided by their distribution.


Important notices
-----------------

* In the Xorg repository the 'TearFree' option was been enabled by default quite some time ago, but this code was never released.\
Xlibre did release the code, so it does have the 'TearFree' option enabled by default.
* The scope of the Xlibre project is only to replace the xorg-server and xf86 driver packages, not other xorg packages like eg. xorg-xwayland.


Repository layout and usage
---------------------------

Each directory contains the PKGBUILD and related files to build the installable package as .zst file. This can be done with eg. command `makepkg`.

The procedure is the same for all packages:
* change directory into the one of the package
* install the required (make)depends
* build the package
* install the package or add it to a repository so subsequent package builds can use it


Conditions related to the order of building xlibre packages
-----------------------------------------------------------

Note that an xlibre-xserver update from 25.0.0.x to 26.0.0.x is considered a major version updade; an update from 25.0.0.3 to 25.0.0.4 is not as this just a minor version update, also known as hotfix.

* A major update will increase the Module ABI versions in the Xlibre packages.
* Before a major updade of xlibre-xserver - and only then - a new version of the xlibre-xf86-input-libinput PKGBUILD file must be downloaded and this package built; this to acommodate for the increased ABI versions while building the xlibre-xserver and xlibre-xf86 packages.
* The major update is done by building the new version of the xlibre-xserver base package which builds the 6 xlibre-xserver packages.
* After a major updade of xlibre-xserver, all xlibre-xf86 driver packages need to be rebuilt.
* Once an Xlibre package has been built it should be used to replace its xorg counterpart, if installed.


Packages build procedure
------------------------

Note: when asked to remove conflicting xorg and xf86 packages when building, answer with: y\
When conflicting xf86 packages cannot be removed, use `pacman -Rdd` to force remove these.\
Keep a note of all removed xf86 packages and install the corresponding xlibre-xf86 ones during step 4!

#### 1. Build package xlibre-xf86-input-libinput v1.5.0.0 - this is only required after a major version update as explained above.
    Note this is a placeholder and will be replaced later in this procedure with a newer version.
- change directory into xlibre-xf86-input-libinput
- make sure xorg-server-devel is installed and also other dependencies from the PKGBUILD file
- build the package using eg. `makepkg`
- install the package:\
   `sudo pacman -U xlibre-xf86-input-libinput-1.5.0.0-1-x86_64.pkg.tar.zst`

#### 2. Build the xlibre-xserver packages
- change directory into xlibre-xserver
- make sure to install all dependencies from the PKGBUILD file like eg. xtrans, libxaw, xorg-font-util and meson
- remove conflicting packages that pacman cannot delete, eg.:\
   `sudo pacman -Rdd xf86-video-vmware xf86-input-vmmouse xf86-input-elographics xf86-input-evdev xf86-input-void xf86-input-wacom`
- build the package using eg. `makepkg`
- install these packages:\
   `sudo pacman -U xlibre-xserver-25.0.0.4-1-x86_64.pkg.tar.zst xlibre-xserver-common-25.0.0.4-1-x86_64.pkg.tar.zst xlibre-xserver-devel-25.0.0.4-1-x86_64.pkg.tar.zst`

#### 3. Build the actual xlibre-xf86-input-libinput package
- change directory once more into xlibre-xf86-input-libinput
- replace the PKGBUILD file with the final one for this package:\
   `mv PKGBUILD-1.5.0.1 PKGBUILD`
- build the package using eg. `makepkg`
- install the package:\
   `sudo pacman -U xlibre-xf86-input-libinput-1.5.1.0-1-x86_64.pkg.tar.zst`

#### 4. Build and install all xlibre packages of which the corresponding xorg one has been removed
This is done with the same procedure as in the previous steps.\
These packages might have to be installed when building:
- xlibre-xf86-input-wacom: gobject-introspection
- xlibre-xf86-video-qxl: spice-protocol libcacard spice
- xlibre-xf86-video-intel: libxvmc
 

Perform checks
--------------

- check there are no more xorg packages that need to be replaced:\
   `pacman -Q | grep 'xorg-server\|xf86-'`
- check that all required xlibre packages are installed:\
   `pacman -Q | grep 'xlibre-'`
- make SURE xlibre-xf86-input-libinput-1.5.0.1 or higher is installed!


Xlibre binary packages repository
---------------------------------

These are available in a separate xlibre repository which can be enabled with the following actions:

* Run commands:\
  `sudo curl -sS https://raw.githubusercontent.com/X11Libre/binpkg-arch-based/refs/heads/main/0x73580DE2EDDFA6D6.gpg | gpg --import -`\
  `sudo pacman-key --lsign-key 73580DE2EDDFA6D6`
* Add the xlibre repository by adding this section to file /etc/pacman.conf:\
  `[xlibre]`\
  `Server = https://github.com/X11Libre/binpkg-arch-based/raw/refs/heads/main/`\
  `# List of available packages: https://github.com/artist4xlibre/packages-arch-based`


Closed source drivers
---------------------

Closed source drivers might not have an updated ABI version to match that of the updated xlibre-xserver. This can be overcome by creating a file named eg. /etc/X11/xorg.conf.d/xlibre.conf containing:

`Section "ServerFlags"`\
`        Option "IgnoreABI" "true"`\
`EndSection`


Questions and answers
---------------------

* Q. How to check which X server and drivers are installed?\
A1. Check the X11 vendor string using:\
  `sudo Xorg -version`\
A2. List the installed X packages with:\
  `pacman -Q | grep 'xlibre-xserver\|xorg-server\|xf86-'`


Available packages
------------------

| Package | Git repository | Release tag |
| --- | --- | --- |
| xlibre-xserver                | https://github.com/X11Libre/xlibre-xserver         | xlibre-xserver-25.0.0.7               |
| xlibre-xserver-common         | https://github.com/X11Libre/xlibre-xserver         | xlibre-xserver-common-25.0.0.7        |
| xlibre-xserver-devel          | https://github.com/X11Libre/xlibre-xserver         | xlibre-xserver-devel-25.0.0.7         |
| xlibre-xserver-xephyr         | https://github.com/X11Libre/xlibre-xserver         | xlibre-xserver-xephyr-25.0.0.7        |
| xlibre-xserver-xnest          | https://github.com/X11Libre/xlibre-xserver         | xlibre-xserver-xnest-25.0.0.7         |
| xlibre-xserver-xvfb           | https://github.com/X11Libre/xlibre-xserver         | xlibre-xserver-xvfb-25.0.0.7          |
| xlibre-xf86-input-elographics | https://github.com/X11Libre/xf86-input-elographics | xlibre-xf86-input-elographics-1.4.4.1 |
| xlibre-xf86-input-evdev       | https://github.com/X11Libre/xf86-input-evdev       | xlibre-xf86-input-evdev-2.11.0.1      |
| xlibre-xf86-input-void        | https://github.com/X11Libre/xf86-input-void        | xlibre-xf86-input-void-1.4.2.1        |
| xlibre-xf86-input-synaptics   | https://github.com/X11Libre/xf86-input-synaptics   | xlibre-xf86-input-synaptics-1.10.0.1  |
| xlibre-xf86-input-vmmouse     | https://github.com/X11Libre/xf86-input-vmmouse     | xlibre-xf86-input-vmmouse-13.2.0.1    |
| xlibre-xf86-input-wacom       | https://github.com/X11Libre/xf86-input-wacom       | xlibre-xf86-input-wacom-1.2.3.1       |
| xlibre-xf86-video-amdgpu      | https://github.com/X11Libre/xf86-video-amdgpu      | xlibre-xf86-video-amdgpu-23.0.0.3     |
| xlibre-xf86-video-ati         | https://github.com/X11Libre/xf86-video-ati         | xfree-xf86-video-ati-22.0.0.1         |
| xlibre-xf86-video-dummy       | https://github.com/X11Libre/xf86-video-dummy       | xlibre-xf86-video-dummy-0.4.1.1       |
| xlibre-xf86-video-fbdev       | https://github.com/X11Libre/xf86-video-fbdev       | xlibre-xf86-video-fbdev-0.5.1.1       |
| xlibre-xf86-video-intel       | https://github.com/X11Libre/xf86-video-intel       | xlibre-xf86-video-intel-3.0.0.1       |
| xlibre-xf86-video-nouveau     | https://github.com/X11Libre/xf86-video-nouveau     | xlibre-xf86-video-nouveau-1.0.18.1    |
| xlibre-xf86-video-nv          | https://github.com/X11Libre/xf86-video-nv          | xlibre-xf86-video-nv-2.1.23.1         |
| xlibre-xf86-video-qxl         | https://github.com/X11Libre/xf86-video-qxl         | xlibre-xf86-video-qxl-0.1.6.1         |
| xlibre-xf86-video-sisusb      | https://github.com/X11Libre/xf86-video-sisusb      | xlibre-xf86-video-sisusb-0.9.7.1      |
| xlibre-xf86-video-vesa        | https://github.com/X11Libre/xf86-video-vesa        | xlibre-xf86-video-vesa-2.6.0.1        |
| xlibre-xf86-video-vmware      | https://github.com/X11Libre/xf86-video-vmware      | xlibre-xf86-video-vmware-13.4.0.1     |
| xlibre-xf86-video-voodoo      | https://github.com/X11Libre/xf86-video-voodoo      | xlibre-xf86-video-voodoo-1.2.6.1      |

\
_artist for Xlibre_

