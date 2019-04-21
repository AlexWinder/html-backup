#!/bin/bash

# Set which HTML content is being backed up
html="www.example.com"

# Set location of where the HTML content currently is - a forward slash (/) should be present at the end of the string.
# By default this will include the html variable previously set, if your system is not configured in such a way then you can remove this
html_location="/var/www/${html}/"

# Set location of temporary directory - a forward slash (/) should be present at the end of the string.
tmp_location="/tmp/"

# How many days would you like to keep files for?
days="7"

######################################################
##### EDITING BELOW MAY CAUSE UNEXPECTED RESULTS #####
######################################################

# Obtain the date
date=$(date +"%Y%m%d-%H%M")

# Set the location of where the backup will be sent to
backup_location="/var/backups/html/"

# Set the backup file name
backup_name="${html}_htmlbackup-${date}"

# Set default file permissions
umask 177

# Copy the HTML directory to the temporary directory
cp -r $html_location $tmp_location

# Rename the temporary directory with the timestamp of the backup
mv ${tmp_location}${html} ${tmp_location}${backup_name}

# Access the temporary directory
cd ${tmp_location}

# Compress the directory into a tar file
tar -cvzf ${tmp_location}${backup_name}.tar.gz ${backup_name}

# Create the backup location, if it doesn't already exist
mkdir -p ${backup_location}${html}

# Move the tar.gz file to the backup location
mv ${tmp_location}${backup_name}.tar.gz ${backup_location}${html}

# Delete the old directory from the temporary folder
rm -rf ${tmp_location}${backup_name}/

# Set a value to be used to find all backups with the same name
find_backup_name="${backup_location}${html}/${html}_htmlbackup*.tar.gz"
# Delete files which are older than the number of days defined
find $find_backup_name -mtime +$days -type f -delete