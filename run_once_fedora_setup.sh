#!/bin/bash

sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf groupupdate core -y
sudo dnf -y update -y
sudo dnf -y upgrade --refresh -y
sudo dnf groupupdate 'core' 'multimedia' 'sound-and-video' --setop='install_weak_deps=False' --exclude='PackageKit-gstreamer-plugin' --allowerasing && sync -y
sudo dnf swap 'ffmpeg-free' 'ffmpeg' --allowerasing -y
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg -y
sudo dnf install lame\* --exclude=lame-devel -y
sudo dnf group upgrade --with-optional Multimedia -y
sudo dnf install ffmpeg ffmpeg-libs libva libva-utils -y


sudo dnf config-manager --set-enabled fedora-cisco-openh264 -y
sudo dnf install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264 -y

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo -y
flatpak update -y

sudo dnf groupupdate sound-and-video -y
sudo dnf install rpmfusion-nonfree-release-tainted -y
sudo dnf --repo=rpmfusion-nonfree-tainted install "*-firmware" -y
sudo dnf install nemo -y
sudo dnf install nemo-fileroller -y
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
sudo dnf copr enable aflyhorse/libjpeg

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc -y
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update -y
sudo dnf install code -y

sudo dnf install copyq -y
sudo dnf install gamemode -y
sudo dnf install gnome-extension-manager -y
sudo dnf install lm-sensors -y
sudo dnf install ddccontrol -y
sudo dnf install gddccontrol -y
sudo dnf install ddccontrol ddccontrol-gtk -y
sudo dnf install vim -y
sudo dnf install mpv -y
sudo dnf install virt-manager -y
sudo dnf install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils -y
sudo dnf install neofetch -y
sudo dnf install vlc -y
sudo dnf install mangohud -y
sudo dnf install steam -y
sudo dnf install xclip -y
sudo dnf install anki -y
sudo dnf install gimp -y
sudo dnf install steam -y
sudo dnf install xclip -y
sudo dnf install lutris -y
sudo dnf install kernelstub -y
sudo dnf install appimagelauncher -y
sudo dnf install gnome-screenshot  -y
sudo dnf install dconf-tools -y
sudo dnf install gedit -y
sudo dnf install easyeffects -y
sudo dnf install google-noto-sans-cjk-fonts -y
sudo dnf install pdfshuffler -y
sudo dnf install git-credential-manager -y
sudo dnf install git-credential-oauth  -y
sudo dnf install lutris -y

# Chinese keyboard, disable super enter shortcut in gnome keyboard settings
sudo dnf install -y fcitx5  fcitx5-configtool  fcitx5-autostart fcitx5-chinese-addons
