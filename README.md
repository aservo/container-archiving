Archiving
=========

## Purpose

This Docker image is intended for 
* use with the bitnami apache helmchart
* SAML authentication

## Github actions

It is a Docker image that has been "optimized" to run with GitHub Actions.

This means:

* it can be run with the `root` user
* it does not declare an own workdir

See https://docs.github.com/en/actions/creating-actions/dockerfile-support-for-github-actions


## Binaries

It contains the following primary binaries:

* [`bitnami apache`](https://hub.docker.com/r/bitnami/apache)
* [`mod_auth_mellon`](https://packages.debian.org/de/source/sid/libapache2-mod-auth-mellon)


