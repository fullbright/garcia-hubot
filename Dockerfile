FROM node:6.12
MAINTAINER Full Bright <full3right@gmail.com>

# -----------------------------------------------------------------------------
# Environment variables
# -----------------------------------------------------------------------------
ENV HUBOT_NAME hubot
ENV HUBOT_SLACK_TOKEN false
ENV HUBOT_AUTH_ADMIN myself
ENV GITLAB_CHANNEL general
ENV GITLAB_DEBUG false
ENV GITLAB_BRANCHES master
ENV GITLAB_SHOW_COMMITS_LIST 0
ENV GITLAB_SHOW_MERGE_DESCRIPTION 0
ENV HUBOT_NEWRELIC_API_KEY false
ENV HUBOT_NEWRELIC_API_HOST api.bright-softwares.com
ENV HUBOT_GOOGLE_CSE_ID unknown
ENV HUBOT_GOOGLE_CSE_KEY unknown
ENV HUBOT_SYSTEM_ACCOUNT fullbot
ENV HUBOT_TV_IPADDRESS 127.0.0.1
ENV HUBOT_WOLFRAM_APPID unknown

# -----------------------------------------------------------------------------
# Pre-install
# -----------------------------------------------------------------------------
#ADD build/ /opt/
COPY build/ /opt/
WORKDIR /opt

# -----------------------------------------------------------------------------
# Install
# -----------------------------------------------------------------------------
#RUN npm install --production; npm cache clean
#RUN apt-get update; apt-get install -y build-essential python2.7; \
RUN apt-get update; apt-get install -y build-essential python2.7 python3;
#RUN npm install --production --python=python2.7; npm cache clean
RUN npm install --production; npm cache clean

# -----------------------------------------------------------------------------
# Post-install
# -----------------------------------------------------------------------------
EXPOSE 8080
VOLUME /opt/scripts

CMD ["/opt/bin/hubot", "--name", "${HUBOT_NAME}", "--adapter", "slack"]
