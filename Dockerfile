# `ubuntu:latest` tag will always point to the latest LTS version
# `ubuntu:rolling` tag will always point to the latest release (regardless of LTS status)
FROM ubuntu:latest

# Install `sudo` and upgrade OS
RUN apt-get update && apt-get install sudo -y
RUN apt-get upgrade -y
# Install `vim`
RUN apt-get install vim -y
# Install `git`
RUN apt-get install git -y
# Install `java`
RUN apt-get install default-jdk-headless -y
# Install `Python3`
RUN apt-get install python3 -y
# Install `bash-completion`
RUN apt-get install bash-completion -y

# Clean
RUN apt-get autoremove -y
RUN apt-get autoclean -y

# Create user `docker` with root password `docker` 
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Create home folder for `docker` and give it correct permissions
RUN mkdir -p /home/docker && chown -R docker:docker /home/docker

# Allow user to use docker cmd without sudo
# usermod -aG docker your-user
RUN usermod -aG docker docker

# Add bash to docker
RUN usermod -s /bin/bash docker

# Copies current directory to docker
COPY . /home/docker

# "Login" as the newly created user
USER docker

# Switch do newly created directory
WORKDIR /home/docker
