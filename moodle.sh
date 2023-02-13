#!/bin/bash

# Actualizar la lista de paquetes
sudo apt-get update

# Instalar los paquetes necesarios
sudo apt-get install -y apache2 mariadb-server php7.4 libapache2-mod-php7.4 php7.4-xml php7.4-mysql php7.4-curl php7.4-json

# Configurar la base de datos
sudo mysql -u root <<EOF
CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'moodleuser'@'localhost' IDENTIFIED BY 'Pepe-jamon22';
GRANT ALL PRIVILEGES ON moodle.* TO 'moodleuser'@'localhost';
EOF

# Descargar la última versión estable de Moodle
wget https://download.moodle.org/download.php/direct/stable38/moodle-latest-38.tgz

# Descomprimir Moodle
tar xzf moodle-latest-38.tgz
sudo mv moodle /var/www/html/moodle

# Configurar los permisos de Apache
sudo chown -R www-data:www-data /var/www/html/moodle
sudo chmod -R 755 /var/www/html/moodle

# Configurar Apache
sudo echo '<VirtualHost *:80>
   DocumentRoot /var/www/html/moodle
   ServerName kokod.xyz/moodle
   <Directory /var/www/html/moodle>
      AllowOverride All
      Require all granted
   </Directory>
</VirtualHost>' > /etc/apache2/sites-available/moodle.conf
sudo a2dissite 000-default
sudo a2ensite moodle.conf
sudo a2enmod rewrite
sudo service apache2 restart

# Acceder a la URL de Moodle para completar la configuración en el navegador
echo "Moodle se ha instalado con éxito. Acceda a http://moodle.local en su navegador para completar la configuración."
