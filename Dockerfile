FROM ubuntu:noble

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update -y && apt-get upgrade -y

RUN echo "Etc/UTC" > /etc/timezone

RUN apt-get install -y --fix-missing wget curl gnupg git file apt-utils nano zip unzip xz-utils build-essential openssh-client rsync sudo snapd apt-transport-https openjdk-8-jre openjdk-8-jdk jq dpkg-dev clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev

# Set environment variables
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV ANDROID_HOME /usr/lib/android-sdk
ENV PATH $PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$JAVA_HOME/bin
RUN java -version

# Install Android SDK command-line tools
# RUN mkdir "$ANDROID_HOME/cmdline-tools"
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O android-sdk-cmdline.zip
RUN unzip android-sdk-cmdline.zip -d "$ANDROID_HOME/cmdline-tools"
RUN mv "$ANDROID_HOME/cmdline-tools/cmdline-tools" "$ANDROID_HOME/cmdline-tools/latest"
RUN rm android-sdk-cmdline.zip

# Accept Android licenses
RUN yes | sdkmanager --licenses > /dev/null

# Install required Android SDK components
RUN sdkmanager "platforms;android-33" "build-tools;33.0.2" "platform-tools" "cmdline-tools;latest"

# Download & Install Node JS
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get update -y && apt-get install -y nodejs && \
    npm install -g @angular/cli && \
    npm install -g firebase-tools

# Download & Install Sentry CLI
RUN curl -sL https://sentry.io/get-cli/ | bash

# Download Flutter SDK
RUN git clone --single-branch -b stable https://github.com/flutter/flutter.git
ENV PATH=$PATH:$HOME/flutter/bin
# Run basic check to download Dark SDK
RUN flutter doctor

RUN wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg
RUN echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
RUN apt-get update -y
RUN apt-get install -y dart libsecret-1-0 libjsoncpp1 && dart --version
ENV PATH=$PATH:/root/.pub-cache/bin
RUN dart pub global activate flutter_to_debian
