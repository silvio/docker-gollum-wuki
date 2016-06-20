
FROM alpine:latest

MAINTAINER Silvio Fricke <silvio.fricke@gmail.com>

ENV LANG C.UTF-8
RUN ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

ENV PORTNUMBER 5555
ENV GIT_ADAPTER grit
ENV PULLNPUSHACTIVATE 0
ENV PULLNPUSHINTERVAL 60

RUN apk update ; \
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
    && rm -rf /var/cache/apk/*

ADD https://github.com/silvio/wuki/archive/master.zip /master.zip
RUN unzip master.zip ;\
    mv wuki-master wuki ;\
    mv wuki/gollum_wiki.yml wuki/gollum_wiki.yml.tmpl

WORKDIR /wuki
VOLUME /wiki

ENV RACK_ENV production
RUN gem install --pre \
    bigdecimal \
    gollum-rugged_adapter \
    github-markdown \
    ;\
    bundle install

ADD adds/start.sh /start.sh
ADD adds/database.yml /wuki/config/database.yml
RUN chmod u+x /start.sh ;\
    chmod a+rwx -R /wuki

ENTRYPOINT ["/start.sh"]
