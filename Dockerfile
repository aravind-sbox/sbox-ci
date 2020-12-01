FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update -y && apt-get upgrade -y

RUN echo "Etc/UTC" > /etc/timezone

RUN apt-get install -y --fix-missing wget curl gnupg git file apt-utils nano zip unzip build-essential openssh-client rsync sudo snapd apt-transport-https

# Download & Install Node JS
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get update -y && apt-get install -y nodejs && \
    npm install -g @angular/cli && \
    npm install -g firebase-tools

RUN snap install snapcraft --classic