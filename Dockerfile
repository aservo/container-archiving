FROM bitnami/apache:2.4.56-debian-11-r2 as builder

USER root

# dependencies for mod_auth_mellon
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
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
    wget https://github.com/latchset/mod_auth_mellon/archive/refs/heads/main.zip ; \
    unzip main.zip ;\
    cd mod_auth_mellon-main ;\
    ./autogen.sh ;\
    ./configure --with-apxs2=/opt/bitnami/apache/bin/apxs --enable-diagnostics;\
    make ;\
    make install;\
    echo 'FINISHED MOD_AUTH_MELLON' ;\
    ls -al /opt/bitnami/apache/modules/mod_auth_mellon.so

USER www-data
