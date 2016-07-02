
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
    apk add \
	bash \
	cmake \
	gcc \
	g++ \
	git \
	icu-dev \
	libssh-dev \
	zlib-dev \
	make \
	musl-dev \
	ruby \
	ruby-bundler \
	ruby-dev \
	ruby-rdoc \
	ruby-irb \
	sqlite-dev \
	sqlite-libs \
	unzip \
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
    apk del \
	cmake \
	gcc \
	g++ \
	ruby-bundler \
	ruby-dev \
	ruby-rdoc \
	ruby-irb \
	icu-dev \
	libssh-dev \
	sqlite-dev \
	zlib-dev \
	make \
	musl-dev \
	; \
    rm -rf /var/cache/apk/*

WORKDIR /wuki
VOLUME /wiki

ENTRYPOINT ["/start.sh"]
