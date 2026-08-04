#!/bin/bash

USER_NAME=${STUDENT_NAME}
NAMESPACE=${CLASS_NAME}

kubectl create configmap ${USER_NAME}-myfirst-configmap \
  --from-file=application-prod.yaml \
  --namespace=${NAMESPACE}

