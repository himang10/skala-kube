#!/bin/bash

USER_NAME=sk199
NAMESPACE=class-3

helm uninstall ${USER_NAME}-mariadb-1 --namespace ${NAMESPACE}
