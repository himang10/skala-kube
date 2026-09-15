#!/bin/bash

USER_NAME=sk199
NAMESPACE=class-3

# Helm 저장소 추가
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update


#TEST="--dry-run --debug"

# Namespace가 존재하는지 확인하고 없으면 생성

helm upgrade --install ${USER_NAME}-mariadb-1 bitnami/mariadb \
  --version 20.5.5 \
  --namespace ${NAMESPACE} \
  -f custom-values.yaml
