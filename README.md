# HTML Content Backup

This is a simple BASH script which can be run on systems with BASH. This allows you to esily take a complete backup of your HTML web content. This can then be run as part of a cron job to easily back up content to another location.

## Contributors

- [Alex Winder](https://www.alexwinder.uk) 

## Getting Started

### Prerequisites

To be able to use this you must have the following installed:

- GNU Tar

This script has been tested to work on the following systems:

- Debian 8 Jessie
- Debian 9 Wheezy

### Installing

#### Store the Backup Script

In order for this script to work correctly it is advised that create the correct folder to place the script. This has been defined as ```/var/backups/html``` in [backup.sh](backup.sh). You are welcome to change this as per your own requirements.

> mkdir -p /var/backups/html

The [backup.sh](backup.sh) should be placed in this location.

#### Configure Values

Once the script is in the correct location then the following information is required to be entered on the backup script:

- The website content you are wanting to backup (line 4 "html").
- The directory where the website content is located (line 7 "html_location").
- The location of the temporary directory (line 11 "tmp_location").
- The number of days you wish to store backup files for (line 14 "days"). This is by default set to 7 days.

##### Optional Values

If you wish you can also edit the following:

- The location where backups will be sent (line 27 "backup_location").

#### Change Permissions

Once the information above has been inserted then the permissions of the file should be changed:

> chmod 700 /var/backups/html/backup.sh

If you have specified a different location to the example given above then you will need to adjust the location accordingly.

#### Test Script

The file can then be tested to see if all things work as expected.

> /var/backups/html/backup.sh

If you have specified a different location to the example given above then you will need to adjust the location accordingly.

A new directory should be created which will be the same as the value in set in the "html" value. Inside this directory should be a complete SQLdump of the database defined.

During testing you will see an output of all of the files which are being included in the tar backup.

#### Automate via Cron

The script can now be added to the crontab, if required, to run automatically. To do this first open the crontab:

> crontab -e

Then append the end of the crontab with a new line:

> 0 4 * * * /var/backups/html/backup.sh

This will cause the script to run every day at 04:00, from the current logged in user. If you wish to run as a different user then you will need to open the crontab for that particular user. This crontab will create a backup of the HTML content specified.

## License

This project is licensed under the [MIT License](LICENSE.md).