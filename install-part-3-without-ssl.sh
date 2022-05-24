#!/bin/sh
cd /etc/apache2/sites-available
# Remove the default configuration
a2dissite 000-default.conf
rm 000-default.conf
wget 