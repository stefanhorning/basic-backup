#!/bin/bash

# Creates stats of daily changes between two backups (how many files were added/removed).
# This is meant to analyze the logfiles created by the rotate.sh. So if you wish to have some
# stats written to a file call this script (usually by cron).
# by Stefan Horning <stefan@hornings.de>

LOG_FOLDER="/media/backup/log" #folder containing all the logfiles
ENDING="rotate.log" # log-file naming, static parts
YESTERDAY=$(date +%Y-%m-%d --date="-1day") # date string
TODAY=$(date +%Y-%m-%d) # date string
OUT_FILE="daily_changes" # output filename

# Use more variables for manual testing:
DATE1=$YESTERDAY
DATE2=$TODAY

LOG_FILE="$DATE1-$ENDING" # complete log filename
# echo "Stats for $DATE1" # feedback print

# If Logfile exists for the day (yesterday, since backups are made the following morning):
if [ -f $LOG_FILE ]; then
	# Compare two logfiles and count differencing files:
	DIFF_AMOUNT=$(diff --side-by-side --suppress-common-lines "$LOG_FOLDER"/"$DATE1"-"$ENDING" "$LOG_FOLDER"/"$DATE2"-"$ENDING" | wc -l)
	# Write results to file:
	echo "$DATE1 | $DIFF_AMOUNT" >> $LOG_FOLDER/$OUT_FILE
else
	# If no backup record exists, write results to file:
	echo "$DATE1 | No Backup exists!" >> $LOG_FOLDER/$OUT_FILE
fi
