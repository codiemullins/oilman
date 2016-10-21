# oilman

oilman makes it painless and easy to restore a DB from the command line. It allows its user to search and choose a backup file. It will then take care of the boring stuff: setting DB to single-user mode, copying log files to the target DB, and then preparing the DB with the appropriate SQL config settings.

**WARNING**: If you currently have the SQL Backup NAS directory mounted to your Mac, oilman will unmount it and restore it to `oilman/sql_backups`

## Getting started

1. Clone this repo to your local Mac.
2. Install gems `bundle install`.
3. Create a `.env` file in the root of the oilman project folder. Specify options (See *Sample .env file* below)
4. From root directory of oilman project run `bin/oilman restore`. Optionally, passing a search string, `oilman restore --search="foo"`, for filtering the list of available `.bak` files.
5. Follow-on screen prompts and options.

### Symbolic Link

To install the CLI `oilman` globally execute the command below from the root directory of oilman

```bash
ln -s "$PWD/bin/oilman" /usr/local/bin/oilman
```

## Sample `.env` file

```
MOUNT_USER="GUEST:"
MOUNT_SERVER="192.168.14.15"

DB_USER="sql_admin"
DB_PASS="password"
DB_HOST="127.0.0.1"
DB_NAME="database"
```

## Sample Output

![sample-output](https://i.imgsafe.org/a8a146c522.png)
