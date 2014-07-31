Simpe bash script for backup files to Yandex.Disk via API
For more details you can visit [article at my blog](http://zharenkov.ru/post/skript-kopirovaniya-faila-na-yandeks.disk-cherez-api)

Features
--------
* OAuth authorization
* Needs only curl (no webdav or yandex client)
* GPG encryption

Settings
--------

token -- token for Yandex.Disk application
backupDir -- name of backup directory
logFile -- name of logfile
GPG -- enable GPG encryption
GPGENCRYPTUID -- GPG UID

Options
-------

<pre>
    -h  Show help
    -f <filename>  Specify filename for upload
    -e  Enable GPG encryption
    -g <uid>  Specify GPG UID
</pre>

Usage
-----

Copy file to Yandex Disk:
```bash
./yd-api-backuper.sh -f /path/to/file/file_name
```
Encrypt and copy file to Yandex Disk:
```bash
./yd-api-backuper.sh -f /path/to/file/file_name -e -g username@server
```