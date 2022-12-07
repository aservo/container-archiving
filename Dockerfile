
## This temporary image compiles and installs mod_auth_mellon into bitnami apache

FROM bitnami/apache:2.4.54-debian-11-r27 as builder

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
    libsasl2-2 \
    libsasl2-modules \
    libsasl2-modules-db \
    libssh2-1 \
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
    ./configure --with-apxs2=/opt/bitnami/apache/bin/apxs ;\
    make ;\
    make install;\
    echo 'FINISHED MOD_AUTH_MELLON' ;\
    ls -al /opt/bitnami/apache/modules/mod_auth_mellon.so


# ---------------------

FROM bitnami/apache:2.4.54-debian-11-r27

# runtime dependencies
RUN apt-get update && apt-get install -y \
    liblasso3 \
  && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/bitnami/apache/modules/mod_auth_mellon.so /opt/bitnami/apache/modules/mod_auth_mellon.so

USER www-data
