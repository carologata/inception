FROM debian:oldstable

ARG WP_DB
ARG WP_USER
ARG WP_PW

RUN apt update && apt install -y mariadb-server && apt clean

RUN mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld && chmod 777 /var/run/mysqld

COPY ./conf/my.cnf        /etc/mysql/my.cnf
COPY ./tools/db-script.sh /tmp/script.sh

RUN chmod 777 /tmp/script.sh && bash /tmp/script.sh

# mysqld_safe is a built-in MariaDB wrapper script that adds safety features:
# - Wraps around the actual mysqld daemon with monitoring and crash recovery
# - Provides proper Docker signal handling for graceful container shutdowns
# - Performs pre-startup validation and enhanced error logging
ENTRYPOINT [ "mysqld_safe" ]