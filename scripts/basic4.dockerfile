
# mkdir ./empty
# rm -rf ./empty/*
# docker build   -t basic4   -f ./scripts/basic4.dockerfile ./empty

FROM ubuntu:22.04

RUN : \
    && apt-get update \
    && apt-get install -y  apt-utils python3 ca-certificates \
    && :
    # && apt-get clean -y  \
    # && rm -rf /var/lib/apt/lists/*

RUN : \
    && apt-get install -y wine64 msitools \
    && :
