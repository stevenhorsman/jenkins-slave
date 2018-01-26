# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node. based on evarga/jenkins-slave
FROM ubuntu:xenial

# In case you need proxy
#RUN echo 'Acquire::http::Proxy "http://127.0.0.1:8080";' >> /etc/apt/apt.conf

# Make sure the package repository is up to date.
RUN apt-get update
RUN apt-get -y upgrade

# Install SSH and Java
RUN apt-get install -y openssh-server openjdk-8-jdk curl sudo

# Add locales after locale-gen as needed
# Upgrade packages on image
# Preparations for sshd
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_GB.UTF-8 &&\
    apt-get -q update &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q upgrade -y -o Dpkg::Options::="--force-confnew" --no-install-recommends &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew" --no-install-recommends openssh-server &&\
    apt-get -q autoremove &&\
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin &&\
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd &&\
    mkdir -p /var/run/sshd

# Standard SSH port
EXPOSE 22

ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
ENV LC_ALL en_GB.UTF-8

# Set user jenkins to the image
RUN useradd -m -d /home/jenkins -s /bin/sh jenkins &&\
    echo "jenkins:jenkins" | chpasswd

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Standard SSH port
EXPOSE 22

# Add node version 8 which should bring in npm
RUN apt-get -y update
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install -y nodejs

# Install maven
RUN sudo apt-get install -y maven

CMD ["/usr/sbin/sshd", "-D"]
