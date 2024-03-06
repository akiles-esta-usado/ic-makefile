from ubuntu:22.04

RUN apt -y update && apt install -y --no-install-recommends \
    build-essential \
    sudo \
    git \
    python3 \
    python3-pip \
    python3-dev \
    autoconf \
    automake \
    yacc \
    bison \
    libreadline-dev

# This is a container for installing apps.
# && rm -rf /var/lib/apt/lists/*

WORKDIR /home/designer