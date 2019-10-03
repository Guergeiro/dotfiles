# `ubuntu:latest` tag will always point to the latest LTS version
# `ubuntu:rolling` tag will always point to the latest release (regardless of LTS status)
FROM ubuntu:latest

# Install `sudo` and upgrade OS
RUN apt-get update && apt-get install sudo -y
RUN apt-get upgrade -y
RUN apt-get autoremove -y
RUN apt-get autoclean -y

# Create user `docker` with root password `docker` 
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Create home folder for `docker` and give it correct permissions
RUN mkdir -p /home/docker && chown -R docker:docker /home/docker

# "Login" as the newly created user
USER docker

# Switch do newly created directory
WORKDIR /home/docker