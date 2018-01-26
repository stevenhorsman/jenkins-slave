# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node. based on evarga/jenkins-slave
FROM evarga/jenkins-slave

# Make sure the package repository is up to date.
RUN apt-get update
RUN apt-get -y upgrade

# Add node version 8 which should bring in npm
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

# Install SSH and Java
RUN apt-get install -y curl sudo nodejs maven

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

CMD ["/usr/sbin/sshd", "-D"]
