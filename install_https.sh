#!/bin/bash

# actualizar el sistema
apt-get update

# instalar Apache
apt-get install apache2

# habilitar el módulo SSL de Apache
a2enmod ssl

# crear un directorio para almacenar los certificados SSL
mkdir /etc/apache2/ssl

# generar los certificados SSL
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt

# editar el archivo de configuración de Apache
nano /etc/apache2/sites-available/default-ssl.conf

# agregar las siguientes líneas al archivo de configuración, reemplazando "your_domain.com" por el nombre de tu dominio:
<VirtualHost _default_:443>
    ServerAdmin webmaster@localhost
    ServerName kokodlocal.ddns.net
    DocumentRoot /var/www/html

    # habilitar SSL
    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/apache.crt
    SSLCertificateKeyFile /etc/apache2/ssl/apache.key

    # configurar el log de acceso
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

# guardar y cerrar el archivo

# habilitar el sitio default-ssl
a2ensite default-ssl

# reiniciar Apache
service apache2 restart
