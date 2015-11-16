#!/usr/bin/env bash

message() {
	echo "-+> ${*}"
}

if [[ ! -e /wiki/gollum_wiki.yml ]]; then
	message "no gollum_wiki.yml configuration file, copy default one"
	sed -i 's#wiki_path: .#wiki_path: /wiki#g' /wuki/gollum_wiki.yml.tmpl
	cp /wuki/gollum_wiki.yml.tmpl /wiki/gollum_wiki.yml

	if [[ ! -e /wiki/wiki.git ]]; then
		message "no /wiki/wiki.git, create a empty repository"
		mkdir /wiki/wiki.git
		git -C /wiki/wiki.git init --bare
	fi

	message "create user access database"
	rake db:create

	message "initial migrate user access database"
	rake db:migrate

	message "initial seed user access database"
	rake db:seed

	message ""
	message " Please change your gollum_wiki.yml file in your data-directory"
	message ""
fi

message "copy gollum_wiki.yml"
cp /wiki/gollum_wiki.yml /wuki/gollum_wiki.yml

message "migrate user access database"
rake db:migrate

message "start wiku"
rackup -E production -o 0.0.0.0 -p ${PORTNUMBER} config.ru
