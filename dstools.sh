#!/bin/bash
set -u

# Variables
FREESPACE=$(df -h | grep dev | awk ' {print $4} ')

# Functions
function RMLOG10MB {
    find /home*/*/ -type f -name "error_log" -size +10000k -exec rm -f {} \;
}

function NCDU {
    read -p "Which path would you like to analyse?: " NCDUPATH
    ncdu $NCDUPATH
}

function COMMONFOLDERS {
    echo
    du -sh /var/log/ /root/ /home/swb/
    echo
    echo "Returning to menu in 10 seconds..."
    sleep 10
    ./dstools.sh
}

function RMARCHIVEDLOGS {
    rm -f /var/log/messages-* /var/log/cron-* /var/log/secure-* /var/log/spooler-* /var/log/maillog-* /var/log/lastlog-* /var/log/exim_paniclog-* /var/log/exim_rejectlog-* /var/log/exim_mainlog-*
}

function LARGERTHAN1GB {
    echo
    echo "Searching for files larger than 1GB..."
    find /home*/*/ -size +1000000k -exec ls -lah {} \;
}

### Ideas of things to include:
# View disk usage in /var/log/ & /root/ & /home/swb/
# ncdu - Explore Disk Usage Vistually (you supply the path)
# Clear old archived logs from /var/log/
# Search for any files larger than 1GB
# Empty all error_log files greater than 10MB
# Empty all cPanel Trash Folders
# See Installatron Backup folder usage
# View & Reduced number of Reserved Blocks on disk

OPTION=$(whiptail --title "Disk Space Tools"  --menu "Available Space: $FREESPACE" 20 60 10 \
"1" "View disk usage in /var/log/ & /root/ & /home/swb/" \
"2" "NCDU - See Disk Usage Visually (you supply the path)" \
"3" "Delete old/archived logs from /var/log/" \
"4" "Search for any files larger than 1GB" \
"5" "Delete all error_log files larger than 10MB" \
"6" "" \
"7" "View & Reduce number of Reserved Blocks on disk" \
"8" "View & Reduce number of Reserved Blocks on dis" \
"9" "" \
"10" "Exit"  3>&1 1>&2 2>&3)

case $OPTION in
    1) COMMONFOLDERS ;;
    2) NCDU ;;
    3) RMARCHIVEDLOGS ;;
    4) LARGERTHAN1GB ;;
    5) RMLOG10MB ;;
    6) tune2fs -l /dev/sda1 | grep Reserved ;;
    7)  ;;
    *) exit 0;;
esac

