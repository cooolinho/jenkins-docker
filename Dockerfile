FROM jenkins/jenkins:2.414

USER root

RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-plugin docker-workflow ssh-agent"

## Generate SSH Files
RUN mkdir -p /var/jenkins_home/.ssh
COPY ./docker/.ssh/config /var/jenkins_home/.ssh/config
RUN ssh-keygen -q -t rsa -N '' -f /var/jenkins_home/.ssh/id_rsa


