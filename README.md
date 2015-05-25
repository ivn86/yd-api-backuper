Simpe bash script for backup files to Yandex.Disk via API
For more details you can visit [article at my blog](http://zharenkov.ru/post/skript-kopirovaniya-faila-na-yandeks.disk-cherez-api)

Features
--------
* OAuth authorization
* Needs only curl (no webdav or yandex client)
* GPG encryption
* email notification

Settings
--------

token -- token for Yandex.Disk application
backupDir -- name of backup directory
logFile -- name of logfile
GPGENCRYPTUID -- GPG UID
mailLog -- email address for sending logs
mailLogErrorOnly -- send email only if error occured

Options
-------

<pre>
    -h  Show help
    -f /path/to/file  Specify filename for upload
    -g user@gpgid  Specify GPG UID
    -m user@localhost  Specify email for logging
    -e  Send email on error only
</pre>

Usage
-----

Copy file to Yandex Disk:
```bash
./yd-api-backuper.sh -f /path/to/file/file_name
```
Encrypt and copy file to Yandex Disk:
```bash
./yd-api-backuper.sh -f /path/to/file/file_name -g username@server
```
Copy file to Yandex Disk and notify user about errors
```bash
./yd-api-backuper.sh -f /path/to/file/file_name -m user@localhost -e
```