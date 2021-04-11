#!/bin/bash

#setup aws cli before using this script and verify aws command path ( which aws )
#this script set as cronjob ( @daily )
#when running this script this will take a backup of the contents that wants and copy the contents to s3 and stores locally ( the local backup deletes after 10 days)



#*********************************************************************
TIMESTAMP=$(date +"%d-%b-%Y")
S3BUCKET=#bucket name
backup_content_path=#absolute path of contents/contents containing dirctory wants to backup
log_path=#absolute path of log file
backup_path=# absolute path to store the backup file 
tmp_path=/tmp/$TIMESTAMP
#*********************************************************************


echo "INFO  $(date +%d-%m-%Y-%H:%M:%S) $user - backup process: started" >> $log_path

mkdir $tmp_path

mv $backup_content_path $tmp_path

tar -xzf $backup_path/$TIMESTAMP.tar.gz $tmp_path


if [ $? -eq 0 ];then 
	echo "INFO  $(date +%d-%m-%Y-%H:%M:%S) $user - local backup creation: success" >> $log_path
	#aws s3 cp $backup_path/$TIMESTAMP.tar.gz s3://$S3BUCKET
	if [ $? -eq 0 ];then
        echo "INFO  $(date +%d-%m-%Y-%H:%M:%S) $user - AWS s3 backup creation: success" >> $log_path
    else
        echo "ERROR  $(date +%d-%m-%Y-%H:%M:%S) $user - AWS s3  backup creation: failed" >> $log_path    	
    fi
else
	echo "ERROR  $(date +%d-%m-%Y-%H:%M:%S) $user - local backup and s3 backup creation: failed" >> $log_path

fi
echo "INFO  $(date +%d-%m-%Y-%H:%M:%S) $user - backup process: completed" >> $log_path

#removing tmp backup file
rm -rf $tmp_path


#remove older backup files
find $backup_path -mtime +10 -exec rm -rf {} \;

