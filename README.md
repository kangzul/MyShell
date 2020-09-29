# SimpleVH

This is simple script to generate virtual host automatically in linux system

### System Requirement
* Linux Distribution (Tested in Linux Mint 19.3)
* Apache2 Webserver

### How To Run
#### Create Virtual Host
* Clone this repo
* Please disable first 000-default.conf with command `sudo a2dissite 000-default.conf`
* Create virtual host with command `sudo ./create_vh.sh`
* Enter domain or name your url address

#### Delete Virtual Host
* Delete virtual host with command `sudo ./delete_vh.sh`
* Enter domain thay you want to delete