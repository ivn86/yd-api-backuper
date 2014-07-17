Simpe bash script for backup files to Yandex.Disk via API
For more details you can visit [my article at my blog](http://zharenkov.ru/post/skript-kopirovaniya-faila-na-yandeks.disk-cherez-api)

Features
--------
* Token authorization
* Needs only curl (no webdav or yandex client)

Settings
--------

token -- token for Yandex.Disk application

backupName -- backup filename pattern

backupDir -- name of backup directory

logFile -- name of logfile

Usage
-----

```bash
./yd-api-backuper.sh /path/to/file/file_name
```