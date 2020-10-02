#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run with sudo privileges"
  exit
fi

ROOT_DIR=$(eval echo ~${SUDO_USER})"/www"
CONF_DIR="/etc/apache2"

echo "Please type one of following list below"

ls -1 ${CONF_DIR}/sites-enabled | sed 's/\(.*\)\..*/\1/'

read -p "Enter filename: " DOMAIN

echo Removing Virtual Host folder

rm -rf ${ROOT_DIR}/${DOMAIN}

echo Removing config from apache services

a2dissite ${DOMAIN}.conf

service apache2 restart

rm -rf ${CONF_DIR}/sites-available/${DOMAIN}.conf

sed -i "/${DOMAIN}/d" /etc/hosts

echo "${DOMAIN} completely removed from virtual host"
