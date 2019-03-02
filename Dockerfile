FROM ubuntu:18.04
MAINTAINER chitnisviraj@gmail.com

WORKDIR /root
EXPOSE 5900

ENV HOME /root
ENV USER root
ENV GEOMETRY 1024x768
ENV TZ Etc/UTC

RUN apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y openbox python tightvncserver firefox lxterminal

RUN mkdir -p ~/.vnc; \
    echo password | vncpasswd -f > ~/.vnc/passwd; \
    chmod 600 ~/.vnc/passwd; \
    touch ~/.Xauthority; \
    mkdir -p ~/.config/openbox

RUN echo '#!/bin/sh \n\
unset SESSION_MANAGER \n\
exec openbox-session &' > ~/.vnc/xstartup
RUN chmod +x ~/.vnc/xstartup
RUN echo '' > ~/.config/openbox/autostart

CMD ln -sf /usr/share/zoneinfo/$TZ /etc/localtime; vncserver -kill :0; vncserver :0 -geometry $GEOMETRY; tail -f ~/.vnc/*.log
