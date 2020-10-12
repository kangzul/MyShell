# MyShell

This is simple script to run some task automatically in linux system

### System Requirement
* Linux Distribution (Tested in Linux Mint 19.3)
* Apache2 Webserver (Create Virtual Host)
* Rclone
* DNScrypt

### Content
* Sync Local Music to Google Drive (Rclone)
* Sync Google Drive to Local (Rclone)
* Run DoH with cloudflare configuration
* Create Virtual Host
* Delete Virtual Host 

### How To Use
* Clone this repo
* cd to `MyShell`
* Run this script with command `sudo ./myshell.sh`
* Select action what you want, type number of option
* Type required information (if needed)

###Note
Please disable first `000-default.conf` with command `sudo a2dissite 000-default.conf`if you want to create Virtual Host