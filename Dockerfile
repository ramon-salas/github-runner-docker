FROM ubuntu:latest

ADD ./initRunner.sh initRunner.sh

RUN apt-get update && apt-get install -y \
    curl \
    tar \
    libicu-dev \
    sudo \
    unzip \
    jq

RUN useradd -m -s /bin/bash githubuser

RUN echo 'githubuser:githubpass' | chpasswd

RUN usermod -aG sudo githubuser

USER githubuser

WORKDIR /home/githubuser

RUN mkdir actions-runner

RUN cd actions-runner && curl -o actions-runner-linux-x64-2.309.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.309.0/actions-runner-linux-x64-2.309.0.tar.gz

RUN cd actions-runner && tar xzf ./actions-runner-linux-x64-2.309.0.tar.gz

RUN mkdir sonarScanner

ADD ./sonar-scanner-cli-5.0.1.3006-linux.zip sonar-scanner-cli-5.0.1.3006-linux.zip

RUN mv sonar-scanner-cli-5.0.1.3006-linux.zip sonarScanner

RUN cd sonarScanner && unzip ./sonar-scanner-cli-5.0.1.3006-linux.zip

ENV SONAR_SCANNER /home/githubuser/sonarScanner/sonar-scanner-5.0.1.3006-linux/bin

ENV PATH="${SONAR_SCANNER}:${PATH}:/jdk/bin:/maven/bin"

CMD ["sh", "/initRunner.sh"]
