FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update -y && apt-get upgrade -y

RUN echo "Etc/UTC" > /etc/timezone

RUN apt-get install -y --fix-missing wget curl gnupg git file apt-utils nano zip unzip xz-utils build-essential openssh-client rsync sudo snapd apt-transport-https openjdk-8-jre openjdk-8-jdk jq dpkg-dev clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin
RUN java -version

# Download & Install Node JS
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get update -y && apt-get install -y nodejs && \
    npm install -g @angular/cli && \
    npm install -g firebase-tools

# Download & Install Sentry CLI
RUN curl -sL https://sentry.io/get-cli/ | bash

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH=$PATH:$HOME/flutter/bin
# Run basic check to download Dark SDK
RUN flutter doctor

RUN wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg
RUN echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
RUN apt-get update -y
RUN apt-get install -y dart libsecret-1-0 libjsoncpp1 && dart --version
ENV PATH=$PATH:/root/.pub-cache/bin
RUN dart pub global activate flutter_to_debian