FROM alpine:latest

RUN apk update && apk add \
  bash \
  curl \
  jq \
  python3 \
  zsh

RUN pip3 install --upgrade pip
RUN pip3 install csvkit

WORKDIR /app
COPY ./examples /app/examples
