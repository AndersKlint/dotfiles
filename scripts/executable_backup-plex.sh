#!/bin/zsh

rsync -aPz pi@192.168.0.5:"/var/lib/plexmediaserver/Library/Application Support/Plex Media Server" /mnt/data/Backup/Plex
