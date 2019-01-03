FROM python:3.6-alpine

ARG BUILD_DATE

LABEL maintainer="Intelygenz"
LABEL org.label-schema.build-date=$BUILD_DATE

# Install new packages
RUN apk add --update build-base python-dev py-pip jpeg-dev zlib-dev libffi-dev openssl-dev git openssh-client sshpass

# Upgrade pip
RUN pip install --upgrade pip

# Change LIBRARY_PATH environment variable because of error in building zlib
ENV LIBRARY_PATH=/lib:/usr/lib

# Set Workdir
WORKDIR /ansible

# Define volumes
VOLUME [ "/ansible" ]

# Install ansible
ARG ANSIBLE_VERSION
RUN pip install ansible==$ANSIBLE_VERSION
