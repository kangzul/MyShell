#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run with sudo privileges"
  exit
fi

dir_root="/home/$USER/www"
dir_conf="/etc/apache2/sites-available"

# Ask user to give name of virtual host

read -p 'Input Domain: ' domain

echo Create Virtual Host Folder at ${dir_root}

# Create folder root for virtual host

mkdir -m 777 ${dir_root}/${domain}

# Create index.html inside root folder

index_file=${dir_root}/${domain}/index.html

cat > ${index_file} << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hay..!!</title>
</head>
<body>
    <h1>Your Virtual Host ${domain} is ready to use</h1>
</body>
</html>
EOF

# Create virtual host configuration

echo Create Virtual Host Config

conf_file=${dir_conf}/${domain}.conf 

cat > ${conf_file} << EOF

<VirtualHost *:80>
        ServerAdmin webmaster@${domain}
        ServerName ${domain}
        ServerAlias www.${domain}
        DocumentRoot ${dir_root}/${domain}

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        <Directory ${dir_root}/${domain}>
            Options Indexes FollowSymLinks
            AllowOverride All
            Require all granted
        </Directory>
</VirtualHost>

EOF

echo Add Virtual Host url at hosts

sed -i "2i127.0.0.1  ${domain}" /etc/hosts

echo Adding Virtual Host Configuration into apache service

a2ensite ${domain}.conf

echo Restart Apache Service

systemctl restart apache2

echo Your Virtual Host $domain is Ready to use
