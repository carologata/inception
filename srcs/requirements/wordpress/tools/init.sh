#!/bin/bash

# If wp-config-sample.php exists, WordPress hasn't been configured yet
if [ -f /var/www/html/wp-config-sample.php ]; then
    # Remove the sample configuration file
    rm -rf /var/www/html/wp-config-sample.php
    # Remove the default Apache index.html page
    rm -fr /var/www/html/index.html

    # Install WordPress core using WP-CLI (WordPress Command Line Interface)
    wp core install --allow-root \
        --path=/var/www/html \
        --title="42SP Inception" \
        --url=$SERVER_NAME \
        --admin_user=$ROOT_USER \
        --admin_password=$ROOT_PW \
        --admin_email=$ROOT_MAIL

    # Create a second WordPress user (non-admin)
    wp user create --allow-root \
        --path=/var/www/html \
        "$WP_USER" "$WP_MAIL" \
        --user_pass=$WP_PW \
        --role='author'

fi

# Start PHP-FPM service in foreground mode
# -F flag keeps it running in foreground (required for Docker containers)
# Without -F, the process would run in background and container would exit
php-fpm8.1 -F