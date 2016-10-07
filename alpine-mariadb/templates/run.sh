#!/bin/sh

VOLUME_DB="/DATA/db"
VOLUME_LOGS="/DATA/log"
VOLUME_CONF="/DATA/conf"
VOLUME_RUN="/var/run/mysqld"

chown -R mysql:mysql /DATA

if [ -f $VOLUME_CONF/my.cnf ]; then
	echo "=> Creating link on MariaDB  config files"
	ln -sf $VOLUME_CONF/my.cnf /etc/mysql/my.cnf 
	chmod o-r /etc/mysql/my.cnf
fi

if [ ! -d $VOLUME_LOGS/mysql ]; then
	echo "=> Creating log folder on MariaDB"
	mkdir -p $VOLUME_LOGS/mysql
fi	

echo "=> Creating run folder on MariaDB"
mkdir -p $VOLUME_RUN
chown -R mysql:mysql $VOLUME_RUN

echo "=> Set permissions folder on MariaDB"
chown -R mysql:mysql /DATA $VOLUME_RUN

if [ ! -d $VOLUME_DB/mysql ]; then
	echo "=> An empty or uninitialized MariaDB volume is detected in $VOLUME_DB"
	echo "=> Installing MariaDB ..."
	mysql_install_db --user=mysql --datadir="$VOLUME_DB/mysql"
	echo "=> Done!"  
else
	echo "=> Using an existing volume of MariaDB"
fi

echo "=> Set permissions folder on MariaDB"
chown -R mysql:mysql /DATA $VOLUME_RUN

echo "=> Start MariaDB"
/usr/bin/mysqld --user=mysql