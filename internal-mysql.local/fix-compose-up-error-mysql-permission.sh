#!/usr/bin/env bash
get_hostname() (
    . ./.env
    echo "${HOST_NAME}"
)
HOST_NAME=$(get_hostname)
mkdir -p "../run/${HOST_NAME}/mysqld"
chmod 777 "../run/${HOST_NAME}/mysqld" -R
