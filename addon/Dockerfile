FROM ghcr.io/home-assistant/amd64-base:latest

RUN apk add --no-cache git rsync jq bash openssh

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]