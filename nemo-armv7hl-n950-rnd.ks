#version=DEVEL
user --groups=audio,video,users --name=nemo --password=nemo
# Keyboard layouts
keyboard us
# Root password
rootpw --plaintext nemo
# System language
lang en_US.UTF-8
# Installation logging level
logging --level=info

# System timezone
timezone --isUtc UTC
# Default Desktop Settings
desktop  --autologinuser=meego
repo --name="mer-core" --baseurl=http://repo.merproject.org/obs/mer-core:/armv7hl:/devel/Core_armv7hl/ --debuginfo --ssl_verify=yes
repo --name="nemo-ux" --baseurl=http://repo.merproject.org/obs/nemo:/devel:/ux/mer-core_armv7hl_devel/ --ssl_verify=yes

TODO: this is still building against old nemo:devel:mw, needs transitioning to mer-core
repo --name="nemo-apps" --baseurl=http://repo.merproject.org/obs/nemo:/devel:/apps/latest_armv7hl/ --ssl_verify=yes

repo --name=nemo-adaptation-n950-n9         --baseurl=http://repo.merproject.org/obs/nemo:/devel:/hw:/ti:/omap3:/n950-n9/next_armv7hl/ 
repo --name=nemo-adaptation-n9xx-common     --baseurl=http://repo.merproject.org/obs/nemo:/devel:/hw:/ti:/omap3:/n9xx-common/next_armv7hl/ 
# Disk partitioning information
part / --fstype="ext3" --ondisk=sda --size=1500

%pre
touch $INSTALL_ROOT/.bootstrap
%end

%post
rm $INSTALL_ROOT/.bootstrap

