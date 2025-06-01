FROM alpine:3.18

RUN apk add --no-cache git rsync jq bash openssh

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]