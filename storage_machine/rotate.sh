#!/bin/bash

# This script is called by the rsync-script on the other host and
# uses cp -al to hardlink on original backup.
# Links data from incremental weekday folders to rotate the data/states of each day.
# This script it meant to be executed by the rsync_backup.sh script on the host
# that delivers the data.

# Destination (backup) directory:
DESTINATION=/media/backup
# Logfile:
LOGFILE=$DESTINATION/log/$(date +%Y-%m-%d)-rotate.log

# Names for the daily increments:
YESTERDAY=01_Gestern
TWO_DAYS_AGO=02_Vorgestern
THREE_DAYS_AGO=03_Vor3Tagen
FOUR_DAYS_AGO=04_Vor4Tagen
FIVE_DAYS_AGO=05_Vor5Tagen
SIX_DAYS_AGO=06_Vor6Tagen
SEVEN_DAYS_AGO=07_Vor7Tagen
# Rotating the incremental backups (relinking and recreating the last):
rm -rf $DESTINATION/$SEVEN_DAYS_AGO
mv $DESTINATION/$SIX_DAYS_AGO $DESTINATION/$SEVEN_DAYS_AGO
mv $DESTINATION/$FIVE_DAYS_AGO $DESTINATION/$SIX_DAYS_AGO
mv $DESTINATION/$FOUR_DAYS_AGO $DESTINATION/$FIVE_DAYS_AGO
mv $DESTINATION/$THREE_DAYS_AGO $DESTINATION/$FOUR_DAYS_AGO
mv $DESTINATION/$TWO_DAYS_AGO $DESTINATION/$THREE_DAYS_AGO
cp -alv $DESTINATION/$YESTERDAY $DESTINATION/$TWO_DAYS_AGO > $LOGFILE
# rsync fills up the YESTERDAY folder every day, after calling this script.
