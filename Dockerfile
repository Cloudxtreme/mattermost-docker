FROM bbania/centos:base
MAINTAINER "Bart Bania" <contact@bartbania.com>

ENV PG_USER=mattermost
ENV PG_PASS=mattermost
ENV PG_HOST=postgres
ENV PG_DATA=mattermost

RUN yum install -q -y python-pip && \
    yum -q clean all
RUN pip -q install supervisor

# Setup gosu for easier command execution
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    curl -q -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" && \
    curl -q -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64.asc" && \
    gpg --verify /usr/local/bin/gosu.asc && \
    rm /usr/local/bin/gosu.asc && \
    rm -r /root/.gnupg/ && \
    chmod +x /usr/local/bin/gosu

RUN useradd -m -d /mattermost mattermost

WORKDIR /mattermost

ADD https://github.com/mattermost/platform/releases/download/v2.0.0/mattermost.tar.gz .
RUN tar -zxf mattermost.tar.gz --strip-components=1 && rm mattermost.tar.gz

RUN mkdir -p /mattermost_data/config

COPY ./configs/config.json /mattermost_data/config/config.json
COPY ./configs/supervisord.conf /mattermost
COPY ./configs/entrypoint.sh / 

RUN chown -R mattermost: /mattermost_data /mattermost

VOLUME /mattermost_data

EXPOSE 80

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "supervisord", "-c /mattermost/supervisord.conf" ]

