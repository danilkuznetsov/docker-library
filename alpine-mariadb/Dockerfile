FROM alpine:edge
MAINTAINER Danil Kuznetsov <kuznetsov.danil.v@gmail.com>

ENV LANG="en_US.UTF-8" \
	LC_ALL="en_US.UTF-8" \
	LANGUAGE="en_US.UTF-8" \ 
	TERM="xterm"

ENV TIMEZONE="Europe/Kiev"

RUN apk update && \
	apk upgrade && \
	apk add --update tzdata && \
	cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
	echo "${TIMEZONE}" > /etc/timezone && \
	apk --update add \
	mariadb mariadb-client bash

RUN apk del tzdata && \
	rm -rf /var/cache/apk/*

ADD templates/my.cnf /etc/mysql/my.cnf
ADD templates/run.sh /

RUN chmod u+x /run.sh

VOLUME ["/DATA"]

EXPOSE 3306

CMD ["/run.sh"]