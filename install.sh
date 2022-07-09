#!/bin/sh
# Check/ensure user has run pre-installer, if not, run it.
# Note that 'skip' can be specified in the first argument.

CheckPre() {
	read -p '(y/n): '
	case $REPLY in
		"Y"|"y")
			echo 'Running pre-install.'
			# Update and upgrade packages, to get up-to-date packages
			sudo apt update -y && sudo apt upgrade
			# Restart the machine
			sudo reboot
		;;
	
		"N"|"n")
			echo 'Running installer!'
		;;
	
		*)
			echo 'Sorry, please type either "y" or "n" to run the pre-installer (y) or not (n).'
			CheckPre
		;;
	esac
}

if [ "$1" != "skip" ]; then
	echo 'Before running this script, please ensure you have run the pre-installer. (Note, this will restart your machine.) Would you like to run this?'
	CheckPre
fi

# Now check/verify the type of installation being done (ssl or no ssl.)
# Note that it can be specified in the command line as the second argument.

VerifyType() {
	case $INSTALLTYPE in
		"ssl"|"Ssl")
			INSTALLTYPE=ssl
			echo "Installing with ssl."
			RAWLINK="https://raw.githubusercontent.com/zymsbgt/shadowsdash-installer/main/shadowsdash-withssl.conf"
		;;
		"nossl"|"Nossl"|"noSsl"|"NoSsl")
			INSTALLTYPE=nossl
			echo "Installing without ssl."
			RAWLINK="https://raw.githubusercontent.com/zymsbgt/shadowsdash-installer/main/shadowsdash-nossl.conf"
		;;
		*)
			echo 'Sorry, please type either "ssl" or "nossl" to install with or without ssl.'
			read -p '(ssl/nossl): ' INSTALLTYPE
			VerifyType
		;;
	esac
}

if [ $2 ]; then
	INSTALLTYPE=$2
	VerifyType
else
	echo 'Please specify if the instillation will use ssl.'
	read -p '(ssl/nossl): ' INSTALLTYPE
	VerifyType
fi

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
wget $RAWLINK

# Tell the user to open the config with Nano
echo "Opening /etc/apache2/sites-available/shadowsdash-"$INSTALLTYPE".conf in 5 seconds. Replace the <domain> field with your own domain in the file, and save it!"
sleep 5
sudo nano "/etc/apache2/sites-available/shadowsdash-"$INSTALLTYPE".conf"

sudo ln -s /etc/apache2/sites-available/shadowsdash.conf /etc/apache2/sites-enabled/shadowsdash.conf
sudo a2enmod rewrite

if [ $INSTALLTYPE = 'ssl' ]; then
	sudo a2enmod ssl
fi

sudo systemctl restart apache2
rm /var/www/html/index.html
echo "Go to the directory /var/www/html and upload your copy of Shadow's Dash to this directory! Type anything after you're done to continue the installation."
read -p "Type anything when done: " BINVAR

crontab -e */2 * * * * php /var/www/html/scripts/queueHandler.php >/dev/null 2>&1
echo "Install finished!"
