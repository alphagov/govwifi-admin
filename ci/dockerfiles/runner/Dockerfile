FROM docker:18.09

RUN apk add --no-cache \
  # our dependencies
  make \
  bash \
  curl \
  # dockerd dependencies
  util-linux \
  iptables \
  # docker-compose dependencies
  py-pip \
  python-dev \
  libffi-dev \
  openssl-dev \
  gcc \
  libc-dev

ARG DOCKER_COMPOSE_VERSION='1.24.0'

RUN pip --no-cache-dir install "docker-compose==${DOCKER_COMPOSE_VERSION}"

ADD docker-helpers.sh .

CMD "ash"

