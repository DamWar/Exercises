FROM ubuntu:22.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    iputils-ping \
    jq \
    lsb-release \
    software-properties-common
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

WORKDIR /azp
COPY ./script.sh .
RUN chmod +x script.sh
ENTRYPOINT [ ./script.sh ]