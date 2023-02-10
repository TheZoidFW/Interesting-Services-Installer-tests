#!/bin/bash

# Update the system
sudo apt-get update -y

# Install necessary packages
sudo apt-get install -y wget unzip

# Download Mattermost
wget https://releases.mattermost.com/5.33.3/mattermost-5.33.3-linux-amd64.tar.gz

# Extract the archive
tar -xzvf mattermost*.tar.gz

# Rename the folder
mv mattermost /opt/mattermost

# Create a user for Mattermost
sudo useradd --system --user-group mattermost

# Change the ownership of the folder
sudo chown -R mattermost:mattermost /opt/mattermost

# Create a configuration file
sudo nano /opt/mattermost/config/config.json

# Add the following configuration to the file:
# {
#   "ServiceSettings": {
#     "ListenAddress": ":8065",
#     "MaximumLoginAttempts": 10,
#     "SegmentDeveloperKey": ""
#   },
#   "SqlSettings": {
#     "DriverName": "mysql",
#     "DataSource": "mmuser:mostest@tcp(dockerhost:3306)/mattermost_test?charset=utf8mb4,utf8\u0026readTimeout=30s\u0026writeTimeout=30s"
#   },
#   "LogSettings": {
#     "EnableConsole": true,
#     "ConsoleLevel": "INFO",
#     "EnableFile": true,
#     "FileLevel": "INFO",
#     "FileFormat": "json",
#     "FileLocation": "/var/log/mattermost/mattermost.log"
#   }
# }

# Save the file and exit

# Create a service file
sudo nano /etc/systemd/system/mattermost.service

# Add the following configuration to the file:
# [Unit]
# Description=Mattermost
# After=network.target
# 
# [Service]
# Type=simple
# User=mattermost
# ExecStart=/opt/mattermost/bin/mattermost
# WorkingDirectory=/opt/mattermost
# Restart=always
# RestartSec=10
# LimitNOFILE=49152
# 
# [Install]
# WantedBy=multi-user.target

# Save the file and exit

# Reload the system manager configuration
sudo systemctl daemon-reload

# Enable the service to start on boot
sudo systemctl enable mattermost

# Start the service
sudo systemctl start mattermost

# Check the status of the service
sudo systemctl status mattermost

# If everything is ok, you should see something like this:
# ● mattermost.service - Mattermost
#    Loaded: loaded (/etc/systemd/system/mattermost.service; enabled; vendor preset: enabled)
#    Active: active (running) since Mon 2021-02-22 09:40:44 UTC; 1h 18min ago
#   Process: 2368 ExecStart=/opt/mattermost/bin/mattermost (code=exited, status=0/SUCCESS)
# Main
