FROM hashicorp/terraform:1.0.3

RUN apk add --update \
    python3 \
    py-pip \
    py-cffi \
    py-cryptography \
    make \
    git \
    curl \
    which \
    bash \
    jq \
    docker \
  && pip install --upgrade pip \
  && apk add --virtual build-deps \
    gcc \
    libffi-dev \
    python3-dev \
    linux-headers \
    musl-dev \
    openssl-dev \
  && pip install gsutil \
  && apk del build-deps \
  && rm -rf /var/cache/apk/*

RUN curl -sSL https://sdk.cloud.google.com | bash

ENV PATH $PATH:/root/google-cloud-sdk/bin

# Create app directory
WORKDIR /usr/src/app

ENTRYPOINT sleep 36000