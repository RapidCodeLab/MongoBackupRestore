#!/bin/bash

show_help(){
cat << EOF
  Usage: ${0##*/} 
  [-h, --help]
  [-d, --directory PATH]
  [-c, --container CONTAINER NAME]
  [-db, --database DATABASE NAME]
EOF
}

die(){
  printf '%s\n' "$1" >&2
  exit 1
}


# var inititalization
_backupdir=
_container=
_dbname=
_dump="/dump"

while :; do
 case $1 in
  -h|-\?|--help)
    show_help
    exit
    ;;
  -d|--directory)
    if ["$2"]; then
      _backupdir=$2
      shift
    else
      die 'ERROR: "--file" requires a non-empty argument.'
    fi
    ;;
   *)
    break 
  esac
  shift
done
# check direcory exists, make if not exists
if [ ! -d $_backupdir ]
then
  mkdir $_backupdir      
fi  

# making date for filename
_current_date=`date '+%d-%m-%y'`  
#
# Count of backup files, delete first if more than amount from settings 
# 
# Make last mongo backup with current date in filename
docker exec -i $_container /usr/bin/mongodump --db $_dbname --out $_dump 
_container_path="$_container:$_dump"
docker cp $_container_path $_backupdir
tar czf "$_backupdir/$_current_date.tar.gz"
# Exit with done message
exit 0

