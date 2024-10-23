#!/bin/bash

# Definir variáveis de ambiente
echo "Exportando variáveis de ambiente para o Apache..."
cat <<EOF >> /etc/apache2/envvars
# daloRADIUS users interface port
export DALORADIUS_USERS_PORT=80

# daloRADIUS operators interface port
export DALORADIUS_OPERATORS_PORT=8000

# daloRADIUS package root directory
export DALORADIUS_ROOT_DIRECTORY=/var/www/daloradius

# daloRADIUS administrator's email
export DALORADIUS_SERVER_ADMIN=admin@daloradius.local
EOF

# Atualizar a configuração do Apache para escutar nas portas definidas
echo "Atualizando a configuração de portas do Apache..."
cat <<EOF > /etc/apache2/ports.conf
Listen \${DALORADIUS_USERS_PORT}
Listen \${DALORADIUS_OPERATORS_PORT}
EOF

# Configurar site de operadores
echo "Configurando o site de operadores..."
cat <<EOF > /etc/apache2/sites-available/operators.conf
<VirtualHost *:\${DALORADIUS_OPERATORS_PORT}>
  ServerAdmin \${DALORADIUS_SERVER_ADMIN}
  DocumentRoot \${DALORADIUS_ROOT_DIRECTORY}/app/operators
  
  <Directory \${DALORADIUS_ROOT_DIRECTORY}/app/operators>
    Options -Indexes +FollowSymLinks
    AllowOverride All
    Require all granted
  </Directory>

  ErrorLog \${APACHE_LOG_DIR}/daloradius/operators/error.log
  CustomLog \${APACHE_LOG_DIR}/daloradius/operators/access.log combined
</VirtualHost>
EOF

# Configurar site de usuários
echo "Configurando o site de usuários..."
cat <<EOF > /etc/apache2/sites-available/users.conf
<VirtualHost *:\${DALORADIUS_USERS_PORT}>
  ServerAdmin \${DALORADIUS_SERVER_ADMIN}
  DocumentRoot \${DALORADIUS_ROOT_DIRECTORY}/app/users

  <Directory \${DALORADIUS_ROOT_DIRECTORY}/app/users>
    Options -Indexes +FollowSymLinks
    AllowOverride None
    Require all granted
  </Directory>

  ErrorLog \${APACHE_LOG_DIR}/daloradius/users/error.log
  CustomLog \${APACHE_LOG_DIR}/daloradius/users/access.log combined
</VirtualHost>
EOF

# Ativar os sites e reiniciar o Apache
echo "Ativando os sites e reiniciando o Apache..."
a2dissite 000-default.conf
a2ensite operators.conf users.conf
systemctl reload apache2
