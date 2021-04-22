FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update -y && apt-get upgrade -y

RUN echo "Etc/UTC" > /etc/timezone

RUN apt-get install -y --fix-missing wget curl gnupg git file apt-utils nano zip unzip build-essential openssh-client rsync sudo snapd apt-transport-https openjdk-8-jre openjdk-8-jdk jq dpkg-dev
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin
RUN java -version

# Download & Install Node JS
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get update -y && apt-get install -y nodejs && \
    npm install -g @angular/cli && \
    npm install -g firebase-tools

# Download & Install Android SDK
ENV SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip" \
    ANDROID_HOME="/usr/local/android-sdk" \
    REPO_OS_OVERRIDE=linux
# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
    && mkdir "$ANDROID_HOME/cmdline-tools" \
    && cd "$ANDROID_HOME/cmdline-tools" \
    && curl -o sdk.zip $SDK_URL \
    && unzip sdk.zip \
    && rm sdk.zip \
    && mkdir "$ANDROID_HOME/licenses" || true \
    && echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "$ANDROID_HOME/licenses/android-sdk-license" \
    && yes | $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager --licenses
# Install Android Build Tool and Libraries ----------------- ADD FUTURE VERSIONS TO THE LIST TO MAKE THE BUILD FASTER
RUN $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager "build-tools;27.0.0" \
    "build-tools;27.0.1" \
    "build-tools;27.0.2" \
    "build-tools;27.0.3" \
    "build-tools;28.0.0" \
    "build-tools;28.0.1" \
    "build-tools;28.0.2" \
    "build-tools;28.0.3" \
    "build-tools;29.0.0" \
    "build-tools;29.0.1" \
    "build-tools;29.0.2" \
    "build-tools;29.0.3" \
    "build-tools;30.0.0" \
    "build-tools;30.0.1" \
    "build-tools;30.0.2" \
    "platforms;android-27" \
    "platforms;android-28" \
    "platforms;android-29" \
    "platforms;android-30" \
    "platform-tools"

RUN $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager --list

# Install flutter
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1
ENV PATH="/flutter/bin:${PATH}"
RUN yes | flutter doctor --android-licenses && flutter doctor
RUN flutter upgrade
RUN flutter precache
