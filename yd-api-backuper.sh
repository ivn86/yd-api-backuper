#!/bin/bash

#
#       Author        :   Zharenkov I.V.
#       License       :   GNU/GPL2
#       Date          :   2014-07-17
#	    Requirements  :   curl
#


if [ ! -f "$1" ];
then
    echo "Error: IMHO file $1 does not exist or unreadable. Check filename."
    exit 1
fi

# ---------- SETTINGS -------------

# Yandex.Disk token
token=''

backupName=`date "+%Y%m%d-%H%M"`_$(basename $1)

# Target directory. Be sure, that the directory exists.
backupDir='backup'

# Logfile name
logFile=yd-api-backuper.log

# ---------- FUNCTIONS ------------

function logger()
{
    echo "["`date "+%Y-%m-%d %H:%M:%S"`"] $backupName: $1" >> $logFile
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

# --------------- MAIN ----------------

uploadFile $1
