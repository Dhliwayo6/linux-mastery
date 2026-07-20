FROM alpine:3.19

RUN apk add --no-cache \
  bash curl wget bind-tools iproute2 iputils netcat-openbsd \
  procps htop nano git python3 jq coreutils

LABEL linux-mastery.type=sandbox

RUN addgroup -g 1000 sandbox && \
    adduser -u 1000 -G sandbox -s /bin/bash -D sandbox

USER sandbox
WORKDIR /home/sandbox

CMD ["/bin/bash"]
