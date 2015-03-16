FROM ubuntu:14.04

MAINTAINER Derek Homan <dhoman@huskers.unl.edu>

RUN echo "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe" > /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc)-updates main universe" >> /etc/apt/sources.list
RUN apt-get update

RUN apt-get -y -q install wget
RUN apt-get -y -q install nodejs npm
RUN apt-get -y -q install nodejs-legacy

RUN wget https://github.com/hakimel/reveal.js/archive/master.zip
RUN unzip master.zip
RUN mv /master /revealjs

RUN mkdir -p /revealjs/md

WORKDIR /revealjs

RUN npm install -g grunt-cli
RUN npm install
RUN sed -i Gruntfile.js -e 's/port: port,/port: port, hostname: "",/'
ADD index.html /revealjs/
ADD custom.css /revealjs/css/
ADD title.js /revealjs/plugin/
ONBUILD ADD slides.md /revealjs/md/

EXPOSE 8000
VOLUME ["/revealjs/md/"]
CMD ["grunt", "serve"]