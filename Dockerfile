FROM bbania/centos:base
MAINTAINER "Bart Bania" <contact@bartbania.com>

ENV PG_USER=mattermost
ENV PG_PASS=mattermost
ENV PG_HOST=postgres

RUN yum install -q -y python-pip && \
    yum -q clean all
RUN pip -q install supervisor

WORKDIR /mattermost

ADD https://github.com/mattermost/platform/releases/download/v2.0.0/mattermost.tar.gz .
RUN tar -zxf mattermost.tar.gz --strip-components=1 && rm mattermost.tar.gz

COPY ./configs/config.json /mattermost/config/config.json
COPY ./configs/supervisord.conf /etc/
COPY ./configs/entrypoint.sh / 

RUN mkdir /mattermost_data

VOLUME /mattermost_data

EXPOSE 80

ENTRYPOINT [ "/entrypoint.sh" ]

