# -*-mic2-options-*- -f fs --compress-disk-image=tar.bz2 --copy-kernel --record-pkgs=name --pkgmgr=zypp --arch=armv7hl -*-mic2-options-*-
# 
# Do not Edit! Generated by:
# kickstarter.py
# 

lang en_US.UTF-8
keyboard us
timezone --utc UTC
part / --size 1500 --ondisk sda --fstype=ext3
rootpw nemo

user --name nemo  --groups audio,video --password nemo 

repo --name=mer-core --baseurl=http://releases.merproject.org/releases/latest/builds/armv7hl/packages  --debuginfo
repo --name=nemo-ux --baseurl=http://repo.merproject.org/obs/nemo:/devel:/ux/latest_armv7hl/ 
repo --name=nemo-apps --baseurl=http://repo.merproject.org/obs/nemo:/devel:/apps/latest_armv7hl/ 
repo --name=nemo-adaptation-bbb --baseurl=http://repo.merproject.org/obs/home:/mike7b4:/bbb/latest_armv7hl/ 
repo --name=nemo-mw --baseurl=http://repo.merproject.org/obs/nemo:/devel:/mw/latest_armv7hl/ 
#repo --name=nemo-adaptation-n9xx-common --baseurl=http://repo.merproject.org/obs/nemo:/devel:/hw:/ti:/omap3:/n9xx-common/latest_armv7hl/ 
repo --name=mer-qt --baseurl=http://repo.merproject.org/obs/mer:/qt:/devel/latest_armv7hl/

%packages
@Mer Core
connman
#@Nemo Complete Wayland
kernel-adaptation-sample
#ti-omap3-sgx-wayland-wsegl 

%end

%pre
touch $INSTALL_ROOT/.bootstrap
%end

%post
rm $INSTALL_ROOT/.bootstrap



## rpm-rebuilddb.post from mer-kickstarter-configs package
# Rebuild db using target's rpm
echo -n "Rebuilding db using target rpm.."
rm -f /var/lib/rpm/__db*
rpm --rebuilddb
echo "done"
## end rpm-rebuilddb.post

#if [ "@SSU_RELEASE_TYPE@" = "rnd" ]; then
#    [ -n "latest" ] && ssu release -r latest
#    [ -n "devel" ] && ssu flavour devel
#    ssu mode 2
#else
#    [ -n "latest" ] && ssu release latest
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
