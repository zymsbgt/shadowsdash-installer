#!/bin/sh
#cd /etc/apache2/sites-available
sudo ln -s /etc/apache2/sites-available/shadowsdash.conf /etc/apache2/sites-enabled/shadowsdash.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
cd /var/www/html
rm index.html
echo "Upload your copy of Shadow's Dash to this directory!"