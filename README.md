# oilman

oilman makes it painless and easy to backup and restore a DB from the command line. It allows its user to search and choose a backup file. It will then take care of the boring stuff: setting DB to single-user mode, copying log files to the target DB, and then preparing the DB with the appropriate SQL config settings.

**WARNING**: If you currently have the SQL Backup NAS directory mounted to your Mac, oilman will unmount it and restore it to `oilman/sql_backups`

## Getting started

1. Clone this repo to your local Mac.
2. Install gems `bundle install`.
3. Create an `.env` file in the root of the oilman project folder. Specify options, example `.env` file below.

### Symbolic Link

To install the CLI `oilman` globally execute the command below from the root directory of oilman

```bash
ln -s "$PWD/bin/oilman" /usr/local/bin/oilman
```

### Sample `.env` file

```
MOUNT_USER="GUEST:"
MOUNT_SERVER="192.168.14.15"

DB_USER="sql_admin"
DB_PASS="password"
DB_HOST="127.0.0.1"
DB_NAME="database"
```

## Creating DB Backup

Oilman makes it easy to create a DB backup, run the command `oilman backup {database_name}`.

** Sample Output**

```bash
$ oilman backup foundation_clone
Backing up database foundation_clone, this can take upto 30 minutes...
$
```

This will create a `.bak` file in the root SQL Backup NAS directory with the format of `{timestamp}_{database_name}_oilman_tmp.bak`

## Restoring DB

Oilman performs DB restores onto the database specified in the `.env` file. Using the command `oilman restore --search="foundation"`, it will search for `.bak` files matching the search string, in this instance foundation, and return directories and `.bak` files which contain the search term in their name.

** Sample Output**

```bash
$ oilman restore --search="foundation"
1. Foundation
2. 20161026162142_foundation_clone_oilman_tmp.bak
3. 20161027084021_foundation_clone_oilman_tmp.bak
Please choose your backup:  3
====
Beginning restore of codie_dev3... This can take awhile...
Go for a short walk or get some coffee...
Executing Command 1 of 5
Executing Command 2 of 5... restore command, this takes the longest by far...
Executing Command 3 of 5
Executing Command 4 of 5
Executing Command 5 of 5
Restore is complete! 😁 😆 Happy Coding!
```
