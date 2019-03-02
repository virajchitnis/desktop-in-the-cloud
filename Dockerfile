FROM ubuntu:18.04
MAINTAINER chitnisviraj@gmail.com

# VNC port
EXPOSE 5900

# Install the necessary software
RUN apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y openbox python tightvncserver firefox lxterminal

# Set timezone
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime

# Create non-root user
RUN adduser --disabled-password --gecos "" cloud
RUN echo 'cloud:cloud' | chpasswd

# Set environment variables
WORKDIR /home/cloud
ENV HOME /home/cloud
ENV USER cloud
ENV GEOMETRY 1024x768
ENV TZ Etc/UTC

# Switch to the non-root user
USER cloud

# Create necessary user files
RUN mkdir -p ~/.vnc; \
    echo cloud | vncpasswd -f > ~/.vnc/passwd; \
    chmod 600 ~/.vnc/passwd; \
    touch ~/.Xauthority; \
    mkdir -p ~/.config/openbox

# Setup the startup scripts
RUN echo '#!/bin/sh \n\
unset SESSION_MANAGER \n\
exec openbox-session &' > ~/.vnc/xstartup
RUN chmod +x ~/.vnc/xstartup
RUN echo '' > ~/.config/openbox/autostart

# Start the vnc server
CMD vncserver -kill :0; vncserver :0 -geometry $GEOMETRY; tail -f ~/.vnc/*.log
