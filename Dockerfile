FROM bitnami/apache:2.4.54-debian-11-r27

USER root

RUN apt-get update

# TODO - cleanout unused libs, e.g. required for ldap
RUN apt-get install -y \
    ca-certificates \
    curl \
    libbrotli1 \
    libcurl4 \
    libldap-2.4-2 \
    libldap-common \
    libnghttp2-14 \
    libpsl5 \
    librtmp1 \
    libsasl2-2 \
    libsasl2-modules \
    libsasl2-modules-db \
    libssh2-1 \
    openssl \
    publicsuffix \
    ldap-utils

USER 1001
