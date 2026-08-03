#!/usr/bin/env bash
set -euo pipefail

NAMESPACE=$CLASS_NAME
CONFIGMAP_NAME="${STUDENT_NUM}-linux-kubeconfig"
KUBECONFIG_FILE="./kube-config"


kubectl create configmap "${CONFIGMAP_NAME}" \
  --namespace "${NAMESPACE}" \
  --from-file="config=${KUBECONFIG_FILE}" \
  --dry-run=client \
  --output=yaml | kubectl apply -f -

echo "configmap/${CONFIGMAP_NAME} is ready in namespace ${NAMESPACE}"
