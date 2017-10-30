# oilman

oilman makes it painless and easy to backup and restore a DB from the command line. It allows its user to search and choose a backup file. It will then take care of the boring stuff: setting DB to single-user mode, copying log files to the target DB, and then preparing the DB with the appropriate SQL config settings.

**WARNING**: If you currently have the SQL Backup NAS directory mounted to your Mac, oilman will unmount it and restore it to `oilman/sql_backups`

## Getting started

1. Clone this repo to your local Mac.
2. Install gems `bundle install`.
3. Create an `.env` file in the root of the oilman project folder. Specify options, example `config.json` file below.
4. You can optionally install the `oilman` CLI globally. To do so, execute this command from the root directory of oilman `ln -s "$PWD/bin/oilman" /usr/local/bin/oilman`.

### Sample `config.json` file

The config file uses named keys to support multiple hosts. See sample below for example of 3 hosts `sql4`, `we12`, `we70`. Note: A `db_owner` can be specified to set the DB owner to a login different than the specified `username`.

```json
{
  "mount_domain": "we",
  "mount_user": "YOUR_USER",
  "mount_password": "YOUR_PASSWORD",
  "mount_server": "readynas2.we.local/backups",

  "sql4": {
    "db_owner": "gas_plant",
    "username": "we\\codie.mullins",
    "password": "****",
    "host": "192.168.14.60",
    "database": "codie_db1"
  },

  "we12": {
    "username": "sql_admin",
    "password": "****",
    "host": "192.168.14.12",
    "database": "codie_db"
  },

  "we70": {
    "username": "sql_admin",
    "password": "***",
    "host": "192.168.14.70",
    "database": "codie_db"
  }
}
```

### Sample `config.json` for Vagrant

```json
{
  "mount_user": "GUEST:",
  "mount_server": "192.168.14.15",
  "mount_path": "\\\\VBOXSVR\\vagrant\\sql_backups",

  "waterfield": {
    "username": "sa",
    "password": "#SAPassword!",
    "host": "192.168.50.4",
    "database": "waterfield_dev",
    "data_dir": "C:\\Program Files\\Microsoft SQL Server\\MSSQL12.SQLEXPRESS\\MSSQL\\DATA",
    "log_dir": "C:\\Program Files\\Microsoft SQL Server\\MSSQL12.SQLEXPRESS\\MSSQL\\DATA"
  },

  "accruent": {
    "username": "sa",
    "password": "#SAPassword!",
    "host": "192.168.50.4",
    "database": "accruent_dev",
    "data_dir": "C:\\Program Files\\Microsoft SQL Server\\MSSQL12.SQLEXPRESS\\MSSQL\\DATA",
    "log_dir": "C:\\Program Files\\Microsoft SQL Server\\MSSQL12.SQLEXPRESS\\MSSQL\\DATA"
  }
}
```

## oilman help

```bash
Commands:
  oilman backup SERVER DATABASE  # Backup specified DATABASE on SERVER (from config.json)
  oilman help [COMMAND]          # Describe available commands or one specific command
  oilman restore SERVER          # restore database .bak file to your chosen SERVER target DB

Options:
  [--verbose], [--no-verbose]
```

## Creating DB Backup

Oilman makes it easy to create a DB backup, run the command `oilman backup {server_name} {database_name}` to backup `database_name` from `server_name` where `server_name` exists in `config.json`.

**Sample Output**

```bash
$ oilman backup we12 foundation_clone
Backing up database foundation_clone, this can take upto 30 minutes...
$
```

This will create a `.bak` file in the root SQL Backup NAS directory with the format of `{timestamp}_{database_name}_oilman_tmp.bak`

## Restoring DB

Oilman performs DB restores onto the database for the chosen server specified in the `config.json` file. Using the command `oilman restore --search="foundation"`, it will search for `.bak` files matching the search string, in this instance foundation, and return directories and `.bak` files which contain the search term in their name.

**Sample Output**

```bash
$ oilman restore we12 --search="foundation"
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

## TODO

- [X] Support multiple database servers
- [X] Support multiple restore target databases
