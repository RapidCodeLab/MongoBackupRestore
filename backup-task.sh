#!/bin/bash

_backupdir="mongobackups"
_container="mongoddb"
_dbname="gopusher"
_dump="/dump"

# check direcory exists, make if not exists
if [ ! -d $_backupdir ]
then
  mkdir $_backupdir      
fi  

# making date for filename
d=`date '+%d-%m-%y'`  
#
# Count of backup files, delete first if more than amount from settings 
# 
# Make last mongo backup with current date in filename
docker exec -i $_container /usr/bin/mongodump --db $_dbname --out $_dump 
_container_path="$_container:$_dump"
docker cp $_container_path $_backupdir
tar czf $_backupdir+"/"+$d+".tar.gz"
# Exit with done message
exit 0
