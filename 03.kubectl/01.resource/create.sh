#!/usr/bin/env bash

set -uo pipefail

# 이 스크립트가 있는 위치를 기준으로 YAML 파일을 찾습니다.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# 적용할 namespace 목록
NAMESPACES=(
  class-0
  class-{6..10}
  skala-practice
)

# 적용할 Kubernetes YAML 목록
YAML_FILES=(
  kubeconfig-secret.yaml
  resources.yaml
  attach-pvc-deploy.yaml
  kubectl-deploy.yaml
)

# 일부 리소스만 적용되는 것을 방지하기 위해 파일을 먼저 확인합니다.
missing_file=0
for yaml_file in "${YAML_FILES[@]}"; do
  if [[ ! -f "${SCRIPT_DIR}/${yaml_file}" ]]; then
    echo "[ERROR] YAML 파일을 찾을 수 없습니다: ${SCRIPT_DIR}/${yaml_file}" >&2
    missing_file=1
  fi
done

if (( missing_file != 0 )); then
  exit 1
fi

# YAML 하나마다 모든 namespace에 반복 적용합니다.
failed_count=0
for yaml_file in "${YAML_FILES[@]}"; do
  for namespace in "${NAMESPACES[@]}"; do
    echo "[APPLY] ${yaml_file} -> namespace/${namespace}"

    if ! kubectl apply -f "${SCRIPT_DIR}/${yaml_file}" -n "${namespace}"; then
      echo "[ERROR] 적용 실패: ${yaml_file} -> namespace/${namespace}" >&2
      ((failed_count += 1))
    fi
  done
done

if (( failed_count != 0 )); then
  echo "[ERROR] 총 ${failed_count}개 적용 작업이 실패했습니다." >&2
  exit 1
fi

echo "[DONE] 모든 YAML 리소스를 모든 namespace에 적용했습니다."
