#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run with sudo privileges"
  exit
fi

echo 'Please select what will you use'
echo '  1. Sync Local Music to Drive'
echo '  2. Sync Drive Music to Local'
echo '  3. Run DoH'
echo '  4. Create Virtual Host (Apache)'
echo '  5. Delete Virtual Host (Apache)'
echo '  6. Enable root without password (MariaDB)'
echo '  #. More Action Will be add here'

read -p 'Input your action : ' ACTION
HOME_DIR=$(eval echo ~${SUDO_USER})
APACHE_DIR=/etc/apache2
WEB_DIR=${HOME_DIR}/www

case ${ACTION} in
    1)
        rclone sync $HOME_DIR/Music google-drive:Music
        rclone cleanup google-drive:
        ;;
    2)
        rclone sync google-drive:Music $HOME_DIR/Music
        rclone cleanup google-drive:
        ;;
    3)
        sed -i "/127.0.0/d" /etc/resolv.conf
        sed -i "2i127.0.0.1" /etc/resolv.conf
        sed -i "3ioptions edns0" /etc/resolv.conf
        /opt/linux-x86_64/dnscrypt-proxy
        ;;
    4)
        # Ask user to give name of virtual host
        read -p 'Input Domain: ' DOMAIN
        echo Create Virtual Host Folder at ${WEB_DIR}
        # Create folder root for virtual host
        mkdir -pm 777 ${WEB_DIR}/${DOMAIN}
        chown ${SUDO_USER}:${SUDO_USER} ${WEB_DIR}/${DOMAIN}
        # Create index.html inside root folder
        echo "<!DOCTYPE html>
        <html lang='en'>
        <head>
            <meta charset='UTF-8'>
            <meta name='viewport' content='width=device-width, initial-scale=1.0'>
            <title>Hay..!!</title>
        </head>
        <body>
            <h1>Your Virtual Host ${DOMAIN} is ready to use</h1>
        </body>
        </html>" > ${WEB_DIR}/${DOMAIN}/index.html
        # Create virtual host configuration
        echo Create Virtual Host Config
        echo "<VirtualHost *:80>
            ServerAdmin webmaster@${DOMAIN}
            ServerName ${DOMAIN}
            ServerAlias www.${DOMAIN}
            DocumentRoot ${WEB_DIR}/${DOMAIN}

            ErrorLog ${APACHE_LOG_DIR}/error.log
            CustomLog ${APACHE_LOG_DIR}/access.log combined

            <Directory ${WEB_DIR}/${DOMAIN}>
                Options Indexes FollowSymLinks
                AllowOverride All
                Require all granted
            </Directory>
        </VirtualHost>" > ${APACHE_DIR}/sites-available/${DOMAIN}.conf 
        echo Add Virtual Host url at hosts
        sed -i "2i127.0.0.1       ${DOMAIN}" /etc/hosts
        echo Adding Virtual Host Configuration into apache service
        a2ensite ${DOMAIN}.conf
        echo Restart Apache Service
        service apache2 restart
        echo Your Virtual Host $DOMAIN is Ready to use
        ;;
    5)
        echo "Please type one of following list below"
        ls -1 ${APACHE_DIR}/sites-enabled | sed 's/\(.*\)\..*/\1/'
        read -p "Enter filename: " DOMAIN
        echo Removing Virtual Host folder
        rm -rf ${WEB_DIR}/${DOMAIN}
        echo Removing config from apache services
        a2dissite ${DOMAIN}.conf
        service apache2 restart
        rm -rf ${APACHE_DIR}/sites-available/${DOMAIN}.conf
        sed -i "/${DOMAIN}/d" /etc/hosts
        echo "${DOMAIN} completely removed from virtual host"
        ;;
    6)
        mysql -u root
        SELECT User,Host FROM mysql.user;
        DROP USER 'root'@'localhost';
        CREATE USER 'root'@'%' IDENTIFIED BY '';
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
        FLUSH PRIVILEGES;
    *)
        echo I don\'t know the option
        ;;
esac