# Usar uma imagem base do Ubuntu
FROM ubuntu:20.04

# Instalar dependências
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    libapache2-mod-php \
    php-mysql \
    php-zip \
    php-mbstring \
    php-common \
    php-curl \
    php-gd \
    php-db \
    php-mail \
    php-mail-mime \
    mariadb-client \
    freeradius-utils \
    git \
    unzip \
    rsyslog \
    && rm -rf /var/lib/apt/lists/*

# Clonar o repositório do daloRADIUS
RUN git clone https://github.com/lirantal/daloradius.git /var/www/daloradius

# Configurar permissões do daloRADIUS
RUN chown -R www-data:www-data /var/www/daloradius \
    && chmod 664 /var/www/daloradius/app/common/includes/daloradius.conf.php.sample

# Copiar os scripts de setup
COPY setup.sh /setup.sh
COPY apache-config.sh /apache-config.sh

# Expor a porta padrão do Apache
EXPOSE 80 8000

# Rodar o setup do daloRADIUS e o Apache no início do container
CMD ["/bin/bash", "/setup.sh"]
