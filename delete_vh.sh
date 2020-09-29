#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run with sudo privileges"
  exit
fi

dir_conf="/etc/apache2"

echo "Please type one of following list below"

ls -1 ${dir_conf}/sites-enabled | sed 's/\(.*\)\..*/\1/'

read -p "Enter filename: " domain

echo Removing Virtual Host folder

rm -rf /home/$USER/www/${domain}

echo Removing config from apache services

a2dissite ${domain}.conf

systemctl restart apache2

rm -rf ${dir_conf}/sites-available/${domain}.conf

sed -i '/${domain}/d' /etc/hosts

echo "${domain} completely removed from virtual host"