#!/bin/bash

# Set the location of where the backup will be sent to
to="${to:-/var/backups/html}"

# Set which website HTML content is being backed up
website=""

# Set location of where the HTML content currently is - a forward slash (/) should be present at the end of the string.
# By default this will include the html variable previously set, if your system is not configured in such a way then you can remove this
from=""

# How many days would you like to keep files for?
days="${days:-7}"

# Enable named parameters to be passed in
while [ $# -gt 0 ]; do

    # If help has been requested
    if [[ $1 == *"--help" ]]; then
        echo
        echo "MySQL/MariaDB Backup Script"
        echo
        echo "This script allows you to easily backup the contents of a website on a web server."
        echo "https://github.com/AlexWinder/html-backup"
        echo
        echo "Options:"
        echo
        echo "--to        Where you would like to back the files up to. Default: ${to}"
        echo "--website   The name of the website with which the backed up files related to."
        echo "--from      The source directory of the website files."
        echo "--days      The number of days to keep backup files before deleting them. Default: ${days} (days)"
        echo "--help      Display help about this script"
        echo
        exit 0
    fi

    # Check all other passed in parameters
    if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
    fi

    shift
done

# Fail-safe to make sure we have a website
if [ -z "$website" ]; then
    echo "You have not specified which website you wish to back up. Please pass in the --website flag with the name of the website you wish to back up."
    exit 1
fi

# Fail-safe to make sure we have a source
if [ -z "$from" ]; then
    echo "You have not specified the path of the source. Please pass in the --from flag with the path to the website which you wish to back up."
    exit 1
fi

######################################################
##### EDITING BELOW MAY CAUSE UNEXPECTED RESULTS #####
######################################################

# Set location of temporary directory - a forward slash (/) should be present at the end of the string.
tmp="/tmp/"

# Fix the path so that it is always in the correct format
to=$(echo "$to" | sed 's:/*$::')
to="$to/"

# Obtain the date
date=$(date +"%Y%m%d-%H%M")

# Set the backup file name
backup_name="${website}_htmlbackup-${date}"

# Set default file permissions
umask 177

# Copy the HTML directory to the temporary directory
cp -r ${from} ${tmp}${website}

# Rename the temporary directory with the timestamp of the backup
mv ${tmp}${website} ${tmp}${backup_name}

# Access the temporary directory
cd ${tmp}

# Compress the directory into a tar file
tar -cvzf ${tmp}${backup_name}.tar.gz ${backup_name}

# Create the backup location, if it doesn't already exist
mkdir -p ${to}${website}

# Move the tar.gz file to the backup location
mv ${tmp}${backup_name}.tar.gz ${to}${website}

# Build checksums
md5sum ${to}${website}/${backup_name}.tar.gz > ${to}${website}/${backup_name}.tar.gz.md5
sha256sum ${to}${website}/${backup_name}.tar.gz > ${to}${website}/${backup_name}.tar.gz.sha256

# Delete the old directory from the temporary folder
rm -rf ${tmp}${backup_name}/

# Set a value to be used to find all backups with the same name
find_backup_name="${to}${website}/${website}_htmlbackup*.tar.gz"
# Delete files which are older than the number of days defined
find $find_backup_name -mtime +$days -type f -delete