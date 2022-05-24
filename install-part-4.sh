#!/bin/sh
echo "Do 'crontab -e' and paste the following command: "
echo "*/2 * * * * php /var/www/html/scripts/queueHandler.php >/dev/null 2>&1"