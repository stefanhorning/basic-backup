# basic-backup
Backup scripts in bash utilizing rsync and hardlinking for efficient incremental
**remote** backups. It can keep states for each backup run. Currently set to 7 days. But if want to run it hourly it can easily be extended.

## Project layout / dependencies
Basic-backup consists of two scripts. One to be placed on the machine you want to
backup ([production_machine](https://github.com/stefanhorning/basic-backup/tree/master/production_machine)) and the other one to be placed on the machine that
receives the backup via SSH ([backup_machine](https://github.com/stefanhorning/basic-backup/tree/master/storage_machine)).
Both scripts are written in Bash and use standard tools like `rsync` and `cp`. So
the scripts should run on most Unix (Linux, MacOS etc.) systems without any further
dependencies.

### Files
#### rync_backup.sh
> [Code of rync_backup.sh](https://github.com/stefanhorning/basic-backup/blob/master/production_machine/rsync_backup.sh)

The script to run daily by cron (you of course can change the interval, but currently
just 7 increments are kept by rotate.sh). This script will utilize rsync to get data accross
in a syncing fashion to be more efficient (not copying same things twice). It will also trigger
the rotate script on the remote host before each sync to prepare the file structure there.

#### rotate.sh
> [Code of rotate.sh](https://github.com/stefanhorning/basic-backup/blob/master/storage_machine/rotate.sh)

Keeps the (daily) increments by keeping hardlinks to the files that were presen in that run. So
storage space is used efficiently. Once files fall out of the rota they are automatically 'garbage
collected' by the file system (unlinked). Script is to be placed on the backup host which can be accessed by SSH from the
initiating host that runs the sync script.

#### backup_stats.sh
> [Code of backup_stats.sh](https://github.com/stefanhorning/basic-backup/blob/master/storage_machine/backup_stats.sh)

Just a script to create stats from logfiles created by `rotate.sh`.

## Setup
Just copy the scripts to the place you want to have them on the machines and make them executable.

Then add a cron job executing the `rsync_backup.sh` script and make sure you have a working SSH
setup that allows non interactive ssh connections to the backup host.
To change settings modify variables in the `rsync_backup.sh` script. Make sure the
`$HOSTNAME` and `$DESTINATION` variables are set correctly and poininting to the backup host.

The `rsync_backup.sh` script will automtically trigger the `rotate.sh` script on the receiving host before a new sync.
It will keep the state of the previous day (or other increment).
There is also a `rsync_excludes` file, holding the patterns you want to exclude
from the syncing (see `man rsync` for details).

On the receiving end make sure the `rotate.sh` script is placed in the folder on the
machine which is referenced in the rsync script.

The rotate script will create a log file for you. To make this log data easier to analyze this
project also comes with a third script called `backup_stats.sh`. This script can write nice textbased
stats by analyzing those logs.

### Installation steps
1. SSH Login to host to be backed up and do a `wget https://raw.githubusercontent.com/stefanhorning/basic-backup/master/production_machine/rsync_backup.sh`
2. Also create a `rsync_excludes` file in the same dir, or use the one from here for a start `wget https://raw.githubusercontent.com/stefanhorning/basic-backup/master/production_machine/rsync_excludes`
3. Create [a passwordless SSH key pair](http://hortonworks.com/kb/generating-ssh-keys-for-passwordless-login/) and put the public key on the backup receiving host
4. SSH Login to the (remote) host to receive the backups and do a `wget https://raw.githubusercontent.com/stefanhorning/basic-backup/master/storage_machine/rotate.sh`
6. Go back to first (backup) host with the rsync script and create a cron job that calls it
7. That's it (unless you messed up some settings/paths)

Optionally put the [stats script](https://github.com/stefanhorning/basic-backup/blob/master/storage_machine/backup_stats.sh) on the backup machine point it to the logs the rotate script
creates and create a cronjob for it to keep the stats up to date.

# Contribute
Feel free to issue pull requests if you have any improvements to suggest.

# Licencing / Disclaimer
The project comes with no strings attached, just use the scripts as you please. I will claim
no copyright on this as it's just a few lines mostly running other commands. The usage of this
scripts come with no warranties either!
