FROM python:slim AS base

ENV UNREAL_VERSION="" \
	ATHEME_VERSION="" \
	DEBIAN_FRONTEND="noninteractive" \
	TERM="xterm-256color" \
	LC_ALL="C.UTF-8"
	
RUN apt-get update && \
	apt-get upgrade -y --with-new-pkgs && \
	apt-get install -y --no-install-recommends \
		apt-utils ca-certificates apt-transport-https
		
COPY base/ /

RUN apt-get update && \
	apt-get upgrade -y --with-new-pkgs && \
	apt-get install -y --no-install-recommends \
		build-essential wget curl gnupg2 expect \
		cmake file pkg-config gettext libssl-dev jq && \
	groupadd ircnet && \
	useradd -mg ircnet ircnet && \
	mkdir -p /home/ircnet/UnrealIRCd /home/ircnet/Atheme-Services && \
	chown -R ircnet:ircnet /home/ircnet /scripts && \
	chmod +x /scripts/*
	
USER ircnet
RUN /scripts/unrealircd.sh \
	&& /scripts/atheme.sh
	
USER root
RUN	apt-get autoremove --purge -y --allow-remove-essential \
		build-essential wget curl gnupg2 expect apt-utils \
		ca-certificates apt-transport-https cmake file \
		pkg-config gettext libssl-dev && \
	apt-get clean autoclean -y && \
	apt-get autoremove -y && \
	rm -rf /var/lib/apt/* /var/lib/cache/* /var/lib/log/* \
		/var/tmp/* /usr/share/doc/ /usr/share/man/ /usr/share/locale/ \
		/root/.cache /root/.local /root/.gnupg /root/.config /tmp/*
		
FROM python:slim

ENV DEBIAN_FRONTEND="noninteractive" \
	TERM="xterm-256color" \
	LC_ALL="C.UTF-8"
	
RUN apt-get update && \
	apt-get upgrade -y --with-new-pkgs && \
	apt-get install -y --no-install-recommends \
		apt-utils ca-certificates apt-transport-https curl gnupg2
		
COPY python/ /
COPY --from=base /home/ircnet/UnrealIRCd /usr/local/ircnet/UnrealIRCd
COPY --from=base /home/ircnet/Atheme-Services /usr/local/ircnet/Atheme-Services	

RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
	apt-get update && \
	apt-get upgrade -y --with-new-pkgs && \
	apt-get install -y --no-install-recommends \
		bash nano net-tools htop wget && \	
	dpkg -i /help/fake_python3-minimal_3.9.2-3_all.deb && \
	apt-get update && \
	apt-get upgrade -y --with-new-pkgs && \
	apt-get install -y --no-install-recommends nodejs && \
	apt-get clean autoclean -y && apt-get autoremove -y && \
	npm install -g npm@latest && \
	npm install -g yarn@latest && \
	yarn global add thelounge && \
	npm cache clean --force && \
	yarn cache clean --all && \
	python3 -m pip install --upgrade pip && \
	python3 -m pip install supervisor && \
	python3 -m pip cache purge && \
	rm -rf /var/lib/apt/* /var/lib/cache/* /var/lib/log/* /tmp/* \
		/var/tmp/* /usr/share/doc/ /usr/share/man/ /usr/share/locale/ \
		/root/.cache /root/.local /root/.npm /root/.gnupg /root/.config && \
	groupadd ircnet && useradd -ms /bin/bash -g ircnet ircnet

