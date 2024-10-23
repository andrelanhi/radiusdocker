#!/bin/bash

# Configurando o MariaDB
echo "Configurando o MariaDB..."
mariadb -u root -proot_password -e "CREATE DATABASE raddb; GRANT ALL ON raddb.* TO 'raduser'@'localhost' IDENTIFIED BY 'radpass'; FLUSH PRIVILEGES;"

# Carregar schemas SQL
mariadb -u raduser -pradpass raddb < /var/www/daloradius/contrib/db/fr3-mariadb-freeradius.sql
mariadb -u raduser -pradpass raddb < /var/www/daloradius/contrib/db/mariadb-daloradius.sql

# Configurar o Apache e daloRADIUS
echo "Configurando o Apache para o daloRADIUS..."
/bin/bash /apache-config.sh

# Iniciar o Apache
echo "Iniciando o Apache..."
apachectl -D FOREGROUND
