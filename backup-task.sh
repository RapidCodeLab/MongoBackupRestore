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
    if [ $2 ]
    then
      _backupdir=$2
      shift
    else
      die 'ERROR: "-d, --directory" requires a non-empty argument.'
    fi
    ;;
  -c|--container)
    if [ $2 ]; then
      _container=$2
      shift
    else
      die 'ERROR: "-c, --container" requires a non-empty argument.'
    fi
    ;;
  -db|--database)
    if [ $2 ]; then
      _dbname=$2
      shift
    else
      die 'ERROR: "-db, --database" requires a non-empty argument.'
    fi
    ;;
  --)
    shift
    break
    ;;
   *)
    break 
  esac
  shift
done

if [ ! $_backupdir ]
then
  die 'ERROR: "-d, --directory" argument is reqired. '
fi

if [ ! $_container ]
then
  die 'ERROR: "-c, --container" argument is reqired. '
fi

if [ ! $_dbname ]
then
  die 'ERROR: "-db, --database" argument is reqired. '
fi

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
tar czf "$_backupdir/$_current_date.tar.gz" $_backupdir 
# Exit with done message
echo "Backup complete"
exit 0

