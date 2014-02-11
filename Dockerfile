# Hulk Hubot, a Hubot for our private IRC channel.
#  docker build -t hulkhubot .
#  docker run -d hulkhubot

FROM ubuntu:12.04
MAINTAINER mcoms

# Get a recent version of NodeJS and npm
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y install -y python-software-properties python g++ make git
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get -y update
RUN apt-get -y install nodejs

# Dump everything to a folder on the root
ADD . /hulkhubot

# Install the Hubot IRC adapter
RUN cd /hulkhubot && npm install hubot-irc --save && npm install

RUN chmod 755 /hulkhubot/bin/hubot

# Export the basic config
ENV HUBOT_IRC_SERVER chat.freenode.net
ENV HUBOT_IRC_ROOMS ##hulkhubot
ENV HUBOT_IRC_NICK hulkhubot
ENV HUBOT_IRC_UNFLOOD true

# Supply additional variables either with:
#  docker run -d -e HUBOT_IRC_ROOMS=##testing -e HUBOT_IRC_NICKSERV_PASSWORD=password hulkhubot
# or by building a second container FROM this one and adding ENV calls.
# Please pick a different nick for your bot if you're also using Freenode :-)

# Supply default arguments (note we use the shell form of CMD)
WORKDIR /hulkhubot
CMD bin/hubot -a irc --name hulkhubot
