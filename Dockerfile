ARG REGISTRY=docker.io
ARG APACHE_IMAGE_TAG=2.4.57-debian-11-r2
ARG MOD_AUTH_MELLON_VERSION=0.18.1

FROM ${REGISTRY}/bitnami/apache:${APACHE_IMAGE_TAG} as builder

USER root

# install dependencies for mod_auth_mellon
RUN apt-get update && apt-get install -y \
        ca-certificates \
        curl \
        dh-autoreconf \
        libcurl4-openssl-dev \
        liblasso3-dev \
        make \
        openssl \
        pkg-config \
        publicsuffix \
        unzip \
        wget \
    && rm -rf /var/lib/apt/lists/*

ARG MOD_AUTH_MELLON_VERSION

# compile mod_auth_mellon
RUN wget "https://github.com/latchset/mod_auth_mellon/releases/download/v${MOD_AUTH_MELLON_VERSION}/mod_auth_mellon-${MOD_AUTH_MELLON_VERSION}.tar.gz" -O /tmp/mod_auth_mellon.tar.gz --no-verbose && \
    mkdir -p /tmp/mod_auth_mellon && \
    tar -xzf /tmp/mod_auth_mellon.tar.gz -C /tmp/mod_auth_mellon --strip-components=1 && \
    cd /tmp/mod_auth_mellon && \
    ./autogen.sh && \
    ./configure --with-apxs2=/opt/bitnami/apache/bin/apxs --enable-diagnostics && \
    make && \
    make install && \
    rm -rf /tmp/mod_auth_mellon*

# install generic packages (keep separated in case we want to use builder image)
RUN apt-get update && apt-get install -y \
        inotify-tools \
    && rm -rf /var/lib/apt/lists/*

# add (and override) scripts to scripts in upstream image
COPY ./scripts /opt/bitnami/scripts/apache/

USER www-data
