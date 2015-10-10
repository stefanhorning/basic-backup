#!/bin/bash

# This script backs up data using rsync and cp -al to hardlink on original backup
# and put changes in incremental weekday folders by rotating them.
# Relies on the rotate.sh script on the backup (remote) host!
# This script should be executed by a daily cron job. It will call the rotate script on the backup host itself so no job needed there.
# by Stefan Horning <stefan@hornings.de>

# Log-File:
LOGFILE=/var/log/backup/$(date +%Y-%m-%d)-backup.log

# Directory to be backed up:
SOURCE=/home
# Destination (backup) directory:
HOST=168.0.0.55
DESTINATION=/media/backup
# File with exclude patterns:
EXCLUDES=./rsync_excludes
# Name of the subfolder the rotate.sh script uses as starting point:
YESTERDAY=01_Gestern

# Rotate files on the backup host first:
ssh root@$HOST "/media/backup/rotate.sh"

# rsync into the recent dir:
rsync -avze ssh --delete --delete-excluded --exclude-from="$EXCLUDES" $SOURCE/ root@$HOST:$DESTINATION/$YESTERDAY/ > $LOGFILE
