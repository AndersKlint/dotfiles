# Post install guide

firefox https://github.com/devangshekhawat/Fedora-39-Post-Install-Guide

setup rpm and vaapi from this guide

# Shell extensions

blur-my-shell@aunetx  
smart-auto-move@khimaros.com
sound-output-device-chooser@kgshank.net
dash-to-panel@jderose9.github.com  
user-theme@gnome-shell-extensions.gcampax.github.com
noannoyance-fork@vrba.dev
Vitals@CoreCoding.com

mkdir /tmp/savedesktop-tmp && git clone https://github.com/vikdevelop/SaveDesktop /tmp/savedesktop-tmp && python3 /tmp/savedesktop-tmp/native/native_installer.py --install && rm -rf /tmp/savedesktop-tmp
savedesktop
in app import fedora-desktop.sd.tar.gz

# ZSH

firefox https://medium.com/@satriajanaka09/setup-zsh-oh-my-zsh-powerlevel10k-on-ubuntu-20-04-c4a4052508fd

# Download music (soulseek client)

firefox https://github.com/Nicotine-Plus/nicotine-plus
flatpak install org.nicotine_plus.Nicotine

# Bitwig

firefox https://www.bitwig.com/previous_releases/
git clone https://github.com/teervo/bitwig-fedora.git
sudo dnf install rpm-build -y
cd bitwig-fedora/
ls
./bitwig.rpm.sh ~/Downloads/bitwig-studio-5.0.4.deb -y
sudo dnf install bitwig-studio-5.0.4-1.fc39.x86_64.rpm -y
if it fails, modify the script to:
QA_RPATHS=$(( 0x0001|0x0010|0x0002|0x0004|0x0008|0x0020 )) rpmbuild --build-in-place -bb $SPEC &&
Also change filenames in script for the archives in rpmbuid/SOURCES the reflect the actual ones

jar jar
sudo rm /opt/bitwig-studio/bin/bitwig.jar
sudo cp bitwig.jar /opt/bitwig-studio/bin/
ls -l /opt/bitwig-studio/bin/

This below is probably done with chezmoi now
dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/39/winehq.repo
sudo dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/39/winehq.repo
sudo dnf install wine
sudo dnf install wine-staging
sudo dnf install cabextract
sudo dnf copr enable patrickl/yabridge
sudo dnf install yabridge --refresh
yabridgectl status
export WINEPREFIX=/mnt/data/MusicProduction/VST

wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks
sh winetricks corefonts vcrun6
sudo dnf install cabextract
sh winetricks corefonts vcrun6
sh winetricks vcrun2019
sh winetricks gdiplus

# Lact

firefox https://github.com/ilya-zlobintsev/LACT/releases/
sudo systemctl enable --now lactd

# Fix suspend on Gigabyte PC

sudo cp /mnt/data/LinuxSetup/disable-gpp0-wakeup/disable-gpp0-wakeup.sh /usr/local/sbin/disable-gpp0-wakeup.sh
sudo cp /mnt/data/LinuxSetup/disable-gpp0-wakeup/disable-gpp0-wakeup.service /etc/systemd/system/disable-gpp0-wakeup.service
sudo systemctl enable disable-gpp0-wakeup.service
sudo systemctl start disable-gpp0-wakeup.service
systemctl status disable-gpp0-wakeup.service

# amd_gpu

firefox https://github.com/Umio-Yasuno/amdgpu_top/releases/tag/v0.7.0
