#!/bin/sh

VOLUME_LOGS="/DATA/logs"
VOLUME_CONF="/DATA/conf"
VOLUME_RUN="/DATA/phpfpm7"

if [ ! -d $VOLUME_RUN ] ; then
	echo "=> Create php-fpm work folder"
	mkdir -p $VOLUME_RUN
fi

if [[ -f $VOLUME_CONF/php-fpm.conf ]]; then
	echo "=> Create link to php-fpm config file"
	ln -sf $VOLUME_CONF/php-fpm.conf /etc/php7/php-fpm.conf
fi

if [ ! -d $VOLUME_LOGS/phpfpm7 ] ; then
	echo "=> Create  php-fpm log folder"
	mkdir -p $VOLUME_LOGS/php-fpm
fi	

# Enabling session files
if [ ! -d $VOLUME_RUN/tmp/sessions/ ] ; then
	mkdir -p $VOLUME_RUN/tmp/sessions/
	chown -Rf www-data:www-data /tmp/sessions 
	chmod g+x $VOLUME_RUN/tmp/sessions/
	sed -i -e "s:;\s*session.save_path\s*=\s*\"N;/path\":session.save_path = /DATA/phpfpm7/tmp/sessions:g" /etc/php7/php.ini
fi

echo "=> Set and check permissions"
chown -R www-data:www-data /DATA/

echo "=> Start php-fpm"
php-fpm7 -F