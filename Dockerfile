FROM ubuntu:noble

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update -y && apt-get upgrade -y

RUN echo "Etc/UTC" > /etc/timezone

RUN apt-get install -y --fix-missing wget curl gnupg git file apt-utils nano zip unzip xz-utils build-essential openssh-client rsync sudo snapd apt-transport-https openjdk-11-jre openjdk-11-jdk jq dpkg-dev clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libgtk-3-0 libx11-6 libglu1-mesa libxrandr2

# # Set environment variables
# ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
# ENV ANDROID_HOME /usr/lib/android-sdk
# ENV PATH $PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$JAVA_HOME/bin
# RUN java -version

# # Install Android SDK command-line tools
# RUN mkdir -p $ANDROID_HOME/cmdline-tools
# RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O android-sdk-cmdline.zip
# RUN unzip android-sdk-cmdline.zip -d $ANDROID_HOME/cmdline-tools
# RUN mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest
# RUN rm android-sdk-cmdline.zip

# # Accept Android licenses
# RUN yes | sdkmanager --licenses > /dev/null

# # Install required Android SDK components
# RUN sdkmanager "platforms;android-33" "build-tools;33.0.2" "platform-tools" "cmdline-tools;latest"

# # Set environment variables for NVM
# ENV NVM_DIR /root/.nvm
# ENV NODE_VERSION 22.14.0

# # Download and install NVM
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash \
#     && . "$NVM_DIR/nvm.sh" \
#     && nvm install $NODE_VERSION \
#     && nvm alias default $NODE_VERSION \
#     && nvm use default

# # Add Node to PATH
# ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
# RUN ls -l $NVM_DIR
# RUN ls -l $NVM_DIR/versions/node/
# RUN echo $PATH
# # Verify installation (optional, good for debugging)
# RUN node -v && npm -v 

# # Install firebase tools
# RUN npm install -g firebase-tools

# Download & Install Sentry CLI
# RUN curl -sL https://sentry.io/get-cli/ | bash

# Download Flutter SDK
RUN wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.0-stable.tar.xz -O flutter.tar.xz
RUN tar -xf flutter.tar.xz
RUN mkdir -p /flutter/bin/cache
RUN ls -l /flutter
ENV PATH=/flutter/bin:$PATH

# Run basic check to download Dark SDK
RUN flutter doctor

RUN wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg
RUN echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
RUN apt-get update -y
RUN apt-get install -y dart libsecret-1-0 libjsoncpp1 && dart --version
ENV PATH=$PATH:/root/.pub-cache/bin
RUN dart pub global activate flutter_to_debian
