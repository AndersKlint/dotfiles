#!/bin/zsh

rsync -aPz --exclude-from=.rsyncignore  /home/anders pi@192.168.0.5:/media/pi/WD_PASSPORT_2TB/Anders/files/Backup/LinuxBackup/home/anders
