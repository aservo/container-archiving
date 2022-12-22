FROM bitnami/apache:2.4.54-debian-11-r27

USER root

RUN apt-get update && \
    apt-get --no-install-recommends --yes install \
        libapache2-mod-auth-mellon \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER www-data
