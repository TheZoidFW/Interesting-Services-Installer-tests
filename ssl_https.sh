#!/bin/bash

# actualizar el sistema
apt-get update

# instalar Apache
apt-get install apache2

# habilitar el módulo SSL de Apache
a2enmod ssl

# instalar Certbot
apt-get install certbot

# obtener un certificado SSL gratuito de Let's Encrypt
certbot --apache

# seguir las instrucciones en pantalla para configurar el dominio y completar la solicitud del certificado

# una vez que se haya obtenido y configurado el certificado, reiniciar Apache
service apache2 restart
