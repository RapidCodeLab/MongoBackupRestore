#!/bin/bash

_backupdir="mongobackups"
# check direcory exists, make if not exists
if [ ! -d $_backupdir ]
then
  mkdir $_backupdir      
fi  
#
d=`date '+%d-%m-%y'`  
echo $d
#
# check ammount of backup files, remove first if more than ammount from settings
#
# write last backup 
#
