
FROM alpine:latest

MAINTAINER Silvio Fricke <silvio.fricke@gmail.com>

ENV LANG C.UTF-8

ENV PORTNUMBER 5555
ENV GIT_ADAPTER grit
ENV PULLNPUSHACTIVATE 0
ENV PULLNPUSHINTERVAL 60

ENV RACK_ENV production

ADD https://github.com/silvio/wuki/archive/master.zip /master.zip
ADD adds/* adds/
ADD misc/* misc/

RUN ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime ; \
    apk update ; \
    apk add -t base \
	bash \
	git \
	icu-dev \
	ruby \
	sqlite-libs \
	unzip \
	zlib-dev \
	; \
    apk add -t devel \
	cmake \
	g++ \
	gcc \
	icu-dev \
	libssh-dev \
	make \
	musl-dev \
	ruby-bundler \
	ruby-dev \
	ruby-irb \
	sqlite-dev \
	zlib-dev \
	; \
    unzip master.zip ;\
    mv wuki-master wuki ;\
    mv wuki/gollum_wiki.yml wuki/gollum_wiki.yml.tmpl \
    ; \
    cd wuki ; \
    bundle install \
    ; \
    ln -sf /adds/start.sh /start.sh ; \
    ln -sf /adds/database.yml /wuki/config/database.yml ; \
    chmod u+x /start.sh ; \
    chmod a+rwx -R /wuki ; \
    apk del devel ;\
    rm -rf /var/cache/apk/*

WORKDIR /wuki
VOLUME /wiki

ENTRYPOINT ["/start.sh"]
