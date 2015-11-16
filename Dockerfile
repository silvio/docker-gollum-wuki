
FROM ruby

MAINTAINER Silvio Fricke <silvio.fricke@gmail.com>

ENV LANG C.UTF-8
RUN ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

ENV PORTNUMBER 5555
ENV GIT_ADAPTER grit
ENV PULLNPUSHACTIVATE 0
ENV PULLNPUSHINTERVAL 60

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -y \
    && apt-get install -y \
	cmake \
	git \
	libicu-dev \
	libssh-dev \
	unzip \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/silvio/wuki/archive/master.zip ;\
    unzip master.zip ;\
    mv wuki-master wuki ;\
    mv wuki/gollum_wiki.yml wuki/gollum_wiki.yml.tmpl

WORKDIR /wuki
VOLUME /wiki

ENV RACK_ENV production
RUN gem install --pre gollum-rugged_adapter ;\
    bundle install

ADD adds/start.sh /start.sh
ADD adds/database.yml /wuki/config/database.yml
RUN chmod u+x /start.sh ;\
    chmod a+rwx -R /wuki

ENTRYPOINT ["/start.sh"]
