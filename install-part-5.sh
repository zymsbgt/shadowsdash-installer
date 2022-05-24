#!/bin/sh
# Starting cron jobs
crontab -e
*/2 * * * * php /var/www/html/scripts/queueHandler.php >/dev/null 2>&1