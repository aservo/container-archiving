
## This temporary image compiles and installs mod_auth_mellon into bitnami apache

FROM bitnami/apache:2.4.54-debian-11-r27 as builder

USER root

# dependencies for mod_auth_mellon
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    git \
    make \
    unzip \
    wget \
    openssl \
    liblasso3-dev \
    libcurl4-openssl-dev \
    publicsuffix \
    pkg-config \
    dh-autoreconf \
  && rm -rf /var/lib/apt/lists/*

# compile mod_auth_mellon
RUN cd /root ;\
    git clone -b feature/improve-logging https://github.com/aservo/mod_auth_mellon.git ; \
    cd mod_auth_mellon ;\
    ./autogen.sh ;\
    ./configure --with-apxs2=/opt/bitnami/apache/bin/apxs --enable-diagnostics;\
    make ;\
    make install;\
    echo 'FINISHED MOD_AUTH_MELLON' ;\
    ls -al /opt/bitnami/apache/modules/mod_auth_mellon.so

USER www-data
