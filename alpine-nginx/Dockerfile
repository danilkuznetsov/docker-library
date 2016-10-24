FROM alpine:edge
MAINTAINER Danil Kuznetsov <kuznetsov.danil.v@gmail.com>

ENV LANG="en_US.UTF-8" \
	LC_ALL="en_US.UTF-8" \
	LANGUAGE="en_US.UTF-8" \
	TERM="xterm"

RUN set -x \
	&& addgroup -g 82 -S www-data \
	&& adduser -u 82 -D -S -G www-data www-data

RUN apk -U upgrade && \
	apk update &&  \
	apk add bash nginx ca-certificates

RUN rm -rf /var/cache/apk/*

ADD templates/nginx.conf /etc/nginx/
ADD templates/sample-site.conf /etc/nginx/conf.d/default.conf
ADD templates/run.sh /
ADD templates/nginx_default_page.html /var/www/nginx-defaults/index.html    
RUN chmod +x /run.sh

EXPOSE 80
VOLUME ["/DATA"]

CMD ["/run.sh"]