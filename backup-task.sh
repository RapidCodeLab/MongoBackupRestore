#!/bin/bash

show_help(){
  cat << EOF
  Usage: ${0##*/} [-h] [-d, --PATH] [-c CONTAINER NAME] [-b DATABASE NAME]
EOF
}

die(){
  printf '%s\n' "$1" >&2
  exit 1
}

show_help
exit 0 

# var inititalization
_backupdir=
_container=
_dbname=
_dump="/dump"

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

