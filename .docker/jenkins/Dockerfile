FROM jenkins:2.7.3

WORKDIR /var/jenkins_home

USER root

# Install meteor
#RUN curl -sL https://install.meteor.com/ | bash -
RUN curl -sL https://install.meteor.com/ | sh
#  && su jenkins -c 'HOME=/var/jenkins_home meteor --release 1.3.3 --version'

# Install fabric
RUN apt-get update\
  && apt-get install -y python-pip python-dev vim dnsutils\
  && pip install fabric

USER jenkins
