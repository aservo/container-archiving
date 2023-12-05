#!/bin/bash

while read LINE; do
  HASH="$(echo -n "$LINE" | sha256sum | cut -d ' ' -f1)"
  echo -n "${HASH:0:2}/${HASH:2:2}/${HASH:4:2}/${HASH:6:2}"
  echo -n "/${HASH:8:4}/${HASH:12:4}/${HASH:16:4}/${HASH:20:4}"
  echo -n "/${HASH:24:8}/${HASH:32:8}/${HASH:40:8}"
  echo -n "/${HASH:48:16}"
  echo
done