## hack by hedayat to get wifi/cmt working
sed -i 's/at_console="true"/group="users"/g' /etc/dbus-1/system.d/*

## rpm-rebuilddb.post from mer-kickstarter-configs package
# Rebuild db using target's rpm
echo -n "Rebuilding db using target rpm.."
rm -f /var/lib/rpm/__db*
rpm --rebuilddb
echo "done"
## end rpm-rebuilddb.post

#if [ "@SSU_RELEASE_TYPE@" = "rnd" ]; then
#   [ -n "@NEMO_RELEASE@" ] && ssu release -r @NEMO_RELEASE@
#    [ -n "@FLAVOUR@" ] && ssu flavour @FLAVOUR@
#    ssu mode 2
#else
#    [ -n "@NEMO_RELEASE@" ] && ssu release @NEMO_RELEASE@
#    ssu mode 4
#fi

## arch-armv7hl.post from mer-kickstarter-configs package
# Without this line the rpm don't get the architecture right.
echo -n 'armv7hl-meego-linux' > /etc/rpm/platform

# Also libzypp has problems in autodetecting the architecture so we force tha as well.
# https://bugs.meego.com/show_bug.cgi?id=11484
echo 'arch = armv7hl' >> /etc/zypp/zypp.conf
## end arch-armv7hl.post

%end

%post --nochroot
if [ -n "$IMG_NAME" ]; then
    echo "BUILD: $IMG_NAME" >> $INSTALL_ROOT/etc/meego-release
fi


%end

%packages

#TODO: fix battery detectiong/charging
#bme blob is linking explicitly to libdsme.so.0.2.0, but libdsme now exports libdsme.so.0.3.0
#We need a workaround, either a symlink from 0.2.0 to 0.3.0 or something similar
#bme-rm-680-bin
#these pull in bme bins
#statefs-provider-bme
#upower-bme

PackageKit-Qt5
PackageKit-glib
PackageKit-zypp
PackageKit
alsa-lib
attr
augeas-libs
basesystem
bash
bluez-configs-mer
bluez-libs
bluez
boardname
boost-filesystem
boost-system
bzip2-libs
bzip2
ca-certificates
cairo
check
cjkuni-fonts
commhistory-daemon
connman-qt5-declarative
connman-qt5
connman-test
connman
contactsd
cor
coreutils
crda
curl
db4-utils
db4
dbus-glib
dbus-libs
dbus-python
dbus
deltarpm
desktop-file-utils
diffutils
droid-sans-fonts
droid-sans-mono-fonts
droid-serif-fonts
dsme
e2fsprogs-libs
e2fsprogs
elfutils-libelf
exempi
expat
farstream
fbset
file-libs
file
filesystem
findutils
fingerterm
flac
fontconfig
fontpackages-filesystem
freetype
fuse-libs
fuse
gawk
gconf
gdb
gdbm
giflib
glesplash
glib-networking
glib2
glibc-common
glibc
gmime
gnupg2
gnutls
google-opensans-fonts
grep
gst-omapfb
gst-plugins-bad-free
gst-plugins-base
gst-plugins-good
gstreamer
gstreamer0.10-nokia-videosrc
gzip
hwdata
info
iotop
iproute
iptables
iputils
iw
json-c
kbd
kcalcore-qt5
kernel-adaptation-n950
kmod-libs
kmod
lcms-libs
lcms
libICE
libSM
libX11
libXau
libXaw
libXdamage
libXext
libXfixes
libXft
libXi
libXmu
libXpm
libXrender
libXt
libXtst
libXv
libaccounts-glib-tools
libaccounts-glib
libaccounts-qt5
libacl
libarchive
libasyncns
libattr
libblkid
libcal-rm-680-bin
libcanberra
libcap
libcmtspeechdata
libcom_err
libcommhistory-qt5-declarative
libcommhistory-qt5-tools
libcommhistory-qt5
libcontacts-qt5
libcontentaction-qt5
libcreds3
libcurl
libdbus-qeventloop-qt5
libdrm
libdsme
libenca-libenca0
libenca
liberation-fonts-common
liberation-mono-fonts
liberation-sans-fonts
liberation-serif-fonts
libexif
libffi
libgcc
libgcrypt
libgpg-error
libgsf
libgudev1
libical
libicu
libidn
libiodata-qt5
libiphb
libiptcdata
libjpeg-turbo
libksba
liblua
libmlocale-qt5
libngf-qt5
libnice
libnl
libnl1
libogg
libomap3camd
libpng
libmeegotouchevents-qt5
libngf-client
libqmfclient1-qt5
libqmfmessageserver1-qt5
libqofono-qt5
libqt5sparql-tracker-direct
libqt5sparql
libqtwebkit5-widgets
libqtwebkit5
libquillmetadata-qt5
libresource
libresourceqt-qt5
libsailfishkeyprovider
libshadowutils
libsignon-glib
libsignon-qt5
libsmack
libsndfile
libsolv-tools
libsolv0
libsoup
libss
libstdc++
libsysfs
libtasn1
libtheora
libtiff
libtool-ltdl
libtrace
#libudev
libusb
libusb1
libuser
libutempter
libuuid
libvisual
libvorbis
libwl1271-bin
libxcb
libxkbcommon
libxkbfile
libxml2
libxslt
libzypp
lipstick-glacier-home-qt5
lipstick-qt5-tools-ui
lipstick-qt5-tools
lipstick-qt5
linux-firmware-ti-connectivity
lsb-release
lsof
lynx
maliit-framework-wayland-inputcontext
maliit-framework-wayland
maliit-plugins
mapplauncherd-booster-qtcomponents-qt5
mapplauncherd-qt5
mapplauncherd
mce-tools
mce
mce-config-legacy
mer-gfx-tests
mer-release
mkcal-qt5
mlite-qt5
mobile-broadband-provider-info
mtdev
multi_c_rehash
n950-camera-fw
nano
ncurses-base
ncurses-libs
ncurses
nemo-configs-n950-n9-wayland
nemo-configs-n950-n9
nemo-mobile-session-common
nemo-mobile-session-wayland
nemo-qml-plugin-accounts-qt5
nemo-qml-plugin-configuration-qt5
nemo-qml-plugin-contacts-qt5-tools
nemo-qml-plugin-contacts-qt5
nemo-qml-plugin-dbus-qt5
nemo-qml-plugin-messages-internal-qt5
nemo-qml-plugin-notifications-qt5
nemo-qml-plugin-signon-qt5
nemo-qml-plugin-systemsettings
nemo-qml-plugin-thumbnailer-qt5
nemo-qml-plugin-time-qt5
nemo-theme-glacier
net-tools
ngfd-settings-nemo
ngfd
nspr
nss-softokn-freebl
nss-sysinit
nss
ofono-tests
ofono
ohm-configs-default
ohm-plugin-core
ohm
omap-update-display
oneshot
openssh-clients
openssh-server
openssh
openssl-libs
orc
pacrunner
pam
pango
passwd
pcre
pixman
policy-settings-basic-n950
polkit
poppler-glib
poppler
popt
prelink
procps
profiled-settings-nemo
profiled
psmisc
pth
pulseaudio-module-cmtspeech-n9xx
pulseaudio-modules-nemo-common
pulseaudio-modules-nemo-mainvolume
pulseaudio-modules-nemo-music
pulseaudio-modules-nemo-parameters
pulseaudio-modules-nemo-record
pulseaudio-modules-nemo-stream-restore
pulseaudio-modules-nemo-voice
pulseaudio-policy-enforcement
pulseaudio-settings-n950
pulseaudio
pygobject2
python-libs
python
qmlcalc
qmlcalendar
qmlgallery
qmlmaps
qmlmusicplayer
qmlnotes
qmlpackagemanager
qmlpinquery
qmlsettings-account-plugin-email
qmlsettings-account-plugin-jabber
qmlsettings
qmsystem-qt5
qt-components-qt5-gallery
qt-components-qt5
qt5-plugin-generic-evdev
qt5-plugin-imageformat-jpeg
qt5-plugin-platform-eglfs
qt5-plugin-platform-minimal
qt5-plugin-sqldriver-sqlite
qt5-qt3d
qt5-qtconcurrent
qt5-qtcore
qt5-qtdbus
qt5-qtdeclarative-import-localstorageplugin
qt5-qtdeclarative-import-location
qt5-qtdeclarative-import-multimedia
qt5-qtdeclarative-import-qtquick2plugin
qt5-qtdeclarative-import-window2
qt5-qtdeclarative-import-xmllistmodel
qt5-qtdeclarative-pim-organizer
qt5-qtdeclarative-qmlscene
qt5-qtdeclarative-qtquick
qt5-qtdeclarative
qt5-qtdocgallery
qt5-qtfeedback
qt5-qtgraphicaleffects
qt5-qtgui
qt5-qtlocation
qt5-qtmultimedia-gsttools
qt5-qtmultimedia-plugin-mediaservice-gstmediaplayer
qt5-qtmultimedia
qt5-qtnetwork
qt5-qtopengl
qt5-qtpim-contacts
qt5-qtpim-organizer
qt5-qtpim-versit
qt5-qtpim-versitorganizer
qt5-qtpositioning
qt5-qtprintsupport
qt5-qtquickcontrols-nemo-examples
qt5-qtsensors-plugin-sensorfw
qt5-qtsensors
qt5-qtserviceframework
qt5-qtsql
qt5-qtsvg-plugin-imageformat-svg
qt5-qtsvg
qt5-qtsysteminfo
qt5-qtwayland-wayland_egl-examples
qt5-qtwayland-wayland_egl
qt5-qtwebkit-uiprocess-launcher
qt5-qtwidgets
qt5-qtxml
qt5-qtxmlpatterns
qtcontacts-sqlite-qt5
quillimagefilter-qt5
readline
recode
rootfiles
rpm-libs
rpm
screen
sed
sensorfw-qt5-configs
sensorfw-qt5
setup
shadow-utils
shared-mime-info
signon-qt5
sound-theme-freedesktop
speex
sqlite
ssu
statefs-contextkit-subscriber
statefs-pp
statefs-qt5
statefs
sysfsutils
systemd-config-mer
systemd-analyze
systemd-libs
systemd-user-session-targets
systemd
taglib
tar
telepathy-accounts-signon
telepathy-farstream
telepathy-glib
telepathy-mission-control
telepathy-qt5-farstream
telepathy-qt5
telepathy-ring
ti-omap3-sgx
ti-wl1273-bt-firmware
ti-wl1273-fm-radio-firmware
time
timed-qt5
tinycdb
tone-generator
totem-pl-parser
tracker-utils
tracker
tumbler
tzdata-timed
tzdata
udev-rules-n950
unzip
usb-moded-config-n950-n9
usb-moded
usbutils
util-linux
v8
vim-common
vim-enhanced
vim-filesystem
vim-minimal
voicecall-qt5
voicecall-ui-reference
wayland
wget
wireless-regdb
wireless-tools
wl1271-cal-bin
wpa_supplicant
xdg-user-dirs
xdg-utils
xkeyboard-config
xorg-x11-filesystem
xorg-x11-xkb-utils
xz-libs
xz
zlib
zypper


%end
