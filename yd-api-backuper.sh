#!/bin/bash

#
#       Author        :   Zharenkov I.V.
#       License       :   GNU/GPL2
#       Date          :   2014-07-17
#	Requirements  :   curl
#       Version       :   0.2
#


# ---------- SETTINGS -------------

# Yandex.Disk token
token=''

# Target directory. Be sure, that the directory exists.
backupDir='backup'

# Logfile name
logFile=yd-api-backuper.log

# Enable GPG encryption
GPG=false

# GPG encryption UID
GPGENCRYPTUID=''


# ---------- FUNCTIONS ------------

function usage
{
cat <<EOF

USAGE: $0 OPTIONS

OPTIONS:

  -h  Show this message
  -f <filename>  Specify filename for upload
  -e  Enable GPG encryption
  -g <uid>  Specify GPG UID

EOF
}

function gpgEncrypt()
{
    gpg -e -r $GPGENCRYPTUID $FILENAME
}

function logger()
{
    echo "["`date "+%Y-%m-%d %H:%M:%S"`"] File $FILENAME: $1" >> $logFile
}

function parseJson()
{
    local output
    regex="(\"$1\":[\"]?)([^\",\}]+)([\"]?)"
    [[ $2 =~ $regex ]] && output=${BASH_REMATCH[2]}
    echo $output
}

function checkError()
{
    echo $(parseJson 'error' "$1")
}

function getUploadUrl()
{
    local output
    local json_out
    local json_error
    json_out=`curl -s -H "Authorization: OAuth $token" https://cloud-api.yandex.net:443/v1/disk/resources/upload/?path=$backupDir/$backupName&overwrite=true`
    json_error=$(checkError "$json_out")
    if [[ $json_error != '' ]];
    then
	logger "Yandex Disk error: $json_error"
	exit 1	
    else
	output=$(parseJson 'href' $json_out)
	echo $output
    fi
}

function uploadFile
{
    local json_out
    local uploadUrl
    local json_error
    uploadUrl=$(getUploadUrl)
    if [[ $uploadUrl != '' ]];
    then
	json_out=`curl -s -T $1 -H "Authorization: OAuth $token" $uploadUrl`
	json_error=$(checkError "$json_out")
	if [[ $json_error != '' ]];
	then
	    logger "Yandex Disk error: $json_error"
	else
	    logger "Copying file to Yandex Disk success"
	fi
    else
	echo 'Some errors occured. Check log file for detail'
	exit 1
    fi
}

function preUpload()
{
    if [ $GPG == true ];
    then
	gpgEncrypt
	FILENAME=$FILENAME.gpg
    fi

    backupName=`date "+%Y%m%d-%H%M"`_$(basename $FILENAME)
}

function postUpload()
{
    if [ $GPG == true ];
    then
	rm $FILENAME
    fi
}

# --------------- OPTIONS -------------

while getopts ":f:g:he" opt; do
    case $opt in
	h)
	    usage
	    exit 1
	    ;;
	f)
	    FILENAME=$OPTARG

	    if [ ! -f $FILENAME ];
	    then
		echo "File not found: $FILENAME"
		logger "File not found"
		exit 1
	    fi
	    ;;
	g)
	    GPGENCRYPTUID=$OPTARG
	    ;;
	e)
	    GPG=true
	    ;;
	\?)
	    echo "Invalid option: -$OPTARG. $0 -h for help" >&2
	    exit 1
	    ;;
	:)
	    echo "Option -$OPTARG requires an argument." >&2
	    exit 1
	    ;;
    esac
done

# --------------- MAIN ----------------

if [[ -z $FILENAME ]]
then
    usage
    exit 1
fi

preUpload

uploadFile $FILENAME

postUpload