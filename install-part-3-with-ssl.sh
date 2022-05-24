#!/bin/sh
sudo ln -s /etc/apache2/sites-available/shadowsdash.conf /etc/apache2/sites-enabled/shadowsdash.conf
sudo a2enmod rewrite
sudo a2enmod ssl
sudo systemctl restart apache2
rm /var/www/html/index.html
echo "Go to the directory /var/www/html and upload your copy of Shadow's Dash to this directory!"