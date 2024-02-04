# HTML Content Backup

This is a simple BASH script which can be run on systems with BASH. This allows you to esily take a complete backup of your HTML web content. This can then be run as part of a cron job to easily back up content to another location.

## Contributors

- [Alex Winder](https://alexwinder.com)

## Getting Started

### Prerequisites

To be able to use this you must have the following installed:

- GNU Tar

This script has been tested to work on the following systems:

- Debian 8 & 9
- Ubuntu 22

## Usage

The [html-backup.sh](html-backup.sh) script accepts a number of named parameters which allows you to customise it for your particular environment.

- `--help` - Show a help guide on the script. If used then no other parameters will be considered.
- `--to` - Where you would like to back the files up to. Default: `/var/backups/html`.
- `--website` - The name of the website with which the backed up files related to.
- `--from` - The source directory of the website files.
- `--days` - The number of days to keep backup files before deleting them. Default: `7` (days).

The script executed on the command line, with the minimum required parameters of `--website` and `--from`.

```bash
./html-backup.sh --website <website_name> --from </path/to/website/files>
```

This will create the HTML backup value set in the `--to` parameter, by default this is `/var/backups/html` if you do not specify the `--to` parameter. A subdirectory will then be created based on your `--website` parameter. Please note that this directory will be created if it doesn't already exist.

You are free to make use of any of the named parameters to customise for your particular usecase. An example usage is listed below:

```bash
./html-backup.sh --website example.com --from /var/www/example.com --to /home/user/backups --days 30
```

The above example will backup the files in `/var/www/example.com` into a directory of `/home/user/backups/example.com`. It will then do a scan and delete any backups which are found to be older than `30` days.

## Automate via Cron

The script can be automated via a crontab. To do this first open the crontab:

```bash
crontab -e
```

Then append the end of the crontab with a new line:

```bash
0 4 * * * /path/to/html-backup/html-backup.sh --website <website_name> --from </path/to/website/files>
```

This will cause the script to run every day at 04:00, from the current logged in user. If you wish to run as a different user then you will need to open the crontab for that particular user. This crontab will create a backup of the HTML content specified.

## Extracting Backup

If you wish to extract a particular backup you can do so with the following command:

```bash
tar -xvf /var/backups/html/example.com/www.example.com_htmlbackup-DATE-TIME.tar.gz
```

You should swap in the path and filename as per your own setup.

## License

This project is licensed under the [MIT License](LICENSE.md).
