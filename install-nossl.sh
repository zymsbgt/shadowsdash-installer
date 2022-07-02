#!/bin/sh

# Installs apache2
sudo apt install -y apache2

# Installs MySQL and configures it (disabling this because MySQL instance is located remotely)
# sudo apt install mysql-server
# Adding PHP 8 repository, installing php 8 and required plugins
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update -y
sudo apt install -y php8.0 libapache2-mod-php8.0
sudo apt install -y php8.0-mysql php8.0-common php8.0-mysql php8.0-xml php8.0-xmlrpc php8.0-curl php8.0-gd php8.0-imagick php8.0-cli php8.0-dev php8.0-imap php8.0-mbstring php8.0-opcache php8.0-soap php8.0-zip php8.0-intl -y

# Install required packages for the script to run
sudo apt install -y zip unzip wget

# Restart apache
sudo systemctl restart apache2

# Move to apache configuration directory
cd /etc/apache2/sites-available

# Remove the default configuration
a2dissite 000-default.conf
rm 000-default.conf

# Get the new configuration
wget https://raw.githubusercontent.com/zymsbgt/shadowsdash-installer/main/shadowsdash-nossl.conf

# Tell the user to open the config with Nano
echo "Opening /etc/apache2/sites-available/shadowsdash-nossl.conf in 5 seconds. Replace the <domain> field with your own domain in the file, and save it!"
sleep 5
sudo nano /etc/apache2/sites-available/shadowsdash-nossl.conf

sudo ln -s /etc/apache2/sites-available/shadowsdash.conf /etc/apache2/sites-enabled/shadowsdash.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
rm /var/www/html/index.html
echo "Go to the directory /var/www/html and upload your copy of Shadow's Dash to this directory! Type exit after you're done to continue the installation."
bash

crontab -e */2 * * * * php /var/www/html/scripts/queueHandler.php >/dev/null 2>&1
echo "Install finished!"
