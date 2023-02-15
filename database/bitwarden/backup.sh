#!/bin/bash
/usr/lib/p7zip/7z  a -tzip -p你的密码 -mem=aes256 /root/bitwarden/backup/bitwarden-backup-$(date +%Y%m%d_%H%M%S).7z /bw-data/
/usr/bin/rclone clone /root/bitwarden/backup 谷歌网盘:bitwarden
sleep 30
rm -f /root/bitwarden/backup/bitwarden-backup-*
echo "BACKUP DATE:" $(date +"%Y-%m-%d %H:%M:%S") >> /var/log/backup.log