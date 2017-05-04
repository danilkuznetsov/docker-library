FROM alpine:edge
MAINTAINER Danil Kuznetsov <kuznetsov.danil.v@gmail.com>

ENV LANG="en_US.UTF-8" \
	LC_ALL="en_US.UTF-8" \
	LANGUAGE="en_US.UTF-8" \
	TERM="xterm"

RUN set -x \
	&& addgroup -g 82 -S nginx \
	&& adduser -u 82 -D -S -G nginx -h /var/cache/nginx -s /sbin/nologin nginx

ENV NGINX_VERSION nginx-1.12.0
ENV GEOIP_VERSION 1.6.10

RUN apk add --update  --no-cache  \
		wget \
		build-base \
		ca-certificates \
		gcc \
		libc-dev \
		make \
		openssl-dev \
		openssl \
		pcre-dev \
		pcre \
		zlib \
		zlib-dev \
		linux-headers \
 && mkdir -p /tmp/src \
 && cd /tmp/src \
    # install GeoIP:
 && wget  https://github.com/maxmind/geoip-api-c/releases/download/v${GEOIP_VERSION}/GeoIP-${GEOIP_VERSION}.tar.gz \
 && tar -zxvf GeoIP-${GEOIP_VERSION}.tar.gz \
 && cd /tmp/src/GeoIP-${GEOIP_VERSION} \
 && ./configure \
 && make \
 && make check \
 && make install \
    # get GeoIP.dat database
 && cd /tmp/src \
 && wget -N http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz \
 && gunzip GeoIP.dat.gz \
 && mkdir /usr/local/share/GeoIP/ \
 && mv GeoIP.dat /usr/local/share/GeoIP/ \
 && echo 'adding /usr/local/share/GeoIP/GeoIP.dat database' \
    # install nginx:
 && wget http://nginx.org/download/${NGINX_VERSION}.tar.gz \
 && tar -zxvf ${NGINX_VERSION}.tar.gz \
 && cd /tmp/src/${NGINX_VERSION} \
 && ./configure \
        --prefix=/etc/nginx \
        --sbin-path=/usr/local/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --pid-path=/run/nginx.pid \
        --lock-path=/run/nginx.lock \
        --http-log-path=/var/log/nginx/access.log \
        --error-log-path=/var/log/nginx/error.log \
        --with-pcre-jit \
        --with-http_ssl_module \
        --with-stream_ssl_module \
        --with-http_stub_status_module \
        --with-http_gzip_static_module \
        --with-http_v2_module \
        --with-http_auth_request_module \
        --with-http_geoip_module \
 && make \
 && make install \
 && rm /usr/local/lib/libGeoIP.a \
 && rm -rf /tmp/src \
 && rm -rf /var/cache/apk/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

ADD templates/nginx.conf /etc/nginx/
ADD templates/default-site.conf /etc/nginx/conf.d/default.conf
ADD templates/default-page.html /var/www/defaults/index.html    

ADD templates/run.sh /RUN/run.sh
RUN chmod u+x /RUN/run.sh

EXPOSE 80 443

VOLUME ["/DATA"]
VOLUME ["/RUN"]
ENTRYPOINT ["/RUN/run.sh"]

CMD ["nginx", "-g", "daemon off;"]