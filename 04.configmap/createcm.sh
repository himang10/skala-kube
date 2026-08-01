#!/bin/bash

USER_NAME="sk199"
NAMESPACE="class-3"

kubectl create configmap ${USER_NAME}-myfirst-configmap \
  --from-file=application-prod.yaml \
  --namespace=${NAMESPACE}

