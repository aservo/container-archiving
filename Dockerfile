ARG REGISTRY=docker.io
ARG APACHE_IMAGE_TAG=2.4.57-debian-11-r124
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
# (highlight is required for cgit syntax highlighting)
RUN apt-get update && apt-get install -y \
        git \
        highlight \
        inotify-tools \
        zip \
    && rm -rf /var/lib/apt/lists/*

# install cgit without postinst script (does not work with the Bitnami Apache image)
ARG CGIT_PACKAGE=cgit
ARG CGIT_TMP_DIR=/tmp/${CGIT_PACKAGE}
RUN apt-get update \
    && mkdir -p ${CGIT_TMP_DIR} \
    && chown -R _apt:root ${CGIT_TMP_DIR} \
    && cd ${CGIT_TMP_DIR} \
    && apt-get download ${CGIT_PACKAGE} \
    && dpkg --unpack $(find . -name "${CGIT_PACKAGE}*.deb" -printf "%f" | head -n 1) \
    && rm /var/lib/dpkg/info/${CGIT_PACKAGE}.postinst -f \
    ## usually, we would need to run 'dpkg --configure ${CGIT_PACKAGE}' now, but then the dependencies would be missing
    ## instead, we just run 'apt-get install -yf' which installs both, dependencies and cgit without postinst script
    && apt-get install -yf \
    && rm -rf /tmp/${CGIT_PACKAGE}* \
    && rm -rf /var/lib/apt/lists/*

# add (and override) scripts to scripts in upstream image
COPY ./scripts /opt/bitnami/scripts/apache/

ADD sha256path.sh /opt/apache2-prg/

RUN chmod +x /opt/apache2-prg/sha256path.sh

USER 1001
