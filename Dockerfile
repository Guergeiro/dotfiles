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
# Install `NodeJS`
RUN apt-get install nodejs -y
# Install `NPM`
RUN apt-get install npm -y
# Install `wget`
RUN apt-get install wget -y

# Clean
RUN apt-get autoremove -y
RUN apt-get autoclean -y

# Create user `breno` with root password `breno` 
RUN useradd -m breno && echo "breno:breno" | chpasswd && adduser breno sudo

# Create home folder for `breno` and give it correct permissions
RUN mkdir -p /home/breno && chown -R breno:breno /home/breno

# Allow user to use breno cmd without sudo
# usermod -aG docker your-user
RUN groupadd docker
RUN usermod -aG docker breno

# Add bash to breno
RUN usermod -s /bin/bash breno

# Copies current directory to breno
COPY . /home/breno

# "Login" as the newly created user
USER breno

# Switch do newly created directory
WORKDIR /home/breno