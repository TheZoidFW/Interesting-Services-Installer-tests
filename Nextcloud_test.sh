#!/bin/bash

user='your user'

password='your password'

flag="control"

if [ ! -f $flag ]; then
        releasever=$(grep -oP '(?<=VERSION_ID=")\d+\.\d+' /etc/os-release)

        zypper ar https://download.opensuse.org/repositories/system:/snappy/openSUSE_Leap_$releasever/ snappy 2>/dev/null 

        zypper --gpg-auto-import-keys refresh

        zypper dup --from snappy

        zypper install -y snapd  

        systemctl enable --now snapd 

        systemctl enable --now snapd.apparmor 

        echo "Snap instalatu diño :)))))"

        touch $flag
        echo "you need to execute the script again. rebooting..."
        sleep 3
        reboot
fi



snap install nextcloud 
if [ $? -ne 0 ];then
        echo "it has not been installed properly"
        exit 1
fi


nextcloud.manual-install $user $password
if [ $? -ne 0 ];then
        echo "it has not been installed properly"
        exit 1
fi


echo "Is it installed correctly?"

echo "What is the trusted domain? but put *"

read domeinua

if [ -z $domeinua ]; then
    echo "Do you know how to write the domain?"
    exit 1
fi

nextcloud.occ config:system:set trusted_domains 1 --value=$domeinua
if [ $? -ne 0 ];then
        echo "no se ha instalado bien"
        exit 1
fi


echo "Domain OK"

nextcloud.enable-https self-signed
if [ $? -ne 0 ];then
        echo "no se ha instalado bien"
        exit 1
fi

echo "Nextcloud has been installed correctly"

server_ipv4=$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1)

echo "Connect here (https://$server_ipv4)"
