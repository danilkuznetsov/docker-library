#!/bin/sh

VOLUME_LOGS="/DATA/logs"
VOLUME_CONF="/DATA/conf/nginx"

if [[ -f $VOLUME_CONF/nginx.conf ]]; then
	echo "=> Creating link on main Nginx config"
	rm -rf /etc/nginx/nginx.conf
	ln -sf $VOLUME_CONF/nginx.conf /etc/nginx/nginx.conf
fi

if [[ -d $VOLUME_CONF/conf.d ]]; then
	echo "=> Creating link on Nginx config files"
	rm -rf /etc/nginx/conf.d
	ln -sf $VOLUME_CONF/conf.d /etc/nginx/conf.d
fi

if [ ! -d $VOLUME_LOGS/nginx ]; then
	echo "=> Create log folder"
 	mkdir -p $VOLUME_LOGS/nginx
fi 

echo "=> Set permissions /DATA/"
chown -R nginx:nginx /DATA/

echo "=> Check and create tmp folder"
mkdir -p /tmp/nginx
chown nginx:nginx /tmp/nginx

echo "=> Start nginx"
exec "$@"