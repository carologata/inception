#!/bin/bash

service mariadb start

mariadb -u root -e "CREATE DATABASE IF NOT EXISTS ${WP_DB}; \
	CREATE USER '${WP_USER}'@'%' IDENTIFIED BY '${WP_PW}'; \
	GRANT ALL ON ${WP_DB}.* TO '${WP_USER}'@'%' IDENTIFIED BY '${WP_PW}'; \
	FLUSH PRIVILEGES;"