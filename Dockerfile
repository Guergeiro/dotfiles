FROM ubuntu:latest

RUN apt-get update && apt-get install sudo -y
RUN apt-get upgrade -y
RUN apt-get autoremove -y
RUN apt-get autoclean -y
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
RUN mkdir -p /home/docker && chown -R docker:docker /home/docker
USER docker
WORKDIR /home/docker