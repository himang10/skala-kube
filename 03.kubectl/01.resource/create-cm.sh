#!/usr/bin/env bash

set -uo pipefail


cp ${HOME}/.kube/config kube-config
# 변경 가능한 변수 (환경변수로 재정의 가능)
KUBECONFIG_SOURCE_FILE="kube-config"
CONFIGMAP_KEY="config"
OUTPUT_FILE="kubeconfig-configmap.yaml"

SOURCE_PATH="./${KUBECONFIG_SOURCE_FILE}"
OUTPUT_PATH="./${OUTPUT_FILE}"

echo "load file = $KUBECONFIG_SOURCE_FILE"
if [[ ! -f "${SOURCE_PATH}" ]]; then
  echo "[ERROR] kubeconfig 원본 파일을 찾을 수 없습니다: ${SOURCE_PATH}" >&2
  exit 1
fi


if ! kubectl create configmap kubeconfig-configmap \
  --from-file="config=${SOURCE_PATH}" \
  --dry-run=client \
  -o yaml > "${OUTPUT_PATH}"; then
  echo "[ERROR] ConfigMap 생성 실패" >&2
  exit 1
fi

echo "[DONE] ${OUTPUT_PATH} 파일이 생성되었습니다."
