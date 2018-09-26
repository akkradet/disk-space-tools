#!/bin/bash

set -u

OPTION=$(whiptail --title "Disk Space Tools" --menu "Choose your option" 15 60 8 \
"1" "Clear old / archived logs from /var/log/" \
"2" "Empty all cPanel Trash Folders" \
"3" "Delete all error_log files larger than 5MB" \
"4" "See Installatron Backup folder usage" \
"5" "View & Reduce number of Reserved Blocks on disk" \
"6" "Exit"  3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $OPTION
else
    echo "You chose Cancel."
fi

case $OPTION in
    1) rm -f /var/log/messages-* /var/log/cron-* /var/log/secure-* /var/log/spooler-* /var/log/maillog-* /var/log/lastlog-* /var/log/exim_paniclog-* /var/log/exim_rejectlog-* /var/log/exim_mainlog-* ;;
    2) COMMAND ;;
    3) find /home*/*/ -type f -name "error_log" -size +5000k -exec rm -f {} \; ;;
    4) du -sh /home*/*/application_backups/ ;;
    5) tune2fs -l /dev/sda1 | grep Reserved ;;
    *) exit 0;;
esac

