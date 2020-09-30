#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run with sudo privileges"
  exit
fi

ROOT_DIR=$(eval echo ~${SUDO_USER})"/www"
CONF_DIR="/etc/apache2/sites-available"

# Ask user to give name of virtual host

read -p 'Input Domain: ' DOMAIN

echo Create Virtual Host Folder at ${ROOT_DIR}

# Create folder root for virtual host

mkdir -pm 777 ${ROOT_DIR}/${DOMAIN}
chown ${SUDO_USER}:${SUDO_USER} ${ROOT_DIR}/${DOMAIN}

# Create index.html inside root folder

index_file=${ROOT_DIR}/${DOMAIN}/index.html

cat > ${index_file} << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hay..!!</title>
</head>
<body>
    <h1>Your Virtual Host ${DOMAIN} is ready to use</h1>
</body>
</html>
EOF

# Create virtual host configuration

echo Create Virtual Host Config

CONF_FILE=${CONF_DIR}/${DOMAIN}.conf 

cat > ${CONF_FILE} << EOF

<VirtualHost *:80>
        ServerAdmin webmaster@${DOMAIN}
        ServerName ${DOMAIN}
        ServerAlias www.${DOMAIN}
        DocumentRoot ${ROOT_DIR}/${DOMAIN}

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        <Directory ${ROOT_DIR}/${DOMAIN}>
            Options Indexes FollowSymLinks
            AllowOverride All
            Require all granted
        </Directory>
</VirtualHost>

EOF

echo Add Virtual Host url at hosts

sed -i "2i127.0.0.1         ${DOMAIN}" /etc/hosts

echo Adding Virtual Host Configuration into apache service

a2ensite ${DOMAIN}.conf

echo Restart Apache Service

service apache2 restart

echo Your Virtual Host $DOMAIN is Ready to use
