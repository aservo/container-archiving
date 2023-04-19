Archiving
=========

## Purpose

This Docker image is intended for:

* providing an all-in-one archiving solution based on Apache webserver for text, files, and SCM repos
* use with the [Bitnami Apache Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/apache)
* SAML authentication

## Binaries

It contains the following primary binaries:

* [`bitnami apache`](https://hub.docker.com/r/bitnami/apache)
* [`mod_auth_mellon`](https://github.com/latchset/mod_auth_mellon)

## Configuration

### Apache

From: https://github.com/bitnami/containers/tree/main/bitnami/apache#customize-this-image

Configuration files are located in `/opt/bitnami/apache/conf`.
To deviate from defaults, start with mounting `/opt/bitnami/apache/conf/httpd.conf`

#### Defaults

  * Document Root: `/app`
  * Virtual hosts files: `/opt/bitnami/apache/conf/vhosts/`
  * Certificates: `/certs`
    * `server.crt`
    * `server.key`

#### Environment Variables

* `APACHE_HTTP_PORT_NUMBER`
* `APACHE_HTTPS_PORT_NUMBER`
