FROM alpine:latest

RUN apk update && apk add \
  bash \
  curl \
  python3 \
  make \
  zsh

RUN pip3 install --upgrade pip
RUN pip3 install csvkit

RUN wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && \
  chmod +x jq-linux64 && \
  mv jq-linux64 /usr/bin/jq

RUN wget https://github.com/ericchiang/pup/releases/download/v0.4.0/pup_v0.4.0_linux_amd64.zip && \
  unzip pup_v0.4.0_linux_amd64.zip && \
  mv pup /usr/bin && \
  rm pup_v0.4.0_linux_amd64.zip

WORKDIR /app
COPY ./examples /app/examples
