#!/bin/bash

set -u

# Functions
function RMLOG10MB {
    find /home*/*/ -type f -name "error_log" -size +10000k -exec rm -f {} \;
}

#function FREESPACE {
#    df -h | grep dev | awk ' {print $4} '
#}
FREESPACE=$(df -h | grep dev | awk ' {print $4} ')
# View disk usage in /var/log/ & /root/ & /home/swb/
# Clear old archived logs from /var/log/
# Empty all cPanel Trash Folders
# Empty all error_log files greater than 10MB
# Search for any files larger than 1GB
# See Installatron Backup folder usage
# View & Reduced number of Reserved Blocks on disk
# 
#

OPTION=$(whiptail --title "Disk Space Tools"  --menu "Available Space: $FREESPACE" 20 60 10 \
"1" "Clear old / archived logs from /var/log/" \
"2" "Empty all cPanel Trash Folders" \
"3" "Delete all error_log files larger than 5MB" \
"4" "See Installatron Backup folder usage" \
"5" "View & Reduce number of Reserved Blocks on disk" \
"6" "View & Reduce number of Reserved Blocks on disk" \
"7" "View & Reduce number of Reserved Blocks on disk" \
"8" "View & Reduce number of Reserved Blocks on disk" \
"9" "View & Reduce number of Reserved Blocks on disk" \
"10" "Exit"  3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $OPTION
else
    echo "You chose Cancel."
fi

case $OPTION in
    1) rm -f /var/log/messages-* /var/log/cron-* /var/log/secure-* /var/log/spooler-* /var/log/maillog-* /var/log/lastlog-* /var/log/exim_paniclog-* /var/log/exim_rejectlog-* /var/log/exim_mainlog-* ;;
    2) COMMAND ;;
    3) RMLOG5MB ;;
    4) du -sh /home*/*/application_backups/ ;;
    5) tune2fs -l /dev/sda1 | grep Reserved ;;
    *) exit 0;;
esac

