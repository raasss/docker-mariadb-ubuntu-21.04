FROM ubuntu:21.04

ENV MYSQL_DATABASE="dbname1"
ENV MYSQL_USER="dbuser1"
ENV MYSQL_PASSWORD="dbuser1pass"

RUN set -e; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get dist-upgrade -y; \
    apt-get install -y --no-install-recommends \
      tini \
      crudini \
      mariadb-server \
      mariadb-client; \
    apt-get autoremove -y; \
    apt-get clean; \
    rm -rvf /var/lib/apt/lists/*

RUN set -e; \
    mkdir -v /var/run/mysqld; \
    chown -v -R mysql:mysql /var/run/mysqld

VOLUME [ "/var/lib/mysql" ]

EXPOSE 3306

COPY 50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod -v 0644 /etc/mysql/mariadb.conf.d/50-server.cnf

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod -v 0755 /docker-entrypoint.sh

ENTRYPOINT ["tini", "--"]
CMD ["/docker-entrypoint.sh"]
