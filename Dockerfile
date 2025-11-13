FROM ubuntu:noble

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update -y && apt-get upgrade -y

RUN echo "Etc/UTC" > /etc/timezone

RUN apt-get install -y --fix-missing wget curl gnupg git file apt-utils nano zip unzip xz-utils build-essential openssh-client rsync sudo apt-transport-https jq dpkg-dev clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libgtk-3-0 libx11-6 libglu1-mesa libxrandr2 parallel ca-certificates

# Set environment variables for NVM
ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=22.14.0

# Download and install NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# Add Node to PATH
ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
RUN ls -l $NVM_DIR
RUN ls -l $NVM_DIR/versions/node/
RUN echo $PATH
# Verify installation (optional, good for debugging)
RUN node -v && npm -v 

# Install firebase tools
RUN npm install -g firebase-tools

# Install gemini-cli
RUN npm install -g @google/gemini-cli

# Download & Install Sentry CLI
RUN curl -sL https://sentry.io/get-cli/ | bash